CREATE OR REPLACE PACKAGE BIPKG_Gv_TIME_SPENT AS
   type bisp_refcursor_type is ref cursor;
   
/******************************************************************************
   name:       bipkg_time_spent
   purpose:

   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06/28/2006  -sgummadi-	   1. created this package.
   1.2 		  06/28/2006  -sgummadi-	   1. added bisp_time_spent procedure
	2.0		   10.29.07		shw			    1. Upgrade for GAMPS 
    3.0         03.03.08    shw             2. add assignmenta1 table, new problem fields for computing 
                                                time spent by activity. 
******************************************************************************/
   
   procedure bisp_time_spent (
      time_spent_cursor   in out   bisp_refcursor_type,
      pcurrgroup		  in 	   varchar2,
	  pfrequency		  in       varchar2,
      poverride			  in       varchar2,
      pzone				  in       varchar2,
      pstartdate		  in       date,
      penddate			  in       date,
	  vinteraction_type	  IN	   VARCHAR2,
      vactivity_type      IN       VARCHAR2,
      vpriority           IN       VARCHAR2
   );
END BIPKG_Gv_TIME_SPENT;
/
CREATE OR REPLACE package body bipkg_Gv_time_spent
as
/******************************************************************************
   name:       bisp_time_spent
   purpose:

   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0		  06/28/2006  -sgummadi-	   1. created bisp_time_spent procedure
	2.0		   10.29.07		shw			    1. Upgrade for GAMPS 
    3.0         03.03.08    shw             2. add assignmenta1 table, new problem fields for computing 
                                                time spent by activity. 
******************************************************************************/

   procedure bisp_time_spent (
      time_spent_cursor   in out   bisp_refcursor_type,
      pcurrgroup		  in 	   varchar2,
	  pfrequency		  in       varchar2,
      poverride			  in       varchar2,
      pzone				  in       varchar2,
      pstartdate		  in       date,
      penddate			  in       date,
	  vinteraction_type	  IN	   VARCHAR2,
      vactivity_type      IN       VARCHAR2,
      vpriority           IN       VARCHAR2
   )  
   is
      v_startdatedisplay   varchar2 (19);
      v_enddatedisplay     varchar2 (19);
      v_gmt_startdate      date;
      v_gmt_enddate        date;
	  v_gmt_startdate_str  varchar2 (19);
	  v_gmt_enddate_str	   varchar2 (19);
      v_db_zone            varchar2 (3);
      v_select_stmt		   varchar2 (32767);
   begin
      v_db_zone := 'GMT';
      bipkg_utils.bisp_getstartandenddates (pfrequency,poverride,pzone,pstartdate,penddate,v_gmt_startdate,v_gmt_enddate)                    ;
      v_startdatedisplay   := to_char (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
      v_enddatedisplay     := to_char (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
      v_gmt_startdate_str  := to_char (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
	  v_gmt_enddate_str    := to_char (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');
	  v_select_stmt :=
	  'SELECT '
	  || ' pb.numberprgn,'
	  || ' pb.assignment,'
	  || ' pb.page,'
	  || ' pb.updated_by,'
	  || ' pb.product_type,'
	  || ' pb.pfz_product_subtype,'
	  || ' pb.problem_type,'
	  || ' pb.problem_status,'
	  || ' pb.ticket_owner,'
	  || ' pb.brief_description,'
	  || ' pb.time_spent,'
	  || ' pb.category,'
	  || ' pb.priority,'
	  || ' pb.pfz_full_name,'
	  || ' pb.pfz_sla_title,'
	  || ' pb.status,'
	  || ' pb.actor,'
	  || ' pb.assignee_name,'
      || ' a1.OPERATORS,'
      || ' am1.TIME_SPENT,'
      || ' am1.DESCRIPTION,'
      || ' am1.TYPE,'
      || ' am1.OPERATOR,'
      || ' am1.SYSMODTIME,'
      || ' am1.THENUMBER,'
	  || ' bipkg_utils.bifnc_adjustfortz(pb.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,'
	  || ' bipkg_utils.bifnc_adjustfortz(pb.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time,'
	  || ' bipkg_utils.bifnc_adjustfortz(pb.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time,'
	  || ' bipkg_utils.bifnc_adjustfortz(pb.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time,'
	  || ' bipkg_utils.bifnc_adjustfortz(pb.prev_update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') prev_update_time,'
	  || ' ''' || v_startdatedisplay || '''' || ' StartDateDisplay,'
	  || ' ''' || v_enddatedisplay || '''' || ' EndDateDisplay'
	  || ' FROM'
	  || ' sc.PROBLEMM1 pb'
      || ' LEFT JOIN sc.ASSIGNMENTA1 A1'
      || ' ON A1.name = pb.assignment AND A1.OPERATORS = pb.updated_by'
      || ' LEFT OUTER JOIN sc.ACTIVITYM1 AM1 ON pb.UPDATE_TIME = AM1.SYSMODTIME AND pb.NUMBERPRGN = AM1.NUMBERPRGN AND pb.PAGE = AM1.PAGE'
	  || ' WHERE'
	  || ' ( ' || bipkg_utils.bifnc_createinlist ('pb.assignment', pcurrgroup) || ' )' 
	  || ' and pb.update_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''')'
	  || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(pb.category, '' '')', vinteraction_type)|| ')'
	  || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(am1.TYPE, '' '')', vactivity_type)|| ')'
	  || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(pb.priority, '' '')', vpriority)|| ')'
	  || ' AND NOT (AM1.TYPE = ''Status Change'')'
	  ;  
      open time_spent_cursor for v_select_stmt;
	  
   end bisp_time_spent;
   
end bipkg_Gv_time_spent;
/

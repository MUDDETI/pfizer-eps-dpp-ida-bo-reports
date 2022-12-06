CREATE OR REPLACE package bipkg_time_spent
as
   type bisp_refcursor_type is ref cursor;
   
/******************************************************************************
   name:       bipkg_time_spent
   purpose:

   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06/28/2006  -sgummadi-	   1. created this package.
   2.0		  06/28/2006  -sgummadi-	   1. added bisp_time_spent procedure
******************************************************************************/
   
   procedure bisp_time_spent (
      time_spent_cursor   in out   bisp_refcursor_type,
      pcurrgroup		  in 	   varchar2,
	  pfrequency		  in       varchar2,
      poverride			  in       varchar2,
      pzone				  in       varchar2,
      pstartdate		  in       date,
      penddate			  in       date
   );
   
end bipkg_time_spent;
/
CREATE OR REPLACE package body bipkg_time_spent
as
/******************************************************************************
   name:       bisp_time_spent
   purpose:

   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0		  06/28/2006  -sgummadi-	   1. created bisp_time_spent procedure
******************************************************************************/

   procedure bisp_time_spent (
      time_spent_cursor   in out   bisp_refcursor_type,
      pcurrgroup		  in 	   varchar2,
	  pfrequency		  in       varchar2,
      poverride			  in       varchar2,
      pzone				  in       varchar2,
      pstartdate		  in       date,
      penddate			  in       date
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
	  'select '
	  || ' problemm1.numberprgn,'
	  || ' problemm1.assignment,'
	  || ' problemm1.updated_by,'
	  || ' problemm1.product_type,'
	  || ' problemm1.problem_type,'
	  || ' problemm1.problem_status,'
	  || ' problemm1.ticket_owner,'
	  || ' problemm1.brief_description,'
	  || ' problemm1.time_spent,'
	  || ' bipkg_utils.bifnc_adjustfortz(problemm1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,'
	  || ' bipkg_utils.bifnc_adjustfortz(problemm1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time,'
	  || ' ''' || v_startdatedisplay || '''' || ' StartDateDisplay,'
	  || ' ''' || v_enddatedisplay || '''' || ' EndDateDisplay'
	  || ' from'
	  || ' sc.problemm1'
	  || ' where'
	  || ' ( ' || bipkg_utils.bifnc_createinlist ('problemm1.assignment', pcurrgroup) || ' )' 
	  || ' and problemm1.update_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''')'
	  || ' and problemm1.updated_by <> ''problem'''
	  ;  
      open time_spent_cursor for v_select_stmt;
	  
   end bisp_time_spent;
   
end bipkg_time_spent;
/


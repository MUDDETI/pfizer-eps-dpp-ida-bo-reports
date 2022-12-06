CREATE OR REPLACE package bipkg_inc_over_sla
as
/******************************************************************************
   name:       bipkg_inc_past_sla
   purpose:

   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0		  07/27/2006  -sgummadi-	   1. added bisp_inc_over_sla										   
******************************************************************************/
   type bisp_refcursor_type is ref cursor;
   
   procedure bisp_main_rpt_trigger(
      main_rpt_trigger_cursor	   in out    bisp_refcursor_type,
	  pzone					   in 		 varchar2,
	  poverride				   in		 varchar2,
	  penddate				   in		 date
   );  
			 
   procedure bisp_inc_over_sla (
      bisp_inc_over_sla_cursor in out bisp_refcursor_type,
	  pcurrgroup			   in 	  varchar2,
	  preportedby			   in	  varchar2,
	  ppriority				   in	  varchar2,
	  pzone					   in	  varchar2,
	  poverride				   in	  varchar2,
	  penddate				   in	  date
   );
end bipkg_inc_over_sla;
/
CREATE OR REPLACE package body bipkg_inc_over_sla
as
/******************************************************************************
   name:       bipkg_inc_past_sla
   purpose:

   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0		  07/27/2006  -sgummadi-	   1. added bisp_inc_over_sla										   
******************************************************************************/
   procedure bisp_main_rpt_trigger(
      main_rpt_trigger_cursor  in out    bisp_refcursor_type,
	  pzone					   in 		 varchar2,
	  poverride				   in		 varchar2,
	  penddate				   in		 date
   )
   is
      v_enddatedisplay     date;
      v_gmt_startdate      date;
      v_gmt_enddate        date;
	  v_db_zone			   varchar2(10);
      v_select_stmt        varchar2(2000);
   begin
      v_db_zone := 'GMT';
	  if penddate is null then
	     bipkg_utils.bisp_getstartandenddates('daily', poverride, pzone, null, null, v_gmt_startdate, v_gmt_enddate);
		 v_enddatedisplay := bipkg_utils.bifnc_adjustfortz(v_gmt_enddate, v_db_zone, pzone);
	  else
	     v_enddatedisplay := bipkg_utils.bifnc_adjustfortz(penddate, v_db_zone, pzone);
	  end if;
	  v_select_stmt := 'select to_date(''' || to_char(v_enddatedisplay, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'') as EndDateDisplay from dual';
	  open main_rpt_trigger_cursor for v_select_stmt;
   end bisp_main_rpt_trigger;

   procedure bisp_inc_over_sla (
      bisp_inc_over_sla_cursor in out bisp_refcursor_type,
	  pcurrgroup			   in 	  varchar2,
	  preportedby			   in	  varchar2,
	  ppriority				   in	  varchar2,
	  pzone					   in	  varchar2,
	  poverride				   in	  varchar2,
	  penddate				   in	  date
   )
   is
	  v_db_zone			   varchar2(3);
      v_gmt_startdate	   date;
	  v_gmt_enddate        date;
	  v_enddate			   varchar2 (100);
	  v_select_stmt		   varchar2(32767);
   begin
      
	  v_db_zone := 'GMT';
	  If penddate is null 
	  then bipkg_utils.bisp_getstartandenddates ('daily', poverride, pzone, null, null, v_gmt_startdate, v_gmt_enddate);
	  else bipkg_utils.bisp_getstartandenddates ('ad-hoc', 0, pzone, null, penddate, v_gmt_startdate, v_gmt_enddate);
	  end if;      
	  v_enddate := ' to_date (''' || to_char (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate, v_db_zone, pzone),'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';	  
      v_select_stmt := ' select'
   				 	|| '   probsummarym1.assignee_name'
					|| ' , bipkg_utils.bifnc_adjustfortz(probsummarym1.open_time,''' || v_db_zone || ''', ''' || pzone || ''') open_time'
					|| ' , probsummarym1.flag'
					|| ' , probsummarym1.pfz_sla_title'
					|| ' , probsummarym1.numberprgn'
					|| ' , probsummarym1.assignment'
					|| ' , probsummarym1.pfz_full_name'
					|| ' , bipkg_utils.bifnc_adjustfortz(probsummarym1.update_time,''' || v_db_zone || ''', ''' || pzone || ''') update_time'
					|| ' , probsummarym1.brief_description'
					|| ' , probsummarym1.last_activity'
					|| ' , probsummarym1.status'
					|| ' , probsummarym1.location'
					|| ' , probsummarym1.action'
					|| ' , probsummarym1.update_action'
					|| ' , ' || v_enddate || ' enddatedisplay'
					|| ' from'
					|| ' probsummarym1'
					|| ' where'
					|| ' probsummarym1.flag = ''t'''
					|| ' and (' || bipkg_utils.bifnc_createnoncsvinlist ('probsummarym1.assignment', pcurrgroup, ';') || ')'
					|| ' and (' || bipkg_utils.bifnc_createnoncsvinlist ('probsummarym1.pfz_full_name', preportedby, ';') || ')'
					|| ' and (' || bipkg_utils.bifnc_createnoncsvinlist ('probsummarym1.pfz_sla_title', ppriority, ';') || ')'
					|| ' and probsummarym1.open_time <= ' || ' to_date (''' || to_char (v_gmt_enddate,'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')'
					;
      open bisp_inc_over_sla_cursor for v_select_stmt;					
   end bisp_inc_over_sla;
end bipkg_inc_over_sla;
/


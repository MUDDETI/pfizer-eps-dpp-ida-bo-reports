CREATE OR REPLACE package bipkg_activity 
as
   type bisp_refcursor_type is ref cursor;

/******************************************************************************
   name:       bipkg_activity
   purpose:

   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06/07/2006  -rgladski-	   1. created this package.
   2.0		  06/08/2006  -rgladski-	   1. added bisp_select_activity procedure
   1.0		  08/17/2006  -shw-			   1. created bisp_select_opn_tckt_actviy 
   1.0		  08/18/2006  -shw-			   1. created bisp_select_opn_all_activity 
******************************************************************************/
   
   procedure bisp_select_activity (
      select_activity_cursor  in out   bisp_refcursor_type,
      pcurr_group        in       varchar2,
      pstartdate         in       date,
      penddate           in       date,
	  pzone				 in		  varchar2,
	  pfrequency		 in		  varchar2,
	  poverride			 in		  varchar2
   ); 

   procedure bisp_select_opn_tckt_actvty (
      select_activity_cursor  in out   bisp_refcursor_type,
      pcurr_group        in       varchar2,
      ppfz_bu	         in       varchar2,
      pprojects	         in       varchar2,
      pstartdate         in       date,
      penddate           in       date,
	  pzone				 in		  varchar2,
	  pfrequency		 in		  varchar2,
	  poverride			 in		  varchar2
   ); 

   procedure bisp_select_opn_all_actvty (
      select_activity_cursor  in out   bisp_refcursor_type,
      pcurr_group        in       varchar2,
      pactivity	         in       varchar2,
      pstatus	         in       varchar2,
      pstartdate         in       date,
      penddate           in       date,
	  pzone				 in		  varchar2,
	  pfrequency		 in		  varchar2,
	  poverride			 in		  varchar2
   ); 

end bipkg_activity;
/
CREATE OR REPLACE package body bipkg_activity
as

-- error handling is done by the report. 
-- we do not trap any exceptions at the database side.

/******************************************************************************
   name:       bisp_select_activity
   purpose:

   revisions:
   ver        date        author          description
   ---------  ----------  ---------------  ------------------------------------
    1.0		  06/08/2006 	-rgladski-		1. created bisp_select_activity
   1.0		  08/17/2006  -shw-			   1. created bisp_select_opn_tckt_actviy 
   1.0		  08/18/2006  -shw-			   1. created bisp_select_opn_all_activity 
******************************************************************************/

   procedure bisp_select_activity (
      select_activity_cursor  in out   bisp_refcursor_type,
      pcurr_group        in       varchar2,
      pstartdate         in       date,
      penddate           in       date,
	  pzone				 in		  varchar2,
	  pfrequency		 in		  varchar2,
	  poverride			 in		  varchar2
   )  
   is
      v_startdatedisplay   date;
      v_enddatedisplay     date;
      v_gmt_startdate      date;
      v_gmt_enddate        date;
	  v_db_zone			   varchar2(4);
      v_select_stmt        varchar2(2000);
	  v_sel_inlist_assign  varchar2(2000);
	  v_sel_inlist_opengrp varchar2(2000);
	  v_date_range         varchar2(2000);

   begin
   		v_db_zone := 'GMT';
		if pfrequency = 'ad-hoc' then
		   --call the date validation function
		    v_startdatedisplay := pstartdate;
		    v_enddatedisplay := penddate;
			v_gmt_startdate := bipkg_utils.bifnc_adjustfortz(pstartdate, pzone, v_db_zone);
			v_gmt_enddate:= bipkg_utils.bifnc_adjustfortz(penddate, pzone, v_db_zone);
		else
			bipkg_utils.bisp_getstartandenddates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
			v_startdatedisplay := bipkg_utils.bifnc_adjustfortz(v_gmt_startdate, v_db_zone, pzone);
			v_enddatedisplay := bipkg_utils.bifnc_adjustfortz(v_gmt_enddate, v_db_zone, pzone);
		end if;
		
		v_sel_inlist_assign := bipkg_utils.bifnc_createinlist ('M1.ASSIGNMENT', pcurr_group);
		v_sel_inlist_opengrp := bipkg_utils.bifnc_createinlist ('M1.OPEN_GROUP', pcurr_group);
		v_date_range := bipkg_utils.bifnc_datesbetween('M1.UPDATE_TIME',v_gmt_startdate,v_gmt_enddate);
		
   		v_select_stmt := 'SELECT /*+ index(M1 PROBLEMM1_3) */ ' ||
		'M1.ASSIGNMENT,' || 
		'M1.CLOSE_TIME,' || 
		'M1.FLAG,' || 
		'M1.NUMBERPRGN,' || 
		'M1.OPEN_TIME,' || 
		'M1.PAGE,' || 
		'M1.UPDATED_BY,' || 
		'M1.UPDATE_TIME,' || 
		'M1.OPEN_GROUP,' || 
		'M2.PFZ_RESOLVE_SLA' ||
		',to_date(' || '''' || to_char(v_gmt_startdate,'DD-MM-YYYY HH24:MI:SS') || '''' || ',''DD-MON-YYYY HH24:MI:SS'') as gmtsdate' ||
		',to_date(' || '''' || to_char(v_gmt_enddate,'DD-MM-YYYY HH24:MI:SS')   || '''' || ',''DD-MON-YYYY HH24:MI:SS'') as gmtedate' ||
		',to_date(' || '''' || to_char(v_startdatedisplay,'DD-MON-YYYY HH24:MI:SS') || '''' || ',''DD-MON-YYYY HH24:MI:SS'') as StartDateDisplay' || 
		',to_date(' || '''' || to_char(v_enddatedisplay,'DD-MON-YYYY HH24:MI:SS') || '''' || ',''DD-MON-YYYY HH24:MI:SS'') as EndDateDisplay ' ||
		
		'FROM	    SC.PROBLEMM1 M1 ' || 
		
		'INNER JOIN	SC.PROBLEMM2 M2' ||
		' ON	  	M1.NUMBERPRGN=M2.NUMBERPRGN' ||
		' AND		M1.PAGE=M2.PAGE ' ||
		
		'WHERE		M1.UPDATED_BY		<> ' || '''problem''' ||   
   		' AND		' || v_date_range || 
		' AND		(' ||
		 			v_sel_inlist_assign || 
		'			OR ' || v_sel_inlist_opengrp || 
		'			AND M1.PAGE			= 1' ||
		'			)' ||
		' and rownum < 10';
		
      open select_activity_cursor for v_select_stmt;
   end bisp_select_activity;


   procedure bisp_select_opn_tckt_actvty (
      select_activity_cursor  in out   bisp_refcursor_type,
      pcurr_group        in       varchar2,
      ppfz_bu	         in       varchar2,
      pprojects	         in       varchar2,
      pstartdate         in       date,
      penddate           in       date,
	  pzone				 in		  varchar2,
	  pfrequency		 in		  varchar2,
	  poverride			 in		  varchar2
   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_whereclause        VARCHAR2 (32767);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.category, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.commodity, probsummarym1.country, probsummarym1.dept,probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_charge_code, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.problem_status, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ';
		v_select_stmt := v_select_stmt || ' ACTIVITYM1.TYPE, ACTIVITYM1.OPERATOR,ACTIVITYM1.THENUMBER,  ACTIVITYM1.SYSMODTIME, ACTIVITYM1.DESCRIPTION, ';  
		v_select_stmt := v_select_stmt || ' PROBLEMM1.UPDATED_BY, PROBLEMM1.PFZ_SLA_TITLE, PROBLEMM1.ASSIGNMENT,PROBLEMM1.PROBLEM_STATUS, PROBLEMM1.LAST_ACTIVITY, PROBLEMM1.ACTOR, PROBLEMM1.UPDATE_ACTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM (PROBSUMMARYM1 PROBSUMMARYM1 INNER JOIN PROBLEMM1 PROBLEMM1 ON PROBSUMMARYM1.NUMBERPRGN = PROBLEMM1.NUMBERPRGN) ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ACTIVITYM1 ACTIVITYM1 ON PROBLEMM1.UPDATE_TIME = ACTIVITYM1.SYSMODTIME AND PROBLEMM1.NUMBERPRGN = ACTIVITYM1.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' WHERE probsummarym1.flag = ' || '''' || 't' || '''' || '';     
		v_select_stmt := v_select_stmt || ' AND probsummarym1.ASSIGNEE_NAME <> ' || '''' || 'UNASSIGNED' || '''' || '';     
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignment', pcurr_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.pfz_bu', ppfz_bu) || ')';

		if (pprojects = 'Y')
		then
			v_whereclause := ' AND probsummarym1.open_time <  ' || '''' || v_gmt_enddate || '''' ;
		else
			v_whereclause := ' AND probsummarym1.pfz_sla_title <> ' || '''' || 'Project' || '''' || ''; 
			v_whereclause := v_whereclause || ' AND probsummarym1.open_time <  ' || '''' || v_gmt_enddate || '''' ;
		end if;
		v_select_stmt := v_select_stmt || v_whereclause ;
		
      open select_activity_cursor for v_select_stmt;
   end bisp_select_opn_tckt_actvty;

-- used for Open Ticket Activity by Assignment-Assignee-ProblemStatus-sproc.rpt 
   procedure bisp_select_opn_all_actvty (
      select_activity_cursor  in out   bisp_refcursor_type,
      pcurr_group        in       varchar2,
      pactivity	         in       varchar2,
      pstatus	         in       varchar2,
      pstartdate         in       date,
      penddate           in       date,
	  pzone				 in		  varchar2,
	  pfrequency		 in		  varchar2,
	  poverride			 in		  varchar2
   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_whereclause        VARCHAR2 (32767);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.category, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.commodity, probsummarym1.country, probsummarym1.dept,probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_charge_code, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.problem_status, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ';
		v_select_stmt := v_select_stmt || ' ACTIVITYM1.TYPE, ACTIVITYM1.OPERATOR,ACTIVITYM1.THENUMBER,  ACTIVITYM1.SYSMODTIME, ACTIVITYM1.DESCRIPTION, ';  
		v_select_stmt := v_select_stmt || ' PROBLEMM1.UPDATED_BY, PROBLEMM1.PFZ_SLA_TITLE, PROBLEMM1.ASSIGNMENT,PROBLEMM1.PROBLEM_STATUS, PROBLEMM1.LAST_ACTIVITY, PROBLEMM1.ACTOR,PROBLEMM1.NUMBERPRGN, PROBLEMM1.ASSIGNEE_NAME,PROBLEMM1.TIME_SPENT,PROBLEMM1.UPDATE_TIME, PROBLEMM1.SYSMODTIME,PROBLEMM1.UPDATE_ACTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM (PROBSUMMARYM1 PROBSUMMARYM1 INNER JOIN PROBLEMM1 PROBLEMM1 ON PROBSUMMARYM1.NUMBERPRGN = PROBLEMM1.NUMBERPRGN) ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ACTIVITYM1 ACTIVITYM1 ON PROBLEMM1.UPDATE_TIME = ACTIVITYM1.SYSMODTIME AND PROBLEMM1.NUMBERPRGN = ACTIVITYM1.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' WHERE probsummarym1.flag = ' || '''' || 't' || '''' || '';     
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignment', pcurr_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.problem_status', pstatus) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT(ACTIVITYM1.DESCRIPTION like  ' || '''' || 'Problem*' || '''' || ')';  

		if (pactivity = 'Activities in date range')
		then
			v_whereclause := ' AND (ACTIVITYM1.SYSMODTIME >= ' || '''' || v_gmt_startdate || '''' || 'AND ACTIVITYM1.SYSMODTIME < ' || '''' || v_gmt_enddate || ''')';
		else
			v_whereclause := ' '; 
		end if;
		v_select_stmt := v_select_stmt || v_whereclause ;
		
      open select_activity_cursor for v_select_stmt;
   end bisp_select_opn_all_actvty;
   
end bipkg_activity;
/


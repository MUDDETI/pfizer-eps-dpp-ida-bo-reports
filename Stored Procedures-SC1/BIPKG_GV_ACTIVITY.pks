CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_GV_ACTIVITY AS
   TYPE bisp_refcursor_type IS REF CURSOR;

/******************************************************************************
   name:       bipkg_activity
   purpose:

   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06/07/2006  -rgladski-	   1. created this package.
   2.0		  06/08/2006  -rgladski-	   1. added bisp_select_activity procedure
   1.0		  08/17/2006  -shw-			   1. created bisp_select_opn_tckt_actviy 
   1.0		  08/18/2006  -shw-               1. created bisp_select_opn_all_activity 
   2.0          10.17.2007  -shw-               1. GAMP process changes 
   2.1          11.17.07    -shw-           1. GAMP views vs. table(s) 
******************************************************************************/
   
   PROCEDURE bisp_select_activity (
      select_activity_cursor  IN OUT   bisp_refcursor_type,
      pcurr_group        IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pzone                 IN          VARCHAR2,
      pfrequency         IN          VARCHAR2,
      poverride             IN          VARCHAR2
   ); 

   PROCEDURE bisp_select_opn_tckt_actvty (
      select_activity_cursor  IN OUT   bisp_refcursor_type,
      pcurr_group        IN       VARCHAR2,
      ppfz_bu             IN       VARCHAR2,
      pprojects             IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pzone                 IN          VARCHAR2,
      pfrequency         IN          VARCHAR2,
      poverride             IN          VARCHAR2,
      vinteraction_type     IN          VARCHAR2
   ); 

   PROCEDURE bisp_select_opn_all_actvty (
      select_activity_cursor  IN OUT   bisp_refcursor_type,
      pcurr_group        IN       VARCHAR2,
      pactivity             IN       VARCHAR2,
      pstatus             IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pzone                 IN          VARCHAR2,
      pfrequency         IN          VARCHAR2,
      poverride             IN          VARCHAR2,
      vinteraction_type     IN          VARCHAR2
   ); 

END BIPKG_GV_ACTIVITY;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.Bipkg_Gv_Activity
AS

-- error handling is done by the report. 
-- we do not trap any exceptions at the database side.

/******************************************************************************
   name:       bisp_select_activity
   purpose:

   revisions:
   ver        date        author          description
   ---------  ----------  ---------------  ------------------------------------
    1.0          06/08/2006     -rgladski-        1. created bisp_select_activity
   1.0          08/17/2006  -shw-               1. created bisp_select_opn_tckt_actviy 
   1.0          08/18/2006  -shw-               1. created bisp_select_opn_all_activity 
   2.0          10.17.2007  -shw-               1. GAMP process changes 
   2.1          11.17.07    -shw-           1. GAMP views vs. table(s) 
******************************************************************************/

   PROCEDURE bisp_select_activity (
      select_activity_cursor  IN OUT   bisp_refcursor_type,
      pcurr_group        IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pzone                 IN          VARCHAR2,
      pfrequency         IN          VARCHAR2,
      poverride             IN          VARCHAR2
   )  
   IS
      v_startdatedisplay   DATE;
      v_enddatedisplay     DATE;
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone               VARCHAR2(4);
      v_select_stmt        VARCHAR2(2000);
      v_sel_inlist_assign  VARCHAR2(2000);
      v_sel_inlist_opengrp VARCHAR2(2000);
      v_date_range         VARCHAR2(2000);

   BEGIN
           v_db_zone := 'GMT';
        IF pfrequency = 'ad-hoc' THEN
           --call the date validation function
            v_startdatedisplay := pstartdate;
            v_enddatedisplay := penddate;
            v_gmt_startdate := Bipkg_Utils.bifnc_adjustfortz(pstartdate, pzone, v_db_zone);
            v_gmt_enddate:= Bipkg_Utils.bifnc_adjustfortz(penddate, pzone, v_db_zone);
        ELSE
            Bipkg_Utils.bisp_getstartandenddates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
            v_startdatedisplay := Bipkg_Utils.bifnc_adjustfortz(v_gmt_startdate, v_db_zone, pzone);
            v_enddatedisplay := Bipkg_Utils.bifnc_adjustfortz(v_gmt_enddate, v_db_zone, pzone);
        END IF;
        
        v_sel_inlist_assign := Bipkg_Utils.bifnc_createinlist ('v_pb.ASSIGNMENT', pcurr_group);
        v_sel_inlist_opengrp := Bipkg_Utils.bifnc_createinlist ('v_pb.OPEN_GROUP', pcurr_group);
        v_date_range := Bipkg_Utils.bifnc_datesbetween('v_pb.UPDATE_TIME',v_gmt_startdate,v_gmt_enddate);
        
           v_select_stmt := 'SELECT ' ||
        'v_pb.ASSIGNMENT,' || 
        'v_pb.CLOSE_TIME,' || 
        'v_pb.FLAG,' || 
        'v_pb.NUMBERPRGN,' || 
        'v_pb.OPEN_TIME,' || 
        'v_pb.PAGE,' || 
        'v_pb.UPDATED_BY,' || 
        'v_pb.UPDATE_TIME,' || 
        'v_pb.OPEN_GROUP,' || 
        'v_pb.PFZ_RESOLVE_SLA' ||
        ',to_date(' || '''' || TO_CHAR(v_gmt_startdate,'DD-MM-YYYY HH24:MI:SS') || '''' || ',''DD-MON-YYYY HH24:MI:SS'') as gmtsdate' ||
        ',to_date(' || '''' || TO_CHAR(v_gmt_enddate,'DD-MM-YYYY HH24:MI:SS')   || '''' || ',''DD-MON-YYYY HH24:MI:SS'') as gmtedate' ||
        ',to_date(' || '''' || TO_CHAR(v_startdatedisplay,'DD-MON-YYYY HH24:MI:SS') || '''' || ',''DD-MON-YYYY HH24:MI:SS'') as StartDateDisplay' || 
        ',to_date(' || '''' || TO_CHAR(v_enddatedisplay,'DD-MON-YYYY HH24:MI:SS') || '''' || ',''DD-MON-YYYY HH24:MI:SS'') as EndDateDisplay ' ||
        
        'FROM        SC.v_problems v_pb ' ||      
        'WHERE        v_pb.UPDATED_BY        <> ' || '''problem''' ||   
           ' AND        ' || v_date_range || 
        ' AND        (' ||
                     v_sel_inlist_assign || 
        '            OR ' || v_sel_inlist_opengrp || 
        '            AND v_pb.PAGE            = 1' ||
        '            )' ||
        ' and rownum < 10';
        
      OPEN select_activity_cursor FOR v_select_stmt;
   END bisp_select_activity;


   PROCEDURE bisp_select_opn_tckt_actvty (
      select_activity_cursor  IN OUT   bisp_refcursor_type,
      pcurr_group        IN       VARCHAR2,
      ppfz_bu             IN       VARCHAR2,
      pprojects             IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pzone                 IN          VARCHAR2,
      pfrequency         IN          VARCHAR2,
      poverride             IN          VARCHAR2,
      vinteraction_type     IN          VARCHAR2
   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone               VARCHAR2(10);
      v_whereclause        VARCHAR2 (32767);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.category, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.commodity, v_psm.country, v_psm.dept,v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_charge_code, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.problem_status, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ';
        v_select_stmt := v_select_stmt || ' ACTIVITYM1.TYPE, ACTIVITYM1.OPERATOR,ACTIVITYM1.THENUMBER,  ACTIVITYM1.SYSMODTIME, ACTIVITYM1.DESCRIPTION, ';  
        v_select_stmt := v_select_stmt || ' v_pb.UPDATED_BY, v_pb.PFZ_SLA_TITLE, v_pb.ASSIGNMENT,v_pb.PROBLEM_STATUS, v_pb.LAST_ACTIVITY, v_pb.ACTOR, v_pb.UPDATE_ACTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED';        
        v_select_stmt := v_select_stmt || ' FROM (sc.v_probsummary v_psm INNER JOIN sc.v_problems v_pb ON v_psm.NUMBERPRGN = v_pb.NUMBERPRGN) ';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ACTIVITYM1 ACTIVITYM1 ON v_pb.UPDATE_TIME = ACTIVITYM1.SYSMODTIME AND v_pb.NUMBERPRGN = ACTIVITYM1.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE v_psm.flag = ' || '''' || 't' || '''' || '';     
        v_select_stmt := v_select_stmt || ' AND v_psm.ASSIGNEE_NAME <> ' || '''' || 'UNASSIGNED' || '''' || '';     
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', pcurr_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.pfz_bu', ppfz_bu) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') ';

        IF (pprojects = 'Y')
        THEN
            v_whereclause := ' AND v_psm.open_time <  ' || '''' || v_gmt_enddate || '''' ;
        ELSE
--            v_whereclause := ' AND v_psm.pfz_sla_title <> ' || '''' || 'Project' || '''' || ''; 
            v_whereclause := ' AND v_psm.PRIORITY <> ' || '''' || 'PROJECT' || '''' || ''; 
            v_whereclause := v_whereclause || ' AND v_psm.open_time <  ' || '''' || v_gmt_enddate || '''' ;
        END IF;
        v_select_stmt := v_select_stmt || v_whereclause ;
        
      OPEN select_activity_cursor FOR v_select_stmt;
   END bisp_select_opn_tckt_actvty;

-- used for Open Ticket Activity by Assignment-Assignee-ProblemStatus-sproc.rpt 
   PROCEDURE bisp_select_opn_all_actvty (
      select_activity_cursor  IN OUT   bisp_refcursor_type,
      pcurr_group        IN       VARCHAR2,
      pactivity             IN       VARCHAR2,
      pstatus             IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pzone                 IN          VARCHAR2,
      pfrequency         IN          VARCHAR2,
      poverride             IN          VARCHAR2,
      vinteraction_type     IN          VARCHAR2
   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone               VARCHAR2(10);
      v_whereclause        VARCHAR2 (32767);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.category, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.commodity, v_psm.country, v_psm.dept,v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_charge_code, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.problem_status, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ';
        v_select_stmt := v_select_stmt || ' ACTIVITYM1.TYPE, ACTIVITYM1.OPERATOR,ACTIVITYM1.THENUMBER,  ACTIVITYM1.SYSMODTIME, ACTIVITYM1.DESCRIPTION, ';  
        v_select_stmt := v_select_stmt || ' v_pb.UPDATED_BY, v_pb.PFZ_SLA_TITLE, v_pb.ASSIGNMENT,v_pb.PROBLEM_STATUS, v_pb.LAST_ACTIVITY, v_pb.ACTOR,v_pb.NUMBERPRGN, v_pb.ASSIGNEE_NAME,v_pb.TIME_SPENT,v_pb.UPDATE_TIME, v_pb.SYSMODTIME,v_pb.UPDATE_ACTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED';        
        v_select_stmt := v_select_stmt || ' FROM (SC.V_PROBSUMMARY v_psm INNER JOIN SC.v_problems v_pb ON v_psm.NUMBERPRGN = v_pb.NUMBERPRGN) ';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN SC.ACTIVITYM1 ACTIVITYM1 ON v_pb.UPDATE_TIME = ACTIVITYM1.SYSMODTIME AND v_pb.NUMBERPRGN = ACTIVITYM1.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE v_psm.flag = ' || '''' || 't' || '''' || '';     
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', pcurr_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.problem_status', pstatus) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT(ACTIVITYM1.DESCRIPTION like  ' || '''' || 'Problem*' || '''' || ')';  
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') ';

        IF (pactivity = 'Activities in date range')
        THEN
            v_whereclause := ' AND (ACTIVITYM1.SYSMODTIME >= ' || '''' || v_gmt_startdate || '''' || 'AND ACTIVITYM1.SYSMODTIME < ' || '''' || v_gmt_enddate || ''')';
        ELSE
            v_whereclause := ' '; 
        END IF;
        v_select_stmt := v_select_stmt || v_whereclause ;
        
      OPEN select_activity_cursor FOR v_select_stmt;
   END bisp_select_opn_all_actvty;
   
END Bipkg_Gv_Activity;
/

CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_GVR_INCIDENTS AS
/******************************************************************************
   NAME:       bipkg_incidents
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
    1.0		   05/12/2006 				   1. Created bisp_select inc 
   1.0        05/24/2006     -shw-        1. Created bisp_select_prb 
   1.0		  05/24/2006	 -shw-		  1. Created bisp_select_inc_site 
   1.0		  05.26.06		 -shw-		  1. created bisp_select_hndld    
   1.0          05.30.06         -shw-          1. created bisp_select_asgnd   
   1.0          06.02.06         -shw-          1. Created bisp_select_inc_act 
   1.0          06.20.06         -shw-          1. Created bisp_select_opn_inc 
   1.0          06.30.06         -shw-          1. NEW34 - Open or Closed Calls/Incidents by Product
                                                     Created bisp_select_inc_prd 
    1.0          07.05.06         -shw-          1. NEW31_Resolved Ticket Report by Related ProjectDivisionSpecailFlag
                                                  Created bisp_select_inc_spflg 
    1.0          07.10.06         -shw-          1. Created bisp_select_inc_closed                                                                       
    1.0          07.17.06         -shw-          1. NEW07 Created bisp_select_inc_OorC 
                                             2. bisp_select_activity_detail 
    1.0           08.12.06         -shw-           1. Created bisp_select_clo_inc 
    1.0           08.11.06         -shw-           1. Created bisp_select_inc_actvty for Daily Summary Report 
    1.0           08.22.06         -shw-           1. Created bisp_select_opened_tickets - for Messaging graphs by Hour/Month report(s)
    1.0           08.22.06         -shw-           1. Created bisp_select_open_inc_grp_analyst - for     Open Tickets Analysis report  
    1.0           10.16.06         -shw-           1. created bisp_select_closed_respond for SLA Compliance Trending report. 
    1.0           10.17.06         -shw-           1. created bisp_opened_location for Tickets Opend by Hour Graph 
    1.0        10.18.06         RIthesh       1. Created BISP_SELECT_PTOC_KBCANDIDATES for roblem Tickets Opened & Closed in a Period by KB Candidates-SPROC.rpt
       1.0          02.19.07         -sg-           1. Created bisp_operator_analysis for Operator Analysis Report
    2.0           10.26.07        shw            1. Upgrade for GAMPS 
    2.1         11.14.07    -shw-           1. Added probsummaryM2 table for Priority field 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
    3.0         01.09.08    shw         4. add resolve_time field 
    3.1         01.10.08    shw         5. add bisp_select_resolved stored procedure 
    3.2         01.15.08    -shw-           select resolved parameter or exclude resolved from open ticket selects 
******************************************************************************/

   TYPE bisp_refcursor_type IS REF CURSOR;

-- 01.15.08-shw- select resolved parameter 
   PROCEDURE bisp_select_inc (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      vinteraction_type  IN       VARCHAR2,
      vtime              IN       VARCHAR2
   );
-- 01.15.08-shw- exclude resolved parameter 
   PROCEDURE bisp_select_opn_inc_by_country (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      pcountry           IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      vinteraction_type  IN       VARCHAR2,
      Excl_Resolve       IN       VARCHAR2
   );
-- 01.15.08-shw- exclude resolved parameter 
   PROCEDURE bisp_select_opn_inc_grp_anlyst (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      panalyst           IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      vinteraction_type  IN       VARCHAR2,
      Excl_Resolve       IN       VARCHAR2
   );
   PROCEDURE bisp_select_inc_actvty (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      pproduct           IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      vinteraction_type  IN       VARCHAR2
   );
-- 01.15.08-shw- select resolved parameter 
   PROCEDURE bisp_select_clo (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      pproduct           IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      vinteraction_type  IN       VARCHAR2,
      vtime              IN       VARCHAR2
   );
-- 01.15.08-shw- exclude resolved parameter 
   PROCEDURE bisp_select_opn_inc (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      pproduct           IN       VARCHAR2,
      pdept              IN       VARCHAR2,
      pbu                IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      vinteraction_type  IN       VARCHAR2,
      Excl_Resolve       IN       VARCHAR2
   );
-- 08.22.06 Created bisp_select_opened_tickets - for Messaging graphs by Hour/Month report(s)
   PROCEDURE bisp_select_opened_tickets (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      pproduct           IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      vinteraction_type  IN       VARCHAR2
   );
-- 10.17.06 Created bisp_opened_loctn - for Opened by Hour Graph 
   PROCEDURE bisp_select_opened_location (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      plocation          IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      vinteraction_type  IN       VARCHAR2
   );
   
   
   -- 10.18.06 Created bisp_select_PTOC_KBCANDIDATES - for OProblem Tickets Opened & Closed in a Period by KB Candidates-SPROC.rpt 
   PROCEDURE bisp_select_PTOC_KBCANDIDATES (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      vinteraction_type  IN       VARCHAR2
   );
   
   
   
   PROCEDURE bisp_select_inc_act (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      popenorclosed      IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      vinteraction_type  IN       VARCHAR2
   );
-- 07.17.06-shw- Activity Detail 
   PROCEDURE bisp_select_activity_detail (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      pnumberprgn        IN       VARCHAR2,
      pzone              IN       VARCHAR2
   );
-- 07.17.06-shw- NEW07_Opened or Closed or Opened And Closed Probsummary 
   PROCEDURE bisp_select_inc_OorC (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      popenorclosed      IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      vinteraction_type  IN       VARCHAR2
   );
   PROCEDURE bisp_select_inc_prd (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      plocation          IN       VARCHAR2,
      pcountry           IN       VARCHAR2,
      pproduct           IN       VARCHAR2,
      popenorclosed      IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      vinteraction_type  IN       VARCHAR2
   );
   PROCEDURE bisp_select_inc_spflg (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      pdivision          IN       VARCHAR2,
      pspecialflag       IN       VARCHAR2,
      pproject           IN       VARCHAR2,
      popenorclosed      IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      vinteraction_type  IN       VARCHAR2
   );
-- 01.15.08-shw- select resolved parameter 
   PROCEDURE bisp_select_inc_site (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      plocation          IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      vinteraction_type  IN       VARCHAR2,
      vtime              IN       VARCHAR2
   );
-- 12.05.06-shw- added Project & Division params for J&J Transition (PCH) 
-- 01.15.08-shw- select resolved parameter 
   PROCEDURE bisp_select_inc_divprj (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      plocation          IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pproject           IN       VARCHAR2,
      pdivision          IN       VARCHAR2,
      vinteraction_type  IN       VARCHAR2,
      vtime              IN       VARCHAR2
   );
   PROCEDURE bisp_select_prb (
      select_prb_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      plocation           IN       VARCHAR2,
      pcallorigin         IN       VARCHAR2,
      pcontactname        IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   );
--    3.0         01.09.08    shw         4. Allow Resolved Exclusion   
   PROCEDURE bisp_select_hndld (
      select_prb_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   );
   PROCEDURE bisp_select_in_queue (
      select_inq_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   );
   PROCEDURE bisp_select_assigned (
      select_prb_cursor   IN OUT   bisp_refcursor_type,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   );
   PROCEDURE bisp_select_closed (
      select_closed_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   );
   PROCEDURE bisp_select_resolved (
      select_resolved_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   );
   
-- 01.15.08-shw- select resolved parameter 
   PROCEDURE bisp_select_closed_respond (
      select_closed_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2,
      vtime               IN       VARCHAR2
   );
   -- For Combined Report #24.
   PROCEDURE bisp_select_inc_by_parm(
      --vsql                   OUT    VARCHAR2,
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignment         IN       VARCHAR2,
      popen_group         IN       VARCHAR2,
      pgroup_by           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   );
   
   PROCEDURE bisp_operator_analysis (
      operator_analysis_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
	  vinteraction_type	  IN	   VARCHAR2
	  
   );
END BIPKG_GVR_INCIDENTS;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.Bipkg_GvR_Incidents
AS
/******************************************************************************
   NAME:       bipkg_incidents
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
    1.0           05/12/2006                    1. Created bisp_select inc 
   1.0        05/24/2006     -shw-        1. Created bisp_select_prb 
   1.0          05/24/2006     -shw-          1. Created bisp_select_inc_site 
   1.0          05.26.06         -shw-          1. created bisp_select_hndld    
   1.0          05.30.06         -shw-          1. created bisp_select_asgnd   
   1.0          06.02.06         -shw-          1. Created bisp_select_inc_act 
   1.0          06.20.06         -shw-          1. Created bisp_select_opn_inc 
   1.0          06.30.06         -shw-          1. NEW34 - Open or Closed Calls/Incidents by Product 
                                                     Created bisp_select_inc_prd                                          
    1.0          07.05.06         -shw-          1. NEW31_Resolved Ticket Report by Related ProjectDivisionSpecailFlag 
                                                  Created bisp_select_inc_spflg 
    1.0          07.10.06         -shw-          1. Created bisp_select_inc_closed                                                                       
    1.0          07.17.06         -shw-          1. NEW07 Created bisp_select_inc_OorC 
                                             2. bisp_select_activity_detail 
    1.0           08.01.06         -shw-         added both open & closed to NEW34 (bisp_select_prb) 
    1.0           08.11.06         -shw-           1. Created bisp_select_clo_inc 
    1.0           08.11.06         -shw-           1. Created bisp_select_inc_actvty for Daily Summary Report 
    1.0           08.16.06         -shw-           1. Created bisp_select_open_inc_by_country 
    1.0           08.22.06         -shw-           1. Created bisp_select_opened_tickets - for Messaging graphs by Hour/Month report(s)
    1.0           08.22.06         -shw-           1. Created bisp_select_open_inc_grp_analyst - for     Open Tickets Analysis report 
    1.0           10.10.06         -shw-           1. Added 'flag' to promsummarym1 selects, for speed.  
    1.0           10.16.06         -shw-           1. created bisp_select_closed_respond for SLA Compliance Trending report. 
    1.0           10.17.06         -shw-           1. created bisp_opened_location for Tickets Opend by Hour Graph 
   1.0        10.17.06         RIthesh       1. Created BISP_SELECT_PTOC_KBCANDIDATES for roblem Tickets Opened & Closed in a Period by KB Candidates-SPROC.rpt
   1.0          02.19.07         -sg-           1. Created bisp_operator_analysis for Operator Analysis Report
    2.0           10.26.07        shw            1. Upgrade for GAMPS 
    2.1         11.14.07    -shw-           1. Added v_psm table for Priority field 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
    2.3         01.03.08     shw        1.Upgrade for GAMPS
    3.0         01.09.08    shw         4. add resolve_time field 
    3.1         01.10.08    shw         5. add bisp_select_resolved stored procedure 
    3.2         01.15.08    -shw-           select resolved parameter or exclude resolved from open ticket selects 
******************************************************************************/
--
-- Error Handling is done by the report. We do not trap any exceptions at the Database side.
--
-- 01.15.08-shw- select resolved parameter 
   PROCEDURE bisp_select_inc (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2,
      vtime               IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.category, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.commodity, v_psm.country, v_psm.dept,v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_charge_code, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.problem_status, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.open_group', porig_group) || ')';
                IF vtime = 'Closed' 
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND v_psm.flag = ' || '''' || 'f' || '''' || ''; 
        Else
        v_select_stmt := v_select_stmt || ' AND v_psm.resolve_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.resolve_time < ' || '''' || v_gmt_enddate || '''' ;
        End If;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc;

-- 01.15.08-shw- exclude resolved parameter 
   PROCEDURE bisp_select_opn_inc_grp_anlyst (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      panalyst           IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      vinteraction_type  IN       VARCHAR2,
      Excl_Resolve       IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_currentdate        VARCHAR(50);
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        v_currentdate := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(SYSDATE, 'EST', pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.category, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.commodity, v_psm.country, v_psm.dept,v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_charge_code, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.problem_status, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, '|| '''' || v_currentdate || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.open_group', porig_group ) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignee_name', panalyst) || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.flag = ' || '''' || 't' || '''' || ''; 
      If Excl_Resolve = 'Y'
      Then
-- only include if resolve_time is NULL 
        v_select_stmt := v_select_stmt || ' AND (NVL(v_psm.resolve_time,'||'''' || SYSDATE || '''' || ') = '||'''' || SYSDATE || '''' || ')' ;
      Else
        v_select_stmt := v_select_stmt || '';
      
      End If;

        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_opn_inc_grp_anlyst;

-- Created bisp_select_open_inc_by_country  for Open Incidents Detail by Country-Assignment report 

-- 01.15.08-shw- exclude resolved parameter 
   PROCEDURE bisp_select_opn_inc_by_country (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      pcountry            IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      vinteraction_type   IN       VARCHAR2,
      Excl_Resolve        IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_currentdate        VARCHAR(50);
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        v_currentdate := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(SYSDATE, 'EST', pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.category, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.commodity, v_psm.country, v_psm.dept,v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_charge_code, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.problem_status, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, '|| '''' || v_currentdate || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.country', pcountry) || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.flag = ' || '''' || 't' || '''' || ''; 
      If Excl_Resolve = 'Y'
      Then
-- only include if resolve_time is NULL 
        v_select_stmt := v_select_stmt || ' AND (NVL(v_psm.resolve_time,'||'''' || SYSDATE || '''' || ') = '||'''' || SYSDATE || '''' || ')' ;
      Else
        v_select_stmt := v_select_stmt || '';
      
      End If;

        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_opn_inc_by_country;

--      Created bisp_select_inc_actvty for Daily Summary Report 

   PROCEDURE bisp_select_inc_actvty (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
      pproduct            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdatem1    DATE;
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.country, v_psm.dept,v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_charge_code, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.problem_status, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.open_group', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.product_type', pproduct) || ')';
        v_select_stmt := v_select_stmt || ' AND ((v_psm.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.open_time < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' OR v_psm.flag = ' || '''' || 't' || '''' || ''; 
        v_select_stmt := v_select_stmt || ' OR (v_psm.open_time < ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time >= ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' OR (v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''))' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc_actvty;

-- 08.11.06-shw- Closed Incidents (Daily Summary Sub-report) 
-- 01.15.08-shw- select resolved parameter 
   PROCEDURE bisp_select_clo (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
      pproduct            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2,
      vtime               IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.country, v_psm.dept,v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_charge_code, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.problem_status, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.open_group', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.product_type', pproduct) || ')';
                IF vtime = 'Closed' 
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND v_psm.flag = ' || '''' || 'f' || '''' || ''; 
        Else
        v_select_stmt := v_select_stmt || ' AND v_psm.resolve_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.resolve_time < ' || '''' || v_gmt_enddate || '''' ;
        End If;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_clo;
-- 06.20.06-shw- Open Probsummary Activity 
-- 01.15.08-shw- exclude resolved parameter 
   PROCEDURE bisp_select_opn_inc (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
      pproduct            IN       VARCHAR2,
      pdept               IN       VARCHAR2,
      pbu                 IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2,
      Excl_Resolve        IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.country, v_psm.dept,v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_charge_code, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.problem_status, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.open_group', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.product_type', pproduct) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.dept', pdept) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.pfz_bu', pbu) || ')';
      If Excl_Resolve = 'Y'
      Then
-- only include if resolve_time is NULL 
        v_select_stmt := v_select_stmt || ' AND (NVL(v_psm.resolve_time,'||'''' || SYSDATE || '''' || ') = '||'''' || SYSDATE || '''' || ')' ;
      Else
        v_select_stmt := v_select_stmt || '';
      End If;
        v_select_stmt := v_select_stmt || ' AND v_psm.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.open_time < ' || '''' || v_gmt_enddate || '''' ;      
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_opn_inc;

-- *****************************************************************************************   
-- 08.22.06 Created bisp_select_open_tickets - for Messaging graphs by Hour/Month report(s) 
   PROCEDURE bisp_select_opened_tickets (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      pproduct            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.country, v_psm.dept,v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_charge_code, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.problem_status, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.product_type', pproduct) || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.open_time < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_opened_tickets;

-- *****************************************************************************************   
-- 10.17.06 Created bisp_opened_loctn - for Tickets Opened by Hour Graph 

   PROCEDURE bisp_select_opened_location (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      plocation           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.country, v_psm.dept,v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_charge_code, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.problem_status, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.location', plocation) || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.open_time < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_opened_location;
   
   
   
   -- *****************************************************************************************   
-- 10.18.06 Created bisp_select_PTOC_KBCANDIDATES - for Problem Tickets Opened & Closed in a Period by KB Candidates-SPROC.rpt 
   PROCEDURE bisp_select_PTOC_KBCANDIDATES (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      vinteraction_type  IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.SOLUTION_CANDIDATE,v_psm.ASSIGNEE_NAME, v_psm.ASSIGNMENT, v_psm.NUMBERPRGN, v_psm.PFZ_FULL_NAME, v_psm.PFZ_SITE_ID, v_psm.BRIEF_DESCRIPTION, v_psm.RESOLUTION, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ( v_psm.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm ' ;
        v_select_stmt := v_select_stmt || ' WHERE (v_psm.SOLUTION_CANDIDATE =  ' || '''' || 't' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;                                                                                                                                   
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_PTOC_KBCANDIDATES;
   
   
   
    
-- 06.02.06-shw- Open or Closed Probsummary with activity and VIP  
   PROCEDURE bisp_select_inc_act (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2, 
      popenorclosed       IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_whereclause        VARCHAR2(32767); 
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT operatorm1v.full_name, activitym1.description, activitym1.datestamp,activitym1.type, activitym1.operator, v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.country, v_psm.dept,v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_charge_code, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_rb_dept, v_psm.pfz_rb_email, v_psm.pfz_rb_location, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.pfz_vip,v_psm.priority_code, v_psm.problem_type, v_psm.problem_status, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON v_psm.updated_by = operatorm1v.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN activitym1 activitym1 ON v_psm.numberprgn = activitym1.numberprgn';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.pfz_vip = ' || '''' || 't' || '''' || ''; 
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        IF (popenorclosed = 'Closed')
        THEN
            v_whereclause := ' AND v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''' ;
        ELSE
            v_whereclause := ' AND v_psm.flag = ' || '''' || 't' || '''' || ''; 
        END IF;
        v_select_stmt := v_select_stmt || v_whereclause ;
        
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc_act;

-- 07.17.06-shw- Activity Details 
-- 01.16.08-shw- added new fields 
   PROCEDURE bisp_select_activity_detail (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      pnumberprgn         IN       VARCHAR2, 
      pzone               IN       VARCHAR2
   )
   AS
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        v_select_stmt := 'SELECT activitym1.numberprgn, activitym1.description, BIPKG_UTILS.BIFNC_AdjustForTZ(activitym1.datestamp,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') datestamp,activitym1.type, activitym1.operator, BIPKG_UTILS.BIFNC_AdjustForTZ(activitym1.sysmodtime,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') sysmodtime, ';
        v_select_stmt := v_select_stmt || ' activitym1.assignment, activitym1.time_spent, activitym1.pfz_total_time_spent, activitym1.product_type, activitym1.problem_type';
        v_select_stmt := v_select_stmt || ' FROM activitym1 activitym1';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('activitym1.numberprgn', pnumberprgn) || ')';
        
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_activity_detail;

-- 07.17.06-shw- NEW07_Opened or Closed or Opened And Closed Probsummary 
   PROCEDURE bisp_select_inc_OorC (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2, 
      popenorclosed       IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_whereclause        VARCHAR2(32767); 
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT operatorm1v.full_name, v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.country, v_psm.dept,v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_charge_code, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_rb_dept, v_psm.pfz_rb_email, v_psm.pfz_rb_location, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.pfz_vip,v_psm.priority_code, v_psm.problem_type, v_psm.problem_status, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.sysmoduser,v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON v_psm.updated_by = operatorm1v.name';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        IF (popenorclosed = 'Opened or Closed in Period')
        THEN
            v_whereclause := ' AND ((v_psm.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.open_time < ' || '''' || v_gmt_enddate || ''')';
            v_whereclause := v_whereclause || ' OR (v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''))';
        ELSE
            v_whereclause := ' AND v_psm.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''' ;
        END IF;
        v_select_stmt := v_select_stmt || v_whereclause ;
        
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc_OorC;
   
-- NEW34 - Open or Closed Calls/Incidents by Product / Products by Country 
--  01.15.08-shw- add resolved option 
   PROCEDURE bisp_select_inc_prd (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2, 
      porig_group         IN       VARCHAR2,
      plocation           IN       VARCHAR2,
      pcountry            IN       VARCHAR2,
      pproduct            IN       VARCHAR2,
      popenorclosed       IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_whereclause        VARCHAR2(32767); 
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT operatorm1v.full_name, operatorm1v_1.full_name, operatorm1_problem_assignee.full_name, ';
        v_select_stmt := v_select_stmt || ' incidentsm1.incident_id, incidentsm1.product_type, incidentsm1.pfz_orig_group, incidentsm1.resolution_code, incidentsm1.pfz_full_name, incidentsm1.phone, incidentsm1.pfz_division, incidentsm1.pfz_bu, incidentsm1.pfz_sla_title, incidentsm1.open, ';
        v_select_stmt := v_select_stmt || ' v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.contact_phone, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.country, v_psm.dept,v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_charge_code, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_rb_dept, v_psm.pfz_rb_email, v_psm.pfz_rb_location, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.pfz_vip,v_psm.priority_code, v_psm.problem_type, v_psm.problem_status, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN screlationm1 screlationm1 ON v_psm.numberprgn = screlationm1.depend';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN incidentsm1 incidentsm1 ON incidentsm1.incident_id = screlationm1.source';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON v_psm.closed_by = operatorm1v.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v_1 ON incidentsm1.closed_by = operatorm1v_1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1_problem_assignee ON v_psm.assignee_name = operatorm1_problem_assignee.name';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.open_group', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.product_type', pproduct) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.location', plocation) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.country', pcountry) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        IF (popenorclosed = 'Closed')
        THEN
            v_whereclause := ' AND v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''' ;
        ELSIF (popenorclosed = 'Resolved')
        THEN
            v_whereclause := ' AND v_psm.resolve_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.resolve_time < ' || '''' || v_gmt_enddate || '''' ;
        ELSIF (popenorclosed = 'Open')
        THEN
            v_whereclause := ' AND v_psm.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.open_time < ' || '''' || v_gmt_enddate || '''' ;
        ELSE
            v_whereclause := ' AND ((v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || ''')' ;
            v_whereclause := v_whereclause || 'OR (v_psm.flag = ' || '''' || 't' || '''' || '';
            v_whereclause := v_whereclause || 'AND v_psm.open_time < ' || '''' || v_gmt_enddate || '''))' ; 
        END IF;
        v_select_stmt := v_select_stmt || v_whereclause ;
        
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc_prd;

-- NEW31_Resolved Ticket Report by Related ProjectDivisionSpecailFlag
--              Created bisp_select_inc_spflg 
   PROCEDURE bisp_select_inc_spflg (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2, 
      pdivision           IN       VARCHAR2,
      pspecialflag        IN       VARCHAR2,
      pproject            IN       VARCHAR2,
      popenorclosed       IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_whereclause        VARCHAR2(32767); 
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.PFZ_RELATED_PROJECTS, ';
        v_select_stmt := v_select_stmt || ' v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.contact_phone, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.country, v_psm.dept,v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_charge_code, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_rb_dept, v_psm.pfz_rb_email, v_psm.pfz_rb_location, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_special_project, v_psm.pfz_total_time_spent, v_psm.pfz_vip,v_psm.priority_code, v_psm.problem_type, v_psm.problem_status, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.pfz_special_project,'|| '''' || ' ' || '''' ||') like ' || '''' || pspecialflag || '''' ; 
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(v_psm.pfz_division,'|| '''' || ' ' || '''' ||')', pdivision) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(v_psm.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        IF (popenorclosed = 'Closed')
        THEN
            v_whereclause := ' AND v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''' ;
        ELSE
            v_whereclause := ' AND v_psm.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.open_time < ' || '''' || v_gmt_enddate || '''' ;
        END IF;
        v_select_stmt := v_select_stmt || v_whereclause ;
        
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc_spflg; 
   
-- 05.24.06-shw- 
-- 01.15.08-shw- select resolved parameter 
   PROCEDURE bisp_select_inc_site (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
      plocation           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2,
      vtime               IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT pfzsitesm1.description, v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.country, v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN PFZSITESM1 pfzsitesm1 ON v_psm.pfz_site_id = pfzsitesm1.site_id ';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.open_group', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.location', plocation) || ')';
                IF vtime = 'Closed' 
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND v_psm.flag = ' || '''' || 'f' || '''' || ''; 
        Else
        v_select_stmt := v_select_stmt || ' AND v_psm.resolve_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.resolve_time < ' || '''' || v_gmt_enddate || '''' ;
        End If;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc_site;
   
-- 05.24.06-shw- NEW28 
-- 12.05.06-shw- added Project & Division params for J&J Transition (PCH) 
-- 01.15.08-shw- select resolved parameter 
   PROCEDURE bisp_select_inc_divprj (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
      plocation           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      pproject            IN       VARCHAR2,
      pdivision           IN       VARCHAR2,
      vinteraction_type   IN       VARCHAR2,
      vtime               IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT pfzsitesm1.description, v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.category,v_psm.commodity,v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.country, v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, v_psm.PFZ_RELATED_PROJECTS, v_psm.PFZ_DIVISION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN PFZSITESM1 pfzsitesm1 ON v_psm.pfz_site_id = pfzsitesm1.site_id ';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.open_group', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.location', plocation) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(v_psm.PFZ_DIVISION,'|| '''' || ' ' || '''' ||')', pdivision) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(v_psm.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';        
                IF vtime = 'Closed' 
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND v_psm.flag = ' || '''' || 'f' || '''' || ''; 
        Else
        v_select_stmt := v_select_stmt || ' AND v_psm.resolve_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.resolve_time < ' || '''' || v_gmt_enddate || '''' ;
        End If;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc_divprj;

   PROCEDURE bisp_select_prb (
      select_prb_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      plocation           IN       VARCHAR2,
      pcallorigin         IN       VARCHAR2,
      pcontactname        IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT assignmenta1.name, operatorm1v.full_name,v_pb.assignment, v_pb.action, v_pb.assignee_name, v_pb.brief_description, v_pb.category, v_pb.closed_by, v_pb.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_pb.country, v_pb.deadline_alert_flag, v_pb.flag, v_pb.groupprgn, v_pb.last_activity, v_pb.location, v_pb.numberprgn, v_pb.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_pb.opened_by, v_pb.call_origin, v_pb.contact_name, v_pb.page, v_pb.pfz_sla_title, v_pb.pfz_total_time_spent, v_pb.priority_code, v_pb.problem_type, v_pb.problem_status, v_pb.product_type, v_pb.resolution_code, v_pb.resolution, v_pb.status,  v_pb.time_spent, v_pb.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_pb.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_pb.category,v_pb.resolved_by,  BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBLEMS v_pb';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN assignmenta1 assignmenta1 ON v_pb.updated_by = assignmenta1.operators';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON v_pb.updated_by = operatorm1v.name';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_pb.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_pb.location', plocation) || ')';
--    08.02.06-shw-    v_select_stmt := v_select_stmt || ' AND ((v_pb.status = ' || '''' || 'open' || '''' || 'AND v_pb.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_pb.open_time < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND ((v_pb.status in (' || '''' || 'open'|| '''' || ','|| '''' || 'work in progress'|| '''' ||','|| '''' || 'restored' || '''' || ') AND v_pb.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_pb.open_time < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' OR (v_pb.status = ' || '''' || 'closed' || '''' || 'AND v_pb.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_pb.close_time < ' || '''' || v_gmt_enddate || '''))' ;
        v_select_stmt := v_select_stmt || ' AND (v_pb.call_origin is null';
        v_select_stmt := v_select_stmt || ' OR (' || Bipkg_Utils.BIFNC_createinlist ('v_pb.call_origin', pcallorigin) || '))';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_pb.contact_name', pcontactname) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_pb.category, '' '')', vinteraction_type)|| ')';
      OPEN select_prb_cursor FOR v_select_stmt ;
   END bisp_select_prb;

-- 05.26.06-shw- sproc for "Tickets Handled and Closed" 'Handled' tickets by Assignment/Assignee    
   PROCEDURE bisp_select_hndld (
      select_prb_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2(32767); 
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT assignmenta1.name, operatorm1v.full_name,v_pb.assignment, v_pb.action, v_pb.assignee_name, v_pb.brief_description, v_psm.category, v_pb.closed_by, v_pb.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_pb.country, v_pb.deadline_alert_flag, v_pb.flag, v_pb.groupprgn, v_pb.last_activity, v_pb.location, v_pb.numberprgn, v_pb.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_pb.opened_by, v_pb.call_origin, v_pb.contact_name, v_pb.page, v_pb.pfz_sla_title, v_pb.pfz_total_time_spent, v_pb.priority_code, v_pb.problem_type, v_pb.problem_status, v_pb.product_type, v_pb.resolution_code, v_pb.resolution, v_pb.status,  v_pb.time_spent, v_pb.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_pb.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBLEMS v_pb';
        v_select_stmt := v_select_stmt || ' INNER JOIN SC.V_PROBSUMMARY v_psm ON v_pb.numberprgn = v_psm.numberprgn';
        v_select_stmt := v_select_stmt || ' AND v_pb.assignment = v_psm.assignment';
        v_select_stmt := v_select_stmt || ' INNER JOIN assignmenta1 assignmenta1 ON v_pb.updated_by = assignmenta1.operators';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON v_pb.updated_by = operatorm1v.name';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_pb.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_pb.updated_by', panalyst) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        v_select_stmt := v_select_stmt || ' AND ((v_pb.update_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_pb.update_time < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' OR (v_pb.page = ' || '''' || '1' || '''' || 'AND v_pb.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_pb.open_time < ' || '''' || v_gmt_enddate || '''))' ;
      OPEN select_prb_cursor FOR v_select_stmt ;
   END bisp_select_hndld;
   
-- 11.01.06-shw- sproc for 'tickets in queue' by Assignment/Assignee    
   PROCEDURE bisp_select_in_queue (
      select_inq_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2(32767); 
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT assignmenta1.name, operatorm1v.full_name,v_pb.assignment, v_pb.action, v_pb.assignee_name, v_pb.brief_description, v_pb.category, v_pb.closed_by, v_pb.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_pb.country, v_pb.deadline_alert_flag, v_pb.flag, v_pb.groupprgn, v_pb.last_activity, v_pb.location, v_pb.numberprgn, v_pb.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_pb.opened_by, v_pb.call_origin, v_pb.contact_name, v_pb.page, v_pb.pfz_sla_title, v_pb.pfz_total_time_spent, v_pb.priority_code, v_pb.problem_type, v_pb.problem_status, v_pb.product_type, v_pb.resolution_code, v_pb.resolution, v_pb.status,  v_pb.time_spent, v_pb.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_pb.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_pb.category,v_pb.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBLEMS v_pb';
        v_select_stmt := v_select_stmt || ' INNER JOIN assignmenta1 assignmenta1 ON v_pb.updated_by = assignmenta1.operators';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON v_pb.updated_by = operatorm1v.name';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_pb.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_pb.updated_by', panalyst) || ')';
        v_select_stmt := v_select_stmt || ' AND ((v_pb.update_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_pb.update_time < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' OR (v_pb.page = ' || '''' || '1' || '''' || 'AND v_pb.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_pb.open_time < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' OR v_pb.flag = ' || '''' || 'f' || '''' || ')'; 
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_pb.category, '' '')', vinteraction_type)|| ')';
      OPEN select_inq_cursor FOR v_select_stmt ;
   END bisp_select_in_queue;

-- 07.11.06-shw- sproc for closed tickets by Assignment/Assignee    
   PROCEDURE bisp_select_closed (
      select_closed_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT operatorm1v.full_name, v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.country, v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON v_psm.closed_by = operatorm1v.name';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.closed_by', panalyst) || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND v_psm.flag = ' || '''' || 'f' || '''' || ''; 
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      OPEN select_closed_cursor FOR v_select_stmt ;
   END bisp_select_closed;
   
   PROCEDURE bisp_select_resolved (
      select_resolved_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT operatorm1v.full_name, v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.country, v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON v_psm.resolved_by = operatorm1v.name';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.resolved_by', panalyst) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        v_select_stmt := v_select_stmt || ' AND (v_psm.resolve_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.resolve_time < ' || '''' || v_gmt_enddate || ''')' ;
--  can be open or closed, as long as it's resolved      v_select_stmt := v_select_stmt || ' AND v_psm.flag = ' || '''' || 'f' || '''' || ''; 
      OPEN select_resolved_cursor FOR v_select_stmt ;
   END bisp_select_resolved;
   
    
--           10.16.06         -shw-           1. created bisp_select_closed_respond for SLA Compliance Trending report. 
-- 01.15.08-shw- select resolved parameter 
   PROCEDURE bisp_select_closed_respond (
      select_closed_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2,
      vtime               IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT operatorm1v.full_name, v_psm.assignment, v_psm.action, v_psm.assignee_name, v_psm.brief_description, v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.country, v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_resolve_sla, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla, v_psm.pfz_sla_title, v_psm.pfz_total_time_spent, v_psm.priority_code, v_psm.problem_type, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.status, v_psm.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_psm.category,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON v_psm.closed_by = operatorm1v.name';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.pfz_respond_sla_group', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.closed_by', panalyst) || ')';
                IF vtime = 'Closed' 
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND v_psm.flag = ' || '''' || 'f' || '''' || ''; 
        Else
        v_select_stmt := v_select_stmt || ' AND v_psm.resolve_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.resolve_time < ' || '''' || v_gmt_enddate || '''' ;
        End If;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      OPEN select_closed_cursor FOR v_select_stmt ;
   END bisp_select_closed_respond;

-- 05.30.06-shw- sproc for 'assigned' tickets by Assignee    
   PROCEDURE bisp_select_assigned (
      select_prb_cursor   IN OUT   bisp_refcursor_type,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.assignee_name, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_psm.flag, v_psm.numberprgn, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_psm.category,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignee_name', panalyst) || ')';
        v_select_stmt := v_select_stmt || ' AND ((v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.open_time < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' OR (v_psm.flag = ' || '''' || 't' || '''' || 'AND v_psm.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.open_time < ' || '''' || v_gmt_enddate || '''))' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      OPEN select_prb_cursor FOR v_select_stmt ;
   END bisp_select_assigned;

   PROCEDURE bisp_select_inc_by_parm(
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignment         IN       VARCHAR2,
      popen_group         IN       VARCHAR2,
      pgroup_by           IN       VARCHAR2, -- The field to group by
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   IS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_db_zone            VARCHAR2(10);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_groupby_field      VARCHAR2(15);
      vsql                 VARCHAR2 (32767);
      vfrom_clause         VARCHAR2(500);
   BEGIN
--       bisp_create_basic_probsumsql(vsql, vfrom_clause, v_gmt_startdate, v_gmt_enddate, pfrequency, poverride, pzone, pstartdate,penddate);
--       vsql := vsql||', assignment, product_type, country, pfz_total_time_spent, pfz_bu, open_group ';
--       vsql := vsql||vfrom_clause;
      v_db_zone := 'GMT';
      Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
      v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
       v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
      CASE
         WHEN UPPER(pgroup_by) = 'COUNTRY' THEN v_groupby_field := 'country';
         WHEN UPPER(pgroup_by) = 'DIVISION' THEN v_groupby_field := 'pfz_bu';
         WHEN UPPER(pgroup_by) = 'PRODUCT' THEN v_groupby_field := 'product_type';
      END CASE;
      vsql := 'SELECT COUNT(numberprgn), sum(pfz_total_time_spent), assignment, nvl('||v_groupby_field||','||''''||' '||''') group_by'
           ||','
           ||'''' || v_startdatedisplay || ''''||' StartDateDisplay , ' 
           ||'''' || v_enddatedisplay || '''' || ' EndDateDisplay'
           ||' FROM SC.V_PROBSUMMARY v_psm'
           ||' WHERE ('||Bipkg_Utils.BIFNC_createinlist('assignment', passignment)||')'
           ||'   AND ('||Bipkg_Utils.BIFNC_createinlist('open_group', popen_group)||')'
           ||'   AND ('|| Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')'
           ||'   AND close_time BETWEEN TO_DATE('||''''||TO_CHAR(v_gmt_startdate, 'DD-MON-YYYY HH24:MI:SS')
                     ||''''||','||''''||'DD-MON-YYYY HH24:MI:SS'||''''||') AND '
                     ||' TO_DATE('||''''||TO_CHAR(v_gmt_enddate, 'DD-MON-YYYY HH24:MI:SS')
                     ||''''||','||''''||'DD-MON-YYYY HH24:MI:SS'||''''||')'
           ||' GROUP BY assignment, nvl('||v_groupby_field||','||''''||' '||''')'||','||'''' || v_startdatedisplay || '''' ||','
           ||'''' || v_enddatedisplay|| ''''
           ||' ORDER BY assignment, nvl('||v_groupby_field||','||''''||' '||''')';
      OPEN select_inc_cursor FOR vsql;
   END bisp_select_inc_by_parm;

-- 02.19.07                       -sg-      sproc for Operator Analysis

   PROCEDURE bisp_operator_analysis (
      operator_analysis_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2(32767); 
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT assignmenta1.name, operatorm1v.full_name,v_pb.assignment, v_pb.action, v_pb.assignee_name, v_pb.brief_description, v_pb.category, v_pb.closed_by, v_pb.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, v_pb.country, v_pb.deadline_alert_flag, v_pb.flag, v_pb.groupprgn, v_pb.last_activity, v_pb.location, v_pb.numberprgn, v_pb.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_pb.opened_by, v_pb.call_origin, v_pb.contact_name, v_pb.page, v_pb.pfz_sla_title, v_pb.pfz_total_time_spent, v_pb.priority_code, v_pb.problem_type, v_pb.problem_status, v_pb.product_type, v_pb.resolution_code, v_pb.resolution, v_pb.status,  v_pb.time_spent, v_pb.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_pb.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,'
        || ' v_pb.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,v_psm.resolved_by, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time'
        || ' FROM SC.V_PROBLEMS v_pb'
        || ' INNER JOIN SC.V_PROBSUMMARY v_psm ON v_pb.numberprgn = v_psm.numberprgn'
        || ' INNER JOIN assignmenta1 assignmenta1 ON v_pb.updated_by = assignmenta1.operators'
        || ' LEFT OUTER JOIN operatorm1v operatorm1v ON v_pb.updated_by = operatorm1v.name'
        || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('NVL(assignmenta1.name, '' '')', passignmentgroup) || ')'
        || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(assignmenta1.operators, '' '')', panalyst) || ')'
        || ' AND v_pb.update_time between ''' || v_gmt_startdate || ''' AND ''' || v_gmt_enddate || ''''
        || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_pb.category, '' '')', vinteraction_type)|| ')';

      OPEN operator_analysis_cursor FOR v_select_stmt ;
      
   END bisp_operator_analysis;

END Bipkg_GvR_Incidents;
/

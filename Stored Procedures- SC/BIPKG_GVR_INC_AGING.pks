CREATE OR REPLACE PACKAGE BIPKG_GVR_INC_AGING AS
   TYPE bisp_refcursor_type IS REF CURSOR;

/******************************************************************************
   NAME:       bipkg_inc_aging
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------


    -- sg 18-JUL-2006 created procedure for Aging Ticket Summary and Detail Report
	1.0	  	04-Aug-2006		  ShW		Create sproc for Outstanding GT x days Old
    2.0           10.26.07        shw            1. Upgrade for GAMPS
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s)
    3.0         01.09.08    shw         4. Allow Resolved Exclusion
    4.0          11.25.08   YERRAV      5.Contactsm1 table and company field are added
                                                in bisp_inc_aging procedure
   
******************************************************************************/

   PROCEDURE bisp_inc_aging (
      inc_aging_cursor   IN OUT   bisp_refcursor_type,
      passigngroup          IN          VARCHAR2,
      ppriority             IN          VARCHAR2,
      pzone                 IN          VARCHAR2,
      vinteraction_type     IN          VARCHAR2,
      Excl_Resolve          IN          VARCHAR2
   );

-- Used for the "Outstanding Tickets GT x Days Old Report(s)
   PROCEDURE bisp_aging_gt (
      inc_aging_cursor   IN OUT   bisp_refcursor_type,
      passigngroup          IN          VARCHAR2,
      porigingroup          IN          VARCHAR2,
      ppriority             IN          VARCHAR2,
      plocation             IN          VARCHAR2,
      pdivision             IN          VARCHAR2,
      pzone                 IN          VARCHAR2,
      vinteraction_type     IN          VARCHAR2,
      Excl_Resolve          IN          VARCHAR2
   );
END BIPKG_GVR_INC_AGING;
/
CREATE OR REPLACE PACKAGE BODY Bipkg_GVr_Inc_Aging
AS
/******************************************************************************
   NAME:       bipkg_inc_aging
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------


    -- sg 18-JUL-2006 created procedure for Aging Ticket Summary and Detail Report
    1.0          04-Aug-2006          ShW        Create sproc for Outstanding GT x days Old
    2.0           10.26.07        shw            1. Upgrade for GAMPS
    3.0     08-Jan-2008     shw         2. Add Excl_Resolve parameter
    4.0          11.25.08   YERRAV      3.Contactsm1 table and company field are added
                                            in bisp_inc_aging Procedure
******************************************************************************/

-- Used for the "Aging Ticket Summary and Detail Report"
--    3.0     08-Jan-2008     shw         2. Add Vtime (exclude Resolved) parameter
--    4.0          11.25.08   YERRAV      3.Contactsm1 table and company field are added                  
   PROCEDURE bisp_inc_aging (
      inc_aging_cursor   IN OUT   bisp_refcursor_type,
      passigngroup       IN       VARCHAR2,
      ppriority          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      vinteraction_type  IN       VARCHAR2,
      Excl_Resolve       IN       VARCHAR2

   )
   IS
      v_db_zone               VARCHAR2 (3);
      v_currentdate           VARCHAR2 (150);
      v_select_stmt           VARCHAR2 (32767);
      v_gmt_enddate           DATE;
   BEGIN
      v_db_zone := 'GMT';
      v_currentdate       :=    'to_date(''' || TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (SYSDATE, 'EST', pzone),'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';
        bipkg_utils.bisp_getStartAndEndDates('daily', -1, pzone, SYSDATE, SYSDATE, v_gmt_enddate, v_gmt_enddate);
      v_select_stmt :=
      'SELECT'
      || ' v_psm.assignment,'
      || ' v_psm.flag,'
      || ' v_psm.numberprgn,'
      || ' v_psm.deadline,'
      || ' v_psm.pfz_sla_title,'
      || ' v_psm.pfz_full_name,'
      || ' v_psm.assignee_name,'
      || ' v_psm.status,'
      || ' v_psm.product_type,'
      || 'con.company,'
      || ' v_psm.location,'
      || ' v_psm.brief_description,'
      || ' v_psm.countprgn,'
      || ' bipkg_utils.bifnc_adjustfortz(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time,'
      || ' bipkg_utils.bifnc_adjustfortz(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,'
      || ' bipkg_utils.bifnc_adjustfortz(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time,'
      || v_currentdate || ' currentdatetime,'
      || ' v_psm.category,'
      || ' v_psm.priority'
      || ' FROM'
      || ' sc.v_probsummary v_psm,sc.contactsm1 con'
--      || ' inner join probsummarym2 on probsummarym1.numberprgn = probsummarym2.numberprgn'
      || ' WHERE v_psm.contact_name = con.contact_name(+) and'
      || ' v_psm.flag = ''t''';
      If Excl_Resolve = 'Y'
      Then
-- only include if resolve_time is NULL
        v_select_stmt := v_select_stmt || ' AND (NVL(v_psm.resolve_time,'||'''' || SYSDATE || '''' || ') = '||'''' || SYSDATE || '''' || ')' ;
      Else
        v_select_stmt := v_select_stmt || '';

      End If;

      v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('v_psm.priority', ppriority) || ')'
-- v. 2.0 GAMPS       || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', ppriority) || ')'
      || ' AND (' || Bipkg_Utils.bifnc_createinlist ('v_psm.assignment', passigngroup) || ')'
      || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')'
      ;

      OPEN inc_aging_cursor FOR v_select_stmt;

   END bisp_inc_aging;


-- Used for the "Outstanding Tickets GT x Days Old Report"
--    3.0     08-Jan-2008     shw         2. Add Vtime (exclude Resolved) parameter
   PROCEDURE bisp_aging_gt (
      inc_aging_cursor   IN OUT   bisp_refcursor_type,
      passigngroup         IN          VARCHAR2,
      porigingroup         IN          VARCHAR2,
      ppriority            IN          VARCHAR2,
      plocation            IN          VARCHAR2,
      pdivision            IN          VARCHAR2,
      pzone                IN          VARCHAR2,
      vinteraction_type    IN          VARCHAR2,
      Excl_Resolve         IN          VARCHAR2
   )
   IS
      v_db_zone               VARCHAR2 (3);
      v_currentdate           VARCHAR2 (150);
      v_select_stmt           VARCHAR2 (32767);
      v_gmt_enddate           DATE;
   BEGIN
      v_db_zone := 'GMT';
      v_currentdate       :=    'to_date(''' || TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (SYSDATE, 'EST', pzone),'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';
      bipkg_utils.bisp_getStartAndEndDates('daily', -1, pzone, SYSDATE, SYSDATE, v_gmt_enddate, v_gmt_enddate);
      v_select_stmt :=
      'select'
      || ' v_psm.assignment,'
      || ' v_psm.flag,'
      || ' v_psm.numberprgn,'
      || ' v_psm.deadline,'
      || ' v_psm.pfz_sla_title,'
      || ' v_psm.pfz_full_name,'
      || ' v_psm.pfz_bu,'
      || ' v_psm.pfz_division,'
      || ' v_psm.pfz_site_id,'
      || ' v_psm.problem_status,'
      || ' v_psm.assignee_name,'
      || ' v_psm.status,'
      || ' v_psm.product_type,'
      || ' v_psm.location,'
      || ' v_psm.priority_code,'
      || ' v_psm.brief_description,'
      || ' v_psm.countprgn,'
      || ' v_psm.groupprgn,'
      || ' v_psm.open_group,'
      || ' v_psm.update_action,'
      || ' v_psm.last_activity,'
      || ' bipkg_utils.bifnc_adjustfortz(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time,'
      || ' bipkg_utils.bifnc_adjustfortz(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,'
      || ' bipkg_utils.bifnc_adjustfortz(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time,'
      || v_currentdate || ' currentdatetime,'
      || ' v_psm.category,'
      || ' v_psm.priority'
      || ' from'
      || ' sc.v_probsummary v_psm'
--      || ' inner join probsummarym2 on probsummarym1.numberprgn = probsummarym2.numberprgn'
      || ' WHERE'
      || ' v_psm.flag = ''t''';
      If Excl_Resolve = 'Y'
      Then
-- only include if resolve_time is NULL
        v_select_stmt := v_select_stmt || ' AND (NVL(v_psm.resolve_time,'||'''' || SYSDATE || '''' || ') = '||'''' || SYSDATE || '''' || ')' ;
      Else
        v_select_stmt := v_select_stmt || '';

      End If;

      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.priority', ppriority) || ')'
-- v. 2.0 GAMPS       || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_sla_title', ppriority) || ')'
      || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.location', plocation) || ')'
      || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_division', pdivision) || ')'
      || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.assignment', passigngroup) || ')'
      || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', porigingroup) || ')'
      || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')'
      ;

      OPEN inc_aging_cursor FOR v_select_stmt;

   END bisp_aging_gt;

END Bipkg_GVr_Inc_Aging;
/

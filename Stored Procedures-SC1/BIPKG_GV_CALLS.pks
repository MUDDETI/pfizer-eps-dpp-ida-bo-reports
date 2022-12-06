CREATE OR REPLACE PACKAGE BIPKG_Gv_CALLS AS
/******************************************************************************
   NAME:       bisp_select_calls
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
    1.0		   05/25/2006 		-SG-		   1. Created bisp_select_calls
	1.0		   10.17.06			-shw-		   1. Open Calls Location - Tickets Opend by Hour Graph
    2.0         10.18.07            -shw-   1. Upgrade for GAMPS
    2.2         11.18.07            -shw-   3. Upgrade to view vs. table(s)
    2.3         12.14.07            -shw-   3.1 fix name changes for GAMP
    2.4         02.06.08            -shw-   4. fix FCR sproc
    2.5         08.25.08            -shw-   5. added PFZ_RB_FULL_NAME to BISP_FCR 
******************************************************************************/
   TYPE bisp_refcursor_type IS REF CURSOR;

   PROCEDURE bisp_select_calls_closed (
      select_calls_closed_cursor  IN OUT   bisp_refcursor_type,
      porig_group        IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
    vinteraction_type    IN       VARCHAR2
   );
-- 06.21.06-shw- Open Calls - for Product Trending by Type report
   PROCEDURE bisp_select_opn_calls (
      select_opn_calls_cursor  IN OUT   bisp_refcursor_type,
      porig_group        IN       VARCHAR2,
      pproduct           IN       VARCHAR2,
      pdept              IN       VARCHAR2,
      pbu                IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
    vinteraction_type    IN       VARCHAR2
   );
-- 10.17.06-shw- Open Calls Location- Tickets Opend by Hour Graph
   PROCEDURE bisp_select_opn_calls_location (
      select_opn_calls_cursor  IN OUT   bisp_refcursor_type,
      porig_group        IN       VARCHAR2,
      plocation          IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
    vinteraction_type    IN       VARCHAR2
   );

   -- SRR May-26-2006 Added procedure for FCR.
   PROCEDURE bisp_select_FCR( --vsql OUT VARCHAR2,
      select_fcr_cursor  IN OUT   bisp_refcursor_type,
      porig_group        IN       VARCHAR2,
      plocation          IN       VARCHAR2,
      psource            IN       VARCHAR2,
      pcontact           IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      ptype              IN       VARCHAR2,
    vinteraction_type    IN       VARCHAR2
   );

   -- ShW Jul-06-2006 Added procedure for opn/clsd by sp.flag
-- NEW31_Resolved Ticket Report by Related ProjectDivisionSpecailFlag
--              Created bisp_select_calls_spflg
   PROCEDURE bisp_select_calls_spflg(
      select_spflg_cursor  IN OUT   bisp_refcursor_type,
      porig_group        IN       VARCHAR2,
      pdivision          IN       VARCHAR2,
      pspecialflag       IN       VARCHAR2,
      pproject           IN       VARCHAR2,
      popenorclosed      IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
    vinteraction_type    IN       VARCHAR2
   );

   -- sg 22-jun-2006 created procedure for fcr report
   procedure bisp_fcr (
      fcr_cursor      in out   bisp_refcursor_type,
      porig_group        in       varchar2,
      pproduct           in       varchar2,
      plocation          in       varchar2,
      psource            in       varchar2,
      pcontact           in       varchar2,
      pfrequency         in       varchar2,
      poverride          in       varchar2,
      pzone              in       varchar2,
      pstartdate         in       date,
      penddate           in       date,
    vinteraction_type    IN       VARCHAR2
   );


   -- RMakkena 19-OCT-2006 created procedure for Web Call Analysis Report.
   procedure BISP_WEBCALLS_ANALYSIS (
      select_opn_calls_cursor  IN OUT   bisp_refcursor_type,
      porig_group        in       varchar2,
      pfrequency         in       varchar2,
      poverride          in       varchar2,
      pzone              in       varchar2,
      pstartdate         in       date,
      penddate           in       date,
	vinteraction_type	 IN		  VARCHAR2
   );
END BIPKG_Gv_CALLS;
/
CREATE OR REPLACE PACKAGE BODY Bipkg_Gv_Calls
AS
/******************************************************************************
   NAME:       bisp_select_calls
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
    1.0           05/25/2006         -SG-           1. Created bisp_select_calls
    1.0           10.17.06            -shw-           1. Open Calls Location - Tickets Opend by Hour Graph
    2.0         10.18.07            -shw-   1. Upgrade for GAMPS
    2.2         11.18.07            -shw-   3. Upgrade to view vs. table(s)
    2.3         12.14.07            -shw-   3.1 fix name changes for GAMP
    2.4         02.06.08            -shw-   4. fix FCR sproc
    2.5         08.25.08            -shw-   5. added PFZ_RB_FULL_NAME to BISP_FCR 
******************************************************************************/
--
-- Error Handling is done by the report. We do not trap any exceptions at the Database side.
--
   PROCEDURE bisp_select_calls_closed (
      select_calls_closed_cursor IN OUT   bisp_refcursor_type,
      porig_group         IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
    vinteraction_type     IN       VARCHAR2
   )
   IS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone               VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');

        v_select_stmt := 'SELECT INCIDENT_ID, PROBLEM_ID, CONTACT_NAME, ' ||
        'SEVERITY, OPEN_TIME, UPDATE_TIME, OPENED_BY, UPDATED_BY, DESCRIPTION, ' ||
        'AFFECTED_ITEM, OWNER_NAME, OPEN, CALLBACK_TYPE, CALLBACK_REASON, NULLPRGN, ' ||
           'RESOLUTION, UNASSIGNED, CATEGORY, HANDLE_TIME, MODEL, TYPE, ' ||
           'DEPT, LOCATION, CLOSE_TIME, CLOSED_BY, SOLUTION_CANDIDATE, AGREEMENT_ID, ' ||
           'PRIORITY_CODE, FIRST_CALL, CONTRACT_ID, CONTRACT_CONSUMED, WORKED_TIME, SYSMODCOUNT, ' ||
           'SYSMODUSER, SYSMODTIME, KPF_ID, PAYROLL_NO, CRITICAL_USER, ROOM, ' ||
           'USER_TYPE, SITE_CATEGORY, TOTAL_LOSS, TEMP_UPDATE, SUBCATEGORY, PRODUCT_TYPE, ' ||
           'PROBLEM_TYPE, FAILED_ENTITLEMENT, COST_CENTRE, CONTACT_LOCATION, PHONE, EXTENSION, ' ||
           'CRITICAL_DEVICE, CAUSE_CODE, RESOLUTION_CODE, COMPANY, COMPANY_ID, VENDOR, ' ||
           'CLASS, COUNTRY, ALTERNATE_CONTACT, ENGINEER, DIFFERENT_FROM_CONTACT, ALTERNATE_PHONE, ' ||
           'ALTERNATE_EXTENSION, CUSTOMER_REFERENCE, FAX, ALTERNATE_FAX, PENDING_CHANGE, ' ||
           'MANDATORY_ASSET, FLOOR, BUILDING, VARIABLE1, VARIABLE2, VARIABLE3,  PFZ_IMPACT, ' ||
   		   'PFZ_PRODUCT_SUBTYPE,PFZ_RB_COUNTRY,PFZ_ESC_ASSIGNMENT, CONTACT_EMAIL, LOCATION_FULL_NAME, ' ||
           'CONTACT_FIRST, CONTACT_LAST, BILLTO, BILLTYPE, GL_NUMBER, ENTITLEMENT_REF, PFZ_RELATED_PROJECTS, '  ||
           'PFZ_VALIDATED, PFZ_RELATED, PFZ_RB_FULL_NAME, PFZ_RB_PHONE, PFZ_RB_LOCATION, PFZ_RB_ROOM, ' ||
           'PFZ_RB_EMAIL, PFZ_RB_CHARGE_CODE, PFZ_RB_OFFICE_TYPE, PFZ_RB_DEPT, PFZ_RB_LOC_TIME, PFZ_RB_SPECIAL, ' ||
           'PFZ_VIP, PFZ_ORIG_GROUP, PFZ_RB_NAME, PFZ_CALL_SOURCE, PFZ_SLA_TITLE, PFZ_SITE_ID, ' ||
           'EMAIL, PFZ_SPECIAL_PROJECT, PFZ_LOC_TIME, PFZ_OFFICE_TYPE, PFZ_CHARGE_CODE, PFZ_FULL_NAME, ' ||
           'PFZ_BU, PFZ_CATSUBPROD, DATE_ACK, DATE_REC, BRIEF_DESCRIPTION, PFZ_RB_VALIDATED, ' ||
           'PFZ_ASSET_VALIDATED, PFZ_RB_BU, PFZ_RB_BUILDING, PFZ_NOTIFY, PFZ_VERSION, PFZ_DIVISION, ' ||
           'PFZ_RB_DIVISION, PFZ_ACTION, PFZ_NOTIFY_METHOD, PFZ_BUSINESS_GROUP, PFZ_SAVE_COUNT, COMMODITY, ' ||
           'SCHEMA, ECCMA_ID, PFZ_RB_FLOOR, PFZ_EMAIL_RESOLUTION, PFZ_KNOWLIX_URL, PFZ_PHARMACIA_ISSUE, ' ||
           'PFZ_CGMP, UNUSED_FIELD, NETWORK_NAME, PFZ_NT_ID, PFZ_RB_NT_ID, ' ||
           '''' || v_startdatedisplay || '''' || ' StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay, CATEGORY' ||
           ' FROM incidentsm1 incidentsm1' ||
           ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('incidentsm1.pfz_orig_group', porig_group) || ')' ||
           ' AND incidentsm1.close_time >= ' || '''' || v_gmt_startdate || '''' ||
           ' AND incidentsm1.close_time < ' || '''' || v_gmt_enddate || '''' ||
        ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(incidentsm1.category, '' '')', vinteraction_type)|| ')';

      OPEN select_calls_closed_cursor FOR v_select_stmt ;
   END bisp_select_calls_closed;

-- 06.21.06-shw- Open Calls - for Product Trending by Type report
   PROCEDURE bisp_select_opn_calls (
      select_opn_calls_cursor IN OUT   bisp_refcursor_type,
      porig_group         IN       VARCHAR2,
      pproduct            IN       VARCHAR2,
      pdept               IN       VARCHAR2,
      pbu                 IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
    vinteraction_type     IN       VARCHAR2
   )
   IS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_date_range         VARCHAR2 (124);
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_date_range         := 'to_date(''' || TO_CHAR(v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'') and to_date(''' || TO_CHAR(v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';

        v_select_stmt := 'SELECT INCIDENT_ID, PROBLEM_ID, CONTACT_NAME, ' ||
        'SEVERITY, OPEN_TIME, UPDATE_TIME, OPENED_BY, UPDATED_BY, DESCRIPTION, ' ||
        'AFFECTED_ITEM, OWNER_NAME, OPEN, CALLBACK_TYPE, CALLBACK_REASON, NULLPRGN, ' ||
           'RESOLUTION, UNASSIGNED, CATEGORY, HANDLE_TIME, MODEL, TYPE, ' ||
           'DEPT, LOCATION, CLOSE_TIME, CLOSED_BY, SOLUTION_CANDIDATE, AGREEMENT_ID, ' ||
           'PRIORITY_CODE, FIRST_CALL, CONTRACT_ID, CONTRACT_CONSUMED, WORKED_TIME, SYSMODCOUNT, ' ||
           'SYSMODUSER, SYSMODTIME, KPF_ID, PAYROLL_NO, CRITICAL_USER, ROOM, ' ||
           'USER_TYPE, SITE_CATEGORY, TOTAL_LOSS, TEMP_UPDATE, SUBCATEGORY, PRODUCT_TYPE, ' ||
           'PROBLEM_TYPE, FAILED_ENTITLEMENT, COST_CENTRE, CONTACT_LOCATION, PHONE, EXTENSION, ' ||
           'CRITICAL_DEVICE, CAUSE_CODE, RESOLUTION_CODE, COMPANY, COMPANY_ID, VENDOR, ' ||
           'CLASS, COUNTRY, ALTERNATE_CONTACT, ENGINEER, DIFFERENT_FROM_CONTACT, ALTERNATE_PHONE, ' ||
           'ALTERNATE_EXTENSION, CUSTOMER_REFERENCE, FAX, ALTERNATE_FAX, PENDING_CHANGE, ' ||
           'MANDATORY_ASSET, FLOOR, BUILDING, VARIABLE1, VARIABLE2, VARIABLE3,  PFZ_IMPACT, ' ||
   		   'PFZ_PRODUCT_SUBTYPE,PFZ_RB_COUNTRY,PFZ_ESC_ASSIGNMENT, CONTACT_EMAIL, LOCATION_FULL_NAME, ' ||
           'CONTACT_FIRST, CONTACT_LAST, BILLTO, BILLTYPE, GL_NUMBER, ENTITLEMENT_REF, PFZ_RELATED_PROJECTS, '  ||
           'PFZ_VALIDATED, PFZ_RELATED, PFZ_RB_FULL_NAME, PFZ_RB_PHONE, PFZ_RB_LOCATION, PFZ_RB_ROOM, ' ||
           'PFZ_RB_EMAIL, PFZ_RB_CHARGE_CODE, PFZ_RB_OFFICE_TYPE, PFZ_RB_DEPT, PFZ_RB_LOC_TIME, PFZ_RB_SPECIAL, ' ||
           'PFZ_VIP, PFZ_ORIG_GROUP, PFZ_RB_NAME, PFZ_CALL_SOURCE, PFZ_SLA_TITLE, PFZ_SITE_ID, ' ||
           'EMAIL, PFZ_SPECIAL_PROJECT, PFZ_LOC_TIME, PFZ_OFFICE_TYPE, PFZ_CHARGE_CODE, PFZ_FULL_NAME, ' ||
           'PFZ_BU, PFZ_CATSUBPROD, DATE_ACK, DATE_REC, BRIEF_DESCRIPTION, PFZ_RB_VALIDATED, ' ||
           'PFZ_ASSET_VALIDATED, PFZ_RB_BU, PFZ_RB_BUILDING, PFZ_NOTIFY, PFZ_VERSION, PFZ_DIVISION, ' ||
           'PFZ_RB_DIVISION, PFZ_ACTION, PFZ_NOTIFY_METHOD, PFZ_BUSINESS_GROUP, PFZ_SAVE_COUNT, COMMODITY, ' ||
           'SCHEMA, ECCMA_ID, PFZ_RB_FLOOR, PFZ_EMAIL_RESOLUTION, PFZ_KNOWLIX_URL, PFZ_PHARMACIA_ISSUE, ' ||
           'PFZ_CGMP, UNUSED_FIELD, NETWORK_NAME, PFZ_NT_ID, PFZ_RB_NT_ID, ' ||
           '''' || v_startdatedisplay || '''' || ' StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay, CATEGORY' ||
           ' FROM incidentsm1 incidentsm1' ||
           ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('incidentsm1.pfz_orig_group', porig_group) || ')' ||
           ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(incidentsm1.product_type, '' '')', pproduct) || ')' ||
           ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(incidentsm1.dept, '' '')', pdept) || ')' ||
           ' AND NOT(' || Bipkg_Utils.BIFNC_createinlist ('NVL(incidentsm1.pfz_bu, '' '')', pbu) || ')' ||
           ' AND incidentsm1.open_time between ' || v_date_range ||
        ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(incidentsm1.category, '' '')', vinteraction_type)|| ')';
      OPEN select_opn_calls_cursor FOR v_select_stmt ;
   END bisp_select_opn_calls;   --

-- 10.17.06-shw- Open Calls Location - Tickets Opend by Hour Graph
   PROCEDURE bisp_select_opn_calls_location (
      select_opn_calls_cursor IN OUT   bisp_refcursor_type,
      porig_group         IN       VARCHAR2,
      plocation           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
    vinteraction_type     IN       VARCHAR2
   )
   IS
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

        v_select_stmt := 'SELECT INCIDENT_ID, PROBLEM_ID, CONTACT_NAME, ' ||
        'SEVERITY, OPEN_TIME, UPDATE_TIME, OPENED_BY, UPDATED_BY, DESCRIPTION, ' ||
        'AFFECTED_ITEM, OWNER_NAME, OPEN, CALLBACK_TYPE, CALLBACK_REASON, NULLPRGN, ' ||
           'RESOLUTION, UNASSIGNED, CATEGORY, HANDLE_TIME, MODEL, TYPE, ' ||
           'DEPT, LOCATION, CLOSE_TIME, CLOSED_BY, SOLUTION_CANDIDATE, AGREEMENT_ID, ' ||
           'PRIORITY_CODE, FIRST_CALL, CONTRACT_ID, CONTRACT_CONSUMED, WORKED_TIME, SYSMODCOUNT, ' ||
           'SYSMODUSER, SYSMODTIME, KPF_ID, PAYROLL_NO, CRITICAL_USER, ROOM, ' ||
           'USER_TYPE, SITE_CATEGORY, TOTAL_LOSS, TEMP_UPDATE, SUBCATEGORY, PRODUCT_TYPE, ' ||
           'PROBLEM_TYPE, FAILED_ENTITLEMENT, COST_CENTRE, CONTACT_LOCATION, PHONE, EXTENSION, ' ||
           'CRITICAL_DEVICE, CAUSE_CODE, RESOLUTION_CODE, COMPANY, COMPANY_ID, VENDOR, ' ||
           'CLASS, COUNTRY, ALTERNATE_CONTACT, ENGINEER, DIFFERENT_FROM_CONTACT, ALTERNATE_PHONE, ' ||
           'ALTERNATE_EXTENSION, CUSTOMER_REFERENCE, FAX, ALTERNATE_FAX, PENDING_CHANGE, ' ||
           'MANDATORY_ASSET, FLOOR, BUILDING, VARIABLE1, VARIABLE2, VARIABLE3,  PFZ_IMPACT, ' ||
   		   'PFZ_PRODUCT_SUBTYPE,PFZ_RB_COUNTRY,PFZ_ESC_ASSIGNMENT, CONTACT_EMAIL, LOCATION_FULL_NAME, ' ||
           'CONTACT_FIRST, CONTACT_LAST, BILLTO, BILLTYPE, GL_NUMBER, ENTITLEMENT_REF, PFZ_RELATED_PROJECTS, '  ||
           'PFZ_VALIDATED, PFZ_RELATED, PFZ_RB_FULL_NAME, PFZ_RB_PHONE, PFZ_RB_LOCATION, PFZ_RB_ROOM, ' ||
           'PFZ_RB_EMAIL, PFZ_RB_CHARGE_CODE, PFZ_RB_OFFICE_TYPE, PFZ_RB_DEPT, PFZ_RB_LOC_TIME, PFZ_RB_SPECIAL, ' ||
           'PFZ_VIP, PFZ_ORIG_GROUP, PFZ_RB_NAME, PFZ_CALL_SOURCE, PFZ_SLA_TITLE, PFZ_SITE_ID, ' ||
           'EMAIL, PFZ_SPECIAL_PROJECT, PFZ_LOC_TIME, PFZ_OFFICE_TYPE, PFZ_CHARGE_CODE, PFZ_FULL_NAME, ' ||
           'PFZ_BU, PFZ_CATSUBPROD, DATE_ACK, DATE_REC, BRIEF_DESCRIPTION, PFZ_RB_VALIDATED, ' ||
           'PFZ_ASSET_VALIDATED, PFZ_RB_BU, PFZ_RB_BUILDING, PFZ_NOTIFY, PFZ_VERSION, PFZ_DIVISION, ' ||
           'PFZ_RB_DIVISION, PFZ_ACTION, PFZ_NOTIFY_METHOD, PFZ_BUSINESS_GROUP, PFZ_SAVE_COUNT, COMMODITY, ' ||
           'SCHEMA, ECCMA_ID, PFZ_RB_FLOOR, PFZ_EMAIL_RESOLUTION, PFZ_KNOWLIX_URL, PFZ_PHARMACIA_ISSUE, ' ||
           'PFZ_CGMP, UNUSED_FIELD, NETWORK_NAME, PFZ_NT_ID, PFZ_RB_NT_ID, ' ||
           '''' || v_startdatedisplay || '''' || ' StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay, CATEGORY' ||
           ' FROM incidentsm1 incidentsm1' ||
           ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('incidentsm1.pfz_orig_group', porig_group) || ')' ||
           ' AND (' || Bipkg_Utils.BIFNC_createinlist ('incidentsm1.location', plocation) || ')' ||
           ' AND incidentsm1.open_time >= ' || '''' || v_gmt_startdate || '''' ||
           ' AND incidentsm1.open_time < ' || '''' || v_gmt_enddate || '''' ||
        ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(incidentsm1.category, '' '')', vinteraction_type)|| ')';
      OPEN select_opn_calls_cursor FOR v_select_stmt ;
   END bisp_select_opn_calls_location;   --


-- ShW Jul-06-2006 Added procedure for opn/clsd by sp.flag
-- NEW31_Resolved Ticket Report by Related ProjectDivisionSpecailFlag
--              Created bisp_select_calls_spflg
   PROCEDURE bisp_select_calls_spflg (
      select_spflg_cursor  IN OUT   bisp_refcursor_type,
      porig_group        IN          VARCHAR2,
      pdivision          IN          VARCHAR2,
      pspecialflag       IN          VARCHAR2,
      pproject           IN          VARCHAR2,
      popenorclosed      IN          VARCHAR2,
      pfrequency         IN          VARCHAR2,
      poverride          IN          VARCHAR2,
      pzone              IN          VARCHAR2,
      pstartdate         IN          DATE,
      penddate           IN          DATE,
    vinteraction_type    IN          VARCHAR2
   )
   IS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_whereclause        VARCHAR2(1000);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT INCIDENT_ID, OPEN_TIME, CLOSE_TIME, LOCATION, PFZ_ORIG_GROUP, PFZ_RELATED_PROJECTS, ' ||
        'FIRST_CALL, BRIEF_DESCRIPTION, PFZ_DIVISION, PFZ_BU, PFZ_SPECIAL_PROJECT,  ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay, CATEGORY';
           v_select_stmt := v_select_stmt || ' FROM incidentsm1 incidentsm1' ;
           v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('incidentsm1.pfz_orig_group', porig_group) || ')';
           v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(incidentsm1.pfz_division,'|| '''' || ' ' || '''' ||')', pdivision) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(incidentsm1.pfz_related_projects,'|| '''' || ' ' || '''' ||')', pproject) ||')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(incidentsm1.CATEGORY,'|| '''' || ' ' || '''' ||')', vinteraction_type) ||')';
        v_select_stmt := v_select_stmt || ' AND NVL(incidentsm1.pfz_special_project,'|| '''' || ' ' || '''' ||') like ' || '''' || pspecialflag || '''' ;
        IF (popenorclosed = 'Closed')
        THEN
            v_whereclause := ' AND incidentsm1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND incidentsm1.close_time < ' || '''' || v_gmt_enddate || '''' ;
        ELSE
            v_whereclause := ' AND incidentsm1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND incidentsm1.open_time < ' || '''' || v_gmt_enddate || '''' ;
        END IF;
            v_select_stmt := v_select_stmt || v_whereclause ;

  OPEN select_spflg_cursor FOR v_select_stmt ;
   END bisp_select_calls_spflg;


   -- For First Call Resolution (FCR) cases.
   -- By Shrikanth.
   -- This procedure is common for all the groups by analyst, product, and type.
   PROCEDURE bisp_select_FCR(
      --vsql OUT VARCHAR2,
      select_fcr_cursor  IN OUT   bisp_refcursor_type,  -- Ref Cursor for Crystal.
      porig_group        IN          VARCHAR2,             -- Original Group.
      plocation          IN          VARCHAR2,             -- Location.
      psource            IN          VARCHAR2,
      pcontact           IN          VARCHAR2,
      pfrequency         IN          VARCHAR2,
      poverride          IN          VARCHAR2,
      pzone              IN          VARCHAR2,
      pstartdate         IN          DATE,
      penddate           IN          DATE,
      ptype              IN          VARCHAR2,
    vinteraction_type    IN          VARCHAR2
   ) IS
   -- Grouping Types:
   -- PROD : group by product.
   -- GROUP: group by PFZ_Orig_Goup.
   -- NAME : group by opened_by.
   -- ALOCP: group by Analyst, Location and Product.
   -- ALOCR: group by Analyst, Location, and Resolution
   --
   vsql VARCHAR2(2000);
   v_startdatedisplay   VARCHAR2(50);
   v_enddatedisplay     VARCHAR2(50);
   v_gmt_startdate      DATE;
   v_gmt_enddate        DATE;
   v_db_zone            VARCHAR2(10);
   BEGIN
      v_db_zone := 'GMT';
      Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
      v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
      v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
      --
      -- Start of Select clause - this depends on the grouping.
      IF (ptype = 'PROD') -- Group by product type.
      THEN
         vsql := 'SELECT trim(I.PRODUCT_TYPE), ';
      ELSIF (ptype = 'GROUP')-- Group by PFZ_Orig_Goup.
      THEN
         vsql := 'SELECT I.PFZ_ORIG_GROUP, ';
      ELSIF (ptype = 'NAME') -- Group by opened_by.
      THEN
         vsql := 'SELECT I.OPENED_BY, NVL(O.FULL_NAME, '||''''||'('||''''||'||I.OPENED_BY||'||''''||')'||''''||'), ';
         -- If FULL_NAME is null, return OPENED_BY enclosed by brackets.
      ELSIF (ptype = 'ALOCP' OR ptype = 'ALOCR')  -- Analyst specific
      THEN
         vsql := 'SELECT I.OPENED_BY, NVL(O.FULL_NAME, '||''''||'('||''''||'||I.OPENED_BY||'||''''||')'||''''||'), '||
                 'I.LOCATION,';
         IF (ptype = 'ALOCP')
         THEN
            vsql := vsql||'I.PRODUCT_TYPE DFIELD, ';
         ELSE
            vsql := vsql||'I.RESOLUTION_CODE DFIELD,';
         END IF;
      END IF;
      --
      -- Core of the Select clause - this is common to all.
      vsql := vsql||' COUNT(*) NO_OF_CALLS, '|| -- Total Number of calls.
               'SUM(DECODE(I.FIRST_CALL,'||''''||'t'||''''||',1,0)) FC_COUNT, '|| -- total First Resolution calls.
               'SUM(DECODE(I.PFZ_SLA_TITLE, '||''''||'Service Request'||''''||', 0, '||''''||'Project'||''''|| -- Support=
               ', 0, 1)) PROB_TOTALS, '|| -- Count of all records that are NOT Service requests or projects;
               ' SUM(DECODE(DECODE(I.PFZ_SLA_TITLE, '||''''||'Service Request'||''''||', 0, '||''''||'Project'||''''||
               ', 0, 1),1,DECODE(I.FIRST_CALL,'||''''||'t'||''''||',1,0),0)) FC_TOTALS,'||-- Support recs that are first call closures.
               'SUM(DECODE(I.PFZ_SLA_TITLE, '||''''||'Service Request'||''''||', 1, '||''''||'Project'||''''|| -- Request=
               ', 1, 0)) REQ_TOTALS, '|| -- Count of all records that ARE Service requests or projects;
               ' SUM(DECODE(DECODE(I.PFZ_SLA_TITLE, '||''''||'Service Request'||''''||', 1, '||''''||'Project'||''''||
               ', 1, 0),1,DECODE(I.FIRST_CALL,'||''''||'t'||''''||',1,0),0)) REQ_FC_TOTALS';-- Request recs that are first call closures.
      -- From Clause.
      IF (ptype = 'PROD' OR ptype = 'GROUP') -- Group by product type.
      THEN
         vsql := vsql||' FROM INCIDENTSM1 I';
      ELSIF (ptype = 'NAME')
      THEN
         vsql := vsql||' FROM INCIDENTSM1 I, OPERATORM1 O'; -- For name and Analyst.
      ELSIF (ptype = 'ALOCP' OR ptype = 'ALOCR')
      THEN
         vsql := vsql||' FROM INCIDENTSM1 I, OPERATORM1V O';
      END IF;
      -- Common portions of the Where clause. To ensure that the date and time is used in fetching the records,
      -- we convert the dates to char using the date-time picture, and convert it back to date-time in the select.
      vsql := vsql||' WHERE I.OPEN_TIME BETWEEN '||'to_date('||''''||TO_CHAR(v_gmt_startdate, 'DD-MON-YYYY HH24:MI:SS')
                  ||''''||','||''''||'DD-MON-YYYY HH24:MI:SS'||''')'
                  ||' AND '||'to_date('||''''||TO_CHAR(v_gmt_enddate, 'DD-MON-YYYY HH24:MI:SS')||''''||','||''''
                  ||'DD-MON-YYYY HH24:MI:SS'||''')'||
                    ' AND ('||Bipkg_Utils.BIFNC_createinlist ('I.PFZ_ORIG_GROUP', porig_group)||')'||
                    ' AND ('||Bipkg_Utils.BIFNC_createinlist ('I.CATEGORY', vinteraction_type)||')'||
                    ' AND ('||Bipkg_Utils.BIFNC_createinlist ('nvl(I.LOCATION,'||''''||'x'||''')', plocation)||')';
      -- Excludes in the report
      IF (psource != 'None')
      THEN
         vsql := vsql||' AND NOT ('||Bipkg_Utils.BIFNC_createinlist ('I.PFZ_CALL_SOURCE', psource)||')';
      END IF;
      IF (pcontact != 'None')
      THEN
         vsql := vsql||' AND NOT ('||Bipkg_Utils.BIFNC_createNonCSVinlist ('I.PFZ_FULL_NAME', pcontact, '|')||')';
      END IF;
      --
      -- Portion of Where clause specific to ptype NAME. Note the outer join.
      IF (ptype = 'NAME' OR ptype = 'ALOCP' OR ptype = 'ALOCR')
      THEN
         vsql := vsql||' AND I.OPENED_BY = O.NAME(+) ';
      END IF;
      --
      -- Group By clause.
      IF (ptype = 'PROD') -- Group by product type.
      THEN
         vsql := vsql||' GROUP BY trim(I.PRODUCT_TYPE) '||
                       ' ORDER BY COUNT(*) desc, trim(I.PRODUCT_TYPE)' ;
      ELSIF (ptype = 'GROUP')-- Group by PFZ_Orig_Goup.
      THEN
         vsql := vsql||' GROUP BY I.PFZ_ORIG_GROUP'||
                       ' ORDER BY COUNT(*) desc, I.PFZ_ORIG_GROUP' ;
      ELSIF (ptype = 'NAME') -- Group by opened_by.
      THEN
         vsql := vsql||' GROUP BY I.OPENED_BY, NVL(O.FULL_NAME, '||''''||'('||''''||'||I.OPENED_BY||'||''''||')'||''''||') ORDER BY I.OPENED_BY';
      ELSIF (ptype = 'ALOCP' OR ptype = 'ALOCR')  -- Analyst specific
      THEN
         vsql := vsql||' GROUP BY I.OPENED_BY, NVL(O.FULL_NAME, '||''''||'('||''''||'||I.OPENED_BY||'||''''||')'||''''||'), '||'I.LOCATION,';
         IF (ptype = 'ALOCP')
         THEN
            vsql := vsql||'I.PRODUCT_TYPE';
         ELSE
            vsql := vsql||'I.RESOLUTION_CODE';
         END IF;
      END IF;
      --
      OPEN select_fcr_cursor FOR vsql;
   END bisp_select_FCR;


   -- sg 22-jun-2006 created procedure for fcr report
   PROCEDURE bisp_fcr
   (
      fcr_cursor      IN OUT   bisp_refcursor_type,
      porig_group        IN       VARCHAR2,
      pproduct           IN       VARCHAR2,
      plocation          IN       VARCHAR2,
      psource            IN       VARCHAR2,
      pcontact           IN       VARCHAR2,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
    vinteraction_type    IN       VARCHAR2
   )
   IS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getstartandenddates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_adjustfortz(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_adjustfortz(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt :=
        'select ' ||
        'incidentsm1.incident_id, ' ||
        'bipkg_utils.bifnc_adjustfortz(incidentsm1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, ' ||
        'incidentsm1.opened_by, ' ||
        'incidentsm1.location, ' ||
        'incidentsm1.close_time, ' ||
        'incidentsm1.first_call, ' ||
        'incidentsm1.product_type, ' ||
        'incidentsm1.pfz_product_subtype, ' ||
        'incidentsm1.problem_type, ' ||
        'incidentsm1.resolution_code, ' ||
        'incidentsm1.pfz_rb_email, ' ||
        'incidentsm1.pfz_rb_full_name, ' ||
        'incidentsm1.pfz_orig_group, ' ||
        'incidentsm1.pfz_call_source, ' ||
        'incidentsm1.pfz_sla_title, ' ||
--02.06.08-shw-        'incidentsm1.pfz_priority_code, ' ||
        'incidentsm1.priority_code, ' ||
        'incidentsm1.pfz_full_name, ' ||
        'incidentsm1.brief_description, ' ||
        'operatorm1v.full_name, ' ||
        '''' || v_startdatedisplay || '''' || ' StartDateDisplay , ' ||
        '''' || v_enddatedisplay || '''' || ' EndDateDisplay, CATEGORY ' ||
           ' from incidentsm1 left outer join operatorm1v on incidentsm1.opened_by = operatorm1v.name '||
           ' where (' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.pfz_orig_group', porig_group) || ')' ||
           ' and (' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.product_type', pproduct) || ')' ||
           ' and (' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.location', plocation) || ')' ||
           ' and (' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.CATEGORY', vinteraction_type) || ')' ||
           ' and not(' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.pfz_call_source', psource) || ')' ||
           ' and not(' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.pfz_full_name', pcontact) || ')' ||
           ' and incidentsm1.open_time between ' ||
        'to_date('||''''||TO_CHAR(v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS') || '''' || ',' || '''' || 'DD-MM-YYYY HH24:MI:SS' || ''')' ||
        ' and ' ||
        'to_date('||''''||TO_CHAR(v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS') || '''' || ',' || '''' || 'DD-MM-YYYY HH24:MI:SS' || ''')'
        ;
      OPEN fcr_cursor FOR v_select_stmt ;
   END bisp_fcr;

  -- RMakkena 19-OCT-2006 created procedure for Web Call Analysis Report.

   PROCEDURE BISP_WEBCALLS_ANALYSIS (
      select_opn_calls_cursor  IN OUT   bisp_refcursor_type,
      porig_group        IN          VARCHAR2,
      pfrequency         IN          VARCHAR2,
      poverride          IN          VARCHAR2,
      pzone              IN          VARCHAR2,
      pstartdate         IN          DATE,
      penddate           IN          DATE,
    vinteraction_type    IN          VARCHAR2

                        ) AS


          v_select_stmt        VARCHAR2(32767);
          v_close_time         DATE;
          v_startdatedisplay   VARCHAR2(50);
          v_enddatedisplay     VARCHAR2(50);
          v_db_zone            VARCHAR2(10);
          v_gmt_startdate      DATE;
          v_gmt_enddate        DATE;



   BEGIN

        v_db_zone := 'GMT';
          Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay   := TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT INCIDENTSM1.INCIDENT_ID, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, INCIDENTSM1.PFZ_CALL_SOURCE, INCIDENTSM1.OPENED_BY, v_psm.NUMBERPRGN, v_psm.PFZ_SITE_ID, INCIDENTSM1.LOCATION, INCIDENTSM1.PFZ_ORIG_GROUP, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay, INCIDENTSM1.CATEGORY';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1 ' ;
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN SCRELATIONM1 SCRELATIONM1 ON INCIDENTSM1.INCIDENT_ID = SCRELATIONM1.SOURCE ';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN SC.V_PROBSUMMARY v_psm ON SCRELATIONM1.DEPEND = v_psm.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE (INCIDENTSM1.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.OPEN_TIME < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.OPENED_BY =  ' || '''' || 'WEBCALL' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(incidentsm1.category, '' '')', vinteraction_type)|| ')';
        OPEN  select_opn_calls_cursor FOR v_select_stmt;
    END BISP_WEBCALLS_ANALYSIS;

END Bipkg_Gv_Calls;
/

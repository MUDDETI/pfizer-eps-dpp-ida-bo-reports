CREATE OR REPLACE PACKAGE BIPKG_GV_RESOLUTION AS
/******************************************************************************
   NAME:       BIPKG_GV_RESOLUTION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2/28/2008     -shw-        1. Created this package.
   2.0        04/07/2008    -shw-        2. use 'handle_time' in Interactions as resolve_time, ASSIGNMENTM1 table.
   3.0        10/23/2008    -shw-       3. add call source, vendor, repg.group params 
   4.0        03/18/2009    -shw-       4. add interaction start, stop, & worked_time to selections 
******************************************************************************/
   TYPE bisp_refcursor_type IS REF CURSOR;

   PROCEDURE bisp_select_resolution (
      select_resolution_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      presolutioncodes    IN       VARCHAR2,
      pcallsource         IN       VARCHAR2,
      pvendor             IN       VARCHAR2,
      prptgroup           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   );

END BIPKG_GV_RESOLUTION;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_GV_RESOLUTION AS
/******************************************************************************
   NAME:       BIPKG_GV_RESOLUTION
   PURPOSE:
REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------------------
   1.0        2/28/2008     -shw-        1. Created this package for Account Unlock-Reset report.
   2.0        04/07/2008    -shw-        2. use 'handle_time' in Interactions as resolve_time, ASSIGNMENTM1 table.
   3.0        10/23/2008    -shw-       3. add call source, vendor, repg.group params 
   4.0        03/18/2009    -shw-       4. add interaction start, stop, & worked_time to selections 
*****************************************************************************************************************************/
PROCEDURE bisp_select_resolution (

      select_resolution_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      presolutioncodes    IN       VARCHAR2,
      pcallsource         IN       VARCHAR2,
      pvendor             IN       VARCHAR2,
      prptgroup           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2

      ) AS

          v_select_stmt        VARCHAR2(32767);
          v_open_time          DATE;
          v_startdatedisplay   VARCHAR2(50);
          v_enddatedisplay     VARCHAR2(50);
          v_db_zone            VARCHAR2(10);
          v_gmt_startdate      DATE;
          v_gmt_enddate        DATE;
          v_gmt_startdate_str  VARCHAR2 (19);
          v_gmt_enddate_str    VARCHAR2 (19);
          v_currentdate        VARCHAR(50);

  BEGIN
--   1.0        2/28/2008     -shw-        1. Created this package for Account Unlock-Reset report.
--  Report combines (UNION ALL) FCR Interactions and Incidents based on timeframe, asignment, and resolution code(s) .
        v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
        v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := '';
        v_select_stmt := v_select_stmt || 'SELECT ' || '''' || 'INCIDENT' || '''' || ' record_type,';
        v_select_stmt := v_select_stmt || ' am1.pfz_reporting_group, am1.pfz_vendor, am1.pfz_service_tower, ';
        v_select_stmt := v_select_stmt || ' operatorm1v.full_name, v_psm.pfz_rb_full_name, v_psm.assignment, v_psm.assignee_name, v_psm.brief_description, ';
        v_select_stmt := v_select_stmt || ' v_psm.closed_by, v_psm.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, ';
        v_select_stmt := v_select_stmt || ' v_psm.country,  v_psm.location, v_psm.pfz_rb_location,v_psm.numberprgn numberprgn, v_psm.INCIDENT_ID pfz_related, v_psm.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,';
        v_select_stmt := v_select_stmt || ' v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_division, v_psm.pfz_full_name, ';
        v_select_stmt := v_select_stmt || ' v_psm.pfz_sla_title, v_psm.problem_type, v_psm.product_type, v_psm.resolution_code, v_psm.resolution, v_psm.updated_by, ';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.PRIORITY,v_psm.category,v_psm.PFZ_PRODUCT_SUBTYPE,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time,';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') pfz_interaction_start, ';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') pfz_interaction_stop, ';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') worked_time ';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' INNER JOIN SC.ASSIGNMENTM1 am1 ON v_psm.ASSIGNMENT = am1.NAME ';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON v_psm.closed_by = operatorm1v.name';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.resolution_code', presolutioncodes) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.pfz_call_source', pcallsource) || ')';
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') ';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', pvendor)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', prptgroup)|| ')';

        v_select_stmt := v_select_stmt || ' UNION ALL ';
        v_select_stmt := v_select_stmt || 'SELECT ' || '''' || 'INTERACTION' || '''' || ' record_type,';
        v_select_stmt := v_select_stmt || ' am1.pfz_reporting_group, am1.pfz_vendor, am1.pfz_service_tower, ';
        v_select_stmt := v_select_stmt || ' operatorm1v.full_name, i1.pfz_rb_full_name, i1.pfz_orig_group assignment, i1.opened_by assignee_name, i1.brief_description, ';
        v_select_stmt := v_select_stmt || ' i1.closed_by, i1.pfz_orig_group closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(i1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, ';
        v_select_stmt := v_select_stmt || ' i1.country, i1.location, i1.pfz_rb_location,i1.INCIDENT_ID numberprgn, i1.PFZ_RELATED pfz_related, i1.pfz_orig_group open_group,BIPKG_UTILS.BIFNC_AdjustForTZ(i1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,';
        v_select_stmt := v_select_stmt || ' i1.opened_by,i1.pfz_bu,i1.pfz_call_source,i1.pfz_division,i1.pfz_full_name, ';
        v_select_stmt := v_select_stmt || ' i1.pfz_sla_title,i1.problem_type,i1.product_type,i1.resolution_code,i1.resolution,i1.updated_by, ';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(i1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' i1.PRIORITY_CODE,i1.category, i1.PFZ_PRODUCT_SUBTYPE, i1.handle_time resolve_time, ';
        v_select_stmt := v_select_stmt || ' NVL(i1.pfz_interaction_start,i1.close_time) pfz_interaction_start, i1.pfz_interaction_stop, ';
        v_select_stmt := v_select_stmt || ' NVL(i1.worked_time,to_date('|| '''' || '4000, 01, 01, 00, 00, 00' || '''' || ',' || '''' ||'YYYY, MM, DD, HH24:MI:SS' ||''''||')) worked_time ';
        v_select_stmt := v_select_stmt || ' FROM SC.INCIDENTSM1 i1';
        v_select_stmt := v_select_stmt || ' INNER JOIN SC.ASSIGNMENTM1 am1 ON i1.pfz_orig_group = am1.NAME ';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON i1.closed_by = operatorm1v.name';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('i1.pfz_orig_group', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('i1.resolution_code', presolutioncodes) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('i1.pfz_call_source', pcallsource) || ')';
        v_select_stmt := v_select_stmt || ' AND i1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND i1.close_time < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(i1.category, '' '')', vinteraction_type)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', pvendor)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', prptgroup)|| ')';
--10.23.08-shw-         v_select_stmt := v_select_stmt || ' AND NVL(i1.PFZ_RELATED,'' '') = ' || '''' || ' ' || '''' || '';

         OPEN select_resolution_cursor FOR v_select_stmt;
  END bisp_select_resolution;
END BIPKG_GV_RESOLUTION;
/

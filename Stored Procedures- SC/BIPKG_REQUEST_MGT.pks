CREATE OR REPLACE PACKAGE BIPKG_REQUEST_MGT AS
/******************************************************************************
   NAME:       BIPKG_REQUEST_MGT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        9/8/2008       shw          1. Created this package.
   2.0        10/08/2008    shw             2. Added OLA/SLA fields per Jeff P. 
   3.0        10/17/2008    shw             3. added request.pfz_requested_end date 
   4.0        11/05/2008    shw             4. added 'Status' parameter 
******************************************************************************/
   TYPE bisp_refcursor_type IS REF CURSOR;

   PROCEDURE bisp_select_RM_Workload (
      overall_RM_cursor  IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vurgency           IN       VARCHAR2,
      vopened_by         IN       VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      vZONE              IN       VARCHAR2,
      vtime              IN       VARCHAR2,
      vVENDOR            IN       VARCHAR2,
      vTOWER             IN       VARCHAR2,
      vRPTGRP            IN       VARCHAR2,
      vREGION            IN       VARCHAR2,
      vAREA              IN       VARCHAR2,
      vCLIENTREGION      IN       VARCHAR2,
      vCLIENTDIVISION    IN       VARCHAR2,
      vCLIENTCOUNTRY     IN       VARCHAR2,
      vCLIENTLOCATION    IN       VARCHAR2,
      vSERVICELEVEL      IN       VARCHAR2,
      vPRODUCTTYPE       IN       VARCHAR2,
      vSTATUS            IN       VARCHAR2

   );
   PROCEDURE bisp_select_RM_Tasks (
      overall_RM_cursor  IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vurgency           IN       VARCHAR2,
      vopened_by         IN       VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      vZONE              IN       VARCHAR2,
      vtime              IN       VARCHAR2,
      vVENDOR            IN       VARCHAR2,
      vTOWER             IN       VARCHAR2,
      vRPTGRP            IN       VARCHAR2,
      vREGION            IN       VARCHAR2,
      vAREA              IN       VARCHAR2,
      vCLIENTREGION      IN       VARCHAR2,
      vCLIENTDIVISION    IN       VARCHAR2,
      vCLIENTCOUNTRY     IN       VARCHAR2,
      vCLIENTLOCATION    IN       VARCHAR2,
      vSERVICELEVEL      IN       VARCHAR2,
      vPRODUCTTYPE       IN       VARCHAR2,
      vSTATUS            IN       VARCHAR2

   );
END BIPKG_REQUEST_MGT;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_REQUEST_MGT AS
/******************************************************************************
   NAME:       BIPKG_REQUEST_MGT 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        9/8/2008       shw          1. Created this package.
   2.0        10/08/2008    shw             2. Added OLA/SLA fields per Jeff P. 
   3.0        10/17/2008    shw             3. added request.pfz_requested_end date 
   4.0        11/05/2008    shw             4. added 'Status' parameter 
******************************************************************************/
   PROCEDURE bisp_select_RM_Workload (
      overall_RM_cursor  IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vurgency           IN       VARCHAR2,
      vopened_by         IN       VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      vZONE              IN       VARCHAR2,
      vtime              IN       VARCHAR2,
      vVENDOR            IN       VARCHAR2,
      vTOWER             IN       VARCHAR2,
      vRPTGRP            IN       VARCHAR2,
      vREGION            IN       VARCHAR2,
      vAREA              IN       VARCHAR2,
      vCLIENTREGION      IN       VARCHAR2,
      vCLIENTDIVISION    IN       VARCHAR2,
      vCLIENTCOUNTRY     IN       VARCHAR2,
      vCLIENTLOCATION    IN       VARCHAR2,
      vSERVICELEVEL      IN       VARCHAR2,
      vPRODUCTTYPE       IN       VARCHAR2,
      vSTATUS            IN       VARCHAR2
   )
   AS
      vfromtz              VARCHAR2 (3);
      v_startdatedisplay   VARCHAR (50);
      v_enddatedisplay     VARCHAR (50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_gmt_startdate_str  VARCHAR2 (19);
      v_gmt_enddate_str    VARCHAR2 (19);
      v_select_stmt        VARCHAR2 (32767);
      v_whereclause        VARCHAR2 (32767);
   BEGIN

      vfromtz := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, vZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, vZONE), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, vZONE), 'DD-MM-YYYY HH24:MI:SS');
        v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
        v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');

        v_select_stmt := ' SELECT request.approval_status, request.assigned_dept, request.assigned_to, request.brief_description, request.category, request.closed_by,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.close_date,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') close_date,'; 
        v_select_stmt := v_select_stmt || ' request.company, request.country, request.last_activity, request.location, request.logical_name, request.numberprgn, request.open_group,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') open_time,';
        v_select_stmt := v_select_stmt || ' request.page, request.parts_summary, request.pfz_bu, request.pfz_bundle, request.pfz_call_source, request.pfz_division, request.pfz_full_name, request.pfz_project_cdp, request.pfz_rb_full_name, request.pfz_total_time_spent,';
        v_select_stmt := v_select_stmt || ' request.priority, request.product_type, request.pfz_product_subtype, request.pfz_urgency, request.requestor_name, request.time_spent, request.total_cost, request.status, request.subcategory, request.updated_by,';
        v_select_stmt := v_select_stmt || ' request.pfz_template_name, request.PFZ_BUNDLE Request_Template_ID,'; 
        v_select_stmt := v_select_stmt || ' request.pfz_lead SLA_duration, request.pfz_bus_hours, request.pfz_sla_schedule, request.pfz_sla_schedule_dur, request.pfz_sla_schedule_clock, request.description, ';
        v_select_stmt := v_select_stmt || ' (select count(*) from sc.SCRELATIONM1 rel1 where request.numberprgn = rel1.source and rel1.depend_filename = ' || '''' || 'problem' || '''' || ') Incidents_Opened,';
        v_select_stmt := v_select_stmt || ' (select count(*) from sc.SCRELATIONM1 rel1 where request.numberprgn = rel1.source and rel1.depend_filename = ' || '''' || 'cm3r' || '''' || ') RFCs_Opened,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.pfz_start_work,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') work_phase_started,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.submit_date,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') submit_date,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.update_date,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') update_date,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.requested_date,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') requested_date,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.planned_start,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') planned_start,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.planned_end,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') planned_end,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.pfz_requested_end,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') pfz_requested_end,';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP,';
        v_select_stmt := v_select_stmt || ' cm1.LOCATION Client_Location,cm1.PFZ_DIVISION Client_Division,';
        v_select_stmt := v_select_stmt || ' sm1.PFZ_REGION_ID Region, sm1.SITE_ID Area,';
        v_select_stmt := v_select_stmt || ' um1.NAME Client_Country,um1.PFZ_REGION_ID Client_Region, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM sc.OCMQM1 request LEFT OUTER JOIN sc.assignmentm1 am1 ON request.assigned_dept = am1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.CONTACTSM1 cm1 ON request.REQUESTOR_NAME = cm1.CONTACT_NAME';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (' ||Bipkg_Utils.bifnc_createinlist ('NVL(request.assigned_dept, '' '')', vassignmentgroup) || ')';
           IF vtime = 'Closed'
           Then
        v_select_stmt := v_select_stmt || ' AND request.close_date between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') ';
            Else
        v_select_stmt := v_select_stmt || ' AND request.submit_date between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') ';
            End If;
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(cm1.LOCATION, '' '')', vCLIENTLOCATION)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(request.pfz_urgency, '' '')', vurgency)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(sm1.PFZ_REGION_ID, '' '')', vREGION)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(sm1.SITE_ID, '' '')', vAREA)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(um1.PFZ_REGION_ID, '' '')', vCLIENTREGION)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(cm1.PFZ_DIVISION, '' '')', vCLIENTDIVISION)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(um1.NAME, '' '')', vCLIENTCOUNTRY)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_DESCRIPTION, '' '')', vSERVICELEVEL)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(request.open_group, '' '')', vopened_by)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(request.product_type, '' '')', vPRODUCTTYPE)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(request.status, '' '')', vSTATUS)|| ')';
      OPEN overall_RM_cursor FOR v_select_stmt;

   END bisp_select_RM_Workload;

/***************************************************************************************************************************************************/
   PROCEDURE bisp_select_RM_Tasks (
      overall_RM_cursor  IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vurgency           IN       VARCHAR2,
      vopened_by         IN       VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      vZONE              IN       VARCHAR2,
      vtime              IN       VARCHAR2,
      vVENDOR            IN       VARCHAR2,
      vTOWER             IN       VARCHAR2,
      vRPTGRP            IN       VARCHAR2,
      vREGION            IN       VARCHAR2,
      vAREA              IN       VARCHAR2,
      vCLIENTREGION      IN       VARCHAR2,
      vCLIENTDIVISION    IN       VARCHAR2,
      vCLIENTCOUNTRY     IN       VARCHAR2,
      vCLIENTLOCATION    IN       VARCHAR2,
      vSERVICELEVEL      IN       VARCHAR2,
      vPRODUCTTYPE       IN       VARCHAR2,
      vSTATUS            IN       VARCHAR2
   )
   AS
      vfromtz              VARCHAR2 (3);
      v_startdatedisplay   VARCHAR (50);
      v_enddatedisplay     VARCHAR (50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_gmt_startdate_str  VARCHAR2 (19);
      v_gmt_enddate_str    VARCHAR2 (19);
      v_select_stmt        VARCHAR2 (32767);
      v_whereclause        VARCHAR2 (32767);
   BEGIN
      vfromtz := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, vZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, vZONE), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, vZONE), 'DD-MM-YYYY HH24:MI:SS');
        v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
        v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');

        v_select_stmt := ' SELECT task.numberprgn task_#, task.phase_num task_phase_num, task.brief_description task_brief_description, task.description task_description, task.category task_category, task.closed_by task_closed_by,';
        v_select_stmt := v_select_stmt || ' task.priority task_priority, task.product_type task_product_type, task.pfz_product_subtype task_product_subtype, task.pfz_lead task_OLA_duration, task.pfz_urgency task_urgency, task.pfz_grouping task_grouping, task.time_spent task_time_spent, task.total task_total, task.pfz_total_time_spent task_total_time_spent, task.status task_status, task.subcategory task_subcategory, task.work_manager task_work_manager,';
        v_select_stmt := v_select_stmt || ' task.assigned_dept task_assigned_dept, task.assigned_to task_assigned_to, ';
        v_select_stmt := v_select_stmt || ' task.pfz_template_name, task.PFZ_BUNDLE task_Request_Template_ID,task.part_no task_Template_ID, '; 
        v_select_stmt := v_select_stmt || ' task.pfz_lead task_SLA_duration, task.pfz_bus_hours task_bus_hrs, task.pfz_sla_schedule task_sla_schedule, task.pfz_sla_schedule_dur task_sla_schedule_dur, task.pfz_sla_schedule_clock task_sla_schedule_clock, ';
        v_select_stmt := v_select_stmt || ' task.manufacturer task_manufacturer, task.model task_model ,task.target_lead_time task_target_lead_time, task.normal_lead_time task_normal_lead_time, task.actual_lead_time task_actual_lead_time, ';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(task.submit_date,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') task_submit_date,'; 
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(task.phase_start_date,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') task_phase_start_date,'; 
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(task.requested_date,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') task_requested_date,'; 
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(task.actual_date,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') task_actual_date,'; 
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(task.update_date,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') task_update_date,'; 
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(task.close_date,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') task_close_date,'; 
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(task.pfz_start_work,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') task_start_work_date,'; 
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(task.target_order,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') task_last_start,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(task.target_completion,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') task_deadline,';

        v_select_stmt := v_select_stmt || ' request.approval_status, request.assigned_dept, request.assigned_to, request.brief_description, request.category, request.closed_by,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.close_date,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') close_date,'; 
        v_select_stmt := v_select_stmt || ' request.company, request.country, request.last_activity, request.location, request.logical_name, request.numberprgn, request.open_group,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') open_time,';
        v_select_stmt := v_select_stmt || ' request.page, request.parts_summary, request.pfz_bu, request.pfz_bundle, request.pfz_call_source, request.pfz_division, request.pfz_full_name, request.pfz_project_cdp, request.pfz_rb_full_name, request.pfz_total_time_spent,';
        v_select_stmt := v_select_stmt || ' request.priority, request.product_type, request.pfz_product_subtype, request.pfz_urgency, request.requestor_name, request.time_spent, request.total_cost, request.status, request.subcategory, request.updated_by,';
        v_select_stmt := v_select_stmt || ' request.pfz_template_name, request.PFZ_BUNDLE Request_Template_ID,'; 
        v_select_stmt := v_select_stmt || ' request.pfz_lead SLA_duration, request.pfz_bus_hours, request.pfz_sla_schedule, request.pfz_sla_schedule_dur, request.pfz_sla_schedule_clock, request.description, ';
        v_select_stmt := v_select_stmt || ' (select count(*) from sc.SCRELATIONM1 rel1 where request.numberprgn = rel1.source and rel1.depend_filename = ' || '''' || 'problem' || '''' || ') Incidents_Opened,';
        v_select_stmt := v_select_stmt || ' (select count(*) from sc.SCRELATIONM1 rel1 where request.numberprgn = rel1.source and rel1.depend_filename = ' || '''' || 'cm3r' || '''' || ') RFCs_Opened,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.pfz_start_work,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') work_phase_started,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.submit_date,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') submit_date,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.update_date,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') update_date,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.requested_date,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') requested_date,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.planned_start,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') planned_start,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.planned_end,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') planned_end,';
        v_select_stmt := v_select_stmt || ' bipkg_utils.bifnc_AdjustForTZ(request.pfz_requested_end,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| vZONE|| ''''|| ') pfz_requested_end,';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP, ';
        v_select_stmt := v_select_stmt || ' cm1.LOCATION Client_Location,cm1.PFZ_DIVISION Client_Division,';
        v_select_stmt := v_select_stmt || ' sm1.PFZ_REGION_ID Region, sm1.SITE_ID Area,';
        v_select_stmt := v_select_stmt || ' um1.NAME Client_Country,um1.PFZ_REGION_ID Client_Region, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM sc.OCMLM1 task INNER JOIN sc.OCMQM1 request ON request.numberprgn = task.parent_quote';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.assignmentm1 am1 ON request.assigned_dept = am1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.CONTACTSM1 cm1 ON request.REQUESTOR_NAME = cm1.CONTACT_NAME';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (' ||Bipkg_Utils.bifnc_createinlist ('NVL(task.assigned_dept, '' '')', vassignmentgroup) || ')';
           IF vtime = 'Closed'
           Then
        v_select_stmt := v_select_stmt || ' AND task.close_date between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') ';
            Else
        v_select_stmt := v_select_stmt || ' AND task.submit_date between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') ';
            End If;
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(cm1.LOCATION, '' '')', vCLIENTLOCATION)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(task.pfz_urgency, '' '')', vurgency)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(sm1.PFZ_REGION_ID, '' '')', vREGION)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(sm1.SITE_ID, '' '')', vAREA)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(um1.PFZ_REGION_ID, '' '')', vCLIENTREGION)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(cm1.PFZ_DIVISION, '' '')', vCLIENTDIVISION)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(um1.NAME, '' '')', vCLIENTCOUNTRY)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_DESCRIPTION, '' '')', vSERVICELEVEL)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(request.open_group, '' '')', vopened_by)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(task.product_type, '' '')', vPRODUCTTYPE)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(task.status, '' '')', vSTATUS)|| ')';
      OPEN overall_RM_cursor FOR v_select_stmt;

   END bisp_select_RM_Tasks;
END BIPKG_REQUEST_MGT;
/

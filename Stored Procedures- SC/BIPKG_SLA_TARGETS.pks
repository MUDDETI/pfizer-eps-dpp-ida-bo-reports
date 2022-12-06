CREATE OR REPLACE PACKAGE BIPKG_SLA_TARGETS AS
/******************************************************************************
   NAME:       bisp_SLA_OVERALL  
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
    4.0         08.18.08    shw         1. std. OVERALL SLA sproc: 
                                            add Cause_Code Exclusion, re-Open Counter  
    4.1         09.12.08    shw         2. verify 'Secondary' vtarget_metric logic  
    4.2         10.11.08    Yerrav      3. add company field from contactsm1.                                                                              
******************************************************************************/
   TYPE bisp_refcursor_type IS REF CURSOR;

   PROCEDURE bisp_select_sla_target (
      overall_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
      vresolution        IN       VARCHAR2,
      vopened_by         IN       VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2,
      vinteraction_type  IN       VARCHAR2,
      vtarget_metric     IN       VARCHAR2,
      vtime              IN       VARCHAR2,
      vVENDOR            IN       VARCHAR2,
      vTOWER             IN       VARCHAR2,
      vRPTGRP            IN       VARCHAR2,
      vREGION            IN       VARCHAR2,
      vAREA              IN       VARCHAR2,
      vCLIENTREGION      IN       VARCHAR2,
      vCLIENTDIVISION    IN       VARCHAR2,
      vCLIENTCOUNTRY     IN       VARCHAR2,
      vSERVICELEVEL      IN       VARCHAR2,
      vCauseCode         IN       VARCHAR2,
      vOpenedAfter       IN       DATE
      
   );
   PROCEDURE bisp_sel_sla_Rspnd_Target (
      overall_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
      vresolution        IN       VARCHAR2,
      vopened_by         IN       VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2,
      vinteraction_type  IN       VARCHAR2,
      vtarget_metric     IN       VARCHAR2,
      vtime              IN       VARCHAR2,
      vVENDOR            IN       VARCHAR2,
      vTOWER             IN       VARCHAR2,
      vRPTGRP            IN       VARCHAR2,
      vREGION            IN       VARCHAR2,
      vAREA              IN       VARCHAR2,
      vCLIENTREGION      IN       VARCHAR2,
      vCLIENTDIVISION    IN       VARCHAR2,
      vCLIENTCOUNTRY     IN       VARCHAR2,
      vSERVICELEVEL      IN       VARCHAR2,
      vCauseCode         IN       VARCHAR2,
      vOpenedAfter       IN       DATE
   );
   PROCEDURE bisp_sel_sla_Rstre_Target (
      overall_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
      vresolution        IN       VARCHAR2,
      vopened_by         IN       VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2,
      vinteraction_type  IN       VARCHAR2,
      vtarget_metric     IN       VARCHAR2,
      vtime              IN       VARCHAR2,
      vVENDOR            IN       VARCHAR2,
      vTOWER             IN       VARCHAR2,
      vRPTGRP            IN       VARCHAR2,
      vREGION            IN       VARCHAR2,
      vAREA              IN       VARCHAR2,
      vCLIENTREGION      IN       VARCHAR2,
      vCLIENTDIVISION    IN       VARCHAR2,
      vCLIENTCOUNTRY     IN       VARCHAR2,
      vSERVICELEVEL      IN       VARCHAR2,
      vCauseCode         IN       VARCHAR2,
      vOpenedAfter       IN       DATE
   );
   PROCEDURE bisp_sel_sla_Rslve_Target (
      overall_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
      vresolution        IN       VARCHAR2,
      vopened_by         IN       VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2,
      vinteraction_type  IN       VARCHAR2,
      vtarget_metric     IN       VARCHAR2,
      vtime              IN       VARCHAR2,
      vVENDOR            IN       VARCHAR2,
      vTOWER             IN       VARCHAR2,
      vRPTGRP            IN       VARCHAR2,
      vREGION            IN       VARCHAR2,
      vAREA              IN       VARCHAR2,
      vCLIENTREGION      IN       VARCHAR2,
      vCLIENTDIVISION    IN       VARCHAR2,
      vCLIENTCOUNTRY     IN       VARCHAR2,
      vSERVICELEVEL      IN       VARCHAR2,
      vCauseCode         IN       VARCHAR2,
      vOpenedAfter       IN       DATE
   );
END BIPKG_SLA_Targets;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_SLA_TARGETS
AS
/*************************************************************************************************
   NAME:       bisp_SLA_OVERALL  
   PURPOSE:     

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
    4.0         08.18.08    shw         1. std. OVERALL SLA sproc: 
                                            add Cause_Code Exclusion, re-Open Counter                               
    4.1         09.12.08    shw         2. verify 'Secondary' vtarget_metric logic    
    4.2         10.11.08    Yerrav      3. add company field from contactsm1.                                                                     
*************************************************************************************************/
--
-- Error Handling is done by the report. We do not trap any exceptions at the Database side.
--
   PROCEDURE bisp_select_sla_target (
      overall_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
      vresolution        IN       VARCHAR2,
      vopened_by         IN       VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2,
      vinteraction_type  IN       VARCHAR2,
      vtarget_metric     IN       VARCHAR2,
      vtime              IN       VARCHAR2,
      vVENDOR            IN       VARCHAR2,
      vTOWER             IN       VARCHAR2,
      vRPTGRP            IN       VARCHAR2,
      vREGION            IN       VARCHAR2,
      vAREA              IN       VARCHAR2,
      vCLIENTREGION      IN       VARCHAR2,
      vCLIENTDIVISION    IN       VARCHAR2,
      vCLIENTCOUNTRY     IN       VARCHAR2,
      vSERVICELEVEL      IN       VARCHAR2,
      vCauseCode         IN       VARCHAR2,
      vOpenedAfter       IN       DATE
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
        Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, ZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');
-- Respond Overall 
              IF vtarget_metric = 'Primary' THEN
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, v_psm.pfz_respond_sla_user SLA_User, v_psm.pfz_respond_sla Made_Missed,v_psm.pfz_respond_sla_group SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.pfz_respond_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        ELSE
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, NVL(v_psm.PFZ_RESPOND_2ND_TARGET_USER, '''') SLA_User, NVL(v_psm.PFZ_RESPOND_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, '' '') SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
-- v.4.0        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, NVL(v_psm.PFZ_RESPOND_2ND_TARGET_USER SLA_User, ''''), NVL(v_psm.PFZ_RESPOND_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, '' '') SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        END IF;        
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';        
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED, v_psm.PFZ_REOPEN_COUNTER,v_psm.CAUSE_CODE,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESTORE_2ND_TARGET,v_psm.PFZ_RESTORE_2ND_TARGET_GROUP,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time,';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP,PFZ_DESCRIPTION,';
        v_select_stmt := v_select_stmt || ' cm1.LOCATION Client_Location,cm1.PFZ_DIVISION Client_Division ,cm1.COMPANY,';
        v_select_stmt := v_select_stmt || ' sm1.PFZ_REGION_ID Region, sm1.SITE_ID Area ,';
        v_select_stmt := v_select_stmt || ' um1.NAME Client_Country,um1.PFZ_REGION_ID Client_Region ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.assignmentm1 am1 ON v_psm.pfz_respond_sla_group = am1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.CONTACTSM1 cm1 ON v_psm.CONTACT_NAME = cm1.CONTACT_NAME';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_respond_sla_group', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.assignmentm1 am1 ON v_psm.PFZ_RESPOND_2ND_TARGET_GROUP = am1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.CONTACTSM1 cm1 ON v_psm.CONTACT_NAME = cm1.CONTACT_NAME';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, '' '')', vassignmentgroup) || ')';
        End If; 
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed' 
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || ' v_psm.open_time > ' || '''' || vOpenedAfter || '''' || ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(cm1.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(sm1.PFZ_REGION_ID, '' '')', vREGION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(sm1.SITE_ID, '' '')', vAREA)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(um1.PFZ_REGION_ID, '' '')', vCLIENTREGION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(cm1.PFZ_DIVISION, '' '')', vCLIENTDIVISION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(um1.NAME, '' '')', vCLIENTCOUNTRY)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_DESCRIPTION, '' '')', vSERVICELEVEL)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.CAUSE_CODE, '' '')', vCauseCode)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
        v_select_stmt := v_select_stmt || ' UNION ALL ';
-- Restore Overall               
            IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, v_psm.pfz_restore_sla_user SLA_User, v_psm.pfz_restore_sla Made_Missed,v_psm.pfz_restore_sla_group SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        Else
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, NVL(v_psm.PFZ_RESTORE_2ND_TARGET_USER, '' '') SLA_User, NVL(v_psm.PFZ_RESTORE_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESTORE_2ND_TARGET_GROUP, '' '') SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        End If; 
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';        
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED, v_psm.PFZ_REOPEN_COUNTER,v_psm.CAUSE_CODE,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESTORE_2ND_TARGET,v_psm.PFZ_RESTORE_2ND_TARGET_GROUP,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time,';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP,PFZ_DESCRIPTION,';
        v_select_stmt := v_select_stmt || ' cm1.LOCATION Client_Location,cm1.PFZ_DIVISION Client_Division,cm1.COMPANY,';
        v_select_stmt := v_select_stmt || ' sm1.PFZ_REGION_ID Region, sm1.SITE_ID Area,';
        v_select_stmt := v_select_stmt || ' um1.NAME Client_Country,um1.PFZ_REGION_ID Client_Region ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.assignmentm1 am1 ON v_psm.pfz_restore_sla_group = am1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.CONTACTSM1 cm1 ON v_psm.CONTACT_NAME = cm1.CONTACT_NAME';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_restore_sla_group', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.assignmentm1 am1 ON v_psm.PFZ_RESTORE_2ND_TARGET_GROUP = am1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.CONTACTSM1 cm1 ON v_psm.CONTACT_NAME = cm1.CONTACT_NAME';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESTORE_2ND_TARGET_GROUP, '' '')', vassignmentgroup) || ')';
        End If; 
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed' 
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || ' v_psm.open_time > ' || '''' || vOpenedAfter || '''' || ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(cm1.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(sm1.PFZ_REGION_ID, '' '')', vREGION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(sm1.SITE_ID, '' '')', vAREA)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(um1.PFZ_REGION_ID, '' '')', vCLIENTREGION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(cm1.PFZ_DIVISION, '' '')', vCLIENTDIVISION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(um1.NAME, '' '')', vCLIENTCOUNTRY)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_DESCRIPTION, '' '')', vSERVICELEVEL)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.CAUSE_CODE, '' '')', vCauseCode)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
        v_select_stmt := v_select_stmt || ' UNION ALL ';
-- Resolve Overall 
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESOLVE'|| ''''|| ' SLA_Type, v_psm.assignee_name SLA_User, v_psm.pfz_resolve_sla Made_Missed,v_psm.assignment SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.resolve_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        Else
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESOLVE'|| ''''|| ' SLA_Type, v_psm.assignee_name SLA_User, NVL(v_psm.PFZ_RESOLVE_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP, v_psm.assignment) SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.resolve_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
              End If; 
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';        
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED, v_psm.PFZ_REOPEN_COUNTER,v_psm.CAUSE_CODE,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESTORE_2ND_TARGET,v_psm.PFZ_RESTORE_2ND_TARGET_GROUP,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time,';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP,PFZ_DESCRIPTION,';
        v_select_stmt := v_select_stmt || ' cm1.LOCATION Client_Location,cm1.PFZ_DIVISION Client_Division ,cm1.COMPANY,';
        v_select_stmt := v_select_stmt || ' sm1.PFZ_REGION_ID Region, sm1.SITE_ID Area ,';
        v_select_stmt := v_select_stmt || ' um1.NAME Client_Country,um1.PFZ_REGION_ID Client_Region ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.assignmentm1 am1 ON v_psm.assignment = am1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.CONTACTSM1 cm1 ON v_psm.CONTACT_NAME = cm1.CONTACT_NAME';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.assignment', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.assignmentm1 am1 ON v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP = am1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.CONTACTSM1 cm1 ON v_psm.CONTACT_NAME = cm1.CONTACT_NAME';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP, '' '')', vassignmentgroup) || ')';
        End If; 
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed' 
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || ' v_psm.open_time > ' || '''' || vOpenedAfter || '''' || ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(cm1.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(sm1.PFZ_REGION_ID, '' '')', vREGION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(sm1.SITE_ID, '' '')', vAREA)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(um1.PFZ_REGION_ID, '' '')', vCLIENTREGION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(cm1.PFZ_DIVISION, '' '')', vCLIENTDIVISION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(um1.NAME, '' '')', vCLIENTCOUNTRY)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_DESCRIPTION, '' '')', vSERVICELEVEL)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.CAUSE_CODE, '' '')', vCauseCode)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
      OPEN overall_sla_cursor FOR v_select_stmt;
   END bisp_select_sla_target;
/**********************************************************************
    4.0         08.18.08    shw         1. std. OVERALL SLA sproc: 
                                            add Cause_Code Exclusion, re-Open Counter                               
**************************************************************************/   
PROCEDURE bisp_sel_sla_Rspnd_Target (
      overall_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
      vresolution        IN       VARCHAR2,
      vopened_by         IN       VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2,
      vinteraction_type  IN       VARCHAR2,
      vtarget_metric     IN       VARCHAR2,
      vtime              IN       VARCHAR2,
      vVENDOR            IN       VARCHAR2,
      vTOWER             IN       VARCHAR2,
      vRPTGRP            IN       VARCHAR2,
      vREGION            IN       VARCHAR2,
      vAREA              IN       VARCHAR2,
      vCLIENTREGION      IN       VARCHAR2,
      vCLIENTDIVISION    IN       VARCHAR2,
      vCLIENTCOUNTRY     IN       VARCHAR2,
      vSERVICELEVEL      IN       VARCHAR2,
      vCauseCode         IN       VARCHAR2,
      vOpenedAfter       IN       DATE
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
        Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, ZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');
              IF vtarget_metric = 'Primary' THEN
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, v_psm.pfz_respond_sla_user SLA_User, v_psm.pfz_respond_sla Made_Missed,v_psm.pfz_respond_sla_group SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.pfz_respond_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        ELSE
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, NVL(v_psm.PFZ_RESPOND_2ND_TARGET_USER, '''') SLA_User, NVL(v_psm.PFZ_RESPOND_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, '' '') SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
-- v.4.0        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, NVL(v_psm.PFZ_RESPOND_2ND_TARGET_USER SLA_User, ''''), NVL(v_psm.PFZ_RESPOND_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, '' '') SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        END IF;        
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';        
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED, v_psm.PFZ_REOPEN_COUNTER,v_psm.CAUSE_CODE,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESTORE_2ND_TARGET,v_psm.PFZ_RESTORE_2ND_TARGET_GROUP,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time, ';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP,PFZ_DESCRIPTION,';
        v_select_stmt := v_select_stmt || ' cm1.LOCATION Client_Location,cm1.PFZ_DIVISION Client_Division ,cm1.COMPANY,';
        v_select_stmt := v_select_stmt || ' sm1.PFZ_REGION_ID Region, sm1.SITE_ID Area ,';
        v_select_stmt := v_select_stmt || ' um1.NAME Client_Country,um1.PFZ_REGION_ID Client_Region ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.assignmentm1 am1 ON v_psm.pfz_respond_sla_group = am1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.CONTACTSM1 cm1 ON v_psm.CONTACT_NAME = cm1.CONTACT_NAME';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_respond_sla_group', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.assignmentm1 am1 ON v_psm.PFZ_RESPOND_2ND_TARGET_GROUP = am1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.CONTACTSM1 cm1 ON v_psm.CONTACT_NAME = cm1.CONTACT_NAME';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, '' '')', vassignmentgroup) || ')';
        End If; 
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed' 
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND v_psm.resolve_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || ' v_psm.open_time > ' || '''' || vOpenedAfter || '''' || ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(cm1.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(sm1.PFZ_REGION_ID, '' '')', vREGION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(sm1.SITE_ID, '' '')', vAREA)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(um1.PFZ_REGION_ID, '' '')', vCLIENTREGION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(cm1.PFZ_DIVISION, '' '')', vCLIENTDIVISION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(um1.NAME, '' '')', vCLIENTCOUNTRY)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_DESCRIPTION, '' '')', vSERVICELEVEL)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.CAUSE_CODE, '' '')', vCauseCode)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
      OPEN overall_sla_cursor FOR v_select_stmt;
   END bisp_sel_sla_Rspnd_Target;
/************************************************************************* 
    4.0         08.18.08    shw         1. std. OVERALL SLA sproc: 
                                            add Cause_Code Exclusion, re-Open Counter                               
**************************************************************************/
   PROCEDURE bisp_sel_sla_Rstre_Target (
      overall_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
      vresolution        IN       VARCHAR2,
      vopened_by         IN       VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2,
      vinteraction_type  IN       VARCHAR2,
      vtarget_metric     IN       VARCHAR2,
      vtime              IN       VARCHAR2,
      vVENDOR            IN       VARCHAR2,
      vTOWER             IN       VARCHAR2,
      vRPTGRP            IN       VARCHAR2,
      vREGION            IN       VARCHAR2,
      vAREA              IN       VARCHAR2,
      vCLIENTREGION      IN       VARCHAR2,
      vCLIENTDIVISION    IN       VARCHAR2,
      vCLIENTCOUNTRY     IN       VARCHAR2,
      vSERVICELEVEL      IN       VARCHAR2,
      vCauseCode         IN       VARCHAR2,
      vOpenedAfter       IN       DATE
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
        Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, ZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');
            IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, v_psm.pfz_restore_sla_user SLA_User, v_psm.pfz_restore_sla Made_Missed,v_psm.pfz_restore_sla_group SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        Else
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, NVL(v_psm.PFZ_RESTORE_2ND_TARGET_USER, '' '') SLA_User, NVL(v_psm.PFZ_RESTORE_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESTORE_2ND_TARGET_GROUP, '' '') SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        End If; 
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';        
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED, v_psm.PFZ_REOPEN_COUNTER,v_psm.CAUSE_CODE,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESTORE_2ND_TARGET,v_psm.PFZ_RESTORE_2ND_TARGET_GROUP,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time, ';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP,PFZ_DESCRIPTION,';
        v_select_stmt := v_select_stmt || ' cm1.LOCATION Client_Location,cm1.PFZ_DIVISION Client_Division,cm1.COMPANY,';
        v_select_stmt := v_select_stmt || ' sm1.PFZ_REGION_ID Region, sm1.SITE_ID Area,';
        v_select_stmt := v_select_stmt || ' um1.NAME Client_Country,um1.PFZ_REGION_ID Client_Region ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.assignmentm1 am1 ON v_psm.pfz_restore_sla_group = am1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.CONTACTSM1 cm1 ON v_psm.CONTACT_NAME = cm1.CONTACT_NAME';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_restore_sla_group', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.assignmentm1 am1 ON v_psm.PFZ_RESTORE_2ND_TARGET_GROUP = am1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.CONTACTSM1 cm1 ON v_psm.CONTACT_NAME = cm1.CONTACT_NAME';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESTORE_2ND_TARGET_GROUP, '' '')', vassignmentgroup) || ')';
        End If; 
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed' 
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND v_psm.resolve_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || ' v_psm.open_time > ' || '''' || vOpenedAfter || '''' || ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(cm1.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(sm1.PFZ_REGION_ID, '' '')', vREGION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(sm1.SITE_ID, '' '')', vAREA)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(um1.PFZ_REGION_ID, '' '')', vCLIENTREGION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(cm1.PFZ_DIVISION, '' '')', vCLIENTDIVISION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(um1.NAME, '' '')', vCLIENTCOUNTRY)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_DESCRIPTION, '' '')', vSERVICELEVEL)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.CAUSE_CODE, '' '')', vCauseCode)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
      OPEN overall_sla_cursor FOR v_select_stmt;
   END bisp_sel_sla_Rstre_Target;
/************************************************************************* 
    4.0         08.18.08    shw         1. std. OVERALL SLA sproc: 
                                            add Cause_Code Exclusion, re-Open Counter                               
**************************************************************************/
   PROCEDURE bisp_sel_sla_Rslve_Target (
      overall_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
      vresolution        IN       VARCHAR2,
      vopened_by         IN       VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2,
      vinteraction_type  IN       VARCHAR2,
      vtarget_metric     IN       VARCHAR2,
      vtime              IN       VARCHAR2,
      vVENDOR            IN       VARCHAR2,
      vTOWER             IN       VARCHAR2,
      vRPTGRP            IN       VARCHAR2,
      vREGION            IN       VARCHAR2,
      vAREA              IN       VARCHAR2,
      vCLIENTREGION      IN       VARCHAR2,
      vCLIENTDIVISION    IN       VARCHAR2,
      vCLIENTCOUNTRY     IN       VARCHAR2,
      vSERVICELEVEL      IN       VARCHAR2,
      vCauseCode         IN       VARCHAR2,
      vOpenedAfter       IN       DATE
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
        Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, ZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESOLVE'|| ''''|| ' SLA_Type, v_psm.assignee_name SLA_User, v_psm.pfz_resolve_sla Made_Missed,v_psm.assignment SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.resolve_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        Else
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESOLVE'|| ''''|| ' SLA_Type, v_psm.assignee_name SLA_User, NVL(v_psm.PFZ_RESOLVE_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP, v_psm.assignment) SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.resolve_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
              End If; 
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';        
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED, v_psm.PFZ_REOPEN_COUNTER,v_psm.CAUSE_CODE,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESTORE_2ND_TARGET,v_psm.PFZ_RESTORE_2ND_TARGET_GROUP,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time, ';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP,PFZ_DESCRIPTION,';
        v_select_stmt := v_select_stmt || ' cm1.LOCATION Client_Location,cm1.PFZ_DIVISION Client_Division ,cm1.COMPANY,';
        v_select_stmt := v_select_stmt || ' sm1.PFZ_REGION_ID Region, sm1.SITE_ID Area ,';
        v_select_stmt := v_select_stmt || ' um1.NAME Client_Country,um1.PFZ_REGION_ID Client_Region ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.assignmentm1 am1 ON v_psm.assignment = am1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.CONTACTSM1 cm1 ON v_psm.CONTACT_NAME = cm1.CONTACT_NAME';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.assignment', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.assignmentm1 am1 ON v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP = am1.name';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.CONTACTSM1 cm1 ON v_psm.CONTACT_NAME = cm1.CONTACT_NAME';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN sc.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP, '' '')', vassignmentgroup) || ')';
        End If; 
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed' 
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND v_psm.resolve_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || ' v_psm.open_time > ' || '''' || vOpenedAfter || '''' || ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(cm1.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(sm1.PFZ_REGION_ID, '' '')', vREGION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(sm1.SITE_ID, '' '')', vAREA)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(um1.PFZ_REGION_ID, '' '')', vCLIENTREGION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(cm1.PFZ_DIVISION, '' '')', vCLIENTDIVISION)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(um1.NAME, '' '')', vCLIENTCOUNTRY)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_DESCRIPTION, '' '')', vSERVICELEVEL)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.CAUSE_CODE, '' '')', vCauseCode)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
      OPEN overall_sla_cursor FOR v_select_stmt;
   END bisp_sel_sla_Rslve_Target;

/************************************************************************* 
**************************************************************************/
END BIPKG_SLA_Targets;
/
CREATE OR REPLACE PACKAGE BIPKG_GvR_SELECT_SLA AS

/******************************************************************************
   NAME:       bisp_select_SLA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/10/2006    shw         1. Created this package for generic
   			  							   SLA reports .
	1.0		   12.07.06		shw			1. select CI Location
	2.0		   10.02.07		shw			1. Upgrade for GAMPS
	2.1		   10.10.07		shw			2. Upgrade for GAMPS - new parameters
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s)
    2.3         12.19.07    shw         4. Resolved or Closed date parameter
    2.4         01.17.08    shw         5. if resolve time is null, replace w/close time
    2.5         02.07.08    shw         6. correct 'RESOLVE' sproc
    2.6         02.12.08    shw         7. add 'Resolve' logic to 'Overall SLA' sproc
    2.7         05.05.08    shw         8. Create custom HP Sprocs (overall, RESP/REST/RESO
                                            remove OperatorM1V , add AssignmentM1 table.
                05.12.08    shw         9. std. SLA sproc: make OPERATORM1V an outer join
    2.8         08.27.08    sanghs      10. Updated the bisp_select_analyst_sla to remove ('v_psm.assignment', vassignmentgroup) 
                                            from Respond and Restore Analyst                   
    4.1         09.12.08    shw         2. verify 'Secondary' vtarget_metric logic                                                                          
******************************************************************************/
   TYPE bisp_refcursor_type IS REF CURSOR;

   PROCEDURE bisp_select_sla_Respond (
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
      vtime              IN       VARCHAR2
   );
   PROCEDURE bisp_select_sla_Restore (
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
      vtime              IN       VARCHAR2
   );
   PROCEDURE bisp_select_sla_Resolve (
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
      vtime              IN       VARCHAR2
   );
/*************************************************************************
    2.7         05.05.08    shw         8. HP SLA Sproc
**************************************************************************/
   PROCEDURE bisp_select_HP_overall_sla (
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
      vRPTGRP            IN       VARCHAR2
   );
   PROCEDURE bisp_select_HP_sla_Respond (
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
      vRPTGRP            IN       VARCHAR2
   );
   PROCEDURE bisp_select_HP_sla_Restore (
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
      vRPTGRP            IN       VARCHAR2
   );
   PROCEDURE bisp_select_HP_sla_Resolve (
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
      vRPTGRP            IN       VARCHAR2
   );


   PROCEDURE bisp_select_overall_sla (
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
      vtime              IN       VARCHAR2
   );
   PROCEDURE bisp_select_analyst_sla (
      analyst_sla_cursor         IN OUT   bisp_refcursor_type,
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
      vtime              IN       VARCHAR2
   );
   PROCEDURE bisp_resolve_sla (
      resolve_sla_cursor         IN OUT   bisp_refcursor_type,
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
      vtarget_metric     IN       VARCHAR2
   );
   PROCEDURE bisp_select_sla_by_ci_location (
      generic_sla_cursor         IN OUT   bisp_refcursor_type,
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
      vtime              IN       VARCHAR2
   );
   PROCEDURE bisp_select_sla_by_loc (
      sla_by_loc_cursor  IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      vpriority          IN       VARCHAR2,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2
   );
END BIPKG_GvR_SELECT_SLA;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_GvR_Select_Sla
AS
/******************************************************************************
   NAME:       bisp_select_sla
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/15/2006    shw         1. Stored Procedure for ALL sla reports.
    1.0           07/25/06     shw            1. Generic SLA recordset extract.
    1.1           08/15/06        shw            2. Generic SLA: Needed NVL on RESTORE for Date and Analyst
    1.0           12.07.06        shw            1. select CI Location
    1.0           01.31.07        shw            3. Generic SLA: mods to 'Respond,Restore' logic
    2.0           10.02.07        shw            1. Upgrade for GAMPS - new fields
    2.1           10.10.07        shw            2. Upgrade for GAMPS - new parameters
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s)
    2.3         12.19.07    shw         4. Resolved or Closed date parameter in seperate RESPOND/RESTORE/RESOLVE
    2.4         01.17.08    shw         5. if resolve time is null, replace w/close time
    2.5         02.07.08    shw         6. correct 'RESOLVE' sproc
    2.6         02.12.08    shw         7. add 'Resolve' logic to 'Overall SLA' sproc
    2.7         05.05.08    shw         8. Create custom HP Sprocs (overall, RESP/REST/RESO
                                            remove OperatorM1V , add AssignmentM1 table.
                05.12.08    shw         9. std. SLA sproc: make OPERATORM1V an outer join
    2.8         08.27.08    sanghs      10. Updated the bisp_select_analyst_sla to remove ('v_psm.assignment', vassignmentgroup) 
                                            from Respond and Restore Analyst                 
    4.1         09.12.08    shw         2. verify 'Secondary' vtarget_metric logic                                                                          
*****************************************************************************/
--
-- Error Handling is done by the report. We do not trap any exceptions at the Database side.
--
/**********************************************************************
    2.7         05.05.08    shw         8. HP SLA Sproc
**************************************************************************/
   PROCEDURE bisp_select_HP_overall_sla (
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
      vRPTGRP            IN       VARCHAR2
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
--        v_select_stmt := v_select_stmt || ' UNION ALL ';
-- Respond Overall
              IF vtarget_metric = 'Primary' THEN
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, v_psm.pfz_respond_sla_user SLA_User, v_psm.pfz_respond_sla Made_Missed,v_psm.pfz_respond_sla_group SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.pfz_respond_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        ELSE
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, NVL(v_psm.PFZ_RESPOND_2ND_TARGET_USER, '''') SLA_User, NVL(v_psm.PFZ_RESPOND_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, '' '') SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
-- v.4.0        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, NVL(v_psm.PFZ_RESPOND_2ND_TARGET_USER SLA_User, ''''), NVL(v_psm.PFZ_RESPOND_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, '' '') SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        END IF;
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time, ';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm INNER JOIN sc.assignmentm1 am1 ON v_psm.pfz_respond_sla_group = am1.name';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_respond_sla_group', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm INNER JOIN sc.assignmentm1 am1 ON v_psm.PFZ_RESPOND_2ND_TARGET_GROUP = am1.name';
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
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
        v_select_stmt := v_select_stmt || ' UNION ALL ';
-- Restore Overall
-- 02.07.08-shw- remove NVL (close_time) from Restore Times)
            IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, v_psm.pfz_restore_sla_user SLA_User, v_psm.pfz_restore_sla Made_Missed,v_psm.pfz_restore_sla_group SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
--02.07.08        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, v_psm.pfz_restore_sla_user SLA_User, v_psm.pfz_restore_sla Made_Missed,v_psm.pfz_restore_sla_group SLA_Group,NVL(bipkg_utils.bifnc_AdjustForTZ(v_psm.pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| '),v_psm.close_time) pfz_sla_time,';
        Else
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, NVL(v_psm.PFZ_RESTORE_2ND_TARGET_USER, '' '') SLA_User, NVL(v_psm.PFZ_RESTORE_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESTORE_2ND_TARGET_GROUP, '' '') SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
-- 02.07.08        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, NVL(v_psm.PFZ_RESTORE_2ND_TARGET_USER, '' '') SLA_User, NVL(v_psm.PFZ_RESTORE_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESTORE_2ND_TARGET_GROUP, '' '') SLA_Group,NVL(bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| '),v_psm.close_time) pfz_sla_time,';
        End If;
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time, ';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm INNER JOIN sc.assignmentm1 am1 ON v_psm.pfz_restore_sla_group = am1.name';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_restore_sla_group', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm INNER JOIN sc.assignmentm1 am1 ON v_psm.PFZ_RESTORE_2ND_TARGET_GROUP = am1.name';
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
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ') AND (';
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
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time, ';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm INNER JOIN sc.assignmentm1 am1 ON v_psm.assignment = am1.name';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.assignment', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm INNER JOIN sc.assignmentm1 am1 ON v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP = am1.name';
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
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
      OPEN overall_sla_cursor FOR v_select_stmt;
   END bisp_select_HP_overall_sla;
/**********************************************************************
    2.7         05.05.08    shw         8. HP SLA Sproc
**************************************************************************/
PROCEDURE bisp_select_HP_sla_Respond (
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
      vRPTGRP            IN       VARCHAR2
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
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time, ';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm INNER JOIN sc.assignmentm1 am1 ON v_psm.pfz_respond_sla_group = am1.name';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_respond_sla_group', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm INNER JOIN sc.assignmentm1 am1 ON v_psm.PFZ_RESPOND_2ND_TARGET_GROUP = am1.name';
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
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
      OPEN overall_sla_cursor FOR v_select_stmt;
   END bisp_select_HP_sla_Respond;
/*************************************************************************
    2.7         05.05.08    shw         8. HP SLA Sproc
**************************************************************************/
   PROCEDURE bisp_select_HP_sla_Restore (
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
      vRPTGRP            IN       VARCHAR2
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
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time, ';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm INNER JOIN sc.assignmentm1 am1 ON v_psm.pfz_restore_sla_group = am1.name';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_restore_sla_group', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm INNER JOIN sc.assignmentm1 am1 ON v_psm.PFZ_RESTORE_2ND_TARGET_GROUP = am1.name';
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
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
      OPEN overall_sla_cursor FOR v_select_stmt;
   END bisp_select_HP_sla_Restore;
/*************************************************************************
    2.7         05.05.08    shw         8. HP SLA Sproc
**************************************************************************/
   PROCEDURE bisp_select_HP_sla_Resolve (
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
      vRPTGRP            IN       VARCHAR2
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
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time,';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm INNER JOIN sc.assignmentm1 am1 ON v_psm.assignment = am1.name';
        v_select_stmt := v_select_stmt || ' WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.assignment', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm INNER JOIN sc.assignmentm1 am1 ON v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP = am1.name';
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
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
      OPEN overall_sla_cursor FOR v_select_stmt;
   END bisp_select_HP_sla_Resolve;

/*************************************************************************
                05.12.08    shw         9. std. SLA sproc: make OPERATORM1V an outer join
**************************************************************************/
   PROCEDURE bisp_select_overall_sla (
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
      vtime              IN       VARCHAR2
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
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name, operatorm1v.full_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time';
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.operatorm1v ON v_psm.pfz_respond_sla_user = operatorm1v.name WHERE (';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_respond_sla_group', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, '' '')', vassignmentgroup) || ')';
        End If;
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed'
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
        v_select_stmt := v_select_stmt || ' UNION ALL ';
            IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, v_psm.pfz_restore_sla_user SLA_User, v_psm.pfz_restore_sla Made_Missed,v_psm.pfz_restore_sla_group SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        Else
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, NVL(v_psm.PFZ_RESTORE_2ND_TARGET_USER, '' '') SLA_User, NVL(v_psm.PFZ_RESTORE_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESTORE_2ND_TARGET_GROUP, '' '') SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        End If;
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name, operatorm1v.full_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time';
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm  LEFT OUTER JOIN sc.operatorm1v ON v_psm.pfz_restore_sla_user = operatorm1v.name WHERE (';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_restore_sla_group', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESTORE_2ND_TARGET_GROUP, '' '')', vassignmentgroup) || ')';
        End If;
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed'
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
        v_select_stmt := v_select_stmt || ' UNION ALL ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESOLVE'|| ''''|| ' SLA_Type, v_psm.assignee_name SLA_User, v_psm.pfz_resolve_sla Made_Missed,v_psm.assignment SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.resolve_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        Else
       v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESOLVE'|| ''''|| ' SLA_Type, v_psm.assignee_name SLA_User, NVL(v_psm.PFZ_RESOLVE_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP, v_psm.assignment) SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.resolve_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
              End If;
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name, operatorm1v.full_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time';
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.operatorm1v ON v_psm.assignee_name = operatorm1v.name WHERE (';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.assignment', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP, '' '')', vassignmentgroup) || ')';
        End If;
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed'
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
      OPEN overall_sla_cursor FOR v_select_stmt;
   END bisp_select_overall_sla;
   /*************************************************************************
                05.12.08    shw         9. std. SLA sproc: make OPERATORM1V an outer join
**************************************************************************/
   PROCEDURE bisp_select_sla_Respond (
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
      vtime              IN       VARCHAR2
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
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name, operatorm1v.full_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time';
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.operatorm1v ON v_psm.pfz_respond_sla_user = operatorm1v.name WHERE (';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_respond_sla_group', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, '' '')', vassignmentgroup) || ')';
        End If;
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed'
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
      OPEN overall_sla_cursor FOR v_select_stmt;
   END bisp_select_sla_Respond;
/*************************************************************************
                05.12.08    shw         9. std. SLA sproc: make OPERATORM1V an outer join
**************************************************************************/
   PROCEDURE bisp_select_sla_Restore (
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
      vtime              IN       VARCHAR2
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
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name, operatorm1v.full_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time';
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm  LEFT OUTER JOIN sc.operatorm1v ON v_psm.pfz_restore_sla_user = operatorm1v.name WHERE (';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_restore_sla_group', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESTORE_2ND_TARGET_GROUP, '' '')', vassignmentgroup) || ')';
        End If;
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed'
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
      OPEN overall_sla_cursor FOR v_select_stmt;
   END bisp_select_sla_Restore;
/*************************************************************************
                05.12.08    shw         9. std. SLA sproc: make OPERATORM1V an outer join
**************************************************************************/
   PROCEDURE bisp_select_sla_Resolve (
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
      vtime              IN       VARCHAR2
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
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name, operatorm1v.full_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_2nd_target_time';
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.operatorm1v ON v_psm.assignee_name = operatorm1v.name WHERE (';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.assignment', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP, '' '')', vassignmentgroup) || ')';
        End If;
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed'
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
      OPEN overall_sla_cursor FOR v_select_stmt;
   END bisp_select_sla_Resolve;


/*************************************************************************
1.0       03.01.07       sg       1. Created bisp_select_analyst_sla
2.0           10.02.07        shw            1. Upgrade for GAMPS - new fields
2.1           10.10.07        shw            2. Upgrade for GAMPS - new parameters
2.2         11.17.07    shw         3. Upgrade to view vs. table(s)
**************************************************************************/
   PROCEDURE bisp_select_analyst_sla (
      analyst_sla_cursor         IN OUT   bisp_refcursor_type,
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
      vtime              IN       VARCHAR2
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
   BEGIN

      vfromtz := 'GMT';
      Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, ZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
      v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
      v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');

-- Respond Analyst
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, v_psm.pfz_respond_sla_user SLA_User, v_psm.pfz_respond_sla Made_Missed,v_psm.pfz_respond_sla_group SLA_Group,bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        Else
        v_select_stmt := ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, v_psm.pfz_respond_sla_user SLA_User, NVL(v_psm.PFZ_RESPOND_2ND_TARGET, '' '') Made_Missed,NVL(v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, '' '') SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        End If;
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name, operatorm1v.full_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE';
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.operatorm1v ON v_psm.pfz_respond_sla_user = operatorm1v.name WHERE (';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.pfz_respond_sla_group, '' '')', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, '' '')', vassignmentgroup) || ')';
        End If;
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.open_group, '' '')', vorig_group)  || ')';
                IF vtime = 'Closed'
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.category', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.opened_by, '' '')', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.resolution_code, '' '')', vresolution)|| ')';
        v_select_stmt := v_select_stmt || ' UNION ALL ';
-- Restore Analyst
           IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, v_psm.pfz_restore_sla_user SLA_User, v_psm.pfz_restore_sla Made_Missed,v_psm.pfz_restore_sla_group SLA_Group,NVL(bipkg_utils.bifnc_AdjustForTZ(pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| '),v_psm.close_time) pfz_sla_time,';
        Else
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, v_psm.pfz_restore_sla_user SLA_User, NVL(v_psm.PFZ_RESTORE_2ND_TARGET, '' '') Made_Missed, NVL(v_psm.PFZ_RESTORE_2ND_TARGET_GROUP, '' '') SLA_Group,NVL(bipkg_utils.bifnc_AdjustForTZ(pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| '),v_psm.close_time) pfz_sla_time,';
        End If;
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name, NVL(operatorm1v.full_name, v_psm.assignee_name) full_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESTORE_2ND_TARGET,v_psm.PFZ_RESTORE_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE';
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.operatorm1v ON v_psm.pfz_restore_sla_user = operatorm1v.name WHERE (';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.pfz_restore_sla_group, '' '')', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESTORE_2ND_TARGET_GROUP, '' '')', vassignmentgroup) || ')';
        End If;
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.open_group, '' '')', vorig_group)  || ')';
                IF vtime = 'Closed'
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.category', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.opened_by, '' '')', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.resolution_code, '' '')', vresolution)|| ')';
        v_select_stmt := v_select_stmt || ' UNION ALL ';
--Resolve Analyst
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESOLVE'|| ''''|| ' SLA_Type, v_psm.assignee_name SLA_User, v_psm.pfz_resolve_sla Made_Missed,v_psm.assignment SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        Else
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESOLVE'|| ''''|| ' SLA_Type, v_psm.assignee_name SLA_User, NVL(v_psm.PFZ_RESOLVE_2ND_TARGET, '' '') Made_Missed, NVL(v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP, v_psm.assignment) SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        End If;
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name, operatorm1v.full_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESOLVE_2ND_TARGET,v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE';
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.operatorm1v ON v_psm.assignee_name = operatorm1v.name WHERE (';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.assignment, '' '')', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP, v_psm.assignment)', vassignmentgroup) || ')';
        End If;
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.open_group, '' '')', vorig_group)  || ')';
                IF vtime = 'Closed'
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.category', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.opened_by, '' '')', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.resolution_code, '' '')', vresolution)|| ')';

      OPEN analyst_sla_cursor FOR v_select_stmt;
   END bisp_select_analyst_sla;
/*************************************************************************
1.0       03.12.07       sg       1. Created bisp_respond_resolve_sla
2.0           10.02.07        shw            1. Upgrade for GAMPS - new fields
2.1           10.10.07        shw            2. Upgrade for GAMPS - new parameters
2.2         11.17.07    shw         3. Upgrade to view vs. table(s)
**************************************************************************/
   PROCEDURE bisp_resolve_sla (
      resolve_sla_cursor         IN OUT   bisp_refcursor_type,
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
      vtarget_metric     IN       VARCHAR2
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
   BEGIN

      vfromtz := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, ZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');

              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := 'SELECT ''RESOLVE'' SLA_Type, v_psm.pfz_respond_sla_user, v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,''' || vfromtz || ''' , ''' || ZONE || ''') pfz_respond_sla_time,';
        Else
        v_select_stmt := 'SELECT ''RESOLVE'' SLA_Type, v_psm.pfz_respond_sla_user, NVL(v_psm.PFZ_RESPOND_2ND_TARGET, '' ''), NVL(v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, v_psm.pfz_respond_sla_group), bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,''' || vfromtz || ''' , ''' || ZONE || ''') pfz_respond_sla_time,';
        End If;
        v_select_stmt := v_select_stmt || ' v_psm.pfz_resolve_sla, bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,''' || vfromtz|| ''' , ''' || ZONE || ''') close_time,';
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name, operatorm1v.full_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group, v_psm.country, v_psm.flag, v_psm.last_activity, v_psm.LOCATION, v_psm.numberprgn, v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time, ''' || vfromtz|| ''' , ''' || ZONE || ''') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time, '''|| vfromtz || ''' , ''' || ZONE|| ''') update_time,v_psm.update_action, ''' || v_startdatedisplay || ''' StartDateDisplay , ''' || v_enddatedisplay || ''' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE';
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.operatorm1v ON v_psm.assignee_name = operatorm1v.name WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.assignment, '' '')', vassignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.open_group, '' '')', vorig_group)  || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.category', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.opened_by, '' '')', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.resolution_code, '' '')', vresolution)|| ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.flag = ''f''';

      OPEN resolve_sla_cursor FOR v_select_stmt;
   END bisp_resolve_sla;

/***********************************************************
    1.0           12.07.06        shw            1. select CI Location - new fields
2.1           10.10.07        shw            2. Upgrade for GAMPS - new parameters
2.2         11.17.07    shw         3. Upgrade to view vs. table(s)
***********************************************************/

   PROCEDURE bisp_select_sla_by_ci_location (
      generic_sla_cursor         IN OUT   bisp_refcursor_type,
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
      vtime              IN       VARCHAR2
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
        v_select_stmt := ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, v_psm.pfz_respond_sla_user SLA_User, v_psm.pfz_respond_sla Made_Missed,v_psm.pfz_respond_sla_group SLA_Group,bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        Else
        v_select_stmt := ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, v_psm.pfz_respond_sla_user SLA_User, NVL(v_psm.PFZ_RESPOND_2ND_TARGET, '' '') Made_Missed, NVL(v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, '' '') SLA_Group,bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        End If;
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name, operatorm1v.full_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action, DeviceM1.LOCATION ci_location, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE';
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.operatorm1v ON v_psm.pfz_respond_sla_user = operatorm1v.name ';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN DeviceM1 ON v_psm.LOCATION = DeviceM1.LOCATION ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' WHERE ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_respond_sla_group', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' WHERE ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.PFZ_RESPOND_2ND_TARGET_GROUP', vassignmentgroup) || ')';
        End If;
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed'
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('DeviceM1.LOCATION', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.PRIORITY', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.category', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
          v_select_stmt := v_select_stmt || ' UNION ALL ';

              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, v_psm.pfz_restore_sla_user SLA_User, v_psm.pfz_restore_sla Made_Missed,v_psm.pfz_restore_sla_group SLA_Group,NVL(bipkg_utils.bifnc_AdjustForTZ(pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| '),v_psm.close_time) pfz_sla_time,';
        Else
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, v_psm.pfz_restore_sla_user SLA_User, NVL(v_psm.PFZ_RESTORE_2ND_TARGET, '' '') Made_Missed, NVL(v_psm.PFZ_RESTORE_2ND_TARGET_GROUP, '' '') SLA_Group,NVL(bipkg_utils.bifnc_AdjustForTZ(pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| '),v_psm.close_time) pfz_sla_time,';
        End If;
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name, NVL(operatorm1v.full_name, v_psm.assignee_name) full_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action, DeviceM1.LOCATION ci_location, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESTORE_2ND_TARGET,v_psm.PFZ_RESTORE_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE';
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.operatorm1v ON v_psm.pfz_restore_sla_user = operatorm1v.name ';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN DeviceM1 ON v_psm.LOCATION = DeviceM1.LOCATION ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' WHERE ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_restore_sla_group', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' WHERE ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.PFZ_RESTORE_2ND_TARGET_GROUP', vassignmentgroup) || ')';
        End If;
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed'
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('DeviceM1.LOCATION', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.PRIORITY', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.category', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';
        v_select_stmt := v_select_stmt || ' UNION ALL ';

              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESOLVE'|| ''''|| ' SLA_Type, v_psm.assignee_name SLA_User, v_psm.pfz_resolve_sla Made_Missed,v_psm.assignment SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        Else
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESOLVE'|| ''''|| ' SLA_Type, v_psm.assignee_name SLA_User, NVL(v_psm.PFZ_RESOLVE_2ND_TARGET, '' '') Made_Missed, NVL(v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP, v_psm.assignment) SLA_Group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
        End
        If;
        v_select_stmt := v_select_stmt || ' v_psm.action, v_psm.assignment,v_psm.assignee_name, operatorm1v.full_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action, DeviceM1.LOCATION ci_location, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESOLVE_2ND_TARGET,v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE';
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.operatorm1v ON v_psm.assignee_name = operatorm1v.name ';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN DeviceM1 ON v_psm.LOCATION = DeviceM1.LOCATION ';
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := v_select_stmt || ' WHERE ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.assignment', vassignmentgroup) || ')';
        Else
        v_select_stmt := v_select_stmt || ' WHERE ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.PFZ_RESOLVE_2ND_TARGET_GROUP', vassignmentgroup) || ')';
        End If;
        v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
                IF vtime = 'Closed'
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        End If;
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('DeviceM1.LOCATION', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.PRIORITY', vpriority)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.category', vinteraction_type)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', vopened_by)|| ') AND NOT(';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', vresolution)|| ')';

      OPEN generic_sla_cursor FOR v_select_stmt;
   END bisp_select_sla_by_ci_location;


/***********************************************************
    1.0           12.07.06        shw            1. select site Location - new fields
2.1           10.10.07        shw            2. Upgrade for GAMPS - new parameters
2.2         11.17.07    shw         3. Upgrade to view vs. table(s)
***********************************************************/
   PROCEDURE bisp_select_sla_by_loc (
      sla_by_loc_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      vpriority          IN       VARCHAR2,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2
   )
   AS
      vfromtz              VARCHAR2 (3);
      v_startdatedisplay   VARCHAR (50);
      v_enddatedisplay     VARCHAR (50);
      v_gmt_startdate      DATE;
      v_gmt_enddate         DATE;
      v_gmt_startdate_str  VARCHAR2 (19);
      v_gmt_enddate_str       VARCHAR2 (19);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
      vfromtz := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, ZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');

        v_select_stmt := 'SELECT  v_psm.action, v_psm.assignment,v_psm.assignee_name, operatorm1v.full_name,v_psm.brief_description,v_psm.closed_by, v_psm.closed_group,bipkg_utils.bifnc_AdjustForTZ(v_psm.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, v_psm.country,v_psm.flag, v_psm.last_activity,v_psm.LOCATION, v_psm.numberprgn,v_psm.open_group, bipkg_utils.bifnc_AdjustForTZ(v_psm.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,v_psm.opened_by, v_psm.pfz_bu,v_psm.pfz_call_source, v_psm.pfz_division,v_psm.pfz_full_name, v_psm.pfz_resolve_sla,v_psm.pfz_respond_sla,v_psm.pfz_respond_sla_group,v_psm.pfz_restore_sla, v_psm.pfz_resolve_sla,v_psm.pfz_sla_title,v_psm.pfz_total_time_spent,v_psm.priority_code, v_psm.problem_type,v_psm.product_type, v_psm.resolution_code,v_psm.resolution, v_psm.status,v_psm.updated_by, bipkg_utils.bifnc_AdjustForTZ(v_psm.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,v_psm.update_action,v_psm.pfz_respond_sla_user, v_psm.pfz_restore_sla_user,v_psm.pfz_restore_sla_group, v_psm.pfz_resolve_sla_group,bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_sla_time,bipkg_utils.bifnc_AdjustForTZ(pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_sla_time,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.respond_to_onsite,v_psm.user_priority,v_psm.pfz_sla_schedule,v_psm.pfz_resolve_ola,v_psm.resolve_time,v_psm.respond_time,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,v_psm.PFZ_RESPOND_2ND_TARGET_TIME,v_psm.PFZ_RESTORE_2ND_TARGET_USER,v_psm.PFZ_RESTORE_2ND_TARGET_TIME';
        v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm LEFT OUTER JOIN sc.operatorm1v ON v_psm.pfz_respond_sla_user = operatorm1v.name WHERE (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.pfz_respond_sla_group', vassignmentgroup) || ')';
        v_select_stmt := v_select_stmt ||'AND ('|| Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', vorig_group)  || ')';
        v_select_stmt := v_select_stmt ||'AND v_psm.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.LOCATION', vlocation)|| ') AND (';
        v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('v_psm.PRIORITY', vpriority)|| ')';

      OPEN sla_by_loc_cursor FOR v_select_stmt;

   END bisp_select_sla_by_loc;

END BIPKG_GvR_Select_Sla;
/

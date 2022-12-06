CREATE OR REPLACE PACKAGE BIPKG_GV_CLOCKS AS
/******************************************************************************
   NAME:       BIPKG_GV_CLOCKS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/24/2008     -shw-        1. Created this package.
   2.0        04/21/2008    -shw-       2. Build derived columns for all 'clocksM1' "Pending" categories,
                                            calculated in Hours.   
******************************************************************************/
   TYPE bisp_refcursor_type IS REF CURSOR;

   PROCEDURE bisp_select_Clocks (
      overall_clocks_cursor         IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      ppriority          IN       VARCHAR2,
      plocation          IN       VARCHAR2,
      presolution        IN       VARCHAR2,
      popened_by         IN       VARCHAR2,
      pvendor            IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pinteraction_type  IN       VARCHAR2,
      ptime              IN       VARCHAR2
   );

END BIPKG_GV_CLOCKS;
/
CREATE OR REPLACE PACKAGE BODY Bipkg_GV_Clocks
AS
/******************************************************************************
   NAME:       BIPKG_GV_CLOCKS  
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/24/2008     -shw-        1. Created this package.
   2.0        04/21/2008    -shw-       2. Build derived columns for all 'clocksM1' "Pending" categories,
                                            calculated in Hours.   
******************************************************************************/
   PROCEDURE bisp_select_Clocks (
      overall_clocks_cursor         IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      ppriority          IN       VARCHAR2,
      plocation          IN       VARCHAR2,
      presolution        IN       VARCHAR2,
      popened_by         IN       VARCHAR2,
      pvendor            IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pinteraction_type  IN       VARCHAR2,
      ptime              IN       VARCHAR2
   )
   IS
          v_select_stmt        VARCHAR2(32767);
          v_startdatedisplay   VARCHAR2(50);
          v_enddatedisplay     VARCHAR2(50);
          v_db_zone            VARCHAR2(10);      
          v_gmt_startdate      DATE;
          v_gmt_enddate        DATE;

   BEGIN
        v_db_zone := 'GMT';      
        bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');

      v_select_stmt := 'SELECT' 
      || ' am1.PFZ_REPORTING_GROUP, am1.PFZ_SERVICE_TOWER, am1.PFZ_VENDOR,'
      || ' (select ((total - to_date('|| '''' || '4000, 01, 01, 00, 00, 00' || ''''||','|| ''''|| 'YYYY, MM, DD, HH24:MI:SS' ||''''||'))  * 24) '
      || ' from sc.clocksm1 cm1 where cm1.key_char = v_psm.numberprgn and cm1.NAME = ' || '''' || 'Pending Customer' || '''' || ') Pending_Customer_Hours, ' 
      || ' (select ((total - to_date('|| '''' || '4000, 01, 01, 00, 00, 00' || '''' || ',' || '''' || 'YYYY, MM, DD, HH24:MI:SS' ||''''||'))  * 24) '
      || ' from sc.clocksm1 cm1 where cm1.key_char = v_psm.numberprgn and cm1.NAME = ' || '''' || 'Pending Pfizer' || '''' || ') Pending_Pfizer_Hours, '
      || ' (select ((total - to_date('|| '''' || '4000, 01, 01, 00, 00, 00' || '''' || ',' || '''' || 'YYYY, MM, DD, HH24:MI:SS' ||''''||'))  * 24) '
      || ' from sc.clocksm1 cm1 where cm1.key_char = v_psm.numberprgn and cm1.NAME = ' || '''' || 'Pending Part' || '''' || ') Pending_Part_Hours, '
      || ' (select ((total - to_date('|| '''' || '4000, 01, 01, 00, 00, 00' || '''' || ',' || '''' || 'YYYY, MM, DD, HH24:MI:SS' ||''''||'))  * 24) '
      || ' from sc.clocksm1 cm1 where cm1.key_char = v_psm.numberprgn and cm1.NAME = ' || '''' || 'Pending RFC' || '''' || ') Pending_RFC_Hours, '
      || ' (select ((total - to_date('|| '''' || '4000, 01, 01, 00, 00, 00' || '''' || ',' || '''' || 'YYYY, MM, DD, HH24:MI:SS' ||''''||'))  * 24) '
      || ' from sc.clocksm1 cm1 where cm1.key_char = v_psm.numberprgn and cm1.NAME = ' || '''' || 'Pending Vendor' || '''' || ') Pending_Vendor_Hours, '
      || ' (select ((total - to_date('|| '''' || '4000, 01, 01, 00, 00, 00' || '''' || ',' || '''' || 'YYYY, MM, DD, HH24:MI:SS' ||''''||'))  * 24) '
      || ' from sc.clocksm1 cm1 where cm1.key_char = v_psm.numberprgn and cm1.NAME = ' || '''' || 'Work in progress' || '''' || ') Work_in_progress_Hours, '
      || ' operatorm1v.full_name,'      
      || ' v_psm.action, v_psm.assignment, v_psm.assignee_name, v_psm.brief_description,'
      || ' v_psm.category, v_psm.closed_by, v_psm.closed_group,'
      || ' bipkg_utils.bifnc_adjustfortz(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time,'    
      || ' v_psm.country, v_psm.flag, v_psm.last_activity, v_psm.location,'
      || ' v_psm.numberprgn, v_psm.open_group,'
      || ' bipkg_utils.bifnc_adjustfortz(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,'    
      || ' v_psm.opened_by, v_psm.pfz_bu, v_psm.pfz_call_source, v_psm.pfz_country_impacted,'
      || ' v_psm.pfz_division, v_psm.pfz_full_name, v_psm.pfz_impact, v_psm.pfz_product_subtype,'
      || ' v_psm.PFZ_RESPOND_2ND_TARGET, v_psm.PFZ_RESPOND_2ND_TARGET_GROUP, v_psm.PFZ_RESPOND_2ND_TARGET_USER,'
      || ' bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| v_db_zone || ''''|| ','|| ''''|| pzone|| ''''|| ') respond_2nd_target_sla_time,'
      || ' v_psm.pfz_respond_sla, v_psm.pfz_respond_sla_group, v_psm.pfz_respond_sla_user,'
      || ' bipkg_utils.bifnc_adjustfortz(v_psm.pfz_respond_sla_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') pfz_respond_sla_time,'    
      || ' v_psm.PFZ_RESTORE_2ND_TARGET, v_psm.PFZ_RESTORE_2ND_TARGET_GROUP, v_psm.PFZ_RESTORE_2ND_TARGET_USER,'
      || ' bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| v_db_zone || ''''|| ','|| ''''|| pzone|| ''''|| ') restore_2nd_target_sla_time,'
      || ' v_psm.pfz_restore_sla, v_psm.pfz_restore_sla_group, v_psm.pfz_restore_sla_user,'
      || ' bipkg_utils.bifnc_adjustfortz(v_psm.pfz_restore_sla_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') pfz_restore_sla_time,'    
      || ' v_psm.pfz_sla_title, v_psm.pfz_total_time_spent,'
      || ' v_psm.priority, v_psm.priority_code,'
      || ' v_psm.problem_type, v_psm.product_type,'
      || ' v_psm.resolution_code, v_psm.resolution,'
      || ' bipkg_utils.bifnc_adjustfortz(v_psm.resolve_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') resolve_time,'    
      || ' bipkg_utils.bifnc_adjustfortz(v_psm.respond_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') respond_time,'    
      || ' v_psm.status, v_psm.updated_by,'
      || ' bipkg_utils.bifnc_adjustfortz(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time,'
      || ' v_psm.update_action, v_psm.user_priority,'
      || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay '
      || ' FROM' 
      || ' sc.v_probsummary v_psm '
      || ' INNER JOIN sc.operatorm1v ON v_psm.updated_by = operatorm1v.name'  
      || ' INNER JOIN sc.assignmentm1 am1 ON v_psm.assignment = am1.name'  
      || ' WHERE 1=1 ';
      
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', pinteraction_type)|| ') ';
                IF ptime = 'Closed' 
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND v_psm.flag = ' || '''' || 'f' || '''' || ''; 
            Else
        v_select_stmt := v_select_stmt || ' AND v_psm.resolve_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.resolve_time < ' || '''' || v_gmt_enddate || '''' ;
            End If;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('am1.PFZ_VENDOR', pvendor) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.LOCATION, '' '')', plocation)|| ') ';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('v_psm.priority', ppriority) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('v_psm.opened_by', popened_by)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('v_psm.resolution_code', presolution)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', porig_group)  || ')';
--        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('cm1.name', pclock_type)  || ')';

      OPEN overall_clocks_cursor FOR v_select_stmt;
      
   END bisp_select_Clocks;
   
END Bipkg_GV_Clocks;
/

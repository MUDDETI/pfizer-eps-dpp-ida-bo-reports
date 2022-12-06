CREATE OR REPLACE PACKAGE Bisp_Select_Sla
AS
/******************************************************************************
   NAME:       bisp_select_SLA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/10/2006    shw         1. Created this package for generic 
   			  							   SLA reports .						   
	1.0		   12.07.06		shw			1. select CI Location
******************************************************************************/
   TYPE bisp_refcursor_type IS REF CURSOR;

   PROCEDURE bisp_select_generic_sla (
      generic_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
	  vresolution		 IN		  VARCHAR2,
	  vopened_by		 IN		  VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2
   );
   
   PROCEDURE bisp_select_overall_sla (
      overall_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
	  vresolution		 IN		  VARCHAR2,
	  vopened_by		 IN		  VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2
   );
   PROCEDURE bisp_select_analyst_sla (
      analyst_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
	  vresolution		 IN		  VARCHAR2,
	  vopened_by		 IN		  VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2
   );
   PROCEDURE bisp_resolve_sla (
      resolve_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
	  vresolution		 IN		  VARCHAR2,
	  vopened_by		 IN		  VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2
   );
   PROCEDURE bisp_select_sla_by_ci_location (
      generic_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
	  vresolution		 IN		  VARCHAR2,
	  vopened_by		 IN		  VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
      frequency          IN       VARCHAR2,
      override           IN       VARCHAR2,
      ZONE               IN       VARCHAR2
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

END Bisp_Select_Sla;
/
CREATE OR REPLACE PACKAGE BODY Bisp_Select_Sla
AS
/******************************************************************************
   NAME:       bisp_select_generic_sla
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/15/2006    shw         1. Stored Procedure for ALL sla reports
   			  							   which qualify by client Location. 
	1.0		   07/25/06     shw			1. Generic SLA recordset extract. 
	1.1		   08/15/06		shw			2. Generic SLA: Needed NVL on RESTORE for Date and Analyst 
	1.0		   12.07.06		shw			1. select CI Location 
	1.0		   01.31.07		shw			3. Generic SLA: mods to 'Respond,Restore' logic 
******************************************************************************/
--
-- Error Handling is done by the report. We do not trap any exceptions at the Database side.
--
   PROCEDURE bisp_select_generic_sla (
      generic_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
	  vresolution		 IN		  VARCHAR2,
	  vopened_by		 IN		  VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
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
	  v_gmt_enddate_str	   VARCHAR2 (19);		  
      v_select_stmt        VARCHAR2 (32767);
	  v_whereclause		   VARCHAR2 (32767);
   BEGIN
   
-- 01.31.07-shw- Expanded to two Respond & Restore selects, one for (A)nalyst, one for (O)verall  
  
        vfromtz := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, ZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
		
-- Respond Analyst 
        v_select_stmt := ' SELECT  '||''''||'RESPONDA'|| ''''|| ' SLA_Type, probsummarym2.pfz_respond_sla_user SLA_User, probsummarym1.pfz_respond_sla Made_Missed,probsummarym1.pfz_respond_sla_group SLA_Group,bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, operatorm1v.full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn INNER JOIN operatorm1v ON probsummarym2.pfz_respond_sla_user = operatorm1v.name WHERE (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_respond_sla_group', vassignmentgroup) || ')';
    	v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.assignment', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.LOCATION', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.opened_by', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.resolution_code', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || '';		
  	    v_select_stmt := v_select_stmt || ' UNION ALL ';
-- Respond Overall 
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESPONDO'|| ''''|| ' SLA_Type, probsummarym2.pfz_respond_sla_user SLA_User, probsummarym1.pfz_respond_sla Made_Missed,probsummarym1.pfz_respond_sla_group SLA_Group,bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, operatorm1v.full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn INNER JOIN operatorm1v ON probsummarym2.pfz_respond_sla_user = operatorm1v.name WHERE (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_respond_sla_group', vassignmentgroup) || ')';
--01.31.07			v_select_stmt := v_select_stmt || ' AND ('|| bipkg_utils.bifnc_createinlist ('probsummarym1.assignment', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.LOCATION', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.opened_by', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.resolution_code', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || '';		
  	    v_select_stmt := v_select_stmt || ' UNION ALL ';
-- Restore Analyst 
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTOREA'|| ''''|| ' SLA_Type, probsummarym2.pfz_restore_sla_user SLA_User, probsummarym1.pfz_restore_sla Made_Missed,probsummarym2.pfz_restore_sla_group SLA_Group,NVL(bipkg_utils.bifnc_AdjustForTZ(pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| '),probsummarym1.close_time) pfz_sla_time,';
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, NVL(operatorm1v.full_name, probsummarym1.assignee_name) full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn LEFT OUTER JOIN operatorm1v ON probsummarym2.pfz_restore_sla_user = operatorm1v.name WHERE (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym2.pfz_restore_sla_group', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.assignment', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.LOCATION', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.opened_by', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.resolution_code', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || '';		
		v_select_stmt := v_select_stmt || ' UNION ALL ';
-- Restore Overall 
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTOREO'|| ''''|| ' SLA_Type, probsummarym2.pfz_restore_sla_user SLA_User, probsummarym1.pfz_restore_sla Made_Missed,probsummarym2.pfz_restore_sla_group SLA_Group,NVL(bipkg_utils.bifnc_AdjustForTZ(pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| '),probsummarym1.close_time) pfz_sla_time,';
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, NVL(operatorm1v.full_name, probsummarym1.assignee_name) full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn LEFT OUTER JOIN operatorm1v ON probsummarym2.pfz_restore_sla_user = operatorm1v.name WHERE (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym2.pfz_restore_sla_group', vassignmentgroup) || ')';
-- 01.31.07 		v_select_stmt := v_select_stmt || ' AND ('|| bipkg_utils.bifnc_createinlist ('probsummarym1.assignment', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.LOCATION', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.opened_by', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.resolution_code', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || '';		
		v_select_stmt := v_select_stmt || ' UNION ALL ';

        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESOLVE'|| ''''|| ' SLA_Type, probsummarym1.assignee_name SLA_User, probsummarym1.pfz_resolve_sla Made_Missed,probsummarym1.assignment SLA_Group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, operatorm1v.full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn INNER JOIN operatorm1v ON probsummarym1.assignee_name = operatorm1v.name WHERE (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.assignment', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.LOCATION', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.opened_by', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.resolution_code', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || '';		
		
      OPEN generic_sla_cursor FOR v_select_stmt;
   END bisp_select_generic_sla;
/************************************************************************* 
1.0       03.01.07       sg       1. Created bisp_select_overall_sla
**************************************************************************/
   PROCEDURE bisp_select_overall_sla (
      overall_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
	  vresolution		 IN		  VARCHAR2,
	  vopened_by		 IN		  VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
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
	  v_gmt_enddate_str	   VARCHAR2 (19);		  
      v_select_stmt        VARCHAR2 (32767);
	  v_whereclause		   VARCHAR2 (32767);
   BEGIN
   
      vfromtz := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, ZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
	  v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');
-- Respond Overall 
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, probsummarym2.pfz_respond_sla_user SLA_User, probsummarym1.pfz_respond_sla Made_Missed,probsummarym1.pfz_respond_sla_group SLA_Group,bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, operatorm1v.full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn INNER JOIN operatorm1v ON probsummarym2.pfz_respond_sla_user = operatorm1v.name WHERE (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_respond_sla_group', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.LOCATION', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.opened_by', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.resolution_code', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || '';		
  	    v_select_stmt := v_select_stmt || ' UNION ALL ';
-- Restore Overall 
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, probsummarym2.pfz_restore_sla_user SLA_User, probsummarym1.pfz_restore_sla Made_Missed,probsummarym2.pfz_restore_sla_group SLA_Group,NVL(bipkg_utils.bifnc_AdjustForTZ(pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| '),probsummarym1.close_time) pfz_sla_time,';
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, NVL(operatorm1v.full_name, probsummarym1.assignee_name) full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn LEFT OUTER JOIN operatorm1v ON probsummarym2.pfz_restore_sla_user = operatorm1v.name WHERE (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym2.pfz_restore_sla_group', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.LOCATION', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.opened_by', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.resolution_code', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || '';		
		v_select_stmt := v_select_stmt || ' UNION ALL ';
-- Resolve Overall 
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESOLVE'|| ''''|| ' SLA_Type, probsummarym1.assignee_name SLA_User, probsummarym1.pfz_resolve_sla Made_Missed,probsummarym1.assignment SLA_Group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, operatorm1v.full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn INNER JOIN operatorm1v ON probsummarym1.assignee_name = operatorm1v.name WHERE (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.assignment', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.LOCATION', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.opened_by', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.resolution_code', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || '';				
      OPEN overall_sla_cursor FOR v_select_stmt;
   END bisp_select_overall_sla;
/************************************************************************* 
1.0       03.01.07       sg       1. Created bisp_select_analyst_sla
**************************************************************************/
   PROCEDURE bisp_select_analyst_sla (
      analyst_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
	  vresolution		 IN		  VARCHAR2,
	  vopened_by		 IN		  VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
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
	  v_gmt_enddate_str	   VARCHAR2 (19);	  
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
    
      vfromtz := 'GMT';
	  Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, ZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
	  v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
	  v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
	  v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');
	  
-- Respond Analyst
        v_select_stmt := ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, probsummarym2.pfz_respond_sla_user SLA_User, probsummarym1.pfz_respond_sla Made_Missed,probsummarym1.pfz_respond_sla_group SLA_Group,bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, operatorm1v.full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn INNER JOIN operatorm1v ON probsummarym2.pfz_respond_sla_user = operatorm1v.name WHERE (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.pfz_respond_sla_group, '' '')', vassignmentgroup) || ')';
    	v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.assignment, '' '')', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.open_group, '' '')', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.LOCATION, '' '')', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.pfz_sla_title, '' '')', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.opened_by, '' '')', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.resolution_code, '' '')', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ''f''';		
  	    v_select_stmt := v_select_stmt || ' UNION ALL ';
-- Restore Analyst 
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, probsummarym2.pfz_restore_sla_user SLA_User, probsummarym1.pfz_restore_sla Made_Missed,probsummarym2.pfz_restore_sla_group SLA_Group,NVL(bipkg_utils.bifnc_AdjustForTZ(pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| '),probsummarym1.close_time) pfz_sla_time,';
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, NVL(operatorm1v.full_name, probsummarym1.assignee_name) full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn LEFT OUTER JOIN operatorm1v ON probsummarym2.pfz_restore_sla_user = operatorm1v.name WHERE (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym2.pfz_restore_sla_group, '' '')', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.assignment, '' '')', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.open_group, '' '')', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.LOCATION, '' '')', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.pfz_sla_title, '' '')', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.opened_by, '' '')', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.resolution_code, '' '')', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ''f''';		
		v_select_stmt := v_select_stmt || ' UNION ALL ';
--Resolve Analyst
        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESOLVE'|| ''''|| ' SLA_Type, probsummarym1.assignee_name SLA_User, probsummarym1.pfz_resolve_sla Made_Missed,probsummarym1.assignment SLA_Group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, operatorm1v.full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn INNER JOIN operatorm1v ON probsummarym1.assignee_name = operatorm1v.name WHERE (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.assignment, '' '')', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.open_group, '' '')', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.LOCATION, '' '')', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.pfz_sla_title, '' '')', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.opened_by, '' '')', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.resolution_code, '' '')', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ''f''';		
		
      OPEN analyst_sla_cursor FOR v_select_stmt;
   END bisp_select_analyst_sla;
/************************************************************************* 
1.0       03.12.07       sg       1. Created bisp_respond_resolve_sla
**************************************************************************/
   PROCEDURE bisp_resolve_sla (
      resolve_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
	  vresolution		 IN		  VARCHAR2,
	  vopened_by		 IN		  VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
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
	  v_gmt_enddate_str	   VARCHAR2 (19);		  
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
    
      vfromtz := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, ZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
	  v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');
	  		
		v_select_stmt := 'SELECT ''RESOLVE'' SLA_Type, probsummarym2.pfz_respond_sla_user, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,''' || vfromtz || ''' , ''' || ZONE || ''') pfz_respond_sla_time,';
        v_select_stmt := v_select_stmt || ' probsummarym1.pfz_resolve_sla, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,''' || vfromtz|| ''' , ''' || ZONE || ''') close_time,';		        				 
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, operatorm1v.full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group, probsummarym1.country, probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time, ''' || vfromtz|| ''' , ''' || ZONE || ''') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time, '''|| vfromtz || ''' , ''' || ZONE|| ''') update_time,probsummarym1.update_action, ''' || v_startdatedisplay || ''' StartDateDisplay , ''' || v_enddatedisplay || ''' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn INNER JOIN operatorm1v ON probsummarym1.assignee_name = operatorm1v.name WHERE (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.assignment, '' '')', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.open_group, '' '')', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.LOCATION, '' '')', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.pfz_sla_title, '' '')', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.opened_by, '' '')', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('NVL(probsummarym1.resolution_code, '' '')', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ''f''';
		
      OPEN resolve_sla_cursor FOR v_select_stmt;
   END bisp_resolve_sla;
   
/*********************************************************** 
	1.0		   12.07.06		shw			1. select CI Location 
***********************************************************/
   
   PROCEDURE bisp_select_sla_by_ci_location (
      generic_sla_cursor         IN OUT   bisp_refcursor_type,
      vassignmentgroup   IN       VARCHAR2,
      vorig_group        IN       VARCHAR2,
      vpriority          IN       VARCHAR2,
      vlocation          IN       VARCHAR2,
	  vresolution		 IN		  VARCHAR2,
	  vopened_by		 IN		  VARCHAR2,
      dstartdate         IN       DATE,
      denddate           IN       DATE,
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
	  v_gmt_enddate_str	   VARCHAR2 (19);		  
      v_select_stmt        VARCHAR2 (32767);
	  v_whereclause		   VARCHAR2 (32767);
   BEGIN
      vfromtz := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, ZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
	  v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');
	  		
        v_select_stmt := ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, probsummarym2.pfz_respond_sla_user SLA_User, probsummarym1.pfz_respond_sla Made_Missed,probsummarym1.pfz_respond_sla_group SLA_Group,bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, operatorm1v.full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action, DeviceM1.LOCATION ci_location, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn INNER JOIN operatorm1v ON probsummarym2.pfz_respond_sla_user = operatorm1v.name ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN DeviceM1 ON probsummarym1.LOCATION = DeviceM1.LOCATION ';
		v_select_stmt := v_select_stmt || ' WHERE ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_respond_sla_group', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.assignment', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('DeviceM1.LOCATION', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.opened_by', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.resolution_code', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || '';		
  	    v_select_stmt := v_select_stmt || ' UNION ALL ';

        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESTORE'|| ''''|| ' SLA_Type, probsummarym2.pfz_restore_sla_user SLA_User, probsummarym1.pfz_restore_sla Made_Missed,probsummarym2.pfz_restore_sla_group SLA_Group,NVL(bipkg_utils.bifnc_AdjustForTZ(pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| '),probsummarym1.close_time) pfz_sla_time,';
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, NVL(operatorm1v.full_name, probsummarym1.assignee_name) full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action, DeviceM1.LOCATION ci_location, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn LEFT OUTER JOIN operatorm1v ON probsummarym2.pfz_restore_sla_user = operatorm1v.name ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN DeviceM1 ON probsummarym1.LOCATION = DeviceM1.LOCATION ';
		v_select_stmt := v_select_stmt || ' WHERE ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym2.pfz_restore_sla_group', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.assignment', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('DeviceM1.LOCATION', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.opened_by', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.resolution_code', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || '';		
		v_select_stmt := v_select_stmt || ' UNION ALL ';

        v_select_stmt := v_select_stmt || ' SELECT  '||''''||'RESOLVE'|| ''''|| ' SLA_Type, probsummarym1.assignee_name SLA_User, probsummarym1.pfz_resolve_sla Made_Missed,probsummarym1.assignment SLA_Group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_sla_time,';
		v_select_stmt := v_select_stmt || ' probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, operatorm1v.full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action, DeviceM1.LOCATION ci_location, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn INNER JOIN operatorm1v ON probsummarym1.assignee_name = operatorm1v.name ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN DeviceM1 ON probsummarym1.LOCATION = DeviceM1.LOCATION ';
		v_select_stmt := v_select_stmt || ' WHERE ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.assignment', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', vorig_group)  || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('DeviceM1.LOCATION', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', vpriority)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.opened_by', vopened_by)|| ') AND NOT(';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.resolution_code', vresolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || '';		
		
      OPEN generic_sla_cursor FOR v_select_stmt;
   END bisp_select_sla_by_ci_location;   
   
   
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
	  v_gmt_enddate_str	   VARCHAR2 (19);		  
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
      vfromtz := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, ZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
      v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
	  v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');
	  		
        v_select_stmt := 'SELECT  probsummarym1.action, probsummarym1.assignment,probsummarym1.assignee_name, operatorm1v.full_name,probsummarym1.brief_description,probsummarym1.closed_by, probsummarym1.closed_group,bipkg_utils.bifnc_AdjustForTZ(probsummarym1.close_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') close_time, probsummarym1.country,probsummarym1.flag, probsummarym1.last_activity,probsummarym1.LOCATION, probsummarym1.numberprgn,probsummarym1.open_group, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.open_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') open_time,probsummarym1.opened_by, probsummarym1.pfz_bu,probsummarym1.pfz_call_source, probsummarym1.pfz_division,probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla,probsummarym1.pfz_respond_sla,probsummarym1.pfz_respond_sla_group,probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla,probsummarym1.pfz_sla_title,probsummarym1.pfz_total_time_spent,probsummarym1.priority_code, probsummarym1.problem_type,probsummarym1.product_type, probsummarym1.resolution_code,probsummarym1.resolution, probsummarym1.status,probsummarym1.updated_by, bipkg_utils.bifnc_AdjustForTZ(probsummarym1.update_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') update_time,probsummarym1.update_action,probsummarym2.pfz_respond_sla_user, probsummarym2.pfz_restore_sla_user,probsummarym2.pfz_restore_sla_group, probsummarym2.pfz_resolve_sla_group,bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_respond_sla_time,bipkg_utils.bifnc_AdjustForTZ(pfz_restore_sla_time,'|| ''''|| vfromtz|| ''''|| ','|| ''''|| ZONE|| ''''|| ') pfz_restore_sla_time,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 INNER JOIN probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn INNER JOIN operatorm1v ON probsummarym2.pfz_respond_sla_user = operatorm1v.name WHERE (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_respond_sla_group', vassignmentgroup) || ')';
		v_select_stmt := v_select_stmt ||'AND ('|| Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', vorig_group)  || ')';
		v_select_stmt := v_select_stmt ||'AND probsummarym1.close_time between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.LOCATION', vlocation)|| ') AND (';
		v_select_stmt := v_select_stmt || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', vpriority)|| ')';

      OPEN sla_by_loc_cursor FOR v_select_stmt;
  
   END bisp_select_sla_by_loc;
   
END Bisp_Select_Sla;
/


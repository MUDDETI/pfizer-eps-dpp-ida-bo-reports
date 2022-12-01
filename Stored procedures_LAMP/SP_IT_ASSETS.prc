CREATE OR REPLACE PROCEDURE SCCICT_OWNER.Sp_IT_Assets(
      rc_IT_Assets                 IN OUT      sys_refcursor,
      pType                    IN VARCHAR2,
      pSubType                 IN VARCHAR2,
      pDivisionManageBy        IN VARCHAR2,
      pTimeZone                IN VARCHAR2,
      pCIASSIGNMENT            IN VARCHAR2,
      --pDivision                IN VARCHAR2,
      pStartDate               IN DATE,
      pEndDate                 IN DATE
  )      
  IS
/******************************************************************************
   NAME:       Sp_IT_Assets
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        02/08/2008  aj       1. Created this procedure.
   
   NOTES:

******************************************************************************/
  v_select_stmt           VARCHAR2(32767);
  v_gmt_startdate       DATE;
  v_gmt_enddate           DATE;

   BEGIN
   
      v_gmt_startdate :=  Bipkg_Utils.BIFNC_AdjustForTZ(pStartDate, pTimeZone, 'GMT');
      v_gmt_enddate :=  Bipkg_Utils.BIFNC_AdjustForTZ(pEndDate, pTimeZone, 'GMT');
      
      v_select_stmt :=
       ' SELECT '
       || ' AC_CMDB_DEVICEM1.NETWORK_NAME CI_NAME,'
       || ' AC_CMDB_DEVICEM1.PFZ_AC_ID,'
       || ' AC_CMDB_DEVICEM1.PFZ_MANAGING_SITE AREA,'
       || ' AC_CMDB_DEVICEM1.PFZ_DIVISION PFZ_DIVISION,'
       || ' AC_CMDB_DEVICEM1.DESCRIPTION BRIEF_DESCRIPTION,'
       || ' AC_CMDB_DEVICEM1.ISTATUS CI_STATUS,'
       || ' AC_CMDB_DEVICEM1.PFZ_FULL_NAME CI_OWNER,'
       || ' AC_CMDB_DEVICEM1.PFZ_USAGE CURRENT_USAGE,'
       || ' AC_CMDB_DEVICEM1.TYPE,'
       || ' AC_CMDB_DEVICEM1.SUBTYPE,'
       || ' AC_CMDB_DEVICEM1.ASSET_TAG,'
       || ' AC_CMDB_DEVICEM1.SERIAL_NO_,'
       || ' AC_CMDB_DEVICEM1.MANUFACTURER,'
       || ' AC_CMDB_DEVICEM1.MODEL,'
       || ' AC_CMDB_DEVICEM1.LOCATION,'
       || ' AC_CMDB_DEVICEM1.BUILDING,'
       || ' AC_CMDB_DEVICEM1.FLOOR,'
       || ' AC_CMDB_DEVICEM1.ROOM,'
       || ' AC_CMDB_DEVICEM1.USER_ID UserID,'
       || ' AC_CMDB_DEVICEM1.CONTACT_NAME CONTACT_NAME,'
       || ' AC_CMDB_DEVICEM1.PFZ_VALIDATED PFZ_VALIDATED,'
       || ' AC_CMDB_DEVICEM1.PFZ_ESC_PRIORITY PFZ_ESC_PRIORITY,'
       || ' AC_CMDB_DEVICEM1.PFZ_ASSIGNMENT CI_MGMT_GROUP,'
       || ' AC_CMDB_DEVICEM1.PFZ_MANAGING_DIVISION DIV_MANAGED_BY,'
       || ' AC_CMDB_DEVICEM1.PFZ_FM_OWNER ASSET_OWNER,'
       || ' AC_CMDB_DEVICEM1.PFZ_ONCALL INC_ASSIGN_GROUP,'
       || ' AC_CMDB_DEVICEM1.ORDER_NUMBER PURCHASE_ORDER,'
       || ' AC_CMDB_DEVICEM1.LOGICAL_NAME CI_ID,'
       || ' AC_CMDB_DEVICEM1.PFZ_ADDED_BY,'
       || ' AC_CMDB_DEVICEM1.PFZ_ADDED_TIME,'
       || ' AC_CMDB_DEVICEM1.PFZ_REGION,'
       || ' Bipkg_Utils.BIFNC_AdjustForTZ(AC_CMDB_DEVICEM1.PFZ_ADDED_TIME, ''GMT'' , ''' || pTimeZone || ''') 

PFZ_ADDED_TIME'
       || ' FROM'
       || ' AC_CMDB_DEVICEM1'
       || ' WHERE'
       || ' (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AC_CMDB_DEVICEM1.TYPE, '' '')', pType) || ')'
       || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AC_CMDB_DEVICEM1.SUBTYPE, '' '')', pSubType) || ')'
       --|| ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AC_CMDB_DEVICEM1.PFZ_DIVISION, '' '')', pDivision) || ')'
       || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AC_CMDB_DEVICEM1.PFZ_ASSIGNMENT, '' '')', pCIASSIGNMENT) || ')'        
       || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AC_CMDB_DEVICEM1.PFZ_MANAGING_DIVISION, '' '')', pDivisionManageBy) || ')'
       || ' AND AC_CMDB_DEVICEM1.PFZ_ADDED_TIME BETWEEN '''|| v_gmt_startdate || ''' AND ''' || v_gmt_enddate || '''' 
       ;

   OPEN rc_IT_Assets FOR v_select_stmt;

END Sp_IT_Assets; 
/


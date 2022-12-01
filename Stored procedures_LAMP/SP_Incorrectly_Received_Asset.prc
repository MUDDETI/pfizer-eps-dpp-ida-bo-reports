CREATE OR REPLACE PROCEDURE SCCICT_OWNER.Sp_Incorrectly_Received_Assets(
      rc_Incorrectly_Received_Assets          IN OUT      sys_refcursor,
      pArea                    IN VARCHAR2,
      pType                    IN VARCHAR2,
      pLocation                IN VARCHAR2,
      pTimeZone                IN VARCHAR2,
  --    pCIASSIGNMENT            IN VARCHAR2,
      pStartDate               IN     DATE,
      pEndDate                 IN     DATE
  )      
  IS
/******************************************************************************
   NAME:       Sp_Incorrectly_Received_Assets
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        02/12/2007   sg       1. Created this procedure.
   2.0        01/15/2008   aj       1. Added CI Assignment Group as a parameter
   3.0        02/25/2008   aj       1. Removed CI Assignment Group as a Parameter
                                    2. Include all the sites for gDMS Assignment Group
   4.0        05/12/2008   aj       1. Removed AC_CONTACTSM1.PFZ_BU IN (''CIT'', '' '')
                                    2. PFZ_MANAGING_DIVISION="WTI"

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
       || ' AC_CONTACTSM1.PFZ_DIVISION CI_OWNER_DIVISION,'
       || ' AC_CONTACTSM1.PFZ_BU CI_OWNER_BU,'
       || ' AC_CONTACTSM1.DEPT_NAME CI_OWNER_DEPT_NAME,'
       || ' AC_CONTACTSM1.DEPT CI_OWNER_DEPT_ID,'
       || ' AC_CONTACTSM1.PFZ_CHARGE_CODE CI_OWNER_COST_CENTER,'
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
       || ' AC_CMDB_DEVICEM1.PFZ_ASSIGNMENT CI_MGMT_GROUP,'
       || ' AC_CMDB_DEVICEM1.PFZ_MANAGING_DIVISION DIV_MANAGED_BY,'
       || ' AC_CMDB_DEVICEM1.PFZ_FM_OWNER ASSET_OWNER,'
       || ' AC_CMDB_DEVICEM1.PFZ_ONCALL INC_ASSIGN_GROUP,'
       || ' AC_CMDB_DEVICEM1.ORDER_NUMBER PURCHASE_ORDER,'
       || ' AC_CMDB_DEVICEM1.LOGICAL_NAME CI_ID,'
       || ' AC_CMDB_DEVICEM1.PFZ_ADDED_BY,'
       || ' Bipkg_Utils.BIFNC_AdjustForTZ(AC_CMDB_DEVICEM1.PFZ_PURCHASE_DATE, ''GMT'' , ''' || pTimeZone || ''') 

RECEIVE_DATE,'       
       || ' Bipkg_Utils.BIFNC_AdjustForTZ(AC_CMDB_DEVICEM1.PFZ_ADDED_TIME, ''GMT'' , ''' || pTimeZone || ''') 

PFZ_ADDED_TIME,'
       || ' go_live_date(AC_CMDB_DEVICEM1.LOCATION) as go_live_date'       
       || ' FROM'
       || ' AC_CMDB_DEVICEM1,'
       || ' AC_CONTACTSM1'
       || ' WHERE'
       || ' AC_CMDB_DEVICEM1.USER_ID = AC_CONTACTSM1.USER_ID (+)'
       || ' AND AC_CMDB_DEVICEM1.CONTACT_NAME = AC_CONTACTSM1.CONTACT_NAME (+)'
       || ' AND InScope_SubType(AC_CMDB_DEVICEM1.TYPE, AC_CMDB_DEVICEM1.SUBTYPE) = ''T'''
       || ' AND InScope_Location(AC_CMDB_DEVICEM1.LOCATION) = ''T'''
       || ' AND AC_CMDB_DEVICEM1.ISTATUS NOT IN (''Void'', ''Retired'')'
       || ' AND AC_CMDB_DEVICEM1.PFZ_AC_ID IS NULL'  
--     || ' AND AC_CMDB_DEVICEM1.PFZ_ADDED_BY <> ''SCAUTO-AC'''  
       || ' AND AC_CMDB_DEVICEM1.PFZ_ADDED_TIME >= go_live_date(AC_CMDB_DEVICEM1.LOCATION)'
       || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AC_CMDB_DEVICEM1.PFZ_MANAGING_SITE, '' '')', pArea) || ')'
       || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AC_CMDB_DEVICEM1.TYPE, '' '')', pType) || ')'
       || ' AND AC_CMDB_DEVICEM1.PFZ_ASSIGNMENT NOT IN(''GBL-CIT-MESSAGING OPS'',''GBL-DIRECTORY SERVICES'',''GBL-WTI-MSG L2'')'
   --  || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AC_CMDB_DEVICEM1.PFZ_ASSIGNMENT, '' '')', pCIASSIGNMENT) || ')'    
       || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AC_CMDB_DEVICEM1.LOCATION, '' '')', pLocation) || ')'
       || ' AND AC_CMDB_DEVICEM1.PFZ_ADDED_TIME BETWEEN '''|| v_gmt_startdate || ''' AND ''' || v_gmt_enddate || '''' 
     --  || ' AND (NVL(AC_CONTACTSM1.PFZ_BU, '' '') IN (''CIT'', '' ''))'
       || ' AND AC_CMDB_DEVICEM1.PFZ_MANAGING_DIVISION = ''WTI'''
       || ' union'
       ||' SELECT '
       || ' AC_CMDB_DEVICEM1.NETWORK_NAME CI_NAME,'
       || ' AC_CMDB_DEVICEM1.PFZ_AC_ID,'
       || ' AC_CMDB_DEVICEM1.PFZ_MANAGING_SITE AREA,'
       || ' AC_CONTACTSM1.PFZ_DIVISION CI_OWNER_DIVISION,'
       || ' AC_CONTACTSM1.PFZ_BU CI_OWNER_BU,'
       || ' AC_CONTACTSM1.DEPT_NAME CI_OWNER_DEPT_NAME,'
       || ' AC_CONTACTSM1.DEPT CI_OWNER_DEPT_ID,'
       || ' AC_CONTACTSM1.PFZ_CHARGE_CODE CI_OWNER_COST_CENTER,'
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
       || ' AC_CMDB_DEVICEM1.PFZ_ASSIGNMENT CI_MGMT_GROUP,'
       || ' AC_CMDB_DEVICEM1.PFZ_MANAGING_DIVISION DIV_MANAGED_BY,'
       || ' AC_CMDB_DEVICEM1.PFZ_FM_OWNER ASSET_OWNER,'
       || ' AC_CMDB_DEVICEM1.PFZ_ONCALL INC_ASSIGN_GROUP,'
       || ' AC_CMDB_DEVICEM1.ORDER_NUMBER PURCHASE_ORDER,'
       || ' AC_CMDB_DEVICEM1.LOGICAL_NAME CI_ID,'
       || ' AC_CMDB_DEVICEM1.PFZ_ADDED_BY,'
       || ' Bipkg_Utils.BIFNC_AdjustForTZ(AC_CMDB_DEVICEM1.PFZ_PURCHASE_DATE, ''GMT'' , ''' || pTimeZone || ''') 

RECEIVE_DATE,'       
       || ' Bipkg_Utils.BIFNC_AdjustForTZ(AC_CMDB_DEVICEM1.PFZ_ADDED_TIME, ''GMT'' , ''' || pTimeZone || ''') 

PFZ_ADDED_TIME,'
       || ' to_date(''06/01/2006'',''MM/DD/YYYY'') as go_live_date'       
       || ' FROM'
       || ' AC_CMDB_DEVICEM1,'
       || ' AC_CONTACTSM1'
       || ' WHERE'
       || ' AC_CMDB_DEVICEM1.USER_ID = AC_CONTACTSM1.USER_ID (+)'
       || ' AND AC_CMDB_DEVICEM1.CONTACT_NAME = AC_CONTACTSM1.CONTACT_NAME (+)'
       || ' AND InScope_SubType(AC_CMDB_DEVICEM1.TYPE, AC_CMDB_DEVICEM1.SUBTYPE) = ''T'''
    -- || ' AND InScope_Location(AC_CMDB_DEVICEM1.LOCATION) = ''T'''
       || ' AND AC_CMDB_DEVICEM1.ISTATUS NOT IN (''Void'', ''Retired'')'
       || ' AND AC_CMDB_DEVICEM1.PFZ_AC_ID IS NULL'  
--     || ' AND AC_CMDB_DEVICEM1.PFZ_ADDED_BY <> ''SCAUTO-AC'''  
       || ' AND AC_CMDB_DEVICEM1.PFZ_ADDED_TIME >= to_date (''06/01/2006'',''MM/DD/YYYY'')'
       || ' AND AC_CMDB_DEVICEM1.PFZ_ASSIGNMENT IN(''GBL-CIT-MESSAGING OPS'',''GBL-DIRECTORY SERVICES'',''GBL-WTI-MSG L2'')'  
       || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AC_CMDB_DEVICEM1.PFZ_MANAGING_SITE, '' '')', pArea) || ')'
       || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AC_CMDB_DEVICEM1.TYPE, '' '')', pType) || ')'
   --  || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AC_CMDB_DEVICEM1.PFZ_ASSIGNMENT, '' '')', pCIASSIGNMENT) || ')'    

       || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AC_CMDB_DEVICEM1.LOCATION, '' '')', pLocation) || ')'
       || ' AND AC_CMDB_DEVICEM1.PFZ_MANAGING_DIVISION = ''WTI'''
       ;
   OPEN rc_Incorrectly_Received_Assets FOR v_select_stmt;

END Sp_Incorrectly_Received_Assets;
/
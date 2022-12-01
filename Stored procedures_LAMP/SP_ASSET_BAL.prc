CREATE OR REPLACE PROCEDURE SCCICT_OWNER.SP_Asset_Bal(
    rc_Asset_Bal          IN OUT      sys_refcursor,
    pArea        IN VARCHAR2,
    pLocation    IN VARCHAR2,
    pType        IN VARCHAR2,
    pTimeZone    IN VARCHAR2,
    pStartDate   IN Date,
    pEndDate     IN Date
  )      
  IS
/******************************************************************************
   NAME:       Sp_Asset_Bal
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        02/20/2007   Ankoosh Jain      1. Created this procedure.
  
   NOTES:

******************************************************************************/
  v_select_stmt           VARCHAR2(32767);
  v_gmt_startdate         DATE;
  v_gmt_enddate           DATE;

   BEGIN
   
      v_gmt_startdate :=  Bipkg_Utils.BIFNC_AdjustForTZ(pStartDate, pTimeZone, 'GMT');
      v_gmt_enddate :=  Bipkg_Utils.BIFNC_AdjustForTZ(pEndDate, pTimeZone, 'GMT');
      
      v_select_stmt :=
       'SELECT DISTINCT '
       ||'DEV1.LOCATION as LOCATION,'
       ||'DEV1.TYPE as TYPE,'
       ||'DEV1.SUBTYPE as SUBTYPE,'
       ||'DEV1.DESCRIPTION as DESCRIPTION,'
       ||'DEV1.SERIAL_NO_ as SERIAL_NUMBER,'
       ||'DEV1.NETWORK_NAME as NETWORK_NAME,'
       ||'DEV1.LOGICAL_NAME as LOGICAL_NAME,'
       ||'DEV1.PFZ_AC_ID as PFZ_AC_ID,'
       ||'DEV1.ISTATUS as STATUS,'
       ||'DEV1.PFZ_FULL_NAME as PFZ_FULL_NAME,'
       ||'DEV1.PFZ_USAGE as PFZ_USAGE,'
       ||'DEV1.ASSET_TAG as ASSET_TAG,'                    
       ||'DEV1.MANUFACTURER as MANUFACTURER,'
       ||'DEV1.MODEL as MODEL,'
       ||'DEV1.BUILDING as BUILDING,'
       ||'DEV1.FLOOR as FLOOR,'
       ||'DEV1.ROOM as ROOM,'                    
       ||'DEV1.PFZ_FM_OWNER as PFZ_FM_OWNER,'
       ||'DEV1.PFZ_ASSIGNMENT as PFZ_ASSIGNMENT,'
       ||'DEV1.PFZ_MANAGING_DIVISION as PFZ_MANAGING_DIVISION,'
       ||'DEV1.PFZ_ADDED_TIME as PFZ_ADDED_TIME,'
       ||'DEV1.PFZ_RETIRED_TIME as PFZ_RETIRED_TIME,'      
       ||'DEV1.ORDER_NUMBER as ORDER_NUMBER,'
       ||'DEV1.PFZ_PURCHASE_DATE as PFZ_PURCHASE_DATE,'
       ||'DEV1.PFZ_MANAGING_SITE as PFZ_MANAGING_SITE,'
       ||'USER1.PFZ_BU as OWNER_BUSINESS_UNIT,'
       ||'USER1.DEPT as OWNER_DEPT_ID,' 
       ||'USER1.DEPT_NAME as OWNER_DEPT_NAME,'
       ||'USER1.PFZ_DIVISION as OWNER_DIVISION,'
       ||'USER1.PFZ_CHARGE_CODE as OWNER_COST_CENTER,'
       ||' Case '
       ||' When '
       ||' upper(DEV1.ISTATUS) = ''RETIRED'''
       ||' and (DEV1.PFZ_RETIRED_TIME between '''||v_gmt_startdate || ''''
       ||' and '''|| v_gmt_enddate ||''')Then ''RETIRED'''
       ||' When'
       ||' upper(DEV1.ISTATUS) <> ''RETIRED''' 
       ||' and (dev1.PFZ_ADDED_TIME between '''||v_gmt_startdate || ''''
       ||' and '''|| v_gmt_enddate ||''')Then ''New Added'''
       ||' When' 
       ||' DEV1.ISTATUS IN (''Run'',''Run - Update'',''New'',''Decommissioned'', ''Build'')'
       ||' and (DEV1.PFZ_ADDED_TIME <'''||v_gmt_startdate ||''')Then ''OLD ACTIVE ASSETS'''
       ||' ELSE '''''
       ||' End as Main_Status'
       || ' FROM'
       || ' AC_CMDB_DEVICEM1 DEV1,'
       || ' AC_CONTACTSM1 USER1'
       || ' WHERE'
       || ' DEV1.USER_ID = USER1.USER_ID (+)'
       || ' AND DEV1.CONTACT_NAME = USER1.CONTACT_NAME (+)'
       --|| ' AND (NVL(USER1.PFZ_BU, '' '') IN (''CIT'', '' ''))'
       || ' AND DEV1.ISTATUS <> ''Void'''
       || ' AND InScope_SubType(DEV1.TYPE, DEV1.SUBTYPE) = ''T'''
       || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(DEV1.TYPE, '' '')', pType) || ')'
       || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(DEV1.LOCATION, '' '')', pLocation) || ')'
       || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(DEV1.PFZ_MANAGING_SITE, '' '')', pArea) || ')'
       || ' AND DEV1.PFZ_ADDED_TIME<''' || v_gmt_enddate || ''''
       || ' AND ((DEV1.PFZ_RETIRED_TIME>''' || v_gmt_startdate || ''') OR (DEV1.PFZ_RETIRED_TIME IS NULL))'
       ;
   OPEN rc_Asset_Bal for v_select_stmt;
   end SP_Asset_Bal; 
/


CREATE OR REPLACE PROCEDURE SCCICT_OWNER.Sp_All_Active_Assets (
      rc_All_Active_Assets     		 IN OUT   SYS_REFCURSOR,
      pArea								 IN       VARCHAR2,
	  pOwner_Business_Unit			     IN		  VARCHAR2,
	  pOwner_Cost_Center				 IN		  VARCHAR2,
	  pOwner_Department_Name			 IN		  VARCHAR2,
	  pOwner_Division				     IN       VARCHAR2,
      pType							     IN       VARCHAR2,
	  pDepartment						 IN		  VARCHAR2,
	  pDivisionManagedBy				 IN		  VARCHAR2,
	  pLocation							 IN		  VARCHAR2,
	  pStatus							 IN		  VARCHAR2,
	  pTimeZone		                     IN       VARCHAR2,
	  PFZ_REGION					     IN		  VARCHAR2
   ) 
   AS

/******************************************************************************
   NAME:       SP_ALL_ACTIVE_ASSETS
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        08/29/2006      -shw-    	   1. Created for "All Active Assets.rpt"  
   			  08/31/06		  -shw-		   2. Added qualifiers to only select AMASSET 'Active' rows 
			  12.11.06		  -shw-		   3. added NVL on parameters.   
			  01.17.07		  -sg-		   4. Added Status parameter

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     SP_ALL_ACTIVE_ASSETS
      Sysdate:         08/29/2006
      Date and Time:   08/29/2006, 10:41:50 AM, and 08/29/2006 10:41:50 AM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
      v_select_stmt		   VARCHAR2 (32767);
   BEGIN
	  v_select_stmt :=
	  'SELECT distinct '
	  || 'dev1.location,'
	  || 'dev1.type,'
	  || 'dev1.subtype,'
	  || 'dev1.logical_name,'
	  || 'dev1.network_name,'
	  || 'dev1.description,'
	  || 'dev1.serial_no_,'
	  || 'dev1.pfz_ac_id,'
	  || 'dev1.istatus,'
	  || 'dev1.pfz_full_name,'
	  || 'user1.dept_name Department,'
	  || 'user1.pfz_charge_code contactsm1_pfz_charge_code,'
	  || 'user1.pfz_bu contactsm1_pfz_bu,'
	  || 'user1.dept contactsm1_dept,'
	  || 'user1.pfz_division contactsm1_pfz_division,'
	  || 'dev1.pfz_fm_owner,'
	  || 'dev1.pfz_usage,'
	  || 'dev1.asset_tag,'
	  || 'dev1.manufacturer,'
	  || 'dev1.model,'
	  || 'dev1.building,'
	  || 'dev1.floor,'
	  || 'dev1.room,'
	  || 'dev1.pfz_assignment,'
	  || 'dev1.pfz_managing_division,'
	  || 'dev1.pfz_managing_site,'
	  || 'dev1.pfz_oncall,'
	  || 'dev1.pfz_esc_assignment,'
	  || 'dev1.pfz_added_time,'
	  || 'dev1.order_number,'
	  || 'dev1.PFZ_REGION,' 
	  || 'bipkg_utils.BIFNC_AdjustForTZ(dev1.pfz_purchase_date,'||''''|| 'GMT'||''''||','||''''|| pTimeZone||''''||')  receive_date, '
	  || 'ac.status am_status, ' 
--      || 'ac.DTLASTMODIF,'
	  || 'f.fixedastno far_fixedastno,'
	  || 'f.description far_description,'
	  || 'f.qty far_qty,'
	  || 'f.dept far_dept,'
	  || 'f.division far_division,'
	  || 'f.city far_city,'
	  || 'f.state far_state,'
	  || 'f.dateofacq far_dateofacq,'
	  || 'f.company far_company,'
	  || 'f.assetclass far_assetclass,'
	  || 'f.ponumber far_ponumber,'
	  || 'f.yrofacq far_yrofacq,'
	  || 'f.fulldispdate far_fulldispdate,'
	  || 'f.lifeyrs far_lifeyrs,'
	  || 'f.serialno far_serialno,'
	  || 'f.vendor far_vendor,'
	  || 'f.cost far_cost,'
	  || 'f.ytddepr far_ytddepr,'
	  || 'f.ltddepr far_ltddepr,'
	  || 'f.nbv far_nbv'
 --     || 'sc.close_time'
	  || ' FROM'
	  || ' AC_AMASSET ac'
	  || ' inner join AC_CMDB_DEVICEM1 dev1'
	  || ' on dev1.PFZ_AC_ID = ac.PFZ_AC_ID'
--      || ' inner join STG_PROBSUMMARYM1 sc'
--      || ' on dev1.LOGICAL_NAME = sc.LOGICAL_NAME'
--      || ' and dev1.NETWORK_NAME = sc.NETWORK_NAME'
	  || ' left join AC_CONTACTSM1 user1'
	  || ' on dev1.USER_ID = user1.USER_ID'
	  || ' and dev1.CONTACT_NAME = user1.CONTACT_NAME' 	
	  || ' left join AC_AMPFZFAR f'
	  || ' on f.serialno = ac.serialno'
	  || ' and f.contract = ac.assettag'
	  || ' WHERE'
	  || ' not ( (' || Bipkg_Utils.BIFNC_createinlist ('NVL(ac.status, '' '')', pStatus) || ') )'	  
	  || ' and (' || Bipkg_Utils.BIFNC_createinlist ('NVL(dev1.pfz_managing_site, '' '')', pArea) || ')'
	  || ' and (' || Bipkg_Utils.BIFNC_createinlist ('NVL(dev1.type, '' '')', pType ) || ')'
	  || ' and (' || Bipkg_Utils.BIFNC_createinlist ('NVL(dev1.pfz_managing_division, '' '')', pDivisionManagedBy ) || ')'
	  || ' and (' || Bipkg_Utils.BIFNC_createinlist ('NVL(dev1.location, '' '')', pLocation ) || ')'
	  || ' and (' || Bipkg_Utils.BIFNC_createinlist ('NVL(user1.dept, '' '')', pDepartment) || ')'
	  || ' and (' || Bipkg_Utils.BIFNC_createinlist ('NVL(user1.dept_name, '' '')', pOwner_Department_Name) || ')'
	  || ' and (' || Bipkg_Utils.BIFNC_createinlist ('NVL(user1.pfz_division, '' '')', pOwner_Division) || ')'
	  || ' and (' || Bipkg_Utils.BIFNC_createinlist ('NVL(user1.pfz_bu, '' '')', pOwner_Business_Unit) || ')'
	  || ' and (' || Bipkg_Utils.BIFNC_createinlist ('NVL(user1.pfz_charge_code, '' '')', pOwner_Cost_Center) || ')'
	  || ' and (' || Bipkg_Utils.BIFNC_createinlist ('NVL(dev1.PFZ_REGION, '' '')', PFZ_REGION) || ')'
	  ;
	  
	  OPEN rc_All_Active_Assets FOR v_select_stmt;
   END Sp_All_Active_Assets;
/
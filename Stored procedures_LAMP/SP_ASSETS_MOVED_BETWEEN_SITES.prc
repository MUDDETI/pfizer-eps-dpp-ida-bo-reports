CREATE OR REPLACE PROCEDURE sp_Assets_Moved_Between_Sites (
      rc_Assets_Moved_Between_Sites      IN OUT   SYS_REFCURSOR
   ) 
   as

/******************************************************************************
   NAME:       SP_ALL_ACTIVE_ASSETS
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        08/30/2006      -shw-    	   1. Created for "Assets Moved Between Sites.rpt"  
   

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     sp_Assets_Moved_Between_Sites
      Sysdate:         08/30/2006
      Date and Time:   08/30/2006, 10:41:50 AM, and 08/30/2006 10:41:50 AM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
      v_select_stmt		   varchar2 (32767);
   begin
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
	  || 'user1.PFZ_DIVISION Department,'
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
	  || 'dev1.pfz_added_time,'
	  || 'dev1.order_number,'
	  || 'dev1.pfz_purchase_date,'
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
	  || ' FROM '
	  || 'AC_AMASSET ac,'
	  || 'AC_AMPFZFAR f,'
	  || 'AC_CMDB_DEVICEM1 dev1,'
	  || 'AC_CONTACTSM1 user1'
	  || ' WHERE '
	  || 'dev1.PFZ_AC_ID = ac.PFZ_AC_ID '
	  || 'and f.serialno = ac.serialno '
	  || 'and f.contract = ac.assettag '
	  || 'and dev1.USER_ID = user1.USER_ID (+) '
	  || 'and dev1.CONTACT_NAME = user1.CONTACT_NAME (+) '; 
/*
  		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('dev1.pfz_managing_site', pArea) || ')';
  		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('dev1.type', pType ) || ')';
  		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('dev1.pfz_managing_division', pDivisionManagedBy ) || ')';
  		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('dev1.location', pLocation ) || ')';
  		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('user1.dept', pDepartment) || ')';
  		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('user1.dept_name', pOwner_Department_Name) || ')';
  		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('user1.pfz_division', pOwner_Division) || ')';
  		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('user1.pfz_bu', pOwner_Business_Unit) || ')';
  		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('user1.pfz_charge_code', pOwner_Cost_Center) || ')';
*/
	  open rc_Assets_Moved_Between_Sites for v_select_stmt;
   end sp_Assets_Moved_Between_Sites;
/

CREATE OR REPLACE PROCEDURE ASSETS_RECONCILED_TO_FAR (
      rc_Assets_Reconciled_to_FAR		 IN OUT	  sys_refcursor,
--      outtext							 out 	  varchar2,
      pArea								 IN       VARCHAR2,
	  pCI_Owner_Business_Unit			 IN		  VARCHAR2,
	  pCI_Owner_Cost_Center				 IN		  VARCHAR2,
	  pCI_Owner_Department_ID			 IN		  VARCHAR2,
	  pCI_Owner_Department_Name			 IN		  VARCHAR2,
	  pCI_Owner_Division				 IN       VARCHAR2,
      pCI_Type							 IN       VARCHAR2,
	  pDivisionManagedBy				 IN		  VARCHAR2,
	  pLocation							 IN		  VARCHAR2,
	  pTimeZone							 IN		  VARCHAR2
--	  pWhichCursor						 IN		  VARCHAR2
   )
   is
/******************************************************************************
   NAME:       Assets_indvl_active_decomm 
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/21/2006          1. Created this procedure.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     Assets_indvl_active_decomm 
      Sysdate:         8/21/2006
      Date and Time:   8/21/2006, 1:02:26 PM, and 8/21/2006 1:02:26 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
      v_select_stmt		   varchar2 (32767);
   begin
      v_select_stmt := 'select dm1.NETWORK_NAME CI_Name, dm1.pfz_ac_id, dm1.PFZ_MANAGING_SITE Area, cm1.pfz_bu business_unit_ci_owner,'||
      ' cm1.dept department_id_ci_owner, cm1.pfz_charge_code cost_center_ci_owner, dm1.description brief_description, '||
      ' dm1.istatus status_ci, dm1.pfz_full_name ci_owner, dm1.type, dm1.subtype, dm1.serial_no_ sn_chasis, dm1.manufacturer, '||
      ' dm1.model, dm1.location, dm1.building building_ci, dm1.floor, dm1.room, dm1.pfz_assignment CI_mgmt_grp, '||
      ' dm1.PFZ_FM_OWNER asset_owner, ama.pfz_po_number  PO_Number, dm1.logical_name ci_id, far.fixedastno assetnum_far, dm1.asset_tag first_asset_tag '||
      ', bipkg_utils.BIFNC_AdjustForTZ(dm1.pfz_purchase_date,'||''''|| 'GMT'||''''||','||''''|| pTimeZone||''''||')  receive_date ';
      v_select_stmt := v_select_stmt ||','||
	  ' far.description description_far, far.qty quantity_far, far.dept dept_far, far.division divis_far,'||
	  ' far.city city_far, far.state state_far, far.dateofacq date_of_acq_far, far.company company_far, '||
	  ' far.assetclass assetclass_far, far.yrofacq yr_of_acq_far, far.fulldispdate full_disposed_date_far,'||
	  ' far.lifeyrs life_yrs_far, far.serialno serial_far, far.ponumber po_number_far, far.vendor vendor_far, '||
	  ' far.cost cost_far, far.ytddepr ytd_depr_far, far.ltddepr ltd_depr_far, far.nbv net_book_value_far, '||
	  ' far.contract Contracts_FAR ';
	  v_select_stmt := v_select_stmt ||
      ' from ac_cmdb_devicem1 dm1, ac_contactsm1 cm1, ac_amasset ama, ac_ampfzfar far '||
      ' where ama.serialno = far.serialno(+) '||
      '  and ama.assettag = far.contract(+) '||
	  '  and far.completematch is not null '||
      '  and dm1.pfz_ac_id = ama.pfz_ac_id '||
      '  and cm1.CONTACT_NAME = dm1.CONTACT_NAME '||
      '  and cm1.USER_ID = dm1.USER_ID '||
      '  AND dm1.TYPE ';
      v_select_stmt := v_select_stmt || ' IN ('||''''||'NETWORK'||''''||','||''''|| 'SERVER'||''''||','||
	  ''''||'STORAGE'||''''||','||''''||'PERSONAL COMPUTER'||''''||')';
	  v_select_stmt := v_select_stmt ||
      ' AND dm1.SUBTYPE IN ('||''''||'SWITCH'||''''||','||''''||'ROUTER'||''''||','||''''||'CHECKPOINT'||''''||
      ','||''''||'HUB'||''''||','||''''||'ACCESS SERVER'||''''||','||''''||'PHYSICAL'||''''||','||''''|| 'CONTROLLER'||''''
      ||','||''''||'NAS CONTROLLER'||''''||','||''''||'NAS FILE SERVER'||''''||','||''''||'SAN SWITCH'||''''||','
      ||''''||'STORAGE ARRAY'||''''||','||''''||'STORAGE UNIT'||''''||','||''''|| 'TAPE DRIVE'||''''||','||''''||
      'TAPE SILO'||''''||','||''''||'DESKTOP'||''''||','||''''||'LAPTOP'||''''||','||''''||'TABLET PC'||''''||','||''''||
      'WIRELESS/ACCESS POINT'||''''||','||''''||'THIN CLIENT'||''''||')'||'  and dm1.pfz_managing_site '|| pArea||
      ' and NVL(dm1.type,''1'') '|| pCI_Type||
      ' and NVL(dm1.location,''1'') '|| pLocation||
      ' and NVL(cm1.pfz_bu,''1'') '|| pCI_Owner_Business_Unit||
      ' and NVL(cm1.dept,''1'') '|| pCI_Owner_Department_ID||
      ' and NVL(cm1.pfz_division,''1'') '|| pCI_Owner_Division||
      ' and NVL(cm1.pfz_charge_code,''1'') '|| pCI_Owner_Cost_Center||
      ' and NVL(cm1.dept_name,''1'') '|| pCI_Owner_Department_Name ||
      ' and NVL(dm1.pfz_managing_division,''1'') '||pDivisionManagedBy;
      open rc_Assets_Reconciled_to_FAR for v_select_stmt;
--        outtext := v_select_stmt;
   end ASSETS_RECONCILED_TO_FAR;
/

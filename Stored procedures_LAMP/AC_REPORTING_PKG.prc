CREATE OR REPLACE PACKAGE ac_reporting_pkg AS
/******************************************************************************
   NAME:       ac_reporting_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        07/31/2006             1. Created this package.
******************************************************************************/

   TYPE bisp_refcursor_type IS REF CURSOR;

/*   PROCEDURE Assets_Retired (
      rc_Assets_Retired			   		 IN OUT   bisp_refcursor_type,
      pArea								 IN       VARCHAR2,
	  pCI_Owner_Business_Unit			 IN		  VARCHAR2,
	  pCI_Owner_Cost_Center				 IN		  VARCHAR2,
	  pCI_Owner_Department_Name			 IN		  VARCHAR2,
	  pCI_Owner_Division				 IN       VARCHAR2,
      pCI_Type							 IN       VARCHAR2,
	  pDepartment						 IN		  VARCHAR2,
	  pStartDate						 IN		  VARCHAR2,
	  pEndDate							 IN		  VARCHAR2
   );   
*/   
  PROCEDURE Assets_Disposed_or_Retired (
      rc_Assets_Disposed_or_Retired	     IN OUT   bisp_refcursor_type,
      pArea								 IN       VARCHAR2,
      pCI_Type							 IN       VARCHAR2,
	  pRetiredDisposedFrom				 IN		  VARCHAR2
   );
   
   PROCEDURE Assets_NonDepreciating (
      rc_Assets_NonDepreciating	   		 IN OUT   bisp_refcursor_type,
      pArea								 IN       VARCHAR2,
      pCI_Type							 IN       VARCHAR2
   );
   
   PROCEDURE Assets_indvl_active_decomm (
--      rc_Assets_indvl_active_decomm		 IN OUT	  bisp_refcursor_type,
      outtext							 out 	  varchar2,
      pArea								 IN       VARCHAR2,
	  pCI_Owner_Business_Unit			 IN		  VARCHAR2,
	  pCI_Owner_Cost_Center				 IN		  VARCHAR2,
	  pCI_Owner_Department_ID			 IN		  VARCHAR2,
	  pCI_Owner_Department_Name			 IN		  VARCHAR2,
	  pCI_Owner_Division				 IN       VARCHAR2,
      pCI_Type							 IN       VARCHAR2,
	  pDivisionManagedBy				 IN		  VARCHAR2,
	  pLocation							 IN		  VARCHAR2,
	  pWhichCursor						 IN		  VARCHAR2
   );
   
END ac_reporting_pkg;
/
CREATE OR REPLACE package body ac_reporting_pkg
as
/******************************************************************************
   name:       ac_reporting_pkg
   purpose:	   provides data to Asset Center reports

   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0		  07/31/2006  RGladski	   	   1. created procedure
   1.1		  12/12/2006	-shw-	 	   2. Allowances for NULL values 
******************************************************************************/
   
  
   PROCEDURE Assets_Disposed_or_Retired (
      rc_Assets_Disposed_or_Retired	     IN OUT   bisp_refcursor_type,
      pArea								 IN       VARCHAR2,
      pCI_Type							 IN       VARCHAR2,
	  pRetiredDisposedFrom				 IN		  VARCHAR2
   ) 
   as
      v_select_stmt		   varchar2 (32767);
   begin
	  v_select_stmt :=
	  'select distinct dev1.location,'
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
	  || 'user1.pfz_charge_code as contactsm1_pfz_charge_code,'
	  || 'dev1.pfz_fm_owner,'
	  || 'dev1.asset_tag,'
	  || 'dev1.manufacturer,'
	  || 'dev1.model,'
	  || 'dev1.pfz_assignment,'
	  || 'dev1.pfz_managing_site,'
	  || 'dev1.order_number,'
	  || 'dev1.pfz_purchase_date,'
	  || 'f.fixedastno as far_fixedastno,'
	  || 'f.description as far_description,'
	  || 'f.qty as far_qty,'
	  || 'f.dept as far_dept,'
	  || 'f.division as far_division,'
	  || 'f.city as far_city,'
	  || 'f.state as far_state,'
	  || 'f.dateofacq as far_dateofacq,'
	  || 'f.company as far_company,'
	  || 'f.yrofacq as far_yrofacq,'
	  || 'f.fulldispdate as far_fulldispdate,'
	  || 'f.lifeyrs as far_lifeyrs,'
	  || 'f.serialno as far_serialno,'
	  || 'f.vendor as far_vendor,'
	  || 'f.cost as far_cost,'
	  || 'f.ytddepr as far_ytddepr,'
	  || 'f.ltddepr as far_ltddepr,'
	  || 'f.nbv as far_nbv,'
	  || 'f.ponumber,'
	  || 'ac.status'
	  || ' from '
	  || 'AC_AMASSET ac,'
	  || 'AC_AMPFZFAR f,'
	  || 'AC_CMDB_DEVICEM1 dev1,'
	  || 'AC_CONTACTSM1 user1'
	  || ' where'
	  || ' dev1.PFZ_AC_ID = ac.PFZ_AC_ID'
	  || ' and dev1.USER_ID = user1.USER_ID (+)'
	  || ' and dev1.CONTACT_NAME = user1.CONTACT_NAME (+)'
	  || ' and NVL(dev1.type,''1'') ' || pCI_Type
	  || ' and NVL(dev1.pfz_managing_site,''1'') ' || pArea; 
	  
	  if (UPPER(pRetiredDisposedFrom) = 'DISPOSEDFAR') then
	  	  v_select_stmt := v_select_stmt 
		  || ' and ac.serialno = f.serialno'
		  || ' and ac.assettag = f.contract'
	  	  || ' and TRIM(f.FULLDISPDATE) <> 0'
		  || ' and upper(dev1.istatus) != ''RETIRED''';
	  elsif (UPPER(pRetiredDisposedFrom) = 'RETIREDCMDB_FNWO') then
	  	  v_select_stmt := v_select_stmt
		  || 'and' 
		  || ' ('
		  || '  (ac.fixedastno = f.fixedastno)'
		  || ' or'
		  || '  (ac.serialno = f.serialno'
		  || '  and ac.assettag = f.contract)'
		  || ' or (ac.pfz_po_number = f.PONUMBER)'
		  /*also try by stripping off leading Company code prefix 
		  (eg: 140-N-754817 to N-754817 per Larry Morth*/
		  || ' or (decode(instr(ac.pfz_po_number,''-''),2,ac.pfz_po_number,substr(ac.pfz_po_number,instr(ac.pfz_po_number,''-'') + 1,(length(ac.pfz_po_number) - instr(ac.pfz_po_number,''-''))))'  
		  || ' = f.PONUMBER)'
		  || ' )'
		  || ' and f.fulldispdate = ''0'''
	  	  || ' and TRIM(f.NBV) = ''$0.00'''
		  || ' and upper(dev1.istatus) = ''RETIRED''';
	  elsif (UPPER(pRetiredDisposedFrom) = 'CMDB_WITH_NO_FAR') then
	  	  v_select_stmt := v_select_stmt
		  || ' and ac.PFZ_AC_ID not like ''20%'''
		  || ' and ac.serialno = f.serialno (+)'
		  || ' and ac.assettag = f.contract (+)'
	  	  || ' and f.serialno is null';

	  else
	  	  v_select_stmt := v_select_stmt;
	  end if;			  		  

	  open rc_Assets_Disposed_or_Retired for v_select_stmt;
	  
   end Assets_Disposed_or_Retired;

   PROCEDURE Assets_NonDepreciating (
      rc_Assets_NonDepreciating    		 IN OUT   bisp_refcursor_type,
      pArea								 IN       VARCHAR2,
      pCI_Type							 IN       VARCHAR2
   ) 
   as
      v_select_stmt		   varchar2 (32767);
   begin
	  v_select_stmt :=
	  'select distinct '
	  || 'dev1.location as location,'
	  || 'dev1.type as type,'
	  || 'dev1.subtype as subtype,'
	  || 'dev1.logical_name as logical_name,'
	  || 'dev1.network_name as network_name,'
	  || 'dev1.description as description,'
	  || 'dev1.serial_no_ as serial_no_,'
	  || 'dev1.pfz_ac_id as pfz_ac_id,'
	  || 'dev1.istatus as istatus,'
	  || 'dev1.pfz_full_name as pfz_full_name,'
	  || 'dev1.pfz_fm_owner as pfz_fm_owner,'
	  || 'dev1.pfz_usage as pfz_usage,'
	  || 'dev1.asset_tag as asset_tag,'
	  || 'dev1.manufacturer as manufacturer,'
	  || 'dev1.model as model,'
	  || 'dev1.building as building,'
	  || 'dev1.floor as floor,'
	  || 'dev1.room as room,'
	  || 'dev1.pfz_assignment as pfz_assignment,'
	  || 'dev1.pfz_managing_division as pfz_managing_division,'
	  || 'dev1.pfz_managing_site as pfz_managing_site,'
	  || 'dev1.pfz_oncall as oncall,'
	  || 'dev1.pfz_added_time as pfz_added_time,'
	  || 'dev1.PFZ_RETIRED_TIME as pfz_retired_time,'
	  || 'dev1.order_number as order_number,'
	  || 'dev1.pfz_purchase_date as pfz_purchase_date,'
--	  || 'decode('
--	  || 'length('
--	  || '(decode(dev1.STG_M1_ADDITION_REASON,''Target Architecture'',dev1.STG_M1_ADDITION_REASON,'''') || decode(dev1.STG_M1_PFZ_REDUCTION_REASON,''Migration To Target Architecture'',dev1.STG_M1_PFZ_REDUCTION_REASON,''''))'
--	  || '),null,'''','
--	  || '(decode(dev1.STG_M1_ADDITION_REASON,''Target Architecture'',dev1.STG_M1_ADDITION_REASON,'''') || decode(dev1.STG_M1_PFZ_REDUCTION_REASON,''Migration To Target Architecture'',dev1.STG_M1_PFZ_REDUCTION_REASON,''''))'
--	  || ') as ATS_Reason,'
	  || '('
	  || 'decode(dev1.PFZ_REDUCTION_REASON,''Migration To Target Architecture'',dev1.PFZ_REDUCTION_REASON,'''')'
	  || ') as ATS_Reason,'
	  || 'user1.PFZ_DIVISION Department,'
	  || 'user1.pfz_charge_code as contactsm1_pfz_charge_code,'
	  || 'user1.pfz_bu as contactsm1_pfz_bu,'
	  || 'user1.dept as contactsm1_dept,'
	  || 'user1.pfz_division as contactsm1_pfz_division,'
	  || 'f.fixedastno as far_fixedastno,'
	  || 'f.description as far_description,'
	  || 'f.qty as far_qty,'
	  || 'f.dept as far_dept,'
	  || 'f.division as far_division,'
	  || 'f.city as far_city,'
	  || 'f.state as far_state,'
	  || 'f.dateofacq as far_dateofacq,'
	  || 'f.company as far_company,'
	  || 'f.assetclass as far_assetclass,'
	  || 'f.ponumber as far_ponumber,'
	  || 'f.yrofacq as far_yrofacq,'
	  || 'f.fulldispdate as far_fulldispdate,'
	  || 'f.lifeyrs as far_lifeyrs,'
	  || 'f.serialno as far_serialno,'
	  || 'f.vendor as far_vendor,'
	  || 'f.cost as far_cost,'
	  || 'f.ytddepr as far_ytddepr,'
	  || 'f.ltddepr as far_ltddepr,'
	  || 'f.nbv as far_nbv'
	  || ' from '
	  || 'AC_AMASSET ac,'
	  || 'AC_AMPFZFAR f,'
	  || 'AC_CMDB_DEVICEM1 dev1,'
	  || 'AC_CONTACTSM1 user1'
	  || ' where'
	  || ' dev1.PFZ_AC_ID = ac.PFZ_AC_ID'
	  || ' and ac.serialno = f.serialno (+)'
	  || ' and ac.assettag = f.contract (+)'
	  || ' and dev1.PFZ_FULL_NAME = user1.PFZ_FULL_NAME (+)'
	  || ' and NVL(dev1.type,''1'') ' || pCI_Type
	  || ' and NVL(dev1.pfz_managing_site,''1'') ' || pArea 
	  || ' and f.cost = ''$999.00'''
	  || ' and (f.cost is null or f.cost = ''$0.00'')';
 
	  open rc_Assets_NonDepreciating for v_select_stmt;
	  
   end Assets_NonDepreciating;
---
   PROCEDURE Assets_indvl_active_decomm (
      outtext							 out 	  varchar2,
      pArea								 IN       VARCHAR2,
	  pCI_Owner_Business_Unit			 IN		  VARCHAR2,
	  pCI_Owner_Cost_Center				 IN		  VARCHAR2,
	  pCI_Owner_Department_ID			 IN		  VARCHAR2,
	  pCI_Owner_Department_Name			 IN		  VARCHAR2,
	  pCI_Owner_Division				 IN       VARCHAR2,
      pCI_Type							 IN       VARCHAR2,
	  pDivisionManagedBy				 IN		  VARCHAR2,
	  pLocation							 IN		  VARCHAR2,
	  pWhichCursor						 IN		  VARCHAR2
   )
   is
      v_select_stmt		   varchar2 (32767);
   begin
      v_select_stmt := 'select dm1.NETWORK_NAME CI_Name, dm1.pfz_ac_id, dm1.PFZ_MANAGING_SITE Area, cm1.pfz_bu business_unit_ci_owner,'||
      ' cm1.dept department_id_ci_owner, cm1.pfz_charge_code cost_center_ci_owner, dm1.description brief_description, '||
      ' dm1.istatus status_ci, dm1.pfz_full_name ci_owner, dm1.type, dm1.subtype, dm1.serial_no_ sn_chasis, dm1.manufacturer, '||
      ' dm1.model, dm1.location, dm1.building building_ci, dm1.floor, dm1.room, dm1.pfz_assignment CI_mgmt_grp, '||
      ' dm1.PFZ_FM_OWNER asset_owner, ama.pfz_po_number  PO_Number, dm1.logical_name ci_id, far.fixedastno assetnum_far, dm1.asset_tag first_asset_tag '||
      ', dm1.pfz_purchase_date '||
      ' from ac_cmdb_devicem1 dm1, ac_contactsm1 cm1, ac_amasset ama, ac_ampfzfar far '||
      ' where ama.serialno = far.serialno(+) '||
      '  and ama.assettag = far.contract(+) '||
      '  and dm1.pfz_ac_id = ama.pfz_ac_id '||
      '  and cm1.CONTACT_NAME = dm1.CONTACT_NAME '||
      '  and cm1.USER_ID = dm1.USER_ID '||
      '  AND dm1.TYPE ';
      if pWhichCursor != 'OWNER'
      then
         v_select_stmt := v_select_stmt || ' IN ('||''''||'NETWORK'||''''||','||''''|| 'SERVER'||''''||','||
	     ''''||'STORAGE'||''''||','||''''||'PERSONAL COMPUTER'||')';
	  else
	     v_select_stmt := v_select_stmt ||' = '||''''||'PERSONAL COMPUTER'||'''';
	  end if;
	  v_select_stmt := v_select_stmt ||
      ' AND dm1.SUBTYPE IN ('||''''||'SWITCH'||''''||','||''''||'ROUTER'||''''||','||''''||'CHECKPOINT'||''''||
      ','||''''||'HUB'||''''||','||''''||'ACCESS SERVER'||''''||','||''''||'PHYSICAL'||''''||','||''''|| 'CONTROLLER'
      ||','||''''||'NAS CONTROLLER'||''''||','||''''||'NAS FILE SERVER'||''''||','||''''||'SAN SWITCH'||''''||','
      ||''''||'STORAGE ARRAY'||''''||','||''''||'STORAGE UNIT'||''''||','||''''|| 'TAPE DRIVE'||''''||','||''''||
      'TAPE SILO'||''''||','||''''||'DESKTOP'||''''||','||''''||'LAPTOP'||''''||','||''''||'TABLET PC'||','||''''||
      'WIRELESS/ACCESS POINT'||''''||','||''''||'THIN CLIENT'||''''||')'||'  and dm1.pfz_managing_site '|| pArea||
      ' and NVL(dm1.type,''1'') '|| pCI_Type||
      ' and NVL(dm1.location,''1'') '|| pLocation||
      ' and NVL(cm1.pfz_bu,''1'') '|| pCI_Owner_Business_Unit||
      ' and NVL(cm1.dept,''1'') '|| pCI_Owner_Department_ID||
      ' and NVL(cm1.pfz_division,''1'') '|| pCI_Owner_Division||
      ' and NVL(cm1.pfz_charge_code,''1'') '|| pCI_Owner_Cost_Center||
      ' and NVL(cm1.dept_name,''1'') '|| pCI_Owner_Department_Name ||
      ' and NVL(dm1.pfz_managing_division,''1'') '||pDivisionManagedBy||
      ' and dm1.istatus in ('||''''||'Run'||''''||','||''''||'run'||''''||','||''''||'New'||''''||','||
      ''''||'RUN'||''''||','||''''||'Run - Update'||''''||')';
        outtext := v_select_stmt;
   end Assets_indvl_active_decomm;
end ac_reporting_pkg;
/
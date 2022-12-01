CREATE OR REPLACE PROCEDURE sp_AC_Assets_Retired (
	  rc_Assets_Retired		     		IN OUT   SYS_REFCURSOR,
	  pArea								IN   VARCHAR2,
	  pCI_Owner_Business_Unit			IN	 VARCHAR2,
	  pCI_Owner_Cost_Center				IN	 VARCHAR2,
	  pCI_Owner_Department_Name			IN	 VARCHAR2,
	  pCI_Owner_Division				IN   VARCHAR2,
	  pCI_Type							IN   VARCHAR2,
	  pDepartment						IN	 VARCHAR2,
	  pStartDate						IN	 VARCHAR2,
	  pEndDate							IN	 VARCHAR2
   ) as
/******************************************************************************
   NAME:       sp_AC_Assets_Retired
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/03/2006      			   1. Created this procedure.
   1.1		  12/12/2006	-shw-	 	   2. Allowances for NULL values 
   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     sp_AC_Assets_Retired
      Sysdate:         10/03/2006
      Date and Time:   10/03/2006, 1:53:04 PM, and 10/03/2006 1:53:04 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
      v_select_stmt		   varchar2 (32767);
   begin
	  v_select_stmt :=
	  'select distinct '
	  || pStartDate	|| ' as pStartDate,'
	  || pEndDate	|| ' as pEndDate,'
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
--	  || 'dev1.oncall,'
	  || 'dev1.pfz_added_time,'
	  || 'dev1.pfz_retired_time,'
	  || 'dev1.order_number,'
	  || 'dev1.pfz_purchase_date,'
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
	  || ' and NVL(user1.dept,''1'') ' || pDepartment
	  || ' and NVL(user1.dept_name,''1'') ' || pCI_Owner_Department_Name
	  || ' and NVL(user1.pfz_division,''1'') ' || pCI_Owner_Division
	  || ' and NVL(user1.pfz_bu,''1'') ' || pCI_Owner_Business_Unit
	  || ' and NVL(user1.pfz_charge_code,''1'') ' || pCI_Owner_Cost_Center
	  || ' and (f.cost is null or f.cost = 0)'
	  || ' and upper(dev1.ISTATUS) = ''RETIRED'''
	  || ' and dev1.PFZ_RETIRED_TIME between'
	  || ' to_date(''' || pStartDate || ''',''MM-DD-YYYY'')'
	  || ' and to_date(''' || pEndDate || ''',''MM-DD-YYYY'')';
 
	  open rc_Assets_Retired for v_select_stmt;
	  
   end sp_AC_Assets_Retired;
/

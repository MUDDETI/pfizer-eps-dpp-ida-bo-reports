CREATE OR REPLACE PROCEDURE sp_Assets_Pending_Retirement (

      rc_Assets_Pending_Ret 		 IN OUT   sys_refcursor,
      pArea								 IN       VARCHAR2,
      pCI_Type							 IN       VARCHAR2,
	  pManaging_Division				 IN		  VARCHAR2,
	  pLocation							 IN		  VARCHAR2,
	  pCI_Owner_Division				 IN       VARCHAR2,
	  pCI_Owner_Business_Unit			 IN		  VARCHAR2,
	  pCI_Owner_DepartmentID			 IN		  VARCHAR2,
	  pCI_Owner_Department_Name			 IN		  VARCHAR2,
	  pCI_Owner_Cost_Center				 IN		  VARCHAR2
   ) 
   is
/******************************************************************************
   NAME:       sp_Assets_Pending_Retirement
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/03/2006   Ron Gladski       1. Created this procedure.
   1.1		  12/12/2006	-shw-	 	   2. Allowances for NULL values 

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     sp_Assets_Pending_Retirement
      Sysdate:         10/03/2006
      Date and Time:   10/03/2006, 4:44:43 PM, and 10/03/2006 4:44:43 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
       v_select_stmt		   varchar2 (32767);
   begin
	  v_select_stmt :=
	  'select distinct '
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
	  || 'dev1.pfz_added_time,'
	  || 'dev1.order_number,'
	  || 'dev1.pfz_purchase_date,'
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
	  || ' from AC_AMASSET ac'
	  || ' inner join AC_CMDB_DEVICEM1 dev1'
	  || ' on dev1.PFZ_AC_ID = ac.PFZ_AC_ID'
	  || ' left join AC_AMPFZFAR f'
	  || ' on ac.serialno = f.serialno'
	  || ' and ac.assettag = f.contract'
	  || ' left join AC_CONTACTSM1 user1'
	  || ' on dev1.PFZ_FULL_NAME = user1.PFZ_FULL_NAME'
	  || ' where'
	  || ' NVL(dev1.type,''1'') ' || pCI_Type
	  || ' and NVL(dev1.pfz_managing_division,''1'') ' || pManaging_Division
	  || ' and NVL(dev1.location,''1'') ' ||pLocation
	  || ' and NVL(dev1.pfz_managing_site,''1'') ' || pArea 
	  || ' and nvl(user1.dept,''1'') ' || pCI_Owner_DepartmentID
	  || ' and nvl(user1.dept_name,''1'') ' || pCI_Owner_Department_Name
	  || ' and nvl(user1.pfz_division,''1'') ' || pCI_Owner_Division
	  || ' and nvl(user1.pfz_bu,''1'') ' || pCI_Owner_Business_Unit
	  || ' and nvl(user1.pfz_charge_code,''1'') ' || pCI_Owner_Cost_Center
	  || ' and upper(dev1.pfz_usage) = ''PENDING RETIREMENT''';
 
	  open rc_Assets_Pending_Ret for v_select_stmt;
	  
END sp_Assets_Pending_Retirement;
/

CREATE OR REPLACE PROCEDURE sp_Assets_Refresh_in_xYR (
      rc_Assets_Refresh_in_xYR     		 IN OUT   SYS_REFCURSOR,
      pArea								 IN       VARCHAR2,
	  pCI_Owner_Business_Unit			 IN		  VARCHAR2,
	  pCI_Owner_Cost_Center				 IN		  VARCHAR2,
	  pCI_Owner_Department_Name			 IN		  VARCHAR2,
	  pCI_Owner_Division				 IN       VARCHAR2,
      pCI_Type							 IN       VARCHAR2,
	  pDepartment						 IN		  VARCHAR2,
	  pDivisionManagedBy				 IN		  VARCHAR2,
	  pLocation							 IN		  VARCHAR2,
	  pThisORNextYr						 IN		  VARCHAR2
   ) 
   as
/******************************************************************************
   NAME:       sp_Assets_Refresh_in_xYR
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/21/2006   Ron Gladski    1. Created this procedure.
   2.0		  10.02.2006  Ron Gladski	 2. adjusted for new AMPFZFAR data 
   			  			  	  			 types
   3.0 		  12/12/2006	-shw-	 	   3. Allowances for NULL values 
   
   NOTES:


******************************************************************************/
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
	  || 'user1.pfz_bu as contactsm1_pfz_bu,'
	  || 'user1.dept as contactsm1_dept,'
	  || 'user1.pfz_division as contactsm1_pfz_division,'
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
	  || 'f.nbv as far_nbv,'
	  /*Calculate the Months past End Of Life, using a divisor of 30.5 
	  into the number of days diff*/
	  /*|| 'decode('
	  || 'sign('
	  || 'round(round(sysdate - to_date('
	  || '(substr(f.dateofacq,5,2) || ''/'' || substr(f.dateofacq,7,2) || ''/'' || (substr(f.dateofacq,1,4) + f.lifeyrs)),''MM/DD/YYYY'''
	  || ')) / 30)),-1,0,'*/
	  || 'round(round(sysdate - to_date('
	  || '(extract(month from f.dateofacq) || ''/'' || extract(day from f.dateofacq) || ''/'' || (extract(year from f.dateofacq) + f.lifeyrs)),''MM/DD/YYYY'''
	  || ')) / 30.5) as mthspastEOL'
	  || ' from '
	  || 'AC_AMASSET ac,'
	  || 'AC_AMPFZFAR f,'
	  || 'AC_CMDB_DEVICEM1 dev1,'
	  || 'AC_CONTACTSM1 user1'
	  || ' where '
	  || 'dev1.PFZ_AC_ID = ac.PFZ_AC_ID '
	  || 'and f.serialno = ac.serialno '
	  || 'and f.contract = ac.assettag '
	  || 'and dev1.USER_ID = user1.USER_ID (+) '
	  || 'and dev1.CONTACT_NAME = user1.CONTACT_NAME (+) '
	  || ' and NVL(dev1.type,''1'') ' || pCI_Type
	  || ' and NVL(dev1.pfz_managing_division,''1'') ' || pDivisionManagedBy 
	  || ' and NVL(dev1.location,''1'') ' || pLocation 
	  || ' and NVL(dev1.pfz_managing_site,''1'') ' || pArea 
	  || ' and NVL(user1.dept,''1'') ' || pDepartment
	  || ' and NVL(user1.dept_name,''1'') ' || pCI_Owner_Department_Name
	  || ' and NVL(user1.pfz_division,''1'') ' || pCI_Owner_Division
	  || ' and NVL(user1.pfz_bu,''1'') ' || pCI_Owner_Business_Unit
	  || ' and NVL(user1.pfz_charge_code,''1'') ' || pCI_Owner_Cost_Center;
	  
	  if (UPPER(pThisORNextYr) = 'NEXT') then
	  	  v_select_stmt := v_select_stmt 
--	  	  || ' and f.nbv = ''$0.00'''
--		  || ' and f.cost <> ''$0.00'''
		  || ' and f.cost <> 0'
		  || ' and ((f.yrofacq + f.lifeyrs) = (extract(YEAR FROM sysdate) + ''1''))';
	  elsif (UPPER(pThisORNextYr) = 'CURRENT') then
	  	  v_select_stmt := v_select_stmt
		  || ' and ((f.yrofacq + f.lifeyrs) = (extract(YEAR FROM sysdate) + ''0''))';
	  elsif (UPPER(pThisORNextYr) = 'OVERDUE') then
	  	  v_select_stmt := v_select_stmt
--		  || ' and f.cost <> ''$0.00'''
		  || ' and f.cost <> 0'
		  --dateofacq looks like this:  200310257
/*		  || ' and round(round(sysdate - to_date('
		  || '(substr(f.dateofacq,5,2) || ''/'' || substr(f.dateofacq,7,2) || ''/'' || (substr(f.dateofacq,1,4) + f.lifeyrs)),''MM/DD/YYYY'''
	  	  || ')) / 30.5) > 0';
*/
		  || ' and round(round(sysdate - to_date('
		  || '(extract(month from f.dateofacq) || ''/'' || extract(day from f.dateofacq) || ''/'' || (extract(year from f.dateofacq) + f.lifeyrs)),''MM/DD/YYYY'''
	  	  || ')) / 30.5) > 0';


	  else
	  	  v_select_stmt := v_select_stmt;
	  end if;			  		  
	  
	  open rc_Assets_Refresh_in_xYR for v_select_stmt;
	  
   end sp_Assets_Refresh_in_xYR;
/

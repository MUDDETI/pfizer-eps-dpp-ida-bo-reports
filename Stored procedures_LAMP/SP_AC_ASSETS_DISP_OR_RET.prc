CREATE OR REPLACE PROCEDURE sp_AC_Assets_Disp_or_Ret (
      rc_Assets_Disposed_or_Retired	     IN OUT   SYS_REFCURSOR,
      pArea								 IN       VARCHAR2,
      pCI_Type							 IN       VARCHAR2,
	  pRetiredDisposedFrom				 IN		  VARCHAR2
   ) 
   as
/******************************************************************************
   NAME:       sp_AC_Assets_Disp_or_Ret
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/21/2006   Ron Gladski    1. Created this procedure.
   2.0		  10.02.2006  Ron Gladski	 2. adjusted for new AMPFZFAR data 
   			  			  	  			 types
   
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
	  	  || ' and f.FULLDISPDATE <> to_date(''01-JAN-1901'')'
		  || ' and upper(dev1.istatus) != ''RETIRED''';
	  elsif (UPPER(pRetiredDisposedFrom) = 'RETIREDCMDB_FNWO') then
	  	  v_select_stmt := v_select_stmt
		  || 'and' 
		  || ' ('
		  || '  (ac.fixedastno = f.fixedastno)'
		  || ' or'
		  || '  (ac.serialno = f.serialno'
		  || '  or ac.assettag = f.contract)'
		  || ' or (ac.pfz_po_number = f.PONUMBER)'
		  /*also try by stripping off leading Company code prefix 
		  (eg: 140-N-754817 to N-754817 per Larry Morth*/
		  || ' or (decode(instr(ac.pfz_po_number,''-''),2,ac.pfz_po_number,substr(ac.pfz_po_number,instr(ac.pfz_po_number,''-'') + 1,(length(ac.pfz_po_number) - instr(ac.pfz_po_number,''-''))))'  
		  || ' = f.PONUMBER)'
		  || ' )'
/*		  || ' and f.fulldispdate = ''0'''*/
	  	  || ' and f.FULLDISPDATE = to_date(''01-JAN-1901'')'
/*	  	  || ' and TRIM(f.NBV) = ''$0.00'''*/
	  	  || ' and f.NBV = 0'
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
	  
   end sp_AC_Assets_Disp_or_Ret;
/

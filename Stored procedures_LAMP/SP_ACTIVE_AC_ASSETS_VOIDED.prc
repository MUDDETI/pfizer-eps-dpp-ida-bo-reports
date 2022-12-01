CREATE OR REPLACE PROCEDURE SCCICT_OWNER.sp_Active_AC_Assets_Voided (
      rc_Active_AC_Assets_Voided	     IN OUT   SYS_REFCURSOR,
      pLocation							 IN VARCHAR2
   ) 
   as
      v_select_stmt		   varchar2 (32767);
   begin
	  v_select_stmt :=
	  'SELECT distinct '
	  || 'dev1.logical_name,'
	  || 'dev1.network_name,'
	  || 'dev1.pfz_ac_id,'
	  || 'dev1.location,'
	  || 'dev1.type,'
	  || 'dev1.subtype,'
	  || 'dev1.description,'
	  || 'dev1.serial_no_,'
	  || 'dev1.pfz_ac_id,'
	  || 'dev1.istatus,'
	  || 'dev1.pfz_full_name,'
	  || 'dev1.pfz_fm_owner,'
	  || 'dev1.asset_tag,'
	  || 'dev1.manufacturer,'
	  || 'dev1.model,'
	  || 'dev1.pfz_assignment,'
	  || 'dev1.pfz_managing_site,'
	  || 'dev1.order_number,'
	  || 'dev1.pfz_purchase_date,'
	  || 'ac.status, ' 
	  || 'ac.pfz_AC_Id,' 
	  || 'ac.AssetTag, '
	  || 'B.seAssignment Assignment,'
	  || 'C.Name Model, '
	  || 'D.FullName Location '
	  || ' FROM '
	  || ' AC_AMASSET ac,'
	  || ' AC_AMPORTFOLIO B,'
	  || ' AC_AMMODEL C,'
	  || ' AC_AMLOCATION D,'
	  || ' AC_CMDB_DEVICEM1 dev1'
	  || ' WHERE'
	  || ' dev1.PFZ_AC_ID = ac.PFZ_AC_ID'
	  || ' and ac.LASTID = B.LASTID	'
  	  || ' and B.LMODELID = C.LMODELID	'	--> Join between Portfolio and Model (needed for Type and Subtype) 
  	  || ' and B.LLOCAID = D.LLOCAID '		--> Join between Portfolio and Location (Needed for site)  
 	  || ' and ac.status <> ''Disposed''' 
  	  || ' and ac.status <> ''Discontinued''' 
  	  || ' and ac.status <> ''Donated''' 
	  || ' and ac.status <> ''Not Found''' 
  	  || ' and ac.status <> ''Removed''' 
  	  || ' and ac.status <> ''Returned to Vendor''' 
  	  || ' and ac.status <> ''Retired''' 
  	  || ' and ac.status <> ''Disposed''' 
	  || ' and ac.status <> ''Sold''' 
      || ' and ac.status <> ''Void''' 
	  || ' and dev1.istatus = ''Void''';
  		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(dev1.location,'|| '''' || ' ' || '''' ||')', pLocation ) || ')';
	
	  open rc_Active_AC_Assets_Voided for v_select_stmt;
   end sp_Active_AC_Assets_Voided;
/
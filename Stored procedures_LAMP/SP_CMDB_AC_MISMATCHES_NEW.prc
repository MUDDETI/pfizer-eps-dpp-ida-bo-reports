CREATE OR REPLACE PROCEDURE SCCICT_OWNER.sp_CMDB_AC_MISMATCHES (
      sysrefcur		 		IN OUT	  sys_refcursor
  )	  
  IS
/******************************************************************************
   NAME:       sp_CMDB_AC_MISMATCHES
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/03/2006   Ron Gladski       1. Created this procedure.
   1.1		  12/12/2006	-shw-	 	   2. Allowances for NULL values 
   1.2		  12/14/2006	-shw-	 	   2. removed above 
   1.3		  11/01/2007	-sg-		   1. Fixed the In AC not in CMDB values
   1.4		  01/02/2008	-aj-		   1. Fixed the In Ac not in CMDB AssetTag and ComputerName
   1.5		  01/03/2008	-aj-		   1. Fixed the In CMDB not in AC NVL(cmdb.pfz_managing_division,''1'') = ''WTI'''	

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     sp_CMDB_AC_MISMATCHES
      Sysdate:         10/03/2006
      Date and Time:   10/03/2006, 4:44:43 PM, and 10/03/2006 4:44:43 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
  v_select_stmt		   varchar2(32767);
  CITypes			   varchar2(32767);
  CISubTypes		   varchar2(32767);

   begin

   CITypes := '(''NETWORK'', ''SERVER'', ''STORAGE'', ''PERSONAL COMPUTER'')';

   CISubTypes := '(''SWITCH'', ''ROUTER'', ''CHECKPOINT'', ''HUB'', ''ACCESS SERVER'', ''PHYSICAL'', ''CONTROLLER'',' 
   || '  ''NAS CONTROLLER'', ''NAS FILE SERVER'', ''SAN SWITCH'', ''STORAGE ARRAY'', ''STORAGE UNIT'', ''TAPE DRIVE'',' 
   || '  ''TAPE SILO'', ''DESKTOP'', ''LAPTOP'',''TABLET PC'',''WIRELESS/ACCESS POINT'',''THIN CLIENT'')';  
   
   v_select_stmt := 
   'SELECT ''In CMDB Not in AC'' as dataSource,'
	|| 'CMDB.NETWORK_NAME as CI_NETWORK_NAME,' 
	|| 'CMDB.PFZ_AC_ID as PFZ_AC_ID,' 
	|| 'CMDB.PFZ_FULL_NAME AS CI_PFZ_FULL_NAME,'
	|| 'CMDB.TYPE AS CI_TYPE,' 
	|| 'CMDB.SUBTYPE AS CI_SUBTYPE,'
	|| 'CMDB.ASSET_TAG AS ASSET_TAG,' 
	|| 'CMDB.SERIAL_NO_ AS SERIAL_NO,' 
	|| 'CMDB.MANUFACTURER AS CI_MANUFACTURER,' 
	|| 'CMDB.MODEL AS CI_MODEL,'
	|| 'CMDB.LOCATION AS CI_LOCATION,' 
	|| 'CMDB.BUILDING AS CI_BUILDING,'
	|| 'CMDB.FLOOR AS CI_FLOOR,'
	|| 'CMDB.ROOM AS CI_ROOM,'
	|| 'CMDB.ISTATUS as STATUS,'
	--see if we have an alternate links on
	--S/N, Asset Tag, or Network Name
	|| 'case'
	|| ' when (select distinct SERIAL_NO_' 
	|| '	 	  FROM AC_CMDB_DEVICEM1 C'
	|| '	 	  inner join AC_AMASSET A'
	|| '		  on c.SERIAL_NO_ = a.serialno'  
	|| '		  where c.NETWORK_NAME = CMDB.NETWORK_NAME) is not null then ''Y'''
	|| ' else '''''
	|| 'end as SN_Linked_Field,'
	|| 'case'
	|| ' when (select distinct ASSET_TAG' 
	|| '	 	  FROM AC_CMDB_DEVICEM1 C'
	|| '	 	  inner join AC_AMASSET A'
	|| '		  on c.ASSET_TAG = a.ASSETTAG'  
	|| '		  where c.NETWORK_NAME = CMDB.NETWORK_NAME) is not null then ''Y'''
	|| ' else '''''
	|| 'end as AssetTag_Linked_Field,'
	|| 'case'
	|| ' when (select distinct NETWORK_NAME' 
	|| '	 	  FROM AC_CMDB_DEVICEM1 C'
	|| '	 	  inner join AC_AMASSET A'
	|| '		  on c.NETWORK_NAME = a.PFZCINAME' 
	|| '		  where c.NETWORK_NAME = CMDB.NETWORK_NAME) is not null then ''Y'''
	|| ' else '''''
	|| 'end as NetworkName_Linked_Field'
	|| ' FROM AC_CMDB_DEVICEM1 CMDB'
	|| ' inner join AC_AMLOCATION l'
	|| ' on cmdb.location = L.NAME'
	|| ' left join AC_AMASSET AC'
	|| ' on CMDB.PFZ_AC_ID = AC.PFZ_AC_ID'
	|| ' WHERE AC.PFZ_AC_ID IS NULL'
	|| ' and CMDB.TYPE IN ' || CITypes
	|| ' and CMDB.SUBTYPE IN ' || CISubTypes  
	|| ' and NVL(cmdb.pfz_managing_division,''1'') = ''WTI'''
	|| ' and upper(cmdb.istatus) not in (''RETIRED'',''VOID'')'
	|| ' and l.bcreateci = 1'
	|| ' and l.slvl = 1'
	|| ' union'
	|| ' SELECT distinct'
	|| '''In AC Not in CMDB'' as dataSource,'
	|| 'AMCOMP.NAME AS CI_NETWORK_NAME,'
	|| 'AC.PFZ_AC_ID AS PFZ_AC_ID,' 
	|| ''''' AS CI_PFZ_FULL_NAME,' --Client has to get back on AC field information
	|| 't.NAME AS CI_TYPE,' 
	|| 'st.NAME AS CI_SUBTYPE,' 
	|| 'AC.ASSETTAG AS ASSET_TAG,' 
	|| 'ac.serialno as SERIAL_NO,' 
	|| 'b.name  AS CI_MANUFACTURER,'
	|| 'cast(m.NAME as varchar2(60)) AS CI_MODEL,'
	|| 'l.CITY AS CI_LOCATION,' 
	|| ''''' AS CI_BUILDING,' --Client has to get back on AC field information
	|| ''''' AS CI_FLOOR,' --Client has to get back on AC field information
	|| ''''' AS CI_ROOM,' --Client has to get back on AC field information
	|| 'AC.STATUS as STATUS,'
	--see if we have an alternate link on
	--S/N, Asset Tag, or Network Name
	|| 'case'
	|| ' when (select distinct serialno' 
	|| '	 	  FROM AC_AMASSET A'
	|| '	 	  inner join AC_CMDB_DEVICEM1 C'
	|| '		  on c.SERIAL_NO_ = a.serialno'  
	|| '		  where a.pfz_ac_id = AC.PFZ_AC_ID) is not null then ''Y'''
	|| ' else '''''
	|| 'end as SN_Linked_Field,'
	|| 'case'
	|| ' when (select distinct ASSETTAG' 
	|| '	 	  FROM AC_AMASSET A'
	|| '	 	  inner join AC_CMDB_DEVICEM1 C'
	|| '		  on c.ASSET_TAG = a.ASSETTAG'  
	|| '		  where a.pfz_ac_id = AC.PFZ_AC_ID) is not null then ''Y'''
	|| ' else '''''
	|| 'end as AssetTag_Linked_Field,'
	|| 'case'
	|| ' when (select distinct PFZCINAME' 
	|| '	 	  FROM AC_AMASSET A'
	|| '	 	  inner join AC_CMDB_DEVICEM1 C'
	|| '		  on c.NETWORK_NAME = a.PFZCINAME' 
	|| '		  where a.pfz_ac_id = AC.PFZ_AC_ID) is not null then ''Y'''
	|| ' else '''''
	|| 'end as NetworkName_Linked_Field'
	|| ' FROM AC_AMASSET AC'
	|| ' left join AC_CMDB_DEVICEM1 CMDB'
	|| ' on AC.PFZ_AC_ID = CMDB.PFZ_AC_ID'
	|| ' inner join AC_AMMODEL M'
	|| ' on ac.LMODELID = m.LMODELID'
	|| ' inner join AMCOMPUTER AMCOMP'
	|| ' on AC.ASSETTAG= AMCOMP.ASSETTAG'
	|| ' inner join AC_AMMODEL st'
	|| ' on m.LPARENTID = st.LMODELID'
	|| ' inner join AC_AMMODEL t'
	|| ' on st.LPARENTID = t.LMODELID'
	|| ' inner join AC_AMBRAND b'
	|| ' on b.LBRANDID = t.LBRANDID'
	|| ' left join AC_AMPORTFOLIO p'
	|| ' on ac.ASSETTAG = p.ASSETTAG'
	|| ' inner join AC_AMLOCATION l'
	|| ' on p.LLOCAID = l.LLOCAID'
	|| ' WHERE CMDB.PFZ_AC_ID IS NULL'
	|| ' AND t.name IN ' || CITypes
	|| ' AND st.name IN ' || CISubTypes
	|| ' and upper(ac.status) not in (''RETIRED'',''SOLD'', ''VOID'', ''ARCHIVED'')'
	|| ' and l.bcreateci = 1'
	|| ' and l.slvl = 1';

   open sysrefcur for v_select_stmt;
	 
END sp_CMDB_AC_MISMATCHES;
/
CREATE OR REPLACE PROCEDURE sp_CMDB_AC_DUPES (
      sysrefcur	  			IN OUT	  sys_refcursor,
      pCI_Type				IN 		  VARCHAR2,
	  pCI_CMDBIStatus		IN		  VARCHAR2,
	  pCI_ACStatus			IN		  VARCHAR2,
	  pCI_Location			IN		  VARCHAR2
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

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     sp_CMDB_AC_MISMATCHES
      Sysdate:         10/03/2006
      Date and Time:   10/03/2006, 4:44:43 PM, and 10/03/2006 4:44:43 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
  v_select_stmt		   varchar2(32767);

   begin

--add alternate system lookup to show if it exists in the other system
   
   v_select_stmt := 
   'SELECT ''CMDB dupes'' as dataSource,'
	|| 'CMDB.NETWORK_NAME as CI_NETWORK_NAME,' 
	|| 'CMDB.PFZ_AC_ID as PFZ_AC_ID,' 
	|| 'CMDB.DESCRIPTION as DESCRIPTION,' 
	|| 'CMDB.ISTATUS as STATUS,'
	|| 'CMDB.PFZ_FULL_NAME AS CI_OWNER,'
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
	|| 'CMDB.pfz_managing_site as PFZ_MANAGING_SITE,'	
	|| 'CMDB.LOGICAL_NAME as CI_LOGICAL_NAME,' 
	|| 'case'
	|| ' when (select count(pfz_ac_id)' 
	|| '	 	  FROM AC_AMASSET'
	|| '		  where pfz_ac_id = cmdb.pfz_ac_id) > 0 then ''in AC'''
	|| ' else '''''
	|| 'end as "Other source system lookup"'
	|| ' FROM AC_CMDB_DEVICEM1 CMDB'
	|| ' WHERE CMDB.PFZ_AC_ID in'
	|| ' (SELECT pfz_ac_id'
	|| ' FROM ac_cmdb_devicem1 GROUP BY pfz_ac_id HAVING Count(*)>1)'
	|| ' and upper(cmdb.subtype) not in (''PDA'',''MONITOR'',''PRINTER'',''DOCKING STATION'')'
	|| ' and NVL(CMDB.TYPE,''1'') ' || pCI_Type
	|| ' and NVL(cmdb.istatus,''1'') ' || pCI_CMDBIStatus
	|| ' and NVL(cmdb.location,''1'') ' || pCI_Location
	|| ' union all'
	|| ' SELECT '
	|| '''AC dupes'' as dataSource,'
	|| ''''' AS CI_NETWORK_NAME,' 
	|| 'AC.PFZ_AC_ID AS PFZ_AC_ID,' 
	|| 'm.name as DESCRIPTION,' 
	|| 'AC.STATUS as STATUS,'
	|| ''''' AS CI_OWNER,'
	|| 't.NAME AS CI_TYPE,' 
	|| 'st.NAME AS CI_SUBTYPE,' 
	|| 'ac.ASSETTAG AS ASSET_TAG,' 
	|| 'ac.serialno as SERIAL_NO,' 
	|| 'b.name AS CI_MANUFACTURER,' 
	|| ''''' AS CI_MODEL,'
	|| 'l.CITY AS CI_LOCATION,' 
	|| ''''' AS CI_BUILDING,' 
	|| ''''' AS CI_FLOOR,'
	|| ''''' AS CI_ROOM,'
	|| ''''' as PFZ_MANAGING_SITE,'
	|| ''''' as CI_LOGICAL_NAME,'
	|| 'case'
	|| ' when (select count(pfz_ac_id)' 
	|| '	 	  FROM ac_cmdb_devicem1'
	|| '		  where pfz_ac_id = ac.pfz_ac_id) > 0 then ''in CMDB'''
	|| ' else '''''
	|| 'end as "Other source system lookup"'
	|| ' FROM AC_AMASSET AC'
	|| ' inner join AC_AMMODEL M'
	|| ' on ac.LMODELID = m.LMODELID'
	|| ' inner join AC_AMMODEL st'
	|| ' on m.LPARENTID = st.LMODELID'
	|| ' inner join AC_AMMODEL t'
	|| ' on st.LPARENTID = t.LMODELID'
	|| ' inner join AC_AMPORTFOLIO p'
	|| ' on ac.ASSETTAG = p.ASSETTAG'
	|| ' inner join AC_AMLOCATION l'
	|| ' on p.LLOCAID = l.LLOCAID'
	|| ' left join AC_AMBRAND b'
	|| ' on m.lbrandid = b.lbrandid'
	|| ' WHERE ac.pfz_ac_id in'
	|| ' (SELECT pfz_ac_id'
	|| ' FROM AC_AMASSET GROUP BY pfz_ac_id HAVING Count(*)>1)'
	|| ' and upper(st.name) not in (''PDA'',''MONITOR'',''PRINTER'',''DOCKING STATION'')'
	|| ' AND NVL(t.name,''1'') ' || pCI_Type
	|| ' AND NVL(ac.status,''1'') ' || pCI_ACStatus
	|| ' and NVL(l.city,''1'') ' || pCI_Location;
--	|| ' and l.bcreateci = 1'
--	|| ' and l.slvl = 1'*/;

   open sysrefcur for v_select_stmt;
	 
END sp_CMDB_AC_DUPES;
/

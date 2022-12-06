CREATE OR REPLACE PACKAGE bipkg_cmdb
AS
   TYPE bisp_refcursor_type IS REF CURSOR;

   -- sg 23-jun-2006 created procedure for added logical and related physical servers report
   
   PROCEDURE bisp_cmdb_al_rp_servers (
      cmdb_alrp_cursor   IN OUT   bisp_refcursor_type,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE
   );
   
   FUNCTION bifnc_cmdb_server_adddate (
      pistatus varchar2,
      padded date, 
	  pdecom date, 
	  pfmstart date, 
	  pfmend date,
	  pretired date,
	  psysmod date
   ) return date;
   
END bipkg_cmdb;
/
CREATE OR REPLACE PACKAGE BODY bipkg_cmdb
AS

   -- sg 23-jun-2006 created procedure for Added Logical and Related Physical Servers report
   PROCEDURE bisp_cmdb_al_rp_servers (
      cmdb_alrp_cursor				 IN OUT   bisp_refcursor_type,
	  pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE
   )
   IS
      v_startdatedisplay   VARCHAR2 (19);
      v_enddatedisplay     VARCHAR2 (19);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_gmt_startdate_str  VARCHAR2 (19);
	  v_gmt_enddate_str	   VARCHAR2 (19);
      v_db_zone            VARCHAR2 (3);
      v_select_stmt		   VARCHAR2 (32767);
   BEGIN
      v_db_zone := 'GMT';
      bipkg_utils.bisp_getstartandenddates (pfrequency,poverride,pzone,pstartdate,penddate,v_gmt_startdate,v_gmt_enddate)                    ;
      v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
      v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
      v_gmt_startdate_str  := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
	  v_gmt_enddate_str    := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');
	  v_select_stmt :=
	  'select '
	  || ' devicem1.type type_l,'
	  || ' devicem1.subtype subtype_l,'
	  || ' devicem1.network_name network_name_l,'
	  || ' devicem1.serial_no_ serial_no__l,'
	  || ' devicem1.istatus istatus_l,'
	  || ' devicem1.pfz_fm_service pfz_fm_service_l,'
	  || ' devicem1.pfz_addition_reason pfz_addition_reason_l,'  
	  || ' devicem1.description description_l,'	  
	  || ' devicem1.pfz_usage pfz_usage_l,'
	  || ' devicem1.location location_l,'
	  || ' devicem1.pfz_assignment pfz_assignment_l,'
	  || ' devicem1.pfz_ext_ref pfz_ext_ref_l,'
	  || ' devicem1.pfz_ext_ref_id pfz_ext_ref_id_l,'
	  || ' devicem1.pfz_full_name pfz_full_name_l,'
	  || ' devicem1.logical_name logical_name_l,'
	  || ' bipkg_utils.bifnc_adjustfortz(devicem1.pfz_retired_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') pfz_retired_time,'	  
	  || ' bipkg_utils.bifnc_adjustfortz(devicem1.pfz_added_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') pfz_added_time,'
	  || ' bipkg_utils.bifnc_adjustfortz(devicem1.pfz_decom_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') pfz_decom_time,'	  
	  || ' bipkg_utils.bifnc_adjustfortz(devicem1.pfz_fm_start,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') pfz_fm_start,'
	  || ' bipkg_utils.bifnc_adjustfortz(devicem1.pfz_fm_end,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') pfz_fm_end,'	  
	  || ' bipkg_utils.bifnc_adjustfortz(devicem1.sysmodtime,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') sysmodtime,'
	  || ' bipkg_utils.bifnc_adjustfortz(bipkg_cmdb.bifnc_cmdb_server_adddate(devicem1.istatus, devicem1.pfz_added_time, devicem1.pfz_decom_time, devicem1.pfz_fm_start, devicem1.pfz_fm_end, devicem1.pfz_retired_time, devicem1.sysmodtime),'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') serveraddtime,'
	  || ' devicem1_1.network_name network_name_p,'
	  || ' devicem1_1.type type_p,'
	  || ' devicem1_1.subtype subtype_p,'
	  || ' devicem1_1.istatus istatus_p,'
	  || ' devicem1_1.pfz_fm_owner pfz_fm_owner_p,'
	  || ' devicem1_1.manufacturer manufacturer_p,'
	  || ' devicem1_1.model model_p,'
	  || ' devicem1_1.pfz_region pfz_region_p,'
	  || ' devicem1_1.location location_p,'
	  || ' devicem1_1.pfz_usage pfz_usage_p,'
	  || ' devicem1_1.pfz_addition_reason pfz_addition_reason_p,'	  
	  || ' devicea5.pfz_divisions,'
	  || ' devicea5.pfz_bus,'
	  || ' devicea5.pfz_percentages,'
	  || ' dm_priorlife.nr_of_lives,'
	  || ' ''' || v_startdatedisplay || '''' || ' StartDateDisplay,' 
	  || ' ''' || v_enddatedisplay || '''' || ' EndDateDisplay'  
	  || ' from' 
	  || ' ('
	  || ' devicem1 left outer join devicem1 devicem1_1'
	  || ' on devicem1.serial_no_ = devicem1_1.network_name'
	  || ' )' 
	  || ' left outer join devicea5'
	  || ' on devicem1.logical_name = devicea5.logical_name'
	  || ' left outer join '
	  || ' ('
	  || ' select devicem1.serial_no_, count(*) nr_of_lives from devicem1 where'
	  || ' devicem1.subtype in (''' || 'FARM GUEST' || ''', ''' || 'LOGICAL' || ''')'
	  || ' and devicem1.istatus in (''' || 'Decommissioned' || ''', ''' || 'Retired' || ''')'
	  || ' group by devicem1.serial_no_'
	  || ' ) dm_priorlife'
	  || ' on devicem1.serial_no_ = dm_priorlife.serial_no_'
	  || ' where'
	  || ' devicem1.type = ''' || 'SERVER' || ''''
	  || ' and devicem1.subtype in (''' || 'FARM GUEST' || ''', ''' || 'LOGICAL' || ''')' 
	  || ' and devicem1.istatus <> ' || '''' || 'Void' || ''''
	  || ' and (devicem1_1.type is null or devicem1_1.type = ''' || 'SERVER' || ''')'
	  || ' and bipkg_cmdb.bifnc_cmdb_server_adddate(devicem1.istatus, devicem1.pfz_added_time, devicem1.pfz_decom_time, devicem1.pfz_fm_start, devicem1.pfz_fm_end, devicem1.pfz_retired_time, devicem1.sysmodtime) between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''')'
	  ;
     open cmdb_alrp_cursor for v_select_stmt ;
   END bisp_cmdb_al_rp_servers;
   
--   27-Jun-2006 - SG - Created this funtion to get the Server Added DateTime
   function bifnc_cmdb_server_adddate (
      pistatus varchar2,
      padded date, 
	  pdecom date, 
	  pfmstart date, 
	  pfmend date,
	  pretired date,
	  psysmod date
   ) return date
   is
   voutdate date;
   vmaxdate date := to_date('01-01-4000 00:00:00', 'DD-MM-YYYY HH24:MI:SS');
   begin
   if padded = null then 
      if pistatus in ('New', 'Build', 'Run', 'Run - Update') then 
	     if pfmstart = null then
		    voutdate := psysmod; --active, no added_time, no fm_start, use last update
		 else
		    voutdate := pfmstart; --active, no added_time, valid fm_start
		 end if;
	  elsif pistatus = 'Retired' then
	     if pfmend = null then
		    if pretired = null or pretired >= vmaxdate then
			   voutdate := psysmod;
			else
			   voutdate := pretired;
			end if;
		 else
		    voutdate := pfmend;
		 end if;
	  elsif pistatus = 'Decommissioned' then
	     if pfmend = null or pfmend >= vmaxdate then
		    if pdecom = null or pdecom >= vmaxdate then
			   voutdate := psysmod;
			else
			   voutdate := pdecom;
			end if;
		 else
		    voutdate := pfmend;
		 end if;	  
	  else 
	     voutdate := psysmod;
	  end if;
   else
      if pistatus in ('New', 'Build', 'Run', 'Run - Update') then 
	     voutdate := padded;
	  elsif pistatus = 'Retired' then
	     if pfmend = null then
		    if pretired = null or pretired >= vmaxdate then
			   if pretired >= padded then
			      voutdate := padded;
			   else
			      voutdate := pretired;
			   end if;
			else
			   voutdate := pretired;
			end if;
		 elsif pfmend >= padded then
		    voutdate := padded;
		 else
		    voutdate := pfmend;
		 end if;
	  elsif pistatus = 'Decommissioned' then
	     if pfmend = null then
		    if pdecom = null or pdecom >= vmaxdate then
			   if psysmod >= padded then
			      voutdate := padded;
			   else
			      voutdate := psysmod;
			   end if;
			elsif pdecom >= padded then
			   voutdate := padded;
			else
			   voutdate := pdecom;
			end if;
		 elsif pfmend >= padded then
		    voutdate := padded;
		 else
		    voutdate := pfmend;
		 end if;  
	  else 
	     voutdate := padded;
	  end if;
   end if;
   return voutdate;
   end bifnc_cmdb_server_adddate;

END bipkg_cmdb;
/


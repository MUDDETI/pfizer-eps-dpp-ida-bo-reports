CREATE OR REPLACE PACKAGE Bipkg_Incidents
AS
/******************************************************************************
   NAME:       bipkg_incidents
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
    1.0		   05/12/2006 				   1. Created bisp_select inc 
   1.0        05/24/2006     -shw-        1. Created bisp_select_prb 
   1.0		  05/24/2006	 -shw-		  1. Created bisp_select_inc_site 
   1.0		  05.26.06		 -shw-		  1. created bisp_select_hndld    
   1.0		  05.30.06		 -shw-		  1. created bisp_select_asgnd   
   1.0		  06.02.06		 -shw-		  1. Created bisp_select_inc_act 
   1.0		  06.20.06		 -shw-		  1. Created bisp_select_opn_inc 
   1.0		  06.30.06		 -shw-		  1. NEW34 - Open or Closed Calls/Incidents by Product
   			  				 			  	 Created bisp_select_inc_prd 
	1.0		  07.05.06		 -shw-		  1. NEW31_Resolved Ticket Report by Related ProjectDivisionSpecailFlag
			  				 			  	 Created bisp_select_inc_spflg 
	1.0		  07.10.06	     -shw-		  1. Created bisp_select_inc_closed 							 										 
	1.0		  07.17.06		 -shw-		  1. NEW07 Created bisp_select_inc_OorC 
			  				 			  2. bisp_select_activity_detail 
	1.0		   08.12.06		 -shw-		   1. Created bisp_select_clo_inc 
	1.0		   08.11.06		 -shw-		   1. Created bisp_select_inc_actvty for Daily Summary Report 
	1.0		   08.22.06		 -shw-		   1. Created bisp_select_opened_tickets - for Messaging graphs by Hour/Month report(s)
	1.0		   08.22.06		 -shw-		   1. Created bisp_select_open_inc_grp_analyst - for 	Open Tickets Analysis report  
	1.0		   10.16.06		 -shw-		   1. created bisp_select_closed_respond for SLA Compliance Trending report. 
	1.0		   10.17.06		 -shw-		   1. created bisp_opened_location for Tickets Opend by Hour Graph 
	1.0        10.18.06	     RIthesh       1. Created BISP_SELECT_PTOC_KBCANDIDATES for roblem Tickets Opened & Closed in a Period by KB Candidates-SPROC.rpt
	   1.0		  02.19.07		 -sg-		   1. Created bisp_operator_analysis for Operator Analysis Report
******************************************************************************/

   TYPE bisp_refcursor_type IS REF CURSOR;

   PROCEDURE bisp_select_inc (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
	  pfrequency		 IN		  VARCHAR2,
	  poverride			 IN		  VARCHAR2,
	  pzone				 IN		  VARCHAR2,
	  pstartdate         IN       DATE,
      penddate           IN       DATE
   );
   PROCEDURE bisp_select_opn_inc_by_country (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      pcountry           IN       VARCHAR2,
	  pzone				 IN		  VARCHAR2
   );
   PROCEDURE bisp_select_opn_inc_grp_anlyst (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      panalyst           IN       VARCHAR2,
	  pzone				 IN		  VARCHAR2
   );
   PROCEDURE bisp_select_inc_actvty (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
	  pproduct			 IN	      VARCHAR2,
	  pfrequency		 IN		  VARCHAR2,
	  poverride			 IN		  VARCHAR2,
	  pzone				 IN		  VARCHAR2,
	  pstartdate         IN       DATE,
      penddate           IN       DATE
   );
   PROCEDURE bisp_select_clo (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
	  pproduct			 IN	      VARCHAR2,
	  pfrequency		 IN		  VARCHAR2,
	  poverride			 IN		  VARCHAR2,
	  pzone				 IN		  VARCHAR2,
	  pstartdate         IN       DATE,
      penddate           IN       DATE
   );
   PROCEDURE bisp_select_opn_inc (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
	  pproduct			 IN	   	  VARCHAR2,
	  pdept				 IN	      VARCHAR2,
	  pbu				 IN	      VARCHAR2,
	  pfrequency		 IN		  VARCHAR2,
	  poverride			 IN		  VARCHAR2,
	  pzone				 IN		  VARCHAR2,
	  pstartdate         IN       DATE,
      penddate           IN       DATE
   );
-- 08.22.06 Created bisp_select_opened_tickets - for Messaging graphs by Hour/Month report(s)
   PROCEDURE bisp_select_opened_tickets (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
	  pproduct			 IN	      VARCHAR2,
	  pfrequency		 IN		  VARCHAR2,
	  poverride			 IN		  VARCHAR2,
	  pzone				 IN		  VARCHAR2,
	  pstartdate         IN       DATE,
      penddate           IN       DATE
   );
-- 10.17.06 Created bisp_opened_loctn - for Opened by Hour Graph 
   PROCEDURE bisp_select_opened_location (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
	  plocation			 IN	      VARCHAR2,
	  pfrequency		 IN		  VARCHAR2,
	  poverride			 IN		  VARCHAR2,
	  pzone				 IN		  VARCHAR2,
	  pstartdate         IN       DATE,
      penddate           IN       DATE
   );
   
   
   -- 10.18.06 Created bisp_select_PTOC_KBCANDIDATES - for OProblem Tickets Opened & Closed in a Period by KB Candidates-SPROC.rpt 
   PROCEDURE bisp_select_PTOC_KBCANDIDATES (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
	  pfrequency		 IN		  VARCHAR2,
	  poverride			 IN		  VARCHAR2,
	  pzone				 IN		  VARCHAR2,
	  pstartdate         IN       DATE,
      penddate           IN       DATE
   );
   
   
   
   PROCEDURE bisp_select_inc_act (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
	  popenorclosed		 IN		  VARCHAR2,
	  pfrequency		 IN		  VARCHAR2,
	  poverride			 IN		  VARCHAR2,
	  pzone				 IN		  VARCHAR2,
	  pstartdate         IN       DATE,
      penddate           IN       DATE
   );
-- 07.17.06-shw- Activity Detail 
   PROCEDURE bisp_select_activity_detail (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      pnumberprgn   	 IN       VARCHAR2,
	  pzone				 IN		  VARCHAR2
   );
-- 07.17.06-shw- NEW07_Opened or Closed or Opened And Closed Probsummary 
   PROCEDURE bisp_select_inc_OorC (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
	  popenorclosed		 IN		  VARCHAR2,
	  pfrequency		 IN		  VARCHAR2,
	  poverride			 IN		  VARCHAR2,
	  pzone				 IN		  VARCHAR2,
	  pstartdate         IN       DATE,
      penddate           IN       DATE
   );
   PROCEDURE bisp_select_inc_prd (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      plocation          IN       VARCHAR2,
      pcountry           IN       VARCHAR2,
	  pproduct			 IN	   	  VARCHAR2,
	  popenorclosed		 IN		  VARCHAR2,
	  pfrequency		 IN		  VARCHAR2,
	  poverride			 IN		  VARCHAR2,
	  pzone				 IN		  VARCHAR2,
	  pstartdate         IN       DATE,
      penddate           IN       DATE
   );
   PROCEDURE bisp_select_inc_spflg (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      pdivision          IN       VARCHAR2,
      pspecialflag       IN       VARCHAR2,
	  pproject  		 IN	   	  VARCHAR2,
	  popenorclosed		 IN		  VARCHAR2,
	  pfrequency		 IN		  VARCHAR2,
	  poverride			 IN		  VARCHAR2,
	  pzone				 IN		  VARCHAR2,
	  pstartdate         IN       DATE,
      penddate           IN       DATE
   );
-- 12.05.06-shw- added Project & Division params for J&J Transition (PCH) 
   PROCEDURE bisp_select_inc_divprj (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      plocation          IN       VARCHAR2,
	  pfrequency		 IN		  VARCHAR2,
	  poverride			 IN		  VARCHAR2,
	  pzone				 IN		  VARCHAR2,
	  pstartdate         IN       DATE,
      penddate           IN       DATE,
      pproject			 IN	      VARCHAR2,
	  pdivision			 IN	      VARCHAR2
   );
   PROCEDURE bisp_select_inc_site (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      plocation          IN       VARCHAR2,
	  pfrequency		 IN		  VARCHAR2,
	  poverride			 IN		  VARCHAR2,
	  pzone				 IN		  VARCHAR2,
	  pstartdate         IN       DATE,
      penddate           IN       DATE
   );
   PROCEDURE bisp_select_prb (
      select_prb_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      plocation           IN       VARCHAR2,
	  pcallorigin		  IN	   VARCHAR2,
	  pcontactname		  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   );
   PROCEDURE bisp_select_hndld (
      select_prb_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   );
   PROCEDURE bisp_select_in_queue (
      select_inq_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   );
   PROCEDURE bisp_select_assigned (
      select_prb_cursor   IN OUT   bisp_refcursor_type,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   );
   PROCEDURE bisp_select_closed (
      select_closed_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   );
   
   PROCEDURE bisp_select_closed_respond (
      select_closed_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   );
   -- This procedure will create the common SQL statement for the probsummarym1 table, and return it in
   -- 2 parts: the select clause and the from and where clause.
   -- All other procedures based on probsummarym1 should first call this procedure, and then 
   -- add on to the returned SQL statement.
--    PROCEDURE bisp_create_basic_probsumsql (
--       vselectclause	  OUT	   VARCHAR2, -- select clause
--       vfromwhereclause	  OUT	   VARCHAR2, -- from and where clause combined.
--       v_gmt_startdate    OUT	   DATE,
--       v_gmt_enddate      OUT  	   DATE,
--       pfrequency          IN      VARCHAR2,
--       poverride           IN      VARCHAR2,
--       pzone               IN      VARCHAR2,
--       pstartdate          IN      DATE,
--       penddate            IN      DATE
--    );
   -- For Combined Report #24.
   PROCEDURE bisp_select_inc_by_parm(
      --vsql	 			  OUT	VARCHAR2,
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignment         IN       VARCHAR2,
	  popen_group		  IN	   VARCHAR2,
	  pgroup_by			  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   );
   
   PROCEDURE bisp_operator_analysis (
      operator_analysis_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   );
   
END Bipkg_Incidents;
/
CREATE OR REPLACE PACKAGE BODY Bipkg_Incidents
AS
/******************************************************************************
   NAME:       bipkg_incidents
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
    1.0		   05/12/2006 				   1. Created bisp_select inc 
   1.0        05/24/2006     -shw-        1. Created bisp_select_prb 
   1.0		  05/24/2006	 -shw-		  1. Created bisp_select_inc_site 
   1.0		  05.26.06		 -shw-		  1. created bisp_select_hndld    
   1.0		  05.30.06		 -shw-		  1. created bisp_select_asgnd   
   1.0		  06.02.06		 -shw-		  1. Created bisp_select_inc_act 
   1.0		  06.20.06		 -shw-		  1. Created bisp_select_opn_inc 
   1.0		  06.30.06		 -shw-		  1. NEW34 - Open or Closed Calls/Incidents by Product 
   			  				 			  	 Created bisp_select_inc_prd 										 
	1.0		  07.05.06		 -shw-		  1. NEW31_Resolved Ticket Report by Related ProjectDivisionSpecailFlag 
			  				 			  	 Created bisp_select_inc_spflg 
	1.0		  07.10.06	     -shw-		  1. Created bisp_select_inc_closed 							 										 
	1.0		  07.17.06		 -shw-		  1. NEW07 Created bisp_select_inc_OorC 
			  				 			  2. bisp_select_activity_detail 
	1.0		   08.01.06		 -shw-         added both open & closed to NEW34 (bisp_select_prb) 
	1.0		   08.11.06		 -shw-		   1. Created bisp_select_clo_inc 
	1.0		   08.11.06		 -shw-		   1. Created bisp_select_inc_actvty for Daily Summary Report 
	1.0		   08.16.06		 -shw-		   1. Created bisp_select_open_inc_by_country 
	1.0		   08.22.06		 -shw-		   1. Created bisp_select_opened_tickets - for Messaging graphs by Hour/Month report(s)
	1.0		   08.22.06		 -shw-		   1. Created bisp_select_open_inc_grp_analyst - for 	Open Tickets Analysis report 
	1.0		   10.10.06		 -shw-		   1. Added 'flag' to promsummarym1 selects, for speed.  
	1.0		   10.16.06		 -shw-		   1. created bisp_select_closed_respond for SLA Compliance Trending report. 
	1.0		   10.17.06		 -shw-		   1. created bisp_opened_location for Tickets Opend by Hour Graph 
   1.0        10.17.06	     RIthesh       1. Created BISP_SELECT_PTOC_KBCANDIDATES for roblem Tickets Opened & Closed in a Period by KB Candidates-SPROC.rpt
   1.0		  02.19.07		 -sg-		   1. Created bisp_operator_analysis for Operator Analysis Report
******************************************************************************/
--
-- Error Handling is done by the report. We do not trap any exceptions at the Database side.
--
   PROCEDURE bisp_select_inc (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.category, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.commodity, probsummarym1.country, probsummarym1.dept,probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_charge_code, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.problem_status, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.open_group', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || '''' ;
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || ''; 
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc;


   PROCEDURE bisp_select_opn_inc_grp_anlyst (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      panalyst           IN       VARCHAR2,
	  pzone				 IN		  VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_currentdate        VARCHAR(50);
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		v_currentdate := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(SYSDATE, 'EST', pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.category, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.commodity, probsummarym1.country, probsummarym1.dept,probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_charge_code, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.problem_status, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, '|| '''' || v_currentdate || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.open_group', porig_group ) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignee_name', panalyst) || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 't' || '''' || ''; 
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_opn_inc_grp_anlyst;

-- Created bisp_select_open_inc_by_country  for Open Incidents Detail by Country-Assignment report 

   PROCEDURE bisp_select_opn_inc_by_country (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      pcountry            IN       VARCHAR2,
      pzone               IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_currentdate        VARCHAR(50);
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		v_currentdate := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(SYSDATE, 'EST', pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.category, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.commodity, probsummarym1.country, probsummarym1.dept,probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_charge_code, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.problem_status, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, '|| '''' || v_currentdate || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.country', pcountry) || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 't' || '''' || ''; 
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_opn_inc_by_country;

-- 	 Created bisp_select_inc_actvty for Daily Summary Report 

   PROCEDURE bisp_select_inc_actvty (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
	  pproduct			  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdatem1    DATE;
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.country, probsummarym1.dept,probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_charge_code, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.problem_status, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.open_group', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.product_type', pproduct) || ')';
		v_select_stmt := v_select_stmt || ' AND ((probsummarym1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.open_time < ' || '''' || v_gmt_enddate || ''')' ;
		v_select_stmt := v_select_stmt || ' OR probsummarym1.flag = ' || '''' || 't' || '''' || ''; 
		v_select_stmt := v_select_stmt || ' OR (probsummarym1.open_time < ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time >= ' || '''' || v_gmt_enddate || ''')' ;
		v_select_stmt := v_select_stmt || ' OR (probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || '''))' ;
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc_actvty;

-- 08.11.06-shw- Closed Incidents (Daily Summary Sub-report) 
   PROCEDURE bisp_select_clo (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
	  pproduct			  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.country, probsummarym1.dept,probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_charge_code, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.problem_status, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.open_group', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.product_type', pproduct) || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || '''' ;
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || ''; 
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_clo;
-- 06.20.06-shw- Open Probsummary Activity 
   PROCEDURE bisp_select_opn_inc (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
	  pproduct			  IN	   VARCHAR2,
	  pdept				  IN	   VARCHAR2,
	  pbu				  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.country, probsummarym1.dept,probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_charge_code, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.problem_status, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.open_group', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.product_type', pproduct) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.dept', pdept) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.pfz_bu', pbu) || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.open_time < ' || '''' || v_gmt_enddate || '''' ;
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_opn_inc;

-- *****************************************************************************************   
-- 08.22.06 Created bisp_select_open_tickets - for Messaging graphs by Hour/Month report(s) 
   PROCEDURE bisp_select_opened_tickets (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
	  pproduct			  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.country, probsummarym1.dept,probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_charge_code, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.problem_status, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.product_type', pproduct) || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.open_time < ' || '''' || v_gmt_enddate || '''' ;
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_opened_tickets;

-- *****************************************************************************************   
-- 10.17.06 Created bisp_opened_loctn - for Tickets Opened by Hour Graph 

   PROCEDURE bisp_select_opened_location (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
	  plocation			  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.country, probsummarym1.dept,probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_charge_code, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.problem_status, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.location', plocation) || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.open_time < ' || '''' || v_gmt_enddate || '''' ;
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_opened_location;
   
   
   
   -- *****************************************************************************************   
-- 10.18.06 Created bisp_select_PTOC_KBCANDIDATES - for OProblem Tickets Opened & Closed in a Period by KB Candidates-SPROC.rpt 
   PROCEDURE bisp_select_PTOC_KBCANDIDATES (
      select_inc_cursor  IN OUT   bisp_refcursor_type,
	  pfrequency		 IN		  VARCHAR2,
	  poverride			 IN		  VARCHAR2,
	  pzone				 IN		  VARCHAR2,
	  pstartdate         IN       DATE,
      penddate           IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT PROBSUMMARYM1.SOLUTION_CANDIDATE,PROBSUMMARYM1.ASSIGNEE_NAME, PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.PFZ_FULL_NAME, PROBSUMMARYM1.PFZ_SITE_ID, PROBSUMMARYM1.BRIEF_DESCRIPTION, PROBSUMMARYM1.RESOLUTION, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1 ' ;
        v_select_stmt := v_select_stmt || ' WHERE (PROBSUMMARYM1.SOLUTION_CANDIDATE =  ' || '''' || 't' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;																																   
		OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_PTOC_KBCANDIDATES;
   
   
   
    
-- 06.02.06-shw- Open or Closed Probsummary with activity and VIP  
   PROCEDURE bisp_select_inc_act (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2, 
	  popenorclosed		  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
	  v_whereclause		   VARCHAR2(32767); 
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT operatorm1v.full_name, activitym1.description, activitym1.datestamp,activitym1.type, activitym1.operator, probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.country, probsummarym1.dept,probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_charge_code, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_rb_dept, probsummarym1.pfz_rb_email, probsummarym1.pfz_rb_location, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.pfz_vip,probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.problem_status, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON probsummarym1.updated_by = operatorm1v.name';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN activitym1 activitym1 ON probsummarym1.numberprgn = activitym1.numberprgn';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.pfz_vip = ' || '''' || 't' || '''' || ''; 
		IF (popenorclosed = 'Closed')
		THEN
			v_whereclause := ' AND probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || '''' ;
		ELSE
			v_whereclause := ' AND probsummarym1.flag = ' || '''' || 't' || '''' || ''; 
		END IF;
		v_select_stmt := v_select_stmt || v_whereclause ;
		
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc_act;

-- 07.17.06-shw- Activity Details 
   PROCEDURE bisp_select_activity_detail (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      pnumberprgn		  IN       VARCHAR2, 
      pzone               IN       VARCHAR2
   )
   AS
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		v_select_stmt := 'SELECT activitym1.numberprgn, activitym1.description, BIPKG_UTILS.BIFNC_AdjustForTZ(activitym1.datestamp,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') datestamp,activitym1.type, activitym1.operator, BIPKG_UTILS.BIFNC_AdjustForTZ(activitym1.sysmodtime,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') sysmodtime ';
		v_select_stmt := v_select_stmt || ' FROM activitym1 activitym1';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('activitym1.numberprgn', pnumberprgn) || ')';
		
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_activity_detail;

-- 07.17.06-shw- NEW07_Opened or Closed or Opened And Closed Probsummary 
   PROCEDURE bisp_select_inc_OorC (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2, 
	  popenorclosed		  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
	  v_whereclause		   VARCHAR2(32767); 
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT operatorm1v.full_name, probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.country, probsummarym1.dept,probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_charge_code, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_rb_dept, probsummarym1.pfz_rb_email, probsummarym1.pfz_rb_location, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.pfz_vip,probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.problem_status, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.sysmoduser,probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON probsummarym1.updated_by = operatorm1v.name';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		IF (popenorclosed = 'Opened or Closed in Period')
		THEN
			v_whereclause := ' AND ((probsummarym1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.open_time < ' || '''' || v_gmt_enddate || ''')';
			v_whereclause := v_whereclause || ' OR (probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || '''))';
		ELSE
			v_whereclause := ' AND probsummarym1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || '''' ;
		END IF;
		v_select_stmt := v_select_stmt || v_whereclause ;
		
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc_OorC;
   
-- NEW34 - Open or Closed Calls/Incidents by Product / Products by Country 
--  
   PROCEDURE bisp_select_inc_prd (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2, 
      porig_group         IN       VARCHAR2,
      plocation           IN       VARCHAR2,
	  pcountry			  IN	   VARCHAR2,
	  pproduct			  IN	   VARCHAR2,
	  popenorclosed		  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
	  v_whereclause		   VARCHAR2(32767); 
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT operatorm1v.full_name, operatorm1v_1.full_name, operatorm1_problem_assignee.full_name, ';
		v_select_stmt := v_select_stmt || ' incidentsm1.incident_id, incidentsm1.product_type, incidentsm1.pfz_orig_group, incidentsm1.resolution_code, incidentsm1.pfz_full_name, incidentsm1.phone, incidentsm1.pfz_division, incidentsm1.pfz_bu, incidentsm1.pfz_sla_title, incidentsm1.open, ';
		v_select_stmt := v_select_stmt || ' probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.contact_phone, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.country, probsummarym1.dept,probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_charge_code, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_rb_dept, probsummarym1.pfz_rb_email, probsummarym1.pfz_rb_location, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.pfz_vip,probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.problem_status, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN screlationm1 screlationm1 ON probsummarym1.numberprgn = screlationm1.depend';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN incidentsm1 incidentsm1 ON incidentsm1.incident_id = screlationm1.source';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON probsummarym1.closed_by = operatorm1v.name';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v_1 ON incidentsm1.closed_by = operatorm1v_1.name';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1_problem_assignee ON probsummarym1.assignee_name = operatorm1_problem_assignee.name';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.open_group', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.product_type', pproduct) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.location', plocation) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.country', pcountry) || ')';
		IF (popenorclosed = 'Closed')
		THEN
			v_whereclause := ' AND probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || '''' ;
		ELSIF (popenorclosed = 'Open')
		THEN
			v_whereclause := ' AND probsummarym1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.open_time < ' || '''' || v_gmt_enddate || '''' ;
		ELSE
			v_whereclause := ' AND ((probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || ''')' ;
			v_whereclause := v_whereclause || 'OR (probsummarym1.flag = ' || '''' || 't' || '''' || '';
			v_whereclause := v_whereclause || 'AND probsummarym1.open_time < ' || '''' || v_gmt_enddate || '''))' ; 
		END IF;
		v_select_stmt := v_select_stmt || v_whereclause ;
		
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc_prd;

-- NEW31_Resolved Ticket Report by Related ProjectDivisionSpecailFlag
--		  	Created bisp_select_inc_spflg 
   PROCEDURE bisp_select_inc_spflg (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2, 
      pdivision           IN       VARCHAR2,
      pspecialflag        IN       VARCHAR2,
	  pproject  		  IN	   VARCHAR2,
	  popenorclosed		  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
	  v_whereclause		   VARCHAR2(32767); 
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT PROBSUMMARYM2.PFZ_RELATED_PROJECTS, ';
		v_select_stmt := v_select_stmt || ' probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.contact_phone, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.country, probsummarym1.dept,probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_charge_code, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_rb_dept, probsummarym1.pfz_rb_email, probsummarym1.pfz_rb_location, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_special_project, probsummarym1.pfz_total_time_spent, probsummarym1.pfz_vip,probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.problem_status, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' INNER JOIN probsummarym2 probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND NVL(probsummarym1.pfz_special_project,'|| '''' || ' ' || '''' ||') like ' || '''' || pspecialflag || '''' ; 
    	v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(probsummarym1.pfz_division,'|| '''' || ' ' || '''' ||')', pdivision) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(probsummarym2.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';
		IF (popenorclosed = 'Closed')
		THEN
			v_whereclause := ' AND probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || '''' ;
		ELSE
			v_whereclause := ' AND probsummarym1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.open_time < ' || '''' || v_gmt_enddate || '''' ;
		END IF;
		v_select_stmt := v_select_stmt || v_whereclause ;
		
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc_spflg; 
   
-- 05.24.06-shw- 
   PROCEDURE bisp_select_inc_site (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
      plocation           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT pfzsitesm1.description, probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.country, probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN PFZSITESM1 pfzsitesm1 ON probsummarym1.pfz_site_id = pfzsitesm1.site_id ';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.open_group', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.location', plocation) || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || '''' ;
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || ''; 
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc_site;
   
-- 05.24.06-shw- NEW28 
-- 12.05.06-shw- added Project & Division params for J&J Transition (PCH) 
   PROCEDURE bisp_select_inc_divprj (
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
      plocation           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      pproject			  IN	   VARCHAR2,
	  pdivision			  IN	   VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT pfzsitesm1.description, probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.category,probsummarym1.commodity,probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.country, probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, PROBSUMMARYM2.PFZ_RELATED_PROJECTS, probsummarym1.PFZ_DIVISION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBSUMMARYM2 PROBSUMMARYM2 ON probsummarym1.NUMBERPRGN = PROBSUMMARYM2.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN PFZSITESM1 pfzsitesm1 ON probsummarym1.pfz_site_id = pfzsitesm1.site_id ';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.open_group', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.location', plocation) || ')';
    	v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(probsummarym1.PFZ_DIVISION,'|| '''' || ' ' || '''' ||')', pdivision) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(PROBSUMMARYM2.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';		
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || '''' ;
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || ''; 
      OPEN select_inc_cursor FOR v_select_stmt ;
   END bisp_select_inc_divprj;

   PROCEDURE bisp_select_prb (
      select_prb_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      plocation           IN       VARCHAR2,
	  pcallorigin		  IN	   VARCHAR2,
	  pcontactname		  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT assignmenta1.name, operatorm1v.full_name,problemm1.assignment, problemm1.action, problemm1.assignee_name, problemm1.brief_description, problemm1.category, problemm1.closed_by, problemm1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(problemm1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, problemm1.country, problemm1.deadline_alert_flag, problemm1.flag, problemm1.groupprgn, problemm1.last_activity, problemm1.location, problemm1.numberprgn, problemm1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(problemm1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, problemm1.opened_by, problemm1.call_origin, problemm1.contact_name, problemm1.page, problemm1.pfz_sla_title, problemm1.pfz_total_time_spent, problemm1.priority_code, problemm1.problem_type, problemm1.problem_status, problemm1.product_type, problemm1.resolution_code, problemm1.resolution, problemm1.status,  problemm1.time_spent, problemm1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(problemm1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, problemm1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM problemm1 problemm1';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN assignmenta1 assignmenta1 ON problemm1.updated_by = assignmenta1.operators';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON problemm1.updated_by = operatorm1v.name';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('problemm1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('problemm1.location', plocation) || ')';
--	08.02.06-shw-	v_select_stmt := v_select_stmt || ' AND ((problemm1.status = ' || '''' || 'open' || '''' || 'AND problemm1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND problemm1.open_time < ' || '''' || v_gmt_enddate || ''')' ;
		v_select_stmt := v_select_stmt || ' AND ((problemm1.status in (' || '''' || 'open'|| '''' || ','|| '''' || 'work in progress'|| '''' ||','|| '''' || 'restored' || '''' || ') AND problemm1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND problemm1.open_time < ' || '''' || v_gmt_enddate || ''')' ;
		v_select_stmt := v_select_stmt || ' OR (problemm1.status = ' || '''' || 'closed' || '''' || 'AND problemm1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND problemm1.close_time < ' || '''' || v_gmt_enddate || '''))' ;
		v_select_stmt := v_select_stmt || ' AND (problemm1.call_origin is null';
		v_select_stmt := v_select_stmt || ' OR (' || Bipkg_Utils.BIFNC_createinlist ('problemm1.call_origin', pcallorigin) || '))';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('problemm1.contact_name', pcontactname) || ')';
      OPEN select_prb_cursor FOR v_select_stmt ;
   END bisp_select_prb;

-- 05.26.06-shw- sproc for 'Handled' tickets by Assignment/Assignee    
   PROCEDURE bisp_select_hndld (
      select_prb_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2(32767); 
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT assignmenta1.name, operatorm1v.full_name,problemm1.assignment, problemm1.action, problemm1.assignee_name, problemm1.brief_description, problemm1.category, problemm1.closed_by, problemm1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(problemm1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, problemm1.country, problemm1.deadline_alert_flag, problemm1.flag, problemm1.groupprgn, problemm1.last_activity, problemm1.location, problemm1.numberprgn, problemm1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(problemm1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, problemm1.opened_by, problemm1.call_origin, problemm1.contact_name, problemm1.page, problemm1.pfz_sla_title, problemm1.pfz_total_time_spent, problemm1.priority_code, problemm1.problem_type, problemm1.problem_status, problemm1.product_type, problemm1.resolution_code, problemm1.resolution, problemm1.status,  problemm1.time_spent, problemm1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(problemm1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, problemm1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM problemm1 problemm1';
		v_select_stmt := v_select_stmt || ' INNER JOIN assignmenta1 assignmenta1 ON problemm1.updated_by = assignmenta1.operators';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON problemm1.updated_by = operatorm1v.name';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('problemm1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('problemm1.updated_by', panalyst) || ')';
		v_select_stmt := v_select_stmt || ' AND ((problemm1.update_time >= ' || '''' || v_gmt_startdate || '''' || 'AND problemm1.update_time < ' || '''' || v_gmt_enddate || ''')' ;
		v_select_stmt := v_select_stmt || ' OR (problemm1.page = ' || '''' || '1' || '''' || 'AND problemm1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND problemm1.open_time < ' || '''' || v_gmt_enddate || '''))' ;
      OPEN select_prb_cursor FOR v_select_stmt ;
   END bisp_select_hndld;
   
-- 11.01.06-shw- sproc for 'tickets in queue' by Assignment/Assignee    
   PROCEDURE bisp_select_in_queue (
      select_inq_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2(32767); 
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT assignmenta1.name, operatorm1v.full_name,problemm1.assignment, problemm1.action, problemm1.assignee_name, problemm1.brief_description, problemm1.category, problemm1.closed_by, problemm1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(problemm1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, problemm1.country, problemm1.deadline_alert_flag, problemm1.flag, problemm1.groupprgn, problemm1.last_activity, problemm1.location, problemm1.numberprgn, problemm1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(problemm1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, problemm1.opened_by, problemm1.call_origin, problemm1.contact_name, problemm1.page, problemm1.pfz_sla_title, problemm1.pfz_total_time_spent, problemm1.priority_code, problemm1.problem_type, problemm1.problem_status, problemm1.product_type, problemm1.resolution_code, problemm1.resolution, problemm1.status,  problemm1.time_spent, problemm1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(problemm1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, problemm1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM problemm1 problemm1';
		v_select_stmt := v_select_stmt || ' INNER JOIN assignmenta1 assignmenta1 ON problemm1.updated_by = assignmenta1.operators';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON problemm1.updated_by = operatorm1v.name';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('problemm1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('problemm1.updated_by', panalyst) || ')';
		v_select_stmt := v_select_stmt || ' AND ((problemm1.update_time >= ' || '''' || v_gmt_startdate || '''' || 'AND problemm1.update_time < ' || '''' || v_gmt_enddate || ''')' ;
		v_select_stmt := v_select_stmt || ' OR (problemm1.page = ' || '''' || '1' || '''' || 'AND problemm1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND problemm1.open_time < ' || '''' || v_gmt_enddate || ''')' ;
		v_select_stmt := v_select_stmt || ' OR problemm1.flag = ' || '''' || 'f' || '''' || ')'; 
      OPEN select_inq_cursor FOR v_select_stmt ;
   END bisp_select_in_queue;

-- 07.11.06-shw- sproc for closed tickets by Assignment/Assignee    
   PROCEDURE bisp_select_closed (
      select_closed_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT operatorm1v.full_name, probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.country, probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON probsummarym1.closed_by = operatorm1v.name';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.closed_by', panalyst) || ')';
		v_select_stmt := v_select_stmt || ' AND (probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || ''')' ;
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || ''; 
      OPEN select_closed_cursor FOR v_select_stmt ;
   END bisp_select_closed;
   
   
--		   10.16.06		 -shw-		   1. created bisp_select_closed_respond for SLA Compliance Trending report. 
   PROCEDURE bisp_select_closed_respond (
      select_closed_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT operatorm1v.full_name, probsummarym1.assignment, probsummarym1.action, probsummarym1.assignee_name, probsummarym1.brief_description, probsummarym1.closed_by, probsummarym1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.country, probsummarym1.flag, probsummarym1.last_activity, probsummarym1.LOCATION, probsummarym1.numberprgn, probsummarym1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, probsummarym1.opened_by, probsummarym1.pfz_bu, probsummarym1.pfz_call_source, probsummarym1.pfz_division, probsummarym1.pfz_full_name, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_respond_sla, probsummarym1.pfz_respond_sla_group, probsummarym1.pfz_restore_sla, probsummarym1.pfz_resolve_sla, probsummarym1.pfz_sla_title, probsummarym1.pfz_total_time_spent, probsummarym1.priority_code, probsummarym1.problem_type, probsummarym1.product_type, probsummarym1.resolution_code, probsummarym1.resolution, probsummarym1.status, probsummarym1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN operatorm1v operatorm1v ON probsummarym1.closed_by = operatorm1v.name';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.pfz_respond_sla_group', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.closed_by', panalyst) || ')';
		v_select_stmt := v_select_stmt || ' AND (probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || ''')' ;
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || ''; 
      OPEN select_closed_cursor FOR v_select_stmt ;
   END bisp_select_closed_respond;

-- 05.30.06-shw- sproc for 'assigned' tickets by Assignee    
   PROCEDURE bisp_select_assigned (
      select_prb_cursor   IN OUT   bisp_refcursor_type,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT probsummarym1.assignee_name, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, probsummarym1.flag, probsummarym1.numberprgn, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignee_name', panalyst) || ')';
		v_select_stmt := v_select_stmt || ' AND ((probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.open_time < ' || '''' || v_gmt_enddate || ''')' ;
		v_select_stmt := v_select_stmt || ' OR (probsummarym1.flag = ' || '''' || 't' || '''' || 'AND probsummarym1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.open_time < ' || '''' || v_gmt_enddate || '''))' ;
      OPEN select_prb_cursor FOR v_select_stmt ;
   END bisp_select_assigned;
--    PROCEDURE bisp_select_assigned (
--       select_prb_cursor   IN OUT   bisp_refcursor_type,
--       panalyst            IN       VARCHAR2,
--       pfrequency          IN       VARCHAR2,
--       poverride           IN       VARCHAR2,
--       pzone               IN       VARCHAR2,
--       pstartdate          IN       DATE,
--       penddate            IN       DATE
--    )
--    AS
--       v_gmt_startdate      DATE;
--       v_gmt_enddate        DATE;
--       v_select_stmt        VARCHAR2 (2000);
-- 	  vfrom_clause         VARCHAR2(500);
--    BEGIN
--         bisp_create_basic_probsumsql(v_select_stmt, vfrom_clause, v_gmt_startdate, v_gmt_enddate, pfrequency, poverride, pzone, pstartdate,penddate);
--         v_select_stmt := v_select_stmt ||vfrom_clause;
-- 		v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignee_name', panalyst) || ')';
-- 		v_select_stmt := v_select_stmt || ' AND ((probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.open_time < ' || '''' || v_gmt_enddate || ''')' ;
-- 		v_select_stmt := v_select_stmt || ' OR (probsummarym1.flag = ' || '''' || 't' || '''' || 'AND probsummarym1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.open_time < ' || '''' || v_gmt_enddate || '''))' ;
--       OPEN select_prb_cursor FOR v_select_stmt ;
--    END bisp_select_assigned;
   --
   -- This procedure will create the common SQL statement for the probsummarym1 table, and return it in
   -- 2 parts: the select clause and the from and where clause.
   -- All other procedures based on probsummarym1 should first call this procedure, and then 
   -- add on to the returned SQL statement.
--    PROCEDURE bisp_create_basic_probsumsql (
--    vselectclause	  OUT	   VARCHAR2, -- select clause
--    vfromwhereclause	  OUT	   VARCHAR2, -- from and where clause combined.
--    v_gmt_startdate    OUT	   DATE,
--    v_gmt_enddate      OUT  	   DATE,
--    pfrequency          IN      VARCHAR2,
--    poverride           IN      VARCHAR2,
--    pzone               IN      VARCHAR2,
--    pstartdate          IN      DATE,
--    penddate            IN      DATE
--    ) IS
--       v_startdatedisplay   VARCHAR2(50);
--       v_enddatedisplay     VARCHAR2(50);
--       v_db_zone			   VARCHAR2(10);
--    BEGIN
--       v_db_zone := 'GMT';
-- 	  bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
-- 	  v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
--  	  v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
--  	  vselectclause := 'SELECT BIPKG_UTILS.BIFNC_AdjustForTZ(close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, flag, numberprgn, BIPKG_UTILS.BIFNC_AdjustForTZ(open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay'; 
--  	  vfromwhereclause := ' FROM probsummarym1';
--     END bisp_create_basic_probsumsql;
   --
   PROCEDURE bisp_select_inc_by_parm(
--       vsql	 			  OUT	VARCHAR2,
      select_inc_cursor   IN OUT   bisp_refcursor_type,
      passignment         IN       VARCHAR2,
	  popen_group		  IN	   VARCHAR2,
	  pgroup_by			  IN	   VARCHAR2, -- The field to group by
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   IS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_db_zone			   VARCHAR2(10);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_groupby_field	   VARCHAR2(15);
      vsql                 VARCHAR2 (32767);
	  vfrom_clause         VARCHAR2(500);
   BEGIN
--       bisp_create_basic_probsumsql(vsql, vfrom_clause, v_gmt_startdate, v_gmt_enddate, pfrequency, poverride, pzone, pstartdate,penddate);
-- 	  vsql := vsql||', assignment, product_type, country, pfz_total_time_spent, pfz_bu, open_group ';
--       vsql := vsql||vfrom_clause;
      v_db_zone := 'GMT';
	  Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	  v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
 	  v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
	  CASE
	     WHEN UPPER(pgroup_by) = 'COUNTRY' THEN v_groupby_field := 'country';
		 WHEN UPPER(pgroup_by) = 'DIVISION' THEN v_groupby_field := 'pfz_bu';
		 WHEN UPPER(pgroup_by) = 'PRODUCT' THEN v_groupby_field := 'product_type';
	  END CASE;
	  vsql := 'SELECT COUNT(numberprgn), sum(pfz_total_time_spent), assignment, nvl('||v_groupby_field||','||''''||' '||''') group_by'
	       ||','
	       ||'''' || v_startdatedisplay || ''''||' StartDateDisplay , ' 
		   ||'''' || v_enddatedisplay || '''' || ' EndDateDisplay'
	       ||' FROM probsummarym1'
	       ||' WHERE ('||Bipkg_Utils.BIFNC_createinlist('assignment', passignment)||')'
	       ||'   AND ('||Bipkg_Utils.BIFNC_createinlist('open_group', popen_group)||')'
		   ||'   AND close_time BETWEEN TO_DATE('||''''||TO_CHAR(v_gmt_startdate, 'DD-MON-YYYY HH24:MI:SS')
			         ||''''||','||''''||'DD-MON-YYYY HH24:MI:SS'||''''||') AND '
					 ||' TO_DATE('||''''||TO_CHAR(v_gmt_enddate, 'DD-MON-YYYY HH24:MI:SS')
					 ||''''||','||''''||'DD-MON-YYYY HH24:MI:SS'||''''||')'
		   ||' GROUP BY assignment, nvl('||v_groupby_field||','||''''||' '||''')'||','||'''' || v_startdatedisplay || '''' ||','
		   ||'''' || v_enddatedisplay|| ''''
		   ||' ORDER BY assignment, nvl('||v_groupby_field||','||''''||' '||''')';
	  OPEN select_inc_cursor FOR vsql;
   END bisp_select_inc_by_parm;

-- 02.19.07					   -sg-	  sproc for Operator Analysis

   PROCEDURE bisp_operator_analysis (
      operator_analysis_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      panalyst            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2(32767); 
   BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT assignmenta1.name, operatorm1v.full_name,problemm1.assignment, problemm1.action, problemm1.assignee_name, problemm1.brief_description, problemm1.category, problemm1.closed_by, problemm1.closed_group, BIPKG_UTILS.BIFNC_AdjustForTZ(problemm1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, problemm1.country, problemm1.deadline_alert_flag, problemm1.flag, problemm1.groupprgn, problemm1.last_activity, problemm1.location, problemm1.numberprgn, problemm1.open_group, BIPKG_UTILS.BIFNC_AdjustForTZ(problemm1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, problemm1.opened_by, problemm1.call_origin, problemm1.contact_name, problemm1.page, problemm1.pfz_sla_title, problemm1.pfz_total_time_spent, problemm1.priority_code, problemm1.problem_type, problemm1.problem_status, problemm1.product_type, problemm1.resolution_code, problemm1.resolution, problemm1.status,  problemm1.time_spent, problemm1.updated_by, BIPKG_UTILS.BIFNC_AdjustForTZ(problemm1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, problemm1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay'
		|| ' FROM problemm1 problemm1'
		|| ' INNER JOIN assignmenta1 assignmenta1 ON problemm1.updated_by = assignmenta1.operators'
		|| ' LEFT OUTER JOIN operatorm1v operatorm1v ON problemm1.updated_by = operatorm1v.name'
		|| ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('NVL(assignmenta1.name, '' '')', passignmentgroup) || ')'
		|| ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(assignmenta1.operators, '' '')', panalyst) || ')'
		|| ' AND problemm1.update_time between ''' || v_gmt_startdate || ''' AND ''' || v_gmt_enddate || '''';

	  OPEN operator_analysis_cursor FOR v_select_stmt ;
	  
   END bisp_operator_analysis;

END Bipkg_Incidents;
/


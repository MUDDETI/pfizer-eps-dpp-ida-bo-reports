CREATE OR REPLACE PACKAGE Bipkg_Inc_Aging
AS
   TYPE bisp_refcursor_type IS REF CURSOR;

/******************************************************************************
   NAME:       bipkg_inc_aging
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------


    -- sg 18-JUL-2006 created procedure for Aging Ticket Summary and Detail Report
	1.0	  	04-Aug-2006		  ShW		Create sproc for Outstanding GT x days Old 
******************************************************************************/
   
   PROCEDURE bisp_inc_aging (
      inc_aging_cursor   IN OUT   bisp_refcursor_type,
	  passigngroup		 IN		  VARCHAR2,
	  ppriority			 IN		  VARCHAR2,
      pzone              IN       VARCHAR2
   );
   
-- Used for the "Outstanding Tickets GT x Days Old Report(s)  
   PROCEDURE bisp_aging_gt (
      inc_aging_cursor   IN OUT   bisp_refcursor_type,
	  passigngroup		 IN		  VARCHAR2,
	  porigingroup		 IN		  VARCHAR2,
	  ppriority			 IN		  VARCHAR2,
	  plocation			 IN		  VARCHAR2,
	  pdivision			 IN		  VARCHAR2,
      pzone              IN       VARCHAR2
   );
END Bipkg_Inc_Aging;
/
CREATE OR REPLACE PACKAGE BODY Bipkg_Inc_Aging
AS
/******************************************************************************
   NAME:       bipkg_inc_aging
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------


    -- sg 18-JUL-2006 created procedure for Aging Ticket Summary and Detail Report
	1.0	  	04-Aug-2006		  ShW		Create sproc for Outstanding GT x days Old 
******************************************************************************/
   
   PROCEDURE bisp_inc_aging (
      inc_aging_cursor   IN OUT   bisp_refcursor_type,
	  passigngroup		 IN		  VARCHAR2,
	  ppriority			 IN		  VARCHAR2,
      pzone              IN       VARCHAR2
   )
   IS
      v_db_zone            VARCHAR2 (3);
	  v_currentdate		   VARCHAR2 (150);
      v_select_stmt		   VARCHAR2 (32767);
   BEGIN
      v_db_zone := 'GMT';
	  v_currentdate	   :=	'to_date(''' || TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (SYSDATE, 'EST', pzone),'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';
	  v_select_stmt :=
	  'select'
	  || ' probsummarym1.assignment,'
	  || ' probsummarym1.flag,'
	  || ' probsummarym1.numberprgn,'
	  || ' probsummarym1.deadline,'
	  || ' probsummarym1.pfz_sla_title,'
	  || ' probsummarym1.pfz_full_name,'
	  || ' probsummarym1.assignee_name,'
	  || ' probsummarym1.status,'
	  || ' probsummarym1.product_type,'
	  || ' probsummarym1.location,'
	  || ' probsummarym1.brief_description,'
	  || ' probsummarym1.countprgn,'
	  || ' bipkg_utils.bifnc_adjustfortz(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,'	
	  || ' bipkg_utils.bifnc_adjustfortz(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time,'
	  || v_currentdate || ' currentdatetime'
	  || ' from' 
	  || ' probsummarym1'
	  || ' where'
	  || ' probsummarym1.flag = ''t''' 
	  || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', ppriority) || ')'
	  || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.assignment', passigngroup) || ')'
	  ;
	  
	  OPEN inc_aging_cursor FOR v_select_stmt;
	  
   END bisp_inc_aging;
   

-- Used for the "Outstanding Tickets GT x Days Old Report(s)  

   PROCEDURE bisp_aging_gt (
      inc_aging_cursor   IN OUT   bisp_refcursor_type,
	  passigngroup		 IN		  VARCHAR2,
	  porigingroup		 IN		  VARCHAR2,
	  ppriority			 IN		  VARCHAR2,
	  plocation			 IN		  VARCHAR2,
	  pdivision			 IN		  VARCHAR2,
      pzone              IN       VARCHAR2
   )
   IS
      v_db_zone            VARCHAR2 (3);
	  v_currentdate		   VARCHAR2 (150);
      v_select_stmt		   VARCHAR2 (32767);
   BEGIN
      v_db_zone := 'GMT';
	  v_currentdate	   :=	'to_date(''' || TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (SYSDATE, 'EST', pzone),'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';
	  v_select_stmt :=
	  'select'
	  || ' probsummarym1.assignment,'
	  || ' probsummarym1.flag,'
	  || ' probsummarym1.numberprgn,'
	  || ' probsummarym1.deadline,'
	  || ' probsummarym1.pfz_sla_title,'
	  || ' probsummarym1.pfz_full_name,'
	  || ' probsummarym1.pfz_bu,'
	  || ' probsummarym1.pfz_division,'
	  || ' probsummarym1.pfz_site_id,'
	  || ' probsummarym1.problem_status,'
	  || ' probsummarym1.assignee_name,'
	  || ' probsummarym1.status,'
	  || ' probsummarym1.product_type,'
	  || ' probsummarym1.location,'
	  || ' probsummarym1.priority_code,'
	  || ' probsummarym1.brief_description,'
	  || ' probsummarym1.countprgn,'
	  || ' probsummarym1.groupprgn,'
	  || ' probsummarym1.open_group,'
	  || ' probsummarym1.update_action,'
	  || ' probsummarym1.last_activity,'
	  || ' bipkg_utils.bifnc_adjustfortz(probsummarym1.repair_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') repair_time,'	
	  || ' bipkg_utils.bifnc_adjustfortz(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,'	
	  || ' bipkg_utils.bifnc_adjustfortz(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time,'
	  || v_currentdate || ' currentdatetime'
	  || ' from' 
	  || ' probsummarym1'
	  || ' where'
	  || ' probsummarym1.flag = ''t''' 
	  || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_sla_title', ppriority) || ')'
	  || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.location', plocation) || ')'
	  || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.pfz_division', pdivision) || ')'
	  || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.assignment', passigngroup) || ')'
	  || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', porigingroup) || ')'
	  ;
	  
	  OPEN inc_aging_cursor FOR v_select_stmt;
	  
   END bisp_aging_gt;
   
END Bipkg_Inc_Aging;
/


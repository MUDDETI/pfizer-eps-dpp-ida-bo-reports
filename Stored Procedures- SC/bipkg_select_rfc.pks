CREATE OR REPLACE PACKAGE BIPKG_SELECT_RFC AS
/******************************************************************************
   NAME:       BIPKG_SELECT_RFC
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        5/25/2006   SRR          1. Created this package. This package is for RFC selection
   1.0		  07.12.06	  SHW		   1.Create CM statistics (SELECT_BICF_CM_STATS)
   1.0		  07.21.06	  -shw-		   1. Create Change_Freeze sproc
   1.0		  09.25.06	  -shw-		   1. Create RFC Printout sproc (s)
   1.0		  10.05.06	  -shw-		   1. create 3rd Weekend Change Window sproc
   1.0		  10.18.06	  -shw-		   1. create RFCs closed by a Team sprc
   1.0        09.22.08    -shw-        1. Create Sproc for RFC On-Time Implementation report.
   1.0        12.18.08    -sanghs-     1. Added 2 new fields in BISP_SELECT_RFC_ON_TIME and BISP_SELECT_RFC_STATS
                                          Stored Procs as part of GAMP2 process changes
	1.0		  02.19.09     -JQuinn		1. Add 1 new field in BISP_SELECT_RFC STATS procedure(pfz_supervisor_full_name) and
	                                       add as a parameter
   1.0        04.01.09    -shw-         1. add ACTUAL_OUTAGE_END date to RFC_ON_TIME, COMPLETION_CODE Parameter 
    2.0         04.09.09    -shw-       1. add excl_group, excl_cm_lead parameters to RFC-ON-TIME sproc.
    3.0         04.17.09    -shw-       1. add Assignmentm1 table 7 params to new RFC_STATISTICS procedure (replace RFC_STATS) 
    3.1         04.24.09    -shw-       2. Changed from-to date selection formatting.
******************************************************************************/

--  FUNCTION MyFunction(Param1 IN NUMBER) RETURN NUMBER;
--  PROCEDURE MyProcedure(Param1 IN NUMBER);
  TYPE BICUR_RFC_TYPE IS REF CURSOR; -- This is the cursor that Crystal expects

-- Used for RFC On-Time Implementation report.
  PROCEDURE BISP_SELECT_RFC_ON_TIME (rfc_cursor IN OUT BICUR_RFC_TYPE,
									assign_group 	 IN VARCHAR2,
                                    category         IN VARCHAR2,
                                    phase_name       IN VARCHAR2,
                                    retro            IN VARCHAR2,
                                    status           IN VARCHAR2,
                                    approval_status  IN VARCHAR2,
									vendor  		 IN VARCHAR2,
									rptgrp  		 IN VARCHAR2,
									tower   		 IN VARCHAR2,
									pfrequency       IN VARCHAR2,
      								poverride        IN VARCHAR2,
      								pzone            IN VARCHAR2,
      								pstartdate       IN DATE,
      								penddate         IN DATE,
                                    completion_code  IN VARCHAR2,
									excl_group 		 IN VARCHAR2,
  								  	excl_cm_lead	 IN VARCHAR2
									);
-- Used for Change Management Statistics report
  PROCEDURE BISP_SELECT_RFC_STATISTICS (rfc_cursor IN OUT BICUR_RFC_TYPE,
  								  	excl_cm_lead		  IN VARCHAR2,
									region 	  	 	 	  IN VARCHAR2,
									site 			 	  IN VARCHAR2,
									assign_group 	 	  IN VARCHAR2,
									excl_group 		 	  IN VARCHAR2,
									vendor  		      IN VARCHAR2,
									rptgrp  		      IN VARCHAR2,
									tower   		      IN VARCHAR2,
                                    category              IN VARCHAR2,
                                    phase_name            IN VARCHAR2,
                                    reason                IN VARCHAR2,
									pfrequency       	  IN VARCHAR2,
      								poverride        	  IN VARCHAR2,
      								pzone            	  IN VARCHAR2,
      								pstartdate       	  IN DATE,
      								penddate         	  IN DATE
									);

  PROCEDURE BISP_SELECT_RFC_MAIN (rfc_cursor IN OUT BICUR_RFC_TYPE,
									whichclause IN VARCHAR2,
									in_rfc_number IN VARCHAR2,
									in_group IN VARCHAR2,
									dstartdate         IN       DATE,
									denddate           IN       DATE,
									frequency          IN       VARCHAR2,
									override           IN       VARCHAR2,
									zone               IN       VARCHAR2
									);
  PROCEDURE BISP_SELECT_RFC_BY_NUM (rfc_cursor IN OUT BICUR_RFC_TYPE,
									in_rfc_number IN VARCHAR2);

-- Used for CIT CM Summary Statistics report
  PROCEDURE BISP_SELECT_RFC_STATS (rfc_cursor IN OUT BICUR_RFC_TYPE,
  								  	excl_cm_lead		  IN VARCHAR2,
									region 	  	 	 	  IN VARCHAR2,
									site 			 	  IN VARCHAR2,
									assign_group 	 	  IN VARCHAR2,
									excl_group 		 	  IN VARCHAR2,
									pfrequency       	  IN VARCHAR2,
      								poverride        	  IN VARCHAR2,
      								pzone            	  IN VARCHAR2,
      								pstartdate       	  IN DATE,
      								penddate         	  IN DATE
									);

-- Used for  CM Approved or Pending Summary Statistics report
  PROCEDURE BISP_SELECT_CM_STATS (rfc_cursor IN OUT BICUR_RFC_TYPE,
									region 	  	 	 IN VARCHAR2,
									area 			 IN VARCHAR2,
									assign_group 	 IN VARCHAR2,
									pfrequency       IN VARCHAR2,
      								poverride        IN VARCHAR2,
      								pzone            IN VARCHAR2,
      								pstartdate       IN DATE,
      								penddate         IN DATE
									);
-- Used for  CM Change Freeze report
  PROCEDURE BISP_SELECT_CHANGE_FREEZE (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2,
									server 			 IN VARCHAR2,
      								pzone            IN VARCHAR2
									);
-- Used for  3rd Weekend Change Window report
  PROCEDURE BISP_SELECT_THIRD_WEEKEND (rfc_cursor IN OUT BICUR_RFC_TYPE,
									status	  	 	 IN VARCHAR2,
									impact 			 IN VARCHAR2,
									raiseprofile	 IN VARCHAR2,
      								pzone            IN VARCHAR2,
      								pstartdate       IN DATE,
      								penddate         IN DATE
									);

-- Used for  "RFCs closed by a Team" main report
  PROCEDURE BISP_SELECT_RFC_BYATEAM (rfc_cursor IN OUT BICUR_RFC_TYPE,
									open_group 	 IN VARCHAR2,
									pfrequency       IN VARCHAR2,
      								poverride        IN VARCHAR2,
      								pzone            IN VARCHAR2,
      								pstartdate       IN DATE,
      								penddate         IN DATE
									);
-- Used for  "RFC changes by Approval-Reviewer" report
  PROCEDURE BISP_SELECT_RFC_CHANGES (rfc_cursor IN OUT BICUR_RFC_TYPE,
									Region 	  	 	 IN VARCHAR2,
									Site 	  	 	 IN VARCHAR2,
									Category 		 IN VARCHAR2,
									Status			 IN VARCHAR2,
      								Pzone            IN VARCHAR2,
									Groups			 IN VARCHAR2
									);
-- Used for  "RFC Printout" main report
  PROCEDURE BISP_SELECT_RFC_PRINTOUT (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2,
									CIname 			 IN VARCHAR2,
      								pzone            IN VARCHAR2
									);
-- Used for  "RFC Printout-CI Items" SUB report
  PROCEDURE BISP_SELECT_CI_ITEMS (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
									);

-- Used for  "RFC Printout- RFC Services Affected" SUB report
  PROCEDURE BISP_SELECT_Services_Affected (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
									);

-- Used for  "RFC Printout- RFC Tasks" SUB report
  PROCEDURE BISP_SELECT_RFC_Tasks (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
									);
-- Used for  "RFC Printout- RFC Related Incidents" SUB report
  PROCEDURE BISP_SELECT_Related_Incidents (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
									);

-- Used for  "RFC Printout- RFC Related Changes" SUB report
  PROCEDURE BISP_SELECT_Related_Changes (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
									);

-- Used for  "RFC Printout- RFC CAB Notes" SUB report
  PROCEDURE BISP_SELECT_Related_CAB_Notes (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2,
      								pzone            IN VARCHAR2
									);
-- Used for  "RFC Printout- RFC Pending Approval" SUB report
  PROCEDURE BISP_SELECT_Pending_Approval (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
									);
-- Used for  "RFC Printout- RFC Past Approval" SUB report
  PROCEDURE BISP_SELECT_Past_Approval (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2,
      								pzone            IN VARCHAR2
									);
-- Used for  "RFC Printout- RFC Future Approval" SUB report
  PROCEDURE BISP_SELECT_Future_Approval (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
									);

-- Used for  "RFC Printout- PIRA Details" SUB report
  PROCEDURE BISP_SELECT_PIRA_Details (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
									);
-- Used for  "RFC Printout- Phase Log" SUB report
  PROCEDURE BISP_SELECT_Phase_Log (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2,
      								pzone            IN VARCHAR2
									);

END BIPKG_SELECT_RFC;
/
CREATE OR REPLACE PACKAGE BODY Bipkg_Select_Rfc AS
/******************************************************************************
   NAME:       BIPKG_SELECT_RFC
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        5/25/2006    -shw-		   . Created this package body.
   1.1		  06/14/06		shw		   RFC_STATS - for CIT CM Summary Report .
   1.2		  07.12.06	  SHW		   1.Create CM statistics (SELECT_BICF_CM_STATS)
   1.0		  07.21.06	  -shw-		   1. Create Change_Freeze sproc
   1.0		  09.25.06	  -shw-		   1. Create RFC Printout sproc (s)
   1.0		  10.05.06	  -shw-		   1. create 3rd Weekend Change Window sproc
   1.0		  10.18.06	  -shw-		   1. create RFCs closed by a Team sprc
   1.0		  12.15.06	  -shw-		   1. create RFC changes by Approval-Reviewer
   1.0        09.22.08    -shw-        1. Create Sproc for RFC On-Time Implementation report.
   1.0        12.18.08    -sanghs-     1. Added 2 new fields in BISP_SELECT_RFC_ON_TIME and BISP_SELECT_RFC_STATS
                                          Stored Procs as part of GAMP2 process changes
	1.0		  02.19.09     -JQuinn		1. Add 1 new field in BISP_SELECT_RFC STATS procedure(pfz_supervisor_full_name) and
	                                       add as a parameter
   1.0        04.01.09    -shw-         1. add ACTUAL_OUTAGE_END date to RFC_ON_TIME, COMPLETION_CODE Parameter 
    2.0         04.09.09    -shw-       1. add excl_group, excl_cm_lead parameters to RFC-ON-TIME sproc.
    3.0         04.17.09    -shw-       1. add Assignmentm1 table 7 params to new RFC_STATISTICS procedure (replace RFC_STATS) 
    3.1         04.24.09    -shw-       2. Changed from-to date selection formatting.
******************************************************************************/
--
-- Error Handling is done by the report. We do not trap any exceptions at the Database side.
--
-- ******************************************
-- Used for RFC On-Time Implementation report.
  PROCEDURE BISP_SELECT_RFC_ON_TIME (rfc_cursor IN OUT BICUR_RFC_TYPE,
									assign_group 	 IN VARCHAR2,
                                    category         IN VARCHAR2,
                                    phase_name       IN VARCHAR2,
                                    retro            IN VARCHAR2,
                                    status           IN VARCHAR2,
                                    approval_status  IN VARCHAR2,
									vendor  		 IN VARCHAR2,
									rptgrp  		 IN VARCHAR2,
									tower   		 IN VARCHAR2,
									pfrequency       IN VARCHAR2,
      								poverride        IN VARCHAR2,
      								pzone            IN VARCHAR2,
      								pstartdate       IN DATE,
      								penddate         IN DATE,
                                    completion_code  IN VARCHAR2,
									excl_group 		 IN VARCHAR2,
  								  	excl_cm_lead	 IN VARCHAR2
   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_gmt_startdate_str  VARCHAR2 (19);
      v_gmt_enddate_str    VARCHAR2 (19);          
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
    BEGIN
           v_db_zone := 'GMT';
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_gmt_startdate_str := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
        v_gmt_enddate_str   := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');

        v_select_stmt := 'SELECT CM3RM1.NUMBERPRGN, CM3RM1.PFZ_RETRO, CM3RM1.COMPLETION_CODE, CM3RM1.PFZ_COMPLETION_CODE_PROD, CM3RM1.PFZ_SITE_ID, CM3RM1.PRIORITY, CM3RM1.CATEGORY, CM3RM1.SUBCATEGORY, CM3RM1.PFZ_RFC_WORKFLOW_TYPE, CM3RM1.PFZ_IMPL_GROUP, CM3RM1.ASSIGN_DEPT, ';
        v_select_stmt := v_select_stmt || ' CM3RM1.STATUS, CM3RM1.PFZ_RB_FULL_NAME, CM3RM1.PFZ_RB_DEPT, CM3RM1.ASSIGNED_TO, CM3RM1.CHANGE_CATEGORY, CM3RM1.NETWORK_NAME, CM3RM1.INSTALL_OR_REMOVE, CM3RM1.REASON, CM3RM1.DESCRIPTION, CM3RM1.JUSTIFICATION, ';
        v_select_stmt := v_select_stmt || ' CM3RM1.APPROVAL_STATUS, CM3RM1.DURATION, CM3RM1.BRIEF_DESCRIPTION, CM3RM1.HOURS_WORKED, CM3RM1.PFZ_SUPERVISOR_FULL_NAME, ';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.REQUEST_DATE,''' || v_db_zone || ''' , ''' || pzone || ''') REQUEST_DATE,';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_START,''' || v_db_zone || ''' , ''' || pzone || ''') PLANNED_START,';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_END,''' || v_db_zone || ''' , ''' || pzone || ''') PLANNED_END,';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ACTUAL_OUTAGE_START,''' || v_db_zone || ''' , ''' || pzone || ''') ACTUAL_OUTAGE_START,';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ACTUAL_OUTAGE_END,''' || v_db_zone || ''' , ''' || pzone || ''') ACTUAL_OUTAGE_END,';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PFZ_IMPL_TIME,''' || v_db_zone || ''' , ''' || pzone || ''') PFZ_IMPL_TIME,';
        v_select_stmt := v_select_stmt || ' AM1.PFZ_VENDOR,AM1.PFZ_REPORTING_GROUP,AM1.PFZ_SERVICE_TOWER, ';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3PHASELOGM1.STARTED_DATE,''' || v_db_zone || ''' , ''' || pzone || ''') STARTED_DATE,';
        v_select_stmt := v_select_stmt || ' CM3PHASELOGM1.PHASE_NAME, PFZSITESM1.DESCRIPTION, PFZSITESM1.PFZ_REGION_ID, '|| '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM CM3PHASELOGM1 CM3PHASELOGM1 INNER JOIN CM3RM1 CM3RM1 ON CM3PHASELOGM1.NUMBERPRGN = CM3RM1.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ASSIGNMENTM1 AM1 ON CM3RM1.ASSIGN_DEPT = AM1.NAME ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN PFZSITESM1 PFZSITESM1 ON CM3RM1.PFZ_SITE_ID = PFZSITESM1.SITE_ID ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.ASSIGN_DEPT, '' '')', assign_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AM1.PFZ_VENDOR, '' '')', vendor) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AM1.PFZ_REPORTING_GROUP, '' '')', rptgrp) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AM1.PFZ_SERVICE_TOWER, '' '')', tower) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.CATEGORY, '' '')', category) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3PHASELOGM1.PHASE_NAME, '' '')', phase_name) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.PFZ_RETRO, '' '')', retro) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.STATUS, '' '')', status) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.PFZ_COMPLETION_CODE_PROD, '' '')', completion_code) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.APPROVAL_STATUS, '' '')', approval_status) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.ASSIGN_DEPT, '' '')', excl_group) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.PFZ_SUPERVISOR_FULL_NAME, '' '')', excl_cm_lead) || ')';
-- 04.24.09 		v_select_stmt := v_select_stmt || ' AND (CM3PHASELOGM1.STARTED_DATE >= ' || '''' || v_gmt_startdate || '''' || 'AND CM3PHASELOGM1.STARTED_DATE < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND CM3PHASELOGM1.STARTED_DATE between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') ';

      OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_RFC_ON_TIME;
-- ******************************************
-- Used for Change Management Statistics report
  PROCEDURE BISP_SELECT_RFC_STATISTICS (rfc_cursor IN OUT BICUR_RFC_TYPE,
  								  	excl_cm_lead		  IN VARCHAR2,
									region 	  	 	 	  IN VARCHAR2,
									site 			 	  IN VARCHAR2,
									assign_group 	 	  IN VARCHAR2,
									excl_group 		 	  IN VARCHAR2,
									vendor  		      IN VARCHAR2,
									rptgrp  		      IN VARCHAR2,
									tower   		      IN VARCHAR2,
                                    category              IN VARCHAR2,
                                    phase_name            IN VARCHAR2,
                                    reason                IN VARCHAR2,
									pfrequency       	  IN VARCHAR2,
      								poverride        	  IN VARCHAR2,
      								pzone            	  IN VARCHAR2,
      								pstartdate       	  IN DATE,
      								penddate         	  IN DATE
   ) AS

	  v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_startdate_str  VARCHAR2 (19);
      v_gmt_enddate_str    VARCHAR2 (19);          
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_gmt_startdate_str := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
        v_gmt_enddate_str   := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');


		v_select_stmt := 'SELECT CM3RM1.NUMBERPRGN, CM3RM1.PFZ_RETRO, CM3RM1.COMPLETION_CODE, CM3RM1.PFZ_COMPLETION_CODE_PROD, CM3RM1.PFZ_SITE_ID, CM3RM1.PRIORITY, CM3RM1.CATEGORY, CM3RM1.SUBCATEGORY, CM3RM1.PFZ_RFC_WORKFLOW_TYPE, CM3RM1.PFZ_IMPL_GROUP, CM3RM1.ASSIGN_DEPT, ';
   		v_select_stmt := v_select_stmt || ' CM3RM1.STATUS, CM3RM1.PFZ_RB_FULL_NAME, CM3RM1.PFZ_RB_DEPT, CM3RM1.ASSIGNED_TO, CM3RM1.CHANGE_CATEGORY, CM3RM1.NETWORK_NAME, CM3RM1.INSTALL_OR_REMOVE, CM3RM1.REASON, CM3RM1.PFZ_SUPERVISOR_FULL_NAME, ';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.REQUEST_DATE,''' || v_db_zone || ''' , ''' || pzone || ''') REQUEST_DATE,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_START,''' || v_db_zone || ''' , ''' || pzone || ''') PLANNED_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_END,''' || v_db_zone || ''' , ''' || pzone || ''') PLANNED_END,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ACTUAL_OUTAGE_START,''' || v_db_zone || ''' , ''' || pzone || ''') ACTUAL_OUTAGE_START,';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ACTUAL_OUTAGE_END,''' || v_db_zone || ''' , ''' || pzone || ''') ACTUAL_OUTAGE_END,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PFZ_IMPL_TIME,''' || v_db_zone || ''' , ''' || pzone || ''') PFZ_IMPL_TIME,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PFZ_PIRA_START,''' || v_db_zone || ''' , ''' || pzone || ''') PFZ_PIRA_START,';
        v_select_stmt := v_select_stmt || ' AM1.PFZ_VENDOR,AM1.PFZ_REPORTING_GROUP,AM1.PFZ_SERVICE_TOWER, ';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3PHASELOGM1.STARTED_DATE,''' || v_db_zone || ''' , ''' || pzone || ''') STARTED_DATE,';
        v_select_stmt := v_select_stmt || ' CM3PHASELOGM1.STARTED_DATE GMT_STARTED_DATE,';
        v_select_stmt := v_select_stmt || ' CM3PHASELOGM1.PHASE_NAME, PFZSITESM1.DESCRIPTION SITE_NAME, PFZSITESM1.PFZ_REGION_ID, '|| '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM CM3PHASELOGM1 CM3PHASELOGM1 INNER JOIN CM3RM1 CM3RM1 ON CM3PHASELOGM1.NUMBERPRGN = CM3RM1.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ASSIGNMENTM1 AM1 ON CM3RM1.ASSIGN_DEPT = AM1.NAME ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN PFZSITESM1 PFZSITESM1 ON CM3RM1.PFZ_SITE_ID = PFZSITESM1.SITE_ID ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.PFZ_SITE_ID,'' '')', site) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(PFZSITESM1.PFZ_REGION_ID,'' '')', region) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.ASSIGN_DEPT, '' '')', assign_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AM1.PFZ_VENDOR, '' '')', vendor) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AM1.PFZ_REPORTING_GROUP, '' '')', rptgrp) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(AM1.PFZ_SERVICE_TOWER, '' '')', tower) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.ASSIGN_DEPT, '' '')', excl_group) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.PFZ_SUPERVISOR_FULL_NAME, '' '')', excl_cm_lead) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.REASON, '' '')', reason) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.CATEGORY, '' '')', category) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3PHASELOGM1.PHASE_NAME, '' '')', phase_name) || ')';
-- 04.24.09 		v_select_stmt := v_select_stmt || ' AND (CM3PHASELOGM1.STARTED_DATE >= ' || '''' || v_gmt_startdate || '''' || 'AND CM3PHASELOGM1.STARTED_DATE < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND CM3PHASELOGM1.STARTED_DATE between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') ';
      OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_RFC_STATISTICS;

-- ******************************************

-- Used for CIT CM Summary Statistics report
  PROCEDURE BISP_SELECT_RFC_STATS (rfc_cursor IN OUT BICUR_RFC_TYPE,
									excl_cm_lead 	 		 IN VARCHAR2,
									region 	  	 	 		 IN VARCHAR2,
									site 			 		 IN VARCHAR2,
									assign_group 	 		 IN	VARCHAR2,
									excl_group 		 		 IN VARCHAR2,
									pfrequency       		 IN VARCHAR2,
      								poverride        		 IN VARCHAR2,
      								pzone            		 IN VARCHAR2,
      								pstartdate       		 IN DATE,
      								penddate         		 IN DATE
   ) AS

	  v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_gmt_startdate_str  VARCHAR2 (19);
      v_gmt_enddate_str    VARCHAR2 (19);          
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_gmt_startdate_str := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
        v_gmt_enddate_str   := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');


		v_select_stmt := 'SELECT CM3RM1.NUMBERPRGN, CM3RM1.PFZ_RETRO, CM3RM1.COMPLETION_CODE, CM3RM1.PFZ_COMPLETION_CODE_PROD, CM3RM1.PFZ_SITE_ID, CM3RM1.PRIORITY, CM3RM1.CATEGORY, CM3RM1.SUBCATEGORY, CM3RM1.PFZ_RFC_WORKFLOW_TYPE, CM3RM1.PFZ_IMPL_GROUP, CM3RM1.ASSIGN_DEPT, ';
   		v_select_stmt := v_select_stmt || ' CM3RM1.STATUS, CM3RM1.PFZ_RB_FULL_NAME, CM3RM1.PFZ_RB_DEPT, CM3RM1.ASSIGNED_TO, CM3RM1.CHANGE_CATEGORY, CM3RM1.NETWORK_NAME, CM3RM1.INSTALL_OR_REMOVE, CM3RM1.REASON, CM3RM1.DESCRIPTION, CM3RM1.JUSTIFICATION,CM3RM1.PFZ_SUPERVISOR_FULL_NAME, ';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.REQUEST_DATE,''' || v_db_zone || ''' , ''' || pzone || ''') REQUEST_DATE,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_START,''' || v_db_zone || ''' , ''' || pzone || ''') PLANNED_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_END,''' || v_db_zone || ''' , ''' || pzone || ''') PLANNED_END,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ACTUAL_OUTAGE_START,''' || v_db_zone || ''' , ''' || pzone || ''') ACTUAL_OUTAGE_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PFZ_IMPL_TIME,''' || v_db_zone || ''' , ''' || pzone || ''') PFZ_IMPL_TIME,';
		v_select_stmt := v_select_stmt || ' CM3PHASELOGM1.PHASE_NAME, CM3PHASELOGM1.STARTED_DATE, PFZSITESM1.DESCRIPTION, PFZSITESM1.PFZ_REGION_ID, '|| '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM CM3PHASELOGM1 CM3PHASELOGM1 INNER JOIN CM3RM1 CM3RM1 ON CM3PHASELOGM1.NUMBERPRGN = CM3RM1.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN PFZSITESM1 PFZSITESM1 ON CM3RM1.PFZ_SITE_ID = PFZSITESM1.SITE_ID ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('CM3RM1.PFZ_SITE_ID', site) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('PFZSITESM1.PFZ_REGION_ID', region) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.ASSIGN_DEPT, '' '')', assign_group) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.ASSIGN_DEPT, '' '')', excl_group) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('NVL(CM3RM1.pfz_supervisor_full_name, '' '')', excl_cm_lead) || ')';
		v_select_stmt := v_select_stmt || ' AND  CM3RM1.CATEGORY = ''RFC'' AND CM3PHASELOGM1.PHASE_NAME = ''RFC PIR/A''';
-- 04.24.09 		v_select_stmt := v_select_stmt || ' AND (CM3PHASELOGM1.STARTED_DATE >= ' || '''' || v_gmt_startdate || '''' || 'AND CM3PHASELOGM1.STARTED_DATE < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND CM3PHASELOGM1.STARTED_DATE between to_date(''' || v_gmt_startdate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') and to_date(''' || v_gmt_enddate_str || ''',''' || 'DD-MM-YYYY HH24:MI:SS' || ''') ';
      OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_RFC_STATS;

-- ******************************************
-- Used for  CM Approved or Pending Summary Statistics report 	07.12.06-shw-
  PROCEDURE BISP_SELECT_CM_STATS (rfc_cursor IN OUT BICUR_RFC_TYPE,
									region 	  	 	 IN VARCHAR2,
									area 			 IN VARCHAR2,
									assign_group 	 IN VARCHAR2,
									pfrequency       IN VARCHAR2,
      								poverride        IN VARCHAR2,
      								pzone            IN VARCHAR2,
      								pstartdate       IN DATE,
      								penddate         IN DATE
   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_gmt_startdate_str  VARCHAR2 (19);
      v_gmt_enddate_str    VARCHAR2 (19);          
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
   		v_db_zone := 'GMT';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_gmt_startdate_str := TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS');
        v_gmt_enddate_str   := TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS');

		v_select_stmt := 'SELECT CM3RM1.NUMBERPRGN, CM3RM1.NETWORK_NAME,CM3RM1.PFZ_SITE_ID,CM3RM1.LOCATION,CM3RM1.PFZ_REGION_ID,CM3RM1.STATUS,CM3RM1.APPROVAL_STATUS, CM3RM1.CLOSED_BY, CM3RM1.CLOSING_COMMENTS,';
		v_select_stmt := v_select_stmt || ' CM3RM1.REQUEST_DATE,CM3RM1.ORIG_DATE_ENTERED,CM3RM1.ASSIGNED_TO,CM3RM1.PLANNED_START,CM3RM1.PLANNED_END, CM3RM1.REASON, CM3RM1.CURRENT_PHASE, CM3RM1.RISK_ASSESSMENT, CM3RM1.PRIORITY, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.BRIEF_DESCRIPTION, CM3RM1.CHANGE_CATEGORY, CM3RM1.REVIEWER_CLASS, CM3RM1.APPROVED_GROUPS, ';
		v_select_stmt := v_select_stmt || ' al.groupprgn,al.operator_fullname,al.dateprgn enddate,(select max(al1.dateprgn) from sc.approvallogm1 al1 where al1.dateprgn <= al.dateprgn and al1.groupprgn <>  '|| '''' || assign_group || '''' ||' and al1.unique_key = al.unique_key) startdate, ';
		v_select_stmt := v_select_stmt || ' ((al.dateprgn - (select  max(al1.dateprgn) from sc.approvallogm1 al1 where al1.dateprgn <= al.dateprgn and al1.groupprgn <>  '|| '''' || assign_group || '''' ||' and al1.unique_key = al.unique_key)) *1440) elapsedtime,';
		v_select_stmt := v_select_stmt || ''|| '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM CM3RM1';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN PFZSITESM1 PFZSITESM1 ON CM3RM1.PFZ_SITE_ID = PFZSITESM1.SITE_ID ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN approvallogM1 al on CM3RM1.NUMBERPRGN = al.UNIQUE_KEY ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('CM3RM1.PFZ_SITE_ID',area) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('PFZSITESM1.PFZ_REGION_ID',region) || ')';
		v_select_stmt := v_select_stmt || ' AND  (CM3RM1.APPROVAL_STATUS = ' || '''' || 'approved' || '''' || '  OR CM3RM1.APPROVAL_STATUS = ' || '''' || 'pending' || '''' || ')';
		v_select_stmt := v_select_stmt || ' AND (instr(CM3RM1.REVIEWER_CLASS,'|| '''' ||  assign_group || '''' ||') > 0 ';
		v_select_stmt := v_select_stmt || ' OR  instr(CM3RM1.APPROVED_GROUPS,'|| '''' ||  assign_group || '''' ||') > 0) ';
    	v_select_stmt := v_select_stmt || ' AND al.groupprgn = '|| '''' || assign_group || '''' ||'' ;
		v_select_stmt := v_select_stmt || ' AND (CM3RM1.ORIG_DATE_ENTERED >= ' || '''' || v_gmt_startdate || '''' || 'AND CM3RM1.ORIG_DATE_ENTERED < ' || '''' || v_gmt_enddate || ''')' ;

      OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_CM_STATS;


-- ******************************************
-- The main procedure for RFCs. This is the one called by the report specific procedures.
  PROCEDURE BISP_SELECT_RFC_MAIN (rfc_cursor IN OUT BICUR_RFC_TYPE,
                                    whichclause IN VARCHAR2,
									in_rfc_number IN VARCHAR2,
									in_group IN VARCHAR2,
									dstartdate         IN       DATE,
									denddate           IN       DATE,
									frequency          IN       VARCHAR2,
									override           IN       VARCHAR2,
									ZONE               IN       VARCHAR2
									) AS
     vselectclause      VARCHAR2(1500);
	 vwhereclause       VARCHAR2(500);
	 vsql               VARCHAR2(2000);
     vfromtz            VARCHAR2 (3);
     v_startdatedisplay VARCHAR2 (50) := ' ';
     v_enddatedisplay   VARCHAR2 (50) := ' ';
     v_gmt_startdate    DATE;
     v_gmt_enddate      DATE;
  BEGIN
     IF (whichclause != 'RFC')
	 THEN
        vfromtz := 'GMT';
	    Bipkg_Utils.bisp_getStartAndEndDates(frequency, override, ZONE, dstartdate, denddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_startdate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
	    v_enddatedisplay := TO_CHAR(Bipkg_Utils.bifnc_AdjustForTZ(v_gmt_enddate, vfromtz, ZONE), 'DD-MM-YYYY HH24:MI:SS');
	 END IF;
     vselectclause := 'SELECT IPL_TYPE, CHANGE_CATEGORY, REASON, BRIEF_DESCRIPTION, PFZ_ASSIGN_FULL_NAME, '||
	 'SUBCATEGORY, PFZ_SITE_ID, RISK_ASSESSMENT, PFZ_IMPACT, STATUS, PFZ_OUTAGE_REQD, PFZ_REGION_ID, NUMBERPRGN, '||
	 'PLANNED_START, LOGICAL_NAME, CURRENT_PHASE, PFZ_RETRO, PRIORITY, PFZ_ABSOLUTE_RISK, SCHED_OUTAGE_START, '||
	 'SCHED_OUTAGE_END, PHONE, ASSIGN_DEPT, PFZ_ASSIGN_LOCATION, PFZ_ASSIGN_EMAIL, PFZ_RB_FULL_NAME, PFZ_RB_PHONE, '||
	 'PFZ_RB_DEPT, PFZ_RB_BU, PFZ_RB_LOCATION, PFZ_RB_BUILDING, PFZ_RB_FLOOR, PFZ_RB_ROOM, PFZ_RB_CHARGE_CODE, '||
	 'PFZ_FULL_NAME, ASSIGN_PHONE, DEPT, PFZ_BU, LOCATION, BUILDING, FLOOR, ROOM, CONTACT_EMAIL, PFZ_CHARGE_CODE, '||
	 'COORDINATOR, PFZ_SUPERVISOR_FULL_NAME, PFZ_GLOBAL_COMM, PFZ_DR_AGREEMENT, PFZ_RAISE_PROFILE, '||
	 'PFZ_MILESTONE_PID, PFZ_BUSINESS_REF, FOREIGN_ID, COMPLETION_CODE, REQUEST_DATE, PLANNED_END, DESCRIPTION, '||
	 'PFZ_IMPACT_STATEMENT, PFZ_RISK_STATEMENT, JUSTIFICATION, PFZ_TECH_DESCRIPTION, PFZ_IMPLEMENTATION_PLAN, '||
	 'PFZ_PRE_TEST, PFZ_POST_TEST, PFZ_UPDATE_ACTION, PFZ_UPDATE_ACTION_ENTRY, PFZ_SUPPORT, BACKOUT_METHOD, '||
	 'PFZ_TDRP_PROVISIONS, PFZ_ESCALATION_PROC, PFZ_REQUISITES, CLOSING_COMMENTS, ORIG_DATE_ENTERED, '||
	 'APPROVAL_STATUS,ACTUAL_OUTAGE_START, PFZ_IMPL_TIME, PFZ_OPEN_GROUP, '||'''' || v_startdatedisplay ||
	 '''' || ' StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay '||
	 ' FROM CM3RM1 ';
	 IF (whichclause = 'RFC')
	 THEN
	    vwhereclause := 'WHERE NUMBERPRGN = '||''''||IN_RFC_NUMBER||'''';
	 ELSE
	    vwhereclause := 'WHERE  PFZ_OPEN_GROUP= '||''''||IN_GROUP ||''''||
	    ' AND (PFZ_IMPL_TIME BETWEEN '||''''||v_gmt_startdate|| ''''|| ' AND '||''''||v_gmt_enddate || ''''||')'||
	    ' ORDER BY ASSIGN_DEPT';
	 END IF;
	 vsql := vselectclause||' '||vwhereclause;
  END BISP_SELECT_RFC_MAIN;

  -- Procedure to select RFC by RFC number.
  PROCEDURE BISP_SELECT_RFC_BY_NUM (rfc_cursor IN OUT BICUR_RFC_TYPE,
									in_rfc_number IN VARCHAR2) AS
  BEGIN
  -- Just call the generic procedure with a parameter RFC.
     BISP_SELECT_RFC_MAIN (rfc_cursor,'RFC', in_rfc_number, '', NULL, NULL, '', '', '');
  END BISP_SELECT_RFC_BY_NUM;

-- ******************************************
-- Used for  3rd Weekend Change Window report
  PROCEDURE BISP_SELECT_THIRD_WEEKEND (rfc_cursor IN OUT BICUR_RFC_TYPE,
									status	  	 	 IN VARCHAR2,
									impact 			 IN VARCHAR2,
									raiseprofile	 IN VARCHAR2,
      								pzone            IN VARCHAR2,
      								pstartdate       IN DATE,
      								penddate         IN DATE
   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
	  pfrequency           VARCHAR2(10);
      poverride            VARCHAR2(10);
      v_whereclause        VARCHAR2 (32767);
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
   		v_db_zone := 'GMT';
		poverride := 0;
		pfrequency := 'ad-hoc';
		Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT DEVICEM1.NETWORK_NAME, CM3RM1.NUMBERPRGN, CM3RM1.NETWORK_NAME,CM3RM1.PRIORITY, CM3RM1.PFZ_SITE_ID,CM3RM1.LOCATION,CM3RM1.PFZ_REGION_ID,CM3RM1.STATUS,CM3RM1.APPROVAL_STATUS, CM3RM1.CLOSED_BY, CM3RM1.CLOSING_COMMENTS,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_END,';
		v_select_stmt := v_select_stmt || ' CM3RM1.ASSIGNED_TO,CM3RM1.REASON, CM3RM1.CURRENT_PHASE,';
		v_select_stmt := v_select_stmt || ' CM3RM1.IPL_TYPE, CM3RM1.PFZ_ASSIGN_FULL_NAME ,CM3RM1.SUBCATEGORY,CM3RM1.RISK_ASSESSMENT, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_IMPACT, CM3RM1.PFZ_OUTAGE_REQD, CM3RM1.LOGICAL_NAME, CM3RM1.PFZ_RETRO,';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_ABSOLUTE_RISK, CM3RM1.PHONE, CM3RM1.ASSIGN_DEPT, CM3RM1.PFZ_ASSIGN_LOCATION, CM3RM1.PFZ_ASSIGN_EMAIL, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_RB_FULL_NAME, CM3RM1.PFZ_RB_PHONE, CM3RM1.PFZ_RB_DEPT, CM3RM1.PFZ_RB_BU, CM3RM1.PFZ_RB_LOCATION, CM3RM1.PFZ_RB_BUILDING, CM3RM1.PFZ_RB_FLOOR, CM3RM1.PFZ_RB_ROOM, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_RB_CHARGE_CODE, CM3RM1.PFZ_FULL_NAME, CM3RM1.ASSIGN_PHONE, CM3RM1.DEPT, CM3RM1.PFZ_BU,CM3RM1.BUILDING, CM3RM1.FLOOR, CM3RM1.ROOM, CM3RM1.CONTACT_EMAIL,';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_CHARGE_CODE, CM3RM1.COORDINATOR, CM3RM1.PFZ_SUPERVISOR_FULL_NAME, CM3RM1.PFZ_GLOBAL_COMM, CM3RM1.PFZ_DR_AGREEMENT, CM3RM1.PFZ_RAISE_PROFILE, CM3RM1.PFZ_MILESTONE_PID, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_BUSINESS_REF, CM3RM1.FOREIGN_ID, CM3RM1.COMPLETION_CODE, CM3RM1.DESCRIPTION, CM3RM1.PFZ_IMPACT_STATEMENT, CM3RM1.PFZ_RISK_STATEMENT, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.JUSTIFICATION, CM3RM1.PFZ_TECH_DESCRIPTION, CM3RM1.PFZ_IMPLEMENTATION_PLAN, CM3RM1.PFZ_PRE_TEST, CM3RM1.PFZ_POST_TEST, CM3RM1.PFZ_UPDATE_ACTION, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_UPDATE_ACTION_ENTRY, CM3RM1.PFZ_SUPPORT, CM3RM1.BACKOUT_METHOD, CM3RM1.PFZ_TDRP_PROVISIONS, CM3RM1.PFZ_ESCALATION_PROC, CM3RM1.PFZ_REQUISITES, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.BRIEF_DESCRIPTION, CM3RM1.CHANGE_CATEGORY, CM3RM1.REVIEWER_CLASS, CM3RM1.APPROVED_GROUPS ';
		v_select_stmt := v_select_stmt || ' FROM CM3RM1 LEFT OUTER JOIN DEVICEM1 ON CM3RM1.NETWORK_NAME = DEVICEM1.NETWORK_NAME ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('CM3RM1.STATUS',status) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('CM3RM1.PFZ_IMPACT',impact) || ')';
		v_select_stmt := v_select_stmt || ' AND (CM3RM1.PLANNED_START >= ' || '''' || v_gmt_startdate || '''' || 'AND CM3RM1.PLANNED_END < ' || '''' || v_gmt_enddate || ''')' ;
		IF (raiseprofile = 'Yes')
		THEN
			v_whereclause := ' AND CM3RM1.PFZ_RAISE_PROFILE = ' || '''' || 't' || '''' || '';
		END IF;

		v_select_stmt := v_select_stmt || v_whereclause ;

      OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_THIRD_WEEKEND;

-- ******************************************
-- Used for  CM Change Freeze report 	07.21.06-shw-
-- 			 modified 10.04.06-shw- to incluse ALL CI names affected by the RFC (CM3RA3)
  PROCEDURE BISP_SELECT_CHANGE_FREEZE (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2,
									server 			 IN VARCHAR2,
      								pzone            IN VARCHAR2
   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
   		v_db_zone := 'GMT';
		v_select_stmt := 'SELECT DEVICEM1.NETWORK_NAME, CM3RM1.NUMBERPRGN, CM3RM1.NETWORK_NAME,CM3RM1.PFZ_SITE_ID,CM3RM1.LOCATION,CM3RM1.PFZ_REGION_ID,CM3RM1.STATUS,CM3RM1.APPROVAL_STATUS, CM3RM1.CLOSED_BY, CM3RM1.CLOSING_COMMENTS,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_END,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.REQUEST_DATE,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') REQUEST_DATE,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ORIG_DATE_ENTERED,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') ORIG_DATE_ENTERED,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.SCHED_OUTAGE_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') SCHED_OUTAGE_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.SCHED_OUTAGE_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') SCHED_OUTAGE_END,';
		v_select_stmt := v_select_stmt || ' CM3RM1.ASSIGNED_TO,CM3RM1.REASON, CM3RM1.CURRENT_PHASE,';
		v_select_stmt := v_select_stmt || ' CM3RM1.IPL_TYPE, CM3RM1.PFZ_ASSIGN_FULL_NAME ,CM3RM1.SUBCATEGORY,CM3RM1.RISK_ASSESSMENT, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_IMPACT, CM3RM1.PFZ_OUTAGE_REQD, CM3RM1.LOGICAL_NAME, CM3RM1.PFZ_RETRO,';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_ABSOLUTE_RISK, CM3RM1.PHONE, CM3RM1.ASSIGN_DEPT, CM3RM1.PFZ_ASSIGN_LOCATION, CM3RM1.PFZ_ASSIGN_EMAIL, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_RB_FULL_NAME, CM3RM1.PFZ_RB_PHONE, CM3RM1.PFZ_RB_DEPT, CM3RM1.PFZ_RB_BU, CM3RM1.PFZ_RB_LOCATION, CM3RM1.PFZ_RB_BUILDING, CM3RM1.PFZ_RB_FLOOR, CM3RM1.PFZ_RB_ROOM, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_RB_CHARGE_CODE, CM3RM1.PFZ_FULL_NAME, CM3RM1.ASSIGN_PHONE, CM3RM1.DEPT, CM3RM1.PFZ_BU,CM3RM1.BUILDING, CM3RM1.FLOOR, CM3RM1.ROOM, CM3RM1.CONTACT_EMAIL,';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_CHARGE_CODE, CM3RM1.COORDINATOR, CM3RM1.PFZ_SUPERVISOR_FULL_NAME, CM3RM1.PFZ_GLOBAL_COMM, CM3RM1.PFZ_DR_AGREEMENT, CM3RM1.PFZ_RAISE_PROFILE, CM3RM1.PFZ_MILESTONE_PID, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_BUSINESS_REF, CM3RM1.FOREIGN_ID, CM3RM1.COMPLETION_CODE, CM3RM1.DESCRIPTION, CM3RM1.PFZ_IMPACT_STATEMENT, CM3RM1.PFZ_RISK_STATEMENT, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.JUSTIFICATION, CM3RM1.PFZ_TECH_DESCRIPTION, CM3RM1.PFZ_IMPLEMENTATION_PLAN, CM3RM1.PFZ_PRE_TEST, CM3RM1.PFZ_POST_TEST, CM3RM1.PFZ_UPDATE_ACTION, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_UPDATE_ACTION_ENTRY, CM3RM1.PFZ_SUPPORT, CM3RM1.BACKOUT_METHOD, CM3RM1.PFZ_TDRP_PROVISIONS, CM3RM1.PFZ_ESCALATION_PROC, CM3RM1.PFZ_REQUISITES, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.BRIEF_DESCRIPTION, CM3RM1.CHANGE_CATEGORY, CM3RM1.REVIEWER_CLASS, CM3RM1.APPROVED_GROUPS ';
		v_select_stmt := v_select_stmt || ' FROM CM3RA3 INNER JOIN DEVICEM1 ON CM3RA3.ASSETS = DEVICEM1.LOGICAL_NAME ';
		v_select_stmt := v_select_stmt || ' INNER JOIN CM3RM1 ON CM3RA3.NUMBERPRGN = CM3RM1.NUMBERPRGN ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('CM3RM1.NUMBERPRGN',rfc) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('DEVICEM1.NETWORK_NAME',server) || ')';

      OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_CHANGE_FREEZE;

-- Used for  "RFCs closed by a Team" main report
  PROCEDURE BISP_SELECT_RFC_BYATEAM (rfc_cursor IN OUT BICUR_RFC_TYPE,
									open_group 	     IN VARCHAR2,
									pfrequency       IN VARCHAR2,
      								poverride        IN VARCHAR2,
      								pzone            IN VARCHAR2,
      								pstartdate       IN DATE,
      								penddate         IN DATE
   ) AS
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
		v_select_stmt := 'SELECT CM3RM1.NUMBERPRGN, CM3RM1.NETWORK_NAME,CM3RM1.PFZ_SITE_ID,CM3RM1.LOCATION,CM3RM1.PFZ_REGION_ID,CM3RM1.STATUS,CM3RM1.APPROVAL_STATUS, CM3RM1.CLOSED_BY, CM3RM1.CLOSING_COMMENTS,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_END,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.REQUEST_DATE,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') REQUEST_DATE,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ORIG_DATE_ENTERED,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') ORIG_DATE_ENTERED,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.SCHED_OUTAGE_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') SCHED_OUTAGE_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.SCHED_OUTAGE_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') SCHED_OUTAGE_END,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ACTUAL_OUTAGE_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') ACTUAL_OUTAGE_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ACTUAL_OUTAGE_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') ACTUAL_OUTAGE_END,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PFZ_PIRA_DATE,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PFZ_PIRA_DATE,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PFZ_IMPL_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PFZ_IMPL_TIME,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME,';
		v_select_stmt := v_select_stmt || ' CM3RM1.ASSIGNED_TO,CM3RM1.REASON, CM3RM1.CURRENT_PHASE,';
		v_select_stmt := v_select_stmt || ' CM3RM1.IPL_TYPE, CM3RM1.PFZ_ASSIGN_FULL_NAME ,CM3RM1.SUBCATEGORY,CM3RM1.RISK_ASSESSMENT, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_IMPACT, CM3RM1.PFZ_OUTAGE_REQD, CM3RM1.LOGICAL_NAME, CM3RM1.PFZ_RETRO,';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_ABSOLUTE_RISK, CM3RM1.PHONE, CM3RM1.ASSIGN_DEPT, CM3RM1.PFZ_ASSIGN_LOCATION, CM3RM1.PFZ_ASSIGN_EMAIL, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_RB_FULL_NAME, CM3RM1.PFZ_RB_PHONE, CM3RM1.PFZ_RB_DEPT, CM3RM1.PFZ_RB_BU, CM3RM1.PFZ_RB_LOCATION, CM3RM1.PFZ_RB_BUILDING, CM3RM1.PFZ_RB_FLOOR, CM3RM1.PFZ_RB_ROOM, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_RB_CHARGE_CODE, CM3RM1.PFZ_FULL_NAME, CM3RM1.ASSIGN_PHONE, CM3RM1.DEPT, CM3RM1.PFZ_BU,CM3RM1.BUILDING, CM3RM1.FLOOR, CM3RM1.ROOM, CM3RM1.CONTACT_EMAIL,';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_CHARGE_CODE, CM3RM1.COORDINATOR, CM3RM1.PFZ_SUPERVISOR_FULL_NAME, CM3RM1.PFZ_GLOBAL_COMM, CM3RM1.PFZ_DR_AGREEMENT, CM3RM1.PFZ_RAISE_PROFILE, CM3RM1.PFZ_MILESTONE_PID, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_BUSINESS_REF, CM3RM1.FOREIGN_ID, CM3RM1.COMPLETION_CODE, CM3RM1.DESCRIPTION, CM3RM1.PFZ_IMPACT_STATEMENT, CM3RM1.PFZ_RISK_STATEMENT, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.JUSTIFICATION, CM3RM1.PFZ_TECH_DESCRIPTION, CM3RM1.PFZ_IMPLEMENTATION_PLAN, CM3RM1.PFZ_PRE_TEST, CM3RM1.PFZ_POST_TEST, CM3RM1.PFZ_UPDATE_ACTION, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_UPDATE_ACTION_ENTRY, CM3RM1.PFZ_SUPPORT, CM3RM1.BACKOUT_METHOD, CM3RM1.PFZ_TDRP_PROVISIONS, CM3RM1.PFZ_ESCALATION_PROC, CM3RM1.PFZ_REQUISITES, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.BRIEF_DESCRIPTION, CM3RM1.CHANGE_CATEGORY, CM3RM1.REVIEWER_CLASS, CM3RM1.APPROVED_GROUPS, CM3RM1.DURATION,CM3RM1.HOURS_WORKED, CM3RM1.PFZ_NON_CMDB_VAL,';
		v_select_stmt := v_select_stmt || ' CM3RM1.PRIORITY, CM3RM1.PFZ_COMPLETED_BY, CM3RM1.PFZ_PIRA_STATUS, CM3RM1.PFZ_PIRA_BY, CM3RM1.PFZ_PIRA_TYPE, CM3RM1.PFZ_PIRA_BRIEF, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_PIRA_DETAILS, CM3RM1.PFZ_PIRA_CLOSE_COMMENTS, CM3RM1.ORIG_OPERATOR, CM3RM1.PFZ_OPEN_GROUP, CM3RM1.UPDATED_BY, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_UPDATE_GROUP, CM3RM1.PFZ_IMPL_BY, CM3RM1.PFZ_IMPL_GROUP, CM3RM1.PFZ_CLOSE_GROUP, '|| '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM CM3RM1';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('CM3RM1.PFZ_OPEN_GROUP',open_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (CM3RM1.PFZ_IMPL_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND CM3RM1.PFZ_IMPL_TIME < ' || '''' || v_gmt_enddate || ''')' ;

      OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_RFC_BYATEAM;

-- ******************************************
-- Used for  "RFC Changes by Approval-Reviewer" report 	12.15.06-shw-
  PROCEDURE BISP_SELECT_RFC_CHANGES (rfc_cursor IN OUT BICUR_RFC_TYPE,
									Region 	  	 	 IN VARCHAR2,
									Site 	  	 	 IN VARCHAR2,
									CATEGORY 		 IN VARCHAR2,
									Status			 IN VARCHAR2,
      								Pzone            IN VARCHAR2,
									GROUPS			 IN VARCHAR2
   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_currentdate        VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
   		v_db_zone := 'GMT';
--		v_currentdate := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(sysdate, 'EST', Pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT CM3RM1.NUMBERPRGN, CM3RM1.NETWORK_NAME,CM3RM1.PFZ_SITE_ID,CM3RM1.LOCATION,CM3RM1.PFZ_REGION_ID,CM3RM1.STATUS,CM3RM1.APPROVAL_STATUS, CM3RM1.CLOSED_BY, CM3RM1.CLOSING_COMMENTS,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_END,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.REQUEST_DATE,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') REQUEST_DATE,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ORIG_DATE_ENTERED,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') ORIG_DATE_ENTERED,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.SCHED_OUTAGE_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') SCHED_OUTAGE_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.SCHED_OUTAGE_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') SCHED_OUTAGE_END,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ACTUAL_OUTAGE_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') ACTUAL_OUTAGE_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ACTUAL_OUTAGE_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') ACTUAL_OUTAGE_END,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PFZ_PIRA_DATE,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PFZ_PIRA_DATE,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PFZ_IMPL_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PFZ_IMPL_TIME,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME,';
		v_select_stmt := v_select_stmt || ' CM3RM1.ASSIGNED_TO,CM3RM1.REASON, CM3RM1.CURRENT_PHASE, CM3RM1.CATEGORY,';
		v_select_stmt := v_select_stmt || ' CM3RM1.IPL_TYPE, CM3RM1.PFZ_ASSIGN_FULL_NAME ,CM3RM1.SUBCATEGORY,CM3RM1.RISK_ASSESSMENT, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_IMPACT, CM3RM1.PFZ_OUTAGE_REQD, CM3RM1.LOGICAL_NAME, CM3RM1.PFZ_RETRO,';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_ABSOLUTE_RISK, CM3RM1.PHONE, CM3RM1.ASSIGN_DEPT, CM3RM1.PFZ_ASSIGN_LOCATION, CM3RM1.PFZ_ASSIGN_EMAIL, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_RB_FULL_NAME, CM3RM1.PFZ_RB_PHONE, CM3RM1.PFZ_RB_DEPT, CM3RM1.PFZ_RB_BU, CM3RM1.PFZ_RB_LOCATION, CM3RM1.PFZ_RB_BUILDING, CM3RM1.PFZ_RB_FLOOR, CM3RM1.PFZ_RB_ROOM, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_RB_CHARGE_CODE, CM3RM1.PFZ_FULL_NAME, CM3RM1.ASSIGN_PHONE, CM3RM1.DEPT, CM3RM1.PFZ_BU,CM3RM1.BUILDING, CM3RM1.FLOOR, CM3RM1.ROOM, CM3RM1.CONTACT_EMAIL,';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_CHARGE_CODE, CM3RM1.COORDINATOR, CM3RM1.PFZ_SUPERVISOR_FULL_NAME, CM3RM1.PFZ_GLOBAL_COMM, CM3RM1.PFZ_DR_AGREEMENT, CM3RM1.PFZ_RAISE_PROFILE, CM3RM1.PFZ_MILESTONE_PID, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_BUSINESS_REF, CM3RM1.FOREIGN_ID, CM3RM1.COMPLETION_CODE, CM3RM1.DESCRIPTION, CM3RM1.PFZ_IMPACT_STATEMENT, CM3RM1.PFZ_RISK_STATEMENT, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.JUSTIFICATION, CM3RM1.PFZ_TECH_DESCRIPTION, CM3RM1.PFZ_IMPLEMENTATION_PLAN, CM3RM1.PFZ_PRE_TEST, CM3RM1.PFZ_POST_TEST, CM3RM1.PFZ_UPDATE_ACTION, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_UPDATE_ACTION_ENTRY, CM3RM1.PFZ_SUPPORT, CM3RM1.BACKOUT_METHOD, CM3RM1.PFZ_TDRP_PROVISIONS, CM3RM1.PFZ_ESCALATION_PROC, CM3RM1.PFZ_REQUISITES, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.BRIEF_DESCRIPTION, CM3RM1.CHANGE_CATEGORY, CM3RM1.REVIEWER_CLASS, CM3RM1.APPROVED_GROUPS, CM3RM1.DURATION,CM3RM1.HOURS_WORKED, CM3RM1.PFZ_NON_CMDB_VAL,';
		v_select_stmt := v_select_stmt || ' CM3RM1.PRIORITY, CM3RM1.PFZ_COMPLETED_BY, CM3RM1.PFZ_PIRA_STATUS, CM3RM1.PFZ_PIRA_BY, CM3RM1.PFZ_PIRA_TYPE, CM3RM1.PFZ_PIRA_BRIEF, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_PIRA_DETAILS, CM3RM1.PFZ_PIRA_CLOSE_COMMENTS, CM3RM1.ORIG_OPERATOR, CM3RM1.PFZ_OPEN_GROUP, CM3RM1.UPDATED_BY, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_UPDATE_GROUP, CM3RM1.PFZ_IMPL_BY, CM3RM1.PFZ_IMPL_GROUP, CM3RM1.PFZ_CLOSE_GROUP, CM3RM1.PFZ_CHANGE_REVIEWER, ';
		v_select_stmt := v_select_stmt || ' DEVICEM1.LOCATION, DEVICEM1.PFZ_MANAGING_SITE, DEVICEM1.NETWORK_NAME, CM3RA1.CURRENT_PENDING_GROUPS, APPROVALLOGM1.GROUPPRGN, APPROVAL_VW.LOCATION, APPROVAL_VW.GROUPPRGN '; --,'|| '''' || v_currentdate || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM CM3RM1';
		v_select_stmt := v_select_stmt || ' INNER JOIN CM3RA3 ON CM3RM1.NUMBERPRGN = CM3RA3.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' INNER JOIN DEVICEM1 ON CM3RA3.ASSETS = DEVICEM1.LOGICAL_NAME ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN CM3RA1 ON CM3RM1.NUMBERPRGN = CM3RA1.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN APPROVAL_VW ON CM3RM1.NUMBERPRGN = APPROVAL_VW.UNIQUE_KEY ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN APPROVALLOGM1 ON CM3RM1.NUMBERPRGN = APPROVALLOGM1.UNIQUE_KEY ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('CM3RM1.PFZ_REGION_ID',region) || ')';
		v_select_stmt := v_select_stmt || ' AND CM3RM1.PLANNED_END >= ' || '''' || SYSDATE || '''' ;
		v_select_stmt := v_select_stmt || ' AND CM3RM1.CATEGORY = ' || '''' || 'RFC' || '''' || '';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('CM3RM1.SUBCATEGORY',CATEGORY) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('CM3RM1.STATUS',Status) || ')';
		v_select_stmt := v_select_stmt || ' AND ((instr(CM3RM1.REVIEWER_CLASS,'|| '''' || Site || '''' ||') > 0 ';
		v_select_stmt := v_select_stmt || ' OR  (' || Bipkg_Utils.BIFNC_createinlist ('CM3RA1.CURRENT_PENDING_GROUPS',GROUPS) || ')';
		v_select_stmt := v_select_stmt || ' OR  (' || Bipkg_Utils.BIFNC_createinlist ('APPROVALLOGM1.GROUPPRGN ',GROUPS) || ')';
		v_select_stmt := v_select_stmt || ' OR  ((' || Bipkg_Utils.BIFNC_createinlist ('APPROVAL_VW.GROUPPRGN ',GROUPS) || ')';
		v_select_stmt := v_select_stmt || ' AND APPROVAL_VW.LOCATION = ' || '''' || 'Future' || '''' || ' )))';

      OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_RFC_CHANGES;

-- ******************************************
-- Used for  "RFC Printout" main report 	09.25.06-shw-
  PROCEDURE BISP_SELECT_RFC_PRINTOUT (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2,
									CIname 			 IN VARCHAR2,
      								pzone            IN VARCHAR2
   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
   		v_db_zone := 'GMT';
		v_select_stmt := 'SELECT CM3RM1.NUMBERPRGN, CM3RM1.NETWORK_NAME,CM3RM1.PFZ_SITE_ID,CM3RM1.LOCATION,CM3RM1.PFZ_REGION_ID,CM3RM1.STATUS,CM3RM1.APPROVAL_STATUS, CM3RM1.CLOSED_BY, CM3RM1.CLOSING_COMMENTS,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PLANNED_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_END,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.REQUEST_DATE,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') REQUEST_DATE,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ORIG_DATE_ENTERED,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') ORIG_DATE_ENTERED,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.SCHED_OUTAGE_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') SCHED_OUTAGE_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.SCHED_OUTAGE_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') SCHED_OUTAGE_END,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ACTUAL_OUTAGE_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') ACTUAL_OUTAGE_START,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.ACTUAL_OUTAGE_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') ACTUAL_OUTAGE_END,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PFZ_PIRA_DATE,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PFZ_PIRA_DATE,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.PFZ_IMPL_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PFZ_IMPL_TIME,';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(CM3RM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME,';
		v_select_stmt := v_select_stmt || ' CM3RM1.ASSIGNED_TO,CM3RM1.REASON, CM3RM1.CURRENT_PHASE,';
		v_select_stmt := v_select_stmt || ' CM3RM1.IPL_TYPE, CM3RM1.PFZ_ASSIGN_FULL_NAME ,CM3RM1.SUBCATEGORY,CM3RM1.RISK_ASSESSMENT, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_IMPACT, CM3RM1.PFZ_OUTAGE_REQD, CM3RM1.LOGICAL_NAME, CM3RM1.PFZ_RETRO,';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_ABSOLUTE_RISK, CM3RM1.PHONE, CM3RM1.ASSIGN_DEPT, CM3RM1.PFZ_ASSIGN_LOCATION, CM3RM1.PFZ_ASSIGN_EMAIL, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_RB_FULL_NAME, CM3RM1.PFZ_RB_PHONE, CM3RM1.PFZ_RB_DEPT, CM3RM1.PFZ_RB_BU, CM3RM1.PFZ_RB_LOCATION, CM3RM1.PFZ_RB_BUILDING, CM3RM1.PFZ_RB_FLOOR, CM3RM1.PFZ_RB_ROOM, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_RB_CHARGE_CODE, CM3RM1.PFZ_FULL_NAME, CM3RM1.ASSIGN_PHONE, CM3RM1.DEPT, CM3RM1.PFZ_BU,CM3RM1.BUILDING, CM3RM1.FLOOR, CM3RM1.ROOM, CM3RM1.CONTACT_EMAIL,';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_CHARGE_CODE, CM3RM1.COORDINATOR, CM3RM1.PFZ_SUPERVISOR_FULL_NAME, CM3RM1.PFZ_GLOBAL_COMM, CM3RM1.PFZ_DR_AGREEMENT, CM3RM1.PFZ_RAISE_PROFILE, CM3RM1.PFZ_MILESTONE_PID, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_BUSINESS_REF, CM3RM1.FOREIGN_ID, CM3RM1.COMPLETION_CODE, CM3RM1.DESCRIPTION, CM3RM1.PFZ_IMPACT_STATEMENT, CM3RM1.PFZ_RISK_STATEMENT, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.JUSTIFICATION, CM3RM1.PFZ_TECH_DESCRIPTION, CM3RM1.PFZ_IMPLEMENTATION_PLAN, CM3RM1.PFZ_PRE_TEST, CM3RM1.PFZ_POST_TEST, CM3RM1.PFZ_UPDATE_ACTION, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_UPDATE_ACTION_ENTRY, CM3RM1.PFZ_SUPPORT, CM3RM1.BACKOUT_METHOD, CM3RM1.PFZ_TDRP_PROVISIONS, CM3RM1.PFZ_ESCALATION_PROC, CM3RM1.PFZ_REQUISITES, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.BRIEF_DESCRIPTION, CM3RM1.CHANGE_CATEGORY, CM3RM1.REVIEWER_CLASS, CM3RM1.APPROVED_GROUPS, CM3RM1.DURATION,CM3RM1.HOURS_WORKED, CM3RM1.PFZ_NON_CMDB_VAL,';
		v_select_stmt := v_select_stmt || ' CM3RM1.PRIORITY, CM3RM1.PFZ_COMPLETED_BY, CM3RM1.PFZ_PIRA_STATUS, CM3RM1.PFZ_PIRA_BY, CM3RM1.PFZ_PIRA_TYPE, CM3RM1.PFZ_PIRA_BRIEF, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_PIRA_DETAILS, CM3RM1.PFZ_PIRA_CLOSE_COMMENTS, CM3RM1.ORIG_OPERATOR, CM3RM1.PFZ_OPEN_GROUP, CM3RM1.UPDATED_BY, ';
		v_select_stmt := v_select_stmt || ' CM3RM1.PFZ_UPDATE_GROUP, CM3RM1.PFZ_IMPL_BY, CM3RM1.PFZ_IMPL_GROUP, CM3RM1.PFZ_CLOSE_GROUP, CM3RM1.PFZ_CHANGE_REVIEWER ';
		v_select_stmt := v_select_stmt || ' FROM CM3RM1';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('CM3RM1.NUMBERPRGN',rfc) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('CM3RM1.NETWORK_NAME',CIname) || ')';

      OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_RFC_PRINTOUT;

-- ******************************************
-- Used for  "RFC Printout-CI Items " SUB report 	09.25.06-shw-
  PROCEDURE BISP_SELECT_CI_ITEMS (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
	   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
   		v_db_zone := 'GMT';
		v_select_stmt := 'SELECT CM3RA3.NUMBERPRGN,DEVICEM1.NETWORK_NAME,  DEVICEM1.LOGICAL_NAME, DEVICEM1.PFZ_VALIDATED, ';
		v_select_stmt := v_select_stmt || 'DEVICEM1.PFZ_QUALIFIED, DEVICEM1.PFZ_FROZEN, DEVICEM1.TYPE, DEVICEM1.SUBTYPE, DEVICEM1.ISTATUS, ';
		v_select_stmt := v_select_stmt || 'DEVICEM1.LOCATION ';
		v_select_stmt := v_select_stmt || 'FROM CM3RA3 INNER JOIN DEVICEM1 ON CM3RA3.ASSETS = DEVICEM1.LOGICAL_NAME ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('CM3RA3.NUMBERPRGN',rfc) || ')';

       OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_CI_ITEMS;

-- ******************************************
-- Used for  "RFC Printout-Services Affected " SUB report 	09.25.06-shw-
  PROCEDURE BISP_SELECT_Services_Affected (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
	   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
   		v_db_zone := 'GMT';
		v_select_stmt := 'SELECT CM3RA14.NUMBERPRGN, DEVICEM1.NETWORK_NAME,  DEVICEM1.LOGICAL_NAME, DEVICEM1.PFZ_FULL_NAME, ';
		v_select_stmt := v_select_stmt || 'DEVICEM1.PFZ_VALIDATED, DEVICEM1.PFZ_GLOBAL, DEVICEM1.DESCRIPTION ';
		v_select_stmt := v_select_stmt || 'FROM CM3RA14 INNER JOIN DEVICEM1 ON CM3RA14.PFZ_SERVICES_AFFECTED = DEVICEM1.LOGICAL_NAME ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('CM3RA14.NUMBERPRGN',rfc) || ')';

       OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_Services_Affected;

-- ******************************************
-- Used for  "RFC Printout-RFC Tasks" SUB report 	09.26.06-shw-
  PROCEDURE BISP_SELECT_RFC_Tasks (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
	   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
   		v_db_zone := 'GMT';
		v_select_stmt := 'SELECT CM3TM1.NUMBERPRGN, CM3TM1.ASSIGNED_TO, CM3TM1.STATUS, CM3TM1.PARENT_CHANGE, CM3TM1.ASSIGNMENT, CM3TM1.DESCRIPTION ';
		v_select_stmt := v_select_stmt || 'FROM CM3TM1  ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('CM3TM1.PARENT_CHANGE',rfc) || ')';

       OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_RFC_Tasks;

-- ******************************************
-- Used for  "RFC Printout-RFC  Related Incidents" SUB report 	09.26.06-shw-
  PROCEDURE BISP_SELECT_Related_Incidents (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
	   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
   		v_db_zone := 'GMT';
		v_select_stmt := 'SELECT PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.PFZ_RB_FULL_NAME, PROBSUMMARYM1.PROBLEM_STATUS, PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.BRIEF_DESCRIPTION, SCRELATIONM1.SOURCE ';
		v_select_stmt := v_select_stmt || ' FROM   SCRELATIONM1 INNER JOIN PROBSUMMARYM1 ON SCRELATIONM1.DEPEND = PROBSUMMARYM1.NUMBERPRGN  ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('SCRELATIONM1.SOURCE',rfc) || ')';

       OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_Related_Incidents;

-- ******************************************
-- Used for  "RFC Printout-RFC  Related Changes" SUB report 	09.26.06-shw-
  PROCEDURE BISP_SELECT_Related_Changes (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
	   ) AS
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
		v_select_stmt := 'SELECT CM3RM1.CURRENT_PHASE, SCRELATIONM1.SOURCE, CM3RM1.NUMBERPRGN, CM3RM1.SUBCATEGORY, CM3RM1.STATUS ';
		v_select_stmt := v_select_stmt || ' FROM  SCRELATIONM1 INNER JOIN CM3RM1 ON SCRELATIONM1.DEPEND = CM3RM1.NUMBERPRGN  ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('SCRELATIONM1.SOURCE',rfc) || ')';

       OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_Related_Changes;

-- ******************************************
-- Used for  "RFC Printout-RFC  Related CAB Notes" SUB report 	09.26.06-shw-
  PROCEDURE BISP_SELECT_Related_CAB_Notes (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2,
      								pzone            IN VARCHAR2
	   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
   		v_db_zone := 'GMT';
		v_select_stmt := 'SELECT PFZRFCCABNOTESM1.CAB, PFZRFCCABNOTESM1.NUMBERPRGN, PFZRFCCABNOTESM1.NOTES, ';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(PFZRFCCABNOTESM1.CAB_DATE,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CAB_DATE ';
		v_select_stmt := v_select_stmt || ' FROM  PFZRFCCABNOTESM1 ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('PFZRFCCABNOTESM1.NUMBERPRGN',rfc) || ')';

       OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_Related_CAB_Notes;

-- ******************************************
-- Used for  "RFC Printout-Pending Approval" SUB report 	09.26.06-shw-
  PROCEDURE BISP_SELECT_Pending_Approval (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
	   ) AS
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
		v_select_stmt := 'SELECT CM3RA1.CURRENT_PENDING_GROUPS, CM3RA1.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' FROM  CM3RA1  ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('CM3RA1.NUMBERPRGN',rfc) || ')';

       OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_Pending_Approval;

-- ******************************************
-- Used for  "RFC Printout-Past Approval" SUB report 	09.26.06-shw-
  PROCEDURE BISP_SELECT_Past_Approval (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2,
      								pzone            IN VARCHAR2
	   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
   		v_db_zone := 'GMT';
		v_select_stmt := 'SELECT APPROVALLOGM1.UNIQUE_KEY, APPROVALLOGM1.GROUPPRGN, APPROVALLOGM1.COMMENTS, APPROVALLOGM1.ACTION, APPROVALLOGM1.OPERATOR_FULLNAME, ';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ( APPROVALLOGM1.DATEPRGN,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') DATEPRGN ';
		v_select_stmt := v_select_stmt || ' FROM APPROVALLOGM1 ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('APPROVALLOGM1.UNIQUE_KEY',rfc) || ')';

       OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_Past_Approval;

-- ******************************************
-- Used for  "RFC Printout-Future Approval" SUB report 	09.26.06-shw-
  PROCEDURE BISP_SELECT_Future_Approval (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
	   ) AS
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
		v_select_stmt := 'SELECT APPROVAL_VW.UNIQUE_KEY, APPROVAL_VW.GROUPPRGN, APPROVAL_VW.LOCATION ';
		v_select_stmt := v_select_stmt || ' FROM  APPROVAL_VW ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('APPROVAL_VW.UNIQUE_KEY',rfc) || ')';
		v_select_stmt := v_select_stmt || ' AND  APPROVAL_VW.LOCATION = ' || '''' || 'Future' || '''' || ' ';

       OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_Future_Approval;

-- ******************************************
-- Used for  "RFC Printout-PIRA Details" SUB report 	09.26.06-shw-
  PROCEDURE BISP_SELECT_PIRA_Details (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2
	   ) AS
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
		v_select_stmt := 'SELECT CM3RA2.PIRA_ACTION_DESC, CM3RA2.PIRA_ACTION_RESP, CM3RA2.PIRA_ACTION_STATUS, CM3RA2.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' FROM  CM3RA2 ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('CM3RA2.NUMBERPRGN',rfc) || ')';

       OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_PIRA_Details;

-- ******************************************
-- Used for  "RFC Printout-Phase Log" SUB report 	09.26.06-shw-
  PROCEDURE BISP_SELECT_Phase_Log (rfc_cursor IN OUT BICUR_RFC_TYPE,
									rfc 	  	 	 IN VARCHAR2,
      								pzone            IN VARCHAR2
	   ) AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
	BEGIN
   		v_db_zone := 'GMT';
		v_select_stmt := 'SELECT CM3PHASELOGM1.PHASE_NAME, CM3PHASELOGM1.OPENED_BY, CM3PHASELOGM1.OPEN_GROUP, CM3PHASELOGM1.NUMBERPRGN, ';
		v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ( CM3PHASELOGM1.STARTED_DATE,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') STARTED_DATE ';
		v_select_stmt := v_select_stmt || ' FROM CM3PHASELOGM1 ';
  		v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('CM3PHASELOGM1.NUMBERPRGN',rfc) || ')';

       OPEN rfc_cursor FOR v_select_stmt ;

    END BISP_SELECT_Phase_Log;


END Bipkg_Select_Rfc;
/

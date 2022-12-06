CREATE OR REPLACE PACKAGE BIPKG_ACTIVITY_RESCODESR AS
/******************************************************************************
   NAME:       BIPKG_ACTIVITY_RESCODESR
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------------
   1.0        10/23/2006    Rithesh         1.This store procedure is to pass the parameter values to report 
                                             'Resolution Code Statistics Report-sproc.rpt'   
******************************************************************************************************************/
 TYPE bisp_refcursor_type IS REF CURSOR;
     
	-- Store procedure for main report
	PROCEDURE BISP_SELECT_RESCODER01 (
     select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         prescode 		           IN		VARCHAR2,
							 passignmentgroup          IN       VARCHAR2,
							 ppriority                 IN       VARCHAR2
							
   );
	
	 --Store procedure for Non-Complaint-Sub rpt 
	 PROCEDURE BISP_SELECT_RESCODENC (
     select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         prescode 		           IN		VARCHAR2,
							 passignmentgroup          IN       VARCHAR2,
							 crescode 		           IN		VARCHAR2,
							 ppriority                 IN       VARCHAR2
   );
   ---Store procedure for Vendor-Sub rpt 
   PROCEDURE BISP_SELECT_RESCODEV (
     select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         prescode 		           IN		VARCHAR2,
							 passignmentgroup          IN       VARCHAR2,
							 ppriority                 IN       VARCHAR2
   );
   ---Store procedure for SBC-Sub rpt 
   PROCEDURE BISP_SELECT_RESCODESBC(
     select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         prescode 		           IN		VARCHAR2,
							 passignmentgroup          IN       VARCHAR2,
							 ppriority                 IN       VARCHAR2
   );
END BIPKG_ACTIVITY_RESCODESR;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_ACTIVITY_RESCODESR AS
/******************************************************************************
   NAME:       BIPKG_ACTIVITY_RESCODESR
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------
   1.0        10/23/2006   Rithesh        1.This store procedure is to pass the parameter values to report 
                                           'Resolution Code Statistics Report-sproc.rpt'   
***********************************************************************************************************/
-- Store procedure for main report
PROCEDURE BISP_SELECT_RESCODER01 (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         prescode 		           IN		VARCHAR2,
							 passignmentgroup          IN       VARCHAR2,
							 ppriority                 IN       VARCHAR2
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
		bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
	    v_select_stmt := 'SELECT PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.RESOLUTION_CODE, PROBSUMMARYM1.NUMBERPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, PROBSUMMARYM1.PFZ_TOTAL_TIME_SPENT, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.ASSIGNEE_NAME, ASSIGNMENTM1.PFZ_REPORTING_GROUP, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1 ' ;
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ASSIGNMENTM1 ASSIGNMENTM1 ON PROBSUMMARYM1.ASSIGNMENT = ASSIGNMENTM1.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('ASSIGNMENTM1.PFZ_REPORTING_GROUP', porig_group) || ')';		
        v_select_stmt := v_select_stmt || ' AND (PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.PFZ_SLA_TITLE', ppriority) || ')';
	    v_select_stmt := v_select_stmt || ' AND NOT (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.RESOLUTION_CODE', prescode) || ')';	
      OPEN select_calls_cursor  FOR v_select_stmt ;
   END BISP_SELECT_RESCODER01 ;



--Store procedure for Non-Complaint-Sub rpt 
PROCEDURE BISP_SELECT_RESCODENC (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         prescode 		           IN		VARCHAR2,
							 passignmentgroup          IN       VARCHAR2,
							 crescode 		           IN		VARCHAR2,
							 ppriority                 IN       VARCHAR2
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
		bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT PROBSUMMARYM1.ASSIGNMENT,PROBSUMMARYM1.PRIORITY_CODE, PROBSUMMARYM1.RESOLUTION_CODE, PROBSUMMARYM1.NUMBERPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, PROBSUMMARYM1.PFZ_TOTAL_TIME_SPENT, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.ASSIGNEE_NAME, ASSIGNMENTM1.PFZ_REPORTING_GROUP, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1 ' ;
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ASSIGNMENTM1 ASSIGNMENTM1 ON PROBSUMMARYM1.ASSIGNMENT = ASSIGNMENTM1.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('ASSIGNMENTM1.PFZ_REPORTING_GROUP', porig_group) || ')';		
        v_select_stmt := v_select_stmt || ' AND (PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.PFZ_SLA_TITLE', ppriority) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.RESOLUTION_CODE', prescode) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.RESOLUTION_CODE', crescode) || ')';
 
        OPEN select_calls_cursor  FOR v_select_stmt ;
   END BISP_SELECT_RESCODENC ;
   
   
  ---Store procedure for Vendor-Sub rpt  
PROCEDURE BISP_SELECT_RESCODEV(
select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         prescode 		           IN		VARCHAR2,
							 passignmentgroup          IN       VARCHAR2,
							 ppriority                 IN       VARCHAR2
   )
   IS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);

   BEGIN
   
   v_db_zone := 'GMT';
		bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT PROBSUMMARYM1.ASSIGNMENT,PROBSUMMARYM1.PRIORITY_CODE, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, PROBSUMMARYM1.RESOLUTION_CODE, PROBSUMMARYM1.NUMBERPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, PROBSUMMARYM1.PFZ_TOTAL_TIME_SPENT, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.VENDOR, PROBSUMMARYM1.OPEN_GROUP,  ASSIGNMENTM1.PFZ_REPORTING_GROUP, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1 ' ;
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ASSIGNMENTM1 ASSIGNMENTM1 ON PROBSUMMARYM1.ASSIGNMENT = ASSIGNMENTM1.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('ASSIGNMENTM1.PFZ_REPORTING_GROUP', porig_group) || ')';		
        v_select_stmt := v_select_stmt || ' AND (PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.PFZ_SLA_TITLE', ppriority) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.RESOLUTION_CODE', prescode) || ')';
        v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.VENDOR IS  NOT  NULL';
        v_select_stmt := v_select_stmt || ' AND NOT (PROBSUMMARYM1.ASSIGNMENT =  ' || '''' || 'MET-CIT-SBC' || '''' || ')';
      OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_RESCODEV;
                      
   
   
   ---Store procedure for SBC-Sub rpt 
   PROCEDURE BISP_SELECT_RESCODESBC(
select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         prescode 		           IN		VARCHAR2,
							 passignmentgroup          IN       VARCHAR2,
							 ppriority                 IN       VARCHAR2
   )
   IS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);

   BEGIN
   
   v_db_zone := 'GMT';
		bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT PROBSUMMARYM1.ASSIGNMENT,PROBSUMMARYM1.PRIORITY_CODE, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, PROBSUMMARYM1.RESOLUTION_CODE, PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.OPEN_TIME, PROBSUMMARYM1.PFZ_TOTAL_TIME_SPENT, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.VENDOR, PROBSUMMARYM1.OPEN_GROUP, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1 ' ;
        v_select_stmt := v_select_stmt || ' WHERE (PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.PFZ_SLA_TITLE', ppriority) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.RESOLUTION_CODE', prescode) || ')';	
		v_select_stmt := v_select_stmt || ' AND (PROBSUMMARYM1.ASSIGNMENT =  ' || '''' || 'MET-CIT-SBC' || '''' || ')';
		OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_RESCODESBC;

END BIPKG_ACTIVITY_RESCODESR;
/


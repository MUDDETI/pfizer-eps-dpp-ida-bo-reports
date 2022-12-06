CREATE OR REPLACE PACKAGE BIPKG_EIWEEKLY_230PROJSR AS
/******************************************************************************
   NAME:       BIPKG_EIWEEKLY_230PROJSR
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------
   1.0        10/17/2006     Rithesh        1.This store procedure is to pass the parameter values to report
                                             '230 Project Status Reporting-sproc.rpt' 
***************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BISP_SELECT_ASSOCIATEDTASKS (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
	                         pticket 		           IN		VARCHAR2
						
						   );
   
PROCEDURE BISP_SELECT_MASTERPROJ (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
					   );

END BIPKG_EIWEEKLY_230PROJSR;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_EIWEEKLY_230PROJSR AS
/******************************************************************************
   NAME:       BIPKG_EIWEEKLY_230PROJSR
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------------
   1.0        10/17/2006    Rithesh         1.This store procedure is to pass the parameter values to report
                                             '230 Project Status Reporting-sproc.rpt' 
******************************************************************************************************************/

PROCEDURE BISP_SELECT_ASSOCIATEDTASKS (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
	                         pticket 		           IN		VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_currentdate		   VARCHAR2 (150);
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   	v_db_zone := 'GMT';
		bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_currentdate	   :=	'to_date(''' || TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (SYSDATE, 'EST', pzone),'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';		
		v_select_stmt := 'SELECT PROBSUMMARYM1.NUMBERPRGN, SCRELATIONM1.DEPEND, SCRELATIONM1.SOURCE, PROBSUMMARYM1.ASSIGNEE_NAME, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.PLANNED_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_START, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.PLANNED_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_END, PROBSUMMARYM1.PFZ_TOTAL_TIME_SPENT, PROBSUMMARYM1.PROBLEM_STATUS, PROBSUMMARYM1.BRIEF_DESCRIPTION, PROBSUMMARYM1.FLAG, PROBSUMMARYM1.PFZ_EST_TIME, PROBSUMMARYM1.PFZ_MILESTONE_PID, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM SCRELATIONM1 SCRELATIONM1 ' ;
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBSUMMARYM1 PROBSUMMARYM1 ON SCRELATIONM1.DEPEND = PROBSUMMARYM1.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(SCRELATIONM1.SOURCE,'|| '''' || ' ' || '''' ||')', pticket) || ')';
		v_select_stmt := v_select_stmt || ' AND (SCRELATIONM1.DEPEND like  ' || '''' || '%i' || '''' || ')'; 
		
		
		OPEN select_calls_cursor  FOR v_select_stmt ;
   END BISP_SELECT_ASSOCIATEDTASKS;
   
   
   
PROCEDURE BISP_SELECT_MASTERPROJ(
select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
			
   )
   IS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
	  v_currentdate		   VARCHAR2 (150);
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);

   BEGIN
   
   v_db_zone := 'GMT';
		bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_currentdate	   :=	'to_date(''' || TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (SYSDATE, 'EST', pzone),'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';		
		v_select_stmt := 'SELECT PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.FLAG, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.PLANNED_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_END, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.PLANNED_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_START, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, PROBSUMMARYM1.PFZ_TOTAL_TIME_SPENT, PROBSUMMARYM1.ASSIGNEE_NAME, PROBSUMMARYM1.PFZ_EST_TIME, PROBSUMMARYM1.PROBLEM_STATUS, SCRELATIONM1.DEPEND, PROBSUMMARYM1.PFZ_PROJECT, PROBSUMMARYM1.BRIEF_DESCRIPTION, PROBSUMMARYM1.PFZ_MILESTONE_PID, PROBSUMMARYM1.ACTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1 ' ;
		v_select_stmt := v_select_stmt || ' INNER JOIN SCRELATIONM1 SCRELATIONM1 ON PROBSUMMARYM1.NUMBERPRGN = SCRELATIONM1.SOURCE ';
		v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (SCRELATIONM1.DEPEND like  ' || '''' || '%i' || '''' || ')'; 
  		v_select_stmt := v_select_stmt || ' AND  (PROBSUMMARYM1.FLAG = ' || '''' || 't' || '''' || 'OR PROBSUMMARYM1.CLOSE_TIME>= ' || '''' || v_gmt_startdate || '''' || ')';
		v_select_stmt := v_select_stmt || ' AND (PROBSUMMARYM1.PFZ_PROJECT =  ' || '''' || 'Master' || '''' || ')'; 
	    	                                                                                                                               
 
    OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_MASTERPROJ;


END BIPKG_EIWEEKLY_230PROJSR;
/


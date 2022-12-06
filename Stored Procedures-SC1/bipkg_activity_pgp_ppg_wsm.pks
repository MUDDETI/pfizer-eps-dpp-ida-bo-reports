CREATE OR REPLACE PACKAGE BIPKG_ACTIVITY_PGP_PPG_WSM AS
/******************************************************************************
   NAME:       BIPKG_ACTIVITY_PGP_PPG_WSM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------------------------------------------------
   1.0        09/26/2006      Rithesh       1. This store procedure passes the parameter values to report
                                              'PGP PPG Weekly Service Meeting Report  All Open Tickets or Those Closed in Past Weekmike2-sproc.rpt'
*****************************************************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_ACTIVITY_PGP_PPG_WSM (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE
							
						
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_ACTIVITY_PGP_PPG_WSM;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_ACTIVITY_PGP_PPG_WSM AS
/******************************************************************************
   NAME:       BIPKG_ACTIVITY_PGP_PPG_WSM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------------------------------------------------
   1.0        09/26/2006     Rithesh        1. This store procedure passes the parameter values to report
                                              'PGP PPG Weekly Service Meeting Report  All Open Tickets or Those Closed in Past Weekmike2-sproc.rpt'
******************************************************************************************************************************************************/

PROCEDURE BIPKG_ACTIVITY_PGP_PPG_WSM(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE
							
							
							 
		
		
               
                        ) AS
						
		 				
	      v_select_stmt        VARCHAR2(32767);
          v_close_time          DATE;
		  v_startdatedisplay   VARCHAR2(50);
          v_enddatedisplay     VARCHAR2(50);
          v_db_zone            VARCHAR2(10);      
	      v_gmt_startdate      DATE;
          v_gmt_enddate        DATE;
		  
		  
          
   BEGIN          
  
        v_db_zone := 'GMT';	  
  	    bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
v_select_stmt := 'SELECT INCIDENTSM1.INCIDENT_ID,INCIDENTSM1.CLOSED_BY, INCIDENTSM1.BRIEF_DESCRIPTION, INCIDENTSM1.PRODUCT_TYPE, INCIDENTSM1.PROBLEM_TYPE, INCIDENTSM1.PFZ_RB_FULL_NAME, INCIDENTSM1.PFZ_SLA_TITLE, PROBSUMMARYM1.NUMBERPRGN, INCIDENTSM1.FIRST_CALL, OPERATORM1V.FULL_NAME, PROBSUMMARYM1.FLAG, OPERATORM1V_2.FULL_NAME, OPERATORM1V_1.FULL_NAME, PROBSUMMARYM1.STATUS, INCIDENTSM1.PFZ_DIVISION, INCIDENTSM1.LOCATION,BIPKG_UTILS.BIFNC_AdjustForTZ(INCIDENTSM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, PROBSUMMARYM1.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ(INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1 ' ;
v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN SCRELATIONM1 SCRELATIONM1 ON INCIDENTSM1.INCIDENT_ID = SCRELATIONM1.SOURCE';
v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN OPERATORM1V OPERATORM1V ON INCIDENTSM1.CLOSED_BY = OPERATORM1V.NAME';
v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN PROBSUMMARYM1 PROBSUMMARYM1 ON SCRELATIONM1.DEPEND = PROBSUMMARYM1.NUMBERPRGN';
v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN OPERATORM1V OPERATORM1V_1 ON PROBSUMMARYM1.CLOSED_BY = OPERATORM1V_1.NAME';
v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN OPERATORM1V OPERATORM1V_2 ON PROBSUMMARYM1.ASSIGNEE_NAME = OPERATORM1V_2.NAME';
v_select_stmt := v_select_stmt || ' WHERE INCIDENTSM1.LOCATION = ' || '''' || 'NEW YORK' || '''' || ''; 
v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.PFZ_DIVISION = ' || '''' || 'PGP' || '''' || 'OR INCIDENTSM1.PFZ_DIVISION = ' || '''' || 'PPG' || ''')';	
v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'OR INCIDENTSM1.CLOSE_TIME is NULL)';
v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.PFZ_DIVISION = ' || '''' || 'PGP' || '''' || 'OR INCIDENTSM1.PFZ_DIVISION = ' || '''' || 'PPG' || ''')';	
	
	OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_ACTIVITY_PGP_PPG_WSM;
END BIPKG_ACTIVITY_PGP_PPG_WSM;
/


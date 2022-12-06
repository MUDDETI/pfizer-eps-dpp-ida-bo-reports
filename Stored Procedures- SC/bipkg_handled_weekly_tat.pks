CREATE OR REPLACE PACKAGE BIPKG_HANDLED_WEEKLY_TAT AS
/******************************************************************************
   NAME:       BIPKG_HANDLED_WEEKLY_TAT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/25/2006    Rithesh         1. Created this package.
******************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_HANDLED_WEEKLY_TAT (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
			                 passignmentgroup          IN       VARCHAR2
							
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_HANDLED_WEEKLY_TAT;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_HANDLED_WEEKLY_TAT AS
/******************************************************************************
   NAME:       BIPKG_HANDLED_WEEKLY_TAT  
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/25/2006    Rithesh         1. Created this package body.
******************************************************************************/

PROCEDURE BIPKG_HANDLED_WEEKLY_TAT(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
							
							
							 
		
		
               
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
		v_select_stmt := 'SELECT  OPERATORM1V.FULL_NAME, PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.FLAG, PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.USER_PRIORITY, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, PROBSUMMARYM1.ASSIGNEE_NAME, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBLEMM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, PROBLEMM1.FLAG, PROBLEMM1.NUMBERPRGN, PROBLEMM1.UPDATED_BY, PROBLEMM1.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1 ' ;
        v_select_stmt := v_select_stmt || ' INNER JOIN PROBLEMM1 PROBLEMM1 ON PROBSUMMARYM1.NUMBERPRGN = PROBLEMM1.NUMBERPRGN  ';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN OPERATORM1V OPERATORM1V ON PROBSUMMARYM1.ASSIGNEE_NAME = OPERATORM1V.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE (PROBSUMMARYM1.FLAG =' || '''' || 'f' || '''' ;
        v_select_stmt := v_select_stmt || ' AND (PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || ' AND PROBSUMMARYM1.CLOSE_TIME< ' || '''' || v_gmt_enddate || ''')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup)|| ')'; 
        v_select_stmt := v_select_stmt || ' OR PROBSUMMARYM1.FLAG = ' || '''' || 't' || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup)|| ')';
        v_select_stmt := v_select_stmt || ' AND PROBLEMM1.UPDATE_TIME < ' || '''' || v_gmt_enddate || ''''; 
        v_select_stmt := v_select_stmt || ' OR (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup)|| ')';
        v_select_stmt := v_select_stmt || ' AND (PROBSUMMARYM1.OPEN_TIME>= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.OPEN_TIME<' || '''' || v_gmt_enddate || '''))';
	    
        OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_HANDLED_WEEKLY_TAT;
END BIPKG_HANDLED_WEEKLY_TAT;
/


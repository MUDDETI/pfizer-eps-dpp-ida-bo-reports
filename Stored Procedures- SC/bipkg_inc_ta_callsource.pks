CREATE OR REPLACE PACKAGE BIPKG_INC_TA_CallSource AS
/******************************************************************************
   NAME:       BIPKG_INC_TA_CallSource
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------
   1.0        09/28/2006    Rithesh         1. To pass the parameter values to Report
                                              'Ticket Assignment by Call Source-sproc.rpt''
********************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_TA_CallSource (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 psource			       IN       VARCHAR2,
							 passignmentgroup          IN       VARCHAR2
						
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_INC_TA_CallSource;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_TA_CallSource AS
/******************************************************************************
   NAME:       BIPKG_INC_TA_CallSource
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------
   1.0        09/28/2006    Rithesh         1. To pass the parameter values to Report
                                              'Ticket Assignment by Call Source-sproc.rpt''
***************************************************************************************************/

PROCEDURE BIPKG_INC_TA_CallSource(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
             
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 psource			       IN       VARCHAR2,
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
		v_select_stmt := 'SELECT PROBSUMMARYM1.BRIEF_DESCRIPTION, PROBSUMMARYM1.PRODUCT_TYPE, PROBLEMM1.ASSIGNEE_NAME, PROBLEMM1.ASSIGNMENT, PROBLEMM2.PFZ_CALL_SOURCE, PROBLEMM1.LAST_ACTIVITY, PROBLEMM1.PFZ_LAST_ASSIGNMENT, PROBLEMM1.OPEN_GROUP, PROBLEMM1.PFZ_SLA_TITLE, PROBLEMM1.UPDATED_BY, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBLEMM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, PROBLEMM1.NUMBERPRGN, PROBLEMM1.PAGE, PROBSUMMARYM1.NUMBERPRGN, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1' ;
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBLEMM1 PROBLEMM1 ON PROBSUMMARYM1.NUMBERPRGN = PROBLEMM1.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBLEMM2 PROBLEMM2 ON PROBLEMM1.NUMBERPRGN = PROBLEMM2.NUMBERPRGN AND (PROBLEMM1.PAGE = PROBLEMM2.PAGE) ' ;
	    v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT(PROBLEMM1.UPDATED_BY = ' || '''' || 'problem' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (PROBLEMM1.LAST_ACTIVITY = ' || '''' || 'ASSIGN' || '''' || 'OR PROBLEMM1.LAST_ACTIVITY = ' || '''' || 'Open' || ''')';
		v_select_stmt := v_select_stmt || ' AND (PROBLEMM1.ASSIGNEE_NAME = ' || '''' || 'UNASSIGNED' || '''' || ')';
	   	v_select_stmt := v_select_stmt || ' AND PROBLEMM1.UPDATE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBLEMM1.UPDATE_TIME < ' || '''' || v_gmt_enddate || '''' ;
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBLEMM2.PFZ_CALL_SOURCE', psource) || ')';
		 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_INC_TA_CallSource;
END BIPKG_INC_TA_CallSource;
/


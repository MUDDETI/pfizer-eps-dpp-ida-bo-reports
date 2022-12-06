CREATE OR REPLACE PACKAGE BIPKG_INC_REASSIGNMENT AS
/******************************************************************************
   NAME:       BIPKG_INC_REASSIGNMENT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------
   1.0        09/13/2006    Rithesh         1. To pass parameter values to report 
                                               Tickets closed by a Queue w_Reassignments-sproc.rpt
*******************************************************************************************************/

   
TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_REASSIGNMENT (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                      
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
							
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_INC_REASSIGNMENT;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_REASSIGNMENT AS
/******************************************************************************
   NAME:       BIPKG_INC_REASSIGNMENT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------
   1.0        09/13/2006    Rithesh         1. To pass parameter values to report 
                                               Tickets closed by a Queue w_Reassignments-sproc.rpt
*****************************************************************************************************/

PROCEDURE BIPKG_INC_REASSIGNMENT(

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
		v_select_stmt := 'SELECT PROBSUMMARYM1.COUNTPRGN, PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1';
    	v_select_stmt := v_select_stmt || ' WHERE PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;
		v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.COUNTPRGN >=  1 '; 
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.assignment', passignmentgroup) || ')';

         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_INC_REASSIGNMENT;         
END BIPKG_INC_REASSIGNMENT;
/


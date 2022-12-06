CREATE OR REPLACE PACKAGE BIPKG_GDE_SLA AS
/******************************************************************************
   NAME:       BIPKG_GDE_SLA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------------------
   1.0        09/01/2006       Rithesh      1. To pass the parameter values to report gde with location and division.rpt
*****************************************************************************************************************************/

  TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_GDE_SLA ( select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             passignmentgroup          IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 presolution		       IN		VARCHAR2
							 
														 
							 
							 
							 		 
							 
							 
                             );


END BIPKG_GDE_SLA;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_GDE_SLA AS
/******************************************************************************
   NAME:       BIPKG_GDE_SLA
   PURPOSE:
REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------------------
   1.0        09/01/2006       Rithesh      1. To pass the parameter values to report gde with location and division.rpt
*****************************************************************************************************************************/
PROCEDURE BIPKG_GDE_SLA (

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
                             
							 passignmentgroup          IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 presolution		       IN		VARCHAR2
							 
		
		
               
                        ) AS
						
		 				
	      v_select_stmt        VARCHAR2(32767);
		  v_open_time          DATE;
          v_startdatedisplay   VARCHAR2(50);
          v_enddatedisplay     VARCHAR2(50);
          v_db_zone            VARCHAR2(10);      
	      v_gmt_startdate      DATE;
          v_gmt_enddate        DATE;
		  v_currentdate        VARCHAR(50);
		  
	
	         
  BEGIN 
	
	    v_db_zone := 'GMT';	  
  	    bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT   PROBSUMMARYM1.STATUS, PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.PFZ_DIVISION, PROBSUMMARYM1.BRIEF_DESCRIPTION,PROBSUMMARYM1.ASSIGNEE_NAME, PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.LOCATION, PROBSUMMARYM1.RESOLUTION_CODE,BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay'; 
		v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1';
    	v_select_stmt := v_select_stmt || ' WHERE PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;
		V_select_stmt := v_select_stmt || 'AND (' ||bipkg_utils.bifnc_createinlist ('probsummarym1.resolution_code', presolution)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.assignment', passignmentgroup) || ')';
		
		
		
         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_GDE_SLA;         
END BIPKG_GDE_SLA;
/


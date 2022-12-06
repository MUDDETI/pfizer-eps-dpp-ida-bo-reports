CREATE OR REPLACE PACKAGE BIPKG_ACTIVITY_QUEUESUMMARY
AS
/******************************************************************************
   NAME:       bipkg_inc_proj
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------
   1.0        08/25/2006   Rithesh Makkena     1.This store procedure are to pass the 
                                              parameters to BIPKG_ACTIVITY_QUEUESUMMARY-SPROC report
************************************************************************************************/

-- Public type declarations

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_ACTIVITY_QUEUESUMMARY (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_ACTIVITY_QUEUESUMMARY;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_ACTIVITY_QUEUESUMMARY AS
/******************************************************************************
   NAME:       BIPKG_ACTIVITY_QUEUESUMMARY
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------
   1.0        08/25/2006             1.This store procedure are to pass the 
                                     parameters to BIPKG_ACTIVITY_QUEUESUMMARY-SPROC report
**********************************************************************************************/




PROCEDURE BIPKG_ACTIVITY_QUEUESUMMARY(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2, 		
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
		passignmentgroup         IN       VARCHAR2
		
		
		
               
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
        
		v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_currentdate := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(sysdate, 'EST', pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt :=  ' SELECT PROBSUMMARYM1.ASSIGNMENT,PROBSUMMARYM1.ASSIGNEE_NAME,PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.PFZ_ASSIGN_COUNT, PROBSUMMARYM1.PFZ_FULL_NAME, PROBSUMMARYM1.PFZ_TOTAL_TIME_SPENT, PROBSUMMARYM1.RESOLUTION_CODE,PROBSUMMARYM1.FLAG,PROBSUMMARYM1.OPEN_GROUP,PROBSUMMARYM1.REASSIGNED,PROBSUMMARYM1.PROBLEM_TYPE, PROBSUMMARYM1.PRODUCT_TYPE, PROBSUMMARYM1.LOCATION,PROBSUMMARYM1.COUNTPRGN,BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, '|| '''' || v_currentdate || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1';
		v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (probsummarym1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.open_time < ' || '''' || v_gmt_enddate || ''')';
		

   OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_ACTIVITY_QUEUESUMMARY;         
END BIPKG_ACTIVITY_QUEUESUMMARY;
/


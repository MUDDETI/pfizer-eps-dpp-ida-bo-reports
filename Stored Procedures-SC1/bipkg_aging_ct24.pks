CREATE OR REPLACE PACKAGE BIPKG_AGING_CT24 AS
/******************************************************************************
   NAME:       BIPKG_AGING_CT24
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------
   1.0        09/12/2006     Rithesh        1.To pass the parameter values to report
                                             'Closed Tickets within 24 Hours-sproc.rpt"
********************************************************************************************/

  
TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_AGING_CT24 (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                      
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_AGING_CT24;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_AGING_CT24 AS
/******************************************************************************
   NAME:       BIPKG_AGING_CT24
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------
   1.0        09/12/2006    Rithesh         1. To pass the parameter values to report
                                             'Closed Tickets within 24 Hours-sproc.rpt"
********************************************************************************************/
PROCEDURE BIPKG_AGING_CT24(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2, 		
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
		passignmentgroup         IN       VARCHAR2
		
		
		
               
                        ) AS
						
		 				
	      v_select_stmt        VARCHAR2(32767);
		  v_pfz_sla_title      VARCHAR2(40); 
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
		 v_select_stmt := ' SELECT PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.FLAG, PROBSUMMARYM1.NUMBERPRGN,PROBSUMMARYM1.DEADLINE, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, PROBSUMMARYM1.PFZ_SLA_TITLE,PROBSUMMARYM1.PFZ_FULL_NAME,PROBSUMMARYM1.RESOLUTION_CODE, PROBSUMMARYM1.ASSIGNEE_NAME,BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
	    v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')'; 
		v_select_stmt := v_select_stmt || ' AND NOT(PROBSUMMARYM1.PFZ_SLA_TITLE =  ' || '''' || 'Project' || '''' || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || '''' ;                      
								                             

         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_AGING_CT24;         
END BIPKG_AGING_CT24;
/


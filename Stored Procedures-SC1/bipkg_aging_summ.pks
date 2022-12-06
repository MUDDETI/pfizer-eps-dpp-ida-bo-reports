CREATE OR REPLACE PACKAGE BIPKG_AGING_SUMM AS
/******************************************************************************
   NAME:       BIPKG_AGING_SUMM
   PURPOSE:  

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------------
   1.0        09/06/2006     Rithesh        1.This store procedure is to pass the parameter returned values to
                                              report ' Open Tickets Summary by Assignment-Assignee.rpt''
******************************************************************************************************************/
TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_AGING_SUMM  (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  



END BIPKG_AGING_SUMM ;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_AGING_SUMM AS
/******************************************************************************
   NAME:       BIPKG_AGING_SUMM
   PURPOSE: 

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------
   1.0        09/06/2006    Rithesh         1. This store procedure is to pass the parameter returned values to
                                              report ' Open Tickets Summary by Assignment-Assignee.rpt''
****************************************************************************************************************/

PROCEDURE BIPKG_AGING_SUMM(

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
          v_flag               CHAR(1);
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
		v_select_stmt := 'SELECT BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,PROBSUMMARYM1.PROBLEM_STATUS, PROBSUMMARYM1.ASSIGNMENT,PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.ASSIGNEE_NAME,PROBSUMMARYM1.BRIEF_DESCRIPTION,PROBSUMMARYM1.PFZ_FULL_NAME, PROBSUMMARYM1.FLAG, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.USER_PRIORITY, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, PROBSUMMARYM1.STATUS, PROBSUMMARYM1.ALERT_STATUS,PROBSUMMARYM1.LAST_ACTIVITY, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1';
        v_select_stmt := v_select_stmt || ' WHERE probsummarym1.flag = ' || '''' || 't' || '''' || '';  
		v_select_stmt := v_select_stmt || ' AND(' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')'; 
		           

         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_AGING_SUMM;         
END BIPKG_AGING_SUMM;
/


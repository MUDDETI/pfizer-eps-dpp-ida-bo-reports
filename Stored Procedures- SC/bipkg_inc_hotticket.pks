CREATE OR REPLACE PACKAGE bipkg_inc_hotticket 
AS
/******************************************************************************
   NAME:       bipkg_inc_proj
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------
   1.0        08/16/2006   Rithesh Makkena     1.This store procedure are to pass the 
                                              parameters to Hot Ticket Detail Report-sproc.rpt
************************************************************************************************/

-- Public type declarations

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE bipkg_inc_hotticket (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             --PFZ_SLA_TITLE             IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END bipkg_inc_hotticket;
/
CREATE OR REPLACE PACKAGE BODY bipkg_inc_hotticket 
AS
/******************************************************************************
   NAME:       bipkg_inc_proj
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------
   1.0        08/16/2006   Rithesh Makkena     1. 1.This store procedure is to pass the 
                                              parameters to theHot Ticket Detail Report-sproc.rpt
 
**************************************************************************************************/

---Procedure Implementation 
PROCEDURE bipkg_inc_hotticket(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        
        --PFZ_SLA_TITLE            IN       VARCHAR2, 
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2, 		
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
		passignmentgroup         IN       VARCHAR2
		
		
		
               
                        ) AS
						
		 				
	      v_select_stmt        VARCHAR2(32767);
		  --v_pfz_sla_title      VARCHAR2(40); 
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
		v_db_zone := 'GMT';
	    bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt :=  'SELECT PROBSUMMARYM1.PROBLEM_STATUS, PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.BRIEF_DESCRIPTION, ACTIVITYM1.TYPE, ACTIVITYM1.SYSMODTIME, PROBSUMMARYM1.FLAG, PROBSUMMARYM1.LOCATION, PROBSUMMARYM1.HOT_TIC, PROBSUMMARYM1.PFZ_SLA_TITLE, ACTIVITYM1.DESCRIPTION,BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, '|| '''' || v_currentdate || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM   SC.PROBSUMMARYM1 PROBSUMMARYM1';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ACTIVITYM1 ACTIVITYM1 ON PROBSUMMARYM1.NUMBERPRGN = ACTIVITYM1.NUMBERPRGN';
		v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 't' || '''' || ''; 
		v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.HOT_TIC =  ' || '''' || 't' || '''' || '';                          
								                             

         OPEN select_calls_cursor FOR v_select_stmt;
  END bipkg_inc_hotticket;         
END bipkg_inc_hotticket;
/


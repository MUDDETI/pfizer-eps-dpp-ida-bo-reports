CREATE OR REPLACE PACKAGE BIPKG_INC_PROBLEMTICKETS AS
/******************************************************************************
   NAME:       BIPKG_INC_PROBLEMTICKETS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------------------------
   1.0        09/14/2006      Rithesh       1.  To pass the parameter values to report
                                               Problem Tickets Closed in the Period by Assignment Group & Resolution-sproc.rpt
*********************************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_PROBLEMTICKETS (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
						
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_INC_PROBLEMTICKETS;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_PROBLEMTICKETS AS
/******************************************************************************
   NAME:       BIPKG_INC_PROBLEMTICKETS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------------------------------
   1.0        09/14/2006     Rithesh        1. To pass the parameter values to report
                                               Problem Tickets Closed in the Period by Assignment Group & Resolution-sproc.rpt
*******************************************************************************************************************************/

PROCEDURE BIPKG_INC_PROBLEMTICKETS(

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
		  v_currentdate        VARCHAR(50);
		  
          
          
         
  BEGIN          
  
     v_db_zone := 'GMT';	  
  	    bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT  BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, PROBSUMMARYM1.PROBLEM_STATUS, PROBSUMMARYM1.PFZ_SLA_TITLE,BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME,PROBSUMMARYM1.FLAG, PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.ASSIGNEE_NAME, PROBSUMMARYM1.SYSMODUSER, PROBSUMMARYM1.BRIEF_DESCRIPTION, PROBSUMMARYM1.PFZ_FULL_NAME, ACTIVITYM1.TYPE, ACTIVITYM1.OPERATOR, BIPKG_UTILS.BIFNC_AdjustForTZ(activitym1.sysmodtime,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') sysmodtime , PROBSUMMARYM1.RESOLUTION, ACTIVITYM1.DESCRIPTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1' ;
		v_select_stmt := v_select_stmt || ' INNER JOIN ACTIVITYM1 ACTIVITYM1 ON PROBSUMMARYM1.NUMBERPRGN = ACTIVITYM1.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;

  
         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_INC_PROBLEMTICKETS;         
END BIPKG_INC_PROBLEMTICKETS;
/


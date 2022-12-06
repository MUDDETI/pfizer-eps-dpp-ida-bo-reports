CREATE OR REPLACE PACKAGE BIPKG_INC_TICKASSG_TEAM AS
/******************************************************************************
   NAME:       BIPKG_INC_TICKASSG_TEAM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------------
   1.0        10/10/2006    Rithesh         1. This store procedure is to pass the parameter values to report
                                              'Tickets Assignments by Team-sproc.rpt' 
******************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_TICKASSG_TEAM (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
			                 passignmentgroup          IN       VARCHAR2,
							 passignmentcodes          IN       VARCHAR2
						
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_INC_TICKASSG_TEAM;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_TICKASSG_TEAM AS
/******************************************************************************
   NAME:       BIPKG_INC_TICKASSG_TEAM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------
   1.0        10/10/2006     Rithesh        1.This store procedure is to pass the parameter values to report
                                              'Tickets Assignments by Team-sproc.rpt' 
***************************************************************************************************************/

PROCEDURE BIPKG_INC_TICKASSG_TEAM(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2,
							 passignmentcodes          IN       VARCHAR2
							 
		
		
               
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
		v_select_stmt := 'SELECT BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, probsummarym1.PROBLEM_STATUS,probsummarym1.ASSIGNEE_NAME, probsummarym1.NUMBERPRGN, probsummarym1.BRIEF_DESCRIPTION, probsummarym1.PFZ_FULL_NAME, ACTIVITYM1.TYPE, ACTIVITYM1.OPERATOR, BIPKG_UTILS.BIFNC_AdjustForTZ(ACTIVITYM1.SYSMODTIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') SYSMODTIME, probsummarym1.PRODUCT_TYPE,PROBLEMM1.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBLEMM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, PROBLEMM1.UPDATED_BY, ACTIVITYM1.NUMBERPRGN, ACTIVITYM1.THENUMBER, ACTIVITYM1.DESCRIPTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1' ;
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBLEMM1 PROBLEMM1 ON probsummarym1.NUMBERPRGN = PROBLEMM1.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' INNER JOIN ACTIVITYM1 ACTIVITYM1 ON PROBLEMM1.NUMBERPRGN = ACTIVITYM1.NUMBERPRGN AND PROBLEMM1.SYSMODTIME = ACTIVITYM1.SYSMODTIME ';
		v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('PROBLEMM1.ASSIGNMENT', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND PROBLEMM1.UPDATE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBLEMM1.UPDATE_TIME < ' || '''' || v_gmt_enddate || '''' ;
		--v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(ACTIVITYM1.TYPE,'|| '''' || ' ' || '''' ||')', passignmentcodes) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('ACTIVITYM1.TYPE', passignmentcodes) || ')';
	
		
	   		 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_INC_TICKASSG_TEAM;
END BIPKG_INC_TICKASSG_TEAM;
/


CREATE OR REPLACE PACKAGE BIPKG_INC_OHT_AA AS
/******************************************************************************
   NAME:       BIPKG_INC_OHT_AA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------------
   1.0        10/04/2006    Rithesh         1. This store procedure is to pass the parameter values to Report
                                               'Open Handled Tickets by Assignment-Assignee-sproc.rpt''
*****************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_OHT_AA (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_INC_OHT_AA;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_OHT_AA AS
/******************************************************************************
   NAME:       BIPKG_INC_OHT_AA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------------
   1.0        10/04/2006       Rithesh      1. This store procedure is to pass the parameter values to Report
                                               'Open Handled Tickets by Assignment-Assignee-sproc.rpt''
*****************************************************************************************************************/

PROCEDURE BIPKG_INC_OHT_AA(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        
      
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2, 		
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
		passignmentgroup         IN       VARCHAR2
		
		
		
               
                        ) AS
						
		 				
	      v_select_stmt        VARCHAR2(32767);
          v_flag               CHAR(1);
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
		v_select_stmt := 'SELECT  BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, PROBSUMMARYM1.PROBLEM_STATUS, PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.BRIEF_DESCRIPTION, PROBSUMMARYM1.PFZ_FULL_NAME, ACTIVITYM1.TYPE, ACTIVITYM1.OPERATOR,BIPKG_UTILS.BIFNC_AdjustForTZ(ACTIVITYM1.SYSMODTIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') SYSMODTIME, PROBSUMMARYM1.FLAG, PROBSUMMARYM1.PRODUCT_TYPE, PROBLEMM1.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBLEMM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, PROBLEMM1.ASSIGNEE_NAME, PROBLEMM1.UPDATED_BY, PROBSUMMARYM1.PROBLEM_TYPE,PROBSUMMARYM1.ASSIGNEE_NAME, ACTIVITYM1.DESCRIPTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBLEMM1 PROBLEMM1' ;
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBSUMMARYM1 PROBSUMMARYM1 ON PROBLEMM1.NUMBERPRGN = PROBSUMMARYM1.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ACTIVITYM1 ACTIVITYM1 ON PROBSUMMARYM1.NUMBERPRGN = ACTIVITYM1.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE PROBSUMMARYM1.FLAG = ' || '''' || 't' || '''' || '';     
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBLEMM1.ASSIGNMENT', passignmentgroup) || ')';
	    v_select_stmt := v_select_stmt || ' AND (ACTIVITYM1.SYSMODTIME >= ' || '''' || v_gmt_startdate || '''' || 'AND ACTIVITYM1.SYSMODTIME < ' || '''' || v_gmt_enddate || ''')' ;
			
								                             

         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_INC_OHT_AA;         
END BIPKG_INC_OHT_AA;
/


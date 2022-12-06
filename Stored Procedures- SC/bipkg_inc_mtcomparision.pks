CREATE OR REPLACE PACKAGE BIPKG_INC_MTCOMPARISION AS
/******************************************************************************
   NAME:       BIPKG_INC_MTCOMPARISION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------------
   1.0        09/06/2006      Rithesh       1. Created this package.This Store procedure is to pass values 
                                            to report ' Monthly Trending Comparison between Two Queues.rpt'
****************************************************************************************************************/


 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_MTCOMPARISION (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                         
                             passignmentgroup          IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 presolution		       IN		VARCHAR2
							
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_INC_MTCOMPARISION;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_MTCOMPARISION AS
/******************************************************************************
   NAME:       BIPKG_INC_MTCOMPARISION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------------
   1.0        09/06/2006      Rithesh       1. Created this package.This Store procedure is to pass values 
                                            to report ' Monthly Trending Comparison between Two Queues.rpt'
******************************************************************************************************************/


    PROCEDURE BIPKG_INC_MTCOMPARISION (
	                       
						   select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             passignmentgroup          IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 presolution		       IN		VARCHAR2
					
							 
							
							
							 
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   		
		v_db_zone := 'GMT';	  
       bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.RESOLUTION_CODE, PROBSUMMARYM1.PROBLEM_TYPE,PROBSUMMARYM1.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || 'AND (' ||bipkg_utils.bifnc_createinlist ('probsummarym1.resolution_code', presolution)|| ')';
		v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;
		
		
		
	OPEN select_calls_cursor FOR v_select_stmt ;
   
   END BIPKG_INC_MTCOMPARISION;

END BIPKG_INC_MTCOMPARISION;
/


CREATE OR REPLACE PACKAGE BIPKG_INC_WSLPRODUCT AS
/******************************************************************************
   NAME:       BIPKG_INC_WSLPRODUCT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------
   1.0        08/31/2006      Rithesh       1.This store procedure is to pass the parameter values to report
                                             'Weekly Service Levels By Product Type-sproc.rpt'
****************************************************************************************************************/

TYPE bisp_refcursor_type is REF CURSOR;
PROCEDURE BIPKG_INC_WSLPRODUCT  (
                         select_calls_cursor   IN OUT   bisp_refcursor_type,
                         
						     passignmentgroup          IN       VARCHAR2,
							 pfrequency                IN       VARCHAR2,
							 poverride                 IN       VARCHAR2,
							 pzone                     IN       VARCHAR2,
							 pstartdate                IN       DATE,
                             penddate                  IN       DATE
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_INC_WSLPRODUCT ;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_WSLPRODUCT AS
/******************************************************************************
   NAME:       BIPKG_INC_WSLPRODUCT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description 
   ---------  ----------  ---------------  ---------------------------------------------------------------------
   1.0        08/31/2006     Rithesh        1. This store procedure is to pass the parameter values to report
                                               'Weekly Service Levels By Product Type-sproc.rpt'
******************************************************************************************************************/
PROCEDURE BIPKG_INC_WSLPRODUCT (
	                       
						   select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
						     passignmentgroup          IN       VARCHAR2,
							 pfrequency                IN       VARCHAR2,
							 poverride                 IN       VARCHAR2,
							 pzone                     IN       VARCHAR2,
							 pstartdate                IN       DATE,
                             penddate                  IN       DATE
							 
							
							 
							
							
							
							 
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
		v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT PROBSUMMARYM1.NUMBERPRGN,  BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.PROBLEM_TYPE, PROBSUMMARYM1.PRODUCT_TYPE, PROBLEMM1.PAGE,PROBSUMMARYM1.ASSIGNMENT, PROBLEMM1.ASSIGNMENT,  BIPKG_UTILS.BIFNC_AdjustForTZ(problemm1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBLEMM1.PREV_UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ')PREV_UPDATE_TIME, PROBSUMMARYM1.COUNTPRGN, PROBSUMMARYM1.BRIEF_DESCRIPTION,BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1';
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBLEMM1 PROBLEMM1 ON PROBSUMMARYM1.NUMBERPRGN = PROBLEMM1.NUMBERPRGN ';
    	v_select_stmt := v_select_stmt || ' WHERE PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;
		--v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || ''; 
        v_select_stmt := v_select_stmt || ' AND NOT(PROBSUMMARYM1.PFZ_SLA_TITLE =  ' || '''' || 'Project' || '''' || ')';
	    v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT(PROBSUMMARYM1.PROBLEM_TYPE =  ' || '''' || 'PROJECT REQUEST' || '''' || ')';
	  
	OPEN select_calls_cursor FOR v_select_stmt ;
   
   END BIPKG_INC_WSLPRODUCT;

END BIPKG_INC_WSLPRODUCT;
/


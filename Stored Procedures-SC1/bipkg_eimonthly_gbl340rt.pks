CREATE OR REPLACE PACKAGE BIPKG_EIMONTHLY_GBL340RT AS
/******************************************************************************
   NAME:       BIPKG_EIMONTHLY_GBL340RT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------
   1.0        10/17/2006    Rithesh         1.This store procedure is to pass the parameter values to report
                                             'GBL340 Resource Time-sproc.rpt' 
***************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_EIMONTHLY_GBL340RT (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
			                 passignmentgroup          IN       VARCHAR2
						
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_EIMONTHLY_GBL340RT;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_EIMONTHLY_GBL340RT AS
/******************************************************************************
   NAME:       BIPKG_EIMONTHLY_GBL340RT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------
   1.0        10/17/2006   Rithesh          1.This store procedure is to pass the parameter values to report
                                             'GBL340 Resource Time-sproc.rpt' 
****************************************************************************************************************/

PROCEDURE BIPKG_EIMONTHLY_GBL340RT(

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
		  
		  
          
   BEGIN          
  
        
		v_db_zone := 'GMT';	  
  	    bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT PROBLEMM1.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBLEMM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, PROBLEMM1.PROBLEM_STATUS, PROBLEMM1.PROBLEM_TYPE, PROBLEMM1.TIME_SPENT, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBLEMM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, PROBLEMM1.UPDATED_BY, PROBLEMM1.NUMBERPRGN, ASSIGNMENTA1.NAME, PROBLEMM1.PRODUCT_TYPE, PROBLEMM1.BRIEF_DESCRIPTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBLEMM1 PROBLEMM1 ' ;
		v_select_stmt := v_select_stmt || ' INNER JOIN ASSIGNMENTA1 ASSIGNMENTA1 ON PROBLEMM1.ASSIGNMENT = ASSIGNMENTA1.NAME  AND PROBLEMM1.UPDATED_BY = ASSIGNMENTA1.OPERATORS ';
	   	v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('PROBLEMM1.ASSIGNMENT', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT(PROBLEMM1.UPDATED_BY =  ' || '''' || 'problem' || '''' || ')';
		v_select_stmt := v_select_stmt || ' AND PROBLEMM1.UPDATE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBLEMM1.UPDATE_TIME < ' || '''' || v_gmt_enddate || '''' ;
	   
	 
	 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_EIMONTHLY_GBL340RT;
END BIPKG_EIMONTHLY_GBL340RT;
/


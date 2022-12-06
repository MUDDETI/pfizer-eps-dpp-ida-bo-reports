CREATE OR REPLACE PACKAGE BIPKG_EIMONTHLY_300YTD AS
/******************************************************************************
   NAME:       BIPKG_EIMONTHLY_300YTD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------
   1.0        10/13/2006    Rithesh         1.This store procedure is to pass the parameter values to report
                                              '300 Monthly YTD Closed Incident Tickets-sproc.rpt'
**************************************************************************************************************/


 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_EIMONTHLY_300YTD (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
			                 passignmentgroup          IN       VARCHAR2
						
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_EIMONTHLY_300YTD;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_EIMONTHLY_300YTD AS
/******************************************************************************
   NAME:       BIPKG_EIMONTHLY_300YTD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------------
   1.0        10/13/2006    Rithesh         1.This store procedure is to pass the parameter values to report
                                              '300 Monthly YTD Closed Incident Tickets-sproc.rpt'
********************************************************************************************************************/

PROCEDURE BIPKG_EIMONTHLY_300YTD(

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
		v_select_stmt := 'SELECT PROBLEMM1.ASSIGNMENT,BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME,PROBSUMMARYM1.FLAG,PROBSUMMARYM1.PRODUCT_TYPE,PROBLEMM1.NUMBERPRGN,PROBLEMM1.UPDATED_BY,PROBSUMMARYM1.PROBLEM_TYPE,PROBSUMMARYM1.PFZ_SLA_TITLE,PROBLEMM1.PAGE,PROBLEMM1.LASTPRGN,PROBLEMM1.STATUS, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1' ;
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBLEMM1 PROBLEMM1 ON PROBSUMMARYM1.NUMBERPRGN = PROBLEMM1.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' WHERE (PROBSUMMARYM1.FLAG = ' || '''' || 'f' ||  '''' || ')';
		v_select_stmt := v_select_stmt || ' AND NOT(PROBSUMMARYM1.PFZ_SLA_TITLE =  ' || '''' || 'Project' || '''' || ')';
		v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBLEMM1.ASSIGNMENT', passignmentgroup) || ')';
	    v_select_stmt := v_select_stmt || ' AND NOT(PROBLEMM1.UPDATED_BY =  ' || '''' || 'problem' || '''' || ')';
		v_select_stmt := v_select_stmt || ' AND NOT(PROBSUMMARYM1.PROBLEM_TYPE =  ' || '''' || 'PROJECT REQUEST' || '''' || ')';
		
		
		
		 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_EIMONTHLY_300YTD;
END BIPKG_EIMONTHLY_300YTD;
/


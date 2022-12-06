CREATE OR REPLACE PACKAGE BIPKG_COMBINEDREP_TOPN AS
/******************************************************************************
   NAME:       BIPKG_COMBINEDREP_TOPN  
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------
   1.0        11/13/2006    Rithesh         1.This store procedure is to pass the parameter values to report
                                             'NEW10_Top N Callers Report-sproc.rpt' 
***************************************************************************************************************/


 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_COMBINEDREP_TOPN (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
			                 porig_group               IN       VARCHAR2
						
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_COMBINEDREP_TOPN;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_COMBINEDREP_TOPN AS
/******************************************************************************
   NAME:       BIPKG_COMBINEDREP_TOPN
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------------
   1.0        11/13/2006    Rithesh         1.This store procedure is to pass the parameter values to report
                                             'NEW10_Top N Callers Report-sproc.rpt' 
****************************************************************************************************************/

PROCEDURE BIPKG_COMBINEDREP_TOPN(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2
							
							 
		
		
               
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
		v_select_stmt := ' SELECT  BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME,INCIDENTSM1.PFZ_FULL_NAME, INCIDENTSM1.PFZ_DIVISION,INCIDENTSM1.BRIEF_DESCRIPTION, INCIDENTSM1.INCIDENT_ID, INCIDENTSM1.PRODUCT_TYPE, INCIDENTSM1.PROBLEM_TYPE, INCIDENTSM1.PFZ_ORIG_GROUP, INCIDENTSM1.PFZ_CHARGE_CODE, INCIDENTSM1.DEPT, INCIDENTSM1.LOCATION, PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.PROBLEM_STATUS, INCIDENTSM1.PFZ_RB_EMAIL, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1 ' ;
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN SCRELATIONM1 SCRELATIONM1 ON INCIDENTSM1.INCIDENT_ID = SCRELATIONM1.SOURCE ';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN PROBSUMMARYM1 PROBSUMMARYM1 ON SCRELATIONM1.DEPEND = PROBSUMMARYM1.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group)|| ')'; 
        v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || ' AND INCIDENTSM1.OPEN_TIME< ' || '''' || v_gmt_enddate || ''')';
        v_select_stmt := v_select_stmt || ' AND NOT (INCIDENTSM1.PFZ_FULL_NAME = ' || '''' || 'AT&T%' || '''' || ' OR INCIDENTSM1.PFZ_FULL_NAME = ' || '''' || 'CIT SERVICE%' || '''' || ' OR INCIDENTSM1.PFZ_FULL_NAME = ' || '''' || 'DIMENSION%' || '''' || ' OR INCIDENTSM1.PFZ_FULL_NAME = ' || '''' || 'OPERATIONS%' || '''' || ' OR INCIDENTSM1.PFZ_FULL_NAME = ' || '''' || 'PSYNCH%' || '''' || ' OR INCIDENTSM1.PFZ_FULL_NAME = ' || '''' || 'SYSTEM ATTENDANT%' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND NOT (INCIDENTSM1.PROBLEM_TYPE = ' || '''' || '%IRMAC' || '''' || ' OR INCIDENTSM1.PROBLEM_TYPE = ' || '''' || 'CUSTOMER SERVICE' || '''' || ')';

				 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_COMBINEDREP_TOPN;
END BIPKG_COMBINEDREP_TOPN;
/


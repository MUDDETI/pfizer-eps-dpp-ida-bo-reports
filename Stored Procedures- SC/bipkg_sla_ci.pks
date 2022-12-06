CREATE OR REPLACE PACKAGE BIPKG_SLA_CI AS
/******************************************************************************
   NAME:       BIPKG_SLA_CI
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------
   1.0        09/05/2006    Rithesh         1. This package is to pass the parameters to report 
                                              'Closed Incidents Over SLA Report-sproc.rpt'
**********************************************************************************************************/
TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_SLA_CI (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             PFZ_FULL_NAME             IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  



END BIPKG_SLA_CI;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_SLA_CI AS
/******************************************************************************
   NAME:       BIPKG_SLA_CI
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------------
   1.0        09/05/2006      Rithesh       1. This store procedure is to pass the parameter values to  report 
                                            'Closed incidents Over SLA Report-sproc.rpt'
***********************************************************************************************************************/

	PROCEDURE BIPKG_SLA_CI (
	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        
        PFZ_FULL_NAME           IN       VARCHAR2, 
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2, 		
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
		passignmentgroup         IN       VARCHAR2
		
		
		
               
                        ) AS
						
		 				
	      v_select_stmt        VARCHAR2(32767);
		  v_pfz_full_name      VARCHAR2(40); 
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
		v_select_stmt := 'SELECT  PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.ASSIGNEE_NAME,PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.FLAG, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.STATUS, PROBSUMMARYM1.PFZ_FULL_NAME,PROBSUMMARYM1.PFZ_RESPOND_SLA, PROBSUMMARYM1.PFZ_RESOLVE_SLA,BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1';
    	v_select_stmt := v_select_stmt || ' WHERE probsummarym1.flag = ' || '''' || 'f' || '''' || '';   
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.PFZ_FULL_NAME', PFZ_FULL_NAME) || ')';
		v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;
        
		
        
	OPEN select_calls_cursor FOR v_select_stmt ;
   
   END BIPKG_SLA_CI;

END BIPKG_SLA_CI;
/


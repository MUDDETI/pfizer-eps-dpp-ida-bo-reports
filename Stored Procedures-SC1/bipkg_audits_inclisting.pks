CREATE OR REPLACE PACKAGE BIPKG_AUDITS_INCLISTING AS
/******************************************************************************
   NAME:       BIPKG_AUDITS_INCLISTING
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------------
   1.0        11/15/2006   Rithesh          1.This store procedure is to pass the parameter values to report
                                              'IncidentListing-sproc.rpt' 
************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_AUDITS_INCLISTING (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
			                 pnumberprgn               IN       VARCHAR2
						
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_AUDITS_INCLISTING;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_AUDITS_INCLISTING AS
/******************************************************************************
   NAME:       BIPKG_AUDITS_INCLISTING
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/15/2006   Rithesh         1.This store procedure is to pass the parameter values to report
                                              'IncidentListing-sproc.rpt' 
******************************************************************************/

PROCEDURE BIPKG_AUDITS_INCLISTING(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 pnumberprgn               IN       VARCHAR2
							
							 
		
		
               
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
		v_select_stmt := ' SELECT PROBSUMMARYM1.NUMBERPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, PROBSUMMARYM1.PFZ_FULL_NAME, PROBSUMMARYM1.PRODUCT_TYPE, PROBSUMMARYM1.PROBLEM_TYPE, PROBSUMMARYM1.BRIEF_DESCRIPTION, ACTIVITYM1.TYPE, ACTIVITYM1.NEGDATESTAMP, PROBSUMMARYM1.RESOLUTION, PROBSUMMARYM1.ACTION, ACTIVITYM1.DESCRIPTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1 ' ;
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ACTIVITYM1 ACTIVITYM1 ON PROBSUMMARYM1.NUMBERPRGN = ACTIVITYM1.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.NUMBERPRGN', pnumberprgn)|| ')'; 
		 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_AUDITS_INCLISTING;
END BIPKG_AUDITS_INCLISTING;
/


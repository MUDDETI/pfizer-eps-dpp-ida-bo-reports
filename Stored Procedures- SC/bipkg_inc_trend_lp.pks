CREATE OR REPLACE PACKAGE BIPKG_INC_TREND_LP AS
/******************************************************************************
   NAME:       BIPKG_INC_TREND_LP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------
   1.0        09/08/2006     Rithesh        1. To pass parameter values to report 
                                        Daily Incident Trending by Location-Product-sproc.rpt
*****************************************************************************************************/

   TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_TREND_LP (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
							 plocation                 IN       VARCHAR2
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  



END BIPKG_INC_TREND_LP ;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_TREND_LP AS
/******************************************************************************
   NAME:       BIPKG_INC_TREND_LP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------
   1.0        09/08/2006   Rithesh          1.  1. To pass parameter values to report 
                                           Daily Incident Trending by Location-Product-sproc.rpt
*****************************************************************************************************/

  PROCEDURE BIPKG_INC_TREND_LP(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        
       
         
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
							 plocation                 IN       VARCHAR2
							 
							
		
		
		
               
                        ) AS
						
		 				
	      v_select_stmt        VARCHAR2(32767); 
          v_open_time          DATE;
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
		  v_select_stmt := 'SELECT probsummarym1.numberprgn, probsummarym1.location, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,probsummarym1.product_type, probsummarym1.open_group,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.location', plocation) || ')'; 
		v_select_stmt := v_select_stmt || ' AND probsummarym1.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.open_time < ' || '''' || v_gmt_enddate || '''' ;
		--v_select_stmt := v_select_stmt || ' AND(' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')'; 
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.open_group', porig_group) || ')';
        
		 

		 
		 OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_INC_TREND_LP;         
END BIPKG_INC_TREND_LP;
/


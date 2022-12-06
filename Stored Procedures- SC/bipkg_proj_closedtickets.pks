CREATE OR REPLACE PACKAGE BIPKG_PROJ_ClosedTickets AS
/******************************************************************************
   NAME:       BIPKG_PROJ_ClosedTickets
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------
   1.0        09/08/2006    Rithesh         1.To pass the parameter values to report 
                                            ClosedTicketsbyProjectwSummary-sproc.rpt
*************************************************************************************/
  TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_PROJ_ClosedTickets (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             
                             
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2, 		
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
		passignmentgroup         IN       VARCHAR2,
		pproject  		         IN	      VARCHAR2
							
							 
							 
							 
							 
							 
							 
                             );
  
  



END BIPKG_PROJ_ClosedTickets ;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_PROJ_ClosedTickets AS
/******************************************************************************
   NAME:       BIPKG_PROJ_ClosedTickets
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------
   1.0        09/08/2006   Rithesh          1. To pass the parameter values to report 
                                            ClosedTicketsbyProjectwSummary-sproc.rpt
*******************************************************************************************/

PROCEDURE BIPKG_PROJ_ClosedTickets(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        
       
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2, 		
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
		passignmentgroup         IN       VARCHAR2,
		pproject  		         IN	      VARCHAR2
		
		
		
               
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
		 v_select_stmt := ' SELECT probsummarym1.numberprgn, probsummarym1.assignment,BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time ,probsummarym1.brief_description, probsummarym1.pfz_full_name, probsummarym1.resolution_code, probsummarym1.open_group, probsummarym1.incident_id,probsummarym2.PFZ_RELATED_PROJECTS, probsummarym1.resolution,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' INNER JOIN probsummarym2 probsummarym2 ON probsummarym1.numberprgn = probsummarym2.numberprgn';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')'; 
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym2.PFZ_RELATED_PROJECTS', pproject) || ')'; 
		v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || '''' ;

         
		 
		 OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_PROJ_ClosedTickets;         
END BIPKG_PROJ_ClosedTickets;
/


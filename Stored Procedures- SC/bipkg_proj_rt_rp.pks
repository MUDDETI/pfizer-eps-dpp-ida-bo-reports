CREATE OR REPLACE PACKAGE BIPKG_PROJ_RT_RP AS
/******************************************************************************
   NAME:       BIPKG_PROJ_RT_RP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------------------------------------
   1.0        09/20/2006     Rithesh        1. Created this package.To pass the parameter values to report
                                              'Resolved Ticket Report by Related Project-sproc.rpt'( sub report having table INCIDENTSM1
********************************************************************************************************************************************/


 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_PROJ_RT_RP (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         pproject 		           IN		VARCHAR2
							
						
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_PROJ_RT_RP;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_PROJ_RT_RP AS
/******************************************************************************
   NAME:       BIPKG_PROJ_RT_RP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------------------------------------------
   1.0        09/20/2006    Rithesh         1. Created this package body.Created this package.To pass the parameter values to report
                                              'Resolved Ticket Report by Related Project-sproc.rpt'( sub report having table INCIDENTSM1
********************************************************************************************************************************************/

PROCEDURE BIPKG_PROJ_RT_RP(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         pproject 	               IN		VARCHAR2
							
						
							 
		
		
               
                        ) AS
						
		 				
	      v_select_stmt        VARCHAR2(32767);
          v_close_time         DATE;
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
		v_select_stmt := 'SELECT INCIDENTSM1.INCIDENT_ID, INCIDENTSM1.LOCATION, INCIDENTSM1.PFZ_ORIG_GROUP, INCIDENTSM1.PFZ_RELATED_PROJECTS, INCIDENTSM1.FIRST_CALL, INCIDENTSM1.BRIEF_DESCRIPTION, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME,BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group ) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';
		v_select_stmt := v_select_stmt || ' AND INCIDENTSM1.FIRST_CALL = ' || '''' || 't' || '''' || '';   
		v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || ''')' ; 
        
		
		
        
				 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_PROJ_RT_RP;
END BIPKG_PROJ_RT_RP;
/


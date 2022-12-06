CREATE OR REPLACE PACKAGE BIPKG_INC_SpecialFlag AS
/******************************************************************************
   NAME:       BIPKG_INC_SpecialFlag
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------
   1.0        09/15/2006     Rithesh        1. To pass the parameter values to report
                                              'Incidents by Special Flag Report-sproc.rpt'
*******************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_SpecialFlag (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 pregion 	  	 	       IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2,
							 porig_group               IN       VARCHAR2
						
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_INC_SpecialFlag;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_SpecialFlag AS
/******************************************************************************
   NAME:       BIPKG_INC_SpecialFlag
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------
   1.0        09/15/2006     Rithesh        1. To pass the parameter values to report
                                              'Incidents by Special Flag Report-sproc.rpt'
**************************************************************************************************/

PROCEDURE BIPKG_INC_SpecialFlag(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        

                             pregion 	  	 	       IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2,
							 porig_group               IN       VARCHAR2
						
							
							 
		
		
               
                        ) AS
						
		 				
	      v_select_stmt        VARCHAR2(32767);
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
		v_select_stmt := 'SELECT PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.OPEN_GROUP, PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.PROBLEM_TYPE, PROBSUMMARYM1.PFZ_BU, PROBSUMMARYM1.PFZ_RB_SPECIAL, PFZSITESM1.PFZ_REGION_ID,PROBSUMMARYM1.PFZ_SITE_ID, PROBSUMMARYM1.CLOSED_GROUP, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1' ;
		v_select_stmt := v_select_stmt || ' INNER JOIN PFZSITESM1 PFZSITESM1 ON PROBSUMMARYM1.PFZ_SITE_ID = PFZSITESM1.SITE_ID ';
        v_select_stmt := v_select_stmt || ' WHERE (' || bipkg_utils.BIFNC_createinlist ('PFZSITESM1.PFZ_REGION_ID',pregion) || ')';   
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.open_group', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.UPDATE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.UPDATE_TIME < ' || '''' || v_gmt_enddate || '''' ;
		 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_INC_SpecialFlag;
END BIPKG_INC_SpecialFlag;
/


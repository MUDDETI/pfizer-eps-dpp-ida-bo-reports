CREATE OR REPLACE PACKAGE BIPKG_INC_TA_BUSINESSHOURS AS
/******************************************************************************
   NAME:       BIPKG_INC_TA_BUSINESSHOURS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------
   1.0        09/21/2006     Rithesh        1. Created this package.O pass the parameter values to Report
                                               'Tickets Assignments with Business Hours-sproc.rpt'
************************************************************************************************************/


 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_TA_BUSINESSHOURS (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2,
							 porig_group               IN       VARCHAR2,
							 pbu				       IN	    VARCHAR2
						
							 
							
							 
							 
							 
							 
							 
							 
                             );
  

END BIPKG_INC_TA_BUSINESSHOURS;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_TA_BUSINESSHOURS AS
/******************************************************************************
   NAME:       BIPKG_INC_TA_BUSINESSHOURS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------
   1.0        09/21/2006      Rithesh       1. Created this package.O pass the parameter values to Report
                                               'Tickets Assignments with Business Hours-sproc.rpt'
************************************************************************************************************/


PROCEDURE BIPKG_INC_TA_BUSINESSHOURS(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2,
							 porig_group               IN       VARCHAR2,
							 pbu				       IN	    VARCHAR2
						
							 
		
		
               
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
		v_select_stmt := 'SELECT BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, probsummarym1.NUMBERPRGN, probsummarym1.BRIEF_DESCRIPTION, probsummarym1.PFZ_FULL_NAME, probsummarym1.PRODUCT_TYPE, PROBLEMM1.UPDATED_BY, PROBLEMM1.PFZ_SLA_TITLE, probsummarym1.PFZ_SLA_TITLE, PROBLEMM1.PROBLEM_STATUS, PROBLEMM1.LAST_ACTIVITY, PROBLEMM1.ACTOR, probsummarym1.PROBLEM_TYPE, probsummarym1.PFZ_BU, probsummarym1.PFZ_RESPOND_SLA, probsummarym1.STATUS, probsummarym1.PROBLEM_STATUS, probsummarym1.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBLEMM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, PROBLEMM1.PAGE, probsummarym1.OPEN_GROUP, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBLEMM1.PREV_UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PREV_UPDATE_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, PROBLEMM1.UPDATE_ACTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 probsummarym1' ;
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBLEMM1 PROBLEMM1 ON probsummarym1.NUMBERPRGN = PROBLEMM1.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.OPEN_GROUP', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.PFZ_BU', pbu) || ')';
		v_select_stmt := v_select_stmt || ' AND PROBLEMM1.UPDATE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBLEMM1.UPDATE_TIME < ' || '''' || v_gmt_enddate || '''' ;
   
		 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_INC_TA_BUSINESSHOURS;
END BIPKG_INC_TA_BUSINESSHOURS;
/


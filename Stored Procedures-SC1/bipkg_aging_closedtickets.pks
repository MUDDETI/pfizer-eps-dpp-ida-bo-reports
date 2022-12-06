CREATE OR REPLACE PACKAGE BIPKG_AGING_ClOSEDTICKETS AS
/******************************************************************************
   NAME:       BIPKG_AGING_ClOSEDTICKETS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------
   1.0        09/14/2006    Rithesh         1. To pass the parameter values to report
                                             Closed Ticket Aging Report Summary and Detail-sproc.rpt
*****************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_AGING_ClOSEDTICKETS (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
							
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_AGING_ClOSEDTICKETS;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_AGING_ClOSEDTICKETS AS
/******************************************************************************
   NAME:       BIPKG_AGING_ClOSEDTICKETS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------
   1.0        09/14/2006     Rithesh       1. To pass the parameter values to report
                                             Closed Ticket Aging Report Summary and Detail-sproc.rpt
******************************************************************************************************/

PROCEDURE BIPKG_AGING_ClOSEDTICKETS(

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
		  v_pfz_sla_title      VARCHAR2(40); 
		  v_flag               CHAR(1);
		  
		  
          
   BEGIN          
  
        v_db_zone := 'GMT';	  
  	    bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.FLAG,PROBSUMMARYM1.PFZ_FULL_NAME,PROBSUMMARYM1.DEADLINE, PROBSUMMARYM1.STATUS, PROBSUMMARYM1.NUMBERPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, PROBSUMMARYM1.PFZ_SLA_TITLE,BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, PROBSUMMARYM1.ASSIGNEE_NAME, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1';
        v_select_stmt := v_select_stmt || ' WHERE PROBSUMMARYM1.FLAG = ' || '''' || 'f' || '''' || '';  
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT(PROBSUMMARYM1.PFZ_SLA_TITLE =  ' || '''' || 'Project' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;

         OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_AGING_ClOSEDTICKETS;
END BIPKG_AGING_ClOSEDTICKETS;
/


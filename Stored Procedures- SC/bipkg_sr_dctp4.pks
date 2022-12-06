CREATE OR REPLACE PACKAGE BIPKG_SR_DCTP4 AS
/******************************************************************************
   NAME:       BIPKG_SR_DCTP4
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------------
   1.0        10/02/2006   Rithesh          1. This store procedure is to pass the parameter values to report
                                               'Data Center Team Performance 4 wks-sproc.rpt'
*****************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_SR_DCTP4 (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
						
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_SR_DCTP4;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_SR_DCTP4 AS
/******************************************************************************
   NAME:       BIPKG_SR_DCTP4
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------
   1.0        10/02/2006     Rithesh        1. his store procedure is to pass the parameter values to report
                                               'Data Center Team Performance 4 wks-sproc.rpt'
***************************************************************************************************************/

PROCEDURE BIPKG_SR_DCTP4(

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
		v_select_stmt := 'SELECT PROBSUMMARYM1.NUMBERPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, PROBSUMMARYM1.BRIEF_DESCRIPTION, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.ASSIGNEE_NAME, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, PROBSUMMARYM1.PFZ_RESPOND_SLA, PROBSUMMARYM1.PFZ_RESTORE_SLA,bipkg_utils.bifnc_AdjustForTZ(PROBSUMMARYM2.PFZ_RESPOND_SLA_TIME,'|| ''''|| v_db_zone || ''''|| ','|| ''''|| pzone || ''''|| ') PFZ_RESPOND_SLA_TIME, bipkg_utils.bifnc_AdjustForTZ(PROBSUMMARYM2.PFZ_RESTORE_SLA_TIME,'|| ''''|| v_db_zone || ''''|| ','|| ''''|| pzone || ''''|| ') PFZ_RESTORE_SLA_TIME, PROBSUMMARYM1.PFZ_RESOLVE_SLA, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1' ;
        v_select_stmt := v_select_stmt || ' INNER JOIN PROBSUMMARYM2 PROBSUMMARYM2 ON PROBSUMMARYM1.NUMBERPRGN = PROBSUMMARYM2.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT (PROBSUMMARYM1.PFZ_SLA_TITLE = ' || '''' || 'Project' || '''' || 'OR PROBSUMMARYM1.PFZ_SLA_TITLE = ' || '''' || 'Service Request' || ''')';
        v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;


		 
		 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_SR_DCTP4;
END BIPKG_SR_DCTP4;
/


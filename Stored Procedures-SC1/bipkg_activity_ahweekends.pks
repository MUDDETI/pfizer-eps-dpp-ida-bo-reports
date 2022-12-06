CREATE OR REPLACE PACKAGE bipkg_activity_AHWEEKENDS AS
/******************************************************************************
   NAME:       AHWEEKENDS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------
   1.0        08/28/2006      Rithesh       1. To pass the parameters to report
                                               'After Hours Weekend Activity By Group-sproc.rpt'
************************************************************************************************/
 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE bipkg_activity_AHWEEKENDS (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                          passignmentgroup    IN       VARCHAR2,
                          pfrequency          IN       VARCHAR2,
                          poverride           IN       VARCHAR2,
                          pzone               IN       VARCHAR2,
                          pstartdate          IN       DATE,
                          penddate            IN       DATE
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END bipkg_activity_AHWEEKENDS;
/
CREATE OR REPLACE PACKAGE BODY bipkg_activity_AHWEEKENDS AS
/******************************************************************************
   NAME:       bipkg_activity_AHWEEKENDS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------
   1.0        08/28/2006       Rithesh     1.To pass the parameters to report
                                             'After Hours Weekend Activity By Group-sproc.rpt'
*******************************************************************************************************/

 PROCEDURE bipkg_activity_AHWEEKENDS (
      
	 select_calls_cursor   IN OUT 	bisp_refcursor_type,
      
	  passignmentgroup    IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2(32767); 
   
   BEGIN
   		v_db_zone := 'GMT';	  
  	    bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
       v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
	   v_select_stmt := 'SELECT BIPKG_UTILS.BIFNC_AdjustForTZ(PROBLEMM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ')UPDATE_TIME,PROBLEMM1.NUMBERPRGN,PROBLEMM1.UPDATED_BY, PROBLEMM1.INCIDENT_ID, PROBLEMM1.ASSIGNMENT,PROBSUMMARYM1.PFZ_FULL_NAME, PROBLEMM1.PROBLEM_TYPE, OPERATORM1V.FULL_NAME, PROBSUMMARYM1.NUMBERPRGN, PROBLEMM1.ASSIGNEE_NAME, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
	   v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1';
	   v_select_stmt := v_select_stmt || ' INNER JOIN PROBLEMM1 PROBLEMM1 ON PROBSUMMARYM1.NUMBERPRGN = PROBLEMM1.NUMBERPRGN';
	   v_select_stmt := v_select_stmt || ' INNER JOIN OPERATORM1V OPERATORM1V ON PROBLEMM1.UPDATED_BY = OPERATORM1V.NAME';
	   v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('problemm1.assignment', passignmentgroup) || ')';
	   v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.UPDATE_TIME >= ' || '''' || v_gmt_startdate || '''' ;
      
	
         OPEN select_calls_cursor FOR v_select_stmt;
  
  END bipkg_activity_AHWEEKENDS;         
END bipkg_activity_AHWEEKENDS;
/


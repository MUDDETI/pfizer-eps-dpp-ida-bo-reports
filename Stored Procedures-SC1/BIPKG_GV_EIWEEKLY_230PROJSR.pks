CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_EIWEEKLY_230PROJSR AS
/******************************************************************************
   NAME:       BIPKG_EIWEEKLY_230PROJSR
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------
   1.0        10/17/2006     Rithesh        1.This store procedure is to pass the parameter values to report
                                             '230 Project Status Reporting-sproc.rpt' 
	2.0		   10.02.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
***************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BISP_SELECT_ASSOCIATEDTASKS (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             pticket                   IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                        
                           );
   
PROCEDURE BISP_SELECT_MASTERPROJ (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                       );
END BIPKG_Gv_EIWEEKLY_230PROJSR;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_EIWEEKLY_230PROJSR AS
/******************************************************************************
   NAME:       BIPKG_EIWEEKLY_230PROJSR
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------------
   1.0        10/17/2006    Rithesh         1.This store procedure is to pass the parameter values to report
                                             '230 Project Status Reporting-sproc.rpt' 
    2.0           10.02.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
******************************************************************************************************************/

PROCEDURE BISP_SELECT_ASSOCIATEDTASKS (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             pticket                   IN       VARCHAR2,
                              vinteraction_type        IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_currentdate        VARCHAR2 (150);
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
       v_db_zone := 'GMT';
        bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_currentdate       :=    'to_date(''' || TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (SYSDATE, 'EST', pzone),'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';        
        v_select_stmt := 'SELECT v_psm.NUMBERPRGN, SCRELATIONM1.DEPEND, SCRELATIONM1.SOURCE, v_psm.ASSIGNEE_NAME, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.PLANNED_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_START, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.PLANNED_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_END, v_psm.PFZ_TOTAL_TIME_SPENT, v_psm.PROBLEM_STATUS, v_psm.BRIEF_DESCRIPTION, v_psm.FLAG, v_psm.PFZ_EST_TIME, v_psm.PFZ_MILESTONE_PID, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_psm.category';
        v_select_stmt := v_select_stmt || ' FROM SCRELATIONM1 SCRELATIONM1 ' ;
        v_select_stmt := v_select_stmt || ' INNER JOIN SC.V_PROBSUMMARY v_psm ON SCRELATIONM1.DEPEND = v_psm.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(SCRELATIONM1.SOURCE,'|| '''' || ' ' || '''' ||')', pticket) || ')';
        v_select_stmt := v_select_stmt || ' AND (SCRELATIONM1.DEPEND like  ' || '''' || '%i' || '''' || ')'; 
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        
        
        OPEN select_calls_cursor  FOR v_select_stmt ;
   END BISP_SELECT_ASSOCIATEDTASKS;
   
   
   
PROCEDURE BISP_SELECT_MASTERPROJ(
select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
            
   )
   IS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_currentdate        VARCHAR2 (150);
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);

   BEGIN
   
   v_db_zone := 'GMT';
        bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_currentdate       :=    'to_date(''' || TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (SYSDATE, 'EST', pzone),'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';        
        v_select_stmt := 'SELECT v_psm.ASSIGNMENT, v_psm.NUMBERPRGN, v_psm.FLAG, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.PLANNED_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_END, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.PLANNED_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_START, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, v_psm.PFZ_TOTAL_TIME_SPENT, v_psm.ASSIGNEE_NAME, v_psm.PFZ_EST_TIME, v_psm.PROBLEM_STATUS, SCRELATIONM1.DEPEND, v_psm.PFZ_PROJECT, v_psm.BRIEF_DESCRIPTION, v_psm.PFZ_MILESTONE_PID, v_psm.ACTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_psm.category';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm ' ;
        v_select_stmt := v_select_stmt || ' INNER JOIN SCRELATIONM1 SCRELATIONM1 ON v_psm.NUMBERPRGN = SCRELATIONM1.SOURCE ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (SCRELATIONM1.DEPEND like  ' || '''' || '%i' || '''' || ')'; 
          v_select_stmt := v_select_stmt || ' AND  (v_psm.FLAG = ' || '''' || 't' || '''' || 'OR v_psm.CLOSE_TIME>= ' || '''' || v_gmt_startdate || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (v_psm.PFZ_PROJECT =  ' || '''' || 'Master' || '''' || ')'; 
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
                                                                                                                                           
 
    OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_MASTERPROJ;


END BIPKG_Gv_EIWEEKLY_230PROJSR;
/

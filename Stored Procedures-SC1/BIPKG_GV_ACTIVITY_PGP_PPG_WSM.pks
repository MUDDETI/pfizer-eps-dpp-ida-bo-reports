CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_ACTIVITY_PGP_PPG_WSM AS
/******************************************************************************
   NAME:       BIPKG_ACTIVITY_PGP_PPG_WSM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------------------------------------------------
   1.0        09/26/2006      Rithesh       1. This store procedure passes the parameter values to report
                                              'PGP PPG Weekly Service Meeting Report  All Open Tickets or Those Closed in Past Weekmike2-sproc.rpt'
    2.0           10.17.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
*****************************************************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_ACTIVITY_PGP_PPG_WSM (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             vinteraction_type         IN       VARCHAR2
                             );
END BIPKG_Gv_ACTIVITY_PGP_PPG_WSM;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_ACTIVITY_PGP_PPG_WSM AS
/******************************************************************************
   NAME:       BIPKG_ACTIVITY_PGP_PPG_WSM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------------------------------------------------
   1.0        09/26/2006     Rithesh        1. This stored procedure passes the parameter values to report
                                              'PGP PPG Weekly Service Meeting Report  All Open Tickets or Those Closed in Past Weekmike2-sproc.rpt'
    2.0           10.17.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
******************************************************************************************************************************************************/

PROCEDURE BIPKG_ACTIVITY_PGP_PPG_WSM(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                               vinteraction_type            IN        VARCHAR2
               
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
v_select_stmt := 'SELECT INCIDENTSM1.INCIDENT_ID,INCIDENTSM1.CLOSED_BY, INCIDENTSM1.BRIEF_DESCRIPTION, INCIDENTSM1.PRODUCT_TYPE, INCIDENTSM1.PROBLEM_TYPE, INCIDENTSM1.PFZ_RB_FULL_NAME, INCIDENTSM1.PFZ_SLA_TITLE, v_psm.NUMBERPRGN, INCIDENTSM1.FIRST_CALL, OPERATORM1V.FULL_NAME, v_psm.FLAG, OPERATORM1V_2.FULL_NAME, OPERATORM1V_1.FULL_NAME, v_psm.STATUS, INCIDENTSM1.PFZ_DIVISION, INCIDENTSM1.LOCATION,BIPKG_UTILS.BIFNC_AdjustForTZ(INCIDENTSM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, v_psm.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ(INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
v_select_stmt := v_select_stmt || ' INCIDENTSM1.CATEGORY,INCIDENTSM1.PFZ_IMPACT,INCIDENTSM1.PFZ_PRODUCT_SUBTYPE ';
v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1 ' ;
v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN SCRELATIONM1 SCRELATIONM1 ON INCIDENTSM1.INCIDENT_ID = SCRELATIONM1.SOURCE';
v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN OPERATORM1V OPERATORM1V ON INCIDENTSM1.CLOSED_BY = OPERATORM1V.NAME';
v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN SC.PROBSUMMARYM1 v_psm ON SCRELATIONM1.DEPEND = v_psm.NUMBERPRGN';
v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN OPERATORM1V OPERATORM1V_1 ON v_psm.CLOSED_BY = OPERATORM1V_1.NAME';
v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN OPERATORM1V OPERATORM1V_2 ON v_psm.ASSIGNEE_NAME = OPERATORM1V_2.NAME';
v_select_stmt := v_select_stmt || ' WHERE INCIDENTSM1.LOCATION = ' || '''' || 'NEW YORK' || '''' || ''; 
v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.PFZ_DIVISION = ' || '''' || 'PGP' || '''' || 'OR INCIDENTSM1.PFZ_DIVISION = ' || '''' || 'PPG' || ''')';    
v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'OR INCIDENTSM1.CLOSE_TIME is NULL)';
v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.PFZ_DIVISION = ' || '''' || 'PGP' || '''' || 'OR INCIDENTSM1.PFZ_DIVISION = ' || '''' || 'PPG' || ''')';    
v_select_stmt := v_select_stmt || ' AND ('||Bipkg_Utils.bifnc_createinlist ('NVL(INCIDENTSM1.CATEGORY, '' '')', vinteraction_type)|| ') ';
    
    OPEN select_calls_cursor FOR v_select_stmt;
    END BIPKG_ACTIVITY_PGP_PPG_WSM;
END BIPKG_Gv_ACTIVITY_PGP_PPG_WSM;
/

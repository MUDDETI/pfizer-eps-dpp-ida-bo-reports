CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_CI_CINC_ACTION AS
/******************************************************************************
   NAME:       BIPKG_CI_CINC_ACTION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------
   1.0        09/29/2006     Rithesh        1.This stored procedure is to pass the parameter values to Report
                                             'Call and Incident by Action-sproc.rpt'
	2.0		   10.18.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
**************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_CI_CINC_ACTION (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             pdivision                 IN       VARCHAR2,
                             porig_group               IN       VARCHAR2,
                              paction                  IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                             );

END BIPKG_Gv_CI_CINC_ACTION;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_CI_CINC_ACTION AS
/******************************************************************************
   NAME:       BIPKG_CI_CINC_ACTION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------
   1.0        09/29/2006    Rithesh         1.This stored procedure is to pass the parameter values to Report
                                             'Call and Incident by Action-sproc.rpt'
    2.0           10.18.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
****************************************************************************************************************/

PROCEDURE BIPKG_CI_CINC_ACTION(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             pdivision                 IN       VARCHAR2,
                             porig_group               IN       VARCHAR2,
                             paction                   IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                       ) AS
          v_select_stmt        VARCHAR2(32767);
          v_pfz_sla_title      VARCHAR2(40); 
          v_open_time          DATE;
          v_flag               CHAR(1);
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
        v_select_stmt := 'SELECT INCIDENTSM1.OPEN_TIME, INCIDENTSM1.PFZ_ORIG_GROUP,INCIDENTSM1.PFZ_RELATED, INCIDENTSM1.PFZ_ACTION, INCIDENTSM1.PFZ_BU, INCIDENTSM1.PFZ_DIVISION,INCIDENTSM1.INCIDENT_ID, BIPKG_UTILS.BIFNC_AdjustForTZ(INCIDENTSM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, v_psm.ASSIGNMENT, v_psm.NUMBERPRGN, v_psm.ASSIGNEE_NAME, v_psm.STATUS, INCIDENTSM1.DESCRIPTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_psm.CATEGORY';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1' ;
        v_select_stmt := v_select_stmt || ' INNER JOIN SC.V_PROBSUMMARY v_psm ON INCIDENTSM1.PFZ_RELATED = v_psm.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ACTION', paction) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group) || ')';
           v_select_stmt := v_select_stmt || ' AND INCIDENTSM1.UPDATE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.UPDATE_TIME < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.PFZ_DIVISION,'|| '''' || ' ' || '''' ||')', pdivision) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';


         OPEN select_calls_cursor FOR v_select_stmt;
    END BIPKG_CI_CINC_ACTION;
END BIPKG_Gv_CI_CINC_ACTION;
/

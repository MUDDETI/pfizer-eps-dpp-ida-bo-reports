CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_PROJ_RTP_RPD AS
/******************************************************************************
   NAME:       BIPKG_PROJ_RTP_RPD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------------------------------------------------------
   1.0        10/05/2006      Rithesh       1.To pass parameter values to report'Resolved Ticket Report by Related Project and Division-sproc.rpt''
                                              a.PROCEDURE BISP_SELECT_TR_HELPDESK for sub report1.
                                              b.PROCEDURE BISP_SELECT_INC_TICRESOLVED for sub report2.
    2.0           10.29.07        shw            1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
**************************************************************************************************************************************************************/


 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BISP_SELECT_TR_HELPDESK (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             pproject                  IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                           );
   
PROCEDURE BISP_SELECT_INC_TICRESOLVED (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             pproject                  IN       VARCHAR2,
                      		 vinteraction_type	 	   IN		VARCHAR2
					   );
END BIPKG_Gv_PROJ_RTP_RPD;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_PROJ_RTP_RPD AS
/******************************************************************************
   NAME:       BIPKG_PROJ_RTP_RPD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------------------------------------------------------
   1.0        10/05/2006    Rithesh         1.To pass parameter values to report'Resolved Ticket Report by Related Project and Division-sproc.rpt''
                                              a.PROCEDURE BISP_SELECT_TR_HELPDESK for sub report1.
                                              b.PROCEDURE BISP_SELECT_INC_TICRESOLVED for sub report2.

    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
**************************************************************************************************************************************************************/

PROCEDURE BISP_SELECT_TR_HELPDESK (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             pproject                  IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone               VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
       v_db_zone := 'GMT';
        bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT INCIDENTSM1.INCIDENT_ID, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME,BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, INCIDENTSM1.LOCATION, INCIDENTSM1.PFZ_ORIG_GROUP,INCIDENTSM1.PFZ_RELATED_PROJECTS, INCIDENTSM1.FIRST_CALL,INCIDENTSM1.BRIEF_DESCRIPTION, INCIDENTSM1.PFZ_BU, INCIDENTSM1.PFZ_DIVISION,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,INCIDENTSM1.category';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group ) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';
        v_select_stmt := v_select_stmt || ' AND INCIDENTSM1.FIRST_CALL = ' || '''' || 't' || '''' || '';   
        v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || ''')' ; 
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(INCIDENTSM1.category, '' '')', vinteraction_type)|| ')';
        
        OPEN select_calls_cursor  FOR v_select_stmt ;
   END BISP_SELECT_TR_HELPDESK;
   
   
   
PROCEDURE BISP_SELECT_INC_TICRESOLVED(
select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             pproject                  IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
   )
   IS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone               VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);

   BEGIN
   
   v_db_zone := 'GMT';
        bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.NUMBERPRGN, v_psm.LOCATION, v_psm.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, v_psm.PFZ_RELATED_PROJECTS,v_psm.PFZ_BU, v_psm.PFZ_DIVISION, v_psm.BRIEF_DESCRIPTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm' ;
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(v_psm.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';
        v_select_stmt := v_select_stmt || ' AND v_psm.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
 
 
    OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_INC_TICRESOLVED;
END BIPKG_Gv_PROJ_RTP_RPD;
/

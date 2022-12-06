CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_CI_PERSUMMREP AS
/******************************************************************************
   NAME:       BIPKG_CI_PERSUMMREP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/16/2006    Rithesh         1. Created this package.
	2.0		   10.18.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
******************************************************************************/

   TYPE bisp_refcursor_type IS REF CURSOR;
     
	

	 PROCEDURE bisp_select_incidentsrep (
     select_calls_cursor         IN OUT   bisp_refcursor_type,
      pdivision          IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      pnotgroup          IN       VARCHAR2,
      psite              IN       VARCHAR2,
      plocation          IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
    vinteraction_type    IN       VARCHAR2
                            
   );

   PROCEDURE bisp_select_incidentsrep01 (
    select_calls_cursor         IN OUT   bisp_refcursor_type,
      pdivision          IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      psite              IN       VARCHAR2,
      plocation          IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
    vinteraction_type    IN       VARCHAR2
                             
   );

   PROCEDURE bisp_select_commandrep(
     select_calls_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pnotgroup          IN       VARCHAR2,
      plocation          IN       VARCHAR2,
    vinteraction_type    IN       VARCHAR2
                             
   );
END BIPKG_Gv_CI_PERSUMMREP;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_CI_PERSUMMREP AS
/******************************************************************************
   NAME:       BIPKG_CI_PERSUMMREP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/16/2006    Rithesh         1. Created this package body.
    2.0           10.18.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
******************************************************************************/

PROCEDURE bisp_select_incidentsrep (
      select_calls_cursor         IN OUT   bisp_refcursor_type,
      pdivision          IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      pnotgroup          IN       VARCHAR2,
      psite              IN       VARCHAR2,
      plocation          IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
    vinteraction_type    IN       VARCHAR2
                             
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
       v_db_zone := 'GMT';
        bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := ' SELECT INCIDENTSM1.PFZ_DIVISION, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, INCIDENTSM1.PROBLEM_TYPE, INCIDENTSM1.PRODUCT_TYPE, INCIDENTSM1.PFZ_ORIG_GROUP, INCIDENTSM1.PFZ_CALL_SOURCE, INCIDENTSM1.OPENED_BY, INCIDENTSM1.FIRST_CALL, INCIDENTSM1.PFZ_FULL_NAME, INCIDENTSM1.RESOLUTION_CODE, INCIDENTSM1.PFZ_RB_LOCATION, INCIDENTSM1.PFZ_SITE_ID, INCIDENTSM1.PFZ_RELATED_PROJECTS, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,INCIDENTSM1.CATEGORY';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1 ' ;
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group)|| ')'; 
        v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.OPEN_TIME>= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.OPEN_TIME<' || '''' || v_gmt_enddate || ''')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_DIVISION', pdivision)|| ')'; 
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_SITE_ID', psite)|| ')'; 
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_RB_LOCATION', plocation)|| ')'; 
        v_select_stmt := v_select_stmt || ' AND NOT (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', pnotgroup)|| ')'; 
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(INCIDENTSM1.CATEGORY, '' '')', vinteraction_type)|| ')';

      OPEN select_calls_cursor  FOR v_select_stmt ;
   END bisp_select_incidentsrep ;



PROCEDURE bisp_select_incidentsrep01 (
     select_calls_cursor         IN OUT   bisp_refcursor_type,
      pdivision          IN       VARCHAR2,
      porig_group        IN       VARCHAR2,
      psite              IN       VARCHAR2,
      plocation          IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
    vinteraction_type    IN       VARCHAR2
                             
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
       v_db_zone := 'GMT';
        bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := ' SELECT INCIDENTSM1.PFZ_DIVISION, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, INCIDENTSM1.PROBLEM_TYPE, INCIDENTSM1.PRODUCT_TYPE, INCIDENTSM1.PFZ_ORIG_GROUP, INCIDENTSM1.PFZ_CALL_SOURCE, INCIDENTSM1.OPENED_BY, INCIDENTSM1.FIRST_CALL, INCIDENTSM1.PFZ_FULL_NAME, INCIDENTSM1.RESOLUTION_CODE, INCIDENTSM1.PFZ_RB_LOCATION, INCIDENTSM1.PFZ_SITE_ID, INCIDENTSM1.PFZ_RELATED_PROJECTS, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,INCIDENTSM1.CATEGORY';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1 ' ;
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group)|| ')'; 
        v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.OPEN_TIME>= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.OPEN_TIME<' || '''' || v_gmt_enddate || ''')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_DIVISION', pdivision)|| ')'; 
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_SITE_ID', psite)|| ')'; 
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_RB_LOCATION', plocation)|| ')'; 
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(INCIDENTSM1.CATEGORY, '' '')', vinteraction_type)|| ')';
        
        OPEN select_calls_cursor  FOR v_select_stmt ;
   END bisp_select_incidentsrep01 ;
   
   

PROCEDURE bisp_select_commandrep (
     select_calls_cursor  IN OUT   bisp_refcursor_type,
      passignmentgroup   IN       VARCHAR2,
      pstartdate         IN       DATE,
      penddate           IN       DATE,
      pfrequency         IN       VARCHAR2,
      poverride          IN       VARCHAR2,
      pzone              IN       VARCHAR2,
      pnotgroup          IN       VARCHAR2,
      plocation          IN       VARCHAR2,
    vinteraction_type    IN       VARCHAR2
                             
   )
   IS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);

   BEGIN
   
   v_db_zone := 'GMT';
        bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := ' SELECT psm1.NUMBERPRGN    as Ticket,psm1.PFZ_RESPOND_SLA_GROUP     as Assignment,psm2.PFZ_RESPOND_SLA_USER as Operator,om1.FULL_NAME   as Assignee, BIPKG_UTILS.BIFNC_AdjustForTZ( psm1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ( psm1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, psm1.FLAG as Flag, RESPOND as SLA_Type, BIPKG_UTILS.BIFNC_AdjustForTZ( psm2.PFZ_RESPOND_SLA_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') SLA_Time,psm1.PFZ_RESPOND_SLA as MadeMissed,psm1.LOCATION as Location,psm1.PFZ_SLA_TITLE as BusType, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,psm1.CATEGORY';
        v_select_stmt := v_select_stmt || ' FROM v_psm psm1 ' ;
        v_select_stmt := v_select_stmt || ' LEFT JOIN  PROBSUMMARYM2 psm2 ON psm1.NUMBERPRGN =psm2.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' LEFT JOIN  OPERATORM1V om1 ON psm2.PFZ_RESPOND_SLA_USER = om1.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE psm1.FLAG =' || '''' || 'f' || '''' ;
        v_select_stmt := v_select_stmt || ' AND NOT(psm1.PFZ_SLA_TITLE = ' || '''' || 'Project' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('psm1.PFZ_RESPOND_SLA_GROUP', passignmentgroup)|| ')';
        v_select_stmt := v_select_stmt || ' AND NOT (' || BIPKG_UTILS.BIFNC_createinlist ('psm1.ASSIGNMENT', pnotgroup)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('psm1.LOCATION ', plocation)|| ')';
        v_select_stmt := v_select_stmt || ' AND (psm1.CLOSE_TIME>= ' || '''' || v_gmt_startdate || '''' || 'AND psm1.CLOSE_TIME<' || '''' || v_gmt_enddate || ''')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(psm1.category, '' '')', vinteraction_type)|| ')';
        v_select_stmt := v_select_stmt || ' UNION ALL ';
        v_select_stmt := ' SELECT psm1.NUMBERPRGN as Ticket,psm1.ASSIGNMENT as Assignment,psm1.ASSIGNEE_NAME as Operator,om1.FULL_NAME as Assignee,BIPKG_UTILS.BIFNC_AdjustForTZ( psm1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ( psm1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, psm1.FLAG as Flag, '||''''||'RESOLVE'|| ''''|| ' SLA_Type,psm1.LOCATION as Location,BIPKG_UTILS.BIFNC_AdjustForTZ( psm1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') SLA_Time, psm1.PFZ_RESOLVE_SLA as MadeMissed, psm1.PFZ_SLA_TITLE as BusType, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,psm1.CATEGORY';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY psm1 ' ;
        v_select_stmt := v_select_stmt || ' LEFT JOIN OPERATORM1V om1 ON psm1.ASSIGNEE_NAME = om1.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE psm1.FLAG =' || '''' || 'f' || '''' ;
        v_select_stmt := v_select_stmt || ' AND NOT(psm1.PFZ_SLA_TITLE = ' || '''' || 'Project' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('psm1.ASSIGNMENT ', passignmentgroup)|| ')';
        v_select_stmt := v_select_stmt || ' AND NOT (' || BIPKG_UTILS.BIFNC_createinlist ('psm1.ASSIGNMENT ', pnotgroup)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('psm1.LOCATION ', plocation)|| ')';
        v_select_stmt := v_select_stmt || ' AND (psm1.CLOSE_TIME>= ' || '''' || v_gmt_startdate || '''' || 'AND psm1.CLOSE_TIME<' || '''' || v_gmt_enddate || ''')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(psm1.category, '' '')', vinteraction_type)|| ')';

              OPEN select_calls_cursor  FOR v_select_stmt;
   END bisp_select_commandrep;
                      

END BIPKG_Gv_CI_PERSUMMREP;
/

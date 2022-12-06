CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_CALLSQUE_CASUMM AS
/******************************************************************************
   NAME:       BIPKG_CALLSQUE_CASUMM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------------
   1.0        10/24/2006    Rithesh         1. This stored procedure is to pass the parameter values to report
                                               'Call Activity Summary-sproc.rpt' 
	2.0		   10.18.07        shw            1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
*********************************************************************************************************************/

 TYPE bisp_refcursor_type IS REF CURSOR;
     
    -- Store procedure for subreport call by source
    PROCEDURE BISP_SELECT_CALLBYSOURCE (
     select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             pdivision                 IN       VARCHAR2,
                             pproject                  IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                             
                            
   );
    
     --Store procedure for sub report - call by priority  
     PROCEDURE BISP_SELECT_CALLBYPRIORITY (
     select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             pdivision                 IN       VARCHAR2,
                             pproject                  IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                            
   );
   ---Store procedure for sub report-- activity by analyst 
   PROCEDURE BISP_SELECT_ACTIVITYBYANALYST (
     select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             pdivision                 IN       VARCHAR2,
                             pproject                  IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                             
   );
    ---Store procedure for sub report- call activity by country  
   PROCEDURE BISP_SELECT_CABYCOUNTRY(
     select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             pdivision                 IN       VARCHAR2,
                             pproject                  IN       VARCHAR2,
                             vinteraction_type	 	   IN		VARCHAR2
	                         
   );

END BIPKG_Gv_CALLSQUE_CASUMM;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_CALLSQUE_CASUMM AS
/******************************************************************************
   NAME:       BIPKG_CALLSQUE_CASUMM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------------
   1.0        10/24/2006    RITHESH         1.This stored procedure is to pass the parameter values to report
                                              'Call Activity Summary-sproc.rpt' 
    2.0           10.18.07        shw            1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
****************************************************************************************************************/

-- Store procedure for subreport call by source 
PROCEDURE BISP_SELECT_CALLBYSOURCE (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             pdivision                 IN       VARCHAR2,
                             pproject                  IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                             
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
        v_select_stmt := 'SELECT INCIDENTSM1.PRIORITY_CODE, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME,INCIDENTSM1.pfz_division,INCIDENTSM1.PFZ_RELATED_PROJECTS, INCIDENTSM1.FIRST_CALL, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, INCIDENTSM1.OPEN, INCIDENTSM1.PFZ_ORIG_GROUP, INCIDENTSM1.PFZ_CALL_SOURCE, INCIDENTSM1.INCIDENT_ID, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' INCIDENTSM1.CATEGORY';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1 ' ;
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group) || ')';        
        v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.OPEN_TIME < ' || '''' || v_gmt_enddate || ''')' ;
         v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.pfz_division,'|| '''' || ' ' || '''' ||')', pdivision) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.CATEGORY,'|| '''' || ' ' || '''' ||')', vinteraction_type) ||')';
 
      OPEN select_calls_cursor  FOR v_select_stmt ;
   END BISP_SELECT_CALLBYSOURCE ;



--Store procedure for sub report - call by priority  
PROCEDURE BISP_SELECT_CALLBYPRIORITY (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             pdivision                 IN       VARCHAR2,
                             pproject                  IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                             
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
        v_select_stmt := 'SELECT INCIDENTSM1.PRIORITY_CODE,INCIDENTSM1.pfz_division,INCIDENTSM1.PFZ_RELATED_PROJECTS, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, INCIDENTSM1.FIRST_CALL, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, INCIDENTSM1.OPEN, INCIDENTSM1.INCIDENT_ID, INCIDENTSM1.PFZ_ORIG_GROUP, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' INCIDENTSM1.CATEGORY';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1 ' ;
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group) || ')';        
        v_select_stmt := v_select_stmt || ' AND ((INCIDENTSM1.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.OPEN_TIME < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' OR (INCIDENTSM1.OPEN_TIME < ' || '''' || v_gmt_startdate || ''')';
        v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.OPEN <> ' || '''' || 'Closed' || '''' || '  OR INCIDENTSM1.CLOSE_TIME >= ' || '''' || v_gmt_enddate || ''')';
        v_select_stmt := v_select_stmt || ' OR (INCIDENTSM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''))' ;
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.pfz_division,'|| '''' || ' ' || '''' ||')', pdivision) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.CATEGORY,'|| '''' || ' ' || '''' ||')', vinteraction_type) ||')';
 
        OPEN select_calls_cursor  FOR v_select_stmt ;
   END BISP_SELECT_CALLBYPRIORITY ;
   
   
  ---Store procedure for sub report-- activity by analyst 
PROCEDURE BISP_SELECT_ACTIVITYBYANALYST (
select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             pdivision                 IN       VARCHAR2,
                             pproject                  IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                             
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
        v_select_stmt := 'SELECT  BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, INCIDENTSM1.FIRST_CALL, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, INCIDENTSM1.OPEN, INCIDENTSM1.INCIDENT_ID, INCIDENTSM1.PFZ_ORIG_GROUP,INCIDENTSM1.pfz_division,INCIDENTSM1.PFZ_RELATED_PROJECTS, INCIDENTSM1.OPENED_BY, OPERATORM1.FULL_NAME, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' INCIDENTSM1.CATEGORY';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1 ' ;
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN OPERATORM1V OPERATORM1 ON INCIDENTSM1.OPENED_BY = OPERATORM1.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND ((INCIDENTSM1.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.OPEN_TIME < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' OR (INCIDENTSM1.OPEN_TIME < ' || '''' || v_gmt_startdate || ''')';
        v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.OPEN <> ' || '''' || 'Closed' || '''' || '  OR INCIDENTSM1.CLOSE_TIME >= ' || '''' || v_gmt_enddate || ''')';
        v_select_stmt := v_select_stmt || ' OR (INCIDENTSM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''))' ;
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.pfz_division,'|| '''' || ' ' || '''' ||')', pdivision) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.CATEGORY,'|| '''' || ' ' || '''' ||')', vinteraction_type) ||')';

              OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_ACTIVITYBYANALYST;
                      
   
   
   ---Store procedure for sub report- call activity by country  
   PROCEDURE BISP_SELECT_CABYCOUNTRY (
select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             pdivision                 IN       VARCHAR2,
                             pproject                  IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
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
        v_select_stmt := 'SELECT INCIDENTSM1.pfz_division,INCIDENTSM1.PFZ_RELATED_PROJECTS,BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, INCIDENTSM1.FIRST_CALL, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, INCIDENTSM1.OPEN, INCIDENTSM1.INCIDENT_ID, INCIDENTSM1.PFZ_ORIG_GROUP, INCIDENTSM1.OPENED_BY, OPERATORM1.FULL_NAME, INCIDENTSM1.COUNTRY, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' INCIDENTSM1.CATEGORY';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1 ' ;
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN OPERATORM1V OPERATORM1 ON INCIDENTSM1.OPENED_BY = OPERATORM1.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND ((INCIDENTSM1.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.OPEN_TIME < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' OR (INCIDENTSM1.OPEN_TIME > ' || '''' || v_gmt_enddate || ''')';
        v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.OPEN <> ' || '''' || 'Closed' || '''' || '  OR INCIDENTSM1.CLOSE_TIME >= ' || '''' || v_gmt_enddate || ''')';
        v_select_stmt := v_select_stmt || ' OR (INCIDENTSM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''))' ;
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.pfz_division,'|| '''' || ' ' || '''' ||')', pdivision) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.CATEGORY,'|| '''' || ' ' || '''' ||')', vinteraction_type) ||')';

        OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_CABYCOUNTRY;

END BIPKG_Gv_CALLSQUE_CASUMM;
/

CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_INC_ACTIVITY_SUMMARY AS
   TYPE bisp_refcursor_type IS REF CURSOR;

/******************************************************************************
   name:       bipkg_activity_summary
   purpose:

   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0		  09/18/2006  -sgummadi-	   1. bisp_inc_activity_summary  - added procedure  
	2.0		   10.26.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
******************************************************************************/
      PROCEDURE Bisp_Inc_Activity_Summary (
      inc_activity_summary_cursor IN OUT bisp_refcursor_type,
      pgroup                    IN     VARCHAR2,
      pzone                     IN     VARCHAR2,
      pfrequency                IN     VARCHAR2,
      poverride                 IN     VARCHAR2,
      pstartdate                IN     DATE,
      penddate                  IN     DATE,
      vinteraction_type         IN     VARCHAR2
   );  
END BIPKG_Gv_INC_ACTIVITY_SUMMARY;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.Bipkg_Gv_Inc_Activity_Summary
AS

/******************************************************************************
   name:       bisp_activity_summary 
   purpose:

   revisions:
   ver        date        author          description
   ---------  ----------  ---------------  ------------------------------------
    1.0          09/18/2006     -sgummadi-        1. bisp_inc_activity_summary - added procedure
    2.0           10.26.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
******************************************************************************/
       
   PROCEDURE bisp_inc_activity_summary (
      inc_activity_summary_cursor IN OUT bisp_refcursor_type,
      pgroup                    IN     VARCHAR2,
      pzone                     IN     VARCHAR2,
      pfrequency                IN     VARCHAR2,
      poverride                 IN     VARCHAR2,
      pstartdate                IN     DATE,
      penddate                  IN     DATE,
      vinteraction_type         IN     VARCHAR2
   )
    IS
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_start_daterange    VARCHAR2 (64);
      v_end_daterange      VARCHAR2 (64);
      v_db_zone            VARCHAR2 (3);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
      v_db_zone := 'GMT';
      Bipkg_Utils.bisp_getstartandenddates (pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
      v_start_daterange   :=   'to_date(''' || TO_CHAR(v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';
      v_end_daterange    :=   'to_date(''' || TO_CHAR(v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';

      v_select_stmt := v_select_stmt
                                           || ' SELECT'
                                           || ' ALL_STATS.STAT_TYPE'
                                           || ' , ALL_STATS.QGROUP'
                                           || ' , ALL_STATS.ACTIVITY'
                                           || ' , ALL_STATS.OPENED'
                                           || ' , ALL_STATS.CLOSED'
                                           || ' , ALL_STATS.HANDLED'
                                           || ' , ALL_STATS.CLOSEDPASTSLA'
                                           || ' , ALL_STATS.PREVOPEN'
                                           || ' , ALL_STATS.PASTOPEN'
                                           || ' , ALL_STATS.SLA_TITLE'
                                           || ' , ALL_STATS.STATUS'
                                           || ' , BIPKG_UTILS.BIFNC_ADJUSTFORTZ (ALL_STATS.OPEN_TIME,''' || V_DB_ZONE || ''', ''' || PZONE || ''') OPEN_TIME'
                                           || ' , TO_DATE(''' || TO_CHAR (Bipkg_Utils.BIFNC_ADJUSTFORTZ (V_GMT_STARTDATE,V_DB_ZONE,PZONE), 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'') AS STARTDATEDISPLAY'
                                           || ' , TO_DATE(''' || TO_CHAR (Bipkg_Utils.BIFNC_ADJUSTFORTZ (V_GMT_ENDDATE,V_DB_ZONE,PZONE), 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'') AS ENDDATEDISPLAY'
                                           || ' , BIPKG_UTILS.BIFNC_ADJUSTFORTZ (SYSDATE, ''EST'' , ''' || PZONE || ''') SYS_TIME'                                   
                                           || ' FROM'
                                           || ' ('
                                           || ' ('
                                           || ' SELECT'
                                           || ' ''TimeFrame'' AS STAT_TYPE'
                                           || ' , PM.QGROUP'
                                           || ' , COUNT(PM.NUMBERPRGN) AS ACTIVITY'
                                           || ' , SUM(PM.OPENED) AS OPENED'
                                           || ' , SUM(PM.CLOSED) AS CLOSED'
                                           || ' , SUM(PM.HANDLED) AS HANDLED'
                                           || ' , SUM(PM.CLOSEDPASTSLA) AS CLOSEDPASTSLA'
                                           || ' , 0 AS PREVOPEN'
                                           || ' , 0 AS PASTOPEN'
                                           || ' , ''NA'' AS SLA_TITLE'
                                           || ' , ''NA'' AS STATUS'
                                           || ' , NULL AS OPEN_TIME'
                                           || ' FROM'
                                           || ' ('
                                           || '   SELECT'
                                           || '      CASE  v_pb.PAGE WHEN 1 THEN v_pb.OPEN_GROUP ELSE v_pb.ASSIGNMENT END AS QGROUP'
                                           || '      , v_pb.NUMBERPRGN'
                                           || '      , MAX(CASE WHEN v_pb.PAGE = 1 AND v_pb.OPEN_TIME BETWEEN ' || V_START_DATERANGE || ' AND ' || V_END_DATERANGE || ' THEN 1 ELSE 0 END) AS OPENED'
                                           || '      , MAX(CASE WHEN v_pb.FLAG = ''f'' AND v_pb.CLOSE_TIME BETWEEN ' || V_START_DATERANGE || ' AND ' || V_END_DATERANGE || ' THEN 1 ELSE 0 END) AS CLOSED'
                                           || '      , MAX(CASE WHEN v_pb.PAGE <> 1 AND v_pb.FLAG = ''t'' THEN 1 ELSE 0 END) AS HANDLED'
                                           || '      , MAX(CASE WHEN v_pb.FLAG = ''f'' AND v_pb.PFZ_RESOLVE_SLA = ''MISSED'' THEN 1 ELSE 0 END) AS CLOSEDPASTSLA'
                                           || '   FROM'
                                           || '      SC.V_PROBLEMS v_pb'
                                           || '   WHERE'
                                           || '      ('
                                           || '         (v_pb.PAGE = 1 AND (' || Bipkg_Utils.BIFNC_CREATEINLIST ('v_pb.OPEN_GROUP', PGROUP) || '))'
                                           || '         OR'
                                           || '         (v_pb.PAGE <> 1 AND (' || Bipkg_Utils.BIFNC_CREATEINLIST ('v_pb.ASSIGNMENT', PGROUP) || '))'
                                           || '      )'
                                           || '      AND v_pb.UPDATE_TIME BETWEEN ' || V_START_DATERANGE || ' AND ' || V_END_DATERANGE
                                           || '      AND v_pb.UPDATED_BY <> ''problem'' '
                                           || '   AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_pb.category, '' '')', vinteraction_type)|| ')'
                                           || '   GROUP BY'
                                           || '      CASE  v_pb.PAGE WHEN 1 THEN v_pb.OPEN_GROUP ELSE v_pb.ASSIGNMENT END'
                                           || '      , v_pb.NUMBERPRGN'
                                           || '   ) PM'
                                           || ' GROUP BY'
                                           || '   PM.QGROUP'
                                           || ' )'
                                           || ' UNION ALL'
                                           || ' ('
                                           || ' SELECT'
                                           || '   ''BeyondTimeFrame'' AS STAT_TYPE'
                                           || '   , v_psm.ASSIGNMENT AS QGROUP'
                                           || '   , 0 AS ACTIVITY'
                                           || '   , 0 AS OPENED'
                                           || '   , 0 AS CLOSED'
                                           || '   , 0 AS HANDLED'
                                           || '   , 0 AS CLOSEDPASTSLA'
                                           || '   , SUM(CASE WHEN v_psm.OPEN_TIME < ' || V_START_DATERANGE || ' THEN 1 ELSE 0 END) AS PREVOPEN'
                                           || '   , SUM(CASE WHEN v_psm.FLAG = ''t'' OR v_psm.CLOSE_TIME > ' || V_END_DATERANGE || ' THEN 1 ELSE 0 END) AS PASTOPEN'
                                           || '   , ''NA'' AS SLA_TITLE'
                                           || '   , ''NA'' AS STATUS'
                                           || '   , NULL AS OPEN_TIME'
                                           || ' FROM'
                                           || '   SC.V_PROBSUMMARY v_psm'
                                           || ' WHERE'
                                           || '   (' || Bipkg_Utils.BIFNC_CREATEINLIST ('v_psm.ASSIGNMENT', PGROUP) || ')' 
                                           || '   AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')'
                                           || '   AND v_psm.OPEN_TIME <= ' || V_END_DATERANGE
                                           || '   AND'
                                           || '   ('
                                           || '      v_psm.FLAG = ''t'''
                                           || '      OR'
                                           || '      v_psm.CLOSE_TIME >= ' || V_START_DATERANGE
                                           || '   )'
                                           || ' GROUP BY'
                                           || '   v_psm.ASSIGNMENT'
                                           || ' )'
                                           || ' UNION ALL'
                                           || ' ('
                                           || ' SELECT'
                                           || '   ''CurrentlyOpen'' AS STAT_TYPE'
                                           || '   , v_psm.ASSIGNMENT AS QGROUP'
                                           || '   , 0 AS ACTIVITY'
                                           || '   , 0 AS OPENED'
                                           || '   , 0 AS CLOSED'
                                           || '   , 0 AS HANDLED'
                                           || '   , 0 AS CLOSEDPASTSLA'
                                           || '   , 0 AS PREVOPEN'
                                           || '   , 0 AS PASTOPEN'
                                           || '   , v_psm.PRIORITY AS SLA_TITLE'
--                                           || '   , v_psm.PFZ_SLA_TITLE AS SLA_TITLE'
                                           || '   , v_psm.STATUS'
                                           || '   , v_psm.OPEN_TIME'
                                           || ' FROM'
                                           || '   SC.V_PROBSUMMARY v_psm'
                                           || ' WHERE'
                                           || '   (' || Bipkg_Utils.BIFNC_CREATEINLIST ('v_psm.ASSIGNMENT', PGROUP) || ')'
                                           || '   AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')'
                                           || '   AND v_psm.FLAG = ''t'' '
                                           || '   AND v_psm.PRIORITY <> ''PROJECT'' '
--                                           || '   AND v_psm.PFZ_SLA_TITLE <> ''Project'' '
                                           || ' )'
                                           || ' ) ALL_STATS'
                                           ;                                                              
                                     OPEN inc_activity_summary_cursor FOR v_select_stmt;

   END bisp_inc_activity_summary;
      
END Bipkg_Gv_Inc_Activity_Summary;
/

CREATE OR REPLACE PACKAGE Bipkg_Inc_Activity_Summary 
AS
   TYPE bisp_refcursor_type IS REF CURSOR;

/******************************************************************************
   name:       bipkg_activity_summary
   purpose:

   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0		  09/18/2006  -sgummadi-	   1. bisp_inc_activity_summary  - added procedure  
******************************************************************************/
      PROCEDURE Bisp_Inc_Activity_Summary (
      inc_activity_summary_cursor IN OUT bisp_refcursor_type,
	  pgroup				  IN 	 VARCHAR2,
	  pzone					  IN	 VARCHAR2,
	  pfrequency			  IN	 VARCHAR2,
	  poverride				  IN	 VARCHAR2,
	  pstartdate			  IN	 DATE,
      penddate				  IN	 DATE
   );  
   
END Bipkg_Inc_Activity_Summary;
/
CREATE OR REPLACE PACKAGE BODY Bipkg_Inc_Activity_Summary
AS

/******************************************************************************
   name:       bisp_activity_summary 
   purpose:

   revisions:
   ver        date        author          description
   ---------  ----------  ---------------  ------------------------------------
	1.0		  09/18/2006 	-sgummadi-		1. bisp_inc_activity_summary - added procedure
******************************************************************************/
       
   PROCEDURE bisp_inc_activity_summary (
      inc_activity_summary_cursor IN OUT bisp_refcursor_type,
	  pgroup				  IN 	 VARCHAR2,
	  pzone					  IN	 VARCHAR2,
	  pfrequency			  IN	 VARCHAR2,
	  poverride				  IN	 VARCHAR2,
	  pstartdate			  IN	 DATE,
      penddate				  IN	 DATE
   )
    IS
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_start_daterange		   VARCHAR2 (64);
	  v_end_daterange		   VARCHAR2 (64);
      v_db_zone            VARCHAR2 (3);
      v_select_stmt	   VARCHAR2 (32767);
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
										   || '      CASE  PROBLEMM1.PAGE WHEN 1 THEN PROBLEMM1.OPEN_GROUP ELSE PROBLEMM1.ASSIGNMENT END AS QGROUP'
										   || '      , PROBLEMM1.NUMBERPRGN'
										   || '      , MAX(CASE WHEN PROBLEMM1.PAGE = 1 AND PROBLEMM1.OPEN_TIME BETWEEN ' || V_START_DATERANGE || ' AND ' || V_END_DATERANGE || ' THEN 1 ELSE 0 END) AS OPENED'
										   || '      , MAX(CASE WHEN PROBLEMM1.FLAG = ''f'' AND PROBLEMM1.CLOSE_TIME BETWEEN ' || V_START_DATERANGE || ' AND ' || V_END_DATERANGE || ' THEN 1 ELSE 0 END) AS CLOSED'
										   || '      , MAX(CASE WHEN PROBLEMM1.PAGE <> 1 AND PROBLEMM1.FLAG = ''t'' THEN 1 ELSE 0 END) AS HANDLED'
										   || '      , MAX(CASE WHEN PROBLEMM1.FLAG = ''f'' AND PROBLEMM2.PFZ_RESOLVE_SLA = ''MISSED'' THEN 1 ELSE 0 END) AS CLOSEDPASTSLA'
										   || '   FROM'
										   || '      PROBLEMM1'
										   || '      , PROBLEMM2'
										   || '   WHERE'
										   || '      PROBLEMM1.NUMBERPRGN = PROBLEMM2.NUMBERPRGN'
										   || '      AND PROBLEMM1.PAGE = PROBLEMM2.PAGE'
										   || '      AND'
										   || '      ('
										   || '         (PROBLEMM1.PAGE = 1 AND (' || Bipkg_Utils.BIFNC_CREATEINLIST ('PROBLEMM1.OPEN_GROUP', PGROUP) || '))'
										   || '         OR'
										   || '         (PROBLEMM1.PAGE <> 1 AND (' || Bipkg_Utils.BIFNC_CREATEINLIST ('PROBLEMM1.ASSIGNMENT', PGROUP) || '))'
										   || '      )'
										   || '      AND PROBLEMM1.UPDATE_TIME BETWEEN ' || V_START_DATERANGE || ' AND ' || V_END_DATERANGE
										   || '      AND PROBLEMM1.UPDATED_BY <> ''problem'' '
										   || '   GROUP BY'
										   || '      CASE  PROBLEMM1.PAGE WHEN 1 THEN PROBLEMM1.OPEN_GROUP ELSE PROBLEMM1.ASSIGNMENT END'
										   || '      , PROBLEMM1.NUMBERPRGN'
										   || '   ) PM'
										   || ' GROUP BY'
										   || '   PM.QGROUP'
										   || ' )'
										   || ' UNION ALL'
										   || ' ('
										   || ' SELECT'
										   || '   ''BeyondTimeFrame'' AS STAT_TYPE'
										   || '   , PROBSUMMARYM1.ASSIGNMENT AS QGROUP'
										   || '   , 0 AS ACTIVITY'
										   || '   , 0 AS OPENED'
										   || '   , 0 AS CLOSED'
										   || '   , 0 AS HANDLED'
										   || '   , 0 AS CLOSEDPASTSLA'
										   || '   , SUM(CASE WHEN PROBSUMMARYM1.OPEN_TIME < ' || V_START_DATERANGE || ' THEN 1 ELSE 0 END) AS PREVOPEN'
										   || '   , SUM(CASE WHEN PROBSUMMARYM1.FLAG = ''t'' OR PROBSUMMARYM1.CLOSE_TIME > ' || V_END_DATERANGE || ' THEN 1 ELSE 0 END) AS PASTOPEN'
										   || '   , ''NA'' AS SLA_TITLE'
										   || '   , ''NA'' AS STATUS'
										   || '   , NULL AS OPEN_TIME'
										   || ' FROM'
										   || '   PROBSUMMARYM1'
										   || ' WHERE'
										   || '   (' || Bipkg_Utils.BIFNC_CREATEINLIST ('PROBSUMMARYM1.ASSIGNMENT', PGROUP) || ')' 
										   || '   AND PROBSUMMARYM1.OPEN_TIME <= ' || V_END_DATERANGE
										   || '   AND'
										   || '   ('
										   || '      PROBSUMMARYM1.FLAG = ''t'''
										   || '      OR'
										   || '      PROBSUMMARYM1.CLOSE_TIME >= ' || V_START_DATERANGE
										   || '   )'
										   || ' GROUP BY'
										   || '   PROBSUMMARYM1.ASSIGNMENT'
										   || ' )'
										   || ' UNION ALL'
										   || ' ('
										   || ' SELECT'
										   || '   ''CurrentlyOpen'' AS STAT_TYPE'
										   || '   , PROBSUMMARYM1.ASSIGNMENT AS QGROUP'
										   || '   , 0 AS ACTIVITY'
										   || '   , 0 AS OPENED'
										   || '   , 0 AS CLOSED'
										   || '   , 0 AS HANDLED'
										   || '   , 0 AS CLOSEDPASTSLA'
										   || '   , 0 AS PREVOPEN'
										   || '   , 0 AS PASTOPEN'
										   || '   , PROBSUMMARYM1.PFZ_SLA_TITLE AS SLA_TITLE'
										   || '   , PROBSUMMARYM1.STATUS'
										   || '   , PROBSUMMARYM1.OPEN_TIME'
										   || ' FROM'
										   || '   PROBSUMMARYM1'
										   || ' WHERE'
										   || '   (' || Bipkg_Utils.BIFNC_CREATEINLIST ('PROBSUMMARYM1.ASSIGNMENT', PGROUP) || ')'
										   || '   AND PROBSUMMARYM1.FLAG = ''t'' '
										   || '   AND PROBSUMMARYM1.PFZ_SLA_TITLE <> ''Project'' '
										   || ' )'
										   || ' ) ALL_STATS'
										   ;								 							 
									 OPEN inc_activity_summary_cursor FOR v_select_stmt;

   END bisp_inc_activity_summary;
      
END Bipkg_Inc_Activity_Summary;
/


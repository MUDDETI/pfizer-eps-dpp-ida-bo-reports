CREATE OR REPLACE PACKAGE BIPKG_PROJ_RTP_RPD AS
/******************************************************************************
   NAME:       BIPKG_PROJ_RTP_RPD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------------------------------------------------------
   1.0        10/05/2006      Rithesh       1.To pass parameter values to report'Resolved Ticket Report by Related Project and Division-sproc.rpt''
                                              a.PROCEDURE BISP_SELECT_TR_HELPDESK for sub report1.
											  b.PROCEDURE BISP_SELECT_INC_TICRESOLVED for sub report2.
**************************************************************************************************************************************************************/


 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BISP_SELECT_TR_HELPDESK (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         pproject 		           IN		VARCHAR2
						
						   );
   
PROCEDURE BISP_SELECT_INC_TICRESOLVED (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2,
							 pproject                  IN       VARCHAR2
					   );
END BIPKG_PROJ_RTP_RPD;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_PROJ_RTP_RPD AS
/******************************************************************************
   NAME:       BIPKG_PROJ_RTP_RPD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------------------------------------------------------
   1.0        10/05/2006    Rithesh         1.To pass parameter values to report'Resolved Ticket Report by Related Project and Division-sproc.rpt''
                                              a.PROCEDURE BISP_SELECT_TR_HELPDESK for sub report1.
											  b.PROCEDURE BISP_SELECT_INC_TICRESOLVED for sub report2.

**************************************************************************************************************************************************************/

PROCEDURE BISP_SELECT_TR_HELPDESK (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         pproject 		           IN		VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   	v_db_zone := 'GMT';
		bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT INCIDENTSM1.INCIDENT_ID, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME,BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, INCIDENTSM1.LOCATION, INCIDENTSM1.PFZ_ORIG_GROUP,INCIDENTSM1.PFZ_RELATED_PROJECTS, INCIDENTSM1.FIRST_CALL,INCIDENTSM1.BRIEF_DESCRIPTION, INCIDENTSM1.PFZ_BU, INCIDENTSM1.PFZ_DIVISION,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group ) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(INCIDENTSM1.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';
        v_select_stmt := v_select_stmt || ' AND INCIDENTSM1.FIRST_CALL = ' || '''' || 't' || '''' || '';   
        v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || ''')' ; 
        
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
							 pproject                  IN       VARCHAR2
   )
   IS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);

   BEGIN
   
   v_db_zone := 'GMT';
		bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.LOCATION, PROBSUMMARYM1.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, PROBSUMMARYM2.PFZ_RELATED_PROJECTS,PROBSUMMARYM1.PFZ_BU, PROBSUMMARYM1.PFZ_DIVISION, PROBSUMMARYM1.BRIEF_DESCRIPTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1' ;
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBSUMMARYM2 PROBSUMMARYM2 ON PROBSUMMARYM1.NUMBERPRGN = PROBSUMMARYM2.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(PROBSUMMARYM2.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';
		v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;
 
 
    OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_INC_TICRESOLVED;


END BIPKG_PROJ_RTP_RPD;
/


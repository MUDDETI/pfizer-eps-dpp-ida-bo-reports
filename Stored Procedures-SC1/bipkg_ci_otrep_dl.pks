CREATE OR REPLACE PACKAGE BIPKG_CI_OTREP_DL AS
/******************************************************************************
   NAME:       BIPKG_CI_OTREP_DL
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------------------------------------------------------------------------
   1.0        10/05/2006      Rithesh       1.This store procedure is to pass the parameter values to report 'Opened Ticket Report by Division and Location-sproc.rpt'.
                                             a.PROCEDURE BISP_SELECT_CALLSOPEN is to pass parameter values to subreport-Calls opened by division.
											 b.PROCEDURE BISP_SELECT_INCIDENTSOPEN is to pass parameter values to subreport-Incidents opened by divison.
****************************************************************************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BISP_SELECT_CALLSOPEN (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 pdept				       IN	    VARCHAR2,
	                         pbu				       IN	    VARCHAR2
							
						
						   );
   
PROCEDURE BISP_SELECT_INCIDENTSOPEN (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 pdept				       IN	    VARCHAR2,
	                         pbu				       IN	    VARCHAR2
					   );
END BIPKG_CI_OTREP_DL ;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_CI_OTREP_DL  AS
/******************************************************************************
   NAME:       BIPKG_CI_OTREP_DL 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------------------------------------------------------------------------------
   1.0        10/05/2006      Rithesh      1.This store procedure is to pass the parameter values to report 'Opened Ticket Report by Division and Location-sproc.rpt'.
                                             a.PROCEDURE BISP_SELECT_CALLSOPEN is to pass parameter values to subreport-Calls opened by division.
											 b.PROCEDURE BISP_SELECT_INCIDENTSOPEN is to pass parameter values to subreport-Incidents opened by divison.
*******************************************************************************************************************************************************************************/
PROCEDURE BISP_SELECT_CALLSOPEN (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                            
							 pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 pdept				       IN	    VARCHAR2,
	                         pbu				       IN	    VARCHAR2
							
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
		v_select_stmt := 'SELECT INCIDENTSM1.INCIDENT_ID, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME,BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, INCIDENTSM1.PFZ_BU, INCIDENTSM1.PFZ_DIVISION, INCIDENTSM1.PRODUCT_TYPE, INCIDENTSM1.BRIEF_DESCRIPTION, INCIDENTSM1.FIRST_CALL, INCIDENTSM1.PFZ_FULL_NAME, INCIDENTSM1.DEPT, INCIDENTSM1.PFZ_ORIG_GROUP, INCIDENTSM1.OPEN, INCIDENTSM1.RESOLUTION,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1';
        v_select_stmt := v_select_stmt || ' WHERE (INCIDENTSM1.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.OPEN_TIME < ' || '''' || v_gmt_enddate || ''')' ; 
        v_select_stmt := v_select_stmt || ' AND INCIDENTSM1.FIRST_CALL = ' || '''' || 't' || '''' || ''; 
	    v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.DEPT', pdept) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_BU', pbu) || ')';
		
        
		OPEN select_calls_cursor  FOR v_select_stmt ;
   END BISP_SELECT_CALLSOPEN;
   
   
   
PROCEDURE BISP_SELECT_INCIDENTSOPEN(
select_calls_cursor   IN OUT   bisp_refcursor_type,
                             
							 pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 pdept				       IN	    VARCHAR2,
	                         pbu				       IN	    VARCHAR2
							
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
        v_select_stmt := 'SELECT PROBSUMMARYM1.PFZ_FULL_NAME, PROBSUMMARYM1.PFZ_DIVISION, PROBSUMMARYM1.PFZ_BU, PROBSUMMARYM1.PRODUCT_TYPE, PROBSUMMARYM1.BRIEF_DESCRIPTION, SCRELATIONM1.DEPEND, PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.DEPT, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.STATUS,PROBSUMMARYM1.FLAG, PROBSUMMARYM1.RESOLUTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1' ;
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN SCRELATIONM1 SCRELATIONM1 ON PROBSUMMARYM1.NUMBERPRGN = SCRELATIONM1.SOURCE ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.DEPT', pdept) || ')';
		v_select_stmt := v_select_stmt || ' AND (PROBSUMMARYM1.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.OPEN_TIME < ' || '''' || v_gmt_enddate || ''')' ; 
		v_select_stmt := v_select_stmt || ' AND NOT (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.PFZ_BU', pbu) || ')';
		
 
    OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_INCIDENTSOPEN;


END BIPKG_CI_OTREP_DL;
/


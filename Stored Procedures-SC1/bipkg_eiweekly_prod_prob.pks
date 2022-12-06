CREATE OR REPLACE PACKAGE BIPKG_EIWEEKLY_PROD_PROB AS
/******************************************************************************
   NAME:       BIPKG_EIWEEKLY_PROD_PROB
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------
   1.0        10/19/2006    Rithesh         1.This store procedure is to pass the parameter values to report
                                              'Product Type _ Problem Type Detail Report-sproc.rpt' 
**************************************************************************************************************/

  TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BISP_SELECT_SYMPTOMDETAIL (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         pproduct 		           IN		VARCHAR2
						
						   );
   
PROCEDURE BISP_SELECT_SYMPTOMDETAIL01 (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
							 pproduct                  IN       VARCHAR2
					   );
END BIPKG_EIWEEKLY_PROD_PROB;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_EIWEEKLY_PROD_PROB AS
/******************************************************************************
   NAME:       BIPKG_EIWEEKLY_PROD_PROB
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------
   1.0        10/19/2006   Rithesh         1.This store procedure is to pass the parameter values to report
                                             'Product Type _ Problem Type Detail Report-sproc.rpt' 
**************************************************************************************************************/

PROCEDURE BISP_SELECT_SYMPTOMDETAIL (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         pproduct 		           IN		VARCHAR2
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
		v_select_stmt := 'SELECT INCIDENTSM1.INCIDENT_ID, INCIDENTSM1.PFZ_FULL_NAME, INCIDENTSM1.PFZ_ORIG_GROUP, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, INCIDENTSM1.PRODUCT_TYPE, INCIDENTSM1.PFZ_RB_FULL_NAME, INCIDENTSM1.PROBLEM_TYPE, INCIDENTSM1.BRIEF_DESCRIPTION, INCIDENTSM1.PFZ_SLA_TITLE, INCIDENTSM1.FIRST_CALL, INCIDENTSM1.DESCRIPTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1 ' ;
		v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PRODUCT_TYPE', pproduct) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (INCIDENTSM1.PROBLEM_TYPE =  ' || '''' || 'PROJECT REQUEST' || '''' || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (INCIDENTSM1.PFZ_SLA_TITLE =  ' || '''' || 'Project' || '''' || ')';
		v_select_stmt := v_select_stmt || ' AND INCIDENTSM1.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.OPEN_TIME < ' || '''' || v_gmt_enddate || '''' ;
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.FIRST_CALL =  ' || '''' || 't' || '''' || ')';
		
		
		OPEN select_calls_cursor  FOR v_select_stmt ;
   END BISP_SELECT_SYMPTOMDETAIL;
   
   
   
PROCEDURE BISP_SELECT_SYMPTOMDETAIL01(
select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         pproduct 		           IN		VARCHAR2
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
        v_select_stmt := 'SELECT PROBSUMMARYM1.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, PROBSUMMARYM1.PROBLEM_TYPE, PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.PFZ_FULL_NAME, PROBSUMMARYM1.PRODUCT_TYPE, PROBSUMMARYM1.PFZ_RB_FULL_NAME, PROBSUMMARYM1.BRIEF_DESCRIPTION, PROBSUMMARYM1.OPEN_GROUP, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.ACTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1 ' ;
		v_select_stmt := v_select_stmt || ' WHERE NOT (PROBSUMMARYM1.PROBLEM_TYPE =  ' || '''' || 'PROJECT REQUEST' || '''' || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.PRODUCT_TYPE', pproduct) || ')';
		v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.OPEN_TIME < ' || '''' || v_gmt_enddate || '''' ;
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.OPEN_GROUP', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (PROBSUMMARYM1.PFZ_SLA_TITLE =  ' || '''' || 'Project' || '''' || ')';
		
 
    OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_SYMPTOMDETAIL01;


END BIPKG_EIWEEKLY_PROD_PROB;
/


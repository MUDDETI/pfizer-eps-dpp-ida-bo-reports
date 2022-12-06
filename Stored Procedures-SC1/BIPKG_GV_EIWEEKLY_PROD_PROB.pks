CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_EIWEEKLY_PROD_PROB AS
/******************************************************************************
   NAME:       BIPKG_EIWEEKLY_PROD_PROB
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------
   1.0        10/19/2006    Rithesh         1.This store procedure is to pass the parameter values to report
                                              'Product Type _ Problem Type Detail Report-sproc.rpt' 
	2.0		   10.02.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
**************************************************************************************************************/

  TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BISP_SELECT_SYMPTOMDETAIL (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             pproduct                  IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                        
                           );
   
PROCEDURE BISP_SELECT_SYMPTOMDETAIL01 (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             pproduct                  IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                       );
END BIPKG_Gv_EIWEEKLY_PROD_PROB;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_EIWEEKLY_PROD_PROB AS
/******************************************************************************
   NAME:       BIPKG_EIWEEKLY_PROD_PROB
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------
   1.0        10/19/2006   Rithesh         1.This store procedure is to pass the parameter values to report
                                             'Product Type _ Problem Type Detail Report-sproc.rpt' 
    2.0           10.02.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
**************************************************************************************************************/

PROCEDURE BISP_SELECT_SYMPTOMDETAIL (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             pproduct                  IN       VARCHAR2,
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
        v_select_stmt := 'SELECT INCIDENTSM1.INCIDENT_ID, INCIDENTSM1.PFZ_FULL_NAME, INCIDENTSM1.PFZ_ORIG_GROUP, BIPKG_UTILS.BIFNC_AdjustForTZ( INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, INCIDENTSM1.PRODUCT_TYPE, INCIDENTSM1.PFZ_RB_FULL_NAME, INCIDENTSM1.PROBLEM_TYPE, INCIDENTSM1.BRIEF_DESCRIPTION, INCIDENTSM1.PFZ_SLA_TITLE, INCIDENTSM1.FIRST_CALL, INCIDENTSM1.DESCRIPTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,INCIDENTSM1.category';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1 ' ;
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PRODUCT_TYPE', pproduct) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT (INCIDENTSM1.PROBLEM_TYPE =  ' || '''' || 'PROJECT REQUEST' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND NOT (INCIDENTSM1.PFZ_SLA_TITLE =  ' || '''' || 'Project' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND INCIDENTSM1.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.OPEN_TIME < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (INCIDENTSM1.FIRST_CALL =  ' || '''' || 't' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(INCIDENTSM1.category, '' '')', vinteraction_type)|| ')';
        
        
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
                             pproduct                  IN       VARCHAR2,
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
        v_select_stmt := 'SELECT v_psm.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ( v_psm.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, v_psm.PROBLEM_TYPE, v_psm.NUMBERPRGN, v_psm.PFZ_FULL_NAME, v_psm.PRODUCT_TYPE, v_psm.PFZ_RB_FULL_NAME, v_psm.BRIEF_DESCRIPTION, v_psm.OPEN_GROUP, v_psm.PFZ_SLA_TITLE, v_psm.ACTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
		v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm ' ;
        v_select_stmt := v_select_stmt || ' WHERE NOT (v_psm.PROBLEM_TYPE =  ' || '''' || 'PROJECT REQUEST' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.PRODUCT_TYPE', pproduct) || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.OPEN_TIME < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.OPEN_GROUP', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT (v_psm.PFZ_SLA_TITLE =  ' || '''' || 'Project' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        
 
    OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_SYMPTOMDETAIL01;


END BIPKG_Gv_EIWEEKLY_PROD_PROB;
/

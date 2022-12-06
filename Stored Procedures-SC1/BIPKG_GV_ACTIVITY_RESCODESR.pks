CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_ACTIVITY_RESCODESR AS
/******************************************************************************
   NAME:       BIPKG_ACTIVITY_RESCODESR
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------------
   1.0        10/23/2006    Rithesh         1.This store procedure is to pass the parameter values to report 
                                             'Resolution Code Statistics Report-sproc.rpt'   
	2.0		   10.17.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
******************************************************************************************************************/
 TYPE bisp_refcursor_type IS REF CURSOR;
     
    -- Stored procedure for main report
    PROCEDURE BISP_SELECT_RESCODER01 (
     select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             prescode                    IN        VARCHAR2,
                             passignmentgroup          IN       VARCHAR2,
                             ppriority                 IN       VARCHAR2,
                               vinteraction_type            IN        VARCHAR2
                            
   );
    
     --Stored procedure for Non-Compliant-Sub rpt 
     PROCEDURE BISP_SELECT_RESCODENC (
     select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             prescode                    IN        VARCHAR2,
                             passignmentgroup          IN       VARCHAR2,
                             crescode                    IN        VARCHAR2,
                             ppriority                 IN       VARCHAR2,
                               vinteraction_type            IN        VARCHAR2
   );
   ---Stored procedure for Vendor-Sub rpt 
   PROCEDURE BISP_SELECT_RESCODEV (
     select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             prescode                    IN        VARCHAR2,
                             passignmentgroup          IN       VARCHAR2,
                             ppriority                 IN       VARCHAR2,
                               vinteraction_type            IN        VARCHAR2
   );
   ---Stored procedure for SBC-Sub rpt 
   PROCEDURE BISP_SELECT_RESCODESBC(
     select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             prescode                    IN        VARCHAR2,
                             passignmentgroup          IN       VARCHAR2,
                             ppriority                 IN       VARCHAR2,
                               vinteraction_type            IN        VARCHAR2
   );
END BIPKG_Gv_ACTIVITY_RESCODESR;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.Bipkg_Gv_Activity_Rescodesr AS
/******************************************************************************
   NAME:       BIPKG_ACTIVITY_RESCODESR
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------
   1.0        10/23/2006   Rithesh        1.This stored procedure is to pass the parameter values to report 
                                           'Resolution Code Statistics Report-sproc.rpt'   
    2.0           10.17.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
***********************************************************************************************************/
-- Stored procedure for main report
PROCEDURE BISP_SELECT_RESCODER01 (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             prescode                    IN        VARCHAR2,
                             passignmentgroup          IN       VARCHAR2,
                             ppriority                 IN       VARCHAR2,
                               vinteraction_type            IN        VARCHAR2
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
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.ASSIGNMENT, v_psm.RESOLUTION_CODE, v_psm.NUMBERPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ( v_psm.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ( v_psm.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, v_psm.PFZ_TOTAL_TIME_SPENT, v_psm.PFZ_SLA_TITLE, v_psm.ASSIGNEE_NAME, ASSIGNMENTM1.PFZ_REPORTING_GROUP, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.CATEGORY,v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm ' ;
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ASSIGNMENTM1 ASSIGNMENTM1 ON v_psm.ASSIGNMENT = ASSIGNMENTM1.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('ASSIGNMENTM1.PFZ_REPORTING_GROUP', porig_group) || ')';        
        v_select_stmt := v_select_stmt || ' AND (v_psm.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.CLOSE_TIME < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.ASSIGNMENT', passignmentgroup) || ')';
-- 2.0 shw         v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.PFZ_SLA_TITLE', ppriority) || ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', ppriority)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.RESOLUTION_CODE', prescode) || ')';    
      OPEN select_calls_cursor  FOR v_select_stmt ;
   END BISP_SELECT_RESCODER01 ;



--Stored procedure for Non-Compliant-Sub rpt 
PROCEDURE BISP_SELECT_RESCODENC (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             prescode                    IN        VARCHAR2,
                             passignmentgroup          IN       VARCHAR2,
                             crescode                    IN        VARCHAR2,
                             ppriority                 IN       VARCHAR2,
                               vinteraction_type            IN        VARCHAR2
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
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.ASSIGNMENT,v_psm.PRIORITY_CODE, v_psm.RESOLUTION_CODE, v_psm.NUMBERPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ( v_psm.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ( v_psm.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, v_psm.PFZ_TOTAL_TIME_SPENT, v_psm.PFZ_SLA_TITLE, v_psm.ASSIGNEE_NAME, ASSIGNMENTM1.PFZ_REPORTING_GROUP, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.CATEGORY,v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm ' ;
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ASSIGNMENTM1 ASSIGNMENTM1 ON v_psm.ASSIGNMENT = ASSIGNMENTM1.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('ASSIGNMENTM1.PFZ_REPORTING_GROUP', porig_group) || ')';        
        v_select_stmt := v_select_stmt || ' AND (v_psm.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.CLOSE_TIME < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.ASSIGNMENT', passignmentgroup) || ')';
-- 2.0 shw         v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.PFZ_SLA_TITLE', ppriority) || ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', ppriority)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.RESOLUTION_CODE', prescode) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.RESOLUTION_CODE', crescode) || ')';
 
        OPEN select_calls_cursor  FOR v_select_stmt ;
   END BISP_SELECT_RESCODENC ;
   
   
  ---Stored procedure for Vendor-Sub rpt  
PROCEDURE BISP_SELECT_RESCODEV(
select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             prescode                    IN        VARCHAR2,
                             passignmentgroup          IN       VARCHAR2,
                             ppriority                 IN       VARCHAR2,
                               vinteraction_type            IN        VARCHAR2
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
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.ASSIGNMENT,v_psm.PRIORITY_CODE, BIPKG_UTILS.BIFNC_AdjustForTZ( v_psm.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, v_psm.RESOLUTION_CODE, v_psm.NUMBERPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ( v_psm.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, v_psm.PFZ_TOTAL_TIME_SPENT, v_psm.PFZ_SLA_TITLE, v_psm.VENDOR, v_psm.OPEN_GROUP,  ASSIGNMENTM1.PFZ_REPORTING_GROUP, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.CATEGORY,v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm ' ;
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ASSIGNMENTM1 ASSIGNMENTM1 ON v_psm.ASSIGNMENT = ASSIGNMENTM1.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('ASSIGNMENTM1.PFZ_REPORTING_GROUP', porig_group) || ')';        
        v_select_stmt := v_select_stmt || ' AND (v_psm.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.CLOSE_TIME < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.ASSIGNMENT', passignmentgroup) || ')';
-- 2.0 shw         v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.PFZ_SLA_TITLE', ppriority) || ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', ppriority)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.RESOLUTION_CODE', prescode) || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.VENDOR IS  NOT  NULL';
        v_select_stmt := v_select_stmt || ' AND NOT ((v_psm.ASSIGNMENT =  ' || '''' || 'MET-CIT-SBC' || '''' || ')';
        v_select_stmt := v_select_stmt || ' OR (v_psm.ASSIGNMENT =  ' || '''' || 'MET-WTI-SBC' || '''' || '))';
      OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_RESCODEV;
                      
   
   
   ---Stored procedure for SBC-Sub rpt 
   PROCEDURE BISP_SELECT_RESCODESBC(
select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             prescode                    IN        VARCHAR2,
                             passignmentgroup          IN       VARCHAR2,
                             ppriority                 IN       VARCHAR2,
                               vinteraction_type            IN        VARCHAR2
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
        Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay := TO_CHAR(Bipkg_Utils.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.ASSIGNMENT,v_psm.PRIORITY_CODE, BIPKG_UTILS.BIFNC_AdjustForTZ( v_psm.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, v_psm.RESOLUTION_CODE, v_psm.NUMBERPRGN, v_psm.OPEN_TIME, v_psm.PFZ_TOTAL_TIME_SPENT, v_psm.PFZ_SLA_TITLE, v_psm.VENDOR, v_psm.OPEN_GROUP, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.CATEGORY,v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm ' ;
        v_select_stmt := v_select_stmt || ' WHERE (v_psm.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.CLOSE_TIME < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.ASSIGNMENT', passignmentgroup) || ')';
-- 2.0 shw         v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.PFZ_SLA_TITLE', ppriority) || ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', ppriority)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' ||Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        v_select_stmt := v_select_stmt || ' AND NOT (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.RESOLUTION_CODE', prescode) || ')';    
        v_select_stmt := v_select_stmt || ' AND ((v_psm.ASSIGNMENT =  ' || '''' || 'MET-CIT-SBC' || '''' || ')';
        v_select_stmt := v_select_stmt || ' OR (v_psm.ASSIGNMENT =  ' || '''' || 'MET-WTI-SBC' || '''' || '))';
        OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_RESCODESBC;

END Bipkg_Gv_Activity_Rescodesr;
/

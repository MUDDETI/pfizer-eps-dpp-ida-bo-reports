CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_AGING_OT_GT5 AS
/******************************************************************************
   NAME:       BIPKG_AGING_OT_GT5
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------
   1.0        09/19/2006    Rithesh         1. To pass the parameter values to Report
                                             'OpenTickets GT 5 days old-sproc.rpt'
	2.0		   10.18.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
****************************************************************************************/
   TYPE bisp_refcursor_type IS REF CURSOR;

   PROCEDURE bipkg_aging_ot_gt5 (
      select_calls_cursor   IN OUT   bisp_refcursor_type,
      pfrequency            IN       VARCHAR2,
      poverride             IN       VARCHAR2,
      pzone                 IN       VARCHAR2,
      pstartdate            IN       DATE,
      penddate              IN       DATE,
      passignmentgroup      IN       VARCHAR2,
      porig_group           IN       VARCHAR2,
      psite                 IN       VARCHAR2,
      vpriority             IN       VARCHAR2,
      vinteraction_type     IN       VARCHAR2
   );
END BIPKG_Gv_AGING_OT_GT5;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_AGING_OT_GT5 AS
/******************************************************************************
   NAME:       BIPKG_AGING_OT_GT5
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------
   1.0        09/19/2006    Rithesh         1. To pass the parameter values to Report
                                             'OpenTickets GT 5 days old-sproc.rpt'
    2.0           10.18.07        shw            1. Upgrade for GAMPS, remove hard-coded priority 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
***************************************************************************************/

PROCEDURE BIPKG_AGING_OT_GT5(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
        
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             porig_group               IN       VARCHAR2,
                             psite                     IN       VARCHAR2,
                             vpriority                 IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                        ) AS
                        
          v_select_stmt        VARCHAR2(32767);
          v_pfz_sla_title      VARCHAR2(40); 
          v_close_time         DATE;
          v_startdatedisplay   VARCHAR2(50);
          v_enddatedisplay     VARCHAR2(50);
          v_db_zone            VARCHAR2(10);      
          v_gmt_startdate      DATE;
          v_gmt_enddate        DATE;
  BEGIN          
  

v_db_zone := 'GMT';      
          bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.SITE_CATEGORY,v_psm.NUMBERPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ( v_psm.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, v_psm.PFZ_FULL_NAME, v_psm.ASSIGNMENT, v_psm.PROBLEM_STATUS,v_psm.PRODUCT_TYPE, v_psm.PFZ_SLA_TITLE, v_psm.FLAG, v_psm.BRIEF_DESCRIPTION, v_psm.REPAIR_TIME, v_psm.ASSIGNEE_NAME, v_psm.OPEN_GROUP, v_psm.COUNTPRGN, v_psm.PFZ_SITE_ID,BIPKG_UTILS.BIFNC_AdjustForTZ( v_psm.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, LOCATIONM1.COUNTRY,v_psm.GROUPPRGN,v_psm.LOCATION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,v_psm.user_priority,';        
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE ';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN LOCATIONM1 LOCATIONM1 ON v_psm.LOCATION = LOCATIONM1.LOCATION';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist (' v_psm.PFZ_SITE_ID',psite) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.OPEN_GROUP', porig_group) || ')';
-- 10.18.07-shw-         v_select_stmt := v_select_stmt || ' AND  (v_psm.PFZ_SLA_TITLE = ' || '''' || 'Business Critical' || '''' || '  OR v_psm.PFZ_SLA_TITLE = ' || '''' || 'High Priority' || '''' || '  OR v_psm.PFZ_SLA_TITLE = ' || '''' || 'Service Request' || '''' || '  OR v_psm.PFZ_SLA_TITLE = ' || '''' || 'Standard Priority' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (v_psm.FLAG = ' || '''' || 't' ||  '''' || ')'; 
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
  --      v_select_stmt := v_select_stmt || ' AND (v_psm.UPDATE_TIME >= ' || '''' ||   v_gmt_startdate ||  '''' || ')' ;
  
  OPEN select_calls_cursor FOR v_select_stmt;
  
  END BIPKG_AGING_OT_GT5;         
END BIPKG_Gv_AGING_OT_GT5;
/

CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_INC_PROJ AS
/******************************************************************************
   NAME:       bipkg_inc_proj
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------
   1.0        08/16/2006   Rithesh Makkena     1.This stored procedure are to pass the 
                                              parameters to the Project Incident Deatils Report
	2.0		   10.26.07		shw			1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
************************************************************************************************/

-- Public type declarations

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE bipkg_inc_proj (select_calls_cursor   IN OUT   bisp_refcursor_type,
                             
                             vpriority                 IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             vinteraction_type         IN		VARCHAR2
                             );
END BIPKG_Gv_INC_PROJ;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.bipkg_Gv_inc_proj 
AS
/******************************************************************************
   NAME:       bipkg_inc_proj
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------
   1.0        08/16/2006   Rithesh Makkena     1. 1.This store procedure are to pass the 
                                              parameters to the Project Incident Deatils Report
    2.0           10.26.07        shw            1. Upgrade for GAMPS  
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
**************************************************************************************************/

---Procedure Implementation 
PROCEDURE bipkg_inc_proj(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
        
        vpriority                IN       VARCHAR2,
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2,         
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
        passignmentgroup         IN       VARCHAR2,
        vinteraction_type        IN       VARCHAR2
                        ) AS
                         
          v_select_stmt        VARCHAR2(32767);
          v_pfz_sla_title      VARCHAR2(40); 
          v_open_time          DATE;
          v_flag               CHAR(1);
          v_startdatedisplay   VARCHAR2(50);
          v_enddatedisplay     VARCHAR2(50);
          v_db_zone            VARCHAR2(10);      
          v_gmt_startdate      DATE;
          v_gmt_enddate        DATE;
          v_currentdate        VARCHAR(50);
        
  BEGIN          

v_db_zone := 'GMT';      
          bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt :=  'SELECT v_psm.ASSIGNMENT,v_psm.BRIEF_DESCRIPTION,v_psm.ASSIGNEE_NAME,v_psm.LAST_ACTIVITY,v_psm.ACTION,v_psm.PFZ_SLA_TITLE,v_psm.STATUS,v_psm.FLAG,v_psm.NUMBERPRGN,v_psm.PFZ_FULL_NAME,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
--        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.PFZ_SLA_TITLE', PFZ_SLA_TITLE) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.flag = ' || '''' || 't' || '''' || '';                           
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';

         OPEN select_calls_cursor FOR v_select_stmt;
  END bipkg_inc_proj;         
END bipkg_Gv_inc_proj;
/

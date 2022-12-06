CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_AGING_CT24 AS
/******************************************************************************
   NAME:       BIPKG_AGING_CT24
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------
   1.0        09/12/2006     Rithesh        1.To pass the parameter values to report
                                             'Closed Tickets within 24 Hours-sproc.rpt"
	2.0		   10.18.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
********************************************************************************************/

  
TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_AGING_CT24 (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                      
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                               vinteraction_type            IN        VARCHAR2,
                             vpriority                 IN       VARCHAR2

                             );
END BIPKG_Gv_AGING_CT24;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_AGING_CT24 AS
/******************************************************************************
   NAME:       BIPKG_AGING_CT24
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------
   1.0        09/12/2006    Rithesh         1. To pass the parameter values to report
                                             'Closed Tickets within 24 Hours-sproc.rpt"
    2.0           10.18.07        shw            1. Upgrade for GAMPS, remove hard-coded priority  
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
********************************************************************************************/
PROCEDURE BIPKG_AGING_CT24(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
        
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2,         
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
        passignmentgroup         IN       VARCHAR2,
        vinteraction_type        IN       VARCHAR2,
        vpriority                IN       VARCHAR2
               
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
         v_select_stmt := ' SELECT v_psm.ASSIGNMENT, v_psm.FLAG, v_psm.NUMBERPRGN,v_psm.DEADLINE, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.PFZ_SLA_TITLE,v_psm.PFZ_FULL_NAME,v_psm.RESOLUTION_CODE, v_psm.ASSIGNEE_NAME,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,';        
        v_select_stmt := v_select_stmt || ' v_psm.PRIORITY';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')'; 
-- 10.18.07-shw-         v_select_stmt := v_select_stmt || ' AND NOT(v_psm.PFZ_SLA_TITLE =  ' || '''' || 'Project' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''' ;                      
        v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ')';
                                                             

         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_AGING_CT24;         
END BIPKG_Gv_AGING_CT24;
/

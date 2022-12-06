CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_INC_HOTTICKET AS
/******************************************************************************
   NAME:       bipkg_inc_proj
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------
   1.0        08/16/2006   Rithesh Makkena     1.This store procedure are to pass the 
                                              parameters to Hot Ticket Detail Report-sproc.rpt
	2.0		   10.26.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
************************************************************************************************/

-- Public type declarations

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE bipkg_inc_hotticket (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2

                                 );

END BIPKG_Gv_INC_HOTTICKET;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.bipkg_Gv_inc_hotticket 
AS
/******************************************************************************
   NAME:       bipkg_inc_proj
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------
   1.0        08/16/2006   Rithesh Makkena     1. 1.This store procedure is to pass the 
                                              parameters to theHot Ticket Detail Report-sproc.rpt
    2.0           10.26.07        shw            1. Upgrade for GAMPS  
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
**************************************************************************************************/

---Procedure Implementation 
PROCEDURE bipkg_inc_hotticket(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2,         
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
        passignmentgroup         IN       VARCHAR2,
        vinteraction_type        IN       VARCHAR2
                        ) AS
                        
                         
          v_select_stmt        VARCHAR2(32767);
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
        v_db_zone := 'GMT';
        bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt :=  'SELECT v_psm.PROBLEM_STATUS, v_psm.ASSIGNMENT, v_psm.NUMBERPRGN, v_psm.BRIEF_DESCRIPTION, ACTIVITYM1.TYPE, ACTIVITYM1.SYSMODTIME, v_psm.FLAG, v_psm.LOCATION, v_psm.HOT_TIC, v_psm.PFZ_SLA_TITLE, ACTIVITYM1.DESCRIPTION,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.update_action, '|| '''' || v_currentdate || '''' || ' EndDateDisplay,';
		v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED';
        v_select_stmt := v_select_stmt || ' FROM   SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ACTIVITYM1 ACTIVITYM1 ON v_psm.NUMBERPRGN = ACTIVITYM1.NUMBERPRGN';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.flag = ' || '''' || 't' || '''' || ''; 
        v_select_stmt := v_select_stmt || ' AND v_psm.HOT_TIC =  ' || '''' || 't' || '''' || '';                          
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
                                                             

         OPEN select_calls_cursor FOR v_select_stmt;
  END bipkg_inc_hotticket;         
END bipkg_Gv_inc_hotticket;
/

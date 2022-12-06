CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_AGING_SUMM AS
/******************************************************************************
   NAME:       BIPKG_AGING_SUMM
   PURPOSE:  

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------------
   1.0        09/06/2006     Rithesh        1.This stored procedure is to pass the parameter returned values to
                                              report ' Open Tickets Summary by Assignment-Assignee.rpt''
	2.0		   10.18.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
******************************************************************************************************************/
TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_AGING_SUMM  (select_calls_cursor   IN OUT   bisp_refcursor_type,
                                                       
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                             
                             );
END BIPKG_Gv_AGING_SUMM;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_AGING_SUMM AS
/******************************************************************************
   NAME:       BIPKG_AGING_SUMM
   PURPOSE: 

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------
   1.0        09/06/2006    Rithesh         1. This stored procedure is to pass the parameter returned values to 
                                              report ' Open Tickets Summary by Assignment-Assignee.rpt''
    2.0           10.18.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
****************************************************************************************************************/

PROCEDURE BIPKG_AGING_SUMM(

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
        bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,v_psm.PROBLEM_STATUS, v_psm.ASSIGNMENT,v_psm.NUMBERPRGN, v_psm.ASSIGNEE_NAME,v_psm.BRIEF_DESCRIPTION,v_psm.PFZ_FULL_NAME, v_psm.FLAG, v_psm.PFZ_SLA_TITLE, v_psm.USER_PRIORITY, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.STATUS, v_psm.ALERT_STATUS,v_psm.LAST_ACTIVITY, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category,';        
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE v_psm.flag = ' || '''' || 't' || '''' || '';  
        v_select_stmt := v_select_stmt || ' AND(' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')'; 
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
                   

         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_AGING_SUMM;         
END BIPKG_Gv_AGING_SUMM;
/

CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_INC_RESPOND_SLA AS
/******************************************************************************
   NAME:       BIPKG_INC_RESPOND_SLA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------------------
   1.0        09/07/2006       Rithesh      1. CTo pass parmater values to report Respond SLA by Analyst-sproc.rpt
	2.0		   10.29.07		shw			1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
*********************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_RESPOND_SLA (select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             vpriority                 IN       VARCHAR2,
                             vinteraction_type	 	   IN		VARCHAR2
                            );
END BIPKG_Gv_INC_RESPOND_SLA;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_INC_RESPOND_SLA AS
/******************************************************************************
   NAME:       BIPKG_INC_RESPOND_SLA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------------------
   1.0        09/07/2006     Rithesh        1. To pass parmater values to report Respond SLA by Analyst-sproc.rpt
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
*********************************************************************************************************************/

  PROCEDURE BIPKG_INC_RESPOND_SLA(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
        
       
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2,         
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
        passignmentgroup         IN       VARCHAR2,
        vpriority                IN       VARCHAR2,
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
        v_select_stmt := 'SELECT v_psm.PFZ_RESPOND_SLA_GROUP, v_psm.PFZ_SLA_TITLE, v_psm.NUMBERPRGN, v_psm.PFZ_RESPOND_SLA_TIME, v_psm.PFZ_FULL_NAME, v_psm.PROBLEM_TYPE, v_psm.PRODUCT_TYPE, v_psm.BRIEF_DESCRIPTION,v_psm.PFZ_RESPOND_SLA_USER,v_psm.PFZ_RESPOND_SLA,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE v_psm.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.close_time < ' || '''' || v_gmt_enddate || '''' ;  
        v_select_stmt := v_select_stmt || ' AND(' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.PFZ_RESPOND_SLA_GROUP', passignmentgroup) || ')'; 
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ')';
--        v_select_stmt := v_select_stmt || ' AND v_psm.PFZ_SLA_TITLE <> ' || '''' || 'Project' || '''' || '';     
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';

         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_INC_RESPOND_SLA;         
END BIPKG_Gv_INC_RESPOND_SLA;
/

CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_INC_TREND_LP AS
/******************************************************************************
   NAME:       BIPKG_INC_TREND_LP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------
   1.0        09/08/2006     Rithesh        1. To pass parameter values to report 
                                        Daily Incident Trending by Location-Product-sproc.rpt
	2.0		   10.29.07		shw			1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
*****************************************************************************************************/

   TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_TREND_LP (select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             plocation                 IN       VARCHAR2,
                             vinteraction_type     	   IN		VARCHAR2
                             );

END BIPKG_Gv_INC_TREND_LP;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_INC_TREND_LP AS
/******************************************************************************
   NAME:       BIPKG_INC_TREND_LP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------
   1.0        09/08/2006   Rithesh          1.  1. To pass parameter values to report 
                                           Daily Incident Trending by Location-Product-sproc.rpt
    2.0           10.29.07        shw            1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
*****************************************************************************************************/

  PROCEDURE BIPKG_INC_TREND_LP(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             porig_group               IN       VARCHAR2,
                             plocation                 IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                        ) AS
                        
                         
          v_select_stmt        VARCHAR2(32767); 
          v_open_time          DATE;
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
          v_select_stmt := 'SELECT v_psm.numberprgn, v_psm.location, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,v_psm.product_type, v_psm.open_group,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_psm.category';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.location', plocation) || ')'; 
        v_select_stmt := v_select_stmt || ' AND v_psm.open_time >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.open_time < ' || '''' || v_gmt_enddate || '''' ;
        --v_select_stmt := v_select_stmt || ' AND(' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')'; 
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.open_group', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        
         

         
         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_INC_TREND_LP;         
END BIPKG_Gv_INC_TREND_LP;
/

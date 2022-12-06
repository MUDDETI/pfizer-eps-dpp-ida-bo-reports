CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_INC_INCIDENTGRAPH AS
/******************************************************************************
   NAME:       BIPKG_INC_INCIDENTGRAPH
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------
   1.0        09/13/2006    Rithesh        1. This store procedure is to pass parameter values to report
                                               Open Incidents by AssignmentHourProduct type (Graph)-sproc.rpt
	2.0		   10.26.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
*****************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_INCIDENTGRAPH (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             pproduct                  IN       VARCHAR2,
                             pproductsubtype           IN       VARCHAR2, 
                             vinteraction_type         IN       VARCHAR2
                             );
END BIPKG_Gv_INC_INCIDENTGRAPH; 
/

CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_INC_INCIDENTGRAPH AS
/******************************************************************************
   NAME:       BIPKG_INC_INCIDENTGRAPH
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------
   1.0        09/13/2006     Rithesh        1. This store procedure is to pass parameter values to report
                                               Open Incidents by AssignmentHourProduct type (Graph)-sproc.rpt
    2.0           10.26.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
    2.3         01.17.08     shw           Update for Gamp
***************************************************************************************************************/

PROCEDURE BIPKG_INC_INCIDENTGRAPH(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             pproduct                  IN       VARCHAR2,
                             pproductsubtype          IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                        ) AS
                        
                         
          v_select_stmt        VARCHAR2(32767);
          v_open_time          DATE;
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
        v_select_stmt := 'SELECT  v_psm.NUMBERPRGN,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, v_psm.ASSIGNMENT, v_psm.PRODUCT_TYPE,  ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_psm.category,v_psm.PFZ_PRODUCT_SUBTYPE';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.PRODUCT_TYPE', pproduct) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.PFZ_PRODUCT_SUBTYPE', pproductsubtype) || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.OPEN_TIME < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        

         OPEN select_calls_cursor FOR v_select_stmt;
    END BIPKG_INC_INCIDENTGRAPH;
END BIPKG_Gv_INC_INCIDENTGRAPH; 
/


CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_INC_PRODUCT AS
/******************************************************************************
   NAME:       BIPKG_INC_Product
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------
   1.0        08/30/2006   Rithesh Makkena   1. This Stored procedure is to pass parameter values to 
                                             report Monthly Baseline By Product Type-sproc.rpt
	2.0		   10.26.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
********************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_Product ( select_calls_cursor   IN OUT   bisp_refcursor_type,
                              
                             passignmentgroup          IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             vinteraction_type     	   IN		VARCHAR2
                            );
END BIPKG_Gv_INC_PRODUCT;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_INC_Product AS
/******************************************************************************
   NAME:       BIPKG_INC_Product
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------------
   1.0        08/30/2006     Rithesh Makkena   1. 1. This Stored procedure is to pass parameter values to 
                                             report Monthly Baseline By Product Type-sproc.rpt
    2.0           10.26.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
********************************************************************************************************************/
 
    PROCEDURE BIPKG_INC_Product (
                           
                           select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                             passignmentgroup          IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
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
        v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.NUMBERPRGN, v_psm.ASSIGNMENT, v_psm.PRODUCT_TYPE, v_psm.PROBLEM_TYPE, v_psm.PFZ_TOTAL_TIME_SPENT,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_psm.category';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE v_psm.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.OPEN_TIME < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT(v_psm.PROBLEM_TYPE =  ' || '''' || 'PROJECT REQUEST' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      
    OPEN select_calls_cursor FOR v_select_stmt ;
   
   END BIPKG_INC_Product;

END BIPKG_Gv_INC_Product;
/

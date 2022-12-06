CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_INC_TICK_AGING AS
   TYPE bisp_refcursor_type IS REF CURSOR;
/******************************************************************************
   NAME:       BIPKG_INC_TICK_AGING
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------------
   1.0        09/05/2006    Rithesh          1. Created this package. This stored procedure is to pass parameters to 
                                             report 'Ticket Aging Report-sproc.rpt'
    2.0           10.29.07        shw            1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
*********************************************************************************************************************/
   PROCEDURE BIPKG_INC_TICK_AGING (
      select_inc_aging_cursor   IN OUT   bisp_refcursor_type,
      porig_group         IN       VARCHAR2,
      pproduct            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
	  vinteraction_type	  IN	   VARCHAR2
   );
END BIPKG_Gv_INC_TICK_AGING;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_INC_TICK_AGING AS
/******************************************************************************
   NAME:       BIPKG_INC_TICK_AGING
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------------------
   1.0        09/05/2006    Rithesh         1. Created this package body. This stored procedure is to pass parameters to 
                                            report'Ticket Aging Report.rpt' 
    2.0           10.29.07        shw            1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
**************************************************************************************************************************/

    PROCEDURE BIPKG_INC_TICK_AGING (
      select_inc_aging_cursor   IN OUT   bisp_refcursor_type,
      porig_group         IN       VARCHAR2,
      pproduct            IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdatem1    DATE;
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone            VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
          
          
          
          BEGIN
           v_db_zone := 'GMT';      
          bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT v_psm.NUMBERPRGN, v_psm.PROBLEM_TYPE,v_psm.LOCATION, v_psm.PRODUCT_TYPE, v_psm.OPEN_GROUP, v_psm.FLAG, v_psm.OPEN_TIME, v_psm.ASSIGNMENT,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_psm.category';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm'; 
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.product_type', pproduct) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.open_group', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.flag = ' || '''' || 't' || '''' || '';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        
             
    OPEN select_inc_aging_cursor FOR v_select_stmt ;
   
   END BIPKG_INC_TICK_AGING;

END BIPKG_Gv_INC_TICK_AGING;
/

CREATE OR REPLACE PACKAGE BIPKG_INC_TICK_AGING AS


   TYPE bisp_refcursor_type IS REF CURSOR;
/******************************************************************************
   NAME:       BIPKG_INC_TICK_AGING
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------------
   1.0        09/05/2006    Rithesh          1. Created this package. This store procedure is to pass parameters to
                                             report 'Ticket Aging Report-sproc.rpt'
*********************************************************************************************************************/


   
   PROCEDURE BIPKG_INC_TICK_AGING (
      select_inc_aging_cursor   IN OUT   bisp_refcursor_type,
      --passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
	  pproduct			  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE

	  

   );
   
   

END BIPKG_INC_TICK_AGING;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_TICK_AGING AS
/******************************************************************************
   NAME:       BIPKG_INC_TICK_AGING
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------------------
   1.0        09/05/2006    Rithesh         1. Created this package body. This store procedure is to pass parameters to 
                                            report'Ticket Aging Report.rpt' 
**************************************************************************************************************************/

	PROCEDURE BIPKG_INC_TICK_AGING (
	  select_inc_aging_cursor   IN OUT   bisp_refcursor_type,
      ---passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
	  pproduct			  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdatem1    DATE;
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
		  
		  
		  
		  BEGIN
   		v_db_zone := 'GMT';	  
  	    bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.PROBLEM_TYPE,PROBSUMMARYM1.LOCATION, PROBSUMMARYM1.PRODUCT_TYPE, PROBSUMMARYM1.OPEN_GROUP, PROBSUMMARYM1.FLAG, PROBSUMMARYM1.OPEN_TIME, PROBSUMMARYM1.ASSIGNMENT,BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1'; 
		v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.product_type', pproduct) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.open_group', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 't' || '''' || '';
		
		     
	OPEN select_inc_aging_cursor FOR v_select_stmt ;
   
   END BIPKG_INC_TICK_AGING;

END BIPKG_INC_TICK_AGING;
/


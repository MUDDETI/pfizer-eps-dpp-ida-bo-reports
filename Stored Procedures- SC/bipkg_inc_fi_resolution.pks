CREATE OR REPLACE PACKAGE BIPKG_INC_FI_Resolution AS
/******************************************************************************
   NAME:       BIPKG_INC_FI_Resoulution
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------
   1.0        09/11/2006    Rithesh         1. This is to pass the  parameter values to report
                                             'First Incident Resolution Report-sproc.rpt'
************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_FI_Resolution (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
	  passignmentgroup    IN       VARCHAR2, 
      porig_group         IN       VARCHAR2,
      plocation           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
							 
                             );
  
  



END BIPKG_INC_FI_Resolution ;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_FI_Resolution AS
/******************************************************************************
   NAME:       BIPKG_INC_FI_Resolution
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------
   1.0        09/11/2006      Rithesh      1. This is to pass the  parameter values to report
                                             'First Incident Resolution Report-sproc.rpt'
************************************************************************************************/


PROCEDURE BIPKG_INC_FI_Resolution(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        
       
      passignmentgroup    IN       VARCHAR2, 
      porig_group         IN       VARCHAR2,
      plocation           IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
	  
	BEGIN  
	   
	   v_db_zone := 'GMT';
	    bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := '  SELECT PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.OPEN_GROUP, PROBSUMMARYM1.NUMBERPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time , BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, PROBSUMMARYM1.PFZ_TOTAL_TIME_SPENT,PROBSUMMARYM1.FLAG, PROBSUMMARYM1.LOCATION,PROBSUMMARYM1.PFZ_SITE_ID, PROBSUMMARYM1.PROBLEM_TYPE, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.CLOSED_GROUP, PROBSUMMARYM1.TOTAL_PAGES,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.open_group', porig_group) || ')';
	    v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.closed_group', passignmentgroup) || ')';
	    v_select_stmt := v_select_stmt || ' AND probsummarym1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND probsummarym1.close_time < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.location', plocation) || ')';
		 
		 		
OPEN select_calls_cursor FOR v_select_stmt ;
   
   END BIPKG_INC_FI_Resolution;

END BIPKG_INC_FI_Resolution;
/


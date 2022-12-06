CREATE OR REPLACE PACKAGE BIPKG_INC_SPM_Incidents AS
/******************************************************************************
   NAME:       BIPKG_INC_SPM_Incidents
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------------
   1.0        09/11/2006    Rithesh         1. This store procedure is to pass parameter values to report
                                               SAN-PGM-MAPS Incidents assigned-sproc.rpt
*************************************************************************************************************/

 
 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_SPM_Incidents (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
	  passignmentgroup    IN       VARCHAR2, 
      pnumberprgn		  IN       VARCHAR2, 
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
							 
                             );
  
  



END BIPKG_INC_SPM_Incidents ;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_SPM_Incidents AS
/******************************************************************************
   NAME:       BIPKG_INC_SPM_Incidents
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------------
   1.0        09/11/2006      Rithesh       1. This store procedure is to pass parameter values to report
                                               SAN-PGM-MAPS Incidents assigned-sproc.rpt
*************************************************************************************************************/

 PROCEDURE BIPKG_INC_SPM_Incidents(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        
       
      passignmentgroup    IN       VARCHAR2, 
      pnumberprgn		  IN       VARCHAR2, 
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
		v_select_stmt := 'SELECT PROBLEMM1.NUMBERPRGN,PROBLEMM1.status,PROBLEMM1.pfz_sla_title,BIPKG_UTILS.BIFNC_AdjustForTZ(PROBLEMM1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBLEMM1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, PROBLEMM1.LAST_ACTIVITY,PROBLEMM1.PAGE, BIPKG_UTILS.BIFNC_AdjustForTZ(problemm1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time , PROBLEMM1.ASSIGNMENT,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBLEMM1 PROBLEMM1';
		v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('PROBLEMM1.NUMBERPRGN', pnumberprgn) || ')';
				 
		 		
OPEN select_calls_cursor FOR v_select_stmt ;
   
   END BIPKG_INC_SPM_Incidents;

END BIPKG_INC_SPM_Incidents;
/


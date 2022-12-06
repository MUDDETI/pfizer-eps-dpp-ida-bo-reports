CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_INC_SPM_INCIDENTS AS
/******************************************************************************
   NAME:       BIPKG_INC_SPM_Incidents
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------------
   1.0        09/11/2006    Rithesh         1. This stored procedure is to pass parameter values to report
                                               SAN-PGM-MAPS Incidents assigned-sproc.rpt
	2.0		   10.29.07		shw	        1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
*************************************************************************************************************/

 
 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_SPM_Incidents (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
      passignmentgroup    IN       VARCHAR2, 
      pnumberprgn         IN       VARCHAR2, 
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type   IN       VARCHAR2
							 
                             );
END BIPKG_Gv_INC_SPM_INCIDENTS;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_INC_SPM_Incidents AS
/******************************************************************************
   NAME:       BIPKG_INC_SPM_Incidents
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------------
   1.0        09/11/2006      Rithesh       1. This store procedure is to pass parameter values to report
                                               SAN-PGM-MAPS Incidents assigned-sproc.rpt
    2.0           10.29.07        shw            1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
*************************************************************************************************************/

 PROCEDURE BIPKG_INC_SPM_Incidents(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
        
       
      passignmentgroup    IN       VARCHAR2, 
      pnumberprgn          IN       VARCHAR2, 
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type      IN       VARCHAR2
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
        v_select_stmt := 'SELECT v_pb.NUMBERPRGN,v_pb.status,v_pb.pfz_sla_title,BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_pb.LAST_ACTIVITY,v_pb.PAGE, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time , v_pb.ASSIGNMENT,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_pb.category';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBLEMS v_pb';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('v_pb.NUMBERPRGN', pnumberprgn) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_pb.category, '' '')', vinteraction_type)|| ')';
                 
                 
OPEN select_calls_cursor FOR v_select_stmt ;
   
   END BIPKG_INC_SPM_Incidents;

END BIPKG_Gv_INC_SPM_Incidents;
/

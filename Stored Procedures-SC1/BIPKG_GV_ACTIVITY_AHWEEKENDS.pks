CREATE OR REPLACE PACKAGE SCREPORT.Bipkg_Gv_Activity_Ahweekends AS
/******************************************************************************
   NAME:       AHWEEKENDS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------
   1.0        08/28/2006      Rithesh       1. To pass the parameters to report
                                               'After Hours Weekend Activity By Group-sproc.rpt'
	2.0		   10.17.07		shw			1. Upgrade for GAMPS 
************************************************************************************************/
 TYPE bisp_refcursor_type IS REF CURSOR;
 PROCEDURE Bipkg_Activity_Ahweekends (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                          passignmentgroup    IN       VARCHAR2,
                          pfrequency          IN       VARCHAR2,
                          poverride           IN       VARCHAR2,
                          pzone               IN       VARCHAR2,
                          pstartdate          IN       DATE,
                          penddate            IN       DATE,
                            vinteraction_type     IN          VARCHAR2
                             );
  
  


END Bipkg_Gv_Activity_Ahweekends;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.Bipkg_Gv_Activity_Ahweekends AS
/******************************************************************************
   NAME:       bipkg_activity_AHWEEKENDS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------
   1.0        08/28/2006       Rithesh     1.To pass the parameters to report
                                             'After Hours Weekend Activity By Group-sproc.rpt'
    2.0           10.17.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
*******************************************************************************************************/

 PROCEDURE Bipkg_Activity_Ahweekends (
      
     select_calls_cursor   IN OUT     bisp_refcursor_type,
      
      passignmentgroup    IN       VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE,
      vinteraction_type      IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR2(50);
      v_enddatedisplay     VARCHAR2(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_db_zone               VARCHAR2(10);
      v_select_stmt        VARCHAR2(32767); 
   
   BEGIN
           v_db_zone := 'GMT';      
          Bipkg_Utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay   := TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
       v_enddatedisplay     := TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
       v_select_stmt := 'SELECT BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ')UPDATE_TIME,v_pb.NUMBERPRGN,v_pb.UPDATED_BY, v_pb.INCIDENT_ID, v_pb.ASSIGNMENT,v_psm.PFZ_FULL_NAME, v_pb.PROBLEM_TYPE, OPERATORM1V.FULL_NAME, v_psm.NUMBERPRGN, v_pb.ASSIGNEE_NAME, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
       v_select_stmt := v_select_stmt || ' v_psm.category ';
       v_select_stmt := v_select_stmt || ' FROM sc.v_probsummary v_psm';
       v_select_stmt := v_select_stmt || ' INNER JOIN sc.v_problems v_pb ON v_psm.NUMBERPRGN = v_pb.NUMBERPRGN';
       v_select_stmt := v_select_stmt || ' INNER JOIN OPERATORM1V OPERATORM1V ON v_pb.UPDATED_BY = OPERATORM1V.NAME';
       v_select_stmt := v_select_stmt || ' WHERE (' || Bipkg_Utils.BIFNC_createinlist ('v_pb.assignment', passignmentgroup) || ')';
       v_select_stmt := v_select_stmt || ' AND v_psm.UPDATE_TIME >= ' || '''' || v_gmt_startdate || '''' ;
       v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      
    
         OPEN select_calls_cursor FOR v_select_stmt;
  
  END Bipkg_Activity_Ahweekends;         
END Bipkg_Gv_Activity_Ahweekends;
/

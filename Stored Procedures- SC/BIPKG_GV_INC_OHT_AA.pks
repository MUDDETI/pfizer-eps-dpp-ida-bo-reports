CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_INC_OHT_AA AS
/******************************************************************************
   NAME:       BIPKG_INC_OHT_AA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------------
   1.0        10/04/2006    Rithesh         1. This store procedure is to pass the parameter values to Report
                                               'Open Handled Tickets by Assignment-Assignee-sproc.rpt''
	2.0           10.26.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
*****************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_OHT_AA (select_calls_cursor   IN OUT   bisp_refcursor_type,
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             vinteraction_type         IN		VARCHAR2
                             );
  
END BIPKG_Gv_INC_OHT_AA;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_INC_OHT_AA AS
/******************************************************************************
   NAME:       BIPKG_INC_OHT_AA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------------
   1.0        10/04/2006       Rithesh      1. This store procedure is to pass the parameter values to Report
                                               'Open Handled Tickets by Assignment-Assignee-sproc.rpt''
    2.0           10.26.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
*****************************************************************************************************************/

PROCEDURE BIPKG_INC_OHT_AA(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
        
      
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2,         
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
        passignmentgroup         IN       VARCHAR2,
        vinteraction_type        IN       VARCHAR2
                        ) AS
                        
          v_select_stmt        VARCHAR2(32767);
          v_flag               CHAR(1);
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
        v_select_stmt := 'SELECT  BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, v_psm.PROBLEM_STATUS, v_psm.NUMBERPRGN, v_psm.BRIEF_DESCRIPTION, v_psm.PFZ_FULL_NAME, ACTIVITYM1.TYPE, ACTIVITYM1.OPERATOR,BIPKG_UTILS.BIFNC_AdjustForTZ(ACTIVITYM1.SYSMODTIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') SYSMODTIME, v_psm.FLAG, v_psm.PRODUCT_TYPE, v_pb.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, v_pb.ASSIGNEE_NAME, v_pb.UPDATED_BY, v_psm.PROBLEM_TYPE,v_psm.ASSIGNEE_NAME, ACTIVITYM1.DESCRIPTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_psm.category';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBLEMS v_pb' ;
        v_select_stmt := v_select_stmt || ' INNER JOIN SC.V_PROBSUMMARY v_psm ON v_pb.NUMBERPRGN = v_psm.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN ACTIVITYM1 ACTIVITYM1 ON v_psm.NUMBERPRGN = ACTIVITYM1.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE v_psm.FLAG = ' || '''' || 't' || '''' || '';     
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_pb.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (ACTIVITYM1.SYSMODTIME >= ' || '''' || v_gmt_startdate || '''' || 'AND ACTIVITYM1.SYSMODTIME < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
            
                                                             

         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_INC_OHT_AA;         
END BIPKG_Gv_INC_OHT_AA;
/

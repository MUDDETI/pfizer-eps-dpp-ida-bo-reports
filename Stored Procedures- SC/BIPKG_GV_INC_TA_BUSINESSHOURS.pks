CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_INC_TA_BUSINESSHOURS AS
/******************************************************************************
   NAME:       BIPKG_INC_TA_BUSINESSHOURS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------
   1.0        09/21/2006     Rithesh        1. Created this package to pass the parameter values to Report
                                               'Tickets Assignments with Business Hours-sproc.rpt'
	2.0		   10.29.07        shw            1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
************************************************************************************************************/


 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_TA_BUSINESSHOURS (select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             porig_group               IN       VARCHAR2,
                             pbu                       IN        VARCHAR2,
                             vinteraction_type	 	   IN		VARCHAR2
                             );
END BIPKG_Gv_INC_TA_BUSINESSHOURS;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_INC_TA_BUSINESSHOURS AS
/******************************************************************************
   NAME:       BIPKG_INC_TA_BUSINESSHOURS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------
   1.0        09/21/2006      Rithesh       1. Created this package.O pass the parameter values to Report
                                               'Tickets Assignments with Business Hours-sproc.rpt'
    2.0           10.29.07        shw            1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
************************************************************************************************************/


PROCEDURE BIPKG_INC_TA_BUSINESSHOURS(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
        
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             porig_group               IN       VARCHAR2,
                             pbu                       IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                        ) AS
                        
                         
          v_select_stmt        VARCHAR2(32767);
          v_close_time          DATE;
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
        v_select_stmt := 'SELECT BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, v_psm.NUMBERPRGN, v_psm.BRIEF_DESCRIPTION, v_psm.PFZ_FULL_NAME, v_psm.PRODUCT_TYPE, v_pb.UPDATED_BY, v_pb.PFZ_SLA_TITLE, v_psm.PFZ_SLA_TITLE, v_pb.PROBLEM_STATUS, v_pb.LAST_ACTIVITY, v_pb.ACTOR, v_psm.PROBLEM_TYPE, v_psm.PFZ_BU, v_psm.PFZ_RESPOND_SLA, v_psm.STATUS, v_psm.PROBLEM_STATUS, v_psm.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, v_pb.PAGE, v_psm.OPEN_GROUP, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.PREV_UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PREV_UPDATE_TIME, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, v_pb.UPDATE_ACTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm' ;
        v_select_stmt := v_select_stmt || ' INNER JOIN SC.V_PROBLEMS v_pb ON v_psm.NUMBERPRGN = v_pb.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.OPEN_GROUP', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.PFZ_BU', pbu) || ')';
        v_select_stmt := v_select_stmt || ' AND v_pb.UPDATE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_pb.UPDATE_TIME < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
   
         OPEN select_calls_cursor FOR v_select_stmt;
    END BIPKG_INC_TA_BUSINESSHOURS;
END BIPKG_Gv_INC_TA_BUSINESSHOURS;
/

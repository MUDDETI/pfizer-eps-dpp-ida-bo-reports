CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_EIMONTHLY_GBL340RT AS
/******************************************************************************
   NAME:       BIPKG_EIMONTHLY_GBL340RT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------
   1.0        10/17/2006    Rithesh         1.This store procedure is to pass the parameter values to report
                                             'GBL340 Resource Time-sproc.rpt' 
	2.0		   10.02.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
***************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_EIMONTHLY_GBL340RT (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                             
                             );
END BIPKG_Gv_EIMONTHLY_GBL340RT;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_EIMONTHLY_GBL340RT AS
/******************************************************************************
   NAME:       BIPKG_EIMONTHLY_GBL340RT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------
   1.0        10/17/2006   Rithesh          1.This store procedure is to pass the parameter values to report
                                             'GBL340 Resource Time-sproc.rpt' 
    2.0           10.02.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
****************************************************************************************************************/

PROCEDURE BIPKG_EIMONTHLY_GBL340RT(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
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
        v_select_stmt := 'SELECT v_pb.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, v_pb.PROBLEM_STATUS, v_pb.PROBLEM_TYPE, v_pb.TIME_SPENT, BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, v_pb.UPDATED_BY, v_pb.NUMBERPRGN, ASSIGNMENTA1.NAME, v_pb.PRODUCT_TYPE, v_pb.BRIEF_DESCRIPTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_pb.category';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBLEMS v_pb ' ;
        v_select_stmt := v_select_stmt || ' INNER JOIN ASSIGNMENTA1 ASSIGNMENTA1 ON v_pb.ASSIGNMENT = ASSIGNMENTA1.NAME  AND v_pb.UPDATED_BY = ASSIGNMENTA1.OPERATORS ';
           v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('v_pb.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT(v_pb.UPDATED_BY =  ' || '''' || 'problem' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND v_pb.UPDATE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_pb.UPDATE_TIME < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_pb.category, '' '')', vinteraction_type)|| ')';
       
     
     OPEN select_calls_cursor FOR v_select_stmt;
    END BIPKG_EIMONTHLY_GBL340RT;
END BIPKG_Gv_EIMONTHLY_GBL340RT;
/

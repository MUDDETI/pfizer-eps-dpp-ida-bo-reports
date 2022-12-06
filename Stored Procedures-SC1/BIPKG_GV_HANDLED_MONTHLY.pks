CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_HANDLED_MONTHLY AS
/******************************************************************************
   NAME:       BIPKG_HANDLED_MONTHLY
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------
   1.0        09/12/2006      Rithesh       1. To pass parameter values to store procedure
                                              'Monthly Calls Handled & Closed-sproc.rpt' 
	2.0		   10.02.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
********************************************************************************************/

   
TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_HANDLED_MONTHLY (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                      
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,                            --- passignmentgroup          IN       VARCHAR2,
                             porig_group               IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                             );
END BIPKG_Gv_HANDLED_MONTHLY;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_HANDLED_MONTHLY  AS
/******************************************************************************
   NAME:       BIPKG_HANDLED_MONTHLY 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------
   1.0        09/12/2006       Rithesh      1.To pass parameter values to store procedure
                                              'Monthly Calls Handled & Closed-sproc.rpt' 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
*********************************************************************************************/

PROCEDURE BIPKG_HANDLED_MONTHLY(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,                             --passignmentgroup          IN       VARCHAR2,
                             porig_group               IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                        ) AS
                        
                         
          v_select_stmt        VARCHAR2(32767);
          v_update_time        DATE;
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
        v_select_stmt := 'SELECT DISTINCT INCIDENTSM1.INCIDENT_ID, INCIDENTSM1.UPDATED_BY, INCIDENTSM1.PFZ_SLA_TITLE,BIPKG_UTILS.BIFNC_AdjustForTZ(INCIDENTSM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, INCIDENTSM1.PFZ_ORIG_GROUP, INCIDENTSM1.FIRST_CALL, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,INCIDENTSM1.category';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('incidentsm1.pfz_orig_group', porig_group) || ')' ; 
        v_select_stmt := v_select_stmt || ' AND INCIDENTSM1.UPDATE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.UPDATE_TIME < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(INCIDENTSM1.category, '' '')', vinteraction_type)|| ')';
     

         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_HANDLED_MONTHLY;         
END BIPKG_Gv_HANDLED_MONTHLY;
/

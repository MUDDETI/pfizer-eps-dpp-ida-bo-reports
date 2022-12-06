CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_INC_SPECIALFLAG AS
/******************************************************************************
   NAME:       BIPKG_INC_SpecialFlag
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------
   1.0        09/15/2006     Rithesh        1. To pass the parameter values to report
                                              'Incidents by Special Flag Report-sproc.rpt'
	2.0		   10.29.07		shw			1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
*******************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_SpecialFlag (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             pregion                   IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             porig_group               IN       VARCHAR2,
                             vinteraction_type     	   IN		VARCHAR2
                             );
END BIPKG_Gv_INC_SPECIALFLAG;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_INC_SpecialFlag AS
/******************************************************************************
   NAME:       BIPKG_INC_SpecialFlag
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------
   1.0        09/15/2006     Rithesh        1. To pass the parameter values to report
                                              'Incidents by Special Flag Report-sproc.rpt'
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
**************************************************************************************************/

PROCEDURE BIPKG_INC_SpecialFlag(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
        

                             pregion                   IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             porig_group               IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                        ) AS
                         
          v_select_stmt        VARCHAR2(32767);
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
        v_select_stmt := 'SELECT v_psm.ASSIGNMENT, v_psm.OPEN_GROUP, v_psm.NUMBERPRGN, v_psm.PROBLEM_TYPE, v_psm.PFZ_BU, v_psm.PFZ_RB_SPECIAL, PFZSITESM1.PFZ_REGION_ID,v_psm.PFZ_SITE_ID, v_psm.CLOSED_GROUP, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,v_psm.category';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm' ;
        v_select_stmt := v_select_stmt || ' INNER JOIN PFZSITESM1 PFZSITESM1 ON v_psm.PFZ_SITE_ID = PFZSITESM1.SITE_ID ';
        v_select_stmt := v_select_stmt || ' WHERE (' || bipkg_utils.BIFNC_createinlist ('PFZSITESM1.PFZ_REGION_ID',pregion) || ')';   
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.open_group', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.UPDATE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.UPDATE_TIME < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
         OPEN select_calls_cursor FOR v_select_stmt;
    END BIPKG_INC_SpecialFlag;
END BIPKG_Gv_INC_SpecialFlag;
/

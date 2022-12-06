CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_INCCONFIGSUMM AS
/******************************************************************************
   NAME:       BIPKG_SANDWICHINCCONFIGSUMM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------
   1.0        10/31/2006    Rithesh         1.This stored procedure is to pass the paramter values to report
                                              'Incidents by Configuration Summary-sproc.rpt' 
	2.0	       10.29.07        shw            1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
****************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_SANDWICH_INCCONFIGSUMM (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             psite                     IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2,
                             vpriority    			   IN		VARCHAR2
                             );
END BIPKG_Gv_INCCONFIGSUMM;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_INCCONFIGSUMM AS
/******************************************************************************
   NAME:       BIPKG_SANDWICHINCCONFIGSUMM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------------
   1.0        10/31/2006   Rithesh          1.This stored procedure is to pass the paramter values to report
                                              'Incidents by Configuration Summary-sproc.rpt' 
    2.0           10.29.07        shw            1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
*************************************************************************************************************/
PROCEDURE BIPKG_SANDWICH_INCCONFIGSUMM(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             psite                     IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2,
                             vpriority                 IN       VARCHAR2
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
        v_select_stmt := 'SELECT v_psm.NUMBERPRGN as Ticket,'||''''||'RESOLVE'|| ''''|| ' SLA_Type,v_psm.ASSIGNMENT as Assignment,v_psm.ASSIGNEE_NAME as Operator,om1.FULL_NAME as Assignee,BIPKG_UTILS.BIFNC_AdjustForTZ( v_psm.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME,BIPKG_UTILS.BIFNC_AdjustForTZ( v_psm.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME,v_psm.FLAG as Flag,v_psm.CLOSE_TIME as SLA_Time, v_psm.PFZ_RESOLVE_SLA as MadeMissed,v_psm.PFZ_SLA_TITLE as BusType,v_psm.PFZ_FULL_NAME as Client,v_psm.LOCATION as Location,dm1.PFZ_MANAGING_SITE as CI_Managing_Site,dm1.NETWORK_NAME as CI_Name,dm1.TYPE as Type,dm1.LOGICAL_NAME as CID, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm ' ;
        v_select_stmt := v_select_stmt || ' LEFT JOIN DEVICEM1 dm1 ON v_psm.LOGICAL_NAME = dm1.LOGICAL_NAME ';
        v_select_stmt := v_select_stmt || ' LEFT JOIN OPERATORM1V om1 ON v_psm.ASSIGNEE_NAME = om1.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('dm1.PFZ_MANAGING_SITE', psite) || ')';
        v_select_stmt := v_select_stmt || ' AND (v_psm.FLAG =  ' || '''' || 'f' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ')';
-- 10.29.07-shw- GAMP        v_select_stmt := v_select_stmt || ' AND NOT (v_psm.PFZ_SLA_TITLE =  ' || '''' || 'Project' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND v_psm.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
         OPEN select_calls_cursor FOR v_select_stmt;
    END BIPKG_SANDWICH_INCCONFIGSUMM;
END BIPKG_Gv_INCCONFIGSUMM;
/

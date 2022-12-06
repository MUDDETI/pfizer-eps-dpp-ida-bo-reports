CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_SLA_CI AS
/******************************************************************************
   NAME:       BIPKG_SLA_CI
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------
   1.0        09/05/2006    Rithesh         1. This package is to pass the parameters to report 
                                              'Closed Incidents Over SLA Report-sproc.rpt'
	2.0		   10.29.07		shw			1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
    2.3         12.19.07    shw         4. Resolved or Closed date parameter 
    2.4         01.18.08    shw         5. if resolve time is null, replace w/close time 
**********************************************************************************************************/
TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_SLA_CI (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                             PFZ_FULL_NAME             IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             vinteraction_type         IN		VARCHAR2,
                             vtarget_metric            IN       VARCHAR2,
                             vtime                     IN       VARCHAR2
                             );

END BIPKG_Gv_SLA_CI;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_SLA_CI AS
/******************************************************************************
   NAME:       BIPKG_SLA_CI
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------------
   1.0        09/05/2006      Rithesh       1. This stored procedure is to pass the parameter values to  report 
                                            'Closed incidents Over SLA Report-sproc.rpt'
    2.0           10.29.07        shw            1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
    2.3         12.19.07    shw         4. Resolved or Closed date parameter 
    2.4         01.18.08    shw         5. if resolve time is null, replace w/close time 
***********************************************************************************************************************/

    PROCEDURE BIPKG_SLA_CI (
    select_calls_cursor   IN OUT     bisp_refcursor_type,
        
        PFZ_FULL_NAME            IN       VARCHAR2, 
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2,         
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
        passignmentgroup         IN       VARCHAR2,
        vinteraction_type        IN       VARCHAR2,
        vtarget_metric           IN       VARCHAR2,
        vtime                    IN       VARCHAR2
                            ) AS
                        
          v_select_stmt        VARCHAR2(32767);
          v_pfz_full_name      VARCHAR2(40); 
          v_open_time          DATE;
          v_flag               CHAR(1);
          v_startdatedisplay   VARCHAR2(50);
          v_enddatedisplay     VARCHAR2(50);
          v_db_zone            VARCHAR2(10);      
          v_gmt_startdate      DATE;
          v_gmt_enddate        DATE;
          v_currentdate        VARCHAR(50);
          
          
          
          BEGIN
           v_db_zone := 'GMT';      
          bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
              IF vtarget_metric = 'Primary'
           Then
        v_select_stmt := 'SELECT  v_psm.ASSIGNMENT, v_psm.ASSIGNEE_NAME,v_psm.NUMBERPRGN, v_psm.FLAG, v_psm.PFZ_SLA_TITLE, v_psm.STATUS, v_psm.PFZ_FULL_NAME,v_psm.PFZ_RESPOND_SLA RESPOND_SLA, v_psm.PFZ_RESOLVE_SLA RESOVLE_SLA,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED, ';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| v_db_zone|| ''''|| ','|| ''''|| pzone|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| v_db_zone || ''''|| ','|| ''''|| pzone || ''''|| ') pfz_restore_2nd_target_time';
            Else
        v_select_stmt := 'SELECT  v_psm.ASSIGNMENT, v_psm.ASSIGNEE_NAME,v_psm.NUMBERPRGN, v_psm.FLAG, v_psm.PFZ_SLA_TITLE, v_psm.STATUS, v_psm.PFZ_FULL_NAME,v_psm.PFZ_RESPOND_2ND_TARGET RESPOND_SLA, v_psm.PFZ_RESOLVE_SLA RESOLVE_SLA,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED, ';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| v_db_zone|| ''''|| ','|| ''''|| pzone|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| v_db_zone || ''''|| ','|| ''''|| pzone || ''''|| ') pfz_restore_2nd_target_time';
            End If;            
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm';
        v_select_stmt := v_select_stmt || ' WHERE v_psm.flag = ' || '''' || 'f' || '''' || '';   
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.PFZ_FULL_NAME', PFZ_FULL_NAME) || ')';
                IF vtime = 'Closed' 
           Then
        v_select_stmt := v_select_stmt || ' AND v_psm.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;
        Else
        v_select_stmt := v_select_stmt || ' AND NVL(v_psm.resolve_time, v_psm.close_time) >= ' || '''' || v_gmt_startdate || '''' || ' and NVL(v_psm.resolve_time, v_psm.close_time) < ' || '''' || v_gmt_enddate || '''' ;
        End If;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        
    OPEN select_calls_cursor FOR v_select_stmt ;
   
   END BIPKG_SLA_CI;

END BIPKG_Gv_SLA_CI;
/

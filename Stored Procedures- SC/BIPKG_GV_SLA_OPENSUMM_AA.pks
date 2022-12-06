CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_SLA_OPENSUMM_AA AS
/******************************************************************************
   NAME:       BIPKG_SLA_OPENSUMM_AA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------
   1.0        09/27/2006   Rithesh          1.To pass the parameter values to Report
                                             'SLA Open Summary by Assignment-Assignee-sproc.rpt'
	2.0		   10.29.07		shw			1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
****************************************************************************************************/
 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_SLA_OPENSUMM_AA (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             vpriority                 IN       VARCHAR2,
                             vinteraction_type	 	   IN		VARCHAR2
	                             );
END BIPKG_Gv_SLA_OPENSUMM_AA;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_SLA_OPENSUMM_AA AS
/******************************************************************************
   NAME:       BIPKG_SLA_OPENSUMM_AA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------
   1.0        09/27/2006     Rithesh        1.To pass the parameter values to Report
                                             'SLA Open Summary by Assignment-Assignee-sproc.rpt'
    2.0           10.29.07        shw            1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
*****************************************************************************************************/
PROCEDURE BIPKG_SLA_OPENSUMM_AA(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
                                     
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
                             passignmentgroup          IN       VARCHAR2,
                             vpriority                 IN       VARCHAR2,
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
        v_select_stmt := ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, v_psm.NUMBERPRGN Ticket,v_psm.ASSIGNEE_NAME Assignee,v_psm.PFZ_RESPOND_SLA MadeMissed,v_psm.PFZ_SLA_TITLE BusType, bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,'|| ''''|| v_db_zone || ''''|| ','|| ''''||  pzone || ''''|| ') pfz_sla_time,';
        v_select_stmt := v_select_stmt || ' v_psm.ASSIGNMENT,OPERATORM1V.FULL_NAME,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' ||  pzone  || '''' || ') OPEN_TIME ,BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' ||  pzone  || '''' || ') CLOSE_TIME ,    v_psm.FLAG    ,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED, ';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RESPOND_2ND_TARGET,v_psm.PFZ_RESPOND_2ND_TARGET_GROUP,v_psm.PFZ_HP_SLA_SCHEDULE,v_psm.PFZ_HP_SLA,v_psm.PFZ_RESPOND_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESPOND_2ND_TARGET_TIME,'|| ''''|| v_db_zone|| ''''|| ','|| ''''|| pzone|| ''''|| ') pfz_respond_2nd_target_time,v_psm.PFZ_RESTORE_2ND_TARGET_USER,bipkg_utils.bifnc_AdjustForTZ(v_psm.PFZ_RESTORE_2ND_TARGET_TIME,'|| ''''|| v_db_zone|| ''''|| ','|| ''''|| pzone|| ''''|| ') pfz_restore_2nd_target_time';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm' ;
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN OPERATORM1V OPERATORM1V ON v_psm.PFZ_RESPOND_SLA_USER = OPERATORM1V.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('v_psm.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT(v_psm.FLAG = ' || '''' || 'f' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.PRIORITY, '' '')', vpriority)|| ')';
-- 10.29.07-shw- GAMP         v_select_stmt := v_select_stmt || ' AND NOT(v_psm.PFZ_SLA_TITLE = ' || '''' || 'Project' || '''' || ')';
           v_select_stmt := v_select_stmt || ' AND v_psm.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_psm.OPEN_TIME < ' || '''' || v_gmt_enddate || '''' ;
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        
        
        OPEN select_calls_cursor FOR v_select_stmt;
    END BIPKG_SLA_OPENSUMM_AA;
END BIPKG_Gv_SLA_OPENSUMM_AA;
/

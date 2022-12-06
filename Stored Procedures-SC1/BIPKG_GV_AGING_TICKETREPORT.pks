CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_AGING_TICKETREPORT AS
/******************************************************************************
   NAME:       BIPKG_AGING_TICKETREPORT
   PURPOSE:

   REVISIONS:
   Ver               Date             Author             Description
   ---------        ----------       ---------------       --------------------------------------------------------------
   1.0        09/12/2006        RM              To pass the parameter values to report Aging Ticket Snapshot Summary and Detail by Project-sproc.rpt
   2.0		  12/29/2006        SG  			 Removed the unnecessary parameters
	3.0		   10.18.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
**********************************************************************************************************/

TYPE bisp_refcursor_type IS REF CURSOR;
 PROCEDURE Bipkg_Aging_Ticketreport (
                                
                            select_calls_cursor   IN OUT   bisp_refcursor_type,
                             passignmentgroup     IN       VARCHAR2,
                             pproject             IN       VARCHAR2,
                             porig_group          IN       VARCHAR2,
                             pzone                IN       VARCHAR2,
                             vinteraction_type    IN       VARCHAR2

                             );

END BIPKG_Gv_AGING_TICKETREPORT;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.Bipkg_Gv_Aging_Ticketreport AS
/******************************************************************************
   NAME:       BIPKG_AGING_TICKETREPORT
   PURPOSE:

   REVISIONS:
   Ver               Date             Author             Description
   ---------        ----------       ---------------       --------------------------------------------------------------
   1.0        09/12/2006        RM              To pass the parameter values to report Aging Ticket Snapshot Summary and Detail by Project-sproc.rpt
   2.0          12/29/2006        SG               Removed the unnecessary parameters
    3.0           10.18.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
**********************************************************************************************************/

PROCEDURE Bipkg_Aging_Ticketreport(

    select_calls_cursor   IN OUT     bisp_refcursor_type,
                             passignmentgroup          IN       VARCHAR2,
                             pproject                  IN       VARCHAR2,
                             porig_group               IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             vinteraction_type         IN       VARCHAR2
                             
                        ) AS
            
          v_select_stmt        VARCHAR2(32767);
          v_db_zone            VARCHAR2(10);      
          
  BEGIN
  
  v_db_zone := 'GMT';

        v_select_stmt := 'SELECT v_psm.ASSIGNMENT,v_psm.FLAG, v_psm.NUMBERPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, v_psm.PFZ_SLA_TITLE, v_psm.PROBLEM_STATUS, BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, v_psm.OPEN_GROUP, v_psm.LAST_ACTIVITY, v_psm.PFZ_RELATED_PROJECTS, v_psm.UPDATED_BY, v_psm.BRIEF_DESCRIPTION,';
        v_select_stmt := v_select_stmt || ' v_psm.category,';        
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm ';
        v_select_stmt := v_select_stmt || ' WHERE v_psm.flag = ''t'' '; 
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.assignment', passignmentgroup) || ')'; 
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('v_psm.open_group', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('NVL(v_psm.pfz_related_projects, '' '')', pproject) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';

         OPEN select_calls_cursor FOR v_select_stmt;
  END Bipkg_Aging_Ticketreport;         
END Bipkg_Gv_Aging_Ticketreport;
/

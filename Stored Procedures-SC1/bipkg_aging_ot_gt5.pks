CREATE OR REPLACE PACKAGE bipkg_aging_ot_gt5
AS
/******************************************************************************
   NAME:       BIPKG_AGING_OT_GT5
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------
   1.0        09/19/2006    Rithesh         1. To pass the parameter values to Report
                                             'OpenTickets GT 5 days old-sproc.rpt'
****************************************************************************************/
   TYPE bisp_refcursor_type IS REF CURSOR;

   PROCEDURE bipkg_aging_ot_gt5 (
      select_calls_cursor   IN OUT   bisp_refcursor_type,
      pfrequency            IN       VARCHAR2,
      poverride             IN       VARCHAR2,
      pzone                 IN       VARCHAR2,
      pstartdate            IN       DATE,
      penddate              IN       DATE,
      passignmentgroup      IN       VARCHAR2,
      porig_group           IN       VARCHAR2,
      psite                  IN       VARCHAR2
   );
END bipkg_aging_ot_gt5;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_AGING_OT_GT5 AS
/******************************************************************************
   NAME:       BIPKG_AGING_OT_GT5
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------
   1.0        09/19/2006    Rithesh         1. To pass the parameter values to Report
                                             'OpenTickets GT 5 days old-sproc.rpt'
***************************************************************************************/

PROCEDURE BIPKG_AGING_OT_GT5(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2,
							 porig_group               IN       VARCHAR2,
							 psite 			           IN       VARCHAR2
						

		
		
               
                        ) AS
						
		 				
	      v_select_stmt        VARCHAR2(32767);
		  v_pfz_sla_title      VARCHAR2(40); 
          v_close_time         DATE;
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
		v_select_stmt := 'SELECT PROBSUMMARYM1.SITE_CATEGORY,PROBSUMMARYM1.NUMBERPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, PROBSUMMARYM1.PFZ_FULL_NAME, PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.PROBLEM_STATUS,PROBSUMMARYM1.PRODUCT_TYPE, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.FLAG, PROBSUMMARYM1.BRIEF_DESCRIPTION, PROBSUMMARYM1.REPAIR_TIME, PROBSUMMARYM1.ASSIGNEE_NAME, PROBSUMMARYM1.OPEN_GROUP, PROBSUMMARYM1.COUNTPRGN, PROBSUMMARYM1.PFZ_SITE_ID,BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, LOCATIONM1.COUNTRY,PROBSUMMARYM1.GROUPPRGN,PROBSUMMARYM1.LOCATION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN LOCATIONM1 LOCATIONM1 ON PROBSUMMARYM1.LOCATION = LOCATIONM1.LOCATION';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist (' PROBSUMMARYM1.PFZ_SITE_ID',psite) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.OPEN_GROUP', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND  (PROBSUMMARYM1.PFZ_SLA_TITLE = ' || '''' || 'Business Critical' || '''' || '  OR PROBSUMMARYM1.PFZ_SLA_TITLE = ' || '''' || 'High Priority' || '''' || '  OR PROBSUMMARYM1.PFZ_SLA_TITLE = ' || '''' || 'Service Request' || '''' || '  OR PROBSUMMARYM1.PFZ_SLA_TITLE = ' || '''' || 'Standard Priority' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (PROBSUMMARYM1.FLAG = ' || '''' || 't' ||  '''' || ')'; 
  --      v_select_stmt := v_select_stmt || ' AND (PROBSUMMARYM1.UPDATE_TIME >= ' || '''' ||   v_gmt_startdate ||  '''' || ')' ;
  
  OPEN select_calls_cursor FOR v_select_stmt;
  
  END BIPKG_AGING_OT_GT5;         
END BIPKG_AGING_OT_GT5;
/


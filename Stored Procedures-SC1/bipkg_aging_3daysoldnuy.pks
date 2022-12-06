CREATE OR REPLACE PACKAGE BIPKG_AGING_3DAYSOLDNUY AS
/******************************************************************************
   NAME:       BIPKG_AGING_3DAYSOLDNUY
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------------
   1.0        10/10/2006     Rithesh       1.This store procedure is to pass the parameter values to report
                                             'More than 3 days old-Not Updated Yesterday-sproc.rpt' 
*************************************************************************************************************/
   TYPE bisp_refcursor_type IS REF CURSOR;

   PROCEDURE BIPKG_AGING_3DAYSOLDNUY (
      select_calls_cursor   IN OUT   bisp_refcursor_type,
      pfrequency            IN       VARCHAR2,
      poverride             IN       VARCHAR2,
      pzone                 IN       VARCHAR2,
      pstartdate            IN       DATE,
      penddate              IN       DATE,
      passignmentgroup      IN       VARCHAR2,
      porig_group           IN       VARCHAR2,
      psite                 IN       VARCHAR2
   );
END BIPKG_AGING_3DAYSOLDNUY;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_AGING_3DAYSOLDNUY AS
/******************************************************************************
   NAME:       BIPKG_AGING_3DAYSOLDNUY
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------
   1.0        10/10/2006    Rithesh         1.This store procedure is to pass the parameter values to report
                                             'More than 3 days old-Not Updated Yesterday-sproc.rpt' 
***************************************************************************************************************/

PROCEDURE BIPKG_AGING_3DAYSOLDNUY(

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
		v_select_stmt := 'SELECT PROBSUMMARYM1.NUMBERPRGN,PROBSUMMARYM1.SITE_CATEGORY,PROBSUMMARYM1.UPDATE_ACTION,PROBSUMMARYM1.LAST_ACTIVITY, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, PROBSUMMARYM1.PFZ_FULL_NAME, PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.PROBLEM_STATUS, PROBSUMMARYM1.PRODUCT_TYPE, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.FLAG, PROBSUMMARYM1.BRIEF_DESCRIPTION, PROBSUMMARYM1.ASSIGNEE_NAME, PROBSUMMARYM1.OPEN_GROUP, PROBSUMMARYM1.COUNTPRGN, PROBSUMMARYM1.PFZ_SITE_ID, PROBSUMMARYM1.GROUPPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1' ;
		v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist (' PROBSUMMARYM1.PFZ_SITE_ID',psite) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.OPEN_GROUP', porig_group) || ')';
        v_select_stmt := v_select_stmt || ' AND (PROBSUMMARYM1.PFZ_SLA_TITLE = ' || '''' || 'Business Critical' || '''' || '  OR PROBSUMMARYM1.PFZ_SLA_TITLE = ' || '''' || 'High Priority' || '''' || '  OR PROBSUMMARYM1.PFZ_SLA_TITLE = ' || '''' || 'Service Request' || '''' || '  OR PROBSUMMARYM1.PFZ_SLA_TITLE = ' || '''' || 'Standard Priority' || '''' || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (PROBSUMMARYM1.FLAG = ' || '''' || 't' ||  '''' || ')'; 
 
  OPEN select_calls_cursor FOR v_select_stmt;
  
  END BIPKG_AGING_3DAYSOLDNUY;         
END BIPKG_AGING_3DAYSOLDNUY;
/


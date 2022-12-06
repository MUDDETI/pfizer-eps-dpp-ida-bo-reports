CREATE OR REPLACE PACKAGE Bipkg_Aging_Ticketreport AS

/******************************************************************************
   NAME:       BIPKG_AGING_TICKETREPORT
   PURPOSE:

   REVISIONS:
   Ver               Date             Author             Description
   ---------        ----------       ---------------       --------------------------------------------------------------
   1.0        09/12/2006        RM              To pass the parameter values to report Aging Ticket Snapshot Summary and Detail by Project-sproc.rpt
   2.0		  12/29/2006        SG  			 Removed the unnecessary parameters
**********************************************************************************************************/

TYPE bisp_refcursor_type IS REF CURSOR;
 PROCEDURE Bipkg_Aging_Ticketreport (
 		   					
							select_calls_cursor   IN OUT   bisp_refcursor_type,
							 passignmentgroup          IN       VARCHAR2,
							 pproject			       IN		VARCHAR2,
							 porig_group               IN       VARCHAR2,
							 pzone					   IN VARCHAR2

                             );

END Bipkg_Aging_Ticketreport;
/
CREATE OR REPLACE PACKAGE BODY Bipkg_Aging_Ticketreport AS
/******************************************************************************
   NAME:       BIPKG_AGING_TICKETREPORT
   PURPOSE:

   REVISIONS:
   Ver               Date             Author             Description
   ---------        ----------       ---------------       --------------------------------------------------------------
   1.0        09/12/2006        RM              To pass the parameter values to report Aging Ticket Snapshot Summary and Detail by Project-sproc.rpt
   2.0		  12/29/2006        SG  			 Removed the unnecessary parameters
**********************************************************************************************************/

PROCEDURE Bipkg_Aging_Ticketreport(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
							 passignmentgroup          IN       VARCHAR2,
							 pproject			       IN		VARCHAR2,
							 porig_group               IN       VARCHAR2,
							 pzone					   IN VARCHAR2
							 
                        ) AS
			
	      v_select_stmt        VARCHAR2(32767);
          v_db_zone            VARCHAR2(10);      
		  
  BEGIN
  
  v_db_zone := 'GMT';

		v_select_stmt := 'SELECT PROBSUMMARYM1.ASSIGNMENT,PROBSUMMARYM1.FLAG, PROBSUMMARYM1.NUMBERPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.PROBLEM_STATUS, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, PROBSUMMARYM1.OPEN_GROUP, PROBSUMMARYM1.LAST_ACTIVITY, PROBSUMMARYM2.PFZ_RELATED_PROJECTS, PROBSUMMARYM1.UPDATED_BY, PROBSUMMARYM1.BRIEF_DESCRIPTION';
        v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
		v_select_stmt := v_select_stmt || '  INNER JOIN PROBSUMMARYM2 PROBSUMMARYM2 ON PROBSUMMARYM1.NUMBERPRGN = PROBSUMMARYM2.NUMBERPRGN';
        v_select_stmt := v_select_stmt || ' WHERE probsummarym1.flag = ''t'' '; 
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')'; 
		v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym1.open_group', porig_group) || ')';
	    v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.BIFNC_createinlist ('probsummarym2.pfz_related_projects', pproject) || ')';

         OPEN select_calls_cursor FOR v_select_stmt;
  END Bipkg_Aging_Ticketreport;         
END Bipkg_Aging_Ticketreport;
/

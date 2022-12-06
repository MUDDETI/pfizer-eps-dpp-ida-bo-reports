CREATE OR REPLACE PACKAGE BIPKG_PROJ_AGINGTICK AS
/******************************************************************************
   NAME:       BIPKG_PROJ_AGINGTICK
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------
   1.0        09/15/2006    Rithesh         1. To pass the parameter values to report 
                                               Aging Ticket Report-sproc.rpt'
*****************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_PROJ_AGINGTICK (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
						     pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2,
							 porig_group               IN       VARCHAR2,
							 pproject                  IN       VARCHAR2,
							 pspecialflag              IN       VARCHAR2,
							 pdivision                 IN       VARCHAR2
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_PROJ_AGINGTICK;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_PROJ_AGINGTICK AS
/******************************************************************************
   NAME:       BIPKG_PROJ_AGINGTICK
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------
   1.0        09/15/2006     Rithesh        1. To pass the parameter values to report 
                                               Aging Ticket Report-sproc.rpt'
***************************************************************************************/

PROCEDURE BIPKG_PROJ_AGINGTICK(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        
     pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2,
							 porig_group               IN       VARCHAR2,
							 pproject                  IN       VARCHAR2,
							 pspecialflag              IN       VARCHAR2,
						     pdivision                 IN       VARCHAR2
							
							
							 
		
		
               
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
		v_select_stmt := 'SELECT PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.FLAG, PROBSUMMARYM1.NUMBERPRGN,BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.PROBLEM_STATUS,BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME,PROBSUMMARYM1.OPEN_GROUP, PROBSUMMARYM1.LAST_ACTIVITY, PROBSUMMARYM2.PFZ_RELATED_PROJECTS, PROBSUMMARYM1.PFZ_DIVISION, PROBSUMMARYM1.PFZ_BU, PROBSUMMARYM1.PFZ_SPECIAL_PROJECT,PROBSUMMARYM1.UPDATED_BY, PROBSUMMARYM1.BRIEF_DESCRIPTION, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1' ;
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBSUMMARYM2 PROBSUMMARYM2 ON PROBSUMMARYM1.NUMBERPRGN = PROBSUMMARYM2.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE PROBSUMMARYM1.FLAG = ' || '''' || 't' || '''' || '';   
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.OPEN_GROUP', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(probsummarym2.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(probsummarym1.pfz_special_project,'|| '''' || ' ' || '''' ||')', pspecialflag) ||')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(probsummarym1.pfz_division,'|| '''' || ' ' || '''' ||')', pdivision) || ')';
		 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_PROJ_AGINGTICK;
END BIPKG_PROJ_AGINGTICK;
/


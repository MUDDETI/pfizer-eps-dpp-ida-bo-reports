CREATE OR REPLACE PACKAGE BIPKG_AGING_ANALYST AS
/******************************************************************************
   NAME:       BIPKG_AGING_ANALYST
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------
   1.0        09/07/2006    Rithesh         1.This tore procedure is to pass the parameter values to report 
                                              OpenTickets by Analyst Aging-sproc.rpt
************************************************************************************************************/

  TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_AGING_ANALYST (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2,
							 porig_group               IN       VARCHAR2,
							 panalyst                  IN       VARCHAR2
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  



END BIPKG_AGING_ANALYST ;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_AGING_ANALYST AS
/******************************************************************************
   NAME:       BIPKG_AGING_ANALYST
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------
   1.0        09/07/2006       Rithesh      1. This tore procedure is to pass the parameter values to report 
                                              OpenTickets by Analyst Aging-sproc.rpt
***************************************************************************************************************/

  PROCEDURE BIPKG_AGING_ANALYST(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        
       
        pfrequency              IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2, 		
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
		passignmentgroup         IN       VARCHAR2,
		porig_group              IN       VARCHAR2,
		panalyst                 IN       VARCHAR2
		
		
		
               
                        ) AS
						
		 				
	      v_select_stmt        VARCHAR2(32767); 
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
		  v_select_stmt := 'SELECT probsummarym1.numberprgn,probsummarym1.location, probsummarym1.pfz_full_name, probsummarym1.assignment,probsummarym1.flag, probsummarym1.brief_description, probsummarym1.assignee_name,probsummarym1.open_group, probsummarym1.last_activity, probsummarym1.pfz_rb_full_name, probsummarym1.vendor, probsummarym1.reference_no, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time,BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM probsummarym1 probsummarym1';
        v_select_stmt := v_select_stmt || ' WHERE probsummarym1.flag = ' || '''' || 't' || '''' || '';  
		v_select_stmt := v_select_stmt || ' AND(' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')'; 
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.open_group', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignee_name', panalyst) || ')';
         
		 
		 OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_AGING_ANALYST;         
END BIPKG_AGING_ANALYST;
/


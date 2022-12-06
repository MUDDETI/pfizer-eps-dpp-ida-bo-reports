CREATE OR REPLACE PACKAGE bipkg_inc_proj 
AS
/******************************************************************************
   NAME:       bipkg_inc_proj
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------
   1.0        08/16/2006   Rithesh Makkena     1.This store procedure are to pass the 
                                              parameters to the Project Incident Deatils Report
************************************************************************************************/

-- Public type declarations

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE bipkg_inc_proj (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             PFZ_SLA_TITLE             IN       VARCHAR2,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END bipkg_inc_proj;
/
CREATE OR REPLACE PACKAGE BODY bipkg_inc_proj 
AS
/******************************************************************************
   NAME:       bipkg_inc_proj
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------
   1.0        08/16/2006   Rithesh Makkena     1. 1.This store procedure are to pass the 
                                              parameters to the Project Incident Deatils Report
 
**************************************************************************************************/

---Procedure Implementation 
PROCEDURE bipkg_inc_proj(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        
        PFZ_SLA_TITLE            IN       VARCHAR2, 
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2, 		
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
		passignmentgroup         IN       VARCHAR2
		
		
		
               
                        ) AS
						
		 				
	      v_select_stmt        VARCHAR2(32767);
		  v_pfz_sla_title      VARCHAR2(40); 
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
		v_select_stmt :=  'SELECT probsummarym1.ASSIGNMENT,probsummarym1.BRIEF_DESCRIPTION,probsummarym1.ASSIGNEE_NAME,probsummarym1.LAST_ACTIVITY,probsummarym1.ACTION,probsummarym1.PFZ_SLA_TITLE,probsummarym1.STATUS,probsummarym1.FLAG,probsummarym1.NUMBERPRGN,probsummarym1.PFZ_FULL_NAME,BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.update_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') update_time, probsummarym1.update_action, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM probsummarym1';
		v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.assignment', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('probsummarym1.PFZ_SLA_TITLE', PFZ_SLA_TITLE) || ')';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 't' || '''' || '';                           
								                             

         OPEN select_calls_cursor FOR v_select_stmt;
  END bipkg_inc_proj;         
END bipkg_inc_proj;
/


CREATE OR REPLACE PACKAGE BIPKG_INC_RESPOND_SLA AS
/******************************************************************************
   NAME:       BIPKG_INC_RESPOND_SLA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------------------
   1.0        09/07/2006       Rithesh      1. CTo pass parmater values to report Respond SLA by Analyst-sproc.rpt
*********************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_RESPOND_SLA (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  



END BIPKG_INC_RESPOND_SLA ;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_RESPOND_SLA AS
/******************************************************************************
   NAME:       BIPKG_INC_RESPOND_SLA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------------------
   1.0        09/07/2006     Rithesh        1. To pass parmater values to report Respond SLA by Analyst-sproc.rpt
*********************************************************************************************************************/

  PROCEDURE BIPKG_INC_RESPOND_SLA(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        
       
        pfrequency               IN       VARCHAR2,
        poverride                IN       VARCHAR2, 
        pzone                    IN       VARCHAR2, 		
        pstartdate               IN       DATE,
        penddate                 IN       DATE,
		passignmentgroup         IN       VARCHAR2
		
		
		
               
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
		  ---v_pfz_sla_title      VARCHAR2(40);
          
          
         
  BEGIN          
  

v_db_zone := 'GMT';
	    
 
 bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT PROBSUMMARYM1.PFZ_RESPOND_SLA_GROUP, PROBSUMMARYM1.PFZ_SLA_TITLE, PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM2.PFZ_RESPOND_SLA_TIME, PROBSUMMARYM1.PFZ_FULL_NAME, PROBSUMMARYM1.PROBLEM_TYPE, PROBSUMMARYM1.PRODUCT_TYPE, PROBSUMMARYM1.BRIEF_DESCRIPTION,PROBSUMMARYM2.PFZ_RESPOND_SLA_USER,PROBSUMMARYM1.PFZ_RESPOND_SLA,BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, BIPKG_UTILS.BIFNC_AdjustForTZ(probsummarym1.open_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') open_time, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1';
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBSUMMARYM2 PROBSUMMARYM2 ON PROBSUMMARYM1.NUMBERPRGN = PROBSUMMARYM2.NUMBERPRGN';
        v_select_stmt := v_select_stmt || ' WHERE PROBSUMMARYM1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.close_time < ' || '''' || v_gmt_enddate || '''' ;  
		v_select_stmt := v_select_stmt || ' AND(' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.PFZ_RESPOND_SLA_GROUP', passignmentgroup) || ')'; 
		v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.PFZ_SLA_TITLE <> ' || '''' || 'Project' || '''' || '';     

         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_INC_RESPOND_SLA;         
END BIPKG_INC_RESPOND_SLA;
/


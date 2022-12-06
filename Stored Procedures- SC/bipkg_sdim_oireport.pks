CREATE OR REPLACE PACKAGE BIPKG_SDIM_OIReport AS
/******************************************************************************
   NAME:       BIPKG_SDIM_OIReport
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------
   1.0        09/29/2006      Rithesh       1. To return the values from store procedure to Report
                                               'OpenIncidentReport-sproc.rpt''
*******************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_SDIM_OIReport (select_calls_cursor   IN OUT   bisp_refcursor_type
                          
							 
                                  
     
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_SDIM_OIReport;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_SDIM_OIReport AS
/******************************************************************************
   NAME:       BIPKG_SDIM_OIReport
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------
   1.0        09/29/2006     Rithesh        1. To return the values from store procedure to Report
                                               'OpenIncidentReport-sproc.rpt''
**********************************************************************************************************/

PROCEDURE BIPKG_SDIM_OIReport(

	select_calls_cursor   IN OUT 	bisp_refcursor_type
        
       

		
		
		
		
               
                        ) AS
						
		 				
	    v_select_stmt        VARCHAR2(32767);
     
		  
          
          
         
  BEGIN          
  


        v_select_stmt := ' SELECT PROBSUMMARYM1.NUMBERPRGN, PROBSUMMARYM1.FLAG, PROBSUMMARYM1.ASSIGNMENT, PROBSUMMARYM1.PFZ_SLA_TITLE';
		v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1' ;
		v_select_stmt := v_select_stmt || ' WHERE probsummarym1.flag = ' || '''' || 't' || '''' || '';                           
		                 
								                             

         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_SDIM_OIReport;         
END BIPKG_SDIM_OIReport;
/


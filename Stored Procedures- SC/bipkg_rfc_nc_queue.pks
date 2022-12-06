CREATE OR REPLACE PACKAGE BIPKG_RFC_NC_QUEUE AS
/******************************************************************************
   NAME:       BIPKG_RFC_NC_QUEUE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ----------------------------------------------------------------
   1.0        09/25/2006     Rithesh        1.To pass the parameters to Report
                                             'All RFC's That Are Not Complete For A Given Queue-sproc.rpt'
***********************************************************************************************************/
 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_RFC_NC_QUEUE (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 assign_group 	           IN	   VARCHAR2
						
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_RFC_NC_QUEUE;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_RFC_NC_QUEUE AS
/******************************************************************************
   NAME:       BIPKG_RFC_NC_QUEUE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------
   1.0        09/25/2006     Rithesh        1. To pass the parameters to Report
                                              'All RFC's That Are Not Complete For A Given Queue-sproc.rpt'
****************************************************************************************************************/
		PROCEDURE BIPKG_RFC_NC_QUEUE(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 assign_group 	           IN	   VARCHAR2
						
							
							 
		
		
               
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
		v_select_stmt := 'SELECT CM3RM1.NUMBERPRGN,CM3RM1.PLANNED_START, CM3RM1.NETWORK_NAME, CM3RM1.PLANNED_END, CM3RM1.PRIORITY, CM3RM1.BRIEF_DESCRIPTION, CM3RM1.PFZ_ASSIGN_FULL_NAME, CM3RM1.ACTUAL_OUTAGE_START, CM3RM1.ASSIGN_DEPT, CM3RM1.ORIG_DATE_ENTERED, CM3RM1.APPROVAL_STATUS, CM3RM1.STATUS,  CM3RM1.PFZ_IMPL_TIME, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM CM3RM1 CM3RM1' ;
		--v_select_stmt := v_select_stmt || ' WHERE (' || bipkg_utils.BIFNC_createinlist ('NVL(CM3RM1.ASSIGN_DEPT,'|| '''' || ' ' || '''' ||')',assign_group) || ')';
		v_select_stmt := v_select_stmt || ' WHERE (' || bipkg_utils.BIFNC_createinlist ('CM3RM1.ASSIGN_DEPT',assign_group) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT(CM3RM1.STATUS = ' || '''' || 'Completed' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND CM3RM1.ORIG_DATE_ENTERED >= ' || '''' || v_gmt_startdate || '''' ;
		 
		 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_RFC_NC_QUEUE;
END BIPKG_RFC_NC_QUEUE;
/


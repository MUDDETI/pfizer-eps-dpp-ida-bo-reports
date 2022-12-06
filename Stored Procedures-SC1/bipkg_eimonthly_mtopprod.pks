CREATE OR REPLACE PACKAGE BIPKG_EIMONTHLY_MTOPPROD AS
/******************************************************************************
   NAME:       BIPKG_EIMONTHLY_MTOPPROD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------
   1.0        10/17/2006    Rithesh         1.This store procedure is to pass the parameter values to report
                                             'MainTopProductsbyTime-sproc.rpt' 
****************************************************************************************************************/


 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_EIMONTHLY_MTOPPROD (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
							 pproduct                  IN       VARCHAR2
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_EIMONTHLY_MTOPPROD;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_EIMONTHLY_MTOPPROD AS
/******************************************************************************
   NAME:       BIPKG_EIMONTHLY_MTOPPROD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------
   1.0        10/17/2006    Rithesh        1.This store procedure is to pass the parameter values to report
                                             'MainTopProductsbyTime-sproc.rpt' 
****************************************************************************************************************/

PROCEDURE BIPKG_EIMONTHLY_MTOPPROD(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
							 pproduct                  IN       VARCHAR2
							
							 
		
		
               
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
		v_select_stmt := 'SELECT INCIDENTSM1.PFZ_ORIG_GROUP, INCIDENTSM1.PRODUCT_TYPE, BIPKG_UTILS.BIFNC_AdjustForTZ(INCIDENTSM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME, INCIDENTSM1.INCIDENT_ID, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM INCIDENTSM1 INCIDENTSM1 ' ;
		v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PFZ_ORIG_GROUP', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND INCIDENTSM1.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND INCIDENTSM1.OPEN_TIME < ' || '''' || v_gmt_enddate || '''' ;
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('INCIDENTSM1.PRODUCT_TYPE', pproduct) || ')';
	 
		 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_EIMONTHLY_MTOPPROD;
END BIPKG_EIMONTHLY_MTOPPROD;
/


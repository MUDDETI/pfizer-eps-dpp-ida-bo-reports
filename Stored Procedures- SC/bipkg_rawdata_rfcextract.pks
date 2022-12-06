CREATE OR REPLACE PACKAGE BIPKG_RAWDATA_RFCEXTRACT AS
/******************************************************************************
   NAME:       BIPKG_RAWDATA_RFCEXTRACT  
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------
   1.0        10/19/2006   Rithesh         1.This store procedure is to pass the parameter values to report
                                            'RFC Extract-sproc.rpt' 
*************************************************************************************************************/

  TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_RAWDATA_RFCEXTRACT (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
			                 porig_group               IN       VARCHAR2,
							 pregion 	  	 	       IN       VARCHAR2, 
							 psite 			           IN       VARCHAR2, 
							 pstatus                   IN       VARCHAR2,
						     PReportType               IN       VARCHAR2,
							 CMLead                    IN       VARCHAR2
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_RAWDATA_RFCEXTRACT;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_RAWDATA_RFCEXTRACT AS
/******************************************************************************
   NAME:       BIPKG_RAWDATA_RFCEXTRACT 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------
   1.0        10/19/2006    Rithesh         1.This store procedure is to pass the parameter values to report
                                            'RFC Extract-sproc.rpt' 
***************************************************************************************************************/

  PROCEDURE BIPKG_RAWDATA_RFCEXTRACT(

	                       select_calls_cursor   IN OUT 	bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
			                 porig_group               IN       VARCHAR2,
							 pregion 	  	 	       IN       VARCHAR2, 
							 psite 			           IN       VARCHAR2, 
							 pstatus                   IN       VARCHAR2,
						     PReportType               IN       VARCHAR2,
							 CMLead                    IN       VARCHAR2
						
							 
		
		
               
                        ) AS
						
		 				
	      v_select_stmt          VARCHAR2(32767);
		  v_whereclause          VARCHAR2(32767);
          v_close_time           DATE;
		  v_startdatedisplay     VARCHAR2(50);
          v_enddatedisplay       VARCHAR2(50);
          v_db_zone              VARCHAR2(10);      
	      v_gmt_startdate        DATE;
          v_gmt_enddate          DATE;
		  
		  
          
   BEGIN          
  
        v_db_zone := 'GMT';	  
  	    bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT CM3RM1.NUMBERPRGN, CM3RM1.PFZ_OPEN_GROUP, CM3RM1.PFZ_REGION_ID, CM3RM1.PFZ_SITE_ID, CM3RM1.STATUS, CM3RM1.BRIEF_DESCRIPTION, BIPKG_UTILS.BIFNC_AdjustForTZ( CM3RM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME, CM3RM1.PFZ_SUPERVISOR_FULL_NAME, CM3RM1.PFZ_ASSIGN_FULL_NAME, BIPKG_UTILS.BIFNC_AdjustForTZ( CM3RM1.PLANNED_START,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_START, BIPKG_UTILS.BIFNC_AdjustForTZ( CM3RM1.PLANNED_END,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') PLANNED_END, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM CM3RM1 CM3RM1 ' ;
    	v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('CM3RM1.PFZ_REGION_ID', pregion) || ')';
	    v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('CM3RM1.PFZ_SITE_ID', psite) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('CM3RM1.PFZ_OPEN_GROUP', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('CM3RM1.STATUS',  pstatus ) || ')';
      if (PReportType = 'Aging')
		then
		    v_whereclause := ' AND NOT (CM3RM1.BRIEF_DESCRIPTION like  ' || '''' || 'TEMPLATE%' || '''' || ')'; 
			v_whereclause := v_whereclause || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('CM3RM1.PFZ_SUPERVISOR_FULL_NAME', CMLead ) || ')';
  elsif (PReportType = 'Closure')
		then
		    v_whereclause := ' AND CM3RM1.PLANNED_END < ' || '''' || v_gmt_enddate || '''';
		else
			v_whereclause := ' AND CM3RM1.PLANNED_START >= ' || '''' || v_gmt_startdate || '''' || 'AND CM3RM1.PLANNED_START < ' || '''' || v_gmt_enddate || '''' ;
		end if;
		v_select_stmt := v_select_stmt || v_whereclause ; 
		
		 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_RAWDATA_RFCEXTRACT;
END BIPKG_RAWDATA_RFCEXTRACT;
/


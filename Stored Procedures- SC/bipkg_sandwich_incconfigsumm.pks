CREATE OR REPLACE PACKAGE BIPKG_SANDWICH_INCCONFIGSUMM AS
/******************************************************************************
   NAME:       BIPKG_SANDWICHINCCONFIGSUMM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------
   1.0        10/31/2006    Rithesh         1.This store procedure is to pass the paramter values to report
                                              'Incidents by Configuration Summary-sproc.rpt' 
****************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_SANDWICH_INCCONFIGSUMM (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
			                 passignmentgroup          IN       VARCHAR2,
							 psite                     IN       VARCHAR2
						 
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_SANDWICH_INCCONFIGSUMM;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_SANDWICH_INCCONFIGSUMM AS
/******************************************************************************
   NAME:       BIPKG_SANDWICHINCCONFIGSUMM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------------
   1.0        10/31/2006   Rithesh          1.This store procedure is to pass the paramter values to report
                                              'Incidents by Configuration Summary-sproc.rpt' 
*************************************************************************************************************/


PROCEDURE BIPKG_SANDWICH_INCCONFIGSUMM(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
			                 passignmentgroup          IN       VARCHAR2,
							 psite                     IN       VARCHAR2
							
							 
		
		
               
                        ) AS
						
		 				
	      v_select_stmt        VARCHAR2(32767);
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
		v_select_stmt := 'SELECT psm1.NUMBERPRGN as Ticket,'||''''||'RESOLVE'|| ''''|| ' SLA_Type,psm1.ASSIGNMENT as Assignment,psm1.ASSIGNEE_NAME as Operator,om1.FULL_NAME as Assignee,BIPKG_UTILS.BIFNC_AdjustForTZ( psm1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME,BIPKG_UTILS.BIFNC_AdjustForTZ( psm1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME,psm1.FLAG as Flag,psm1.CLOSE_TIME as SLA_Time, psm1.PFZ_RESOLVE_SLA as MadeMissed,psm1.PFZ_SLA_TITLE as BusType,psm1.PFZ_FULL_NAME as Client,psm1.LOCATION as Location,dm1.PFZ_MANAGING_SITE as CI_Managing_Site,dm1.NETWORK_NAME as CI_Name,dm1.TYPE as Type,dm1.LOGICAL_NAME as CID, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 psm1 ' ;
        v_select_stmt := v_select_stmt || ' LEFT JOIN DEVICEM1 dm1 ON psm1.LOGICAL_NAME = dm1.LOGICAL_NAME ';
        v_select_stmt := v_select_stmt || ' LEFT JOIN OPERATORM1V om1 ON psm1.ASSIGNEE_NAME = om1.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('dm1.PFZ_MANAGING_SITE', psite) || ')';
        v_select_stmt := v_select_stmt || ' AND (psm1.FLAG =  ' || '''' || 'f' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND NOT (psm1.PFZ_SLA_TITLE =  ' || '''' || 'Project' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('psm1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND psm1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND psm1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;
		 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_SANDWICH_INCCONFIGSUMM;
END BIPKG_SANDWICH_INCCONFIGSUMM;
/


CREATE OR REPLACE PACKAGE BIPKG_SLA_OPENSUMM_AA AS
/******************************************************************************
   NAME:       BIPKG_SLA_OPENSUMM_AA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------
   1.0        09/27/2006   Rithesh          1.To pass the parameter values to Report
                                             'SLA Open Summary by Assignment-Assignee-sproc.rpt'
****************************************************************************************************/
 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_SLA_OPENSUMM_AA (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_SLA_OPENSUMM_AA;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_SLA_OPENSUMM_AA AS
/******************************************************************************
   NAME:       BIPKG_SLA_OPENSUMM_AA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------
   1.0        09/27/2006     Rithesh        1.To pass the parameter values to Report
                                             'SLA Open Summary by Assignment-Assignee-sproc.rpt'
*****************************************************************************************************/

PROCEDURE BIPKG_SLA_OPENSUMM_AA(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
							 
							 
							
							 
		
		
               
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
		v_select_stmt := ' SELECT  '||''''||'RESPOND'|| ''''|| ' SLA_Type, PROBSUMMARYM1.NUMBERPRGN Ticket,PROBSUMMARYM1.ASSIGNEE_NAME Assignee,PROBSUMMARYM1.PFZ_RESPOND_SLA MadeMissed,PROBSUMMARYM1.PFZ_SLA_TITLE BusType, bipkg_utils.bifnc_AdjustForTZ(pfz_respond_sla_time,'|| ''''|| v_db_zone || ''''|| ','|| ''''||  pzone || ''''|| ') pfz_sla_time,';
        v_select_stmt := v_select_stmt || ' PROBSUMMARYM1.ASSIGNMENT,OPERATORM1V.FULL_NAME,BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' ||  pzone  || '''' || ') OPEN_TIME ,BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' ||  pzone  || '''' || ') CLOSE_TIME ,	PROBSUMMARYM1.FLAG	,' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		-- v_select_stmt := 'SELECT PROBSUMMARYM1.NUMBERPRGN  ,PROBSUMMARYM1.ASSIGNMENT,PROBSUMMARYM1.ASSIGNEE_NAME,OPERATORM1V.FULL_NAME ,BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME ,BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, PROBSUMMARYM1.FLAG, PROBSUMMARYM2.PFZ_RESPOND_SLA_TIME, PROBSUMMARYM1.PFZ_RESPOND_SLA, PROBSUMMARYM1.PFZ_SLA_TITLE, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1' ;
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN  PROBSUMMARYM2 PROBSUMMARYM2 ON PROBSUMMARYM1.NUMBERPRGN = PROBSUMMARYM2.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN OPERATORM1V OPERATORM1V ON PROBSUMMARYM2.PFZ_RESPOND_SLA_USER = OPERATORM1V.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND NOT(PROBSUMMARYM1.FLAG = ' || '''' || 'f' || '''' || ')';
        v_select_stmt := v_select_stmt || ' AND NOT(PROBSUMMARYM1.PFZ_SLA_TITLE = ' || '''' || 'Project' || '''' || ')';
	   	v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.OPEN_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.OPEN_TIME < ' || '''' || v_gmt_enddate || '''' ;
		
		
		OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_SLA_OPENSUMM_AA;
END BIPKG_SLA_OPENSUMM_AA;
/


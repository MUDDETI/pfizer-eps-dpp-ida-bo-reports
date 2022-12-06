CREATE OR REPLACE PACKAGE BIPKG_INC_REJ_TCKTS AS

   
TYPE bisp_refcursor_type IS REF CURSOR;

/******************************************************************************
   NAME:       BIPKG_INC_REJ_TCKTS 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------------
   1.0        09/20/2006    S.Westgate          1. Created this package. This stored procedure is to pass parameters to
                                             report ''Rejected Incident Tickets-sproc.rpt'
*********************************************************************************************************************/

   PROCEDURE BIPKG_INC_REJ_TCKTS (
      select_inc_rej_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
      pproject			  IN	   VARCHAR2,
	  pdivision			  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE

   );
END BIPKG_INC_REJ_TCKTS;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_REJ_TCKTS AS

   

/******************************************************************************
   NAME:       BIPKG_INC_REJ_TCKTS 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------------
   1.0        09/20/2006    S.Westgate          1. Created this package. This stored procedure is to pass parameters to
                                             report ''Rejected Incident Tickets-sproc.rpt'
	1.1		12/01/06		S. Westgate		 Add Division and Project Parameters.										 
*********************************************************************************************************************/

   PROCEDURE BIPKG_INC_REJ_TCKTS (
      select_inc_rej_cursor   IN OUT   bisp_refcursor_type,
      passignmentgroup    IN       VARCHAR2,
      porig_group         IN       VARCHAR2,
      pproject			  IN	   VARCHAR2,
	  pdivision			  IN	   VARCHAR2,
      pfrequency          IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE

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
  		v_select_stmt := 'SELECT PROBLEMM1.ASSIGNMENT, PROBLEMM1.PFZ_REJECTED, PROBLEMM1.NUMBERPRGN, PROBLEMM1.PFZ_LAST_ASSIGNMENT, ';
		v_select_stmt := v_select_stmt || 'PROBLEMM1.PAGE, PROBLEMM1.UPDATED_BY, PROBLEMM1.SYSMODUSER, PROBLEMM1.TICKET_OWNER, ';
		v_select_stmt := v_select_stmt || 'PROBLEMM1.PRODUCT_TYPE, PROBLEMM1.BRIEF_DESCRIPTION,PROBLEMM1.FLAG, ';
        v_select_stmt := v_select_stmt || 'OPERATORM1V.FULL_NAME, PROBSUMMARYM2.PFZ_RELATED_PROJECTS, PROBSUMMARYM1.PFZ_DIVISION, '; 
        v_select_stmt := v_select_stmt || 'PROBSUMMARYM1.OPEN_GROUP, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.close_time,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') close_time, ';
		v_select_stmt := v_select_stmt || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay'; 
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1';
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBSUMMARYM2 PROBSUMMARYM2 ON PROBSUMMARYM1.NUMBERPRGN = PROBSUMMARYM2.NUMBERPRGN ';
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBLEMM1 PROBLEMM1 ON PROBSUMMARYM1.NUMBERPRGN = PROBLEMM1.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN OPERATORM1V OPERATORM1V ON PROBLEMM1.TICKET_OWNER = OPERATORM1V.NAME ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('PROBLEMM1.ASSIGNMENT', passignmentgroup) || ')'; 	
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBLEMM1.PFZ_LAST_ASSIGNMENT', porig_group ) || ')'; 						
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBSUMMARYM1.OPEN_GROUP', porig_group ) || ')'; 						
    	v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(PROBSUMMARYM1.PFZ_DIVISION,'|| '''' || ' ' || '''' ||')', pdivision) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('NVL(PROBSUMMARYM2.PFZ_RELATED_PROJECTS,'|| '''' || ' ' || '''' ||')', pproject) ||')';		
        v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.close_time >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.close_time < ' || '''' || v_gmt_enddate || '''' ;  
		v_select_stmt := v_select_stmt || ' AND PROBLEMM1.UPDATED_BY <> ' || '''' || 'problem' || '''' || '';
		v_select_stmt := v_select_stmt || ' AND probsummarym1.flag = ' || '''' || 'f' || '''' || ''; 
		
         OPEN select_inc_rej_cursor FOR v_select_stmt;

  END BIPKG_INC_REJ_TCKTS;
END BIPKG_INC_REJ_TCKTS;
/

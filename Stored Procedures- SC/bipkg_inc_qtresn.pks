CREATE OR REPLACE PACKAGE BIPKG_INC_QTRESN AS
/******************************************************************************
   NAME:       BIPKG_INC_QTRESN
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -------------------------------------------------------------------
   1.0        10/02/2006    Rithesh        1.This store procedure is to pass the parameter values to report
                                             ' Queues to Ticket Resolution-sproc.rpt' 
*************************************************************************************************************/


 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BISP_SELECT_AVGAQUE_RES (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
	                        
						
						   );
   
PROCEDURE BISP_SELECT_AVGAQUE1_RES1 (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 pnumberprgn               IN       VARCHAR2,
							 pnumberprgn1              IN       VARCHAR2,
							 pnumberprgn2              IN       VARCHAR2,
							 pnumberprgn3              IN       VARCHAR2,
							 pnumberprgn4              IN       VARCHAR2,
							 passignmentgroup          IN       VARCHAR2
					   );
END BIPKG_INC_QTRESN;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_QTRESN AS
/******************************************************************************
   NAME:       BIPKG_INC_QTRESN
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/02/2006    Rithesh         1.This store procedure is to pass the parameter values to report
                                             ' Queues to Ticket Resolution-sproc.rpt' 
******************************************************************************/


PROCEDURE BISP_SELECT_AVGAQUE_RES (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                            
							 pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);
   BEGIN
   v_db_zone := 'GMT';	  
  	    bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := ' SELECT PROBSUMMARYM1.NUMBERPRGN,PROBSUMMARYM1.COUNTPRGN, BIPKG_UTILS.BIFNC_AdjustForTZ( PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, PROBLEMM1.ASSIGNMENT, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1' ;
		v_select_stmt := v_select_stmt || ' INNER JOIN PROBLEMM1 PROBLEMM1 ON PROBSUMMARYM1.NUMBERPRGN = PROBLEMM1.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('PROBLEMM1.ASSIGNMENT', passignmentgroup) || ')';
		v_select_stmt := v_select_stmt || ' AND PROBSUMMARYM1.CLOSE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBSUMMARYM1.CLOSE_TIME < ' || '''' || v_gmt_enddate || '''' ;
		
   
		OPEN select_calls_cursor  FOR v_select_stmt ;
   END BISP_SELECT_AVGAQUE_RES;
   
  
  
   
   
PROCEDURE BISP_SELECT_AVGAQUE1_RES1 (
select_calls_cursor   IN OUT   bisp_refcursor_type,
                             
							 pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 pnumberprgn               IN       VARCHAR2,
							 pnumberprgn1              IN       VARCHAR2,
							 pnumberprgn2              IN       VARCHAR2,
							 pnumberprgn3              IN       VARCHAR2,
							 pnumberprgn4              IN       VARCHAR2,
							 passignmentgroup          IN       VARCHAR2
   
   )
   AS
      v_startdatedisplay   VARCHAR(50);
      v_enddatedisplay     VARCHAR(50);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2 (32767);

   BEGIN
   
        v_db_zone := 'GMT';	  
  	    bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT PROBSUMMARYM1.COUNTPRGN, PROBSUMMARYM1.NUMBERPRGN, PROBLEMM1.ASSIGNMENT, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBSUMMARYM1.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME, PROBSUMMARYM1.ASSIGNMENT, PROBLEMM1.PAGE, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBSUMMARYM1 PROBSUMMARYM1' ;
        v_select_stmt := v_select_stmt || ' INNER JOIN PROBLEMM1 PROBLEMM1 ON PROBSUMMARYM1.NUMBERPRGN = PROBLEMM1.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('PROBLEMM1.ASSIGNMENT', passignmentgroup) || ')';
	    v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS .BIFNC_createinlist ('PROBSUMMARYM1.NUMBERPRGN', pnumberprgn) || ')' || ' OR (' || BIPKG_UTILS .BIFNC_createinlist ('PROBSUMMARYM1.NUMBERPRGN', pnumberprgn1) || ')'|| ' OR (' || BIPKG_UTILS .BIFNC_createinlist ('PROBSUMMARYM1.NUMBERPRGN', pnumberprgn2) || ')'|| ' OR (' || BIPKG_UTILS .BIFNC_createinlist ('PROBSUMMARYM1.NUMBERPRGN', pnumberprgn3) || ')' || ' OR (' || BIPKG_UTILS .BIFNC_createinlist ('PROBSUMMARYM1.NUMBERPRGN', pnumberprgn4)|| ')';
								                 
		 OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_AVGAQUE1_RES1;


END  BIPKG_INC_QTRESN;
/


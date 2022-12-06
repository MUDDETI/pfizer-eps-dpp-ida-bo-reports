CREATE OR REPLACE PACKAGE BIPKG_INC_IQ_MOTG AS
/******************************************************************************
   NAME:       BIPKG_INC_IQ_MOTG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------
   1.0        11/09/2006      Rithesh       1. This store procedure is to pass the parameter values to report
                                              'Incident Queue Monitoring-sproc.rpt' 
****************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_INC_IQ_MOTG (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
            
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2,
							 pmmgroup                  IN       VARCHAR2,
							 pmgroup                   IN       VARCHAR2
						   
						
							 
							
							 
							 
							 
							 
							 
							 
                             );
  
  


END BIPKG_INC_IQ_MOTG;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_INC_IQ_MOTG AS
/******************************************************************************
   NAME:       BIPKG_INC_IQ_MOTG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------------
   1.0        11/09/2006     Rithesh        1. This store procedure is to pass the parameter values to report
                                              'Incident Queue Monitoring-sproc.rpt' 
******************************************************************************************************************/

PROCEDURE BIPKG_INC_IQ_MOTG(

	select_calls_cursor   IN OUT 	bisp_refcursor_type,
        

                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 passignmentgroup          IN       VARCHAR2,
							 pmmgroup                  IN       VARCHAR2,
							 pmgroup                   IN       VARCHAR2
						
						
							
							 
		
		
               
                        ) AS
						
		 				
	      v_select_stmt        VARCHAR2(32767);
          v_close_time          DATE;
		  v_startdatedisplay   VARCHAR2(50);
          v_enddatedisplay     VARCHAR2(50);
          v_db_zone            VARCHAR2(10);      
	      v_gmt_startdate      DATE;
          v_gmt_enddate        DATE;
		  v_whereclause		   VARCHAR2(32767); 
		  
		  
          
   BEGIN          
  
        v_db_zone := 'GMT';	  
  	    bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
	    v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_select_stmt := 'SELECT PROBLEMM1.NUMBERPRGN, PROBLEMM1.ASSIGNMENT,PROBLEMM1.PAGE, PROBLEMM1.BRIEF_DESCRIPTION,PROBLEMM1.OPENED_BY, PROBSUMMARYM1.OPEN_GROUP,OPERATORM1V.NAME, BIPKG_UTILS.BIFNC_AdjustForTZ(PROBLEMM1.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME ,PROBLEMM1.UPDATED_BY, OPERATORM1V.FULL_NAME, PROBLEMM1.TIME_SPENT, PROBLEMM1.LAST_ACTIVITY,BIPKG_UTILS.BIFNC_AdjustForTZ(PROBLEMM1.PREV_UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ')PREV_UPDATE_TIME, ASSIGNMENTA1.NAME, PROBSUMMARYM1.PFZ_RB_FULL_NAME, PROBLEMM1.PRODUCT_TYPE, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM PROBLEMM1 PROBLEMM1' ;
        v_select_stmt := v_select_stmt || ' INNER JOIN PROBSUMMARYM1 PROBSUMMARYM1 ON PROBLEMM1.NUMBERPRGN = PROBSUMMARYM1.NUMBERPRGN ';
        v_select_stmt := v_select_stmt || ' INNER JOIN OPERATORM1V OPERATORM1V ON PROBLEMM1.UPDATED_BY = OPERATORM1V.NAME ';
        v_select_stmt := v_select_stmt || ' INNER JOIN ASSIGNMENTA1 ASSIGNMENTA1 ON PROBLEMM1.UPDATED_BY = ASSIGNMENTA1.OPERATORS ';
        v_select_stmt := v_select_stmt || ' WHERE (PROBLEMM1.UPDATE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND PROBLEMM1.UPDATE_TIME < ' || '''' || v_gmt_enddate || ''')' ;
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('ASSIGNMENTA1.NAME', pmgroup) ||')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('PROBLEMM1.ASSIGNMENT', passignmentgroup) || ')';
          
				  if NOT ( pmmgroup = 'Y')
		then 
		v_whereclause :=  ' AND NOT (' || BIPKG_UTILS.BIFNC_createinlist ('PROBLEMM1.ASSIGNMENT', pmgroup) || ')';
        v_whereclause :=  ' AND PROBLEMM1.UPDATED_BY = OPERATORM1V.NAME ';
	    end if;
		v_select_stmt := v_select_stmt || v_whereclause ;

			
		 
		 OPEN select_calls_cursor FOR v_select_stmt;
	END BIPKG_INC_IQ_MOTG;
END BIPKG_INC_IQ_MOTG;
/


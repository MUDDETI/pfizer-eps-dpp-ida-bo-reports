CREATE OR REPLACE PACKAGE BIPKG_EIMONTHLY_PBHDT AS
/******************************************************************************
   NAME:       BIPKG_EIMONTHLY_PBHDT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------------
   1.0        10/16/2006    Rithesh        1.This store procedure is to pass the parameter values to the report
                                            'Product-Based Help Desk Tickets.-sproc1rpt.rpt'
***********************************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BISP_SELECT_PRODUCTTREND (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         pproduct 		           IN		VARCHAR2
						
						   );
   
PROCEDURE BISP_SELECT_PRODUCTTREND01 (select_calls_cursor   IN OUT   bisp_refcursor_type,
                          
							 
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
							 pproduct                  IN       VARCHAR2
					   );
END BIPKG_EIMONTHLY_PBHDT;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_EIMONTHLY_PBHDT AS
/******************************************************************************
   NAME:       BIPKG_EIMONTHLY_PBHDT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  --------------------------------------------------------------------------
   1.0        10/16/2006  Rithesh           1.This store procedure is to pass the parameter values to the report
                                            'Product-Based Help Desk Tickets.-sproc1rpt.rpt'
********************************************************************************************************************/

PROCEDURE BISP_SELECT_PRODUCTTREND (
      select_calls_cursor    IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
	                         pproduct 		           IN		VARCHAR2
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
		v_select_stmt := 'SELECT ALLTICKETS_VW.TICKET, ALLTICKETS_VW.OPENTIME, BIPKG_UTILS.BIFNC_AdjustForTZ(ALLTICKETS_VW.OPENTIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPENTIME, ALLTICKETS_VW.ORIGGROUP, ALLTICKETS_VW.PROBLEM, ALLTICKETS_VW.PRODUCT, ALLTICKETS_VW.PRIORITY, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM ALLTICKETS_VW ALLTICKETS_VW ' ;
	    v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('ALLTICKETS_VW.ORIGGROUP', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('ALLTICKETS_VW.PRODUCT', pproduct) || ')';
		v_select_stmt := v_select_stmt || ' AND (ALLTICKETS_VW.PROBLEM like  ' || '''' || '%IRMAC' || '''' || ')'; 
		v_select_stmt := v_select_stmt || ' AND ALLTICKETS_VW.OPENTIME >= ' || '''' || v_gmt_startdate || '''' || 'AND ALLTICKETS_VW.OPENTIME < ' || '''' || v_gmt_enddate || '''' ;
		v_select_stmt := v_select_stmt || ' AND NOT(ALLTICKETS_VW.PRIORITY =  ' || '''' || 'Project' || '''' || ')';
	
		OPEN select_calls_cursor  FOR v_select_stmt ;
   END BISP_SELECT_PRODUCTTREND;
   
   
   
PROCEDURE BISP_SELECT_PRODUCTTREND01(
select_calls_cursor   IN OUT   bisp_refcursor_type,
                             pfrequency                IN       VARCHAR2,
                             poverride                 IN       VARCHAR2,
                             pzone                     IN       VARCHAR2,
                             pstartdate                IN       DATE,
                             penddate                  IN       DATE,
							 porig_group               IN       VARCHAR2,
							 pproduct                  IN       VARCHAR2
   )
   IS
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
		v_select_stmt := 'SELECT ALLTICKETS_VW.TICKET, ALLTICKETS_VW.OPENTIME, BIPKG_UTILS.BIFNC_AdjustForTZ(ALLTICKETS_VW.OPENTIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPENTIME, ALLTICKETS_VW.ORIGGROUP, ALLTICKETS_VW.PROBLEM, ALLTICKETS_VW.PRODUCT, ALLTICKETS_VW.PRIORITY, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
        v_select_stmt := v_select_stmt || ' FROM ALLTICKETS_VW ALLTICKETS_VW ' ;
	    v_select_stmt := v_select_stmt || ' WHERE (' || BIPKG_UTILS.BIFNC_createinlist ('ALLTICKETS_VW.PRODUCT', pproduct) || ')';
		v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('ALLTICKETS_VW.ORIGGROUP', porig_group) || ')';
		v_select_stmt := v_select_stmt || ' AND NOT (ALLTICKETS_VW .PROBLEM LIKE ' || '''' || '%IRMAC' || '''' || ' OR ALLTICKETS_VW.PROBLEM LIKE ' || '''' || 'PROJECT REQUEST' || '''' || ')'; 
		v_select_stmt := v_select_stmt || ' AND NOT(ALLTICKETS_VW.PRIORITY =  ' || '''' || 'Project' || '''' || ')';
		v_select_stmt := v_select_stmt || ' AND ALLTICKETS_VW.OPENTIME >= ' || '''' || v_gmt_startdate || '''' || 'AND ALLTICKETS_VW.OPENTIME < ' || '''' || v_gmt_enddate || '''' ;
 
    OPEN select_calls_cursor  FOR v_select_stmt;
   END BISP_SELECT_PRODUCTTREND01;


END BIPKG_EIMONTHLY_PBHDT;
/


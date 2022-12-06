/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE bipkg_REPORTM1
AS
   TYPE bisp_refcursor_type IS REF CURSOR;

   PROCEDURE bisp_select_REPORTM1 (
      select_calls_cursor IN OUT   bisp_refcursor_type,
       pfrequency         IN      VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
    
   );
   
END bipkg_REPORTM1;
/
/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE BODY bipkg_REPORTM1
AS
/******************************************************************************
   NAME:       bisp_select_REPORTM1 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
    1.0		   05/25/2006 		-SHW-		   1. Created bisp_select_REPORTM1  
			   								   (Allows 'dummy' main reports to compute
											   display start-end dates).
    
******************************************************************************/
--
-- Error Handling is done by the report. We do not trap any exceptions at the Database side.
--
   PROCEDURE bisp_select_REPORTM1 (
      select_calls_cursor IN OUT   bisp_refcursor_type,
       pfrequency         IN       VARCHAR2,
      poverride           IN       VARCHAR2,
      pzone               IN       VARCHAR2,
      pstartdate          IN       DATE,
      penddate            IN       DATE
      
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
		v_startdatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_enddatedisplay := TO_CHAR(BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone), 'DD-MM-YYYY HH24:MI:SS');
		v_select_stmt := 'SELECT 1 reportnumber, ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay , ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay';
		v_select_stmt := v_select_stmt || ' FROM DUAL PFZREPORTM1';      
		OPEN select_calls_cursor FOR v_select_stmt ;
   END bisp_select_REPORTM1;
END bipkg_REPORTM1;
/

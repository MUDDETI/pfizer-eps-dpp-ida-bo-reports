CREATE OR REPLACE PACKAGE BIPKG_CREATE_HP_CDB_DATA AS
/******************************************************************************
   NAME:       BIPKG_CREATE_HP_CDB_DATA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/19/2008    shw             1.Create Recordset for HP CDB Table.
   1.1        11/24/2008    shw             1. restrict to TYPE - SERVER 
******************************************************************************/

  TYPE rc IS REF CURSOR;

  PROCEDURE CREATE_SC_HP_DATA(c1 IN OUT rc);

END BIPKG_CREATE_HP_CDB_DATA;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_CREATE_HP_CDB_DATA AS
/******************************************************************************
   NAME:       BIPKG_CREATE_HP_CDB_DATA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/19/2008    shw             1.Create Recordset for HP CDB Table.
   1.1        11/24/2008    shw             1. restrict to TYPE - SERVER 
******************************************************************************/

  PROCEDURE CREATE_SC_HP_DATA(c1 IN OUT rc)
   IS
      v_select_stmt		   VARCHAR2 (32767);
  
  Begin

	  v_select_stmt :=
   'SELECT' 
    ||' DEVICEM1.NETWORK_NAME,'
    ||' DEVICEM1.PFZ_ESC_PRIORITY,'  
    ||' DEVICEM1.PFZ_ASSIGNMENT,' 
    ||' DEVICEM1.ISTATUS,' 
    ||' DEVICEM1.SUBTYPE,' 
    ||' DEVICEM1.OPERATING_SYSTEM,' 
    ||' DEVICEM1.PFZ_MANAGING_SITE,' 
    ||' ASSIGNMENTM1.PFZ_REPORTING_GROUP,' 
    ||' ASSIGNMENTM1.PFZ_VENDOR,' 
    ||' ASSIGNMENTM1.PFZ_SERVICE_TOWER'
    ||' FROM   SC.DEVICEM1 DEVICEM1' 
    ||' INNER JOIN SC.ASSIGNMENTM1 ASSIGNMENTM1 ON DEVICEM1.PFZ_ASSIGNMENT=ASSIGNMENTM1.NAME'
	||' WHERE DEVICEM1.TYPE = (''' || 'SERVER' || ''')'
	  ;
     open c1 for v_select_stmt ;

  End CREATE_SC_HP_DATA;

END BIPKG_CREATE_HP_CDB_DATA;
/

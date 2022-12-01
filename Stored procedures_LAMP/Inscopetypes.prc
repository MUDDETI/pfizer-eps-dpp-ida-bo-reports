CREATE OR REPLACE FUNCTION SCCICT_OWNER.InScope_SubType (
	  pType							 IN		  VARCHAR2,
	  pSubType						 IN		  VARCHAR2
) RETURN CHAR IS
vType	 VARCHAR2(100);
vSubType			   VARCHAR2(100);
v_InScope_SubType CHAR;
/******************************************************************************
   NAME:       InScope_SubType
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        02/14/2007   SG       1. Created this function.

   NOTES:

******************************************************************************/
BEGIN

--Initialization
vType := NVL(pType, ' ');
vSubType := NVL(pSubType, ' ');
v_InScope_SubType := 'F';

IF vType = 'NETWORK' THEN
   IF vSubType IN ('SWITCH', 'ROUTER', 'CHECKPOINT', 'HUB', 'ACCESS SERVER', 'APPLIANCE', 'CONTROLLER', 'GLOBAL LOAD BALANCER', 'PROBE ANALYZER') 
   THEN v_InScope_SubType := 'T';
   END IF;
ELSIF vType = 'SERVER' THEN
   IF vSubType IN ('PHYSICAL') 
   THEN v_InScope_SubType := 'T';
   END IF;
ELSIF vType = 'STORAGE' THEN
   IF vSubType IN ('CONTROLLER', 'NAS CONTROLLER', 'NAS FILE SERVER', 'SAN SWITCH', 'STORAGE ARRAY', 'STORAGE UNIT', 'TAPE DRIVE', 'TAPE SILO')
   THEN v_InScope_SubType := 'T';
   END IF;
ELSIF vType = 'PERSONAL COMPUTER' THEN
   IF vSubType IN ('DESKTOP', 'LAPTOP', 'WORKSTATION', 'TABLET', 'TABLET PC') 
   THEN v_InScope_SubType := 'T';
   END IF;   
END IF;

	RETURN v_InScope_SubType;
END InScope_SubType;
/
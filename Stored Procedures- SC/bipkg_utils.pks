CREATE OR REPLACE PACKAGE BIPKG_UTILS AS
/******************************************************************************
   NAME:       BIPKG_UTILS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        5/15/2006   SRR          	   Utility package - holds all common functions and procedures
   			  			  				   to be used by Crystal reports.
    2.0       03/24/2009    SHW             change (BIFNC_createNonCSVinlist) to isolate single-quote values.                                            
******************************************************************************/

  TYPE rc IS REF CURSOR;

  FUNCTION   BIFNC_AdjustForTZ(dtIn date, fromTZ varchar2, toTZ varchar2) RETURN date;
  FUNCTION	 BIFNC_createNonCSVinlist(infield VARCHAR2, inlov VARCHAR2, inchar VARCHAR2) RETURN VARCHAR2;
  FUNCTION   BIFNC_createinlist (infield VARCHAR2, inlov VARCHAR2) RETURN VARCHAR2;
  FUNCTION   BIFNC_GetTZNamefromCrystal (tzName varchar2) RETURN varchar2;

  -- Procedure accepting 2 date values and return a string statement witht the proper between statement:
  -- incolumn between to_date(to_char....
  FUNCTION  BIFNC_DATESBETWEEN(incolumn IN varchar2, date1 IN DATE, date2 IN DATE) RETURN VARCHAR2;

  PROCEDURE  BISP_GetStartAndEndDates(frequency IN varchar2, override IN number, tzone IN varchar2,
                                     instdate IN date, inenddate IN date, stdate OUT date, eddate OUT date);
  PROCEDURE  BISP_CRTIMEZONES(c1 IN OUT rc);

  PROCEDURE  BISP_MainRptTrigger(
  			 c1			 IN OUT rc,
			 pstartdate  IN       TIMESTAMP,
			 penddate    IN       TIMESTAMP,
			 pzone		 IN		  VARCHAR2,
			 pfrequency	 IN		  VARCHAR2,
			 poverride	 IN		  VARCHAR2
			 );

  PROCEDURE  BISP_ListOfFrequencies(
  			 c1			 IN OUT rc
			 );


END BIPKG_UTILS;
/
CREATE OR REPLACE PACKAGE BODY BIPKG_UTILS AS
/******************************************************************************
   NAME:       BIPKG_UTILS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        5/15/2006   SRR          	   Utility package - holds all common functions and procedures
   			  			  				   to be used by Crystal reports.
    2.0       03/24/2009    SHW             change (BIFNC_createNonCSVinlist) to isolate single-quote values.                                            
******************************************************************************/
--
-- Error Handling is done by the report. We do not trap any exceptions at the Database side.
--
FUNCTION bifnc_AdjustForTZ(dtIn date, fromTZ varchar2, toTZ varchar2)
RETURN date IS

tzoDT  		date := dtIn;
tmpfromTZ	varchar2(30);
tmptoTZ		varchar2(30);

/******************************************************************************
   NAME:       bifnc_AdjustForTZ
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/08/2006          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     AdjustForTZ
      Sysdate:         05/08/2006
      Date and Time:   05/08/2006, 10:54:01 AM, and 05/08/2006 10:54:01 AM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/


BEGIN

   tmpfromTZ := bifnc_GetTZNamefromCrystal(fromTZ);
   tmptoTZ := bifnc_GetTZNamefromCrystal(toTZ);
   tzoDT := from_tz(cast(dtIn as timestamp),tmpfromTZ) at time zone tmptoTz;

   RETURN tzoDT;

   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END bifnc_AdjustForTZ;
--
/******************************************************************************
   NAME:       bifnc_createNonCSVinlist
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/08/2006                    1. Created this function.
   1.1		  07.17.06		shw	  	        1. Increased variable size limits (2000 to 6000)
    2.0       03/24/2009    SHW             change (BIFNC_createNonCSVinlist) to isolate single-quote values. 
******************************************************************************/

FUNCTION BIFNC_createNonCSVinlist(infield VARCHAR2, inlov VARCHAR2, inchar VARCHAR2) RETURN VARCHAR2 is
   outclause     VARCHAR2 (6000);
   wildcharpos   NUMBER (4);
   intemp        VARCHAR2 (6000);
   curpos		 number(4);
   squotecharpos NUMBER (4);
   singlequote   VARCHAR (4);
BEGIN
   outclause := infield;
   intemp := inlov;
   
   -- check if any of the input list has an * or % 
   wildcharpos := INSTR (inlov, '*');
   if nvl(wildcharpos,0) = 0
   then
      wildcharpos := INSTR (inlov, '%');
   end if;

-- 03.25.09-shw-    
   ---------------------------------------------------------
   -- check if any of the input values has a single quote (') 
   singlequote := chr(39);      -- single quote character 
      -- Replace all 'single quotes with two single quotes in the input list of values.
      select replace(inlov, singlequote, '''''')
	  into intemp
	  from dual;
   ---------------------------------------------------------

   IF (wildcharpos = 0)                                      -- no wild cards
   THEN
      outclause := outclause || ' in ('; -- Begin the list of values as list in ( ...)
      LOOP
         curpos := INSTR (intemp, inchar);  -- Check where the first parameter ends
		 if curpos > 0  -- More than one parameter; need to put commas in the list
		 then
		    outclause := outclause||''''||trim(SUBSTR (intemp, 1, curpos - 1))|| ''''||','; -- enclose each value in quotes
		 else
		    outclause := outclause||''''||trim(intemp)|| ''''||')'; -- The last or only parameter; close the bracket
		 end if;
		  EXIT WHEN nvl(curpos,0) = 0; -- Exit when we have no more parameters
		 intemp := SUBSTR (intemp, nvl(curpos,0) + 1, LENGTH (intemp)); -- holding area with remaining parameters.
      END LOOP;
      RETURN outclause;
   ELSE -- wild card exists
      -- Replace all '*' with % in the input list of values.
      select replace(inlov, '*', '%')
	  into intemp
	  from dual;
	  outclause := '';
	  LOOP
         outclause :=  outclause||inField || ' like ';
         curpos := INSTR (intemp, ',');  -- Check where the first parameter ends
		 if curpos > 0  -- More than one parameter; need to put commas in the list
		 then
		    outclause := outclause||''''||trim(SUBSTR (intemp, 1, curpos - 1))|| ''''||' OR '; -- enclose each value in quotes
		 else
		    outclause := outclause||''''||trim(intemp)|| ''''; -- The last or only parameter; close the bracket
		 end if;
		  EXIT WHEN nvl(curpos,0) = 0; -- Exit when we have no more parameters
		 intemp := SUBSTR (intemp, nvl(curpos,0) + 1, LENGTH (intemp)); -- holding area with remaining parameters.
      END LOOP;
	  RETURN outclause;
   END IF;
END BIFNC_createNonCSVinlist;

--

FUNCTION BIFNC_createinlist (infield VARCHAR2, inlov VARCHAR2)
RETURN VARCHAR2
IS
   outclause     VARCHAR2 (6000);
--    wildcharpos   NUMBER (4);
--    intemp        VARCHAR2 (2000);
--    curpos		 number(4);
BEGIN
--    outclause := infield;
--    intemp := inlov;
--    -- check if any of the input list has an * or %
--    wildcharpos := INSTR (inlov, '*');
--    if nvl(wildcharpos,0) = 0
--    then
--       wildcharpos := INSTR (inlov, '%');
--    end if;
--
--    IF (wildcharpos = 0)                                      -- no wild cards
--    THEN
--       outclause := outclause || ' in ('; -- Begin the list of values as list in ( ...)
--       LOOP
--          curpos := INSTR (intemp, ',');  -- Check where the first parameter ends
-- 		 if curpos > 0  -- More than one parameter; need to put commas in the list
-- 		 then
-- 		    outclause := outclause||''''||trim(SUBSTR (intemp, 1, curpos - 1))|| ''''||','; -- enclose each value in quotes
-- 		 else
-- 		    outclause := outclause||''''||trim(intemp)|| ''''||')'; -- The last or only parameter; close the bracket
-- 		 end if;
-- 		  EXIT WHEN nvl(curpos,0) = 0; -- Exit when we have no more parameters
-- 		 intemp := SUBSTR (intemp, nvl(curpos,0) + 1, LENGTH (intemp)); -- holding area with remaining parameters.
--       END LOOP;
--       RETURN outclause;
--    ELSE -- wild card exists
--       -- Replace all '*' with % in the input list of values.
--       select replace(inlov, '*', '%')
-- 	  into intemp
-- 	  from dual;
-- 	  outclause := '';
-- 	  LOOP
--          outclause :=  outclause||inField || ' like ';
--          curpos := INSTR (intemp, ',');  -- Check where the first parameter ends
-- 		 if curpos > 0  -- More than one parameter; need to put commas in the list
-- 		 then
-- 		    outclause := outclause||''''||trim(SUBSTR (intemp, 1, curpos - 1))|| ''''||' OR '; -- enclose each value in quotes
-- 		 else
-- 		    outclause := outclause||''''||trim(intemp)|| ''''; -- The last or only parameter; close the bracket
-- 		 end if;
-- 		  EXIT WHEN nvl(curpos,0) = 0; -- Exit when we have no more parameters
-- 		 intemp := SUBSTR (intemp, nvl(curpos,0) + 1, LENGTH (intemp)); -- holding area with remaining parameters.
--       END LOOP;
-- 	  RETURN outclause;
--    END IF;
   outclause := BIFNC_createNonCSVinlist(infield, inlov, ',');
   RETURN outclause;
END bifnc_createinlist;
--
FUNCTION BIFNC_GetTZNamefromCrystal (tzName varchar2)
RETURN varchar2 is
   tzCode varchar2(100);

/******************************************************************************
   NAME:       bifnc_GetTZNamefromCrystal
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/08/2006   RGladski       1. Created this function.

   NOTES:  Takes a 3 character input and return a valid Oracle time zone name entry
   		   (list created from entries in V$TIMEZONE_NAMES.TZNAME)

******************************************************************************/


BEGIN
	 tzCode := upper(substr(tzName,1,3));

	 if tzCode = 'AUS' then
	 	return 'Australia/Sydney';
	 elsif tzCode = 'CET' then
		return 'Europe/Paris';
	 elsif tzCode = 'CHN' then
		return 'Asia/Hong_Kong';
	 elsif tzCode = 'CST' then
		return 'America/Chicago';
	 elsif tzCode = 'EET' then
		return 'Europe/Athens';
	 elsif tzCode = 'EST' then
		return 'America/New_York';
	 elsif tzCode = 'GMT' then
		return 'GMT';
	 elsif tzCode = 'IND' then
		return 'Asia/Calcutta';
	 elsif tzCode = 'JPN' then
		return 'Asia/Tokyo';
	 elsif tzCode = 'MST' then
		return 'America/Denver';
	 elsif tzCode = 'NZL' then
		return 'Pacific/Auckland';
	 elsif tzCode = 'PRI' then
		return 'America/Puerto_Rico';
	 elsif tzCode = 'PST' then
		return 'America/Los_Angeles';
	 elsif tzCode = 'SAN' then
		return 'Europe/London';
	 elsif tzCode = 'SGP' then
		return 'Asia/Singapore';
	 elsif tzCode = 'THA' then
		return 'Asia/Bangkok';
	 else
	 	return 'GMT';
	 end if;

	 EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	    NULL;
	  WHEN OTHERS THEN
	    -- Consider logging the error and then re-raise
	    RAISE;

END bifnc_GetTZNamefromCrystal;
--

PROCEDURE BISP_GetStartAndEndDates(frequency IN varchar2, override IN number, tzone IN varchar2,
                                   instdate IN date, inenddate IN date, stdate OUT date, eddate OUT date) is
offset number(4);
startdate date;
enddate date;
--   Procedure getStartAndEndDates: return the report start and end dates based on the override, frequency, and
--   timezone.
--  Shrikanth Rao
--  10-May -2006
BEGIN
   enddate := sysdate -1 - override;
   enddate := to_date(to_char(enddate, 'DD-MON-YYYY')||' 23:59:59','DD-MON-YYYY HH24:MI:SS');
   if (frequency = 'ad-hoc')
   then
      --check start and end dates. If invalid, return correct ones
	  if (instdate is null)
	  then
	     startdate := sysdate -1;
	  else
	     startdate := instdate;
	  end if;
	  if (inenddate is null)
	  then
	     enddate := sysdate;
	  else
	     enddate := inenddate;
	  end if;
   elsif (frequency = 'daily')
   then
      offset := override + 1;
	  startdate := trunc(sysdate) -offset;
   elsif (frequency = 'weekly')
   then
      offset := override + 7;
	  startdate := trunc(sysdate) -offset;
   elsif (frequency = 'weekly trend 6')  -- 6 weeks
   then
      offset := override + 42;
	  startdate := trunc(sysdate) -offset;
   elsif (frequency = 'twelve weeks') -- 12 weeks
   then
      offset := override + 84;
	  startdate := trunc(sysdate) -offset;
   elsif (frequency = 'weekly trend') -- 13 weeks
   then
      offset := override + 91;
	  startdate := trunc(sysdate) -offset;
   elsif (frequency = 'bi-weekly')
   then
      offset := override + 14;
	  startdate := trunc(sysdate) -offset;
   elsif (frequency = 'monthly')
   then
      offset := override + 1;
	  startdate := trunc(sysdate) -offset;
	  startdate := to_date('01-'||to_char(startdate, 'MON-YYYY'), 'DD-MON-YYYY'); -- The first of the month
   elsif (frequency = 'monthly full') -- starts on Sunday
   then
      offset := override + 1;
	  startdate := trunc(sysdate) -offset;
	  startdate := to_date('01-'||to_char(startdate, 'MON-YYYY'), 'DD-MON-YYYY'); -- The first of the month
	  if to_number(to_char(startdate, 'D')) < 7
	  then
	     startdate := startdate - (to_number(to_char(startdate, 'D')) - 1);
	  else
	     startdate := startdate + 1;
	  end if;
   elsif (frequency = 'monthly trend')  -- 13 months
   then
      offset := override + 1;
	  startdate := trunc(sysdate) -offset;
	  startdate := to_date('01-'||to_char(startdate, 'MON-YYYY'), 'DD-MON-YYYY'); -- The first of the month
	  startdate := add_months(startdate, -12);
   elsif (frequency = 'monthly trend 6')  -- 6 months
   then
      offset := override + 1;
	  startdate := trunc(sysdate) -offset;
	  startdate := to_date('01-'||to_char(startdate, 'MON-YYYY'), 'DD-MON-YYYY'); -- The first of the month
	  startdate := add_months(startdate, -5);
   elsif (frequency = 'quarterly')  -- In this quarter
   then
      offset := override + 1;
	  startdate := trunc(sysdate) -offset;
	  startdate := to_date('01-'||to_char(startdate, 'MON-YYYY'), 'DD-MON-YYYY'); -- The first of the month
	  startdate := add_months(startdate, -2);
   elsif (frequency = 'year to date')
   then
      offset := override + 1;
	  startdate := trunc(sysdate) -offset;
	  startdate := to_date('01-JAN-'||to_char(startdate, 'YYYY'), 'DD-MON-YYYY'); -- The first of the current year
   elsif (frequency = 'yearly')
   then
      offset := override + 1;
	  startdate := trunc(sysdate) -offset;
	  startdate := add_months(to_date('01-JAN-'||to_char(startdate, 'YYYY'), 'DD-MON-YYYY'), -12); -- The first of correct year
   elsif (frequency = 'semi-annual')  -- 6 months of data
   then
      offset := override;
	  startdate := trunc(sysdate) - offset;
	  startdate := add_months(startdate, - 6);
   elsif (frequency = 'annual')  -- 12 months of data
   then
      offset := override;
	  startdate := trunc(sysdate) - offset;
	  startdate := add_months(startdate, - 12);
   end if;
   stdate := bifnc_AdjustForTZ(startdate, tzone, 'GMT');
   eddate := bifnc_AdjustForTZ(enddate, tzone, 'GMT');
END BISP_GetStartAndEndDates;

PROCEDURE BISP_CRTIMEZONES (c1 IN OUT rc) is

   sqlstmt VARCHAR2(2000);

/******************************************************************************
   NAME:       BISP_CRTIMEZONES
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/08/2006   RGladski       1. Created this function.

   NOTES:  Creates a list of common-name Time Zone entries.  Used to populate
   		   a BOXI Business View List of Values, which in turn is used to present
		   a predefined parameter prompt in a Crystal Report/
		   These entries are in turn parsed by the Oracle Function: GetOracleTZNamefromCrystal

******************************************************************************/


BEGIN
	sqlstmt := 'select ''AUS - (Sydney, Canberra, Melbourne)'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''CET - (Paris, Rome, Berlin, Stockholm)'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''CHN - (China - All Sites)'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''CST - (US - Central Time )'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''EET - (Athens, Bucharest, Istanbul)'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''EST - (New York City, Groton, New London)'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''GMT - (UTC)'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''IND - (India - All Sites)'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''JPN - (Japan - All Sites)'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''MST - (US - Mountain Standard Time)'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''NZL - (New Zealand - All Sites)'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''PRI - (Puerto Rico - All Sites)'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''PST - (US - Pacific Standard Time)'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''SAN - (Dublin, London, Sandwich)'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''SGP - (Singapore - All Sites)'' as TimeZones from dual';
	sqlstmt := sqlstmt || ' union';
	sqlstmt := sqlstmt || ' select ''THA - (Thailand - All Sites)'' as TimeZones from dual';


	OPEN c1 FOR sqlstmt;

   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END BISP_CRTIMEZONES;

FUNCTION  BIFNC_DATESBETWEEN(incolumn IN varchar2, date1 IN DATE, date2 IN DATE) RETURN VARCHAR2 IS
datesbetween varchar2 (250);
-- This utility function returns a 'Between' clause. The input arguments are:
-- incolumn: This is the column name, assumed to contain date values.
-- date1: This is the earliest date in the range between which incolumn values must lie.
-- date2: This is the latest date in the range between which incolumn values must lie.
-- Return: the statement: incolumn between to_date(' char value of date1') and to_date(' char value of date2').
BEGIN
   datesbetween := incolumn||' between to_date('||''''||to_char(date1, 'DD-MON-YYYY HH24:MI:SS')||''''||
                    ','||''''||'DD-MON-YYYY HH24:MI:SS'||''''||') AND to_date('||''''||to_char(date2, 'DD-MON-YYYY HH24:MI:SS')||''''||
                    ','||''''||'DD-MON-YYYY HH24:MI:SS'||''''|| ')';
   return datesbetween;
END BIFNC_DATESBETWEEN;


PROCEDURE  BISP_MainRptTrigger(
	c1 	   		 IN OUT rc,
    pstartdate   IN       TIMESTAMP,
    penddate     IN       TIMESTAMP,
	pzone		 IN		  VARCHAR2,
	pfrequency	 IN		  VARCHAR2,
	poverride	 IN		  VARCHAR2
)
is
      v_startdatedisplay   DATE;
      v_enddatedisplay     DATE;
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_db_zone			   VARCHAR2(10);
      v_select_stmt        VARCHAR2(2000);

BEGIN

   	v_db_zone := 'GMT';
	if pfrequency = 'ad-hoc' then
	   --call the date validation function
	   v_startdatedisplay := BIPKG_UTILS.BIFNC_AdjustForTZ(pstartdate, pzone, v_db_zone);
	   v_enddatedisplay:= BIPKG_UTILS.BIFNC_AdjustForTZ(penddate, pzone, v_db_zone);
	else
		bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
		v_startdatedisplay := BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_startdate, v_db_zone, pzone);
		v_enddatedisplay := BIPKG_UTILS.BIFNC_AdjustForTZ(v_gmt_enddate, v_db_zone, pzone);
	end if;

	v_select_stmt := 'select 1 as RECORDNUMBER' ||
	',to_date(' || '''' || to_char(v_startdatedisplay,'DD-MON-YYYY HH24:MI:SS') || '''' || ',''DD-MON-YYYY HH24:MI:SS'') as StartDateDisplay' ||
	',to_date(' || '''' || to_char(v_enddatedisplay,'DD-MON-YYYY HH24:MI:SS') || '''' || ',''DD-MON-YYYY HH24:MI:SS'') as EndDateDisplay' ||
	' from dual';

	OPEN c1 FOR v_select_stmt;


END BISP_MainRptTrigger;


PROCEDURE BISP_ListOfFrequencies (c1 IN OUT rc) is

   v_select_stmt VARCHAR2(2000);

/******************************************************************************
   NAME:       BISP_CRTIMEZONES
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/08/2006   RGladski       1. Created this function.

   NOTES:  Creates a list of common-name Time Zone entries.  Used to populate
   		   a BOXI Business View List of Values, which in turn is used to present
		   a predefined parameter prompt in a Crystal Report/
		   These entries are in turn parsed by the Oracle Function: GetOracleTZNamefromCrystal

******************************************************************************/


BEGIN
	v_select_stmt := 'select ''ad-hoc'' as Frequency from dual'||
	' union select ''daily'' as Frequency from dual'||
	' union select ''weekly'' as Frequency from dual'||
	' union select ''weekly trend 6'' as Frequency from dual'||
    ' union select ''twelve weeks'' as Frequency from dual'||
	' union select ''weekly trend'' as Frequency from dual'||
	' union select ''bi-weekly'' as Frequency from dual'||
	' union select ''monthly'' as Frequency from dual'||
	' union select ''monthly full'' as Frequency from dual'||
	' union select ''monthly trend'' as Frequency from dual'||
	' union select ''quarterly'' as Frequency from dual'||
	' union select ''year to date'' as Frequency from dual'||
	' union select ''yearly'' as Frequency from dual'||
	' union select ''semi-annual'' as Frequency from dual'||
	' union select ''annual'' as Frequency from dual';

	OPEN c1 FOR v_select_stmt;

   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END BISP_ListOfFrequencies;



END BIPKG_UTILS;
/

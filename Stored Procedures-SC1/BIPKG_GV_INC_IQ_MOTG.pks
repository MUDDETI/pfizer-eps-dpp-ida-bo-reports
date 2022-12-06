/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_INC_IQ_MOTG AS
/******************************************************************************
   NAME:       BIPKG_INC_IQ_MOTG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------------
   1.0        11/09/2006      Rithesh       1. This stored procedure is to pass the parameter values to report
                                              'Incident Queue Monitoring-sproc.rpt'
	2.0		   10.26.07		shw            1. Upgrade for GAMPS
    2.2         11.17.07    shw             2. Upgrade to view vs. table(s)
    2.3         08.05.08    shw             3. New Fields 0 
    2.4         09.03.08    shw             4. correct error converting clob to varchar (ac1.DESCRIPTION) 
    2.5         09.30.08    shw             5  Added New Fields(v_psm.PFZ_REOPEN_COUNTER,v_psm.ELAPSED_TIME)
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
      pmgroup                   IN       VARCHAR2,
      vinteraction_type         IN		 VARCHAR2,
      vVENDOR                   IN       VARCHAR2,
      vTOWER                    IN       VARCHAR2,
      vRPTGRP                   IN       VARCHAR2,
      vREGION                   IN       VARCHAR2,
      vAREA                     IN       VARCHAR2,
      vCLIENTREGION             IN       VARCHAR2,
      vCLIENTDIVISION           IN       VARCHAR2,
      vCLIENTCOUNTRY            IN       VARCHAR2,
      vSERVICELEVEL             IN       VARCHAR2
	                             );
END BIPKG_Gv_INC_IQ_MOTG;
/
/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_INC_IQ_MOTG AS
/******************************************************************************
   NAME:       BIPKG_INC_IQ_MOTG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  -----------------------------------------------------------------------
   1.0        11/09/2006     Rithesh        1. This stored procedure is to pass the parameter values to report
                                              'Incident Queue Monitoring-sproc.rpt'
    2.2         11.17.07    shw             2. Upgrade to view vs. table(s)
    2.3         08.05.08    shw             3. New Fields 0 
    2.4         09.03.08    shw             4. correct error converting clob to varchar (ac1.DESCRIPTION) 
    2.5         09.30.08    shw             5. Added New Fields(v_psm.PFZ_REOPEN_COUNTER,v_psm.ELAPSED_TIME)
******************************************************************************************************************/

PROCEDURE BIPKG_INC_IQ_MOTG(

    select_calls_cursor   IN OUT     bisp_refcursor_type,

      pfrequency                IN       VARCHAR2,
      poverride                 IN       VARCHAR2,
      pzone                     IN       VARCHAR2,
      pstartdate                IN       DATE,
      penddate                  IN       DATE,
      passignmentgroup          IN       VARCHAR2,
      pmmgroup                  IN       VARCHAR2,
      pmgroup                   IN       VARCHAR2,
      vinteraction_type         IN		 VARCHAR2,
      vVENDOR                   IN       VARCHAR2,
      vTOWER                    IN       VARCHAR2,
      vRPTGRP                   IN       VARCHAR2,
      vREGION                   IN       VARCHAR2,
      vAREA                     IN       VARCHAR2,
      vCLIENTREGION             IN       VARCHAR2,
      vCLIENTDIVISION           IN       VARCHAR2,
      vCLIENTCOUNTRY            IN       VARCHAR2,
      vSERVICELEVEL             IN       VARCHAR2
                        ) AS
          v_select_stmt        VARCHAR2(32767);
          v_close_time         DATE;
          v_startdatedisplay   VARCHAR2(50);
          v_enddatedisplay     VARCHAR2(50);
          v_db_zone            VARCHAR2(10);
          v_gmt_startdate      DATE;
          v_gmt_enddate        DATE;
          v_whereclause        VARCHAR2(32767);
   BEGIN
        v_db_zone := 'GMT';
          bipkg_utils.bisp_getStartAndEndDates(pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
        v_startdatedisplay   := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
        v_enddatedisplay     := TO_CHAR (bipkg_utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');

        v_select_stmt := 'SELECT DISTINCT';
        v_select_stmt := v_select_stmt || ' v_pb.NUMBERPRGN, v_pb.ASSIGNMENT,v_pb.PAGE, v_pb.BRIEF_DESCRIPTION,v_pb.OPENED_BY,BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') UPDATE_TIME,v_pb.UPDATED_BY, v_pb.TIME_SPENT, v_pb.LAST_ACTIVITY,BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.PREV_UPDATE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ')PREV_UPDATE_TIME, v_pb.PRODUCT_TYPE,v_pb.PFZ_PRODUCT_SUBTYPE,';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(v_pb.SYSMODTIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') SYSMODTIME,';
        v_select_stmt := v_select_stmt || ' v_psm.PFZ_RB_FULL_NAME, v_psm.OPEN_GROUP,v_psm.COUNTPRGN ReAssignments,v_psm.PFZ_REOPEN_COUNTER,v_psm.ELAPSED_TIME,v_psm.category, v_psm.PRIORITY, ';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.RESOLVE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') RESOLVE_TIME,';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.PFZ_RESTORE_SLA_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') RESTORE_TIME,';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.OPEN_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') OPEN_TIME,';
        v_select_stmt := v_select_stmt || ' BIPKG_UTILS.BIFNC_AdjustForTZ(v_psm.CLOSE_TIME,'|| '''' || v_db_zone || '''' || ',' || '''' || pzone || '''' || ') CLOSE_TIME,';
        v_select_stmt := v_select_stmt || ' OPERATORM1V.NAME, OPERATORM1V.FULL_NAME, AA1.NAME,';
        v_select_stmt := v_select_stmt || ' ac1.TYPE,to_char(substr(ac1.DESCRIPTION,1,120)) Activity_Desc,';
        v_select_stmt := v_select_stmt || ' am1.PFZ_VENDOR,am1.PFZ_SERVICE_TOWER,am1.PFZ_REPORTING_GROUP,am1.PFZ_DESCRIPTION,';
        v_select_stmt := v_select_stmt || ' cm1.LOCATION Client_Location, cm1.PFZ_DIVISION Client_Division,';
        v_select_stmt := v_select_stmt || ' sm1.PFZ_REGION_ID Region, sm1.SITE_ID Area,';
        v_select_stmt := v_select_stmt || ' um1.NAME Client_Country,um1.PFZ_REGION_ID Client_Region,';
        v_select_stmt := v_select_stmt || ' ' || '''' || v_startdatedisplay || '''' || 'StartDateDisplay, ' || '''' || v_enddatedisplay || '''' || ' EndDateDisplay ';

--        v_select_stmt := 'SELECT *';

        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBLEMS v_pb,';
        v_select_stmt := v_select_stmt || ' SC.V_PROBSUMMARY v_psm,';
        v_select_stmt := v_select_stmt || ' SC.ACTIVITYM1 ac1,';
        v_select_stmt := v_select_stmt || ' SC.OPERATORM1V OPERATORM1V,';
        v_select_stmt := v_select_stmt || ' SC.ASSIGNMENTA1 AA1,';
        v_select_stmt := v_select_stmt || ' SC.ASSIGNMENTM1 am1,';
        v_select_stmt := v_select_stmt || ' SC.PFZSITESM1 sm1,';
        v_select_stmt := v_select_stmt || ' SC.CONTACTSM1 cm1,';
        v_select_stmt := v_select_stmt || ' SC.COUNTRYM1 um1';

--        v_select_stmt := v_select_stmt || ' INNER JOIN SC.V_PROBSUMMARY v_psm ON v_pb.NUMBERPRGN = v_psm.NUMBERPRGN ';
--        v_select_stmt := v_select_stmt || ' INNER JOIN SC.OPERATORM1V OPERATORM1V ON v_pb.UPDATED_BY = OPERATORM1V.NAME ';
--        v_select_stmt := v_select_stmt || ' INNER JOIN SC.ASSIGNMENTA1 AA1 ON v_pb.UPDATED_BY = AA1.OPERATORS ';
--        v_select_stmt := v_select_stmt || ' INNER JOIN SC.ASSIGNMENTM1 am1 ON v_pb.ASSIGNMENT = am1.name';
--        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN SC.PFZSITESM1 sm1 ON am1.PFZ_SITE_ID = sm1.SITE_ID';
--        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN SC.CONTACTSM1 cm1 ON v_pb.CONTACT_NAME = cm1.CONTACT_NAME';
--        v_select_stmt := v_select_stmt || ' LEFT OUTER JOIN SC.COUNTRYM1 um1 ON cm1.COUNTRY = um1.NAME';
        v_select_stmt := v_select_stmt || ' WHERE (v_pb.UPDATE_TIME >= ' || '''' || v_gmt_startdate || '''' || 'AND v_pb.UPDATE_TIME < ' || '''' || v_gmt_enddate || ''')';
        v_select_stmt := v_select_stmt || ' AND (v_pb.NUMBERPRGN = v_psm.NUMBERPRGN)';
        v_select_stmt := v_select_stmt || ' AND (v_pb.NUMBERPRGN = ac1.NUMBERPRGN)';
        v_select_stmt := v_select_stmt || ' AND (v_pb.PAGE = ac1.PAGE)';
        v_select_stmt := v_select_stmt || ' AND (v_pb.UPDATED_BY = OPERATORM1V.NAME)';
        v_select_stmt := v_select_stmt || ' AND (v_pb.UPDATED_BY = AA1.OPERATORS)';
        v_select_stmt := v_select_stmt || ' AND (v_pb.ASSIGNMENT = am1.name)';
        v_select_stmt := v_select_stmt || ' AND (am1.PFZ_SITE_ID = sm1.SITE_ID(+))';
        v_select_stmt := v_select_stmt || ' AND (v_pb.CONTACT_NAME = cm1.CONTACT_NAME(+))';
        v_select_stmt := v_select_stmt || ' AND (cm1.COUNTRY = um1.NAME(+))';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('AA1.NAME', pmgroup) ||')';
        v_select_stmt := v_select_stmt || ' AND (' || BIPKG_UTILS.BIFNC_createinlist ('v_pb.ASSIGNMENT', passignmentgroup) || ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_VENDOR, '' '')', vVENDOR)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_SERVICE_TOWER, '' '')', vTOWER)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_REPORTING_GROUP, '' '')', vRPTGRP)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(sm1.PFZ_REGION_ID, '' '')', vREGION)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(sm1.SITE_ID, '' '')', vAREA)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(um1.PFZ_REGION_ID, '' '')', vCLIENTREGION)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(cm1.PFZ_DIVISION, '' '')', vCLIENTDIVISION)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(um1.NAME, '' '')', vCLIENTCOUNTRY)|| ')';
        v_select_stmt := v_select_stmt || ' AND (' || Bipkg_Utils.bifnc_createinlist ('NVL(am1.PFZ_DESCRIPTION, '' '')', vSERVICELEVEL)|| ')';
        if NOT ( pmmgroup = 'Y')
        then
        v_select_stmt := v_select_stmt || ' AND NOT (' || BIPKG_UTILS.BIFNC_createinlist ('v_pb.ASSIGNMENT', pmgroup) || ')';
        end if;
         OPEN select_calls_cursor FOR v_select_stmt;
         
         
         
    END BIPKG_INC_IQ_MOTG;
END BIPKG_Gv_INC_IQ_MOTG;
/

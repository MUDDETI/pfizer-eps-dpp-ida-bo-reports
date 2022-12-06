CREATE OR REPLACE PACKAGE BIPKG_Gv_EUS_EXEC_SUMM AS
TYPE bisp_ref_cursor IS REF CURSOR;
/******************************************************************************
   name:       bipkg_eus_exec_summ_rpt
   purpose:
   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0		  07/28/2006  -sgummadi-	   1. added bisp_quality_matrix 
	2.0		   10.02.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
    2.3         01.17.08    shw         4. add product_sub_type    
    3.0         02.18.08    -shw-           3. remove product sub-type from sub-sproc param list  
******************************************************************************/ 

   PROCEDURE bisp_quality_matrix (
      bisp_quality_matrix     IN OUT bisp_ref_cursor,
      p_report_type           IN     VARCHAR2,
      p_assignment_group      IN     VARCHAR2,
      p_analyst               IN     VARCHAR2,
      p_division              IN     VARCHAR2,
      p_service_groups        IN     VARCHAR2,
      p_service               IN     VARCHAR2,
      p_service_offering      IN     VARCHAR2,
      p_service_suboffering   IN     VARCHAR2,
      p_service_event         IN     VARCHAR2,
      p_zone                  IN     VARCHAR2,
      p_frequency             IN     VARCHAR2,
      p_override              IN     NUMBER,
      p_startdate             IN     DATE,
      p_enddate               IN     DATE,
      vinteraction_type       IN     VARCHAR2
   );
   
/*****************************************************************************************************************************************************

The Function bifnc_srv_evnt_str first turns the null inputs into valid strings and then calls two functions bifnc_swt_str and bifnc_vap_str
It returns service;service offering;service sub offering;service event string based on the following fields
Resolution Code       :       probsummarym1.resolution_code
Cause Code                :       probsummarym1.cause_code
Problem Type            :       probsummarym1.problem_type
Product Type              :       probsummarym1.product_type
Special Flag              :          probsummarym1.pfz_special_project

*****************************************************************************************************************************************************/
   FUNCTION bifnc_srv_evnt_str (
      p_resolution        IN      VARCHAR2,
      p_causecode         IN      VARCHAR2,
      p_problem           IN      VARCHAR2,
      p_product           IN      VARCHAR2,
      p_specialflag       IN      VARCHAR2
   ) RETURN VARCHAR2;
END BIPKG_Gv_EUS_EXEC_SUMM;
/
CREATE OR REPLACE PACKAGE BODY Bipkg_Gv_Eus_Exec_Summ
AS

/*****************************************************************************************************************************************************
   name:       bipkg_eus_exec_summ
   purpose:

   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0          07/28/2006  -sgummadi-       1. added bisp_quality_matrix 
    2.0           10.02.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
    2.3         01.17.08    shw         4. add product_sub_type    
    3.0         02.18.08    -shw-           3. remove product sub-type from sub-sproc param list  
*****************************************************************************************************************************************************/

   PROCEDURE bisp_quality_matrix (
      bisp_quality_matrix     IN OUT bisp_ref_cursor,
      p_report_type           IN     VARCHAR2,
      p_assignment_group      IN     VARCHAR2,
      p_analyst               IN     VARCHAR2,
      p_division              IN     VARCHAR2,
      p_service_groups        IN     VARCHAR2,
      p_service               IN     VARCHAR2,
      p_service_offering      IN     VARCHAR2,
      p_service_suboffering   IN     VARCHAR2,
      p_service_event         IN     VARCHAR2,
      p_zone                  IN     VARCHAR2,
      p_frequency             IN     VARCHAR2,
      p_override              IN     NUMBER,
      p_startdate             IN     DATE,
      p_enddate               IN     DATE,
      vinteraction_type       IN     VARCHAR2
   )
   IS
      v_startdatedisplay             VARCHAR2 (200);
      v_enddatedisplay               VARCHAR2 (200);
      v_gmt_startdate                DATE;
      v_gmt_enddate                  DATE;
      v_gmt_startdate_str            VARCHAR2(200);
      v_gmt_enddate_str              VARCHAR2(200);
      v_db_zone                      VARCHAR2 (3);
      v_srv_str                      VARCHAR(1000);
      v_select_stmt                  VARCHAR2 (32767);      
   BEGIN
     
     --TimeZone of the Database
      v_db_zone := 'GMT';      
     
      --Caluclate Start and End Dates in Database TimeZone based on the the parameters entered while running the report
      Bipkg_Utils.bisp_getstartandenddates (p_frequency, p_override, p_zone, p_startdate, p_enddate, v_gmt_startdate, v_gmt_enddate); 
     
      --Convert the start and end dates to strings so that they can be used in the SQL statement to filter records
      v_gmt_startdate_str  := 'to_date(''' || TO_CHAR (v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';
      v_gmt_enddate_str    := 'to_date(''' || TO_CHAR (v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';
      
      --Convert the start and end dates to TimeZone parameter and then to strings so that they can be used in the SQL statement in order to send the dates back to the report for display
      v_startdatedisplay   := 'to_date(''' || TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,p_zone),'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';
      v_enddatedisplay       := 'to_date(''' || TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,p_zone),'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';      
      
      --Create Service Event String by replacing any *'s with %'s and joining Service, Service Offering, Service Sub Offering, and Service Event which  will be used to filter records
      v_srv_str := REPLACE(p_service, '*', '%') || ';' || REPLACE(p_service_offering, '*', '%') || ';' || REPLACE(p_service_suboffering, '*', '%') || ';' || REPLACE(p_service_event, '*', '%') || '%';
      
      --Building SQL Statement
      v_select_stmt := '   select'
                    || '   v_psm.assignment'
                    || ' , v_psm.open_group'
                    || ' , v_psm.numberprgn'            
                    || ' , v_psm.flag'
                    || ' , v_psm.resolution_code'
                    || ' , v_psm.cause_code'
                    || ' , v_psm.problem_type'
                    || ' , v_psm.product_type'
                    || ' , v_psm.pfz_product_subtype'
                    || ' , v_psm.pfz_special_project'
                    || ' , v_psm.pfz_division'
                    || ' , v_psm.pfz_bu'
                    || ' , v_psm.pfz_sla_title'
                    || ' , v_psm.pfz_resolve_sla'
                    || ' , v_psm.user_priority'
                    || ' , v_psm.updated_by'
                    || ' , v_psm.pfz_total_time_spent'
                    || ' , bipkg_utils.bifnc_adjustfortz (v_psm.open_time,''' || v_db_zone || ''', ''' || p_zone || ''') open_time'
                    || ' , bipkg_utils.bifnc_adjustfortz (v_psm.close_time,''' || v_db_zone || ''', ''' || p_zone || ''') close_time'
                    || ' , bipkg_eus_exec_summ.bifnc_srv_evnt_str (v_psm.resolution_code, v_psm.cause_code, v_psm.problem_type, v_psm.product_type, v_psm.pfz_special_project) service_event_string' 
                    || ' , ' || v_startdatedisplay || ' startdatedisplay'
                    || ' , ' || v_enddatedisplay || ' enddatedisplay'
                    || ' , v_psm.category'
                    || ' , v_psm.priority'
                    || ' from'
                    || ' SC.V_PROBSUMMARY v_psm'
                    || ' where'
-- v.2.0 GAMPS                     || ' v_psm.pfz_sla_title <> ''Project'''                    
                    || ' v_psm.priority <> ''PROJECT'''                    
                    || ' and (' || Bipkg_Utils.bifnc_createnoncsvinlist ('NVL(v_psm.assignment, '' '')', p_service_groups, ';') || ')'
                    || ' and (' || Bipkg_Utils.bifnc_createnoncsvinlist ('NVL(v_psm.assignment, '' '')', p_assignment_group, ';') || ')'
                    || ' and (' || Bipkg_Utils.bifnc_createnoncsvinlist ('NVL(v_psm.updated_by, '' '')', p_analyst, ';') || ')'
                    || ' and (' || Bipkg_Utils.bifnc_createnoncsvinlist ('NVL(v_psm.pfz_division, '' '')', p_division, ';') || ')'                                                        
                    || ' AND (' || Bipkg_Utils.bifnc_createnoncsvinlist ('NVL(v_psm.category, '' '')', vinteraction_type, ';')|| ')'
                    || ' and'
                    || ' ('
                    || ' ('
                    || ' v_psm.close_time between ' || v_gmt_startdate_str || ' and ' || v_gmt_enddate_str
                    || ' and bipkg_eus_exec_summ.bifnc_srv_evnt_str (v_psm.resolution_code, v_psm.cause_code, v_psm.problem_type, v_psm.product_type, v_psm.pfz_special_project) like ''' || v_srv_str || '''' 
                    || ' )'
                    ;
                    
      --Include Back Orders for Executive Summary report
      IF p_report_type <> 'EXECUTIVE SUMMARY' THEN 
      v_select_stmt := v_select_stmt
                                        || ' )'
                                    ;                                    
      ELSE                                    
                                    v_select_stmt := v_select_stmt
                                         || ' or'
                                    || ' ('
                                    || ' v_psm.open_time <= ' || v_gmt_enddate_str 
                                    || ' and'
                                    || ' ('
                                    || ' v_psm.flag = ''t'''
                                    || ' or'
                                    || ' v_psm.close_time > ' || v_gmt_enddate_str
                                    || ' )'
                                    || ' )'
                                    || ' )'
                                    ;

      END IF;
                      
      OPEN bisp_quality_matrix FOR v_select_stmt;
      
   END bisp_quality_matrix;

   
      
/*****************************************************************************************************************************************************

The Function bifnc_srv_evnt_str first turns the null inputs into valid strings and then calls two functions bifnc_swt_str and bifnc_vap_str
It returns service;service offering;service sub offering;service event string based on the following fields
Resolution Code       :       v_psm.resolution_code
Cause Code                :       v_psm.cause_code
Problem Type            :       v_psm.problem_type
Product Type              :       v_psm.product_type
Special Flag              :          v_psm.pfz_special_project
*****************************************************************************************************************************************************/   


   FUNCTION bifnc_srv_evnt_str (
      p_resolution        IN      VARCHAR2,
      p_causecode         IN      VARCHAR2,
      p_problem           IN      VARCHAR2,
      p_product           IN      VARCHAR2,
      p_specialflag       IN      VARCHAR2
   ) RETURN VARCHAR2 IS
      v_resolution       VARCHAR2(255);
      v_problem          VARCHAR2(255);
      v_product          VARCHAR2(255);
      v_specialflag      VARCHAR2(255);
      v_causecode        VARCHAR2(255);
      v_srv_evnt_str     VARCHAR2(999);
   BEGIN
   
   v_resolution := NVL(p_resolution, ' ');
   v_problem := NVL(p_problem, ' '); 
   v_product := NVL(p_product, ' '); 
   v_causecode := NVL(p_causecode, ' '); 
   v_specialflag := NVL(p_specialflag, ' '); 

      IF v_product = 'HOME SUPPORT' THEN
            IF v_specialflag LIKE '%EXEC SUPT%' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - VIP and Executive Support;Home Support';
            ELSE v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Remote User Support;Remote On-Site Support';
            END IF;
      ELSIF  v_resolution = 'EUS - MEETING SETUP AND SUPPORT' THEN 
            IF v_specialflag LIKE '%EXEC SUPT%'  THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - VIP and Executive Support;Meeting Support';
            ELSIF v_problem = 'HARDWARE IRMAC' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Meeting Support - General - On-Site;IT Equipment Meeting Support - On-Site';
            ELSIF v_problem = 'PROJECT REQUEST' THEN
                  IF v_product = 'VIDEO/AUDIO VISUAL CONFERENCING' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Meeting Support - General - Off-Site;Audio Visual Support - Off-Site';
                  ELSE v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Meeting Support - General - Off-Site;IT Equipment Meeting Support - Off-Site';
                  END IF;
            ELSE v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Meeting Support - General - On-Site;Audio Visual Support - On-Site';
            END IF;
      ELSIF v_resolution IN ('EUS - INSTALL DESKSIDE', 'EUS - INSTALL REMOTELY') THEN
            IF v_causecode = 'EQUIPMENT LOAN' THEN
                  IF v_specialflag LIKE '%EXEC SUPT%' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - VIP and Executive Support;Equipment Loans';
                  ELSE v_srv_evnt_str := 'EUS;Site Services;Deskside Support - IT Hardware Break / Fix Support;Hardware Equipment Loan Request Handling';
                  --v_srv_evnt_str := 'EUS;Site Services;Deskside Support - On-Site Drop-In Centers;On-Site Loaner Service';
                  END IF;
           ELSIF v_causecode = 'SOFTWARE REMOVED' THEN v_srv_evnt_str := 'EUS;Site Services;PC Fulfillment - Software IRMAC;Software Removals';
           ELSIF v_causecode = 'ONBOARD' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Onboarding / Offboarding Support;Onboarding Support';
           ELSIF v_causecode  = 'OFFBOARD' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Onboarding / Offboarding Support;Offboarding Support';
           ELSIF v_product = 'CABLE SERVICE' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Port Activation Support;LAN Port Cable Distribution';
           ELSIF v_product = 'MANAGED DESKTOP (MD)' THEN 
                 IF v_causecode = 'NEW SOFTWARE' THEN v_srv_evnt_str := 'EUS;Platform Management / DMS;Software Distribution Support;Software Distribution & Application Packaging';
                 ELSIF v_causecode = 'APPLICATION DEPENDENCY' THEN v_srv_evnt_str := 'EUS;Platform Management / DMS;Software Distribution Support;One-Off Business Application Certification';
                 ELSIF v_causecode = 'NON-PACKAGED SOFTWARE REQUEST' THEN v_srv_evnt_str := 'EUS;Platform Management / DMS;Software Distribution Support;Non-packaged Software Install';
                 ELSE v_srv_evnt_str := 'EUS;Platform Management / DMS;Software Distribution Support;Pfizer Application Install';
                   END IF;            
         ELSIF v_problem = 'HARDWARE IRMAC' THEN
               IF v_product IN ('BLACKBERRY', 'PDA', 'PALMPILOT') THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - PDA & Handheld Support;PDA & Handheld Installation';
               ELSIF v_product = 'LAB PC' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Lab, Process and Non-standard PC Support;Lab, Process, or Non-standard PC Hardware IRMAC';
               ELSE v_srv_evnt_str := 'EUS;Site Services;PC Fulfillment - Hardware IRMAC;New Hardware Installs';
               END IF;
         ELSIF v_problem = 'SOFTWARE IRMAC' THEN
               IF v_product IN ('BLACKBERRY', 'PDA', 'PALMPILOT') THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - PDA & Handheld Support;PDA & Handheld Upgrades';
               ELSIF v_product = 'LAB PC' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Lab, Process and Non-standard PC Support;Lab, Process or Non-Standard PC Software IRMAC';
               ELSE v_srv_evnt_str := 'EUS;Site Services;PC Fulfillment - Software IRMAC;Software Installations';
               END IF;
         ELSE v_srv_evnt_str := 'Other;Other;Other;Other1';
         END IF;
      ELSIF v_resolution = 'EUS - CONFIGURATION SOFTWARE' THEN
            IF v_specialflag LIKE '%EXEC SUPT%'  THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - VIP and Executive Support;Pre-Travel Diagnostics';
            ELSIF v_product = 'LAB PC' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Lab, Process and Non-standard PC Support;Lab, Process, or Non-standard PC Service Restoration';
            ELSIF v_product = 'MANAGED DESKTOP (MD)' THEN
                  IF v_problem = 'ACCOUNT PROBLEM' THEN  v_srv_evnt_str := 'EUS;Platform Management / DMS;Managed Desktop Infrastructure Support;Controlled Desktop Permissions';
                  ELSE 
                  --v_srv_evnt_str := 'EUS;Platform Management / DMS;Managed Desktop Infrastructure Support;Major / Minor DMS Releases';
                  v_srv_evnt_str := 'EUS;Platform Management / DMS;Managed Desktop Infrastructure Support;DMS Maintenance Release';
                  --v_srv_evnt_str := 'EUS;Platform Management / DMS;Managed Desktop Infrastructure Support;Maintenance Releases';
                  END IF;
            ELSIF v_problem = 'NETWORK PROBLEM' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Service Restoration;Network Connectivity Support';
            ELSIF v_problem = 'SOFTWARE IRMAC' THEN v_srv_evnt_str := 'EUS;Site Services;PC Fulfillment - Software IRMAC;Software Changes';
            ELSE v_srv_evnt_str := 'EUS;Service Desk;Application Support;General Application Support';
            END IF;
      ELSIF v_resolution = 'EUS - PROCUREMENT SUPPORT' THEN 
            IF v_specialflag LIKE '%EXEC SUPT%'  THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - VIP and Executive Support;IT Procurement Support';
            ELSE v_srv_evnt_str := 'EUS;Site Services;PC Fulfillment - Procurement Support;Hardware / Software Acquisition Consultations';
            END IF;
      ELSIF v_resolution = 'EUS - HD ACCOUNT NEW' THEN
            IF v_product = 'GRAS/SECURE ID CARD' THEN v_srv_evnt_str := 'EUS;Service Desk;Account Management;Secure ID Token Account Created';
            ELSE v_srv_evnt_str := 'EUS;Service Desk;Account Management;Account Creation';
            END IF;
      ELSIF v_resolution = 'EUS - HOW-TO INSTRUCTION' THEN
            IF v_product LIKE 'GRAS%' THEN v_srv_evnt_str := 'EUS;Service Desk;Application Support;Global Remote Access Support';
            ELSE v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Remote User Support;General Support';
            END IF;             
      ELSIF v_resolution = 'EUS - CONFIGURATION HARDWARE' THEN
            IF v_product = 'LAB PC' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Lab, Process and Non-standard PC Support;Lab, Process, or Non-standard PC Break / Fix';
            ELSIF v_problem = 'HARDWARE PROBLEM' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Service Restoration;Level 2 Hardware/Software Support';
            ELSE v_srv_evnt_str := 'EUS;Site Services;PC Fulfillment - Hardware IRMAC;Hardware Changes';
            END IF;
      ELSIF v_resolution = 'EUS - DSKTP NEW BUILD' THEN
            IF v_product = 'MANAGED DESKTOP (MD)' THEN v_srv_evnt_str := 'EUS;Platform Management / DMS;Deployment Support;DMS Desktop Deployment - All Services';
            ELSE v_srv_evnt_str := 'EUS;Site Services;PC Fulfillment - PC Refresh;Life Cycle PC Refresh Management & Deployment';
            END IF;
      ELSIF v_resolution = 'EUS - PROJECT SUPPORT & DATA ENTRY' THEN
            IF v_product = 'ASSET CENTER' THEN v_srv_evnt_str := 'EUS;Site Services;PC Fulfillment - IT Equipment Disposal & Inventory  Management;Hardware Inventory Management';
            ELSIF v_problem = 'HARDWARE IRMAC' THEN v_srv_evnt_str := 'EUS;Site Services;PC Fulfillment - IT Equipment Disposal & Inventory  Management;Donation Processing';
            ELSE v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Depot Support;Depot Equipment Receipt';
            END IF;      
      ELSIF v_resolution = 'EUS - CONFIGURATION NETWORK' THEN 
            IF v_causecode = 'PORT ISSUE' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Port Activation Support;Port Activated or Deactivated';
            ELSE v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Service Restoration;PC Disaster Recovery (APAC)';
            END IF;      
      ELSIF v_resolution = 'EUS - HARDWARE SHIPPED' THEN
            IF v_causecode = 'CLIENT REQUEST' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Remote User Support;Equipment Distribution';
            ELSIF v_causecode = 'MAINTENANCE' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Depot Support;Depot Equipment Repair / Replacement';
            ELSE v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Depot Support;Depot Equipment Shipping';
            END IF;
      ELSIF v_resolution = 'EUS - VIDEOCONFERENCE SETUP & SUPPORT' THEN
            IF v_problem = 'CUSTOMER SERVICE' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Meeting Support - General - On-Site;Video Conference Support - On-Site';
            ELSE v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Meeting Support - General - Off-Site;Video Conference Support - Off-Site';
            END IF;
      ELSIF v_resolution IN ('EUS - HARDWARE FIXED', 'EUS - HARDWARE REPLACED') THEN
            IF v_causecode = 'HARDWARE FAILURE - IN WARRANTY' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - IT Hardware Break / Fix Support;Hardware Warranty Repair';
            ELSIF v_causecode = 'HARDWARE FAILURE - OUT OF WARRANTY' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - IT Hardware Break / Fix Support;Hardware Non-warranty Repair';
            ELSIF v_problem = 'PRINTER PROBLEM' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Printer Support;Printer Maintenance';
            ELSIF v_problem = 'HARDWARE PROBLEM' AND v_product = 'VIDEO/VIDEO CONFERENCING' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Meeting Support - General - On-Site;Video Conference Hardware Break / Fix - On-Site';
            ELSIF v_problem = 'HARDWARE PROBLEM' AND v_product = 'VIDEO/AUDIO VISUAL CONFERENCING' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Meeting Support - General - On-Site;Audio Visual Equipment Break / Fix - On-Site';
            ELSIF v_problem = 'PROJECT REQUEST' AND v_product = 'VIDEO/VIDEO CONFERENCING' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Meeting Support - General - Off-Site;Video Conference Hardware Break / Fix - Off-Site';
            ELSIF v_problem = 'PROJECT REQUEST' AND v_product = 'VIDEO/AUDIO VISUAL CONFERENCING' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Meeting Support - General - Off-Site;Audio Visual Equipment Break / Fix - Off-Site';   
            ELSE v_srv_evnt_str := 'Other;Other;Other;Other2';
            END IF;
      ELSIF v_resolution LIKE 'TELECOM%' THEN v_srv_evnt_str := 'EUS;Service Desk;Service Desk;Voice Level 1 Support';            
      ELSIF v_resolution IN ('EUS - HD ACCOUNT ENABLED', 'EUS - HD ACCOUNT RENEWAL') THEN v_srv_evnt_str := 'EUS;Service Desk;Account Management;Account Extension';
      ELSIF v_resolution = 'EUS - HD ACCOUNT DISABLED' THEN v_srv_evnt_str := 'EUS;Service Desk;Account Management;Account Disabled';
      ELSIF v_resolution = 'EUS - ADMIN MAILBOX' THEN v_srv_evnt_str := 'EUS;Service Desk;Account Management;Mailbox Administration';
      ELSIF v_resolution = 'EUS - ADMIN DL' THEN v_srv_evnt_str := 'EUS;Service Desk;Account Management;Distribution List Administration';   
      ELSIF v_resolution = 'DC ADM - ACCOUNT/GROUP IRMAC' THEN v_srv_evnt_str := 'EUS;Service Desk;Account Management;Group Creation / Modification / Deletion';   
      ELSIF v_resolution = 'DC ADM - FILE SYSTEM IRMAC' THEN v_srv_evnt_str := 'EUS;Service Desk;Account Management;File Share Creation';
      ELSIF v_resolution = 'EUS - HD ACCOUNT CHANGE' THEN v_srv_evnt_str := 'EUS;Service Desk;Account Management;DMS Privilege Changes';
      ELSIF v_resolution = 'EUS - HD ACCOUNT UNLOCK' THEN v_srv_evnt_str := 'EUS;Service Desk;Password Reset;Account Unlocked';   
      ELSIF v_resolution = 'EUS - HD RESET PASSWORD' THEN v_srv_evnt_str := 'EUS;Service Desk;Password Reset;Password Reset';   
      ELSIF v_resolution = 'DC SW - APPLICATION IRMAC' THEN v_srv_evnt_str := 'EUS;Service Desk;Application Support;Enterprise Application Support';
      ELSIF v_resolution = 'DC MISC - NON-PEREGRINE ESCALATION' THEN v_srv_evnt_str := 'EUS;Service Desk;Application Support;External Customer Support for Pfizer IT Products';
      ELSIF v_resolution = 'EUS - HARDWARE REMOVED' THEN v_srv_evnt_str := 'EUS;Site Services;PC Fulfillment - Hardware IRMAC;Hardware Removals';
      ELSIF v_resolution = 'EUS - HARDWARE ADDED' THEN v_srv_evnt_str := 'EUS;Site Services;PC Fulfillment - Hardware IRMAC;Hardware Additions';
      ELSIF v_resolution = 'EUS - HARDWARE MOVED' THEN v_srv_evnt_str := 'EUS;Site Services;PC Fulfillment - Hardware IRMAC;Hardware Moves';
      ELSIF v_resolution = 'EUS - DSKTP REBUILD' THEN v_srv_evnt_str := 'EUS;Site Services;PC Fulfillment - IT Equipment Disposal & Inventory  Management;PC Decommission';
      ELSIF v_resolution = 'EUS - DATA MANAGEMENT' THEN v_srv_evnt_str := 'EUS;Site Services;PC Fulfillment - IT Equipment Disposal & Inventory  Management;Data Archiving'; 
      ELSIF v_resolution = 'DC ADM - PRINTER IRMAC' THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Printer Support;Network Print Queue Management';
      ELSIF v_resolution IN ('EUS - VIRUS PROBLEM - VIRUS REMOVED', 'EUS - VIRUS PROBLEM - NO VIRUS FOUND') THEN v_srv_evnt_str := 'EUS;Site Services;Deskside Support - Virus Response and Remediation;Virus Removal & Application of Patches'; 
      ELSIF v_resolution = 'MAJOR OUTAGE' THEN v_srv_evnt_str := 'EUS;Platform Management / DMS;Managed Desktop Infrastructure Support;Major or Global Incidents';
      ELSE v_srv_evnt_str := 'Other;Other;Other;Other3';
      END IF;
      
      IF v_srv_evnt_str LIKE 'Other;Other;Other;%' THEN
            IF v_problem LIKE 'SERVER%' THEN v_srv_evnt_str := 'EUS;Service Desk;Service Desk;Level 1 Operations Support';
            ELSIF v_problem = 'PROJECT REQUEST' THEN v_srv_evnt_str := 'EUS;Service Desk;Service Desk;Service Desk Project Support';
            --v_srv_evnt_str := 'EUS;Site Services;Deskside Support - T&M - Project;Desk Side Support Project';
            END IF;
      END IF;
      
   RETURN v_srv_evnt_str;
   
   END bifnc_srv_evnt_str; 
   
END Bipkg_Gv_Eus_Exec_Summ;
/

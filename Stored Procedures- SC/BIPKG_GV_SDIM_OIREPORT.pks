CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_SDIM_OIREPORT AS
/******************************************************************************
   NAME:       BIPKG_SDIM_OIReport
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------------------------------
   1.0        09/29/2006      Rithesh       1. To return the values from stored procedure to Report
                                               'OpenIncidentReport-sproc.rpt''
	2.0		   10.29.07		shw			1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
*******************************************************************************************************/

 TYPE bisp_refcursor_type is REF CURSOR;
 PROCEDURE BIPKG_SDIM_OIReport (select_calls_cursor   IN OUT   bisp_refcursor_type
                             );

END BIPKG_Gv_SDIM_OIREPORT;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.BIPKG_Gv_SDIM_OIReport AS
/******************************************************************************
   NAME:       BIPKG_SDIM_OIReport
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ---------------------------------------------------------------
   1.0        09/29/2006     Rithesh        1. To return the values from stored procedure to Report
                                               'OpenIncidentReport-sproc.rpt''
    2.0           10.29.07        shw            1. Upgrade for GAMPS 
    2.2         11.18.07    shw         3. Upgrade to view vs. table(s) 
**********************************************************************************************************/

PROCEDURE BIPKG_SDIM_OIReport(

    select_calls_cursor   IN OUT     bisp_refcursor_type
                        ) AS
                        
                         
        v_select_stmt        VARCHAR2(32767);
  BEGIN          
        v_select_stmt := ' SELECT v_psm.NUMBERPRGN, v_psm.FLAG, v_psm.ASSIGNMENT, v_psm.PFZ_SLA_TITLE,';
        v_select_stmt := v_select_stmt || ' v_psm.category, v_psm.PFZ_IMPACT,v_psm.PRIORITY,v_psm.PFZ_PRODUCT_SUBTYPE,v_psm.PFZ_COUNTRY_IMPACTED';
        v_select_stmt := v_select_stmt || ' FROM SC.V_PROBSUMMARY v_psm' ;
        v_select_stmt := v_select_stmt || ' WHERE v_psm.flag = ' || '''' || 't' || '''' || '';                           
                         
                                                             

         OPEN select_calls_cursor FOR v_select_stmt;
  END BIPKG_SDIM_OIReport;         
END BIPKG_Gv_SDIM_OIReport;
/

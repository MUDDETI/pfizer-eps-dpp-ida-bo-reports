CREATE OR REPLACE PACKAGE SCREPORT.BIPKG_Gv_ACTIVITY_SUMMARY AS
   TYPE bisp_refcursor_type IS REF CURSOR;

/******************************************************************************
   name:       bipkg_activity_summary
   purpose:

   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0		  07/25/2006  -sgummadi-	   1. added bisp_activity_summary procedure  
	2.0		   10.18.07		shw			1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
******************************************************************************/

   PROCEDURE bisp_activity_summary (
      activity_summary_cursor IN OUT bisp_refcursor_type,
      pgroup                  IN      VARCHAR2,
      pcountry                  IN     VARCHAR2,
      p_c_or_s                  IN     VARCHAR2,
      pzone                      IN     VARCHAR2,
      pfrequency              IN     VARCHAR2,
      poverride                  IN     VARCHAR2,
      pstartdate              IN     DATE,
      penddate                  IN     DATE,
      vinteraction_type           IN     VARCHAR2
   );  
   
   PROCEDURE bisp_activity_summary_generic (
      act_summ_generic_cursor IN OUT bisp_refcursor_type,
      pgroup                  IN   VARCHAR2,
      preportby                IN   VARCHAR2,
      pfilterby                    IN   VARCHAR2,
      pzone                     IN   VARCHAR2,
      pfrequency        IN   VARCHAR2,
      poverride              IN   VARCHAR2,
      pstartdate          IN   DATE,
      penddate             IN   DATE,
      vinteraction_type           IN     VARCHAR2
   ); 
END BIPKG_Gv_ACTIVITY_SUMMARY;
/
CREATE OR REPLACE PACKAGE BODY SCREPORT.Bipkg_Gv_Activity_Summary
AS

/******************************************************************************
   name:       bisp_activity_summary 
   purpose:

   revisions:
   ver        date        author          description
   ---------  ----------  ---------------  ------------------------------------
    1.0          07/25/2006     -sgummadi-        1. developed bisp_activity_summary proc 
    2.0           10.18.07        shw            1. Upgrade for GAMPS 
    2.2         11.17.07    shw         3. Upgrade to view vs. table(s) 
******************************************************************************/
    
   PROCEDURE bisp_activity_summary (
      activity_summary_cursor       IN OUT      bisp_refcursor_type,
      pgroup                       IN         VARCHAR2,
      pcountry                        IN          VARCHAR2,
      p_c_or_s                        IN          VARCHAR2,
      pzone                            IN          VARCHAR2,
      pfrequency                    IN          VARCHAR2,
      poverride                        IN          VARCHAR2,
      pstartdate                    IN         DATE,
      penddate                      IN         DATE,
      vinteraction_type                  IN           VARCHAR2
   )
   IS
      v_startdatedisplay   VARCHAR2 (19);
      v_enddatedisplay     VARCHAR2 (19);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_date_range           VARCHAR2 (124);
      v_db_zone            VARCHAR2 (3);
      v_select_stmt       VARCHAR2 (32767);
   BEGIN
      v_db_zone := 'GMT';
      Bipkg_Utils.bisp_getstartandenddates (pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
      v_startdatedisplay   := TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
      v_enddatedisplay     := TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
      v_date_range         := 'to_date(''' || TO_CHAR(v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'') and to_date(''' || TO_CHAR(v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';

      v_select_stmt := v_select_stmt || ' select'
                                                                           || ' tc.qgroup,'    ;                                   
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt  || ' nvl(tc.country, ''UNKNOWN'') as country,';
      ELSE 
      v_select_stmt := v_select_stmt || ' ''NA'' as country,';
      END IF;      
      v_select_stmt := v_select_stmt || ' substr(tc.qgroup, 1, 3) as site,'
                                          || ' pfzsitesm1.description as sitedescr,'
                                          || ' tc.type,'
                                     || ' tc.ticketcnt,'
                                     || ' tc.timespent,'
                                     || ' to_date(''' || v_startdatedisplay || ''', ''DD-MM-YYYY HH24:MI:SS'') as StartDateDisplay,' 
                                     || ' to_date(''' || v_enddatedisplay || ''', ''DD-MM-YYYY HH24:MI:SS'') as EndDateDisplay'
                                        || ' from'
                                        || ' ('
                                        || ' ('
                                        || ' select pm1.qgroup,';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' pm1.country,'; 
      END IF;
      v_select_stmt := v_select_stmt || ' ''Incs Activity'' as type,'
                                       || ' count(pm1.numberprgn) as ticketcnt,'
                                       || ' 0 as timespent'
                                       || ' from'
                                       || ' ('
                                       || ' select';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' v_pb.country,';
      END IF;
      v_select_stmt := v_select_stmt || ' case v_pb.page when 1 then v_pb.open_group else v_pb.assignment end as qgroup,'
                                       || ' v_pb.numberprgn'
                                       || ' from'
                                       || ' sc.v_problems v_pb' 
                                       || ' where'
                                       || ' ('
                                       || ' (v_pb.page = 1 and (' || Bipkg_Utils.bifnc_createinlist ('v_pb.open_group', pgroup) || '))'
                                       || ' or'
                                       || ' (v_pb.page <> 1 and (' || Bipkg_Utils.bifnc_createinlist ('v_pb.assignment', pgroup) || '))'
                                       || ' )';
      IF NOT (pcountry IN ('*', '%')) THEN
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_pb.country', pcountry) || ')';
      END IF;                                 
      v_select_stmt := v_select_stmt || ' and v_pb.update_time between ' || v_date_range 
                                       || ' group by';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' v_pb.country,'; 
      END IF;
      v_select_stmt := v_select_stmt || ' case v_pb.page when 1 then v_pb.open_group else v_pb.assignment end,'
                                       || ' v_pb.numberprgn'
                                       || ' ) pm1'
                                       || ' group by';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' pm1.country,'; 
      END IF;
      v_select_stmt := v_select_stmt || ' pm1.qgroup'
                                       || ' )'
                                       || ' union all'
                                       || ' ('
                                         || ' select'
                                       || ' psm1.qgroup,';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' psm1.country,'; 
      END IF;
      v_select_stmt := v_select_stmt || ' ''Incs Handled'' as type,'
                                       || ' count(psm1.numberprgn) as ticketcnt,'
                                       || ' 0 as timespent'
                                       || ' from'
                                       || ' ('
                                       || ' select';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.country,';
      END IF;
      v_select_stmt := v_select_stmt || ' v_psm.assignment as qgroup,'
                                       || ' v_psm.numberprgn'
                                       || ' from'
                                       || ' sc.v_probsummary v_psm, sc.v_problems v_pb' 
                                       || ' where'
                                       || ' v_psm.numberprgn = v_pb.numberprgn'
                                       || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.assignment', pgroup) || ')';
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';

      IF NOT (pcountry IN ('*', '%')) THEN
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.country', pcountry) || ')';
      END IF;                                 
      v_select_stmt := v_select_stmt || ' and v_psm.open_time <= to_date(''' || TO_CHAR(v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')'
                                       || ' and (v_psm.flag = ''t'' or v_psm.close_time >= to_date(''' || TO_CHAR(v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS''))'           
                                       || ' and v_pb.update_time between ' || v_date_range 
                                       || ' group by';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.country,';
      END IF;
      v_select_stmt := v_select_stmt || ' v_psm.assignment,'
                                          || ' v_psm.numberprgn'
                                       || ' ) psm1'
                                       || ' group by';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' psm1.country,';
      END IF;
      v_select_stmt := v_select_stmt || ' psm1.qgroup'
                                          || ' )'
                                       || ' union all'
                                       || ' ('
                                       || ' select'
                                       || ' v_psm.open_group as qgroup,';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.country,';
      END IF;
      v_select_stmt := v_select_stmt || ' ''Incs Opened'' as type,'
                                       || ' count(v_psm.numberprgn) as ticketcnt,'
                                       || ' 0 as timespent'
                                       || ' from'
                                       || ' sc.v_probsummary v_psm'
                                       || ' where'
                                       || ' (' || Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', pgroup) || ')';
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      IF NOT (pcountry IN ('*', '%')) THEN
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.country', pcountry) || ')';
      END IF;                                 
      v_select_stmt := v_select_stmt || ' and v_psm.open_time between ' || v_date_range
                                       || ' group by';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.country,';
      END IF;
      v_select_stmt := v_select_stmt || ' v_psm.open_group'
                                          || ' )'
                                       || ' union all'
                                       || ' ('
                                       || ' select'
                                       || ' v_psm.assignment as qgroup,';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.country,';
      END IF;
      v_select_stmt := v_select_stmt || ' decode(v_psm.flag, ''t'', ''Incs in Queue'', ''f'', ''Incs Closed'', ''Other'') as type,'
                                       || ' count(v_psm.numberprgn) as ticketcnt,'
                                       || ' sum(v_psm.pfz_total_time_spent) as timespent'
                                       || ' from'
                                       || ' sc.v_probsummary v_psm'
                                       || ' where'
                                       || ' (' || Bipkg_Utils.bifnc_createinlist ('v_psm.assignment', pgroup) || ')';
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      IF NOT (pcountry IN ('*', '%')) THEN
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.country', pcountry) || ')';
      END IF;                                 
      v_select_stmt := v_select_stmt || ' and (v_psm.flag  = ''t'' or v_psm.close_time between ' || v_date_range || ')'
                                       || ' group by';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.country,';
      END IF;
      v_select_stmt := v_select_stmt || ' v_psm.assignment,'
                                          || ' v_psm.flag'
                                       || ' )'
                                       || ' union all'
                                       || ' ('
                                       || ' select'
                                       || ' incidentsm1.pfz_orig_group as qgroup,';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' incidentsm1.country,';
      END IF;
      v_select_stmt := v_select_stmt || ' ''Calls Opened'' as type,'
                                       || ' count(incidentsm1.incident_id) as ticketcnt,'
                                       || ' 0 as timespent'
                                       || ' from'
                                       || ' incidentsm1'
                                       || ' where'
                                       || ' (' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.pfz_orig_group', pgroup) || ')';
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('NVL(incidentsm1.category, '' '')', vinteraction_type)|| ')';
      IF NOT (pcountry IN ('*', '%')) THEN
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.country', pcountry) || ')';
      END IF;                                 
      v_select_stmt := v_select_stmt || ' and incidentsm1.open_time between ' || v_date_range
                                       || ' group by';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' incidentsm1.country,'; 
      END IF;
      v_select_stmt := v_select_stmt || ' incidentsm1.pfz_orig_group'
                                     || ' )'
                                       || ' union all'
                                       || ' ('
                                       || ' select'
                                       || ' incidentsm1.pfz_orig_group as qgroup,';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' incidentsm1.country,';
      END IF;
      v_select_stmt := v_select_stmt || ' ''Calls Closed'' as type,' 
                                       || ' count(incidentsm1.incident_id) as ticketcnt,'
                                       || ' 0 as timespent'
                                       || ' from'
                                       || ' incidentsm1'
                                       || ' where'
                                       || ' (' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.pfz_orig_group', pgroup) || ')';
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('NVL(incidentsm1.category, '' '')', vinteraction_type)|| ')';
      IF NOT (pcountry IN ('*', '%')) THEN
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.country', pcountry) || ')';
      END IF;                                 
      v_select_stmt := v_select_stmt || ' and incidentsm1.close_time between ' || v_date_range
                                       || ' group by';
      IF p_c_or_s = 'C' THEN    
      v_select_stmt := v_select_stmt || ' incidentsm1.country,';
      END IF;
      v_select_stmt := v_select_stmt || ' incidentsm1.pfz_orig_group'
                                     || ' )'
                                       || ' ) tc,'
                                       || ' pfzsitesm1'
                                       || ' where'
                                       || ' substr(tc.qgroup, 1, 3) = pfzsitesm1.site_id';
                                             
      OPEN activity_summary_cursor FOR v_select_stmt;
                                                                                                  
   END bisp_activity_summary;
   
   
   PROCEDURE bisp_activity_summary_generic (
      act_summ_generic_cursor IN OUT bisp_refcursor_type,
      pgroup                  IN   VARCHAR2,
      preportby                    IN   VARCHAR2,
      pfilterby                  IN   VARCHAR2,
      pzone                    IN   VARCHAR2,
      pfrequency            IN   VARCHAR2,
      poverride                  IN   VARCHAR2,
      pstartdate              IN   DATE,
      penddate                  IN   DATE,
      vinteraction_type         IN     VARCHAR2
   )
   IS
      v_startdatedisplay   VARCHAR2 (19);
      v_enddatedisplay     VARCHAR2 (19);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
      v_date_range           VARCHAR2 (124);
      v_db_zone            VARCHAR2 (3);
      v_select_stmt       VARCHAR2 (32767);
   BEGIN
      v_db_zone := 'GMT';
      Bipkg_Utils.bisp_getstartandenddates (pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
      v_startdatedisplay   := TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
      v_enddatedisplay     := TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
      v_date_range         := 'to_date(''' || TO_CHAR(v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'') and to_date(''' || TO_CHAR(v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';

       v_select_stmt := v_select_stmt || ' select'
                                                                            || ' tc.qgroup,'    ;
                                                                                           
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt  || ' nvl(tc.country, ''UNKNOWN'') as reportby,';       
      ELSIF preportby = 'Site' THEN
      v_select_stmt := v_select_stmt || ' CONCAT(CONCAT(SUBSTR(tc.qgroup, 1, 3), '' - ''), pfzsitesm1.description) as reportby,';  
      ELSIF preportby = 'Product' THEN
      v_select_stmt := v_select_stmt || ' tc.product_type as reportby,';      
      ELSE
      v_select_stmt := v_select_stmt || ' ''NA'' as reportby,';
      END IF;
      
--      v_select_stmt := v_select_stmt  || ' substr(tc.qgroup, 1, 3) as site,'
--                                                                   || ' pfzsitesm1.description as sitedescr,';
                                                                   
      v_select_stmt := v_select_stmt  || ' tc.type,'
                                                                    || ' tc.ticketcnt,'
                                                                    || ' tc.timespent,'
                                                                    || ' to_date(''' || v_startdatedisplay || ''', ''DD-MM-YYYY HH24:MI:SS'') as StartDateDisplay,' 
                                                                    || ' to_date(''' || v_enddatedisplay || ''', ''DD-MM-YYYY HH24:MI:SS'') as EndDateDisplay'
                                                                       || ' from'
                                                                       || ' ('
                                                                       || ' ('
                                                                       || ' select pm1.qgroup,';
                                                                   
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' pm1.country,';   
      ELSIF preportby = 'Product' THEN
      v_select_stmt := v_select_stmt || ' pm1.product_type,';
      END IF;
        
      v_select_stmt := v_select_stmt || ' ''Incs Activity'' as type,'
                                       || ' count(pm1.numberprgn) as ticketcnt,'
                                       || ' 0 as timespent'
                                       || ' from'
                                       || ' ('
                                       || ' select';
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' v_pb.country,';
      ELSIF preportby = 'Product' THEN
      v_select_stmt := v_select_stmt || ' v_pb.product_type, ';      
      END IF;
      v_select_stmt := v_select_stmt || ' case v_pb.page when 1 then v_pb.open_group else v_pb.assignment end as qgroup,'
                                       || ' v_pb.numberprgn'
                                       || ' from'
                                       || ' sc.v_problems v_pb' 
                                       || ' where'
                                       || ' ('
                                       || ' (v_pb.page = 1 and (' || Bipkg_Utils.bifnc_createinlist ('v_pb.open_group', pgroup) || '))'
                                       || ' or'
                                       || ' (v_pb.page <> 1 and (' || Bipkg_Utils.bifnc_createinlist ('v_pb.assignment', pgroup) || '))'
                                       || ' )';
      IF NOT (pfilterby IN ('*', '%')) THEN
      IF preportby = 'Country' THEN
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_pb.country', pfilterby) || ')';
      ELSIF preportby = 'Product' THEN
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_pb.product_type', pfilterby) || ')';      
      END IF;
      END IF;             
      v_select_stmt := v_select_stmt || ' and v_pb.update_time between ' || v_date_range 
                                       || ' group by';
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' v_pb.country,'; 
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' v_pb.product_type,';       
      END IF;
      v_select_stmt := v_select_stmt || ' case v_pb.page when 1 then v_pb.open_group else v_pb.assignment end,'
                                       || ' v_pb.numberprgn'
                                       || ' ) pm1'
                                       || ' group by';
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' pm1.country,'; 
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' pm1.product_Type,';       
      END IF;
      v_select_stmt := v_select_stmt || ' pm1.qgroup'
                                       || ' )'
                                       || ' union all'
                                       || ' ('
                                         || ' select'
                                       || ' psm1.qgroup,';
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' psm1.country,'; 
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' psm1.product_type,';       
      END IF;
      v_select_stmt := v_select_stmt || ' ''Incs Handled'' as type,'
                                       || ' count(psm1.numberprgn) as ticketcnt,'
                                       || ' 0 as timespent'
                                       || ' from'
                                       || ' ('
                                       || ' select';
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.country,';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.product_type,';      
      END IF;
      v_select_stmt := v_select_stmt || ' v_psm.assignment as qgroup,'
                                       || ' v_psm.numberprgn'
                                       || ' from'
                                       || ' sc.v_probsummary v_psm, sc.v_problems v_pb' 
                                       || ' where'
                                       || ' v_psm.numberprgn = v_pb.numberprgn'
                                       || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.assignment', pgroup) || ')';                                     
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      IF NOT (pfilterby IN ('*', '%')) THEN
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.country', pfilterby) || ')';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.product_type', pfilterby) || ')';
      END IF;
      END IF;                                       
      v_select_stmt := v_select_stmt || ' and v_psm.open_time <= to_date(''' || TO_CHAR(v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')'
                                       || ' and (v_psm.flag = ''t'' or v_psm.close_time >= to_date(''' || TO_CHAR(v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS''))'           
                                       || ' and v_pb.update_time between ' || v_date_range 
                                       || ' group by';                                     
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.country,';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.product_type,';      
      END IF;                                     
      v_select_stmt := v_select_stmt || ' v_psm.assignment,'
                                          || ' v_psm.numberprgn'
                                       || ' ) psm1'
                                       || ' group by';

      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' psm1.country,';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' psm1.product_type,';      
      END IF;        

      v_select_stmt := v_select_stmt || ' psm1.qgroup'
                                          || ' )'
                                       || ' union all'
                                       || ' ('
                                       || ' select'
                                       || ' v_psm.open_group as qgroup,';
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.country,';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.product_type,';      
      END IF;        
      v_select_stmt := v_select_stmt || ' ''Incs Opened'' as type,'
                                       || ' count(v_psm.numberprgn) as ticketcnt,'
                                       || ' 0 as timespent'
                                       || ' from'
                                       || ' sc.v_probsummary v_psm'
                                       || ' where'
                                       || ' (' || Bipkg_Utils.bifnc_createinlist ('v_psm.open_group', pgroup) || ')';
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      IF NOT (pfilterby IN ('*', '%')) THEN
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.country', pfilterby) || ')';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.product_type', pfilterby) || ')';
      END IF;
      END IF;                                         
      v_select_stmt := v_select_stmt || ' and v_psm.open_time between ' || v_date_range
                                       || ' group by';
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.country,';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.product_type,';      
      END IF;        
      v_select_stmt := v_select_stmt || ' v_psm.open_group'
                                          || ' )'
                                       || ' union all'
                                       || ' ('
                                       || ' select'
                                       || ' v_psm.assignment as qgroup,';
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.country,';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.product_type,';      
      END IF;        
      v_select_stmt := v_select_stmt || ' decode(v_psm.flag, ''t'', ''Incs in Queue'', ''f'', ''Incs Closed'', ''Other'') as type,'
                                       || ' count(v_psm.numberprgn) as ticketcnt,'
                                       || ' sum(v_psm.pfz_total_time_spent) as timespent'
                                       || ' from'
                                       || ' sc.v_probsummary v_psm'
                                       || ' where'
                                       || ' (' || Bipkg_Utils.bifnc_createinlist ('v_psm.assignment', pgroup) || ')';
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('NVL(v_psm.category, '' '')', vinteraction_type)|| ')';
      IF NOT (pfilterby IN ('*', '%')) THEN
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.country', pfilterby) || ')';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('v_psm.product_type', pfilterby) || ')';
      END IF;
      END IF;                                         
      v_select_stmt := v_select_stmt || ' and (v_psm.flag  = ''t'' or v_psm.close_time between ' || v_date_range || ')'
                                       || ' group by';
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.country,';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' v_psm.product_type,';      
      END IF;        
      v_select_stmt := v_select_stmt || ' v_psm.assignment,'
                                          || ' v_psm.flag'
                                       || ' )'
                                       || ' union all'
                                       || ' ('
                                       || ' select'
                                       || ' incidentsm1.pfz_orig_group as qgroup,';
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' incidentsm1.country,';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' incidentsm1.product_type,';      
      END IF;
      v_select_stmt := v_select_stmt || ' ''Calls Opened'' as type,'
                                       || ' count(incidentsm1.incident_id) as ticketcnt,'
                                       || ' 0 as timespent'
                                       || ' from'
                                       || ' incidentsm1'
                                       || ' where'
                                       || ' (' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.pfz_orig_group', pgroup) || ')';
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('NVL(incidentsm1.category, '' '')', vinteraction_type)|| ')';
      IF NOT (pfilterby IN ('*', '%')) THEN
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.country', pfilterby) || ')';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.product_type', pfilterby) || ')';
      END IF;
      END IF;                     
      v_select_stmt := v_select_stmt || ' and incidentsm1.open_time between ' || v_date_range
                                       || ' group by';
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' incidentsm1.country,';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' incidentsm1.product_type,';      
      END IF;
      v_select_stmt := v_select_stmt || ' incidentsm1.pfz_orig_group'
                                     || ' )'
                                       || ' union all'
                                       || ' ('
                                       || ' select'
                                       || ' incidentsm1.pfz_orig_group as qgroup,';
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' incidentsm1.country,';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' incidentsm1.product_type,';      
      END IF;
      v_select_stmt := v_select_stmt || ' ''Calls Closed'' as type,' 
                                       || ' count(incidentsm1.incident_id) as ticketcnt,'
                                       || ' 0 as timespent'
                                       || ' from'
                                       || ' incidentsm1'
                                       || ' where'
                                       || ' (' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.pfz_orig_group', pgroup) || ')';
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('NVL(incidentsm1.category, '' '')', vinteraction_type)|| ')';
      IF NOT (pfilterby IN ('*', '%')) THEN
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.country', pfilterby) || ')';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('incidentsm1.product_type', pfilterby) || ')';
      END IF;
      END IF;                             
      v_select_stmt := v_select_stmt || ' and incidentsm1.close_time between ' || v_date_range
                                       || ' group by';
      IF preportby = 'Country' THEN    
      v_select_stmt := v_select_stmt || ' incidentsm1.country,';
      ELSIF preportby = 'Product' THEN    
      v_select_stmt := v_select_stmt || ' incidentsm1.product_type,';      
      END IF;
      v_select_stmt := v_select_stmt || ' incidentsm1.pfz_orig_group'
                                     || ' )'
                                       || ' ) tc,'
                                       || ' pfzsitesm1'
                                       || ' where'
                                       || ' substr(tc.qgroup, 1, 3) = pfzsitesm1.site_id';
                                             
      OPEN act_summ_generic_cursor FOR v_select_stmt;
                                                                                                  
   END bisp_activity_summary_generic;      
END Bipkg_Gv_Activity_Summary;
/

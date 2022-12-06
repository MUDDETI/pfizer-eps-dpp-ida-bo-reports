CREATE OR REPLACE PACKAGE Bipkg_Activity_Summary 
AS
   TYPE bisp_refcursor_type IS REF CURSOR;

/******************************************************************************
   name:       bipkg_activity_summary
   purpose:

   revisions:
   ver        date        author           description
   ---------  ----------  ---------------  ------------------------------------
   1.0		  07/25/2006  -sgummadi-	   1. added bisp_activity_summary procedure  
******************************************************************************/

   PROCEDURE bisp_activity_summary (
      activity_summary_cursor IN OUT bisp_refcursor_type,
	  pgroup				  IN 	 VARCHAR2,
	  pcountry				  IN	 VARCHAR2,
	  p_c_or_s				  IN	 VARCHAR2,
	  pzone					  IN	 VARCHAR2,
	  pfrequency			  IN	 VARCHAR2,
	  poverride				  IN	 VARCHAR2,
	  pstartdate			  IN	 DATE,
      penddate				  IN	 DATE
   );  
   
   PROCEDURE bisp_activity_summary_generic (
      act_summ_generic_cursor IN OUT bisp_refcursor_type,
	  pgroup			  	IN   VARCHAR2,
	  preportby		  	  IN   VARCHAR2,
	  pfilterby			  	  IN   VARCHAR2,
	  pzone					 IN   VARCHAR2,
	  pfrequency		IN   VARCHAR2,
	  poverride			  IN   VARCHAR2,
	  pstartdate		  IN   DATE,
      penddate			 IN   DATE
   );  
END Bipkg_Activity_Summary;
/
CREATE OR REPLACE PACKAGE BODY Bipkg_Activity_Summary
AS

/******************************************************************************
   name:       bisp_activity_summary 
   purpose:

   revisions:
   ver        date        author          description
   ---------  ----------  ---------------  ------------------------------------
	1.0		  07/25/2006 	-sgummadi-		1. developed bisp_activity_summary proc 
******************************************************************************/
    
   PROCEDURE bisp_activity_summary (
      activity_summary_cursor	   IN OUT	  bisp_refcursor_type,
	  pgroup        			   IN         VARCHAR2,
	  pcountry			 		   IN		  VARCHAR2,
	  p_c_or_s			 		   IN		  VARCHAR2,
	  pzone				 		   IN		  VARCHAR2,
	  pfrequency		 		   IN		  VARCHAR2,
	  poverride			 		   IN		  VARCHAR2,
	  pstartdate         		   IN         DATE,
      penddate           		   IN         DATE
   )
   IS
      v_startdatedisplay   VARCHAR2 (19);
      v_enddatedisplay     VARCHAR2 (19);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_date_range		   VARCHAR2 (124);
      v_db_zone            VARCHAR2 (3);
      v_select_stmt	   VARCHAR2 (32767);
   BEGIN
      v_db_zone := 'GMT';
      Bipkg_Utils.bisp_getstartandenddates (pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
      v_startdatedisplay   := TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
      v_enddatedisplay     := TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
      v_date_range  	   := 'to_date(''' || TO_CHAR(v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'') and to_date(''' || TO_CHAR(v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';

	  v_select_stmt := v_select_stmt || ' select'
	  				   				 	  		 				  || ' tc.qgroup,'	;  								 
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
	  v_select_stmt := v_select_stmt || ' problemm1.country,';
	  END IF;
	  v_select_stmt := v_select_stmt || ' case problemm1.page when 1 then problemm1.open_group else problemm1.assignment end as qgroup,'
						  			 || ' problemm1.numberprgn'
						  			 || ' from'
						  			 || ' problemm1' 
						  			 || ' where'
						  			 || ' ('
						  			 || ' (problemm1.page = 1 and (' || Bipkg_Utils.bifnc_createinlist ('problemm1.open_group', pgroup) || '))'
						  			 || ' or'
						  			 || ' (problemm1.page <> 1 and (' || Bipkg_Utils.bifnc_createinlist ('problemm1.assignment', pgroup) || '))'
						  			 || ' )';
      IF NOT (pcountry IN ('*', '%')) THEN
	  v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('problemm1.country', pcountry) || ')';
      END IF;								 
	  v_select_stmt := v_select_stmt || ' and problemm1.update_time between ' || v_date_range 
						  			 || ' group by';
      IF p_c_or_s = 'C' THEN	
	  v_select_stmt := v_select_stmt || ' problemm1.country,'; 
	  END IF;
	  v_select_stmt := v_select_stmt || ' case problemm1.page when 1 then problemm1.open_group else problemm1.assignment end,'
						  			 || ' problemm1.numberprgn'
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
	  v_select_stmt := v_select_stmt || ' probsummarym1.country,';
	  END IF;
	  v_select_stmt := v_select_stmt || ' probsummarym1.assignment as qgroup,'
						  			 || ' probsummarym1.numberprgn'
						  			 || ' from'
						  			 || ' probsummarym1, problemm1' 
						  			 || ' where'
						  			 || ' probsummarym1.numberprgn = problemm1.numberprgn'
						  			 || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.assignment', pgroup) || ')';
      IF NOT (pcountry IN ('*', '%')) THEN
	  v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.country', pcountry) || ')';
      END IF;								 
	  v_select_stmt := v_select_stmt || ' and probsummarym1.open_time <= to_date(''' || TO_CHAR(v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')'
						  			 || ' and (probsummarym1.flag = ''t'' or probsummarym1.close_time >= to_date(''' || TO_CHAR(v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS''))' 		  
						  			 || ' and problemm1.update_time between ' || v_date_range 
						  			 || ' group by';
      IF p_c_or_s = 'C' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.country,';
	  END IF;
	  v_select_stmt := v_select_stmt || ' probsummarym1.assignment,'
	  				   				 || ' probsummarym1.numberprgn'
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
						  			 || ' probsummarym1.open_group as qgroup,';
      IF p_c_or_s = 'C' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.country,';
	  END IF;
	  v_select_stmt := v_select_stmt || ' ''Incs Opened'' as type,'
						  			 || ' count(probsummarym1.numberprgn) as ticketcnt,'
						  			 || ' 0 as timespent'
						  			 || ' from'
						  			 || ' probsummarym1'
						  			 || ' where'
						  			 || ' (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', pgroup) || ')';
      IF NOT (pcountry IN ('*', '%')) THEN
	  v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.country', pcountry) || ')';
      END IF;								 
	  v_select_stmt := v_select_stmt || ' and probsummarym1.open_time between ' || v_date_range
						  			 || ' group by';
      IF p_c_or_s = 'C' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.country,';
	  END IF;
	  v_select_stmt := v_select_stmt || ' probsummarym1.open_group'
	  				   				 || ' )'
						  			 || ' union all'
						  			 || ' ('
						  			 || ' select'
						  			 || ' probsummarym1.assignment as qgroup,';
      IF p_c_or_s = 'C' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.country,';
	  END IF;
	  v_select_stmt := v_select_stmt || ' decode(probsummarym1.flag, ''t'', ''Incs in Queue'', ''f'', ''Incs Closed'', ''Other'') as type,'
						  			 || ' count(probsummarym1.numberprgn) as ticketcnt,'
						  			 || ' sum(probsummarym1.pfz_total_time_spent) as timespent'
						  			 || ' from'
						  			 || ' probsummarym1'
						  			 || ' where'
						  			 || ' (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.assignment', pgroup) || ')';
      IF NOT (pcountry IN ('*', '%')) THEN
	  v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.country', pcountry) || ')';
      END IF;								 
	  v_select_stmt := v_select_stmt || ' and (probsummarym1.flag  = ''t'' or probsummarym1.close_time between ' || v_date_range || ')'
						  			 || ' group by';
      IF p_c_or_s = 'C' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.country,';
	  END IF;
	  v_select_stmt := v_select_stmt || ' probsummarym1.assignment,'
	  				   				 || ' probsummarym1.flag'
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
	  pgroup			  	IN   VARCHAR2,
	  preportby		  	  IN   VARCHAR2,
	  pfilterby			  	  IN   VARCHAR2,
	  pzone					 IN   VARCHAR2,
	  pfrequency		IN   VARCHAR2,
	  poverride			  IN   VARCHAR2,
	  pstartdate		  IN   DATE,
      penddate			 IN   DATE
   )
   IS
      v_startdatedisplay   VARCHAR2 (19);
      v_enddatedisplay     VARCHAR2 (19);
      v_gmt_startdate      DATE;
      v_gmt_enddate        DATE;
	  v_date_range		   VARCHAR2 (124);
      v_db_zone            VARCHAR2 (3);
      v_select_stmt	   VARCHAR2 (32767);
   BEGIN
      v_db_zone := 'GMT';
      Bipkg_Utils.bisp_getstartandenddates (pfrequency, poverride, pzone, pstartdate, penddate, v_gmt_startdate, v_gmt_enddate);
      v_startdatedisplay   := TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (v_gmt_startdate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
      v_enddatedisplay     := TO_CHAR (Bipkg_Utils.bifnc_adjustfortz (v_gmt_enddate,v_db_zone,pzone),'DD-MM-YYYY HH24:MI:SS');
      v_date_range  	   := 'to_date(''' || TO_CHAR(v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'') and to_date(''' || TO_CHAR(v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')';

	   v_select_stmt := v_select_stmt || ' select'
	  				   				 	  		 				   || ' tc.qgroup,'	;
																  						 
      IF preportby = 'Country' THEN	
	  v_select_stmt := v_select_stmt  || ' nvl(tc.country, ''UNKNOWN'') as reportby,'; 	  
	  ELSIF preportby = 'Site' THEN
	  v_select_stmt := v_select_stmt || ' CONCAT(CONCAT(SUBSTR(tc.qgroup, 1, 3), '' - ''), pfzsitesm1.description) as reportby,';  
	  ELSIF preportby = 'Product' THEN
	  v_select_stmt := v_select_stmt || ' tc.product_type as reportby,';	  
	  ELSE
	  v_select_stmt := v_select_stmt || ' ''NA'' as reportby,';
	  END IF;
	  
--	  v_select_stmt := v_select_stmt  || ' substr(tc.qgroup, 1, 3) as site,'
--																   || ' pfzsitesm1.description as sitedescr,';
																   
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
	  v_select_stmt := v_select_stmt || ' problemm1.country,';
	  ELSIF preportby = 'Product' THEN
	  v_select_stmt := v_select_stmt || ' problemm1.product_type, ';	  
	  END IF;
	  v_select_stmt := v_select_stmt || ' case problemm1.page when 1 then problemm1.open_group else problemm1.assignment end as qgroup,'
						  			 || ' problemm1.numberprgn'
						  			 || ' from'
						  			 || ' problemm1' 
						  			 || ' where'
						  			 || ' ('
						  			 || ' (problemm1.page = 1 and (' || Bipkg_Utils.bifnc_createinlist ('problemm1.open_group', pgroup) || '))'
						  			 || ' or'
						  			 || ' (problemm1.page <> 1 and (' || Bipkg_Utils.bifnc_createinlist ('problemm1.assignment', pgroup) || '))'
						  			 || ' )';
      IF NOT (pfilterby IN ('*', '%')) THEN
	  IF preportby = 'Country' THEN
	  v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('problemm1.country', pfilterby) || ')';
	  ELSIF preportby = 'Product' THEN
	  v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('problemm1.product_type', pfilterby) || ')';	  
      END IF;
	  END IF;			 
	  v_select_stmt := v_select_stmt || ' and problemm1.update_time between ' || v_date_range 
						  			 || ' group by';
      IF preportby = 'Country' THEN	
	  v_select_stmt := v_select_stmt || ' problemm1.country,'; 
      ELSIF preportby = 'Product' THEN	
	  v_select_stmt := v_select_stmt || ' problemm1.product_type,'; 	  
	  END IF;
	  v_select_stmt := v_select_stmt || ' case problemm1.page when 1 then problemm1.open_group else problemm1.assignment end,'
						  			 || ' problemm1.numberprgn'
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
	  v_select_stmt := v_select_stmt || ' probsummarym1.country,';
      ELSIF preportby = 'Product' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.product_type,';	  
	  END IF;
	  v_select_stmt := v_select_stmt || ' probsummarym1.assignment as qgroup,'
						  			 || ' probsummarym1.numberprgn'
						  			 || ' from'
						  			 || ' probsummarym1, problemm1' 
						  			 || ' where'
						  			 || ' probsummarym1.numberprgn = problemm1.numberprgn'
						  			 || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.assignment', pgroup) || ')';									 
      IF NOT (pfilterby IN ('*', '%')) THEN
	  IF preportby = 'Country' THEN	
	  v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.country', pfilterby) || ')';
      ELSIF preportby = 'Product' THEN	
	  v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.product_type', pfilterby) || ')';
	  END IF;
      END IF;								  	 
	  v_select_stmt := v_select_stmt || ' and probsummarym1.open_time <= to_date(''' || TO_CHAR(v_gmt_startdate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS'')'
						  			 || ' and (probsummarym1.flag = ''t'' or probsummarym1.close_time >= to_date(''' || TO_CHAR(v_gmt_enddate, 'DD-MM-YYYY HH24:MI:SS') || ''', ''DD-MM-YYYY HH24:MI:SS''))' 		  
						  			 || ' and problemm1.update_time between ' || v_date_range 
						  			 || ' group by';									 
      IF preportby = 'Country' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.country,';
      ELSIF preportby = 'Product' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.product_type,';	  
	  END IF;									 
	  v_select_stmt := v_select_stmt || ' probsummarym1.assignment,'
	  				   				 || ' probsummarym1.numberprgn'
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
						  			 || ' probsummarym1.open_group as qgroup,';
      IF preportby = 'Country' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.country,';
      ELSIF preportby = 'Product' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.product_type,';	  
	  END IF;		
	  v_select_stmt := v_select_stmt || ' ''Incs Opened'' as type,'
						  			 || ' count(probsummarym1.numberprgn) as ticketcnt,'
						  			 || ' 0 as timespent'
						  			 || ' from'
						  			 || ' probsummarym1'
						  			 || ' where'
						  			 || ' (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.open_group', pgroup) || ')';
      IF NOT (pfilterby IN ('*', '%')) THEN
	  IF preportby = 'Country' THEN	
	  v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.country', pfilterby) || ')';
      ELSIF preportby = 'Product' THEN	
	  v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.product_type', pfilterby) || ')';
	  END IF;
      END IF;										 
	  v_select_stmt := v_select_stmt || ' and probsummarym1.open_time between ' || v_date_range
						  			 || ' group by';
      IF preportby = 'Country' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.country,';
      ELSIF preportby = 'Product' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.product_type,';	  
	  END IF;		
	  v_select_stmt := v_select_stmt || ' probsummarym1.open_group'
	  				   				 || ' )'
						  			 || ' union all'
						  			 || ' ('
						  			 || ' select'
						  			 || ' probsummarym1.assignment as qgroup,';
      IF preportby = 'Country' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.country,';
      ELSIF preportby = 'Product' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.product_type,';	  
	  END IF;		
	  v_select_stmt := v_select_stmt || ' decode(probsummarym1.flag, ''t'', ''Incs in Queue'', ''f'', ''Incs Closed'', ''Other'') as type,'
						  			 || ' count(probsummarym1.numberprgn) as ticketcnt,'
						  			 || ' sum(probsummarym1.pfz_total_time_spent) as timespent'
						  			 || ' from'
						  			 || ' probsummarym1'
						  			 || ' where'
						  			 || ' (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.assignment', pgroup) || ')';
      IF NOT (pfilterby IN ('*', '%')) THEN
	  IF preportby = 'Country' THEN	
	  v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.country', pfilterby) || ')';
      ELSIF preportby = 'Product' THEN	
	  v_select_stmt := v_select_stmt || ' and (' || Bipkg_Utils.bifnc_createinlist ('probsummarym1.product_type', pfilterby) || ')';
	  END IF;
      END IF;										 
	  v_select_stmt := v_select_stmt || ' and (probsummarym1.flag  = ''t'' or probsummarym1.close_time between ' || v_date_range || ')'
						  			 || ' group by';
      IF preportby = 'Country' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.country,';
      ELSIF preportby = 'Product' THEN	
	  v_select_stmt := v_select_stmt || ' probsummarym1.product_type,';	  
	  END IF;		
	  v_select_stmt := v_select_stmt || ' probsummarym1.assignment,'
	  				   				 || ' probsummarym1.flag'
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
END Bipkg_Activity_Summary;
/


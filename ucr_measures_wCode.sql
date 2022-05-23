/*
1) Build Fact TABLE 
2) Build SELECT QUERY TO pull ALL required DATA fields.

Objective OF project: We want TO know: How many labs are NOT reviewed OR reviewed?
Build TABLE WITH calculated fields IN excel FILE.
We have category fields based ON DATE/TIME.
*/

-- Tableau fields
-- Reviewed_Flag: IF [Reviewed Sw] = 1 THEN 'Reviewed'ELSEIF ([Result Recvd Sw] = 1 AND [Reviewed Sw] = 0) THEN 'Unreviewed'ELSE "Not Resulted" END as Reviewed_Flag
-- Test_Category: IF [Lab Cat Id] = 0 OR [Lab Cat Id] = 10 OR[Lab Cat Id] = 11 OR[Lab Cat Id] = 12 OR[Lab Cat Id] = 23 OR[Lab Cat Id] = 200000001 THEN 'Lab'ELSEIF[Lab Cat Id] = 1 OR [Lab Cat Id] = 2 OR[Lab Cat Id] = 3 OR[Lab Cat Id] = 6 THEN 'Radiology'ELSEOtherEND AS Test_Category
-- Turnaround Time: IF [Turnaround Time Pre-Calc] < 0 THEN 0 ELSE [Turnaround Time Pre-Calc] END as Turnaround Time
-- Turnaround Time Pre-Calc: DATEDIFF('day',IF [Result Recvd Date Time] < #1901-01-02#OR ISNULL([Result Recvd Date Time]) OR [Result Recvd Date Time] < [Encounter Date] THEN [Encounter Date]ELSE [Result Recvd Date Time] END,IF [Reviewed Sw] = 0 THEN TODAY()ELSEIF [Reviewed Date Time] < #1901-01-02#OR ISNULL([Reviewed Date Time])THEN [Encounter Date] + 1ELSE [Reviewed Date Time] END) as Turnaround Time Pre-Calc
-- Unreviewed Categories: IF [Test_Category] = 'Lab' AND [Critical_Flag] = 'Critical' AND Turnaround_Time > 90    THEN 'Critical Unreviewed > 3 Months'ELSEIF [Test_Category] = 'Lab' AND [Critical_Flag] = 'Critical' AND Turnaround_Time > 14 AND Turnaround_Time <= 90    THEN "Critical Unreviewed btw 2 Weeks and 3 Months"ELSEIF [Test_Category] = 'Lab' AND [Critical_Flag] = 'Critical' AND Turnaround_Time > 4 AND Turnaround_Time <= 14    THEN "Critical Unreviewed btw 5 Days and 2 Weeks"ELSEIF [Test_Category] = 'Lab' and [Critical_Flag] = 'Critical' and Turnaround_Time > 1 and Turnaround_Time <= 4    THEN "Critical Unreviewed btw 24 Hours and 4 Days"ELSEIF [Test_Category] = 'Lab' AND [Critical_Flag] = 'Critical' AND Turnaround_Time <= 1    THEN "Critical Unreviewed within 24 Hours"ELSEIF [Test_Category] = 'Lab' AND [Critical_Flag] = 'Non-Critical' AND Turnaround_Time > 90    THEN "Non-Critical Unreviewed > 3 Months"ELSEIF [Test_Category] = 'Lab' AND [Critical_Flag] = 'Non-Critical' AND Turnaround_Time > 14 AND Turnaround_Time <= 90    THEN "Non-Critical Unreviewed btw 2 Weeks and 3 Months"ELSEIF [Test_Category] = 'Lab' AND [Critical_Flag] = 'Non-Critical' AND Turnaround_Time > 4 AND Turnaround_Time <= 14    THEN "Non-Critical Unreviewed btw 5 Days and 2 Weeks"ELSEIF [Test_Category] = 'Lab' AND [Critical_Flag] = 'Non-Critical' AND Turnaround_Time <= 4    THEN "Non-Critical Unreviewed btw 0 days and 4 Days"else nullEND as Unreviewed Categories
-- Unreviewed Categories (Rad.): IF [Test_Category] = 'Radiology' AND Turnaround_Time > 90    THEN "Unreviewed > 3 Months"ELSEIF [Test_Category] = 'Radiology' AND Turnaround_Time > 14 and Turnaround_Time <= 90    THEN "Unreviewed btw 2 Weeks and 3 Months"ELSEIF [Test_Category] = 'Radiology' and Turnaround_Time > 4 AND Turnaround_Time <= 14    THEN "Unreviewed btw 5 Days and 2 Weeks"ELSEIF [Test_Category] = 'Radiology' AND Turnaround_Time >= 0 AND Turnaround_Time <= 4    THEN "Unreviewed btw 0 and 4 Days"END as Unreviewed Categories (Rad.)
-- Unreviewed Categories: IF [Critical_Flag] = 'Critical' AND (Order_Timeframe_Buckets = "3 Mos - 6 Mos" OR Order_Timeframe_Buckets = "6 Mos - 9 Mos" OR Order_Timeframe_Buckets = "9 Mos - 12 Mos")     THEN 'Critical Unreviewed > 3 Months'ELSEIF [Critical_Flag] = 'Critical' AND Order_Timeframe_Buckets = "2 Wks - 3 Mos"    THEN "Critical Unreviewed btw 2 Weeks and 3 Months"ELSEIF [Critical_Flag] = 'Critical' AND Order_Timeframe_Buckets = "5 Days - 2 Wks"    THEN "Critical Unreviewed btw 5 Days and 2 Weeks"ELSEIF [Critical_Flag] = 'Critical' AND Order_Timeframe_Buckets = "24 Hrs - 4 Days"    THEN "Critical Unreviewed btw 24 Hours and 4 Days"ELSEIF [Critical_Flag] = 'Critical' AND Order_Timeframe_Buckets = "< 24 Hrs"    THEN "Critical Unreviewed within 24 Hours"ELSEIF [Critical_Flag] = 'Non-Critical' AND (Order_Timeframe_Buckets = "3 Mos - 6 Mos" OR Order_Timeframe_Buckets = "6 Mos - 9 Mos" OR Order_Timeframe_Buckets = "9 Mos - 12 Mos")     THEN "Non-Critical Unreviewed > 3 Months"ELSEIF [Critical_Flag] = 'Non-Critical' AND Order_Timeframe_Buckets = "2 Wks - 3 Mos"     THEN "Non-Critical Unreviewed btw 2 Weeks and 3 Months"ELSEIF [Critical_Flag] = 'Non-Critical' AND Order_Timeframe_Buckets = "5 Days - 2 Wks"    THEN "Non-Critical Unreviewed btw 5 Days and 2 Weeks"ELSEIF [Critical_Flag] = 'Non-Critical' AND (Order_Timeframe_Buckets = "<24 Hrs" OR Order_Timeframe_Buckets = "24 Hrs - 4 Days")    THEN "Non-Critical Unreviewed btw 0 days and 4 Days"END
-- Unreviewed Categories (Rad.): IF [Critical_Flag] = 'Non-Critical' AND (Order_Timeframe_Buckets = "3 Mos - 6 Mos" OR Order_Timeframe_Buckets = "6 Mos - 9 Mos" OR Order_Timeframe_Buckets = "9 Mos - 12 Mos")     THEN "Unreviewed > 3 Months"ELSEIF [Critical_Flag] = 'Non-Critical' AND Order_Timeframe_Buckets = "2 Wks - 3 Mos"    THEN "Unreviewed btw 2 Weeks and 3 Months"ELSEIF [Critical_Flag] = 'Non-Critical' AND Order_Timeframe_Buckets = "5 Days - 2 Wks"    THEN "Unreviewed btw 5 Days and 2 Weeks"ELSEIF [Critical_Flag] = 'Non-Critical' AND (Order_Timeframe_Buckets = "24 Hrs - 4 Days" OR Order_Timeframe_Buckets = "< 24 Hrs")    THEN "Unreviewed btw 0 and 4 Days"END

/*SHOW TABLE EDWPS_Staging.facility;
SHOW TABLE edwps.EMR_Lab;
SHOW TABLE edwps.EMR_Lab_Detail;
SHOW TABLE edwps.Ref_EMR_Lab_Type;
SHOW TABLE EDWPS.Provider;
SHOW TABLE edwps_staging.Provider_Person;
SHOW TABLE edwps.Fact_EMR_Lab_Internal_Result;*/

--SEL * FROM EDWPS_staging.Fact_UCR_Measures;

--count of unique lab_sk 
/*SEL DISTINCT lab_sk, Count(DISTINCT lab_sk) AS count_lab 
FROM EDWPS_TEMP.Fact_UCR_Measures 
HAVING count_lab >= 1
GROUP BY 1*/

DEL FROM EDWPS_Staging.Fact_UCR_Measures;

--Insert into new table for UCR measures
INSERT INTO edwps_Staging.Fact_UCR_Measures

	SELECT 	lab.Lab_SK
			,fac.COID
			,lab.provider_dw_id
			,lab.patient_dw_id
			,lab.Collection_Date_Time
			,lab.Encounter_Date
			,lab.Lab_Cat_Id
			,labtype.Lab_Name
			,lab.Lab_Reason_Txt
			,lab.Lab_Result_Txt
			,lab.Critical_Lab_Sw
			,lab.Result_Recvd_Date_Time
			,lab.Result_Recvd_Sw
			,lab.reviewed_date_time
			,lab.Reviewed_Sw
			,CASE 
				WHEN lab.Reviewed_Sw = 1 THEN 'Reviewed' 
				WHEN (lab.Result_Recvd_Sw = 1 AND lab.Reviewed_Sw = 0) 	THEN 'Unreviewed' 
				ELSE 'Not Resulted' 
				END AS Reviewed_Flag
			,CASE 
				WHEN lab.Lab_Cat_Id = 0 OR lab.Lab_Cat_Id = 10 OR lab.Lab_Cat_Id = 11 OR lab.Lab_Cat_Id = 12 OR lab.Lab_Cat_Id = 23 OR lab.Lab_Cat_Id = 200000001 THEN 'Lab' 
				WHEN lab.Lab_Cat_Id = 1 OR lab.Lab_Cat_Id = 2 OR lab.Lab_Cat_Id = 3 OR lab.Lab_Cat_Id = 6 THEN 'Radiology' 
				ELSE 'Other' 
				END AS Test_Category
			,CASE 
				WHEN Turnaround_Time_Pre_Calc < 0 THEN 0 
				ELSE Turnaround_Time_Pre_Calc 
				END AS Turnaround_Time
			,CASE 
				WHEN lab.encounter_date IS NOT NULL THEN
					((CASE 
						WHEN lab.Reviewed_Sw = 0 THEN Current_Date
						WHEN (Cast(lab.reviewed_date_time AS DATE) < '1901-01-02' OR lab.reviewed_date_time IS NULL) THEN lab.Encounter_Date + 1
						ELSE Cast(lab.reviewed_date_time AS DATE) END)
					- (CASE 
						WHEN Cast(lab.Result_Recvd_Date_Time AS DATE) < '1901-01-02' OR lab.Result_Recvd_Date_Time IS NULL OR Cast(lab.Result_Recvd_Date_Time AS DATE) < lab.Encounter_Date
						THEN lab.Encounter_Date
						ELSE Cast(lab.Result_Recvd_Date_Time AS DATE) END))
				ELSE NULL END AS Turnaround_Time_Pre_Calc
				
	FROM EDWPS.EMR_Lab AS lab
	JOIN EDWPS_Staging.facility AS fac
		ON fac.COID = lab.COID
	JOIN edwps.Ref_EMR_Lab_Type AS labtype
		ON lab.lab_sk = labtype.lab_type_sk
	;
;

SHOW TABLE edwps.Person;
SHOW TABLE edwps.Physician_Current;
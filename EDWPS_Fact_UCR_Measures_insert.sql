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

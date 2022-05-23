DROP TABLE edwps_staging.Fact_UCR_Measures;

CREATE MULTISET TABLE edwps_staging.Fact_UCR_Measures ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO
     (
	 --primary key
	  Lab_SK DECIMAL(18,0) NOT NULL,
	  -- non-calculated metrics
	  Coid CHAR(5) CHARACTER SET Latin NOT CaseSpecific NOT NULL,
	  Provider_DW_Id DECIMAL(18,0),
	  Patient_DW_Id DECIMAL(18,0),
	  Collection_Date_Time TIMESTAMP(0),
	  Encounter_Date DATE FORMAT 'yyyy-mm-dd',
	  Lab_Cat_Id INTEGER,
	  Lab_Name VARCHAR(250) CHARACTER SET Latin NOT CaseSpecific,
	  Lab_Reason_Txt VARCHAR(255) CHARACTER SET Latin NOT CaseSpecific,
	  Lab_Result_Txt VARCHAR(255) CHARACTER SET Latin NOT CaseSpecific,
	  Critical_Lab_Sw BYTEINT,
	  Result_Recvd_Date_Time TIMESTAMP(0),
	  Result_Recvd_Sw BYTEINT Compress (0 ,1 ),
	  Reviewed_Date_Time TIMESTAMP(0),
	  Reviewed_Sw BYTEINT,
	   --calculated metrics
	  Reviewed_Flag VARCHAR(100) CHARACTER SET Latin NOT CaseSpecific,
	  Test_Category VARCHAR(100) CHARACTER SET Latin NOT CaseSpecific,
	  Turnaround_Time INTEGER,
	  Turnaround_Time_Pre_Calc INTEGER
	  )
UNIQUE PRIMARY INDEX XUPI_Fact_UCR_Measures ( Lab_SK);
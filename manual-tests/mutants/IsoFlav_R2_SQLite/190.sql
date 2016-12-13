-- 190
-- UCColumnE
-- ListElementExchanger with ChainedSupplier with UniqueConstraintSupplier and UniqueColumnsWithAlternativesSupplier - Exchanged DataSrc_ID with Food_Detail_Desc

CREATE TABLE "DATA_SRC" (
	"DataSrc_ID"	DECIMAL	CONSTRAINT "DATA_SRC_PrimaryKey" UNIQUE,
	"Authors"	TEXT,
	"Title"	TEXT,
	"Year"	DECIMAL,
	"Journal"	TEXT,
	"Vol"	TEXT,
	"Start_Page"	TEXT,
	"End_Page"	TEXT
)

CREATE TABLE "DATSRCLN" (
	"NDB_No"	TEXT,
	"Nutr_No"	TEXT,
	"DataSrc_ID"	DECIMAL
)

CREATE TABLE "FOOD_DES" (
	"NDB_No"	TEXT	CONSTRAINT "FOOD_DES_PrimaryKey" UNIQUE,
	"FdGrp_Cd"	TEXT,
	"Long_Desc"	TEXT
)

CREATE TABLE "ISFL_DAT" (
	"NDB_No"	TEXT,
	"Nutr_No"	TEXT,
	"Isfl_Val"	DECIMAL,
	"SD"	DECIMAL,
	"n"	DECIMAL,
	"Min"	DECIMAL,
	"Max"	DECIMAL,
	"CC"	TEXT,
	"DataSrc_ID"	TEXT,
	CONSTRAINT "ISFL_DAT_PrimaryKey" UNIQUE ("NDB_No", "Nutr_No")
)

CREATE TABLE "NUTR_DEF" (
	"Nutr_no"	TEXT	CONSTRAINT "NUTR_DEF_PrimaryKey" UNIQUE,
	"NutrDesc"	TEXT,
	"Unit"	TEXT
)

CREATE TABLE "SYBN_DTL" (
	"NDB_No"	TEXT,
	"Nutr_No"	TEXT,
	"DataSrc_ID"	DECIMAL,
	"FoodNo"	TEXT,
	"Food_Detail_Desc"	TEXT,
	"Nutr_Val"	DECIMAL,
	"Std_Dev"	DECIMAL,
	"Num_Data_Pts"	DECIMAL,
	"Sam_Hand_Rtg"	DECIMAL,
	"AnalMeth_Rtg"	DECIMAL,
	"SampPlan_Rtg"	DECIMAL,
	"AnalQC_Rtg"	DECIMAL,
	"NumSamp_QC"	DECIMAL,
	"CC"	TEXT,
	CONSTRAINT "SYBN_DTL_PrimaryKey" UNIQUE ("NDB_No", "Food_Detail_Desc", "FoodNo", "Nutr_No")
)


-- 33
-- PKCColumnA
-- ListElementAdder with ChainedSupplier with PrimaryKeyConstraintSupplier and PrimaryKeyColumnsWithAlternativesSupplier - Added AnalMeth_Rtg

CREATE TABLE "DATA_SRC" (
	"DataSrc_ID"	DECIMAL	CONSTRAINT "DATA_SRC_PrimaryKey" UNIQUE,
	"Authors"	LONGVARCHAR,
	"Title"	LONGVARCHAR,
	"Year"	DECIMAL,
	"Journal"	LONGVARCHAR,
	"Vol"	LONGVARCHAR,
	"Start_Page"	LONGVARCHAR,
	"End_Page"	LONGVARCHAR
)

CREATE TABLE "DATSRCLN" (
	"NDB_No"	LONGVARCHAR,
	"Nutr_No"	LONGVARCHAR,
	"DataSrc_ID"	DECIMAL
)

CREATE TABLE "FOOD_DES" (
	"NDB_No"	LONGVARCHAR	CONSTRAINT "FOOD_DES_PrimaryKey" UNIQUE,
	"FdGrp_Cd"	LONGVARCHAR,
	"Long_Desc"	LONGVARCHAR
)

CREATE TABLE "ISFL_DAT" (
	"NDB_No"	LONGVARCHAR,
	"Nutr_No"	LONGVARCHAR,
	"Isfl_Val"	DECIMAL,
	"SD"	DECIMAL,
	"n"	DECIMAL,
	"Min"	DECIMAL,
	"Max"	DECIMAL,
	"CC"	LONGVARCHAR,
	"DataSrc_ID"	LONGVARCHAR,
	CONSTRAINT "ISFL_DAT_PrimaryKey" UNIQUE ("NDB_No", "Nutr_No")
)

CREATE TABLE "NUTR_DEF" (
	"Nutr_no"	LONGVARCHAR	CONSTRAINT "NUTR_DEF_PrimaryKey" UNIQUE,
	"NutrDesc"	LONGVARCHAR,
	"Unit"	LONGVARCHAR
)

CREATE TABLE "SYBN_DTL" (
	"NDB_No"	LONGVARCHAR,
	"Nutr_No"	LONGVARCHAR,
	"DataSrc_ID"	DECIMAL,
	"FoodNo"	LONGVARCHAR,
	"Food_Detail_Desc"	LONGVARCHAR,
	"Nutr_Val"	DECIMAL,
	"Std_Dev"	DECIMAL,
	"Num_Data_Pts"	DECIMAL,
	"Sam_Hand_Rtg"	DECIMAL,
	"AnalMeth_Rtg"	DECIMAL	PRIMARY KEY,
	"SampPlan_Rtg"	DECIMAL,
	"AnalQC_Rtg"	DECIMAL,
	"NumSamp_QC"	DECIMAL,
	"CC"	LONGVARCHAR,
	CONSTRAINT "SYBN_DTL_PrimaryKey" UNIQUE ("NDB_No", "DataSrc_ID", "FoodNo", "Nutr_No")
)


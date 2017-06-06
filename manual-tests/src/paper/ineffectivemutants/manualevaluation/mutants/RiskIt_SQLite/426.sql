-- 426
-- FKCColumnPairE
-- ListElementExchanger with ChainedSupplier with ForeignKeyConstraintSupplier and ForeignKeyColumnPairWithAlternativesSupplier - Exchanged Pair(SSN, SSN) with Pair(SSN, SEX)

CREATE TABLE "userrecord" (
	"NAME"	CHAR(50),
	"ZIP"	CHAR(5),
	"SSN"	INT	PRIMARY KEY	NOT NULL,
	"AGE"	INT,
	"SEX"	CHAR(50),
	"MARITAL"	CHAR(50),
	"RACE"	CHAR(50),
	"TAXSTAT"	CHAR(50),
	"DETAIL"	CHAR(100),
	"HOUSEHOLDDETAIL"	CHAR(100),
	"FATHERORIGIN"	CHAR(50),
	"MOTHERORIGIN"	CHAR(50),
	"BIRTHCOUNTRY"	CHAR(50),
	"CITIZENSHIP"	CHAR(50)
)

CREATE TABLE "education" (
	"SSN"	INT	PRIMARY KEY	 REFERENCES "userrecord" ("SSN")	NOT NULL,
	"EDUCATION"	CHAR(50),
	"EDUENROLL"	CHAR(50)
)

CREATE TABLE "employmentstat" (
	"SSN"	INT	PRIMARY KEY	 REFERENCES "userrecord" ("SSN")	NOT NULL,
	"UNEMPLOYMENTREASON"	CHAR(50),
	"EMPLOYMENTSTAT"	CHAR(50)
)

CREATE TABLE "geo" (
	"REGION"	CHAR(50)	NOT NULL,
	"RESSTATE"	CHAR(50)	PRIMARY KEY	NOT NULL
)

CREATE TABLE "industry" (
	"INDUSTRYCODE"	INT	PRIMARY KEY	NOT NULL,
	"INDUSTRY"	CHAR(50),
	"STABILITY"	INT
)

CREATE TABLE "investment" (
	"SSN"	INT	PRIMARY KEY	 REFERENCES "userrecord" ("SSN")	NOT NULL,
	"CAPITALGAINS"	INT,
	"CAPITALLOSSES"	INT,
	"STOCKDIVIDENDS"	INT
)

CREATE TABLE "occupation" (
	"OCCUPATIONCODE"	INT	PRIMARY KEY	NOT NULL,
	"OCCUPATION"	CHAR(50),
	"STABILITY"	INT
)

CREATE TABLE "job" (
	"SSN"	INT	PRIMARY KEY	 REFERENCES "userrecord" ("SSN")	NOT NULL,
	"WORKCLASS"	CHAR(50),
	"INDUSTRYCODE"	INT	 REFERENCES "industry" ("INDUSTRYCODE"),
	"OCCUPATIONCODE"	INT	 REFERENCES "occupation" ("OCCUPATIONCODE"),
	"UNIONMEMBER"	CHAR(50),
	"EMPLOYERSIZE"	INT,
	"WEEKWAGE"	INT,
	"SELFEMPLOYED"	SMALLINT,
	"WORKWEEKS"	INT
)

CREATE TABLE "migration" (
	"SSN"	INT	PRIMARY KEY	 REFERENCES "userrecord" ("SSN")	NOT NULL,
	"MIGRATIONCODE"	CHAR(50),
	"MIGRATIONDISTANCE"	CHAR(50),
	"MIGRATIONMOVE"	CHAR(50),
	"MIGRATIONFROMSUNBELT"	CHAR(50)
)

CREATE TABLE "stateabbv" (
	"ABBV"	CHAR(2)	NOT NULL,
	"NAME"	CHAR(50)	NOT NULL
)

CREATE TABLE "wage" (
	"INDUSTRYCODE"	INT	 REFERENCES "industry" ("INDUSTRYCODE")	NOT NULL,
	"OCCUPATIONCODE"	INT	 REFERENCES "occupation" ("OCCUPATIONCODE")	NOT NULL,
	"MEANWEEKWAGE"	INT,
	PRIMARY KEY ("INDUSTRYCODE", "OCCUPATIONCODE")
)

CREATE TABLE "youth" (
	"SSN"	INT	PRIMARY KEY	 REFERENCES "userrecord" ("SEX")	NOT NULL,
	"PARENTS"	CHAR(50)
)

CREATE TABLE "ziptable" (
	"ZIP"	CHAR(5),
	"CITY"	CHAR(20),
	"STATENAME"	CHAR(20),
	"COUNTY"	CHAR(20)
)


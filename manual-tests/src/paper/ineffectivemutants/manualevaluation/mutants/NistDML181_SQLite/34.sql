-- 34
-- UCColumnA
-- Added UNIQUE to column TITLE in table ORDERS

CREATE TABLE "LONG_NAMED_PEOPLE" (
	"FIRSTNAME"	VARCHAR(373),
	"LASTNAME"	VARCHAR(373),
	"AGE"	INT,
	PRIMARY KEY ("FIRSTNAME", "LASTNAME")
)

CREATE TABLE "ORDERS" (
	"FIRSTNAME"	VARCHAR(373),
	"LASTNAME"	VARCHAR(373),
	"TITLE"	VARCHAR(80)	UNIQUE,
	"COST"	NUMERIC(5, 2),
	FOREIGN KEY ("FIRSTNAME", "LASTNAME") REFERENCES "LONG_NAMED_PEOPLE" ("FIRSTNAME", "LASTNAME")
)


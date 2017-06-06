-- 9
-- FKCColumnPairE
-- ListElementExchanger with ChainedSupplier with ForeignKeyConstraintSupplier and ForeignKeyColumnPairWithAlternativesSupplier - Exchanged Pair(FIRSTNAME, FIRSTNAME) with Pair(COST, FIRSTNAME)

CREATE TABLE "LONG_NAMED_PEOPLE" (
	"FIRSTNAME"	VARCHAR(373),
	"LASTNAME"	VARCHAR(373),
	"AGE"	INT,
	PRIMARY KEY ("FIRSTNAME", "LASTNAME")
)

CREATE TABLE "ORDERS" (
	"FIRSTNAME"	VARCHAR(373),
	"LASTNAME"	VARCHAR(373),
	"TITLE"	VARCHAR(80),
	"COST"	NUMERIC(5, 2),
	FOREIGN KEY ("LASTNAME", "COST") REFERENCES "LONG_NAMED_PEOPLE" ("LASTNAME", "FIRSTNAME")
)


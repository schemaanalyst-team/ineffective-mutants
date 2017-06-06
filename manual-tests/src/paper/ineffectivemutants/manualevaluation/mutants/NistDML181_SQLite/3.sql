-- 3
-- FKCColumnPairR
-- ListElementRemover with ChainedSupplier with ForeignKeyConstraintSupplier and ForeignKeyColumnSupplier - Removed Pair(FIRSTNAME, FIRSTNAME)

CREATE TABLE "LONG_NAMED_PEOPLE" (
	"FIRSTNAME"	VARCHAR(373),
	"LASTNAME"	VARCHAR(373),
	"AGE"	INT,
	PRIMARY KEY ("FIRSTNAME", "LASTNAME")
)

CREATE TABLE "ORDERS" (
	"FIRSTNAME"	VARCHAR(373),
	"LASTNAME"	VARCHAR(373)	 REFERENCES "LONG_NAMED_PEOPLE" ("LASTNAME"),
	"TITLE"	VARCHAR(80),
	"COST"	NUMERIC(5, 2)
)


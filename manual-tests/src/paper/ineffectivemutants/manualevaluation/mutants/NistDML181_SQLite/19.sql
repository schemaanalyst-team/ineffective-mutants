-- 19
-- PKCColumnR
-- ListElementRemover with ChainedSupplier with PrimaryKeyConstraintSupplier and PrimaryKeyColumnSupplier - Removed LASTNAME

CREATE TABLE "LONG_NAMED_PEOPLE" (
	"FIRSTNAME"	VARCHAR(373)	PRIMARY KEY,
	"LASTNAME"	VARCHAR(373),
	"AGE"	INT
)

CREATE TABLE "ORDERS" (
	"FIRSTNAME"	VARCHAR(373),
	"LASTNAME"	VARCHAR(373),
	"TITLE"	VARCHAR(80),
	"COST"	NUMERIC(5, 2),
	FOREIGN KEY ("FIRSTNAME", "LASTNAME") REFERENCES "LONG_NAMED_PEOPLE" ("FIRSTNAME", "LASTNAME")
)


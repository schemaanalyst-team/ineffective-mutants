-- 23
-- PKCColumnA
-- ListElementAdder with ChainedSupplier with PrimaryKeyConstraintSupplier and PrimaryKeyColumnsWithAlternativesSupplier - Added city

CREATE TABLE "Employee" (
	"id"	INT,
	"first"	VARCHAR(15),
	"last"	VARCHAR(20),
	"age"	INT,
	"address"	VARCHAR(30),
	"city"	VARCHAR(20),
	"state"	VARCHAR(20),
	PRIMARY KEY ("id", "city"),
	CHECK ("id" >= 0),
	CHECK ("age" > 0),
	CHECK ("age" <= 150)
)


-- 30
-- UCColumnR
-- ListElementRemover with ChainedSupplier with UniqueConstraintSupplier and UniqueColumnSupplier - Removed B

CREATE TABLE "T" (
	"A"	CHAR	CONSTRAINT "UniqueOnColsAandB" UNIQUE,
	"B"	CHAR,
	"C"	CHAR
)

CREATE TABLE "S" (
	"X"	CHAR,
	"Y"	CHAR,
	"Z"	CHAR,
	CONSTRAINT "RefToColsAandB" FOREIGN KEY ("X", "Y") REFERENCES "T" ("A", "B")
)


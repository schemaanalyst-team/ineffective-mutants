-- 29
-- UCColumnR
-- ListElementRemover with ChainedSupplier with UniqueConstraintSupplier and UniqueColumnSupplier - Removed A

CREATE TABLE "T" (
	"A"	CHAR,
	"B"	CHAR	CONSTRAINT "UniqueOnColsAandB" UNIQUE,
	"C"	CHAR
)

CREATE TABLE "S" (
	"X"	CHAR,
	"Y"	CHAR,
	"Z"	CHAR,
	CONSTRAINT "RefToColsAandB" FOREIGN KEY ("X", "Y") REFERENCES "T" ("A", "B")
)


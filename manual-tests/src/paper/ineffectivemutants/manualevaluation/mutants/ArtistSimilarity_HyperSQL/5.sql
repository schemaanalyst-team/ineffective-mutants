-- 5
-- PKCColumnA
-- ListElementAdder with ChainedSupplier with PrimaryKeyConstraintSupplier and PrimaryKeyColumnsWithAlternativesSupplier - Added target

CREATE TABLE "artists" (
	"artist_id"	LONGVARCHAR	PRIMARY KEY
)

CREATE TABLE "similarity" (
	"target"	LONGVARCHAR	PRIMARY KEY	 REFERENCES "artists" ("artist_id"),
	"similar"	LONGVARCHAR	 REFERENCES "artists" ("artist_id")
)


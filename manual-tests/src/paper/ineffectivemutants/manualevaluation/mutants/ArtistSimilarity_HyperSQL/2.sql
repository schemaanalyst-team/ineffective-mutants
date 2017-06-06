-- 2
-- FKCColumnPairR
-- ListElementRemover with ChainedSupplier with ForeignKeyConstraintSupplier and ForeignKeyColumnSupplier - Removed Pair(similar, artist_id)

CREATE TABLE "artists" (
	"artist_id"	LONGVARCHAR	PRIMARY KEY
)

CREATE TABLE "similarity" (
	"target"	LONGVARCHAR	 REFERENCES "artists" ("artist_id"),
	"similar"	LONGVARCHAR
)


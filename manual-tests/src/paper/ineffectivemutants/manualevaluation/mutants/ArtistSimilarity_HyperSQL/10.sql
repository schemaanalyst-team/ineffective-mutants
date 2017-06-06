-- 10
-- UCColumnA
-- Added UNIQUE to column target in table similarity

CREATE TABLE "artists" (
	"artist_id"	LONGVARCHAR	PRIMARY KEY
)

CREATE TABLE "similarity" (
	"target"	LONGVARCHAR	 REFERENCES "artists" ("artist_id")	UNIQUE,
	"similar"	LONGVARCHAR	 REFERENCES "artists" ("artist_id")
)


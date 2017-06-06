-- 11
-- UCColumnA
-- Added UNIQUE to column similar in table similarity

CREATE TABLE "artists" (
	"artist_id"	LONGVARCHAR	PRIMARY KEY
)

CREATE TABLE "similarity" (
	"target"	LONGVARCHAR	 REFERENCES "artists" ("artist_id"),
	"similar"	LONGVARCHAR	 REFERENCES "artists" ("artist_id")	UNIQUE
)


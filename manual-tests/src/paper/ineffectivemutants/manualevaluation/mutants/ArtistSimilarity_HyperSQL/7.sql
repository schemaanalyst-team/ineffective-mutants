-- 7
-- NNCA
-- Added NOT NULL to column artist_id in table artists

CREATE TABLE "artists" (
	"artist_id"	LONGVARCHAR	PRIMARY KEY	NOT NULL
)

CREATE TABLE "similarity" (
	"target"	LONGVARCHAR	 REFERENCES "artists" ("artist_id"),
	"similar"	LONGVARCHAR	 REFERENCES "artists" ("artist_id")
)


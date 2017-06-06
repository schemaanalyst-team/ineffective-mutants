-- 8
-- NNCA
-- Added NOT NULL to column target in table similarity

CREATE TABLE "artists" (
	"artist_id"	LONGVARCHAR	PRIMARY KEY
)

CREATE TABLE "similarity" (
	"target"	LONGVARCHAR	 REFERENCES "artists" ("artist_id")	NOT NULL,
	"similar"	LONGVARCHAR	 REFERENCES "artists" ("artist_id")
)


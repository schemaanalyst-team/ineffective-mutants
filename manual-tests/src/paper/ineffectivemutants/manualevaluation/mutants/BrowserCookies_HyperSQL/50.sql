-- 50
-- UCColumnA
-- Added UNIQUE to column host in table places

CREATE TABLE "places" (
	"host"	LONGVARCHAR	UNIQUE	NOT NULL,
	"path"	LONGVARCHAR	NOT NULL,
	"title"	LONGVARCHAR,
	"visit_count"	INT,
	"fav_icon_url"	LONGVARCHAR,
	PRIMARY KEY ("host", "path")
)

CREATE TABLE "cookies" (
	"id"	INT	PRIMARY KEY	NOT NULL,
	"name"	LONGVARCHAR	NOT NULL,
	"value"	LONGVARCHAR,
	"expiry"	INT,
	"last_accessed"	INT,
	"creation_time"	INT,
	"host"	LONGVARCHAR,
	"path"	LONGVARCHAR,
	FOREIGN KEY ("host", "path") REFERENCES "places" ("host", "path"),
	UNIQUE ("name", "host", "path"),
	CHECK ("expiry" = 0 OR "expiry" > "last_accessed"),
	CHECK ("last_accessed" >= "creation_time")
)


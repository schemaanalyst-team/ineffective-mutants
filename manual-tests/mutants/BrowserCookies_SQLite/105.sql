-- 105
-- UCColumnA
-- Added UNIQUE to column expiry in table cookies

CREATE TABLE "places" (
	"host"	TEXT	NOT NULL,
	"path"	TEXT	NOT NULL,
	"title"	TEXT,
	"visit_count"	INT,
	"fav_icon_url"	TEXT,
	PRIMARY KEY ("host", "path")
)

CREATE TABLE "cookies" (
	"id"	INT	PRIMARY KEY	NOT NULL,
	"name"	TEXT	NOT NULL,
	"value"	TEXT,
	"expiry"	INT	UNIQUE,
	"last_accessed"	INT,
	"creation_time"	INT,
	"host"	TEXT,
	"path"	TEXT,
	FOREIGN KEY ("host", "path") REFERENCES "places" ("host", "path"),
	UNIQUE ("name", "host", "path"),
	CHECK ("expiry" = 0 OR "expiry" > "last_accessed"),
	CHECK ("last_accessed" >= "creation_time")
)


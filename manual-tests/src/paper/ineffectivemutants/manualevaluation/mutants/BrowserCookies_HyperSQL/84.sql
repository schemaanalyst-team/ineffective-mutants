-- 84
-- UCColumnE
-- ListElementExchanger with ChainedSupplier with UniqueConstraintSupplier and UniqueColumnsWithAlternativesSupplier - Exchanged path with creation_time

CREATE TABLE "places" (
	"host"	LONGVARCHAR	NOT NULL,
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
	UNIQUE ("name", "host", "creation_time"),
	CHECK ("expiry" = 0 OR "expiry" > "last_accessed"),
	CHECK ("last_accessed" >= "creation_time")
)


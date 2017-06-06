-- 10
-- NNCA
-- Added NOT NULL to column TNUM3 in table TEST12549

CREATE TABLE "TEST12549" (
	"TNUM1"	NUMERIC(5, 0)	CONSTRAINT "CND12549A" NOT NULL,
	"TNUM2"	NUMERIC(5, 0)	CONSTRAINT "CND12549B" UNIQUE,
	"TNUM3"	NUMERIC(5, 0)	NOT NULL,
	CONSTRAINT "CND12549C" CHECK ("TNUM3" > 0)
)


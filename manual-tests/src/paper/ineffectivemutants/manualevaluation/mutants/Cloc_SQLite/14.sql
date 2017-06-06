-- 14
-- NNCA
-- Added NOT NULL to column Project in table t

CREATE TABLE "metadata" (
	"timestamp"	VARCHAR(50),
	"Project"	VARCHAR(50),
	"elapsed_s"	INT
)

CREATE TABLE "t" (
	"Project"	VARCHAR(50)	NOT NULL,
	"Language"	VARCHAR(50),
	"File"	VARCHAR(50),
	"nBlank"	INT,
	"nComment"	INT,
	"nCode"	INT,
	"nScaled"	INT
)


-- 155
-- UCColumnA
-- Added UNIQUE to column pendingUninstall in table addon

CREATE TABLE "addon" (
	"internal_id"	INT	PRIMARY KEY,
	"id"	LONGVARCHAR,
	"syncGUID"	LONGVARCHAR	UNIQUE,
	"location"	LONGVARCHAR,
	"version"	LONGVARCHAR,
	"type"	LONGVARCHAR,
	"internalName"	LONGVARCHAR,
	"updateURL"	LONGVARCHAR,
	"updateKey"	LONGVARCHAR,
	"optionsURL"	LONGVARCHAR,
	"optionsType"	LONGVARCHAR,
	"aboutURL"	LONGVARCHAR,
	"iconURL"	LONGVARCHAR,
	"icon64URL"	LONGVARCHAR,
	"defaultLocale"	INT,
	"visible"	INT,
	"active"	INT,
	"userDisabled"	INT,
	"appDisabled"	INT,
	"pendingUninstall"	INT	UNIQUE,
	"descriptor"	LONGVARCHAR,
	"installDate"	INT,
	"updateDate"	INT,
	"applyBackgroundUpdates"	INT,
	"bootstrap"	INT,
	"skinnable"	INT,
	"size"	INT,
	"sourceURI"	LONGVARCHAR,
	"releaseNotesURI"	LONGVARCHAR,
	"softDisabled"	INT,
	"isForeignInstall"	INT,
	"hasBinaryComponents"	INT,
	"strictCompatibility"	INT,
	UNIQUE ("id", "location")
)

CREATE TABLE "addon_locale" (
	"addon_internal_id"	INT,
	"locale"	LONGVARCHAR,
	"locale_id"	INT,
	UNIQUE ("addon_internal_id", "locale")
)

CREATE TABLE "locale" (
	"id"	INT	PRIMARY KEY,
	"name"	LONGVARCHAR,
	"description"	LONGVARCHAR,
	"creator"	LONGVARCHAR,
	"homepageURL"	LONGVARCHAR
)

CREATE TABLE "locale_strings" (
	"locale_id"	INT,
	"type"	LONGVARCHAR,
	"value"	LONGVARCHAR
)

CREATE TABLE "targetApplication" (
	"addon_internal_id"	INT,
	"id"	LONGVARCHAR,
	"minVersion"	LONGVARCHAR,
	"maxVersion"	LONGVARCHAR,
	UNIQUE ("addon_internal_id", "id")
)

CREATE TABLE "targetPlatform" (
	"addon_internal_id"	INT,
	"os"	LONGVARCHAR,
	"abi"	LONGVARCHAR,
	UNIQUE ("addon_internal_id", "os", "abi")
)


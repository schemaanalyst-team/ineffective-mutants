-- 70
-- UCColumnA
-- Added UNIQUE to column discounted_price in table products

CREATE TABLE "products" (
	"product_no"	INT	PRIMARY KEY	NOT NULL,
	"name"	VARCHAR(100)	NOT NULL,
	"price"	NUMERIC	NOT NULL,
	"discounted_price"	NUMERIC	UNIQUE	NOT NULL,
	CHECK ("price" > 0),
	CHECK ("discounted_price" > 0),
	CHECK ("price" > "discounted_price")
)

CREATE TABLE "orders" (
	"order_id"	INT	PRIMARY KEY,
	"shipping_address"	VARCHAR(100)
)

CREATE TABLE "order_items" (
	"product_no"	INT	 REFERENCES "products" ("product_no"),
	"order_id"	INT	 REFERENCES "orders" ("order_id"),
	"quantity"	INT	NOT NULL,
	PRIMARY KEY ("product_no", "order_id"),
	CHECK ("quantity" > 0)
)


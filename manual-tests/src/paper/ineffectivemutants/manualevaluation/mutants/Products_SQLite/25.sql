-- 25
-- FKCColumnPairA
-- ListElementAdder with ChainedSupplier with ForeignKeyConstraintSupplier and ForeignKeyColumnPairsWithAlternativesSupplier - Added Pair(order_id, name)

CREATE TABLE "products" (
	"product_no"	INT	PRIMARY KEY	NOT NULL,
	"name"	VARCHAR(100)	NOT NULL,
	"price"	NUMERIC	NOT NULL,
	"discounted_price"	NUMERIC	NOT NULL,
	CHECK ("price" > 0),
	CHECK ("discounted_price" > 0),
	CHECK ("price" > "discounted_price")
)

CREATE TABLE "orders" (
	"order_id"	INT	PRIMARY KEY,
	"shipping_address"	VARCHAR(100)
)

CREATE TABLE "order_items" (
	"product_no"	INT,
	"order_id"	INT	 REFERENCES "orders" ("order_id"),
	"quantity"	INT	NOT NULL,
	PRIMARY KEY ("product_no", "order_id"),
	FOREIGN KEY ("product_no", "order_id") REFERENCES "products" ("product_no", "name"),
	CHECK ("quantity" > 0)
)


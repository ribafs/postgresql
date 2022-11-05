

/* -----------------------------------------------------------------------
   products
   ----------------------------------------------------------------------- */

DROP TABLE "products" CASCADE CONSTRAINTS;


CREATE TABLE "products"
(
	"ProductID" NUMBER  NOT NULL,
	"ProductName" VARCHAR2(40) default '' NOT NULL,
	"SupplierID" NUMBER,
	"CategoryID" NUMBER,
	"QuantityPerUnit" VARCHAR2(20),
	"UnitPrice" NUMBER(12,2),
	"UnitsInStock" NUMBER,
	"UnitsOnOrder" NUMBER,
	"ReorderLevel" NUMBER,
	"Discontinued" NUMBER(1,0) default 0 NOT NULL,
	"Notes" VARCHAR2(2000),
	"OrderDate" DATE
);

	ALTER TABLE "products"
	    ADD CONSTRAINT "products_PK" 
	PRIMARY KEY ("ProductID");


/* -----------------------------------------------------------------------
   blobtest
   ----------------------------------------------------------------------- */

DROP TABLE "blobtest" CASCADE CONSTRAINTS;


CREATE TABLE "blobtest"
(
	"BlobID" NUMBER  NOT NULL,
	"BlobName" VARCHAR2(30)  NOT NULL,
	"BlobData" BLOB  NOT NULL
);

	ALTER TABLE "blobtest"
	    ADD CONSTRAINT "blobtest_PK" 
	PRIMARY KEY ("BlobID");


/* -----------------------------------------------------------------------
   clobtest
   ----------------------------------------------------------------------- */

DROP TABLE "clobtest" CASCADE CONSTRAINTS;


CREATE TABLE "clobtest"
(
	"ClobID" NUMBER  NOT NULL,
	"ClobName" VARCHAR2(30)  NOT NULL,
	"ClobData" CLOB  NOT NULL
);

	ALTER TABLE "clobtest"
	    ADD CONSTRAINT "clobtest_PK" 
	PRIMARY KEY ("ClobID");


/* -----------------------------------------------------------------------
   idgentest
   ----------------------------------------------------------------------- */

DROP TABLE "idgentest" CASCADE CONSTRAINTS;

DROP SEQUENCE "idgentest_SEQ";


CREATE TABLE "idgentest"
(
	"ID" NUMBER  NOT NULL,
	"Name" VARCHAR2(40) default '' NOT NULL
);

	ALTER TABLE "idgentest"
	    ADD CONSTRAINT "idgentest_PK" 
	PRIMARY KEY ("ID");
CREATE SEQUENCE "idgentest_SEQ" INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE ORDER;


/* -----------------------------------------------------------------------
   temporaltest
   ----------------------------------------------------------------------- */

DROP TABLE "temporaltest" CASCADE CONSTRAINTS;


CREATE TABLE "temporaltest"
(
	"ID" NUMBER  NOT NULL,
	"timecol" DATE,
	"datecol" DATE,
	"timestampcol" DATE
);

	ALTER TABLE "temporaltest"
	    ADD CONSTRAINT "temporaltest_PK" 
	PRIMARY KEY ("ID");


/* -----------------------------------------------------------------------
   temporaltest
   ----------------------------------------------------------------------- */

DROP TABLE "temporaltest" CASCADE CONSTRAINTS;


CREATE TABLE "temporaltest"
(
	"ID" NUMBER  NOT NULL,
	"timecol" DATE,
	"datecol" DATE,
	"timestampcol" DATE
);

	ALTER TABLE "temporaltest"
	    ADD CONSTRAINT "temporaltest_PK" 
	PRIMARY KEY ("ID");


/* -----------------------------------------------------------------------
   indexes
   ----------------------------------------------------------------------- */

DROP TABLE "indexes" CASCADE CONSTRAINTS;


CREATE TABLE "indexes"
(
	"ProductName" VARCHAR2(50),
	"SupplierID" NUMBER,
	"CategoryID" NUMBER,
	"UnitPrice" NUMBER(12,2)
);
CREATE INDEX "ProductNameIDX" ON "indexes" ("ProductName");
CREATE INDEX "ComplexIDX" ON "indexes" ("SupplierID","CategoryID","UnitPrice");
CREATE INDEX "ProductNameIDX" ON "indexes" ("ProductName");
CREATE INDEX "ComplexIDX" ON "indexes" ("SupplierID","CategoryID","UnitPrice");


/* -----------------------------------------------------------------------
   fk_test
   ----------------------------------------------------------------------- */

DROP TABLE "fk_test" CASCADE CONSTRAINTS;


CREATE TABLE "fk_test"
(
	"UniqueCol1" NUMBER,
	"UniqueCol2" NUMBER
);


/* -----------------------------------------------------------------------
   ref_table
   ----------------------------------------------------------------------- */

DROP TABLE "ref_table" CASCADE CONSTRAINTS;


CREATE TABLE "ref_table"
(
	"RefID1" NUMBER  NOT NULL,
	"RefID2" NUMBER  NOT NULL
);

	ALTER TABLE "ref_table"
	    ADD CONSTRAINT "ref_table_PK" 
	PRIMARY KEY ("RefID1","RefID2");

ALTER TABLE "ref_table" ADD CONSTRAINT "refid1" FOREIGN KEY ("RefID1") REFERENCES "fk_test" ("UniqueCol1");

ALTER TABLE "ref_table" ADD CONSTRAINT "refid1" FOREIGN KEY ("RefID2") REFERENCES "fk_test" ("UniqueCol2");

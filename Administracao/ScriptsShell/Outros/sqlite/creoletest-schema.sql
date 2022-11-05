
-----------------------------------------------------------------------------
-- products
-----------------------------------------------------------------------------

DROP TABLE [products];


CREATE TABLE [products]
(
	[ProductID] INTEGER  NOT NULL,
	[ProductName] VARCHAR(40) default '' NOT NULL,
	[SupplierID] INTEGER,
	[CategoryID] INTEGER,
	[QuantityPerUnit] VARCHAR(20),
	[UnitPrice] DECIMAL(12,2),
	[UnitsInStock] INTEGER,
	[UnitsOnOrder] INTEGER,
	[ReorderLevel] INTEGER,
	[Discontinued] INTEGER default 0 NOT NULL,
	[Notes] MEDIUMTEXT,
	[OrderDate] DATETIME
);

-----------------------------------------------------------------------------
-- blobtest
-----------------------------------------------------------------------------

DROP TABLE [blobtest];


CREATE TABLE [blobtest]
(
	[BlobID] INTEGER  NOT NULL,
	[BlobName] VARCHAR(30)  NOT NULL,
	[BlobData] LONGBLOB  NOT NULL
);

-----------------------------------------------------------------------------
-- clobtest
-----------------------------------------------------------------------------

DROP TABLE [clobtest];


CREATE TABLE [clobtest]
(
	[ClobID] INTEGER  NOT NULL,
	[ClobName] VARCHAR(30)  NOT NULL,
	[ClobData] LONGTEXT  NOT NULL
);

-----------------------------------------------------------------------------
-- idgentest
-----------------------------------------------------------------------------

DROP TABLE [idgentest];


CREATE TABLE [idgentest]
(
	[ID] INTEGER  NOT NULL PRIMARY KEY,
	[Name] VARCHAR(40) default '' NOT NULL
);

-----------------------------------------------------------------------------
-- temporaltest
-----------------------------------------------------------------------------

DROP TABLE [temporaltest];


CREATE TABLE [temporaltest]
(
	[ID] INTEGER  NOT NULL,
	[timecol] TIME,
	[datecol] DATETIME,
	[timestampcol] TIMESTAMP
);

-----------------------------------------------------------------------------
-- temporaltest
-----------------------------------------------------------------------------

DROP TABLE [temporaltest];


CREATE TABLE [temporaltest]
(
	[ID] INTEGER  NOT NULL,
	[timecol] TIME,
	[datecol] DATETIME,
	[timestampcol] TIMESTAMP
);

-----------------------------------------------------------------------------
-- indexes
-----------------------------------------------------------------------------

DROP TABLE [indexes];


CREATE TABLE [indexes]
(
	[ProductName] VARCHAR(50),
	[SupplierID] INTEGER,
	[CategoryID] INTEGER,
	[UnitPrice] DECIMAL(12,2),
	UNIQUE ([SupplierID],[CategoryID],[UnitPrice])
);

CREATE INDEX [ProductNameIDX] ON [indexes] ([ProductName]);

CREATE INDEX [ComplexIDX] ON [indexes] ([SupplierID],[CategoryID],[UnitPrice]);

-----------------------------------------------------------------------------
-- fk_test
-----------------------------------------------------------------------------

DROP TABLE [fk_test];


CREATE TABLE [fk_test]
(
	[UniqueCol1] INTEGER,
	[UniqueCol2] INTEGER,
	UNIQUE ([UniqueCol1]),
	UNIQUE ([UniqueCol2])
);

-----------------------------------------------------------------------------
-- ref_table
-----------------------------------------------------------------------------

DROP TABLE [ref_table];


CREATE TABLE [ref_table]
(
	[RefID1] INTEGER  NOT NULL,
	[RefID2] INTEGER  NOT NULL
);

-- SQLite does not support foreign keys; this is just for reference
-- FOREIGN KEY ([RefID1]) REFERENCES fk_test ([UniqueCol1])

-- SQLite does not support foreign keys; this is just for reference
-- FOREIGN KEY ([RefID2]) REFERENCES fk_test ([UniqueCol2])

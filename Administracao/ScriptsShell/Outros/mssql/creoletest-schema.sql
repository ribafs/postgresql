
/* ---------------------------------------------------------------------- */
/* products											*/
/* ---------------------------------------------------------------------- */


IF EXISTS (SELECT 1 FROM sysobjects WHERE type = 'U' AND name = 'products')
BEGIN
     DECLARE @reftable_1 nvarchar(60), @constraintname_1 nvarchar(60)
     DECLARE refcursor CURSOR FOR
     select reftables.name tablename, cons.name constraintname
      from sysobjects tables,
           sysobjects reftables,
           sysobjects cons,
           sysreferences ref
       where tables.id = ref.rkeyid
         and cons.id = ref.constid
         and reftables.id = ref.fkeyid
         and tables.name = 'products'
     OPEN refcursor
     FETCH NEXT from refcursor into @reftable_1, @constraintname_1
     while @@FETCH_STATUS = 0
     BEGIN
       exec ('alter table '+@reftable_1+' drop constraint '+@constraintname_1)
       FETCH NEXT from refcursor into @reftable_1, @constraintname_1
     END
     CLOSE refcursor
     DEALLOCATE refcursor
     DROP TABLE [products]
END


CREATE TABLE [products]
(
	[ProductID] INT  NOT NULL,
	[ProductName] VARCHAR(40) default '' NOT NULL,
	[SupplierID] INT  NULL,
	[CategoryID] INT  NULL,
	[QuantityPerUnit] VARCHAR(20)  NULL,
	[UnitPrice] DECIMAL(12,2)  NULL,
	[UnitsInStock] INT  NULL,
	[UnitsOnOrder] INT  NULL,
	[ReorderLevel] INT  NULL,
	[Discontinued] INT default 0 NOT NULL,
	[Notes] TEXT  NULL,
	[OrderDate] DATETIME  NULL,
	CONSTRAINT [products]_PK PRIMARY KEY ([ProductID])
);

/* ---------------------------------------------------------------------- */
/* blobtest											*/
/* ---------------------------------------------------------------------- */


IF EXISTS (SELECT 1 FROM sysobjects WHERE type = 'U' AND name = 'blobtest')
BEGIN
     DECLARE @reftable_2 nvarchar(60), @constraintname_2 nvarchar(60)
     DECLARE refcursor CURSOR FOR
     select reftables.name tablename, cons.name constraintname
      from sysobjects tables,
           sysobjects reftables,
           sysobjects cons,
           sysreferences ref
       where tables.id = ref.rkeyid
         and cons.id = ref.constid
         and reftables.id = ref.fkeyid
         and tables.name = 'blobtest'
     OPEN refcursor
     FETCH NEXT from refcursor into @reftable_2, @constraintname_2
     while @@FETCH_STATUS = 0
     BEGIN
       exec ('alter table '+@reftable_2+' drop constraint '+@constraintname_2)
       FETCH NEXT from refcursor into @reftable_2, @constraintname_2
     END
     CLOSE refcursor
     DEALLOCATE refcursor
     DROP TABLE [blobtest]
END


CREATE TABLE [blobtest]
(
	[BlobID] INT  NOT NULL,
	[BlobName] VARCHAR(30)  NOT NULL,
	[BlobData] IMAGE  NOT NULL,
	CONSTRAINT [blobtest]_PK PRIMARY KEY ([BlobID])
);

/* ---------------------------------------------------------------------- */
/* clobtest											*/
/* ---------------------------------------------------------------------- */


IF EXISTS (SELECT 1 FROM sysobjects WHERE type = 'U' AND name = 'clobtest')
BEGIN
     DECLARE @reftable_3 nvarchar(60), @constraintname_3 nvarchar(60)
     DECLARE refcursor CURSOR FOR
     select reftables.name tablename, cons.name constraintname
      from sysobjects tables,
           sysobjects reftables,
           sysobjects cons,
           sysreferences ref
       where tables.id = ref.rkeyid
         and cons.id = ref.constid
         and reftables.id = ref.fkeyid
         and tables.name = 'clobtest'
     OPEN refcursor
     FETCH NEXT from refcursor into @reftable_3, @constraintname_3
     while @@FETCH_STATUS = 0
     BEGIN
       exec ('alter table '+@reftable_3+' drop constraint '+@constraintname_3)
       FETCH NEXT from refcursor into @reftable_3, @constraintname_3
     END
     CLOSE refcursor
     DEALLOCATE refcursor
     DROP TABLE [clobtest]
END


CREATE TABLE [clobtest]
(
	[ClobID] INT  NOT NULL,
	[ClobName] VARCHAR(30)  NOT NULL,
	[ClobData] TEXT  NOT NULL,
	CONSTRAINT [clobtest]_PK PRIMARY KEY ([ClobID])
);

/* ---------------------------------------------------------------------- */
/* idgentest											*/
/* ---------------------------------------------------------------------- */


IF EXISTS (SELECT 1 FROM sysobjects WHERE type = 'U' AND name = 'idgentest')
BEGIN
     DECLARE @reftable_4 nvarchar(60), @constraintname_4 nvarchar(60)
     DECLARE refcursor CURSOR FOR
     select reftables.name tablename, cons.name constraintname
      from sysobjects tables,
           sysobjects reftables,
           sysobjects cons,
           sysreferences ref
       where tables.id = ref.rkeyid
         and cons.id = ref.constid
         and reftables.id = ref.fkeyid
         and tables.name = 'idgentest'
     OPEN refcursor
     FETCH NEXT from refcursor into @reftable_4, @constraintname_4
     while @@FETCH_STATUS = 0
     BEGIN
       exec ('alter table '+@reftable_4+' drop constraint '+@constraintname_4)
       FETCH NEXT from refcursor into @reftable_4, @constraintname_4
     END
     CLOSE refcursor
     DEALLOCATE refcursor
     DROP TABLE [idgentest]
END


CREATE TABLE [idgentest]
(
	[ID] INT  NOT NULL IDENTITY,
	[Name] VARCHAR(40) default '' NOT NULL,
	CONSTRAINT [idgentest]_PK PRIMARY KEY ([ID])
);

/* ---------------------------------------------------------------------- */
/* temporaltest											*/
/* ---------------------------------------------------------------------- */


IF EXISTS (SELECT 1 FROM sysobjects WHERE type = 'U' AND name = 'temporaltest')
BEGIN
     DECLARE @reftable_5 nvarchar(60), @constraintname_5 nvarchar(60)
     DECLARE refcursor CURSOR FOR
     select reftables.name tablename, cons.name constraintname
      from sysobjects tables,
           sysobjects reftables,
           sysobjects cons,
           sysreferences ref
       where tables.id = ref.rkeyid
         and cons.id = ref.constid
         and reftables.id = ref.fkeyid
         and tables.name = 'temporaltest'
     OPEN refcursor
     FETCH NEXT from refcursor into @reftable_5, @constraintname_5
     while @@FETCH_STATUS = 0
     BEGIN
       exec ('alter table '+@reftable_5+' drop constraint '+@constraintname_5)
       FETCH NEXT from refcursor into @reftable_5, @constraintname_5
     END
     CLOSE refcursor
     DEALLOCATE refcursor
     DROP TABLE [temporaltest]
END


CREATE TABLE [temporaltest]
(
	[ID] INT  NOT NULL,
	[timecol] DATETIME  NULL,
	[datecol] DATETIME  NULL,
	[timestampcol] DATETIME  NULL,
	CONSTRAINT [temporaltest]_PK PRIMARY KEY ([ID])
);

/* ---------------------------------------------------------------------- */
/* temporaltest											*/
/* ---------------------------------------------------------------------- */


IF EXISTS (SELECT 1 FROM sysobjects WHERE type = 'U' AND name = 'temporaltest')
BEGIN
     DECLARE @reftable_6 nvarchar(60), @constraintname_6 nvarchar(60)
     DECLARE refcursor CURSOR FOR
     select reftables.name tablename, cons.name constraintname
      from sysobjects tables,
           sysobjects reftables,
           sysobjects cons,
           sysreferences ref
       where tables.id = ref.rkeyid
         and cons.id = ref.constid
         and reftables.id = ref.fkeyid
         and tables.name = 'temporaltest'
     OPEN refcursor
     FETCH NEXT from refcursor into @reftable_6, @constraintname_6
     while @@FETCH_STATUS = 0
     BEGIN
       exec ('alter table '+@reftable_6+' drop constraint '+@constraintname_6)
       FETCH NEXT from refcursor into @reftable_6, @constraintname_6
     END
     CLOSE refcursor
     DEALLOCATE refcursor
     DROP TABLE [temporaltest]
END


CREATE TABLE [temporaltest]
(
	[ID] INT  NOT NULL,
	[timecol] DATETIME  NULL,
	[datecol] DATETIME  NULL,
	[timestampcol] DATETIME  NULL,
	CONSTRAINT [temporaltest]_PK PRIMARY KEY ([ID])
);

/* ---------------------------------------------------------------------- */
/* indexes											*/
/* ---------------------------------------------------------------------- */


IF EXISTS (SELECT 1 FROM sysobjects WHERE type = 'U' AND name = 'indexes')
BEGIN
     DECLARE @reftable_7 nvarchar(60), @constraintname_7 nvarchar(60)
     DECLARE refcursor CURSOR FOR
     select reftables.name tablename, cons.name constraintname
      from sysobjects tables,
           sysobjects reftables,
           sysobjects cons,
           sysreferences ref
       where tables.id = ref.rkeyid
         and cons.id = ref.constid
         and reftables.id = ref.fkeyid
         and tables.name = 'indexes'
     OPEN refcursor
     FETCH NEXT from refcursor into @reftable_7, @constraintname_7
     while @@FETCH_STATUS = 0
     BEGIN
       exec ('alter table '+@reftable_7+' drop constraint '+@constraintname_7)
       FETCH NEXT from refcursor into @reftable_7, @constraintname_7
     END
     CLOSE refcursor
     DEALLOCATE refcursor
     DROP TABLE [indexes]
END


CREATE TABLE [indexes]
(
	[ProductName] VARCHAR(50)  NULL,
	[SupplierID] INT  NULL,
	[CategoryID] INT  NULL,
	[UnitPrice] DECIMAL(12,2)  NULL,
	UNIQUE ([SupplierID],[CategoryID],[UnitPrice])
);

CREATE INDEX [ProductNameIDX] ON [indexes] ([ProductName]);

CREATE INDEX [ComplexIDX] ON [indexes] ([SupplierID],[CategoryID],[UnitPrice]);

/* ---------------------------------------------------------------------- */
/* fk_test											*/
/* ---------------------------------------------------------------------- */


IF EXISTS (SELECT 1 FROM sysobjects WHERE type = 'U' AND name = 'fk_test')
BEGIN
     DECLARE @reftable_8 nvarchar(60), @constraintname_8 nvarchar(60)
     DECLARE refcursor CURSOR FOR
     select reftables.name tablename, cons.name constraintname
      from sysobjects tables,
           sysobjects reftables,
           sysobjects cons,
           sysreferences ref
       where tables.id = ref.rkeyid
         and cons.id = ref.constid
         and reftables.id = ref.fkeyid
         and tables.name = 'fk_test'
     OPEN refcursor
     FETCH NEXT from refcursor into @reftable_8, @constraintname_8
     while @@FETCH_STATUS = 0
     BEGIN
       exec ('alter table '+@reftable_8+' drop constraint '+@constraintname_8)
       FETCH NEXT from refcursor into @reftable_8, @constraintname_8
     END
     CLOSE refcursor
     DEALLOCATE refcursor
     DROP TABLE [fk_test]
END


CREATE TABLE [fk_test]
(
	[UniqueCol1] INT  NULL,
	[UniqueCol2] INT  NULL,
	UNIQUE ([UniqueCol1]),
	UNIQUE ([UniqueCol2])
);

/* ---------------------------------------------------------------------- */
/* ref_table											*/
/* ---------------------------------------------------------------------- */


IF EXISTS (SELECT 1 FROM sysobjects WHERE type ='RI' AND name='refid1')
    ALTER TABLE [ref_table] DROP CONSTRAINT [refid1];

IF EXISTS (SELECT 1 FROM sysobjects WHERE type ='RI' AND name='refid1')
    ALTER TABLE [ref_table] DROP CONSTRAINT [refid1];

IF EXISTS (SELECT 1 FROM sysobjects WHERE type = 'U' AND name = 'ref_table')
BEGIN
     DECLARE @reftable_9 nvarchar(60), @constraintname_9 nvarchar(60)
     DECLARE refcursor CURSOR FOR
     select reftables.name tablename, cons.name constraintname
      from sysobjects tables,
           sysobjects reftables,
           sysobjects cons,
           sysreferences ref
       where tables.id = ref.rkeyid
         and cons.id = ref.constid
         and reftables.id = ref.fkeyid
         and tables.name = 'ref_table'
     OPEN refcursor
     FETCH NEXT from refcursor into @reftable_9, @constraintname_9
     while @@FETCH_STATUS = 0
     BEGIN
       exec ('alter table '+@reftable_9+' drop constraint '+@constraintname_9)
       FETCH NEXT from refcursor into @reftable_9, @constraintname_9
     END
     CLOSE refcursor
     DEALLOCATE refcursor
     DROP TABLE [ref_table]
END


CREATE TABLE [ref_table]
(
	[RefID1] INT  NOT NULL,
	[RefID2] INT  NOT NULL,
	CONSTRAINT [ref_table]_PK PRIMARY KEY ([RefID1],[RefID2])
);

BEGIN
ALTER TABLE [ref_table] ADD CONSTRAINT [refid1] FOREIGN KEY ([RefID1]) REFERENCES [fk_test] ([UniqueCol1])
END
;

BEGIN
ALTER TABLE [ref_table] ADD CONSTRAINT [refid1] FOREIGN KEY ([RefID2]) REFERENCES [fk_test] ([UniqueCol2])
END
;

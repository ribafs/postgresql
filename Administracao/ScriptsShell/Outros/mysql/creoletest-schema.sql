
# This is a fix for InnoDB in MySQL >= 4.1.x
# It "suspends judgement" for fkey relationships until are tables are set.
SET FOREIGN_KEY_CHECKS = 0;

#-----------------------------------------------------------------------------
#-- products
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `products`;


CREATE TABLE `products`
(
	`ProductID` INTEGER  NOT NULL,
	`ProductName` VARCHAR(40) default '' NOT NULL,
	`SupplierID` INTEGER,
	`CategoryID` INTEGER,
	`QuantityPerUnit` VARCHAR(20),
	`UnitPrice` DECIMAL(12,2),
	`UnitsInStock` INTEGER,
	`UnitsOnOrder` INTEGER,
	`ReorderLevel` INTEGER,
	`Discontinued` INTEGER default 0 NOT NULL,
	`Notes` TEXT,
	`OrderDate` DATE,
	PRIMARY KEY (`ProductID`)
)Type=MyISAM;

#-----------------------------------------------------------------------------
#-- blobtest
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `blobtest`;


CREATE TABLE `blobtest`
(
	`BlobID` INTEGER  NOT NULL,
	`BlobName` VARCHAR(30)  NOT NULL,
	`BlobData` LONGBLOB  NOT NULL,
	PRIMARY KEY (`BlobID`)
)Type=MyISAM;

#-----------------------------------------------------------------------------
#-- clobtest
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `clobtest`;


CREATE TABLE `clobtest`
(
	`ClobID` INTEGER  NOT NULL,
	`ClobName` VARCHAR(30)  NOT NULL,
	`ClobData` LONGTEXT  NOT NULL,
	PRIMARY KEY (`ClobID`)
)Type=MyISAM;

#-----------------------------------------------------------------------------
#-- idgentest
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `idgentest`;


CREATE TABLE `idgentest`
(
	`ID` INTEGER  NOT NULL AUTO_INCREMENT,
	`Name` VARCHAR(40) default '' NOT NULL,
	PRIMARY KEY (`ID`)
)Type=MyISAM;

#-----------------------------------------------------------------------------
#-- temporaltest
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `temporaltest`;


CREATE TABLE `temporaltest`
(
	`ID` INTEGER  NOT NULL,
	`timecol` TIME,
	`datecol` DATE,
	`timestampcol` DATETIME,
	PRIMARY KEY (`ID`)
)Type=MyISAM;

#-----------------------------------------------------------------------------
#-- temporaltest
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `temporaltest`;


CREATE TABLE `temporaltest`
(
	`ID` INTEGER  NOT NULL,
	`timecol` TIME,
	`datecol` DATE,
	`timestampcol` DATETIME,
	PRIMARY KEY (`ID`)
)Type=MyISAM;

#-----------------------------------------------------------------------------
#-- indexes
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `indexes`;


CREATE TABLE `indexes`
(
	`ProductName` VARCHAR(50),
	`SupplierID` INTEGER,
	`CategoryID` INTEGER,
	`UnitPrice` DECIMAL(12,2),
	UNIQUE KEY `UniqueComplexIDX` (`SupplierID`, `CategoryID`, `UnitPrice`),
	KEY `ProductNameIDX`(`ProductName`),
	KEY `ComplexIDX`(`SupplierID`, `CategoryID`, `UnitPrice`)
)Type=MyISAM;

#-----------------------------------------------------------------------------
#-- fk_test
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `fk_test`;


CREATE TABLE `fk_test`
(
	`UniqueCol1` INTEGER,
	`UniqueCol2` INTEGER,
	UNIQUE KEY `fk_test_U_1` (`UniqueCol1`),
	UNIQUE KEY `fk_test_U_2` (`UniqueCol2`)
)Type=MyISAM;

#-----------------------------------------------------------------------------
#-- ref_table
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `ref_table`;


CREATE TABLE `ref_table`
(
	`RefID1` INTEGER  NOT NULL,
	`RefID2` INTEGER  NOT NULL,
	PRIMARY KEY (`RefID1`,`RefID2`),
	CONSTRAINT `refid1`
		FOREIGN KEY (`RefID1`)
		REFERENCES `fk_test` (`UniqueCol1`),
	INDEX `FI_id1` (`RefID2`),
	CONSTRAINT `refid1`
		FOREIGN KEY (`RefID2`)
		REFERENCES `fk_test` (`UniqueCol2`)
)Type=MyISAM;

# This restores the fkey checks, after having unset them earlier
SET FOREIGN_KEY_CHECKS = 1;

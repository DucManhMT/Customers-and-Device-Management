use crm;
-- ======================
-- CATEGORY & TYPE
-- ======================
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    CategoryImage NVARCHAR(255)
);

CREATE TABLE Type (
    TypeID INT PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL,
    TypeImage NVARCHAR(255),
    CategoryID INT NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- ======================
-- ACCOUNT
-- ======================

CREATE TABLE Role (
    RoleID INT PRIMARY KEY,
    RoleName NVARCHAR(50) UNIQUE
);

CREATE TABLE Account (
    Username NVARCHAR(100) PRIMARY KEY,
    PasswordHash NVARCHAR(255) NOT NULL,
    AccountStatus ENUM('Active', 'Deactive'),
    RoleID INT,
    FOREIGN KEY (RoleID) REFERENCES Role(RoleID)
);

CREATE TABLE Feature (
    FeatureID INT PRIMARY KEY,
    FeatureURL NVARCHAR(255) NOT NULL,
    Description NVARCHAR(255)
);

CREATE TABLE RoleFeature (
    RoleFeatureID INT PRIMARY KEY,
    RoleID INT NOT NULL,
    FeatureID INT NOT NULL,
    FOREIGN KEY (RoleID) REFERENCES Role(RoleID),
    FOREIGN KEY (FeatureID) REFERENCES Feature(FeatureID)
);

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    StaffName NVARCHAR(150) NOT NULL,
    Phone NVARCHAR(50) UNIQUE NOT NULL,
    Address NVARCHAR(100),
    Email NVARCHAR(150) UNIQUE NOT NULL,
    Image NVARCHAR(255),
    DateOfBirth DATE,
    Username NVARCHAR(100),
    FOREIGN KEY (Username) REFERENCES Account(Username)
);

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(150) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    Phone NVARCHAR(50) UNIQUE NOT NULL,
    Email NVARCHAR(150) UNIQUE NOT NULL,
    Username NVARCHAR(100),
    FOREIGN KEY (Username) REFERENCES Account(Username)
);

-- ======================
-- PRODUCT & SPECIFICATIONS
-- ======================
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(150) NOT NULL,
    ProductImage NVARCHAR(255),
    ProductDescription NVARCHAR(255),
    TypeID INT NOT NULL,
    FOREIGN KEY (TypeID) REFERENCES Type(TypeID)
);

CREATE TABLE SpecificationType (
    SpecificationTypeID INT PRIMARY KEY,
    SpecificationTypeName NVARCHAR(100) NOT NULL,
    TypeID INT NOT NULL,
    FOREIGN KEY (TypeID) REFERENCES Type(TypeID)
);

CREATE TABLE Specification (
    SpecificationID INT PRIMARY KEY,
    SpecificationName NVARCHAR(100) NOT NULL,
    SpecificationValue NVARCHAR(255) NOT NULL,
    SpecificationTypeID INT NOT NULL,
    FOREIGN KEY (SpecificationTypeID) REFERENCES SpecificationType(SpecificationTypeID)
);

CREATE TABLE ProductSpecification (
    ProductSpecificationID INT PRIMARY KEY,
    ProductID INT NOT NULL,
    SpecificationID INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (SpecificationID) REFERENCES Specification(SpecificationID)
);

-- ======================
-- WAREHOUSE & INVENTORY
-- ======================
CREATE TABLE InventoryItem (
    ItemID INT PRIMARY KEY,
    SerialNumber NVARCHAR(255) UNIQUE NOT NULL,
    ProductID INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Warehouse (
    WarehouseID INT PRIMARY KEY,
    WarehouseName NVARCHAR(100) NOT NULL,
    Location NVARCHAR(255),
    WarehouseManager NVARCHAR(255) NOT NULL,
    FOREIGN KEY (WarehouseManager) REFERENCES Account(Username)
);

CREATE TABLE ProductWarehouse (
    ProductWarehouseID INT PRIMARY KEY,
    ProductStatus ENUM('In stock', 'Exported'),
    WarehouseID INT NOT NULL,
    ItemID INT NOT NULL,
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID),
    FOREIGN KEY (ItemID) REFERENCES InventoryItem(ItemID)
);

CREATE TABLE ProductTransaction (
    TransactionID INT PRIMARY KEY,
    TransactionDate DATETIME NOT NULL,
    SourceWarehouse INT,
    DestinationWarehouse INT,
    TransactionStatus ENUM('Export', 'Import'),
    ItemID INT NOT NULL,
    Note NVARCHAR(255),
    FOREIGN KEY (ItemID) REFERENCES InventoryItem(ItemID),
    FOREIGN KEY (SourceWarehouse) REFERENCES Warehouse(WarehouseID),
	FOREIGN KEY (DestinationWarehouse) REFERENCES Warehouse(WarehouseID)
);

-- ======================
-- CUSTOMER FEEDBACK
-- ======================
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY,
    Content NVARCHAR(255),
    Rating INT,
    Response NVARCHAR(255),
    FeedbackDate DATETIME NOT NULL,
    CustomerID NVARCHAR(100),
    FOREIGN KEY (CustomerID) REFERENCES Account(Username)
);

-- ======================
-- CONTRACT & REQUEST
-- ======================
CREATE TABLE Contract (
    ContractID INT PRIMARY KEY,
    ContractImage NVARCHAR(255) NOT NULL,
    StartDate Date NOT NULL,
    ExpiredDate DATE NOT NULL,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Request (
    RequestID INT PRIMARY KEY,
    RequestDescription NVARCHAR(255),
    RequestStatus ENUM('Pending', 'Approved', 'Rejected', 'Finished', 'Processing'),
    StartDate DATETIME NOT NULL,
    FinishedDate DATETIME,
    Note NVARCHAR(255),
    ContractID INT NOT NULL,
    FOREIGN KEY (ContractID) REFERENCES Contract(ContractID)
);

CREATE TABLE AccountRequest(
    AccountRequestID INT PRIMARY KEY,
    Username NVARCHAR(100) NOT NULL,
    RequestID INT NOT NULL,
    FOREIGN KEY (Username) REFERENCES Account(Username),
    FOREIGN KEY (RequestID) REFERENCES Request(RequestID)
);

CREATE TABLE RequestLog (
    RequestLogID INT PRIMARY KEY,
    ActionDate DATE,
    OldStatus ENUM('Pending', 'Approved', 'Rejected'),
    NewStatus ENUM('Pending', 'Approved', 'Rejected', 'Finished'),
    RequestID INT NOT NULL,
    Username NVARCHAR(100),
    FOREIGN KEY (RequestID) REFERENCES Request(RequestID),
    FOREIGN KEY (Username) REFERENCES Account(Username)
);

-- ======================
-- PRODUCT REQUEST
-- ======================
CREATE TABLE ProductRequest (
    ProductRequestID INT PRIMARY KEY,
    Quantity INT NOT NULL,
    RequestDate DATE NOT NULL,
    Status ENUM('Pending', 'Approved', 'Rejected', 'Finished'),
    Description NVARCHAR(255),
    RequestID INT NOT NULL,
    ProductID INT NOT NULL,
    WarehouseID INT NOT NULL,
    FOREIGN KEY (RequestID) REFERENCES Request(RequestID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID)
);

CREATE TABLE WarehouseLog (
    WarehouseLogID INT PRIMARY KEY,
    LogDate DATE NOT NULL,
    Description NVARCHAR(255),
    WarehouseID INT NOT NULL,
    ProductRequestID INT NOT NULL,
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID),
    FOREIGN KEY (ProductRequestID) REFERENCES ProductRequest(ProductRequestID)
);


CREATE TABLE ProductExported (
   ProductWarehouseID INT PRIMARY KEY,
   WarehouseLogID INT NOT NULL,
   FOREIGN KEY (ProductWarehouseID) REFERENCES ProductWarehouse(ProductWarehouseID),
   FOREIGN KEY (WarehouseLogID) REFERENCES WarehouseLog(WarehouseLogID)
);

-- ======================
-- DEVICE
-- ======================
CREATE TABLE ProductContract (
    ItemID INT NOT NULL PRIMARY KEY,
    ContractID INT NOT NULL,
    FOREIGN KEY (ContractID) REFERENCES Contract(ContractID),
    FOREIGN KEY (ItemID) REFERENCES InventoryItem(ItemID)
);

CREATE TABLE UserOTP (
    UserOTPID INT PRIMARY KEY,
    Email VARCHAR(255) NOT NULL,
    OTPCode VARCHAR(10) NOT NULL,
    ExpiredTime DATETIME NOT NULL
);


INSERT INTO Role (RoleID, RoleName) VALUES
(1, 'Admin'),
(2, 'Customer'),
(3, 'CustomerSupporter'),
(4, 'WarehouseKeeper'),
(5, 'TechnicianLeader'),
(6, 'TechnicianEmployee');


CREATE TABLE Province (
	ProvinceID INT PRIMARY KEY NOT NULL,
    ProvinceName NVARCHAR(255) NOT NULL
);

CREATE TABLE Village (
	VillageID INT PRIMARY KEY NOT NULL,
    VillageName NVARCHAR(255) NOT NULL,
    ProvinceID INT NOT NULL,
    FOREIGN KEY (ProvinceID) REFERENCES Province(ProvinceID)
)


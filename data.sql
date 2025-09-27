CREATE TABLE Account (
                         username VARCHAR(50) NOT NULL,
                         password VARCHAR(255) NOT NULL,
                         activeStatus BOOLEAN NOT NULL,
                         role INT NOT NULL,
                         PRIMARY KEY (username)
);

CREATE TABLE Customer (
                          customerId INT NOT NULL,
                          customerName VARCHAR(100) NOT NULL,
                          customerAddress VARCHAR(100) NOT NULL,
                          customerPhone VARCHAR(36) NOT NULL,
                          customerMail VARCHAR(100) NOT NULL,
                          username VARCHAR(50) NOT NULL,
                          PRIMARY KEY (customerId),
                          FOREIGN KEY (username) REFERENCES Account(username)
);

CREATE TABLE Staff (
                       staffId INT NOT NULL,
                       staffLastName VARCHAR(100) NOT NULL,
                       staffFirstName VARCHAR(100) NOT NULL,
                       staffPhone VARCHAR(36) NOT NULL,
                       staffAddress VARCHAR(100) NOT NULL,
                       staffEmail VARCHAR(100) NOT NULL,
                       image BLOB NOT NULL,
                       dateOfBirth DATE NOT NULL,
                       username VARCHAR(50) NOT NULL,
                       PRIMARY KEY (staffId),
                       FOREIGN KEY (username) REFERENCES Account(username)
);

CREATE TABLE Request (
                         requestId INT NOT NULL,
                         requestDescription TEXT NOT NULL,
                         requestStatus INT NOT NULL,
                         createdDate DATE NOT NULL,
                         finishedDate DATE,
                         note TEXT,
                         PRIMARY KEY (requestId)
);

CREATE TABLE Contract (
                          contractId INT NOT NULL,
                          contractImage BLOB NOT NULL,
                          startDate DATE NOT NULL,
                          expiredDate DATE NOT NULL,
                          requestId INT NOT NULL,
                          customerId INT NOT NULL,
                          PRIMARY KEY (contractId),
                          FOREIGN KEY (requestId) REFERENCES Request(requestId),
                          FOREIGN KEY (customerId) REFERENCES Customer(customerId)
);

CREATE TABLE Feedback (
                          feedbackId INT NOT NULL,
                          content TEXT NOT NULL,
                          rating INT NOT NULL,
                          response TEXT,
                          username VARCHAR(50) NOT NULL,
                          PRIMARY KEY (feedbackId),
                          FOREIGN KEY (username) REFERENCES Account(username)
);

CREATE TABLE Warehouse (
                           warehouseId INT NOT NULL,
                           warehouseName VARCHAR(100) NOT NULL,
                           warehouseStatus INT NOT NULL,
                           location VARCHAR(100) NOT NULL,
                           PRIMARY KEY (warehouseId)
);

CREATE TABLE WarehouseLog (
                              warehouseLogId INT NOT NULL,
                              date DATE NOT NULL,
                              status INT NOT NULL,
                              warehouseLogDescription TEXT NOT NULL,
                              warehouseId INT NOT NULL,
                              requestId INT NOT NULL,
                              PRIMARY KEY (warehouseLogId),
                              FOREIGN KEY (warehouseId) REFERENCES Warehouse(warehouseId),
                              FOREIGN KEY (requestId) REFERENCES Request(requestId)
);

CREATE TABLE UpdatedLog (
                            updatedLogId INT NOT NULL,
                            dateUpdated DATE NOT NULL,
                            warehouseId INT NOT NULL,
                            PRIMARY KEY (updatedLogId),
                            FOREIGN KEY (warehouseId) REFERENCES Warehouse(warehouseId)
);

CREATE TABLE Category (
                          categoryId INT NOT NULL,
                          categoryName VARCHAR(100) NOT NULL,
                          categoryImage BLOB,
                          PRIMARY KEY (categoryId)
);

CREATE TABLE Device (
                        deviceId INT NOT NULL,
                        deviceName VARCHAR(100) NOT NULL,
                        deviceImage BLOB,
                        deviceDescription TEXT,
                        categoryId INT NOT NULL,
                        PRIMARY KEY (deviceId),
                        FOREIGN KEY (categoryId) REFERENCES Category(categoryId)
);

CREATE TABLE Component (
                           componentId INT NOT NULL,
                           componentName VARCHAR(100) NOT NULL,
                           componentImage BLOB,
                           componentDescription TEXT,
                           updatedLogId INT,
                           categoryId INT,
                           PRIMARY KEY (componentId),
                           FOREIGN KEY (updatedLogId) REFERENCES UpdatedLog(updatedLogId),
                           FOREIGN KEY (categoryId) REFERENCES Category(categoryId)
);

CREATE TABLE ComponentImportExport (
                                       componentImportExportId INT NOT NULL,
                                       componentImportExportQuantity INT NOT NULL,
                                       warehouseLogId INT NOT NULL,
                                       componentId INT NOT NULL,
                                       PRIMARY KEY (componentImportExportId),
                                       FOREIGN KEY (warehouseLogId) REFERENCES WarehouseLog(warehouseLogId),
                                       FOREIGN KEY (componentId) REFERENCES Component(componentId)
);

CREATE TABLE Specification (
                               specId INT NOT NULL,
                               specName VARCHAR(50) NOT NULL,
                               specValue TEXT NOT NULL,
                               PRIMARY KEY (specId)
);

CREATE TABLE SerialNumber (
                              serialNumberId INT NOT NULL,
                              serialNumberValue VARCHAR(100) NOT NULL,
                              deviceId INT NOT NULL,
                              PRIMARY KEY (serialNumberId),
                              FOREIGN KEY (deviceId) REFERENCES Device(deviceId)
);

CREATE TABLE DeviceInContract (
                                  contractId INT NOT NULL,
                                  serialNumberId INT NOT NULL,
                                  PRIMARY KEY (contractId, serialNumberId),
                                  FOREIGN KEY (contractId) REFERENCES Contract(contractId),
                                  FOREIGN KEY (serialNumberId) REFERENCES SerialNumber(serialNumberId)
);

CREATE TABLE AccountRequest (
                                username VARCHAR(50) NOT NULL,
                                requestId INT NOT NULL,
                                PRIMARY KEY (username, requestId),
                                FOREIGN KEY (username) REFERENCES Account(username),
                                FOREIGN KEY (requestId) REFERENCES Request(requestId)
);

CREATE TABLE InStock (
                         quantity INT NOT NULL,
                         componentId INT NOT NULL,
                         warehouseId INT NOT NULL,
                         PRIMARY KEY (componentId, warehouseId),
                         FOREIGN KEY (componentId) REFERENCES Component(componentId),
                         FOREIGN KEY (warehouseId) REFERENCES Warehouse(warehouseId)
);

CREATE TABLE ComponentSpecification (
                                        specId INT NOT NULL,
                                        componentId INT NOT NULL,
                                        PRIMARY KEY (specId, componentId),
                                        FOREIGN KEY (specId) REFERENCES Specification(specId),
                                        FOREIGN KEY (componentId) REFERENCES Component(componentId)
);

CREATE TABLE DeviceComponent (
                                 componentQuantity INT NOT NULL,
                                 componentId INT NOT NULL,
                                 deviceId INT NOT NULL,
                                 PRIMARY KEY (componentId, deviceId),
                                 FOREIGN KEY (componentId) REFERENCES Component(componentId),
                                 FOREIGN KEY (deviceId) REFERENCES Device(deviceId)
);

CREATE TABLE DeviceInWarehouse (
                                   deviceQuantity INT NOT NULL,
                                   deviceId INT NOT NULL,
                                   warehouseId INT NOT NULL,
                                   PRIMARY KEY (deviceId, warehouseId),
                                   FOREIGN KEY (deviceId) REFERENCES Device(deviceId),
                                   FOREIGN KEY (warehouseId) REFERENCES Warehouse(warehouseId)
);

CREATE TABLE ComponentUpdate (
                                 componentUpdateId INT NOT NULL,
                                 oldQuantity INT NOT NULL,
                                 newQuantity INT NOT NULL,
                                 updatedLogId INT NOT NULL,
                                 componentId INT NOT NULL,
                                 PRIMARY KEY (componentUpdateId),
                                 FOREIGN KEY (updatedLogId) REFERENCES UpdatedLog(updatedLogId),
                                 FOREIGN KEY (componentId) REFERENCES Component(componentId)
);

CREATE TABLE DeviceUpdate (
                              deviceUpdateId INT NOT NULL,
                              oldQuantity INT NOT NULL,
                              newQuantity INT NOT NULL,
                              deviceId INT NOT NULL,
                              updatedLogId INT NOT NULL,
                              PRIMARY KEY (deviceUpdateId),
                              FOREIGN KEY (deviceId) REFERENCES Device(deviceId),
                              FOREIGN KEY (updatedLogId) REFERENCES UpdatedLog(updatedLogId)
);

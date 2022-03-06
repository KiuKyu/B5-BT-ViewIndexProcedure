CREATE DATABASE demo;
USE demo;
CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY ,
    productCode VARCHAR(20),
    productName VARCHAR(40),
    productPrice INT,
    productAmount INT,
    productDescription VARCHAR(100),
    productStatus BIT
);

INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
VALUES ('IP6', 'iPhone 6', 6000000, 5, 'Hàng tồn kho', 1),
       ('IP7', 'iPhone 7', 7000000, 10, 'Hàng tồn kho', 1),
       ('IP8', 'iPhone 8', 8000000, 15, 'Hàng tồn kho', 1),
       ('IP9', 'iPhone 9', 0, 0, 'Không tồn tại', 0),
       ('IPX', 'iPhone X', 10000000, 20, 'Hàng mới', 1);

SELECT * FROM Products;
# Tạo Unique Index trên bảng Products (sử dụng cột productCode để tạo chỉ mục)
ALTER TABLE Products ADD INDEX idx_productCode (productCode);
# Tạo Composite Index trên bảng Products (sử dụng 2 cột productName và productPrice)
ALTER TABLE Products ADD INDEX idx_name_price (productName, productPrice);
# Sử dụng câu lệnh EXPLAIN để biết được câu lệnh SQL của bạn thực thi như nào
EXPLAIN SELECT * FROM Products WHERE productCode = 'IP6';
EXPLAIN SELECT * FROM Products WHERE productAmount = '0';

# Tạo view lấy về các thông tin: productCode, productName, productPrice, productStatus từ bảng products.
CREATE VIEW prd_details AS
    SELECT productCode, productName, productPrice, productStatus
FROM Products;
# Tiến hành sửa đổi view
UPDATE prd_details
SET productName = 'iPhone 10' WHERE productCode = 'IPX';

SELECT * FROM products;
# Tiến hành xoá view
DROP VIEW prd_details;
# Tạo store procedure lấy tất cả thông tin của tất cả các sản phẩm trong bảng product
DELIMITER //
CREATE PROCEDURE getInfo()
BEGIN
    SELECT productCode, productName, productPrice, productAmount, productDescription
    FROM Products;
END //
DELIMITER ;

CALL getInfo();
# Tạo store procedure thêm một sản phẩm mới
DELIMITER //
CREATE PROCEDURE addNewProduct (
IN inputProductCode VARCHAR(20),
IN inputProductName VARCHAR(40),
IN inputProductPrice INT,
IN inputProductAmount INT,
IN inputProductDescription VARCHAR(100),
IN inputProductStatus BIT
)
BEGIN
    INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus) VALUES
        (inputProductCode, inputProductName, inputProductPrice, inputProductAmount, inputProductDescription, inputProductStatus);
END //
DELIMITER ;

CALL addNewProduct ('IP11', 'iPhone 11', 11000000,
    30, 'Hàng mới', 1);
# Tạo store procedure sửa thông tin sản phẩm theo id
DELIMITER //
CREATE PROCEDURE editProduct (
    IN findProductId INT,
    IN newProductCode VARCHAR(20),
    IN newProductName VARCHAR(40),
    IN newProductAmount INT,
    IN newProductPrice INT,
    IN newProductDescription VARCHAR(100),
    IN newProductStatus BIT
)
BEGIN
    UPDATE Products SET productCode = newProductCode,
                        productName = newProductName,
                        productAmount = newProductAmount,
                        productPrice = newProductPrice,
                        productDescription = newProductDescription,
                        productStatus = newProductStatus
    WHERE Id = findProductId;
END //
DELIMITER ;
CALL editProduct(9, 'IP9', 'iPhone Cirno', 0, 0,
    'Doesnt even exist bro', 0);
# Tạo store procedure xoá sản phẩm theo id
DELIMITER //
CREATE PROCEDURE deleteProduct (IN findProductId INT)
BEGIN
    DELETE FROM Products WHERE Id = findProductId;
END //
DELIMITER ;

CALL deleteProduct(4);
SELECT * FROM Products;

<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/3/2025
  Time: 9:45 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Product List</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Warehouse/ViewProduct.css">
</head>
<body>
<div class="container">
    <h1>Product In Warehouse List</h1>

    <div class="top-controls">
        <button id="addProductBtn" class="btn btn-primary">Add Product</button>

        <div class="filter-section">
            <h3>Filters</h3>

            <form action="viewProductWarehouse" method="GET">
                <div class="filter-group">
                    <label>Product Name:</label>
                    <input type="text" name="productName" placeholder="Search by name">
                </div>
                <div class="filter-group">
                    <label>Type:</label>
                    <input type="text" name="productType" placeholder="Search by type">
                </div>
                <div class="filter-group">
                    <label>Stock Status:</label>
                    <select name="status" id="stockFilter">
                        <option value="">All</option>
                        <option value="In_Stock">In Stock</option>
                        <option value="Exported">Exported</option>
                    </select>
                </div>
                <input type="submit" value="Apply Filters" class="btn btn-secondary">
            </form>
        </div>
    </div>

    <div class="product-list">
        <table>
            <thead>
            <tr>
                <th>Name</th>
                <th>Description</th>
                <th>Type</th>
                <th>Specification</th>
                <th>Stock</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="productWarehouse" items="${products}">
                <tr>
                    <td>${productWarehouse.productName}</td>
                    <td>${productWarehouse.productDescription}</td>
                    <td>${productWarehouse.type.typeName}</td>
                    <td>
                        <c:forEach var="spec" items="${productWarehouse.productSpecifications}">
                            ${spec.specification.specificationName}: ${spec.specification.specificationValue}<br/>
                        </c:forEach>
                    </td>
                    <td>${productCounts[productWarehouse.productID]}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

</div>


</body>
</html>

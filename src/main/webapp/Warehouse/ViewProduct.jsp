<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/3/2025
  Time: 9:45 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Product List</title>
    <link rel="stylesheet" href="ViewProduct.css">
</head>
<body>
<div class="container">
    <h1>Product List</h1>

    <div class="top-controls">
        <button id="addProductBtn" class="btn btn-primary">Add Product</button>

        <div class="filter-section">
            <h3>Filters</h3>
            <div class="filter-group">
                <label>Product Type:</label>
                <select id="typeFilter">
                    <option value="">All Types</option>
                    <option value="1">Laptop</option>
                    <option value="2">Desktop</option>
                    <option value="3">Components</option>
                </select>
            </div>
            <div class="filter-group">
                <label>Specifications:</label>
                <div id="specFilters">
                    <!-- Dynamically populated by JavaScript -->
                </div>
            </div>
            <div class="filter-group">
                <label>Stock Status:</label>
                <select id="stockFilter">
                    <option value="">All</option>
                    <option value="In stock">In Stock</option>
                    <option value="Exported">Exported</option>
                </select>
            </div>
            <button id="applyFiltersBtn" class="btn">Apply Filters</button>
        </div>
    </div>

    <div class="product-list">
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Image</th>
                <th>Name</th>
                <th>Description</th>
                <th>Type</th>
                <th>Stock</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody id="productTableBody">
            <!-- Products will be loaded here by JavaScript -->
            </tbody>
        </table>
    </div>

    <div class="pagination" id="pagination">
        <!-- Pagination controls will be added by JavaScript -->
    </div>
</div>

<!-- Product Modal (for Add/Edit) -->
<div id="productModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h2 id="modalTitle">Add Product</h2>
        <form id="productForm">
            <input type="hidden" id="productId" name="productId">

            <div class="form-group">
                <label for="productName">Product Name:</label>
                <input type="text" id="productName" name="productName" required>
            </div>

            <div class="form-group">
                <label for="productDescription">Description:</label>
                <textarea id="productDescription" name="productDescription"></textarea>
            </div>

            <div class="form-group">
                <label for="productType">Product Type:</label>
                <select id="productType" name="productType" required>
                    <option value="1">Laptop</option>
                    <option value="2">Desktop</option>
                    <option value="3">Components</option>
                </select>
            </div>

            <div class="form-group">
                <label for="productImage">Product Image URL:</label>
                <input type="text" id="productImage" name="productImage">
            </div>

            <div class="form-group specifications-section">
                <label>Specifications:</label>
                <div id="specificationsContainer">
                    <!-- Will be dynamically populated -->
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Save Product</button>
                <button type="button" class="btn" id="cancelBtn">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script src="ViewProduct.js"></script>
</body>
</html>

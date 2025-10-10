<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Product</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            box-sizing: border-box;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-full">
<div class="container mx-auto px-4 py-8">
    <!-- Header -->
    <div class="bg-white rounded-lg shadow-lg p-6 mb-8">
        <h1 class="text-3xl font-bold text-gray-800 mb-2">View Product In Warehouse</h1>
    </div>

    <!-- Function Buttons -->
    <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
        <h2 class="text-xl font-semibold text-gray-800 mb-4">Inventory Actions</h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <a href=""
               class="bg-green-600 hover:bg-green-700 text-white font-medium py-3 px-4 rounded-lg transition duration-200 flex items-center justify-center shadow-md hover:shadow-lg transform hover:-translate-y-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd"
                          d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-11a1 1 0 10-2 0v2H7a1 1 0 100 2h2v2a1 1 0 102 0v-2h2a1 1 0 100-2h-2V7z"
                          clip-rule="evenodd"/>
                </svg>
                Import Products
            </a>

            <a href=""
               class="bg-amber-600 hover:bg-amber-700 text-white font-medium py-3 px-4 rounded-lg transition duration-200 flex items-center justify-center shadow-md hover:shadow-lg transform hover:-translate-y-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd"
                          d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-8.707l-3-3a1 1 0 00-1.414 0l-3 3a1 1 0 001.414 1.414L9 9.414V13a1 1 0 102 0V9.414l1.293 1.293a1 1 0 001.414-1.414z"
                          clip-rule="evenodd"/>
                </svg>
                Export Products
            </a>

            <a href=""
               class="bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-3 px-4 rounded-lg transition duration-200 flex items-center justify-center shadow-md hover:shadow-lg transform hover:-translate-y-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd"
                          d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 0111.601 2.566 1 1 0 11-1.885.666A5.002 5.002 0 005.999 7H9a1 1 0 010 2H4a1 1 0 01-1-1V3a1 1 0 011-1zm.008 9.057a1 1 0 011.276.61A5.002 5.002 0 0014.001 13H11a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0v-2.101a7.002 7.002 0 01-11.601-2.566 1 1 0 01.61-1.276z"
                          clip-rule="evenodd"/>
                </svg>
                Transfer Items
            </a>
        </div>
    </div>


    <!-- Filters -->
    <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
        <h2 class="text-xl font-semibold text-gray-800 mb-4">Filter</h2>
        <form action="viewProductWarehouse" method="GET" id="filterForm" class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <input type="hidden" name="pageSize" value="${pageSize}">
            <input type="hidden" name="page" value="${currentPage}">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">ProductName</label>
                <input type="text" id="productName" name="productName"
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                       placeholder="Enter product name...">
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Product Type</label>
                <select id="productType" name="productType"
                        class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <option value="">All type</option>
                    <c:forEach items="${uniqueProductTypes}" var="type">
                        <option value="${type.typeName}" ${productType == type.typeName ? 'selected' : ''}>${type.typeName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="flex items-end">
                <button type="submit"
                        class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-md transition duration-200">
                    Apply Filters
                </button>
            </div>
        </form>
    </div>

    <!-- Page Size Selector -->
    <div class="bg-white rounded-lg shadow-lg p-4 mb-6">
        <div class="flex justify-between items-center">
            <div class="flex items-center space-x-4">
                <span class="text-sm text-gray-600">Display:</span>
                <form action="viewProductWarehouse" method="GET">
                    <input type="hidden" name="productName" value="${productName}">
                    <input type="hidden" name="productType" value="${productType}">
                    <input type="hidden" name="page" value="${currentPage}">
                    <select name="pageSize" id="pageSize" class="px-3 py-1 border border-gray-300 rounded-md text-sm"
                            onchange="this.form.submit()">
                        <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                        <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                        <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                    </select>
                </form>
            </div>
            <div class="text-sm text-gray-600">
                Total: <span id="totalProducts" class="font-semibold text-blue-600"></span>${totalProducts}
                products
            </div>
        </div>
    </div>

    <!-- Products Table (styled) -->
    <div class="bg-white rounded-lg shadow-lg p-4 mb-8">
        <div class="overflow-x-auto">
            <table class="min-w-full table-auto border-collapse">
                <thead class="bg-gray-50">
                <tr>
                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Name
                    </th>
                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Description
                    </th>
                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Type
                    </th>
                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Specification
                    </th>
                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Stock
                    </th>
                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Action
                    </th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                <c:forEach var="productWarehouse" items="${products}">
                    <tr class="hover:bg-gray-50">
                        <td class="px-4 py-3 text-sm text-gray-800">${productWarehouse.productName}</td>
                        <td class="px-4 py-3 text-sm text-gray-600">${productWarehouse.productDescription}</td>
                        <td class="px-4 py-3 text-sm text-gray-700">${productWarehouse.type.typeName}</td>
                        <td class="px-4 py-3 text-sm text-gray-700">
                            <c:forEach var="spec" items="${productWarehouse.productSpecifications}">
                                <div class="whitespace-nowrap">
                                    <span class="font-medium text-gray-800">${spec.specification.specificationName}:</span>
                                    <span class="text-gray-600">${spec.specification.specificationValue}</span>
                                </div>
                            </c:forEach>
                        </td>
                        <td class="px-4 py-3 text-sm font-semibold text-gray-900">
                                ${productCounts[productWarehouse.productID]}
                        </td>
                        <td class="px-4 py-3">
                            <a href=""
                               class="inline-flex items-center px-3 py-1.5 rounded-md text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-1">
                                View Detail
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pagination (styled) -->
    <div class="bg-white rounded-lg shadow-lg p-6">
        <c:set var="startItem" value="${totalProducts == 0 ? 0 : (currentPage - 1) * pageSize + 1}"/>
        <c:set var="endItem"
               value="${currentPage * pageSize > totalProducts ? totalProducts : currentPage * pageSize}"/>

        <div class="flex items-center justify-between mb-4 text-sm text-gray-600">
            <div>
                Page <span class="font-semibold">${currentPage}</span>
                of <span class="font-semibold">${totalPages}</span>
            </div>
            <div>
                Displaying <span class="font-semibold">${startItem} - ${endItem}</span>
                of <span class="font-semibold">${totalProducts}</span> items
            </div>
        </div>

        <div class="flex justify-center">
            <ul class="inline-flex -space-x-px rounded-md shadow-sm">
                <!-- Previous -->
                <c:if test="${currentPage > 1}">
                    <li>
                        <a class="px-3 py-2 ml-0 leading-tight text-gray-700 bg-white border border-gray-300 rounded-l-md hover:bg-gray-50"
                           href="viewProductWarehouse?page=${currentPage - 1}&pageSize=${pageSize}&productName=${productName}&productType=${productType}">
                            Previous
                        </a>
                    </li>
                </c:if>

                <!-- Page Numbers -->
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li>
                        <a class="px-3 py-2 leading-tight border text-sm ${i == currentPage ? 'bg-blue-600 text-white border-blue-600' : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50'}"
                           href="viewProductWarehouse?page=${i}&pageSize=${pageSize}&productName=${productName}&productType=${productType}">
                                ${i}
                        </a>
                    </li>
                </c:forEach>

                <!-- Next -->
                <c:if test="${currentPage < totalPages}">
                    <li>
                        <a class="px-3 py-2 leading-tight text-gray-700 bg-white border border-gray-300 rounded-r-md hover:bg-gray-50"
                           href="viewProductWarehouse?page=${currentPage + 1}&pageSize=${pageSize}&productName=${productName}&productType=${productType}">
                            Next
                        </a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</div>
</body>
</html>

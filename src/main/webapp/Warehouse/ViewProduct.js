// Mock data for demonstration - in a real app this would come from the server
const mockProducts = [
    {
        id: 1,
        name: "Dell XPS 13",
        image: "https://example.com/xps13.jpg",
        description: "Premium ultrabook with InfinityEdge display",
        typeId: 1,
        typeName: "Laptop",
        specifications: [
            { id: 1, name: "Processor", value: "Intel Core i7" },
            { id: 2, name: "RAM", value: "16GB" },
            { id: 3, name: "Storage", value: "512GB SSD" }
        ],
        stock: 5
    },
    {
        id: 2,
        name: "HP Pavilion",
        image: "https://example.com/pavilion.jpg",
        description: "Budget-friendly laptop for everyday use",
        typeId: 1,
        typeName: "Laptop",
        specifications: [
            { id: 1, name: "Processor", value: "Intel Core i5" },
            { id: 2, name: "RAM", value: "8GB" },
            { id: 3, name: "Storage", value: "256GB SSD" }
        ],
        stock: 8
    },
    {
        id: 3,
        name: "Dell OptiPlex",
        image: "https://example.com/optiplex.jpg",
        description: "Business desktop computer",
        typeId: 2,
        typeName: "Desktop",
        specifications: [
            { id: 1, name: "Processor", value: "Intel Core i5" },
            { id: 2, name: "RAM", value: "8GB" },
            { id: 4, name: "Graphics", value: "Integrated" }
        ],
        stock: 3
    },
    {
        id: 4,
        name: "NVIDIA RTX 3080",
        image: "https://example.com/rtx3080.jpg",
        description: "High-performance graphics card",
        typeId: 3,
        typeName: "Components",
        specifications: [
            { id: 5, name: "Memory", value: "10GB GDDR6X" },
            { id: 6, name: "Ports", value: "HDMI, DisplayPort" }
        ],
        stock: 2
    },
    {
        id: 5,
        name: "AMD Ryzen 9 5900X",
        image: "https://example.com/ryzen9.jpg",
        description: "12-core, 24-thread desktop processor",
        typeId: 3,
        typeName: "Components",
        specifications: [
            { id: 1, name: "Processor", value: "AMD Ryzen 9" },
            { id: 7, name: "Socket", value: "AM4" },
            { id: 8, name: "TDP", value: "105W" }
        ],
        stock: 0
    },
    {
        id: 6,
        name: "Lenovo ThinkPad X1",
        image: "https://example.com/thinkpad.jpg",
        description: "Business laptop with excellent keyboard",
        typeId: 1,
        typeName: "Laptop",
        specifications: [
            { id: 1, name: "Processor", value: "Intel Core i7" },
            { id: 2, name: "RAM", value: "16GB" },
            { id: 3, name: "Storage", value: "1TB SSD" }
        ],
        stock: 4
    },
    {
        id: 7,
        name: "HP EliteDesk",
        image: "https://example.com/elitedesk.jpg",
        description: "Compact business desktop",
        typeId: 2,
        typeName: "Desktop",
        specifications: [
            { id: 1, name: "Processor", value: "Intel Core i5" },
            { id: 2, name: "RAM", value: "16GB" },
            { id: 3, name: "Storage", value: "256GB SSD" }
        ],
        stock: 6
    },
    {
        id: 8,
        name: "Crucial MX500 SSD",
        image: "https://example.com/mx500.jpg",
        description: "Reliable solid state drive",
        typeId: 3,
        typeName: "Components",
        specifications: [
            { id: 3, name: "Storage", value: "1TB" },
            { id: 9, name: "Interface", value: "SATA" }
        ],
        stock: 12
    }
];

// Mock specification options
const specificationOptions = [
    { id: 1, name: "Processor", values: ["Intel Core i3", "Intel Core i5", "Intel Core i7", "AMD Ryzen 5", "AMD Ryzen 7", "AMD Ryzen 9"] },
    { id: 2, name: "RAM", values: ["4GB", "8GB", "16GB", "32GB", "64GB"] },
    { id: 3, name: "Storage", values: ["128GB SSD", "256GB SSD", "512GB SSD", "1TB SSD", "2TB HDD"] },
    { id: 4, name: "Graphics", values: ["Integrated", "NVIDIA GTX", "NVIDIA RTX", "AMD Radeon"] },
    { id: 5, name: "Memory", values: ["4GB", "6GB", "8GB", "10GB", "12GB", "16GB"] },
    { id: 6, name: "Ports", values: ["USB-C", "HDMI", "DisplayPort", "VGA"] },
    { id: 7, name: "Socket", values: ["AM4", "LGA1200", "LGA1700"] },
    { id: 8, name: "TDP", values: ["65W", "95W", "105W", "125W"] },
    { id: 9, name: "Interface", values: ["SATA", "NVMe", "PCIe"] }
];

// Pagination variables
let currentPage = 1;
const itemsPerPage = 5;
let filteredProducts = [...mockProducts];

// DOM Elements
document.addEventListener('DOMContentLoaded', function() {
    // Initialize the application
    loadSpecificationFilters();
    renderProducts();
    setupEventListeners();
});

function loadSpecificationFilters() {
    const specFiltersContainer = document.getElementById('specFilters');
    specFiltersContainer.innerHTML = '';

    // Add the most common spec filters
    const commonSpecs = specificationOptions.slice(0, 4);

    commonSpecs.forEach(spec => {
        const filterDiv = document.createElement('div');
        filterDiv.className = 'spec-filter';

        const select = document.createElement('select');
        select.id = `spec-${spec.id}`;
        select.name = `spec-${spec.id}`;

        const defaultOption = document.createElement('option');
        defaultOption.value = '';
        defaultOption.textContent = `${spec.name}...`;
        select.appendChild(defaultOption);

        spec.values.forEach(value => {
            const option = document.createElement('option');
            option.value = value;
            option.textContent = value;
            select.appendChild(option);
        });

        filterDiv.appendChild(select);
        specFiltersContainer.appendChild(filterDiv);
    });
}

function renderProducts() {
    // Apply pagination
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const paginatedProducts = filteredProducts.slice(startIndex, endIndex);

    const tbody = document.getElementById('productTableBody');
    tbody.innerHTML = '';

    if (paginatedProducts.length === 0) {
        const tr = document.createElement('tr');
        const td = document.createElement('td');
        td.colSpan = 7;
        td.textContent = 'No products found';
        td.style.textAlign = 'center';
        tr.appendChild(td);
        tbody.appendChild(tr);
        return;
    }

    paginatedProducts.forEach(product => {
        const tr = document.createElement('tr');

        // ID column
        const tdId = document.createElement('td');
        tdId.textContent = product.id;
        tr.appendChild(tdId);

        // Image column
        const tdImage = document.createElement('td');
        const img = document.createElement('img');
        img.src = product.image;
        img.alt = product.name;
        img.className = 'product-image';
        img.onerror = function() { this.src = 'https://via.placeholder.com/50'; };
        tdImage.appendChild(img);
        tr.appendChild(tdImage);

        // Name column
        const tdName = document.createElement('td');
        tdName.textContent = product.name;
        tr.appendChild(tdName);

        // Description column
        const tdDesc = document.createElement('td');
        tdDesc.textContent = product.description;
        tr.appendChild(tdDesc);

        // Type column
        const tdType = document.createElement('td');
        tdType.textContent = product.typeName;
        tr.appendChild(tdType);

        // Stock column
        const tdStock = document.createElement('td');
        tdStock.textContent = product.stock > 0 ? `In stock (${product.stock})` : 'Out of stock';
        tdStock.style.color = product.stock > 0 ? 'green' : 'red';
        tr.appendChild(tdStock);

        // Actions column
        const tdActions = document.createElement('td');

        const editBtn = document.createElement('button');
        editBtn.className = 'action-btn';
        editBtn.textContent = 'Edit';
        editBtn.onclick = function() { openEditProductModal(product); };
        tdActions.appendChild(editBtn);

        tr.appendChild(tdActions);

        tbody.appendChild(tr);
    });

    renderPagination();
}

function renderPagination() {
    const totalPages = Math.ceil(filteredProducts.length / itemsPerPage);
    const paginationElement = document.getElementById('pagination');
    paginationElement.innerHTML = '';

    if (totalPages <= 1) return;

    // Previous button
    if (currentPage > 1) {
        const prevBtn = document.createElement('button');
        prevBtn.className = 'page-btn';
        prevBtn.textContent = '«';
        prevBtn.onclick = function() {
            currentPage--;
            renderProducts();
        };
        paginationElement.appendChild(prevBtn);
    }

    // Page numbers
    for (let i = 1; i <= totalPages; i++) {
        const pageBtn = document.createElement('button');
        pageBtn.className = 'page-btn';
        if (i === currentPage) pageBtn.classList.add('active');
        pageBtn.textContent = i;
        pageBtn.onclick = function() {
            currentPage = i;
            renderProducts();
        };
        paginationElement.appendChild(pageBtn);
    }

    // Next button
    if (currentPage < totalPages) {
        const nextBtn = document.createElement('button');
        nextBtn.className = 'page-btn';
        nextBtn.textContent = '»';
        nextBtn.onclick = function() {
            currentPage++;
            renderProducts();
        };
        paginationElement.appendChild(nextBtn);
    }
}

function applyFilters() {
    const typeFilter = document.getElementById('typeFilter').value;
    const stockFilter = document.getElementById('stockFilter').value;

    // Get specification filters
    const specFilters = [];
    specificationOptions.slice(0, 4).forEach(spec => {
        const select = document.getElementById(`spec-${spec.id}`);
        if (select && select.value) {
            specFilters.push({
                id: spec.id,
                value: select.value
            });
        }
    });

    // Apply filters
    filteredProducts = mockProducts.filter(product => {
        // Type filter
        if (typeFilter && product.typeId.toString() !== typeFilter) {
            return false;
        }

        // Stock filter
        if (stockFilter === 'In stock' && product.stock <= 0) {
            return false;
        } else if (stockFilter === 'Exported' && product.stock > 0) {
            return false;
        }

        // Specification filters
        for (const filter of specFilters) {
            const specMatch = product.specifications.some(spec =>
                spec.id === filter.id && spec.value.includes(filter.value)
            );
            if (!specMatch) return false;
        }

        return true;
    });

    // Reset to first page
    currentPage = 1;
    renderProducts();
}

function openAddProductModal() {
    // Clear form
    document.getElementById('productForm').reset();
    document.getElementById('productId').value = '';
    document.getElementById('modalTitle').textContent = 'Add Product';

    // Load specifications options in the form
    loadSpecificationsInForm();

    // Show modal
    document.getElementById('productModal').style.display = 'block';
}

function openEditProductModal(product) {
    document.getElementById('productId').value = product.id;
    document.getElementById('productName').value = product.name;
    document.getElementById('productDescription').value = product.description;
    document.getElementById('productImage').value = product.image;
    document.getElementById('productType').value = product.typeId;
    document.getElementById('modalTitle').textContent = 'Edit Product';

    // Load specifications options in the form
    loadSpecificationsInForm(product.specifications);

    // Show modal
    document.getElementById('productModal').style.display = 'block';
}

function loadSpecificationsInForm(productSpecs = []) {
    const container = document.getElementById('specificationsContainer');
    container.innerHTML = '';

    specificationOptions.forEach(spec => {
        const div = document.createElement('div');
        div.className = 'spec-item';

        const label = document.createElement('label');
        label.textContent = spec.name + ':';
        div.appendChild(label);

        const select = document.createElement('select');
        select.name = `spec-${spec.id}`;
        select.id = `form-spec-${spec.id}`;

        const defaultOption = document.createElement('option');
        defaultOption.value = '';
        defaultOption.textContent = 'Select...';
        select.appendChild(defaultOption);

        spec.values.forEach(value => {
            const option = document.createElement('option');
            option.value = value;
            option.textContent = value;
            select.appendChild(option);
        });

        // Set selected value if editing
        const existingSpec = productSpecs.find(s => s.id === spec.id);
        if (existingSpec) {
            for (let i = 0; i < select.options.length; i++) {
                if (select.options[i].value === existingSpec.value) {
                    select.selectedIndex = i;
                    break;
                }
            }
        }

        div.appendChild(select);
        container.appendChild(div);
    });
}

function setupEventListeners() {
    // Add product button
    document.getElementById('addProductBtn').addEventListener('click', openAddProductModal);

    // Apply filters button
    document.getElementById('applyFiltersBtn').addEventListener('click', applyFilters);

    // Modal close button
    document.querySelector('.close').addEventListener('click', function() {
        document.getElementById('productModal').style.display = 'none';
    });

    // Cancel button in form
    document.getElementById('cancelBtn').addEventListener('click', function() {
        document.getElementById('productModal').style.display = 'none';
    });

    // Form submission (Save product)
    document.getElementById('productForm').addEventListener('submit', function(e) {
        e.preventDefault();
        saveProduct();
    });

    // Close modal when clicking outside of it
    window.addEventListener('click', function(e) {
        const modal = document.getElementById('productModal');
        if (e.target === modal) {
            modal.style.display = 'none';
        }
    });
}

function saveProduct() {
    const productId = document.getElementById('productId').value;
    const isEdit = productId !== '';

    // Get form values
    const productData = {
        id: isEdit ? parseInt(productId) : mockProducts.length + 1,
        name: document.getElementById('productName').value,
        description: document.getElementById('productDescription').value,
        image: document.getElementById('productImage').value,
        typeId: parseInt(document.getElementById('productType').value),
        typeName: document.getElementById('productType').options[document.getElementById('productType').selectedIndex].text,
        specifications: [],
        stock: isEdit ? mockProducts.find(p => p.id === parseInt(productId)).stock : 0
    };

    // Get specifications
    specificationOptions.forEach(spec => {
        const select = document.getElementById(`form-spec-${spec.id}`);
        if (select && select.value) {
            productData.specifications.push({
                id: spec.id,
                name: spec.name,
                value: select.value
            });
        }
    });

    // Update or add product
    if (isEdit) {
        // Find and update product
        const index = mockProducts.findIndex(p => p.id === parseInt(productId));
        if (index !== -1) {
            mockProducts[index] = productData;
        }
    } else {
        // Add new product
        mockProducts.push(productData);
    }

    // Close modal
    document.getElementById('productModal').style.display = 'none';

    // Refresh product list
    filteredProducts = [...mockProducts];
    renderProducts();

    // Show confirmation message
    alert(isEdit ? 'Product updated successfully!' : 'Product added successfully!');
}
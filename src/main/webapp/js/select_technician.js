        document.getElementById('assignBtn').addEventListener('click', function(e) {
            const selectedTechnician = document.querySelector('input[name="selectedTechnician"]:checked');
            if (!selectedTechnician) {
                e.preventDefault();
                alert('Please select a technician to assign the tasks.');
                return false;
            }
        });
        
        document.addEventListener('DOMContentLoaded', function() {
            const technicianCards = document.querySelectorAll('.technician-card');
            const radioButtons = document.querySelectorAll('input[name="selectedTechnician"]');
            
            radioButtons.forEach(radio => {
                radio.addEventListener('change', function() {
                    technicianCards.forEach(card => {
                        card.classList.remove('selected');
                    });
                    
                    if (this.checked) {
                        const card = this.closest('.form-check').querySelector('.technician-card');
                        card.classList.add('selected');
                        
                        card.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                });
            });
            
            technicianCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    if (!this.classList.contains('selected')) {
                        this.style.transform = 'translateY(-2px)';
                    }
                });
                
                card.addEventListener('mouseleave', function() {
                    if (!this.classList.contains('selected')) {
                        this.style.transform = 'translateY(0)';
                    }
                });
            });
        });
        
        function clearFilters() {
            document.getElementById('searchName').value = '';
            document.getElementById('filterLocation').value = '';
            document.getElementById('filterAge').value = '';
            document.getElementById('filterForm').submit();
        }
        
        function applyFilters() {
            document.getElementById('filterForm').submit();
        }
        
        function updatePageSize() {
            const pageSize = document.getElementById('pageSize').value;
            const form = document.getElementById('filterForm');
            
            let pageSizeInput = document.querySelector('input[name="recordsPerPage"]');
            if (!pageSizeInput) {
                pageSizeInput = document.createElement('input');
                pageSizeInput.type = 'hidden';
                pageSizeInput.name = 'recordsPerPage';
                form.appendChild(pageSizeInput);
            }
            pageSizeInput.value = pageSize;
            
            let pageInput = document.querySelector('input[name="page"]');
            if (!pageInput) {
                pageInput = document.createElement('input');
                pageInput.type = 'hidden';
                pageInput.name = 'page';
                form.appendChild(pageInput);
            }
            pageInput.value = '1';
            
            form.submit();
        }
        
        function goToPage(page) {
            const searchName = document.getElementById('searchName').value;
            const location = document.getElementById('filterLocation').value;
            const ageRange = document.getElementById('filterAge').value;
            const recordsPerPage = document.getElementById('pageSize').value;
            
            let url = '${pageContext.request.contextPath}/task/selectTechnician?page=' + page;
            
            <c:forEach var="taskId" items="${selectedTaskIds}">
                url += '&selectedTasks=${taskId}';
            </c:forEach>
            
            if (searchName) url += '&searchName=' + encodeURIComponent(searchName);
            if (location) url += '&location=' + encodeURIComponent(location);
            if (ageRange) url += '&ageRange=' + encodeURIComponent(ageRange);
            if (recordsPerPage) url += '&recordsPerPage=' + encodeURIComponent(recordsPerPage);
            
            window.location.href = url;
            return false;
        }
        
        function buildPaginationUrl(page) {
            const searchName = document.getElementById('searchName').value;
            const location = document.getElementById('filterLocation').value;
            const ageRange = document.getElementById('filterAge').value;
            const recordsPerPage = document.getElementById('pageSize').value;
            
            let url = '${pageContext.request.contextPath}/task/selectTechnician?page=' + page;
            
            <c:forEach var="taskId" items="${selectedTaskIds}">
                url += '&selectedTasks=${taskId}';
            </c:forEach>
            
            if (searchName) url += '&searchName=' + encodeURIComponent(searchName);
            if (location) url += '&location=' + encodeURIComponent(location);
            if (ageRange) url += '&ageRange=' + encodeURIComponent(ageRange);
            if (recordsPerPage) url += '&recordsPerPage=' + encodeURIComponent(recordsPerPage);
            
            return url;
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Technicians loaded: ${totalCount}');
            
            document.getElementById('clearFilterBtn').addEventListener('click', clearFilters);
            document.getElementById('applyFilterBtn').addEventListener('click', applyFilters);
            
            const pageSizeSelector = document.getElementById('pageSize');
            if (pageSizeSelector) {
                pageSizeSelector.addEventListener('change', updatePageSize);
                
                <c:if test="${not empty recordsPerPage}">
                    pageSizeSelector.value = '${recordsPerPage}';
                </c:if>
            }
            
            const paginationLinks = document.querySelectorAll('.pagination .page-link[data-page]');
            paginationLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    const page = this.getAttribute('data-page');
                    goToPage(parseInt(page));
                });
            });
            
            showFilterSummary();
        });
        
     
        function viewTech(staffId) {
            const form = document.createElement('form');
            form.method = 'post';
            form.action = '${pageContext.request.contextPath}/tech/employees/view';

            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'id';
            input.value = staffId;
            form.appendChild(input);

            document.body.appendChild(form);
            form.submit();
        }


        function showFilterSummary() {
            const searchName = document.getElementById('searchName').value;
            const location = document.getElementById('filterLocation').value;
            const ageRange = document.getElementById('filterAge').value;
            
            if (searchName || location || ageRange) {
                let summary = 'Active filters: ';
                const filters = [];
                
                if (searchName) filters.push('Search: "' + searchName + '"');
                if (location) filters.push('Location: "' + location + '"');
                if (ageRange) {
                    const ageText = document.querySelector('#filterAge option[value="' + ageRange + '"]').textContent;
                    filters.push('Age: "' + ageText + '"');
                }
                
                summary += filters.join(', ');
                
                let filterSummary = document.getElementById('filterSummary');
                if (!filterSummary) {
                    filterSummary = document.createElement('div');
                    filterSummary.id = 'filterSummary';
                    filterSummary.className = 'alert alert-info alert-dismissible fade show mt-2';
                    filterSummary.innerHTML = '<i class="bi bi-info-circle me-2"></i><span id="filterSummaryText"></span>';
                    document.querySelector('.filter-section').appendChild(filterSummary);
                }
                
                document.getElementById('filterSummaryText').textContent = summary;
                filterSummary.style.display = 'block';
            } else {
                const filterSummary = document.getElementById('filterSummary');
                if (filterSummary) {
                    filterSummary.style.display = 'none';
                }
            }
        }
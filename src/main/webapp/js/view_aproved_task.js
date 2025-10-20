      document.getElementById('pageSize').addEventListener('change', function() {
        const form = document.getElementById('filterForm');
        const pageSizeInput = form.querySelector('input[name="pageSize"]');
        const pageInput = form.querySelector('input[name="page"]');
        
        pageSizeInput.value = this.value;
        pageInput.value = 1; 
        form.submit();
      });

      function clearFilters() {
        document.getElementById('phoneFilter').value = '';
        document.getElementById('fromDate').value = '';
        document.getElementById('toDate').value = '';
        document.getElementById('customerFilter').value = '';
        
        const form = document.getElementById('filterForm');
        form.querySelector('input[name="page"]').value = 1;
        form.submit();

      }

      function goToPage(page) {
        const form = document.getElementById('filterForm');
        form.querySelector('input[name="page"]').value = page;
        form.querySelector('input[name="action"]').value = 'filter';
        form.submit();
      }

      document.addEventListener('DOMContentLoaded', function() {
        initializeTaskSelection();
        initializeDateFilters();
        initializePagination();
      });
      
      function initializePagination() {
        const paginationLinks = document.querySelectorAll('.pagination-link');
        paginationLinks.forEach(link => {
          link.addEventListener('click', function(e) {
            e.preventDefault();
            
            if (this.hasAttribute('data-disabled') || this.hasAttribute('data-current')) {
              return false;
            }
            
            const page = this.getAttribute('data-page');
            if (page) {
              goToPage(page);
            }
          });
        });
      }
      
      function initializeDateFilters() {
        const fromDate = document.getElementById('fromDate');
        const toDate = document.getElementById('toDate');
        
        const today = new Date().toISOString().split('T')[0];
        fromDate.setAttribute('max', today);
        toDate.setAttribute('max', today);
        
        fromDate.addEventListener('change', function() {
          validateDateRange();
        });
        
        toDate.addEventListener('change', function() {
          validateDateRange();
        });
      }
      
      function validateDateRange() {
        const fromDate = document.getElementById('fromDate');
        const toDate = document.getElementById('toDate');
        
        if (fromDate.value && toDate.value) {
          const from = new Date(fromDate.value);
          const to = new Date(toDate.value);
          
          if (from > to) {
            toDate.setCustomValidity('To Date must be after From Date');
            toDate.reportValidity();
            return false;
          } else {
            toDate.setCustomValidity('');
          }
          
          toDate.setAttribute('min', fromDate.value);
          fromDate.setAttribute('max', toDate.value);
        } else {
          toDate.setCustomValidity('');
          const today = new Date().toISOString().split('T')[0];
          fromDate.setAttribute('max', today);
          toDate.removeAttribute('min');
        }
        return true;
      }

      let selectedTasks = new Set();

      function initializeTaskSelection() {
        const checkboxes = document.querySelectorAll('.request-checkbox');
        checkboxes.forEach(checkbox => {
          checkbox.addEventListener('change', function(event) {
            const taskId = this.value;
            const row = this.closest('tr');
            
            if (this.checked) {
              selectedTasks.add(taskId);
              row.classList.add('table-success');
              addTaskToSelectedList(taskId, row);
            } else {
              selectedTasks.delete(taskId);
              row.classList.remove('table-success');
              removeTaskFromSelectedList(taskId);
            }
            
            updateSelectedCount();
            toggleSelectedTasksDisplay();
          });
        });

        const quickAssignBtn = document.getElementById('quickAssignBtn');
        if (quickAssignBtn) {
          quickAssignBtn.addEventListener('click', function() {
            if (selectedTasks.size > 0) {
              assignSelectedTasks();
            }
          });
        }
      }

      function addTaskToSelectedList(taskId, row) {
        const selectedTasksDisplay = document.getElementById('selectedTasksDisplay');
        const template = document.getElementById('selectedTaskTemplate');
        const clone = template.content.cloneNode(true);

        const cells = row.querySelectorAll('td');
        const requestDesc = cells[1].querySelector('.fw-bold') ? cells[1].querySelector('.fw-bold').textContent.trim() : '';
        const note = cells[1].querySelector('.text-muted') ? cells[1].querySelector('.text-muted').textContent.trim() : '';
        const customerName = cells[2].querySelector('.fw-semibold') ? cells[2].querySelector('.fw-semibold').textContent.trim() : '';
        const phone = cells[2].querySelector('.text-muted') ? cells[2].querySelector('.text-muted').textContent.trim() : '';
        const date = cells[3].querySelector('small') ? cells[3].querySelector('small').textContent.trim() : '';
        const status = cells[4].querySelector('.badge') ? cells[4].querySelector('.badge').textContent.trim() : '';

        const itemRoot = clone.querySelector('[data-task-id]');
        if (itemRoot) itemRoot.setAttribute('data-task-id', taskId);
        const idEl = clone.querySelector('.selected-task-id');
        if (idEl) idEl.textContent = taskId;
        const descEl = clone.querySelector('.selected-task-desc');
        if (descEl) descEl.textContent = requestDesc || 'Service Request';
        const noteEl = clone.querySelector('.selected-task-note');
        if (noteEl) noteEl.textContent = note || '';
        const custEl = clone.querySelector('.selected-task-customer');
        if (custEl) custEl.textContent = customerName || '';
        const phoneEl = clone.querySelector('.selected-task-phone');
        if (phoneEl) phoneEl.textContent = phone || '';
        const dateEl = clone.querySelector('.selected-task-date');
        if (dateEl) dateEl.textContent = date || '';
        const statusEl = clone.querySelector('.selected-task-status');
        if (statusEl) statusEl.textContent = status || '';

        const viewBtn = clone.querySelector('.selected-task-view');
        if (viewBtn) {
          viewBtn.addEventListener('click', function() {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/task/detail';
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'id';
            input.value = taskId;
            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
          });
        }

        const removeBtn = clone.querySelector('.selected-task-remove');
        if (removeBtn) {
          removeBtn.addEventListener('click', function() {
            removeTaskFromSelection(taskId);
          });
        }

        selectedTasksDisplay.appendChild(clone);
      }

      function removeTaskFromSelectedList(taskId) {
        const taskItem = document.querySelector(`[data-task-id="${taskId}"]`);
        if (taskItem) {
          taskItem.remove();
        }
      }

      function removeTaskFromSelection(taskId) {
        selectedTasks.delete(taskId);
        
        const checkbox = document.querySelector(`input[value="${taskId}"]`);
        if (checkbox) {
          checkbox.checked = false;
          checkbox.closest('tr').classList.remove('table-success');
        }
        
        removeTaskFromSelectedList(taskId);
        updateSelectedCount();
        updateSelectAllCheckbox();
        toggleSelectedTasksDisplay();
      }

      function updateSelectedCount() {
        const count = selectedTasks.size;
        
        document.getElementById('selectedRequestsCount').textContent = count;
        document.getElementById('quickAssignCount').textContent = count;
        
        const selectedCountBadges = document.querySelectorAll('#selectedCountBadge');
        selectedCountBadges.forEach(badge => {
          badge.textContent = count + ' selected';
        });

        const quickAssignBtn = document.getElementById('quickAssignBtn');
        if (quickAssignBtn) {
          quickAssignBtn.disabled = count === 0;
        }
      }

      function toggleSelectedTasksDisplay() {
        const emptyState = document.getElementById('emptyState');
        const selectedTasksContainer = document.getElementById('selectedTasksContainer');
        const assignmentActions = document.getElementById('assignmentActions');
        
        if (selectedTasks.size > 0) {
          emptyState.style.display = 'none';
          selectedTasksContainer.style.display = 'block';
          if (assignmentActions) {
            assignmentActions.style.display = 'block';
          }
        } else {
          emptyState.style.display = 'block';
          selectedTasksContainer.style.display = 'none';
          if (assignmentActions) {
            assignmentActions.style.display = 'none';
          }
        }
      }

      function clearAllSelections() {
        selectedTasks.clear();
        
        document.querySelectorAll('.request-checkbox').forEach(checkbox => {
          checkbox.checked = false;
          checkbox.closest('tr').classList.remove('table-success');
        });
        
        const selectedTasksDisplay = document.getElementById('selectedTasksDisplay');
        selectedTasksDisplay.innerHTML = '';
        
        updateSelectedCount();
        toggleSelectedTasksDisplay();
      }

      function assignSelectedTasks() {
        if (selectedTasks.size === 0) {
          alert('Please select at least one task to assign.');
          return;
        }
        
        const taskCount = selectedTasks.size;
        if (confirm(`Are you sure you want to assign ${taskCount} task(s) to a technician?`)) {
          const form = document.createElement('form');
          form.method = 'POST';
          form.action = '${pageContext.request.contextPath}/task/selectTechnician';
          
          Array.from(selectedTasks).forEach(taskId => {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'selectedTasks';
            input.value = taskId;
            form.appendChild(input);
          });
          
          document.body.appendChild(form);
          form.submit();
        }

      }

      
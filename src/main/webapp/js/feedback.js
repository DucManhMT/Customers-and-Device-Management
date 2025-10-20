 function toggleCustomInput() {
            const feedbackType = document.getElementById('feedbackType').value;
            const customDiv = document.getElementById('customContentDiv');
            const customInput = document.getElementById('customContent');
            
            if (feedbackType === 'other') {
                customDiv.style.display = 'block';
                customInput.required = true;
            } else {
                customDiv.style.display = 'none';
                customInput.required = false;
                customInput.value = '';
            }
        }

        const starInputs = document.querySelectorAll('input[name="rating"]');
        const ratingText = document.getElementById('ratingText');
        
        const ratingTexts = {
            5: { text: 'Excellent - Perfect service!', class: 'text-success' },
            4: { text: 'Good - Quality service', class: 'text-primary' },
            3: { text: 'Average - Acceptable service', class: 'text-warning' },
            2: { text: 'Poor - Needs improvement', class: 'text-danger' },
            1: { text: 'Very Poor - Unsatisfied', class: 'text-danger' }
        };
        
        starInputs.forEach(input => {
            input.addEventListener('change', function() {
                const rating = parseInt(this.value);
                const ratingInfo = ratingTexts[rating];
                
                ratingText.textContent = ratingInfo.text;
                ratingText.className = ratingInfo.class;
            });
        });

        const responseTextarea = document.getElementById('response');
        const charCount = document.getElementById('charCount');
        
        responseTextarea.addEventListener('input', function() {
            const currentLength = this.value.length;
            charCount.textContent = currentLength;
            
            charCount.classList.remove('warning', 'danger');
            
            if (currentLength > 450) {
                charCount.classList.add('danger');
            } else if (currentLength > 400) {
                charCount.classList.add('warning');
            }
        });

        document.querySelector('button[type="reset"]').addEventListener('click', function() {
            ratingText.textContent = 'Please select rating';
            ratingText.className = 'text-muted';
            charCount.textContent = '0';
            charCount.classList.remove('warning', 'danger');
            toggleCustomInput();
        });
        
        function changePageSize() {
            const recordsPerPage = document.getElementById('recordsPerPage').value;
            const currentPage = 1;
            window.location.href = `?page=${currentPage}&recordsPerPage=${recordsPerPage}`;
        }
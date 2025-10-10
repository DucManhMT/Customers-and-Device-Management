<%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 10/6/2025
  Time: 9:43 PM
  To change this template use File | Settings | File Templates.
--%>


<%--Nghiêm cấm tự ý sửa components của người khác--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div style="justify-self: flex-end;margin-left: auto">
    <button type="submit" class="btn btn-primary">Search</button>
    <button type="button" class="btn btn-danger" onclick="resetFilters(event, this)">Reset</button>
    <script>
        function resetFilters(e, btn) {
            if (e) e.preventDefault();

            var form = btn ? btn.closest('form') : document.querySelector('form');
            if (form) {
                // Reset form fields
                form.reset();


                // Get the form action URL
                var action = form.getAttribute('action') || window.location.pathname;
                var baseUrl;
                try {
                    var resolved = new URL(action, window.location.href);
                    baseUrl = resolved.origin + resolved.pathname; // remove query parameters
                } catch (err) {
                    baseUrl = action; // fallback if URL constructor fails
                }

                window.location.href = baseUrl;
            } else {
                // Fallback: reload the page without query parameters
                window.location.href = window.location.origin + window.location.pathname;
            }
        }
    </script>
</div>
<%--
  Created by IntelliJ IDEA.
  User: anhtu
  Date: 10/6/2025
  Time: 9:47 PM
  To change this template use File | Settings | File Templates.
--%>


<%--Nghiêm cấm tự ý sửa components của người khác--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="d-flex align-items-center gap-3"><label for="status">Filter by Status:</label>
    <select id="status" name="status" class="form-select" style="width: 200px; display: inline-block;">
        <option value="">All</option>
        <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
        <option value="Approved" ${status == 'Approved' ? 'selected' : ''}>Approved</option>
        <option value="Processing" ${status == 'Processing' ? 'selected' : ''}>Processing</option>
        <option value="Rejected" ${status == 'Rejected' ? 'selected' : ''}>Rejected</option>
        <option value="Tech_Finished" ${status == 'Tech_Finished' ? 'selected' : ''}>Tech Finished</option>
        <option value="Finished" ${status == 'Finished' ? 'selected' : ''}>Finished</option>
    </select>
</div>

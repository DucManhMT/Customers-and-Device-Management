<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 10/7/2025
  Time: 2:45 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<header class="bg-white border-bottom">
    <div class="container d-flex align-items-center gap-3 py-2">
        <button type="button"
                class="btn btn-light d-inline-flex align-items-center gap-2"
                onclick="if(history.length>1){history.back()}else{location.href='${pageContext.request.contextPath}/index.jsp'}"
                title="Go back">
            <span aria-hidden="true">←</span>
            <span>Back</span>
        </button>

        <a href="${pageContext.request.contextPath}/index.jsp"
           class="text-dark fw-semibold fs-5 text-decoration-none ms-1">
            CRM
        </a>

        <nav class="ms-auto d-flex align-items-center gap-3" aria-label="Primary">
            <span class="d-inline-flex align-items-center gap-1 text-muted small">
                <span>Signed in as:</span>
                <strong class="text-dark">
                    ${empty sessionScope.account ? 'Guest' : sessionScope.account.username}
                </strong>
            </span>
        </nav>
    </div>
</header>

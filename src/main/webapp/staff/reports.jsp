<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý báo cáo - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/staff/css/staff.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <jsp:include page="/staff/includes/navbar.jsp" />
    

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}
                </div>
            </c:if>
<!-- PowerBI Dashboard (tùy chọn) -->
            <div class="card staff-card mt-4">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0"><i class="fas fa-chart-pie me-2"></i>Dashboard PowerBI</h5>
                </div>
                <div class="card-body">
                    <div class="powerbi-dashboard-container text-center">
<iframe title="test" width="1140" height="541.25" src="https://app.powerbi.com/reportEmbed?reportId=57d1ccf9-1ad0-4b8b-a2a4-9209a90ea36f&autoAuth=true&ctid=e7572e92-7aee-4713-a3c4-ba64888ad45f" frameborder="0" allowFullScreen="true"></iframe>           
            
            
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
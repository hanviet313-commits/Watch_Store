<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lỗi hệ thống - WatchStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="alert alert-danger text-center">
        <h2>Đã xảy ra lỗi!</h2>
        <p>Xin lỗi, hệ thống gặp sự cố hoặc bạn không có quyền truy cập chức năng này.</p>
        <% String err = (String) request.getAttribute("errorMessage"); if (err != null) { %>
            <div class="alert alert-warning mt-3">Chi tiết lỗi: <%= err %></div>
        <% } %>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary mt-3">Về trang chủ</a>
    </div>
</div>
</body>
</html> 
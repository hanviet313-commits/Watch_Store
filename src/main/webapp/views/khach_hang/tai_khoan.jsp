<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.watchstore.model.NguoiDung" %>
<%
    NguoiDung user = (NguoiDung) request.getAttribute("user");
    String msg = (String) request.getAttribute("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý tài khoản</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/main-style.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/views/includes/navbar.jsp"/>
<div class="container mt-4">
    <h2>Quản lý tài khoản</h2>
    <% if (msg != null) { %>
        <div class="alert alert-success"><%= msg %></div>
    <% } %>
    <form method="post" action="${pageContext.request.contextPath}/tai-khoan">
        <div class="mb-3">
            <label class="form-label">Họ và tên</label>
            <input type="text" class="form-control" name="tenDayDu" value="<%= user.getTenDayDu() %>" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" class="form-control" value="<%= user.getEmail() %>" readonly>
        </div>
        <div class="mb-3">
            <label class="form-label">Số điện thoại</label>
            <input type="text" class="form-control" name="sdt" value="<%= user.getSdt() %>" required>
        </div>
        <button type="submit" class="btn btn-primary">Cập nhật</button>
    </form>
    <a href="${pageContext.request.contextPath}/doi-mat-khau" class="btn btn-warning mt-2">
        <i class="bi bi-key"></i> Đổi mật khẩu
    </a>
</div>
</body>
</html> 
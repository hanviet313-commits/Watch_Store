<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập - WatchStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f8f9fa; }
        .login-container { max-width: 400px; margin: 60px auto; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="/WatchStore/">WatchStore</a>
    </div>
</nav>
<div class="login-container bg-white p-4 rounded shadow">
    <h2 class="mb-4 text-center">Đăng nhập</h2>
    <% String error = (String) request.getAttribute("error"); if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>
    <form action="${pageContext.request.contextPath}/dang-nhap" method="post">
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" name="email" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Mật khẩu</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
    </form>
    <div class="mt-3 text-center">
        <span>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/dang-ky">Đăng ký</a></span>
    </div>
</div>
<footer class="bg-dark text-white text-center py-3 mt-5">
    &copy; 2025 WatchStore. All rights reserved.
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
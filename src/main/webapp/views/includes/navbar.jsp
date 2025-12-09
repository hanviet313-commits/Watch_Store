<%-- 
    Document   : navbar
    Created on : May 15, 2024, 7:59:16 AM
    Author     : trananh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.watchstore.model.ThongBao" %>
<%
    Object userLogin = session.getAttribute("nguoiDung");
    List<ThongBao> thongBaoList = (List<ThongBao>) request.getAttribute("thongBaoList");
    boolean hasThongBao = thongBaoList != null && !thongBaoList.isEmpty();
    String uri = request.getRequestURI();
%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
    .navbar {
        padding: 15px 0 !important;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08) !important;
        background: #fff !important;
        border-radius: 0 0 12px 12px !important;
    }
    .navbar-brand {
        font-family: 'Quicksand', sans-serif !important;
        font-size: 2.2rem !important;
        font-weight: 800 !important;
        letter-spacing: -0.5px !important;
        color: #d0021b !important;
    }
    .nav-link {
        font-weight: 600 !important;
        font-size: 1.08rem !important;
        padding: 8px 16px !important;
        border-radius: 8px !important;
        color: #222 !important;
        transition: all 0.3s !important;
        background: none !important;
    }
    .nav-link.active, .nav-link:focus, .nav-link:active {
        background: #d0021b !important;
        color: #fff !important;
    }
    .nav-link:hover {
        background-color: rgba(208,2,27,0.08) !important;
        color: #d0021b !important;
    }
    .navbar-nav {
        gap: 2px;
    }
    .notification-icon {
        position: relative;
        cursor: pointer;
    }
    .notification-dot {
        position: absolute;
        top: 10px;
        right: 10px;
        width: 8px;
        height: 8px;
        background-color: red;
        border-radius: 50%;
        display: none;
    }
    .notification-dot.active {
        display: block;
    }
    .notification-dropdown {
        position: absolute;
        top: 50px;
        right: 0;
        width: 350px;
        max-height: 400px;
        overflow-y: auto;
        background-color: #f9f9f9;
        border: 1px solid #ddd;
        border-radius: 5px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        display: none;
        z-index: 1030;
    }
    .notification-dropdown-header {
        padding: 10px 15px;
        font-weight: bold;
        border-bottom: 1px solid #ddd;
        background-color: #fff;
    }
    .notification-item {
        display: flex;
        padding: 10px 15px;
        border-bottom: 1px solid #eee;
        text-decoration: none;
        color: #333;
    }
    .notification-item:last-child {
        border-bottom: none;
    }
    .notification-item:hover {
        background-color: #f1f1f1;
    }
    .notification-item-content {
        flex-grow: 1;
    }
    .notification-item-title {
        font-weight: bold;
    }
    .notification-item-body {
        font-size: 0.9em;
        color: #555;
    }
     .notification-item-body, .notification-item-title {
        white-space: normal;
        word-wrap: break-word;
    }
</style>

<nav class="navbar navbar-expand-lg navbar-light bg-white">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">WatchStore</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item dropdown">
                    <a class="nav-link notification-icon" href="#" id="notificationBell" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-bell fs-5"></i>
                        <span class="notification-dot<%= hasThongBao ? " active" : "" %>"></span>
                    </a>
                    <ul class="dropdown-menu notification-dropdown" aria-labelledby="notificationBell" style="width:350px;">
                        <li class="notification-dropdown-header px-3 py-2">Thông báo</li>
                        <% if (hasThongBao) { 
                            for (ThongBao tb : thongBaoList) { %>
                                <li class="notification-item px-3 py-2">
                                    <div class="notification-item-content">
                                        <div class="notification-item-title"><%= tb.getTieuDe() %></div>
                                        <div class="notification-item-body"><%= tb.getNoiDung() %></div>
                                    </div>
                                </li>
                        <%   } 
                           } else { %>
                            <li class="notification-item-body p-3">Không có thông báo mới.</li>
                        <% } %>
                    </ul>
                </li>
                <% if (userLogin == null) { %>
                <li class="nav-item"><a class="nav-link<%= uri.endsWith("/gio-hang") ? " active" : "" %>" href="${pageContext.request.contextPath}/gio-hang">Giỏ hàng</a></li>
                <li class="nav-item"><a class="nav-link<%= uri.endsWith("/dang-nhap") ? " active" : "" %>" href="${pageContext.request.contextPath}/dang-nhap">Đăng nhập</a></li>
                <li class="nav-item"><a class="nav-link<%= uri.endsWith("/dang-ky") ? " active" : "" %>" href="${pageContext.request.contextPath}/dang-ky">Đăng ký</a></li>
                <% } else { %>
                <li class="nav-item"><a class="nav-link<%= uri.endsWith("/tai-khoan") ? " active" : "" %>" href="${pageContext.request.contextPath}/tai-khoan">Tài khoản</a></li>
                <li class="nav-item"><a class="nav-link<%= uri.endsWith("/don-hang") ? " active" : "" %>" href="${pageContext.request.contextPath}/don-hang">Đơn hàng</a></li>
                <li class="nav-item"><a class="nav-link<%= uri.endsWith("/gio-hang") ? " active" : "" %>" href="${pageContext.request.contextPath}/gio-hang">Giỏ hàng</a></li>
                <li class="nav-item"><a class="nav-link<%= uri.endsWith("/doi-mat-khau") ? " active" : "" %>" href="${pageContext.request.contextPath}/doi-mat-khau">Đổi mật khẩu</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/dang-xuat">Đăng xuất</a></li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<script>
// Hiển thị dropdown khi click chuông (không cần fetch API)
document.addEventListener('DOMContentLoaded', function () {
    const bell = document.getElementById('notificationBell');
    const dropdown = document.querySelector('.notification-dropdown');
    bell.addEventListener('click', function (e) {
        e.preventDefault();
        dropdown.style.display = (dropdown.style.display === 'block') ? 'none' : 'block';
    });
    window.addEventListener('click', function (e) {
        if (!bell.contains(e.target) && !dropdown.contains(e.target)) {
            dropdown.style.display = 'none';
        }
    });
});
</script>


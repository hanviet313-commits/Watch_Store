<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
.sidebar .list-group-item {
    border: none !important;
}
</style>

<div class="sidebar bg-dark text-white" style="min-height: 100vh; width: 250px;">
    <div class="p-3">
        <h4 class="text-center mb-4">Staff Dashboard</h4>
        <div class="list-group">
            <a href="${pageContext.request.contextPath}/staff/dashboard" 
               class="list-group-item list-group-item-action bg-dark text-white ${(pageContext.request.servletPath == '/staff/dashboard.jsp' || pageContext.request.servletPath == '/staff/dashboard') ? 'active' : ''}">
                <i class="fas fa-tachometer-alt me-2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/staff/orders" 
               class="list-group-item list-group-item-action bg-dark text-white ${(pageContext.request.servletPath == '/staff/orders.jsp' || pageContext.request.servletPath == '/staff/orders') ? 'active' : ''}">
                <i class="fas fa-shopping-cart me-2"></i> Quản lý đơn hàng
            </a>
            <a href="${pageContext.request.contextPath}/staff/products" 
               class="list-group-item list-group-item-action bg-dark text-white ${(pageContext.request.servletPath == '/staff/products.jsp' || pageContext.request.servletPath == '/staff/products') ? 'active' : ''}">
                <i class="fas fa-box me-2"></i> Quản lý sản phẩm
            </a>
            <a href="${pageContext.request.contextPath}/staff/notifications" 
               class="list-group-item list-group-item-action bg-dark text-white ${(pageContext.request.servletPath == '/staff/notifications.jsp' || pageContext.request.servletPath == '/staff/notifications') ? 'active' : ''}">
                <i class="fas fa-bell me-2"></i> Quản lý thông báo
            </a>
            <a href="${pageContext.request.contextPath}/staff/complaints" 
               class="list-group-item list-group-item-action bg-dark text-white ${(pageContext.request.servletPath == '/staff/complaints.jsp' || pageContext.request.servletPath == '/staff/complaints') ? 'active' : ''}">
                <i class="fas fa-exclamation-circle me-2"></i> Khiếu nại
            </a>
            <a href="${pageContext.request.contextPath}/staff/reports" 
               class="list-group-item list-group-item-action bg-dark text-white ${(pageContext.request.servletPath == '/staff/reports.jsp' || pageContext.request.servletPath == '/staff/reports') ? 'active' : ''}">
                <i class="fas fa-chart-bar me-2"></i> Báo cáo
            </a>
            <a href="${pageContext.request.contextPath}/nv/quan-ly-danh-gia" 
               class="list-group-item list-group-item-action bg-dark text-white ${(pageContext.request.servletPath == '/nv/quan-ly-danh-gia') ? 'active' : ''}">
                <i class="fas fa-star me-2"></i> Quản lý đánh giá
            </a>
            <a href="${pageContext.request.contextPath}/doi-mat-khau" 
               class="list-group-item list-group-item-action bg-dark text-white ${(pageContext.request.servletPath == '/doi-mat-khau.jsp' || pageContext.request.servletPath == '/doi-mat-khau') ? 'active' : ''}">
                <i class="fas fa-key me-2"></i> Đổi mật khẩu
            </a>
            <a href="${pageContext.request.contextPath}/dang-xuat" 
               class="list-group-item list-group-item-action bg-dark text-white">
                <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
            </a>
        </div>
    </div>
</div> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="sidebar bg-dark text-white" style="min-height: 100vh; width: 250px;">
    <div class="p-3">
        <h4 class="text-center mb-4">Admin Dashboard</h4>
        <div class="list-group">
            <a href="${pageContext.request.contextPath}/admin/dashboard" 
               class="list-group-item list-group-item-action bg-dark text-white ${pageContext.request.servletPath == '/admin/dashboard.jsp' ? 'active' : ''}">
                <i class="fas fa-tachometer-alt me-2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/admin/quan-ly-nguoi-dung" 
               class="list-group-item list-group-item-action bg-dark text-white ${pageContext.request.servletPath == '/admin/danh_sach_nguoi_dung.jsp' ? 'active' : ''}">
                <i class="fas fa-users me-2"></i> Quản lý người dùng
            </a>
            <a href="${pageContext.request.contextPath}/admin/phan-quyen" 
               class="list-group-item list-group-item-action bg-dark text-white ${pageContext.request.servletPath == '/admin/phan-quyen' ? 'active' : ''}">
                <i class="fas fa-user-shield me-2"></i> Phân quyền
            </a>
           
            <a href="${pageContext.request.contextPath}/dang-xuat" 
               class="list-group-item list-group-item-action bg-dark text-white">
                <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
            </a>
        </div>
    </div>
</div>
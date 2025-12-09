<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">
      <i class="fas fa-user-shield me-2"></i>Admin Dashboard
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbar" aria-controls="adminNavbar" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="adminNavbar">
      <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/quan-ly-nguoi-dung">Quản lý người dùng</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/phan-quyen">Phân quyền</a></li>

        <li class="nav-item"><a class="nav-link text-danger" href="${pageContext.request.contextPath}/dang-xuat"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
      </ul>
    </div>
  </div>
</nav>

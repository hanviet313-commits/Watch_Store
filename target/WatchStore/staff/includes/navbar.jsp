<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/staff/dashboard">
      <i class="fas fa-user-cog me-2"></i>Staff Dashboard
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#staffNavbar" aria-controls="staffNavbar" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="staffNavbar">
      <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/dashboard">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/orders">Quản lý đơn hàng</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/products">Quản lý sản phẩm</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/notifications">Quản lý thông báo</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/nv/quan-ly-danh-gia">Quản lý đánh giá</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/complaints">Khiếu nại</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/reports">Báo cáo</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/doi-mat-khau"><i class="fas fa-key"></i> Đổi mật khẩu</a></li>
        <li class="nav-item"><a class="nav-link text-danger" href="${pageContext.request.contextPath}/dang-xuat"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
      </ul>
    </div>
  </div>
</nav> 
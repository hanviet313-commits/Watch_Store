<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - WatchStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .admin-content {
            display: flex;
        }
        .admin-main {
            flex: 1;
            padding: 20px;
        }
        .dashboard-card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .card-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        .card-title {
            font-size: 1.1rem;
            font-weight: 600;
        }
        .card-value {
            font-size: 2rem;
            font-weight: 700;
        }
        .recent-users-table th, .recent-users-table td {
            padding: 12px 15px;
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <jsp:include page="/admin/includes/navbar.jsp" />
    
    <div class="admin-content">
        <jsp:include page="/admin/includes/sidebar.jsp" />
        
        <div class="admin-main">
            <h2 class="mb-4">Dashboard</h2>
            
            <div class="row">
                <div class="col-md-3">
                    <div class="card dashboard-card bg-primary text-white">
                        <div class="card-body text-center">
                            <div class="card-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="card-title">Tổng người dùng</div>
                            <div class="card-value">${totalUsers}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card dashboard-card bg-success text-white">
                        <div class="card-body text-center">
                            <div class="card-icon">
                                <i class="fas fa-user-tie"></i>
                            </div>
                            <div class="card-title">Nhân viên</div>
                            <div class="card-value">${totalStaff}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card dashboard-card bg-info text-white">
                        <div class="card-body text-center">
                            <div class="card-icon">
                                <i class="fas fa-user-tag"></i>
                            </div>
                            <div class="card-title">Khách hàng</div>
                            <div class="card-value">${totalCustomers}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card dashboard-card bg-danger text-white">
                        <div class="card-body text-center">
                            <div class="card-icon">
                                <i class="fas fa-user-lock"></i>
                            </div>
                            <div class="card-title">Tài khoản bị khóa</div>
                            <div class="card-value">
                                <c:out value="${totalDisabledUsers}" default="0" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Recent Users -->
            <div class="card admin-card mb-4">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0">Người dùng mới đăng ký</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table recent-users-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>Vai trò</th>
                                    <th>Ngày đăng ký</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentUsers}" var="user">
                                    <tr>
                                        <td>${user.idNguoiDung}</td>
                                        <td>${user.tenDayDu}</td>
                                        <td>${user.email}</td>
                                        <td>${user.vaiTro}</td>
                                        <td>${user.ngayTao}</td>
                                        <td>
                                            <span class="status-badge ${user.trangThai == 1 ? 'status-completed' : 'status-cancelled'}">
                                                ${user.trangThai == 1 ? 'Hoạt động' : 'Bị khóa'}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/quan-ly-nguoi-dung?id=${user.idNguoiDung}" 
                                               class="btn btn-sm btn-primary">Chi tiết</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- System Activity -->
            <div class="card admin-card">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0">Hoạt động hệ thống</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table admin-table">
                            <thead>
                                <tr>
                                    <th>Thời gian</th>
                                    <th>Người dùng</th>
                                    <th>Hoạt động</th>
                                    <th>Chi tiết</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${systemActivities}" var="activity">
                                    <tr>
                                        <td>${activity.thoiGian}</td>
                                        <td>${activity.nguoiDung}</td>
                                        <td>${activity.hoatDong}</td>
                                        <td>${activity.chiTiet}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



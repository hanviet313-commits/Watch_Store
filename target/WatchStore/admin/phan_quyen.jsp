<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phân quyền - Admin Dashboard</title>
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
        .admin-card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .admin-table th, .admin-table td {
            padding: 12px 15px;
            vertical-align: middle;
        }
        .role-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        .role-admin {
            background-color: #cce5ff;
            color: #004085;
        }
        .role-staff {
            background-color: #d4edda;
            color: #155724;
        }
        .role-customer {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <jsp:include page="/admin/includes/navbar.jsp" />
    
    <div class="admin-content">
        <jsp:include page="/admin/includes/sidebar.jsp" />
        
        <div class="admin-main">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Phân quyền người dùng</h2>
            </div>
            
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <div class="card admin-card">
                <div class="card-header bg-dark text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Danh sách người dùng và vai trò</h5>
                        <div class="input-group" style="width: 300px;">
                            <input type="text" class="form-control" placeholder="Tìm kiếm..." id="searchInput">
                            <button class="btn btn-outline-light" type="button" id="searchButton">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table admin-table" id="usersTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>Vai trò hiện tại</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${users}" var="user">
                                    <tr>
                                        <td>${user.idNguoiDung}</td>
                                        <td>${user.tenDayDu}</td>
                                        <td>${user.email}</td>
                                        <td>
                                            <span class="role-badge 
                                                ${user.vaiTro == 'admin' ? 'role-admin' : 
                                                  user.vaiTro == 'staff' ? 'role-staff' : 'role-customer'}">
                                                ${user.vaiTro}
                                            </span>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-primary" 
                                                    onclick="changeRole(${user.idNguoiDung}, '${user.vaiTro}')">
                                                <i class="fas fa-user-tag"></i> Đổi vai trò
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <div class="card admin-card mt-4">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0">Quản lý quyền hạn</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="card mb-3">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0">Admin</h5>
                                </div>
                                <div class="card-body">
                                    <ul class="list-group">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Quản lý người dùng
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Phân quyền
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Quản lý sản phẩm
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Quản lý đơn hàng
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Quản lý khiếu nại
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Xem báo cáo
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Cấu hình hệ thống
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card mb-3">
                                <div class="card-header bg-success text-white">
                                    <h5 class="mb-0">Nhân viên</h5>
                                </div>
                                <div class="card-body">
                                    <ul class="list-group">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Quản lý người dùng
                                            <span class="badge bg-danger rounded-pill"><i class="fas fa-times"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Phân quyền
                                            <span class="badge bg-danger rounded-pill"><i class="fas fa-times"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Quản lý sản phẩm
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Quản lý đơn hàng
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Quản lý khiếu nại
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Xem báo cáo
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Cấu hình hệ thống
                                            <span class="badge bg-danger rounded-pill"><i class="fas fa-times"></i></span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card mb-3">
                                <div class="card-header bg-danger text-white">
                                    <h5 class="mb-0">Khách hàng</h5>
                                </div>
                                <div class="card-body">
                                    <ul class="list-group">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Xem sản phẩm
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Đặt hàng
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Xem lịch sử đơn hàng
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Đánh giá sản phẩm
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Gửi khiếu nại
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Quản lý tài khoản cá nhân
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check"></i></span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal Đổi vai trò -->
    <div class="modal fade" id="changeRoleModal" tabindex="-1" aria-labelledby="changeRoleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="changeRoleModalLabel">Đổi vai trò người dùng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/phan-quyen" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="roleIdNguoiDung" name="idNguoiDung">
                        <div class="mb-3">
                            <label for="currentRole" class="form-label">Vai trò hiện tại</label>
                            <input type="text" class="form-control" id="currentRole" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="newRole" class="form-label">Vai trò mới</label>
                            <select class="form-select" id="newRole" name="vaiTro" required>
                                <option value="customer">Khách hàng</option>
                                <option value="staff">Nhân viên</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Tìm kiếm người dùng
        document.getElementById('searchButton').addEventListener('click', function() {
            const searchValue = document.getElementById('searchInput').value.toLowerCase();
            const table = document.getElementById('usersTable');
            const rows = table.getElementsByTagName('tr');
            
            for (let i = 1; i < rows.length; i++) {
                const cells = rows[i].getElementsByTagName('td');
                let found = false;
                
                for (let j = 0; j < cells.length - 1; j++) {
                    const cellValue = cells[j].textContent.toLowerCase();
                    if (cellValue.includes(searchValue)) {
                        found = true;
                        break;
                    }
                }
                
                rows[i].style.display = found ? '' : 'none';
            }
        });
        
        // Hiển thị modal đổi vai trò
        function changeRole(id, currentRole) {
            document.getElementById('roleIdNguoiDung').value = id;
            document.getElementById('currentRole').value = currentRole;
            document.getElementById('newRole').value = currentRole;
            
            const changeRoleModal = new bootstrap.Modal(document.getElementById('changeRoleModal'));
            changeRoleModal.show();
        }
    </script>
</body>
</html>
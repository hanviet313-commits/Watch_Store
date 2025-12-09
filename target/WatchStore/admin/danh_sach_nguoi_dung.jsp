<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - Admin Dashboard</title>
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
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        .status-active {
            background-color: #c3e6cb;
            color: #155724;
        }
        .status-disabled {
            background-color: #f5c6cb;
            color: #721c24;
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
                <h2>Quản lý người dùng</h2>
                <div>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                        <i class="fas fa-user-plus"></i> Thêm người dùng
                    </button>
                </div>
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
                        <h5 class="mb-0">Danh sách người dùng</h5>
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
                                    <th>Số điện thoại</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${users}" var="user">
                                    <tr>
                                        <td>${user.idNguoiDung}</td>
                                        <td>${user.tenDayDu}</td>
                                        <td>${user.email}</td>
                                        <td>${user.sdt}</td>
                                        <td>
                                            <span class="role-badge 
                                                ${user.vaiTro == 'admin' ? 'role-admin' : 
                                                  user.vaiTro == 'staff' ? 'role-staff' : 'role-customer'}">
                                                ${user.vaiTro}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="status-badge ${user.trangThai == 1 ? 'status-active' : 'status-disabled'}">
                                                ${user.trangThai == 1 ? 'Hoạt động' : 'Bị khóa'}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="btn-group">
                                                <button type="button" class="btn btn-sm btn-primary" 
                                                        onclick="editUser(${user.idNguoiDung})">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <c:if test="${user.trangThai == 1}">
                                                    <button type="button" class="btn btn-sm btn-danger" 
                                                            onclick="lockUser(${user.idNguoiDung})">
                                                        <i class="fas fa-lock"></i>
                                                    </button>
                                                </c:if>
                                                <c:if test="${user.trangThai == 0}">
                                                    <button type="button" class="btn btn-sm btn-success" 
                                                            onclick="unlockUser(${user.idNguoiDung})">
                                                        <i class="fas fa-unlock"></i>
                                                    </button>
                                                </c:if>
                                                <button type="button" class="btn btn-sm btn-info" 
                                                        onclick="changeRole(${user.idNguoiDung})">
                                                    <i class="fas fa-user-tag"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal Thêm người dùng -->
    <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addUserModalLabel">Thêm người dùng mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/quan-ly-nguoi-dung/them" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="tenDayDu" class="form-label">Họ tên</label>
                            <input type="text" class="form-control" id="tenDayDu" name="tenDayDu" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="sdt" class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" id="sdt" name="sdt" required>
                        </div>
                        <div class="mb-3">
                            <label for="matKhau" class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control" id="matKhau" name="matKhau" required>
                        </div>
                        <div class="mb-3">
                            <label for="vaiTro" class="form-label">Vai trò</label>
                            <select class="form-select" id="vaiTro" name="vaiTro" required>
                                <option value="customer">Khách hàng</option>
                                <option value="staff">Nhân viên</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Thêm người dùng</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Modal Sửa người dùng -->
    <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editUserModalLabel">Sửa thông tin người dùng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/quan-ly-nguoi-dung/sua" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="editIdNguoiDung" name="idNguoiDung">
                        <div class="mb-3">
                            <label for="editTenDayDu" class="form-label">Họ tên</label>
                            <input type="text" class="form-control" id="editTenDayDu" name="tenDayDu" required>
                        </div>
                        <div class="mb-3">
                            <label for="editEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="editEmail" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="editSdt" class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" id="editSdt" name="sdt" required>
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
    
    <!-- Modal Đổi vai trò -->
    <div class="modal fade" id="changeRoleModal" tabindex="-1" aria-labelledby="changeRoleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="changeRoleModalLabel">Đổi vai trò người dùng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/quan-ly-nguoi-dung/doi-vai-tro" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="roleIdNguoiDung" name="idNguoiDung">
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
        
        // Hiển thị modal sửa người dùng
        function editUser(id) {
            // Gọi API để lấy thông tin người dùng
            fetch('${pageContext.request.contextPath}/admin/api/nguoi-dung/' + id)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('editIdNguoiDung').value = data.idNguoiDung;
                    document.getElementById('editTenDayDu').value = data.tenDayDu;
                    document.getElementById('editEmail').value = data.email;
                    document.getElementById('editSdt').value = data.sdt;
                    
                    const editUserModal = new bootstrap.Modal(document.getElementById('editUserModal'));
                    editUserModal.show();
                });
        }
        
        // Khóa tài khoản người dùng
        function lockUser(id) {
            if (confirm('Bạn có chắc chắn muốn khóa tài khoản này?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/quan-ly-nguoi-dung/khoa?id=' + id;
            }
        }
        
        // Mở khóa tài khoản người dùng
        function unlockUser(id) {
            if (confirm('Bạn có chắc chắn muốn mở khóa tài khoản này?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/quan-ly-nguoi-dung/mo-khoa?id=' + id;
            }
        }
        
        // Hiển thị modal đổi vai trò
        function changeRole(id) {
            document.getElementById('roleIdNguoiDung').value = id;
            const changeRoleModal = new bootstrap.Modal(document.getElementById('changeRoleModal'));
            changeRoleModal.show();
        }
    </script>
</body>
</html>

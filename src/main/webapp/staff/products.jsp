<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/staff/css/staff.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/staff/includes/navbar.jsp" />
    <div style="display: flex;">
        <jsp:include page="/staff/includes/sidebar.jsp" />
        <div style="flex: 1; padding: 20px;">
            <!-- BẮT ĐẦU NỘI DUNG QUẢN LÝ SẢN PHẨM STAFF -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Quản lý sản phẩm</h2>
                <a href="${pageContext.request.contextPath}/staff/products/add" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Thêm sản phẩm mới
                </a>
            </div>
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <div class="card staff-card">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0">Danh sách sản phẩm</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table staff-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Hình ảnh</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Giá</th>
                                    <th>Tồn kho</th>
                                    <th>Nhà sản xuất</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${products}">
                                    <tr>
                                        <td>${p.idSanPham}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.urlAnh.startsWith('http://') || p.urlAnh.startsWith('https://')}">
                                                    <img src="${p.urlAnh}" alt="${p.tenSanPham}" class="img-thumbnail" style="width: 80px; height: 80px; object-fit: cover;">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/img_Url/${p.urlAnh}" alt="${p.tenSanPham}" class="img-thumbnail" style="width: 80px; height: 80px; object-fit: cover;">
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${p.tenSanPham}</td>
                                        <td>${p.gia}</td>
                                        <td>
                                            <div class="input-group" style="width: 120px;">
                                                <input type="number" class="form-control form-control-sm stock-input" 
                                                       value="${p.soLuongTon}" min="0" data-id="${p.idSanPham}" readonly>
                                            </div>
                                        </td>
                                        <td>${p.nhaSanXuat}</td>
                                        <td>
                                            <div class="btn-group">
                                                <a href="${pageContext.request.contextPath}/staff/products/edit?id=${p.idSanPham}" 
                                                   class="btn btn-warning btn-sm">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <button type="button" class="btn btn-danger btn-sm delete-product" 
                                                        data-id="${p.idSanPham}" data-name="${p.tenSanPham}">
                                                    <i class="fas fa-trash"></i>
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
            <!-- KẾT THÚC NỘI DUNG QUẢN LÝ SẢN PHẨM STAFF -->
        </div>
    </div>

    <!-- Modal xác nhận xóa -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa sản phẩm <span id="productName"></span>?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Xử lý xóa sản phẩm
        document.querySelectorAll('.delete-product').forEach(btn => {
            btn.addEventListener('click', function() {
                const id = this.dataset.id;
                const name = this.dataset.name;
                document.getElementById('productName').textContent = name;
                document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/staff/products/delete?id=' + id;
                new bootstrap.Modal(document.getElementById('deleteModal')).show();
            });
        });

        // Xử lý cập nhật tồn kho
        document.querySelectorAll('.update-stock').forEach(btn => {
            btn.addEventListener('click', function() {
                const id = this.dataset.id;
                const input = document.querySelector(`.stock-input[data-id="${id}"]`);
                const soLuong = input.value;
                
                fetch('${pageContext.request.contextPath}/staff/products/update-stock', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `id=${id}&soLuong=${soLuong}`
                }).then(response => {
                    if (response.ok) {
                        location.reload();
                    }
                });
            });
        });
    </script>
</body>
</html> 
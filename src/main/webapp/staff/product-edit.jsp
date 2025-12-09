<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa sản phẩm - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/staff/css/staff.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/staff/includes/navbar.jsp" />
    
    <div class="container-fluid staff-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Sửa sản phẩm</h2>
                <a href="${pageContext.request.contextPath}/staff/products" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>

            <div class="card staff-card">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0">Thông tin sản phẩm</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/staff/products/edit" method="post" class="needs-validation" novalidate>
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id" value="${sanPham.idSanPham}">
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="tenSanPham" class="form-label">Tên sản phẩm</label>
                                <input type="text" class="form-control" id="tenSanPham" name="tenSanPham" value="${sanPham.tenSanPham}" required>
                                <div class="invalid-feedback">Vui lòng nhập tên sản phẩm</div>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label for="nhaSanXuat" class="form-label">Nhà sản xuất</label>
                                <input type="text" class="form-control" id="nhaSanXuat" name="nhaSanXuat" value="${sanPham.nhaSanXuat}" required>
                                <div class="invalid-feedback">Vui lòng nhập nhà sản xuất</div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="gia" class="form-label">Giá</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" id="gia" name="gia" value="${sanPham.gia}" min="0" step="0.01" required>
                                    <span class="input-group-text">VNĐ</span>
                                </div>
                                <div class="invalid-feedback">Vui lòng nhập giá sản phẩm</div>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label for="soLuongTon" class="form-label">Số lượng tồn kho</label>
                                <input type="number" class="form-control" id="soLuongTon" name="soLuongTon" value="${sanPham.soLuongTon}" min="0" required>
                                <div class="invalid-feedback">Vui lòng nhập số lượng tồn kho</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="urlAnh" class="form-label">URL hình ảnh</label>
                            <input type="text" class="form-control" id="urlAnh" name="urlAnh" value="${sanPham.urlAnh}" required>
                            <div class="invalid-feedback">Vui lòng nhập URL hình ảnh hợp lệ</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Xem trước hình ảnh</label>
                            <div class="text-center">
                                <img src="${pageContext.request.contextPath}/img_Url/${sanPham.urlAnh}" alt="${sanPham.tenSanPham}" class="img-thumbnail" style="max-height: 200px;">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="moTa" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="moTa" name="moTa" rows="4" required>${sanPham.moTa}</textarea>
                            <div class="invalid-feedback">Vui lòng nhập mô tả sản phẩm</div>
                        </div>

                        <div class="text-end">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Lưu thay đổi
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        (function () {
            'use strict'
            var forms = document.querySelectorAll('.needs-validation')
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
        })()

        // Preview image when URL changes
        document.getElementById('urlAnh').addEventListener('change', function() {
            const preview = document.querySelector('.img-thumbnail');
            preview.src = this.value;
        });

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
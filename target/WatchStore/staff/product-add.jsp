<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sản phẩm mới - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/staff/css/staff.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/staff/includes/navbar.jsp" />
    
    <div class="container-fluid staff-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Thêm sản phẩm mới</h2>
                <a href="${pageContext.request.contextPath}/staff/products" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>

            <div class="card staff-card">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0">Thông tin sản phẩm</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/staff/products" method="post" class="needs-validation" novalidate>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="tenSanPham" class="form-label">Tên sản phẩm</label>
                                <input type="text" class="form-control" id="tenSanPham" name="tenSanPham" required>
                                <div class="invalid-feedback">Vui lòng nhập tên sản phẩm</div>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label for="nhaSanXuat" class="form-label">Nhà sản xuất</label>
                                <input type="text" class="form-control" id="nhaSanXuat" name="nhaSanXuat" required>
                                <div class="invalid-feedback">Vui lòng nhập nhà sản xuất</div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="gia" class="form-label">Giá</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" id="gia" name="gia" min="0" step="0.01" required>
                                    <span class="input-group-text">VNĐ</span>
                                </div>
                                <div class="invalid-feedback">Vui lòng nhập giá sản phẩm</div>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label for="soLuongTon" class="form-label">Số lượng tồn kho</label>
                                <input type="number" class="form-control" id="soLuongTon" name="soLuongTon" min="0" required>
                                <div class="invalid-feedback">Vui lòng nhập số lượng tồn kho</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="urlAnh" class="form-label">URL hình ảnh</label>
                            <input type="text" class="form-control" id="urlAnh" name="urlAnh" required>
                            <div class="invalid-feedback" id="urlAnhFeedback">Vui lòng nhập URL hình ảnh hợp lệ (link hoặc tên file .jpg/.png/.gif)</div>
                        </div>

                        <div class="mb-3">
                            <label for="moTa" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="moTa" name="moTa" rows="4" required></textarea>
                            <div class="invalid-feedback">Vui lòng nhập mô tả sản phẩm</div>
                        </div>

                        <div class="text-end">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Thêm sản phẩm
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

        // Validate URL hình ảnh: chấp nhận link http(s) hoặc tên file .jpg/.png/.gif
        const urlAnhInput = document.getElementById('urlAnh');
        const urlAnhFeedback = document.getElementById('urlAnhFeedback');
        if (urlAnhInput) {
            urlAnhInput.addEventListener('input', function() {
                const value = this.value.trim();
                const urlPattern = /^(https?:\/\/).+/i;
                const filePattern = /^([^\/]+)\.(jpg|jpeg|png|gif)$/i;
                if (value === '' || urlPattern.test(value) || filePattern.test(value)) {
                    this.setCustomValidity('');
                    urlAnhFeedback.style.display = 'none';
                } else {
                    this.setCustomValidity('invalid');
                    urlAnhFeedback.style.display = 'block';
                }
            });
        }
    </script>
</body>
</html> 
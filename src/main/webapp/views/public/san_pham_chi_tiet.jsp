<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chi tiết sản phẩm - ${sanPham.tenSanPham}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main-style.css">
    <style>
        :root {
            --main-red: #d0021b;
            --main-dark: #212529;
            --main-gray: #f5f5f7;
            --main-white: #ffffff;
            --main-radius: 12px;
            --main-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }
        
        body {
            background-color: var(--main-gray);
            font-family: 'Quicksand', sans-serif;
        }
        
        .navbar {
            padding: 15px 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            background-color: var(--main-white);
        }
        
        .navbar-brand {
            font-size: 2.2rem;
            font-weight: 800;
            letter-spacing: -0.5px;
        }
        
        .nav-link {
            font-weight: 600;
            padding: 8px 16px !important;
            border-radius: 8px;
            transition: all 0.3s;
        }
        
        .nav-link:hover {
            background-color: rgba(208,2,27,0.08);
            color: var(--main-red) !important;
        }
        
        .product-container {
            background-color: var(--main-white);
            border-radius: var(--main-radius);
            box-shadow: var(--main-shadow);
            padding: 30px;
            margin-top: 30px;
            margin-bottom: 30px;
        }
        
        .product-image {
            max-width: 100%;
            height: auto;
            border-radius: var(--main-radius);
            box-shadow: var(--main-shadow);
            transition: transform 0.3s;
        }
        
        .product-image:hover {
            transform: scale(1.02);
        }
        
        .product-info {
            padding: 20px;
        }
        
        .product-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 15px;
            color: var(--main-dark);
        }
        
        .product-price {
            font-size: 1.8rem;
            color: var(--main-red);
            font-weight: 700;
            margin-bottom: 20px;
        }
        
        .product-description {
            margin: 25px 0;
            padding: 20px;
            background-color: rgba(0,0,0,0.02);
            border-radius: var(--main-radius);
            border-left: 4px solid var(--main-red);
        }
        
        .product-meta {
            margin-bottom: 25px;
            padding: 15px 0;
            border-top: 1px solid #eee;
            border-bottom: 1px solid #eee;
        }
        
        .product-meta h5 {
            font-size: 1rem;
            font-weight: 700;
            margin-bottom: 5px;
            color: var(--main-dark);
        }
        
        .product-meta p {
            font-size: 1.1rem;
            color: #666;
        }
        
        .add-to-cart-form {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-top: 30px;
        }
        
        .quantity-input {
            width: 120px;
            padding: 12px 15px;
            border-radius: 10px;
            border: 1px solid #e0e0e0;
            font-size: 1rem;
            text-align: center;
        }
        
        .btn-main {
            background: var(--main-red);
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-main:hover {
            background: #b00016;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(208,2,27,0.3);
        }
        
        /* Nút Mua ngay */
        .btn-success {
            background: #28a745;
            color: white;
            border: none;
            transition: all 0.3s;
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.2);
        }
        
        .btn-success:hover {
            background: #218838;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(40, 167, 69, 0.3);
        }
        
        /* Đánh giá sản phẩm */
        .reviews-section {
            margin-top: 50px;
            background-color: var(--main-white);
            border-radius: var(--main-radius);
            box-shadow: var(--main-shadow);
            padding: 30px;
        }
        
        .section-title {
            position: relative;
            margin-bottom: 30px;
            padding-bottom: 15px;
            font-weight: 700;
            color: var(--main-dark);
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 80px;
            height: 4px;
            background: var(--main-red);
            border-radius: 2px;
        }
        
        .review-item {
            border: 1px solid #eee;
            border-radius: var(--main-radius);
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s;
        }
        
        .review-item:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transform: translateY(-3px);
        }
        
        .review-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .review-stars {
            color: #ffc107;
            font-weight: 600;
        }
        
        .review-date {
            color: #888;
            font-size: 0.9rem;
        }
        
        .review-content {
            color: #444;
            line-height: 1.6;
        }
        
        /* Form đánh giá */
        .review-form {
            background-color: #f9f9f9;
            border-radius: var(--main-radius);
            padding: 25px;
            margin-top: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--main-dark);
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border-radius: 10px;
            border: 1px solid #e0e0e0;
            font-size: 1rem;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--main-red);
            box-shadow: 0 0 0 3px rgba(208,2,27,0.1);
        }
        
        .btn-primary {
            background: var(--main-red);
            border-color: var(--main-red);
            padding: 12px 25px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-primary:hover {
            background: #b00016;
            border-color: #b00016;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(208,2,27,0.3);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .product-info {
                padding: 20px 0;
            }
            
            .add-to-cart-form {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .quantity-input {
                width: 100%;
                margin-bottom: 15px;
            }
            
            .btn-main {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<jsp:include page="/views/includes/navbar.jsp"/>

<div class="container">
    <c:if test="${not empty param.msg}">
        <c:choose>
            <c:when test="${param.msg eq 'success'}">
                <div class="alert alert-success mt-4">
                    <i class="fas fa-check-circle me-2"></i> Đánh giá sản phẩm thành công!
                </div>
            </c:when>
            <c:when test="${param.msg eq 'error'}">
                <div class="alert alert-danger mt-4">
                    <i class="fas fa-exclamation-circle me-2"></i> Có lỗi xảy ra khi đánh giá sản phẩm!
                </div>
            </c:when>
            <c:when test="${param.msg eq 'empty'}">
                <div class="alert alert-warning mt-4">
                    <i class="fas fa-exclamation-triangle me-2"></i> Vui lòng nhập nội dung đánh giá!
                </div>
            </c:when>
        </c:choose>
    </c:if>
    
    <div class="product-container">
        <div class="row">
            <div class="col-md-6">
                <img src="${pageContext.request.contextPath}/img_Url/${sanPham.urlAnh}" class="product-image" alt="${sanPham.tenSanPham}">
            </div>
            <div class="col-md-6 product-info">
                <h1 class="product-title">${sanPham.tenSanPham}</h1>
                <p class="product-price">${sanPham.gia}₫</p>
                
                <div class="product-description">
                    <h5 class="mb-3">Mô tả sản phẩm:</h5>
                    <p>${sanPham.moTa}</p>
                </div>
                
                <div class="product-meta">
                    <div class="row mb-3">
                        <div class="col-6">
                            <h5><i class="fas fa-industry me-2"></i> Nhà sản xuất:</h5>
                            <p>${sanPham.nhaSanXuat}</p>
                        </div>
                        <div class="col-6">
                            <h5><i class="fas fa-box me-2"></i> Số lượng còn lại:</h5>
                            <p>${sanPham.soLuongTon} sản phẩm</p>
                        </div>
                    </div>
                </div>
                
                <form method="get" action="${pageContext.request.contextPath}/gio-hang" class="add-to-cart-form">
                    <input type="hidden" name="action" value="add"/>
                    <input type="hidden" name="idSanPham" value="${sanPham.idSanPham}"/>
                    <input type="number" name="soLuong" value="1" min="1" max="${sanPham.soLuongTon}" class="form-control quantity-input"/>
                    <button type="submit" class="btn btn-main">
                        <i class="fas fa-cart-plus"></i> <span>Thêm vào giỏ hàng</span>
                    </button>
                </form>
                
                <!-- Nút Mua ngay -->
                <form method="get" action="${pageContext.request.contextPath}/dat-hang" class="mt-3">
                    <input type="hidden" name="action" value="buynow"/>
                    <input type="hidden" name="idSanPham" value="${sanPham.idSanPham}"/>
                    <div class="d-flex gap-3 mb-3">
                        <input type="hidden" type="number" name="soLuong" value="1" min="1" max="${sanPham.soLuongTon}" 
                               class="form-control quantity-input-buynow" style="width: 120px;"
                               aria-label="Số lượng mua ngay"/>
                        <button type="submit" class="btn btn-success flex-grow-1" style="padding: 12px 20px; border-radius: 10px; font-weight: 600;">
                            <i class="fas fa-bolt"></i> <span>Mua ngay</span>
                        </button>
                    </div>
                </form>
                
                <!-- Script để đồng bộ số lượng giữa hai form -->
                <script>
                    document.addEventListener('DOMContentLoaded', function() {
                        const cartQuantityInput = document.querySelector('.quantity-input');
                        const buyNowQuantityInput = document.querySelector('.quantity-input-buynow');
                        
                        // Đồng bộ từ giỏ hàng sang mua ngay
                        cartQuantityInput.addEventListener('change', function() {
                            buyNowQuantityInput.value = this.value;
                        });
                        
                        // Đồng bộ từ mua ngay sang giỏ hàng
                        buyNowQuantityInput.addEventListener('change', function() {
                            cartQuantityInput.value = this.value;
                        });
                        
                        // Kiểm tra giới hạn số lượng
                        function validateQuantity(input) {
                            const max = parseInt(input.max);
                            const value = parseInt(input.value);
                            if (value > max) {
                                input.value = max;
                                alert('Số lượng không được vượt quá ' + max);
                            }
                            if (value < 1) {
                                input.value = 1;
                            }
                        }
                        
                        cartQuantityInput.addEventListener('input', function() {
                            validateQuantity(this);
                        });
                        
                        buyNowQuantityInput.addEventListener('input', function() {
                            validateQuantity(this);
                        });
                    });
                </script>
            </div>
        </div>
    </div>

    <div class="reviews-section">
        <h2 class="section-title">Đánh giá từ khách hàng</h2>
        
        <c:if test="${empty danhGiaList}">
            <div class="text-center py-4">
                <i class="fas fa-comment-slash fa-3x text-muted mb-3"></i>
                <p class="lead">Chưa có đánh giá nào cho sản phẩm này</p>
            </div>
        </c:if>
        
        <c:forEach var="dg" items="${danhGiaList}">
            <div class="review-item">
                <div class="review-header">
                    <div class="review-stars">
                        <c:forEach begin="1" end="${dg.soSao}">
                            <i class="fas fa-star"></i>
                        </c:forEach>
                        <c:forEach begin="${dg.soSao + 1}" end="5">
                            <i class="far fa-star"></i>
                        </c:forEach>
                    </div>
                    <div class="review-date">${dg.ngayDanhGia}</div>
                </div>
                <div class="review-content">${dg.noiDung}</div>
            </div>
        </c:forEach>
        
        <c:if test="${sessionScope.nguoiDung != null}">
            <h4 class="mt-5 mb-3">Viết đánh giá của bạn</h4>
            <form method="post" action="${pageContext.request.contextPath}/danh-gia" class="review-form">
                <input type="hidden" name="idSanPham" value="${sanPham.idSanPham}"/>
                
                <div class="form-group mb-3">
                    <label for="soSao">Đánh giá của bạn:</label>
                    <select name="soSao" id="soSao" class="form-control">
                        <c:forEach begin="1" end="5" var="i">
                            <option value="${i}">${i} sao</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group mb-3">
                    <label for="noiDung">Nhận xét của bạn:</label>
                    <textarea name="noiDung" id="noiDung" class="form-control" rows="4" placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..." required></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-paper-plane"></i> <span>Gửi đánh giá</span>
                </button>
            </form>
        </c:if>
        
        <c:if test="${sessionScope.nguoiDung == null}">
            <div class="alert alert-info mt-4">
                <i class="fas fa-info-circle me-2"></i> Vui lòng <a href="${pageContext.request.contextPath}/dang-nhap" class="alert-link">đăng nhập</a> để viết đánh giá.
            </div>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



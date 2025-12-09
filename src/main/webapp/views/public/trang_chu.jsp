<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.watchstore.model.SanPham" %>
<%
    List<SanPham> dsSanPham = (List<SanPham>) request.getAttribute("dsSanPham");
    String msg = request.getParameter("msg");
    Object userLogin = session.getAttribute("nguoiDung");
%>
<!DOCTYPE html>
<html>
<head>
    <title>WatchStore - Trang chủ</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main-style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --main-red: #d0021b;
            --main-dark: #212529;
            --main-gray: #f5f5f7;
            --main-white: #ffffff;
            --main-radius: 12px;
            --main-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }
        
        /* Cải thiện giao diện chung */
        body { 
            background: var(--main-gray);
            font-family: 'Quicksand', sans-serif;
        }
        
        /* Cải thiện header */
        .navbar {
            padding: 15px 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
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
        
        /* Cải thiện banner */
        .carousel-inner {
            border-radius: var(--main-radius);
            overflow: hidden;
            box-shadow: var(--main-shadow);
        }
        .carousel-caption {
            background: rgba(0,0,0,0.4);
            border-radius: 16px;
            padding: 20px;
            backdrop-filter: blur(5px);
            bottom: 40px;
        }
        .carousel-control-prev, .carousel-control-next {
            width: 50px;
            height: 50px;
            background: rgba(255,255,255,0.3);
            border-radius: 50%;
            top: 50%;
            transform: translateY(-50%);
            margin: 0 20px;
        }
        
        /* Cải thiện form tìm kiếm */
        .search-form {
            background: var(--main-white);
            padding: 25px;
            border-radius: var(--main-radius);
            box-shadow: var(--main-shadow);
            margin: 30px 0;
            position: relative;
            z-index: 10;
        }
        .search-form .form-control, .search-form .form-select {
            border-radius: 10px;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            font-size: 1rem;
        }
        .search-form .btn-primary {
            padding: 12px 15px;
            border-radius: 10px;
            font-weight: 600;
            background: var(--main-red);
            border: none;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .search-form .btn-primary:hover {
            background: #b00016;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(208,2,27,0.3);
        }
        
        /* Cải thiện sản phẩm */
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
        .product-card {
            border: none;
            border-radius: var(--main-radius);
            overflow: hidden;
            transition: all 0.3s;
            height: 100%;
            background: var(--main-white);
        }
        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.12);
        }
        .card-img-top {
            height: 240px;
            object-fit: cover;
            transition: all 0.5s;
        }
        .product-card:hover .card-img-top {
            transform: scale(1.05);
        }
        .card-body {
            padding: 20px;
        }
        .card-title {
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 10px;
            height: 40px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        .card-text {
            color: #666;
            margin-bottom: 15px;
            height: 48px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        .price {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--main-red);
            margin-bottom: 15px;
        }
        .btn-main {
            background: var(--main-red);
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: auto;
        }
        .btn-main:hover {
            background: #b00016;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(208,2,27,0.3);
        }
        .btn-outline-danger {
            border-color: var(--main-red);
            color: var(--main-red);
            font-weight: 600;
            transition: all 0.3s;
            padding: 10px 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .btn-outline-danger:hover {
            background: var(--main-red);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(208,2,27,0.2);
        }
        
        /* Cải thiện footer */
        footer {
            background: var(--main-dark);
            color: white;
            border-radius: var(--main-radius) var(--main-radius) 0 0;
            margin-top: 80px;
            padding: 50px 0 20px;
        }
        .footer-content {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
        }
        .footer-col {
            flex: 1;
            min-width: 250px;
            margin-bottom: 30px;
        }
        .footer-col h5 {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 20px;
            position: relative;
            padding-bottom: 10px;
        }
        .footer-col h5::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 40px;
            height: 3px;
            background: var(--main-red);
        }
        .footer-social a {
            display: inline-block;
            width: 36px;
            height: 36px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            text-align: center;
            line-height: 36px;
            color: white;
            margin-right: 10px;
            transition: all 0.3s;
        }
        .footer-social a:hover {
            background: var(--main-red);
            transform: translateY(-3px);
        }
        
        /* Thêm các phần mới */
        .features {
            display: flex;
            justify-content: space-between;
            margin: 40px 0;
            flex-wrap: wrap;
        }
        .feature-item {
            flex: 1;
            min-width: 200px;
            text-align: center;
            padding: 20px;
            margin: 10px;
            background: var(--main-white);
            border-radius: var(--main-radius);
            box-shadow: var(--main-shadow);
            transition: all 0.3s;
        }
        .feature-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .feature-icon {
            font-size: 2.5rem;
            color: var(--main-red);
            margin-bottom: 15px;
        }
        .feature-title {
            font-weight: 700;
            margin-bottom: 10px;
        }
        .feature-text {
            color: #666;
            font-size: 0.9rem;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .carousel-caption {
                padding: 10px;
                bottom: 20px;
            }
            .carousel-caption h2 {
                font-size: 1.2rem;
            }
            .carousel-caption p {
                font-size: 0.9rem;
            }
            .feature-item {
                min-width: 100%;
                margin: 10px 0;
            }
        }
    </style>
</head>
<body>
<jsp:include page="/views/includes/navbar.jsp"/>
<div class="container mt-4">
    <% if ("outofstock".equals(msg)) { %>
        <div class="alert alert-danger">Số lượng vượt quá tồn kho hoặc sản phẩm không còn hàng!</div>
    <% } %>
    
    <!-- Slider/banner -->
    <div id="mainSlider" class="carousel slide mb-4" data-bs-ride="carousel">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#mainSlider" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#mainSlider" data-bs-slide-to="1"></button>
        </div>
        <div class="carousel-inner rounded-4 shadow">
            <div class="carousel-item active">
                <img src="https://image.donghohaitrieu.com/wp-content/uploads/2025/04/banner-dong-ho-orient-vietnam-special-edition.jpg" class="d-block w-100" style="height:400px;object-fit:cover;" alt="Banner 1">
                <div class="carousel-caption d-none d-md-block">
                    <h2 class="fw-bold">Đồng hồ chính hãng, đẳng cấp</h2>
                    <p>Khám phá bộ sưu tập mới nhất tại WatchStore</p>
                    <a href="${pageContext.request.contextPath}/danh-sach-san-pham" class="btn btn-main btn-lg mt-2">Mua ngay</a>
                </div>
            </div>
            <div class="carousel-item">
                <img src="https://image.donghohaitrieu.com/wp-content/uploads/2025/04/banner-dong-ho-orient-vietnam-special-edition.jpg" class="d-block w-100" style="height:400px;object-fit:cover;" alt="Banner 2">
                <div class="carousel-caption d-none d-md-block">
                    <h2 class="fw-bold">Sang trọng & trẻ trung</h2>
                    <p>Phong cách thời thượng cho mọi lứa tuổi</p>
                    <a href="${pageContext.request.contextPath}/danh-sach-san-pham" class="btn btn-main btn-lg mt-2">Khám phá</a>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#mainSlider" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#mainSlider" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>
    
    <!-- Form tìm kiếm sản phẩm -->
    <form action="danh-sach-san-pham" method="GET" class="row g-3 search-form">
        <div class="col-md-6">
            <input type="text" class="form-control" name="keyword" placeholder="Tìm kiếm theo tên sản phẩm...">
        </div>
        <div class="col-md-3">
            <select class="form-select" name="nhaSanXuat">
                <option value="">Tất cả nhà sản xuất</option>
                <option value="Casio">Casio</option>
                <option value="Citizen">Citizen</option>
                <option value="Seiko">Seiko</option>
                <option value="Tissot">Tissot</option>
            </select>
        </div>
        <div class="col-md-3">
            <button type="submit" class="btn btn-primary w-100">
                <i class="fas fa-search"></i> <span>Tìm kiếm</span>
            </button>
        </div>
    </form>
    
    <!-- Tính năng nổi bật -->
    <div class="features">
        <div class="feature-item">
            <div class="feature-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <h4 class="feature-title">Chính hãng 100%</h4>
            <p class="feature-text">Tất cả sản phẩm đều được nhập khẩu chính hãng</p>
        </div>
        <div class="feature-item">
            <div class="feature-icon">
                <i class="fas fa-truck"></i>
            </div>
            <h4 class="feature-title">Giao hàng nhanh</h4>
            <p class="feature-text">Giao hàng toàn quốc từ 1-3 ngày</p>
        </div>
        <div class="feature-item">
            <div class="feature-icon">
                <i class="fas fa-shield-alt"></i>
            </div>
            <h4 class="feature-title">Bảo hành 5 năm</h4>
            <p class="feature-text">Chế độ bảo hành và hậu mãi tốt nhất</p>
        </div>
        <div class="feature-item">
            <div class="feature-icon">
                <i class="fas fa-exchange-alt"></i>
            </div>
            <h4 class="feature-title">Đổi trả 30 ngày</h4>
            <p class="feature-text">Đổi trả miễn phí trong 30 ngày đầu tiên</p>
        </div>
    </div>
    
    <!-- Sản phẩm nổi bật -->
    <h2 class="section-title mt-5">Sản phẩm nổi bật</h2>
    <div class="row">
        <% if (dsSanPham != null) for (SanPham sp : dsSanPham) { %>
            <div class="col-md-3 mb-4">
                <div class="card product-card h-100">
                    <img src="${pageContext.request.contextPath}/img_Url/<%= sp.getUrlAnh() %>" class="card-img-top" alt="<%= sp.getTenSanPham() %>">
                    <div class="card-body">
                        <h5 class="card-title"><%= sp.getTenSanPham() %></h5>
                        <p class="card-text" style="min-height:40px"><%= sp.getMoTa() %></p>
                        <p class="card-text text-danger fw-bold"><%= String.format("%,.0f₫", sp.getGia()) %></p>
                        <div class="d-flex flex-wrap gap-2">
                            <a href="${pageContext.request.contextPath}/gio-hang?action=add&idSanPham=<%= sp.getIdSanPham() %>&soLuong=1" class="btn btn-main">
                                <i class="fas fa-cart-plus"></i> <span>Thêm vào giỏ</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/san-pham?id=<%= sp.getIdSanPham() %>" class="btn btn-outline-danger">
                                <i class="fas fa-eye"></i> <span>Chi tiết</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>
    </div>
    
</div>
<footer class="mt-5">
    <div class="container footer-content py-4">
        <div class="footer-col">
            <h5>Liên hệ</h5>
            <p>Địa chỉ: 123 Đường ABC, Quận 1, TP.HCM</p>
            <p>Hotline: 0123 456 789</p>
            <p>Email: support@watchstore.com</p>
        </div>
        <div class="footer-col">
            <h5>Kết nối</h5>
            <div class="footer-social">
                <a href="#"><i class="fab fa-facebook"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-youtube"></i></a>
                <a href="#"><i class="fab fa-tiktok"></i></a>
            </div>
        </div>
        <div class="footer-col text-end">
            <h5>Bản quyền</h5>
            <p>&copy; 2025 WatchStore. All rights reserved.</p>
        </div>
    </div>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>






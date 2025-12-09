<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.watchstore.model.GioHang, com.watchstore.model.ChiTietGioHang" %>
<%
    GioHang cart = (GioHang) request.getAttribute("cart");
    String error = (String) request.getAttribute("error");
    Boolean isBuyNow = (Boolean) request.getAttribute("isBuyNow");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Thanh toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
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
        
        .checkout-container {
            background-color: var(--main-white);
            border-radius: var(--main-radius);
            box-shadow: var(--main-shadow);
            padding: 30px;
            margin-top: 30px;
            margin-bottom: 30px;
        }
        
        .checkout-table th, .checkout-table td { 
            vertical-align: middle !important; 
        }
        
        .checkout-total { 
            font-size: 1.2rem; 
            font-weight: bold; 
            color: var(--main-red); 
        }
        
        .btn-success {
            background: #28a745;
            border: none;
            padding: 12px 25px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-success:hover {
            background: #218838;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }
    </style>
</head>
<body>
<div class="container mt-4 mb-5">
    <h2 class="mb-4">
        <% if (isBuyNow != null && isBuyNow) { %>
            <i class="fas fa-bolt me-2"></i> Thanh toán nhanh
        <% } else { %>
            <i class="fas fa-shopping-cart me-2"></i> Thanh toán đơn hàng
        <% } %>
    </h2>
    
    <% if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>
    
    <c:if test="${empty cart or empty cart.items}">
        <div class="alert alert-info">Giỏ hàng trống. <a href="${pageContext.request.contextPath}/">Quay lại mua sắm</a></div>
    </c:if>
    
    <c:if test="${not empty cart and not empty cart.items}">
        <div class="checkout-container">
            <div class="row">
                <div class="col-lg-7 mb-4">
                    <h5 class="mb-3"><i class="fas fa-clipboard-list me-2"></i> Thông tin đơn hàng</h5>
                    <div class="table-responsive">
                        <table class="table table-bordered checkout-table">
                            <thead class="table-light">
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Giá</th>
                                    <th>Số lượng</th>
                                    <th>Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:set var="tong" value="0" scope="page"/>
                            <c:forEach var="it" items="${cart.items}">
                                <tr>
                                    <td>
                                        <strong>${it.sanPham.tenSanPham}</strong>
                                    </td>
                                    <td>${it.sanPham.gia}₫</td>
                                    <td>${it.soLuong}</td>
                                    <td>${it.sanPham.gia * it.soLuong}₫</td>
                                    <c:set var="tong" value="${tong + (it.sanPham.gia * it.soLuong)}" scope="page"/>
                                </tr>
                            </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="3" class="text-end">Tổng cộng:</th>
                                    <th class="checkout-total">${tong}₫</th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
                
                <div class="col-lg-5">
                    <h5 class="mb-3"><i class="fas fa-map-marker-alt me-2"></i> Thông tin giao hàng</h5>
                    <form method="post" action="${pageContext.request.contextPath}/dat-hang">
                        <input type="hidden" name="tongTien" value="${tong}"/>
                        <% if (isBuyNow != null && isBuyNow) { %>
                            <input type="hidden" name="isBuyNow" value="true"/>
                        <% } %>
                        
                        <div class="mb-3">
                            <label class="form-label">Địa chỉ giao hàng</label>
                            <textarea class="form-control" name="diaChiNhan" rows="3" required placeholder="Nhập địa chỉ giao hàng chi tiết"></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại người nhận</label>
                            <input type="text" class="form-control" name="sdtNhan" required placeholder="Nhập số điện thoại">
                        </div>
                        
                        <c:if test="${empty sessionScope.nguoiDung}">
                            <div class="mb-3">
                                <label for="tenDayDu" class="form-label">Họ tên</label>
                                <input type="text" class="form-control" id="tenDayDu" name="tenDayDu" required placeholder="Nhập họ tên của bạn">
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" required placeholder="Nhập email của bạn">
                            </div>
                        </c:if>
                        
                        <button type="submit" class="btn btn-success btn-lg w-100">
                            <i class="fas fa-check-circle"></i> <span>Xác nhận đặt hàng</span>
                        </button>
                    </form>
                    
                    <div class="mt-3 text-center">
                        <% if (isBuyNow != null && isBuyNow) { %>
                            <a href="${pageContext.request.contextPath}/san-pham?id=${cart.items[0].idSanPham}" class="btn btn-link">
                                <i class="fas fa-arrow-left"></i> Quay lại trang sản phẩm
                            </a>
                        <% } else { %>
                            <a href="${pageContext.request.contextPath}/gio-hang" class="btn btn-link">
                                <i class="fas fa-arrow-left"></i> Quay lại giỏ hàng
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

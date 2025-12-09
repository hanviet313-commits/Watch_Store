<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/main-style.css" rel="stylesheet">
    <style>
        .cart-img { width: 80px; height: 80px; object-fit: cover; border-radius: 8px; }
        .cart-table th, .cart-table td { vertical-align: middle !important; }
        .cart-total { font-size: 1.3rem; font-weight: bold; color: #d9534f; }
        .cart-actions { min-width: 120px; }
    </style>
</head>
<body>
    <jsp:include page="/views/includes/navbar.jsp"/>
<div class="container mt-4 mb-5">
    <h2 class="mb-4">🛒 Giỏ hàng của bạn</h2>
    <c:if test="${not empty msg}">
        <c:choose>
            <c:when test="${msg eq 'added'}">
                <div class="alert alert-success">Đã thêm sản phẩm vào giỏ hàng!</div>
            </c:when>
            <c:when test="${msg eq 'updated'}">
                <div class="alert alert-success">Cập nhật giỏ hàng thành công!</div>
            </c:when>
            <c:when test="${msg eq 'cleared'}">
                <div class="alert alert-success">Đã xóa toàn bộ giỏ hàng!</div>
            </c:when>
            <c:when test="${msg eq 'outofstock'}">
                <div class="alert alert-danger">Số lượng vượt quá tồn kho hoặc sản phẩm không còn hàng!</div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-danger">${msg}</div>
            </c:otherwise>
        </c:choose>
    </c:if>
    <c:if test="${empty cart or empty cart.items}">
        <div class="alert alert-info">Giỏ hàng trống. <a href="/WatchStore/">Tiếp tục mua sắm</a></div>
    </c:if>
    <c:if test="${not empty cart and not empty cart.items}">
        <div class="table-responsive">
            <table class="table table-bordered cart-table align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Ảnh</th>
                        <th>Sản phẩm</th>
                        <th>Giá</th>
                        <th style="width:120px;">Số lượng</th>
                        <th>Thành tiền</th>
                        <th class="cart-actions">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                <c:set var="tong" value="0" scope="page"/>
                <c:forEach var="it" items="${cart.items}">
                    <tr>
                        <td>
                            <img src="${pageContext.request.contextPath}/img_Url/${it.sanPham.urlAnh}" class="cart-img" alt="${it.sanPham.tenSanPham}">
                        </td>
                        <td>
                            <strong>${it.sanPham.tenSanPham}</strong><br>
                            <small>${it.sanPham.moTa}</small>
                        </td>
                        <td class="text-danger fw-bold">${it.sanPham.gia}₫</td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/gio-hang" class="d-flex align-items-center">
                                <input type="hidden" name="action" value="update"/>
                                <input type="hidden" name="idSanPham" value="${it.idSanPham}"/>
                                <input type="number" name="soLuong" value="${it.soLuong}" min="1" class="form-control me-2" style="width:70px"/>
                                <button class="btn btn-sm btn-outline-primary">Cập nhật</button>
                            </form>
                        </td>
                        <td class="cart-total">
                            <c:set var="thanhTien" value="${it.sanPham.gia * it.soLuong}" scope="page"/>
                            ${thanhTien}₫
                            <c:set var="tong" value="${tong + thanhTien}" scope="page"/>
                        </td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/gio-hang">
                                <input type="hidden" name="action" value="remove"/>
                                <input type="hidden" name="idSanPham" value="${it.idSanPham}"/>
                                <input type="hidden" name="soLuong" value="0"/>
                                <button class="btn btn-sm btn-outline-danger" onclick="return confirm('Bạn chắc chắn muốn xóa sản phẩm này?')">Xóa</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <th colspan="4" class="text-end">Tổng cộng:</th>
                        <th class="cart-total" colspan="2">${tong}₫</th>
                    </tr>
                </tfoot>
            </table>
        </div>
        <!-- Kiểm tra form xóa toàn bộ giỏ hàng -->
        <div class="d-flex justify-content-between mt-4">
            <div>
                <a href="${pageContext.request.contextPath}/" class="btn btn-secondary"><i class="bi bi-arrow-left"></i> Tiếp tục mua hàng</a>
                <a href="${pageContext.request.contextPath}/xoa-gio-hang" class="btn btn-danger ms-2" 
                   onclick="return confirm('Bạn chắc chắn muốn xóa toàn bộ giỏ hàng?')">
                    <i class="bi bi-trash"></i> Xóa toàn bộ giỏ hàng
                </a>
            </div>
            <a href="${pageContext.request.contextPath}/dat-hang" class="btn btn-success btn-lg">Thanh toán</a>
        </div>
    </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- Nếu muốn dùng icon Bootstrap, thêm dòng sau vào <head>: -->
<!-- <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"> -->
</body>
</html>




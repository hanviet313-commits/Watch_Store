<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #${order.id}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/staff/includes/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Chi tiết đơn hàng #${order.id}</h2>
            <a href="${pageContext.request.contextPath}/staff/orders" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <div class="row">
            <!-- Thông tin đơn hàng -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">Thông tin đơn hàng</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-borderless">
                            <tr>
                                <th>Trạng thái:</th>
                                <td><span class="badge bg-info">${order.status}</span></td>
                            </tr>
                            <tr>
                                <th>Ngày đặt:</th>
                                <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                            </tr>
                            <tr>
                                <th>Tổng tiền:</th>
                                <td class="text-danger fw-bold">${order.totalAmount}₫</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Thông tin khách hàng và người nhận -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="card-title mb-0">Thông tin khách hàng & người nhận</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-borderless">
                            <tr>
                                <th>Họ tên khách:</th>
                                <td>${order.customerName}</td>
                            </tr>
                            <tr>
                                <th>Email khách:</th>
                                <td>${order.email}</td>
                            </tr>
                            <tr>
                                <th>SĐT khách:</th>
                                <td>${order.customerPhone}</td>
                            </tr>
                            <tr>
                                <th>Địa chỉ nhận:</th>
                                <td>${order.address}</td>
                            </tr>
                            <tr>
                                <th>SĐT người nhận:</th>
                                <td>${order.receiverPhone}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Chi tiết sản phẩm -->
        <div class="card mb-4">
            <div class="card-header bg-success text-white">
                <h5 class="card-title mb-0">Chi tiết sản phẩm</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Đơn giá</th>
                                <th>Số lượng</th>
                                <th>Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orderItems}" var="item">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${pageContext.request.contextPath}/img_Url/${item.image}" 
                                                 alt="${item.productName}" 
                                                 class="me-3" 
                                                 style="width: 50px; height: 50px; object-fit: cover;">
                                            <div>
                                                <span>${item.productName}</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${item.price}₫</td>
                                    <td>${item.quantity}</td>
                                    <td class="text-danger">${item.subtotal}₫</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
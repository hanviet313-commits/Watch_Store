<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - Watch Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/staff/css/staff.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/staff/includes/navbar.jsp" />
    <div style="display: flex;">
        <jsp:include page="/staff/includes/sidebar.jsp" />
        <div style="flex: 1; padding: 20px;">
            <!-- BẮT ĐẦU NỘI DUNG DASHBOARD STAFF -->
            <h2 class="mb-4">Dashboard</h2>
            <!-- Stats Cards -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card staff-card">
                        <div class="card-body stats-card">
                            <i class="fas fa-shopping-cart text-primary"></i>
                            <div class="number">${totalOrders}</div>
                            <div class="label">Tổng đơn hàng</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card staff-card">
                        <div class="card-body stats-card">
                            <i class="fas fa-box text-success"></i>
                            <div class="number">${totalProducts}</div>
                            <div class="label">Sản phẩm</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card staff-card">
                        <div class="card-body stats-card">
                            <i class="fas fa-users text-info"></i>
                            <div class="number">${totalCustomers}</div>
                            <div class="label">Khách hàng</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card staff-card">
                        <div class="card-body stats-card">
                            <i class="fas fa-star text-warning"></i>
                            <div class="number">${totalReviews}</div>
                            <div class="label">Đánh giá</div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Recent Orders -->
            <div class="card staff-card mb-4">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0">Đơn hàng gần đây</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table staff-table">
                            <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày đặt</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentOrders}" var="order">
                                    <tr>
                                        <td>#${order[0]}</td>
                                        <td>${order[1]}</td>
                                        <td>${order[2]}</td>
                                        <td>${order[3]}</td>
                                        <td>
                                            <span class="status-badge status-${order[4].toLowerCase()}">
                                                ${order[4]}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/staff/orders/view?id=${order[0]}" 
                                               class="btn btn-sm btn-primary">Chi tiết</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- Recent Reviews -->
            <div class="card staff-card">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0">Đánh giá gần đây</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table staff-table">
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Khách hàng</th>
                                    <th>Đánh giá</th>
                                    <th>Ngày</th>
                                    <th>Trả lời</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentReviews}" var="review">
                                    <tr>
                                        <td>${review[1]}</td>
                                        <td>${review[2]}</td>
                                        <td>
                                            <div class="text-warning">
                                                <c:forEach begin="1" end="${review[3]}">
                                                    <i class="fas fa-star"></i>
                                                </c:forEach>
                                            </div>
                                        </td>
                                        <td>${review[4]}</td>
                                        <td>${review[6] != null ? review[6] : 'Chưa trả lời'}</td>
                                        <td>
                                            <span class="status-badge ${review[5] == 1 ? 'status-completed' : 'status-cancelled'}">
                                                ${review[5] == 1 ? 'Hiển thị' : 'Ẩn'}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/nv/quan-ly-danh-gia" 
                                               class="btn btn-sm btn-primary">Chi tiết</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- KẾT THÚC NỘI DUNG DASHBOARD STAFF -->
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
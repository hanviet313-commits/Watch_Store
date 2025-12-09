<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng (Staff)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/staff/includes/navbar.jsp" />
<div style="display: flex;">
    <jsp:include page="/staff/includes/sidebar.jsp" />
    <div style="flex: 1; padding: 20px;">
        <!-- BẮT ĐẦU NỘI DUNG QUẢN LÝ ĐƠN HÀNG STAFF -->
        <h2 class="mb-4">Quản lý đơn hàng</h2>
        <c:if test="${not empty sessionScope.orderStatusMessage}">
            <div class="alert alert-info">${sessionScope.orderStatusMessage}</div>
            <c:remove var="orderStatusMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">Lỗi: ${errorMessage}</div>
        </c:if>
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle">
                <thead class="table-dark">
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
                    <c:forEach items="${orders}" var="order">
                        <tr>
                            <td>#${order[0]}</td>
                            <td>${order[1]}</td>
                            <td>${order[2]}</td>
                            <td>${order[3]}₫</td>
                            <td>
                                <span class="badge bg-info">${order[4]}</span>
                            </td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/staff/orders/update-status" class="d-flex align-items-center" style="gap: 4px;">
                                    <input type="hidden" name="orderId" value="${order[0]}" />
                                    <select name="status" class="form-select form-select-sm" style="width: auto;">
                                        <c:forEach var="st" items="${['Chờ xác nhận','Đang xử lý','Đang giao','Hoàn thành','Đã hủy']}">
                                            <option value="${st}" ${order[4] == st ? 'selected' : ''}>${st}</option>
                                        </c:forEach>
                                    </select>
                                    <button type="submit" class="btn btn-sm btn-success">Cập nhật</button>
                                </form>
                                <a href="${pageContext.request.contextPath}/staff/orders/view?id=${order[0]}" class="btn btn-sm btn-primary ms-1">Chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <!-- KẾT THÚC NỘI DUNG QUẢN LÝ ĐƠN HÀNG STAFF -->
    </div>
</div>
</body>
</html> 
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.watchstore.model.SanPham" %>
<%
    List<SanPham> danhSachSanPham = (List<SanPham>) request.getAttribute("danhSachSanPham");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kết quả tìm kiếm sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/views/includes/navbar.jsp"/>
<div class="container mt-4">
    <h2>Kết quả tìm kiếm sản phẩm</h2>
    <div class="row">
        <% if (danhSachSanPham != null && !danhSachSanPham.isEmpty()) { 
            for (SanPham sp : danhSachSanPham) { %>
            <div class="col-md-3 mb-4">
                <div class="card h-100">
                    <img src="${pageContext.request.contextPath}/img_Url/<%= sp.getUrlAnh() %>" class="card-img-top" alt="<%= sp.getTenSanPham() %>">
                    <div class="card-body">
                        <h5 class="card-title"><%= sp.getTenSanPham() %></h5>
                        <p class="card-text"><%= sp.getMoTa() %></p>
                        <p class="card-text text-danger fw-bold"><%= String.format("%,.0f₫", sp.getGia()) %></p>
                        <a href="${pageContext.request.contextPath}/san-pham?id=<%= sp.getIdSanPham() %>" class="btn btn-outline-danger">Xem chi tiết</a>
                    </div>
                </div>
            </div>
        <% }} else { %>
            <div class="col-12">
                <div class="alert alert-warning">Không tìm thấy sản phẩm phù hợp!</div>
            </div>
        <% } %>
    </div>
    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Quay lại trang chủ</a>
</div>
</body>
</html> 
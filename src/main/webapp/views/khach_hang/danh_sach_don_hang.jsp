<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.watchstore.model.DonHang, com.watchstore.model.ChiTietDonHang" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/main-style.css" rel="stylesheet">
    <style>
        .order-nav .nav-link {
            color: #495057;
            border-radius: 0;
            padding: 10px 15px;
        }
        .order-nav .nav-link.active {
            color: #0d6efd;
            border-bottom: 2px solid #0d6efd;
            background-color: transparent;
        }
        .order-nav .nav-link:hover:not(.active) {
            border-bottom: 2px solid #dee2e6;
        }
        .badge-counter {
            font-size: 0.7em;
            margin-left: 5px;
            background-color: #f8f9fa;
            color: #6c757d;
            padding: 2px 6px;
            border-radius: 10px;
        }
        /* Đảm bảo phông chữ nhất quán */
        .modal-body, .modal-title, .form-label, .form-control, .form-text {
            font-family: 'Quicksand', Arial, Helvetica, sans-serif;
        }
        /* Đảm bảo textarea hiển thị đúng */
        textarea.form-control {
            font-family: 'Quicksand', Arial, Helvetica, sans-serif;
            font-size: 1rem;
            line-height: 1.5;
        }
        /* Đảm bảo checkbox hiển thị đúng */
        .form-check-label {
            font-family: 'Quicksand', Arial, Helvetica, sans-serif;
            font-weight: normal;
        }
    </style>
</head>
<body>
<jsp:include page="/views/includes/navbar.jsp"/>
<div class="container mt-4 mb-5">
    <h2 class="mb-3">📦 Đơn hàng của tôi</h2>
    
    <!-- Thanh navbar lọc đơn hàng -->
    <ul class="nav nav-tabs order-nav mb-4">
        <li class="nav-item">
            <a class="nav-link ${empty param.status ? 'active' : ''}" href="${pageContext.request.contextPath}/don-hang">
                Tất cả
                <span class="badge-counter">${allOrdersCount}</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.status eq 'cho-xac-nhan' ? 'active' : ''}" href="${pageContext.request.contextPath}/don-hang?status=cho-xac-nhan">
                Chờ xác nhận
                <span class="badge-counter">${choXacNhanCount}</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.status eq 'dang-xu-ly' ? 'active' : ''}" href="${pageContext.request.contextPath}/don-hang?status=dang-xu-ly">
                Đang xử lý
                <span class="badge-counter">${dangXuLyCount}</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.status eq 'dang-giao' ? 'active' : ''}" href="${pageContext.request.contextPath}/don-hang?status=dang-giao">
                Đang giao
                <span class="badge-counter">${dangGiaoCount}</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.status eq 'hoan-thanh' ? 'active' : ''}" href="${pageContext.request.contextPath}/don-hang?status=hoan-thanh">
                Hoàn thành
                <span class="badge-counter">${hoanThanhCount}</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.status eq 'da-huy' ? 'active' : ''}" href="${pageContext.request.contextPath}/don-hang?status=da-huy">
                Đã hủy
                <span class="badge-counter">${daHuyCount}</span>
            </a>
        </li>
    </ul>
    
    <!-- Hiển thị thông báo -->
    <c:if test="${not empty msg}">
        <c:choose>
            <c:when test="${msg eq 'success'}">
                <div class="alert alert-success">Đơn hàng đã được hủy thành công!</div>
            </c:when>
            <c:when test="${msg eq 'error'}">
                <div class="alert alert-danger">Không thể hủy đơn hàng. Đơn hàng có thể đã được xử lý hoặc đang giao.</div>
            </c:when>
            <c:when test="${msg eq 'invalid'}">
                <div class="alert alert-danger">Mã đơn hàng không hợp lệ!</div>
            </c:when>
            <c:when test="${msg eq 'complaint_success'}">
                <div class="alert alert-success">Khiếu nại đã được gửi thành công! Chúng tôi sẽ xem xét và phản hồi sớm nhất.</div>
            </c:when>
            <c:when test="${msg eq 'complaint_error'}">
                <div class="alert alert-danger">Có lỗi xảy ra khi gửi khiếu nại. Vui lòng thử lại sau!</div>
            </c:when>
        </c:choose>
    </c:if>
    
    <c:if test="${empty filteredOrders}">
        <div class="alert alert-info">Không có đơn hàng nào ${not empty param.status ? 'ở trạng thái này' : ''}.</div>
    </c:if>
    
    <c:forEach var="dh" items="${filteredOrders}">
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <div>
                    <strong>Đơn hàng #${dh.idDonHang}</strong> - 
                    <span class="text-muted">${dh.ngayDat}</span>
                </div>
                <div>
                    <c:choose>
                        <c:when test="${dh.trangThai eq 'Chờ xác nhận'}">
                            <span class="badge bg-warning text-dark">${dh.trangThai}</span>
                        </c:when>
                        <c:when test="${dh.trangThai eq 'Đang xử lý'}">
                            <span class="badge bg-info">${dh.trangThai}</span>
                        </c:when>
                        <c:when test="${dh.trangThai eq 'Đang giao'}">
                            <span class="badge bg-primary">${dh.trangThai}</span>
                        </c:when>
                        <c:when test="${dh.trangThai eq 'Hoàn thành'}">
                            <span class="badge bg-success">${dh.trangThai}</span>
                        </c:when>
                        <c:when test="${dh.trangThai eq 'Đã hủy'}">
                            <span class="badge bg-danger">${dh.trangThai}</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary">${dh.trangThai}</span>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Nút hủy đơn hàng chỉ hiển thị khi đơn hàng ở trạng thái "Chờ xác nhận" hoặc "Đang xử lý" -->
                    <c:if test="${dh.trangThai eq 'Chờ xác nhận' || dh.trangThai eq 'Đang xử lý'}">
                        <form method="post" action="${pageContext.request.contextPath}/huy-don-hang" style="display: inline;">
                            <input type="hidden" name="idDonHang" value="${dh.idDonHang}">
                            <button type="submit" class="btn btn-sm btn-danger" 
                                    onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?');">
                                Hủy đơn hàng
                            </button>
                        </form>
                    </c:if>
                    
                    <!-- Nút khiếu nại chỉ hiển thị khi đơn hàng ở trạng thái "Hoàn thành" -->
                    <c:if test="${dh.trangThai eq 'Hoàn thành'}">
                        <button type="button" class="btn btn-sm btn-warning" 
                                data-bs-toggle="modal" data-bs-target="#complaintModal${dh.idDonHang}">
                            Gửi khiếu nại
                        </button>
                        
                        <!-- Modal khiếu nại -->
                        <div class="modal fade" id="complaintModal${dh.idDonHang}" tabindex="-1" aria-labelledby="complaintModalLabel${dh.idDonHang}" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="complaintModalLabel${dh.idDonHang}">Gửi khiếu nại cho đơn hàng #${dh.idDonHang}</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form method="post" action="${pageContext.request.contextPath}/khieu-nai">
                                        <div class="modal-body">
                                            <input type="hidden" name="idDonHang" value="${dh.idDonHang}">
                                            <div class="mb-3">
                                                <label for="noiDung${dh.idDonHang}" class="form-label fw-semibold">Nội dung khiếu nại:</label>
                                                <textarea class="form-control" id="noiDung${dh.idDonHang}" name="noiDung" rows="4" required 
                                                          placeholder="Vui lòng mô tả chi tiết vấn đề bạn gặp phải với đơn hàng này"></textarea>
                                            </div>
                                            <div class="mb-3">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="yeuCauTraHang${dh.idDonHang}" name="yeuCauTraHang">
                                                    <label class="form-check-label fw-medium" for="yeuCauTraHang${dh.idDonHang}">
                                                        Yêu cầu trả hàng/hoàn tiền
                                                    </label>
                                                </div>
                                                <div class="form-text text-muted">
                                                    Chọn tùy chọn này nếu bạn muốn trả lại sản phẩm và nhận lại tiền. Yêu cầu sẽ được xem xét bởi nhân viên.
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                            <button type="submit" class="btn btn-warning">Gửi khiếu nại</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
            <div class="card-body">
                <!-- Nội dung chi tiết đơn hàng -->
                <p><strong>Địa chỉ:</strong> ${dh.diaChi}</p>
                <p><strong>Số điện thoại:</strong> ${dh.sdtNguoiNhan}</p>
                <p><strong>Tổng tiền:</strong> ${dh.tongTien}₫</p>
                
                <h5 class="mt-3">Sản phẩm:</h5>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Ảnh</th>
                            <th>Sản phẩm</th>
                            <th>Đơn giá</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${dh.items}">
                            <tr>
                                <td><img src="${pageContext.request.contextPath}/img_Url/${item.sanPham.urlAnh}" alt="${item.sanPham.tenSanPham}" style="width:50px;height:50px;object-fit:cover;"></td>
                                <td>${item.sanPham.tenSanPham}</td>
                                <td>${item.donGia}₫</td>
                                <td>${item.soLuong}</td>
                                <td>${item.donGia * item.soLuong}₫</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:forEach>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>











<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đánh giá - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/staff/css/staff.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/staff/includes/navbar.jsp" />
    <div style="display: flex;">
        <jsp:include page="/staff/includes/sidebar.jsp" />
        <div style="flex: 1; padding: 20px;">
            <!-- BẮT ĐẦU NỘI DUNG QUẢN LÝ ĐÁNH GIÁ STAFF -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Quản lý đánh giá</h2>
            </div>
            <c:if test="${not empty param.msg}">
                <div class="alert alert-${param.msg.contains('success') ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
                    <c:choose>
                        <c:when test="${param.msg == 'reply_success'}">Trả lời đánh giá thành công!</c:when>
                        <c:when test="${param.msg == 'reply_error'}">Có lỗi xảy ra khi trả lời đánh giá!</c:when>
                        <c:when test="${param.msg == 'toggle_success'}">Cập nhật trạng thái đánh giá thành công!</c:when>
                        <c:when test="${param.msg == 'toggle_error'}">Có lỗi xảy ra khi cập nhật trạng thái!</c:when>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <div class="card staff-card">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0">Danh sách đánh giá</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table staff-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Sản phẩm</th>
                                    <th>Người đánh giá</th>
                                    <th>Nội dung</th>
                                    <th>Số sao</th>
                                    <th>Ngày đánh giá</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="review" items="${reviews}">
                                    <tr>
                                        <td>${review.idDanhGia}</td>
                                        <td>${review.tenSanPham}</td>
                                        <td>${review.tenNguoiDung}</td>
                                        <td>${review.noiDung}</td>
                                        <td>
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="fas fa-star ${i <= review.soSao ? 'text-warning' : 'text-muted'}"></i>
                                            </c:forEach>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${review.ngayDanhGia}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${review.trangThai}">
                                                    <span class="badge bg-success">Hiển thị</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Ẩn</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#replyModal${review.idDanhGia}">
                                                <i class="fas fa-reply"></i> Trả lời
                                            </button>
                                            <form action="${pageContext.request.contextPath}/nv/quan-ly-danh-gia" method="POST" class="d-inline">
                                                <input type="hidden" name="action" value="toggle">
                                                <input type="hidden" name="idDanhGia" value="${review.idDanhGia}">
                                                <input type="hidden" name="isHidden" value="${!review.trangThai}">
                                                <button type="submit" class="btn btn-warning btn-sm">
                                                    <i class="fas fa-eye-slash"></i> Ẩn
                                                </button>
                                            </form>
                                        </td>
                                    </tr>

                                    <!-- Modal trả lời đánh giá -->
                                    <div class="modal fade" id="replyModal${review.idDanhGia}" tabindex="-1">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Trả lời đánh giá</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/nv/quan-ly-danh-gia" method="POST">
                                                    <div class="modal-body">
                                                        <input type="hidden" name="action" value="reply">
                                                        <input type="hidden" name="idDanhGia" value="${review.idDanhGia}">
                                                        <div class="mb-3">
                                                            <label class="form-label">Nội dung đánh giá:</label>
                                                            <p class="form-control-plaintext">${review.noiDung}</p>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">Trả lời:</label>
                                                            <textarea name="reply" class="form-control" rows="3" required>${review.traLoi}</textarea>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                        <button type="submit" class="btn btn-primary">Gửi trả lời</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty reviews}">
                                    <tr><td colspan="8" class="text-center">Không có đánh giá nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- KẾT THÚC NỘI DUNG QUẢN LÝ ĐÁNH GIÁ STAFF -->
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
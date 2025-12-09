<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý thông báo - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/staff/css/staff.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/staff/includes/navbar.jsp" />
    <div style="display: flex;">
        <jsp:include page="/staff/includes/sidebar.jsp" />
        <div style="flex: 1; padding: 20px;">
            <!-- BẮT ĐẦU NỘI DUNG QUẢN LÝ THÔNG BÁO STAFF -->
            <c:if test="${not empty message}">
                <div class="alert alert-info">${message}</div>
            </c:if>
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Quản lý thông báo</h2>
            </div>
            <div class="card staff-card">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0">Danh sách thông báo</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table staff-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tiêu đề</th>
                                    <th>Nội dung</th>
                                    <th>Ngày tạo</th>
                                    <th>Ngày kết thúc</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="n" items="${notifications}">
                                    <tr>
                                        <td>${n.idThongBao}</td>
                                        <td>${n.tieuDe}</td>
                                        <td>${n.noiDung}</td>
                                        <td><fmt:formatDate value="${n.ngayTao}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td><fmt:formatDate value="${n.ngayKetThuc}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td>
                                            <!-- Nút sửa: mở modal -->
                                            <button type="button" class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editModal${n.idThongBao}"><i class="fas fa-edit"></i></button>
                                            <!-- Nút xóa: gửi form -->
                                            <form method="post" action="notifications" style="display:inline;" onsubmit="return confirm('Bạn chắc chắn muốn xóa?');">
                                                <input type="hidden" name="action" value="delete" />
                                                <input type="hidden" name="idThongBao" value="${n.idThongBao}" />
                                                <button type="submit" class="btn btn-danger btn-sm"><i class="fas fa-trash"></i></button>
                                            </form>
                                            <!-- Modal sửa -->
                                            <div class="modal fade" id="editModal${n.idThongBao}" tabindex="-1" aria-labelledby="editModalLabel${n.idThongBao}" aria-hidden="true">
                                              <div class="modal-dialog">
                                                <div class="modal-content">
                                                  <form method="post" action="notifications">
                                                    <input type="hidden" name="action" value="edit" />
                                                    <input type="hidden" name="idThongBao" value="${n.idThongBao}" />
                                                    <div class="modal-header">
                                                      <h5 class="modal-title" id="editModalLabel${n.idThongBao}">Sửa thông báo</h5>
                                                      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                      <div class="mb-3">
                                                        <label class="form-label">Tiêu đề</label>
                                                        <input type="text" class="form-control" name="tieuDe" value="${n.tieuDe}" required />
                                                      </div>
                                                      <div class="mb-3">
                                                        <label class="form-label">Nội dung</label>
                                                        <textarea class="form-control" name="noiDung" required>${n.noiDung}</textarea>
                                                      </div>
                                                      <div class="mb-3">
                                                        <label class="form-label">Ngày kết thúc</label>
                                                        <input type="datetime-local" class="form-control" name="ngayKetThuc" value="<fmt:formatDate value='${n.ngayKetThuc}' pattern='yyyy-MM-dd\'T\'HH:mm'/>" required />
                                                      </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                      <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                                                    </div>
                                                  </form>
                                                </div>
                                              </div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty notifications}">
                                    <tr><td colspan="5" class="text-center">Không có thông báo nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="card staff-card mb-4">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">Thêm thông báo mới</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="notifications">
                        <input type="hidden" name="action" value="add" />
                        <div class="mb-3">
                            <label class="form-label">Tiêu đề</label>
                            <input type="text" class="form-control" name="tieuDe" required />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Nội dung</label>
                            <textarea class="form-control" name="noiDung" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Ngày kết thúc</label>
                            <input type="datetime-local" class="form-control" name="ngayKetThuc" required />
                        </div>
                        <button type="submit" class="btn btn-success">Thêm thông báo</button>
                    </form>
                </div>
            </div>
            <!-- KẾT THÚC NỘI DUNG QUẢN LÝ THÔNG BÁO STAFF -->
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
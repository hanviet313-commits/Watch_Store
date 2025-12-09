<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý khiếu nại - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/staff/css/staff.css" rel="stylesheet">

</head>
<body>
    <jsp:include page="/staff/includes/navbar.jsp" />
    <div style="display: flex;">
        <jsp:include page="/staff/includes/sidebar.jsp" />
        <div style="flex: 1; padding: 20px;">
            <!-- BẮT ĐẦU NỘI DUNG QUẢN LÝ KHIẾU NẠI STAFF -->
            <div class="container-fluid staff-content">
                <div class="container-fluid">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Quản lý khiếu nại</h2>
                        <div>
                            <button class="btn btn-outline-secondary" onclick="window.location.reload();">
                                <i class="bi bi-arrow-clockwise"></i> Làm mới
                            </button>
                        </div>
                    </div>
                    
                    <!-- Hiển thị thông báo nếu có -->
                    <c:if test="${not empty param.msg}">
                        <c:choose>
                            <c:when test="${param.msg eq 'success'}">
                                <div class="alert alert-success alert-dismissible fade show">
                                    <i class="bi bi-check-circle-fill me-2"></i> Cập nhật khiếu nại thành công!
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:when>
                            <c:when test="${param.msg eq 'error'}">
                                <div class="alert alert-danger alert-dismissible fade show">
                                    <i class="bi bi-exclamation-triangle-fill me-2"></i> Có lỗi xảy ra khi cập nhật khiếu nại!
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:when>
                            <c:when test="${param.msg eq 'not_found'}">
                                <div class="alert alert-warning alert-dismissible fade show">
                                    <i class="bi bi-exclamation-circle-fill me-2"></i> Không tìm thấy khiếu nại!
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:when>
                        </c:choose>
                    </c:if>
                    
                    <!-- Bộ lọc -->
                    <div class="card staff-card mb-4">
                        <div class="card-header bg-dark text-white">
                            <h5 class="mb-0">Bộ lọc</h5>
                        </div>
                        <div class="card-body">
                            <form method="get" action="${pageContext.request.contextPath}/staff/complaints" class="row g-3">
                                <div class="col-md-3">
                                    <label for="filterStatus" class="form-label">Trạng thái</label>
                                    <select id="filterStatus" name="status" class="form-select">
                                        <option value="">Tất cả</option>
                                        <option value="Đang chờ" ${param.status eq 'Đang chờ' ? 'selected' : ''}>Đang chờ</option>
                                        <option value="Đang xử lý" ${param.status eq 'Đang xử lý' ? 'selected' : ''}>Đang xử lý</option>
                                        <option value="Đã xử lý" ${param.status eq 'Đã xử lý' ? 'selected' : ''}>Đã xử lý</option>
                                        <option value="Từ chối" ${param.status eq 'Từ chối' ? 'selected' : ''}>Từ chối</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="filterReturn" class="form-label">Yêu cầu trả hàng</label>
                                    <select id="filterReturn" name="returnRequest" class="form-select">
                                        <option value="">Tất cả</option>
                                        <option value="true" ${param.returnRequest eq 'true' ? 'selected' : ''}>Có</option>
                                        <option value="false" ${param.returnRequest eq 'false' ? 'selected' : ''}>Không</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="searchTerm" class="form-label">Tìm kiếm</label>
                                    <input type="text" class="form-control" id="searchTerm" name="search" 
                                           placeholder="Tìm theo ID, khách hàng, đơn hàng..." value="${param.search}">
                                </div>
                                <div class="col-md-2 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i class="bi bi-search me-1"></i> Lọc
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Thêm debug info ở đầu trang -->
                    <%-- Debug info --%>
                    <c:if test="${not empty complaints}">
                        <div class="d-none">
                            <p>Number of complaints: ${complaints.size()}</p>
                            <c:forEach var="kn" items="${complaints}" varStatus="status">
                                <p>Complaint ${status.index}: ID=${kn.idKhieuNai}, User=${kn.tenNguoiDung}</p>
                            </c:forEach>
                        </div>
                    </c:if>

                    <div class="card staff-card">
                        <div class="card-header bg-dark text-white">
                            <h5 class="mb-0">Danh sách khiếu nại</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table staff-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Khách hàng</th>
                                            <th>Đơn hàng</th>
                                            <th>Nội dung</th>
                                            <th>Ngày gửi</th>
                                            <th>Trạng thái</th>
                                            <th>Yêu cầu trả hàng</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty complaints}">
                                                <c:forEach var="kn" items="${complaints}">
                                                    <tr>
                                                        <td>${kn.idKhieuNai}</td>
                                                        <td>${kn.tenNguoiDung}</td>
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/staff/orders?id=${kn.idDonHang}" 
                                                               class="text-decoration-none">#${kn.idDonHang}</a>
                                                        </td>
                                                        <td class="complaint-content" title="${kn.noiDung}">${kn.noiDung}</td>
                                                        <td><fmt:formatDate value="${kn.ngayGui}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${kn.trangThai eq 'Đang chờ'}">
                                                                    <span class="badge bg-warning text-dark">${kn.trangThai}</span>
                                                                </c:when>
                                                                <c:when test="${kn.trangThai eq 'Đang xử lý'}">
                                                                    <span class="badge bg-info">${kn.trangThai}</span>
                                                                </c:when>
                                                                <c:when test="${kn.trangThai eq 'Đã xử lý'}">
                                                                    <span class="badge bg-success">${kn.trangThai}</span>
                                                                </c:when>
                                                                <c:when test="${kn.trangThai eq 'Từ chối'}">
                                                                    <span class="badge bg-danger">${kn.trangThai}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">${kn.trangThai}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:if test="${kn.yeuCauTraHang}">
                                                                <span class="badge bg-danger">Yêu cầu trả hàng</span>
                                                            </c:if>
                                                            <c:if test="${!kn.yeuCauTraHang}">
                                                                <span class="badge bg-secondary">Không</span>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <button type="button" class="btn btn-primary btn-sm" 
                                                                    data-bs-toggle="modal" 
                                                                    data-bs-target="#updateModal${kn.idKhieuNai}">
                                                                <i class="bi bi-pencil-square"></i> Xử lý
                                                            </button>
                                                        </td>
                                                    </tr>
                                                    
                                                    <!-- Modal cập nhật trạng thái -->
                                                    <div class="modal fade" id="updateModal${kn.idKhieuNai}" tabindex="-1" aria-hidden="true">
                                                        <div class="modal-dialog modal-lg">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title">Cập nhật khiếu nại #${kn.idKhieuNai}</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <form action="${pageContext.request.contextPath}/staff/complaints" method="post">
                                                                    <div class="modal-body">
                                                                        <input type="hidden" name="action" value="update">
                                                                        <input type="hidden" name="idKhieuNai" value="${kn.idKhieuNai}">
                                                                        
                                                                        <!-- Hiển thị thông tin khiếu nại -->
                                                                        <div class="row mb-3">
                                                                            <div class="col-md-6">
                                                                                <h6 class="fw-bold">Thông tin khiếu nại</h6>
                                                                                <p><strong>Khách hàng:</strong> ${kn.tenNguoiDung}</p>
                                                                                <p><strong>Đơn hàng:</strong> #${kn.idDonHang}</p>
                                                                                <p><strong>Ngày gửi:</strong> <fmt:formatDate value="${kn.ngayGui}" pattern="dd/MM/yyyy HH:mm" /></p>
                                                                            </div>
                                                                            <div class="col-md-6">
                                                                                <h6 class="fw-bold">Trạng thái hiện tại</h6>
                                                                                <p>
                                                                                    <strong>Trạng thái:</strong> 
                                                                                    <c:choose>
                                                                                        <c:when test="${kn.trangThai eq 'Đang chờ'}">
                                                                                            <span class="badge bg-warning text-dark">${kn.trangThai}</span>
                                                                                        </c:when>
                                                                                        <c:when test="${kn.trangThai eq 'Đang xử lý'}">
                                                                                            <span class="badge bg-info">${kn.trangThai}</span>
                                                                                        </c:when>
                                                                                        <c:when test="${kn.trangThai eq 'Đã xử lý'}">
                                                                                            <span class="badge bg-success">${kn.trangThai}</span>
                                                                                        </c:when>
                                                                                        <c:when test="${kn.trangThai eq 'Từ chối'}">
                                                                                            <span class="badge bg-danger">${kn.trangThai}</span>
                                                                                        </c:when>
                                                                                    </c:choose>
                                                                                </p>
                                                                                <p>
                                                                                    <strong>Yêu cầu trả hàng:</strong> 
                                                                                    <c:if test="${kn.yeuCauTraHang}">
                                                                                        <span class="badge bg-danger">Có</span>
                                                                                    </c:if>
                                                                                    <c:if test="${!kn.yeuCauTraHang}">
                                                                                        <span class="badge bg-secondary">Không</span>
                                                                                    </c:if>
                                                                                </p>
                                                                            </div>
                                                                        </div>
                                                                        
                                                                        <div class="mb-3">
                                                                            <label class="form-label fw-bold">Nội dung khiếu nại:</label>
                                                                            <div class="p-3 bg-light rounded">
                                                                                ${kn.noiDung}
                                                                            </div>
                                                                        </div>
                                                                        
                                                                        <c:if test="${kn.yeuCauTraHang}">
                                                                            <div class="alert alert-warning">
                                                                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                                                                <strong>Lưu ý:</strong> Khách hàng yêu cầu trả hàng/hoàn tiền. 
                                                                                Nếu bạn chọn "Đã xử lý", đơn hàng sẽ được chuyển sang trạng thái "Đã trả hàng".
                                                                            </div>
                                                                        </c:if>
                                                                        
                                                                        <div class="mb-3">
                                                                            <label for="trangThai${kn.idKhieuNai}" class="form-label fw-bold">Cập nhật trạng thái:</label>
                                                                            <select id="trangThai${kn.idKhieuNai}" name="trangThai" class="form-select" required>
                                                                                <option value="Đang chờ" ${kn.trangThai eq 'Đang chờ' ? 'selected' : ''}>Đang chờ</option>
                                                                                <option value="Đang xử lý" ${kn.trangThai eq 'Đang xử lý' ? 'selected' : ''}>Đang xử lý</option>
                                                                                <option value="Đã xử lý" ${kn.trangThai eq 'Đã xử lý' ? 'selected' : ''}>Đã xử lý</option>
                                                                                <option value="Từ chối" ${kn.trangThai eq 'Từ chối' ? 'selected' : ''}>Từ chối</option>
                                                                            </select>
                                                                        </div>
                                                                        
                                                                        <div class="mb-3">
                                                                            <label for="phanHoi${kn.idKhieuNai}" class="form-label fw-bold">Phản hồi cho khách hàng:</label>
                                                                            <textarea id="phanHoi${kn.idKhieuNai}" name="phanHoi" class="form-control" rows="4"
                                                                                      placeholder="Nhập phản hồi của bạn cho khách hàng...">${kn.phanHoi}</textarea>
                                                                            <div class="form-text">Phản hồi này sẽ được hiển thị cho khách hàng khi họ xem chi tiết khiếu nại.</div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                                                            <i class="bi bi-x-circle me-1"></i> Đóng
                                                                        </button>
                                                                        <button type="submit" class="btn btn-primary">
                                                                            <i class="bi bi-check-circle me-1"></i> Lưu thay đổi
                                                                        </button>
                                                                    </div>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr><td colspan="8" class="text-center">Không có khiếu nại nào.</td></tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- KẾT THÚC NỘI DUNG QUẢN LÝ KHIẾU NẠI STAFF -->
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Tự động đóng thông báo sau 5 giây
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function(alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);
        });
    </script>
</body>
</html> 

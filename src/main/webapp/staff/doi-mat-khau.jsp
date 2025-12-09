<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.watchstore.model.NguoiDung" %>
<%
    NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Đổi mật khẩu - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/staff/css/staff.css" rel="stylesheet">
    <style>
        .password-container {
            max-width: 500px;
            margin: 40px auto;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.15);
            padding: 30px;
        }
        .form-control:focus {
            border-color: #6c757d;
            box-shadow: 0 0 0 0.25rem rgba(108,117,125,0.25);
        }
        .password-feedback {
            display: none;
            font-size: 0.875em;
        }
        .password-feedback.show {
            display: block;
        }
        .password-match { color: #198754; }
        .password-mismatch { color: #dc3545; }
    </style>
</head>
<body>
<jsp:include page="/staff/includes/navbar.jsp"/>
<div style="display: flex;">
    <jsp:include page="/staff/includes/sidebar.jsp"/>
    <div style="flex: 1; padding: 40px 0;">
        <div class="password-container">
            <div class="d-flex align-items-center mb-4">
                <i class="fas fa-key fa-2x text-primary me-2"></i>
                <h2 class="mb-0">Đổi mật khẩu</h2>
            </div>
            <% if (error != null) { %>
                <div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i><%= error %></div>
            <% } %>
            <% if (success != null) { %>
                <div class="alert alert-success"><i class="fas fa-check-circle me-2"></i><%= success %></div>
            <% } %>
            <form action="${pageContext.request.contextPath}/doi-mat-khau" method="post" id="changePasswordForm">
                <div class="mb-3">
                    <label for="matKhauCu" class="form-label"><i class="fas fa-lock me-1"></i> Mật khẩu hiện tại</label>
                    <input type="password" class="form-control" id="matKhauCu" name="matKhauCu" required>
                </div>
                <div class="mb-3">
                    <label for="matKhauMoi" class="form-label"><i class="fas fa-key me-1"></i> Mật khẩu mới</label>
                    <input type="password" class="form-control" id="matKhauMoi" name="matKhauMoi" required>
                    <div class="form-text">Mật khẩu nên có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số.</div>
                </div>
                <div class="mb-4">
                    <label for="xacNhanMatKhau" class="form-label"><i class="fas fa-check-double me-1"></i> Xác nhận mật khẩu mới</label>
                    <input type="password" class="form-control" id="xacNhanMatKhau" name="xacNhanMatKhau" required>
                    <div id="passwordFeedback" class="password-feedback mt-1">
                        <i class="fas fa-times-circle me-1"></i>Mật khẩu không khớp
                    </div>
                </div>
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-check me-2"></i>Đổi mật khẩu</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Kiểm tra mật khẩu khớp nhau
    document.addEventListener('DOMContentLoaded', function() {
        const matKhauMoi = document.getElementById('matKhauMoi');
        const xacNhanMatKhau = document.getElementById('xacNhanMatKhau');
        const feedback = document.getElementById('passwordFeedback');
        const form = document.getElementById('changePasswordForm');
        function checkPasswordMatch() {
            if (xacNhanMatKhau.value === '') {
                feedback.classList.remove('show', 'password-match', 'password-mismatch');
                return;
            }
            if (matKhauMoi.value === xacNhanMatKhau.value) {
                feedback.classList.add('show', 'password-match');
                feedback.classList.remove('password-mismatch');
                feedback.innerHTML = '<i class="fas fa-check-circle me-1"></i>Mật khẩu khớp';
            } else {
                feedback.classList.add('show', 'password-mismatch');
                feedback.classList.remove('password-match');
                feedback.innerHTML = '<i class="fas fa-times-circle me-1"></i>Mật khẩu không khớp';
            }
        }
        matKhauMoi.addEventListener('input', checkPasswordMatch);
        xacNhanMatKhau.addEventListener('input', checkPasswordMatch);
        form.addEventListener('submit', function(event) {
            if (matKhauMoi.value !== xacNhanMatKhau.value) {
                event.preventDefault();
                feedback.classList.add('show', 'password-mismatch');
                feedback.classList.remove('password-match');
                feedback.innerHTML = '<i class="fas fa-times-circle me-1"></i>Mật khẩu không khớp';
                xacNhanMatKhau.focus();
            }
        });
    });
</script>
</body>
</html> 
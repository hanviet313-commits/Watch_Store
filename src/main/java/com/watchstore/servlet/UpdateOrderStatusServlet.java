package com.watchstore.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/staff/orders/update-status")
public class UpdateOrderStatusServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Cấu hình encoding UTF-8
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        
        String orderId = req.getParameter("orderId");
        String status = req.getParameter("status");
        String message = null;
        if (orderId == null || status == null || orderId.isEmpty() || status.isEmpty()) {
            message = "Thiếu thông tin đơn hàng hoặc trạng thái.";
        } else {
            try (Connection conn = com.watchstore.util.CSDLUtill.getConnection()) {
                String sql = "UPDATE don_hang SET trang_thai = ? WHERE id_don_hang = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, status);
                    stmt.setInt(2, Integer.parseInt(orderId));
                    int updated = stmt.executeUpdate();
                    if (updated > 0) {
                        message = "Cập nhật trạng thái thành công!";
                    } else {
                        message = "Không tìm thấy đơn hàng để cập nhật.";
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                message = "Lỗi khi cập nhật trạng thái: " + e.getMessage();
            }
        }
        req.getSession().setAttribute("orderStatusMessage", message);
        resp.sendRedirect(req.getContextPath() + "/staff/orders");
    }
} 
package com.watchstore.servlet;
import com.watchstore.dao.DonHangDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/staff/orders")
public class StaffOrdersServlet extends HttpServlet {
    private DonHangDAO donHangDAO = new DonHangDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        
        // Kiểm tra thông báo từ session (nếu có)
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("orderStatusMessage") != null) {
            req.setAttribute("statusMessage", session.getAttribute("orderStatusMessage"));
            session.removeAttribute("orderStatusMessage");
        }
        
        // Lấy tham số lọc (nếu có)
        String statusFilter = req.getParameter("status");
        
        List<Object[]> orders = new ArrayList<>();
        try {
            StringBuilder sqlBuilder = new StringBuilder(
                "SELECT dh.id_don_hang, nd.ten_day_du, dh.ngay_dat, dh.tong_tien, dh.trang_thai " +
                "FROM don_hang dh JOIN nguoi_dung nd ON dh.id_nguoi_dung = nd.id_nguoi_dung ");
            
            // Thêm điều kiện lọc nếu có
            if (statusFilter != null && !statusFilter.isEmpty()) {
                sqlBuilder.append("WHERE dh.trang_thai = ? ");
            }
            
            sqlBuilder.append("ORDER BY dh.ngay_dat DESC");
            
            try (Connection conn = com.watchstore.util.CSDLUtill.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sqlBuilder.toString())) {
                
                // Thiết lập tham số nếu có lọc
                if (statusFilter != null && !statusFilter.isEmpty()) {
                    stmt.setString(1, statusFilter);
                }
                
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Object[] order = new Object[5];
                        order[0] = rs.getInt("id_don_hang");
                        order[1] = rs.getString("ten_day_du");
                        order[2] = rs.getTimestamp("ngay_dat");
                        order[3] = rs.getBigDecimal("tong_tien");
                        order[4] = rs.getString("trang_thai");
                        orders.add(order);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", e.getMessage());
        }
        
        // Lấy danh sách các trạng thái đơn hàng để hiển thị bộ lọc
        List<String> orderStatuses = Arrays.asList("Chờ xác nhận", "Đang xử lý", "Đang giao", "Hoàn thành", "Đã hủy");
        req.setAttribute("orderStatuses", orderStatuses);
        req.setAttribute("currentFilter", statusFilter);
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/staff/orders.jsp").forward(req, resp);
    }
} 

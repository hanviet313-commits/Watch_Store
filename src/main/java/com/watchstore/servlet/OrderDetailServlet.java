package com.watchstore.servlet;

import com.watchstore.dao.DonHangDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/staff/orders/view")
public class OrderDetailServlet extends HttpServlet {
    private DonHangDAO donHangDAO = new DonHangDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        
        String orderId = req.getParameter("id");
        if (orderId == null || orderId.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Không tìm thấy mã đơn hàng");
            req.getRequestDispatcher("/staff/orders.jsp").forward(req, resp);
            return;
        }

        try {
            // Lấy thông tin đơn hàng và người nhận
            String orderSql = "SELECT dh.*, nd.ten_day_du, nd.email, nd.sdt as sdt_khach " +
                            "FROM don_hang dh " +
                            "JOIN nguoi_dung nd ON dh.id_nguoi_dung = nd.id_nguoi_dung " +
                            "WHERE dh.id_don_hang = ?";
            // Lấy chi tiết sản phẩm trong đơn hàng
            String itemsSql = "SELECT spd.*, sp.ten_san_pham, sp.url_anh " +
                            "FROM san_pham_trong_don spd " +
                            "JOIN san_pham sp ON spd.id_san_pham = sp.id_san_pham " +
                            "WHERE spd.id_don_hang = ?";

            try (Connection conn = com.watchstore.util.CSDLUtill.getConnection()) {
                // Lấy thông tin đơn hàng
                try (PreparedStatement orderStmt = conn.prepareStatement(orderSql)) {
                    orderStmt.setInt(1, Integer.parseInt(orderId));
                    try (ResultSet rs = orderStmt.executeQuery()) {
                        if (rs.next()) {
                            Map<String, Object> order = new HashMap<>();
                            order.put("id", rs.getInt("id_don_hang"));
                            order.put("customerName", rs.getString("ten_day_du"));
                            order.put("email", rs.getString("email"));
                            order.put("customerPhone", rs.getString("sdt_khach"));
                            order.put("orderDate", rs.getTimestamp("ngay_dat"));
                            order.put("status", rs.getString("trang_thai"));
                            order.put("totalAmount", rs.getBigDecimal("tong_tien"));
                            order.put("address", rs.getString("dia_chi"));
                            order.put("receiverPhone", rs.getString("sdt_nguoi_nhan"));
                            req.setAttribute("order", order);
                        } else {
                            req.setAttribute("errorMessage", "Không tìm thấy đơn hàng với mã " + orderId);
                            req.getRequestDispatcher("/staff/orders.jsp").forward(req, resp);
                            return;
                        }
                    }
                }
                
                // Lấy chi tiết sản phẩm
                List<Map<String, Object>> orderItems = new ArrayList<>();
                try (PreparedStatement itemsStmt = conn.prepareStatement(itemsSql)) {
                    itemsStmt.setInt(1, Integer.parseInt(orderId));
                    try (ResultSet rs = itemsStmt.executeQuery()) {
                        while (rs.next()) {
                            Map<String, Object> item = new HashMap<>();
                            item.put("productId", rs.getInt("id_san_pham"));
                            item.put("productName", rs.getString("ten_san_pham"));
                            item.put("image", rs.getString("url_anh"));
                            item.put("quantity", rs.getInt("so_luong"));
                            item.put("price", rs.getBigDecimal("don_gia"));
                            item.put("subtotal", rs.getBigDecimal("don_gia").multiply(new java.math.BigDecimal(rs.getInt("so_luong"))));
                            orderItems.add(item);
                        }
                    }
                }
                req.setAttribute("orderItems", orderItems);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ: " + orderId);
            req.getRequestDispatcher("/staff/orders.jsp").forward(req, resp);
            return;
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Lỗi khi lấy thông tin đơn hàng: " + e.getMessage());
        }

        req.getRequestDispatcher("/staff/order-detail.jsp").forward(req, resp);
    }
} 

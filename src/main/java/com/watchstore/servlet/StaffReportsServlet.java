package com.watchstore.servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/staff/reports")
public class StaffReportsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Cấu hình encoding UTF-8
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        
        String reportType = req.getParameter("type");
        if (reportType == null) {
            reportType = "sales"; // Mặc định là báo cáo doanh số
        }
        
        try {
            switch (reportType) {
                case "sales":
                    loadSalesReport(req);
                    break;
                case "products":
                    loadProductReport(req);
                    break;
                case "orders":
                    loadOrderReport(req);
                    break;
                case "customers":
                    loadCustomerReport(req);
                    break;
                default:
                    loadSalesReport(req);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Lỗi khi tải báo cáo: " + e.getMessage());
        }
        
        req.setAttribute("currentReport", reportType);
        req.getRequestDispatcher("/staff/reports.jsp").forward(req, resp);
    }
    
    private void loadSalesReport(HttpServletRequest req) throws SQLException {
        // Báo cáo doanh số theo tháng
        List<Map<String, Object>> monthlySales = new ArrayList<>();
        String sql = "SELECT MONTH(ngay_dat) as thang, YEAR(ngay_dat) as nam, " +
                    "SUM(tong_tien) as doanh_thu, COUNT(*) as so_don " +
                    "FROM don_hang WHERE trang_thai = 'Hoàn thành' " +
                    "GROUP BY MONTH(ngay_dat), YEAR(ngay_dat) " +
                    "ORDER BY nam DESC, thang DESC";
        
        try (Connection conn = com.watchstore.util.CSDLUtill.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> month = new HashMap<>();
                month.put("thang", rs.getInt("thang"));
                month.put("nam", rs.getInt("nam"));
                month.put("doanh_thu", rs.getBigDecimal("doanh_thu"));
                month.put("so_don", rs.getInt("so_don"));
                monthlySales.add(month);
            }
        }
        
        // Tổng doanh thu
        double totalRevenue = 0;
        int totalOrders = 0;
        try (Connection conn = com.watchstore.util.CSDLUtill.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(
                "SELECT SUM(tong_tien) as total_revenue, COUNT(*) as total_orders " +
                "FROM don_hang WHERE trang_thai = 'Hoàn thành'")) {
            
            if (rs.next()) {
                totalRevenue = rs.getDouble("total_revenue");
                totalOrders = rs.getInt("total_orders");
            }
        }
        
        req.setAttribute("monthlySales", monthlySales);
        req.setAttribute("totalRevenue", totalRevenue);
        req.setAttribute("totalOrders", totalOrders);
    }
    
    private void loadProductReport(HttpServletRequest req) throws SQLException {
        // Báo cáo sản phẩm bán chạy
        List<Map<String, Object>> topProducts = new ArrayList<>();
        String sql = "SELECT sp.ten_san_pham, sp.nha_san_xuat, " +
                    "SUM(spd.so_luong) as tong_ban, " +
                    "SUM(spd.so_luong * spd.don_gia) as doanh_thu " +
                    "FROM san_pham_trong_don spd " +
                    "JOIN san_pham sp ON spd.id_san_pham = sp.id_san_pham " +
                    "JOIN don_hang dh ON spd.id_don_hang = dh.id_don_hang " +
                    "WHERE dh.trang_thai = 'Hoàn thành' " +
                    "GROUP BY sp.id_san_pham, sp.ten_san_pham, sp.nha_san_xuat " +
                    "ORDER BY tong_ban DESC LIMIT 10";
        
        try (Connection conn = com.watchstore.util.CSDLUtill.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("ten_san_pham", rs.getString("ten_san_pham"));
                product.put("nha_san_xuat", rs.getString("nha_san_xuat"));
                product.put("tong_ban", rs.getInt("tong_ban"));
                product.put("doanh_thu", rs.getBigDecimal("doanh_thu"));
                topProducts.add(product);
            }
        }
        
        req.setAttribute("topProducts", topProducts);
    }
    
    private void loadOrderReport(HttpServletRequest req) throws SQLException {
        // Báo cáo đơn hàng theo trạng thái
        List<Map<String, Object>> orderStatus = new ArrayList<>();
        String sql = "SELECT trang_thai, COUNT(*) as so_luong, SUM(tong_tien) as tong_tien " +
                    "FROM don_hang GROUP BY trang_thai";
        
        try (Connection conn = com.watchstore.util.CSDLUtill.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> status = new HashMap<>();
                status.put("trang_thai", rs.getString("trang_thai"));
                status.put("so_luong", rs.getInt("so_luong"));
                status.put("tong_tien", rs.getBigDecimal("tong_tien"));
                orderStatus.add(status);
            }
        }
        
        req.setAttribute("orderStatus", orderStatus);
    }
    
    private void loadCustomerReport(HttpServletRequest req) throws SQLException {
        // Báo cáo khách hàng
        List<Map<String, Object>> topCustomers = new ArrayList<>();
        String sql = "SELECT nd.ten_day_du, nd.email, " +
                    "COUNT(dh.id_don_hang) as so_don, " +
                    "SUM(dh.tong_tien) as tong_tien " +
                    "FROM nguoi_dung nd " +
                    "JOIN don_hang dh ON nd.id_nguoi_dung = dh.id_nguoi_dung " +
                    "WHERE nd.vai_tro = 'customer' " +
                    "GROUP BY nd.id_nguoi_dung, nd.ten_day_du, nd.email " +
                    "ORDER BY tong_tien DESC LIMIT 10";
        
        try (Connection conn = com.watchstore.util.CSDLUtill.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> customer = new HashMap<>();
                customer.put("ten_day_du", rs.getString("ten_day_du"));
                customer.put("email", rs.getString("email"));
                customer.put("so_don", rs.getInt("so_don"));
                customer.put("tong_tien", rs.getBigDecimal("tong_tien"));
                topCustomers.add(customer);
            }
        }
        
        req.setAttribute("topCustomers", topCustomers);
    }
} 
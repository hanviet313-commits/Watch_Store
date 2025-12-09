package com.watchstore.controller;

import com.watchstore.dao.DonHangDAO;
import com.watchstore.model.NguoiDung;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/huy-don-hang")
public class HuyDonHangServlet extends HttpServlet {
    private DonHangDAO donHangDAO = new DonHangDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }
    
    private void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        
        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("nguoiDung") == null) {
            System.out.println("Người dùng chưa đăng nhập, chuyển hướng đến trang đăng nhập");
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        
        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        String message = "";
        
        try {
            // Lấy ID đơn hàng từ request
            String idDonHangStr = req.getParameter("idDonHang");
            System.out.println("Nhận yêu cầu hủy đơn hàng với ID: " + idDonHangStr);
            
            if (idDonHangStr == null || idDonHangStr.trim().isEmpty()) {
                System.out.println("ID đơn hàng không hợp lệ: null hoặc rỗng");
                message = "invalid";
            } else {
                int idDonHang = Integer.parseInt(idDonHangStr);
                System.out.println("Người dùng #" + nguoiDung.getIdNguoiDung() + " đang cố gắng hủy đơn hàng #" + idDonHang);
                
                // Gọi phương thức hủy đơn hàng
                boolean success = donHangDAO.cancelOrder(idDonHang, nguoiDung.getIdNguoiDung());
                
                if (success) {
                    // Hoàn lại số lượng tồn kho cho các sản phẩm trong đơn hàng
                    com.watchstore.dao.SanPhamDAO spDao = new com.watchstore.dao.SanPhamDAO();
                    java.sql.Connection conn = null;
                    try {
                        conn = com.watchstore.util.CSDLUtill.getConnection();
                        String sql = "SELECT id_san_pham, so_luong FROM san_pham_trong_don WHERE id_don_hang = ?";
                        try (java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, idDonHang);
                            try (java.sql.ResultSet rs = ps.executeQuery()) {
                                while (rs.next()) {
                                    int idSanPham = rs.getInt("id_san_pham");
                                    int soLuong = rs.getInt("so_luong");
                                    // Lấy số lượng tồn kho hiện tại
                                    com.watchstore.model.SanPham sp = spDao.getSanPhamById(idSanPham);
                                    if (sp != null) {
                                        int soLuongMoi = sp.getSoLuongTon() + soLuong;
                                        spDao.capNhatTonKho(idSanPham, soLuongMoi);
                                    }
                                }
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (conn != null) try { conn.close(); } catch (Exception ignore) {}
                    }
                    System.out.println("Hủy đơn hàng thành công và đã hoàn lại tồn kho");
                    message = "success";
                } else {
                    System.out.println("Hủy đơn hàng thất bại");
                    message = "error";
                }
            }
        } catch (NumberFormatException e) {
            System.out.println("Lỗi định dạng số: " + e.getMessage());
            message = "invalid";
        } catch (Exception e) {
            System.out.println("Lỗi không xác định: " + e.getMessage());
            e.printStackTrace();
            message = "error";
        }
        
        // Chuyển hướng về trang danh sách đơn hàng với thông báo
        System.out.println("Chuyển hướng đến trang danh sách đơn hàng với thông báo: " + message);
        resp.sendRedirect(req.getContextPath() + "/don-hang?msg=" + message);
    }
}





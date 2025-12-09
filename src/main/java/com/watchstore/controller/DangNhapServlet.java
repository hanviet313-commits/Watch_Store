package com.watchstore.controller;
import com.watchstore.dao.NguoiDungDAO;
import com.watchstore.model.NguoiDung;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/dang-nhap")
public class DangNhapServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        
        // Không mã hóa mật khẩu nữa
        // String hashedPassword = MaHoaMatKhauUtil.hashMD5(password);
        
        NguoiDungDAO ndDAO = new NguoiDungDAO();
        NguoiDung nguoiDung = ndDAO.checkLogin(email, password);
        
        if (nguoiDung != null) {
            HttpSession session = req.getSession();
            session.setAttribute("nguoiDung", nguoiDung);

            // Gộp giỏ hàng session vào giỏ hàng user
            com.watchstore.dao.GioHangDAO gioHangDAO = new com.watchstore.dao.GioHangDAO();
            com.watchstore.model.GioHang gioHangSession = (com.watchstore.model.GioHang) session.getAttribute("cart");
            if (gioHangSession != null && gioHangSession.getItems() != null && !gioHangSession.getItems().isEmpty()) {
                for (com.watchstore.model.ChiTietGioHang item : gioHangSession.getItems()) {
                    gioHangDAO.addToCart(nguoiDung.getIdNguoiDung(), item.getIdSanPham(), item.getSoLuong());
                }
            }
            // Lấy lại giỏ hàng mới nhất từ DB và lưu vào session
            com.watchstore.model.GioHang gioHangMoi = gioHangDAO.getByUserId(nguoiDung.getIdNguoiDung());
            session.setAttribute("cart", gioHangMoi);
            
            // Kiểm tra URL trả về từ session
            String returnUrl = (String) session.getAttribute("returnUrl");
            if (returnUrl != null) {
                session.removeAttribute("returnUrl"); // Xóa URL khỏi session
                resp.sendRedirect(returnUrl);
                return;
            }
            
            // Nếu không có URL trả về, chuyển hướng mặc định theo vai trò
            if (nguoiDung.getVaiTro().equals("admin")) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else if (nguoiDung.getVaiTro().equals("staff")) {
                resp.sendRedirect(req.getContextPath() + "/staff/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/");
            }
            return;
        } else {
            req.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            req.getRequestDispatcher("/views/auth/dang_nhap.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        // Kiểm tra nếu đã đăng nhập thì chuyển hướng
        HttpSession session = req.getSession();
        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        
        if (nguoiDung != null) {
            if (nguoiDung.getVaiTro().equals("admin")) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else if (nguoiDung.getVaiTro().equals("staff")) {
                resp.sendRedirect(req.getContextPath() + "/staff/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/");
            }
            return;
        }
        
        req.getRequestDispatcher("/views/auth/dang_nhap.jsp").forward(req, resp);
    }
}


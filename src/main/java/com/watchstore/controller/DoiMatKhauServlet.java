package com.watchstore.controller;

import com.watchstore.dao.NguoiDungDAO;
import com.watchstore.model.NguoiDung;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/doi-mat-khau")
public class DoiMatKhauServlet extends HttpServlet {
    private NguoiDungDAO ndDAO = new NguoiDungDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra đăng nhập
        HttpSession session = req.getSession(false);
        NguoiDung nd = (NguoiDung) (session != null ? session.getAttribute("nguoiDung") : null);
        if (nd == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        // Phân biệt vai trò để forward đúng giao diện
        if ("staff".equals(nd.getVaiTro()) || "admin".equals(nd.getVaiTro())) {
            req.getRequestDispatcher("/staff/doi-mat-khau.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/views/khach_hang/doi_mat_khau.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        
        // Kiểm tra đăng nhập
        HttpSession session = req.getSession(false);
        NguoiDung nd = (NguoiDung) (session != null ? session.getAttribute("nguoiDung") : null);
        if (nd == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        
        // Lấy thông tin từ form
        String matKhauCu = req.getParameter("matKhauCu");
        String matKhauMoi = req.getParameter("matKhauMoi");
        String xacNhanMatKhau = req.getParameter("xacNhanMatKhau");
        
        // Kiểm tra mật khẩu mới và xác nhận mật khẩu
        if (!matKhauMoi.equals(xacNhanMatKhau)) {
            req.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp");
            if ("staff".equals(nd.getVaiTro()) || "admin".equals(nd.getVaiTro())) {
                req.getRequestDispatcher("/staff/doi-mat-khau.jsp").forward(req, resp);
            } else {
                req.getRequestDispatcher("/views/khach_hang/doi_mat_khau.jsp").forward(req, resp);
            }
            return;
        }
        
        // Kiểm tra độ dài mật khẩu
        if (matKhauMoi.length() < 8) {
            req.setAttribute("error", "Mật khẩu mới phải có ít nhất 8 ký tự");
            if ("staff".equals(nd.getVaiTro()) || "admin".equals(nd.getVaiTro())) {
                req.getRequestDispatcher("/staff/doi-mat-khau.jsp").forward(req, resp);
            } else {
                req.getRequestDispatcher("/views/khach_hang/doi_mat_khau.jsp").forward(req, resp);
            }
            return;
        }
        
        // Kiểm tra mật khẩu cũ
        if (!ndDAO.checkPassword(nd.getIdNguoiDung(), matKhauCu)) {
            req.setAttribute("error", "Mật khẩu cũ không đúng");
            if ("staff".equals(nd.getVaiTro()) || "admin".equals(nd.getVaiTro())) {
                req.getRequestDispatcher("/staff/doi-mat-khau.jsp").forward(req, resp);
            } else {
                req.getRequestDispatcher("/views/khach_hang/doi_mat_khau.jsp").forward(req, resp);
            }
            return;
        }
        
        // Cập nhật mật khẩu
        if (ndDAO.updatePassword(nd.getIdNguoiDung(), matKhauMoi)) {
            req.setAttribute("success", "Đổi mật khẩu thành công");
        } else {
            req.setAttribute("error", "Đổi mật khẩu thất bại");
        }
        
        if ("staff".equals(nd.getVaiTro()) || "admin".equals(nd.getVaiTro())) {
            req.getRequestDispatcher("/staff/doi-mat-khau.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/views/khach_hang/doi_mat_khau.jsp").forward(req, resp);
        }
    }
}


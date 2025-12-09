package com.watchstore.controller;

import com.watchstore.model.NguoiDung;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/phan-quyen")
public class PhanQuyenServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        if (nguoiDung == null || !"admin".equals(nguoiDung.getVaiTro())) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        // Lấy danh sách người dùng để hiển thị trên trang phân quyền
        java.util.List<com.watchstore.model.NguoiDung> users = new com.watchstore.dao.NguoiDungDAO().getAllUsers();
        req.setAttribute("users", users);
        req.getRequestDispatcher("/admin/phan_quyen.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        if (nguoiDung == null || !"admin".equals(nguoiDung.getVaiTro())) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        String idStr = req.getParameter("idNguoiDung");
        String vaiTro = req.getParameter("vaiTro");
        String message = null;
        if (idStr != null && vaiTro != null) {
            try {
                int id = Integer.parseInt(idStr);
                com.watchstore.dao.NguoiDungDAO dao = new com.watchstore.dao.NguoiDungDAO();
                dao.updateRole(id, vaiTro);
                message = "Cập nhật vai trò thành công!";
            } catch (Exception e) {
                message = "Có lỗi xảy ra khi cập nhật vai trò!";
            }
        }
        // Sau khi đổi vai trò, load lại danh sách người dùng và forward về trang phân quyền
        java.util.List<com.watchstore.model.NguoiDung> users = new com.watchstore.dao.NguoiDungDAO().getAllUsers();
        req.setAttribute("users", users);
        req.setAttribute("message", message);
        req.getRequestDispatcher("/admin/phan_quyen.jsp").forward(req, resp);
    }
} 
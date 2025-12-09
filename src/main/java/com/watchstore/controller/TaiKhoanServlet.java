package com.watchstore.controller;

import com.watchstore.dao.NguoiDungDAO;
import com.watchstore.model.NguoiDung;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/tai-khoan")
public class TaiKhoanServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        NguoiDung nd = (NguoiDung) (session != null ? session.getAttribute("nguoiDung") : null);
        if (nd == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        req.setAttribute("user", nd);
        req.getRequestDispatcher("/views/khach_hang/tai_khoan.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        NguoiDung nd = (NguoiDung) (session != null ? session.getAttribute("nguoiDung") : null);
        if (nd == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        String ten = req.getParameter("tenDayDu");
        String sdt = req.getParameter("sdt");
        nd.setTenDayDu(ten);
        nd.setSdt(sdt);
        new NguoiDungDAO().updateProfile(nd);
        session.setAttribute("nguoiDung", nd);
        req.setAttribute("user", nd);
        req.setAttribute("msg", "Cập nhật thành công!");
        req.getRequestDispatcher("/views/khach_hang/tai_khoan.jsp").forward(req, resp);
    }
} 
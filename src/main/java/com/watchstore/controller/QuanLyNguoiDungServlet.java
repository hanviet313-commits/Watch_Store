
package com.watchstore.controller;

import com.watchstore.dao.NguoiDungDAO;
import com.watchstore.model.NguoiDung;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/quan-ly-nguoi-dung")
public class QuanLyNguoiDungServlet extends HttpServlet {
    private NguoiDungDAO dao = new NguoiDungDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<NguoiDung> ds = dao.getAllUsers();
        req.setAttribute("users", ds);
        req.getRequestDispatcher("/admin/danh_sach_nguoi_dung.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("idNguoiDung"));
        String role = req.getParameter("vaiTro");
        int status = Integer.parseInt(req.getParameter("trangThai"));
        dao.updateRole(id, role);
        dao.updateStatus(id, status);
        resp.sendRedirect(req.getContextPath()+"/admin/quan-ly-nguoi-dung");
    }
}

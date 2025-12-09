
package com.watchstore.controller;

import com.watchstore.dao.SanPhamDAO;
import com.watchstore.model.SanPham;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/nv/quan-ly-san-pham")
public class QuanLySanPhamServlet extends HttpServlet {
    private SanPhamDAO dao = new SanPhamDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<SanPham> ds = dao.getAllSanPham();
        req.setAttribute("products", ds);
        req.getRequestDispatcher("/views/nhan_vien/quan_ly_san_pham.jsp").forward(req, resp);
    }

    // Implement POST for add/edit/delete similarly
}

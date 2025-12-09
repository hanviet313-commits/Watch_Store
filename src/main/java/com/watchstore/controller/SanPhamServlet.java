package com.watchstore.controller;

import com.watchstore.dao.SanPhamDAO;
import com.watchstore.dao.DanhGiaDAO;
import com.watchstore.model.SanPham;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/san-pham")
public class SanPhamServlet extends HttpServlet {
    private SanPhamDAO spDao = new SanPhamDAO();
    private DanhGiaDAO dgDao = new DanhGiaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int idSanPham = Integer.parseInt(req.getParameter("id"));
        SanPham sp = spDao.getSanPhamById(idSanPham);
        if (sp != null) {
            req.setAttribute("sanPham", sp);
            req.setAttribute("danhGiaList", dgDao.getByProduct(idSanPham));
            req.getRequestDispatcher("/views/public/san_pham_chi_tiet.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/?msg=notfound");
        }
    }
} 
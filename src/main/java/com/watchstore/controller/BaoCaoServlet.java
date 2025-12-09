
package com.watchstore.controller;

import com.watchstore.dao.BaoCaoDAO;
import com.watchstore.model.BaoCao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/nv/bao-cao")
public class BaoCaoServlet extends HttpServlet {
    private BaoCaoDAO dao = new BaoCaoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int nam = Integer.parseInt(req.getParameter("nam"));
        List<BaoCao> ds = dao.getMonthlySales(nam);
        req.setAttribute("reports", ds);
        req.getRequestDispatcher("/views/nhan_vien/bao_cao_don_hang.jsp").forward(req, resp);
    }
}

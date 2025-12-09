
package com.watchstore.controller;

import com.watchstore.dao.DonHangDAO;
import com.watchstore.model.DonHang;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/nv/quan-ly-don-hang")
public class QuanLyDonHangServlet extends HttpServlet {
    private DonHangDAO dao = new DonHangDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<DonHang> ds = dao.getAllOrders();
        req.setAttribute("orders", ds);
        req.getRequestDispatcher("/views/nhan_vien/quan_ly_don_hang.jsp").forward(req, resp);
    }

    // handle POST to update status...
}

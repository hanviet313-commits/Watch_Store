package com.watchstore.controller;

import com.watchstore.dao.DanhGiaDAO;
import com.watchstore.model.DanhGia;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/nv/quan-ly-danh-gia")
public class QuanLyDanhGiaServlet extends HttpServlet {
    private DanhGiaDAO dao = new DanhGiaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<DanhGia> ds = dao.getAllReviews();
        System.out.println("Reviews list size in servlet: " + ds.size());
        req.setAttribute("reviews", ds);
        req.getRequestDispatcher("/staff/reviews.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        int idDanhGia = Integer.parseInt(req.getParameter("idDanhGia"));
        
        if ("reply".equals(action)) {
            String reply = req.getParameter("reply");
            if (dao.updateReply(idDanhGia, reply)) {
                resp.sendRedirect(req.getContextPath() + "/nv/quan-ly-danh-gia?msg=reply_success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/nv/quan-ly-danh-gia?msg=reply_error");
            }
        } else if ("toggle".equals(action)) {
            boolean isHidden = Boolean.parseBoolean(req.getParameter("isHidden"));
            if (dao.toggleVisibility(idDanhGia, isHidden)) {
                resp.sendRedirect(req.getContextPath() + "/nv/quan-ly-danh-gia?msg=toggle_success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/nv/quan-ly-danh-gia?msg=toggle_error");
            }
        }
    }
}

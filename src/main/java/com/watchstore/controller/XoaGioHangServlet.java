package com.watchstore.controller;

import com.watchstore.dao.GioHangDAO;
import com.watchstore.model.GioHang;
import com.watchstore.model.NguoiDung;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/xoa-gio-hang")
public class XoaGioHangServlet extends HttpServlet {
    private GioHangDAO ghDao = new GioHangDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        
        try {
            if (session.getAttribute("nguoiDung") == null) {
                // Xóa giỏ hàng trong session
                session.removeAttribute("cart");
            } else {
                // Xóa giỏ hàng trong database
                NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
                GioHang gh = ghDao.getByUser(nd.getIdNguoiDung());
                if (gh != null) {
                    ghDao.clearCart(gh.getIdGioHang());
                }
            }
            resp.sendRedirect(req.getContextPath() + "/gio-hang?msg=cleared");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/gio-hang?msg=error_clearing");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
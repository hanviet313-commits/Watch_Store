package com.watchstore.controller;
import com.watchstore.dao.NguoiDungDAO;
import com.watchstore.model.NguoiDung;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/dang-ky")
public class DangKyServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String ten = req.getParameter("fullname");
        String email = req.getParameter("email");
        String sdt = req.getParameter("phone");
        String pass = req.getParameter("password");
        // Không mã hóa mật khẩu nữa
        // String hashed = MaHoaMatKhauUtil.hashMD5(pass);
        
        NguoiDung nd = new NguoiDung();
        nd.setTenDayDu(ten);
        nd.setEmail(email);
        nd.setSdt(sdt);
        nd.setMatKhau(pass);
        nd.setVaiTro("khach_hang");
        
        if (new NguoiDungDAO().insertNguoiDung(nd)) {
            resp.sendRedirect(req.getContextPath()+"/views/auth/dang_nhap.jsp?registered=success");
        } else {
            req.setAttribute("error", "Đăng ký không thành công");
            req.getRequestDispatcher("/views/auth/dang_ky.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/dang_ky.jsp").forward(req, resp);
    }
}

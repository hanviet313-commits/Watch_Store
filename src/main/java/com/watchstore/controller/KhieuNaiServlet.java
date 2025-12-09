package com.watchstore.controller;

import com.watchstore.dao.KhieuNaiDAO;
import com.watchstore.model.KhieuNai;
import com.watchstore.model.NguoiDung;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/khieu-nai")
public class KhieuNaiServlet extends HttpServlet {
    private KhieuNaiDAO knDao = new KhieuNaiDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Chuyển hướng về trang danh sách đơn hàng
        resp.sendRedirect(req.getContextPath() + "/don-hang");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        
        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        
        try {
            // Lấy thông tin từ form
            int idDonHang = Integer.parseInt(req.getParameter("idDonHang"));
            String noiDung = req.getParameter("noiDung");
            boolean yeuCauTraHang = req.getParameter("yeuCauTraHang") != null;
            
            // Tạo đối tượng khiếu nại
            KhieuNai kn = new KhieuNai();
            kn.setIdNguoiDung(nd.getIdNguoiDung());
            kn.setIdDonHang(idDonHang);
            kn.setNoiDung(noiDung);
            kn.setTrangThai("Đang chư");
            kn.setYeuCauTraHang(yeuCauTraHang);
            
            // Lưu khiếu nại vào cơ sở dữ liệu
            boolean success = knDao.guiKhieuNai(kn);
            
            if (success) {
                // Chuyển hướng về trang danh sách đơn hàng với thông báo thành công
                resp.sendRedirect(req.getContextPath() + "/don-hang?msg=complaint_success");
            } else {
                // Chuyển hướng về trang danh sách đơn hàng với thông báo lỗi
                resp.sendRedirect(req.getContextPath() + "/don-hang?msg=complaint_error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/don-hang?msg=complaint_error");
        }
    }
}






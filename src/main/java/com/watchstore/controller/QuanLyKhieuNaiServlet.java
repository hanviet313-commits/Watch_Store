package com.watchstore.controller;

import com.watchstore.dao.DonHangDAO;
import com.watchstore.dao.KhieuNaiDAO;
import com.watchstore.model.KhieuNai;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/nv/quan-ly-khieu-nai")
public class QuanLyKhieuNaiServlet extends HttpServlet {
    private KhieuNaiDAO khieuNaiDAO = new KhieuNaiDAO();
    private DonHangDAO donHangDAO = new DonHangDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy các tham số lọc
        String status = req.getParameter("status");
        String returnParam = req.getParameter("return");
        String search = req.getParameter("search");
        
        // Lấy danh sách khiếu nại theo bộ lọc
        List<KhieuNai> ds;
        if (status != null || returnParam != null || search != null) {
            // Chuyển đổi tham số returnParam thành boolean
            Boolean returnValue = null;
            if (returnParam != null && !returnParam.isEmpty()) {
                returnValue = Boolean.parseBoolean(returnParam);
            }
            
            // Lấy danh sách khiếu nại đã lọc
            ds = khieuNaiDAO.getFilteredComplaints(status, returnValue, search);
        } else {
            // Lấy tất cả khiếu nại nếu không có bộ lọc
            ds = khieuNaiDAO.getAllComplaints();
        }
        
        req.setAttribute("complaints", ds);
        req.getRequestDispatcher("/views/nhan_vien/quan_ly_khieu_nai.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        
        if ("update".equals(action)) {
            try {
                int idKhieuNai = Integer.parseInt(req.getParameter("idKhieuNai"));
                String trangThai = req.getParameter("trangThai");
                String phanHoi = req.getParameter("phanHoi");
                
                // Lấy thông tin khiếu nại
                KhieuNai kn = khieuNaiDAO.getById(idKhieuNai);
                
                if (kn != null) {
                    // Cập nhật trạng thái khiếu nại
                    boolean updated = khieuNaiDAO.updateComplaintStatus(idKhieuNai, trangThai, phanHoi);
                    
                    // Nếu khiếu nại có yêu cầu trả hàng và được duyệt
                    if (updated && kn.isYeuCauTraHang() && "Đã xử lý".equals(trangThai)) {
                        // Cập nhật trạng thái đơn hàng thành "Đã trả hàng"
                        donHangDAO.updateOrderStatus(kn.getIdDonHang(), "Đã trả hàng");
                    }
                    
                    resp.sendRedirect(req.getContextPath() + "/nv/quan-ly-khieu-nai?msg=success");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/nv/quan-ly-khieu-nai?msg=not_found");
                }
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/nv/quan-ly-khieu-nai?msg=error");
            }
        }
    }
}



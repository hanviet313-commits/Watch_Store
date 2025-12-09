package com.watchstore.servlet;

import com.watchstore.dao.DonHangDAO;
import com.watchstore.dao.KhieuNaiDAO;
import com.watchstore.model.KhieuNai;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff/complaints")
public class StaffComplaintsServlet extends HttpServlet {
    private KhieuNaiDAO khieuNaiDAO;
    private DonHangDAO donHangDAO;
    
    @Override
    public void init() throws ServletException {
        khieuNaiDAO = new KhieuNaiDAO();
        donHangDAO = new DonHangDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Cấu hình encoding UTF-8
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        
        System.out.println("StaffComplaintsServlet.doGet() called"); // Debug log
        
        // Lấy các tham số lọc
        String status = req.getParameter("status");
        String returnParam = req.getParameter("returnRequest");
        String search = req.getParameter("search");
        
        System.out.println("Filter params - status: " + status + 
                          ", returnRequest: " + returnParam + 
                          ", search: " + search); // Debug log
        
        // Lấy danh sách khiếu nại theo bộ lọc
        List<KhieuNai> ds;
        if (status != null && !status.isEmpty() || 
            returnParam != null && !returnParam.isEmpty() || 
            search != null && !search.isEmpty()) {
            
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
        
        System.out.println("Retrieved " + (ds != null ? ds.size() : "null") + " complaints"); // Debug log
        
        req.setAttribute("complaints", ds);
        req.getRequestDispatcher("/staff/complaints.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        
        System.out.println("StaffComplaintsServlet.doPost() called with action: " + action); // Debug log
        
        if ("update".equals(action)) {
            try {
                int idKhieuNai = Integer.parseInt(req.getParameter("idKhieuNai"));
                String trangThai = req.getParameter("trangThai");
                String phanHoi = req.getParameter("phanHoi");
                
                System.out.println("Updating complaint #" + idKhieuNai + 
                                  " with status: " + trangThai + 
                                  ", response: " + phanHoi); // Debug log
                
                // Lấy thông tin khiếu nại
                KhieuNai kn = khieuNaiDAO.getById(idKhieuNai);
                
                if (kn != null) {
                    // Cập nhật trạng thái khiếu nại
                    boolean updated = khieuNaiDAO.updateComplaintStatus(idKhieuNai, trangThai, phanHoi);
                    
                    System.out.println("Update result: " + updated); // Debug log
                    
                    // Nếu khiếu nại có yêu cầu trả hàng và được duyệt
                    if (updated && kn.isYeuCauTraHang() && "Đã xử lý".equals(trangThai)) {
                        // Cập nhật trạng thái đơn hàng thành "Đã trả hàng"
                        boolean orderUpdated = donHangDAO.updateOrderStatus(kn.getIdDonHang(), "Đã trả hàng");
                        System.out.println("Order update result: " + orderUpdated); // Debug log
                    }
                    
                    resp.sendRedirect(req.getContextPath() + "/staff/complaints?msg=success");
                } else {
                    System.out.println("Complaint not found: " + idKhieuNai); // Debug log
                    
                    // Thử cập nhật trực tiếp mà không cần kiểm tra khiếu nại tồn tại
                    boolean directUpdate = khieuNaiDAO.updateComplaintStatus(idKhieuNai, trangThai, phanHoi);
                    
                    if (directUpdate) {
                        System.out.println("Direct update successful"); // Debug log
                        resp.sendRedirect(req.getContextPath() + "/staff/complaints?msg=success");
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/staff/complaints?msg=not_found");
                    }
                }
            } catch (Exception e) {
                System.out.println("Error updating complaint: " + e.getMessage()); // Debug log
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/staff/complaints?msg=error");
            }
        }
    }
} 

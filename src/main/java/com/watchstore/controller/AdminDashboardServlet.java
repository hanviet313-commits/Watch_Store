package com.watchstore.controller;

import com.watchstore.dao.NguoiDungDAO;
import com.watchstore.model.NguoiDung;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra quyền admin
        HttpSession session = req.getSession();
        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        
        if (nguoiDung == null || !nguoiDung.getVaiTro().equals("admin")) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        
        try {
            // Lấy thống kê người dùng
            int totalUsers = nguoiDungDAO.countAllUsers();
            int totalStaff = nguoiDungDAO.countUsersByRole("staff");
            int totalCustomers = nguoiDungDAO.countUsersByRole("customer");
            int totalDisabledUsers = nguoiDungDAO.countDisabledUsers();
            
            System.out.println("Dashboard stats: Total=" + totalUsers + 
                               ", Staff=" + totalStaff + 
                               ", Customers=" + totalCustomers + 
                               ", Disabled=" + totalDisabledUsers); // Thêm log để debug
            
            // Đặt các giá trị vào request attribute
            req.setAttribute("totalUsers", totalUsers);
            req.setAttribute("totalStaff", totalStaff);
            req.setAttribute("totalCustomers", totalCustomers);
            req.setAttribute("totalDisabledUsers", totalDisabledUsers);
            
            // Lấy danh sách người dùng mới đăng ký
            List<NguoiDung> recentUsers = nguoiDungDAO.getRecentUsers(5);
            req.setAttribute("recentUsers", recentUsers);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Lỗi khi lấy thống kê: " + e.getMessage());
        }
        
        // Hiển thị trang dashboard
        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}


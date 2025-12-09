package com.watchstore.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.watchstore.dao.DonHangDAO;
import com.watchstore.dao.SanPhamDAO;
import com.watchstore.dao.NguoiDungDAO;
import com.watchstore.dao.DanhGiaDAO;
import com.watchstore.model.NguoiDung;

@WebServlet("/staff/dashboard")
public class StaffDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DonHangDAO donHangDAO;
    private SanPhamDAO sanPhamDAO;
    private NguoiDungDAO nguoiDungDAO;
    private DanhGiaDAO danhGiaDAO;

    public void init() {
        donHangDAO = new DonHangDAO();
        sanPhamDAO = new SanPhamDAO();
        nguoiDungDAO = new NguoiDungDAO();
        danhGiaDAO = new DanhGiaDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Cấu hình encoding UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");

        // Kiểm tra đăng nhập và vai trò
        if (nguoiDung == null) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        if (!nguoiDung.getVaiTro().equals("staff") && !nguoiDung.getVaiTro().equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            int totalOrders = 0;
            int totalProducts = 0;
            int totalCustomers = 0;
            int totalReviews = 0;
            List<Object[]> recentOrders = java.util.Collections.emptyList();
            List<Object[]> recentReviews = java.util.Collections.emptyList();
            try {
                totalOrders = donHangDAO.getTotalOrders();
                totalProducts = sanPhamDAO.getTotalProducts();
                totalCustomers = nguoiDungDAO.getTotalCustomers();
                totalReviews = danhGiaDAO.getTotalReviews();
                recentOrders = donHangDAO.getRecentOrders(5);
                recentReviews = danhGiaDAO.getRecentReviews(5);
            } catch (Exception ex) {
                ex.printStackTrace();
                request.setAttribute("errorMessage", ex.getMessage());
            }
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("recentOrders", recentOrders);
            request.setAttribute("recentReviews", recentReviews);
            request.getRequestDispatcher("/staff/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 
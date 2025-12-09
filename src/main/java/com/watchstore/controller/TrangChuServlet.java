package com.watchstore.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.watchstore.dao.SanPhamDAO;
import com.watchstore.model.NguoiDung;
import com.watchstore.model.SanPham;

@WebServlet("/")
public class TrangChuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SanPhamDAO sanPhamDAO;

    public void init() {
        sanPhamDAO = new SanPhamDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");

        // Nếu là staff hoặc admin đã đăng nhập, chuyển đến trang quản trị
        if (nguoiDung != null && (nguoiDung.getVaiTro().equals("staff") || nguoiDung.getVaiTro().equals("admin"))) {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }

        try {
            // Lấy danh sách sản phẩm
            List<SanPham> danhSachSanPham = sanPhamDAO.getAllSanPham();
            request.setAttribute("dsSanPham", danhSachSanPham);

            // Forward to trang chủ
            request.getRequestDispatcher("/views/public/trang_chu.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
} 
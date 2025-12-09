package com.watchstore.servlet;

import com.watchstore.dao.SanPhamDAO;
import com.watchstore.model.SanPham;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff/products/*")
public class StaffProductsServlet extends HttpServlet {
    private SanPhamDAO sanPhamDAO = new SanPhamDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Cấu hình encoding UTF-8
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        
        String action = req.getPathInfo();
        
        if (action == null || action.equals("/")) {
            // Hiển thị danh sách sản phẩm
            List<SanPham> products = sanPhamDAO.getAllSanPham();
            req.setAttribute("products", products);
            req.getRequestDispatcher("/staff/products.jsp").forward(req, resp);
        } else if (action.equals("/edit")) {
            // Hiển thị form sửa sản phẩm
            int id = Integer.parseInt(req.getParameter("id"));
            SanPham product = sanPhamDAO.getSanPhamById(id);
            req.setAttribute("sanPham", product);
            req.getRequestDispatcher("/staff/product-edit.jsp").forward(req, resp);
        } else if (action.equals("/add")) {
            // Hiển thị form thêm sản phẩm
            req.getRequestDispatcher("/staff/product-add.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Cấu hình encoding UTF-8
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        
        String action = req.getPathInfo();
        
        if (action == null || action.equals("/")) {
            // Xử lý thêm sản phẩm mới
            SanPham sp = new SanPham();
            sp.setTenSanPham(req.getParameter("tenSanPham"));
            sp.setMoTa(req.getParameter("moTa"));
            sp.setGia(Double.parseDouble(req.getParameter("gia")));
            sp.setUrlAnh(req.getParameter("urlAnh"));
            sp.setSoLuongTon(Integer.parseInt(req.getParameter("soLuongTon")));
            sp.setNhaSanXuat(req.getParameter("nhaSanXuat"));
            
            if (sanPhamDAO.themSanPham(sp)) {
                req.setAttribute("message", "Thêm sản phẩm thành công!");
            } else {
                req.setAttribute("error", "Thêm sản phẩm thất bại!");
            }
            resp.sendRedirect(req.getContextPath() + "/staff/products");
        } else if (action.equals("/edit")) {
            // Xử lý cập nhật sản phẩm
            SanPham sp = new SanPham();
            sp.setIdSanPham(Integer.parseInt(req.getParameter("id")));
            sp.setTenSanPham(req.getParameter("tenSanPham"));
            sp.setMoTa(req.getParameter("moTa"));
            sp.setGia(Double.parseDouble(req.getParameter("gia")));
            sp.setUrlAnh(req.getParameter("urlAnh"));
            sp.setSoLuongTon(Integer.parseInt(req.getParameter("soLuongTon")));
            sp.setNhaSanXuat(req.getParameter("nhaSanXuat"));
            
            if (sanPhamDAO.capNhatSanPham(sp)) {
                req.setAttribute("message", "Cập nhật sản phẩm thành công!");
            } else {
                req.setAttribute("error", "Cập nhật sản phẩm thất bại!");
            }
            resp.sendRedirect(req.getContextPath() + "/staff/products");
        } else if (action.equals("/delete")) {
            // Xử lý xóa sản phẩm
            int id = Integer.parseInt(req.getParameter("id"));
            if (sanPhamDAO.xoaSanPham(id)) {
                req.setAttribute("message", "Xóa sản phẩm thành công!");
            } else {
                req.setAttribute("error", "Xóa sản phẩm thất bại!");
            }
            resp.sendRedirect(req.getContextPath() + "/staff/products");
        } else if (action.equals("/update-stock")) {
            int id = Integer.parseInt(req.getParameter("id"));
            int soLuong = Integer.parseInt(req.getParameter("soLuong"));
            System.out.println("[DEBUG] Update stock: id=" + id + ", soLuong=" + soLuong);
            boolean result = sanPhamDAO.capNhatTonKho(id, soLuong);
            System.out.println("[DEBUG] Update result: " + result);
            if (result) {
                resp.setStatus(200); // OK
            } else {
                resp.setStatus(500); // Lỗi
                resp.getWriter().write("Cập nhật tồn kho thất bại!");
            }
            return;
        }
    }
} 
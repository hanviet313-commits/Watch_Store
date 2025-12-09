package com.watchstore.servlet;

import com.watchstore.dao.SanPhamDAO;
import com.watchstore.model.SanPham;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DanhSachSanPhamServlet", urlPatterns = {"/danh-sach-san-pham"})
public class DanhSachSanPhamServlet extends HttpServlet {
    private SanPhamDAO sanPhamDAO;

    @Override
    public void init() throws ServletException {
        try {
            sanPhamDAO = new SanPhamDAO();
        } catch (Exception e) {
            throw new ServletException("Không thể khởi tạo SanPhamDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy các tham số tìm kiếm
            String keyword = request.getParameter("keyword");
            String nhaSanXuat = request.getParameter("nhaSanXuat");
            String sortBy = request.getParameter("sortBy");

            // Lấy danh sách sản phẩm theo điều kiện tìm kiếm
            List<SanPham> danhSachSanPham = sanPhamDAO.timKiemSanPham(keyword, nhaSanXuat, sortBy);

            // Đặt danh sách sản phẩm vào request
            request.setAttribute("danhSachSanPham", danhSachSanPham);

            // Chuyển hướng đến trang JSP
            request.getRequestDispatcher("/views/public/danh_sach_san_pham.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi xảy ra khi tìm kiếm sản phẩm");
        }
    }

    @Override
    public void destroy() {
        if (sanPhamDAO != null) {
            sanPhamDAO.closeConnection();
        }
    }
} 
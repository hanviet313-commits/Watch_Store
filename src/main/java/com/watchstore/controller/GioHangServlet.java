package com.watchstore.controller;

import com.watchstore.dao.GioHangDAO;
import com.watchstore.dao.SanPhamDAO;
import com.watchstore.model.GioHang;
import com.watchstore.model.NguoiDung;
import com.watchstore.model.SanPham;
import com.watchstore.model.ChiTietGioHang;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/gio-hang")
public class GioHangServlet extends HttpServlet {
    private GioHangDAO ghDao = new GioHangDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(true);
        String action = req.getParameter("action");
        if (session.getAttribute("nguoiDung") == null) {
            if ("add".equals(action)) {
                int idSanPham = Integer.parseInt(req.getParameter("idSanPham"));
                int soLuong = 1;
                try {
                    soLuong = Integer.parseInt(req.getParameter("soLuong"));
                } catch (Exception ignored) {}
                SanPham sp = new SanPhamDAO().getSanPhamById(idSanPham);
                if (sp == null || soLuong > sp.getSoLuongTon()) {
                    resp.sendRedirect(req.getContextPath() + "/?msg=outofstock");
                    return;
                }
                GioHang gh = (GioHang) session.getAttribute("cart");
                if (gh == null) {
                    gh = new GioHang();
                    gh.setItems(new ArrayList<>());
                }
                boolean found = false;
                for (ChiTietGioHang item : gh.getItems()) {
                    if (item.getIdSanPham() == idSanPham) {
                        item.setSoLuong(item.getSoLuong() + soLuong);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    ChiTietGioHang newItem = new ChiTietGioHang();
                    newItem.setIdSanPham(idSanPham);
                    newItem.setSoLuong(soLuong);
                    newItem.setSanPham(sp);
                    gh.getItems().add(newItem);
                }
                session.setAttribute("cart", gh);
                resp.sendRedirect(req.getContextPath() + "/gio-hang?msg=added");
                return;
            }
            GioHang gh = (GioHang) session.getAttribute("cart");
            req.setAttribute("cart", gh);
            req.setAttribute("msg", req.getParameter("msg"));
            req.getRequestDispatcher("/views/khach_hang/gio_hang.jsp").forward(req, resp);
            return;
        }
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        if ("add".equals(action)) {
            int idSanPham = Integer.parseInt(req.getParameter("idSanPham"));
            int soLuong = 1;
            try {
                soLuong = Integer.parseInt(req.getParameter("soLuong"));
            } catch (Exception ignored) {}
            SanPham sp = new SanPhamDAO().getSanPhamById(idSanPham);
            GioHang gh = ghDao.getByUser(nd.getIdNguoiDung());
            int soLuongTrongGio = 0;
            if (gh != null && gh.getItems() != null) {
                for (ChiTietGioHang item : gh.getItems()) {
                    if (item.getIdSanPham() == idSanPham) {
                        soLuongTrongGio = item.getSoLuong();
                        break;
                    }
                }
            }
            if (sp == null || soLuong + soLuongTrongGio > sp.getSoLuongTon()) {
                resp.sendRedirect(req.getContextPath() + "/?msg=outofstock");
                return;
            }
            ghDao.createCartIfNotExist(nd.getIdNguoiDung());
            ghDao.addToCart(nd.getIdNguoiDung(), idSanPham, soLuong);
            resp.sendRedirect(req.getContextPath() + "/gio-hang?msg=added");
            return;
        }
        GioHang gh = ghDao.getByUser(nd.getIdNguoiDung());
        req.setAttribute("cart", gh);
        req.setAttribute("msg", req.getParameter("msg"));
        req.getRequestDispatcher("/views/khach_hang/gio_hang.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(true);
        String action = req.getParameter("action");
        
        // Xử lý xóa toàn bộ giỏ hàng
        if ("clear".equals(action)) {
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
            return; // Kết thúc phương thức ngay tại đây
        }
        
        // Xử lý các action khác
        try {
            // Đảm bảo có tham số idSanPham và soLuong
            String idSanPhamStr = req.getParameter("idSanPham");
            String soLuongStr = req.getParameter("soLuong");
            
            if (idSanPhamStr == null || soLuongStr == null) {
                resp.sendRedirect(req.getContextPath() + "/gio-hang?msg=error");
                return;
            }
            
            int idSanPham = Integer.parseInt(idSanPhamStr);
            int soLuong = Integer.parseInt(soLuongStr);
            
            if (session.getAttribute("nguoiDung") == null) {
                // Xử lý giỏ hàng cho người dùng chưa đăng nhập
                handleGuestCart(req, resp, action, idSanPham, soLuong);
            } else {
                // Xử lý giỏ hàng cho người dùng đã đăng nhập
                handleUserCart(req, resp, action, idSanPham, soLuong);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/gio-hang?msg=error_format");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/gio-hang?msg=error");
        }
    }

    // Xử lý giỏ hàng cho người dùng chưa đăng nhập
    private void handleGuestCart(HttpServletRequest req, HttpServletResponse resp, String action, int idSanPham, int soLuong) 
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        SanPham sp = new SanPhamDAO().getSanPhamById(idSanPham);
        
        if (sp == null || soLuong > sp.getSoLuongTon()) {
            resp.sendRedirect(req.getContextPath() + "/gio-hang?msg=outofstock");
            return;
        }
        
        GioHang gh = (GioHang) session.getAttribute("cart");
        if (gh == null) {
            gh = new GioHang();
            gh.setItems(new ArrayList<>());
        }
        
        switch (action) {
            case "add":
                boolean found = false;
                for (ChiTietGioHang item : gh.getItems()) {
                    if (item.getIdSanPham() == idSanPham) {
                        item.setSoLuong(item.getSoLuong() + soLuong);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    ChiTietGioHang newItem = new ChiTietGioHang();
                    newItem.setIdSanPham(idSanPham);
                    newItem.setSoLuong(soLuong);
                    newItem.setSanPham(sp);
                    gh.getItems().add(newItem);
                }
                break;
            case "update":
                for (ChiTietGioHang item : gh.getItems()) {
                    if (item.getIdSanPham() == idSanPham) {
                        item.setSoLuong(soLuong);
                        break;
                    }
                }
                break;
            case "remove":
                gh.getItems().removeIf(item -> item.getIdSanPham() == idSanPham);
                break;
        }
        
        session.setAttribute("cart", gh);
        resp.sendRedirect(req.getContextPath() + "/gio-hang?msg=updated");
    }

    // Xử lý giỏ hàng cho người dùng đã đăng nhập
    private void handleUserCart(HttpServletRequest req, HttpServletResponse resp, String action, int idSanPham, int soLuong) 
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        int idUser = nd.getIdNguoiDung();
        
        SanPham sp = new SanPhamDAO().getSanPhamById(idSanPham);
        if (sp == null || soLuong > sp.getSoLuongTon()) {
            resp.sendRedirect(req.getContextPath() + "/gio-hang?msg=outofstock");
            return;
        }
        
        ghDao.createCartIfNotExist(idUser);
        
        switch (action) {
            case "add":
                ghDao.addToCart(idUser, idSanPham, soLuong);
                break;
            case "update":
                ghDao.updateQuantity(ghDao.getByUser(idUser).getIdGioHang(), idSanPham, soLuong);
                break;
            case "remove":
                ghDao.removeFromCart(ghDao.getByUser(idUser).getIdGioHang(), idSanPham);
                break;
        }
        
        resp.sendRedirect(req.getContextPath() + "/gio-hang?msg=updated");
    }
}









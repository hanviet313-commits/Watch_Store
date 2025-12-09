package com.watchstore.controller;

import com.watchstore.dao.DonHangDAO;
import com.watchstore.model.DonHang;
import com.watchstore.model.GioHang;
import com.watchstore.model.ChiTietGioHang;
import com.watchstore.model.ChiTietDonHang;
import com.watchstore.model.NguoiDung;
import com.watchstore.dao.GioHangDAO;
import com.watchstore.model.SanPham;
import com.watchstore.dao.SanPhamDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/dat-hang")
public class DatHangServlet extends HttpServlet {
    private GioHangDAO ghDao = new GioHangDAO();
    private SanPhamDAO spDao = new SanPhamDAO();
    private DonHangDAO dhDao = new DonHangDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        
        // Kiểm tra đăng nhập
        if (nd == null) {
            // Lưu URL hiện tại vào session để sau khi đăng nhập có thể quay lại
            String requestURL = req.getRequestURL().toString();
            String queryString = req.getQueryString();
            String returnUrl = requestURL + (queryString != null ? "?" + queryString : "");
            session.setAttribute("returnUrl", returnUrl);
            
            // Chuyển hướng đến trang đăng nhập
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        
        GioHang gh = null;
        
        // Xử lý chức năng "Mua ngay"
        String action = req.getParameter("action");
        if ("buynow".equals(action)) {
            String idSanPhamStr = req.getParameter("idSanPham");
            String soLuongStr = req.getParameter("soLuong");
            
            if (idSanPhamStr != null && soLuongStr != null) {
                try {
                    int idSanPham = Integer.parseInt(idSanPhamStr);
                    int soLuong = Integer.parseInt(soLuongStr);
                    
                    // Lấy thông tin sản phẩm
                    SanPham sp = spDao.getById(idSanPham);
                    
                    if (sp != null && sp.getSoLuongTon() >= soLuong) {
                        // Tạo giỏ hàng tạm thời cho mua ngay
                        GioHang tempCart = new GioHang();
                        tempCart.setItems(new ArrayList<>());
                        
                        // Thêm sản phẩm vào giỏ hàng tạm thời
                        ChiTietGioHang ctgh = new ChiTietGioHang();
                        ctgh.setIdSanPham(idSanPham);
                        ctgh.setSoLuong(soLuong);
                        ctgh.setSanPham(sp);
                        tempCart.getItems().add(ctgh);
                        
                        // Lưu giỏ hàng tạm thời vào session
                        session.setAttribute("tempCart", tempCart);
                        
                        // Chuyển hướng đến trang thanh toán với giỏ hàng tạm thời
                        req.setAttribute("cart", tempCart);
                        req.setAttribute("isBuyNow", true);
                        req.getRequestDispatcher("/views/khach_hang/thanh_toan.jsp").forward(req, resp);
                        return;
                    } else {
                        // Sản phẩm không tồn tại hoặc không đủ số lượng
                        resp.sendRedirect(req.getContextPath() + "/san-pham?id=" + idSanPham + "&msg=outofstock");
                        return;
                    }
                } catch (NumberFormatException e) {
                    resp.sendRedirect(req.getContextPath() + "/");
                    return;
                }
            }
        }
        
        // Xử lý thanh toán bình thường từ giỏ hàng
        if (nd != null) {
            gh = ghDao.getByUserId(nd.getIdNguoiDung());
        } else {
            gh = (GioHang) session.getAttribute("cart");
        }

        if (gh == null || gh.getItems() == null || gh.getItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/gio-hang");
            return;
        }

        req.setAttribute("cart", gh);
        req.getRequestDispatcher("/views/khach_hang/thanh_toan.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        NguoiDung nd = null;
        GioHang gh = null;
        
        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("nguoiDung") == null) {
            // Lưu URL hiện tại vào session để sau khi đăng nhập có thể quay lại
            String requestURL = req.getRequestURL().toString();
            String queryString = req.getQueryString();
            String returnUrl = requestURL + (queryString != null ? "?" + queryString : "");
            session.setAttribute("returnUrl", returnUrl);
            
            // Chuyển hướng đến trang đăng nhập
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        
        nd = (NguoiDung) session.getAttribute("nguoiDung");
        
        // Kiểm tra xem có phải là mua ngay không bằng cách lấy giỏ hàng tạm thời từ session
        gh = (GioHang) session.getAttribute("tempCart");
        if (gh == null) {
            // Nếu không phải mua ngay, xử lý giỏ hàng bình thường
            gh = ghDao.getByUser(nd.getIdNguoiDung());
        }
        
        // kiểm tra tồn kho trước khi đặt hàng
        boolean outOfStock = false;
        StringBuilder outMsg = new StringBuilder();
        if (gh != null && gh.getItems() != null) {
            for (ChiTietGioHang ctp : gh.getItems()) {
                SanPham sp = ctp.getSanPham();
                if (ctp.getSoLuong() > sp.getSoLuongTon()) {
                    outOfStock = true;
                    outMsg.append("Sản phẩm ").append(sp.getTenSanPham()).append(" chỉ còn ").append(sp.getSoLuongTon()).append(" sản phẩm!\n");
                }
            }
        }
        
        if (outOfStock) {
            req.setAttribute("cart", gh);
            req.setAttribute("msg", outMsg.toString());
            req.getRequestDispatcher("/views/khach_hang/gio_hang.jsp").forward(req, resp);
            return;
        }
        
        // build DonHang
        DonHang dh = new DonHang();
        dh.setIdNguoiDung(nd.getIdNguoiDung());
        dh.setDiaChi(req.getParameter("diaChiNhan"));
        String sdtNhan = req.getParameter("sdtNhan");
        if (sdtNhan == null || sdtNhan.trim().isEmpty()) sdtNhan = nd.getSdt();
        dh.setSdtNguoiNhan(sdtNhan);
        
        List<ChiTietDonHang> items = new ArrayList<>();
        double tong = 0;
        if (gh != null && gh.getItems() != null) {
            for (ChiTietGioHang ctp : gh.getItems()) {
                ChiTietDonHang ctd = new ChiTietDonHang();
                ctd.setIdSanPham(ctp.getIdSanPham());
                ctd.setSoLuong(ctp.getSoLuong());
                ctd.setDonGia(ctp.getSanPham().getGia());
                tong += ctd.getDonGia() * ctd.getSoLuong();
                items.add(ctd);
                
                // Cập nhật số lượng tồn kho
                SanPham sp = spDao.getById(ctp.getIdSanPham());
                if (sp != null) {
                    sp.setSoLuongTon(sp.getSoLuongTon() - ctp.getSoLuong());
                    spDao.capNhatTonKho(sp.getIdSanPham(), sp.getSoLuongTon());
                }
            }
        }
        
        dh.setItems(items);
        dh.setTongTien(tong);
        
        if (dhDao.createOrder(dh)) {
            // Xóa giỏ hàng sau khi đặt hàng thành công
            if (gh != null) {
                for (ChiTietGioHang ctp : gh.getItems()) {
                    ghDao.removeFromCart(gh.getIdGioHang(), ctp.getIdSanPham());
                }
            }
            resp.sendRedirect(req.getContextPath() + "/views/khach_hang/order-success.jsp");
        } else {
            req.setAttribute("error", "Thanh toán thất bại");
            req.getRequestDispatcher("/views/khach_hang/thanh_toan.jsp").forward(req, resp);
        }
    }
}


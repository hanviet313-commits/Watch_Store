package com.watchstore.controller;

import com.watchstore.dao.DonHangDAO;
import com.watchstore.model.DonHang;
import com.watchstore.model.NguoiDung;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/don-hang")
public class DonHangServlet extends HttpServlet {
    private DonHangDAO dhDao = new DonHangDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        
        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        
        // Lấy danh sách đơn hàng mới nhất từ cơ sở dữ liệu
        List<DonHang> allOrders = dhDao.getOrdersByUser(nd.getIdNguoiDung());
        
        // Lấy tham số trạng thái từ URL
        String status = req.getParameter("status");
        List<DonHang> filteredOrders = new ArrayList<>();
        
        // Lọc đơn hàng theo trạng thái
        if (status != null && !status.isEmpty()) {
            String trangThai = "";
            switch (status) {
                case "cho-xac-nhan":
                    trangThai = "Chờ xác nhận";
                    break;
                case "dang-xu-ly":
                    trangThai = "Đang xử lý";
                    break;
                case "dang-giao":
                    trangThai = "Đang giao";
                    break;
                case "hoan-thanh":
                    trangThai = "Hoàn thành";
                    break;
                case "da-huy":
                    trangThai = "Đã hủy";
                    break;
            }
            
            for (DonHang dh : allOrders) {
                if (dh.getTrangThai().equals(trangThai)) {
                    filteredOrders.add(dh);
                }
            }
        } else {
            filteredOrders = allOrders;
        }
        
        // Đếm số lượng đơn hàng theo từng trạng thái
        int choXacNhanCount = 0;
        int dangXuLyCount = 0;
        int dangGiaoCount = 0;
        int hoanThanhCount = 0;
        int daHuyCount = 0;
        
        for (DonHang dh : allOrders) {
            switch (dh.getTrangThai()) {
                case "Chờ xác nhận":
                    choXacNhanCount++;
                    break;
                case "Đang xử lý":
                    dangXuLyCount++;
                    break;
                case "Đang giao":
                    dangGiaoCount++;
                    break;
                case "Hoàn thành":
                    hoanThanhCount++;
                    break;
                case "Đã hủy":
                    daHuyCount++;
                    break;
            }
        }
        
        // Đặt các thuộc tính vào request
        req.setAttribute("allOrdersCount", allOrders.size());
        req.setAttribute("choXacNhanCount", choXacNhanCount);
        req.setAttribute("dangXuLyCount", dangXuLyCount);
        req.setAttribute("dangGiaoCount", dangGiaoCount);
        req.setAttribute("hoanThanhCount", hoanThanhCount);
        req.setAttribute("daHuyCount", daHuyCount);
        req.setAttribute("filteredOrders", filteredOrders);
        
        // Lấy thông báo từ tham số URL (nếu có)
        String msg = req.getParameter("msg");
        if (msg != null) {
            req.setAttribute("msg", msg);
        }
        
        req.getRequestDispatcher("/views/khach_hang/danh_sach_don_hang.jsp").forward(req, resp);
    }
}





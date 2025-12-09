package com.watchstore.servlet;

import com.watchstore.dao.ThongBaoDAO;
import com.watchstore.model.ThongBao;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
@WebServlet("/staff/notifications")
public class StaffNotificationsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        ThongBaoDAO dao = new ThongBaoDAO();
        java.util.List<ThongBao> notifications = dao.getAll();
        req.setAttribute("notifications", notifications);

        req.getRequestDispatcher("/staff/notifications.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        ThongBaoDAO dao = new ThongBaoDAO();
        boolean result = false;
        String message = "";
        try {
            if ("add".equals(action)) {
                String tieuDe = req.getParameter("tieuDe");
                String noiDung = req.getParameter("noiDung");
                String ngayKetThuc = req.getParameter("ngayKetThuc");
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                ThongBao tb = new ThongBao();
                tb.setTieuDe(tieuDe);
                tb.setNoiDung(noiDung);
                try {
                    if (ngayKetThuc == null || ngayKetThuc.isEmpty()) {
                        throw new IllegalArgumentException("Ngày kết thúc không được để trống!");
                    }
                    tb.setNgayKetThuc(sdf.parse(ngayKetThuc));
                } catch (Exception pe) {
                    message = "Lỗi định dạng ngày: " + pe.getMessage();
                    req.setAttribute("message", message);
                    doGet(req, resp);
                    return;
                }
                result = dao.insert(tb);
                message = result ? "Thêm thông báo thành công!" : "Thêm thông báo thất bại!";
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("idThongBao"));
                String tieuDe = req.getParameter("tieuDe");
                String noiDung = req.getParameter("noiDung");
                String ngayKetThuc = req.getParameter("ngayKetThuc");
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                ThongBao tb = new ThongBao();
                tb.setIdThongBao(id);
                tb.setTieuDe(tieuDe);
                tb.setNoiDung(noiDung);
                try {
                    if (ngayKetThuc == null || ngayKetThuc.isEmpty()) {
                        throw new IllegalArgumentException("Ngày kết thúc không được để trống!");
                    }
                    tb.setNgayKetThuc(sdf.parse(ngayKetThuc));
                } catch (Exception pe) {
                    message = "Lỗi định dạng ngày: " + pe.getMessage();
                    req.setAttribute("message", message);
                    doGet(req, resp);
                    return;
                }
                result = dao.update(tb);
                message = result ? "Cập nhật thông báo thành công!" : "Cập nhật thông báo thất bại!";
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("idThongBao"));
                result = dao.delete(id);
                message = result ? "Xóa thông báo thành công!" : "Xóa thông báo thất bại!";
            }
        } catch (Exception e) {
            message = "Lỗi xử lý: " + e.getMessage();
            e.printStackTrace(); // log chi tiết lỗi
        }
        req.setAttribute("message", message);
        // Sau khi xử lý, load lại danh sách
        doGet(req, resp);
    }
} 
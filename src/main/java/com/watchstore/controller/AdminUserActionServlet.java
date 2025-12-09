package com.watchstore.controller;

import com.watchstore.dao.NguoiDungDAO;
import com.watchstore.model.NguoiDung;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {
    "/admin/quan-ly-nguoi-dung/them",
    "/admin/quan-ly-nguoi-dung/sua",
    "/admin/quan-ly-nguoi-dung/khoa",
    "/admin/quan-ly-nguoi-dung/mo-khoa",
    "/admin/quan-ly-nguoi-dung/doi-vai-tro"
})
public class AdminUserActionServlet extends HttpServlet {
    private NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Kiểm tra quyền admin
        HttpSession session = request.getSession();
        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        
        if (nguoiDung == null || !nguoiDung.getVaiTro().equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }
        
        String action = request.getServletPath();
        String message = null;
        
        try {
            if (action.contains("/khoa")) {
                // Khóa tài khoản
                int id = Integer.parseInt(request.getParameter("id"));
                nguoiDungDAO.updateStatus(id, 0);
                message = "Đã khóa tài khoản người dùng thành công!";
            } else if (action.contains("/mo-khoa")) {
                // Mở khóa tài khoản
                int id = Integer.parseInt(request.getParameter("id"));
                nguoiDungDAO.updateStatus(id, 1);
                message = "Đã mở khóa tài khoản người dùng thành công!";
            }
            
            if (message != null) {
                request.getSession().setAttribute("message", message);
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/quan-ly-nguoi-dung");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Kiểm tra quyền admin
        HttpSession session = request.getSession();
        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        
        if (nguoiDung == null || !nguoiDung.getVaiTro().equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }
        
        String action = request.getServletPath();
        String message = null;
        
        try {
            if (action.contains("/them")) {
                // Thêm người dùng mới
                String tenDayDu = request.getParameter("tenDayDu");
                String email = request.getParameter("email");
                String sdt = request.getParameter("sdt");
                String matKhau = request.getParameter("matKhau");
                String vaiTro = request.getParameter("vaiTro");
                
                // Không mã hóa mật khẩu nữa
                // String hashedPassword = MaHoaMatKhauUtil.hashMD5(matKhau);
                
                // Tạo đối tượng người dùng mới
                NguoiDung newUser = new NguoiDung();
                newUser.setTenDayDu(tenDayDu);
                newUser.setEmail(email);
                newUser.setSdt(sdt);
                newUser.setMatKhau(matKhau);
                newUser.setVaiTro(vaiTro);
                newUser.setTrangThai(1); // Mặc định là hoạt động
                
                // Thêm vào cơ sở dữ liệu
                nguoiDungDAO.addUser(newUser);
                message = "Đã thêm người dùng mới thành công!";
            } else if (action.contains("/sua")) {
                // Sửa thông tin người dùng
                int id = Integer.parseInt(request.getParameter("idNguoiDung"));
                String tenDayDu = request.getParameter("tenDayDu");
                String email = request.getParameter("email");
                String sdt = request.getParameter("sdt");
                
                // Cập nhật thông tin
                NguoiDung userToUpdate = nguoiDungDAO.getUserById(id);
                if (userToUpdate != null) {
                    userToUpdate.setTenDayDu(tenDayDu);
                    userToUpdate.setEmail(email);
                    userToUpdate.setSdt(sdt);
                    
                    nguoiDungDAO.updateUser(userToUpdate);
                    message = "Đã cập nhật thông tin người dùng thành công!";
                }
                
            } else if (action.contains("/doi-vai-tro")) {
                // Đổi vai trò người dùng
                int id = Integer.parseInt(request.getParameter("idNguoiDung"));
                String vaiTro = request.getParameter("vaiTro");
                
                nguoiDungDAO.updateRole(id, vaiTro);
                message = "Đã đổi vai trò người dùng thành công!";
            }
            
            if (message != null) {
                request.getSession().setAttribute("message", message);
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/quan-ly-nguoi-dung");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}


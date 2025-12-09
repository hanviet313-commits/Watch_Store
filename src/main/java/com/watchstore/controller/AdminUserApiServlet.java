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
import java.io.PrintWriter;

@WebServlet("/admin/api/nguoi-dung/*")
public class AdminUserApiServlet extends HttpServlet {
    private NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Kiểm tra quyền admin
            HttpSession session = request.getSession();
            NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
            
            if (nguoiDung == null || !nguoiDung.getVaiTro().equals("admin")) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }
            
            // Lấy ID người dùng từ URL
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            
            String[] splits = pathInfo.split("/");
            if (splits.length != 2) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            
            int userId;
            try {
                userId = Integer.parseInt(splits[1]);
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            
            // Lấy thông tin người dùng
            NguoiDung user = nguoiDungDAO.getUserById(userId);
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            // Trả về thông tin người dùng dưới dạng JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            
            // Tạo JSON thủ công
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"idNguoiDung\":").append(user.getIdNguoiDung()).append(",");
            json.append("\"tenDayDu\":\"").append(escapeJson(user.getTenDayDu())).append("\",");
            json.append("\"email\":\"").append(escapeJson(user.getEmail())).append("\",");
            json.append("\"sdt\":\"").append(escapeJson(user.getSdt())).append("\",");
            json.append("\"vaiTro\":\"").append(escapeJson(user.getVaiTro())).append("\",");
            json.append("\"trangThai\":").append(user.getTrangThai());
            json.append("}");
            
            out.print(json.toString());
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    // Hàm để escape các ký tự đặc biệt trong JSON
    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}
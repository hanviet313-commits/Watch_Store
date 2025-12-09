package com.watchstore.controller;

import com.watchstore.dao.DanhGiaDAO;
import com.watchstore.model.DanhGia;
import com.watchstore.model.NguoiDung;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/danh-gia")
public class DanhGiaServlet extends HttpServlet {
    private DanhGiaDAO dgDao = new DanhGiaDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        int idSanPham = Integer.parseInt(req.getParameter("idSanPham"));
        String noiDung = req.getParameter("noiDung");
        int soSao = Integer.parseInt(req.getParameter("soSao"));
        
        if (noiDung == null || noiDung.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/san-pham?id=" + idSanPham + "&msg=empty");
            return;
        }
        
        DanhGia dg = new DanhGia();
        dg.setIdNguoiDung(nd.getIdNguoiDung());
        dg.setIdSanPham(idSanPham);
        dg.setNoiDung(noiDung);
        dg.setSoSao(soSao);
        
        if (dgDao.themDanhGia(dg)) {
            resp.sendRedirect(req.getContextPath() + "/san-pham?id=" + idSanPham + "&msg=success");
        } else {
            resp.sendRedirect(req.getContextPath() + "/san-pham?id=" + idSanPham + "&msg=error");
        }
    }
}

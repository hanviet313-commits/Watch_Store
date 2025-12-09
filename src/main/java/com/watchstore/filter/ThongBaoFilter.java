package com.watchstore.filter;

import com.watchstore.dao.ThongBaoDAO;
import com.watchstore.model.ThongBao;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class ThongBaoFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        ThongBaoDAO thongBaoDAO = new ThongBaoDAO();
        List<ThongBao> thongBaoList = thongBaoDAO.getAll();
        request.setAttribute("thongBaoList", thongBaoList);
        chain.doFilter(request, response);
    }
} 
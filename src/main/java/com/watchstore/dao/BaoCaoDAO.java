
package com.watchstore.dao;

import com.watchstore.model.BaoCao;
import com.watchstore.util.CSDLUtill;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BaoCaoDAO {
    public List<BaoCao> getMonthlySales(int nam) {
        List<BaoCao> list = new ArrayList<>();
        String sql = "SELECT MONTH(ngay_dat) as thang, YEAR(ngay_dat) as nam, SUM(tong_tien) as doanh_thu "
                   + "FROM don_hang WHERE YEAR(ngay_dat)=? GROUP BY MONTH(ngay_dat)";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nam);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BaoCao bc = new BaoCao();
                bc.setThang(rs.getInt("thang"));
                bc.setNam(rs.getInt("nam"));
                bc.setTongDoanhThu(rs.getDouble("doanh_thu"));
                list.add(bc);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}

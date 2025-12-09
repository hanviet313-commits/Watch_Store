package com.watchstore.dao;

import com.watchstore.model.ThongBao;
import com.watchstore.util.CSDLUtill;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ThongBaoDAO {
    public List<ThongBao> getAll() {
        List<ThongBao> list = new ArrayList<>();
        String sql = "SELECT * FROM thong_bao";
        try (Connection conn = CSDLUtill.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                ThongBao tb = new ThongBao();
                tb.setIdThongBao(rs.getInt("id_thong_bao"));
                tb.setTieuDe(rs.getString("tieu_de"));
                tb.setNoiDung(rs.getString("noi_dung"));
                tb.setNgayTao(rs.getTimestamp("ngay_tao"));
                tb.setNgayKetThuc(rs.getTimestamp("ngay_ket_thuc"));
                list.add(tb);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(ThongBao tb) {
        String sql = "INSERT INTO thong_bao(tieu_de,noi_dung,ngay_ket_thuc) VALUES(?,?,?)";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tb.getTieuDe());
            ps.setString(2, tb.getNoiDung());
            ps.setTimestamp(3, new Timestamp(tb.getNgayKetThuc().getTime()));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(ThongBao tb) {
        String sql = "UPDATE thong_bao SET tieu_de=?,noi_dung=?,ngay_ket_thuc=? WHERE id_thong_bao=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tb.getTieuDe());
            ps.setString(2, tb.getNoiDung());
            ps.setTimestamp(3, new Timestamp(tb.getNgayKetThuc().getTime()));
            ps.setInt(4, tb.getIdThongBao());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM thong_bao WHERE id_thong_bao=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}

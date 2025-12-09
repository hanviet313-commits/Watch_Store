package com.watchstore.dao;

import com.watchstore.model.DanhGia;
import com.watchstore.util.CSDLUtill;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.TimeZone;

public class DanhGiaDAO {
    
    static {
        // Cấu hình timezone cho Java application
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
    }

    public boolean themDanhGia(DanhGia dg) {
        String sql = "INSERT INTO danh_gia(id_san_pham,id_nguoi_dung,noi_dung,so_sao) VALUES(?,?,?,?)";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dg.getIdSanPham());
            ps.setInt(2, dg.getIdNguoiDung());
            ps.setString(3, dg.getNoiDung());
            ps.setInt(4, dg.getSoSao());
            return ps.executeUpdate() > 0;
        } catch(Exception e) { e.printStackTrace(); }
        return false;
    }

    public List<DanhGia> getByProduct(int idSanPham) {
        List<DanhGia> list = new ArrayList<>();
        String sql = "SELECT * FROM danh_gia WHERE id_san_pham=? AND trang_thai=1";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idSanPham);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                DanhGia dg = new DanhGia();
                dg.setIdDanhGia(rs.getInt("id_danh_gia"));
                dg.setIdSanPham(idSanPham);
                dg.setIdNguoiDung(rs.getInt("id_nguoi_dung"));
                dg.setNoiDung(rs.getString("noi_dung"));
                dg.setSoSao(rs.getInt("so_sao"));
                dg.setNgayDanhGia(rs.getTimestamp("ngay_danh_gia"));
                list.add(dg);
            }
        } catch(Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<DanhGia> getAllReviews() {
        List<DanhGia> list = new ArrayList<>();
        String sql = "SELECT dg.*, sp.ten_san_pham, nd.ten_day_du " +
                    "FROM danh_gia dg " +
                    "JOIN san_pham sp ON dg.id_san_pham = sp.id_san_pham " +
                    "JOIN nguoi_dung nd ON dg.id_nguoi_dung = nd.id_nguoi_dung " +
                    "ORDER BY dg.ngay_danh_gia DESC";
        try (Connection conn = CSDLUtill.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            System.out.println("SQL Query: " + sql);
            while (rs.next()) {
                DanhGia dg = new DanhGia();
                dg.setIdDanhGia(rs.getInt("id_danh_gia"));
                dg.setIdSanPham(rs.getInt("id_san_pham"));
                dg.setIdNguoiDung(rs.getInt("id_nguoi_dung"));
                dg.setNoiDung(rs.getString("noi_dung"));
                dg.setSoSao(rs.getInt("so_sao"));
                dg.setNgayDanhGia(rs.getTimestamp("ngay_danh_gia"));
                dg.setTraLoi(rs.getString("tra_loi"));
                dg.setTrangThai(rs.getBoolean("trang_thai"));
                dg.setTenSanPham(rs.getString("ten_san_pham"));
                dg.setTenNguoiDung(rs.getString("ten_day_du"));
                list.add(dg);
                System.out.println("Found review: " + dg.getIdDanhGia() + " - " + dg.getTenSanPham() + " - " + dg.getTenNguoiDung());
            }
            System.out.println("Total reviews found: " + list.size());
        } catch(Exception e) { 
            System.out.println("Error in getAllReviews: " + e.getMessage());
            e.printStackTrace(); 
        }
        return list;
    }

    public int getTotalReviews() throws SQLException {
        String sql = "SELECT COUNT(*) FROM danh_gia";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Object[]> getRecentReviews(int limit) throws SQLException {
        List<Object[]> reviews = new ArrayList<>();
        String sql = "SELECT dg.id_danh_gia, sp.ten_san_pham, nd.ten_day_du, dg.so_sao, dg.ngay_danh_gia, dg.trang_thai, dg.tra_loi " +
                     "FROM danh_gia dg " +
                     "JOIN san_pham sp ON dg.id_san_pham = sp.id_san_pham " +
                     "JOIN nguoi_dung nd ON dg.id_nguoi_dung = nd.id_nguoi_dung " +
                     "ORDER BY dg.ngay_danh_gia DESC LIMIT ?";
        
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Object[] review = new Object[7];
                    review[0] = rs.getInt("id_danh_gia");
                    review[1] = rs.getString("ten_san_pham");
                    review[2] = rs.getString("ten_day_du");
                    review[3] = rs.getInt("so_sao");
                    review[4] = rs.getTimestamp("ngay_danh_gia");
                    review[5] = rs.getInt("trang_thai");
                    review[6] = rs.getString("tra_loi");
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    public boolean updateReply(int idDanhGia, String reply) {
        String sql = "UPDATE danh_gia SET tra_loi = ? WHERE id_danh_gia = ?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reply);
            ps.setInt(2, idDanhGia);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleVisibility(int idDanhGia, boolean isHidden) {
        String sql = "UPDATE danh_gia SET trang_thai = ? WHERE id_danh_gia = ?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isHidden);
            ps.setInt(2, idDanhGia);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}

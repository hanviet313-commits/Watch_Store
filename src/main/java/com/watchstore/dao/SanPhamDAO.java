package com.watchstore.dao;

import com.watchstore.model.SanPham;
import com.watchstore.util.CSDLUtill;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SanPhamDAO {
    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;

    public SanPhamDAO() {
        try {
            conn = CSDLUtill.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<SanPham> timKiemSanPham(String keyword, String nhaSanXuat, String sortBy) {
        List<SanPham> danhSachSanPham = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM san_pham WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Thêm điều kiện tìm kiếm theo từ khóa
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (ten_san_pham LIKE ? OR mo_ta LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        // Thêm điều kiện lọc theo nhà sản xuất
        if (nhaSanXuat != null && !nhaSanXuat.trim().isEmpty()) {
            sql.append(" AND nha_san_xuat = ?");
            params.add(nhaSanXuat);
        }

        // Thêm điều kiện sắp xếp
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            switch (sortBy) {
                case "price_asc":
                    sql.append(" ORDER BY gia ASC");
                    break;
                case "price_desc":
                    sql.append(" ORDER BY gia DESC");
                    break;
                case "name_asc":
                    sql.append(" ORDER BY ten_san_pham ASC");
                    break;
                case "name_desc":
                    sql.append(" ORDER BY ten_san_pham DESC");
                    break;
            }
        }

        try {
            ps = conn.prepareStatement(sql.toString());
            
            // Set các tham số
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            rs = ps.executeQuery();
            while (rs.next()) {
                SanPham sanPham = new SanPham();
                sanPham.setIdSanPham(rs.getInt("id_san_pham"));
                sanPham.setTenSanPham(rs.getString("ten_san_pham"));
                sanPham.setMoTa(rs.getString("mo_ta"));
                sanPham.setGia(rs.getDouble("gia"));
                sanPham.setSoLuongTon(rs.getInt("so_luong_ton"));
                sanPham.setUrlAnh(rs.getString("url_anh"));
                sanPham.setNhaSanXuat(rs.getString("nha_san_xuat"));
                danhSachSanPham.add(sanPham);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return danhSachSanPham;
    }

    public void closeConnection() {
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public SanPham getSanPhamById(int id) {
        String sql = "SELECT * FROM san_pham WHERE id_san_pham=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                SanPham sp = new SanPham();
                sp.setIdSanPham(rs.getInt("id_san_pham"));
                sp.setTenSanPham(rs.getString("ten_san_pham"));
                sp.setMoTa(rs.getString("mo_ta"));
                sp.setGia(rs.getDouble("gia"));
                sp.setUrlAnh(rs.getString("url_anh"));
                sp.setSoLuongTon(rs.getInt("so_luong_ton"));
                sp.setNhaSanXuat(rs.getString("nha_san_xuat"));
                return sp;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<SanPham> getAllSanPham() {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM san_pham";
        try (Connection conn = CSDLUtill.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                SanPham sp = new SanPham();
                sp.setIdSanPham(rs.getInt("id_san_pham"));
                sp.setTenSanPham(rs.getString("ten_san_pham"));
                sp.setMoTa(rs.getString("mo_ta"));
                sp.setGia(rs.getDouble("gia"));
                sp.setUrlAnh(rs.getString("url_anh"));
                sp.setSoLuongTon(rs.getInt("so_luong_ton"));
                sp.setNhaSanXuat(rs.getString("nha_san_xuat"));
                list.add(sp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalProducts() throws SQLException {
        String sql = "SELECT COUNT(*) FROM san_pham";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public boolean themSanPham(SanPham sp) {
        String sql = "INSERT INTO san_pham(ten_san_pham, mo_ta, gia, url_anh, so_luong_ton, nha_san_xuat) VALUES(?,?,?,?,?,?)";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sp.getTenSanPham());
            ps.setString(2, sp.getMoTa());
            ps.setDouble(3, sp.getGia());
            ps.setString(4, sp.getUrlAnh());
            ps.setInt(5, sp.getSoLuongTon());
            ps.setString(6, sp.getNhaSanXuat());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean capNhatSanPham(SanPham sp) {
        String sql = "UPDATE san_pham SET ten_san_pham=?, mo_ta=?, gia=?, url_anh=?, so_luong_ton=?, nha_san_xuat=? WHERE id_san_pham=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sp.getTenSanPham());
            ps.setString(2, sp.getMoTa());
            ps.setDouble(3, sp.getGia());
            ps.setString(4, sp.getUrlAnh());
            ps.setInt(5, sp.getSoLuongTon());
            ps.setString(6, sp.getNhaSanXuat());
            ps.setInt(7, sp.getIdSanPham());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean xoaSanPham(int id) {
        String sql = "DELETE FROM san_pham WHERE id_san_pham=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean capNhatTonKho(int id, int soLuong) {
        String sql = "UPDATE san_pham SET so_luong_ton=? WHERE id_san_pham=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, soLuong);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy thông tin sản phẩm theo ID
     * @param idSanPham ID của sản phẩm cần lấy
     * @return Đối tượng SanPham hoặc null nếu không tìm thấy
     */
    public SanPham getById(int idSanPham) {
        return getSanPhamById(idSanPham);
    }
}


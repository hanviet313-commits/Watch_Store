
package com.watchstore.dao;

import com.watchstore.model.GioHang;
import com.watchstore.model.ChiTietGioHang;
import com.watchstore.model.SanPham;
import com.watchstore.util.CSDLUtill;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class GioHangDAO {
    public GioHang getByUser(int idNguoiDung) {
        GioHang gh = null;
        String sqlGh = "SELECT * FROM gio_hang WHERE id_nguoi_dung=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement psGh = conn.prepareStatement(sqlGh)) {
            psGh.setInt(1, idNguoiDung);
            ResultSet rsGh = psGh.executeQuery();
            if (rsGh.next()) {
                gh = new GioHang();
                gh.setIdGioHang(rsGh.getInt("id_gio_hang"));
                gh.setIdNguoiDung(idNguoiDung);
                // load items
                String sqlItems = "SELECT * FROM san_pham_trong_gio WHERE id_gio_hang=?";
                try (PreparedStatement psItems = conn.prepareStatement(sqlItems)) {
                    psItems.setInt(1, gh.getIdGioHang());
                    ResultSet rsIt = psItems.executeQuery();
                    List<ChiTietGioHang> list = new ArrayList<>();
                    SanPhamDAO spDao = new SanPhamDAO();
                    while (rsIt.next()) {
                        ChiTietGioHang it = new ChiTietGioHang();
                        it.setIdGioHang(gh.getIdGioHang());
                        it.setIdSanPham(rsIt.getInt("id_san_pham"));
                        it.setSoLuong(rsIt.getInt("so_luong"));
                        SanPham sp = spDao.getSanPhamById(it.getIdSanPham());
                        it.setSanPham(sp);
                        list.add(it);
                    }
                    gh.setItems(list);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return gh;
    }

    /**
     * Lấy giỏ hàng của người dùng theo ID người dùng
     * @param idNguoiDung ID của người dùng
     * @return Đối tượng GioHang hoặc null nếu không tìm thấy
     */
    public GioHang getByUserId(int idNguoiDung) {
        return getByUser(idNguoiDung);
    }

    public void createCartIfNotExist(int idNguoiDung) {
        String sql = "INSERT IGNORE INTO gio_hang(id_nguoi_dung) VALUES(?)";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idNguoiDung);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean addToCart(int idNguoiDung, int idSanPham, int soLuong) {
        createCartIfNotExist(idNguoiDung);
        GioHang gh = getByUser(idNguoiDung);
        String sqlUp = "UPDATE san_pham_trong_gio SET so_luong=so_luong+? WHERE id_gio_hang=? AND id_san_pham=?";
        String sqlIn = "INSERT INTO san_pham_trong_gio(id_gio_hang,id_san_pham,so_luong) VALUES(?,?,?)";
        try (Connection conn = CSDLUtill.getConnection()) {
            // try update
            try (PreparedStatement psUp = conn.prepareStatement(sqlUp)) {
                psUp.setInt(1, soLuong);
                psUp.setInt(2, gh.getIdGioHang());
                psUp.setInt(3, idSanPham);
                int updated = psUp.executeUpdate();
                if (updated > 0) return true;
            }
            // else insert
            try (PreparedStatement psIn = conn.prepareStatement(sqlIn)) {
                psIn.setInt(1, gh.getIdGioHang());
                psIn.setInt(2, idSanPham);
                psIn.setInt(3, soLuong);
                return psIn.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateQuantity(int idGioHang, int idSanPham, int soLuong) {
        String sql = "UPDATE san_pham_trong_gio SET so_luong=? WHERE id_gio_hang=? AND id_san_pham=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, soLuong);
            ps.setInt(2, idGioHang);
            ps.setInt(3, idSanPham);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeFromCart(int idGioHang, int idSanPham) {
        String sql = "DELETE FROM san_pham_trong_gio WHERE id_gio_hang=? AND id_san_pham=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idGioHang);
            ps.setInt(2, idSanPham);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa toàn bộ sản phẩm trong giỏ hàng
     * @param idGioHang ID của giỏ hàng cần xóa
     * @return true nếu xóa thành công, false nếu có lỗi
     */
    public boolean clearCart(int idGioHang) {
        String sql = "DELETE FROM san_pham_trong_gio WHERE id_gio_hang=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idGioHang);
            ps.executeUpdate();
            return true; // Trả về true ngay cả khi không có sản phẩm nào bị xóa
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}




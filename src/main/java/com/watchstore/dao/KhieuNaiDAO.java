package com.watchstore.dao;

import com.watchstore.model.KhieuNai;
import com.watchstore.util.CSDLUtill;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.TimeZone;

public class KhieuNaiDAO {
    
    static {
        // Cấu hình timezone cho Java application
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
    }

    public boolean guiKhieuNai(KhieuNai kn) {
        String sql = "INSERT INTO khieu_nai(id_don_hang, id_nguoi_dung, noi_dung, trang_thai, yeu_cau_tra_hang) VALUES(?, ?, ?, N'Đang chờ', ?)";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, kn.getIdDonHang());
            ps.setInt(2, kn.getIdNguoiDung());
            ps.setString(3, kn.getNoiDung());
            ps.setBoolean(4, kn.isYeuCauTraHang());
            return ps.executeUpdate() > 0;
        } catch(Exception e) { 
            e.printStackTrace(); 
        }
        return false;
    }

    public List<KhieuNai> getByUser(int idNguoiDung) {
        List<KhieuNai> list = new ArrayList<>();
        String sql = "SELECT * FROM khieu_nai WHERE id_nguoi_dung = ? ORDER BY ngay_gui DESC";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idNguoiDung);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                KhieuNai kn = new KhieuNai();
                kn.setIdKhieuNai(rs.getInt("id_khieu_nai"));
                kn.setIdNguoiDung(rs.getInt("id_nguoi_dung"));
                kn.setIdDonHang(rs.getInt("id_don_hang"));
                kn.setNoiDung(rs.getString("noi_dung"));
                kn.setPhanHoi(rs.getString("phan_hoi"));
                kn.setTrangThai(rs.getString("trang_thai"));
                kn.setNgayGui(rs.getTimestamp("ngay_gui"));
                kn.setYeuCauTraHang(rs.getBoolean("yeu_cau_tra_hang"));
                list.add(kn);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy tất cả khiếu nại kèm theo tên người dùng
     */
    public List<KhieuNai> getAllComplaints() {
        List<KhieuNai> list = new ArrayList<>();
        String sql = "SELECT kn.*, nd.ten_day_du as ho_ten FROM khieu_nai kn " +
                     "JOIN nguoi_dung nd ON kn.id_nguoi_dung = nd.id_nguoi_dung " +
                     "ORDER BY kn.ngay_gui DESC";
        try (Connection conn = CSDLUtill.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            System.out.println("Executing SQL: " + sql); // Debug log
            while (rs.next()) {
                KhieuNai kn = new KhieuNai();
                kn.setIdKhieuNai(rs.getInt("id_khieu_nai"));
                kn.setIdNguoiDung(rs.getInt("id_nguoi_dung"));
                kn.setIdDonHang(rs.getInt("id_don_hang"));
                kn.setNoiDung(rs.getString("noi_dung"));
                kn.setPhanHoi(rs.getString("phan_hoi"));
                kn.setTrangThai(rs.getString("trang_thai"));
                kn.setNgayGui(rs.getTimestamp("ngay_gui"));
                kn.setYeuCauTraHang(rs.getBoolean("yeu_cau_tra_hang"));
                kn.setTenNguoiDung(rs.getString("ho_ten"));
                list.add(kn);
            }
            System.out.println("Found " + list.size() + " complaints"); // Debug log
        } catch (Exception e) {
            System.out.println("Error in getAllComplaints: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy thông tin khiếu nại theo ID
     */
    public KhieuNai getById(int idKhieuNai) {
        String sql = "SELECT kn.*, nd.ten_day_du as ho_ten FROM khieu_nai kn " +
                     "JOIN nguoi_dung nd ON kn.id_nguoi_dung = nd.id_nguoi_dung " +
                     "WHERE kn.id_khieu_nai = ?";
        
        System.out.println("Executing getById for complaint #" + idKhieuNai); // Debug log
        
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idKhieuNai);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    KhieuNai kn = new KhieuNai();
                    kn.setIdKhieuNai(rs.getInt("id_khieu_nai"));
                    kn.setIdNguoiDung(rs.getInt("id_nguoi_dung"));
                    kn.setIdDonHang(rs.getInt("id_don_hang"));
                    kn.setNoiDung(rs.getString("noi_dung"));
                    kn.setPhanHoi(rs.getString("phan_hoi"));
                    kn.setTrangThai(rs.getString("trang_thai"));
                    kn.setNgayGui(rs.getTimestamp("ngay_gui"));
                    kn.setYeuCauTraHang(rs.getBoolean("yeu_cau_tra_hang"));
                    kn.setTenNguoiDung(rs.getString("ho_ten"));
                    
                    System.out.println("Found complaint #" + idKhieuNai); // Debug log
                    return kn;
                } else {
                    System.out.println("Complaint #" + idKhieuNai + " not found in database"); // Debug log
                    return null;
                }
            }
        } catch (Exception e) {
            System.out.println("Error in getById: " + e.getMessage()); // Debug log
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Cập nhật trạng thái khiếu nại
     */
    public boolean updateComplaintStatus(int idKhieuNai, String trangThai, String phanHoi) {
        String sql = "UPDATE khieu_nai SET trang_thai = ?, phan_hoi = ? WHERE id_khieu_nai = ?";
        
        System.out.println("Updating complaint #" + idKhieuNai + 
                          " with status: " + trangThai + 
                          ", response: " + phanHoi); // Debug log
        
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trangThai);
            ps.setString(2, phanHoi);
            ps.setInt(3, idKhieuNai);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Update affected " + rowsAffected + " rows"); // Debug log
            
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Error in updateComplaintStatus: " + e.getMessage()); // Debug log
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy danh sách khiếu nại theo bộ lọc
     */
    public List<KhieuNai> getFilteredComplaints(String trangThai, Boolean yeuCauTraHang, String search) {
        List<KhieuNai> list = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(
            "SELECT kn.*, nd.ten_day_du as ho_ten FROM khieu_nai kn " +
            "JOIN nguoi_dung nd ON kn.id_nguoi_dung = nd.id_nguoi_dung WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        
        // Thêm điều kiện lọc theo trạng thái
        if (trangThai != null && !trangThai.isEmpty()) {
            sqlBuilder.append(" AND kn.trang_thai = ?");
            params.add(trangThai);
        }
        
        // Thêm điều kiện lọc theo yêu cầu trả hàng
        if (yeuCauTraHang != null) {
            sqlBuilder.append(" AND kn.yeu_cau_tra_hang = ?");
            params.add(yeuCauTraHang);
        }
        
        // Thêm điều kiện tìm kiếm
        if (search != null && !search.isEmpty()) {
            sqlBuilder.append(" AND (kn.id_khieu_nai LIKE ? OR nd.ten_day_du LIKE ? OR kn.id_don_hang LIKE ? OR kn.noi_dung LIKE ?)");
            String searchPattern = "%" + search + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Thêm sắp xếp
        sqlBuilder.append(" ORDER BY kn.ngay_gui DESC");
        
        String sql = sqlBuilder.toString();
        System.out.println("Executing SQL: " + sql); // Debug log
        System.out.println("With params: " + params); // Debug log
        
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Thiết lập các tham số
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                KhieuNai kn = new KhieuNai();
                kn.setIdKhieuNai(rs.getInt("id_khieu_nai"));
                kn.setIdNguoiDung(rs.getInt("id_nguoi_dung"));
                kn.setIdDonHang(rs.getInt("id_don_hang"));
                kn.setNoiDung(rs.getString("noi_dung"));
                kn.setPhanHoi(rs.getString("phan_hoi"));
                kn.setTrangThai(rs.getString("trang_thai"));
                kn.setNgayGui(rs.getTimestamp("ngay_gui"));
                kn.setYeuCauTraHang(rs.getBoolean("yeu_cau_tra_hang"));
                kn.setTenNguoiDung(rs.getString("ho_ten"));
                list.add(kn);
            }
            System.out.println("Found " + list.size() + " filtered complaints"); // Debug log
        } catch (Exception e) {
            System.out.println("Error in getFilteredComplaints: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
}








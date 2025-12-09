package com.watchstore.dao;

import com.watchstore.model.NguoiDung;
import com.watchstore.util.CSDLUtill;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.TimeZone;

public class NguoiDungDAO {
    
    static {
        // Cấu hình timezone cho Java application
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
    }

    public NguoiDung checkLogin(String email, String hashedPassword) {
        String sql = "SELECT * FROM nguoi_dung WHERE email=? AND mat_khau=? AND trang_thai=1";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                NguoiDung nd = new NguoiDung();
                nd.setIdNguoiDung(rs.getInt("id_nguoi_dung"));
                nd.setTenDayDu(rs.getString("ten_day_du"));
                nd.setEmail(rs.getString("email"));
                nd.setVaiTro(rs.getString("vai_tro"));
                nd.setTrangThai(rs.getInt("trang_thai"));
                return nd;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertNguoiDung(NguoiDung nd) {
        String sql = "INSERT INTO nguoi_dung(ten_day_du,email,mat_khau,sdt,vai_tro,trang_thai) VALUES(?,?,?,?,?,1)";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nd.getTenDayDu());
            ps.setString(2, nd.getEmail());
            ps.setString(3, nd.getMatKhau());
            ps.setString(4, nd.getSdt());
            ps.setString(5, nd.getVaiTro());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<NguoiDung> getAllUsers() {
        List<NguoiDung> list = new ArrayList<>();
        String sql = "SELECT * FROM nguoi_dung";
        try (Connection conn = CSDLUtill.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                NguoiDung nd = new NguoiDung();
                nd.setIdNguoiDung(rs.getInt("id_nguoi_dung"));
                nd.setTenDayDu(rs.getString("ten_day_du"));
                nd.setEmail(rs.getString("email"));
                nd.setVaiTro(rs.getString("vai_tro"));
                nd.setTrangThai(rs.getInt("trang_thai"));
                list.add(nd);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateRole(int idNguoiDung, String newRole) {
        String sql = "UPDATE nguoi_dung SET vai_tro=? WHERE id_nguoi_dung=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newRole);
            ps.setInt(2, idNguoiDung);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStatus(int idNguoiDung, int trangThai) {
        String sql = "UPDATE nguoi_dung SET trang_thai=? WHERE id_nguoi_dung=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trangThai);
            ps.setInt(2, idNguoiDung);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateProfile(NguoiDung nd) {
        String sql = "UPDATE nguoi_dung SET ten_day_du=?, sdt=? WHERE id_nguoi_dung=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nd.getTenDayDu());
            ps.setString(2, nd.getSdt());
            ps.setInt(3, nd.getIdNguoiDung());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int getTotalCustomers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM nguoi_dung WHERE vai_tro = 'customer'";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int insertAndGetId(NguoiDung nd) {
        String sql = "INSERT INTO nguoi_dung(ten_day_du,email,mat_khau,sdt,vai_tro,trang_thai) VALUES(?,?,?,?,?,1)";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, nd.getTenDayDu());
            ps.setString(2, nd.getEmail());
            ps.setString(3, nd.getMatKhau());
            ps.setString(4, nd.getSdt());
            ps.setString(5, nd.getVaiTro());
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * Kiểm tra mật khẩu của người dùng
     * @param idNguoiDung ID của người dùng
     * @param hashedPassword Mật khẩu đã được mã hóa
     * @return true nếu mật khẩu đúng, false nếu sai
     */
    public boolean checkPassword(int idNguoiDung, String hashedPassword) {
        String sql = "SELECT COUNT(*) FROM nguoi_dung WHERE id_nguoi_dung=? AND mat_khau=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idNguoiDung);
            ps.setString(2, hashedPassword);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật mật khẩu của người dùng
     * @param idNguoiDung ID của người dùng
     * @param newHashedPassword Mật khẩu mới đã được mã hóa
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updatePassword(int idNguoiDung, String newHashedPassword) {
        String sql = "UPDATE nguoi_dung SET mat_khau=? WHERE id_nguoi_dung=?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHashedPassword);
            ps.setInt(2, idNguoiDung);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đếm tổng số người dùng
    public int countAllUsers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM nguoi_dung";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // Đếm số người dùng theo vai trò
    public int countUsersByRole(String vaiTro) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM nguoi_dung WHERE vai_tro = ?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vaiTro);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // Kiểm tra kết nối cơ sở dữ liệu
    public boolean testConnection() {
        try (Connection conn = CSDLUtill.getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Sửa lại phương thức countDisabledUsers()
    public int countDisabledUsers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM nguoi_dung WHERE trang_thai = 0";
        
        try {
            // Kiểm tra kết nối trước
            if (!testConnection()) {
                System.out.println("Không thể kết nối đến cơ sở dữ liệu!");
                return 0;
            }
            
            try (Connection conn = CSDLUtill.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    count = rs.getInt(1);
                }
                System.out.println("SQL: " + sql);
                System.out.println("Số lượng tài khoản bị khóa: " + count);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }

    // Lấy danh sách người dùng mới đăng ký
    public List<NguoiDung> getRecentUsers(int limit) {
        List<NguoiDung> users = new ArrayList<>();
        String sql = "SELECT * FROM nguoi_dung ORDER BY ngay_tao DESC LIMIT ?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                NguoiDung user = new NguoiDung();
                user.setIdNguoiDung(rs.getInt("id_nguoi_dung"));
                user.setTenDayDu(rs.getString("ten_day_du"));
                user.setEmail(rs.getString("email"));
                user.setSdt(rs.getString("sdt"));
                user.setVaiTro(rs.getString("vai_tro"));
                user.setTrangThai(rs.getInt("trang_thai"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Cập nhật trạng thái người dùng
    public boolean updateUserStatus(int idNguoiDung, int trangThai) {
        String sql = "UPDATE nguoi_dung SET trang_thai = ? WHERE id_nguoi_dung = ?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trangThai);
            ps.setInt(2, idNguoiDung);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật vai trò người dùng
    public boolean updateUserRole(int idNguoiDung, String vaiTro) {
        String sql = "UPDATE nguoi_dung SET vai_tro = ? WHERE id_nguoi_dung = ?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vaiTro);
            ps.setInt(2, idNguoiDung);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật thông tin người dùng
    public boolean updateUser(NguoiDung user) {
        String sql = "UPDATE nguoi_dung SET ten_day_du = ?, email = ?, sdt = ? WHERE id_nguoi_dung = ?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getTenDayDu());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getSdt());
            ps.setInt(4, user.getIdNguoiDung());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy thông tin người dùng theo ID
    public NguoiDung getUserById(int idNguoiDung) {
        String sql = "SELECT * FROM nguoi_dung WHERE id_nguoi_dung = ?";
        try (Connection conn = CSDLUtill.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idNguoiDung);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                NguoiDung user = new NguoiDung();
                user.setIdNguoiDung(rs.getInt("id_nguoi_dung"));
                user.setTenDayDu(rs.getString("ten_day_du"));
                user.setEmail(rs.getString("email"));
                user.setSdt(rs.getString("sdt"));
                user.setVaiTro(rs.getString("vai_tro"));
                user.setTrangThai(rs.getInt("trang_thai"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm phương thức addUser() để tương thích với AdminUserActionServlet
    public boolean addUser(NguoiDung nd) {
        return insertNguoiDung(nd);
    }
}






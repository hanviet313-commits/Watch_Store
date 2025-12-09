package com.watchstore.model;
import java.util.Date;

public class NguoiDung {
    private int idNguoiDung;
    private String tenDayDu;
    private String email;
    private String matKhau;
    private String sdt;
    private String vaiTro;
    private int trangThai;
    private Date ngayTao;

    public int getIdNguoiDung() { return idNguoiDung; }
    public void setIdNguoiDung(int idNguoiDung) { this.idNguoiDung = idNguoiDung; }
    public String getTenDayDu() { return tenDayDu; }
    public void setTenDayDu(String tenDayDu) { this.tenDayDu = tenDayDu; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getMatKhau() { return matKhau; }
    public void setMatKhau(String matKhau) { this.matKhau = matKhau; }
    public String getSdt() { return sdt; }
    public void setSdt(String sdt) { this.sdt = sdt; }
    public String getVaiTro() { return vaiTro; }
    public void setVaiTro(String vaiTro) { this.vaiTro = vaiTro; }
    public int getTrangThai() { return trangThai; }
    public void setTrangThai(int trangThai) { this.trangThai = trangThai; }
    public Date getNgayTao() { return ngayTao; }
    public void setNgayTao(Date ngayTao) { this.ngayTao = ngayTao; }
}
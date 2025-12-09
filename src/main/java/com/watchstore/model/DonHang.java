
package com.watchstore.model;

import java.util.Date;
import java.util.List;

public class DonHang {
    private int idDonHang;
    private int idNguoiDung;
    private Date ngayDat;
    private String trangThai;
    private double tongTien;
    private String diaChi;
    private String sdtNguoiNhan;
    private List<ChiTietDonHang> items;

    public int getIdDonHang() { return idDonHang; }
    public void setIdDonHang(int idDonHang) { this.idDonHang = idDonHang; }
    public int getIdNguoiDung() { return idNguoiDung; }
    public void setIdNguoiDung(int idNguoiDung) { this.idNguoiDung = idNguoiDung; }
    public Date getNgayDat() { return ngayDat; }
    public void setNgayDat(Date ngayDat) { this.ngayDat = ngayDat; }
    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
    public double getTongTien() { return tongTien; }
    public void setTongTien(double tongTien) { this.tongTien = tongTien; }
    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }
    public String getSdtNguoiNhan() { return sdtNguoiNhan; }
    public void setSdtNguoiNhan(String sdtNguoiNhan) { this.sdtNguoiNhan = sdtNguoiNhan; }
    public List<ChiTietDonHang> getItems() { return items; }
    public void setItems(List<ChiTietDonHang> items) { this.items = items; }
}

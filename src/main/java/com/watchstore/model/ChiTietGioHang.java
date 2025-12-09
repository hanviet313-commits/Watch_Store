
package com.watchstore.model;

public class ChiTietGioHang {
    private int idGioHang;
    private int idSanPham;
    private int soLuong;
    private SanPham sanPham;

    public int getIdGioHang() { return idGioHang; }
    public void setIdGioHang(int idGioHang) { this.idGioHang = idGioHang; }
    public int getIdSanPham() { return idSanPham; }
    public void setIdSanPham(int idSanPham) { this.idSanPham = idSanPham; }
    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }
    public SanPham getSanPham() { return sanPham; }
    public void setSanPham(SanPham sanPham) { this.sanPham = sanPham; }
}

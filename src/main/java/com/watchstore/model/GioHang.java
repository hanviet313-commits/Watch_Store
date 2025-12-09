
package com.watchstore.model;

import java.util.List;

public class GioHang {
    private int idGioHang;
    private int idNguoiDung;
    private List<ChiTietGioHang> items;

    public int getIdGioHang() { return idGioHang; }
    public void setIdGioHang(int idGioHang) { this.idGioHang = idGioHang; }
    public int getIdNguoiDung() { return idNguoiDung; }
    public void setIdNguoiDung(int idNguoiDung) { this.idNguoiDung = idNguoiDung; }
    public List<ChiTietGioHang> getItems() { return items; }
    public void setItems(List<ChiTietGioHang> items) { this.items = items; }
}

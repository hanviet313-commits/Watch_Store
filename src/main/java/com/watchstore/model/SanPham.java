package com.watchstore.model;

public class SanPham {
    private int idSanPham;
    private String tenSanPham;
    private String moTa;
    private double gia;
    private int soLuongTon;
    private String urlAnh;
    private String nhaSanXuat;

    public SanPham() {
    }

    public SanPham(int idSanPham, String tenSanPham, String moTa, double gia, int soLuongTon, String urlAnh, String nhaSanXuat) {
        this.idSanPham = idSanPham;
        this.tenSanPham = tenSanPham;
        this.moTa = moTa;
        this.gia = gia;
        this.soLuongTon = soLuongTon;
        this.urlAnh = urlAnh;
        this.nhaSanXuat = nhaSanXuat;
    }

    public int getIdSanPham() {
        return idSanPham;
    }

    public void setIdSanPham(int idSanPham) {
        this.idSanPham = idSanPham;
    }

    public String getTenSanPham() {
        return tenSanPham;
    }

    public void setTenSanPham(String tenSanPham) {
        this.tenSanPham = tenSanPham;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public double getGia() {
        return gia;
    }

    public void setGia(double gia) {
        this.gia = gia;
    }

    public int getSoLuongTon() {
        return soLuongTon;
    }

    public void setSoLuongTon(int soLuongTon) {
        this.soLuongTon = soLuongTon;
    }

    public String getUrlAnh() {
        return urlAnh;
    }

    public void setUrlAnh(String urlAnh) {
        this.urlAnh = urlAnh;
    }

    public String getNhaSanXuat() {
        return nhaSanXuat;
    }

    public void setNhaSanXuat(String nhaSanXuat) {
        this.nhaSanXuat = nhaSanXuat;
    }

    @Override
    public String toString() {
        return "SanPham{" +
                "idSanPham=" + idSanPham +
                ", tenSanPham='" + tenSanPham + '\'' +
                ", moTa='" + moTa + '\'' +
                ", gia=" + gia +
                ", soLuongTon=" + soLuongTon +
                ", urlAnh='" + urlAnh + '\'' +
                ", nhaSanXuat='" + nhaSanXuat + '\'' +
                '}';
    }
}

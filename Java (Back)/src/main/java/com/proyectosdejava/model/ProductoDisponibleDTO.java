package com.proyectosdejava.model;

import java.math.BigDecimal;

public class ProductoDisponibleDTO {

    private Integer codigo;
    private String nombre;
    private String marca;
    private String categoria;
    private String unidad;
    private Integer stockDisponible;
    private BigDecimal precio;

    public ProductoDisponibleDTO(Integer codigo, String nombre, String marca, String categoria,
                                 String unidad, Integer stockDisponible, BigDecimal precio) {
        this.codigo = codigo;
        this.nombre = nombre;
        this.marca = marca;
        this.categoria = categoria;
        this.unidad = unidad;
        this.stockDisponible = stockDisponible;
        this.precio = precio;
    }

    public Integer getCodigo() {
        return codigo;
    }

    public void setCodigo(Integer codigo) {
        this.codigo = codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getUnidad() {
        return unidad;
    }

    public void setUnidad(String unidad) {
        this.unidad = unidad;
    }

    public Integer getStockDisponible() {
        return stockDisponible;
    }

    public void setStockDisponible(Integer stockDisponible) {
        this.stockDisponible = stockDisponible;
    }

    public BigDecimal getPrecio() {
        return precio;
    }

    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }
}

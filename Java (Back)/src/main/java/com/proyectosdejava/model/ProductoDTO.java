package com.proyectosdejava.model;

import java.math.BigDecimal;

/*Esto es el equivalente a la los SELECT, por lo mismo que producto es una tabla que se compone de otras*/
public class ProductoDTO {

    private Integer codigo;
    private String nombre;
    private String marca;
    private String categoria;
    private String unidadMedida;
    private Integer stockActual;
    private Integer stockMinimo;
    private BigDecimal precio;

    // Constructor con todos los campos
    public ProductoDTO(Integer codigo, String nombre, String marca,
                       String categoria, String unidadMedida,
                       Integer stockActual, Integer stockMinimo,
                       BigDecimal precio) {
        this.codigo = codigo;
        this.nombre = nombre;
        this.marca = marca;
        this.categoria = categoria;
        this.unidadMedida = unidadMedida;
        this.stockActual = stockActual;
        this.stockMinimo = stockMinimo;
        this.precio = precio;
    }

    public Integer getCodigo() {
        return codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public String getMarca() {
        return marca;
    }

    public String getCategoria() {
        return categoria;
    }

    public String getUnidadMedida() {
        return unidadMedida;
    }

    public Integer getStockActual() {
        return stockActual;
    }

    public Integer getStockMinimo() {
        return stockMinimo;
    }

    public BigDecimal getPrecio() {
        return precio;
    }
}

package com.proyectosdejava.model;

import java.math.BigDecimal;

public class HistorialVentaDTO {

    private Integer codigo;
    private String fecha;
    private String usuario;
    private String correo;
    private String rol;
    private BigDecimal total;
    private Integer estado;

    public HistorialVentaDTO(Integer codigo, String fecha, String usuario, String correo,
                             String rol, BigDecimal total, Integer estado) {
        this.codigo = codigo;
        this.fecha = fecha;
        this.usuario = usuario;
        this.correo = correo;
        this.rol = rol;
        this.total = total;
        this.estado = estado;
    }

    public Integer getCodigo() {
        return codigo;
    }

    public void setCodigo(Integer codigo) {
        this.codigo = codigo;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public Integer getEstado() {
        return estado;
    }

    public void setEstado(Integer estado) {
        this.estado = estado;
    }
}

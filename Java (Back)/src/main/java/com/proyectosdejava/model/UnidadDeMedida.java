package com.proyectosdejava.model;

import jakarta.persistence.*;

@Entity
@Table(name = "unidad_de_medida")
public class UnidadDeMedida {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_unidad_de_medida")
    private Integer idUnidadDeMedida;

    private String nombre;
    private String abreviacion;
    private String descripcion;
    private Integer estado;

    public Integer getIdUnidadDeMedida() {
        return idUnidadDeMedida;
    }

    public void setIdUnidadDeMedida(Integer idUnidadDeMedida) {
        this.idUnidadDeMedida = idUnidadDeMedida;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getAbreviacion() {
        return abreviacion;
    }

    public void setAbreviacion(String abreviacion) {
        this.abreviacion = abreviacion;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Integer getEstado() {
        return estado;
    }

    public void setEstado(Integer estado) {
        this.estado = estado;
    }
}
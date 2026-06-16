package com.proyectosdejava.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class CategoriaRepository {

    @PersistenceContext
    private EntityManager em;

    public List<Object[]> buscarActivas(String nombre) {
        return em.createStoredProcedureQuery("sp_buscar_categorias_activas")
                .registerStoredProcedureParameter("c_nombre", String.class, ParameterMode.IN)
                .setParameter("c_nombre", nombre)
                .getResultList();
    }

    public List<Object[]> buscarInactivas(String nombre) {
        return em.createStoredProcedureQuery("sp_buscar_categorias_inactivas")
                .registerStoredProcedureParameter("c_nombre", String.class, ParameterMode.IN)
                .setParameter("c_nombre", nombre)
                .getResultList();
    }

    public String crear(String nombre, String descripcion) {
        StoredProcedureQuery query = em.createStoredProcedureQuery("sp_categoria_crear")
                .registerStoredProcedureParameter("c_nombre",      String.class, ParameterMode.IN)
                .registerStoredProcedureParameter("c_descripcion", String.class, ParameterMode.IN)
                .registerStoredProcedureParameter("c_resultado",   String.class, ParameterMode.OUT)
                .setParameter("c_nombre",      nombre)
                .setParameter("c_descripcion", descripcion);
        query.execute();
        return (String) query.getOutputParameterValue("c_resultado");
    }

    public String editar(Integer idCategoria, String nombre, String descripcion) {
        StoredProcedureQuery query = em.createStoredProcedureQuery("sp_categoria_editar")
                .registerStoredProcedureParameter("c_id_categoria", Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter("c_nombre",       String.class,  ParameterMode.IN)
                .registerStoredProcedureParameter("c_descripcion",  String.class,  ParameterMode.IN)
                .registerStoredProcedureParameter("c_resultado",    String.class,  ParameterMode.OUT)
                .setParameter("c_id_categoria", idCategoria)
                .setParameter("c_nombre",       nombre)
                .setParameter("c_descripcion",  descripcion);
        query.execute();
        return (String) query.getOutputParameterValue("c_resultado");
    }

    public String cambiarEstado(Integer idCategoria, Integer estado) {
        StoredProcedureQuery query = em.createStoredProcedureQuery("sp_categoria_cambiar_estado")
                .registerStoredProcedureParameter("p_id_categoria", Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter("p_estado",       Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter("p_resultado",    String.class,  ParameterMode.OUT)
                .setParameter("p_id_categoria", idCategoria)
                .setParameter("p_estado",       estado);
        query.execute();
        return (String) query.getOutputParameterValue("p_resultado");
    }
}
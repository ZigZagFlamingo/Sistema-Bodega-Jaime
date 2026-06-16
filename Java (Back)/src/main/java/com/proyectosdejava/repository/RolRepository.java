package com.proyectosdejava.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class RolRepository {

    @PersistenceContext
    private EntityManager em;

    public List<Object[]> buscarActivos(String nombre, String descripcion) {
        return em.createStoredProcedureQuery("sp_buscar_roles_activos")
                .registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .setParameter(1, nombre)
                .setParameter(2, descripcion)
                .getResultList();
    }

    public List<Object[]> buscarInactivos(String nombre, String descripcion) {
        return em.createStoredProcedureQuery("sp_buscar_roles_inactivos")
                .registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .setParameter(1, nombre)
                .setParameter(2, descripcion)
                .getResultList();
    }

    public String crear(String nombre, String descripcion) {
        StoredProcedureQuery query = em.createStoredProcedureQuery("sp_rol_crear")
                .registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.OUT)
                .setParameter(1, nombre)
                .setParameter(2, descripcion);
        query.execute();
        return (String) query.getOutputParameterValue(3);
    }

    public String editar(Integer idRol, String nombre, String descripcion) {
        StoredProcedureQuery query = em.createStoredProcedureQuery("sp_rol_editar")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(4, String.class, ParameterMode.OUT)
                .setParameter(1, idRol)
                .setParameter(2, nombre)
                .setParameter(3, descripcion);
        query.execute();
        return (String) query.getOutputParameterValue(4);
    }

    public String cambiarEstado(Integer idRol, Integer estado) {
        StoredProcedureQuery query = em.createStoredProcedureQuery("sp_rol_cambiar_estado")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.OUT)
                .setParameter(1, idRol)
                .setParameter(2, estado);
        query.execute();
        return (String) query.getOutputParameterValue(3);
    }
}

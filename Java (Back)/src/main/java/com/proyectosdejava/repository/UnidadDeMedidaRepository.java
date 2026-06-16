package com.proyectosdejava.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class UnidadDeMedidaRepository {

    @PersistenceContext
    private EntityManager em;

    //Búsqueda activas con filtros opcionales
    public List<Object[]> buscarActivas(String nombre, String abreviacion) {
        return em.createStoredProcedureQuery("sp_buscar_unidades_de_medida_activas")
                .registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .setParameter(1, nombre)      // null si no se filtra
                .setParameter(2, abreviacion) // null si no se filtra
                .getResultList();
    }

    //Búsqueda inactivas con filtros opcionales
    public List<Object[]> buscarInactivas(String nombre, String abreviacion) {
        return em.createStoredProcedureQuery("sp_buscar_unidades_de_medida_inactivas")
                .registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .setParameter(1, nombre)
                .setParameter(2, abreviacion)
                .getResultList();
    }

    //Crear — tiene parámetro OUT
    public String crear(String nombre, String abreviacion, String descripcion) {
        StoredProcedureQuery query = em
                .createStoredProcedureQuery("sp_unidad_de_medida_crear")
                .registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(4, String.class, ParameterMode.OUT)
                .setParameter(1, nombre)
                .setParameter(2, abreviacion)
                .setParameter(3, descripcion);
        query.execute();
        return (String) query.getOutputParameterValue(4); // "OK:..." o "ERROR:..."
    }

    //Editar — tiene parámetro OUT
    public String editar(Integer id, String nombre, String abreviacion, String descripcion) {
        StoredProcedureQuery query = em
                .createStoredProcedureQuery("sp_unidad_de_medida_editar")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(4, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(5, String.class, ParameterMode.OUT)
                .setParameter(1, id)
                .setParameter(2, nombre)
                .setParameter(3, abreviacion)
                .setParameter(4, descripcion);
        query.execute();
        return (String) query.getOutputParameterValue(5);
    }

    //Cambiar estado — tiene parámetro OUT
    public String cambiarEstado(Integer id, Integer estado) {
        StoredProcedureQuery query = em
                .createStoredProcedureQuery("sp_unidad_de_medida_cambiar_estado")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.OUT)
                .setParameter(1, id)
                .setParameter(2, estado);
        query.execute();
        return (String) query.getOutputParameterValue(3);
    }
}
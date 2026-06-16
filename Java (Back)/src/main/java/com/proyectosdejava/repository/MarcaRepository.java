package com.proyectosdejava.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class MarcaRepository {

    @PersistenceContext
    private EntityManager em;

    //Búsqueda activas
    public List<Object[]> buscarActivas(String nombre, String empresa) {
        return em.createStoredProcedureQuery("sp_buscar_marcas_activas")
                .registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .setParameter(1, nombre)
                .setParameter(2, empresa)
                .getResultList();
    }

    //Búsqueda inactivas
    public List<Object[]> buscarInactivas(String nombre, String empresa) {
        return em.createStoredProcedureQuery("sp_buscar_marcas_inactivas")
                .registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .setParameter(1, nombre)
                .setParameter(2, empresa)
                .getResultList();
    }

    //Crear
    public String crear(String nombre, String empresa) {
        StoredProcedureQuery query = em
                .createStoredProcedureQuery("sp_marca_crear")
                .registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.OUT)
                .setParameter(1, nombre)
                .setParameter(2, empresa);
        query.execute();
        return (String) query.getOutputParameterValue(3);
    }

    //Editar
    public String editar(Integer idMarca, String nombre, String empresa) {
        StoredProcedureQuery query = em
                .createStoredProcedureQuery("sp_marca_editar")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class,  ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class,  ParameterMode.IN)
                .registerStoredProcedureParameter(4, String.class,  ParameterMode.OUT)
                .setParameter(1, idMarca)
                .setParameter(2, nombre)
                .setParameter(3, empresa);
        query.execute();
        return (String) query.getOutputParameterValue(4);
    }

    //Cambiar estado
    public String cambiarEstado(Integer idMarca, Integer estado) {
        StoredProcedureQuery query = em
                .createStoredProcedureQuery("sp_marca_cambiar_estado")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class,  ParameterMode.OUT)
                .setParameter(1, idMarca)
                .setParameter(2, estado);
        query.execute();
        return (String) query.getOutputParameterValue(3);
    }
}

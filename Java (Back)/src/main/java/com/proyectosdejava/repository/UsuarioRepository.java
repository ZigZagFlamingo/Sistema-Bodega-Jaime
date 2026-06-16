package com.proyectosdejava.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class UsuarioRepository {

    @PersistenceContext
    private EntityManager em;

    public List<Object[]> buscarActivos(String nombre, String correo, String rol) {
        return em.createStoredProcedureQuery("sp_buscar_usuarios_activos")
                .registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
                .setParameter(1, nombre)
                .setParameter(2, correo)
                .setParameter(3, rol)
                .getResultList();
    }

    public List<Object[]> buscarInactivos(String nombre, String correo, String rol) {
        return em.createStoredProcedureQuery("sp_buscar_usuarios_inactivos")
                .registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
                .setParameter(1, nombre)
                .setParameter(2, correo)
                .setParameter(3, rol)
                .getResultList();
    }

    public String crear(Integer idRol, String nombre, String correo, String password) {
        StoredProcedureQuery query = em.createStoredProcedureQuery("sp_usuario_crear")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(4, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(5, String.class, ParameterMode.OUT)
                .setParameter(1, idRol)
                .setParameter(2, nombre)
                .setParameter(3, correo)
                .setParameter(4, password);
        query.execute();
        return (String) query.getOutputParameterValue(5);
    }

    public String editar(Integer idUsuario, Integer idRol, String nombre, String correo, String password) {
        StoredProcedureQuery query = em.createStoredProcedureQuery("sp_usuario_editar")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(4, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(5, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(6, String.class, ParameterMode.OUT)
                .setParameter(1, idUsuario)
                .setParameter(2, idRol)
                .setParameter(3, nombre)
                .setParameter(4, correo)
                .setParameter(5, password);
        query.execute();
        return (String) query.getOutputParameterValue(6);
    }

    public String cambiarEstado(Integer idUsuario, Integer estado) {
        StoredProcedureQuery query = em.createStoredProcedureQuery("sp_usuario_cambiar_estado")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.OUT)
                .setParameter(1, idUsuario)
                .setParameter(2, estado);
        query.execute();
        return (String) query.getOutputParameterValue(3);
    }

    public boolean tieneRol(Integer idUsuario, String nombreRol) {
        Number total = (Number) em.createNativeQuery(
                        "SELECT COUNT(*) FROM usuario u " +
                                "INNER JOIN rol r ON u.id_rol = r.id_rol " +
                                "WHERE u.id_usuario = :idUsuario " +
                                "AND u.estado = 1 " +
                                "AND LOWER(r.nombre) = LOWER(:nombreRol)")
                .setParameter("idUsuario", idUsuario)
                .setParameter("nombreRol", nombreRol)
                .getSingleResult();
        return total.intValue() > 0;
    }
}

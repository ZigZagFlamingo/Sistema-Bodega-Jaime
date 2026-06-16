package com.proyectosdejava.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class AuthRepository {

    @PersistenceContext
    private EntityManager em;

    /**
     * Busca un usuario activo por correo y contraseña.
     * Retorna un Map con los datos del usuario (id, nombre, correo, rol, nombreRol),
     * o null si las credenciales son incorrectas o el usuario está inactivo.
     */
    public Map<String, Object> buscarPorCredenciales(String correo, String password) {
        List<Object[]> resultados = em.createNativeQuery(
                "SELECT u.id_usuario, u.nombre, u.correo, u.id_rol, r.nombre AS nombre_rol " +
                "FROM usuario u " +
                "INNER JOIN rol r ON u.id_rol = r.id_rol " +
                "WHERE u.correo = :correo " +
                "AND u.password = :password " +
                "AND u.estado = 1"
        )
        .setParameter("correo", correo)
        .setParameter("password", password)
        .getResultList();

        if (resultados.isEmpty()) return null;

        Object[] fila = resultados.get(0);
        Map<String, Object> usuario = new HashMap<>();
        usuario.put("idUsuario", fila[0]);
        usuario.put("nombre", fila[1]);
        usuario.put("correo", fila[2]);
        usuario.put("idRol", fila[3]);
        usuario.put("rol", fila[4]);      // nombre del rol en minúsculas lo maneja el frontend
        usuario.put("nombreRol", fila[4]);

        return usuario;
    }
}

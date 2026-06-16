package com.proyectosdejava.service;

import com.proyectosdejava.repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UsuarioService {

    private final UsuarioRepository repository;

    public UsuarioService(UsuarioRepository repository) {
        this.repository = repository;
    }

    public List<Object[]> buscarActivos(String nombre, String correo, String rol) {
        return repository.buscarActivos(nombre, correo, rol);
    }

    public List<Object[]> buscarInactivos(String nombre, String correo, String rol) {
        return repository.buscarInactivos(nombre, correo, rol);
    }

    @Transactional
    public Map<String, String> crear(Integer idRol, String nombre, String correo, String password) {
        return buildRespuesta(repository.crear(idRol, nombre, correo, password));
    }

    @Transactional
    public Map<String, String> editar(Integer idUsuario, Integer idRol, String nombre,
                                      String correo, String password) {
        return buildRespuesta(repository.editar(idUsuario, idRol, nombre, correo, password));
    }

    @Transactional
    public Map<String, String> cambiarEstado(Integer idUsuario, Integer estado) {
        return buildRespuesta(repository.cambiarEstado(idUsuario, estado));
    }

    private Map<String, String> buildRespuesta(String resultado) {
        Map<String, String> respuesta = new HashMap<>();
        respuesta.put("mensaje", resultado);
        return respuesta;
    }
}

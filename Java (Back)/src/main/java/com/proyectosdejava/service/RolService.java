package com.proyectosdejava.service;

import com.proyectosdejava.repository.RolRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class RolService {

    private final RolRepository repository;

    public RolService(RolRepository repository) {
        this.repository = repository;
    }

    public List<Object[]> buscarActivos(String nombre, String descripcion) {
        return repository.buscarActivos(nombre, descripcion);
    }

    public List<Object[]> buscarInactivos(String nombre, String descripcion) {
        return repository.buscarInactivos(nombre, descripcion);
    }

    @Transactional
    public Map<String, String> crear(String nombre, String descripcion) {
        return buildRespuesta(repository.crear(nombre, descripcion));
    }

    @Transactional
    public Map<String, String> editar(Integer id, String nombre, String descripcion) {
        return buildRespuesta(repository.editar(id, nombre, descripcion));
    }

    @Transactional
    public Map<String, String> cambiarEstado(Integer id, Integer estado) {
        return buildRespuesta(repository.cambiarEstado(id, estado));
    }

    private Map<String, String> buildRespuesta(String resultado) {
        Map<String, String> respuesta = new HashMap<>();
        respuesta.put("mensaje", resultado);
        return respuesta;
    }
}

package com.proyectosdejava.service;

import com.proyectosdejava.repository.CategoriaRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CategoriaService {

    @Autowired
    private CategoriaRepository repository;

    public List<Object[]> buscarActivas(String nombre) {
        return repository.buscarActivas(nombre);
    }

    public List<Object[]> buscarInactivas(String nombre) {
        return repository.buscarInactivas(nombre);
    }

    @Transactional
    public Map<String, String> crear(String nombre, String descripcion) {
        return buildRespuesta(repository.crear(nombre, descripcion));
    }

    @Transactional
    public Map<String, String> editar(Integer idCategoria, String nombre, String descripcion) {
        return buildRespuesta(repository.editar(idCategoria, nombre, descripcion));
    }

    @Transactional
    public Map<String, String> cambiarEstado(Integer idCategoria, Integer estado) {
        return buildRespuesta(repository.cambiarEstado(idCategoria, estado));
    }

    private Map<String, String> buildRespuesta(String resultado) {
        Map<String, String> respuesta = new HashMap<>();
        respuesta.put("mensaje", resultado);
        return respuesta;
    }
}
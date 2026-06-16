package com.proyectosdejava.service;

import com.proyectosdejava.repository.UnidadDeMedidaRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UnidadDeMedidaService {

    private final UnidadDeMedidaRepository repository;

    public UnidadDeMedidaService(UnidadDeMedidaRepository repository) {
        this.repository = repository;
    }

    public List<Object[]> buscarActivas(String nombre, String abreviacion) {
        return repository.buscarActivas(nombre, abreviacion);
    }

    public List<Object[]> buscarInactivas(String nombre, String abreviacion) {
        return repository.buscarInactivas(nombre, abreviacion);
    }

    @Transactional
    public Map<String, String> crear(String nombre, String abreviacion, String descripcion) {
        String resultado = repository.crear(nombre, abreviacion, descripcion);
        return buildRespuesta(resultado);
    }

    @Transactional
    public Map<String, String> editar(Integer id, String nombre, String abreviacion, String descripcion) {
        String resultado = repository.editar(id, nombre, abreviacion, descripcion);
        return buildRespuesta(resultado);
    }

    @Transactional
    public Map<String, String> cambiarEstado(Integer id, Integer estado) {
        String resultado = repository.cambiarEstado(id, estado);
        return buildRespuesta(resultado);
    }

    private Map<String, String> buildRespuesta(String resultado) {
        Map<String, String> respuesta = new HashMap<>();
        respuesta.put("mensaje", resultado);
        return respuesta;
    }
}
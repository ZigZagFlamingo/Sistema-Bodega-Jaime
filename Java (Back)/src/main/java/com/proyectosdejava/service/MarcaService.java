package com.proyectosdejava.service;

import com.proyectosdejava.repository.MarcaRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MarcaService {

    private final MarcaRepository repository;

    public MarcaService(MarcaRepository repository) {
        this.repository = repository;
    }

    public List<Object[]> buscarActivas(String nombre, String empresa) {
        return repository.buscarActivas(nombre, empresa);
    }

    public List<Object[]> buscarInactivas(String nombre, String empresa) {
        return repository.buscarInactivas(nombre, empresa);
    }

    @Transactional
    public Map<String, String> crear(String nombre, String empresa) {
        return buildRespuesta(repository.crear(nombre, empresa));
    }

    @Transactional
    public Map<String, String> editar(Integer id, String nombre, String empresa) {
        return buildRespuesta(repository.editar(id, nombre, empresa));
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

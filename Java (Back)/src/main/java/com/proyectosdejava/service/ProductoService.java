package com.proyectosdejava.service;

// src/main/java/com/tuapp/service/ProductoService.java

import com.proyectosdejava.model.ProductoDTO;
import com.proyectosdejava.repository.ProductoRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ProductoService {

    @Autowired
    private ProductoRepository productoRepository;

    public List<ProductoDTO> buscarActivos(String nombre, String marca, String categoria) {
        return productoRepository.buscarActivos(nombre, marca, categoria);
    }

    public List<ProductoDTO> buscarInactivos(String nombre, String marca, String categoria) {
        return productoRepository.buscarInactivos(nombre, marca, categoria);
    }

    @Transactional
    public Map<String, String> crearProducto(Integer idMarca, Integer idCategoria, Integer idUnidadDeMedida,
                                             String nombre, Integer stockActual,
                                             Integer stockMinimo, BigDecimal precioVenta) {
        return buildRespuesta(productoRepository.crearProducto(
                idMarca, idCategoria, idUnidadDeMedida,
                nombre, stockActual, stockMinimo, precioVenta
        ));
    }

    @Transactional
    public Map<String, String> editarProducto(Integer idProducto, Integer idMarca, Integer idCategoria,
                                              Integer idUnidadDeMedida, String nombre,
                                              BigDecimal precioVenta) {
        return buildRespuesta(productoRepository.editarProducto(
                idProducto, idMarca, idCategoria, idUnidadDeMedida,
                nombre, precioVenta
        ));
    }

    @Transactional
    public Map<String, String> cambiarEstado(Integer idProducto, Integer estado) {
        return buildRespuesta(productoRepository.cambiarEstado(idProducto, estado));
    }

    private Map<String, String> buildRespuesta(String resultado) {
        Map<String, String> respuesta = new HashMap<>();
        respuesta.put("mensaje", resultado);
        return respuesta;
    }
}

package com.proyectosdejava.controller;

// src/main/java/com/tuapp/controller/ProductoController.java

import com.proyectosdejava.model.Producto;
import com.proyectosdejava.model.ProductoDTO;
import com.proyectosdejava.service.ProductoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/producto")
public class ProductoController {

    @Autowired
    private ProductoService productoService;

    @GetMapping("/listar-activos")
    public ResponseEntity<List<ProductoDTO>> buscarActivos(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String marca,
            @RequestParam(required = false) String categoria) {

        List<ProductoDTO> resultado = productoService.buscarActivos(nombre, marca, categoria);
        return ResponseEntity.ok(resultado);
    }


    @GetMapping("/listar-inactivos")
    public ResponseEntity<List<ProductoDTO>> buscarInactivos(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String marca,
            @RequestParam(required = false) String categoria) {

        List<ProductoDTO> resultado = productoService.buscarInactivos(nombre, marca, categoria);
        return ResponseEntity.ok(resultado);
    }

    @PostMapping
    public ResponseEntity<Map<String, String>> crear(@RequestBody Producto producto) {
        Map<String, String> respuesta = productoService.crearProducto(
                producto.getIdMarca(),
                producto.getIdCategoria(),
                producto.getIdUnidadDeMedida(),
                producto.getNombre(),
                producto.getStockActual(),
                producto.getStockMinimo(),
                producto.getPrecioVenta()
        );
        HttpStatus status = respuesta.get("mensaje").startsWith("OK")
                ? HttpStatus.CREATED : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status).body(respuesta);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Map<String, String>> editar(
            @PathVariable Integer id,
            @RequestBody Producto producto) {
        Map<String, String> respuesta = productoService.editarProducto(
                id,
                producto.getIdMarca(),
                producto.getIdCategoria(),
                producto.getIdUnidadDeMedida(),
                producto.getNombre(),
                producto.getPrecioVenta()
        );
        HttpStatus status = respuesta.get("mensaje").startsWith("OK")
                ? HttpStatus.OK : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status).body(respuesta);
    }

    @PatchMapping("/{id}/estado")
    public ResponseEntity<Map<String, String>> cambiarEstado(
            @PathVariable Integer id,
            @RequestParam Integer valor) {
        Map<String, String> respuesta = productoService.cambiarEstado(id, valor);
        HttpStatus status = respuesta.get("mensaje").startsWith("OK")
                ? HttpStatus.OK : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status).body(respuesta);
    }
}

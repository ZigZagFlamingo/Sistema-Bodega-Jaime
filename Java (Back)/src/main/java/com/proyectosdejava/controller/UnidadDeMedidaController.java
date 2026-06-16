package com.proyectosdejava.controller;

import com.proyectosdejava.service.UnidadDeMedidaService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/unidad-de-medida")
public class UnidadDeMedidaController {

    private final UnidadDeMedidaService service;

    public UnidadDeMedidaController(UnidadDeMedidaService service) {
        this.service = service;
    }


    @GetMapping("/listar-activas")
    public ResponseEntity<List<Object[]>> buscarActivas(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String abreviacion) {

        List<Object[]> resultado = service.buscarActivas(nombre, abreviacion);
        return ResponseEntity.ok(resultado);
    }


    @GetMapping("/listar-inactivas")
    public ResponseEntity<List<Object[]>> buscarInactivas(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String abreviacion) {

        List<Object[]> resultado = service.buscarInactivas(nombre, abreviacion);
        return ResponseEntity.ok(resultado);
    }


    @PostMapping
    public ResponseEntity<Map<String, String>> crear(@RequestBody Map<String, String> body) {
        Map<String, String> respuesta = service.crear(
                body.get("nombre"),
                body.get("abreviacion"),
                body.get("descripcion")
        );
        HttpStatus status = respuesta.get("mensaje").startsWith("OK")
                ? HttpStatus.CREATED
                : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status).body(respuesta);
    }


    @PutMapping("/{id}")
    public ResponseEntity<Map<String, String>> editar(
            @PathVariable Integer id,
            @RequestBody Map<String, String> body) {
        Map<String, String> respuesta = service.editar(
                id,
                body.get("nombre"),
                body.get("abreviacion"),
                body.get("descripcion")
        );
        HttpStatus status = respuesta.get("mensaje").startsWith("OK")
                ? HttpStatus.OK
                : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status).body(respuesta);
    }


    @PatchMapping("/{id}/estado")
    public ResponseEntity<Map<String, String>> cambiarEstado(
            @PathVariable Integer id,
            @RequestParam Integer valor) {
        Map<String, String> respuesta = service.cambiarEstado(id, valor);
        HttpStatus status = respuesta.get("mensaje").startsWith("OK")
                ? HttpStatus.OK
                : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status).body(respuesta);
    }
}
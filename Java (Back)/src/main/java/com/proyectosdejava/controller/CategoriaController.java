package com.proyectosdejava.controller;

import com.proyectosdejava.service.CategoriaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/categoria")
public class CategoriaController {

    @Autowired
    private CategoriaService service;

    @GetMapping("/listar-activas")
    public ResponseEntity<List<Object[]>> activas(
            @RequestParam(required = false) String nombre) {
        return ResponseEntity.ok(service.buscarActivas(nombre));
    }

    @GetMapping("/listar-inactivas")
    public ResponseEntity<List<Object[]>> inactivas(
            @RequestParam(required = false) String nombre) {
        return ResponseEntity.ok(service.buscarInactivas(nombre));
    }

    @PostMapping
    public ResponseEntity<Map<String, String>> crear(
            @RequestBody Map<String, String> body) {
        Map<String, String> respuesta = service.crear(
                body.get("nombre"),
                body.get("descripcion")
        );
        HttpStatus status = respuesta.get("mensaje").startsWith("OK")
                ? HttpStatus.CREATED : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status).body(respuesta);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Map<String, String>> editar(
            @PathVariable Integer id,
            @RequestBody Map<String, String> body) {
        Map<String, String> respuesta = service.editar(
                id,
                body.get("nombre"),
                body.get("descripcion")
        );
        HttpStatus status = respuesta.get("mensaje").startsWith("OK")
                ? HttpStatus.OK : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status).body(respuesta);
    }

    @PatchMapping("/{id}/estado")
    public ResponseEntity<Map<String, String>> cambiarEstado(
            @PathVariable Integer id,
            @RequestParam Integer valor) {
        Map<String, String> respuesta = service.cambiarEstado(id, valor);
        HttpStatus status = respuesta.get("mensaje").startsWith("OK")
                ? HttpStatus.OK : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status).body(respuesta);
    }
}
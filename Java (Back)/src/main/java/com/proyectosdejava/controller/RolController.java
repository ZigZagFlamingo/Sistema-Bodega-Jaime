package com.proyectosdejava.controller;

import com.proyectosdejava.service.RolService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/rol")
public class RolController {

    private final RolService service;

    public RolController(RolService service) {
        this.service = service;
    }

    @GetMapping("/listar-activos")
    public ResponseEntity<List<Object[]>> buscarActivos(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String descripcion) {
        return ResponseEntity.ok(service.buscarActivos(nombre, descripcion));
    }

    @GetMapping("/listar-inactivos")
    public ResponseEntity<List<Object[]>> buscarInactivos(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String descripcion) {
        return ResponseEntity.ok(service.buscarInactivos(nombre, descripcion));
    }

    @PostMapping
    public ResponseEntity<Map<String, String>> crear(@RequestBody Map<String, String> body) {
        Map<String, String> respuesta = service.crear(
                body.get("nombre"),
                body.get("descripcion")
        );
        HttpStatus status = esOk(respuesta) ? HttpStatus.CREATED : HttpStatus.BAD_REQUEST;
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
        HttpStatus status = esOk(respuesta) ? HttpStatus.OK : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status).body(respuesta);
    }

    @PatchMapping("/{id}/estado")
    public ResponseEntity<Map<String, String>> cambiarEstado(
            @PathVariable Integer id,
            @RequestParam Integer valor) {
        Map<String, String> respuesta = service.cambiarEstado(id, valor);
        HttpStatus status = esOk(respuesta) ? HttpStatus.OK : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status).body(respuesta);
    }

    private boolean esOk(Map<String, String> respuesta) {
        return respuesta.get("mensaje").startsWith("OK");
    }
}

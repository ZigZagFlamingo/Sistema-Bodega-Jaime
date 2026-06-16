package com.proyectosdejava.controller;

import com.proyectosdejava.service.MarcaService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/marca")
public class MarcaController {

    private final MarcaService service;

    public MarcaController(MarcaService service) {
        this.service = service;
    }

    @GetMapping("/listar-activas")
    public ResponseEntity<List<Object[]>> buscarActivas(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String empresa) {
        return ResponseEntity.ok(service.buscarActivas(nombre, empresa));
    }

    @GetMapping("/listar-inactivas")
    public ResponseEntity<List<Object[]>> buscarInactivas(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String empresa) {
        return ResponseEntity.ok(service.buscarInactivas(nombre, empresa));
    }

    @PostMapping
    public ResponseEntity<Map<String, String>> crear(@RequestBody Map<String, String> body) {
        Map<String, String> respuesta = service.crear(
                body.get("nombre"),
                body.get("empresa")
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
                body.get("empresa")
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

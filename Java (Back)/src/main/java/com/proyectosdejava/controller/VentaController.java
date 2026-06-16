package com.proyectosdejava.controller;

import com.proyectosdejava.model.HistorialVentaDTO;
import com.proyectosdejava.model.ProductoDisponibleDTO;
import com.proyectosdejava.model.Venta;
import com.proyectosdejava.service.VentaService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/venta")
public class VentaController {

    private final VentaService service;

    public VentaController(VentaService service) {
        this.service = service;
    }

    @GetMapping("/productos-disponibles")
    public ResponseEntity<List<ProductoDisponibleDTO>> buscarProductosDisponibles(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String marca,
            @RequestParam(required = false) String categoria,
            @RequestParam(required = false) String unidad) {
        return ResponseEntity.ok(service.buscarProductosDisponibles(nombre, marca, categoria, unidad));
    }

    @GetMapping("/historial")
    public ResponseEntity<List<HistorialVentaDTO>> buscarHistorial(
            @RequestParam(required = false) String usuario,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaInicio,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaFin,
            @RequestParam(required = false) Integer estado) {
        return ResponseEntity.ok(service.buscarHistorial(usuario, fechaInicio, fechaFin, estado));
    }

    @PostMapping
    public ResponseEntity<Map<String, String>> registrarVenta(@RequestBody Venta venta) {
        Map<String, String> respuesta = service.registrarVenta(venta);
        HttpStatus status = esOk(respuesta) ? HttpStatus.CREATED : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status).body(respuesta);
    }

    @PatchMapping("/{id}/anular")
    public ResponseEntity<Map<String, String>> anularVenta(
            @PathVariable Integer id,
            @RequestParam Integer idUsuario) {
        Map<String, String> respuesta = service.anularVenta(id, idUsuario);
        HttpStatus status = esOk(respuesta) ? HttpStatus.OK : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status).body(respuesta);
    }

    private boolean esOk(Map<String, String> respuesta) {
        return respuesta.get("mensaje").startsWith("OK");
    }
}

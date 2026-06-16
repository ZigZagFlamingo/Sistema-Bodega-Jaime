package com.proyectosdejava.controller;

import com.proyectosdejava.model.Usuario;
import com.proyectosdejava.service.UsuarioService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/usuario")
public class UsuarioController {

    private final UsuarioService service;

    public UsuarioController(UsuarioService service) {
        this.service = service;
    }

    @GetMapping("/listar-activos")
    public ResponseEntity<List<Object[]>> buscarActivos(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String correo,
            @RequestParam(required = false) String rol) {
        return ResponseEntity.ok(service.buscarActivos(nombre, correo, rol));
    }

    @GetMapping("/listar-inactivos")
    public ResponseEntity<List<Object[]>> buscarInactivos(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String correo,
            @RequestParam(required = false) String rol) {
        return ResponseEntity.ok(service.buscarInactivos(nombre, correo, rol));
    }

    @PostMapping
    public ResponseEntity<Map<String, String>> crear(@RequestBody Usuario usuario) {
        Map<String, String> respuesta = service.crear(
                usuario.getIdRol(),
                usuario.getNombre(),
                usuario.getCorreo(),
                usuario.getPassword()
        );
        HttpStatus status = esOk(respuesta) ? HttpStatus.CREATED : HttpStatus.BAD_REQUEST;
        return ResponseEntity.status(status).body(respuesta);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Map<String, String>> editar(
            @PathVariable Integer id,
            @RequestBody Usuario usuario) {
        Map<String, String> respuesta = service.editar(
                id,
                usuario.getIdRol(),
                usuario.getNombre(),
                usuario.getCorreo(),
                usuario.getPassword()
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

package com.proyectosdejava.controller;

import com.proyectosdejava.service.AuthService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService service;

    public AuthController(AuthService service) {
        this.service = service;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credenciales) {
        String correo = credenciales.get("correo");
        String password = credenciales.get("password");

        if (correo == null || password == null) {
            return ResponseEntity.badRequest().body(Map.of("mensaje", "Correo y contraseña son requeridos"));
        }

        Map<String, Object> resultado = service.login(correo, password);

        if (resultado == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("mensaje", "Correo o contraseña incorrectos"));
        }

        return ResponseEntity.ok(resultado);
    }
}

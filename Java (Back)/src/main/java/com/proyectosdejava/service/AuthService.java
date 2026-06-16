package com.proyectosdejava.service;

import com.proyectosdejava.repository.AuthRepository;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class AuthService {

    private final AuthRepository repository;

    public AuthService(AuthRepository repository) {
        this.repository = repository;
    }

    public Map<String, Object> login(String correo, String password) {
        return repository.buscarPorCredenciales(correo, password);
    }
}

package com.example.demo.service;

import com.example.demo.entity.*;
import com.example.demo.repository.*;
import com.example.demo.service.*;
import com.example.demo.DTOs.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public AuthResponseDTO register(RegisterRequestDTO request) {

        Usuario usuario = new Usuario();

        usuario.setNombre(request.getNombre());
        usuario.setApellido(request.getApellido());
        usuario.setEmail(request.getEmail());

        usuario.setPasswordHash(
                passwordEncoder.encode(request.getPassword())
        );

        usuario.setRol("SECRETARIO");
        usuario.setActivo(true);
        usuario.setCreatedAt(LocalDateTime.now());

        usuarioRepository.save(usuario);

        String jwt = jwtUtil.generateToken(usuario);

        return new AuthResponseDTO(jwt);
    }

    public AuthResponseDTO login(LoginRequestDTO request) {

        Usuario usuario = usuarioRepository
                .findByEmail(request.getEmail())
                .orElseThrow();

        boolean passwordCorrect =
        request.getPassword()
                .equals(usuario.getPasswordHash());
       /*
       boolean passwordCorrect =
       passwordEncoder.matches(
        request.getPassword(),
        usuario.getPasswordHash()
    );
    */                 

        if (!passwordCorrect) {
            throw new RuntimeException("Password incorrecto");
        }

        String jwt = jwtUtil.generateToken(usuario);

        return new AuthResponseDTO(jwt);
    }
}
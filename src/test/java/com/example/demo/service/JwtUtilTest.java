package com.example.demo.service;

import com.example.demo.entity.Usuario;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class JwtUtilTest {
    private JwtUtil jwtUtil;
    private Usuario usuario;
    @BeforeEach
    void setUp() {
        jwtUtil = new JwtUtil();
        usuario = new Usuario();
        usuario.setEmail("alexander@correo.com");
    }
    @Test
    void debeGenerarToken() {
        String token = jwtUtil.generateToken(usuario);
        assertNotNull(token);
        assertFalse(token.isEmpty());
    }
    @Test
    void debeExtraerUsernameDelToken() {
        String token = jwtUtil.generateToken(usuario);
        String username = jwtUtil.extractUsername(token);
        assertEquals(
                "alexander@correo.com",
                username
        );
    }

    @Test
    void debeValidarTokenCorrectamente() {
        String token = jwtUtil.generateToken(usuario);
        boolean valido =
                jwtUtil.isTokenValid(token, usuario);
        assertTrue(valido);
    }
    @Test
    void debeRetornarFalseCuandoUsuarioNoCoincide() {
        String token = jwtUtil.generateToken(usuario);
        Usuario otroUsuario = new Usuario();
        otroUsuario.setEmail("otro@correo.com");
        boolean valido =
                jwtUtil.isTokenValid(token, otroUsuario);
        assertFalse(valido);
    }
    @Test
    void tokenDebeContenerFechaExpiracion() {
        String token = jwtUtil.generateToken(usuario);
        assertNotNull(
                jwtUtil.extractClaim(
                        token,
                        claims -> claims.getExpiration()
                )
        );
    }
    @Test
    void tokenDebeContenerSubjectCorrecto() {
        String token = jwtUtil.generateToken(usuario);
        String subject =
                jwtUtil.extractClaim(
                        token,
                        claims -> claims.getSubject()
                );

        assertEquals(
                usuario.getEmail(),
                subject
        );
    }
}

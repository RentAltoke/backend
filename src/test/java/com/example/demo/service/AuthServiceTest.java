package com.example.demo.service;

import com.example.demo.DTOs.AuthResponseDTO;
import com.example.demo.DTOs.LoginRequestDTO;
import com.example.demo.DTOs.RegisterRequestDTO;
import com.example.demo.entity.Usuario;
import com.example.demo.repository.UsuarioRepository;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private UsuarioRepository usuarioRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtUtil jwtUtil;

    @InjectMocks
    private AuthService authService;

    private RegisterRequestDTO registerRequest;
    private LoginRequestDTO loginRequest;
    private Usuario usuario;

    @BeforeEach
    void setUp() {

        registerRequest = new RegisterRequestDTO();
        registerRequest.setNombre("Alexander");
        registerRequest.setApellido("Acosta");
        registerRequest.setEmail("alex@test.com");
        registerRequest.setPassword("123456");

        loginRequest = new LoginRequestDTO();
        loginRequest.setEmail("alex@test.com");
        loginRequest.setPassword("123456");

        usuario = new Usuario();
        usuario.setId(1);
        usuario.setNombre("Alexander");
        usuario.setApellido("Acosta");
        usuario.setEmail("alex@test.com");
        usuario.setPasswordHash("123456");
        usuario.setRol("SECRETARIO");
        usuario.setActivo(true);
    }

    @Test
    void register_DeberiaRegistrarUsuarioCorrectamente() {

        when(passwordEncoder.encode("123456"))
                .thenReturn("PASSWORD_ENCRIPTADO");

        when(jwtUtil.generateToken(any(Usuario.class)))
                .thenReturn("JWT_TOKEN");

        AuthResponseDTO response =
                authService.register(registerRequest);

        assertNotNull(response);
        assertEquals("JWT_TOKEN", response.getToken());

        ArgumentCaptor<Usuario> captor =
                ArgumentCaptor.forClass(Usuario.class);

        verify(usuarioRepository).save(captor.capture());

        Usuario usuarioGuardado = captor.getValue();

        assertEquals("Alexander", usuarioGuardado.getNombre());
        assertEquals("Acosta", usuarioGuardado.getApellido());
        assertEquals("alex@test.com", usuarioGuardado.getEmail());

        assertEquals(
                "PASSWORD_ENCRIPTADO",
                usuarioGuardado.getPasswordHash()
        );

        assertEquals("SECRETARIO", usuarioGuardado.getRol());

        assertTrue(usuarioGuardado.getActivo());

        assertNotNull(usuarioGuardado.getCreatedAt());

        verify(passwordEncoder, times(1))
                .encode("123456");

        verify(jwtUtil, times(1))
                .generateToken(any(Usuario.class));
    }

    @Test
    void login_DeberiaRetornarTokenSiCredencialesSonCorrectas() {

        when(usuarioRepository.findByEmail("alex@test.com"))
                .thenReturn(Optional.of(usuario));

        when(jwtUtil.generateToken(usuario))
                .thenReturn("JWT_TOKEN");

        AuthResponseDTO response =
                authService.login(loginRequest);

        assertNotNull(response);
        assertEquals("JWT_TOKEN", response.getToken());

        verify(usuarioRepository)
                .findByEmail("alex@test.com");

        verify(jwtUtil)
                .generateToken(usuario);
    }

    @Test
    void login_DeberiaLanzarExcepcionSiEmailNoExiste() {

        when(usuarioRepository.findByEmail("alex@test.com"))
                .thenReturn(Optional.empty());

        assertThrows(
                java.util.NoSuchElementException.class,
                () -> authService.login(loginRequest)
        );

        verify(jwtUtil, never())
                .generateToken(any());
    }

    @Test
    void login_DeberiaLanzarExcepcionSiPasswordEsIncorrecto() {

        usuario.setPasswordHash("OTRA_PASSWORD");

        when(usuarioRepository.findByEmail("alex@test.com"))
                .thenReturn(Optional.of(usuario));

        RuntimeException exception =
                assertThrows(
                        RuntimeException.class,
                        () -> authService.login(loginRequest)
                );

        assertEquals(
                "Password incorrecto",
                exception.getMessage()
        );

        verify(jwtUtil, never())
                .generateToken(any());
    }
}
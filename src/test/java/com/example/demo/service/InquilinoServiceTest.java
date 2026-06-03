package com.example.demo.service;
import com.example.demo.entity.Inquilino;
import com.example.demo.repository.InquilinoRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import java.util.List;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

class InquilinoServiceTest {

    @Mock
    private InquilinoRepository repo;

    @InjectMocks
    private InquilinoService service;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void listarDebeRetornarTodosLosInquilinos() {

        Inquilino i1 = new Inquilino();
        Inquilino i2 = new Inquilino();

        when(repo.findAll()).thenReturn(List.of(i1, i2));

        List<Inquilino> resultado = service.listar();

        assertEquals(2, resultado.size());

        verify(repo, times(1)).findAll();
    }
}
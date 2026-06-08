package com.example.demo.service;

import com.example.demo.DTOs.ReciboResumenDTO;
import com.example.demo.entity.Recibo;
import com.example.demo.repository.ReciboRepository;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ReciboServiceTest {

    @Mock
    private ReciboRepository repo;

    @InjectMocks
    private ReciboService service;

    private Recibo recibo1;
    private Recibo recibo2;

    @BeforeEach
    void setUp() {

        recibo1 = new Recibo();
        recibo1.setId(1);

        recibo2 = new Recibo();
        recibo2.setId(2);
    }

    @Test
    void debeListarTodosLosRecibos() {

        List<Recibo> recibos =
                Arrays.asList(recibo1, recibo2);

        when(repo.findAll())
                .thenReturn(recibos);

        List<Recibo> resultado =
                service.listar();

        assertNotNull(resultado);
        assertEquals(2, resultado.size());

        verify(repo, times(1))
                .findAll();
    }

    @Test
    void debeRetornarListaVaciaCuandoNoHayRecibos() {

        when(repo.findAll())
                .thenReturn(List.of());

        List<Recibo> resultado =
                service.listar();

        assertTrue(resultado.isEmpty());

        verify(repo).findAll();
    }

    @Test
    void debeRetornarResumenDeRecibos() {

        ReciboResumenDTO dto =
                mock(ReciboResumenDTO.class);

        List<ReciboResumenDTO> resumen =
                List.of(dto);

        when(repo.findResumen())
                .thenReturn(resumen);

        List<ReciboResumenDTO> resultado =
                service.resumen();

        assertEquals(1, resultado.size());

        verify(repo, times(1))
                .findResumen();
    }

    @Test
    void debeRetornarRecibosPendientes() {

        List<Recibo> pendientes =
                List.of(recibo1);

        when(repo.findByEstadoCobroFalse())
                .thenReturn(pendientes);

        List<Recibo> resultado =
                service.pendientes();

        assertEquals(1, resultado.size());

        verify(repo, times(1))
                .findByEstadoCobroFalse();
    }

    @Test
    void debeRetornarListaVaciaSiNoHayPendientes() {

        when(repo.findByEstadoCobroFalse())
                .thenReturn(List.of());

        List<Recibo> resultado =
                service.pendientes();

        assertTrue(resultado.isEmpty());

        verify(repo)
                .findByEstadoCobroFalse();
    }
}
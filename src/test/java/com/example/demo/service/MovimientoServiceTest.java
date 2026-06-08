package com.example.demo.service;
import com.example.demo.entity.Movimiento;
import com.example.demo.repository.*;
import java.util.Collections;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MovimientoServiceTest {

    @Mock
    private MovimientoRepository movimientoRepo;

    @Mock
    private CuentaBancariaRepository cuentaRepo;

    @Mock
    private InmuebleRepository inmuebleRepo;

    @Mock
    private UnidadRepository unidadRepo;

    @Mock
    private ReciboRepository reciboRepo;

    @InjectMocks
    private MovimientoService service;

    private Movimiento movimiento1;
    private Movimiento movimiento2;

    @BeforeEach
    void setUp() {

        movimiento1 = new Movimiento();
        movimiento1.setId(1);

        movimiento2 = new Movimiento();
        movimiento2.setId(2);
    }

    @Test
    void debeListarTodosLosMovimientos() {

        when(movimientoRepo.findAll())
                .thenReturn(List.of(movimiento1, movimiento2));

        List<Movimiento> resultado =
                service.listarTodos();

        assertEquals(2, resultado.size());

        verify(movimientoRepo, times(1))
                .findAll();
    }

    @Test
    void debeRetornarMovimientosPorUnidad() {

        Integer unidadId = 1;

        when(movimientoRepo.findByUnidadId(unidadId))
                .thenReturn(List.of(movimiento1));

        List<Movimiento> resultado =
                service.porUnidad(unidadId);

        assertEquals(1, resultado.size());

        verify(movimientoRepo)
                .findByUnidadId(unidadId);
    }

    @Test
    void debeRetornarMovimientosPorInmueble() {

        Integer inmuebleId = 1;

        when(movimientoRepo.findByInmuebleId(inmuebleId))
                .thenReturn(List.of(movimiento1));

        List<Movimiento> resultado =
                service.porInmueble(inmuebleId);

        assertEquals(1, resultado.size());

        verify(movimientoRepo)
                .findByInmuebleId(inmuebleId);
    }

    @Test
    void debeRetornarMovimientosPorInquilino() {

        Integer inquilinoId = 1;

        when(movimientoRepo.findMovimientosByInquilino(inquilinoId))
                .thenReturn(List.of(movimiento1));

        List<Movimiento> resultado =
                service.porInquilino(inquilinoId);

        assertEquals(1, resultado.size());

        verify(movimientoRepo)
                .findMovimientosByInquilino(inquilinoId);
    }

    @Test
    void debeRetornarResumenGeneral() {

        Object[] fila = {
                "INGRESO",
                1500.00
        };

        when(movimientoRepo.resumen()).thenReturn(List.<Object[]>of(fila));
        List<Object[]> resultado=service.resumen();

        assertEquals(1, resultado.size());

        verify(movimientoRepo)
                .resumen();
    }

    @Test
    void debeRetornarResumenPorInmueble() {

        Object[] fila = {
                "Edificio Central",
                4500.00
        };



        when(movimientoRepo.resumenPorInmueble()).thenReturn(Collections.singletonList(fila));
        List<Object[]> resultado =service.resumenPorInmueble();

        assertEquals(1, resultado.size());

        verify(movimientoRepo)
                .resumenPorInmueble();
    }

    @Test
    void debeRetornarResumenPorUnidad() {

        Object[] fila = {
                "101",
                1200.00
        };


        
        when(movimientoRepo.resumenPorUnidad()).thenReturn(Collections.singletonList(fila));
        List<Object[]> resultado =service.resumenPorUnidad();




        assertEquals(1, resultado.size());

        verify(movimientoRepo)
                .resumenPorUnidad();
    }

    @Test
    void debeRetornarListaVaciaCuandoNoHayMovimientos() {

        when(movimientoRepo.findAll())
                .thenReturn(List.of());

        List<Movimiento> resultado =
                service.listarTodos();

        assertTrue(resultado.isEmpty());

        verify(movimientoRepo)
                .findAll();
    }
}
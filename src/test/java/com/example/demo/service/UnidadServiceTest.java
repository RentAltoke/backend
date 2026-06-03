package com.example.demo.service;
import com.example.demo.repository.UnidadRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import java.util.List;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

class UnidadServiceTest {

    @Mock
    private UnidadRepository repo;

    @InjectMocks
    private UnidadService service;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void listarConDetalleDebeRetornarDatos() {

        List<Object[]> datos = List.of(
                new Object[]{"101", "DISPONIBLE"},
                new Object[]{"102", "OCUPADO"}
        );

        when(repo.obtenerUnidadesConDetalle())
                .thenReturn(datos);

        List<Object[]> resultado = service.listarConDetalle();

        assertEquals(2, resultado.size());

        verify(repo).obtenerUnidadesConDetalle();
    }
}
package com.example.demo.controller;
import com.example.demo.entity.Inquilino;
import com.example.demo.entity.Movimiento;
import com.example.demo.enums.TipoMovimiento;
import com.example.demo.repository.InquilinoRepository;
import com.example.demo.repository.MovimientoRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import java.util.List;
import java.util.Optional;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
class ReporteControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private MovimientoRepository movimientoRepository;

    @MockitoBean
    private InquilinoRepository inquilinoRepository;

    @Test
    void debeGenerarPdfCorrectamente() throws Exception {
        Inquilino inquilino = new Inquilino();
        inquilino.setId(1);
        inquilino.setNombreCompleto("Carlos Ruiz");

        Movimiento movimiento = new Movimiento();
        movimiento.setMonto(1000.0);
        movimiento.setDescripcion("Pago alquiler");
        movimiento.setTipo(TipoMovimiento.INGRESO);

        when(inquilinoRepository.findById(1))
                .thenReturn(Optional.of(inquilino));

        when(movimientoRepository.findMovimientosByInquilino(1))
                .thenReturn(List.of(movimiento));

        mockMvc.perform(get("/api/reportes/caja/1"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_PDF))
                .andExpect(header().exists("Content-Disposition"));
    }
}
package com.example.demo.controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import com.example.demo.service.*;
import com.example.demo.entity.*;
import com.example.demo.enums.TipoMovimiento;
import com.example.demo.DTOs.*;
import com.example.demo.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;

import java.io.ByteArrayOutputStream;
import java.util.List;

import com.example.demo.entity.Inquilino;
import com.example.demo.entity.Movimiento;
import com.example.demo.repository.InquilinoRepository;
import com.example.demo.repository.MovimientoRepository;



@RestController
@RequestMapping("/api/reportes")
@RequiredArgsConstructor
@CrossOrigin("*")

public class ReporteController {

    private final MovimientoRepository movimientoRepository;
    private final InquilinoRepository inquilinoRepository;

    @GetMapping("/caja/{inquilinoId}")
    public ResponseEntity<byte[]> generarReporteCaja(
            @PathVariable Integer inquilinoId) throws Exception {

        Inquilino inquilino = inquilinoRepository.findById(inquilinoId)
                .orElseThrow(() ->
                        new RuntimeException("Inquilino no encontrado"));

        List<Movimiento> movimientos =
                movimientoRepository.findMovimientosByInquilino(inquilinoId);

        double ingresos = movimientos.stream()
                .filter(m -> m.getTipo() == TipoMovimiento.INGRESO)
                .mapToDouble(Movimiento::getMonto)
                .sum();

        double gastos = movimientos.stream()
                .filter(m -> m.getTipo() == TipoMovimiento.GASTO)
                .mapToDouble(Movimiento::getMonto)
                .sum();

        double balance = ingresos - gastos;

        String html = generarHtml(
                inquilino,
                movimientos,
                ingresos,
                gastos,
                balance
        );

        ByteArrayOutputStream os = new ByteArrayOutputStream();

        PdfRendererBuilder builder = new PdfRendererBuilder();
        builder.withHtmlContent(html, null);
        builder.toStream(os);
        builder.run();

        HttpHeaders headers = new HttpHeaders();

        headers.setContentType(MediaType.APPLICATION_PDF);

        headers.setContentDisposition(
                ContentDisposition.inline()
                        .filename("reporte-caja.pdf")
                        .build()
        );

        return new ResponseEntity<>(
                os.toByteArray(),
                headers,
                HttpStatus.OK
        );
    }

 private String generarHtml(
        Inquilino inquilino,
        List<Movimiento> movimientos,
        double ingresos,
        double gastos,
        double balance) {

    StringBuilder filas = new StringBuilder();

    for (Movimiento m : movimientos) {

        filas.append("""
            <tr>
                <td>%s</td>
                <td>%s</td>
                <td>%s</td>
                <td>%s</td>
                <td>%s</td>
                <td>%s</td>
                <td>S/ %.2f</td>
            </tr>
            """.formatted(
                m.getFecha(),
                m.getTipo(),
                m.getCategoria(),
                m.getUnidad() != null && m.getUnidad().getInmueble() != null
                        ? m.getUnidad().getInmueble().getNombre()
                        : "-",
                m.getUnidad() != null
                        ? m.getUnidad().getCodigo()
                        : "-",
                m.getDescripcion(),
                m.getMonto()
        ));
    }

        return """
    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml">

    <head>
        <meta charset="UTF-8" />

        <style>

            body{
                font-family: Arial, sans-serif;
                padding:20px;
            }

            h1{
                text-align:center;
            }

            .resumen{
                margin:20px 0;
            }

            .resumen p{
                font-size:14px;
                margin:5px 0;
            }

            table{
                width:100%%;
                border-collapse:collapse;
            }

            th,td{
                border:1px solid #ccc;
                padding:8px;
                font-size:12px;
            }

            th{
                background:#f2f2f2;
            }

        </style>

    </head>

    <body>

        <h1>Reporte de Movimientos</h1>

        <h3>Inquilino: %s</h3>

        <div class="resumen">
            <p><strong>Total Ingresos:</strong> S/ %.2f</p>
            <p><strong>Total Gastos:</strong> S/ %.2f</p>
            <p><strong>Balance:</strong> S/ %.2f</p>
        </div>

        <table>

            <thead>
                <tr>
                    <th>Fecha</th>
                    <th>Tipo</th>
                    <th>Categoría</th>
                    <th>Inmueble</th>
                    <th>Unidad</th>
                    <th>Descripción</th>
                    <th>Monto</th>
                </tr>
            </thead>

            <tbody>
                %s
            </tbody>

        </table>

    </body>

    </html>
    """.formatted(
        inquilino.getNombreCompleto(),
        ingresos,
        gastos,
        balance,
        filas.toString()
);

}
    

}

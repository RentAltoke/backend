package com.example.demo.entity;
import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;
import java.math.BigDecimal;

@Entity
@Table(name = "contratos")
@Data
public class Contrato {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "inquilino_id")
    private Inquilino inquilino;

    @ManyToOne
    @JoinColumn(name = "unidad_id")
    private Unidad unidad;

    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private Integer diaPago;
    private BigDecimal montoRenta;
    private String estado;
}
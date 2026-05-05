package com.example.demo.entity;
import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;
import java.math.BigDecimal;


@Entity
@Table(name = "recibos")
@Data
public class Recibo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String codigo;

    @ManyToOne
    @JoinColumn(name = "contrato_id")
    private Contrato contrato;

    private LocalDate fechaEmision;
    private Integer anio;
    private Integer mes;

    private Boolean estadoCobro;
    private BigDecimal total;
}
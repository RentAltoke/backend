package com.example.demo.entity;
import jakarta.persistence.*;
import java.math.BigDecimal;
import lombok.Data;
@Data
@Entity
@Table(name = "cuentas_bancarias")
public class CuentaBancaria {
    @Id
    private Integer id;

    private String codigo;

    @ManyToOne
    @JoinColumn(name = "banco_id")
    private Banco banco;
    @Column(name = "moneda") 
    private String moneda;
    private String numeroCuenta;
    private String tipo;
    private BigDecimal saldoActual;
    private String titular;
}
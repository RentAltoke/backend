package com.example.demo.entity;
import com.example.demo.enums.*;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.math.BigDecimal;
import lombok.Data;

@Data
@Entity
@Table(name = "movimientos")
public class Movimiento {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String codigo;
    private LocalDate fecha;

    @Enumerated(EnumType.STRING)
    private TipoMovimiento tipo;

    private String categoria;
    private double monto;

    @ManyToOne
    @JoinColumn(name = "cuenta_id")
    private CuentaBancaria cuenta;

    @ManyToOne
    @JoinColumn(name = "inmueble_id")
    private Inmueble inmueble;

    @ManyToOne
    @JoinColumn(name = "unidad_id")
    private Unidad unidad;

    @ManyToOne
    @JoinColumn(name = "recibo_id")
    private Recibo recibo;

    private String descripcion;
}
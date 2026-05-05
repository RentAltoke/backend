package com.example.demo.entity;
import com.example.demo.enums.*;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "unidades")
@Data
public class Unidad {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "inmueble_id")
    private Inmueble inmueble;

    private String tipo;
    private String planta;
    private String codigo;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado") 
    private EstadoUnidad estado;
}
package com.example.demo.entity;
import com.example.demo.enums.*;
import jakarta.persistence.*;
import lombok.Data;
@Entity
@Table(name = "inmuebles")
@Data
public class Inmueble {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String nombre;

    @Enumerated(EnumType.STRING)
    private TipoInmueble tipo;

    private String direccion;
    private String numero;

    @Column(name = "codigo_postal")
    private String codigoPostal;

    private String ciudad;
    private String descripcion;

    @Column(name = "imagen_url")
    private String imagenUrl;
}
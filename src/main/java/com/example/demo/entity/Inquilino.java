package com.example.demo.entity;

import com.example.demo.enums.*;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "inquilinos")
@Data
public class Inquilino {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String codigo;
    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_persona")
    private TipoPersona tipoPersona;
    @Column(name = "nombre_completo")
    private String nombreCompleto;
    private String documentoIdentidad;
    private String telefono;
    private String email;
    private Boolean activo;

}
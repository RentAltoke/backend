package com.example.demo.entity;
import jakarta.persistence.*;
import lombok.Data;
@Data
@Entity
@Table(name = "bancos")
public class Banco {
    @Id
    private Integer id;
    private String nombre;
}
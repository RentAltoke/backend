package com.example.demo.DTOs;
import lombok.Data;
@Data
public class RegisterRequestDTO {
    private String nombre;
    private String apellido;
    private String email;
    private String password;
}

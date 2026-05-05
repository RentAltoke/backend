package com.example.demo.controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import com.example.demo.service.*;
import com.example.demo.entity.*;
import com.example.demo.repository.ReciboResumenDTO;

import java.util.List;


@RestController
@RequestMapping("/api/recibos")
@CrossOrigin("*")
public class ReciboController {

    @Autowired
    private ReciboService service;

    @GetMapping
    public List<Recibo> listar() {
        return service.listar();
    }

    @GetMapping("/resumen")
    public List<ReciboResumenDTO> resumen() {
        return service.resumen();
    }

    @GetMapping("/pendientes")
    public List<Recibo> pendientes() {
        return service.pendientes();
    }
}
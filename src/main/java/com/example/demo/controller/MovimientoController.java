package com.example.demo.controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import com.example.demo.service.*;
import java.util.List;
import com.example.demo.entity.Movimiento;
import com.example.demo.service.MovimientoService;



@RestController
@RequestMapping("/api/movimientos")
@CrossOrigin("*")
public class MovimientoController {

    @Autowired
    private MovimientoService service;



    @GetMapping
    public List<Movimiento> listar() {
        return service.listarTodos();
    }

    // 🔹 Por unidad (ingresos)
    @GetMapping("/unidad/{id}")
    public List<Movimiento> porUnidad(@PathVariable Integer id) {
        return service.porUnidad(id);
    }

    // 🔹 Por inmueble (gastos)
    @GetMapping("/inmueble/{id}")
    public List<Movimiento> porInmueble(@PathVariable Integer id) {
        return service.porInmueble(id);
    }


    // 🔹 Resumen general
    @GetMapping("/resumen")
    public List<Object[]> resumen() {
        return service.resumen();
    }

    @GetMapping("/resumen/inmueble")
    public List<Object[]> resumenPorInmueble() {
        return service.resumenPorInmueble();
    }

    @GetMapping("/resumen/unidad")
    public List<Object[]> resumenPorUnidad() {
        return service.resumenPorUnidad();
    }

    @GetMapping("/inquilino/{id}")
    public List<Movimiento> porInquilino(@PathVariable Integer id) {
    return service.porInquilino(id);
}
}
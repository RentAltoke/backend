package com.example.demo.controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import com.example.demo.repository.*;
import com.example.demo.service.UnidadService;
import com.example.demo.entity.*;
import java.util.List;

@RestController
@RequestMapping("/api/inmuebles")
@CrossOrigin("*")
public class InmuebleController {

    @Autowired
    private InmuebleRepository inmuebleRepo;

    @Autowired
    private UnidadRepository unidadRepo;
    
    @Autowired
    private UnidadService unidadService;

    @GetMapping
    public List<Inmueble> listar() {
        return inmuebleRepo.findAll();
    }

    @GetMapping("/unidades")
    public List<Object[]> listarTodasLasUnidades() {
        return unidadService.listarConDetalle();
    }


    @GetMapping("/{id}/unidades")
    public List<Unidad> unidades(@PathVariable Integer id) {
        return unidadRepo.findByInmuebleId(id);
    }

    @GetMapping("/{id}")
    public Inmueble obtenerPorId(@PathVariable Integer id) {
        return inmuebleRepo.findById(id)
            .orElseThrow(() -> new RuntimeException("Inmueble no encontrado"));
}

}
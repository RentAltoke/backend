package com.example.demo.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import com.example.demo.repository.*;
import com.example.demo.entity.*;
import com.example.demo.service.*;
import java.util.List;


@RestController
@RequestMapping("/api/inquilinos")
@CrossOrigin("*")
public class InquilinoController {

    @Autowired
    private InquilinoService service;

    @GetMapping
    public List<Inquilino> listar() {
        return service.listar();
    }

    @GetMapping("/morosos")
    public List<Inquilino> morosos() {
        return service.morosos();
    }

    @PostMapping
    public Inquilino guardar(@RequestBody Inquilino inquilino) {
        return service.guardar(inquilino);
    }

}
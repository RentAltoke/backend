package com.example.demo.service;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import com.example.demo.repository.*;
import java.util.List;
import com.example.demo.entity.*;
import com.example.demo.DTOs.*;

@Service
public class ReciboService {

    @Autowired
    private ReciboRepository repo;

    public List<Recibo> listar() {
        return repo.findAll();
    }

    public List<ReciboResumenDTO> resumen() {
        return repo.findResumen();
    }

    public List<Recibo> pendientes() {
        return repo.findByEstadoCobroFalse();
    }
}

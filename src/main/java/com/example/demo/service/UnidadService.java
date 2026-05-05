package com.example.demo.service;
import com.example.demo.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;
@Service
public class UnidadService {

    @Autowired
    private UnidadRepository unidadRepo;

    public List<Object[]> listarConDetalle() {
        return unidadRepo.obtenerUnidadesConDetalle();
    }
}
package com.example.demo.service;

import com.example.demo.entity.Inmueble;
import com.example.demo.repository.InmuebleRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class InmuebleService {

    @Autowired
    private InmuebleRepository inmuebleRepository;

    public List<Inmueble> listar() {
        return inmuebleRepository.findAll();
    }

    public Inmueble obtenerPorId(Integer id) {
        return inmuebleRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Inmueble no encontrado"));
    }

    public Inmueble guardar(Inmueble inmueble) {
        return inmuebleRepository.save(inmueble);
    }


    public void eliminar(Integer id) {
        inmuebleRepository.deleteById(id);
    }
}
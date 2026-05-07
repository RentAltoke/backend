package com.example.demo.service;
import com.example.demo.repository.*;
import com.example.demo.entity.*;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
@Service
public class InquilinoService {

    @Autowired
    private InquilinoRepository repo;

    public List<Inquilino> listar() {
        return repo.findAll();
    }

    public List<Inquilino> morosos() {
        return repo.findMorosos();
    }

     public Inquilino guardar(Inquilino inquilino) {
        return repo.save(inquilino);
    }
}
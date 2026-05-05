package com.example.demo.repository;

import com.example.demo.entity.Inmueble;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InmuebleRepository extends JpaRepository<Inmueble, Integer> {
}
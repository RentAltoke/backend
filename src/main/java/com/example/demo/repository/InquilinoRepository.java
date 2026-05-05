package com.example.demo.repository;
import com.example.demo.entity.*;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;

@Repository
public interface InquilinoRepository extends JpaRepository<Inquilino, Integer> {

    @Query("""
    SELECT DISTINCT i FROM Inquilino i
    JOIN Contrato c ON c.inquilino.id = i.id
    JOIN Recibo r ON r.contrato.id = c.id
    WHERE r.estadoCobro = false
    """)
    List<Inquilino> findMorosos();

}
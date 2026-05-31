package com.example.demo.repository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.example.demo.entity.*;
import com.example.demo.entity.Movimiento;
import com.example.demo.enums.TipoMovimiento;
import org.springframework.data.repository.query.Param;




@Repository
public interface MovimientoRepository extends JpaRepository<Movimiento, Integer> {


    @Query("SELECT m FROM Movimiento m WHERE m.unidad.id = :unidadId")
    List<Movimiento> findByUnidadId(@Param("unidadId") Integer unidadId);


    @Query("SELECT m FROM Movimiento m WHERE m.inmueble.id = :inmuebleId")
    List<Movimiento> findByInmuebleId(@Param("inmuebleId") Integer inmuebleId);


    @Query("SELECT m.tipo, SUM(m.monto) FROM Movimiento m GROUP BY m.tipo")
    List<Object[]> resumen();


    @Query("""
        SELECT m.inmueble.id, SUM(m.monto)
        FROM Movimiento m
        WHERE m.inmueble IS NOT NULL
        GROUP BY m.inmueble.id
    """)
    List<Object[]> resumenPorInmueble();


    @Query("""
        SELECT m.unidad.id, SUM(m.monto)
        FROM Movimiento m
        WHERE m.unidad IS NOT NULL
        GROUP BY m.unidad.id
    """)
    List<Object[]> resumenPorUnidad();


    List<Movimiento> findByTipo(TipoMovimiento tipo);

@Query("""
SELECT m
FROM Movimiento m
WHERE m.unidad.id IN (
    SELECT c.unidad.id
    FROM Contrato c
    WHERE c.inquilino.id = :inquilinoId
    AND c.estado = 'ACTIVO'
)
""")
List<Movimiento> findMovimientosByInquilino(@Param("inquilinoId") Integer inquilinoId);



}
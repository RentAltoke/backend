package com.example.demo.repository;

import com.example.demo.entity.Unidad;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface UnidadRepository extends JpaRepository<Unidad, Integer> {
    List<Unidad> findByInmuebleId(Integer inmuebleId);

@Query(value = """
SELECT 
    u.id AS unidad_id,
    u.codigo,
    u.tipo,
    u.planta,
    u.estado AS estado_unidad,

    u.inmueble_id,
    im.nombre AS nombre_inmueble,
    im.direccion,

    i.nombre_completo,

    c.monto_renta
FROM unidades u
LEFT JOIN inmuebles im 
    ON im.id = u.inmueble_id
LEFT JOIN contratos c 
    ON c.unidad_id = u.id 
    AND c.estado = 'ACTIVO'
LEFT JOIN inquilinos i 
    ON i.id = c.inquilino_id
ORDER BY u.inmueble_id, u.id
""", nativeQuery = true)
List<Object[]> obtenerUnidadesConDetalle();

}
package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import com.example.demo.repository.*;
import com.example.demo.DTOs.*;
import java.util.List;
import org.springframework.stereotype.Repository;
import com.example.demo.entity.*;
@Repository
public interface ReciboRepository extends JpaRepository<Recibo, Integer> {

@Query(value = """
SELECT 
    r.id AS id_recibo,
    r.codigo AS codigo_recibo,
    r.total AS total_recibo,
    r.fecha_emision AS fecha_emision,

    i.codigo AS codigo_inquilino,
    i.nombre_completo AS inquilino,

    u.codigo AS unidad,
    u.tipo AS tipo_unidad,
    im.nombre AS inmueble,
    im.imagen_url AS imagen_url,

    COALESCE(SUM(CASE WHEN c.nombre = 'renta' THEN rd.importe END),0) AS renta,
    COALESCE(SUM(CASE WHEN c.nombre = 'agua' THEN rd.importe END),0) AS agua,
    COALESCE(SUM(CASE WHEN c.nombre = 'luz' THEN rd.importe END),0) AS luz,
    COALESCE(SUM(CASE WHEN c.nombre = 'mantenimiento' THEN rd.importe END),0) AS mantenimiento,
    COALESCE(SUM(CASE WHEN c.nombre = 'ipc_anual' THEN rd.importe END),0) AS ipc,
    COALESCE(SUM(CASE WHEN c.nombre = 'igv' THEN rd.importe END),0) AS igv,
    COALESCE(SUM(CASE WHEN c.nombre = 'otros' THEN rd.importe END),0) AS otros

FROM recibos r
LEFT JOIN contratos ct ON r.contrato_id = ct.id
LEFT JOIN inquilinos i ON ct.inquilino_id = i.id
LEFT JOIN unidades u ON ct.unidad_id = u.id
LEFT JOIN inmuebles im ON u.inmueble_id = im.id

LEFT JOIN recibo_detalle rd ON r.id = rd.recibo_id
LEFT JOIN conceptos_recibo c ON rd.concepto_id = c.id

GROUP BY 
    r.id, r.codigo, r.total, r.fecha_emision,
    i.codigo, i.nombre_completo,
    u.codigo, u.tipo,
    im.nombre, im.imagen_url

ORDER BY r.fecha_emision DESC
""", nativeQuery = true)
List<ReciboResumenDTO> findResumen();


    List<Recibo> findByEstadoCobroFalse();



}


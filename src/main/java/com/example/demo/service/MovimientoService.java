package com.example.demo.service;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import com.example.demo.repository.*;
import java.util.List;
import com.example.demo.entity.*;
import com.example.demo.enums.TipoMovimiento;
import java.math.BigDecimal;

@Service
public class MovimientoService {

    @Autowired
    private MovimientoRepository movimientoRepo;

    @Autowired
    private CuentaBancariaRepository cuentaRepo;

    @Autowired
    private InmuebleRepository inmuebleRepo;

    @Autowired
    private UnidadRepository unidadRepo;

    @Autowired
    private ReciboRepository reciboRepo;


    
    // 🔹 CONSULTAS
    public List<Movimiento> listarTodos() {
        return movimientoRepo.findAll();
    }

    public List<Movimiento> porUnidad(Integer id) {
        return movimientoRepo.findByUnidadId(id);
    }

    public List<Movimiento> porInmueble(Integer id) {
        return movimientoRepo.findByInmuebleId(id);
    }


    public List<Object[]> resumen() {
        return movimientoRepo.resumen();
    }

    public List<Object[]> resumenPorInmueble() {
        return movimientoRepo.resumenPorInmueble();
    }

    public List<Object[]> resumenPorUnidad() {
        return movimientoRepo.resumenPorUnidad();
    }

    public List<Movimiento> porInquilino(Integer id) {
    return movimientoRepo.findMovimientosByInquilino(id);
    }
}
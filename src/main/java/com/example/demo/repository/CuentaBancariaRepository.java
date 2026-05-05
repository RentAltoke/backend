package com.example.demo.repository;
import com.example.demo.entity.CuentaBancaria;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CuentaBancariaRepository extends JpaRepository<CuentaBancaria, Integer> {

    // 🔹 Buscar por código (ya que es único)
    CuentaBancaria findByCodigo(String codigo);

    // 🔹 Buscar por número de cuenta (también único)
    CuentaBancaria findByNumeroCuenta(String numeroCuenta);

    // 🔹 Buscar cuentas por banco
    List<CuentaBancaria> findByBancoId(Integer bancoId);

    // 🔹 Buscar por moneda (PEN, USD, etc.)
    List<CuentaBancaria> findByMoneda(String moneda);

    // 🔹 Buscar cuentas con saldo mayor a X
    List<CuentaBancaria> findBySaldoActualGreaterThan(Double monto);

    // 🔹 Buscar cuentas con saldo menor a X
    List<CuentaBancaria> findBySaldoActualLessThan(Double monto);
}
package com.example.demo.repository;

import java.time.LocalDate;

public interface ReciboResumenDTO {

    Integer getId_recibo();
    String getCodigo_recibo();
    Double getTotal_recibo();

    LocalDate getFecha_emision();

    String getCodigo_inquilino();
    String getInquilino();


    String getUnidad();
    String getTipo_unidad();
    String getInmueble();
    String getImagen_url();


    Double getRenta();
    Double getAgua();
    Double getLuz();
    Double getMantenimiento();
    Double getIpc();
    Double getIgv();
    Double getOtros();
}
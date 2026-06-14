package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.List;
import java.util.Map;

@SpringBootApplication
public class RentaltokeBackendApplication implements CommandLineRunner {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Value("${spring.datasource.url}")
    private String url;

    @Value("${spring.datasource.username}")
    private String username;

    public static void main(String[] args) {
        SpringApplication.run(RentaltokeBackendApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {

        System.out.println("==================================");
        System.out.println("Datasource URL = " + url);
        System.out.println("Datasource User = " + username);
        System.out.println("==================================");

        System.out.println("--- CONECTADO A POSTGRESQL ---");

        try {
            List<Map<String, Object>> tables = jdbcTemplate.queryForList(
                "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'"
            );

            if (tables.isEmpty()) {
                System.out.println("La base de datos está conectada pero no tiene tablas.");
            } else {
                tables.forEach(row ->
                    System.out.println("Tabla encontrada: " + row.get("table_name"))
                );
            }
        } catch (Exception e) {
            System.err.println("Error al consultar la base de datos: " + e.getMessage());
        }
    }
}
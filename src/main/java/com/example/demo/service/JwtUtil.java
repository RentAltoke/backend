package com.example.demo.service;
import com.example.demo.repository.*;
import com.example.demo.entity.*;
import com.example.demo.repository.*;
import com.example.demo.service.*;


//import dsw.sigconbackend.model.Modulo;
//import dsw.sigconbackend.model.Usuario;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

import io.jsonwebtoken.SignatureAlgorithm;

import java.security.Key;

import java.util.Base64;

@Service
public class JwtUtil {
    private static final long JWT_EXPIRATION = 31536000000L;
    private final String SECRET_KEY ="mi_clave_super_secreta_muy_larga_123456";

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public <T> T extractClaim(
            String token,
            Function<Claims, T> resolver
    ) {
        Claims claims = extractAllClaims(token);
        return resolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {

        return Jwts.parserBuilder()
                .setSigningKey(getSignKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    public String generateToken(Usuario usuario) {

        return Jwts.builder()
                .setSubject(usuario.getEmail())
                .setIssuedAt(new Date())
                .setExpiration(
                    new Date(System.currentTimeMillis() + JWT_EXPIRATION)
                )
                .signWith(getSignKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    public boolean isTokenValid(String token, Usuario usuario) {

        final String username = extractUsername(token);

        return username.equals(usuario.getEmail())
                && !isTokenExpired(token);
    }

    private boolean isTokenExpired(String token) {

        return extractClaim(token, Claims::getExpiration)
                .before(new Date());
    }

    private Key getSignKey() {

        byte[] keyBytes = Decoders.BASE64.decode(
                Base64.getEncoder().encodeToString(
                        SECRET_KEY.getBytes()
                )
        );

        return Keys.hmacShaKeyFor(keyBytes);
    }
}
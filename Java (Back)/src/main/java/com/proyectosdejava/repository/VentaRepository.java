package com.proyectosdejava.repository;

import com.proyectosdejava.model.HistorialVentaDTO;
import com.proyectosdejava.model.ProductoDisponibleDTO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Repository
public class VentaRepository {

    @PersistenceContext
    private EntityManager em;

    public List<ProductoDisponibleDTO> buscarProductosDisponibles(String nombre, String marca,
                                                                  String categoria, String unidad) {
        List<Object[]> filas = em.createStoredProcedureQuery("sp_buscar_productos_disponibles_venta")
                .registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(4, String.class, ParameterMode.IN)
                .setParameter(1, nombre)
                .setParameter(2, marca)
                .setParameter(3, categoria)
                .setParameter(4, unidad)
                .getResultList();

        return filas.stream().map(f -> new ProductoDisponibleDTO(
                toInteger(f[0]),
                toStringValue(f[1]),
                toStringValue(f[2]),
                toStringValue(f[3]),
                toStringValue(f[4]),
                toInteger(f[5]),
                toBigDecimal(f[6])
        )).collect(Collectors.toList());
    }

    public List<HistorialVentaDTO> buscarHistorial(String usuario, LocalDate fechaInicio,
                                                  LocalDate fechaFin, Integer estado) {
        List<Object[]> filas = em.createStoredProcedureQuery("sp_buscar_historial_ventas")
                .registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, Date.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, Date.class, ParameterMode.IN)
                .registerStoredProcedureParameter(4, Integer.class, ParameterMode.IN)
                .setParameter(1, usuario)
                .setParameter(2, fechaInicio == null ? null : Date.valueOf(fechaInicio))
                .setParameter(3, fechaFin == null ? null : Date.valueOf(fechaFin))
                .setParameter(4, estado)
                .getResultList();

        return filas.stream().map(f -> new HistorialVentaDTO(
                toInteger(f[0]),
                toStringValue(f[1]),
                toStringValue(f[2]),
                toStringValue(f[3]),
                toStringValue(f[4]),
                toBigDecimal(f[5]),
                toInteger(f[6])
        )).collect(Collectors.toList());
    }

    public Map<String, Object> crearVenta(Integer idUsuario) {
        StoredProcedureQuery query = em.createStoredProcedureQuery("sp_venta_crear")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, Integer.class, ParameterMode.OUT)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.OUT)
                .setParameter(1, idUsuario);
        query.execute();

        Map<String, Object> respuesta = new HashMap<>();
        respuesta.put("idVenta", toInteger(query.getOutputParameterValue(2)));
        respuesta.put("mensaje", query.getOutputParameterValue(3));
        return respuesta;
    }

    public String crearDetalleVenta(Integer idVenta, Integer idProducto, Integer cantidad) {
        StoredProcedureQuery query = em.createStoredProcedureQuery("sp_detalle_venta_crear")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(4, String.class, ParameterMode.OUT)
                .setParameter(1, idVenta)
                .setParameter(2, idProducto)
                .setParameter(3, cantidad);
        query.execute();
        return (String) query.getOutputParameterValue(4);
    }

    public String reducirStock(Integer idProducto, Integer cantidad) {
        StoredProcedureQuery query = em.createStoredProcedureQuery("sp_producto_reducir_stock")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.OUT)
                .setParameter(1, idProducto)
                .setParameter(2, cantidad);
        query.execute();
        return (String) query.getOutputParameterValue(3);
    }

    public String devolverStock(Integer idVenta) {
        StoredProcedureQuery query = em.createStoredProcedureQuery("sp_venta_devolver_stock")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.OUT)
                .setParameter(1, idVenta);
        query.execute();
        return (String) query.getOutputParameterValue(2);
    }

    public String anularVenta(Integer idVenta) {
        StoredProcedureQuery query = em.createStoredProcedureQuery("sp_venta_anular")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.OUT)
                .setParameter(1, idVenta);
        query.execute();
        return (String) query.getOutputParameterValue(2);
    }

    private Integer toInteger(Object valor) {
        if (valor == null) {
            return null;
        }
        if (valor instanceof Number) {
            return ((Number) valor).intValue();
        }
        return Integer.valueOf(valor.toString());
    }

    private BigDecimal toBigDecimal(Object valor) {
        if (valor == null) {
            return null;
        }
        if (valor instanceof BigDecimal) {
            return (BigDecimal) valor;
        }
        return new BigDecimal(valor.toString());
    }

    private String toStringValue(Object valor) {
        return valor == null ? null : valor.toString();
    }
}

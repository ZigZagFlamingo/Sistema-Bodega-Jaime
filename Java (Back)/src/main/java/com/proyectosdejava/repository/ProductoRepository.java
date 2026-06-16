package com.proyectosdejava.repository;

import com.proyectosdejava.model.ProductoDTO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Repository
public class ProductoRepository {

    @PersistenceContext
    private EntityManager em;

    //Búsqueda activos/inactivos — convierten Object[] a ProductoDTO
    private List<ProductoDTO> ejecutarBusqueda(String spNombre,
                                               String nombre,
                                               String marca,
                                               String categoria) {
        List<Object[]> filas = em.createStoredProcedureQuery(spNombre)
                .registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
                .setParameter(1, nombre)
                .setParameter(2, marca)
                .setParameter(3, categoria)
                .getResultList();

        return filas.stream().map(f -> new ProductoDTO(
                (Integer)    f[0],   // Código
                (String)     f[1],   // Nombre
                (String)     f[2],   // Marca
                (String)     f[3],   // Categoría
                (String)     f[4],   // Unidad de medida
                (Integer)    f[5],   // Stock Actual
                (Integer)    f[6],   // Stock Mínimo
                (BigDecimal) f[7]    // Precio
        )).collect(Collectors.toList());
    }

    public List<ProductoDTO> buscarActivos(String nombre, String marca, String categoria) {
        return ejecutarBusqueda("sp_buscar_productos_activos", nombre, marca, categoria);
    }

    public List<ProductoDTO> buscarInactivos(String nombre, String marca, String categoria) {
        return ejecutarBusqueda("sp_buscar_productos_inactivos", nombre, marca, categoria);
    }

    //Crear — tiene parámetro OUT
    public String crearProducto(Integer idMarca, Integer idCategoria, Integer idUnidadDeMedida,
                                String nombre, Integer stockActual,
                                Integer stockMinimo, BigDecimal precioVenta) {
        StoredProcedureQuery q = em.createStoredProcedureQuery("sp_producto_crear")
                .registerStoredProcedureParameter(1, Integer.class,    ParameterMode.IN)
                .registerStoredProcedureParameter(2, Integer.class,    ParameterMode.IN)
                .registerStoredProcedureParameter(3, Integer.class,    ParameterMode.IN)
                .registerStoredProcedureParameter(4, String.class,     ParameterMode.IN)
                .registerStoredProcedureParameter(5, Integer.class,    ParameterMode.IN)
                .registerStoredProcedureParameter(6, Integer.class,    ParameterMode.IN)
                .registerStoredProcedureParameter(7, BigDecimal.class, ParameterMode.IN)
                .registerStoredProcedureParameter(8, String.class,     ParameterMode.OUT)
                .setParameter(1, idMarca)
                .setParameter(2, idCategoria)
                .setParameter(3, idUnidadDeMedida)
                .setParameter(4, nombre)
                .setParameter(5, stockActual)
                .setParameter(6, stockMinimo)
                .setParameter(7, precioVenta);
        q.execute();
        return (String) q.getOutputParameterValue(8); // "OK: ..." o "ERROR: ..."
    }

    //Editar — tiene parámetro OUT
    public String editarProducto(Integer idProducto, Integer idMarca, Integer idCategoria,
                                 Integer idUnidadDeMedida, String nombre, BigDecimal precioVenta) {

        em.createNativeQuery("CALL sp_producto_editar(:idProducto, :idMarca, :idCategoria, " +
                        ":idUnidadDeMedida, :nombre, NULL, NULL, " +
                        ":precioVenta, @resultado)")
                .setParameter("idProducto",       idProducto)
                .setParameter("idMarca",          idMarca)
                .setParameter("idCategoria",      idCategoria)
                .setParameter("idUnidadDeMedida", idUnidadDeMedida)
                .setParameter("nombre",           nombre)
                .setParameter("precioVenta",      precioVenta)
                .executeUpdate();

        return (String) em.createNativeQuery("SELECT @resultado")
                .getSingleResult();
    }

    //Cambiar estado — tiene parámetro OUT
    public String cambiarEstado(Integer idProducto, Integer estado) {
        StoredProcedureQuery q = em.createStoredProcedureQuery("sp_producto_cambiar_estado")
                .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter(3, String.class,  ParameterMode.OUT)
                .setParameter(1, idProducto)
                .setParameter(2, estado);
        q.execute();
        return (String) q.getOutputParameterValue(3);
    }
}

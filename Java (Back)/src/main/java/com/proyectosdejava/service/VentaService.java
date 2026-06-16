package com.proyectosdejava.service;

import com.proyectosdejava.model.DetalleVenta;
import com.proyectosdejava.model.HistorialVentaDTO;
import com.proyectosdejava.model.ProductoDisponibleDTO;
import com.proyectosdejava.model.Venta;
import com.proyectosdejava.repository.UsuarioRepository;
import com.proyectosdejava.repository.VentaRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class VentaService {

    private final VentaRepository ventaRepository;
    private final UsuarioRepository usuarioRepository;

    public VentaService(VentaRepository ventaRepository, UsuarioRepository usuarioRepository) {
        this.ventaRepository = ventaRepository;
        this.usuarioRepository = usuarioRepository;
    }

    public List<ProductoDisponibleDTO> buscarProductosDisponibles(String nombre, String marca,
                                                                  String categoria, String unidad) {
        return ventaRepository.buscarProductosDisponibles(nombre, marca, categoria, unidad);
    }

    public List<HistorialVentaDTO> buscarHistorial(String usuario, LocalDate fechaInicio,
                                                   LocalDate fechaFin, Integer estado) {
        return ventaRepository.buscarHistorial(usuario, fechaInicio, fechaFin, estado);
    }

    @Transactional
    public Map<String, String> registrarVenta(Venta venta) {
        if (venta == null) {
            return buildRespuesta("ERROR: La venta es obligatoria.");
        }
        if (venta.getIdUsuario() == null) {
            return buildRespuesta("ERROR: El usuario es obligatorio.");
        }
        if (!puedeRegistrarVenta(venta.getIdUsuario())) {
            return buildRespuesta("ERROR: El usuario no tiene permiso para registrar ventas.");
        }
        if (venta.getDetalles() == null || venta.getDetalles().isEmpty()) {
            return buildRespuesta("ERROR: La venta debe tener al menos un detalle.");
        }

        Map<String, Object> creacion = ventaRepository.crearVenta(venta.getIdUsuario());
        String resultadoCreacion = String.valueOf(creacion.get("mensaje"));
        if (!esOk(resultadoCreacion)) {
            return buildRespuesta(resultadoCreacion);
        }

        Integer idVenta = (Integer) creacion.get("idVenta");
        if (idVenta == null) {
            marcarRollback();
            return buildRespuesta("ERROR: No se pudo obtener el codigo de la venta.");
        }

        for (DetalleVenta detalle : venta.getDetalles()) {
            Map<String, String> validacion = validarDetalle(detalle);
            if (!esOk(validacion.get("mensaje"))) {
                marcarRollback();
                return validacion;
            }

            String resultadoDetalle = ventaRepository.crearDetalleVenta(
                    idVenta,
                    detalle.getIdProducto(),
                    detalle.getCantidad()
            );
            if (!esOk(resultadoDetalle)) {
                marcarRollback();
                return buildRespuesta(resultadoDetalle);
            }

            String resultadoStock = ventaRepository.reducirStock(
                    detalle.getIdProducto(),
                    detalle.getCantidad()
            );
            if (!esOk(resultadoStock)) {
                marcarRollback();
                return buildRespuesta(resultadoStock);
            }
        }

        Map<String, String> respuesta = buildRespuesta("OK: Venta registrada");
        respuesta.put("idVenta", String.valueOf(idVenta));
        return respuesta;
    }

    @Transactional
    public Map<String, String> anularVenta(Integer idVenta, Integer idUsuario) {
        if (idUsuario == null) {
            return buildRespuesta("ERROR: El usuario administrador es obligatorio.");
        }
        if (!usuarioRepository.tieneRol(idUsuario, "Administrador")) {
            return buildRespuesta("ERROR: Solo un administrador puede anular ventas.");
        }
        return buildRespuesta(ventaRepository.anularVenta(idVenta));
    }

    private boolean puedeRegistrarVenta(Integer idUsuario) {
        return usuarioRepository.tieneRol(idUsuario, "Administrador")
                || usuarioRepository.tieneRol(idUsuario, "Encargado");
    }

    private Map<String, String> validarDetalle(DetalleVenta detalle) {
        if (detalle == null) {
            return buildRespuesta("ERROR: El detalle de venta es obligatorio.");
        }
        if (detalle.getIdProducto() == null) {
            return buildRespuesta("ERROR: El producto es obligatorio.");
        }
        if (detalle.getCantidad() == null || detalle.getCantidad() <= 0) {
            return buildRespuesta("ERROR: La cantidad debe ser mayor que cero.");
        }
        return buildRespuesta("OK");
    }

    private boolean esOk(String resultado) {
        return resultado != null && resultado.startsWith("OK");
    }

    private void marcarRollback() {
        TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
    }

    private Map<String, String> buildRespuesta(String resultado) {
        Map<String, String> respuesta = new HashMap<>();
        respuesta.put("mensaje", resultado);
        return respuesta;
    }
}

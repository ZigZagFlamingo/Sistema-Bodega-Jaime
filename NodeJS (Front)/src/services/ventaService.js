import api from './api'

const ventaService = {

    buscarProductosDisponibles: (nombre = null, marca = null, categoria = null, unidad = null) =>
        api.get('/venta/productos-disponibles', { params: { nombre, marca, categoria, unidad } }),

    buscarHistorial: (usuario = null, fechaInicio = null, fechaFin = null, estado = null) =>
        api.get('/venta/historial', { params: { usuario, fechaInicio, fechaFin, estado } }),

    registrar: (datos) =>
        api.post('/venta', datos),

    anular: (id, idUsuario) =>
        api.patch(`/venta/${id}/anular`, null, { params: { idUsuario } }),
}

export default ventaService

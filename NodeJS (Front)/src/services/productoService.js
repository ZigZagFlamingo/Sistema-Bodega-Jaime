import api from './api'

const productoService = {

    buscarActivos: (nombre = null, marca = null, categoria = null) =>
        api.get('/producto/listar-activos', { params: { nombre, marca, categoria } }),

    buscarInactivos: (nombre = null, marca = null, categoria = null) =>
        api.get('/producto/listar-inactivos', { params: { nombre, marca, categoria } }),

    crear: (datos) =>
        api.post('/producto', datos),

    editar: (id, datos) =>
        api.put(`/producto/${id}`, datos),

    cambiarEstado: (id, valor) =>
        api.patch(`/producto/${id}/estado`, null, { params: { valor } }),
}

export default productoService
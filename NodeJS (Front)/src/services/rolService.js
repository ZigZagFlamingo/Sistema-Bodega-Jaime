import api from './api'

const rolService = {

    buscarActivos: (nombre = null, descripcion = null) =>
        api.get('/rol/listar-activos', { params: { nombre, descripcion } }),

    buscarInactivos: (nombre = null, descripcion = null) =>
        api.get('/rol/listar-inactivos', { params: { nombre, descripcion } }),

    crear: (datos) =>
        api.post('/rol', datos),

    editar: (id, datos) =>
        api.put(`/rol/${id}`, datos),

    cambiarEstado: (id, valor) =>
        api.patch(`/rol/${id}/estado`, null, { params: { valor } }),
}

export default rolService

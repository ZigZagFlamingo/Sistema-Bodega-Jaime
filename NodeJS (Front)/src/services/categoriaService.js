import api from './api'

const categoriaService = {

    buscarActivas: (nombre = null) =>
        api.get('/categoria/listar-activas', { params: { nombre } }),

    buscarInactivas: (nombre = null) =>
        api.get('/categoria/listar-inactivas', { params: { nombre } }),

    crear: (datos) =>
        api.post('/categoria', datos),

    editar: (id, datos) =>
        api.put(`/categoria/${id}`, datos),

    cambiarEstado: (id, valor) =>
        api.patch(`/categoria/${id}/estado`, null, { params: { valor } }),
}

export default categoriaService
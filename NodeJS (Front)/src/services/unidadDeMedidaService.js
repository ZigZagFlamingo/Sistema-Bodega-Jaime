import api from './api'

const unidadDeMedidaService = {

    buscarActivas: (nombre = null, abreviacion = null) =>
        api.get('/unidad-de-medida/listar-activas', { params: { nombre, abreviacion } }),

    buscarInactivas: (nombre = null, abreviacion = null) =>
        api.get('/unidad-de-medida/listar-inactivas', { params: { nombre, abreviacion } }),

    crear: (datos) =>
        api.post('/unidad-de-medida', datos),

    editar: (id, datos) =>
        api.put(`/unidad-de-medida/${id}`, datos),

    cambiarEstado: (id, valor) =>
        api.patch(`/unidad-de-medida/${id}/estado`, null, { params: { valor } }),
}

export default unidadDeMedidaService
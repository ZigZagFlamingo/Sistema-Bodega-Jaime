import api from './api'

const marcaService = {

    buscarActivas: (nombre = null, empresa = null) =>
        api.get('/marca/listar-activas', { params: { nombre, empresa } }),

    buscarInactivas: (nombre = null, empresa = null) =>
        api.get('/marca/listar-inactivas', { params: { nombre, empresa } }),

    crear: (datos) =>
        api.post('/marca', datos),

    editar: (id, datos) =>
        api.put(`/marca/${id}`, datos),

    cambiarEstado: (id, valor) =>
        api.patch(`/marca/${id}/estado`, null, { params: { valor } }),
}

export default marcaService
import api from './api'

const usuarioService = {

    buscarActivos: (nombre = null, correo = null, rol = null) =>
        api.get('/usuario/listar-activos', { params: { nombre, correo, rol } }),

    buscarInactivos: (nombre = null, correo = null, rol = null) =>
        api.get('/usuario/listar-inactivos', { params: { nombre, correo, rol } }),

    crear: (datos) =>
        api.post('/usuario', datos),

    editar: (id, datos) =>
        api.put(`/usuario/${id}`, datos),

    cambiarEstado: (id, valor) =>
        api.patch(`/usuario/${id}/estado`, null, { params: { valor } }),
}

export default usuarioService

import api from './api'

const selectorService = {
    marcas: () =>
        api.get('/marca/listar-activas'),

    categorias: () =>
        api.get('/categoria/listar-activas'),

    unidades: () =>
        api.get('/unidad-de-medida/listar-activas'),
}

export default selectorService
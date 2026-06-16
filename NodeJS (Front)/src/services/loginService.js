import api from './api'

const loginService = {
  login: async (correo, password) => {
    const response = await api.post('/auth/login', { correo, password })
    return response.data
  },

  cerrarSesion: () => {
    localStorage.removeItem('usuarioSesion')
  },
}

export default loginService

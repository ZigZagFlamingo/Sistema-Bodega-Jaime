const normalizarRol = (rol) => {
  if (!rol) return null
  return String(rol).trim().toLowerCase()
}

const rolPorId = {
  1: 'administrador',
  2: 'encargado',
}

export const obtenerRolSesion = () => {
  if (typeof window === 'undefined') return null

  const usuarioSesion = localStorage.getItem('usuarioSesion')
  if (usuarioSesion) {
    try {
      const usuario = JSON.parse(usuarioSesion)
      const rol = usuario.rol || usuario.nombreRol || usuario.role
      if (rol) return normalizarRol(rol)
      if (usuario.idRol && rolPorId[usuario.idRol]) return rolPorId[usuario.idRol]
    } catch {
      return null
    }
  }

  return normalizarRol(
    localStorage.getItem('rolSesion') ||
    localStorage.getItem('rol') ||
    localStorage.getItem('role')
  )
}

const permisos = {
  rol: ['administrador'],
  usuario: ['administrador'],
  registroVenta: ['administrador', 'encargado'],
  historialVenta: ['administrador'],
}

export const puedeVerModulo = (modulo) => {
  const rolesPermitidos = permisos[modulo]
  if (!rolesPermitidos) return true

  const rolSesion = obtenerRolSesion()
  if (!rolSesion) return true

  return rolesPermitidos.includes(rolSesion)
}

import { NavLink } from 'react-router-dom'
import { puedeVerModulo } from '../services/sesionService'

function Navbar({ onCerrarSesion }) {
  const linkClass = ({ isActive }) =>
    isActive
      ? 'block bg-gray-600 px-4 py-2 rounded'
      : 'block px-4 py-2 rounded hover:bg-gray-700'

  return (
    <nav className="bg-gray-800 text-white w-48 min-w-48 h-screen sticky top-0 p-4 flex flex-col gap-2 overflow-y-auto shrink-0">
      <NavLink to="/" className="block text-lg font-medium mb-4 hover:text-gray-300">
        Bodega Jaime
      </NavLink>
      <NavLink to="/marca" className={linkClass}>
        Marcas
      </NavLink>
      <NavLink to="/categoria" className={linkClass}>
        Categorias
      </NavLink>
      <NavLink to="/unidad-de-medida" className={linkClass}>
        Unidades de medida
      </NavLink>
      <NavLink to="/producto" className={linkClass}>
        Productos
      </NavLink>
      {puedeVerModulo('rol') && (
        <NavLink to="/rol" className={linkClass}>
          Roles
        </NavLink>
      )}
      {puedeVerModulo('usuario') && (
        <NavLink to="/usuario" className={linkClass}>
          Usuarios
        </NavLink>
      )}
      {puedeVerModulo('registroVenta') && (
        <NavLink to="/venta" className={linkClass}>
          Registro de venta
        </NavLink>
      )}
      {puedeVerModulo('historialVenta') && (
        <NavLink to="/historial-venta" className={linkClass}>
          Historial de ventas
        </NavLink>
      )}

      <div className="mt-auto pt-4 border-t border-gray-600 sticky bottom-0 bg-gray-800">
        <button
          onClick={onCerrarSesion}
          className="w-full text-left px-4 py-2 rounded hover:bg-red-700 text-sm text-gray-300 hover:text-white transition-colors"
        >
          Cerrar sesion
        </button>
      </div>
    </nav>
  )
}

export default Navbar

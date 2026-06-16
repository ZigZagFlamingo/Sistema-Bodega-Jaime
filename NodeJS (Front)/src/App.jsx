import { useState } from 'react'
import { Routes, Route, Navigate, useNavigate } from 'react-router-dom'
import Navbar from './components/Navbar'
import Inicio from './pages/Inicio'
import Marca from './pages/Marca'
import Categoria from './pages/Categoria'
import UnidadDeMedida from './pages/UnidadDeMedida'
import Producto from './pages/Producto'
import Rol from './pages/Rol'
import Usuario from './pages/Usuario'
import Venta from './pages/Venta'
import HistorialVenta from './pages/HistorialVenta'
import Login from './pages/Login'
import { puedeVerModulo } from './services/sesionService'
import loginService from './services/loginService'

function App() {
  const navigate = useNavigate()
  const [sesionActiva, setSesionActiva] = useState(
    () => !!localStorage.getItem('usuarioSesion')
  )

  const handleLoginExitoso = () => {
    setSesionActiva(true)
    navigate('/', { replace: true })
  }

  const handleCerrarSesion = () => {
    loginService.cerrarSesion()
    setSesionActiva(false)
    navigate('/login', { replace: true })
  }

  if (!sesionActiva) {
    return (
      <Routes>
        <Route path="/login" element={<Login onLoginExitoso={handleLoginExitoso} />} />
        <Route path="*" element={<Navigate to="/login" replace />} />
      </Routes>
    )
  }

  const rutaPermitida = (modulo, componente) =>
    puedeVerModulo(modulo) ? componente : <Navigate to="/" replace />

  return (
    <div className="flex">
      <Navbar onCerrarSesion={handleCerrarSesion} />
      <main className="flex-1 p-6 bg-gray-100 min-h-screen">
        <Routes>
          <Route path="/login" element={<Navigate to="/" replace />} />
          <Route path="/" element={<Inicio />} />
          <Route path="/marca" element={<Marca />} />
          <Route path="/categoria" element={<Categoria />} />
          <Route path="/unidad-de-medida" element={<UnidadDeMedida />} />
          <Route path="/producto" element={<Producto />} />
          <Route path="/rol" element={rutaPermitida('rol', <Rol />)} />
          <Route path="/usuario" element={rutaPermitida('usuario', <Usuario />)} />
          <Route path="/venta" element={rutaPermitida('registroVenta', <Venta />)} />
          <Route path="/historial-venta" element={rutaPermitida('historialVenta', <HistorialVenta />)} />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </main>
    </div>
  )
}

export default App

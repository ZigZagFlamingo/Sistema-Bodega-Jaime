import { useState } from 'react'
import loginService from '../services/loginService'

function Login({ onLoginExitoso }) {
  const [correo, setCorreo] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [cargando, setCargando] = useState(false)

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setCargando(true)

    try {
      const usuario = await loginService.login(correo.trim(), password)
      localStorage.setItem('usuarioSesion', JSON.stringify(usuario))
      onLoginExitoso()
    } catch (err) {
      const status = err.response?.status
      const mensajeBackend = err.response?.data?.mensaje

      if (status === 401 || status === 403) {
        setError(mensajeBackend || 'Correo o password incorrectos')
      } else if (!err.response) {
        setError('No se pudo conectar con el servidor')
      } else {
        setError(mensajeBackend || 'No se pudo iniciar sesion')
      }
    } finally {
      setCargando(false)
    }
  }

  return (
    <div className="min-h-screen bg-[#eaf2fb] flex items-center justify-center px-4">
      <div className="bg-white/85 rounded-2xl shadow-lg p-10 w-full max-w-md">
        <h1 className="text-3xl font-bold text-slate-900 mb-1">Bodega Jaime</h1>
        <p className="text-slate-500 text-sm mb-8">Inicia sesion para continuar</p>

        <form onSubmit={handleSubmit} className="flex flex-col gap-5">
          <div className="flex flex-col gap-1">
            <label className="text-sm font-medium text-slate-600">Correo</label>
            <input
              type="email"
              value={correo}
              onChange={(e) => setCorreo(e.target.value)}
              required
              placeholder="tu@correo.com"
              className="border border-slate-300 rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500"
            />
          </div>

          <div className="flex flex-col gap-1">
            <label className="text-sm font-medium text-slate-600">Password</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              placeholder="********"
              className="border border-slate-300 rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500"
            />
          </div>

          {error && (
            <p className="text-red-700 text-sm bg-red-50 border border-red-200 rounded-lg px-3 py-2">
              {error}
            </p>
          )}

          <button
            type="submit"
            disabled={cargando}
            className="bg-yellow-400 border-4 border-yellow-500 text-slate-950 py-2.5 rounded-xl text-sm font-bold hover:bg-yellow-300 transition-colors disabled:opacity-60"
          >
            {cargando ? 'Ingresando...' : 'Ingresar'}
          </button>
        </form>
      </div>
    </div>
  )
}

export default Login

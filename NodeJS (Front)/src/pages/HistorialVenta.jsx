/* eslint-disable react-hooks/set-state-in-effect, react-hooks/exhaustive-deps */
import { useState, useEffect } from 'react'
import ventaService from '../services/ventaService'
import usuarioService from '../services/usuarioService'

function HistorialVenta() {
  const [usuarios, setUsuarios] = useState([])
  const [historial, setHistorial] = useState([])
  const [idUsuario, setIdUsuario] = useState('')
  const [historialUsuario, setHistorialUsuario] = useState('')
  const [fechaInicio, setFechaInicio] = useState('')
  const [fechaFin, setFechaFin] = useState('')
  const [estadoHistorial, setEstadoHistorial] = useState('')
  const [mensaje, setMensaje] = useState(null)
  const [mensajeError, setMensajeError] = useState(false)

  const inputClass = 'border border-slate-300 rounded-lg bg-transparent px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500'
  const buttonPrimary = 'bg-slate-800 text-white px-5 py-3 rounded-lg text-sm font-semibold hover:bg-slate-700'
  const buttonSecondary = 'bg-white/80 text-slate-700 px-5 py-3 rounded-lg text-sm font-semibold hover:bg-white'
  const buttonDanger = 'bg-red-50 text-red-700 border border-red-100 px-4 py-1.5 rounded-lg text-xs font-bold hover:bg-red-100'

  const cargarUsuarios = async () => {
    try {
      const res = await usuarioService.buscarActivos()
      setUsuarios(res.data)
    } catch {
      setMensaje('Error al cargar usuarios')
      setMensajeError(true)
    }
  }

  const cargarHistorial = async () => {
    try {
      const res = await ventaService.buscarHistorial(
        historialUsuario || null,
        fechaInicio || null,
        fechaFin || null,
        estadoHistorial === '' ? null : Number(estadoHistorial)
      )
      setHistorial(res.data)
    } catch {
      setMensaje('Error al cargar historial de ventas')
      setMensajeError(true)
    }
  }

  useEffect(() => {
    cargarUsuarios()
    cargarHistorial()
  }, [])

  const limpiarFiltros = async () => {
    setHistorialUsuario('')
    setFechaInicio('')
    setFechaFin('')
    setEstadoHistorial('')

    try {
      const res = await ventaService.buscarHistorial(null, null, null, null)
      setHistorial(res.data)
    } catch {
      setMensaje('Error al cargar historial de ventas')
      setMensajeError(true)
    }
  }

  const ventasActivas = historial.filter(v => Number(v.estado) === 1)
  const ventasAnuladas = historial.filter(v => Number(v.estado) === 0)
  const ingresosActivos = ventasActivas.reduce((total, venta) => total + Number(venta.total || 0), 0)

  const estadoBadge = (estado) =>
    Number(estado) === 1
      ? 'bg-green-50 text-green-700 border-green-100'
      : 'bg-red-50 text-red-700 border-red-100'

  const anularVenta = async (idVenta) => {
    if (!idUsuario) {
      setMensaje('Selecciona un usuario administrador para anular')
      setMensajeError(true)
      return
    }

    try {
      const res = await ventaService.anular(idVenta, Number(idUsuario))
      const exito = res.data.mensaje.startsWith('OK')
      setMensaje(res.data.mensaje)
      setMensajeError(!exito)
      if (exito) {
        cargarHistorial()
      }
    } catch (error) {
      setMensaje(error.response?.data?.mensaje || 'Error al anular venta')
      setMensajeError(true)
    }
  }

  return (
    <div className="-m-6 min-h-screen bg-[#eaf2fb] p-8 text-slate-900">
      <div className="flex flex-col lg:flex-row lg:items-start lg:justify-between gap-5 mb-7">
        <div>
          <h1 className="text-4xl font-bold tracking-tight border-l-2 border-slate-800 pl-2">Historial de ventas</h1>
          <p className="text-sm text-slate-500 mt-2">Consulta operativa de ventas registradas</p>
        </div>

        <div className="bg-white/80 rounded-2xl p-4 shadow-sm min-w-64">
          <p className="text-xs text-slate-500">Ingresos activos</p>
          <p className="text-3xl font-bold">S/ {ingresosActivos.toFixed(2)}</p>
          <p className="text-xs text-slate-500 mt-1">{historial.length} registro(s) encontrados</p>
        </div>
      </div>

      {mensaje && (
        <div className={`mb-5 border-l-4 p-3 rounded text-sm flex justify-between items-center shadow-sm ${mensajeError ? 'bg-red-50 text-red-800 border-red-500' : 'bg-green-50 text-green-800 border-green-500'}`}>
          <span>{mensaje}</span>
          <button onClick={() => setMensaje(null)} className="ml-4 text-base leading-none hover:opacity-70">x</button>
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div className="bg-white/80 rounded-2xl p-4 shadow-sm">
          <p className="text-xs text-slate-500">Ventas encontradas</p>
          <p className="text-2xl font-bold">{historial.length}</p>
        </div>
        <div className="bg-white/80 rounded-2xl p-4 shadow-sm">
          <p className="text-xs text-slate-500">Ventas activas</p>
          <p className="text-2xl font-bold text-green-700">{ventasActivas.length}</p>
        </div>
        <div className="bg-white/80 rounded-2xl p-4 shadow-sm">
          <p className="text-xs text-slate-500">Ventas anuladas</p>
          <p className="text-2xl font-bold text-red-700">{ventasAnuladas.length}</p>
        </div>
        <div className="bg-white/80 rounded-2xl p-4 shadow-sm">
          <p className="text-xs text-slate-500">Total activo</p>
          <p className="text-2xl font-bold">S/ {ingresosActivos.toFixed(2)}</p>
        </div>
      </div>

      <div className="bg-white/50 border border-white/70 rounded-2xl p-5 mb-7 shadow-sm">
        <div className="flex flex-wrap gap-3">
          <div className="flex flex-col gap-1 flex-1 min-w-56">
            <label className="text-xs font-bold text-slate-500">Usuario o correo</label>
            <input
              placeholder="Buscar usuario o correo"
              value={historialUsuario}
              onChange={e => setHistorialUsuario(e.target.value)}
              className={inputClass}
            />
          </div>

          <div className="flex flex-col gap-1">
            <label className="text-xs font-bold text-slate-500">Fecha inicio</label>
            <input
              type="date"
              value={fechaInicio}
              onChange={e => setFechaInicio(e.target.value)}
              className={inputClass}
            />
          </div>

          <div className="flex flex-col gap-1">
            <label className="text-xs font-bold text-slate-500">Fecha fin</label>
            <input
              type="date"
              value={fechaFin}
              onChange={e => setFechaFin(e.target.value)}
              className={inputClass}
            />
          </div>

          <div className="flex flex-col gap-1">
            <label className="text-xs font-bold text-slate-500">Estado</label>
            <select
              value={estadoHistorial}
              onChange={e => setEstadoHistorial(e.target.value)}
              className={inputClass}
            >
              <option value="">Todos</option>
              <option value="1">Activas</option>
              <option value="0">Anuladas</option>
            </select>
          </div>

          <div className="flex items-end gap-2">
            <button onClick={cargarHistorial} className={buttonPrimary}>
              Buscar
            </button>
            <button onClick={limpiarFiltros} className={buttonSecondary}>
              Limpiar
            </button>
          </div>
        </div>

        <div className="flex flex-col gap-1 max-w-md mt-4">
          <label className="text-xs font-bold text-slate-500">Usuario administrador para anular</label>
          <select
            value={idUsuario}
            onChange={e => setIdUsuario(e.target.value)}
            className={inputClass}
          >
            <option value="">-- Selecciona un usuario --</option>
            {usuarios.map(u => (
              <option key={u[0]} value={u[0]}>{u[1]} - {u[3]}</option>
            ))}
          </select>
        </div>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full min-w-[980px] text-sm">
          <thead className="text-slate-800 border-b border-slate-400">
            <tr>
              <th className="py-4 px-3 text-left font-bold">ID</th>
              <th className="py-4 px-3 text-left font-bold">Fecha</th>
              <th className="py-4 px-3 text-left font-bold">Usuario</th>
              <th className="py-4 px-3 text-left font-bold">Correo</th>
              <th className="py-4 px-3 text-left font-bold">Rol</th>
              <th className="py-4 px-3 text-left font-bold">Total</th>
              <th className="py-4 px-3 text-left font-bold">Estado</th>
              <th className="py-4 px-3 text-left font-bold">Accion</th>
            </tr>
          </thead>
          <tbody>
            {historial.length === 0 ? (
              <tr>
                <td colSpan={8} className="py-12 text-center text-slate-400">Sin ventas registradas</td>
              </tr>
            ) : (
              historial.map(v => (
                <tr key={v.codigo} className="border-b border-slate-200 hover:bg-white/45">
                  <td className="py-7 px-3 text-slate-500">{v.codigo}</td>
                  <td className="py-7 px-3">{v.fecha}</td>
                  <td className="py-7 px-3 font-medium">{v.usuario}</td>
                  <td className="py-7 px-3">{v.correo}</td>
                  <td className="py-7 px-3">{v.rol}</td>
                  <td className="py-7 px-3 font-bold">S/ {Number(v.total).toFixed(2)}</td>
                  <td className="py-7 px-3">
                    <span className={`inline-flex border px-3 py-2 rounded-lg text-xs font-bold ${estadoBadge(v.estado)}`}>
                      {v.estado === 1 ? 'Activa' : 'Anulada'}
                    </span>
                  </td>
                  <td className="py-7 px-3">
                    {v.estado === 1 ? (
                      <button onClick={() => anularVenta(v.codigo)} className={buttonDanger}>
                        Anular
                      </button>
                    ) : (
                      <span className="text-slate-400">-</span>
                    )}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
}

export default HistorialVenta

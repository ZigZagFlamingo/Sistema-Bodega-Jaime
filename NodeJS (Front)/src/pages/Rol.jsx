/* eslint-disable react-hooks/set-state-in-effect, react-hooks/exhaustive-deps */
import { useState, useEffect } from 'react'
import rolService from '../services/rolService'

function Rol() {
  const [roles, setRoles] = useState([])
  const [verActivos, setVerActivos] = useState(true)
  const [filtroNombre, setFiltroNombre] = useState('')
  const [filtroDescripcion, setFiltroDescripcion] = useState('')
  const [mensaje, setMensaje] = useState(null)
  const [mensajeError, setMensajeError] = useState(false)

  const [modalAbierto, setModalAbierto] = useState(false)
  const [editando, setEditando] = useState(null)
  const [form, setForm] = useState({ nombre: '', descripcion: '' })

  const inputLine = 'w-full bg-transparent border-0 border-b border-slate-400 px-0 py-2 text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:border-slate-700'
  const filterInput = 'border border-slate-300 rounded-lg bg-transparent px-4 py-3 text-sm flex-1 min-w-40 focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500'

  const cargar = async (nombre = filtroNombre, descripcion = filtroDescripcion) => {
    try {
      const res = verActivos
        ? await rolService.buscarActivos(nombre || null, descripcion || null)
        : await rolService.buscarInactivos(nombre || null, descripcion || null)
      setRoles(res.data)
    } catch {
      setMensaje('Error al cargar roles')
      setMensajeError(true)
    }
  }

  useEffect(() => { cargar() }, [verActivos])

  const abrirCrear = () => {
    setEditando(null)
    setForm({ nombre: '', descripcion: '' })
    setMensaje(null)
    setModalAbierto(true)
  }

  const abrirEditar = (rol) => {
    setEditando(rol)
    setForm({ nombre: rol[1], descripcion: rol[2] })
    setMensaje(null)
    setModalAbierto(true)
  }

  const guardar = async () => {
    try {
      const res = editando
        ? await rolService.editar(editando[0], form)
        : await rolService.crear(form)
      const exito = res.data.mensaje.startsWith('OK')
      setMensaje(res.data.mensaje)
      setMensajeError(!exito)
      if (exito) {
        setModalAbierto(false)
        cargar()
      }
    } catch (error) {
      setMensaje(error.response?.data?.mensaje || 'Error al guardar')
      setMensajeError(true)
    }
  }

  const cambiarEstado = async (id, nuevoEstado) => {
    try {
      const res = await rolService.cambiarEstado(id, nuevoEstado)
      setMensaje(res.data.mensaje)
      setMensajeError(false)
      cargar()
    } catch (error) {
      setMensaje(error.response?.data?.mensaje || 'Error al cambiar estado')
      setMensajeError(true)
    }
  }

  const limpiarFiltros = () => {
    setFiltroNombre('')
    setFiltroDescripcion('')
    cargar('', '')
  }

  return (
    <div className="-m-6 min-h-screen bg-[#eaf2fb] p-8 text-slate-900">
      <div className="flex flex-col lg:flex-row lg:items-start lg:justify-between gap-5 mb-7">
        <div>
          <h1 className="text-4xl font-bold tracking-tight border-l-2 border-slate-800 pl-2">Roles</h1>
          <p className="text-sm text-slate-500 mt-2">Permisos y perfiles del sistema</p>
        </div>

        <div className="flex flex-col items-stretch sm:items-end gap-3">
          <button
            onClick={abrirCrear}
            className="bg-yellow-400 border-4 border-yellow-500 text-slate-950 px-6 py-2 rounded-xl font-bold hover:bg-yellow-300 flex items-center justify-center gap-3"
          >
            <span className="text-2xl leading-none">+</span>
            nuevo
          </button>
          <input
            placeholder="...buscar rol"
            value={filtroNombre}
            onChange={e => setFiltroNombre(e.target.value)}
            onKeyDown={e => { if (e.key === 'Enter') cargar() }}
            className="w-full sm:w-80 border border-slate-300 rounded-lg bg-transparent px-4 py-4 text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500"
          />
        </div>
      </div>

      {mensaje && !modalAbierto && (
        <div className={`mb-5 border-l-4 p-3 rounded text-sm flex justify-between items-center shadow-sm ${mensajeError ? 'bg-red-50 text-red-800 border-red-500' : 'bg-green-50 text-green-800 border-green-500'}`}>
          <span>{mensaje}</span>
          <button onClick={() => setMensaje(null)} className="ml-4 text-base leading-none hover:opacity-70">x</button>
        </div>
      )}

      <div className="flex flex-wrap gap-3 mb-7">
        <input
          placeholder="Buscar por nombre"
          value={filtroNombre}
          onChange={e => setFiltroNombre(e.target.value)}
          className={filterInput}
        />
        <input
          placeholder="Buscar por descripcion"
          value={filtroDescripcion}
          onChange={e => setFiltroDescripcion(e.target.value)}
          className={filterInput}
        />
        <button onClick={() => cargar()} className="bg-slate-800 text-white px-5 py-3 rounded-lg text-sm font-semibold hover:bg-slate-700">
          Buscar
        </button>
        <button onClick={limpiarFiltros} className="bg-white/80 text-slate-700 px-5 py-3 rounded-lg text-sm font-semibold hover:bg-white">
          Limpiar
        </button>
        <button onClick={() => setVerActivos(!verActivos)} className="bg-white/80 text-slate-700 px-5 py-3 rounded-lg text-sm font-semibold hover:bg-white">
          Ver {verActivos ? 'inactivos' : 'activos'}
        </button>
        <span className="bg-white/70 text-slate-600 px-5 py-3 rounded-lg text-sm font-semibold">
          {roles.length} registro(s)
        </span>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full min-w-[760px] text-sm">
          <thead className="text-slate-800 border-b border-slate-400">
            <tr>
              <th className="py-4 px-3 text-left font-bold">ID</th>
              <th className="py-4 px-3 text-left font-bold">Nombre</th>
              <th className="py-4 px-3 text-left font-bold">Descripcion</th>
              <th className="py-4 px-3 text-left font-bold">Acciones</th>
            </tr>
          </thead>
          <tbody>
            {roles.length === 0 ? (
              <tr>
                <td colSpan={4} className="py-12 text-center text-slate-400">Sin resultados</td>
              </tr>
            ) : (
              roles.map((r) => (
                <tr key={r[0]} className="border-b border-slate-200 hover:bg-white/45">
                  <td className="py-7 px-3 text-slate-500">{r[0]}</td>
                  <td className="py-7 px-3 font-medium">{r[1]}</td>
                  <td className="py-7 px-3">{r[2]}</td>
                  <td className="py-7 px-3">
                    <div className="flex flex-wrap gap-2">
                      <button onClick={() => abrirEditar(r)} className="bg-yellow-400 border-2 border-yellow-500 text-slate-950 px-4 py-1.5 rounded-lg text-xs font-bold hover:bg-yellow-300">
                        Editar
                      </button>
                      <button
                        onClick={() => cambiarEstado(r[0], verActivos ? 0 : 1)}
                        className={`px-4 py-1.5 rounded-lg text-xs font-bold ${verActivos ? 'bg-red-50 text-red-700 border border-red-100 hover:bg-red-100' : 'bg-green-50 text-green-700 border border-green-100 hover:bg-green-100'}`}
                      >
                        {verActivos ? 'Desactivar' : 'Activar'}
                      </button>
                    </div>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {modalAbierto && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-[#eaf2fb] rounded-md shadow-2xl w-full max-w-xl min-h-[440px] relative p-9">
            <button
              onClick={() => setModalAbierto(false)}
              className="absolute right-8 top-6 text-5xl leading-none text-slate-700 hover:text-slate-950"
            >
              x
            </button>

            <h2 className="text-3xl font-bold uppercase mb-9">
              {editando ? 'Editar rol' : 'Registrar nuevo rol'}
            </h2>

            <div className="space-y-5">
              <div>
                <label className="text-slate-400 text-lg">nombre</label>
                <input
                  placeholder="Nombre del rol"
                  value={form.nombre}
                  onChange={e => setForm({ ...form, nombre: e.target.value })}
                  className={inputLine}
                />
              </div>

              <div>
                <label className="text-slate-400 text-lg">descripcion</label>
                <textarea
                  placeholder="Descripcion"
                  value={form.descripcion}
                  onChange={e => setForm({ ...form, descripcion: e.target.value })}
                  className={`${inputLine} resize-none`}
                  rows={3}
                />
              </div>
            </div>

            {mensaje && (
              <div className={`mt-6 p-3 rounded text-sm ${mensajeError ? 'bg-red-50 text-red-800' : 'bg-green-50 text-green-800'}`}>
                {mensaje}
              </div>
            )}

            <button
              onClick={guardar}
              className="mt-8 bg-yellow-400 border-4 border-yellow-500 text-slate-950 px-10 py-3 rounded-xl font-bold hover:bg-yellow-300 w-full sm:w-80"
            >
              Guardar
            </button>
          </div>
        </div>
      )}
    </div>
  )
}

export default Rol

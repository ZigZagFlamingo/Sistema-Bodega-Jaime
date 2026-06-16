/* eslint-disable react-hooks/set-state-in-effect, react-hooks/exhaustive-deps */
import { useState, useEffect } from 'react'
import usuarioService from '../services/usuarioService'
import rolService from '../services/rolService'

function Usuario() {
  const [usuarios, setUsuarios] = useState([])
  const [roles, setRoles] = useState([])
  const [verActivos, setVerActivos] = useState(true)
  const [filtroNombre, setFiltroNombre] = useState('')
  const [filtroCorreo, setFiltroCorreo] = useState('')
  const [filtroRol, setFiltroRol] = useState('')
  const [mensaje, setMensaje] = useState(null)
  const [mensajeError, setMensajeError] = useState(false)

  const [modalAbierto, setModalAbierto] = useState(false)
  const [editando, setEditando] = useState(null)
  const [form, setForm] = useState({ idRol: '', nombre: '', correo: '', password: '' })

  const inputLine = 'w-full bg-transparent border-0 border-b border-slate-400 px-0 py-2 text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:border-slate-700'
  const filterInput = 'border border-slate-300 rounded-lg bg-transparent px-4 py-3 text-sm flex-1 min-w-40 focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500'
  const selectClass = 'border border-slate-300 rounded-md px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500'

  const cargar = async (nombre = filtroNombre, correo = filtroCorreo, rol = filtroRol) => {
    try {
      const res = verActivos
        ? await usuarioService.buscarActivos(nombre || null, correo || null, rol || null)
        : await usuarioService.buscarInactivos(nombre || null, correo || null, rol || null)
      setUsuarios(res.data)
    } catch {
      setMensaje('Error al cargar usuarios')
      setMensajeError(true)
    }
  }

  const cargarRoles = async () => {
    try {
      const res = await rolService.buscarActivos()
      setRoles(res.data)
      return res.data
    } catch {
      setMensaje('Error al cargar roles')
      setMensajeError(true)
      return []
    }
  }

  useEffect(() => { cargar() }, [verActivos])

  const abrirCrear = async () => {
    await cargarRoles()
    setEditando(null)
    setForm({ idRol: '', nombre: '', correo: '', password: '' })
    setMensaje(null)
    setModalAbierto(true)
  }

  const abrirEditar = async (usuario) => {
    const rolesActivos = await cargarRoles()
    const rolActual = rolesActivos.find(r => r[1] === usuario[3])
    setEditando(usuario)
    setForm({
      idRol: rolActual ? rolActual[0] : '',
      nombre: usuario[1],
      correo: usuario[2],
      password: ''
    })
    setMensaje(null)
    setModalAbierto(true)
  }

  const buildPayload = () => ({
    idRol: form.idRol ? Number(form.idRol) : null,
    nombre: form.nombre,
    correo: form.correo,
    password: form.password
  })

  const guardar = async () => {
    try {
      const payload = buildPayload()
      const res = editando
        ? await usuarioService.editar(editando[0], payload)
        : await usuarioService.crear(payload)
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
      const res = await usuarioService.cambiarEstado(id, nuevoEstado)
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
    setFiltroCorreo('')
    setFiltroRol('')
    cargar('', '', '')
  }

  return (
    <div className="-m-6 min-h-screen bg-[#eaf2fb] p-8 text-slate-900">
      <div className="flex flex-col lg:flex-row lg:items-start lg:justify-between gap-5 mb-7">
        <div>
          <h1 className="text-4xl font-bold tracking-tight border-l-2 border-slate-800 pl-2">Usuarios</h1>
          <p className="text-sm text-slate-500 mt-2">Personal responsable y acceso por rol</p>
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
            placeholder="...buscar usuario"
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
          placeholder="Buscar por correo"
          value={filtroCorreo}
          onChange={e => setFiltroCorreo(e.target.value)}
          className={filterInput}
        />
        <input
          placeholder="Buscar por rol"
          value={filtroRol}
          onChange={e => setFiltroRol(e.target.value)}
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
          {usuarios.length} registro(s)
        </span>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full min-w-[900px] text-sm">
          <thead className="text-slate-800 border-b border-slate-400">
            <tr>
              <th className="py-4 px-3 text-left font-bold">ID</th>
              <th className="py-4 px-3 text-left font-bold">Nombre</th>
              <th className="py-4 px-3 text-left font-bold">Correo</th>
              <th className="py-4 px-3 text-left font-bold">Rol</th>
              <th className="py-4 px-3 text-left font-bold">Acciones</th>
            </tr>
          </thead>
          <tbody>
            {usuarios.length === 0 ? (
              <tr>
                <td colSpan={5} className="py-12 text-center text-slate-400">Sin resultados</td>
              </tr>
            ) : (
              usuarios.map((u) => (
                <tr key={u[0]} className="border-b border-slate-200 hover:bg-white/45">
                  <td className="py-7 px-3 text-slate-500">{u[0]}</td>
                  <td className="py-7 px-3 font-medium">{u[1]}</td>
                  <td className="py-7 px-3">{u[2]}</td>
                  <td className="py-7 px-3">
                    <span className="inline-flex bg-white/80 border border-slate-200 px-3 py-1 rounded-lg text-xs font-semibold">
                      {u[3]}
                    </span>
                  </td>
                  <td className="py-7 px-3">
                    <div className="flex flex-wrap gap-2">
                      <button onClick={() => abrirEditar(u)} className="bg-yellow-400 border-2 border-yellow-500 text-slate-950 px-4 py-1.5 rounded-lg text-xs font-bold hover:bg-yellow-300">
                        Editar
                      </button>
                      <button
                        onClick={() => cambiarEstado(u[0], verActivos ? 0 : 1)}
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
          <div className="bg-[#eaf2fb] rounded-md shadow-2xl w-full max-w-2xl min-h-[560px] relative p-9">
            <button
              onClick={() => setModalAbierto(false)}
              className="absolute right-8 top-6 text-5xl leading-none text-slate-700 hover:text-slate-950"
            >
              x
            </button>

            <h2 className="text-3xl font-bold uppercase mb-9">
              {editando ? 'Editar usuario' : 'Registrar nuevo usuario'}
            </h2>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div className="space-y-5">
                <div>
                  <label className="text-slate-400 text-lg">nombre</label>
                  <input
                    placeholder="Nombre del usuario"
                    value={form.nombre}
                    onChange={e => setForm({ ...form, nombre: e.target.value })}
                    className={inputLine}
                  />
                </div>

                <div>
                  <label className="text-slate-400 text-lg">correo</label>
                  <input
                    placeholder="correo@ejemplo.com"
                    type="email"
                    value={form.correo}
                    onChange={e => setForm({ ...form, correo: e.target.value })}
                    className={inputLine}
                  />
                </div>
              </div>

              <div className="space-y-5">
                <div>
                  <label className="text-slate-700 block mb-2">Rol:</label>
                  <select
                    value={form.idRol}
                    onChange={e => setForm({ ...form, idRol: e.target.value })}
                    className={`${selectClass} w-full`}
                  >
                    <option value="">-- Selecciona un rol --</option>
                    {roles.map(r => (
                      <option key={r[0]} value={r[0]}>{r[1]}</option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="text-slate-400 text-lg">password</label>
                  <input
                    placeholder={editando ? 'Nuevo password opcional' : 'Password'}
                    type="password"
                    value={form.password}
                    onChange={e => setForm({ ...form, password: e.target.value })}
                    className={inputLine}
                  />
                </div>
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

export default Usuario

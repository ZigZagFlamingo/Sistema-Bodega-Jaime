import { useState, useEffect } from 'react'
import productoService from '../services/productoService'
import selectorService from '../services/selectorService'
import marcaService from '../services/marcaService'
import categoriaService from '../services/categoriaService'
import unidadDeMedidaService from '../services/unidadDeMedidaService'

function Producto() {
  const [productos, setProductos] = useState([])
  const [verActivos, setVerActivos] = useState(true)
  const [filtroNombre, setFiltroNombre] = useState('')
  const [filtroMarca, setFiltroMarca] = useState('')
  const [filtroCategoria, setFiltroCategoria] = useState('')
  const [mensaje, setMensaje] = useState(null)
  const [mensajeError, setMensajeError] = useState(false)

  const [marcas, setMarcas] = useState([])
  const [categorias, setCategorias] = useState([])
  const [unidades, setUnidades] = useState([])

  const [modalAbierto, setModalAbierto] = useState(false)
  const [editando, setEditando] = useState(null)
  const [form, setForm] = useState({
    idMarca: '',
    idCategoria: '',
    idUnidadDeMedida: '',
    nombre: '',
    stockActual: '',
    stockMinimo: '',
    precioVenta: ''
  })

  const [expandido, setExpandido] = useState({ marca: false, categoria: false, unidad: false })
  const [nuevaMarca, setNuevaMarca] = useState({ nombre: '', empresa: '' })
  const [nuevaCategoria, setNuevaCategoria] = useState({ nombre: '', descripcion: '' })
  const [nuevaUnidad, setNuevaUnidad] = useState({ nombre: '', abreviacion: '', descripcion: '' })
  const [mensajeExpandido, setMensajeExpandido] = useState({ marca: null, categoria: null, unidad: null })

  const inputLine = 'w-full bg-transparent border-0 border-b border-slate-400 px-0 py-2 text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:border-slate-700'
  const selectClass = 'border border-slate-300 rounded-md px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500'

  const cargar = async () => {
    try {
      const res = verActivos
        ? await productoService.buscarActivos(filtroNombre || null, filtroMarca || null, filtroCategoria || null)
        : await productoService.buscarInactivos(filtroNombre || null, filtroMarca || null, filtroCategoria || null)
      setProductos(res.data)
    } catch {
      setMensaje('Error al cargar productos')
      setMensajeError(true)
    }
  }

  const cargarSelectores = async () => {
    try {
      const [rm, rc, ru] = await Promise.all([
        selectorService.marcas(),
        selectorService.categorias(),
        selectorService.unidades(),
      ])
      setMarcas(rm.data)
      setCategorias(rc.data)
      setUnidades(ru.data)
    } catch {
      setMensaje('Error al cargar selectores')
      setMensajeError(true)
    }
  }

  useEffect(() => { cargar() }, [verActivos])

  const limpiarFormulario = () => {
    setForm({
      idMarca: '',
      idCategoria: '',
      idUnidadDeMedida: '',
      nombre: '',
      stockActual: '',
      stockMinimo: '',
      precioVenta: ''
    })
    setExpandido({ marca: false, categoria: false, unidad: false })
    setNuevaMarca({ nombre: '', empresa: '' })
    setNuevaCategoria({ nombre: '', descripcion: '' })
    setNuevaUnidad({ nombre: '', abreviacion: '', descripcion: '' })
    setMensajeExpandido({ marca: null, categoria: null, unidad: null })
  }

  const abrirCrear = async () => {
    await cargarSelectores()
    setEditando(null)
    limpiarFormulario()
    setMensaje(null)
    setModalAbierto(true)
  }

  const abrirEditar = async (producto) => {
    await cargarSelectores()
    setEditando(producto)
    setForm({
      idMarca: '',
      idCategoria: '',
      idUnidadDeMedida: '',
      nombre: producto.nombre,
      stockActual: '',
      stockMinimo: '',
      precioVenta: producto.precio
    })
    setExpandido({ marca: false, categoria: false, unidad: false })
    setMensajeExpandido({ marca: null, categoria: null, unidad: null })
    setMensaje(null)
    setModalAbierto(true)
  }

  const guardarNuevaMarca = async () => {
    try {
      const res = await marcaService.crear(nuevaMarca)
      if (res.data.mensaje.startsWith('OK')) {
        await cargarSelectores()
        const todasMarcas = await marcaService.buscarActivas()
        const creada = todasMarcas.data.find(m => m[1].toLowerCase() === nuevaMarca.nombre.toLowerCase())
        if (creada) setForm(prev => ({ ...prev, idMarca: creada[0] }))
        setNuevaMarca({ nombre: '', empresa: '' })
        setExpandido(prev => ({ ...prev, marca: false }))
        setMensajeExpandido(prev => ({ ...prev, marca: null }))
      } else {
        setMensajeExpandido(prev => ({ ...prev, marca: res.data.mensaje }))
      }
    } catch (error) {
      setMensajeExpandido(prev => ({ ...prev, marca: error.response?.data?.mensaje || 'Error al guardar' }))
    }
  }

  const guardarNuevaCategoria = async () => {
    try {
      const res = await categoriaService.crear(nuevaCategoria)
      if (res.data.mensaje.startsWith('OK')) {
        await cargarSelectores()
        const todas = await categoriaService.buscarActivas()
        const creada = todas.data.find(c => c[1].toLowerCase() === nuevaCategoria.nombre.toLowerCase())
        if (creada) setForm(prev => ({ ...prev, idCategoria: creada[0] }))
        setNuevaCategoria({ nombre: '', descripcion: '' })
        setExpandido(prev => ({ ...prev, categoria: false }))
        setMensajeExpandido(prev => ({ ...prev, categoria: null }))
      } else {
        setMensajeExpandido(prev => ({ ...prev, categoria: res.data.mensaje }))
      }
    } catch (error) {
      setMensajeExpandido(prev => ({ ...prev, categoria: error.response?.data?.mensaje || 'Error al guardar' }))
    }
  }

  const guardarNuevaUnidad = async () => {
    try {
      const res = await unidadDeMedidaService.crear(nuevaUnidad)
      if (res.data.mensaje.startsWith('OK')) {
        await cargarSelectores()
        const todas = await unidadDeMedidaService.buscarActivas()
        const creada = todas.data.find(u => u[1].toLowerCase() === nuevaUnidad.nombre.toLowerCase())
        if (creada) setForm(prev => ({ ...prev, idUnidadDeMedida: creada[0] }))
        setNuevaUnidad({ nombre: '', abreviacion: '', descripcion: '' })
        setExpandido(prev => ({ ...prev, unidad: false }))
        setMensajeExpandido(prev => ({ ...prev, unidad: null }))
      } else {
        setMensajeExpandido(prev => ({ ...prev, unidad: res.data.mensaje }))
      }
    } catch (error) {
      setMensajeExpandido(prev => ({ ...prev, unidad: error.response?.data?.mensaje || 'Error al guardar' }))
    }
  }

  const guardar = async () => {
    try {
      const datosProducto = editando
        ? {
            idMarca: form.idMarca || null,
            idCategoria: form.idCategoria || null,
            idUnidadDeMedida: form.idUnidadDeMedida || null,
            nombre: form.nombre,
            precioVenta: form.precioVenta
          }
        : {
            idMarca: form.idMarca,
            idCategoria: form.idCategoria,
            idUnidadDeMedida: form.idUnidadDeMedida,
            nombre: form.nombre,
            stockActual: form.stockActual,
            stockMinimo: form.stockMinimo,
            precioVenta: form.precioVenta
          }

      const res = editando
        ? await productoService.editar(editando.codigo, datosProducto)
        : await productoService.crear(datosProducto)

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
      const res = await productoService.cambiarEstado(id, nuevoEstado)
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
    setFiltroMarca('')
    setFiltroCategoria('')
  }

  const productosFiltrados = productos
  const totalStock = productosFiltrados.reduce((total, p) => total + Number(p.stockActual || 0), 0)
  const stockBajo = productosFiltrados.filter(p => Number(p.stockActual || 0) <= Number(p.stockMinimo || 0)).length
  const valorInventario = productosFiltrados.reduce((total, p) => total + (Number(p.stockActual || 0) * Number(p.precio || 0)), 0)

  const stockBadge = (producto) => {
    const stock = Number(producto.stockActual || 0)
    const minimo = Number(producto.stockMinimo || 0)
    if (stock <= 0) return 'bg-red-50 text-red-700 border-red-100'
    if (stock <= minimo) return 'bg-yellow-50 text-yellow-700 border-yellow-100'
    return 'bg-green-50 text-green-700 border-green-100'
  }

  return (
    <div className="-m-6 min-h-screen bg-[#eaf2fb] p-8 text-slate-900">
      <div className="flex flex-col lg:flex-row lg:items-start lg:justify-between gap-5 mb-7">
        <div>
          <h1 className="text-4xl font-bold tracking-tight border-l-2 border-slate-800 pl-2">Productos</h1>
          <p className="text-sm text-slate-500 mt-2">Gestion de inventario y precios de venta</p>
        </div>

        <div className="flex flex-col items-stretch sm:items-end gap-3">
          <button
            onClick={abrirCrear}
            className="bg-yellow-400 border-4 border-yellow-500 text-slate-950 px-6 py-2 rounded-xl font-bold hover:bg-yellow-300 flex items-center justify-center gap-3"
          >
            <span className="text-2xl leading-none">+</span>
            nuevo
          </button>
          <div className="relative">
            <input
              placeholder="...buscar"
              value={filtroNombre}
              onChange={e => setFiltroNombre(e.target.value)}
              onKeyDown={e => { if (e.key === 'Enter') cargar() }}
              className="w-full sm:w-80 border border-slate-300 rounded-lg bg-transparent px-4 py-4 text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500"
            />
          </div>
        </div>
      </div>

      {mensaje && !modalAbierto && (
        <div className={`mb-5 border-l-4 p-3 rounded text-sm flex justify-between items-center shadow-sm ${mensajeError ? 'bg-red-50 text-red-800 border-red-500' : 'bg-green-50 text-green-800 border-green-500'}`}>
          <span>{mensaje}</span>
          <button onClick={() => setMensaje(null)} className="ml-4 text-base leading-none hover:opacity-70">x</button>
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <div className="bg-white/80 rounded-2xl p-4 shadow-sm">
          <p className="text-xs text-slate-500">Productos listados</p>
          <p className="text-2xl font-bold">{productosFiltrados.length}</p>
        </div>
        <div className="bg-white/80 rounded-2xl p-4 shadow-sm">
          <p className="text-xs text-slate-500">Stock total</p>
          <p className="text-2xl font-bold">{totalStock}</p>
        </div>
        <div className="bg-white/80 rounded-2xl p-4 shadow-sm">
          <p className="text-xs text-slate-500">Valor inventario</p>
          <p className="text-2xl font-bold">S/ {valorInventario.toFixed(2)}</p>
          <p className="text-xs text-red-500 mt-1">{stockBajo} con stock bajo</p>
        </div>
      </div>

      <div className="flex flex-wrap gap-3 mb-7">
        <input
          placeholder="Buscar por marca"
          value={filtroMarca}
          onChange={e => setFiltroMarca(e.target.value)}
          className="border border-slate-300 rounded-lg bg-transparent px-4 py-3 text-sm flex-1 min-w-40 focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500"
        />
        <input
          placeholder="Buscar por categoria"
          value={filtroCategoria}
          onChange={e => setFiltroCategoria(e.target.value)}
          className="border border-slate-300 rounded-lg bg-transparent px-4 py-3 text-sm flex-1 min-w-40 focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500"
        />
        <button onClick={cargar} className="bg-slate-800 text-white px-5 py-3 rounded-lg text-sm font-semibold hover:bg-slate-700">
          Buscar
        </button>
        <button onClick={limpiarFiltros} className="bg-white/80 text-slate-700 px-5 py-3 rounded-lg text-sm font-semibold hover:bg-white">
          Limpiar
        </button>
        <button onClick={() => setVerActivos(!verActivos)} className="bg-white/80 text-slate-700 px-5 py-3 rounded-lg text-sm font-semibold hover:bg-white">
          Ver {verActivos ? 'inactivos' : 'activos'}
        </button>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full min-w-[980px] text-sm">
          <thead className="text-slate-800 border-b border-slate-400">
            <tr>
              <th className="py-4 px-3 text-left font-bold">Descripcion</th>
              <th className="py-4 px-3 text-left font-bold">Marca</th>
              <th className="py-4 px-3 text-left font-bold">Categoria</th>
              <th className="py-4 px-3 text-left font-bold">P. venta</th>
              <th className="py-4 px-3 text-left font-bold">Se vende por</th>
              <th className="py-4 px-3 text-left font-bold">Inventarios</th>
              <th className="py-4 px-3 text-left font-bold">Acciones</th>
            </tr>
          </thead>
          <tbody>
            {productosFiltrados.length === 0 ? (
              <tr>
                <td colSpan={7} className="py-12 text-center text-slate-400">Sin resultados</td>
              </tr>
            ) : (
              productosFiltrados.map((p) => (
                <tr key={p.codigo} className="border-b border-slate-200 hover:bg-white/45">
                  <td className="py-8 px-3 font-medium">{p.nombre}</td>
                  <td className="py-8 px-3">{p.marca}</td>
                  <td className="py-8 px-3">{p.categoria}</td>
                  <td className="py-8 px-3">S/ {Number(p.precio || 0).toFixed(2)}</td>
                  <td className="py-8 px-3">{p.unidadMedida}</td>
                  <td className="py-8 px-3">
                    <span className={`inline-flex min-w-12 justify-center border px-3 py-2 rounded-lg text-xs font-bold ${stockBadge(p)}`}>
                      {p.stockActual}
                    </span>
                    <span className="ml-2 text-xs text-slate-500">min. {p.stockMinimo}</span>
                  </td>
                  <td className="py-8 px-3">
                    <div className="flex flex-wrap gap-2">
                      <button onClick={() => abrirEditar(p)} className="bg-yellow-400 border-2 border-yellow-500 text-slate-950 px-4 py-1.5 rounded-lg text-xs font-bold hover:bg-yellow-300">
                        Editar
                      </button>
                      <button
                        onClick={() => cambiarEstado(p.codigo, verActivos ? 0 : 1)}
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
          <div className="bg-[#eaf2fb] rounded-md shadow-2xl w-full max-w-4xl min-h-[620px] max-h-[92vh] overflow-y-auto relative p-9">
            <button
              onClick={() => setModalAbierto(false)}
              className="absolute right-8 top-6 text-5xl leading-none text-slate-700 hover:text-slate-950"
            >
              x
            </button>

            <h2 className="text-3xl font-bold uppercase mb-9">
              {editando ? 'Editar producto' : 'Registrar nuevo producto'}
            </h2>

            <div className="grid grid-cols-1 lg:grid-cols-2 gap-10">
              <div className="space-y-5">
                <div>
                  <label className="text-slate-400 text-lg">nombre</label>
                  <input
                    value={form.nombre}
                    onChange={e => setForm({ ...form, nombre: e.target.value })}
                    className={inputLine}
                    placeholder="Nombre del producto"
                  />
                </div>

                <div>
                  <label className="text-slate-400 text-lg">precio venta</label>
                  <input
                    type="number"
                    min="0.01"
                    step="0.01"
                    value={form.precioVenta}
                    onChange={e => setForm({ ...form, precioVenta: e.target.value })}
                    className={inputLine}
                    placeholder="0.00"
                  />
                </div>

                <div>
                  <label className="text-slate-400 text-lg">marca</label>
                  <div className="flex gap-3">
                    <select
                      value={form.idMarca}
                      onChange={e => setForm({ ...form, idMarca: e.target.value })}
                      className={`${selectClass} flex-1`}
                    >
                      <option value="">-- Selecciona marca --</option>
                      {marcas.map(m => (
                        <option key={m[0]} value={m[0]}>{m[1]}</option>
                      ))}
                    </select>
                    <button
                      onClick={() => setExpandido(prev => ({ ...prev, marca: !prev.marca }))}
                      className="px-4 rounded-md border border-slate-300 bg-white text-sm font-semibold hover:bg-slate-50"
                    >
                      {expandido.marca ? 'x' : '+'}
                    </button>
                  </div>
                </div>

                {expandido.marca && (
                  <div className="border border-yellow-400 rounded-xl p-4 space-y-3 bg-white/50">
                    <input
                      placeholder="Nombre de la marca"
                      value={nuevaMarca.nombre}
                      onChange={e => setNuevaMarca({ ...nuevaMarca, nombre: e.target.value })}
                      className={inputLine}
                    />
                    <input
                      placeholder="Empresa"
                      value={nuevaMarca.empresa}
                      onChange={e => setNuevaMarca({ ...nuevaMarca, empresa: e.target.value })}
                      className={inputLine}
                    />
                    <button onClick={guardarNuevaMarca} className="bg-yellow-400 border-2 border-yellow-500 px-5 py-2 rounded-lg text-sm font-bold">
                      Guardar marca
                    </button>
                    {mensajeExpandido.marca && <p className="text-xs text-red-700">{mensajeExpandido.marca}</p>}
                  </div>
                )}

                {!editando && (
                  <button
                    onClick={guardar}
                    className="mt-8 bg-yellow-400 border-4 border-yellow-500 text-slate-950 px-10 py-3 rounded-xl font-bold hover:bg-yellow-300 w-full sm:w-80"
                  >
                    Guardar
                  </button>
                )}
              </div>

              <div className="space-y-6">
                <div>
                  <p className="text-slate-700 mb-3">Se vende por:</p>
                  <select
                    value={form.idUnidadDeMedida}
                    onChange={e => setForm({ ...form, idUnidadDeMedida: e.target.value })}
                    className={selectClass}
                  >
                    <option value="">-- Selecciona unidad --</option>
                    {unidades.map(u => (
                      <option key={u[0]} value={u[0]}>{u[1]}</option>
                    ))}
                  </select>
                  <button
                    onClick={() => setExpandido(prev => ({ ...prev, unidad: !prev.unidad }))}
                    className="ml-3 px-4 py-2 rounded-md border border-slate-300 bg-white text-sm font-semibold hover:bg-slate-50"
                  >
                    {expandido.unidad ? 'x' : '+ Nueva'}
                  </button>
                </div>

                {expandido.unidad && (
                  <div className="border border-yellow-400 rounded-xl p-4 space-y-3 bg-white/50">
                    <input
                      placeholder="Nombre de la unidad"
                      value={nuevaUnidad.nombre}
                      onChange={e => setNuevaUnidad({ ...nuevaUnidad, nombre: e.target.value })}
                      className={inputLine}
                    />
                    <input
                      placeholder="Abreviacion"
                      value={nuevaUnidad.abreviacion}
                      onChange={e => setNuevaUnidad({ ...nuevaUnidad, abreviacion: e.target.value })}
                      className={inputLine}
                    />
                    <input
                      placeholder="Descripcion"
                      value={nuevaUnidad.descripcion}
                      onChange={e => setNuevaUnidad({ ...nuevaUnidad, descripcion: e.target.value })}
                      className={inputLine}
                    />
                    <button onClick={guardarNuevaUnidad} className="bg-yellow-400 border-2 border-yellow-500 px-5 py-2 rounded-lg text-sm font-bold">
                      Guardar unidad
                    </button>
                    {mensajeExpandido.unidad && <p className="text-xs text-red-700">{mensajeExpandido.unidad}</p>}
                  </div>
                )}

                <div>
                  <label className="text-slate-700 mr-4">Categoria:</label>
                  <select
                    value={form.idCategoria}
                    onChange={e => setForm({ ...form, idCategoria: e.target.value })}
                    className={selectClass}
                  >
                    <option value="">-- Selecciona categoria --</option>
                    {categorias.map(c => (
                      <option key={c[0]} value={c[0]}>{c[1]}</option>
                    ))}
                  </select>
                  <button
                    onClick={() => setExpandido(prev => ({ ...prev, categoria: !prev.categoria }))}
                    className="ml-3 px-4 py-2 rounded-md border border-slate-300 bg-white text-sm font-semibold hover:bg-slate-50"
                  >
                    {expandido.categoria ? 'x' : '+ Nueva'}
                  </button>
                </div>

                {expandido.categoria && (
                  <div className="border border-yellow-400 rounded-xl p-4 space-y-3 bg-white/50">
                    <input
                      placeholder="Nombre de la categoria"
                      value={nuevaCategoria.nombre}
                      onChange={e => setNuevaCategoria({ ...nuevaCategoria, nombre: e.target.value })}
                      className={inputLine}
                    />
                    <input
                      placeholder="Descripcion"
                      value={nuevaCategoria.descripcion}
                      onChange={e => setNuevaCategoria({ ...nuevaCategoria, descripcion: e.target.value })}
                      className={inputLine}
                    />
                    <button onClick={guardarNuevaCategoria} className="bg-yellow-400 border-2 border-yellow-500 px-5 py-2 rounded-lg text-sm font-bold">
                      Guardar categoria
                    </button>
                    {mensajeExpandido.categoria && <p className="text-xs text-red-700">{mensajeExpandido.categoria}</p>}
                  </div>
                )}

                {!editando && (
                  <div className="border border-orange-400 rounded-2xl p-4 space-y-4">
                    <p className="font-medium text-slate-700">Controlar stock</p>
                    <div>
                      <label className="text-slate-400 text-lg">stock</label>
                      <input
                        type="number"
                        min="0"
                        value={form.stockActual}
                        onChange={e => setForm({ ...form, stockActual: e.target.value })}
                        className={inputLine}
                      />
                    </div>
                    <div>
                      <label className="text-slate-400 text-lg">stock minimo</label>
                      <input
                        type="number"
                        min="0"
                        value={form.stockMinimo}
                        onChange={e => setForm({ ...form, stockMinimo: e.target.value })}
                        className={inputLine}
                      />
                    </div>
                  </div>
                )}

                {editando && (
                  <button
                    onClick={guardar}
                    className="mt-8 bg-yellow-400 border-4 border-yellow-500 text-slate-950 px-10 py-3 rounded-xl font-bold hover:bg-yellow-300 w-full sm:w-80"
                  >
                    Guardar
                  </button>
                )}
              </div>
            </div>

            {mensaje && (
              <div className={`mt-6 p-3 rounded text-sm ${mensajeError ? 'bg-red-50 text-red-800' : 'bg-green-50 text-green-800'}`}>
                {mensaje}
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  )
}

export default Producto

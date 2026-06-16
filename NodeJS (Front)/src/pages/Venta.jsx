/* eslint-disable react-hooks/set-state-in-effect, react-hooks/exhaustive-deps */
import { useState, useEffect } from 'react'
import ventaService from '../services/ventaService'
import usuarioService from '../services/usuarioService'

function Venta() {
  const [usuarios, setUsuarios] = useState([])
  const [productos, setProductos] = useState([])
  const [detalles, setDetalles] = useState([])
  const [cantidades, setCantidades] = useState({})

  const [idUsuario, setIdUsuario] = useState('')
  const [filtroNombre, setFiltroNombre] = useState('')
  const [filtroMarca, setFiltroMarca] = useState('')
  const [filtroCategoria, setFiltroCategoria] = useState('')
  const [filtroUnidad, setFiltroUnidad] = useState('')

  const [mensaje, setMensaje] = useState(null)
  const [mensajeError, setMensajeError] = useState(false)
  const [confirmacionAbierta, setConfirmacionAbierta] = useState(false)

  const inputClass = 'border border-slate-300 rounded-lg bg-transparent px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500'
  const buttonPrimary = 'bg-yellow-400 border-4 border-yellow-500 text-slate-950 px-5 py-3 rounded-xl text-sm font-bold hover:bg-yellow-300 disabled:opacity-50 disabled:cursor-not-allowed'
  const buttonSecondary = 'bg-white/80 text-slate-700 px-5 py-3 rounded-lg text-sm font-semibold hover:bg-white'
  const buttonDanger = 'bg-red-50 text-red-700 border border-red-100 px-3 py-1.5 rounded-lg text-xs font-bold hover:bg-red-100'

  const cargarUsuarios = async () => {
    try {
      const res = await usuarioService.buscarActivos()
      setUsuarios(res.data)
    } catch {
      setMensaje('Error al cargar usuarios')
      setMensajeError(true)
    }
  }

  const cargarProductos = async () => {
    try {
      const res = await ventaService.buscarProductosDisponibles(
        filtroNombre || null,
        filtroMarca || null,
        filtroCategoria || null,
        filtroUnidad || null
      )
      setProductos(res.data)
    } catch {
      setMensaje('Error al cargar productos disponibles')
      setMensajeError(true)
    }
  }

  useEffect(() => {
    cargarUsuarios()
    cargarProductos()
  }, [])

  const cambiarCantidad = (idProducto, valor) => {
    setCantidades({ ...cantidades, [idProducto]: valor })
  }

  const stockClass = (stock) => {
    if (stock <= 0) return 'bg-red-50 text-red-700 border-red-100'
    if (stock <= 3) return 'bg-yellow-50 text-yellow-700 border-yellow-100'
    return 'bg-green-50 text-green-700 border-green-100'
  }

  const agregarDetalle = (producto) => {
    const cantidad = Number(cantidades[producto.codigo] || 1)

    if (cantidad <= 0) {
      setMensaje('La cantidad debe ser mayor que cero.')
      setMensajeError(true)
      return
    }

    if (cantidad > producto.stockDisponible) {
      setMensaje('La cantidad no puede superar el stock disponible.')
      setMensajeError(true)
      return
    }

    const existente = detalles.find(d => d.idProducto === producto.codigo)

    if (existente) {
      const nuevaCantidad = existente.cantidad + cantidad
      if (nuevaCantidad > producto.stockDisponible) {
        setMensaje('La cantidad total no puede superar el stock disponible.')
        setMensajeError(true)
        return
      }

      setDetalles(detalles.map(d =>
        d.idProducto === producto.codigo
          ? { ...d, cantidad: nuevaCantidad, subtotal: nuevaCantidad * Number(producto.precio) }
          : d
      ))
    } else {
      setDetalles([
        ...detalles,
        {
          idProducto: producto.codigo,
          nombre: producto.nombre,
          marca: producto.marca,
          unidad: producto.unidad,
          precio: Number(producto.precio),
          stockDisponible: producto.stockDisponible,
          cantidad,
          subtotal: cantidad * Number(producto.precio)
        }
      ])
    }

    setMensaje('Producto agregado al carrito.')
    setMensajeError(false)
  }

  const quitarDetalle = (idProducto) => {
    setDetalles(detalles.filter(d => d.idProducto !== idProducto))
  }

  const disminuirDetalle = (idProducto) => {
    setDetalles(detalles.map(d => {
      if (d.idProducto !== idProducto) return d
      const nuevaCantidad = Math.max(1, d.cantidad - 1)
      return { ...d, cantidad: nuevaCantidad, subtotal: nuevaCantidad * d.precio }
    }))
  }

  const aumentarDetalle = (idProducto) => {
    const detalle = detalles.find(d => d.idProducto === idProducto)
    if (!detalle) return

    if (detalle.cantidad >= detalle.stockDisponible) {
      setMensaje('La cantidad no puede superar el stock disponible.')
      setMensajeError(true)
      return
    }

    setDetalles(detalles.map(d => {
      if (d.idProducto !== idProducto) return d
      const nuevaCantidad = d.cantidad + 1
      return { ...d, cantidad: nuevaCantidad, subtotal: nuevaCantidad * d.precio }
    }))
  }

  const totalVenta = detalles.reduce((total, d) => total + d.subtotal, 0)
  const totalProductos = detalles.reduce((total, d) => total + d.cantidad, 0)
  const productosStockBajo = productos.filter(p => Number(p.stockDisponible || 0) <= 3).length

  const validarVenta = () => {
    if (!idUsuario) {
      setMensaje('Selecciona un usuario responsable para registrar la venta.')
      setMensajeError(true)
      return false
    }

    if (detalles.length === 0) {
      setMensaje('Agrega al menos un producto al carrito antes de registrar.')
      setMensajeError(true)
      return false
    }

    return true
  }

  const abrirConfirmacionVenta = () => {
    if (!validarVenta()) return
    setMensaje(null)
    setConfirmacionAbierta(true)
  }

  const registrarVenta = async () => {
    if (!validarVenta()) return

    try {
      const res = await ventaService.registrar({
        idUsuario: Number(idUsuario),
        detalles: detalles.map(d => ({
          idProducto: d.idProducto,
          cantidad: d.cantidad
        }))
      })
      const exito = res.data.mensaje.startsWith('OK')
      setMensaje(exito ? 'Venta registrada correctamente.' : res.data.mensaje)
      setMensajeError(!exito)

      if (exito) {
        setDetalles([])
        setCantidades({})
        setConfirmacionAbierta(false)
        cargarProductos()
      }
    } catch (error) {
      setMensaje(error.response?.data?.mensaje || 'Error al registrar venta')
      setMensajeError(true)
      setConfirmacionAbierta(false)
    }
  }

  const limpiarFiltros = () => {
    setFiltroNombre('')
    setFiltroMarca('')
    setFiltroCategoria('')
    setFiltroUnidad('')
  }

  return (
    <div className="-m-6 min-h-screen bg-[#eaf2fb] p-8 text-slate-900">
      <div className="flex flex-col lg:flex-row lg:items-start lg:justify-between gap-5 mb-7">
        <div>
          <h1 className="text-4xl font-bold tracking-tight border-l-2 border-slate-800 pl-2">Registro de venta</h1>
          <p className="text-sm text-slate-500 mt-2">Caja de atencion con carrito visible</p>
        </div>

        <div className="bg-white/80 rounded-2xl p-4 shadow-sm min-w-60">
          <p className="text-xs text-slate-500">Total a cobrar</p>
          <p className="text-3xl font-bold">S/ {totalVenta.toFixed(2)}</p>
          <p className="text-xs text-slate-500 mt-1">{totalProductos} producto(s) en carrito</p>
        </div>
      </div>

      {mensaje && (
        <div className={`mb-5 border-l-4 p-3 rounded text-sm flex justify-between items-center shadow-sm ${mensajeError ? 'bg-red-50 text-red-800 border-red-500' : 'bg-green-50 text-green-800 border-green-500'}`}>
          <span>{mensaje}</span>
          <button onClick={() => setMensaje(null)} className="ml-4 text-base leading-none hover:opacity-70">x</button>
        </div>
      )}

      <div className="grid grid-cols-1 xl:grid-cols-[minmax(0,1fr)_420px] gap-6 items-start">
        <div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
            <div className="bg-white/80 rounded-2xl p-4 shadow-sm">
              <p className="text-xs text-slate-500">Productos disponibles</p>
              <p className="text-2xl font-bold">{productos.length}</p>
            </div>
            <div className="bg-white/80 rounded-2xl p-4 shadow-sm">
              <p className="text-xs text-slate-500">Productos con poco stock</p>
              <p className="text-2xl font-bold">{productosStockBajo}</p>
            </div>
          </div>

          <div className="flex flex-wrap gap-3 mb-7">
            <input
              placeholder="Producto"
              value={filtroNombre}
              onChange={e => setFiltroNombre(e.target.value)}
              className={`${inputClass} flex-1 min-w-40`}
            />
            <input
              placeholder="Marca"
              value={filtroMarca}
              onChange={e => setFiltroMarca(e.target.value)}
              className={`${inputClass} flex-1 min-w-40`}
            />
            <input
              placeholder="Categoria"
              value={filtroCategoria}
              onChange={e => setFiltroCategoria(e.target.value)}
              className={`${inputClass} flex-1 min-w-40`}
            />
            <input
              placeholder="Unidad"
              value={filtroUnidad}
              onChange={e => setFiltroUnidad(e.target.value)}
              className={`${inputClass} flex-1 min-w-40`}
            />
            <button onClick={cargarProductos} className="bg-slate-800 text-white px-5 py-3 rounded-lg text-sm font-semibold hover:bg-slate-700">
              Buscar
            </button>
            <button onClick={limpiarFiltros} className={buttonSecondary}>
              Limpiar
            </button>
          </div>

          <div className="overflow-x-auto">
            <div className="min-w-[540px] text-sm">
              <div className="grid grid-cols-[minmax(0,1fr)_64px_76px_82px_92px] gap-3 border-b border-slate-400 px-3 py-4 font-bold text-slate-800">
                <span>Producto</span>
                <span>Stock</span>
                <span>Precio</span>
                <span>Cant.</span>
                <span>Accion</span>
              </div>

              {productos.length === 0 ? (
                <div className="py-12 text-center text-slate-400">Sin productos disponibles</div>
              ) : (
                productos.map(p => (
                  <div key={p.codigo} className="grid grid-cols-[minmax(0,1fr)_64px_76px_82px_92px] gap-3 items-center border-b border-slate-200 px-3 py-6 hover:bg-white/45">
                    <div className="min-w-0">
                      <p className="font-medium truncate">{p.nombre}</p>
                      <p className="text-xs text-slate-500 mt-1 truncate">{p.marca} - {p.unidad}</p>
                    </div>
                    <span className={`inline-flex justify-center border px-2 py-2 rounded-lg text-xs font-bold ${stockClass(Number(p.stockDisponible))}`}>
                      {p.stockDisponible}
                    </span>
                    <span className="font-semibold">S/ {Number(p.precio).toFixed(2)}</span>
                    <input
                      type="number"
                      min="1"
                      max={p.stockDisponible}
                      value={cantidades[p.codigo] || 1}
                      onChange={e => cambiarCantidad(p.codigo, e.target.value)}
                      className={`${inputClass} w-full py-2 px-3`}
                    />
                    <button
                      onClick={() => agregarDetalle(p)}
                      className="bg-yellow-400 border-2 border-yellow-500 text-slate-950 px-3 py-2 rounded-lg text-xs font-bold hover:bg-yellow-300"
                    >
                      Agregar
                    </button>
                  </div>
                ))
              )}
            </div>
          </div>
        </div>

        <aside className="bg-white/80 rounded-2xl shadow-sm xl:sticky xl:top-6 overflow-hidden">
          <div className="px-5 py-4 border-b border-slate-100">
            <div className="flex justify-between items-start gap-3">
              <div>
                <h2 className="text-xl font-bold">Carrito de compras</h2>
                <p className="text-xs text-slate-500">{totalProductos} producto(s) por cobrar</p>
              </div>
              <span className="bg-slate-100 text-slate-700 px-3 py-1 rounded-lg text-xs font-bold">
                {detalles.length} item(s)
              </span>
            </div>
          </div>

          <div className="p-5">
            <div className="flex flex-col gap-1 mb-4">
              <label className="text-xs font-bold text-slate-500">Usuario responsable</label>
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

            <div className="max-h-[52vh] overflow-y-auto rounded-xl bg-[#eaf2fb]">
              {detalles.length === 0 ? (
                <div className="p-8 text-center text-sm text-slate-400">Sin productos agregados</div>
              ) : (
                detalles.map(d => (
                  <div key={d.idProducto} className="bg-white border-b border-slate-100 last:border-b-0 p-4">
                    <div className="flex justify-between gap-3">
                      <div>
                        <p className="text-sm font-bold text-slate-900">{d.nombre}</p>
                        <p className="text-xs text-slate-500">{d.marca} - {d.unidad}</p>
                        <p className={`text-xs mt-1 ${d.stockDisponible - d.cantidad <= 3 ? 'text-yellow-700' : 'text-slate-500'}`}>
                          Stock restante: {d.stockDisponible - d.cantidad}
                        </p>
                      </div>
                      <button onClick={() => quitarDetalle(d.idProducto)} className={`${buttonDanger} h-fit`}>
                        Quitar
                      </button>
                    </div>

                    <div className="flex justify-between items-center mt-4">
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => disminuirDetalle(d.idProducto)}
                          disabled={d.cantidad <= 1}
                          className={`w-9 h-9 rounded-lg text-sm font-bold ${d.cantidad <= 1 ? 'bg-slate-100 text-slate-400 cursor-not-allowed' : 'bg-slate-200 text-slate-700 hover:bg-slate-300'}`}
                        >
                          -
                        </button>
                        <span className="min-w-10 text-center text-sm font-bold text-slate-900">{d.cantidad}</span>
                        <button
                          onClick={() => aumentarDetalle(d.idProducto)}
                          disabled={d.cantidad >= d.stockDisponible}
                          className={`w-9 h-9 rounded-lg text-sm font-bold ${d.cantidad >= d.stockDisponible ? 'bg-slate-100 text-slate-400 cursor-not-allowed' : 'bg-slate-200 text-slate-700 hover:bg-slate-300'}`}
                        >
                          +
                        </button>
                      </div>

                      <div className="text-right">
                        <p className="text-xs text-slate-500">S/ {d.precio.toFixed(2)} c/u</p>
                        <p className="text-sm font-bold text-slate-900">S/ {d.subtotal.toFixed(2)}</p>
                      </div>
                    </div>
                  </div>
                ))
              )}
            </div>

            <div className="border-t border-slate-100 mt-5 pt-5">
              <div className="bg-white border border-slate-200 rounded-xl p-4 mb-4">
                <div className="flex justify-between items-center">
                  <span className="text-sm text-slate-500">Total</span>
                  <span className="text-3xl font-bold text-slate-900">S/ {totalVenta.toFixed(2)}</span>
                </div>
                <p className="text-xs text-slate-500 mt-1">{totalProductos} producto(s) por cobrar</p>
              </div>
              <button onClick={abrirConfirmacionVenta} className={`${buttonPrimary} w-full`}>
                Registrar venta
              </button>
            </div>
          </div>
        </aside>
      </div>

      {confirmacionAbierta && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-[#eaf2fb] rounded-md shadow-2xl w-full max-w-md overflow-hidden">
            <div className="px-6 py-5 border-b border-slate-200">
              <h2 className="text-2xl font-bold uppercase">Confirmar venta</h2>
              <p className="text-sm text-slate-500">Revisa el total antes de registrar.</p>
            </div>

            <div className="p-6">
              <div className="bg-white/80 rounded-xl mb-4 max-h-52 overflow-y-auto">
                {detalles.map(d => (
                  <div key={d.idProducto} className="flex justify-between gap-3 p-3 border-b border-slate-100 last:border-b-0 text-sm">
                    <div>
                      <p className="font-bold text-slate-900">{d.nombre}</p>
                      <p className="text-xs text-slate-500">Cantidad: {d.cantidad}</p>
                    </div>
                    <p className="font-bold text-slate-900">S/ {d.subtotal.toFixed(2)}</p>
                  </div>
                ))}
              </div>

              <div className="flex justify-between items-center bg-white border border-slate-200 rounded-xl p-4 mb-5">
                <span className="text-sm text-slate-500">Total a cobrar</span>
                <span className="text-2xl font-bold text-slate-900">S/ {totalVenta.toFixed(2)}</span>
              </div>

              <div className="flex justify-end gap-3">
                <button onClick={() => setConfirmacionAbierta(false)} className={buttonSecondary}>
                  Cancelar
                </button>
                <button onClick={registrarVenta} className={buttonPrimary}>
                  Confirmar venta
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default Venta

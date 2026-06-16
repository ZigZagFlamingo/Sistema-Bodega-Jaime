/* eslint-disable react-hooks/set-state-in-effect, react-hooks/exhaustive-deps */
import { useEffect, useMemo, useState } from 'react'
import ventaService from '../services/ventaService'
import productoService from '../services/productoService'

function Inicio() {
  const [historial, setHistorial] = useState([])
  const [productos, setProductos] = useState([])
  const [filtro, setFiltro] = useState('todo')
  const [mensaje, setMensaje] = useState(null)

  const cargarDatos = async () => {
    try {
      const [ventasRes, productosRes] = await Promise.all([
        ventaService.buscarHistorial(),
        productoService.buscarActivos()
      ])
      setHistorial(ventasRes.data)
      setProductos(productosRes.data)
    } catch {
      setMensaje('No se pudieron cargar los datos del dashboard')
    }
  }

  useEffect(() => {
    cargarDatos()
  }, [])

  const parseFecha = (valor) => {
    if (!valor) return null
    const normalizada = String(valor).replace(' ', 'T')
    const fecha = new Date(normalizada)
    return Number.isNaN(fecha.getTime()) ? null : fecha
  }

  const fechaDia = (valor) => {
    if (!valor) return 'Sin fecha'
    return String(valor).split('T')[0].split(' ')[0]
  }

  const historialFiltrado = useMemo(() => {
    if (filtro === 'todo' || filtro === 'dia') return historial

    const hoy = new Date()
    hoy.setHours(0, 0, 0, 0)

    return historial.filter(venta => {
      const fecha = parseFecha(venta.fecha)
      if (!fecha) return false
      const fechaBase = new Date(fecha)
      fechaBase.setHours(0, 0, 0, 0)

      if (filtro === 'hoy') {
        return fechaBase.getTime() === hoy.getTime()
      }

      const limite = new Date(hoy)
      if (filtro === '7') limite.setDate(limite.getDate() - 6)
      if (filtro === '30') limite.setDate(limite.getDate() - 29)
      if (filtro === '12') limite.setMonth(limite.getMonth() - 12)

      return fechaBase >= limite
    })
  }, [historial, filtro])

  const ventasActivas = historialFiltrado.filter(v => Number(v.estado) === 1)
  const ventasAnuladas = historialFiltrado.filter(v => Number(v.estado) === 0)
  const totalVentas = historialFiltrado.length
  const ingresos = ventasActivas.reduce((total, venta) => total + Number(venta.total || 0), 0)
  const stockDisponible = productos.reduce((total, producto) => total + Number(producto.stockActual || 0), 0)
  const stockBajo = productos.filter(producto => Number(producto.stockActual || 0) <= Number(producto.stockMinimo || 0))
  const valorInventario = productos.reduce(
    (total, producto) => total + (Number(producto.stockActual || 0) * Number(producto.precio || 0)),
    0
  )

  const ventasPorDia = historialFiltrado.reduce((acc, venta) => {
    const dia = fechaDia(venta.fecha)
    acc[dia] = (acc[dia] || 0) + Number(venta.total || 0)
    return acc
  }, {})

  const diasVentas = Object.entries(ventasPorDia).sort(([a], [b]) => a.localeCompare(b))
  const maxVentaDia = Math.max(1, ...diasVentas.map(([, total]) => total))

  const topStockBajo = [...productos]
    .sort((a, b) => Number(a.stockActual || 0) - Number(b.stockActual || 0))
    .slice(0, 5)

  const topValorInventario = [...productos]
    .map(producto => ({
      ...producto,
      valor: Number(producto.stockActual || 0) * Number(producto.precio || 0)
    }))
    .sort((a, b) => b.valor - a.valor)
    .slice(0, 10)

  const movimientosCaja = [...historialFiltrado]
    .sort((a, b) => (parseFecha(b.fecha)?.getTime() || 0) - (parseFecha(a.fecha)?.getTime() || 0))
    .slice(0, 5)

  const filtros = [
    { id: 'todo', label: 'Todo' },
    { id: '7', label: 'Ultimos 7 dias' },
    { id: '30', label: 'Ultimos 30 dias' },
    { id: '12', label: 'Ultimos 12 meses' },
    { id: 'hoy', label: 'Hoy' },
    { id: 'dia', label: 'Por Dia' }
  ]

  const cardClass = 'bg-white rounded-2xl p-5 shadow-sm'
  const labelClass = 'text-sm text-slate-600'
  const valueClass = 'text-3xl font-bold text-slate-900 mt-5'

  return (
    <div className="-m-6 min-h-screen bg-[#eaf2fb] p-8 text-slate-900">
      <div className="flex flex-col xl:flex-row xl:items-center xl:justify-between gap-5 mb-6">
        <h1 className="text-5xl font-bold tracking-tight">Dashboard</h1>

        <div className="bg-white rounded-xl p-3 shadow-sm flex flex-wrap gap-2">
          {filtros.map(item => (
            <button
              key={item.id}
              onClick={() => setFiltro(item.id)}
              className={`px-4 py-2 rounded-lg text-sm ${filtro === item.id ? 'bg-slate-200 font-semibold' : 'hover:bg-slate-100'}`}
            >
              {item.label}
            </button>
          ))}
          <button
            onClick={() => setFiltro('todo')}
            className="px-4 py-2 rounded-lg text-sm hover:bg-slate-100"
          >
            Limpiar filtro
          </button>
        </div>
      </div>

      {mensaje && (
        <div className="bg-red-50 text-red-800 border-l-4 border-red-500 p-3 rounded mb-5 text-sm">
          {mensaje}
        </div>
      )}

      <div className="grid grid-cols-1 xl:grid-cols-[1fr_340px] gap-5">
        <div className="space-y-5">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
            <div className={cardClass}>
              <div className="flex justify-between">
                <p className={labelClass}>Ventas</p>
                <span className="text-xl">$</span>
              </div>
              <p className={valueClass}>S/ {ingresos.toFixed(2)}</p>
              <p className="text-xs text-slate-500 mt-3">{totalVentas} venta(s) registradas</p>
            </div>

            <div className={cardClass}>
              <div className="flex justify-between">
                <p className={labelClass}>Stock disponible</p>
                <span className="text-xl">stk</span>
              </div>
              <p className={valueClass}>{stockDisponible}</p>
              <p className="text-xs text-slate-500 mt-3">{productos.length} producto(s) activos</p>
            </div>

            <div className={cardClass}>
              <div className="flex justify-between">
                <p className={labelClass}>Valor inventario</p>
                <span className="text-xl">S/</span>
              </div>
              <p className={valueClass}>S/ {valorInventario.toFixed(2)}</p>
              <p className="text-xs text-slate-500 mt-3">{stockBajo.length} producto(s) con stock bajo</p>
            </div>
          </div>

          <div className={`${cardClass} min-h-[360px]`}>
            <p className="text-base font-bold mb-8">Total ventas</p>
            <p className="text-3xl font-bold">S/ {ingresos.toFixed(2)}</p>
            <p className="text-sm text-red-500 mt-3">{ventasAnuladas.length} venta(s) anuladas en el periodo</p>

            <div className="mt-8 border-t border-slate-100 pt-6">
              {diasVentas.length === 0 ? (
                <div className="h-40 flex items-center justify-center text-slate-400">sin data...</div>
              ) : (
                <div className="flex flex-col gap-3">
                  {diasVentas.map(([dia, total]) => (
                    <div key={dia} className="flex items-center gap-3">
                      <span className="text-xs text-slate-500 w-24">{dia}</span>
                      <div className="flex-1 h-8 bg-slate-100 rounded-full overflow-hidden">
                        <div
                          className="h-8 bg-slate-800 text-white text-xs flex items-center px-3 rounded-full"
                          style={{ width: `${Math.max(10, (total / maxVentaDia) * 100)}%` }}
                        >
                          S/ {Number(total).toFixed(2)}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>

        <div className={`${cardClass} min-h-[530px] flex flex-col`}>
          <h2 className="text-2xl font-bold text-center">TOP 5</h2>
          <p className="text-center text-slate-500 mt-3">Productos con menor stock</p>

          <div className="mt-8 flex-1">
            {topStockBajo.length === 0 ? (
              <div className="h-full flex items-center justify-center text-slate-400">sin data...</div>
            ) : (
              <div className="space-y-3">
                {topStockBajo.map((producto, index) => (
                  <div key={producto.codigo} className="flex items-center gap-3 border border-slate-100 rounded-xl p-3">
                    <span className="w-8 h-8 rounded-full bg-slate-100 flex items-center justify-center text-sm font-bold">
                      {index + 1}
                    </span>
                    <div className="flex-1 min-w-0">
                      <p className="font-semibold truncate">{producto.nombre}</p>
                      <p className="text-xs text-slate-500">{producto.marca}</p>
                    </div>
                    <span className={`px-2 py-1 rounded-lg text-xs font-semibold ${Number(producto.stockActual || 0) <= Number(producto.stockMinimo || 0) ? 'bg-red-50 text-red-700' : 'bg-slate-100 text-slate-700'}`}>
                      {producto.stockActual}
                    </span>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 xl:grid-cols-[1fr_1fr] gap-5 mt-5">
        <div className={cardClass}>
          <div className="flex items-center gap-3 mb-5">
            <h2 className="text-2xl font-bold">Movimientos de caja</h2>
            <span className="text-xs bg-slate-100 px-2 py-1 rounded-full">Realtime</span>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="text-slate-600 border-b">
                <tr>
                  <th className="p-2 text-left">Fecha</th>
                  <th className="p-2 text-left">Tipo</th>
                  <th className="p-2 text-left">Usuario</th>
                  <th className="p-2 text-right">Monto</th>
                </tr>
              </thead>
              <tbody>
                {movimientosCaja.length === 0 ? (
                  <tr><td colSpan={4} className="p-4 text-center text-slate-400">sin data...</td></tr>
                ) : (
                  movimientosCaja.map(movimiento => (
                    <tr key={movimiento.codigo} className="border-b border-slate-100">
                      <td className="p-2">{movimiento.fecha}</td>
                      <td className="p-2">{Number(movimiento.estado) === 1 ? 'venta' : 'anulada'}</td>
                      <td className="p-2">{movimiento.usuario}</td>
                      <td className="p-2 text-right">S/ {Number(movimiento.total || 0).toFixed(2)}</td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>

        <div className={cardClass}>
          <h2 className="text-2xl font-bold mb-7">TOP 10 productos por valor</h2>

          {topValorInventario.length === 0 ? (
            <div className="h-32 flex items-center justify-center text-slate-400">sin data...</div>
          ) : (
            <div className="space-y-3">
              {topValorInventario.map(producto => (
                <div key={producto.codigo} className="flex items-center gap-3">
                  <div className="w-36 truncate text-sm text-slate-600">{producto.nombre}</div>
                  <div className="flex-1 h-7 bg-slate-100 rounded-full overflow-hidden">
                    <div
                      className="h-7 bg-blue-600 rounded-full"
                      style={{ width: `${Math.max(8, (producto.valor / Math.max(1, topValorInventario[0]?.valor || 1)) * 100)}%` }}
                    />
                  </div>
                  <div className="w-24 text-right text-sm font-semibold">S/ {producto.valor.toFixed(2)}</div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

export default Inicio

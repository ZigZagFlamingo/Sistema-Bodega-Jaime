Use BodegaJaime;
/*
-- Registro de Unidades de Medida
INSERT INTO unidad_de_medida (nombre, abreviacion, descripcion) VALUES
    ('Cosa',    'C',  'Pieza individual, paquete, botella u objeto que no se venda a granel'),
    ('Kilogramo', 'KG',  'Medida de peso en kilogramos'),
    ('Litro',     'LT',  'Medida de volumen en litros');
    
*/
-- 1. Declarar una variable para el parámetro de salida
SET @resultado = '';

-- Registro de Roles
CALL sp_rol_crear('Administrador', 'Acceso completo al sistema', @resultado);
CALL sp_rol_crear('Encargado', 'Registra ventas y consulta informacion operativa', @resultado);

-- Registro de Usuarios
SET @id_administrador = (SELECT id_rol FROM rol WHERE nombre = 'Administrador' LIMIT 1);
SET @id_encargado = (SELECT id_rol FROM rol WHERE nombre = 'Encargado' LIMIT 1);

CALL sp_usuario_crear(@id_administrador, 'Shandee', 'shandee@bodegajaime.com', 'Shandee123', @resultado);
CALL sp_usuario_crear(@id_administrador, 'Gonsalo', 'gonsalo@bodegajaime.com', 'Gonsalo123', @resultado);
CALL sp_usuario_crear(@id_encargado, 'Luis', 'luis@bodegajaime.com', 'Luis123', @resultado);
CALL sp_usuario_crear(@id_encargado, 'Franco', 'franco@bodegajaime.com', 'Franco123', @resultado);

CALL sp_unidad_de_medida_crear('Cosa', 'Csa', 'Pieza individual, paquete, botella u objeto que no se venda a granel', @resultado);
CALL sp_unidad_de_medida_crear('Kilogramo', 'KG', 'Medida de peso en kilogramos', @resultado);
CALL sp_unidad_de_medida_crear('Litro', 'LT', 'Medida de volumen en litros', @resultado);

/*
-- Registro de Categorías    
INSERT INTO categoria (nombre, descripcion) VALUES
    ('Lácteos',          'Leche, yogurt, queso y derivados'),
    ('Aceites y grasas', 'Aceites, mantecas y productos grasos'),
    ('Arroz y granos',   'Arroz, menestras, quinua y similares'),
    ('Bebidas', 'Gaseosas, jugos, etc'),
    ('Vegetales', 'Vegetales, hortalizas y similares'),
    ('Frutas', 'Plantas generalmente dulces, a veces ácidas');
*/
CALL sp_categoria_crear('Lácteos', 'Leche, yogurt, queso y derivados', @resultado);
CALL sp_categoria_crear('Aceites y grasas', 'Aceites, mantecas y productos grasos', @resultado);
CALL sp_categoria_crear('Arroz y granos', 'Arroz, menestras, quinua y similares', @resultado);
CALL sp_categoria_crear('Bebidas', 'Gaseosas, jugos, etc', @resultado);
CALL sp_categoria_crear('Vegetales', 'Vegetales, hortalizas y similares', @resultado);
CALL sp_categoria_crear('Frutas', 'Plantas generalmente dulces, a veces ácidas', @resultado);

/*
-- Registro de Marcas
INSERT INTO marca (nombre, empresa) VALUES
    ('Gloria',    'Gloria S.A.'),
    ('Alicorp',   'Alicorp S.A.A.'),
    ('Costeño',   'La empresa de Costeño ns'),
    ('Coca-Cola', 'Coca-Cola company'),
    ('Marca que vende vegetales', 'no conozco marcas que vendan vegetales'),
    ('Marca que vende frutas', 'no conozco marcas que vendan frutas');
*/
CALL sp_marca_crear('Gloria', 'Gloria S.A.', @resultado);
CALL sp_marca_crear('Alicorp', 'Alicorp S.A.A.', @resultado);
CALL sp_marca_crear('Costeño', 'La empresa de Costeño ns', @resultado);
CALL sp_marca_crear('Coca-Cola', 'Coca-Cola company', @resultado);
CALL sp_marca_crear('Marca que vende vegetales', 'no conozco marcas que vendan vegetales', @resultado);
CALL sp_marca_crear('Marca que vende frutas', 'no conozco marcas que vendan frutas', @resultado);
/*
INSERT INTO producto(id_marca, id_categoria, id_unidad_de_medida, nombre, stock_actual, stock_minimo, precio_venta) VALUES
    (1, 1, 1, 'Leche Gloria Entera 1L',          80, 20, 4.50),
    (1, 1, 1, 'Leche Gloria Semidescremada 1L',  60, 15, 4.70),
    (1, 1, 1, 'Yogurt Gloria Fresa 1L',          40, 10, 6.20),
    (1, 1, 1, 'Leche Gloria Evaporada 400G',    120, 30, 3.10),
    (2, 2, 1, 'Aceite Primor 1L',                60, 15, 7.80),
    (2, 2, 1, 'Aceite Primor 500ML',             80, 20, 4.90),
    (2, 2, 1, 'Manteca Famosa 500G',             50, 10, 4.20),
    (3, 3, 1, 'Arroz Costeño Extra 1KG',        200, 50, 3.80),
    (3, 3, 1, 'Arroz Costeño Extra 5KG',         90, 20, 17.50),
    (3, 3, 2, 'Lentejas a granel',               40, 10,  3.80),
    (3, 3, 2, 'Quinua a granel',                 25,  5,  7.50),
    (4, 4, 1, 'Inca Kola Sabor Original 1L',     20,  5, 4.90),
    (4, 4, 1, 'Coca-Cola 1.5L',                  30,  5,  5.50),
    (4, 4, 1, 'Coca-Cola 500ML',                 50, 10,  3.20),
    (4, 4, 1, 'Sprite 1L',                       25,  5,  4.90),
    (5, 5, 2, 'Cebolla Roja',                    30, 10, 4.59),
    (5, 5, 2, 'Tomate',                          50, 15,  2.80),
    (5, 5, 2, 'Papa Blanca',                    100, 30,  1.90),
    (5, 5, 2, 'Zanahoria',                       40, 10,  1.50),
    (6, 6, 2, 'Sandía',                          10,  2, 1.89),
    (6, 6, 2, 'Mango',                           30,  8,  3.20),
    (6, 6, 2, 'Plátano de seda',                 45, 10,  2.10),
    (6, 6, 3, 'Jugo de naranja natural',         20,  5,  4.00);
*/
CALL sp_producto_crear(1, 1, 1, 'Leche Gloria Entera 1L',          80, 20, 4.50, @resultado);
CALL sp_producto_crear(1, 1, 1, 'Leche Gloria Semidescremada 1L',  60, 15, 4.70, @resultado);
CALL sp_producto_crear(1, 1, 1, 'Yogurt Gloria Fresa 1L',          40, 10, 6.20, @resultado);
CALL sp_producto_crear(1, 1, 1, 'Leche Gloria Evaporada 400G',    120, 30, 3.10, @resultado);
CALL sp_producto_crear(2, 2, 1, 'Aceite Primor 1L',                60, 15, 7.80, @resultado);
CALL sp_producto_crear(2, 2, 1, 'Aceite Primor 500ML',             80, 20, 4.90, @resultado);
CALL sp_producto_crear(2, 2, 1, 'Manteca Famosa 500G',             50, 10, 4.20, @resultado);
CALL sp_producto_crear(3, 3, 1, 'Arroz Costeño Extra 1KG',        200, 50, 3.80, @resultado);
CALL sp_producto_crear(3, 3, 1, 'Arroz Costeño Extra 5KG',         90, 20, 17.50, @resultado);
CALL sp_producto_crear(3, 3, 2, 'Lentejas a granel',               40, 10,  3.80, @resultado);
CALL sp_producto_crear(3, 3, 2, 'Quinua a granel',                 25,  5,  7.50, @resultado);
CALL sp_producto_crear(4, 4, 1, 'Inca Kola Sabor Original 1L',     20,  5, 4.90, @resultado);
CALL sp_producto_crear(4, 4, 1, 'Coca-Cola 1.5L',                  30,  5,  5.50, @resultado);
CALL sp_producto_crear(4, 4, 1, 'Coca-Cola 500ML',                 50, 10,  3.20, @resultado);
CALL sp_producto_crear(4, 4, 1, 'Sprite 1L',                       25,  5,  4.90, @resultado);
CALL sp_producto_crear(5, 5, 2, 'Cebolla Roja',                    30, 10, 4.59, @resultado);
CALL sp_producto_crear(5, 5, 2, 'Tomate',                          50, 15,  2.80, @resultado);
CALL sp_producto_crear(5, 5, 2, 'Papa Blanca',                    100, 30,  1.90, @resultado);
CALL sp_producto_crear(5, 5, 2, 'Zanahoria',                       40, 10,  1.50, @resultado);
CALL sp_producto_crear(6, 6, 2, 'Sandía',                          10,  2, 1.89, @resultado);
CALL sp_producto_crear(6, 6, 2, 'Mango',                           30,  8,  3.20, @resultado);
CALL sp_producto_crear(6, 6, 2, 'Plátano de seda',                 45, 10,  2.10, @resultado);
CALL sp_producto_crear(6, 6, 3, 'Jugo de naranja natural',         20,  5,  4.00, @resultado);

-- 1. Declarar una variable para el parámetro de salida
SET @resultado = '';

-- =============================================================
-- Registro de Proveedores
-- =============================================================
CALL sp_proveedor_crear('Distribuidora Gloria S.A.', 'Carlos Mendoza', '987654321', @resultado);
CALL sp_proveedor_crear('Alicorp Distribución Norte', 'Rosa Fernández', '976543210', @resultado);
CALL sp_proveedor_crear('Costeño Alimentos S.A.C.', 'Jorge Salinas', '965432109', @resultado);
CALL sp_proveedor_crear('Coca-Cola Perú', 'Ana Quispe', '954321098', @resultado);
CALL sp_proveedor_crear('Mercado Mayorista de Frutas y Verduras', 'Pedro Huamán', '943210987', @resultado);

-- =============================================================
-- Variables de apoyo: usuarios, proveedores y productos
-- =============================================================
SET @id_shandee = (SELECT id_usuario FROM usuario WHERE nombre = 'Shandee' LIMIT 1);
SET @id_gonsalo = (SELECT id_usuario FROM usuario WHERE nombre = 'Gonsalo' LIMIT 1);
SET @id_luis    = (SELECT id_usuario FROM usuario WHERE nombre = 'Luis'    LIMIT 1);
SET @id_franco  = (SELECT id_usuario FROM usuario WHERE nombre = 'Franco'  LIMIT 1);

SET @id_prov_gloria    = (SELECT id_proveedor FROM proveedor WHERE nombre = 'Distribuidora Gloria S.A.' LIMIT 1);
SET @id_prov_alicorp   = (SELECT id_proveedor FROM proveedor WHERE nombre = 'Alicorp Distribución Norte' LIMIT 1);
SET @id_prov_costeno   = (SELECT id_proveedor FROM proveedor WHERE nombre = 'Costeño Alimentos S.A.C.' LIMIT 1);
SET @id_prov_cocacola  = (SELECT id_proveedor FROM proveedor WHERE nombre = 'Coca-Cola Perú' LIMIT 1);
SET @id_prov_mercado   = (SELECT id_proveedor FROM proveedor WHERE nombre = 'Mercado Mayorista de Frutas y Verduras' LIMIT 1);

SET @id_leche_entera    = (SELECT id_producto FROM producto WHERE nombre = 'Leche Gloria Entera 1L' LIMIT 1);
SET @id_leche_semi      = (SELECT id_producto FROM producto WHERE nombre = 'Leche Gloria Semidescremada 1L' LIMIT 1);
SET @id_yogurt_fresa    = (SELECT id_producto FROM producto WHERE nombre = 'Yogurt Gloria Fresa 1L' LIMIT 1);
SET @id_aceite_1l       = (SELECT id_producto FROM producto WHERE nombre = 'Aceite Primor 1L' LIMIT 1);
SET @id_aceite_500ml    = (SELECT id_producto FROM producto WHERE nombre = 'Aceite Primor 500ML' LIMIT 1);
SET @id_arroz_1kg       = (SELECT id_producto FROM producto WHERE nombre = 'Arroz Costeño Extra 1KG' LIMIT 1);
SET @id_arroz_5kg       = (SELECT id_producto FROM producto WHERE nombre = 'Arroz Costeño Extra 5KG' LIMIT 1);
SET @id_cocacola_15l    = (SELECT id_producto FROM producto WHERE nombre = 'Coca-Cola 1.5L' LIMIT 1);
SET @id_cocacola_500ml  = (SELECT id_producto FROM producto WHERE nombre = 'Coca-Cola 500ML' LIMIT 1);
SET @id_cebolla         = (SELECT id_producto FROM producto WHERE nombre = 'Cebolla Roja' LIMIT 1);
SET @id_tomate          = (SELECT id_producto FROM producto WHERE nombre = 'Tomate' LIMIT 1);
SET @id_papa            = (SELECT id_producto FROM producto WHERE nombre = 'Papa Blanca' LIMIT 1);
SET @id_sandia          = (SELECT id_producto FROM producto WHERE nombre = 'Sandía' LIMIT 1);
SET @id_mango           = (SELECT id_producto FROM producto WHERE nombre = 'Mango' LIMIT 1);

-- =============================================================
-- Registro de Entradas de mercadería
-- =============================================================

-- Entrada 1: Distribuidora Gloria - lácteos
SET @id_entrada = NULL;
CALL sp_entrada_crear(@id_prov_gloria, @id_gonsalo, @id_entrada, @resultado);
SET @id_entrada_1 = @id_entrada;
CALL sp_detalle_entrada_crear(@id_entrada_1, @id_leche_entera, 50, 3.20, @resultado);
CALL sp_detalle_entrada_crear(@id_entrada_1, @id_leche_semi,   40, 3.35, @resultado);
CALL sp_detalle_entrada_crear(@id_entrada_1, @id_yogurt_fresa, 30, 4.50, @resultado);

-- Entrada 2: Alicorp - aceites
SET @id_entrada = NULL;
CALL sp_entrada_crear(@id_prov_alicorp, @id_gonsalo, @id_entrada, @resultado);
SET @id_entrada_2 = @id_entrada;
CALL sp_detalle_entrada_crear(@id_entrada_2, @id_aceite_1l,    40, 5.60, @resultado);
CALL sp_detalle_entrada_crear(@id_entrada_2, @id_aceite_500ml, 50, 3.50, @resultado);

-- Entrada 3: Costeño - arroz
SET @id_entrada = NULL;
CALL sp_entrada_crear(@id_prov_costeno, @id_shandee, @id_entrada, @resultado);
SET @id_entrada_3 = @id_entrada;
CALL sp_detalle_entrada_crear(@id_entrada_3, @id_arroz_1kg, 150, 2.70, @resultado);
CALL sp_detalle_entrada_crear(@id_entrada_3, @id_arroz_5kg,  60, 12.80, @resultado);

-- Entrada 4: Coca-Cola Perú - bebidas
SET @id_entrada = NULL;
CALL sp_entrada_crear(@id_prov_cocacola, @id_shandee, @id_entrada, @resultado);
SET @id_entrada_4 = @id_entrada;
CALL sp_detalle_entrada_crear(@id_entrada_4, @id_cocacola_15l,   25, 4.00, @resultado);
CALL sp_detalle_entrada_crear(@id_entrada_4, @id_cocacola_500ml, 40, 2.30, @resultado);

-- Entrada 5: Mercado Mayorista - verduras y frutas
SET @id_entrada = NULL;
CALL sp_entrada_crear(@id_prov_mercado, @id_gonsalo, @id_entrada, @resultado);
SET @id_entrada_5 = @id_entrada;
CALL sp_detalle_entrada_crear(@id_entrada_5, @id_cebolla, 25, 3.00, @resultado);
CALL sp_detalle_entrada_crear(@id_entrada_5, @id_tomate,  30, 1.80, @resultado);
CALL sp_detalle_entrada_crear(@id_entrada_5, @id_papa,    60, 1.20, @resultado);
CALL sp_detalle_entrada_crear(@id_entrada_5, @id_sandia,  15, 1.10, @resultado);
CALL sp_detalle_entrada_crear(@id_entrada_5, @id_mango,   20, 2.00, @resultado);

-- =============================================================
-- Edición de una entrada (genera registro de auditoría)
-- =============================================================

-- Se corrige la cantidad y el precio de costo registrado para la leche entera
SET @id_detalle_a_editar = (
    SELECT id_detalle_entrada FROM detalle_entrada
    WHERE id_entrada = @id_entrada_1 AND id_producto = @id_leche_entera
    LIMIT 1
);
CALL sp_entrada_editar(@id_entrada_1, @id_detalle_a_editar, @id_gonsalo, 55, 3.10, 'Corrección de cantidad y precio según factura del proveedor', @resultado);

-- =============================================================
-- Registro de Ajustes de inventario
-- =============================================================

-- Ajuste negativo: mermas de productos perecibles
CALL sp_ajuste_inventario_crear(@id_tomate, @id_shandee, -5, 'Merma por productos en mal estado', @resultado);
CALL sp_ajuste_inventario_crear(@id_sandia, @id_shandee, -2, 'Producto dañado durante el transporte', @resultado);

-- Ajuste positivo: corrección de un conteo manual previo
CALL sp_ajuste_inventario_crear(@id_arroz_1kg, @id_gonsalo, 10, 'Se encontraron sacos adicionales no registrados en el almacén', @resultado);

-- =============================================================
-- Conteo físico de inventario
-- =============================================================

-- Se inicia un conteo físico, cargando todos los productos activos
SET @id_conteo = NULL;
CALL sp_conteo_fisico_iniciar(@id_shandee, @id_conteo, @resultado);

-- Se registra la cantidad contada físicamente para algunos productos
-- (el resto de productos del conteo queda en 0 por defecto, simulando que aún no han sido contados)
CALL sp_detalle_conteo_registrar(@id_conteo, @id_cebolla, 18, @resultado);
CALL sp_detalle_conteo_registrar(@id_conteo, @id_papa,    95, @resultado);
CALL sp_detalle_conteo_registrar(@id_conteo, @id_mango,   28, @resultado);

-- Se consultan las diferencias encontradas en el conteo
CALL sp_conteo_fisico_ver_diferencias(@id_conteo);

-- Se aplica el ajuste automático para el producto con menor stock físico que el registrado
CALL sp_conteo_fisico_aplicar_ajuste(@id_conteo, @id_cebolla, @id_shandee, @resultado);
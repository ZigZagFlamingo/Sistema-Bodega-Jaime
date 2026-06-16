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

DROP DATABASE IF EXISTS bodegaJaime;
Create Database if not exists bodegaJaime;
Use BodegaJaime;

-- =============================================================
-- TABLAS
-- =============================================================

-- Tabla: marca
CREATE TABLE marca (
    id_marca INT NOT NULL AUTO_INCREMENT,
    nombre   VARCHAR(100) NOT NULL,
    empresa  VARCHAR(200) NOT NULL,
    estado   TINYINT      NOT NULL DEFAULT 1,
    PRIMARY KEY (id_marca)
) ENGINE=InnoDB;

-- Tabla: categoria
CREATE TABLE categoria (
    id_categoria INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_categoria)
) ENGINE=InnoDB;

-- Tabla: unidad_de_medida
CREATE TABLE unidad_de_medida (
    id_unidad_de_medida INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    abreviacion VARCHAR(10)  NOT NULL,
    descripcion  TEXT,
    estado  TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_unidad_de_medida)
) ENGINE=InnoDB;

-- Tabla: rol
CREATE TABLE rol (
    id_rol INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_rol)
) ENGINE=InnoDB;

-- Tabla: usuario
CREATE TABLE usuario (
    id_usuario INT NOT NULL AUTO_INCREMENT,
    id_rol INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    password VARCHAR(100) NOT NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_usuario),
    CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
) ENGINE=InnoDB;


-- Tabla: producto
CREATE TABLE producto (
    id_producto INT  NOT NULL AUTO_INCREMENT,
    id_marca	INT NOT NULL,
    id_categoria	INT NOT NULL,
    id_unidad_de_medida	INT	NOT NULL,
    nombre VARCHAR(100)  NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 0,
    precio_venta DECIMAL(10,2)  NOT NULL,
    codigo_barras VARCHAR(13) UNIQUE,
    estado TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_producto),
    CONSTRAINT fk_producto_marca  FOREIGN KEY (id_marca)  REFERENCES marca(id_marca),
    CONSTRAINT fk_producto_categoria  FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    CONSTRAINT fk_producto_unidad FOREIGN KEY (id_unidad_de_medida) REFERENCES unidad_de_medida(id_unidad_de_medida)
) ENGINE=InnoDB;

-- Tabla: venta
CREATE TABLE venta (
    id_venta INT NOT NULL AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    fecha_venta DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL DEFAULT 0,
    estado TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_venta),
    CONSTRAINT fk_venta_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

-- Tabla: detalle_venta
CREATE TABLE detalle_venta (
    id_detalle_venta INT NOT NULL AUTO_INCREMENT,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_detalle_venta),
    CONSTRAINT fk_detalle_venta FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
) ENGINE=InnoDB;

-- Tabla: proveedor
-- Requerida por HU - Registro de entradas de mercadería
-- Criterio: Para registrar una entrada es obligatorio seleccionar un proveedor
CREATE TABLE proveedor (
    id_proveedor INT          NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(150) NOT NULL,
    contacto     VARCHAR(100),
    telefono     VARCHAR(20),
    estado       TINYINT      NOT NULL DEFAULT 1,
    PRIMARY KEY (id_proveedor)
) ENGINE=InnoDB;

-- Tabla: entrada
-- Requerida por HU - Registro de entradas de mercadería
-- Criterio: Cada entrada registrada contiene: fecha y hora, proveedor,
--           productos recibidos con su cantidad y precio de costo unitario
CREATE TABLE entrada (
    id_entrada   INT      NOT NULL AUTO_INCREMENT,
    id_proveedor INT      NOT NULL,
    id_usuario   INT      NOT NULL,
    fecha_entrada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_costo  DECIMAL(10,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (id_entrada),
    CONSTRAINT fk_entrada_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    CONSTRAINT fk_entrada_usuario   FOREIGN KEY (id_usuario)   REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

-- Tabla: detalle_entrada
-- Requerida por HU - Registro de entradas de mercadería
-- Criterio: Una entrada puede incluir uno o más productos
-- Criterio: Para cada producto son obligatorios la cantidad recibida y el precio de costo unitario
CREATE TABLE detalle_entrada (
    id_detalle_entrada INT           NOT NULL AUTO_INCREMENT,
    id_entrada         INT           NOT NULL,
    id_producto        INT           NOT NULL,
    cantidad           INT           NOT NULL,
    precio_costo       DECIMAL(10,2) NOT NULL,
    subtotal_costo     DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_detalle_entrada),
    CONSTRAINT fk_detalle_entrada_entrada   FOREIGN KEY (id_entrada)  REFERENCES entrada(id_entrada),
    CONSTRAINT fk_detalle_entrada_producto  FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
) ENGINE=InnoDB;

-- Tabla: auditoria_entrada
-- Requerida por HU - Auditoría de entradas de mercadería
-- Criterio: Cada modificación registra: fecha y hora del cambio, usuario que la realizó,
--           qué información fue modificada y el motivo ingresado
CREATE TABLE auditoria_entrada (
    id_auditoria_entrada INT      NOT NULL AUTO_INCREMENT,
    id_entrada           INT      NOT NULL,
    id_usuario           INT      NOT NULL,
    fecha_modificacion   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    informacion_modificada TEXT   NOT NULL,
    motivo               TEXT     NOT NULL,
    PRIMARY KEY (id_auditoria_entrada),
    CONSTRAINT fk_auditoria_entrada_entrada  FOREIGN KEY (id_entrada)  REFERENCES entrada(id_entrada),
    CONSTRAINT fk_auditoria_entrada_usuario  FOREIGN KEY (id_usuario)  REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

-- Tabla: tipo_movimiento
-- Requerida por HU - Historial de movimientos
-- Criterio: Los tipos de movimiento son: venta, entrada de mercadería, ajuste y modificación de entrada
CREATE TABLE tipo_movimiento (
    id_tipo_movimiento INT          NOT NULL AUTO_INCREMENT,
    nombre             VARCHAR(100) NOT NULL,
    descripcion        TEXT,
    PRIMARY KEY (id_tipo_movimiento)
) ENGINE=InnoDB;

-- Tabla: movimiento_inventario
-- Requerida por HU - Historial de movimientos
-- Criterio: Cada movimiento muestra: fecha y hora, tipo de movimiento,
--           producto, cantidad y responsable
CREATE TABLE movimiento_inventario (
    id_movimiento      INT      NOT NULL AUTO_INCREMENT,
    id_tipo_movimiento INT      NOT NULL,
    id_producto        INT      NOT NULL,
    id_usuario         INT      NOT NULL,
    id_referencia      INT,
    cantidad           INT      NOT NULL,
    fecha_movimiento   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_movimiento),
    CONSTRAINT fk_movimiento_tipo     FOREIGN KEY (id_tipo_movimiento) REFERENCES tipo_movimiento(id_tipo_movimiento),
    CONSTRAINT fk_movimiento_producto FOREIGN KEY (id_producto)        REFERENCES producto(id_producto),
    CONSTRAINT fk_movimiento_usuario  FOREIGN KEY (id_usuario)         REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

-- Tabla: ajuste_inventario
-- Requerida por HU - Ajustes de inventario
-- Criterio: Para registrar un ajuste son obligatorios el producto, la cantidad y el motivo
-- Criterio: Un ajuste puede ser positivo o negativo
-- Criterio: Un ajuste registrado no puede editarse ni eliminarse
CREATE TABLE ajuste_inventario (
    id_ajuste    INT      NOT NULL AUTO_INCREMENT,
    id_producto  INT      NOT NULL,
    id_usuario   INT      NOT NULL,
    cantidad     INT      NOT NULL,
    motivo       TEXT     NOT NULL,
    fecha_ajuste DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_ajuste),
    CONSTRAINT fk_ajuste_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT fk_ajuste_usuario  FOREIGN KEY (id_usuario)  REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

-- Tabla: conteo_fisico
-- Requerida por HU - Conteo físico de inventario
-- Criterio: El sistema programa el próximo conteo dos semanas después del último registrado
-- Criterio: Un conteo físico registrado no puede editarse una vez confirmado
CREATE TABLE conteo_fisico (
    id_conteo        INT      NOT NULL AUTO_INCREMENT,
    id_usuario       INT      NOT NULL,
    fecha_conteo     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_proximo    DATE     NOT NULL,
    tiene_diferencias TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_conteo),
    CONSTRAINT fk_conteo_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

-- Tabla: detalle_conteo_fisico
-- Requerida por HU - Conteo físico de inventario
-- Criterio: Un conteo incluye todos los productos activos del sistema
-- Criterio: Para cada producto se registra la cantidad contada físicamente
-- Criterio: El sistema muestra las diferencias entre el stock registrado y el contado
-- Criterio: Por cada diferencia el administrador puede registrar un ajuste automático o ignorarla
CREATE TABLE detalle_conteo_fisico (
    id_detalle_conteo INT     NOT NULL AUTO_INCREMENT,
    id_conteo         INT     NOT NULL,
    id_producto       INT     NOT NULL,
    stock_sistema     INT     NOT NULL,
    stock_contado     INT     NOT NULL,
    diferencia        INT     NOT NULL,
    ajuste_aplicado   TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_detalle_conteo),
    CONSTRAINT fk_detalle_conteo_conteo    FOREIGN KEY (id_conteo)   REFERENCES conteo_fisico(id_conteo),
    CONSTRAINT fk_detalle_conteo_producto  FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
) ENGINE=InnoDB;
-- =============================================================
--                Vistas F
-- =============================================================

-- Búsqueda de Productos activos con filtros opcionales
DELIMITER $$
CREATE PROCEDURE sp_buscar_productos_activos(
    IN p_nombre    VARCHAR(100),
    IN p_marca     VARCHAR(100),
    IN p_categoria VARCHAR(100)
)
BEGIN
    SELECT
        p.id_producto  AS "Código",
        p.nombre       AS "Nombre",
        m.nombre       AS "Marca",
        c.nombre       AS "Categoría",
        um.abreviacion AS "Unidad de medida",
        p.stock_actual AS "Stock Actual",
        p.stock_minimo AS "Stock Mínimo",
        p.precio_venta AS "Precio",
        p.codigo_barras AS "Código de barras"
    FROM producto p
    INNER JOIN marca            m ON p.id_marca            = m.id_marca
    INNER JOIN categoria        c ON p.id_categoria        = c.id_categoria
    INNER JOIN unidad_de_medida um ON p.id_unidad_de_medida = um.id_unidad_de_medida
    WHERE p.estado = 1
      AND (p_nombre    IS NULL OR p.nombre  LIKE CONCAT('%', p_nombre,    '%'))
      AND (p_marca     IS NULL OR m.nombre  LIKE CONCAT('%', p_marca,     '%'))
      AND (p_categoria IS NULL OR c.nombre  LIKE CONCAT('%', p_categoria, '%'));
END$$
DELIMITER ; -- funciona

-- Búsqueda de productos inactivos con filtros opcionales
DELIMITER $$
CREATE PROCEDURE sp_buscar_productos_inactivos(
    IN p_nombre    VARCHAR(100),
    IN p_marca     VARCHAR(100),
    IN p_categoria VARCHAR(100)
)
BEGIN
    SELECT
        p.id_producto  AS "Código",
        p.nombre       AS "Nombre",
        m.nombre       AS "Marca",
        c.nombre       AS "Categoría",
        um.abreviacion  AS "Unidad de medida",
        p.stock_actual AS "Stock Actual",
        p.stock_minimo AS "Stock Mínimo",
        p.precio_venta AS "Precio",
        p.codigo_barras AS "Código de barras"
    FROM producto p
    INNER JOIN marca            m ON p.id_marca            = m.id_marca
    INNER JOIN categoria        c ON p.id_categoria        = c.id_categoria
    INNER JOIN unidad_de_medida um ON p.id_unidad_de_medida = um.id_unidad_de_medida
    WHERE p.estado = 0
      AND (p_nombre    IS NULL OR p.nombre  LIKE CONCAT('%', p_nombre,    '%'))
      AND (p_marca     IS NULL OR m.nombre  LIKE CONCAT('%', p_marca,     '%'))
      AND (p_categoria IS NULL OR c.nombre  LIKE CONCAT('%', p_categoria, '%'));
END$$
DELIMITER ; -- funciona

-- Búsqueda de Categorias activas con filtro opcional (nombre)
DELIMITER $$
CREATE PROCEDURE sp_buscar_categorias_activas(
    IN c_nombre    VARCHAR(100)
)
BEGIN
    SELECT
        id_categoria  AS "Código",
        nombre       AS "Nombre",
        descripcion AS "Descripción"
    FROM categoria
    WHERE estado = 1
      AND (c_nombre    IS NULL OR nombre  LIKE CONCAT('%', c_nombre,    '%'));
END$$
DELIMITER ; -- funciona

-- Búsqueda de Categorias inactivas con filtro opcional (nombre)
DELIMITER $$
CREATE PROCEDURE sp_buscar_categorias_inactivas(
    IN c_nombre    VARCHAR(100)
)
BEGIN
    SELECT
        id_categoria  AS "Código",
        nombre       AS "Nombre",
        descripcion AS "Descripción"
    FROM categoria
    WHERE estado = 0
      AND (c_nombre    IS NULL OR nombre  LIKE CONCAT('%', c_nombre,    '%'));
END$$
DELIMITER ; -- funciona

-- Búsqueda de Marcas activas con filtro opcional (nombre y empresa)
DELIMITER $$
CREATE PROCEDURE sp_buscar_marcas_activas(
    IN m_nombre    VARCHAR(100),
    IN m_empresa   VARCHAR(200)
)
BEGIN
    SELECT
        id_marca AS "Código",
        nombre       AS "Nombre",
        empresa      AS "Empresa"
    FROM marca
    WHERE estado = 1
      AND (m_nombre  IS NULL OR nombre   LIKE CONCAT('%', m_nombre,  '%'))
      AND (m_empresa IS NULL OR empresa  LIKE CONCAT('%', m_empresa, '%'));
END$$
DELIMITER ; -- funciona

-- Búsqueda de Marcas inactivas con filtro opcional (nombre y empresa)
DELIMITER $$
CREATE PROCEDURE sp_buscar_marcas_inactivas(
    IN m_nombre    VARCHAR(100),
    IN m_empresa   VARCHAR(200)
)
BEGIN
    SELECT
        id_marca AS "Código",
        nombre       AS "Nombre",
        empresa      AS "Empresa"
    FROM marca
    WHERE estado = 0
      AND (m_nombre  IS NULL OR nombre   LIKE CONCAT('%', m_nombre,  '%'))
      AND (m_empresa IS NULL OR empresa  LIKE CONCAT('%', m_empresa, '%'));
END$$
DELIMITER ; -- funciona

-- Búsqueda de Unidades de Medidas activas con filtro opcional (nombre y abreviación)
DELIMITER $$
CREATE PROCEDURE sp_buscar_unidades_de_medida_activas(
    IN um_nombre      VARCHAR(100),
    IN um_abreviacion VARCHAR(10)
)
BEGIN
    SELECT
        id_unidad_de_medida AS "Código",
        nombre       AS "Nombre",
        abreviacion  AS "Abreviación",
        descripcion  AS "Descripción"
    FROM unidad_de_medida
    WHERE estado = 1
      AND (um_nombre      IS NULL OR nombre      LIKE CONCAT('%', um_nombre,  '%'))
      AND (um_abreviacion IS NULL OR abreviacion LIKE CONCAT('%', um_abreviacion, '%'));
END$$
DELIMITER ; -- funciona

-- Búsqueda de Unidades de Medidas inactivas con filtro opcional (nombre y abreviación)
DELIMITER $$
CREATE PROCEDURE sp_buscar_unidades_de_medida_inactivas(
    IN um_nombre      VARCHAR(100),
    IN um_abreviacion VARCHAR(10)
)
BEGIN
    SELECT
        id_unidad_de_medida AS "Código",
        nombre       AS "Nombre",
        abreviacion  AS "Abreviación",
        descripcion  AS "Descripción"
    FROM unidad_de_medida
    WHERE estado = 0
      AND (um_nombre      IS NULL OR nombre      LIKE CONCAT('%', um_nombre,  '%'))
      AND (um_abreviacion IS NULL OR abreviacion LIKE CONCAT('%', um_abreviacion, '%'));
END$$
DELIMITER ; -- funciona

-- Búsqueda de Roles activos con filtro opcional (nombre y descripción)
DELIMITER $$
CREATE PROCEDURE sp_buscar_roles_activos(
    IN r_nombre      VARCHAR(100),
    IN r_descripcion TEXT
)
BEGIN
    SELECT
        id_rol      AS "Código",
        nombre      AS "Nombre",
        descripcion AS "Descripción"
    FROM rol
    WHERE estado = 1
      AND (r_nombre      IS NULL OR nombre      LIKE CONCAT('%', r_nombre,      '%'))
      AND (r_descripcion IS NULL OR descripcion LIKE CONCAT('%', r_descripcion, '%'));
END$$
DELIMITER ; -- funciona

-- Búsqueda de Roles inactivos con filtro opcional (nombre y descripción)
DELIMITER $$
CREATE PROCEDURE sp_buscar_roles_inactivos(
    IN r_nombre      VARCHAR(100),
    IN r_descripcion TEXT
)
BEGIN
    SELECT
        id_rol      AS "Código",
        nombre      AS "Nombre",
        descripcion AS "Descripción"
    FROM rol
    WHERE estado = 0
      AND (r_nombre      IS NULL OR nombre      LIKE CONCAT('%', r_nombre,      '%'))
      AND (r_descripcion IS NULL OR descripcion LIKE CONCAT('%', r_descripcion, '%'));
END$$
DELIMITER ; -- funciona

-- Búsqueda de Usuarios activos con filtro opcional (nombre, correo y rol)
DELIMITER $$
CREATE PROCEDURE sp_buscar_usuarios_activos(
    IN u_nombre VARCHAR(100),
    IN u_correo VARCHAR(150),
    IN u_rol    VARCHAR(100)
)
BEGIN
    SELECT
        u.id_usuario AS "Código",
        u.nombre     AS "Nombre",
        u.correo     AS "Correo",
        r.nombre     AS "Rol"
    FROM usuario u
    INNER JOIN rol r ON u.id_rol = r.id_rol
    WHERE u.estado = 1
      AND (u_nombre IS NULL OR u.nombre LIKE CONCAT('%', u_nombre, '%'))
      AND (u_correo IS NULL OR u.correo LIKE CONCAT('%', u_correo, '%'))
      AND (u_rol    IS NULL OR r.nombre LIKE CONCAT('%', u_rol,    '%'));
END$$
DELIMITER ; -- funciona

-- Búsqueda de Usuarios inactivos con filtro opcional (nombre, correo y rol)
DELIMITER $$
CREATE PROCEDURE sp_buscar_usuarios_inactivos(
    IN u_nombre VARCHAR(100),
    IN u_correo VARCHAR(150),
    IN u_rol    VARCHAR(100)
)
BEGIN
    SELECT
        u.id_usuario AS "Código",
        u.nombre     AS "Nombre",
        u.correo     AS "Correo",
        r.nombre     AS "Rol"
    FROM usuario u
    INNER JOIN rol r ON u.id_rol = r.id_rol
    WHERE u.estado = 0
      AND (u_nombre IS NULL OR u.nombre LIKE CONCAT('%', u_nombre, '%'))
      AND (u_correo IS NULL OR u.correo LIKE CONCAT('%', u_correo, '%'))
      AND (u_rol    IS NULL OR r.nombre LIKE CONCAT('%', u_rol,    '%'));
END$$
DELIMITER ; -- funciona

-- Busqueda de productos disponibles para venta con filtros opcionales
DELIMITER $$
CREATE PROCEDURE sp_buscar_productos_disponibles_venta(
    IN p_nombre    VARCHAR(100),
    IN p_marca     VARCHAR(100),
    IN p_categoria VARCHAR(100),
    IN p_unidad    VARCHAR(100)
)
BEGIN
    SELECT
        p.id_producto  AS "Codigo",
        p.nombre       AS "Nombre",
        m.nombre       AS "Marca",
        c.nombre       AS "Categoria",
        um.abreviacion AS "Unidad",
        p.stock_actual AS "Stock Disponible",
        p.precio_venta AS "Precio"
    FROM producto p
    INNER JOIN marca            m ON p.id_marca = m.id_marca
    INNER JOIN categoria        c ON p.id_categoria = c.id_categoria
    INNER JOIN unidad_de_medida um ON p.id_unidad_de_medida = um.id_unidad_de_medida
    WHERE p.estado = 1
      AND p.stock_actual > 0
      AND (p_nombre    IS NULL OR p.nombre  LIKE CONCAT('%', p_nombre,    '%'))
      AND (p_marca     IS NULL OR m.nombre  LIKE CONCAT('%', p_marca,     '%'))
      AND (p_categoria IS NULL OR c.nombre  LIKE CONCAT('%', p_categoria, '%'))
      AND (p_unidad    IS NULL OR um.nombre LIKE CONCAT('%', p_unidad,    '%') OR um.abreviacion LIKE CONCAT('%', p_unidad, '%'));
END$$
DELIMITER ; -- funciona

-- Busqueda del historial de ventas con filtros opcionales
DELIMITER $$
CREATE PROCEDURE sp_buscar_historial_ventas(
    IN h_usuario      VARCHAR(100),
    IN h_fecha_inicio DATE,
    IN h_fecha_fin    DATE,
    IN h_estado       TINYINT
)
BEGIN
    SELECT
        v.id_venta    AS "Codigo",
        v.fecha_venta AS "Fecha",
        u.nombre      AS "Usuario",
        u.correo      AS "Correo",
        r.nombre      AS "Rol",
        v.total       AS "Total",
        v.estado      AS "Estado"
    FROM venta v
    INNER JOIN usuario u ON v.id_usuario = u.id_usuario
    INNER JOIN rol r ON u.id_rol = r.id_rol
    WHERE (h_usuario IS NULL OR u.nombre LIKE CONCAT('%', h_usuario, '%') OR u.correo LIKE CONCAT('%', h_usuario, '%'))
      AND (h_fecha_inicio IS NULL OR DATE(v.fecha_venta) >= h_fecha_inicio)
      AND (h_fecha_fin IS NULL OR DATE(v.fecha_venta) <= h_fecha_fin)
      AND (h_estado IS NULL OR v.estado = h_estado)
    ORDER BY v.fecha_venta DESC;
END$$
DELIMITER ; -- funciona
-- =============================================================
--                Vistas F
-- =============================================================

-- =============================================================
--                Funciones
-- =============================================================

-- Verifica si un producto existe (evita registros repetidos)
DELIMITER $$
CREATE FUNCTION fn_producto_existe(p_nombre VARCHAR(100))
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM producto
        WHERE LOWER(nombre) = LOWER(p_nombre)
    );
END$$
DELIMITER ; -- funciona

-- Verifica si un producto tiene stock disponible para vender
DELIMITER $$
CREATE FUNCTION fn_producto_stock_disponible(p_id_producto INT, p_cantidad INT)
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM producto
        WHERE id_producto = p_id_producto
          AND estado = 1
          AND p_cantidad > 0
          AND stock_actual >= p_cantidad
    );
END$$
DELIMITER ; -- funciona

-- Genera código de barras EAN-13 ficticio único
DELIMITER $$
CREATE FUNCTION fn_generar_codigo_barras()
RETURNS VARCHAR(13)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE codigo VARCHAR(13);
    DECLARE intentos INT DEFAULT 0;
    REPEAT
        -- Genera 12 dígitos aleatorios con prefijo 200 (rango de uso libre)
        SET codigo = CONCAT(
            '200',
            LPAD(FLOOR(RAND() * 1000000000), 9, '0')
        );
        SET intentos = intentos + 1;
    UNTIL NOT EXISTS (SELECT 1 FROM producto WHERE codigo_barras = codigo) OR intentos > 100
    END REPEAT;
    RETURN codigo;
END$$
DELIMITER ; -- funciona

-- Verifica si una marca existe (evita registros repetidos)
DELIMITER $$
CREATE FUNCTION fn_marca_existe(m_nombre VARCHAR(100))
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM marca
        WHERE LOWER(nombre) = LOWER(m_nombre)
    );
END$$
DELIMITER ; -- funciona

-- Verifica si una categoria existe (evita registros repetidos)
DELIMITER $$
CREATE FUNCTION fn_categoria_existe(c_nombre VARCHAR(100))
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM categoria
        WHERE LOWER(nombre) = LOWER(c_nombre)
    );
END$$
DELIMITER ; -- funciona

-- Verifica si una unidad de medida existe (evita registros repetidos)
DELIMITER $$
CREATE FUNCTION fn_unidad_de_medida_existe(um_nombre VARCHAR(100))
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM unidad_de_medida
        WHERE LOWER(nombre) = LOWER(um_nombre)
    );
END$$
DELIMITER ; -- funciona

-- Verifica si un nombre de rol existe (evita registros repetidos)
DELIMITER $$
CREATE FUNCTION fn_rol_nombre_existe(r_nombre VARCHAR(100))
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM rol
        WHERE LOWER(nombre) = LOWER(r_nombre)
    );
END$$
DELIMITER ; -- funciona

-- Verifica si una descripcion de rol existe (evita registros repetidos)
DELIMITER $$
CREATE FUNCTION fn_rol_descripcion_existe(r_descripcion TEXT)
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM rol
        WHERE LOWER(descripcion) = LOWER(r_descripcion)
    );
END$$
DELIMITER ; -- funciona

-- Verifica si un correo de usuario existe (evita registros repetidos)
DELIMITER $$
CREATE FUNCTION fn_usuario_correo_existe(u_correo VARCHAR(150))
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM usuario
        WHERE LOWER(correo) = LOWER(u_correo)
    );
END$$
DELIMITER ; -- funciona

-- Verifica si el password contiene solo letras y numeros, con al menos una letra y un numero
DELIMITER $$
CREATE FUNCTION fn_usuario_password_valido(u_password VARCHAR(100))
RETURNS BOOLEAN
NO SQL
NOT DETERMINISTIC
BEGIN
    RETURN u_password REGEXP '^[A-Za-z0-9]+$'
       AND u_password REGEXP '[A-Za-z]'
       AND u_password REGEXP '[0-9]';
END$$
DELIMITER ; -- funciona

/*
Función: fn_marca_tiene_productos_activos
Descripción: Verifica si una marca posee productos activos asociados.
*/
DELIMITER $$
CREATE FUNCTION fn_marca_tiene_productos_activos(p_id_marca INT)
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM producto
        WHERE id_marca = p_id_marca
			AND estado = 1
    );
END$$
DELIMITER ; -- funciona

/*
Función: fn_categoria_tiene_productos_activos
Descripción: Verifica si una categoría posee productos activos asociados
*/
DELIMITER $$
CREATE FUNCTION fn_categoria_tiene_productos_activos(p_id_categoria INT)
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM producto
        WHERE id_categoria = p_id_categoria 
			AND estado = 1
    );
END$$
DELIMITER ; -- funciona

/*
Función: fn_unidad_tiene_productos
Descripción: Verifica si una unidad posee productos
*/
DELIMITER $$
CREATE FUNCTION fn_unidad_de_medida_tiene_productos(p_id_unidad INT)
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM producto
        WHERE id_unidad_de_medida = p_id_unidad
    );
END$$
DELIMITER ; -- funciona
-- ========================================================================================================================================
--                PROCEDIEMIENTOS    -----ROL-----ROL-----ROL-----ROL-----ROL-----ROL
-- ========================================================================================================================================
DELIMITER $$
CREATE PROCEDURE sp_rol_crear(
    IN  r_nombre      VARCHAR(100),
    IN  r_descripcion TEXT,
    OUT r_resultado   VARCHAR(200)
)
BEGIN
    IF fn_rol_nombre_existe(TRIM(r_nombre)) THEN
        SET r_resultado = 'ERROR: Ya existe un rol con ese nombre.';
    ELSEIF fn_rol_descripcion_existe(TRIM(r_descripcion)) THEN
        SET r_resultado = 'ERROR: Ya existe un rol con esa descripción.';
    ELSEIF r_nombre IS NULL OR TRIM(r_nombre) = '' THEN
        SET r_resultado = 'ERROR: El nombre del rol es obligatorio.';
    ELSEIF r_descripcion IS NULL OR TRIM(r_descripcion) = '' THEN
        SET r_resultado = 'ERROR: La descripción del rol es obligatoria.';
    ELSE
        INSERT INTO rol (nombre, descripcion)
        VALUES (TRIM(r_nombre), TRIM(r_descripcion));
        SET r_resultado = 'OK: Rol creado';
    END IF;
END$$
DELIMITER ; -- funciona

DELIMITER $$
CREATE PROCEDURE sp_rol_editar(
    IN  r_id_rol      INT,
    IN  r_nombre      VARCHAR(100),
    IN  r_descripcion TEXT,
    OUT r_resultado   VARCHAR(200)
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM rol
        WHERE LOWER(nombre) = LOWER(TRIM(r_nombre)) AND id_rol != r_id_rol
    ) THEN
        SET r_resultado = 'ERROR: Ya existe un rol con ese nombre.';
    ELSEIF EXISTS (
        SELECT 1 FROM rol
        WHERE LOWER(descripcion) = LOWER(TRIM(r_descripcion)) AND id_rol != r_id_rol
    ) THEN
        SET r_resultado = 'ERROR: Ya existe un rol con esa descripción.';
    ELSE
        UPDATE rol
        SET
            nombre      = IF(r_nombre      IS NULL OR TRIM(r_nombre)      = '', nombre,      TRIM(r_nombre)),
            descripcion = IF(r_descripcion IS NULL OR TRIM(r_descripcion) = '', descripcion, TRIM(r_descripcion))
        WHERE id_rol = r_id_rol;
        SET r_resultado = IF(
            (r_nombre IS NULL OR TRIM(r_nombre) = '') AND (r_descripcion IS NULL OR TRIM(r_descripcion) = ''),
            'OK: Ningún cambio realizado',
            'OK: Rol actualizado'
        );
    END IF;
END$$
DELIMITER ; -- funciona

DELIMITER $$
CREATE PROCEDURE sp_rol_cambiar_estado(
    IN  r_id_rol    INT,
    IN  r_estado    TINYINT,
    OUT r_resultado VARCHAR(200)
)
BEGIN
    UPDATE rol SET estado = r_estado WHERE id_rol = r_id_rol;
    SET r_resultado = IF(r_estado = 1, 'OK: Rol activado.', 'OK: Rol inactivado.');
END$$
DELIMITER ; -- funciona

-- ========================================================================================================================================
--                PROCEDIEMIENTOS    -----USUARIO-----USUARIO-----USUARIO-----USUARIO-----USUARIO
-- ========================================================================================================================================
DELIMITER $$
CREATE PROCEDURE sp_usuario_crear(
    IN  u_id_rol   INT,
    IN  u_nombre   VARCHAR(100),
    IN  u_correo   VARCHAR(150),
    IN  u_password VARCHAR(100),
    OUT u_resultado VARCHAR(200)
)
BEGIN
    IF u_id_rol IS NULL OR NOT EXISTS (SELECT 1 FROM rol WHERE id_rol = u_id_rol) THEN
        SET u_resultado = 'ERROR: El rol seleccionado no existe.';
    ELSEIF u_nombre IS NULL OR TRIM(u_nombre) = '' THEN
        SET u_resultado = 'ERROR: El nombre del usuario es obligatorio.';
    ELSEIF u_correo IS NULL OR TRIM(u_correo) = '' THEN
        SET u_resultado = 'ERROR: El correo del usuario es obligatorio.';
    ELSEIF fn_usuario_correo_existe(TRIM(u_correo)) THEN
        SET u_resultado = 'ERROR: Ya existe un usuario con ese correo.';
    ELSEIF u_password IS NULL OR TRIM(u_password) = '' THEN
        SET u_resultado = 'ERROR: El password del usuario es obligatorio.';
    ELSEIF NOT fn_usuario_password_valido(TRIM(u_password)) THEN
        SET u_resultado = 'ERROR: El password debe contener letras y numeros.';
    ELSE
        INSERT INTO usuario (id_rol, nombre, correo, password)
        VALUES (u_id_rol, TRIM(u_nombre), TRIM(u_correo), TRIM(u_password));
        SET u_resultado = 'OK: Usuario creado';
    END IF;
END$$
DELIMITER ; -- funciona

DELIMITER $$
CREATE PROCEDURE sp_usuario_editar(
    IN  u_id_usuario INT,
    IN  u_id_rol     INT,
    IN  u_nombre     VARCHAR(100),
    IN  u_correo     VARCHAR(150),
    IN  u_password   VARCHAR(100),
    OUT u_resultado  VARCHAR(200)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM usuario WHERE id_usuario = u_id_usuario) THEN
        SET u_resultado = 'ERROR: Usuario no encontrado.';
    ELSEIF u_id_rol IS NOT NULL AND NOT EXISTS (SELECT 1 FROM rol WHERE id_rol = u_id_rol) THEN
        SET u_resultado = 'ERROR: El rol seleccionado no existe.';
    ELSEIF u_correo IS NOT NULL AND TRIM(u_correo) != '' AND EXISTS (
        SELECT 1 FROM usuario
        WHERE LOWER(correo) = LOWER(TRIM(u_correo)) AND id_usuario != u_id_usuario
    ) THEN
        SET u_resultado = 'ERROR: Ya existe un usuario con ese correo.';
    ELSEIF u_password IS NOT NULL AND TRIM(u_password) != '' AND NOT fn_usuario_password_valido(TRIM(u_password)) THEN
        SET u_resultado = 'ERROR: El password debe contener letras y numeros.';
    ELSE
        UPDATE usuario
        SET
            id_rol   = IF(u_id_rol IS NULL, id_rol, u_id_rol),
            nombre   = IF(u_nombre   IS NULL OR TRIM(u_nombre)   = '', nombre,   TRIM(u_nombre)),
            correo   = IF(u_correo   IS NULL OR TRIM(u_correo)   = '', correo,   TRIM(u_correo)),
            password = IF(u_password IS NULL OR TRIM(u_password) = '', password, TRIM(u_password))
        WHERE id_usuario = u_id_usuario;
        SET u_resultado = IF(
            (u_id_rol IS NULL) AND
            (u_nombre IS NULL OR TRIM(u_nombre) = '') AND
            (u_correo IS NULL OR TRIM(u_correo) = '') AND
            (u_password IS NULL OR TRIM(u_password) = ''),
            'OK: Ningun cambio realizado',
            'OK: Usuario actualizado'
        );
    END IF;
END$$
DELIMITER ; -- funciona

DELIMITER $$
CREATE PROCEDURE sp_usuario_cambiar_estado(
    IN  u_id_usuario INT,
    IN  u_estado     TINYINT,
    OUT u_resultado  VARCHAR(200)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM usuario WHERE id_usuario = u_id_usuario) THEN
        SET u_resultado = 'ERROR: Usuario no encontrado.';
    ELSE
        UPDATE usuario SET estado = u_estado WHERE id_usuario = u_id_usuario;
        SET u_resultado = IF(u_estado = 1, 'OK: Usuario activado.', 'OK: Usuario inactivado.');
    END IF;
END$$
DELIMITER ; -- funciona

-- ========================================================================================================================================
--                PROCEDIEMIENTOS    -----VENTA-----VENTA-----VENTA-----VENTA-----VENTA
-- ========================================================================================================================================
DELIMITER $$
CREATE PROCEDURE sp_venta_crear(
    IN  v_id_usuario INT,
    OUT v_id_venta   INT,
    OUT v_resultado  VARCHAR(200)
)
BEGIN
    IF v_id_usuario IS NULL OR NOT EXISTS (SELECT 1 FROM usuario WHERE id_usuario = v_id_usuario) THEN
        SET v_id_venta = NULL;
        SET v_resultado = 'ERROR: El usuario no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM usuario WHERE id_usuario = v_id_usuario AND estado = 1) THEN
        SET v_id_venta = NULL;
        SET v_resultado = 'ERROR: El usuario esta inactivo.';
    ELSE
        INSERT INTO venta (id_usuario) VALUES (v_id_usuario);
        SET v_id_venta = LAST_INSERT_ID();
        SET v_resultado = 'OK: Venta creada';
    END IF;
END$$
DELIMITER ; -- funciona

DELIMITER $$
CREATE PROCEDURE sp_detalle_venta_crear(
    IN  d_id_venta    INT,
    IN  d_id_producto INT,
    IN  d_cantidad    INT,
    OUT d_resultado   VARCHAR(200)
)
BEGIN
    DECLARE d_precio_unitario DECIMAL(10,2);
    DECLARE d_subtotal DECIMAL(10,2);

    IF d_id_venta IS NULL OR NOT EXISTS (SELECT 1 FROM venta WHERE id_venta = d_id_venta AND estado = 1) THEN
        SET d_resultado = 'ERROR: La venta no existe o esta anulada.';
    ELSEIF d_id_producto IS NULL OR NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = d_id_producto AND estado = 1) THEN
        SET d_resultado = 'ERROR: El producto no existe o esta inactivo.';
    ELSEIF d_cantidad IS NULL OR d_cantidad <= 0 THEN
        SET d_resultado = 'ERROR: La cantidad debe ser mayor que cero.';
    ELSEIF NOT fn_producto_stock_disponible(d_id_producto, d_cantidad) THEN
        SET d_resultado = 'ERROR: Stock insuficiente para la venta.';
    ELSE
        SELECT precio_venta INTO d_precio_unitario
        FROM producto
        WHERE id_producto = d_id_producto;

        SET d_subtotal = d_precio_unitario * d_cantidad;

        INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal)
        VALUES (d_id_venta, d_id_producto, d_cantidad, d_precio_unitario, d_subtotal);

        UPDATE venta
        SET total = total + d_subtotal
        WHERE id_venta = d_id_venta;

        SET d_resultado = 'OK: Detalle de venta creado';
    END IF;
END$$
DELIMITER ; -- funciona

DELIMITER $$
CREATE PROCEDURE sp_producto_reducir_stock(
    IN  p_id_producto INT,
    IN  p_cantidad    INT,
    OUT p_resultado   VARCHAR(200)
)
BEGIN
    IF p_id_producto IS NULL OR NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = p_id_producto AND estado = 1) THEN
        SET p_resultado = 'ERROR: El producto no existe o esta inactivo.';
    ELSEIF p_cantidad IS NULL OR p_cantidad <= 0 THEN
        SET p_resultado = 'ERROR: La cantidad debe ser mayor que cero.';
    ELSEIF NOT fn_producto_stock_disponible(p_id_producto, p_cantidad) THEN
        SET p_resultado = 'ERROR: Stock insuficiente para la venta.';
    ELSE
        UPDATE producto
        SET stock_actual = stock_actual - p_cantidad
        WHERE id_producto = p_id_producto;
        SET p_resultado = 'OK: Stock actualizado';
    END IF;
END$$
DELIMITER ; -- funciona

DELIMITER $$
CREATE PROCEDURE sp_venta_devolver_stock(
    IN  v_id_venta   INT,
    OUT v_resultado  VARCHAR(200)
)
BEGIN
    DECLARE terminado BOOLEAN DEFAULT FALSE;
    DECLARE d_id_producto INT;
    DECLARE d_cantidad INT;
    DECLARE cur_detalle CURSOR FOR
        SELECT id_producto, cantidad
        FROM detalle_venta
        WHERE id_venta = v_id_venta;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET terminado = TRUE;

    IF v_id_venta IS NULL OR NOT EXISTS (SELECT 1 FROM venta WHERE id_venta = v_id_venta) THEN
        SET v_resultado = 'ERROR: La venta no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM venta WHERE id_venta = v_id_venta AND estado = 1) THEN
        SET v_resultado = 'ERROR: La venta ya esta anulada.';
    ELSEIF NOT EXISTS (SELECT 1 FROM detalle_venta WHERE id_venta = v_id_venta) THEN
        SET v_resultado = 'ERROR: La venta no tiene detalle.';
    ELSE
        OPEN cur_detalle;

        leer_detalle: LOOP
            FETCH cur_detalle INTO d_id_producto, d_cantidad;
            IF terminado THEN
                LEAVE leer_detalle;
            END IF;

            UPDATE producto
            SET stock_actual = stock_actual + d_cantidad
            WHERE id_producto = d_id_producto;
        END LOOP;

        CLOSE cur_detalle;
        SET v_resultado = 'OK: Stock devuelto';
    END IF;
END$$
DELIMITER ; -- funciona

DELIMITER $$
CREATE PROCEDURE sp_venta_anular(
    IN  v_id_venta  INT,
    OUT v_resultado VARCHAR(200)
)
BEGIN
    DECLARE v_devolucion VARCHAR(200);

    IF v_id_venta IS NULL OR NOT EXISTS (SELECT 1 FROM venta WHERE id_venta = v_id_venta) THEN
        SET v_resultado = 'ERROR: La venta no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM venta WHERE id_venta = v_id_venta AND estado = 1) THEN
        SET v_resultado = 'ERROR: La venta ya esta anulada.';
    ELSE
        CALL sp_venta_devolver_stock(v_id_venta, v_devolucion);

        IF v_devolucion LIKE 'OK:%' THEN
            UPDATE venta SET estado = 0 WHERE id_venta = v_id_venta;
            SET v_resultado = 'OK: Venta anulada.';
        ELSE
            SET v_resultado = v_devolucion;
        END IF;
    END IF;
END$$
DELIMITER ; -- funciona

-- ========================================================================================================================================
--                PROCEDIEMIENTOS    -----MARCA-----MARCA-----MARCA---- -MARCA-----MARCA-----MARCA
-- ==================================== ====================================================================================================
DELIMITER $$

CREATE PROCEDURE sp_marca_crear(
    IN  m_nombre    VARCHAR(100),
    IN  m_empresa   VARCHAR(200),
    OUT m_resultado VARCHAR(200)
)
BEGIN
	IF EXISTS (
        SELECT 1 FROM marca
        WHERE LOWER(nombre) = LOWER(TRIM(m_nombre))
    ) THEN
        SET m_resultado = 'ERROR: Ya existe una marca con ese nombre.';
    ELSEIF m_nombre IS NULL OR TRIM(m_nombre) = '' THEN
        SET m_resultado = 'ERROR: El nombre de la marca es obligatorio.';
    ELSEIF m_empresa IS NULL OR TRIM(m_empresa) = '' THEN
        SET m_resultado = 'ERROR: El nombre de la empresa tras la marca es obligatorio.';
    ELSE
        INSERT INTO marca (nombre, empresa) VALUES (TRIM(m_nombre), TRIM(m_empresa));
        SET m_resultado = 'OK: Marca creada';
    END IF; 
END$$
DELIMITER ; -- funciona

DELIMITER $$
CREATE PROCEDURE sp_marca_editar(
    IN  m_id_marca  INT,
    IN  m_nombre    VARCHAR(100),
    IN  m_empresa   VARCHAR(200),
    OUT m_resultado VARCHAR(200)
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM marca
        WHERE LOWER(nombre) = LOWER(TRIM(m_nombre)) AND id_marca != m_id_marca
    ) THEN
        SET m_resultado = 'ERROR: Ya existe una marca con ese nombre.';
    ELSE
        UPDATE marca
        SET
            nombre  = IF(m_nombre  IS NULL OR TRIM(m_nombre)  = '' OR m_nombre = nombre, nombre,  TRIM(m_nombre)),
            empresa = IF(m_empresa IS NULL OR TRIM(m_empresa) = '' OR m_empresa = empresa, empresa, TRIM(m_empresa))
        WHERE id_marca = m_id_marca;
        SET m_resultado = IF((m_nombre IS NULL OR TRIM(m_nombre) = '') AND (m_empresa IS NULL OR TRIM(m_empresa) = ''), 'OK: Ningún cambio realizado', 'OK: Marca actualizada');
    END IF;
END$$
DELIMITER ; -- funciona pero no da el mensaje "OK: Ningún cambio realizado" cuando el nombre de la marca y empresa son iguales al original

DELIMITER $$
CREATE PROCEDURE sp_marca_cambiar_estado(
    IN  m_id_marca  INT,
    IN  m_estado    TINYINT,
    OUT m_resultado VARCHAR(200)
)
BEGIN
    IF m_estado = 0 AND fn_marca_tiene_productos_activos(m_id_marca) THEN
        SET m_resultado = 'ERROR: No se puede inactivar una marca con productos activos.';
    ELSE
        UPDATE marca SET estado = m_estado WHERE id_marca = m_id_marca;
        SET m_resultado = IF(m_estado = 1, 'OK: Marca activada.', 'OK: Marca inactivada.');
    END IF;
END$$
DELIMITER ; -- probada solo la parte de activar/inactivar sin considerar productos


-- ========================================================================================================================================
--                PROCEDIEMIENTOS  --------- CATEGORÍA---------- CATEGORÍA------- CATEGORÍA-----
-- =======================================================================================================================================

DELIMITER $$
CREATE PROCEDURE sp_categoria_crear(
    IN  c_nombre      VARCHAR(100),
    IN  c_descripcion TEXT,
    OUT c_resultado   VARCHAR(200)
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM categoria
        WHERE LOWER(nombre) = LOWER(TRIM(c_nombre))
    ) THEN
        SET c_resultado = 'ERROR: Ya existe una categoría con ese nombre.';
    ELSEIF c_nombre IS NULL OR TRIM(c_nombre) = '' THEN
        SET c_resultado = 'ERROR: El nombre de la categoría es obligatoria.';
    ELSEIF c_descripcion IS NULL OR TRIM(c_descripcion) = '' THEN
        SET c_resultado = 'ERROR: La descripción de la categoría es obligatoria.';
    ELSE
        INSERT INTO categoria (nombre, descripcion) VALUES (TRIM(c_nombre), c_descripcion);
        SET c_resultado = 'OK: Categoría creada';
    END IF;
END$$
DELIMITER ; -- funciona

DELIMITER $$
CREATE PROCEDURE sp_categoria_editar(
    IN  c_id_categoria INT,
    IN  c_nombre       VARCHAR(100),
    IN  c_descripcion  TEXT,
    OUT c_resultado    VARCHAR(200)
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM categoria
        WHERE LOWER(nombre) = LOWER(TRIM(c_nombre)) AND id_categoria != c_id_categoria
    ) THEN
        SET c_resultado = 'ERROR: Ya existe una categoría con ese nombre.';
    ELSE
        UPDATE categoria 
	SET 
		nombre = IF(c_nombre  IS NULL OR TRIM(c_nombre)  = '', nombre,  TRIM(c_nombre)), 
		descripcion = IF(c_descripcion IS NULL OR TRIM(c_descripcion) = '', descripcion, TRIM(c_descripcion))
	WHERE id_categoria = c_id_categoria;
	SET c_resultado = IF(
		(c_nombre IS NULL OR TRIM(c_nombre) = '') AND (c_descripcion IS NULL OR TRIM(c_descripcion) = ''), 
		'OK: Ningún cambio realizado', 'OK: Categoría actualizada'
	);
    END IF;
END$$
DELIMITER ; -- funciona pero no da el mensaje "OK: Ningún cambio realizado" cuando el nombre de la categoría y descripción son iguales al original

DELIMITER $$
CREATE PROCEDURE sp_categoria_cambiar_estado(
    IN  p_id_categoria INT,
    IN  p_estado       TINYINT,
    OUT p_resultado    VARCHAR(200)
)
BEGIN
    IF p_estado = 0 AND fn_categoria_tiene_productos_activos(p_id_categoria) THEN
        SET p_resultado = 'ERROR: No se puede inactivar una categoría con productos activos.';
    ELSE
        UPDATE categoria SET estado = p_estado WHERE id_categoria = p_id_categoria;
        SET p_resultado = IF(p_estado = 1, 'OK: Categoría activada.', 'OK: Categoría inactivada.');
    END IF;
END$$
DELIMITER ;  -- probada solo la parte de activar/inactivar sin considerar productos

-- ========================================================================================================================================
--                PROCEDIEMIENTOs  ---------- UNIDAD DE MEDIDA---------- UNIDAD DE MEDIDA------- UNIDAD DE MEDIDA---
-- ===================================== ==================================================================================================

DELIMITER $$
CREATE PROCEDURE sp_unidad_de_medida_crear(
    IN  um_nombre      VARCHAR(100),
    IN  um_abreviacion VARCHAR(10),
    IN  um_descripcion TEXT,
    OUT um_resultado   VARCHAR(200)
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM unidad_de_medida
        WHERE LOWER(nombre) = LOWER(TRIM(um_nombre))
    ) THEN
        SET um_resultado = 'ERROR: Ya existe una unidad de medida con ese nombre.';
    ELSEIF um_nombre IS NULL OR TRIM(um_nombre) = '' THEN
        SET um_resultado = 'ERROR: El nombre de la unidad es obligatorio.';
    ELSEIF um_abreviacion IS NULL OR TRIM(um_abreviacion) = '' THEN
        SET um_resultado = 'ERROR: La abreviación es obligatoria.';
    ELSE
        INSERT INTO unidad_de_medida (nombre, abreviacion, descripcion)
        VALUES (TRIM(um_nombre), TRIM(um_abreviacion), um_descripcion);
        SET um_resultado = 'OK: Unidad de medida creada';
    END IF;
END$$
DELIMITER ; -- funciona

DELIMITER $$
CREATE PROCEDURE sp_unidad_de_medida_editar(
    IN  um_id_unidad_de_medida   INT,
    IN  um_nombre      VARCHAR(100),
    IN  um_abreviacion VARCHAR(10),
    IN  um_descripcion TEXT,
    OUT um_resultado   VARCHAR(200)
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM unidad_de_medida
        WHERE LOWER(nombre) = LOWER(TRIM(um_nombre)) AND id_unidad_de_medida != um_id_unidad_de_medida
    ) THEN
        SET um_resultado = 'ERROR: Ya existe una unidad de medida con ese nombre.';
    ELSE
        UPDATE unidad_de_medida 
	SET 
		nombre = IF(um_nombre  IS NULL OR TRIM(um_nombre)  = '', nombre,  TRIM(um_nombre)), 
		abreviacion = IF(um_abreviacion IS NULL OR TRIM(um_abreviacion)  = '', abreviacion,  TRIM(um_abreviacion)),
		descripcion = IF(um_descripcion IS NULL OR TRIM(um_descripcion)  = '', descripcion,  TRIM(um_descripcion))
	WHERE id_unidad_de_medida = um_id_unidad_de_medida;
	SET um_resultado = IF((um_nombre IS NULL OR TRIM(um_nombre) = '') AND (um_abreviacion IS NULL OR TRIM(um_abreviacion) = '') AND (um_descripcion IS NULL OR TRIM(um_descripcion) = ''), 'OK: Ningún cambio realizado', 'OK: Unidad de medida actualizada');
    END IF;
END$$
DELIMITER ; -- funciona pero no da el mensaje "OK: Ningún cambio realizado" cuando el nombre de la UM, la abreviación y descripción son iguales al original


DELIMITER $$
CREATE PROCEDURE sp_unidad_de_medida_cambiar_estado(
    IN  um_id_unidad_de_medida INT,
    IN  um_estado    TINYINT,
    OUT um_resultado VARCHAR(200)
)
BEGIN
    IF um_estado = 0 AND fn_unidad_de_medida_tiene_productos(um_id_unidad_de_medida) THEN
        SET um_resultado = 'ERROR: No se puede inactivar una unidad con productos asociados.';
    ELSE
        UPDATE unidad_de_medida SET estado = um_estado WHERE id_unidad_de_medida = um_id_unidad_de_medida;
        SET um_resultado = IF(um_estado = 1, 'OK: Unidad activada.', 'OK: Unidad inactivada.');
    END IF;
END$$
DELIMITER ; -- probada solo la parte de activar/inactivar sin considerar productos


-- ========================================================================================================================================
--                PROCEDIEMIENTOS  ---------- PRODUCTO--------- PRODUCTO------- PRODUCTO--- - PRODUCTO---- PRODUCTO---- PRODUCTO---- 
-- ===================================== ==================================================================================================

DELIMITER $$
CREATE PROCEDURE sp_producto_crear(
    IN  p_id_marca            INT,
    IN  p_id_categoria        INT,
    IN  p_id_unidad_de_medida INT,
    IN  p_nombre              VARCHAR(100),
    IN  p_stock_actual        INT,
    IN  p_stock_minimo        INT,
    IN  p_precio_venta        DECIMAL(10,2),
    OUT p_resultado           VARCHAR(200)
)
BEGIN
	DECLARE v_codigo_barras VARCHAR(13);
    
    IF EXISTS (
        SELECT 1 FROM producto
        WHERE LOWER(nombre) = LOWER(TRIM(p_nombre))
    ) THEN
        SET p_resultado = 'ERROR: Ya existe una producto con ese nombre.';
    ELSEIF p_nombre IS NULL OR TRIM(p_nombre) = '' THEN
        SET p_resultado = 'ERROR: El nombre del producto es obligatorio.';
	ELSEIF p_id_marca IS NULL THEN
		SET p_resultado = 'ERROR: La marca del producto es obligatoria.';
	ELSEIF p_id_categoria IS NULL THEN
		SET p_resultado = 'ERROR: La categoría del producto es obligatoria.';
	ELSEIF p_id_unidad_de_medida IS NULL THEN
		SET p_resultado = 'ERROR: La unidad de medida del producto es obligatoria';
    ELSEIF p_stock_actual IS NULL OR p_stock_actual < 0 THEN
        SET p_resultado = 'ERROR: El stock actual es obligatorio.';
	ELSEIF p_stock_minimo IS NULL OR p_stock_minimo < 0 THEN
		SET p_resultado = 'ERROR: El stock mínimo tiene que ser mayor o igual que 0.';
    ELSEIF p_precio_venta IS NULL OR p_precio_venta <= 0 THEN
        SET p_resultado = 'ERROR: El precio de venta incorrecto.';
	ELSE
        SET v_codigo_barras = fn_generar_codigo_barras();
    INSERT INTO producto
            (id_marca, id_categoria, id_unidad_de_medida, nombre, stock_actual, stock_minimo, precio_venta, codigo_barras)
        VALUES
            (p_id_marca, p_id_categoria, p_id_unidad_de_medida,
             TRIM(p_nombre), p_stock_actual, IFNULL(p_stock_minimo, 0), p_precio_venta, v_codigo_barras);
 
        SET p_resultado = 'OK: Producto creado';
    END IF;
END$$
DELIMITER ; -- funciona

DELIMITER $$
CREATE PROCEDURE sp_producto_editar(
    IN  p_id_producto         INT,
    IN  p_id_marca            INT,
    IN  p_id_categoria        INT,
    IN  p_id_unidad_de_medida INT,
    IN  p_nombre              VARCHAR(100),
    IN  p_stock_actual        INT,
    IN  p_stock_minimo        INT,
    IN  p_precio_venta        DECIMAL(10,2),
    IN  p_codigo_barras		  VARCHAR(13),
    OUT p_resultado           VARCHAR(200)
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM producto
        WHERE LOWER(nombre) = LOWER(TRIM(p_nombre)) AND id_producto != p_id_producto
    ) THEN
        SET p_resultado = 'ERROR: Ya existe una producto con ese nombre.';
	ELSEIF p_codigo_barras IS NOT NULL AND TRIM(p_codigo_barras) != '' AND EXISTS (
        SELECT 1 FROM producto
        WHERE codigo_barras = TRIM(p_codigo_barras) AND id_producto != p_id_producto
    ) THEN
        SET p_resultado = 'ERROR: Ya existe un producto con ese código de barras.';
    ELSE
        UPDATE producto
        SET 
			id_marca            = IF(p_id_marca            IS NULL,                          id_marca,     p_id_marca),
            id_categoria        = IF(p_id_categoria        IS NULL, id_categoria,                      p_id_categoria),
            id_unidad_de_medida = IF(p_id_unidad_de_medida IS NULL, id_unidad_de_medida,        p_id_unidad_de_medida),
            nombre              = IF(p_nombre             IS NULL OR TRIM(p_nombre)  = '', nombre,  TRIM(p_nombre)),
            precio_venta        = IF(p_precio_venta        IS NULL, precio_venta,                      p_precio_venta),
            codigo_barras       = IF(p_codigo_barras IS NULL OR TRIM(p_codigo_barras) = '', codigo_barras, TRIM(p_codigo_barras))
        WHERE id_producto = p_id_producto;
        SET p_resultado = IF(
			(p_id_marca IS NULL) AND (p_id_categoria IS NULL) AND (p_id_unidad_de_medida IS NULL) AND
            (p_nombre IS NULL OR TRIM(p_nombre)  = '') AND
            (p_precio_venta IS NULL), 'OK: Producto sin cambios.','OK: Producto actualizado correctamente.'
		);
    END IF;
END$$
DELIMITER ; -- funciona pero no da el mensaje "OK: Ningún cambio realizado" cuando todos los campos son iguales al original

DELIMITER $$
CREATE PROCEDURE sp_producto_cambiar_estado(
    IN  p_id_producto INT,
    IN  p_estado      TINYINT,
    OUT p_resultado   VARCHAR(200)
)
BEGIN
    DECLARE p_id_marca            INT;
    DECLARE p_id_categoria        INT;
 
    IF p_estado = 1 THEN
            SELECT id_marca, id_categoria
            INTO p_id_marca, p_id_categoria
            FROM producto WHERE id_producto = p_id_producto;
 
            IF (select m.estado from marca m where m.id_marca = p_id_marca) = 0 THEN
                UPDATE marca SET estado = 1 WHERE id_marca = p_id_marca AND estado = 0;
            END IF;
            IF (select c.estado from categoria c where c.id_categoria = p_id_categoria) = 0 THEN
                UPDATE categoria SET estado = 1 WHERE id_categoria = p_id_categoria AND estado = 0;
            END IF;
        END IF;
 
        UPDATE producto SET estado = p_estado WHERE id_producto = p_id_producto;
        SET p_resultado = IF(p_estado = 1, 'OK: Producto activado.', 'OK: Producto inactivado.');
END$$
DELIMITER ; -- funciona

-- ========================================================================================================================================
--                FUNCIONES    -----INVENTARIO-----INVENTARIO-----INVENTARIO-----INVENTARIO-----INVENTARIO
-- ========================================================================================================================================

-- Verifica si un proveedor existe y está activo
DELIMITER $$
CREATE FUNCTION fn_proveedor_activo(p_id_proveedor INT)
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM proveedor
        WHERE id_proveedor = p_id_proveedor AND estado = 1
    );
END$$
DELIMITER ;

-- Verifica si una entrada existe
DELIMITER $$
CREATE FUNCTION fn_entrada_existe(p_id_entrada INT)
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM entrada
        WHERE id_entrada = p_id_entrada
    );
END$$
DELIMITER ;

-- Verifica si un producto está activo y disponible para agregar a una entrada
DELIMITER $$
CREATE FUNCTION fn_producto_activo(p_id_producto INT)
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM producto
        WHERE id_producto = p_id_producto AND estado = 1
    );
END$$
DELIMITER ;

-- Verifica si un ajuste negativo supera el stock actual del producto
DELIMITER $$
CREATE FUNCTION fn_ajuste_negativo_valido(p_id_producto INT, p_cantidad INT)
RETURNS BOOLEAN
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM producto
        WHERE id_producto = p_id_producto
          AND stock_actual >= ABS(p_cantidad)
    );
END$$
DELIMITER ;

-- ========================================================================================================================================
--                PROCEDIMIENTOS    -----PROVEEDOR-----PROVEEDOR-----PROVEEDOR-----PROVEEDOR-----PROVEEDOR
-- ========================================================================================================================================

DELIMITER $$
CREATE PROCEDURE sp_proveedor_crear(
    IN  p_nombre    VARCHAR(150),
    IN  p_contacto  VARCHAR(100),
    IN  p_telefono  VARCHAR(20),
    OUT p_resultado VARCHAR(200)
)
BEGIN
    IF p_nombre IS NULL OR TRIM(p_nombre) = '' THEN
        SET p_resultado = 'ERROR: El nombre del proveedor es obligatorio.';
    ELSEIF EXISTS (
        SELECT 1 FROM proveedor
        WHERE LOWER(nombre) = LOWER(TRIM(p_nombre))
    ) THEN
        SET p_resultado = 'ERROR: Ya existe un proveedor con ese nombre.';
    ELSE
        INSERT INTO proveedor (nombre, contacto, telefono)
        VALUES (TRIM(p_nombre), TRIM(p_contacto), TRIM(p_telefono));
        SET p_resultado = 'OK: Proveedor creado.';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_proveedor_editar(
    IN  p_id_proveedor INT,
    IN  p_nombre       VARCHAR(150),
    IN  p_contacto     VARCHAR(100),
    IN  p_telefono     VARCHAR(20),
    OUT p_resultado    VARCHAR(200)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM proveedor WHERE id_proveedor = p_id_proveedor) THEN
        SET p_resultado = 'ERROR: El proveedor no existe.';
    ELSEIF EXISTS (
        SELECT 1 FROM proveedor
        WHERE LOWER(nombre) = LOWER(TRIM(p_nombre)) AND id_proveedor != p_id_proveedor
    ) THEN
        SET p_resultado = 'ERROR: Ya existe un proveedor con ese nombre.';
    ELSE
        UPDATE proveedor
        SET
            nombre   = IF(p_nombre   IS NULL OR TRIM(p_nombre)   = '', nombre,   TRIM(p_nombre)),
            contacto = IF(p_contacto IS NULL OR TRIM(p_contacto) = '', contacto, TRIM(p_contacto)),
            telefono = IF(p_telefono IS NULL OR TRIM(p_telefono) = '', telefono, TRIM(p_telefono))
        WHERE id_proveedor = p_id_proveedor;
        SET p_resultado = IF(
            (p_nombre   IS NULL OR TRIM(p_nombre)   = '') AND
            (p_contacto IS NULL OR TRIM(p_contacto) = '') AND
            (p_telefono IS NULL OR TRIM(p_telefono) = ''),
            'OK: Ningún cambio realizado.',
            'OK: Proveedor actualizado.'
        );
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_proveedor_cambiar_estado(
    IN  p_id_proveedor INT,
    IN  p_estado       TINYINT,
    OUT p_resultado    VARCHAR(200)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM proveedor WHERE id_proveedor = p_id_proveedor) THEN
        SET p_resultado = 'ERROR: El proveedor no existe.';
    ELSE
        UPDATE proveedor SET estado = p_estado WHERE id_proveedor = p_id_proveedor;
        SET p_resultado = IF(p_estado = 1, 'OK: Proveedor activado.', 'OK: Proveedor inactivado.');
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_buscar_proveedores_activos(
    IN p_nombre   VARCHAR(150),
    IN p_contacto VARCHAR(100)
)
BEGIN
    SELECT
        id_proveedor AS "Código",
        nombre       AS "Nombre",
        contacto     AS "Contacto",
        telefono     AS "Teléfono"
    FROM proveedor
    WHERE estado = 1
      AND (p_nombre   IS NULL OR nombre   LIKE CONCAT('%', p_nombre,   '%'))
      AND (p_contacto IS NULL OR contacto LIKE CONCAT('%', p_contacto, '%'));
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_buscar_proveedores_inactivos(
    IN p_nombre   VARCHAR(150),
    IN p_contacto VARCHAR(100)
)
BEGIN
    SELECT
        id_proveedor AS "Código",
        nombre       AS "Nombre",
        contacto     AS "Contacto",
        telefono     AS "Teléfono"
    FROM proveedor
    WHERE estado = 0
      AND (p_nombre   IS NULL OR nombre   LIKE CONCAT('%', p_nombre,   '%'))
      AND (p_contacto IS NULL OR contacto LIKE CONCAT('%', p_contacto, '%'));
END$$
DELIMITER ;

-- ========================================================================================================================================
--                PROCEDIMIENTOS    -----ENTRADA-----ENTRADA-----ENTRADA-----ENTRADA-----ENTRADA
-- ========================================================================================================================================

-- Crea el encabezado de una entrada, retorna el id generado para agregar el detalle
DELIMITER $$
CREATE PROCEDURE sp_entrada_crear(
    IN  e_id_proveedor INT,
    IN  e_id_usuario   INT,
    OUT e_id_entrada   INT,
    OUT e_resultado    VARCHAR(200)
)
BEGIN
    IF e_id_proveedor IS NULL OR NOT fn_proveedor_activo(e_id_proveedor) THEN
        SET e_id_entrada = NULL;
        SET e_resultado  = 'ERROR: El proveedor no existe o está inactivo.';
    ELSEIF e_id_usuario IS NULL OR NOT EXISTS (SELECT 1 FROM usuario WHERE id_usuario = e_id_usuario AND estado = 1) THEN
        SET e_id_entrada = NULL;
        SET e_resultado  = 'ERROR: El usuario no existe o está inactivo.';
    ELSE
        INSERT INTO entrada (id_proveedor, id_usuario)
        VALUES (e_id_proveedor, e_id_usuario);
        SET e_id_entrada = LAST_INSERT_ID();
        SET e_resultado  = 'OK: Entrada creada.';
    END IF;
END$$
DELIMITER ;

-- Agrega un producto al detalle de una entrada e incrementa el stock del producto
DELIMITER $$
CREATE PROCEDURE sp_detalle_entrada_crear(
    IN  d_id_entrada   INT,
    IN  d_id_producto  INT,
    IN  d_cantidad     INT,
    IN  d_precio_costo DECIMAL(10,2),
    OUT d_resultado    VARCHAR(200)
)
BEGIN
    DECLARE d_subtotal_costo DECIMAL(10,2);

    IF d_id_entrada IS NULL OR NOT fn_entrada_existe(d_id_entrada) THEN
        SET d_resultado = 'ERROR: La entrada no existe.';
    ELSEIF d_id_producto IS NULL OR NOT fn_producto_activo(d_id_producto) THEN
        SET d_resultado = 'ERROR: El producto no existe o está inactivo.';
    ELSEIF d_cantidad IS NULL OR d_cantidad <= 0 THEN
        SET d_resultado = 'ERROR: La cantidad debe ser mayor que cero.';
    ELSEIF d_precio_costo IS NULL OR d_precio_costo <= 0 THEN
        SET d_resultado = 'ERROR: El precio de costo debe ser mayor que cero.';
    ELSE
        SET d_subtotal_costo = d_cantidad * d_precio_costo;

        INSERT INTO detalle_entrada (id_entrada, id_producto, cantidad, precio_costo, subtotal_costo)
        VALUES (d_id_entrada, d_id_producto, d_cantidad, d_precio_costo, d_subtotal_costo);

        UPDATE producto
        SET stock_actual = stock_actual + d_cantidad
        WHERE id_producto = d_id_producto;

        UPDATE entrada
        SET total_costo = total_costo + d_subtotal_costo
        WHERE id_entrada = d_id_entrada;

        INSERT INTO movimiento_inventario (id_tipo_movimiento, id_producto, id_usuario, id_referencia, cantidad)
        SELECT 2, d_id_producto, e.id_usuario, d_id_entrada, d_cantidad
        FROM entrada e WHERE e.id_entrada = d_id_entrada;

        SET d_resultado = 'OK: Detalle de entrada registrado.';
    END IF;
END$$
DELIMITER ;

-- Edita el detalle de una entrada existente, registra la auditoría y ajusta el stock
DELIMITER $$
CREATE PROCEDURE sp_entrada_editar(
    IN  e_id_entrada          INT,
    IN  e_id_detalle_entrada  INT,
    IN  e_id_usuario          INT,
    IN  e_nueva_cantidad      INT,
    IN  e_nuevo_precio_costo  DECIMAL(10,2),
    IN  e_motivo              TEXT,
    OUT e_resultado           VARCHAR(200)
)
BEGIN
    DECLARE v_cantidad_anterior     INT;
    DECLARE v_precio_costo_anterior DECIMAL(10,2);
    DECLARE v_subtotal_anterior     DECIMAL(10,2);
    DECLARE v_nuevo_subtotal        DECIMAL(10,2);
    DECLARE v_diferencia_cantidad   INT;
    DECLARE v_diferencia_subtotal   DECIMAL(10,2);
    DECLARE v_id_producto           INT;
    DECLARE v_info_modificada       TEXT;

    IF NOT fn_entrada_existe(e_id_entrada) THEN
        SET e_resultado = 'ERROR: La entrada no existe.';
    ELSEIF NOT EXISTS (
        SELECT 1 FROM detalle_entrada
        WHERE id_detalle_entrada = e_id_detalle_entrada AND id_entrada = e_id_entrada
    ) THEN
        SET e_resultado = 'ERROR: El detalle no pertenece a la entrada indicada.';
    ELSEIF e_motivo IS NULL OR TRIM(e_motivo) = '' THEN
        SET e_resultado = 'ERROR: El motivo de la modificación es obligatorio.';
    ELSEIF e_nueva_cantidad IS NOT NULL AND e_nueva_cantidad <= 0 THEN
        SET e_resultado = 'ERROR: La cantidad debe ser mayor que cero.';
    ELSEIF e_nuevo_precio_costo IS NOT NULL AND e_nuevo_precio_costo <= 0 THEN
        SET e_resultado = 'ERROR: El precio de costo debe ser mayor que cero.';
    ELSE
        SELECT id_producto, cantidad, precio_costo, subtotal_costo
        INTO v_id_producto, v_cantidad_anterior, v_precio_costo_anterior, v_subtotal_anterior
        FROM detalle_entrada
        WHERE id_detalle_entrada = e_id_detalle_entrada;

        SET e_nueva_cantidad     = IFNULL(e_nueva_cantidad,     v_cantidad_anterior);
        SET e_nuevo_precio_costo = IFNULL(e_nuevo_precio_costo, v_precio_costo_anterior);
        SET v_nuevo_subtotal     = e_nueva_cantidad * e_nuevo_precio_costo;
        SET v_diferencia_cantidad = e_nueva_cantidad - v_cantidad_anterior;
        SET v_diferencia_subtotal = v_nuevo_subtotal  - v_subtotal_anterior;

        UPDATE detalle_entrada
        SET
            cantidad       = e_nueva_cantidad,
            precio_costo   = e_nuevo_precio_costo,
            subtotal_costo = v_nuevo_subtotal
        WHERE id_detalle_entrada = e_id_detalle_entrada;

        UPDATE producto
        SET stock_actual = stock_actual + v_diferencia_cantidad
        WHERE id_producto = v_id_producto;

        UPDATE entrada
        SET total_costo = total_costo + v_diferencia_subtotal
        WHERE id_entrada = e_id_entrada;

        SET v_info_modificada = CONCAT(
            'Cantidad: ', v_cantidad_anterior, ' → ', e_nueva_cantidad, ' | ',
            'Precio costo: ', v_precio_costo_anterior, ' → ', e_nuevo_precio_costo
        );

        INSERT INTO auditoria_entrada (id_entrada, id_usuario, informacion_modificada, motivo)
        VALUES (e_id_entrada, e_id_usuario, v_info_modificada, TRIM(e_motivo));

        INSERT INTO movimiento_inventario (id_tipo_movimiento, id_producto, id_usuario, id_referencia, cantidad)
        VALUES (4, v_id_producto, e_id_usuario, e_id_entrada, v_diferencia_cantidad);

        SET e_resultado = 'OK: Entrada actualizada y auditoría registrada.';
    END IF;
END$$
DELIMITER ;

-- Consulta el historial de entradas con filtros opcionales
DELIMITER $$
CREATE PROCEDURE sp_buscar_historial_entradas(
    IN e_id_proveedor INT,
    IN e_fecha_inicio DATE,
    IN e_fecha_fin    DATE
)
BEGIN
    SELECT
        e.id_entrada    AS "Código",
        e.fecha_entrada AS "Fecha",
        p.nombre        AS "Proveedor",
        u.nombre        AS "Registrado por",
        e.total_costo   AS "Total costo"
    FROM entrada e
    INNER JOIN proveedor p ON e.id_proveedor = p.id_proveedor
    INNER JOIN usuario   u ON e.id_usuario   = u.id_usuario
    WHERE (e_id_proveedor IS NULL OR e.id_proveedor = e_id_proveedor)
      AND (e_fecha_inicio IS NULL OR DATE(e.fecha_entrada) >= e_fecha_inicio)
      AND (e_fecha_fin    IS NULL OR DATE(e.fecha_entrada) <= e_fecha_fin)
    ORDER BY e.fecha_entrada DESC;
END$$
DELIMITER ;

-- Consulta el detalle de una entrada específica
DELIMITER $$
CREATE PROCEDURE sp_consultar_detalle_entrada(
    IN e_id_entrada INT
)
BEGIN
    IF NOT fn_entrada_existe(e_id_entrada) THEN
        SELECT 'ERROR: La entrada no existe.' AS Mensaje;
    ELSE
        SELECT
            de.id_detalle_entrada AS "Código detalle",
            p.nombre              AS "Producto",
            de.cantidad           AS "Cantidad",
            de.precio_costo       AS "Precio costo",
            de.subtotal_costo     AS "Subtotal costo"
        FROM detalle_entrada de
        INNER JOIN producto p ON de.id_producto = p.id_producto
        WHERE de.id_entrada = e_id_entrada;
    END IF;
END$$
DELIMITER ;

-- ========================================================================================================================================
--                PROCEDIMIENTOS    -----AUDITORÍA ENTRADA-----AUDITORÍA ENTRADA-----AUDITORÍA ENTRADA
-- ========================================================================================================================================

-- Consulta la auditoría de una entrada con filtros opcionales por fecha y usuario
DELIMITER $$
CREATE PROCEDURE sp_buscar_auditoria_entrada(
    IN a_id_entrada  INT,
    IN a_id_usuario  INT,
    IN a_fecha_inicio DATE,
    IN a_fecha_fin    DATE
)
BEGIN
    IF NOT fn_entrada_existe(a_id_entrada) THEN
        SELECT 'ERROR: La entrada no existe.' AS Mensaje;
    ELSE
        SELECT
            ae.id_auditoria_entrada   AS "Código",
            ae.fecha_modificacion     AS "Fecha modificación",
            u.nombre                  AS "Modificado por",
            ae.informacion_modificada AS "Qué se modificó",
            ae.motivo                 AS "Motivo"
        FROM auditoria_entrada ae
        INNER JOIN usuario u ON ae.id_usuario = u.id_usuario
        WHERE ae.id_entrada = a_id_entrada
          AND (a_id_usuario  IS NULL OR ae.id_usuario = a_id_usuario)
          AND (a_fecha_inicio IS NULL OR DATE(ae.fecha_modificacion) >= a_fecha_inicio)
          AND (a_fecha_fin    IS NULL OR DATE(ae.fecha_modificacion) <= a_fecha_fin)
        ORDER BY ae.fecha_modificacion ASC;
    END IF;
END$$
DELIMITER ;

-- ========================================================================================================================================
--                PROCEDIMIENTOS    -----AJUSTE INVENTARIO-----AJUSTE INVENTARIO-----AJUSTE INVENTARIO
-- ========================================================================================================================================

DELIMITER $$
CREATE PROCEDURE sp_ajuste_inventario_crear(
    IN  a_id_producto INT,
    IN  a_id_usuario  INT,
    IN  a_cantidad    INT,
    IN  a_motivo      TEXT,
    OUT a_resultado   VARCHAR(200)
)
BEGIN
    IF a_id_producto IS NULL OR NOT fn_producto_activo(a_id_producto) THEN
        SET a_resultado = 'ERROR: El producto no existe o está inactivo.';
    ELSEIF a_id_usuario IS NULL OR NOT EXISTS (SELECT 1 FROM usuario WHERE id_usuario = a_id_usuario AND estado = 1) THEN
        SET a_resultado = 'ERROR: El usuario no existe o está inactivo.';
    ELSEIF a_cantidad IS NULL OR a_cantidad = 0 THEN
        SET a_resultado = 'ERROR: La cantidad del ajuste no puede ser cero.';
    ELSEIF a_motivo IS NULL OR TRIM(a_motivo) = '' THEN
        SET a_resultado = 'ERROR: El motivo del ajuste es obligatorio.';
    ELSEIF a_cantidad < 0 AND NOT fn_ajuste_negativo_valido(a_id_producto, a_cantidad) THEN
        SET a_resultado = 'ERROR: El ajuste negativo supera el stock actual del producto.';
    ELSE
        UPDATE producto
        SET stock_actual = stock_actual + a_cantidad
        WHERE id_producto = a_id_producto;

        INSERT INTO ajuste_inventario (id_producto, id_usuario, cantidad, motivo)
        VALUES (a_id_producto, a_id_usuario, a_cantidad, TRIM(a_motivo));

        INSERT INTO movimiento_inventario (id_tipo_movimiento, id_producto, id_usuario, id_referencia, cantidad)
        VALUES (3, a_id_producto, a_id_usuario, LAST_INSERT_ID(), a_cantidad);

        SET a_resultado = 'OK: Ajuste de inventario registrado.';
    END IF;
END$$
DELIMITER ;

-- Consulta el historial de ajustes con filtros opcionales
DELIMITER $$
CREATE PROCEDURE sp_buscar_ajustes_inventario(
    IN a_id_producto  INT,
    IN a_fecha_inicio DATE,
    IN a_fecha_fin    DATE
)
BEGIN
    SELECT
        aj.id_ajuste    AS "Código",
        aj.fecha_ajuste AS "Fecha",
        p.nombre        AS "Producto",
        aj.cantidad     AS "Cantidad ajustada",
        u.nombre        AS "Registrado por",
        aj.motivo       AS "Motivo"
    FROM ajuste_inventario aj
    INNER JOIN producto p ON aj.id_producto = p.id_producto
    INNER JOIN usuario  u ON aj.id_usuario  = u.id_usuario
    WHERE (a_id_producto  IS NULL OR aj.id_producto = a_id_producto)
      AND (a_fecha_inicio IS NULL OR DATE(aj.fecha_ajuste) >= a_fecha_inicio)
      AND (a_fecha_fin    IS NULL OR DATE(aj.fecha_ajuste) <= a_fecha_fin)
    ORDER BY aj.fecha_ajuste DESC;
END$$
DELIMITER ;

-- ========================================================================================================================================
--                PROCEDIMIENTOS    -----HISTORIAL MOVIMIENTOS-----HISTORIAL MOVIMIENTOS-----HISTORIAL MOVIMIENTOS
-- ========================================================================================================================================

-- Consulta el historial de movimientos con filtros combinables
DELIMITER $$
CREATE PROCEDURE sp_buscar_historial_movimientos(
    IN m_id_tipo_movimiento INT,
    IN m_id_producto        INT,
    IN m_fecha_inicio       DATE,
    IN m_fecha_fin          DATE
)
BEGIN
    SELECT
        mi.id_movimiento      AS "Código",
        mi.fecha_movimiento   AS "Fecha",
        tm.nombre             AS "Tipo de movimiento",
        p.nombre              AS "Producto",
        mi.cantidad           AS "Cantidad",
        u.nombre              AS "Responsable"
    FROM movimiento_inventario mi
    INNER JOIN tipo_movimiento tm ON mi.id_tipo_movimiento = tm.id_tipo_movimiento
    INNER JOIN producto        p  ON mi.id_producto        = p.id_producto
    INNER JOIN usuario         u  ON mi.id_usuario         = u.id_usuario
    WHERE (m_id_tipo_movimiento IS NULL OR mi.id_tipo_movimiento = m_id_tipo_movimiento)
      AND (m_id_producto        IS NULL OR mi.id_producto        = m_id_producto)
      AND (m_fecha_inicio       IS NULL OR DATE(mi.fecha_movimiento) >= m_fecha_inicio)
      AND (m_fecha_fin          IS NULL OR DATE(mi.fecha_movimiento) <= m_fecha_fin)
    ORDER BY mi.fecha_movimiento DESC;
END$$
DELIMITER ;

-- ========================================================================================================================================
--                PROCEDIMIENTOS    -----CONTEO FÍSICO-----CONTEO FÍSICO-----CONTEO FÍSICO-----CONTEO FÍSICO
-- ========================================================================================================================================

-- Inicia un conteo físico cargando todos los productos activos con su stock actual
DELIMITER $$
CREATE PROCEDURE sp_conteo_fisico_iniciar(
    IN  c_id_usuario INT,
    OUT c_id_conteo  INT,
    OUT c_resultado  VARCHAR(200)
)
BEGIN
    DECLARE v_fecha_proximo DATE;

    IF c_id_usuario IS NULL OR NOT EXISTS (SELECT 1 FROM usuario WHERE id_usuario = c_id_usuario AND estado = 1) THEN
        SET c_id_conteo = NULL;
        SET c_resultado = 'ERROR: El usuario no existe o está inactivo.';
    ELSEIF NOT EXISTS (SELECT 1 FROM producto WHERE estado = 1) THEN
        SET c_id_conteo = NULL;
        SET c_resultado = 'ERROR: No hay productos activos para contar.';
    ELSE
        SET v_fecha_proximo = DATE_ADD(CURDATE(), INTERVAL 14 DAY);

        INSERT INTO conteo_fisico (id_usuario, fecha_proximo)
        VALUES (c_id_usuario, v_fecha_proximo);

        SET c_id_conteo = LAST_INSERT_ID();

        INSERT INTO detalle_conteo_fisico (id_conteo, id_producto, stock_sistema, stock_contado, diferencia)
        SELECT c_id_conteo, id_producto, stock_actual, 0, 0 - stock_actual
        FROM producto
        WHERE estado = 1;

        SET c_resultado = 'OK: Conteo físico iniciado.';
    END IF;
END$$
DELIMITER ;

-- Registra la cantidad contada físicamente para un producto dentro de un conteo
DELIMITER $$
CREATE PROCEDURE sp_detalle_conteo_registrar(
    IN  dc_id_conteo       INT,
    IN  dc_id_producto     INT,
    IN  dc_stock_contado   INT,
    OUT dc_resultado       VARCHAR(200)
)
BEGIN
    DECLARE v_stock_sistema INT;

    IF NOT EXISTS (SELECT 1 FROM conteo_fisico WHERE id_conteo = dc_id_conteo) THEN
        SET dc_resultado = 'ERROR: El conteo no existe.';
    ELSEIF NOT EXISTS (
        SELECT 1 FROM detalle_conteo_fisico
        WHERE id_conteo = dc_id_conteo AND id_producto = dc_id_producto
    ) THEN
        SET dc_resultado = 'ERROR: El producto no forma parte de este conteo.';
    ELSEIF dc_stock_contado IS NULL OR dc_stock_contado < 0 THEN
        SET dc_resultado = 'ERROR: La cantidad contada no puede ser negativa.';
    ELSE
        SELECT stock_sistema INTO v_stock_sistema
        FROM detalle_conteo_fisico
        WHERE id_conteo = dc_id_conteo AND id_producto = dc_id_producto;

        UPDATE detalle_conteo_fisico
        SET
            stock_contado = dc_stock_contado,
            diferencia    = dc_stock_contado - v_stock_sistema
        WHERE id_conteo = dc_id_conteo AND id_producto = dc_id_producto;

        SET dc_resultado = 'OK: Cantidad contada registrada.';
    END IF;
END$$
DELIMITER ;

-- Muestra las diferencias encontradas al finalizar un conteo
DELIMITER $$
CREATE PROCEDURE sp_conteo_fisico_ver_diferencias(
    IN c_id_conteo INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM conteo_fisico WHERE id_conteo = c_id_conteo) THEN
        SELECT 'ERROR: El conteo no existe.' AS Mensaje;
    ELSE
        UPDATE conteo_fisico
        SET tiene_diferencias = EXISTS (
            SELECT 1 FROM detalle_conteo_fisico
            WHERE id_conteo = c_id_conteo AND diferencia != 0
        )
        WHERE id_conteo = c_id_conteo;

        SELECT
            p.nombre                   AS "Producto",
            dcf.stock_sistema          AS "Stock en sistema",
            dcf.stock_contado          AS "Stock contado",
            dcf.diferencia             AS "Diferencia",
            dcf.ajuste_aplicado        AS "Ajuste aplicado"
        FROM detalle_conteo_fisico dcf
        INNER JOIN producto p ON dcf.id_producto = p.id_producto
        WHERE dcf.id_conteo = c_id_conteo
        ORDER BY dcf.diferencia ASC;
    END IF;
END$$
DELIMITER ;

-- Aplica el ajuste automático para un producto con diferencia en el conteo
DELIMITER $$
CREATE PROCEDURE sp_conteo_fisico_aplicar_ajuste(
    IN  c_id_conteo    INT,
    IN  c_id_producto  INT,
    IN  c_id_usuario   INT,
    OUT c_resultado    VARCHAR(200)
)
BEGIN
    DECLARE v_diferencia INT;
    DECLARE v_ajuste_resultado VARCHAR(200);

    IF NOT EXISTS (SELECT 1 FROM conteo_fisico WHERE id_conteo = c_id_conteo) THEN
        SET c_resultado = 'ERROR: El conteo no existe.';
    ELSEIF NOT EXISTS (
        SELECT 1 FROM detalle_conteo_fisico
        WHERE id_conteo = c_id_conteo AND id_producto = c_id_producto
    ) THEN
        SET c_resultado = 'ERROR: El producto no forma parte de este conteo.';
    ELSEIF EXISTS (
        SELECT 1 FROM detalle_conteo_fisico
        WHERE id_conteo = c_id_conteo AND id_producto = c_id_producto AND ajuste_aplicado = 1
    ) THEN
        SET c_resultado = 'ERROR: El ajuste ya fue aplicado para este producto.';
    ELSE
        SELECT diferencia INTO v_diferencia
        FROM detalle_conteo_fisico
        WHERE id_conteo = c_id_conteo AND id_producto = c_id_producto;

        IF v_diferencia = 0 THEN
            SET c_resultado = 'OK: No hay diferencia que ajustar para este producto.';
        ELSE
            CALL sp_ajuste_inventario_crear(c_id_producto, c_id_usuario, v_diferencia, 'conteo físico', v_ajuste_resultado);

            IF v_ajuste_resultado LIKE 'OK:%' THEN
                UPDATE detalle_conteo_fisico
                SET ajuste_aplicado = 1
                WHERE id_conteo = c_id_conteo AND id_producto = c_id_producto;
                SET c_resultado = 'OK: Ajuste aplicado desde conteo físico.';
            ELSE
                SET c_resultado = v_ajuste_resultado;
            END IF;
        END IF;
    END IF;
END$$
DELIMITER ;

-- Consulta el próximo conteo programado
DELIMITER $$
CREATE PROCEDURE sp_conteo_fisico_proximo()
BEGIN
    SELECT
        cf.id_conteo     AS "Último conteo",
        cf.fecha_conteo  AS "Fecha del último conteo",
        cf.fecha_proximo AS "Próximo conteo programado",
        u.nombre         AS "Realizado por"
    FROM conteo_fisico cf
    INNER JOIN usuario u ON cf.id_usuario = u.id_usuario
    ORDER BY cf.fecha_conteo DESC
    LIMIT 1;
END$$
DELIMITER ;
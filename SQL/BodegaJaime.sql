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

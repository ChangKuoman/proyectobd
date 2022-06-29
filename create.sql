-- Creacion de tablas

CREATE TABLE IF NOT EXISTS persona (
    dni VARCHAR(8),
    nombre VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS trabajador(
    dni VARCHAR(8),
    sueldo DOUBLE PRECISION,
    celular VARCHAR(9)
);

CREATE TABLE IF NOT EXISTS clientedelivery(
    dni VARCHAR(8),
    celular VARCHAR(9)
);

CREATE TABLE IF NOT EXISTS clientelocal(
    dni VARCHAR(8)
);

CREATE TABLE IF NOT EXISTS turno(
    dni VARCHAR(8),
    dia VARCHAR(1),
    hora_entrada TIME,
    hora_salida TIME
);

CREATE TABLE IF NOT EXISTS repartidor(
    dni VARCHAR(8),
    direccion VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS trabajadorlocal(
    dni VARCHAR(8),
    direccion VARCHAR(50),
    rol VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS local(
    direccion VARCHAR(50),
    aforo SMALLINT,
    nombre VARCHAR(50),
    telefono VARCHAR(9)
);

CREATE TABLE IF NOT EXISTS caja(
    direccion VARCHAR(50),
    numero SMALLINT
);


CREATE TABLE IF NOT EXISTS producto (
    nombre_producto VARCHAR(30),
    medida VARCHAR(20),
    precio_unitario DECIMAL
);

CREATE TABLE IF NOT EXISTS empresa (
    ruc VARCHAR(11),
    razon_social VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS compra (
    correlativo INTEGER,
    fecha_hora TIMESTAMP,
    metodo_pago VARCHAR(10),
    total DECIMAL
);

CREATE TABLE IF NOT EXISTS delivery (
    correlativo INTEGER,
    Rdni VARCHAR(8),
    Cdni VARCHAR(8),
    direccion VARCHAR(50),
    costo_envio SMALLINT,
    fecha_hora_delivery TIMESTAMP
);

CREATE TABLE IF NOT EXISTS compralocal (
    correlativo INTEGER,
    numero SMALLINT,
    direccion VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS itemcompra (
    nombre_producto VARCHAR(30),
    medida VARCHAR(20),
    correlativo INTEGER,
    cantidad INTEGER,
    subtotal DECIMAL
);

CREATE TABLE IF NOT EXISTS stock (
    nombre_producto VARCHAR (30),
    medida VARCHAR(20),
    direccion VARCHAR(50),
    cantidad INTEGER
);

CREATE TABLE IF NOT EXISTS entregaproductos (
    nombre_producto VARCHAR(30),
    medida VARCHAR(20),
    direccion VARCHAR(50),
    ruc VARCHAR(11),
    fecha DATE,
    cantidad INTEGER
);

CREATE TABLE IF NOT EXISTS boleta (
    correlativo INTEGER,
    dni VARCHAR(8)
);

CREATE TABLE IF NOT EXISTS factura (
    correlativo INTEGER,
    ruc VARCHAR(11)
);

CREATE TABLE IF NOT EXISTS encargadocaja(
    dni VARCHAR(8),
    numero SMALLINT,
    direccion VARCHAR(50)
);


-- Key constraints

-- Persona
ALTER TABLE persona ADD CONSTRAINT pk_persona_dni PRIMARY KEY (dni);


-- Trabajador
ALTER TABLE Trabajador ADD CONSTRAINT pk_trabajador_dni PRIMARY KEY (dni);
ALTER TABLE Trabajador ADD CONSTRAINT fk_trabajador_persona_dni FOREIGN KEY (dni) REFERENCES persona(dni);


-- ClienteDelivery
ALTER TABLE ClienteDelivery ADD CONSTRAINT pk_cliente_delivery_dni PRIMARY KEY (dni);
ALTER TABLE ClienteDelivery ADD CONSTRAINT fk_cliente_delivery_persona_dni FOREIGN KEY (dni) REFERENCES persona(dni);


-- ClienteLocal
ALTER TABLE ClienteLocal ADD CONSTRAINT pk_cliente_local_dni PRIMARY KEY (dni);
ALTER TABLE ClienteLocal ADD CONSTRAINT fk_cliente_local_persona_dni FOREIGN KEY (dni) REFERENCES persona(dni);


-- Turno
ALTER TABLE Turno ADD CONSTRAINT pk_turno_dni_dia PRIMARY KEY (dni, dia);
ALTER TABLE Turno ADD CONSTRAINT fk_turno_trabajador_dni FOREIGN KEY (dni) REFERENCES Trabajador(dni);


-- LOCAL
ALTER TABLE Local ADD CONSTRAINT pk_local_direccion PRIMARY KEY (direccion);


-- Repartidor
ALTER TABLE Repartidor ADD CONSTRAINT pk_repartidor_dni PRIMARY KEY (dni);
ALTER TABLE Repartidor ADD CONSTRAINT fk_repartidor_trabajador_dni FOREIGN KEY (dni) REFERENCES Trabajador(dni);
ALTER TABLE Repartidor ADD CONSTRAINT fk_repartidor_local_direccion FOREIGN KEY (direccion) REFERENCES local(direccion);


-- TrabajadorLocal
ALTER TABLE TrabajadorLocal ADD CONSTRAINT pk_trabajador_local_dni PRIMARY KEY (dni);
ALTER TABLE TrabajadorLocal ADD CONSTRAINT fk_trabajador_local_trabajador_dni FOREIGN KEY (dni) REFERENCES Trabajador(dni);
ALTER TABLE TrabajadorLocal ADD CONSTRAINT fk_trabajador_local_local_direccion FOREIGN KEY (direccion) REFERENCES local(direccion);



-- Caja
ALTER TABLE Caja ADD CONSTRAINT pk_caja_direccion_numero PRIMARY KEY (direccion, numero);
ALTER TABLE Caja ADD CONSTRAINT fk_caja_local_direccion FOREIGN KEY (direccion) REFERENCES Local(direccion);


-- Producto
ALTER TABLE Producto ADD CONSTRAINT pk_producto_nombre_medida PRIMARY KEY (nombre_producto, medida);


-- Empresa
ALTER TABLE Empresa ADD CONSTRAINT pk_empresa_ruc PRIMARY KEY (ruc);


-- Compra
ALTER TABLE Compra ADD CONSTRAINT pk_compra_correlativo PRIMARY KEY (correlativo);


-- Delivery
ALTER TABLE Delivery ADD CONSTRAINT pk_delivery_correlativo PRIMARY KEY (correlativo);
ALTER TABLE Delivery ADD CONSTRAINT fk_delivery_compra_correlativo FOREIGN KEY (correlativo) REFERENCES Compra(correlativo);
ALTER TABLE Delivery ADD CONSTRAINT fk_delivery_repartidor_dni FOREIGN KEY (Rdni) REFERENCES Repartidor(dni);
ALTER TABLE Delivery ADD CONSTRAINT fk_delivery_cliente_dni FOREIGN KEY (Cdni) REFERENCES clientedelivery(dni);


-- Compra Local
ALTER TABLE CompraLocal ADD CONSTRAINT pk_compra_local_correlativo PRIMARY KEY (correlativo) ;
ALTER TABLE CompraLocal ADD CONSTRAINT fk_compra_local_compra_correlativo FOREIGN KEY (correlativo) REFERENCES Compra(correlativo);
ALTER TABLE CompraLocal ADD CONSTRAINT fk_compra_local_caja_numero FOREIGN KEY (numero, direccion) REFERENCES Caja(numero, direccion);


-- Item Compra
ALTER TABLE ItemCompra ADD CONSTRAINT pk_item_compra_nombre_correlativo_medida PRIMARY KEY (nombre_producto, correlativo, medida);
ALTER TABLE ItemCompra ADD CONSTRAINT fk_item_compra_producto_nombre_medida FOREIGN KEY (nombre_producto, medida) REFERENCES Producto(nombre_producto, medida);
ALTER TABLE ItemCompra ADD CONSTRAINT fk_item_compra_compra_correlativo FOREIGN KEY (correlativo) REFERENCES Compra(correlativo);


-- Stock
ALTER TABLE Stock ADD CONSTRAINT pk_stock_direccion PRIMARY KEY (direccion,medida,nombre_producto);
ALTER TABLE Stock ADD CONSTRAINT fk_stock_producto_nombre_medida FOREIGN KEY (nombre_producto, medida) REFERENCES Producto(nombre_producto, medida);
ALTER TABLE Stock ADD CONSTRAINT fk_stock_local_direccion FOREIGN KEY (direccion) REFERENCES Local(direccion);


-- Entrega Productos
ALTER TABLE EntregaProductos ADD CONSTRAINT pk_entrega_productos_medida PRIMARY KEY (medida,nombre_producto,direccion,fecha,ruc);
ALTER TABLE EntregaProductos ADD CONSTRAINT fk_entrega_productos_producto_nombre_medida FOREIGN KEY (nombre_producto, medida) REFERENCES Producto (nombre_producto, medida);
ALTER TABLE EntregaProductos ADD CONSTRAINT fk_entrega_productos_local_direccion FOREIGN KEY (direccion) REFERENCES Local(direccion);
ALTER TABLE EntregaProductos ADD CONSTRAINT fk_entrega_productos_empresa FOREIGN KEY (ruc) REFERENCES Empresa(ruc);


-- Boleta
ALTER TABLE Boleta ADD CONSTRAINT pk_boleta_correlativo PRIMARY KEY (correlativo);
ALTER TABLE Boleta ADD CONSTRAINT fk_boleta_compra_local_correlativo FOREIGN KEY (correlativo) REFERENCES CompraLocal(correlativo);
ALTER TABLE Boleta ADD CONSTRAINT fk_boleta_cliente_local_dni FOREIGN KEY (dni) REFERENCES clientelocal(dni);


-- Factura
ALTER TABLE Factura ADD CONSTRAINT pk_factura_correlativo PRIMARY KEY (correlativo);
ALTER TABLE Factura ADD CONSTRAINT fk_factura_compra_local_correlativo FOREIGN KEY (correlativo) REFERENCES CompraLocal(correlativo);
ALTER TABLE Factura ADD CONSTRAINT fk_factura_empresa_ruc FOREIGN KEY (ruc) REFERENCES Empresa(ruc);


-- Encargado Caja
ALTER TABLE encargadocaja ADD CONSTRAINT pk_encargado_caja_dni PRIMARY KEY (dni);
ALTER TABLE encargadocaja ADD CONSTRAINT fk_encargado_caja_trabajador_local_dni FOREIGN KEY (dni) REFERENCES trabajadorlocal(dni);
ALTER TABLE encargadocaja ADD CONSTRAINT fk_encargado_caja_caja_numero_direccion FOREIGN KEY (numero, direccion) REFERENCES Caja(numero, direccion);


-- Not null constraints

ALTER TABLE persona ALTER COLUMN nombre SET NOT NULL;

ALTER TABLE trabajador ALTER COLUMN sueldo SET NOT NULL ;
ALTER TABLE trabajador ALTER COLUMN celular SET NOT NULL ;

ALTER TABLE clientedelivery ALTER COLUMN celular SET NOT NULL ;

ALTER TABLE turno ALTER COLUMN hora_entrada SET NOT NULL ;
ALTER TABLE turno ALTER COLUMN hora_salida SET NOT NULL ;

ALTER TABLE trabajadorlocal ALTER COLUMN rol SET NOT NULL ;

ALTER TABLE local ALTER COLUMN direccion SET NOT NULL ;

ALTER TABLE producto ALTER COLUMN precio_unitario SET NOT NULL ;

ALTER TABLE empresa ALTER COLUMN razon_social SET NOT NULL ;

ALTER TABLE compra ALTER COLUMN fecha_hora SET NOT NULL ;
ALTER TABLE compra ALTER COLUMN metodo_pago SET NOT NULL ;
ALTER TABLE compra ALTER COLUMN total SET NOT NULL ;

ALTER TABLE delivery ALTER COLUMN direccion SET NOT NULL ;
ALTER TABLE delivery ALTER COLUMN costo_envio SET NOT NULL ;
ALTER TABLE delivery ALTER COLUMN fecha_hora_delivery SET NOT NULL ;

ALTER TABLE itemcompra ALTER COLUMN cantidad SET NOT NULL ;
ALTER TABLE itemcompra ALTER COLUMN subtotal SET NOT NULL ;

ALTER TABLE stock ALTER COLUMN cantidad SET NOT NULL ;

ALTER TABLE entregaproductos ALTER COLUMN cantidad SET NOT NULL ;

-- Otros constraints


-- Empresa
ALTER TABLE empresa ADD CONSTRAINT unique_empresa_razon_social UNIQUE(razon_social);

-- Empresa
ALTER TABLE empresa ADD CONSTRAINT unique_empresa_razon_social UNIQUE(razon_social);

-- Producto
ALTER TABLE producto ADD CONSTRAINT producto_precio_unitario CHECK (precio_unitario > 0);

-- Compra
ALTER TABLE compra ADD CONSTRAINT compra_metodo_pago CHECK (metodo_pago IN ('Yape', 'Plin', 'Visa', 'MasterCard', 'Efectivo'));

-- Stock
ALTER TABLE stock ADD CONSTRAINT stock_cantidad CHECK (cantidad >= 0);

-- Local
ALTER TABLE local ADD CONSTRAINT local_aforo CHECK (aforo > 0);

-- Turno
ALTER TABLE turno ADD CONSTRAINT turno_dia CHECK (dia IN ('L', 'M', 'X', 'J', 'V', 'S', 'D'));
ALTER TABLE turno ADD CONSTRAINT turno_hora_entrada_salida CHECK (hora_entrada < hora_salida);

-- Trabajador
ALTER TABLE trabajador ADD CONSTRAINT trabajador_sueldo CHECK (sueldo > 0);

-- Triggers
CREATE OR REPLACE FUNCTION actualizar_subtotal()
RETURNS TRIGGER AS
$$
    BEGIN
        UPDATE itemcompra i SET subtotal = NEW.cantidad * (
                SELECT precio_unitario
                FROM producto p
                WHERE p.nombre_producto = NEW.nombre_producto
                AND p.medida = NEW.medida
            )
            WHERE i.nombre_producto = NEW.nombre_producto
            AND i.medida = NEW.medida;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_subtotal
AFTER INSERT ON itemcompra
FOR EACH ROW EXECUTE FUNCTION actualizar_subtotal();


CREATE OR REPLACE FUNCTION actualizar_total()
RETURNS TRIGGER AS
$$
    BEGIN
        UPDATE compra SET total = (
            SELECT SUM(subtotal)
            FROM itemcompra
            WHERE NEW.correlativo = itemcompra.correlativo
        )
        WHERE correlativo = NEW.correlativo;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_total
AFTER INSERT ON itemcompra
FOR EACH ROW EXECUTE FUNCTION actualizar_total();

CREATE OR REPLACE FUNCTION sumar_stock()
RETURNS TRIGGER AS
$$
    BEGIN
        IF EXISTS (
            SELECT cantidad
            FROM stock
            WHERE nombre_producto = NEW.nombre_producto
            AND medida = NEW.medida
            AND direccion = NEW.direccion)
        THEN
            UPDATE stock SET cantidad = cantidad + NEW.cantidad
            WHERE nombre_producto = NEW.nombre_producto
            AND medida = NEW.medida
            AND direccion = NEW.direccion;
        ELSE
            INSERT INTO stock(nombre_producto, medida, direccion, cantidad) VALUES
                (NEW.nombre_producto, NEW.medida, NEW.direccion, NEW.cantidad);
        END IF;
        RETURN NEW;
    END
$$ LANGUAGE plpgsql;

CREATE TRIGGER sumar_stock
AFTER INSERT ON entregaproductos
FOR EACH ROW EXECUTE FUNCTION sumar_stock();


CREATE OR REPLACE FUNCTION restar_stock()
RETURNS TRIGGER AS
$$
    BEGIN
        IF EXISTS (
            SELECT direccion
            FROM compralocal
            WHERE correlativo = NEW.correlativo)
        THEN
            UPDATE stock SET cantidad = cantidad - NEW.cantidad
            WHERE nombre_producto = NEW.nombre_producto
            AND medida = NEW.medida
            AND direccion = (
                SELECT direccion
                FROM compralocal
                WHERE correlativo = NEW.correlativo
            );
        ELSIF EXISTS (
            SELECT direccion
            FROM delivery
            WHERE correlativo = NEW.correlativo)
        THEN
            UPDATE stock SET cantidad = cantidad - NEW.cantidad
            WHERE nombre_producto = NEW.nombre_producto
            AND medida = NEW.medida
            AND direccion = (
                SELECT repartidor.direccion
                FROM delivery JOIN repartidor
                ON delivery.rdni = repartidor.dni
                WHERE NEW.correlativo = delivery.correlativo
            );
        ELSE
            UPDATE stock SET cantidad = cantidad - NEW.cantidad
            WHERE nombre_producto = NEW.nombre_producto
            AND medida = NEW.medida
            AND direccion = 'Av. Talara, Cercado de Lima 15836';
        END IF;
        RETURN NEW;
    END
$$ LANGUAGE plpgsql;

CREATE TRIGGER restar_stock
BEFORE INSERT ON itemcompra
FOR EACH ROW EXECUTE FUNCTION restar_stock();
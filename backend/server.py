import json
from flask import Flask, jsonify, render_template, abort
import psycopg2
import psycopg2.extras
import os
from flask_cors import CORS
from dotenv import load_dotenv

app = Flask(__name__)
load_dotenv()
CORS(app, origins=["http://localhost:8080"])

def get_connection():
    db = psycopg2.connect(database=os.environ.get("database"), user=os.environ.get("user"), password=os.environ.get("password"), options=os.environ.get("options"), host=os.environ.get("host"))
    db.autocommit = True
    cursor = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    return db, cursor

def get_table_names():
    db, cursor = get_connection()
    cursor.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = '{}'".format(os.environ.get("schema")))
    result = cursor.fetchall()
    return [dict(row).get("table_name") for row in result]

@app.route("/<recurso_nombre>", methods=["GET"])
def get(recurso_nombre):
    if recurso_nombre not in get_table_names():
        abort(404)
    db, cursor = get_connection()
    cursor.execute("SELECT * FROM "  + recurso_nombre)
    result = cursor.fetchall()

    return jsonify({
        recurso_nombre : [dict(row) for row in result]
    }), 200

@app.route("/consulta1", methods=["GET"])
def consulta1():
    db, cursor = get_connection()
    cursor.execute("""
    select extract(month from c.fecha_hora) as mes, count(c.correlativo) as compras_con_tarjeta_mayores_al_promedio
    from compra c join compralocal cl on (c.correlativo = cl.correlativo) join caja ca on (cl.numero = ca.numero and cl.direccion = ca.direccion)
    where ca.direccion in (
        select direccion from (select max(total_por_local) as maximo_total
        from (select ca1.direccion, sum(c1.total) as total_por_local
        from compra c1 join compralocal cl1 on (c1.correlativo = cl1.correlativo) join caja ca1 on (cl1.numero = ca1.numero and cl1.direccion = ca1.direccion)
        group by ca1.direccion) s1) s2
        join (select ca1.direccion, sum(c1.total) as total_por_local
        from compra c1 join compralocal cl1 on (c1.correlativo = cl1.correlativo) join caja ca1 on (cl1.numero = ca1.numero and cl1.direccion = ca1.direccion)
                                    group by ca1.direccion) s3 on (maximo_total = total_por_local)
    )
    and c.total > (select avg(total) from compra)
    and (c.metodo_pago = 'Visa' or c.metodo_pago = 'MasterCard')
    and extract(year from c.fecha_hora) = '2021'
    group by extract(month from c.fecha_hora)
    order by mes
    """)
    result = cursor.fetchall()
    return jsonify({
        "consulta":[dict(row) for row in result]
    }), 200

@app.route("/consulta2", methods=["GET"])
def consulta2():
    db, cursor = get_connection()
    cursor.execute("""
    SELECT nombre_producto, veces FROM ((SELECT nombre_producto, sum(cantidad) veces FROM COMPRA as C , (SELECT nombre_producto, correlativo, cantidad FROM itemcompra
        WHERE nombre_producto IN (
            SELECT nombre_producto FROM entregaproductos
                WHERE ruc=(SELECT foo.ruc FROM (
                                SELECT ruc, COUNT(nombre_producto) FROM entregaproductos
                                    WHERE medida LIKE '%oz' OR medida LIKE '%L' OR medida LIKE '%ml'
                                    GROUP BY ruc
                                    ORDER BY 2 DESC
                                    LIMIT 1) AS foo))) AS Item
                                    WHERE C.correlativo = Item.correlativo
                                    AND (extract(month from fecha_hora) IN ('1','2','3','12','11','10'))
                                    AND (extract(year from fecha_hora) IN ('2020','2021'))
                                    GROUP BY nombre_producto
                                    ORDER BY 2
                                    LIMIT 10)
    UNION
    (SELECT nombre_producto, sum(cantidad) veces FROM COMPRA as C , (SELECT nombre_producto, correlativo, cantidad FROM itemcompra
        WHERE nombre_producto IN (
            SELECT nombre_producto FROM entregaproductos
                WHERE ruc=(SELECT foo.ruc FROM (
                                SELECT ruc, COUNT(nombre_producto) FROM entregaproductos
                                    WHERE medida LIKE '%oz' OR medida LIKE '%L' OR medida LIKE '%ml'
                                    GROUP BY ruc
                                    ORDER BY 2 DESC
                                    LIMIT 1) AS foo))) AS Item
                                    WHERE C.correlativo = Item.correlativo
                                    AND (extract(month from fecha_hora) IN ('1','2','3','12','11','10'))
                                    AND (extract(year from fecha_hora) IN ('2020','2021'))
                                    GROUP BY nombre_producto
                                    ORDER BY 2 DESC
                                    LIMIT 10) ) AS foo1 ORDER BY 2;
    """)
    result = cursor.fetchall()
    return jsonify({
        "consulta":[dict(row) for row in result]
    }), 200

@app.route("/consulta3", methods=["GET"])
def consulta3():
    db, cursor = get_connection()
    cursor.execute("""
    SELECT r.dni AS dni_repartidor, nombre AS nombre_repartidor, count(r.dni) AS cantidad_entregas, nombre_producto
    FROM Delivery d JOIN ItemCompra i ON (d.correlativo = i.correlativo) JOIN Repartidor r on (d.rdni = r.dni) JOIN Persona p2 on (r.dni = p2.dni)
    WHERE i.nombre_producto IN (
        SELECT nombre_producto
        FROM (
            (SELECT nombre_producto, sum(cantidad) AS cant
            FROM ItemCompra i JOIN Delivery d ON i.correlativo = d.correlativo JOIN Compra c ON i.correlativo = c.correlativo
            WHERE
                EXTRACT(MONTH FROM c.fecha_hora)
                    IN ('1', '2', '3', '4', '5', '6')
                AND EXTRACT(YEAR FROM c.fecha_hora) = '2021'
            GROUP BY nombre_producto)
                T3 JOIN
            (SELECT max(cant) AS maximo FROM (
                SELECT sum(cantidad) AS cant
                FROM ItemCompra i JOIN Delivery d ON i.correlativo = d.correlativo JOIN Compra c ON i.correlativo = c.correlativo
                WHERE
                    EXTRACT(MONTH FROM c.fecha_hora)
                        IN ('1', '2', '3', '4', '5', '6')
                    AND EXTRACT(YEAR FROM c.fecha_hora) = '2021'
                GROUP BY nombre_producto
                ) T2
            ) T4
                ON (maximo = cant)
        ) T1
    )
    AND cdni IN (
        SELECT b.dni
        FROM CompraLocal cl JOIN Boleta b ON cl.correlativo = b.correlativo JOIN Compra c ON cl.correlativo = c.correlativo
        WHERE EXTRACT(YEAR FROM c.fecha_hora) < '2021'
    )
    GROUP BY r.dni, nombre, nombre_producto;
    """)
    result = cursor.fetchall()
    return jsonify({
        "consulta":[dict(row) for row in result]
    }), 200

@app.errorhandler(404)
def not_found(error):
    return jsonify({
        "success" : False,
        "code" : 404
    }), 404

if __name__ == "__main__":
    app.run(debug=True)
from flask import Flask, jsonify, render_template
import psycopg2

app = Flask(__name__)
conn = psycopg2.connect(database="proyectobasededatos1", user="jjoc", password="1234", options="-c search_path=proyecto1k")
cursor = conn.cursor()

@app.route("/<recurso_nombre>", methods=["GET"])
def get(recurso_nombre):
    cursor.execute("SELECT * FROM "  + recurso_nombre + ";")
    titulos = [desc[0] for desc in cursor.description]
    objetos = cursor.fetchall()
    conn.commit()
    return render_template("index.html", titulo="Compras", titulos=titulos, objetos=objetos)

if __name__ == "__main__":
    app.run(debug=True)
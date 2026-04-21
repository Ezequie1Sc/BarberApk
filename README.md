<div align="center">
  <img src="/icons/flutter.svg" width="80" alt="Flutter Logo" />
  <h1 style="margin-top: 0;">Barber Shop App</h1>
  <p>Aplicación integral para barberías que facilita la reserva de turnos, la compra de productos y la gestión de clientes.</p>
  
  <div>
    <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter" />
    <img src="https://img.shields.io/badge/Python-3.10-green?logo=python" />
    <img src="https://img.shields.io/badge/Flask-2.3-black?logo=flask" />
    <img src="https://img.shields.io/badge/PostgreSQL-15-blue?logo=postgresql" />
    <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey" />
  </div>

  <br />
  
  <img src="/proyectos/barberia/b_1.png" width="600" alt="App Preview" />
</div>

---

## 📱 Demo

<p align="center">
  <img src="/barberAPK.webm" width="300" alt="App Demo Video" />
</p>

---

## 🚀 Tecnologías utilizadas

<div align="center">
  <table>
    <tr>
      <td align="center" width="110">
        <img src="/icons/flutter.svg" width="40" height="40" alt="Flutter" /><br/>
        <b>Flutter</b>
      </td>
      <td align="center" width="110">
        <img src="/icons/dart.svg" width="40" height="40" alt="Dart" /><br/>
        <b>Dart</b>
      </td>
      <td align="center" width="110">
        <img src="/icons/flask.svg" width="40" height="40" alt="Flask" /><br/>
        <b>Flask</b>
      </td>
      <td align="center" width="110">
        <img src="/icons/python.svg" width="40" height="40" alt="Python" /><br/>
        <b>Python</b>
      </td>
      <td align="center" width="110">
        <img src="/icons/postgresql.svg" width="40" height="40" alt="PostgreSQL" /><br/>
        <b>PostgreSQL</b>
      </td>
    </tr>
  </table>
</div>

---

## 🎯 El problema

> **Barberías perdían clientes por falta de sistema de reservas y mala gestión de turnos.**

Sin un sistema digital, las barberías enfrentaban:
- Pérdida de clientes por falta de disponibilidad horaria.
- Dobles reservas y confusiones en los turnos.
- Dificultad para vender productos de manera complementaria.

---

## 💡 La solución

**App todo-en-uno que digitaliza reservas 24/7, catálogo de productos y sistema de fidelización.**

- ✅ Reservas en tiempo real desde cualquier lugar.
- ✅ Catálogo de productos con compra integrada.
- ✅ Sistema de fidelización para clientes recurrentes.
- ✅ Gestión centralizada de clientes y turnos.

---

## ⚙️ ¿Cómo funciona?

1. **Sincronización en tiempo real de disponibilidad**  
   Los barberos ven su agenda actualizada al instante.

2. **Pasarela de pagos integrada**  
   Pago seguro de reservas y productos desde la app.

3. **Base de datos centralizada**  
   Toda la información de clientes, turnos y productos en PostgreSQL.

4. **Notificaciones automáticas**  
   Recordatorios de turnos y promociones personalizadas.

---

## 📊 Impacto real

> 📈 **Aumentó reservas en 80%**  
> 💰 **Generó 40% más ingresos por venta de productos.**

Los negocios que implementaron la app reportaron:
- Menos ausencias gracias a los recordatorios.
- Mayor ticket promedio por la venta cruzada de productos.
- Clientes más satisfechos por la facilidad de reserva.

---

## 🖼️ Galería

<div align="center">
  <img src="/proyectos/barberia/b_2.png" width="200" />
  <img src="/proyectos/barberia/b_3.png" width="200" />
  <img src="/proyectos/barberia/b_4.png" width="200" />
  <img src="/proyectos/barberia/b_5.png" width="200" />
</div>

---

## 🛠️ Instalación y uso

### Requisitos previos

- Flutter 3.x
- Python 3.10+
- PostgreSQL 15+
- Git

### Backend (Flask + PostgreSQL)

```bash
# Clonar el repositorio
git clone https://github.com/Ezequie1Sc/BarberApk.git
cd BarberApk/backend

# Crear entorno virtual
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate

# Instalar dependencias
pip install -r requirements.txt

# Configurar variables de entorno (crear archivo .env)
# DATABASE_URL=postgresql://usuario:contraseña@localhost/barberdb

# Ejecutar migraciones
flask db upgrade

# Iniciar servidor
flask run****

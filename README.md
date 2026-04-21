<div align="center">
  <h1>✂️ Barber Shop App</h1>
  <p>Aplicación integral para barberías que facilita la reserva de turnos, la compra de productos y la gestión de clientes.</p>
  
  <div>
    <img src="https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter" />
    <img src="https://img.shields.io/badge/Python-3.10-green?style=for-the-badge&logo=python" />
    <img src="https://img.shields.io/badge/Flask-2.3-black?style=for-the-badge&logo=flask" />
    <img src="https://img.shields.io/badge/PostgreSQL-15-blue?style=for-the-badge&logo=postgresql" />
    <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge&logo=android" />
  </div>

  <br />
  
  <img src="https://via.placeholder.com/800x400?text=App+Screenshot" width="600" alt="App Preview" />
  <!-- Reemplaza el placeholder con tu imagen real -->
</div>

---

## 📱 Demo

<p align="center">
  <video width="300" controls>
    <source src="/barberAPK.webm" type="video/webm">
    Tu navegador no soporta el video.
  </video>
</p>

---

## 🚀 Tecnologías utilizadas

<div align="center">
  <table>
    <tr>
      <td align="center" width="120">
        <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg" width="50" height="50" alt="Flutter" /><br/>
        <b>Flutter</b>
      </td>
      <td align="center" width="120">
        <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg" width="50" height="50" alt="Dart" /><br/>
        <b>Dart</b>
      </td>
      <td align="center" width="120">
        <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flask/flask-original.svg" width="50" height="50" alt="Flask" /><br/>
        <b>Flask</b>
      </td>
      <td align="center" width="120">
        <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg" width="50" height="50" alt="Python" /><br/>
        <b>Python</b>
      </td>
      <td align="center" width="120">
        <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original.svg" width="50" height="50" alt="PostgreSQL" /><br/>
        <b>PostgreSQL</b>
      </td>
    </tr>
  </table>
</div>

---

## 🎯 El problema

> **Barberías perdían clientes por falta de sistema de reservas y mala gestión de turnos.**

Sin un sistema digital, las barberías enfrentaban:
- ❌ Pérdida de clientes por falta de disponibilidad horaria.
- ❌ Dobles reservas y confusiones en los turnos.
- ❌ Dificultad para vender productos de manera complementaria.

---

## 💡 La solución

**App todo-en-uno que digitaliza reservas 24/7, catálogo de productos y sistema de fidelización.**

- ✅ Reservas en tiempo real desde cualquier lugar.
- ✅ Catálogo de productos con compra integrada.
- ✅ Sistema de fidelización para clientes recurrentes.
- ✅ Gestión centralizada de clientes y turnos.

---

## ⚙️ ¿Cómo funciona?

| Paso | Descripción |
|------|-------------|
| 1️⃣ | **Sincronización en tiempo real de disponibilidad** - Los barberos ven su agenda actualizada al instante. |
| 2️⃣ | **Pasarela de pagos integrada** - Pago seguro de reservas y productos desde la app. |
| 3️⃣ | **Base de datos centralizada** - Toda la información de clientes, turnos y productos en PostgreSQL. |
| 4️⃣ | **Notificaciones automáticas** - Recordatorios de turnos y promociones personalizadas. |

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
  <img src="https://via.placeholder.com/200x400?text=Screen+1" width="200" />
  <img src="https://via.placeholder.com/200x400?text=Screen+2" width="200" />
  <img src="https://via.placeholder.com/200x400?text=Screen+3" width="200" />
  <img src="https://via.placeholder.com/200x400?text=Screen+4" width="200" />
</div>
<!-- Reemplaza los placeholders con tus imágenes reales -->

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
flask run

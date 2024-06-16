const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();

// Configuración básica de CORS
app.use(cors());

// Middleware para servir archivos estáticos
app.use(express.static(path.join(__dirname, 'public')));

// Rutas de tu aplicación
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public/html', 'index.html'));
});

// Otros endpoints y configuraciones de tu aplicación...

const PORT = process.env.PORT || 3000;


// Iniciar el servidor
app.listen(PORT, () => {
    console.log(`Servidor Express escuchando en el puerto ${PORT}`);
});

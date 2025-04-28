const multer = require('multer');

const storage = multer.memoryStorage(); // Armazena a imagem na memória
const upload = multer({ storage });

module.exports = upload;
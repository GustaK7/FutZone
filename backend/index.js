require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

app.use((req, res, next) => {
  console.log(`Recebida requisição: ${req.method} ${req.url}`);
  next();
});

mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB conectado!'))
  .catch(err => console.error('Erro ao conectar no MongoDB:', err));

// Importar models
const Space = require('./models/Space');
const User = require('./models/User');
const Reservation = require('./models/reservartion');
const Rating = require('./models/rating');

// Middleware de validação para usuários
const validateUserData = (req, res, next) => {
  next(); // Middleware vazio para não bloquear as requisições
};

// Rotas para espaços esportivos
app.get('/spaces', async (req, res) => {
  try {
    const spaces = await Space.find();
    res.json(spaces);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar espaços' });
  }
});

app.post('/spaces', async (req, res) => {
  console.log('Recebido no POST /spaces:', req.body); // Log para depuração
  try {
    const space = new Space(req.body);
    await space.save();
    res.status(201).json(space);
  } catch (err) {
    console.error('Erro ao cadastrar espaço:', err);
    res.status(400).json({ error: 'Erro ao cadastrar espaço', details: err.message });
  }
});

// Rotas para usuários
app.get('/users', async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar usuários' });
  }
});

app.post('/users', validateUserData, async (req, res) => {
  try {
    const user = new User(req.body);
    await user.save();
    res.status(201).json(user);
  } catch (err) {
    res.status(400).json({ error: 'Erro ao cadastrar usuário', details: err.message });
  }
});

// Rota para buscar informações de um usuário pelo ID
app.get('/users/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Verificar se o ID é válido
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ error: 'ID inválido' });
    }

    const user = await User.findById(id);

    if (!user) {
      return res.status(404).json({ error: 'Usuário não encontrado' });
    }

    res.json(user);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar informações do usuário', details: err.message });
  }
});

// Rota para atualizar informações do usuário
app.put('/users/:id', validateUserData, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, email, phone } = req.body;

    console.log(`Recebido PUT /users/${id}`); // Log do ID recebido
    console.log('Dados recebidos no corpo da requisição:', req.body);
    console.log('Dados recebidos no corpo da requisição:', { name, email, phone });

    // Converter o ID para ObjectId
    if (!mongoose.Types.ObjectId.isValid(id)) {
      console.error('ID inválido:', id); // Log de erro
      return res.status(400).json({ error: 'ID inválido' });
    }
    const objectId = new mongoose.Types.ObjectId(id); // Corrigido para usar 'new' ao instanciar ObjectId

    // Verificar se o usuário existe
    const user = await User.findById(objectId);
    if (!user) {
      console.error('Usuário não encontrado para o ID:', id); // Log de erro
      return res.status(404).json({ error: 'Usuário não encontrado' });
    }

    // Atualizar informações do usuário
    user.name = name || user.name;
    user.email = email || user.email;
    // Garantir que o campo phone seja um número antes de salvar
    user.phone = parseInt(phone, 10) || user.phone;
    await user.save();

    console.log('Usuário atualizado com sucesso:', user); // Log de sucesso
    res.json({ message: 'Informações do usuário atualizadas com sucesso', user });
  } catch (err) {
    console.error('Erro ao atualizar informações do usuário:', err); // Log de erro
    res.status(500).json({ error: 'Erro ao atualizar informações do usuário', details: err.message });
  }
});

// Rota para alterar senha do usuário
app.put('/users/:id/password', async (req, res) => {
  try {
    const { id } = req.params;
    const { currentPassword, newPassword } = req.body;
    const user = await User.findById(id);
    if (!user) return res.status(404).json({ error: 'Usuário não encontrado' });

    // Verificar senha atual (mocked para simplificação)
    if (user.password !== currentPassword) {
      return res.status(400).json({ error: 'Senha atual incorreta' });
    }

    // Atualizar senha
    user.password = newPassword;
    await user.save();
    res.json({ message: 'Senha alterada com sucesso' });
  } catch (err) {
    res.status(400).json({ error: 'Erro ao alterar senha', details: err.message });
  }
});

// Rotas para reservas
app.get('/reservations', async (req, res) => {
  try {
    const reservations = await Reservation.find().populate('userId').populate('spaceId');
    res.json(reservations);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar reservas' });
  }
});

app.post('/reservations', async (req, res) => {
  try {
    const reservation = new Reservation(req.body);
    await reservation.save();
    res.status(201).json(reservation);
  } catch (err) {
    res.status(400).json({ error: 'Erro ao cadastrar reserva' });
  }
});

// Rotas para comentários/ratings
app.get('/ratings', async (req, res) => {
  try {
    const ratings = await Rating.find().populate('userId').populate('spaceId');
    res.json(ratings);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar avaliações' });
  }
});

app.post('/ratings', async (req, res) => {
  try {
    const rating = new Rating(req.body);
    await rating.save();
    res.status(201).json(rating);
  } catch (err) {
    res.status(400).json({ error: 'Erro ao cadastrar avaliação' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});
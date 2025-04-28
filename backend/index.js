require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB conectado!'))
  .catch(err => console.error('Erro ao conectar no MongoDB:', err));

// Importar models
const Space = require('./models/Space');
const User = require('./models/User');
const Reservation = require('./models/reservartion');
const Rating = require('./models/rating');

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

app.post('/users', async (req, res) => {
  try {
    const user = new User(req.body);
    await user.save();
    res.status(201).json(user);
  } catch (err) {
    res.status(400).json({ error: 'Erro ao cadastrar usuário' });
  }
});

// Rota para atualizar informações do usuário
app.put('/users/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, phone, email } = req.body;
    const user = await User.findByIdAndUpdate(id, { name, phone, email }, { new: true });
    if (!user) return res.status(404).json({ error: 'Usuário não encontrado' });
    res.json(user);
  } catch (err) {
    res.status(400).json({ error: 'Erro ao atualizar informações do usuário', details: err.message });
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
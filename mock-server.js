const express = require('express');
const cors = require('cors');
const app = express();

app.use(express.json());

const argv = require('minimist')(process.argv.slice(2));
const PORT = argv.port || 8080;
const ORIGIN = argv.origin || 'http://localhost:5555';

app.use(cors({ origin: ORIGIN, credentials: true }));

// Тестовые пользователи
const users = [
  {
    id: '1',
    username: 'viewer',
    email: 'viewer@taskmanager.local',
    role: 'viewer',
    password: 'password123',
    createdAt: new Date().toISOString(),
  },
  {
    id: '2',
    username: 'member',
    email: 'member@taskmanager.local',
    role: 'member',
    password: 'password123',
    createdAt: new Date().toISOString(),
  },
  {
    id: '3',
    username: 'admin',
    email: 'admin@taskmanager.local',
    role: 'admin',
    password: 'password123',
    createdAt: new Date().toISOString(),
  },
];

const projects = [];
const tasks = [];
const tags = [];
const comments = [];

// Авторизация
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body;
  const user = users.find(u => u.username === username && u.password === password);

  if (!user) {
    return res.status(401).json({ message: 'Неверный логин или пароль' });
  }

  const { password: _, ...userWithoutPassword } = user;
  const token = `token_${user.id}_${Date.now()}`;

  res.json({ token, user: userWithoutPassword });
});

app.get('/api/auth/me', (req, res) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  if (!token) {
    return res.status(401).json({ message: 'Требуется авторизация' });
  }

  const userId = token.split('_')[1];
  const user = users.find(u => u.id === userId);

  if (!user) {
    return res.status(401).json({ message: 'Неверный токен' });
  }

  const { password: _, ...userWithoutPassword } = user;
  res.json({ user: userWithoutPassword });
});

console.log(`🚀 Mock API запущен на http://localhost:${PORT}`);
console.log(`📝 CORS разрешён для: ${ORIGIN}`);
console.log(`\n👥 Тестовые пользователи:`);
console.log(`   viewer / password123 (Просмотр)`);
console.log(`   member / password123 (Участник)`);
console.log(`   admin / password123 (Администратор)`);

app.listen(PORT);

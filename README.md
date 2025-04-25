# Futzone

Sistema de reserva de espaços esportivos com Flutter (frontend) e Node.js + MongoDB Atlas (backend).

## Pré-requisitos
- **Git**
- **Node.js** (18+)
- **Flutter** (mesma versão do projeto)
- **MongoDB Atlas** (string de conexão)

## Como rodar o projeto

### 1. Clonar o repositório
```sh
git clone <URL_DO_SEU_REPOSITORIO>
cd futzone
```

### 2. Configurar o backend
```sh
cd backend
npm install
```
Crie um arquivo `.env` com:
```
MONGO_URI=mongodb+srv://<usuario>:<senha>@<cluster>.mongodb.net/<banco>?retryWrites=true&w=majority&appName=<appName>
```
Inicie o backend:
```sh
node index.js
```

### 3. Configurar o frontend Flutter
```sh
cd ..
flutter pub get
```
- Para rodar no navegador:
  ```sh
  flutter run -d chrome
  ```
- Para rodar no emulador Android:
  - Altere o backendUrl em `lib/main.dart` para `http://10.0.2.2:3000`
  - Rode:
    ```sh
    flutter run
    ```

### 4. Versionamento com Git
- Baixar alterações:
  ```sh
  git pull
  ```
- Enviar alterações:
  ```sh
  git add .
  git commit -m "Mensagem do commit"
  git push
  ```

### 5. Dicas
- Sempre faça `git pull` antes de começar a trabalhar.
- Combine com o time para evitar conflitos.
- O backend precisa estar rodando para o app funcionar.
- O Atlas deve liberar o IP de acesso (0.0.0.0/0 para testes).

---

Se tiver dúvidas, consulte o código ou abra uma issue!

# 🐾 PetCare - Smart Pet Health & Adoption System

A comprehensive DBMS project for pet adoption and health management, built with Node.js, Express, MySQL, and Vite.

## 🏗️ Project Structure

```
PetCare/
├── client/          # Frontend (Vite + Vanilla JS)
├── server/          # Backend (Node.js + Express + MySQL)
├── README.md        # This file
└── .gitignore
```

## 🚀 Features

- **User Authentication** - JWT-based secure login/signup with bcrypt password hashing
- **Pet Management** - Add, view, update, and delete pet listings
- **Adoption System** - Submit and manage adoption requests
- **Profile Management** - User profile with real-time API integration
- **Responsive Design** - Mobile-friendly interface
- **Real-time Validation** - Form validation with immediate feedback

## 🛠️ Tech Stack

### Frontend
- **Vite** - Build tool and dev server
- **Vanilla JavaScript** - ES6+ modules
- **CSS3** - Modern styling with flexbox/grid
- **HTML5** - Semantic markup

### Backend
- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **MySQL2** - Database driver
- **JWT** - Authentication tokens
- **bcrypt** - Password hashing
- **CORS** - Cross-origin resource sharing

### Database
- **MySQL** - Relational database
- **Structured Schema** - Users, pets, adoption requests, vaccinations

## 📋 Prerequisites

- [Node.js](https://nodejs.org/) (v18 or higher)
- [MySQL](https://www.mysql.com/) (v8.0 or higher)
- [npm](https://www.npmjs.com/) (comes with Node.js)
- [Git](https://git-scm.com/)

## 🚀 Local Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/AsherWood39/DBMS_Project--PetCare.git
cd DBMS_Project--PetCare
```

### 2. Database Setup

1. **Start MySQL server** and create the database:
   ```sql
   CREATE DATABASE petcare_db;
   USE petcare_db;
   ```

2. **Import the schema**:
   ```bash
   mysql -u your_username -p petcare_db < server/petcare_schema.sql
   ```

3. **Import sample data** (optional):
   ```bash
   mysql -u your_username -p petcare_db < server/sample_data.sql
   ```

### 3. Backend Setup

1. **Navigate to server directory**:
   ```bash
   cd server
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Create environment file**:
   ```bash
   # Create .env file in server directory
   DB_HOST=localhost
   DB_PORT=3306
   DB_USER=your_mysql_username
   DB_PASSWORD=your_mysql_password
   DB_NAME=petcare_db
   JWT_SECRET=your_super_secret_jwt_key_here
   JWT_EXPIRE=30d
   PORT=5000
   ```

4. **Start the backend server**:
   ```bash
   # Development mode (with nodemon)
   npm run dev
   
   # Production mode
   npm start
   ```

   Server will run on: `http://localhost:5000`

### 4. Frontend Setup

1. **Navigate to client directory**:
   ```bash
   cd client
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Start the development server**:
   ```bash
   npm run dev
   ```

   Frontend will run on: `http://localhost:5173` (Vite default)

### 5. Access the Application

- **Frontend**: Open [http://localhost:5173](http://localhost:5173)
- **Backend API**: [http://localhost:5000](http://localhost:5000)
- **API Documentation**: Check `/server/src/routes/` for available endpoints

## 🌐 Production Deployment

### Deploy Frontend to Vercel

1. **Prepare for deployment**:
   ```bash
   cd client
   npm run build
   ```

2. **Deploy to Vercel**:
   - Install Vercel CLI: `npm i -g vercel`
   - Login: `vercel login`
   - Deploy: `vercel --prod`
   - Or use the [Vercel Dashboard](https://vercel.com) to connect your GitHub repo

3. **Configure environment variables** in Vercel dashboard:
   - `VITE_API_BASE_URL=https://your-backend-url.onrender.com`

### Deploy Backend to Render

1. **Prepare for deployment**:
   - Ensure `package.json` has correct start script
   - Create `render.yaml` (optional but recommended)

2. **Deploy to Render**:
   - Go to [Render Dashboard](https://render.com)
   - Create new Web Service
   - Connect your GitHub repository
   - Configure:
     - **Build Command**: `cd server && npm install`
     - **Start Command**: `cd server && npm start`
     - **Environment**: Node

3. **Configure environment variables** in Render:
   ```
   DB_HOST=your_mysql_host
   DB_PORT=3306
   DB_USER=your_mysql_username
   DB_PASSWORD=your_mysql_password
   DB_NAME=petcare_db
   JWT_SECRET=your_super_secret_jwt_key_here
   JWT_EXPIRE=30d
   PORT=10000
   ```

4. **Database options**:
   - Use Render's managed PostgreSQL (requires schema migration)
   - Use external MySQL service (PlanetScale, AWS RDS, etc.)
   - Update connection strings accordingly

### Update Frontend API URL

After backend deployment, update the API base URL in your frontend:

```javascript
// In client/utils/api.js
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'https://your-backend-url.onrender.com';
```

## 🔧 Available Scripts

### Backend (`/server`)
```bash
npm start      # Start production server
npm run dev    # Start development server with nodemon
```

### Frontend (`/client`)
```bash
npm run dev      # Start development server
npm run build    # Build for production
npm run preview  # Preview production build
npm run serve    # Serve on port 3000
```

## 📁 API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/auth/me` - Get current user
- `POST /api/auth/logout` - User logout

### Users
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile
- `DELETE /api/users/profile` - Delete user account

### Pets
- `GET /api/pets` - Get all available pets
- `POST /api/pets` - Create new pet listing
- `GET /api/pets/:id` - Get specific pet
- `PUT /api/pets/:id` - Update pet
- `DELETE /api/pets/:id` - Delete pet

### Adoption Requests
- `GET /api/adoption-requests` - Get adoption requests
- `POST /api/adoption-requests` - Submit adoption request
- `PUT /api/adoption-requests/:id` - Update request status

## 🔐 Security Features

- **Password Hashing** - bcrypt with salt rounds
- **JWT Authentication** - Secure token-based auth
- **Input Validation** - Server-side validation
- **CORS Protection** - Configured for secure origins
- **Environment Variables** - Sensitive data protection

## 🐛 Troubleshooting

### Common Issues

1. **Database Connection Error**:
   - Check MySQL server is running
   - Verify credentials in `.env` file
   - Ensure database exists

2. **Port Already in Use**:
   - Kill processes: `npx kill-port 5000` or `npx kill-port 5173`
   - Change port in environment variables

3. **Frontend API Errors**:
   - Verify backend server is running
   - Check CORS configuration
   - Confirm API endpoints

4. **Dependencies Issues**:
   ```bash
   # Clear cache and reinstall
   npm run clean && npm install
   ```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **AsherWood39** - [GitHub](https://github.com/AsherWood39)
- **asiiyaah** - [GitHub](https://github.com/asiiyaah)
- **Athi183** - [GitHub](https://github.com/Athi183)
- **AnnaTJeby** - [GitHub](https://github.com/AnnaTJeby)

---

**🎉 Enjoy using PetCare - Smart Pet Health & Adoption System!**

For support, please open an issue on GitHub or contact the development team.

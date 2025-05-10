# EcoNomiza
App de registro de gastos para Android

## 🌟 Estructura MVVM en EcoNomiza
Para mantener un código limpio y escalable, EcoNomiza sigue la arquitectura **MVVM** (Modelo-Vista-ViewModel).

### 🏗️ Descripción de Capas
- **Models:** Definen la estructura de los datos utilizados en la aplicación.
- **ViewModels:** Gestionan el estado y la lógica de presentación.
- **Views:** Contienen la UI y se comunican con los ViewModels.
- **Repositories:** Manejan la obtención y almacenamiento de datos.
- **Services:** Conectan con APIs externas o bases de datos.

### 📂 Estructura de Carpetas
/lib 
    ├── models/ # Modelos de datos 
    ├── views/ # Pantallas y widgets 
    ├── viewmodels/ # Lógica de presentación 
    ├── services/ # Servicios externos (API, BD) 
    ├── repositories/ # Manejo de datos 
    ├── utils/ # Funciones auxiliares 
    ├── main.dart # Punto de entrada

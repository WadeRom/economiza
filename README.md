# EcoNomiza
App de registro de gastos para Android

## 📦 Instalación

1. **Clona el repositorio, abre una terminal**
   ```sh
    C:\Users\tuUsuario\Escritorio> git clone git@github.com:WadeRom/economiza.git
    C:\Users\tuUsuario\Escritorio> cd economiza

2. **Cambia a la rama develop con Git**
   ```sh
    C:\Users\tuUsuario\Escritorio\economiza> git checkout develop

3. **Instala las dependencias**
    ```sh 
    C:\Users\tuUsuario\Escritorio\economiza> flutter create .
    C:\Users\tuUsuario\Escritorio\economiza> flutter pub get

4. **Ejecuta el proyecto**
    ```sh
    C:\Users\tuUsuario\Escritorio\economiza> flutter run

## 🛠️ Proceso correcto para aportar al repositorio

1. Actualizar tu repositorio antes de trabajar Antes de empezar cualquier desarrollo, asegúrate de tener la última versión de   develop:
    ```sh
    C:\Users\tuUsuario\Escritorio\economiza> git checkout develop
    C:\Users\tuUsuario\Escritorio\economiza> git pull origin develop

2. Crear una nueva rama para tu desarrollo Nunca trabajes directamente en develop. Crea una rama separada para tu feature o corrección:
    ```sh
    C:\Users\tuUsuario\Escritorio\economiza> git checkout -b nombre-de-tu-rama

3. Desarrollar y realizar commits A medida que avances, guarda tus cambios con commits organizados:
    ```sh
    C:\Users\tuUsuario\Escritorio\economiza> git add .
    C:\Users\tuUsuario\Escritorio\economiza> git commit -m "feat: agregar reporte de gastos en pantalla"

4. Subir la rama al remoto Cuando termines los cambios, súbelos a GitHub:
    ```sh
    C:\Users\tuUsuario\Escritorio\economiza> git push origin nombre-de-tu-rama

5. Crear un Pull Request (PR) Desde GitHub, crea un Pull Request para fusionar tu rama en develop. Un revisor del equipo verificará los cambios antes de integrarlos.
    - Ve al repositorio en GitHub.
    - Busca tu rama y selecciona “Compare & Pull Request”.
    - Escribe una breve descripción del cambio y solicita revisión.
    - Envía el PR y espera la aprobación antes de fusionar en develop.

6. Fusionar los cambios en develop (cuando el PR sea aprobado) Después de que alguien del equipo apruebe tu PR, puedes fusionarlo en develop con:
    ```sh
    C:\Users\tuUsuario\Escritorio\economiza> git checkout develop
    C:\Users\tuUsuario\Escritorio\economiza> git merge nombre-de-tu-rama
    C:\Users\tuUsuario\Escritorio\economiza> git push origin develop

7. Actualizar develop y eliminar la rama si ya no es necesaria
    ```sh
    C:\Users\tuUsuario\Escritorio\economiza> git checkout develop
    C:\Users\tuUsuario\Escritorio\economiza> git pull origin develop
    C:\Users\tuUsuario\Escritorio\economiza> git branch -d feature-nueva-funcionalidad  # Eliminación local
    C:\Users\tuUsuario\Escritorio\economiza> git push origin --delete feature-nueva-funcionalidad  # Eliminación en remoto


## 🌟 Estructura MVVM en EcoNomiza
Para mantener un código limpio y escalable, EcoNomiza sigue la arquitectura **MVVM** (Modelo-Vista-ViewModel).


### 🏗️ Descripción de Capas
- **Models:** Definen la estructura de los datos utilizados en la aplicación.
- **ViewModels:** Gestionan el estado y la lógica de presentación.
- **Views:** Contienen la UI y se comunican con los ViewModels.
- **Repositories:** Manejan la obtención y almacenamiento de datos.
- **Services:** Conectan con APIs externas o bases de datos.

### 📂 Estructura de Carpetas
/lib # Código fuente en Dart
    ├── models/ # Modelos de datos 
    ├── views/ # Pantallas y widgets 
    ├── viewmodels/ # Lógica de presentación 
    ├── services/ # Servicios externos (API, BD) 
    ├── repositories/ # Manejo de datos 
    ├── utils/ # Funciones auxiliares 
    ├── main.dart # Punto de entrada

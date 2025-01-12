# Proyecto Administrativo para la Clínica Virgen de Guadalupe
 
Este proyecto fue desarrollado para cumplir con los requerimientos y especificaciones de la Clínica Virgen de Guadalupe. La aplicación utiliza Firebase para la autenticación y el almacenamiento de datos. Además, se empleó Flutter y Dart para el desarrollo del frontend, siguiendo una arquitectura basada en Modelo-Vista-Servicio-VistaModelo (MVVM). A continuación, se detallan las principales funcionalidades y características del proyecto.

### Tecnologías Utilizadas

- **Firebase Authentication:** Para la gestión de usuarios y autenticación segura.

- **Firebase Firestore:** Para el almacenamiento de datos en tiempo real.

- **Flutter y Dart:** Para el desarrollo de la interfaz de usuario y la lógica del frontend.

- **Arquitectura MVVM:** Para separar la lógica de negocio, la gestión de datos y la interfaz de usuario, mejorando la mantenibilidad y escalabilidad del proyecto.

## Funcionalidades Principales

### 1. Usuarios

- Registro y autenticación de usuarios mediante Firebase Authentication.

- Gestión de perfiles de usuario.

### 2. Paquetes Clínicos

Visualización de paquetes disponibles para terapias y tratamientos.

Gestión y administración de paquetes por parte del administrador.

3. Progreso de Mi Terapia

Monitoreo y actualización del progreso de las terapias.

Visualización gráfica del avance en las sesiones de terapia.

4. Especialistas

Listado de especialistas disponibles.

Visualización de información detallada de cada especialista.

5. Administrar Citas

Gestión de citas: programar, cancelar y modificar.

Notificaciones automáticas para recordatorios de citas.

6. Galería de Citas

Historial visual de citas realizadas.

Creación de álbumes por terapias, permitiendo organizar las fotografías relacionadas.

Opciones para filtrar y buscar álbumes y fotos específicas.

Arquitectura MVVM

El proyecto sigue la arquitectura Modelo-Vista-Servicio-VistaModelo, con los siguientes componentes principales:

Modelo: Representa la estructura y los datos de la aplicación, incluyendo las clases que interactúan con Firebase Firestore y otros servicios.

Vista: Contiene los elementos de interfaz de usuario desarrollados en Flutter.

Servicio: Maneja las interacciones con Firebase, como la autenticación y las consultas a Firestore.

VistaModelo: Actúa como intermediario entre el modelo y la vista, gestionando la lógica de negocio y proporcionando datos a la interfaz de usuario de manera reactiva.

Configuración e Instalación

Clonar este repositorio:

git clone <URL_DEL_REPOSITORIO>

Instalar las dependencias necesarias:

flutter pub get

Configurar Firebase:

Crear un proyecto en Firebase Console.

Descargar el archivo google-services.json (para Android) y GoogleService-Info.plist (para iOS) y colocarlos en las carpetas correspondientes del proyecto Flutter.

Configurar las reglas de seguridad para Firestore y Authentication según las necesidades del cliente.

Iniciar el proyecto:

flutter run

Consideraciones de Seguridad

Implementar validaciones adicionales en el frontend para evitar el ingreso de datos incorrectos.

Configurar reglas de acceso en Firebase Firestore para proteger la información sensible.

Usar HTTPS en todas las conexiones para garantizar la seguridad de los datos.

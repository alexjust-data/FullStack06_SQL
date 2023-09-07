# FullStack_SQL

En los archivos .ipynb de este repositorio encontrarás de forma ordenada los apuntes y ejercicios en `PostgreSQL` sobre BBDD relacionales.

**UNA MIRADA GENERAL SOBRE LA CREACIÓN DE UN SISTEMA DE DATOS**

**EJEMPLO :** 

Estás interesado en construir una página web que actúe como una base de datos donde están todas las empresas que cotizan en la bolsa de Estados Unidos, incluyendo sus estados financieros disponibles en la SEC EDGAR. A continuación, proporciono un plan esquemático dividido por áreas de trabajo y tareas.


1. Investigación y Planeación  
1.1. Investigar APIs y fuentes de datos de la SEC EDGAR  
1.2. Definir las características y el alcance de la aplicación  
1.3. Seleccionar tecnologías y herramientas (backend, frontend, bases de datos, etc.)  
1.4. Diseñar la arquitectura del sistema  
  
2. Diseño de Base de Datos  
2.1. Diseñar el esquema de la base de datos  
2.2. Crear tablas para Empresas, Estados Financieros, Usuarios, etc.  
2.3. Configurar índices y optimizar rendimiento  

3. Backend: Tubería de Datos (Data Pipeline)  
3.1. Crear script para acceder al API de SEC EDGAR  
3.2. Diseñar y construir ETL para procesar y almacenar datos  
3.3. Implementar trabajos de cron para actualizar la base de datos periódicamente  

4. Backend: API  
4.1. Crear endpoints para acceder a los datos de las empresas  
4.2. Implementar autenticación y autorización  
4.3. Implementar lógica para búsqueda y filtrado  
4.4. Desarrollar pruebas automatizadas para la API  

5. Frontend: Interfaz Web  
5.1. Diseñar la UI/UX  
5.2. Implementar vistas para búsqueda, perfiles de empresas, estados financieros, etc.  
5.3. Conectar el frontend con el backend a través de la API  
  
6. Seguridad  
6.1. Implementar HTTPS  
6.2. Evaluar y fortalecer la seguridad de la API  
6.3. Implementar medidas anti-scraping  
  
7. Despliegue  
7.1. Configurar servidores y bases de datos en el entorno de producción  
7.2. Automatizar el proceso de despliegue  
7.3. Establecer monitoreo y alertas  

8. Mantenimiento y Actualización  
8.1. Monitorizar el rendimiento del sistema  
8.2. Realizar copias de seguridad de la base de datos  
8.3. Mantener la tubería de datos actualizada con nuevas especificaciones o cambios en las fuentes de datos  

---

A continuación, describo de manera esquemática y ordenada cómo construir desde cero el sistema de base de datos hasta que esté operativo.  
  
1. Elección del Sistema de Gestión de Bases de Datos (SGBD)  

1.1. Evaluar requisitos técnicos y escoger un SGBD (ejemplo: PostgreSQL, MySQL, MongoDB)   
1.2. Decidir sobre la infraestructura: local vs cloud (ejemplo: AWS RDS, Azure SQL)   
  
2. Instalación y Configuración del SGBD  

2.1. Instalar el software SGBD seleccionado en el servidor   
2.2. Configurar ajustes de seguridad: reglas de firewall, usuarios y permisos   
2.3. Establecer parámetros para mejorar rendimiento (caché, índices, etc.)   
  
3. Diseño del Esquema  

3.1. Diseñar el esquema en papel o usando una herramienta de diseño como dbdiagram.io   
3.2. Definir tablas, relaciones, índices, y tipos de datos   
  
4. Creación de la Base de Datos  

4.1. Conectarse al SGBD usando un cliente (ejemplo: pgAdmin para PostgreSQL, MySQL Workbench para MySQL)   
4.2. Crear la base de datos y ejecutar los scripts SQL para crear tablas, índices, etc.   
4.3. Insertar datos de prueba si es necesario   
  
5. Integración de la Base de Datos con Backend  

5.1. Instalar un ORM o driver para conectarse a la base de datos (ejemplo: SQLAlchemy para Python, Sequelize para Node.js)   
5.2. Establecer la conexión entre el backend y la base de datos   
5.3. Implementar funciones de CRUD (Crear, Leer, Actualizar, Eliminar) en el backend   
  
6. Desarrollo de la Tubería de Datos (Data Pipeline)  

6.1. Diseñar ETL (Extracción, Transformación, Carga) para ingresar datos de SEC EDGAR   
6.2. Implementar trabajos cron o utilizar herramientas como Apache Airflow para automatizar la tubería de datos   
6.3. Probar la tubería en un entorno separado antes de llevarla a producción   
  
7. Backups y Recuperación  

7.1. Configurar backups automáticos de la base de datos   
7.2. Establecer un plan de recuperación de desastres   
7.3. Probar el proceso de recuperación de datos   
  
8. Monitoreo y Mantenimiento  

8.1. Utilizar herramientas de monitoreo para observar el rendimiento (ejemplo: Prometheus, Grafana)    
8.2. Establecer alertas para situaciones críticas como fallos en la base de datos, latencia alta, etc.    
8.3. Planificar el escalado del sistema en base al crecimiento previsto    
    
9. Despliegue en Producción  

9.1. Verificar que todos los aspectos de la base de datos funcionan como se espera en un entorno de pruebas   
9.2. Migrar la base de datos al entorno de producción usando herramientas de migración o backups   
9.3. Confirmar que la base de datos está operativa y es accesible por el backend en el entorno de producción   
  
Este plan es un esquema general. Cada una de estas etapas podría desglosarse en más sub-tareas dependiendo del proyecto específico.   
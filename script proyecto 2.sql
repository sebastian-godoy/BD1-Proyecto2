create database proyecto2;
use proyecto2;

-- Crear la tabla Estudiante
CREATE TABLE Estudiante (
    Carnet BIGINT PRIMARY KEY,
    Nombres VARCHAR(255),
    Apellidos VARCHAR(255),
    FechaNacimiento DATE,
    Correo VARCHAR(255),
    Telefono NUMERIC(10),
    Direccion VARCHAR(255),
    NumeroDPI BIGINT,
    CarreraID INT,
    CreditosPoseidos INT DEFAULT 0,
    FechaCreacion TIMESTAMP
);

-- Crear la tabla Carrera
CREATE TABLE Carrera (
    CarreraID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255)
);

-- Crear la tabla Docente
CREATE TABLE Docente (
    RegistroSIIF INT PRIMARY KEY,
    Nombres VARCHAR(255),
    Apellidos VARCHAR(255),
    FechaNacimiento DATE,
    Correo VARCHAR(255),
    Telefono NUMERIC(10),
    Direccion VARCHAR(255),
    NumeroDPI BIGINT
);

-- Crear la tabla Curso
CREATE TABLE Curso (
    CodigoCurso INT PRIMARY KEY,
    NombreCurso VARCHAR(255),
    CreditosNecesarios INT,
    CreditosOtorga INT,
    CarreraID INT,
    EsObligatorio BOOLEAN
);

-- Crear la tabla CursoHabilitado
CREATE TABLE CursoHabilitado (
    CursoHabilitadoID INT AUTO_INCREMENT PRIMARY KEY,
    CursoID INT,
    Ciclo VARCHAR(2),
    DocenteID INT,
    CupoMaximo INT,
    Seccion CHAR(1),
    AnioActual INT,
    CantidadEstudiantesAsignados INT DEFAULT 0
);
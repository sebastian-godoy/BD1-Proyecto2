create database Proyecto2;
use Proyecto2;

CREATE TABLE Carrera (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL
);

CREATE TABLE Estudiante (
    Carnet BIGINT PRIMARY KEY,
    Nombres VARCHAR(255) NOT NULL,
    Apellidos VARCHAR(255) NOT NULL,
    Fecha_nacimiento DATE NOT NULL,
    Correo VARCHAR(255) NOT NULL,
    Telefono BIGINT NOT NULL,
    Direccion VARCHAR(255) NOT NULL,
    Numero_DPI BIGINT NOT NULL,
    Carrera_id INT NOT NULL,
    Creditos INT DEFAULT 0,
    Fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Carrera_id) REFERENCES Carrera(id)
);

CREATE TABLE Curso (
    Codigo INT PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Creditos_necesarios INT NOT NULL,
    Creditos_otorga INT NOT NULL,
    Carrera_id INT,
    Es_obligatorio BOOLEAN NOT NULL,
    FOREIGN KEY (Carrera_id) REFERENCES Carrera(id)
);

CREATE TABLE Curso_habilitado (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Codigo_curso INT,
    Ciclo VARCHAR(2) NOT NULL,
    Docente_id INT NOT NULL,
    Cupo_maximo INT NOT NULL,
    Seccion CHAR(1) NOT NULL,
    Anio_actual INT NOT NULL,
    Estudiantes_asignados INT DEFAULT 0,
    FOREIGN KEY (Codigo_curso) REFERENCES Curso(Codigo),
    FOREIGN KEY (Docente_id) REFERENCES Docentes(Id)
);

CREATE TABLE Asignados (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Carnet_estudiante BIGINT,
    Codigo_curso INT,
    Ciclo VARCHAR(2) NOT NULL,
    Seccion CHAR(1) NOT NULL,
    FOREIGN KEY (Carnet_estudiante) REFERENCES Estudiante(Carnet),
    FOREIGN KEY (Codigo_curso) REFERENCES Curso(Codigo)
);

CREATE TABLE Horario_curso (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Curso_habilitado_id INT,
    Dia_semana INT NOT NULL,
    Horario VARCHAR(255) NOT NULL,
    FOREIGN KEY (Curso_habilitado_id) REFERENCES Curso_habilitado(Id)
);

CREATE TABLE Asignacion_curso (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Codigo_curso INT,
    Ciclo VARCHAR(2) NOT NULL,
    Seccion CHAR(1) NOT NULL,
    Carnet_estudiante BIGINT,
    FOREIGN KEY (Codigo_curso) REFERENCES Curso(Codigo),
    FOREIGN KEY (Carnet_estudiante) REFERENCES Estudiante(Carnet)
);

CREATE TABLE Desasignacion_curso (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Codigo_curso INT,
    Ciclo VARCHAR(2) NOT NULL,
    Seccion CHAR(1) NOT NULL,
    Carnet_estudiante BIGINT,
    FOREIGN KEY (Codigo_curso) REFERENCES Curso(Codigo),
    FOREIGN KEY (Carnet_estudiante) REFERENCES Estudiante(Carnet)
);

CREATE TABLE Nota (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Codigo_curso INT,
    Ciclo VARCHAR(2) NOT NULL,
    Seccion CHAR(1) NOT NULL,
    Carnet_estudiante BIGINT,
    Nota DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (Codigo_curso) REFERENCES Curso(Codigo),
    FOREIGN KEY (Carnet_estudiante) REFERENCES Estudiante(Carnet)
);

CREATE TABLE Acta (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Codigo_curso INT,
    Ciclo VARCHAR(2) NOT NULL,
    Seccion CHAR(1) NOT NULL,
    Fecha_generacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Codigo_curso) REFERENCES Curso(Codigo)
);


DELIMITER //
CREATE PROCEDURE crearCarrera(IN nombre VARCHAR(255))
BEGIN
    INSERT INTO Carrera (Nombre) VALUES (nombre);
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE registrarEstudiante(
    IN carnet BIGINT, 
    IN nombres VARCHAR(255), 
    IN apellidos VARCHAR(255), 
    IN fecha_nacimiento DATE, 
    IN correo VARCHAR(255), 
    IN telefono BIGINT, 
    IN direccion VARCHAR(255), 
    IN numero_dpi BIGINT, 
    IN carrera_id INT
)
BEGIN
    INSERT INTO Estudiante (Carnet, Nombres, Apellidos, Fecha_nacimiento, Correo, Telefono, Direccion, Numero_DPI, Carrera_id)
    VALUES (carnet, nombres, apellidos, fecha_nacimiento, correo, telefono, direccion, numero_dpi, carrera_id);
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE registrarDocente(
    IN nombres VARCHAR(255), 
    IN apellidos VARCHAR(255), 
    IN fecha_nacimiento DATE, 
    IN correo VARCHAR(255), 
    IN telefono BIGINT, 
    IN direccion VARCHAR(255), 
    IN numero_dpi BIGINT, 
    IN registro_siif NUMERIC
)
BEGIN
    INSERT INTO Docentes (Nombres, Apellidos, Fecha_nacimiento, Correo, Telefono, Direccion, Numero_DPI, Registro_SIIF)
    VALUES (nombres, apellidos, fecha_nacimiento, correo, telefono, direccion, numero_dpi, registro_siif);
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE crearCurso(
    IN codigo NUMERIC, 
    IN nombre VARCHAR(255), 
    IN creditos_necesarios NUMERIC, 
    IN creditos_otorga NUMERIC, 
    IN carrera_id INT, 
    IN es_obligatorio BOOLEAN
)
BEGIN
    INSERT INTO Curso (Codigo, Nombre, Creditos_necesarios, Creditos_otorga, Carrera_id, Es_obligatorio)
    VALUES (codigo, nombre, creditos_necesarios, creditos_otorga, carrera_id, es_obligatorio);
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE habilitarCurso(
    IN codigo_curso NUMERIC, 
    IN ciclo VARCHAR(2), 
    IN docente_id INT, 
    IN cupo_maximo NUMERIC, 
    IN seccion CHAR(1)
)
BEGIN
    INSERT INTO Curso_habilitado (Codigo_curso, Ciclo, Docente_id, Cupo_maximo, Seccion, Anio_actual, Estudiantes_asignados)
    VALUES (codigo_curso, ciclo, docente_id, cupo_maximo, seccion, YEAR(CURDATE()), 0);
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE agregarHorario(
    IN id_curso_habilitado INT, 
    IN dia NUMERIC, 
    IN horario VARCHAR(255)
)
BEGIN
    INSERT INTO Horario_curso (Curso_habilitado_id, Dia_semana, Horario)
    VALUES (id_curso_habilitado, dia, horario);
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE asignarCurso(
    IN codigo_curso NUMERIC, 
    IN ciclo VARCHAR(2), 
    IN seccion CHAR(1), 
    IN carnet_estudiante BIGINT
)
BEGIN
    -- Validar que el estudiante no esté asignado al mismo curso o a otra sección
    IF EXISTS (SELECT 1 FROM Asignacion_curso WHERE Codigo_curso = codigo_curso AND Ciclo = ciclo AND Seccion = seccion AND Carnet_estudiante = carnet_estudiante) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El estudiante ya está asignado a este curso o sección';
    END IF;
    
    -- Validar otros criterios, como créditos necesarios, carrera, cupo máximo, etc.
    
    -- Si todas las validaciones son exitosas, realizar la asignación
    INSERT INTO Asignacion_curso (Codigo_curso, Ciclo, Seccion, Carnet_estudiante)
    VALUES (codigo_curso, ciclo, seccion, carnet_estudiante);
    
    -- Actualizar el contador de estudiantes asignados en Curso_habilitado
    UPDATE Curso_habilitado
    SET Estudiantes_asignados = Estudiantes_asignados + 1
    WHERE Id = (SELECT Id FROM Curso_habilitado WHERE Codigo_curso = codigo_curso AND Ciclo = ciclo AND Seccion = seccion AND Anio_actual = YEAR(CURDATE()));
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE desasignarCurso(
    IN codigo_curso NUMERIC, 
    IN ciclo VARCHAR(2), 
    IN seccion CHAR(1), 
    IN carnet_estudiante BIGINT
)
BEGIN
    -- Validar que el estudiante esté asignado a este curso o sección
    IF NOT EXISTS (SELECT 1 FROM Asignacion_curso WHERE Codigo_curso = codigo_curso AND Ciclo = ciclo AND Seccion = seccion AND Carnet_estudiante = carnet_estudiante) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El estudiante no está asignado a este curso o sección';
    END IF;
    
    -- Realizar la desasignación
    DELETE FROM Asignacion_curso
    WHERE Codigo_curso = codigo_curso AND Ciclo = ciclo AND Seccion = seccion AND Carnet_estudiante = carnet_estudiante;
    
    -- Actualizar el contador de estudiantes asignados en Curso_habilitado
    UPDATE Curso_habilitado
    SET Estudiantes_asignados = Estudiantes_asignados - 1
    WHERE Id = (SELECT Id FROM Curso_habilitado WHERE Codigo_curso = codigo_curso AND Ciclo = ciclo AND Seccion = seccion AND Anio_actual = YEAR(CURDATE()));
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ingresarNota(
    IN codigo_curso NUMERIC, 
    IN ciclo VARCHAR(2), 
    IN seccion CHAR(1), 
    IN carnet_estudiante BIGINT, 
    IN nota NUMERIC
)
BEGIN
    -- Validar que el estudiante esté asignado a este curso o sección
    IF NOT EXISTS (SELECT 1 FROM Asignacion_curso WHERE Codigo_curso = codigo_curso AND Ciclo = ciclo AND Seccion = seccion AND Carnet_estudiante = carnet_estudiante) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El estudiante no está asignado a este curso o sección';
    END IF;
    
    -- Insertar la nota (puedes aplicar redondeo aquí si es necesario)
    INSERT INTO Nota (Codigo_curso, Ciclo, Seccion, Carnet_estudiante, Nota)
    VALUES (codigo_curso, ciclo, seccion, carnet_estudiante, nota);
    
    -- Verificar si el estudiante aprobó el curso y actualizar los créditos
    IF nota >= 61 THEN
        UPDATE Estudiante
        SET Creditos = Creditos + (SELECT Creditos_otorga FROM Curso WHERE Codigo = codigo_curso)
        WHERE Carnet = carnet_estudiante;
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE generarActa(
    IN codigo_curso NUMERIC, 
    IN ciclo VARCHAR(2), 
    IN seccion CHAR(1)
)
BEGIN
    -- Verificar si todas las notas están ingresadas
    DECLARE nota_count INT;
    SELECT COUNT(*) INTO nota_count
    FROM Asignacion_curso
    LEFT JOIN Nota ON Asignacion_curso.Carnet_estudiante = Nota.Carnet_estudiante
    WHERE Asignacion_curso.Codigo_curso = codigo_curso
      AND Asignacion_curso.Ciclo = ciclo
      AND Asignacion_curso.Seccion = seccion;

    IF nota_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No todas las notas han sido ingresadas';
    ELSE
        -- Insertar el acta con la fecha y hora actual
        INSERT INTO Acta (Codigo_curso, Ciclo, Seccion, Fecha_generacion)
        VALUES (codigo_curso, ciclo, seccion, NOW());
    END IF;
END;
//
DELIMITER ;






drop database Proyecto2;
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


CREATE TABLE Docentes (
    Id INT AUTO_INCREMENT PRIMARY KEY,  -- Cambiado a INT
    Nombres VARCHAR(255),
    Apellidos VARCHAR(255),
    Fecha_de_nacimiento DATE,
    Correo VARCHAR(255),
    Teléfono NUMERIC,
    Dirección VARCHAR(255),
    Número_de_DPI BIGINT,
    registro_siif NUMERIC  -- Agrega esta columna
);
CREATE INDEX idx_docentes_registro_siif ON Docentes(registro_siif);

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
    Docente_id NUMERIC,  -- Cambiado a INT
    Cupo_maximo INT NOT NULL,
    Seccion CHAR(1) NOT NULL,
    Anio_actual INT NOT NULL,
    Estudiantes_asignados INT DEFAULT 0,
    FOREIGN KEY (Codigo_curso) REFERENCES Curso(Codigo),
    FOREIGN KEY (Docente_id) REFERENCES Docentes(registro_siif)
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
    INSERT INTO Docentes (Nombres, Apellidos, Fecha_de_nacimiento, Correo, Teléfono, Dirección, Número_de_DPI, Registro_SIIF)
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
    IN seccion CHAR(1),
	IN anio_actual INT,
    IN estudiantes_asignados INT
)
BEGIN
    INSERT INTO Curso_habilitado (Codigo_curso, Ciclo, Docente_id, Cupo_maximo, Seccion, Anio_actual, Estudiantes_asignados)
    VALUES (codigo_curso, ciclo, docente_id, cupo_maximo, seccion, YEAR(CURDATE()), estudiantes_asignados);
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
    -- Declarar la variable curso_habilitado_id
    DECLARE curso_habilitado_id INT;

    -- Validar que el estudiante no esté asignado al mismo curso o a otra sección
    IF EXISTS (SELECT 1 FROM Asignacion_curso WHERE Codigo_curso = codigo_curso AND Ciclo = ciclo AND Seccion = seccion AND Carnet_estudiante = carnet_estudiante) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El estudiante ya está asignado a este curso o sección';
    END IF;

    -- Obtener el Id del Curso_habilitado
    SELECT Id INTO curso_habilitado_id FROM Curso_habilitado WHERE Codigo_curso = codigo_curso AND Ciclo = ciclo AND Seccion = seccion AND Anio_actual = YEAR(CURDATE());

    -- Si todas las validaciones son exitosas, realizar la asignación
    INSERT INTO Asignacion_curso (Codigo_curso, Ciclo, Seccion, Carnet_estudiante)
    VALUES (codigo_curso, ciclo, seccion, carnet_estudiante);
    
    -- Actualizar el contador de estudiantes asignados en Curso_habilitado
    UPDATE Curso_habilitado
    SET Estudiantes_asignados = Estudiantes_asignados + 1
    WHERE Id = curso_habilitado_id;
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
    -- Declarar la variable curso_habilitado_id
    DECLARE curso_habilitado_id INT;

    -- Validar que el estudiante esté asignado a este curso o sección
    IF NOT EXISTS (SELECT 1 FROM Asignacion_curso WHERE Codigo_curso = codigo_curso AND Ciclo = ciclo AND Seccion = seccion AND Carnet_estudiante = carnet_estudiante) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El estudiante no está asignado a este curso o sección';
    END IF;

    -- Obtener el Id del Curso_habilitado
    SELECT Id INTO curso_habilitado_id FROM Curso_habilitado WHERE Codigo_curso = codigo_curso AND Ciclo = ciclo AND Seccion = seccion AND Anio_actual = YEAR(CURDATE());

    -- Realizar la desasignación
    DELETE FROM Asignacion_curso
    WHERE Codigo_curso = codigo_curso AND Ciclo = ciclo AND Seccion = seccion AND Carnet_estudiante = carnet_estudiante;
    
    -- Actualizar el contador de estudiantes asignados en Curso_habilitado
    UPDATE Curso_habilitado
    SET Estudiantes_asignados = Estudiantes_asignados - 1
    WHERE Id = curso_habilitado_id;
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

DELIMITER //
CREATE PROCEDURE consultarPensum(IN codigo_carrera INT)
BEGIN
    SELECT Codigo, Nombre, 
           CASE WHEN Es_obligatorio = 1 THEN 'Sí' ELSE 'No' END AS Es_obligatorio,
           Creditos_necesarios
    FROM Curso
    WHERE Carrera_id = codigo_carrera;
END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE consultarEstudiante(IN carnet_estudiante BIGINT)
BEGIN
    SELECT e.Carnet, CONCAT(e.Nombres, ' ', e.Apellidos) AS Nombre_completo, 
           e.Fecha_nacimiento, e.Correo, e.Telefono, e.Direccion, e.Numero_DPI, 
           c.Nombre AS Carrera, e.Creditos
    FROM Estudiante e
    INNER JOIN Carrera c ON e.Carrera_id = c.id
    WHERE e.Carnet = carnet_estudiante;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE consultarDocente(IN registro_siif INT)
BEGIN
    SELECT Registro_SIIF, CONCAT(Nombres, ' ', Apellidos) AS Nombre_completo, 
           Fecha_de_nacimiento, Correo, Teléfono, Dirección, Número_de_DPI
    FROM Docentes
    WHERE Registro_SIIF = registro_siif;
END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE consultarAsignados(
    IN codigo_curso INT, 
    IN ciclo VARCHAR(2), 
    IN anio INT, 
    IN seccion CHAR(1)
)
BEGIN
    SELECT ac.Carnet, CONCAT(e.Nombres, ' ', e.Apellidos) AS Nombre_completo, 
           e.Creditos
    FROM Asignacion_curso ac
    INNER JOIN Estudiante e ON ac.Carnet = e.Carnet
    WHERE ac.Codigo_curso = codigo_curso AND ac.Ciclo = ciclo AND ac.Anio = anio AND ac.Seccion = seccion;
END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE consultarAprobacion(
    IN codigo_curso INT, 
    IN ciclo VARCHAR(2), 
    IN anio INT, 
    IN seccion CHAR(1)
)
BEGIN
    SELECT ac.Codigo_curso, ac.Carnet, CONCAT(e.Nombres, ' ', e.Apellidos) AS Nombre_completo, 
           CASE WHEN n.Nota >= 61 THEN 'APROBADO' ELSE 'DESAPROBADO' END AS Estado
    FROM Asignacion_curso ac
    INNER JOIN Estudiante e ON ac.Carnet = e.Carnet
    LEFT JOIN Nota n ON ac.Carnet = n.Carnet_estudiante AND ac.Codigo_curso = n.Codigo_curso
    WHERE ac.Codigo_curso = codigo_curso AND ac.Ciclo = ciclo AND ac.Anio = anio AND ac.Seccion = seccion;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE consultarActas(IN codigo_curso INT)
BEGIN
    SELECT a.Codigo_curso, a.Seccion,
           CASE 
               WHEN a.Ciclo = '1S' THEN 'PRIMER SEMESTRE'
               WHEN a.Ciclo = '2S' THEN 'SEGUNDO SEMESTRE'
               WHEN a.Ciclo = 'VJ' THEN 'VACACIONES DE JUNIO'
               WHEN a.Ciclo = 'VD' THEN 'VACACIONES DE DICIEMBRE'
               ELSE a.Ciclo
           END AS Ciclo, 
           a.Anio, a.Cantidad_estudiantes, a.Fecha_generacion
    FROM Acta a
    WHERE a.Codigo_curso = codigo_curso
    ORDER BY a.Fecha_generacion;
END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE consultarDesasignacion(

    IN codigo_curso INT, 
    IN ciclo VARCHAR(2), 
    IN anio INT, 
    IN seccion CHAR(1)
)
BEGIN
    DECLARE total_estudiantes INT;
    DECLARE total_desasignados INT;

    SELECT COUNT(*) INTO total_estudiantes
    FROM Asignacion_curso
    WHERE Codigo_curso = codigo_curso AND Ciclo = ciclo AND Anio = anio AND Seccion = seccion;

    SELECT COUNT(*) INTO total_desasignados
    FROM Desasignacion_curso
    WHERE Codigo_curso = codigo_curso AND Ciclo = ciclo AND Anio = anio AND Seccion = seccion;

    IF total_estudiantes = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay estudiantes asignados a este curso y sección.';
    ELSE
        SELECT total_estudiantes AS Cantidad_estudiantes, total_desasignados AS Cantidad_desasignados,
               (total_desasignados / total_estudiantes * 100) AS Porcentaje_desasignacion;
    END IF;
END;
//
DELIMITER ;

CALL crearCarrera('Ingeniería Informática');
CALL registrarEstudiante(123456789, 'Juan', 'Pérez', '1995-05-15', 'juan@example.com', 1234567890, '123 Main St', 1234567890123, 1);
CALL registrarDocente('María', 'González', '1980-10-20', 'maria@example.com', 9876543210, '456 Elm St', 9876543210123, 1001);
CALL crearCurso(101, 'Introducción a la Programación', 4, 4, 1, 1);
CALL habilitarCurso(101, '1S', 1001, 30, 'A','5','51');
CALL agregarHorario(1, 1, 'Lunes 10:00 AM - 12:00 PM');
CALL asignarCurso(101, '1S', 'A', 123456789);
CALL ingresarNota(101, '1S', 'A', 123456789, 85);
-- CALL ingresarNota(101, '1S', 'A', 123456789, 85);
CALL generarActa(101, '1S', 'A');
CALL consultarPensum(1); -- Consultar el pensum de la carrera con ID 1
CALL consultarEstudiante(123456789); -- Consultar el estudiante con carnet 123456789
CALL consultarDocente(1001); -- Consultar el docente con registro SIIF 1001
CALL consultarAsignados(101, '1S', 2023, 'A'); -- Consultar los estudiantes asignados a un curso en el primer semestre del 2023 en la sección 'A'
CALL consultarAprobacion(101, '1S', 2023, 'A'); -- Consultar si los estudiantes aprobaron o desaprobaron un curso en el primer semestre del 2023 en la sección 'A'
CALL desasignarCurso(101, '1S', 'A', 123456789);


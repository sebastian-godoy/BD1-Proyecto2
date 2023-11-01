drop database Proyecto2;
create database Proyecto2;
use Proyecto2;


CREATE TABLE Carrera (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL UNIQUE
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
    IN fecha_nacimiento VARCHAR(10),  -- Cambiado el tipo de dato a VARCHAR
    IN correo VARCHAR(255), 
    IN telefono BIGINT, 
    IN direccion VARCHAR(255), 
    IN numero_dpi BIGINT, 
    IN carrera_id INT
)
BEGIN
    -- Convertir la fecha al formato 'YYYY-MM-DD'
    SET fecha_nacimiento = STR_TO_DATE(fecha_nacimiento, '%d-%m-%Y');

    -- Insertar los datos en la tabla
    INSERT INTO Estudiante (Carnet, Nombres, Apellidos, Fecha_nacimiento, Correo, Telefono, Direccion, Numero_DPI, Carrera_id)
    VALUES (carnet, nombres, apellidos, fecha_nacimiento, correo, telefono, direccion, numero_dpi, carrera_id);
END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE registrarDocente(
    IN nombres VARCHAR(255), 
    IN apellidos VARCHAR(255), 
    IN fecha_nacimiento VARCHAR(10),  -- Cambiado el tipo de dato a VARCHAR
    IN correo VARCHAR(255), 
    IN telefono BIGINT, 
    IN direccion VARCHAR(255), 
    IN numero_dpi BIGINT, 
    IN registro_siif NUMERIC
)
BEGIN
    -- Convertir la fecha al formato 'YYYY-MM-DD'
    SET fecha_nacimiento = STR_TO_DATE(fecha_nacimiento, '%d-%m-%Y');

    -- Insertar los datos en la tabla
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
    SELECT ac.Carnet_estudiante, CONCAT(e.Nombres, ' ', e.Apellidos) AS Nombre_completo, e.Creditos
    FROM Asignados ac  -- Cambiar a la tabla 'Asignados' en lugar de 'Asignacion_curso'
    INNER JOIN Estudiante e ON ac.Carnet_estudiante = e.Carnet
    WHERE ac.Codigo_curso = codigo_curso AND ac.Ciclo = ciclo AND ac.Seccion = seccion; -- Eliminar la condición de 'Anio'
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


-- PRUEBAS DEL AUX
CALL crearCarrera('Ingenieria Civil');       -- 1  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Industrial');  -- 2  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Sistemas');    -- 3  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Electronica'); -- 4  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Mecanica');    -- 5  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Mecatronica'); -- 6  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Quimica');     -- 7  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Ambiental');   -- 8  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Materiales');  -- 9  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Textil');      -- 10 VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE

-- REGISTRO DE DOCENTES
CALL registrarDocente('Docente1','Apellido1','30-10-1999','aadf@ingenieria.usac.edu.gt',12345678,'direccion',12345678910,1);
CALL registrarDocente('Docente2','Apellido2','20-11-1999','docente2@ingenieria.usac.edu.gt',12345678,'direcciondocente2',12345678911,2);
CALL registrarDocente('Docente3','Apellido3','20-12-1980','docente3@ingenieria.usac.edu.gt',12345678,'direcciondocente3',12345678912,3);
CALL registrarDocente('Docente4','Apellido4','20-11-1981','docente4@ingenieria.usac.edu.gt',12345678,'direcciondocente4',12345678913,4);
CALL registrarDocente('Docente5','Apellido5','20-09-1982','docente5@ingenieria.usac.edu.gt',12345678,'direcciondocente5',12345678914,5);

-- REGISTRO DE ESTUDIANTES
-- SISTEMAS
CALL registrarEstudiante(202000001,'Estudiante de','Sistemas Uno','30-10-1999','sistemasuno@gmail.com',12345678,'direccion estudiantes sistemas 1',337859510101,3);
CALL registrarEstudiante(202000002,'Estudiante de','Sistemas Dos','3-5-2000','sistemasdos@gmail.com',12345678,'direccion estudiantes sistemas 2',32781580101,3);
CALL registrarEstudiante(202000003,'Estudiante de','Sistemas Tres','3-5-2002','sistemastres@gmail.com',12345678,'direccion estudiantes sistemas 3',32791580101,3);
-- CIVIL
CALL registrarEstudiante(202100001,'Estudiante de','Civil Uno','3-5-1990','civiluno@gmail.com',12345678,'direccion de estudiante civil 1',3182781580101,1);
CALL registrarEstudiante(202100002,'Estudiante de','Civil Dos','03-08-1998','civildos@gmail.com',12345678,'direccion de estudiante civil 2',3181781580101,1);
-- INDUSTRIAL
CALL registrarEstudiante(202200001,'Estudiante de','Industrial Uno','30-10-1999','industrialuno@gmail.com',12345678,'direccion de estudiante industrial 1',3878168901,2);
CALL registrarEstudiante(202200002,'Estudiante de','Industrial Dos','20-10-1994','industrialdos@gmail.com',89765432,'direccion de estudiante industrial 2',29781580101,2);
-- ELECTRONICA
CALL registrarEstudiante(202300001, 'Estudiante de','Electronica Uno','20-10-2005','electronicauno@gmail.com',89765432,'direccion de estudiante electronica 1',29761580101,4);
CALL registrarEstudiante(202300002, 'Estudiante de','Electronica Dos', '01-01-2008','electronicados@gmail.com',12345678,'direccion de estudiante electronica 2',387916890101,4);
-- ESTUDIANTES RANDOM
CALL registrarEstudiante(201710160, 'ESTUDIANTE','SISTEMAS RANDOM','20-08-1994','estudiasist@gmail.com',89765432,'direccionestudisist random',29791580101,3);
CALL registrarEstudiante(201710161, 'ESTUDIANTE','CIVIL RANDOM','20-08-1995','estudiacivl@gmail.com',89765432,'direccionestudicivl random',30791580101,1);

-- AGREGAR CURSO
-- aqui se debe de agregar el AREA COMUN a carrera
-- Insertar el registro con id 0
INSERT INTO carrera (id,nombre) VALUES (0,'Area Comun');
UPDATE carrera SET id = 0 WHERE id = LAST_INSERT_ID();
-- AREA COMUN
CALL crearCurso(0006,'Idioma Tecnico 1',0,7,0,false); 
CALL crearCurso(0007,'Idioma Tecnico 2',0,7,0,false);
CALL crearCurso(101,'MB 1',0,7,0,true); 
CALL crearCurso(103,'MB 2',0,7,0,true); 
CALL crearCurso(017,'SOCIAL HUMANISTICA 1',0,4,0,true); 
CALL crearCurso(019,'SOCIAL HUMANISTICA 2',0,4,0,true); 
CALL crearCurso(348,'QUIMICA GENERAL',0,3,0,true); 
CALL crearCurso(349,'QUIMICA GENERAL LABORATORIO',0,1,0,true);
-- INGENIERIA EN SISTEMAS
CALL crearCurso(777,'Compiladores 1',80,4,3,true); 
CALL crearCurso(770,'INTR. A la Programacion y computacion 1',0,4,3,true); 
CALL crearCurso(960,'MATE COMPUTO 1',33,5,3,true); 
CALL crearCurso(795,'lOGICA DE SISTEMAS',33,2,3,true);
CALL crearCurso(796,'LENGUAJES FORMALES Y DE PROGRAMACIÓN',0,3,3,TRUE);
-- INGENIERIA INDUSTRIAL
CALL crearCurso(123,'Curso Industrial 1',0,4,2,true); 
CALL crearCurso(124,'Curso Industrial 2',0,4,2,true);
CALL crearCurso(125,'Curso Industrial enseñar a pensar',10,2,2,false);
CALL crearCurso(126,'Curso Industrial ENSEÑAR A DIBUJAR',2,4,2,true);
CALL crearCurso(127,'Curso Industrial 3',8,4,2,true);
-- INGENIERIA CIVIL
CALL crearCurso(321,'Curso Civil 1',0,4,1,true);
CALL crearCurso(322,'Curso Civil 2',4,4,1,true);
CALL crearCurso(323,'Curso Civil 3',8,4,1,true);
CALL crearCurso(324,'Curso Civil 4',12,4,1,true);
CALL crearCurso(325,'Curso Civil 5',16,4,1,false);
CALL crearCurso(0250,'Mecanica de Fluidos',0,5,1,true);
-- INGENIERIA ELECTRONICA
CALL crearCurso(421,'Curso Electronica 1',0,4,4,true);
CALL crearCurso(422,'Curso Electronica 2',4,4,4,true);
CALL crearCurso(423,'Curso Electronica 3',8,4,4,false);
CALL crearCurso(424,'Curso Electronica 4',12,4,4,true);
CALL crearCurso(425,'Curso Electronica 5',16,4,4,true);






-- PRUEBAS DE CALIFICACION 2
CALL registrarEstudiante(202500001,'Estudiante de','Sistemas Calificacion','31-10-2023','sistemascalificacion@gmail.com',12345678,'direccion Sistemas calificacion',42792920101,3); -- OK
CALL registrarEstudiante(202100002,'Estudiante de','Civil Dos','03-08-1998','civildos@gmail.com',12345678,'direccion de estudiante civil 2',3181781580101,1); -- YA EXISTE
CALL registrarEstudiante(202400002,'Estudiante de','carrear inexistente','03-08-1998','civildos@gmail.com',12345678,'direccion de estudiante civil 2',3181781580101,100); -- NO EXISTE CARRERA
-- REGISTRO DE CARRERAS
CALL crearCarrera('Carrera de calificacion');    -- OK
CALL crearCarrera('Ingenieria Sistemas');    -- YA EXISTE
CALL crearCarrera('C@RR3ER@ N0 TI3N3 S010 13ETRAS');    -- CARRERA NO TIENE SOLO LETRAS
-- REGISTRO DE DOCENTES 
CALL registrarDocente('Docente','De Calificacion','20-12-1980','docentecali@ingenieria.usac.edu.gt',12345678,'direcciondocentecalificacion',12345678912,100); -- OK
CALL registrarDocente('Docente3','Apellido3','20-12-1980','docente3@ingenieria.usac.edu.gt',12345678,'direcciondocente3',12345678912,3); -- YA EXISTE
CALL registrarDocente('Docente con','correo incorrect','20-12-1980','docente3ingenieria.usac.edu.gt',12345678,'direcciondocente3',12345678912,20); -- CORREO INVALIDO
-- AGREGAR CURSO
CALL crearCurso(778,'Curso Calificacion',0,4,3,false); -- OK
CALL crearCurso(503802,'curso negativo',-2,4,2,true); -- CURSO CON NUMEROS NEGATIVOS
CALL crearCurso(503802,'curso sin carrera',2,4,1000,true); -- no existe carrera

-- AGREGAR CURSO HABILITADO
CALL habilitarCurso(101,'2S',100,3,'A'); -- OK AREA COMUN
CALL habilitarCurso(778,'2S',1,2,'A'); -- OK AREA PROFESIONAL SISTEMAS
CALL habilitarCurso(101,'2S',100,3,'2'); -- SECCION NO ES UNA LETRA

-- AGREGAR HORARIO DE CURSO HABILITADO
CALL agregarHorario(1,3,"9:00-10:40"); -- SE PUEDE MODIFICAR PRIMER NUMERO (ID CURSO HABILITADO)
CALL agregarHorario(2,3,"17:00-18:40"); -- SE PUEDE MODIFICAR PRIMER NUMERO (ID CURSO HABILITADO)
CALL agregarHorario(1000,3,"17:00-18:40"); -- id de curso habilidato no existe
CALL agregarHorario(1,100,"17:00-18:40"); -- dia fuera de rango

-- ASIGNAR CURSO ESTUDIANTE
-- codcurso, ciclo, seccion, carnet
CALL asignarCurso(101,'2S','a',202000001); -- AREA COMUN OK
CALL asignarCurso(101,'2S','a',202100001); -- AREA COMUN OK
CALL asignarCurso(101,'2S','a',202200001); -- AREA COMUN OK
-- area profesional
CALL asignarCurso(778,'2S','a',202000001); -- AREA PROFESIONAL SISTEMAS OK
CALL asignarCurso(778,'2S','a',202000002); -- AREA PROFESIONAL SISTEMAS OK
CALL asignarCurso(778,'2S','a',202100001); -- AREA PROFESIONAL SISTEMAS ESTUDIANTE NO PUEDE LLEVAR CURSO DE OTRA CARRERA
CALL asignarCurso(101,'2S','a',202300001); -- AREA COMUN SE LLEGO AL LIMITE DE ASIGNADOS
CALL asignarCurso(101,'2S','a',202200001); -- AREA COMUN ESTUDIANTE YA ASIGNADO
CALL asignarCurso(101,'2S','a',123456789); -- CARNET NO EXISTE
CALL asignarCurso(101,'2S','Z',202800002); -- SECCION NO EXISTE

-- DESASIGNAR CURSO ESTUDIANTE
CALL desasignarCurso(101,'2S','a',202200001); -- curso desasignado ok
CALL desasignarCurso(101,'2S','a',201709311); -- no existe el estudiante en la seccion

-- INGRESAR NOTA
CALL ingresarNota(101,'2S','a',202000001,-61); -- ERROR EN NOTA
CALL ingresarNota(101,'2S','a',202000001,61);
CALL ingresarNota(101,'2S','a',202100001,60.4);

-- GENERAR ACTA
CALL generarActa(101,'2S','a'); -- OK
CALL generarActa(778,'2S','a'); -- NO SE HA INGRESADO NOTAS


-- CALIFICACION DE PROCESAMIENTO DE DATOS
-- CONSULTA 1
CALL consultarPensum(3);
CALL consultarPensum(4);
-- CONSULTA 2
CALL consultarEstudiante(202000001);
CALL consultarEstudiante(202000002);
CALL consultarEstudiante(202100002);
CALL consultarEstudiante(202500001);
-- CONSULTA 3
CALL consultarDocente(1);
CALL consultarDocente(100);
-- CONSULTA 4
CALL consultarAsignados(101, '2S', 2023, 'A');
CALL consultarAsignados(778, '2S', 2023, 'A');
-- CONSULTA 5
CALL consultarAprobacion(101, '2S', 2023, 'A');
CALL consultarAprobacion(778, '2S', 2023, 'A');
-- CONSULTA 6
CALL consultarActas(101);
CALL consultarActas(778);
-- CONSULTA 7
call consultarDesasignacion(101, '2S', 2023, 'A');
call consultarDesasignacion(778, '2S', 2023, 'A');



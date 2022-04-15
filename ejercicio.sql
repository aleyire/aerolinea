---crear BD
CREATE DATABASE aerolinea_db;
-- creando tablas
CREATE TABLE pasajeros (
    rut VARCHAR(255) NOT null PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL
);
CREATE TABLE vuelos (
    id serial not null primary key,
    ruta VARCHAR(255) NOT NULL,
    stock_asientos INT check ((stock_asientos > 0 and stock_asientos <= 200)),
    horario_despegue timestamp NOT NULL,
    horario_aterrizaje timestamp NOT NULL
);
CREATE TABLE boletos (
    id serial not null primary key,
    pasajeros_rut_fk VARCHAR(255),
    vuelos_fk INT not NULL,
    precio INT not null,
    FOREIGN KEY (pasajeros_rut_fk) references pasajeros(rut),
    FOREIGN KEY (vuelos_fk) references vuelos(id)
);
--Agregar 5 vuelos
BEGIN TRANSACTION;
INSERT INTO vuelos (ruta, stock_asientos, horario_despegue,horario_aterrizaje) VALUES ('Santiago-Dubai',200,'2022-04-14 09:59:59','2022-04-14 15:59:59');
INSERT INTO vuelos (ruta, stock_asientos, horario_despegue,horario_aterrizaje) VALUES ('Santiago-Milan',200,'2022-05-14 19:00:13','2022-04-15 01:00:13');
INSERT INTO vuelos (ruta, stock_asientos, horario_despegue,horario_aterrizaje) VALUES ('Santiago- Marruecos',200,'2022-04-14 09:59:59','2022-04-14 12:59:59');
INSERT INTO vuelos (ruta, stock_asientos, horario_despegue,horario_aterrizaje) VALUES ('Santiago- Cancún',200,'2022-04-16 13:59:12','2022-04-16 22:59:12');
INSERT INTO vuelos (ruta, stock_asientos, horario_despegue,horario_aterrizaje) VALUES ('Santiago-Zurich',200,'2022-04-12 09:14:59','2022-04-13 10:14:59');
commit;
--Agregar 5 pasajeros
BEGIN TRANSACTION;
INSERT INTO pasajeros (rut, nombre, apellido) VALUES ('17431170-0','Maria Kika','Lay');
INSERT INTO pasajeros (rut, nombre, apellido) VALUES ('17191453-1','Maria Alejandra','Barria');
INSERT INTO pasajeros (rut, nombre, apellido) VALUES ('2655448-9','Maria Adriana','Oviedo');
INSERT INTO pasajeros (rut, nombre, apellido) VALUES ('22638027-2','Martin','Lay');
INSERT INTO pasajeros (rut, nombre, apellido) VALUES ('12345678-9','Brat','Pit');
commit;
--Con transacción comprar un boleto (vuelo 1) a su nombre (pasajero 1)
BEGIN TRANSACTION;
INSERT INTO boletos (pasajeros_rut_fk,vuelos_fk, precio ) VALUES ('17431170-0',11,100000);
UPDATE vuelos SET stock_asientos = stock_asientos - 1 WHERE id = 11;
COMMIT;
--luego cambiar de vuelo (vuelo 3)
BEGIN TRANSACTION;
UPDATE vuelos SET stock_asientos = stock_asientos - 1 WHERE id = 13;
UPDATE vuelos SET stock_asientos = stock_asientos + 1 WHERE id = 11;
COMMIT;
--mostrar que el vuelo inicial vuelva a quedar con la cantidad de asientos disponibles
SELECT * FROM vuelos;
--comprar 5 vuelos más y mostrar el total que ha ganado la aerolínea
BEGIN TRANSACTION;
INSERT INTO boletos (pasajeros_rut_fk,vuelos_fk, precio ) VALUES ('17191453-1',13,100000);
UPDATE vuelos SET stock_asientos = stock_asientos - 1 WHERE id = 13;
INSERT INTO boletos (pasajeros_rut_fk,vuelos_fk, precio ) VALUES ('2655448-9',11,100000);
UPDATE vuelos SET stock_asientos = stock_asientos - 1 WHERE id = 11;
INSERT INTO boletos (pasajeros_rut_fk,vuelos_fk, precio ) VALUES ('17431170-0',15,100000);
UPDATE vuelos SET stock_asientos = stock_asientos - 1 WHERE id = 15;
INSERT INTO boletos (pasajeros_rut_fk,vuelos_fk, precio ) VALUES ('17431170-0',13,100000);
UPDATE vuelos SET stock_asientos = stock_asientos - 1 WHERE id = 13;
INSERT INTO boletos (pasajeros_rut_fk,vuelos_fk, precio ) VALUES ('22638027-2',11,100000);
UPDATE vuelos SET stock_asientos = stock_asientos - 1 WHERE id = 11;
COMMIT;
SELECT sum(boletos.precio) as ganancia_total
FROM boletos
INNER JOIN vuelos ON boletos.vuelos_fk = vuelos.id;
--Mostrar que vuelo tiene más asientos disponibles
select * from vuelos where stock_asientos = (select max(stock_asientos) from vuelos) ;
-- Mostrar que vuelo tiene menos asientos disponibles
select * from vuelos where stock_asientos = (select min(stock_asientos) from vuelos) ;
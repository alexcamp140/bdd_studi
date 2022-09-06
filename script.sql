DROP TABLE IF EXISTS utilisateur_complexe;
DROP TABLE IF EXISTS utilisateur;

CREATE TABLE utilisateur (
id int(11) NOT NULL AUTO_INCREMENT,
login varchar(20) NOT NULL,
nom varchar(255) NOT NULL,
prenom varchar(255) NOT NULL,
password  varchar(50) NOT NULL,
role enum('admin', 'utilisateur', 'hote') NOT NULL,
PRIMARY KEY (id)
);

INSERT INTO utilisateur(login,nom, prenom, password, role) VALUES
('adu06','dubois', 'alexandre', sha('r8coZ32-mx'), 'admin'),
('jbo25','bourdin', 'jean-jacques', sha('rbz32*5296E'), 'utilisateur'),
('tdu09','dupond', 'tintin', sha('Oplu056--bz'), 'utilisateur');

CREATE TABLE complexe(
id SMALLINT NOT NULL AUTO_INCREMENT,
nom varchar(255) DEFAULT NULL,
adresse varchar(255) DEFAULT NULL,
code_postal char(5) DEFAULT NULL,
ville varchar(255) DEFAULT NULL,
site_internet  varchar(255) DEFAULT NULL,
num_tel  char(10) DEFAULT NULL,
PRIMARY KEY (id)
);

INSERT INTO complexe (id, nom, adresse, code_postal, ville, site_internet, num_tel) VALUES
(1, 'UGC lille', 'rue de Bethune','59000','Lille','https://www.lille.ugc.fr', '0321225566'),
(2, 'UGC Heron Parc', 'Avenue de l\'avenir','59491', 'Villeneuve d\'Ascq','https://www.v2.ugc.fr', '0365554478');

DROP TABLE IF EXISTS utilisateur_complexe;
CREATE TABLE utilisateur_complexe(
id_utilisateur int(11) NOT NULL,
id_complexe SMALLINT NOT NULL,
PRIMARY KEY (id_utilisateur, id_complexe)
);

INSERT INTO utilisateur_complexe(id_utilisateur, id_complexe) values
('1',1),
('1',2),
('2',1),
('3',2);

ALTER TABLE utilisateur_complexe ADD CONSTRAINT utilisateur_fk FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;
ALTER TABLE utilisateur_complexe ADD CONSTRAINT complexe_fk FOREIGN KEY (id_complexe) REFERENCES complexe(id) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;

DROP TABLE IF EXISTS salle;

CREATE TABLE salle (
id INT(11) NOT NULL AUTO_INCREMENT,
id_complexe SMALLINT NOT NULL,
nom varchar(255) DEFAULT NULL,
nb_place int(11) NOT NULL,
PRIMARY KEY (id),
KEY id_complexe (id_complexe)
);

INSERT INTO salle ( id_complexe, nom, nb_place) VALUES
( 1, '01', 64),
( 2, '02', 65),
( 1, 'Ibiza', 70);

ALTER TABLE salle
ADD CONSTRAINT salle_fk FOREIGN KEY (id_complexe) REFERENCES complexe(id) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;

DROP TABLE IF EXISTS classification;
CREATE TABLE classification (
id INT(2) not null AUTO_INCREMENT,
label varchar(255) not null,
primary key(id)
);

insert into classification (label) values
('Tous publics'),
('Avertissement'),
('Interdit aux moins de 12 ans'),
('Interdit aux moins de 16 ans'),
('Interdit aux moins de 18 ans');

DROP TABLE IF EXISTS genre;
CREATE TABLE genre(
id INT(3) not null AUTO_INCREMENT,
label varchar(255) not null,
primary key(id)
);

insert into genre (label) values
('Action'),
('Aventures'),
('Biopic'),
('Comédie'),
('Comédie musicale'),
('Comédie musicale'),
('Drame'),
('Espionnage'),
('Catastrophe'),
('Guerre'),
('Science-fiction'),
('Historique'),
('Western'),
('Policier'),
('Péplum'),
('Fantastique');

DROP TABLE IF EXISTS film;
CREATE TABLE film (
id INT(11) not null AUTO_INCREMENT,
titre varchar(255) not null,
duree int(3) not null,
realisateur varchar(255),
resume text not null,
id_classification int(2) not null,
id_genre int(3) not null,
primary key (id),
key id_classification(id_classification),
key id_genre(id_genre)
);

insert into film (titre,duree,realisateur,resume, id_classification, id_genre) values
('Rumba la vie',103, 'Franck DUBOSK','Tony, la cinquantaine, chauffeur d\’autobus scolaire renfermé sur lui-même, vit seul après avoir abandonné femme et enfant vingt ans plus tôt. Bousculé par un malaise cardiaque, il trouve le courage nécessaire pour affronter son passé.',1,4),
('Les Vieux fourneaux 2 : bons pour l\’asile', 117, 'Christophe DUTHURON', 'Pour venir en aide à des migrants qu\’il cachait à Paris, Pierrot les conduit dans le Sud-Ouest chez Antoine qui lui-même accueille déjà Mimile, en pleine reconquête amoureuse de Berthe. S\’attendant à trouver à la campagne, les six réfugiés goûteront surtout à la légendaire hospitalité d\’un village français.',1,4),
('Tad l\'explorateur et la table d\'émeraude', 90, 'Enrique Gato','Le rêve de Tad Stones est d\’être reconnu comme un grand archéologue mais toutes ses tentatives pour se faire accepter par Ryan, le brillant chef d\’expédition et ses collègues tournent au fiasco. En ouvrant un sarcophage, il déclenche une malédiction qui va mettre la vie de ses amis en danger.', 1,2);

ALTER TABLE film
ADD CONSTRAINT classificaton_fk FOREIGN KEY (id_classification) REFERENCES classification(id) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;

ALTER TABLE film
ADD CONSTRAINT genre_fk FOREIGN KEY (id_genre) REFERENCES genre(id) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;


DROP TABLE if exists seance;
CREATE TABLE seance(
id INT(11) NOT NULL AUTO_INCREMENT,
date_debut datetime DEFAULT NULL,
date_fin datetime DEFAULT NULL,
id_salle INT NOT NULL,
id_film INT NOT NULL,
PRIMARY KEY (id),
KEY id_salle (id_salle),
KEY id_film (id_film)
);

insert into seance (date_debut, date_fin, id_salle,id_film) VALUES
('2022-08-30 20:00:00','2022-08-30 22:00:00',1,1  ),
('2022-08-31 16:30:00','2022-08-31 18:30:00',2,2  ),
('2022-09-15 19:00:00','2022-08-31 21:30:00',2,3  ),
('2022-09-18 19:00:00','2022-08-31 21:30:00',2,3  ),
('2022-10-01 19:00:00','2022-08-31 21:30:00',3,2  );

ALTER TABLE seance
ADD CONSTRAINT seance_fk FOREIGN KEY (id_salle) REFERENCES salle(id) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;

ALTER TABLE seance
ADD CONSTRAINT film_fk FOREIGN KEY (id_film) REFERENCES film(id) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;

drop table if exists tarif;
CREATE TABLE tarif(
id INT(11) NOT NULL AUTO_INCREMENT,
type enum ('étudiant','plein tarif', 'moins de 14 ans' ),
montant INT(11),
PRIMARY KEY (id)
);

insert into tarif (type, montant) values
('étudiant','700'),
('plein tarif','1000'),
('moins de 14 ans','500');


drop table if exists client;
CREATE TABLE client (
id int(11) NOT NULL AUTO_INCREMENT,
reference varchar(20) NOT NULL,
nom varchar(150) NOT NULL,
prenom varchar(150) NOT NULL,
login varchar(150) NOT NULL,
password  varchar(50) NOT NULL,
PRIMARY KEY (id)
);

insert into client (reference, nom, prenom, login, password) VALUES
('CLI001','Rousseau', 'Jean-Jacques', 'jjrousseau39@hotmail.com', sha('monPassword-08')),
('CLI5595','Terieur', 'Alain', 'tunninglainlain@gmail.com', sha('*-9558Pmoibc2')),
('CLI8524','Nina', 'Lulu', 'ninilulu@free.fr', sha('?Azerty123'));

drop table if exists reservation;
CREATE TABLE reservation(
num_reservation INT(11) NOT NULL AUTO_INCREMENT,
date_reservation datetime DEFAULT NULL,
status enum('paiement effectue', 'paiement en attente','remboursé') not null,
id_client int(11) DEFAULT NULL,
id_utilisateur int(11) DEFAULT NULL,
PRIMARY KEY (num_reservation),
KEY id_utilisateur(id_utilisateur),
KEY id_client(id_client)
);

alter table reservation
ADD CONSTRAINT resa_client_fk FOREIGN KEY (id_client) REFERENCES client(id) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;

insert into reservation(date_reservation,status, id_client, id_utilisateur) values
(sysdate(),'paiement en attente', 1,null),
(sysdate(),'paiement effectue', null,3),
(sysdate(),'remboursé', null,2),
(sysdate(),'paiement effectue', 2,null);

create table paiement(
id int(11) not null AUTO_INCREMENT,
type enum('espece', 'cb', 'visa'),
montant int(11) not null,
date_paiement datetime not null,
num_reservation int(11) not null,
PRIMARY KEY (id),
key num_reservation(num_reservation)
);

alter table paiement
ADD CONSTRAINT paiement_FK FOREIGN KEY (num_reservation) REFERENCES reservation(num_reservation) ON DELETE CASCADE ON UPDATE NO ACTION;
commit;

insert INTO paiement( type, montant, date_paiement, num_reservation) VALUES
('visa', 2100, sysdate(), 2),
('espece', 1500, sysdate(), 3);

create table reservation_seance(
id int(11) not NULL AUTO_INCREMENT,
num_reservation int(11) not null,
id_tarif int(11) not null,
nb_place int(2) not null,
id_seance int(11) not null,
PRIMARY KEY (id),
KEY num_reservation(num_reservation),
KEY id_tarif(id_tarif),
KEY id_seance(id_seance)
);

ALTER TABLE reservation_seance
ADD CONSTRAINT num_reservation_fk FOREIGN KEY (num_reservation) REFERENCES reservation(num_reservation) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE reservation_seance
ADD CONSTRAINT id_seance_fk FOREIGN KEY (id_seance) REFERENCES seance(id) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE reservation_seance
ADD CONSTRAINT id_tarif_fk FOREIGN KEY (id_tarif) REFERENCES tarif(id) ON DELETE CASCADE ON UPDATE NO ACTION;

insert into reservation_seance(num_reservation, id_tarif, nb_place, id_seance) values
(1,1,2,1),
(1,2,1,1),
(2,1,3,2),
(3,2,1,3),
(3,3,1,3),
(4,3,4,5);

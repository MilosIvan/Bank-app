/*
SQLyog Community v13.2.1 (64 bit)
MySQL - 10.4.32-MariaDB : Database - banka
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`banka` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `banka`;

/*Table structure for table `korisnici` */

DROP TABLE IF EXISTS `korisnici`;

CREATE TABLE `korisnici` (
  `oib` varchar(11) NOT NULL,
  `ime` varchar(15) NOT NULL,
  `prezime` varchar(15) NOT NULL,
  `datum_rodenja` varchar(30) NOT NULL,
  `email` varchar(25) NOT NULL,
  `adresa` text DEFAULT NULL,
  `telefon` varchar(10) DEFAULT NULL,
  `username` varchar(25) NOT NULL,
  `pass` text NOT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`oib`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `korisnici` */

insert  into `korisnici`(`oib`,`ime`,`prezime`,`datum_rodenja`,`email`,`adresa`,`telefon`,`username`,`pass`,`admin`) values 
('25100478596','Stjepan','Vlahov','2000-07-15','vlahov.stjepan10@hotmail.','Josipa Benčaka 35, Dubrava','0915825874','stjepan','vlahov',0),
('25142500214','Admin','Admin','99.99.9999.','admin@admin.com','Admin','0000000000','admin','admin',1),
('25547896887','Robert','Kovačić','2025-01-15','robert.kovacic@hotmail.co','Novi zavoj 15, Dubrava','0915826987','robert','kovacic',0),
('38819976281','Ivan','Milos','4.7.2000.','ivan.milos@gmail.com','Vinogorski zavoj 2','0919082896','ivan','milos',0),
('55866932150','Vlatko','Horvat','1956-07-15','vlatko.horvat@gmail.com','Ilica 140, Zagreb','0915825874','vlatko','horvat',0),
('55877732150','Ivana','Sever','1976-07-15','ivana.sever@gmail.com','Kapucinska ulica, Zagreb','0998596931','ivana','sever',0);

/*Table structure for table `korisnicki_racuni` */

DROP TABLE IF EXISTS `korisnicki_racuni`;

CREATE TABLE `korisnicki_racuni` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oib_korisnika` varchar(11) NOT NULL,
  `naziv` varchar(30) NOT NULL,
  `iban` varchar(21) NOT NULL,
  `valuta` varchar(5) NOT NULL,
  `stanje` double(8,2) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `oib_korisnika` (`oib_korisnika`),
  CONSTRAINT `korisnicki_racuni_ibfk_1` FOREIGN KEY (`oib_korisnika`) REFERENCES `korisnici` (`oib`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `korisnicki_racuni` */

insert  into `korisnicki_racuni`(`id`,`oib_korisnika`,`naziv`,`iban`,`valuta`,`stanje`) values 
(1,'55877732150','Tekući račun u eurima','HR8279677621581731958','EUR',10389.88),
(2,'55877732150','Žiro račun u eurima','HR5748952795341951508','EUR',834.47),
(3,'38819976281','Žiro račun u eurima','HR1469553887064757302','EUR',5348.21),
(4,'38819976281','Tekući račun u eurima','HR0582649690955399726','EUR',690.86),
(5,'55866932150','Tekući račun u eurima','HR5721190979350854447','EUR',15894.30),
(6,'55866932150','Žiro račun u eurima','HR2466201674641478957','EUR',30510.30),
(7,'25100478596','Žiro račun u eurima','HR8567956924528941353','EUR',308.90),
(8,'25100478596','Tekući račun u eurima','HR9542611407445066540','EUR',919.90),
(9,'25547896887','Tekući račun u eurima','HR5190247858266949585','EUR',4080.16),
(10,'25547896887','Žiro račun u eurima','HR4757984503406834706','EUR',517.87);

/*Table structure for table `obavijesti` */

DROP TABLE IF EXISTS `obavijesti`;

CREATE TABLE `obavijesti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oib_primatelja` varchar(11) NOT NULL,
  `naslov` varchar(100) NOT NULL,
  `sadrzaj` text NOT NULL,
  `datum` varchar(30) NOT NULL,
  `procitano` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `obavijesti` */

insert  into `obavijesti`(`id`,`oib_primatelja`,`naslov`,`sadrzaj`,`datum`,`procitano`) values 
(6,'55877732150','Prestanak izvršenja plaćanja u korist računa primatelja plaćanja u bivšoj Novoj hrvatskoj banci\r\n','Poštovani,\n\nna temelju pripajanja Nove hrvatske banke Hrvatskoj poštanskoj banci od 3. 7. 2024. neće biti moguće izvršavanje plaćanja u korist računa primatelja plaćanja koji počinje sa strukturom IBAN-a HRxx2503007xxxxxxxxxx.\n\nZa plaćanja u korist primatelja plaćanja koji imaju otvoren račun sa strukturom IBAN-a HRxx2503007xxxxxxxxxx od primatelja plaćanja potrebno je pribaviti novi broj računa. Ako imate ugovoren trajni nalog u korist navedenog IBAN-a, on će biti zatvoren i potrebno je otvoriti novi trajni nalog u korist novog broja računa. U slučaju da imate zadane naloge s datumom plaćanja u budućnosti, oni će biti odbijeni i potrebno je zadati nove s novim brojem računa.\n\nVaša Zagrebačka banka','Tue Feb 18 2025 11:26:17 GMT+0',0),
(7,'25142500214','OPREZ! Prijevare s obećanom zaradom od uloga u kriptovalute','Upozoravamo na povećanu aktivnost prevaranata koji putem društvenih mreža, SMS-ova, Vibera, WhatsAppa i poziva nagovaraju klijente na trgovanje kriptovalutama i obećaju im brzu i laku zaradu.\n\nMolimo za povećani oprez, pogotovo ako se od Vas zahtijeva da nakon poziva otvorite link dostavljen putem e-maila ili instalirate aplikaciju za udaljeni pristup jer će u tom slučaju prevaranti preuzeti kontrolu nad Vašim računalom i/ili mobilnim uređajem.\n\nNikada ne ustupajte:\nbroj tokena i kodove koje generira token (OTP/APLI, MAC)\npodatke o karticama (broj kartice, rok važenja, CVV broj)\nosobne podatke (preslik podataka s osobne iskaznice, podatke o računima i sl.)\npristup mobilnom uređaju ili računalu.','Tue Feb 18 2025 11:31:51 GMT+0',0),
(10,'55877732150','Novosti vezane za autorizaciju platnih transakcija karticom potrošača na internetu - od 26.06.2024.','Obavještavamo vas da se 26.06.2024. ukida mogućnost autorizacije za izvršenje platne transakcije karticom na internetskom prodajnom mjestu (dalje: transakcija) putem m-tokena unosom MAC/APPLI2 podataka, navedena u Općim uvjetima poslovanja Zagrebačke banke d.d. po transakcijskim računima potrošača i Općim uvjetima poslovanja Zagrebačke banke d.d. za izdavanje i upotrebu kreditnih kartica za potrošače, te se umjesto navedenog načina uvodi novi način autoriziranja tih transakcija, skeniranjem QR koda s ekranskog sučelja Banke.','Tue Feb 18 2025 11:33:01 GMT+0',0),
(13,'00000000000','Najava mogućih poteškoća kod plaćanja putem e-zabe i m-zabe','Poštovana/i,\n\nu subotu, 16.3.2024., od 09:00 do 13:00 sati, zbog regulatornih usklađivanja s novim SEPA platnim shemama, moguće su poteškoće s plaćanjima putem e-zabe i m-zabe.\n\nVaša Zaba','Tue Feb 18 2025 13:46:31 GMT+0',1),
(14,'00000000000','Provjere na usklađenost sa Sankcijama kod instant plaćanja','Obavještavamo vas da je na temelju nove EU Uredbe 2024/886 o instant kreditnim transferima u eurima Banka obvezna provjeriti je li korisnik platnih usluga osoba ili subjekt na koji se primjenjuju ciljane financijske mjere ograničavanja.\n\nZa vrijeme trajanja takve provjere usluga instant plaćanja može biti onemogućena, uz poruku \"Nalog odbijen zbog provjere usklađenosti sa Sankcijama\". U slučaju dodatnih pitanja molimo obratite se svojem bankaru ili Kontakt centru na broj telefona 01/3773 333 ili na e-adresu zaba@unicreditgroup.zaba.hr.','Tue Feb 18 2025 14:01:47 GMT+0',1),
(15,'00000000000','Povećanje broja naloga za potvrdu QR kodom','Poštovani,\n\nobavještavamo Vas da smo povećali broj naloga za plaćanja u zemlji koje možete potvrditi skeniranjem jednog QR koda, te on sada iznosi deset.\n\nVaša Zaba','Tue Feb 18 2025 14:02:11 GMT+0',0),
(16,'00000000000','Obavijest o uslugama online bankarstva','Obavještavamo Vas da pristup uslugama internetskog bankarstva i bankarstva putem mobilnih uređaja neće biti moguć ako istima pokušate pristupiti iz zemalja protiv kojih je uveden opsežan paket zabrana (osim Kube): https://www.zaba.hr/home/footer/uvjeti-poslovanja/sankcionirane-drzave-i-regije-2022.','Tue Feb 18 2025 14:02:19 GMT+0',0),
(21,'38819976281','Naslov','Obavijest Ivanu','Tue Feb 18 2025 15:01:02 GMT+0',0),
(22,'00000000000','Naslov 2','Obavijest svima','Tue Feb 18 2025 15:01:14 GMT+0',1);

/*Table structure for table `transakcije` */

DROP TABLE IF EXISTS `transakcije`;

CREATE TABLE `transakcije` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_racuna` int(11) NOT NULL,
  `iban_primatelja` varchar(21) NOT NULL,
  `iznos` double(8,2) unsigned NOT NULL,
  `opis` text DEFAULT NULL,
  `datum` varchar(30) NOT NULL,
  `saldo` double(8,2) unsigned NOT NULL,
  `vrsta` enum('UPLATA','ISPLATA') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `transakcije_ibfk_1` (`id_racuna`),
  CONSTRAINT `transakcije_ibfk_1` FOREIGN KEY (`id_racuna`) REFERENCES `korisnicki_racuni` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `transakcije` */

insert  into `transakcije`(`id`,`id_racuna`,`iban_primatelja`,`iznos`,`opis`,`datum`,`saldo`,`vrsta`) values 
(1,3,'HR8279677621581731958',150.00,'Ivan šalje Ivani 150 eura','Tue Feb 18 2025 11:55:13 GMT+0',5486.86,'ISPLATA'),
(2,1,'HR8279677621581731958',150.00,'Ivan šalje Ivani 150 eura','Tue Feb 18 2025 11:55:13 GMT+0',9056.23,'UPLATA'),
(3,3,'HR8279677621581731958',60.78,'Ivan šalje Ivani 60.78 eura','Tue Feb 18 2025 11:56:55 GMT+0',5426.08,'ISPLATA'),
(4,1,'HR8279677621581731958',60.78,'Ivan šalje Ivani 60.78 eura','Tue Feb 18 2025 11:56:55 GMT+0',9117.01,'UPLATA'),
(5,3,'HR1469553887064757302',762.13,'Uplata na račun Ivan Milos','Tue Feb 18 2025 12:10:26 GMT+0',6188.21,'UPLATA'),
(6,1,'HR1469553887064757302',762.13,'Uplata na račun Ivan Milos','Tue Feb 18 2025 12:10:26 GMT+0',8354.88,'ISPLATA'),
(7,2,'HR4500216464979451201',315.00,'Uplata na strani račun','Tue Feb 18 2025 12:13:57 GMT+0',925.46,'ISPLATA'),
(8,2,'HR2015260002514863255',90.99,'Online kupovina','Tue Feb 18 2025 12:14:30 GMT+0',834.47,'ISPLATA'),
(9,1,'HR1469553887064757302',65.00,'Prijenos sredstava','Tue Feb 18 2025 12:14:51 GMT+0',8289.88,'ISPLATA'),
(10,3,'HR1469553887064757302',65.00,'Prijenos sredstava','Tue Feb 18 2025 12:14:51 GMT+0',6253.21,'UPLATA'),
(11,3,'HR1469553887064757302',100.00,'prijenos na vlastiti račun','Tue Feb 18 2025 12:15:50 GMT+0',6353.21,'UPLATA'),
(12,4,'HR1469553887064757302',100.00,'prijenos na vlastiti račun','Tue Feb 18 2025 12:15:50 GMT+0',1790.86,'ISPLATA'),
(13,3,'HR2541002585963254021',5.00,'za kavu','Tue Feb 18 2025 12:30:14 GMT+0',6348.21,'ISPLATA'),
(14,4,'HR8279677621581731958',1000.00,'Ivan salje Ivani 1000 EUR','Tue Feb 18 2025 13:33:37 GMT+0',790.86,'ISPLATA'),
(15,1,'HR8279677621581731958',1000.00,'Ivan salje Ivani 1000 EUR','Tue Feb 18 2025 13:33:37 GMT+0',9289.88,'UPLATA'),
(17,4,'HR8279677621581731958',100.00,'Ivan salje Ivani 100 EUR','Tue Feb 18 2025 14:05:44 GMT+0',690.86,'ISPLATA'),
(18,1,'HR8279677621581731958',100.00,'Ivan salje Ivani 100 EUR','Tue Feb 18 2025 14:05:44 GMT+0',9389.88,'UPLATA'),
(20,3,'HR8279677621581731958',1000.00,'Ivan salje Ivani 1000 EUR','Tue Feb 18 2025 14:58:56 GMT+0',5348.21,'ISPLATA'),
(21,1,'HR8279677621581731958',1000.00,'Ivan salje Ivani 1000 EUR','Tue Feb 18 2025 14:58:56 GMT+0',10389.88,'UPLATA');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

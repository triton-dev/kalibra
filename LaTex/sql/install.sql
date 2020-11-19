-------------------------------------------------------------------------------
--
-- KALIBRA adatbázis
--
-- 2020. Szikora György
--
-------------------------------------------------------------------------------

\c template0

drop database if exist kalibra;
create database kalibra;

\c kalibra

--
-- Domainek létrehozása.
--
drop domain if exists d_cikk;
create domain d_cikk as VARCHAR(12);

drop domain if exists d_curidobelyeg; 
create domain d_curidobelyeg as TIMESTAMP(0) default current_timestamp;

drop domain if exists d_datum; 
create domain d_datum as DATE;

drop domain if exists d_eszkszam;
create domain d_eszkszam as VARCHAR(9);

drop domain if exists d_eszktipus;
create domain d_eszktipus as VARCHAR(40);

drop domain if exists d_fajl;
create domain d_fajl as VARCHAR(255);

drop domain if exists d_fhnev;
create domain d_fhnev as VARCHAR(25);

drop domain if exists d_gravir;
create domain d_gravir as VARCHAR(10);

drop domain if exists d_gysz;
create domain d_gysz as VARCHAR(40);

drop domain if exists d_hamis;
create domain d_hamis as BOOLEAN default false;

drop domain if exists d_idobelyeg;
create domain d_idobelyeg as TIMESTAMP(0) default null;

drop domain if exists d_igaz;
create domain d_igaz as BOOLEAN defalut true;

drop domain if exists d_int;
create domain d_int as INTEGER;

drop domain if exists d_jelszo;
create domain d_jelszo as TEXT default md5(’init’);

drop domain if exists d_jkvszam;
create domain d_jkvszam as VARCHAR(50);

drop domain if exists d_ktghely;
create domain d_ktghely as VARCHAR(8);

drop domain if exists d_leiras;
create domain d_leiras as VARCHAR(255);

drop domain if exists d_megyseg;
create domain d_megyseg as VARCHAR(10);

drop domain if exists d_minosites;
create domain d_minosites as VARCHAR(20);

drop domain if exists d_mukmod;
create domain d_mukmod as VARCHAR(40);

drop domain if exists d_nev;
create domain d_nev as VARCHAR(40);

drop domain if exists d_num4_1;
create domain d_num4_1 as NUMERIC(4,1);

drop domain if exists d_num9_4;
create domain d_num9_4 as NUMERIC(9,4);

drop domain if exists d_osztas;
create domain d_osztas as VARCHAR(25);

drop domain if exists d_partnerkod;
create domain d_partnerkod as VARCHAR(4);

drop domain if exists d_serial;
create domain d_serial as SERIAL;

drop domain if exists d_szerep;
create domain d_szerep as VARCHAR(25);

drop domain if exists d_tartomany;
create domain d_tartomany as VARCHAR(40);

drop domain if exists d_tech;
create domain d_tech as VARCHAR(255);

drop domain if exists d_titulus;
create domain d_titulus as VARCHAR(40);

drop domain if exists d_torzsszam;
create domain d_torzsszam as VARCHAR(5);

drop domain if exists d_txt;
create domain d_txt as TEXT;
--
--
--

--
-- Táblák létrehozása.
--

create table szerep(
	szerep d_szerep primary key
)with oids;

create table me(
	me d_megyseg primary key
)with oids;

create table minosites(
	minosites d_minosites primary key
)with oids;

create table mukmod(
	mukmod d_mukmod primary key
)with oids;

create table eszktipus(
	eszktipus d_eszktipus primary key
)with oids;

create table partner(
	partnerkod d_partnerkod primary key,
	partnernev d_nev not null
)with oids;

create table koltseghely(
	ktghely d_ktghely primary key,
	ktghelynev d_nev not null
)with oids;

create table dolgozo(
	torzsszam d_torzsszam primary key,
	vnev d_nev not null,
	knev d_nev not null,
	hnev d_nev default null,
	titulus d_titulus default null,
	ktghely d_ktghely references koltseghely(ktghely) 
		on update cascade on delete restrict,
	kilepett d_hamis
)with oids;

create table felhasznalo(
	fhnev d_fhnev primary key,
	vnev d_nev not null,
	knev d_nev not null,
	hnev d_nev default null,
	titulus d_titulus default null,
	jelszo d_jelszo,
	szerep d_szerep references szerep(szerep)
		on update cascade on delete restrict,
	aktiv d_igaz
)with oids;

create table torzsadat(
	cikkszam d_cikk primary key,
	megnevezes d_nev not null,
	gyarto d_nev,
	típus d_nev,
	mukodes d_mukmod references mukmod(mukmod)
		on update cascade on delete restrict,
	eszkoztipus d_eszktipus references eszktipus(eszktipus)
		on update cascade on delete restrict,
	osztas d_osztas
	osztasme d_megyseg references me(me)
		on update cascade on delete restrict,
	pontossag d_osztas
	tartomany d_tartomany
	tartomanyme d_megyseg references me(me)
		on update cascade on delete restrict,
	kalibciklus d_int,
	zarolt d_hamis,
	constraint rossz_kalibciklus check(kalibciklus >= 0)
)with oids;

create table eszkoz(
	gravirszam d_gravir primary key,
	cikkszam d_cikk references torzsadat(cikk),
		on update cascade on delete restrict,
	gysz d_gysz
	eszkozszam d_eszkszam default null,
	eszkozalszam d_eszkaszam default null,
	torzseszkoz d_hamis,
	minosites d_minosites references minosites(minosites)
		on update cascade on delete restrict,
	ekalibciklus d_integer default 365,
	kaliblejar d_datum,
	uzemdatum d_datum,
	seljavdatum d_datum,
	seldatum d_datum,
	constraint rossz_kalibciklus check(ekalibciklus >= 0),
	constraint eszkoz_alszam_egyedi unique(eszkozszam, eszkozalszam),
	constraint rossz_kaliblejar_datum check(kaliblejar > uzemdatum),
	constraint rossz_seljavdatum check(seljavdatum >= uzemdatum),
	constraint rossz_seldatum check(seldatum >= seljavdatum)
)with oids;

create table technologia(
	gravirszam d_gravir,
	technologia d_tech,
	constraint letezo_gravirszam_technologia_paros 
		primary key(gravirszam, technologia)
)with oids;

create table mozgdolg(
	sorszam d_serial primary key
	gravirszam d_gravir references eszkoz(gravirszam)
		on update cascade on delete restrict,
	torzsszam d_torzsszam references dolgozo(torzsszam)
		on update cascade on delete restrict,
	mettol d_curidobelyeg,
	meddig d_idobelyeg,
	constraint rossz_mozgdolg_meddig check(meddig >= mettol)
)with oids;

create table mozgktgh(
	sorszam d_serial primary key,
	gravirszam d_gravir references eszkoz(gravirszam)
		on update cascade on delete restrict,
	ktghely d_ktghely references koltseghely(ktghely)
		on update cascade on delete restrict,
	mettol d_curidobelyeg,
	meddig d_idobelyeg,
	constraint rossz_mozgktgh_meddig check(meddig >= mettol)
)with oids;

create table bkalibfej(
	bksorszam d_serial primary key,
	gravirszam d_gravir references eszkoz(gravirszam)
		on update cascade on delete restrict,
	fhnev d_fhnev references felhasznalo(fhnev)
		on update cascade on delete restrict,
	kalibidopont d_curidobelyeg,
	homerseklet d_num4_1,
	paratartalom d_num4_1,
	constraint rossz_homerseklet check(homerseklet between 0 and 100),
	constraint rossz_paratartalom check(paratartalom between 0 and 100)
)with oids;

create table bkalibtetel(
bksorszam d_int references bkalibfej(bksorszam) 
	on update cascade on delete restrict,
tetelszam d_int,
elvart d_num9_4,
mert d_num9_4,
primary key(bksorszam, tetelszam)
)with oids;

create table bkaliberedmeny(
	bksorszam d_int primary key,
	minosites d_minosites references minosites(minosites)
		on update cascade on delete restrict,
	megjegyzes d_txt
)with oids;

create table kkalib(
	kksorszám d_serial primary key,
	partnerkod d_partnerkod references partner(partnerkod)
		on update cascade on delete restrict,
	jkvszam d_jkvszam,
	kalibdatum d_datum,
	gravirszam d_gravir references eszkoz(gravirszam)
		on update cascade on delete restrict,
	minosites d_minosites references minosites(minosites)
		on update cascade on delete restrict,
	kalibervenyes d_datum,
	jciklido d_int default null,
	fhnev d_fhnev references felhasznalo(fhnev)
		on update cascade on delete restrict,
	rogzidopont d_curidobelyeg,
	constraint letezo_partner_jegyzokonyvszam_kalibdatum 
		unique(partnerkod, jkvszam, kalidatum),
	constraint rossz_ciklusido check(jciklido >= 0)
)with oids;

create table selejtezes(
	selsorszam d_serial primary key,
	gravirszam d_gravir references eszkoz(gravirszam)
		on update cascade on delete restrict,
	indoklas d_txt,
	idopont d_curidobelyeg,
	fhnev d_fhnev references felhasznalo(fhnev)
		on update cascade on delete restrict
)with oids;

create table fenykep(
	cikkszam d_cikk references torzsadat(cikkszam)
		on update cascade on delete restrict,
	sorszam d_serial,
	fajlnev d_fajl,
	leiras d_leiras,
	primary key(cikkszam, sorszam)
)with oids;

create table csatolmany(
	gravirszam d_gravir references eszkoz(gravirszam)
		on update cascade on delete restrict,
	sorszam d_serial,
	fajlnev d_fajl,
	leiras d_leiras,
	primary key(gravirszam, sorszam)
)with oids;
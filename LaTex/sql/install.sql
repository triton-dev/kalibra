-------------------------------------------------------------------------------
--
-- KALIBRA adatbázis
--
-- 2020. Szikora György
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- \i install.sql
-- Csak Linux psql konzolos létrehozás esetén kell a következő 4 sor.
 \c template1
 drop database if exists kalibra;
 create database kalibra;
 \c kalibra
-------------------------------------------------------------------------------

--
-- Domainek létrehozása.
--
drop domain if exists d_cikk cascade;
create domain d_cikk as VARCHAR(12);

drop domain if exists d_curidobelyeg cascade; 
create domain d_curidobelyeg as TIMESTAMP(0) default current_timestamp;

drop domain if exists d_datum cascade; 
create domain d_datum as DATE;

drop domain if exists d_eszkszam cascade;
create domain d_eszkszam as VARCHAR(9);

drop domain if exists d_eszktipus cascade;
create domain d_eszktipus as VARCHAR(40);

drop domain if exists d_fajl cascade;
create domain d_fajl as VARCHAR(255);

drop domain if exists d_fhnev cascade;
create domain d_fhnev as VARCHAR(25);

drop domain if exists d_gravir cascade;
create domain d_gravir as VARCHAR(10);

drop domain if exists d_gysz cascade;
create domain d_gysz as VARCHAR(40);

drop domain if exists d_hamis cascade;
create domain d_hamis as BOOLEAN default false;

drop domain if exists d_idobelyeg cascade;
create domain d_idobelyeg as TIMESTAMP(0) default null;

drop domain if exists d_igaz cascade;
create domain d_igaz as BOOLEAN default true;

drop domain if exists d_int cascade;
create domain d_int as INTEGER;

drop domain if exists d_jelszo cascade;
create domain d_jelszo as TEXT default md5('init');

drop domain if exists d_jkvszam cascade;
create domain d_jkvszam as VARCHAR(50);

drop domain if exists d_ktghely cascade;
create domain d_ktghely as VARCHAR(8);

drop domain if exists d_leiras cascade;
create domain d_leiras as VARCHAR(255);

drop domain if exists d_megyseg cascade;
create domain d_megyseg as VARCHAR(10);

drop domain if exists d_minosites cascade;
create domain d_minosites as VARCHAR(20);

drop domain if exists d_mukmod cascade;
create domain d_mukmod as VARCHAR(40);

drop domain if exists d_nev cascade;
create domain d_nev as VARCHAR(40);

drop domain if exists d_num4_1 cascade;
create domain d_num4_1 as NUMERIC(4,1);

drop domain if exists d_num9_4 cascade;
create domain d_num9_4 as NUMERIC(9,4);

drop domain if exists d_osztas cascade;
create domain d_osztas as VARCHAR(25);

drop domain if exists d_partnerkod cascade;
create domain d_partnerkod as VARCHAR(4);

drop domain if exists d_szerep cascade;
create domain d_szerep as VARCHAR(25);

drop domain if exists d_tartomany cascade;
create domain d_tartomany as VARCHAR(40);

drop domain if exists d_tech cascade;
create domain d_tech as VARCHAR(255);

drop domain if exists d_titulus cascade;
create domain d_titulus as VARCHAR(40);

drop domain if exists d_torzsszam cascade;
create domain d_torzsszam as VARCHAR(5);

drop domain if exists d_txt cascade;
create domain d_txt as TEXT;

drop domain if exists d_tarhely cascade;
create domain d_tarhely as varchar(15);

drop sequence if exists seq_mozgdolg cascade;
create sequence seq_mozgdolg;
create domain d_mozgdolg as integer default nextval('seq_mozgdolg');

drop sequence if exists seq_mozgktgh cascade;
create sequence seq_mozgktgh;
create domain d_mozgktgh as integer default nextval('seq_mozgktgh');

drop sequence if exists seq_bkalibfej cascade;
create sequence seq_bkalibfej;
create domain d_bkalibfej as integer default nextval('seq_bkalibfej');

drop sequence if exists seq_kkalib cascade;
create sequence seq_kkalib;
create domain d_kkalib as integer default nextval('seq_kkalib');

drop sequence if exists seq_selejtezes cascade;
create sequence seq_selejtezes;
create domain d_selejtezes as integer default nextval('seq_selejtezes');

drop sequence if exists seq_fenykep cascade;
create sequence seq_fenykep;
create domain d_fenykep as integer default nextval('seq_fenykep');

drop sequence if exists seq_csatolmany cascade;
create sequence seq_csatolmany;
create domain d_csatolmany as integer default nextval('seq_csatolmany');
--
--
--



--
-- Táblák létrehozása.
--
drop table if exists szerep cascade;
create table szerep(
	szerep d_szerep primary key,
	aktivszerep d_igaz
)with oids;

drop table if exists me cascade;
create table me(
	me d_megyseg primary key,
	meleiras d_nev,
	aktivme d_igaz
)with oids;

drop table if exists minosites cascade;
create table minosites(
	minosites d_minosites primary key,
	aktivminosites d_igaz
)with oids;

drop table if exists mukmod cascade;
create table mukmod(
	mukmod d_mukmod primary key,
	aktivmukmod d_igaz
)with oids;

drop table if exists eszktipus cascade;
create table eszktipus(
	eszktipus d_eszktipus primary key,
	aktiveszktipus d_igaz
)with oids;

drop table if exists partner cascade;
create table partner(
	partnerkod d_partnerkod primary key,
	partnernev d_nev not null,
	aktivpartner d_igaz
)with oids;

drop table if exists koltseghely cascade;
create table koltseghely(
	ktghely d_ktghely primary key,
	ktghelynev d_nev not null,
	aktivktghely d_igaz
)with oids;

drop table if exists dolgozo cascade;
create table dolgozo(
	torzsszam d_torzsszam primary key,
	vnev d_nev not null,
	knev d_nev not null,
	hnev d_nev default null,
	titulus d_titulus default null,
	ktghely d_ktghely references koltseghely(ktghely) 
		on update cascade on delete restrict
		check (fn_aktiv_koltseghely(ktghely)),
	aktivdolgozo d_igaz
)with oids;

drop table if exists felhasznalo cascade;
create table felhasznalo(
	fhnev d_fhnev primary key,
	vnev d_nev not null,
	knev d_nev not null,
	hnev d_nev default null,
	titulus d_titulus default null,
	jelszo d_jelszo,
	szerep d_szerep references szerep(szerep)
		on update cascade on delete restrict,
	aktivfelhasznalo d_igaz
)with oids;

drop table if exists torzsadat cascade;
create table torzsadat(
	cikkszam d_cikk primary key,
	megnevezes d_nev not null,
	gyarto d_nev,
	tipus d_nev,
	mukodes d_mukmod references mukmod(mukmod)
		on update cascade on delete restrict,
	eszkoztipus d_eszktipus references eszktipus(eszktipus)
		on update cascade on delete restrict,
	osztas d_osztas,
	osztasme d_megyseg references me(me)
		on update cascade on delete restrict,
	pontossag d_osztas,
	pontossagme d_megyseg references me(me)
		on update cascade on delete restrict,
	tartomany d_tartomany,
	tartomanyme d_megyseg references me(me)
		on update cascade on delete restrict,
	kalibciklus d_int,
	zarolt d_hamis, -- aktív cikk
	constraint rossz_kalibciklus check(kalibciklus >= 0)
)with oids;

drop table if exists eszkoz cascade;
create table eszkoz(
	gravirszam d_gravir primary key,
	cikkszam d_cikk references torzsadat(cikkszam)
		on update cascade on delete restrict,
	gysz d_gysz,
	eszkozszam d_eszkszam default null,
	eszkozalszam d_eszkszam default null,
	torzseszkoz d_hamis,
	minosites d_minosites references minosites(minosites)
		on update cascade on delete restrict,
	ekalibciklus d_int default 365,
	kaliblejar d_datum,
	uzemdatum d_datum,
	seljavdatum d_datum,
	seldatum d_datum,
	tarhely d_tarhely,
	aktiveszkoz d_igaz, 
	foreign key (cikkszam) references torzsadat(cikkszam)
		on update cascade on delete restrict,
	constraint rossz_kalibciklus check(ekalibciklus >= 0),
	constraint eszkoz_alszam_egyedi unique(eszkozszam, eszkozalszam),
	constraint rossz_kaliblejar_datum check(kaliblejar > uzemdatum),
	constraint rossz_seljavdatum check(seljavdatum >= uzemdatum),
	constraint rossz_seldatum check(seldatum >= seljavdatum)
)with oids;

drop table if exists technologia cascade;
create table technologia(
	gravirszam d_gravir references eszkoz(gravirszam)
		on update cascade on delete restrict,
	technologia d_tech,
	constraint letezo_gravirszam_technologia_paros 
		primary key(gravirszam, technologia)
)with oids;

drop table if exists mozgdolg cascade;
create table mozgdolg(
	sorszam d_mozgdolg primary key,
	gravirszam d_gravir references eszkoz(gravirszam)
		on update cascade on delete restrict,
	torzsszam d_torzsszam references dolgozo(torzsszam)
		on update cascade on delete restrict,
	mettol d_curidobelyeg,
	meddig d_idobelyeg,
	constraint rossz_mozgdolg_meddig check(meddig >= mettol)
)with oids;

drop table if exists mozgktgh cascade;
create table mozgktgh(
	sorszam d_mozgktgh primary key,
	gravirszam d_gravir references eszkoz(gravirszam)
		on update cascade on delete restrict,
	ktghely d_ktghely references koltseghely(ktghely)
		on update cascade on delete restrict,
	mettol d_curidobelyeg,
	meddig d_idobelyeg,
	constraint rossz_mozgktgh_meddig check(meddig >= mettol)
)with oids;

drop table if exists bkalibfej cascade;
create table bkalibfej(
	bksorszam d_bkalibfej primary key,
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

drop table if exists bkalibtetel cascade;
create table bkalibtetel(
	bksorszam d_int references bkalibfej(bksorszam) 
		on update cascade on delete restrict,
	tetelszam d_int,
	elvart d_num9_4,
	mert d_num9_4,
	primary key(bksorszam, tetelszam)
)with oids;

drop table if exists bkaliberedmeny cascade;
create table bkaliberedmeny(
	bksorszam d_int references bkalibfej(bksorszam)
		on update cascade on delete restrict primary key,
	minosites d_minosites references minosites(minosites)
		on update cascade on delete restrict,
	megjegyzes d_txt
)with oids;

drop table if exists kkalib cascade;
create table kkalib(
	kksorszám d_kkalib primary key,
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
		unique(partnerkod, jkvszam, kalibdatum),
	constraint rossz_ciklusido check(jciklido >= 0)
)with oids;

drop table if exists selejtezes cascade;
create table selejtezes(
	selsorszam d_selejtezes primary key,
	gravirszam d_gravir references eszkoz(gravirszam)
		on update cascade on delete restrict,
	indoklas d_txt,
	idopont d_curidobelyeg,
	fhnev d_fhnev references felhasznalo(fhnev)
		on update cascade on delete restrict
)with oids;

drop table if exists fenykep cascade;
create table fenykep(
	cikkszam d_cikk references torzsadat(cikkszam)
		on update cascade on delete restrict,
	sorszam d_fenykep,
	fajlnev d_fajl,
	leiras d_leiras,
	primary key(cikkszam, sorszam)
)with oids;

drop table if exists csatolmany cascade;
create table csatolmany(
	gravirszam d_gravir references eszkoz(gravirszam)
		on update cascade on delete restrict,
	sorszam d_csatolmany,
	fajlnev d_fajl,
	leiras d_leiras,
	primary key(gravirszam, sorszam)
)with oids;

drop table if exists kiadotteszkoz;
create table kiadotteszkoz (
	gravirszam d_gravir references eszkoz(gravirszam)
		on update cascade on delete restrict,
	mettol d_curidobelyeg,
	meddig d_idobelyeg default null,
	hol d_ktghely default null,
	primary key(gravirszam, mettol)
) with oids;

-------------------------------------------------------------------------------
-- Függvények létrehozása
-------------------------------------------------------------------------------

-- Aktív dolgozó ellenőrzése.
create or replace function fn_aktiv_dolgozo(tsz varchar)
	returns boolean as
$$
declare
	aktiv dolgozo.aktivdolgozo%type;
	tszam alias for $1;
begin
	select aktivdolgozo into aktiv from dolgozo where torzsszam=tszam;
	if not found then
		raise notice '% törzsszámú dolgozó nem létezik.',tszam;
		return false;
	end if;
	return aktiv;
end;
$$	
language plpgsql;
-------------------------------------------------------------------------------

-- Aktív felhasználó ellenőrzése.
create or replace function fn_aktiv_felhasznalo (f varchar)
	returns boolean as
$$
declare
	aktiv felhasznalo.aktivfelhasznalo%type;
	felh alias for $1;
begin
	select aktivfelhasznalo into aktiv from felhasznalo where fhnev=felh;
	if not found then
		raise notice '% felhasználó nem létezik.',felh;
		return false;
	end if;
	return aktiv;
end;
$$
language plpgsql;
-------------------------------------------------------------------------------

-- Aktív költséghely ellenőrzése.
create or replace function fn_aktiv_koltseghely(k varchar) 
	returns boolean as
$$
declare
	ktg alias for $1;
	aktiv koltseghely.aktivktghely%type;
begin
	select aktivktghely into aktiv from koltseghely where ktghely=ktg;
	if not found then
		raise notice '% költséghely nem létezik.',ktg;
		return false;
	end if;
	return aktiv;
end;
$$
language plpgsql;
-------------------------------------------------------------------------------

-- Cikkszám zárolásának ellenőrzése.
create or replace function fn_zarolt_cikk(c varchar)
	returns boolean as
$$
declare
	cikk alias for $1;
	zar torzsadat.zarolt%type;
begin
	select zarolt into zar from torzsadat where cikkszam=cikk;
	if not found then
		raise notice '% cikkszám nem létezik.',cikk;
		return true;
	end if;
	return zar;
end;
$$
language plpgsql;
-------------------------------------------------------------------------------

-- Aktív eszköz ellenőrzése.
create or replace function fn_aktiv_eszkoz (gr varchar) 
	returns boolean as
$$
declare
	aktiv eszkoz.aktiveszkoz%type;
	gravir alias for $1;
begin
	select aktiveszkoz into aktiv from eszkoz where gravirszam=gravir;
	if not found then
		raise notice '% gravírszámú eszköz nem létezik.',gravir;
		return false;
	end if;
	return aktiv;
end;
$$
language plpgsql;
-------------------------------------------------------------------------------

-- Aktív partner ellenőrzése.
create or replace function fn_aktiv_partner(p varchar)
	returns boolean as
$$
declare
	aktiv partner.aktivpartner%type;
	pkod alias for $1;
begin
	select aktivpartner into aktiv from partner where partnerkod=pkod;
	if not found then
		raise notice '% partnerkódú partner nem létezik.',pkod;
		return false;
	end if;
	return aktiv;
end;
$$
language plpgsql;
-------------------------------------------------------------------------------


-- Eszköz kiadása költséghelyre, vagy dolgozónak.
create or replace function fn_eszkozkiadas
	(grav varchar, dolg boolean, helyre varchar)
		returns boolean as
$$
declare
	gravir alias for $1;
	dolgozonak alias for $2;
	hely alias for $3;
	holvan varchar;
	mikor kiadotteszkoz.mettol%type;
	aktiv dolgozo.aktivdolgozo%type;

begin
	-- Csak olyan eszköt adhatunk ki, ami nincs kiadva.
	select hol,mettol into holvan,mikor from kiadotteszkoz
		where gravirszam=gravir and meddig is null;
	if found then
		raise notice '% gravírszámú eszköz % időpontban kiadva % -nak/nek.',
			gravir,mikor,holvan;
		return false;
	end if;
	
	-- Csak aktív eszközt adunk ki.
	if not fn_aktiv_eszkoz(gravir) then
		raise notice '% gravírszámú eszköz nem aktív.',gravir;
		return false;
	end if;
		
	if dolgozonak then
		-- Csak aktív dolgozónak adunk eszközt.
		select fn_aktiv_dolgozo(hely) into aktiv;
		if aktiv then
			insert into mozgdolg(gravirszam,torzsszam) values(gravir,hely);
			insert into kiadotteszkoz(gravirszam,hol) values(gravir, hely);
			return true;
		else
			raise notice '% törzsszámú dolgozó nem aktív.',hely;
			return false;
		end if;
	else
		-- Csak aktív költséghelyre adunk eszközt.
		select fn_aktiv_koltseghely(hely) into aktiv;
		if aktiv then
			insert into mozgktgh(gravirszam, ktghely) values(gravir,hely);
			insert into kiadotteszkoz(gravirszam,hol) values(gravir, hely);
			return true;
		else
			raise notice '% költséghely nem aktív.',hely;
			return false;
		end if;
	end if;
	return true;
end;
$$
language plpgsql;
-------------------------------------------------------------------------------

-- Eszköz visszavétele.
create or replace function fn_eszkozvisszavet(g varchar)
	returns boolean as
$$
declare
	gravir alias for $1;
begin
	perform gravir from kiadotteszkoz 
		where gravirszam=gravir and meddig is null;
	
	if not found then
		raise notice '% gravírszámú eszköz nincs kiadva.',gravir;
		return false;
	end if;
	
	update mozgdolg set meddig=current_timestamp 
		where gravirszam=gravir and meddig is null;
		
	update mozgktgh set meddig=current_timestamp
		where gravirszam=gravir and meddig is null;
	
	update kiadotteszkoz set meddig=current_timestamp
		where gravirszam=gravir and meddig is null;
		
	return true;
end;
$$
language plpgsql;

-- Alapjelszó beállítása
--                      fhnev
-- Function: alapjelszo(text)
-- DROP FUNCTION alapjelszo(text);
CREATE OR REPLACE FUNCTION alapjelszo(text)
	RETURNS boolean AS
$$
declare
	alapjelszo text := md5('init');
	fh alias for $1;
begin
	update felhasznalo set jelszo = alapjelszo where md5(fhnev) = md5(fh);
	return true;
end;
$$
LANGUAGE plpgsql;
-------------------------------------------------------------------------------

-- Jelszócsere
--                      fhnev, uj1, uj2, regi
-- Function: jelszocsere(text, text, text, text)
-- DROP FUNCTION jelszocsere(text, text, text, text);
CREATE OR REPLACE FUNCTION jelszocsere(text, text, text, text)
	RETURNS boolean AS
$$
declare
	fh alias for $1;
	uj1 alias for $2;
	uj2 alias for $3;
	regi alias for $4;
begin
	if uj1 <> uj2 or length(trim(uj1)) = 0 or length(trim(uj2)) = 0
		or trim(uj1) = trim(regi) or trim(uj2) = trim(regi) then
			return false;	-- az új jelszavak nem egyeznek meg, vagy üresek,
							-- vagy nincs változás
	end if;
	
	perform fhnev from felhasznalo where md5(fhnev) = md5(fh) 
		and jelszo = md5(regi);

	if not found then
		return false; -- nem található a felhasználónév-jelszó páros
	else
		update felhasznalo set jelszo = md5(uj1) where md5(fhnev) = md5(fh);
		return true; -- sikeres jelszócsere
	end if;
end;
$$
LANGUAGE plpgsql;
-------------------------------------------------------------------------------

-- Bejelentkezés
--                 fhnev, jelszo
-- Function: login(text, text)
-- DROP FUNCTION login(text, text);
CREATE OR REPLACE FUNCTION login(text, text)
	RETURNS boolean AS
$$
declare
	fh alias for $1;
	jsz alias for $2;
begin
	perform fhnev from felhasznalo where md5(fhnev) = md5(fh)
		and jelszo = md5(jsz) and aktivfelhasznalo;
	if found then 
		return true;
	end if; -- sikeres bejelentkezés
	
	return false;  -- sikertelen bejelentkezés
end;
$$
LANGUAGE plpgsql;
-------------------------------------------------------------------------------


-- Nézetek létrehozása

-- Aktiv MINŐSTÉS
drop view if exists v_aktivminosites cascade;
create view v_aktivminosites as
	select * from minosites where aktivminosites;

-- Aktív ESZKÖZTÍPUS
drop view if exists v_aktiveszktipus cascade;
create view v_aktiveszktipus as
	select * from eszktipus where aktiveszktipus;
	
-- Aktív MŰKÖDÉSMÓD
drop view if exists v_aktivmukmod cascade;
create view v_aktivmukmod as
	select * from mukmod where aktivmukmod;
	
-- Aktív ME (mértékegység)
drop view if exists aktivme cascade;
create view v_aktivme as
	select * from me where aktivme;
	
-- Aktiv SZEREP
drop view if exists v_aktivszerep cascade;
create view v_aktivszerep as
	select * from szerep where aktivszerep;

-- Aktív PARTNER
drop view if exists v_aktivpartner cascade;
create view v_aktivpartner as
	select * from partner where aktivpartner;
	
-- Aktív DOLGOZO
drop view if exists v_aktivdolgozo cascade;
create view v_aktivdolgozo as
	select torzsszam, titulus, vnev||' '||knev||' '||hnev as nev,
	ktghely, ktghelynev, 
	case when aktivdolgozo then 'aktív' else 'passzív' end as statusz,
	aktivdolgozo
	from dolgozo join koltseghely using(ktghely) 
	where aktivdolgozo order by vnev,knev,hnev;

-- Passzív DOLGOZO
drop view if exists v_passzivdolgozo cascade;
create view v_passzivdolgozo as
	select torzsszam, titulus, vnev||' '||knev||' '||hnev as nev,
	ktghely, ktghelynev, 
	case when aktivdolgozo then 'aktív' else 'passzív' end as statusz,
	aktivdolgozo
	from dolgozo join koltseghely using(ktghely) 
	where not aktivdolgozo order by vnev,knev,hnev;

-- Dolgozók listája
drop view if exists v_dolgozo cascade;
create view v_dolgozo as
	select * from v_aktivdolgozo
	union
	select * from v_passzivdolgozo
	order by nev;

-- Felhasználó nézet bejelentkezési adatokhoz
drop view if exists v_felhasznalo_login cascade;
create view v_felhasznalo_login as
	select (case when titulus='' then vnev||' '||knev else titulus||' '
		||vnev||' '||knev end) || 
		case when hnev!='' then ' '||hnev else '' end as nev, 
		fhnev,szerep, aktivfelhasznalo, 
		case when jelszo=md5('init') then true 
		else false end as alapjelszo from felhasznalo;





-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Adatok betöltése.

-- Költséghelyek:
insert into koltseghely(ktghely,ktghelynev) values
('11-110-0','Törzs Ügyvezető'),
('11-120-0','Folyamatszervezési és Informatikai Ö.Cs.'),
('11-335-0','Minőségirányítási csoport'),
('11-210-0','Humánügyi és Bérelszámolási Osztály'),
('11-220-0','Tervezési és Controlling Osztály'),
('11-230-0','Pénzügyi és Számviteli Osztály'),
('11-250-0','Közbeszerzési és Versenyeztetési Csoport'),
('11-260-0','Anyaggazdálkodási Osztály'),
('21-322-1','Központi Raktár'),
('21-322-3','Szerszámraktár'),
('11-400-0','Termelési Főosztály'),
('12-330-0','Minőségellenőrzési Csoport'),
('12-420-0','Járműjavító Üzem'),
('12-430-0','Fődarabjavító Üzem'),
('12-440-0','Termeléskoor. és Üzemgazd. Csoport'),
('13-321-0','SM szerelő'),
('13-421-0','Járműlakatos  művezetőség'),
('13-422-0','Járműszerelő művezetőség'),
('13-423-0','Jármű villanyszerelő művezetőség'),
('13-424-0','Fényező művezetőség'),
('13-425-0','Asztalos művezetőség'),
('13-431-0','Motorjavító műhely'),
('13-432-0','Kerékpárjavító műhely'),
('13-433-0','Forgóváz-javító műhely'),
('13-441-0','Alkatrészgyártó művezetőség'),
('13-443-0','Műszerész tevékenység'),
('13-444-0','Kitérőgyártó csoport'),
('11-300-0','Műszaki és Termelést Előkészítő Főoszt.'),
('11-310-0','Technológiai Osztály'),
('11-330-0','Üzemfenntartás'),
('11-410-0','Termékfejlesztési és Értékesítési Osztál'),
('12-340-0','Állapotfelvevők'),
('13-333-0','Hibajavítók'),
('14-460-0','Szakmunkásképző csoport');

-- Dolgozók:
insert into dolgozo(torzsszam,vnev,knev,hnev,titulus,ktghely) values
('95248','Balaskó','Angéla','Ildikó','dr.','11-110-0'),
('95481','Bassola','Eszter','','dr.','11-110-0'),
('93585','Boros','Tibor','István','','11-110-0'),
('93360','Dongó','Péter','','','11-110-0'),
('94331','Gulyásné Sasvári','Mária','Erzsébet','','11-110-0'),
('95051','Kalmár','Lajosné','','','11-110-0'),
('95340','Kiss','Teréz','','','11-110-0'),
('95241','Takács-Szabados','Zsuzsanna','','','11-110-0'),
('95020','Várszegi','Gyula','Ervin','','11-110-0'),
('95483','Fenyvesy','László','','','11-120-0'),
('93901','Sepler','Ádám','','','11-120-0'),
('95157','Szalkai','József','','','11-120-0'),
('95463','Ipach','Corina','','','11-335-0'),
('94970','Jobban','Zoltán','Tibor','','11-335-0'),
('95509','Laczkó-Albert','Annamária','','','11-335-0'),
('95153','Faragó','Istvánné','','','11-210-0'),
('95355','Nagyné Huszár','Andrea','','','11-210-0'),
('95353','Papp','Erika','','','11-210-0'),
('95349','Simon','Melinda','','','11-210-0'),
('94832','Bánkiné Békés','Andrea','','','11-220-0'),
('94541','Galambosné Stuhán','Beáta','','','11-220-0'),
('95237','Hunyadi','Szandra','','','11-220-0'),
('94925','Kallós','Dóra','','','11-220-0'),
('94519','Bront','Zsuzsanna','','','11-230-0'),
('94311','Kovács','Erika','','','11-230-0'),
('94971','Sinkó','Klaudia','','','11-230-0'),
('95141','Takácsné Varga','Judit','','','11-230-0'),
('95378','Tamás','Mária','','','11-230-0'),
('95240','Weiser','Gabriella','','','11-230-0'),
('94892','Kozák-Németh','Eszter','','','11-250-0'),
('95114','Marsi','Melinda','Zsanett','','11-250-0'),
('95155','Monori','Anita','','','11-250-0'),
('95247','Aug','Mariann','','','11-260-0'),
('94959','Czibiné Monori','Hajnalka','','','11-260-0'),
('93920','Gulyás','Tibor','','','11-260-0'),
('94957','Gyetván','Ádám','','','11-260-0'),
('94942','Körmendi','Bence','','','11-260-0'),
('94735','Sepler','Ádámné','','','11-260-0'),
('95428','Takács','Edina','','','11-260-0'),
('93409','Boda','József','','','21-322-1'),
('95457','Dékányné Csomortáni','Katalin','','','21-322-1'),
('95384','Gál','Dóra','','','21-322-1'),
('95156','Gerse','Ferenc','','','21-322-1'),
('94880','Kiss','Lajos','','','21-322-1'),
('95468','Litauszki','István','','','21-322-1'),
('95337','Pető','Csaba','István','','21-322-1'),
('94716','Szikora','Györgyné','','','11-210-0'),
('95522','Török','Balázs','','','21-322-1'),
('93310','Varga','Zoltán','','','21-322-1'),
('95356','Zoltán','Anna','','','21-322-1'),
('93570','Szabóné Vörös','Angelika','','','21-322-3'),
('95517','Balogh','László','Imre','','11-400-0'),
('95432','Izápy','Levente','','','11-400-0'),
('95249','Balogh','Csaba','Imre','','12-330-0'),
('95245','Berta','Béla','','','12-330-0'),
('94710','Boós','Tamás','','','12-330-0'),
('94717','Csik','Ferenc','','','12-330-0'),
('94650','Gyarmati','Boldizsár','','','12-330-0'),
('95389','Kóczián','László','József','','12-330-0'),
('95431','Nagy','Erzsébet','','','12-330-0'),
('94636','Patai','Sándor','','','12-330-0'),
('95077','Remmer','Tibor','','','12-330-0'),
('94366','Bánki','Gábor','','','12-420-0'),
('94579','Berczi','Balázs','','','12-420-0'),
('93758','Galló','György','','','12-420-0'),
('93351','Molnár','Géza','','','12-420-0'),
('93395','Scheidt','Béla','István','','12-420-0'),
('93566','Székely','Brigitta','','','12-420-0'),
('95069','Tánczos','Károly','','','12-420-0'),
('94015','Bognár','Gyula','','','12-430-0'),
('93881','Edőcs','Attila','','','12-430-0'),
('93438','Füzi','Attila','','','12-430-0'),
('95199','Juhász','Bence','','','12-430-0'),
('93353','Pálovics','Csaba','','','12-430-0'),
('93374','Somogyi','Gábor','','','12-430-0'),
('93417','Szernecz','Gábor','','','12-430-0'),
('93571','Thurzóné Fehér','Hajnalka','','','12-430-0'),
('93425','Zanker','László','','','12-430-0'),
('94758','Babai','Csilla','','','12-440-0'),
('93558','Bősze','Katalin','','','12-440-0'),
('93362','Fekete','László','','','12-440-0'),
('93855','Kovács','Miklós','','','12-440-0'),
('93782','Szikora','György','','','12-440-0'),
('95531','Balog','Tamás','','','13-321-0'),
('95320','Bánszki','László','Balázs','','13-321-0'),
('95530','Czimrák','György','','','13-321-0'),
('94295','Domonyi','Ferenc','','','13-321-0'),
('94026','Dóra','István','','','13-321-0'),
('95109','Drevenka','László','','','13-321-0'),
('95472','Farkas','Gábor','','','13-321-0'),
('94378','Hegedűs','Balázs','','','13-321-0'),
('95525','Kármán','István','Zoltán','','13-321-0'),
('95366','Lelesz','Tibor','','','13-321-0'),
('95134','Sárközi','László','','','13-321-0'),
('95474','Szász','József','Péter','','13-321-0'),
('95138','Szentmiklósi','Gábor','','','13-321-0'),
('95398','Bognár','Ferenc','','','13-421-0'),
('95462','Borsody','Olivér','','','13-421-0'),
('95215','Csonka','Zoltán','Endre','','13-421-0'),
('95374','Fekete','Levente','','','13-421-0'),
('95375','Gányási','Dávid','','','13-421-0'),
('93774','Geresics','Zoltán','','','13-421-0'),
('95529','Gergely','Albert','','','13-421-0'),
('95406','Harcsa','Péter','','','13-421-0'),
('95218','Hartmann','Bence','','','13-421-0'),
('93411','Illés','Ferenc','','','13-421-0'),
('94723','Jabronka','Sándor','','','13-421-0'),
('95294','Jakabovics','Imre','','','13-421-0'),
('95068','Kardos','Gábor','','','13-421-0'),
('93434','Kelemen','János','','','13-421-0'),
('94899','Kis','László','Barnabás','','13-421-0'),
('95381','Kiss','Sándor','','','13-421-0'),
('95095','Kozma','László','','','13-421-0'),
('95408','Ludányi','József','','','13-421-0'),
('94578','Menyhárt','Imre','','','13-421-0'),
('93972','Molnár','Attila','','','13-421-0'),
('95508','Nemes','Gábor','','','13-421-0'),
('95228','Németh','László','István','','13-421-0'),
('93898','Oláh','Tamás','','','13-421-0'),
('93625','Ozsváth','Artúr','','','13-421-0'),
('93435','Pap','Attila','','','13-421-0'),
('95502','Pesti','Imre','','','13-421-0'),
('95506','Rafael','János','','','13-421-0'),
('94722','Seres','Péter','Pál','','13-421-0'),
('93389','Somogyi','Attila','','','13-421-0'),
('94728','Szabó','János','','','13-421-0'),
('94765','Torma','Gábor','','','13-421-0'),
('95526','Tóth','Péter','','','13-421-0'),
('93897','Valkó','László','','','13-421-0'),
('95224','Vavrik','Zoltán','','','13-421-0'),
('93406','Babák','László','','','13-422-0'),
('94772','Bartal','Ferenc','','','13-422-0'),
('95293','Csáki','János','','','13-422-0'),
('94148','Dobos','József','','','13-422-0'),
('95063','Fodor','Zoltán','','','13-422-0'),
('94425','Fundukidisz','Szokrátész','','','13-422-0'),
('93638','Grózinger','Sándor','','','13-422-0'),
('93376','Kitka','Tibor','','','13-422-0'),
('93415','Kocsis','Zoltán','','','13-422-0'),
('94002','Kuti','István','','','13-422-0'),
('93453','Maka','Károly','József','','13-422-0'),
('93786','Máj','Henrik','','','13-422-0'),
('95070','Monfera','Tibor','','','13-422-0'),
('93914','Paunoch','Krisztián','','','13-422-0'),
('95448','Pósfai','András','Arnold','','13-422-0'),
('95473','Simon','Ádám','','','13-422-0'),
('93865','Szentmiklósi','Zsolt','','','13-422-0'),
('95001','Széles','Zoltán','Attila','','13-422-0'),
('95067','Bán','Ferenc','','','13-423-0'),
('93642','Bischoff','László','','','13-423-0'),
('93350','Csepelyi','Gusztáv','','','13-423-0'),
('95130','Dócs','Endre','','','13-423-0'),
('94988','Frideczki','Olivér','','','13-423-0'),
('93432','Halász','Géza','Tibor','','13-423-0'),
('93330','Kis','Zoltán','Károly','','13-423-0'),
('95479','Kisné Kanyó','Mária','','','13-423-0'),
('95385','Kőhalmi','Krisztián','','','13-423-0'),
('94534','Krénn','Lőrinc','','','13-423-0'),
('93367','Lenge','Zoltán','','','13-423-0'),
('93751','Máj','Tamás','','','13-423-0'),
('95179','Márhoffer','Attila','','','13-423-0'),
('93392','Orosz','László','','','13-423-0'),
('93373','Simon','Attila','','','13-423-0'),
('95421','Sinka','Zoltán','','','13-423-0'),
('94393','Sóvágó','Zoltán','','','13-423-0'),
('95152','Staniow','Tamás','','','13-423-0'),
('95383','Szabó','Gábor','Dávid','','13-423-0'),
('95478','Szabó','Ilona','','','13-423-0'),
('94336','Tápler','János','','','13-423-0'),
('93429','Tóth','Ferenc','','','13-423-0'),
('94528','Török','Péter','','','13-423-0'),
('95075','Varga','Tamás','János','','13-423-0'),
('95446','Vörös','Dominik','','','13-423-0'),
('94588','Balogh','István','','','13-424-0'),
('95486','Berényi','Tamás','','','13-424-0'),
('95118','Boda','Attila','','','13-424-0'),
('95464','Dodek','József','','','13-424-0'),
('94841','Dudar','György','','','13-424-0'),
('95512','Fridrich','József','','','13-424-0'),
('93859','Haludka','László','','','13-424-0'),
('95274','Hegedűs','Péter','','','13-424-0'),
('95513','Juhász','Bence','','','13-424-0'),
('94629','Kohári','István','','','13-424-0'),
('94582','Kovács','Attila','','','13-424-0'),
('94639','Kovács','József','László','','13-424-0'),
('95223','Kőpájer','János','','','13-424-0'),
('94842','Kőröshegyi','Csaba','','','13-424-0'),
('95227','Meszes','Zoltán','','','13-424-0'),
('94960','Oláh','Tibor','','','13-424-0'),
('95033','Sátori','Dániel','József','','13-424-0'),
('95528','Szám','Péter','','','13-424-0'),
('95494','Számel','Tibor','','','13-424-0'),
('95352','Székely','Kálmán','','','13-424-0'),
('93414','Takács','Károly','','','13-424-0'),
('95278','Zvornyik','Krisztina','','','13-424-0'),
('94243','Bőr','Gábor','','','13-425-0'),
('94232','Gémesi','János','','','13-425-0'),
('95131','Horváth','Dániel','Viktor','','13-425-0'),
('94244','Kuknyó','László','','','13-425-0'),
('95154','Oszvald','Ferenc','','','13-425-0'),
('93876','Palásti','Zoltán','','','13-425-0'),
('95196','Sipos','László','','','13-425-0'),
('95523','Szalma','Zoltán','','','13-425-0'),
('95117','Széles','Sándor','','','13-425-0'),
('95092','Vágányik','Mihály','','','13-425-0'),
('93381','Biró','Frigyes','','','13-431-0'),
('93314','Csizmadia','Zsigmond','','','13-431-0'),
('95407','Fodor','Zsolt','','','13-431-0'),
('95426','Gáspár','Ferenc','Imre','','13-431-0'),
('95251','Kovács','Ádám','Richárd','','13-431-0'),
('95413','Lekk','Tamás','','','13-431-0'),
('94135','Rettegi','Tibor','','','13-431-0'),
('94864','Sántits','Zoltán','','','13-431-0'),
('95427','Szabó','Károly','','','13-431-0'),
('95214','Vaida','Adrian','','','13-431-0'),
('94065','Veszelik','Pál','András','','13-431-0'),
('95395','Baker','Andy','George','','13-432-0'),
('93452','Botyánszki','Zsolt','Béla','','13-432-0'),
('95202','Bölcskei','László','','','13-432-0'),
('93852','Bujáki','János','','','13-432-0'),
('95269','Gidófalvi','István','','','13-432-0'),
('93355','Hegedüs','Gyula','','','13-432-0'),
('94810','Holecskó','József','','','13-432-0'),
('95484','Jambrich','Sándor','','','13-432-0'),
('95198','Kecser','Dénes','','','13-432-0'),
('95047','Kis','Csaba','István','','13-432-0'),
('93446','Lezsák','Zsolt','','','13-432-0'),
('93750','Lojdl','József','Imre','','13-432-0'),
('93304','Nagy','István','Lajos','','13-432-0'),
('94870','Plavecz','András','','','13-432-0'),
('93363','Seidl','Ferenc','','','13-432-0'),
('95339','Sinka','Péter','Pál','','13-432-0'),
('95101','Szabó','Csaba','','','13-432-0'),
('93785','Sziládi','Csaba','József','','13-432-0'),
('95055','Szőke','Szabolcs','','','13-432-0'),
('94676','Varga','János','Tamás','','13-432-0'),
('95377','Varga','Krisztofer','','','13-432-0'),
('94679','Balogh','István','','','13-433-0'),
('95322','Birnat','Anton','','','13-433-0'),
('95176','Bodnár','Csaba','Gyula','','13-433-0'),
('95194','Elek','Lajos','','','13-433-0'),
('95397','Hahn','András','','','13-433-0'),
('94367','Juhász','Gyula','','','13-433-0'),
('93391','Kovács','Kálmán','','','13-433-0'),
('93364','Kovács','Zoltán','','','13-433-0'),
('93941','László','Tibor','','','13-433-0'),
('93970','Lukács','Sándor','','','13-433-0'),
('95470','Nagy','Pál','','','13-433-0'),
('93460','Oszkó','Imre','István','','13-433-0'),
('95466','Sipos','Zsolt','','','13-433-0'),
('93384','Szalóczi','János','','','13-433-0'),
('94646','Telek','Csaba','','','13-433-0'),
('95188','Tóth','Gábor','','','13-433-0'),
('93795','Vedrédi','Attila','','','13-433-0'),
('95250','Bodai','Bence','','','13-441-0'),
('95524','Boldizsár','György','','','13-441-0'),
('93861','Dudás','Pál','','','13-441-0'),
('95057','Farkas','Ferenc','','','13-441-0'),
('93313','Gellény','Ottó','','','13-441-0'),
('95180','Gyurcsák','Ferenc','','','13-441-0'),
('94886','Kovács','Róbert','','','13-441-0'),
('95167','Lovász','Adrián','','','13-441-0'),
('95174','Mezei','György','','','13-441-0'),
('94736','Nagy','Szilveszter','','','13-441-0'),
('93308','Németh','Béla','','','13-441-0'),
('93343','Pápai','Lajos','Károly','','13-441-0'),
('95331','Rédl','Ferenc','','','13-441-0'),
('93338','Szabó','János','Sándor','','13-441-0'),
('93826','Toman','Nándor','','','13-441-0'),
('95497','Zsiák','Roland','Erik','','13-441-0'),
('93790','Ács','Attila','','','13-443-0'),
('93926','Bóna','Gábor','','','13-443-0'),
('95321','Böröczi','Richárd','','','13-443-0'),
('95203','Cserni','Sándor','','','13-443-0'),
('93437','Cserny','Csaba','István','','13-443-0'),
('95328','Csorba','Péter','','','13-443-0'),
('95527','Hamar','Árpád','','','13-443-0'),
('95511','Hujacz','Zoltán','','','13-443-0'),
('93561','Jenei','Lászlóné','','','13-443-0'),
('93319','Kalmár','István','László','','13-443-0'),
('94981','Kaszás','Tamás','','','13-443-0'),
('95200','Kiss','Ádám','','','13-443-0'),
('94935','Kiss','Ákos','','','13-443-0'),
('95475','Kövesdi','Tibor','','','13-443-0'),
('95168','Máthé','Norbert','','','13-443-0'),
('94033','Németi','László','Imre','','13-443-0'),
('94361','Ombodi','József','','','13-443-0'),
('93354','Papp','János','István','','13-443-0'),
('93979','Pisiák','Ágoston','István','','13-443-0'),
('93426','Wild','Zoltán','','','13-443-0'),
('94918','Bognár','József','Ferenc','','13-444-0'),
('94982','Breza','Arnold','','','13-444-0'),
('93622','Hajdu','Tibor','','','13-444-0'),
('95499','Jaksi','Mihály','','','13-444-0'),
('95444','Krehely','Sándor','','','13-444-0'),
('95445','Máté','Zoltán','','','13-444-0'),
('95501','Örkényi','Szabolcs','András','','13-444-0'),
('95246','Pusztai','Olivér','','','13-444-0'),
('95323','Ragályi','László','József','','13-444-0'),
('95500','Remisch','Bence','','','13-444-0'),
('94897','Steer','János','','','13-444-0'),
('95452','Buczynski','Kazimierz','Edward','','11-300-0'),
('93303','Erőss','Mihály','','','11-310-0'),
('95450','Kormány','Nándor','','','11-310-0'),
('93387','Laczkó','József','','','11-310-0'),
('93306','Mityka','György','','','11-310-0'),
('93318','Örkényi','Zsolt','','','11-310-0'),
('95225','Szabó','Bence','','','11-310-0'),
('95238','Tóth','Miklós','','','11-310-0'),
('94973','Végh','Benjamin','Ákos','','11-310-0'),
('94288','Barát','Imre','','','11-330-0'),
('94830','Egyed','István','','','11-330-0'),
('93621','Jenei','László','','','11-330-0'),
('95394','Máté','István','','','11-330-0'),
('95058','Molnár','András','','','11-330-0'),
('93397','Németh','Attila','','','11-330-0'),
('95252','Öreg','Zoltán','','','11-330-0'),
('94664','Papp','Imre','László','','11-330-0'),
('95449','Rőth','Ágnes','Beáta','','11-330-0'),
('93618','Szakács','Sándor','','','11-330-0'),
('95476','Ihász','Andrea','','','11-410-0'),
('94673','Kiss','András','','','11-410-0'),
('95120','Kohut','Barbara','','','11-410-0'),
('94896','Tokai','Károly','','','11-410-0'),
('95159','Tóth','Gábor','','','11-410-0'),
('95515','Verseczki','András','Manó','','11-410-0'),
('95387','Berencsi','Attila','Endre','','12-340-0'),
('93560','Bognár','Gyuláné','','','12-340-0'),
('93291','Holló','János','','','12-340-0'),
('93749','Plavecz','József','','','12-340-0'),
('95455','Bányai','Károly','Zsolt','','13-333-0'),
('95490','Hartmann','Csaba','','','13-333-0'),
('95243','Ködmön','Emil','','','13-333-0'),
('95453','Remete','József','','','13-333-0'),
('95236','Rezsu','Sándor','','','13-333-0'),
('95270','Savella','Bálint','','','13-333-0'),
('93627','Szalkai','László','','','13-333-0'),
('93615','Székelyi','István','','','13-333-0'),
('95283','Vidosa','Zoltán','','','13-333-0'),
('93743','Gulyás','Zoltán','','','14-460-0'),
('94805','Héni','Tibor','','','14-460-0'),
('95440','Kóczé','Dezső','','','14-460-0'),
('94989','Sasvári','Krisztina','Judit','','14-460-0'),
('93293','Sebestyén','Tibor','','','14-460-0'),
('95516','Tisóczki','Richárd','Zsolt','','14-460-0');

-- Szerepek:
insert into szerep values
('mérőeszköz felügyelő'),
('metrológus'),
('laborvezető'),
('lekérdező'),
('admin');

-- Felhasználók:
insert into felhasznalo(fhnev,vnev,knev,hnev,titulus,szerep) values
('jobbanz','Jobban','Zoltán','Tibor','','laborvezető'),
('sasvarik','Sasvári','Krisztina','Judit','','mérőeszköz felügyelő'),
('ipachc','Ipach','Corina','','','metrológus'),
('gsm','Gulyásné Sasvári','Mária','Erzsébet','','lekérdező'),
('kalibadmin','Kalibra','Rendszer','Adminisztrátor','','admin');

-- Minősítések:
insert into minosites values
('kalibrált'),
('nem kalibrált'),
('selejt');

-- Mennyiségi egységek:
insert into me values
('UNI','univerzális'),
('-','határozatlan'),
('%','Százalék'),
('%(t)','Tömegszázalék'),
('%(V)','Térfogatszázalék'),
('%o(t)','Tömegezrelék'),
('%o(V)','Térfogatezrelék'),
('°C','Celsius fok'),
('°F','Fahrenheit'),
('A','Amper'),
('bar','bar'),
('cm','Centiméter'),
('Coll','Inch'),
('F','Farad'),
('Fok','Fok'),
('g','Gramm'),
('h','Óra'),
('hPa','Hektopascal'),
('Hz','Hertz (1/másodperc)'),
('J','Joule'),
('K','Kelvin'),
('kA','Kiloamper'),
('kHz','Kilohertz'),
('kJ','Kilojoule'),
('km','Kilométer'),
('km/h','Kilométer/óra'),
('kN','Kilonewton'),
('kOhm','Kiloohm'),
('kPa','Kilopascal'),
('kt','Kilotonna'),
('kV','Kilovolt'),
('kVA','Kilovoltamper'),
('kW','Kilowatt'),
('kWh','Kilowatt/óra'),
('l','Liter'),
('m','Méter'),
('m/s','Méter/másodperc'),
('m/s2','Méter/másodperc^2'),
('m2','Négyzetméter'),
('m3','Köbméter'),
('mA','Milliamper'),
('mbar','Millibar'),
('mF','Millifarad'),
('mg','Milligramm'),
('MGW','Megawatt'),
('MHz','Megahertz'),
('min','Perc'),
('MJ','Megajoule'),
('mJ','Millijoule'),
('ml','Milliliter'),
('mm','Milliméter'),
('mm2','Négyzetmilliméter'),
('mm3','Köbmilliméter'),
('MN','Meganewton'),
('MOhm','Megaohm'),
('MPa','Megapascal'),
('ms','Millimásodperc'),
('mT','Millitesla'),
('MV','Megavolt'),
('mV','Millivolt'),
('MVA','Megavoltamper'),
('mW','Milliwatt'),
('MWh','Megawattóra'),
('N','Newton'),
('N/m','Newton/Méter'),
('N/mm2','Newton/négyzetmilliméter'),
('nA','Nanoamper'),
('nF','Nanofarad'),
('nm','Nanométer'),
('ns','Nanomásodperc'),
('Ohm','Ohm'),
('Óra','Óra'),
('Pa','Pascal'),
('pF','Pikofarad'),
('ppb','Parts per billion'),
('ppb(m)','Massen-parts per billion'),
('ppb(V)','Volumen-parts per billion'),
('ppm','Parts per million'),
('ppm(m)','Massen-parts per million'),
('ppm(V)','Volumen-parts per million'),
('ppt','Parts per trillion'),
('ppt(m)','Massen-parts per trillion'),
('ppt(V)','Volumen-parts per trillion'),
('ps','Pikomásodperc'),
('s','Másodperc'),
('T','Tesla'),
('t','Tonna'),
('uA','Mikroamper'),
('uF','Mikrofarad'),
('um','Mikrométer'),
('V','Volt'),
('VA','Voltamper'),
('W','Watt');

-- Eszköztípusok:
insert into eszktipus values
('mechanikus'),
('mélységmérős'),
('csőrös'),
('kétoldalas'),
('univerzális'),
('kengyeles'),
('-');

-- Műlödési módok:
insert into mukmod values
('mechanikus'),
('nóniuszos'),
('mérőórás'),
('digitális'),
('univerzális'),
('-');

-- Teszt Törzsadatok:
insert into torzsadat values
('MEV0000001-1','tolóméró','Mitutoyo','15A2','nóniuszos','mélységmérős','1','mm','0.02','mm','0-150','mm',365,false),
('MEV0000002-2','mérőszalag','OBI','','mechanikus','mechanikus','1','mm','1','mm','0-3','m',180,false),
('MEV0000003-3','talpas derékszög','','','mechanikus','mechanikus','','-','2','%','0-300','mm',365,false),
('MEV0000004-4','multiméter','Voltcraft','CAT III.','univerzális','univerzális','','-','','-','','-',720,false),
('MEV0000005-5','mikorméter','Mitutoyo','5075','nóniuszos','kengyeles','0.5','mm','0.01','mm','50-75','mm',90,false);

-- Teszt eszközök:
 insert into eszkoz(gravirszam,cikkszam,gysz,minosites,ekalibciklus,kaliblejar,uzemdatum) values
('100','MEV0000001-1','My 1234','kalibrált',180,'2020-12-31','2019-11-23'),
('101','MEV0000001-1','My 1872','kalibrált',360,'2021-12-31','2020-01-01'),
('102','MEV0000001-1','My 9812','kalibrált',120,'2021-03-31','2020-03-19'),
('103','MEV0000001-1','My 1882','kalibrált',720,'2020-12-31','2020-04-08'),
('104','MEV0000001-1','My 8712','kalibrált',540,'2022-06-17','2020-06-01');



 

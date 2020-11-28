-------------------------------------------------------------------------------
--
-- KALIBRA adatbázis
--
-- 2020. Szikora György
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- \i ldr_install.sql
-- Csak Linux psql konzolos létrehozás esetén kell a következő 4 sor.
-- \c template1
-- drop database if exists kalibra;
-- create database kalibra;
-- \c kalibra
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
	típus d_nev,
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

-- Aktív dolgozó ellenőrzése
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

-- Aktív felhasználó ellenőrzése
create or replace function fn_aktiv_felhasznalo (f varchar)
	returns boolean as
$$
declare
	aktiv felhasznalo.aktivfelhasznalo%type;
	felh alias for $1;
begin
	select aktivfelhasznalo into aktiv where felhasznalo=felh;
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

-- Cikkszám zárolásának ellenőrzése
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

-- Aktív partner ellenőrzése
create or replace function fn_aktiv_partner(p varchar)
	returns boolean as
$$
declare
	
begin

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
-------------------------------------------------------------------------------


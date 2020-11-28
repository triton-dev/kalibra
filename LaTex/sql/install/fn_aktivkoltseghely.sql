-- Aktív költséghely ellenőrzése.

create or replace function fn_aktiv_koltseghely(k varchar) 
returns boolean as
$$
declare
	ktg alias for $1;
	akt koltseghely.aktiv%type;
begin
	select aktiv into akt from koltseghely where ktghely=ktg;
	if not found then
		raise notice '% költséghely nem létezik.',ktg;
		return false;
	end if;
	return akt;
end;
$$
language plpgsql;
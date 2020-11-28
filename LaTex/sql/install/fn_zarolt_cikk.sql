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
-- aktív dolgozó ellenőrzése

create or replace function fn_kilepett_dolgozo(t varchar) 
returns boolean as
$$
declare
	tsz alias for $1;
	akt dolgozo.kilepett%type;
begin
	select kilepett into akt from dolgozo where torzsszam=tsz;
	if not found then
		raise notice '% törzsszámú dolgozó nem létezik.',tsz;
		return true;
	end if;
	return akt;
end;
$$
language plpgsql;
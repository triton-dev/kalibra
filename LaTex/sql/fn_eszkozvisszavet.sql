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
	
	update eszkoz set kiadva=false 
		where gravirszam=gravir;
	
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
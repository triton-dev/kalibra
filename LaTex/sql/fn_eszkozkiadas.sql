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

begin
	select hol,mettol into holvan,mikor from kiadotteszkoz
		where gravirszam=gravir and meddig is null;
		
	if found then
		raise notice '% gravírszámú eszköz % időpontban kiadva % -nak/nek.',
			gravir,mikor,holvan;
		return false;
	end if;
	
	insert into kiadotteszkoz(gravirszam,hol) values(gravir, hely);
	
	update eszkoz set kiadva=true where gravirszam=gravir;
	
	if dolgozonak then
		insert into mozgdolg(gravirszam,torzsszam) values(gravir,hely);	
	else
		insert into mozgktgh(gravirszam, ktghely) values(gravir,hely);	
	end if;
	return true;
end;
$$
language plpgsql;
create or replace function muszermozgas() returns trigger as
$$
declare
	gravszam eszkoz.gravirszam%type;
	tol kiadotteszkoz.mettol%type;
	holvan kiadotteszkoz.hol%type;
begin
	if (TG_OP = 'INSERT') then
	raise notice 'INSERT';
		select gravirszam,mettol,hol into gravszam,tol,holvan from kiadotteszkoz 
			where gravirszam=new.gravirszam and meddig is null;
		if (found) then
			raise exception '% gravírszámú eszköz % időponttól kiadva: %',new.gravirszam,tol,holvan;
			return null;
		end if;
		insert into kiadotteszkoz(gravirszam,hol) values(new.gravirszam,new.torzsszam);
		update eszkoz set kiadva=true where gravirszam=new.gravirszam;
		return new;
	end if;
	
	if (TG_OP = 'UPDATE') then
	raise notice 'UPDATE';
		select gravirszam into gravszam from kiadotteszkoz 
			where gravirszam=new.gravirszam and meddig is null;
		if (not found) then
			raise exception '% gravírszámú eszköz nincs kiadva.', new.gravirszam;
			return null;
		end if;
		update eszkoz set kiadva=false where gravirszam=new.gravirszam;
		update kiadotteszkoz set meddig=current_timestamp where gravirszam=new.gravirszam and hol=new.hol;
		return new;
	end if;
	--return null;
end;
$$
language plpgsql;

drop trigger if exists muszerkiad on mozgdolg;
create trigger muszerkiad before insert or update on mozgdolg
for each row execute procedure muszermozgas();
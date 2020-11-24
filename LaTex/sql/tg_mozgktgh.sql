create or replace function muszermozgaskh() returns trigger as
$$
declare
	gravszam eszkoz.gravirszam%type;
	tol kiadotteszkoz.mettol%type;
begin
	if (TG_OP = 'INSERT') then
	raise notice 'INSERT';
		select gravirszam,mettol into gravszam,tol from kiadotteszkoz 
			where gravirszam=new.gravirszam and meddig is null;
		if (found) then
			raise exception '% gravírszámú eszköz % időponttól kiadva.',new.gravirszam,tol;
			return null;
		end if;
		insert into kiadotteszkoz(gravirszam) values(new.gravirszam);
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
		update kiadotteszkoz set meddig=current_timestamp where gravirszam=new.gravirszam;
		return new;
	end if;
	--return null;
end;
$$
language plpgsql;

drop trigger if exists muszerkiadkh on mozgktgh;
create trigger muszerkiadkh before insert or update on mozgktgh
for each row execute procedure muszermozgaskh();
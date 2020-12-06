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
		and jelszo = md5(jsz);
	if found then 
		return true;
	end if; -- sikeres bejelentkezés
	
	return false;  -- sikertelen bejelentkezés
end;
$$
LANGUAGE plpgsql;

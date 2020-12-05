-- Function: alapjelszo(text)

 

-- DROP FUNCTION alapjelszo(text);

 

CREATE OR REPLACE FUNCTION alapjelszo(text)

  RETURNS integer AS

$BODY$

declare

alapjelszo text := md5('kalibra');

begin

  update felhasznalo set jelszo = alapjelszo where md5(fhnev) = md5($1);

  return 1;

end;

$BODY$

  LANGUAGE plpgsql VOLATILE

  COST 100;

ALTER FUNCTION alapjelszo(text)

  OWNER TO gyuri;

 

---------------------------------------------------------------------------

 

 

-- Function: jelszocsere(text, text, text, text)

 

-- DROP FUNCTION jelszocsere(text, text, text, text);

 

CREATE OR REPLACE FUNCTION jelszocsere(

    text,

    text,

    text,

    text)

  RETURNS integer AS

$BODY$

declare

begin

  if $2 <> $3 or length(trim($2)) = 0 or length(trim($3)) = 0

    or trim($2) = trim($4) or trim($3) = trim($4) then

    return 0; -- az új jelszavak nem egyeznek meg, vagy üresek,

              -- vagy nincs változás

  end if;

  perform fhnev from felhasznalo where md5(fhnev) = md5($1)

    and jelszo = md5($4)

    and meddig is null;

  if not found then

    return 0; -- nem található a felhasználónév-jelszó páros

  else

    update felhasznalo set jelszo = md5($2) where md5(fhnev) = md5($1);

    return 1; -- sikeres jelszócsere

  end if;

end;

$BODY$

  LANGUAGE plpgsql VOLATILE

  COST 100;

ALTER FUNCTION jelszocsere(text, text, text, text)

  OWNER TO gyuri;

 

 

--------------------------------------------------------------------------------

 

-- Function: login(text, text)

 

-- DROP FUNCTION login(text, text);

 

CREATE OR REPLACE FUNCTION login(

    text,

    text)

  RETURNS integer AS

$BODY$

declare

begin

  perform fhnev from felhasznalo where md5(fhnev) = md5($1)

    and jelszo = md5($2)

    and meddig is null;

 

  if found then return 1; end if; -- sikeres bejelentkezés

  return 0;  -- sikertelen bejelentkezés

end;

$BODY$

  LANGUAGE plpgsql VOLATILE

  COST 100;

ALTER FUNCTION login(text, text)

  OWNER TO gyuri;
CREATE OR REPLACE FUNCTION validar_campos_nascimento()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.nome IS NULL THEN
        RAISE EXCEPTION 'Nome não pode ser nulo';
    ELSIF NEW.data_nascimento IS NULL THEN
        RAISE EXCEPTION 'Data de nascimento não pode ser nula';
    ELSIF NEW.peso IS NULL THEN
        RAISE EXCEPTION 'Peso não pode ser nulo';
    ELSIF NEW.altura IS NULL THEN
        RAISE EXCEPTION 'Altura não pode ser nula';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_nascimento_update
BEFORE UPDATE ON nascimento
FOR EACH ROW
EXECUTE FUNCTION validar_campos_nascimento();

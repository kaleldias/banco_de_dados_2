CREATE OR REPLACE FUNCTION validar_horario_agendamento()
RETURNS TRIGGER AS $$
DECLARE
    hora_inicio TIME := NEW.horario_inicio;
    hora_fim TIME := NEW.horario_fim;
    dia_semana INT;
BEGIN
    dia_semana := EXTRACT(DOW FROM NEW.data_agendamento);
    
    IF dia_semana = 0 OR dia_semana = 6 THEN
        RAISE EXCEPTION 'Agendamentos não permitidos no sábado e domingo';
    END IF;
    
    IF (hora_inicio < '08:00' OR (hora_inicio >= '12:00' AND hora_inicio < '13:30') OR hora_inicio >= '17:30') THEN
        RAISE EXCEPTION 'Horário de agendamento fora do expediente';
    END IF;
    
    IF (hora_fim > '12:00' AND hora_inicio < '12:00') OR (hora_fim > '17:30') THEN
        RAISE EXCEPTION 'O agendamento não pode ultrapassar o horário do expediente';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_agendamento
BEFORE INSERT OR UPDATE ON agendamento
FOR EACH ROW
EXECUTE FUNCTION validar_horario_agendamento();

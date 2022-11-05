-- +++++++++++++++++++++++++++++++
-- Exemplo 1 - Atualizando Saldos
-- +++++++++++++++++++++++++++++++
--
--
-- Passo 01 - Criar a function
--
create function saldo_upd() returns opaque as
'
begin
     if tg_op = ''INSERT'' then
        update empresas
        set saldo = (saldo + (new.credito - new.debito))
        where id = new.fkempresa;
        return new;
     end if;
                                                                              
     if tg_op = ''DELETE'' then
        update empresas
        set saldo = (saldo - (old.credito - old.debito)) where id = old.fkempresa;
        return old;
        end if;
     if tg_op = ''UPDATE'' then
        update empresas
        set saldo =
        (saldo - (old.credito - old.debito)+
        (new.credito - new.debito))
        where id = old.fkempresa OR id = new.fkempresa
        return new;
        end if;
end;
'
language 'plpgsql';


-- Passo 02 - Criar a trigger
                                                                              
create trigger atualiza_saldo
after insert or update or delete
on movempresas
for each row
execute procedure saldo_upd();
--


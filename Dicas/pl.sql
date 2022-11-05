-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
create or replace function ajusta_saldo_conta(integer) returns numeric as
'
declare
        idconta alias for $1;
        vsaldo  numeric;
begin
        vsaldo = (select sum(movimentos.credito-movimentos.debito) from movimentos where movimentos.fkconta = idconta);
                                                                              
        if vsaldo is null then
                raise exception ''Conta % não cadastrada!'',idconta;
        else
                update contas set saldo = (vsaldo) where id = idconta;
                return vsaldo;
        end if;
end;
'
language 'plpgsql';




-- Atualizando o saldo de todas as contas
--
create or replace function ajusta_saldos_contas() returns bigint as
'
declare
        vsaldo numeric;
        r record;
        cont bigint;
begin
        for r in select id from contas loop
                vsaldo = (select sum(movimentos.credito-movimentos.debito) from movimentos where movimentos.fkconta = r.id);
                update contas set saldo = (vsaldo) where id = r.id;
        end loop;
        cont := (select count(id) from contas);
        return cont;
end;
'
language 'plpgsql';


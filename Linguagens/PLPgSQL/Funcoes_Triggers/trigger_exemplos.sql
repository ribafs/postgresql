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
        where id = old.fkempresa;
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


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 2 - Log de Insert, Update e Delete da tabela precos
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
--
-- Passo 01 - Criacao da function
--
--
create or replace function precos_log() returns opaque as
'
begin

     if tg_op = ''INSERT'' then
        new.data_ins := now();
        new.user_ins := current_user;
        new.data_atu := now();
        new.user_atu := current_user;
     end if;

     if tg_op = ''UPDATE'' then
        new.data_ins := old.data_ins;
        new.user_ins := old.user_ins;
        new.data_atu := now();
        new.user_atu := current_user;
     end if;

     if tg_op=''DELETE'' then
	insert into precos_log_del(id,
                                     produto,
                                     valor,
                                     data_ins,
                                     user_ins,
                                     data_atu,
                                     user_atu,
                                     data_del,
                                     user_del)

                              values(old.id,
                                     old.produto,
                                     old.valor,
                                     old.data_ins,
                                     old.user_ins,
                                     old.data_atu,
                                     old.user_atu,
                                     now(),
                                     current_user);
     end if;

     return new;

end;
'
language 'plpgsql';
--
-- Passo 02 - Criacao da trigger
-- Trigger para
-- before (antes de insert ou update)
--
create trigger precos_log_ins_upd
before insert or update
on precos
for each row
execute procedure precos_log();
--
-- Trigger para
-- after (apos ter deletado)
--
create trigger precos_log_del
after delete
on precos
for each row
execute procedure precos_log();
--
--
-- ++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Passo 01 - Criar a view
--
create view v_precos as
select id, produto, valor from precos;
-- Passo 02 - Criar as regras para ins, upd e del
-- Regra para Insert
create rule rv_precos_ins as
on insert to v_precos
do instead
insert into precos(produto,valor) values(new.produto,new.valor);
--
-- Regra para Update
--
create rule rv_precos_upd as
on update to v_precos
do instead
update precos
set
   produto = new.produto,
   valor = new.valor
   where id = old.id;
--
-- Regra para Delete
--
create rule rv_precos_del as
on delete to v_precos
do instead
delete from precos
where id = old.id;

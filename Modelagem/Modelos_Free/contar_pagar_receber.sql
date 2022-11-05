Controle de Contas a Pagar e a Receber

telefones -- fixos ou celulares
telefone
pessoa
prefixo
numero

/*
enderecos
endereco
tipo_logradouro
logradouro
numero
bairro
cidade
uf
email
*/

funcionarios -- Serão os usuários do sistema da intranet
funcionario
data_adminssao
nome
data_nasc
cep --rel
rg
cpf
telefone --rel
email
contato
contato_telefone

clientes
cliente
data_cadastro
nome
data_nasc
cep --rel
rg
cpf
cnpj
inscricao_estadual
telefone
email
contato
contato_telefone

fornecedores
fornecedor
data_cadastro
nome
cep --rel
cpf
cnpj
inscricao_estadual
telefone
fax
site
email
contato
contato_telefone

contas_pagar
conta
data_emissao
fornecedor
vencimento
documento -- fatura, nota fiscal, etc
descricao
valor

contas_pagas
conta
data
valor

contas_receber
conta
data_emissao
cliente
vencimento
documento -- fatura, nota fiscal, etc
descricao
valor

contas_recebidas
conta
data
valor

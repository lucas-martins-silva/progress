/*
**
** Include para definicao da temp-table para informacoes sobre 
** a empresa que deu origem a mensagem do item para o adapter NeoGrid.
** 
** Autor: Anderson Elton Kruger
** Data: 16/05/2001
** 
*/


def temp-table tt-from-role 
    field local-orig as char
    field papel-orig as char
    field contato-orig-nome as char
    field contato-orig-fone as char
    field contato-orig-email as char
    field endereco-orig like estabelec.endereco
    field cidade-orig like estabelec.cidade
    field bairro-orig like estabelec.bairro
    field uf-orig like estabelec.estado
    field pais-orig like estabelec.pais
    field cep-orig like estabelec.cep.

/*
**
** Include para definicao da temp-table para informacoes sobre 
** a empresa destino da mensagem do item para o adapter NeoGrid.
** 
** Autor: Anderson Elton Kruger
** Data: 16/05/2001
** 
*/

def temp-table tt-to-role
    field local-dest as char
    field papel-dest as char
    field contato-dest-nome as char
    field contato-dest-fone as char
    field contato-dest-email as char
    field endereco-dest like estabelec.endereco
    field cidade-dest like estabelec.cidade
    field bairro-dest like estabelec.bairro
    field uf-dest like estabelec.estado
    field pais-dest like estabelec.pais
    field cep-dest like estabelec.cep.

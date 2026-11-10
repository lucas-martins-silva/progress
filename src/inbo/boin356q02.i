/*
**  BOIN356q02.i
**
**  Prazo-Compra X Item-Forne - Parcelas X Fornecedores
**
**  éltima altera‡Æo : 26/11/99 - brf13170 (Odil B. Neto)
**
**  Espec¡fica de WCC0301D.W
**
*/
     
def temp-table {1} NO-UNDO
    field sequencia    as integer
    field numero-ordem like prazo-compra.numero-ordem  
    field parcela      like prazo-compra.parcela
    field fornec       like item-fornec.cod-emite 
    field nome-fornec  like emitente.nome-abrev
    field quantidade   like ordem-compra.qt-solic format ">>>>>,>>9.9999"
    field contr-forn   like item-fornec.contr-forn
    field data-entrega like prazo-compra.data-entrega
    field r-rowid  as rowid.


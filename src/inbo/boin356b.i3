/*
**  BOIN356b.i2
**
**  Prazo-Compra X Item-Forne - Parcelas X Fornecedores
**
**  éltima altera‡Æo : 26/11/99 - brf13170 (Odil B. Neto)
**
**  Temp Table Auxiliar - Espec¡fica de WCC0301D.W
**  Criada para conter os dados de quantidade alterados 
**  em tela pelo usu rio.
**
*/
     
def temp-table {1} NO-UNDO
    field i-seq          as integer
    field de-quant       as decimal
    field r-ordem-compra as rowid
    field r-prazo-compra as rowid
    field r-rowid        as rowid.
    

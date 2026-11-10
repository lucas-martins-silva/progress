/*
**  BOAD180F.I
**
**  mov-ap - Movimentação dos Documentos (Contas a Pagar)
**
**  Ultima altera‡Æo : 30/03/99 - GeraBO
*/
 
DEFINE TEMP-TABLE {1} like mov-ap
    field conta-contab as int format 9999999999999
    field c-lanca  as char 
    field r-rowid  as rowid.

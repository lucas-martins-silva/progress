/*
**  BOAD049D.i
**
**  tt-conta-contabil - Contas Contábeis dos Impostos dos Títulos a Receber
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
DEFINE TEMP-TABLE {1}         
    field cod-conta-contabil     like conta-contab.conta-contabil
    field titulo-conta           like conta-contab.titulo
    field natureza               as character format "XX"
    field valor                  like titulo.vl-original
    field r-rowid                as rowid.


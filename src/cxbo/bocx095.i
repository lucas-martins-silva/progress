/*
**  BOCX095.i
**
**  desp-imp - Esta tabela mantem os registros do cadastro de despsas/impostos que serao utilizados nos processos de importacao.
**
**  Ultima alteracao : 04/05/99 - GeraBO
*/

DEFINE TEMP-TABLE {1} NO-UNDO  like desp-imp
    field r-rowid              as rowid
    index codigo is unique primary
        cod-desp.        

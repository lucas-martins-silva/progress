/**********************************************************************************
**
**  APAPI019.I
**
**  DEFINIÄ«O DE TEMP-TABLEÔS.
** 
**  i-opcao: 1-inclui 2-modifica 3-elimina 4-copia 5-atualiza 
**
**********************************************************************************/

def temp-table tt-pef-pec no-undo
    field i-opcao            as int 
    field c-usuario          as char format "x(12)"
    field cod-versao-integ   as int
    field l-vid-rel          as logical.

def temp-table tt-mov-pef like mov-pef-pend
    field l-copia-reg        as logical.
    
def temp-table tt-erro-pef-prep no-undo
    field i-cod-erro        as int  format "9999999"
    field c-desc-erro       as char format "x(70)"
    field c-arquivo-erro    as char format "x(100)".
    
/* apapi019.i */

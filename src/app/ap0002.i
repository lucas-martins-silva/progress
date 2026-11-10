/******************************************************************************
***
*** app/ap0002.i - Verifica Autoriza‡äes Documento.
***
***              ### (Include usada nos programas ap0002.p e ap0002a.p).
***
******************************************************************************/

def input  param p-ep-codigo    as integer no-undo.
def input  param p-cod-estabel  as char    no-undo.
def input  param p-cod-fornec   as integer no-undo.
def input  param p-cod-esp      as char    no-undo.
def input  param p-serie        as char    no-undo.
def input  param p-nr-docto     as char    no-undo.
def input  param p-parcela      as char    no-undo.
def input  param p-cod-portador as integer no-undo.
def input  param p-nr-bordero   as integer no-undo.
def input  param p-valor        as dec     no-undo.
def input  param p-tipo-pagto   as integer no-undo.
def input  param p-usuario      as char    no-undo.
def output param p-erro         as logical no-undo.
            
def var i-permissao  as integer no-undo.
def var i-nr-autoriz as integer no-undo.
def var l-view-msg   as logical no-undo.
def var l-estabelec  as logical no-undo.
def var c-char-2     as char    no-undo.
def var l-erro       as logical no-undo.

assign p-erro       = no
       i-permissao  = 0
       i-nr-autoriz = 0
       l-view-msg   = {1}.
                        
find first param-ap where param-ap.ep-codigo = p-ep-codigo no-lock no-error.

find first estabelec no-lock
     where estabelec.cod-estabel = p-cod-estabel no-error.
     
if avail estabelec then 
   assign l-estabelec = yes
          c-char-2    = estabelec.char-2.     
    
{app/ap0002.i3}

assign p-erro = l-erro.

/* Fim Include */


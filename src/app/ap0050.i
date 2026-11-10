/******************************************************************************
***
*** app/ap0050.i - Verifica Autoriza‡äes Documento.
***
***              ### (Include usada no programa ap0050.p).
***
******************************************************************************/

def input  param p-row-tit-ap as rowid   no-undo.
def input  param p-usuario    as char    no-undo.
def output param p-erro       as logical no-undo.
        
def var i-nr-autoriz as integer   no-undo.
def var i-permissao  as integer   no-undo.
def var c-tipo       as character no-undo.
def var l-view-msg   as logical   no-undo.
def var l-erro       as logical   no-undo.
def var l-estabelec  as logical   no-undo.
def var c-char-2     as char      no-undo.
                    
assign p-erro       = no
       i-nr-autoriz = 0
       i-permissao  = 0
       l-view-msg   = {1}.
                        
find tit-ap where rowid(tit-ap) = p-row-tit-ap no-lock no-error.
if  avail tit-ap then do:

    find first param-ap 
         where param-ap.ep-codigo = tit-ap.ep-codigo no-lock no-error.
        
    find first estabelec no-lock
         where estabelec.cod-estabel = tit-ap.cod-estabel no-error.
        
    if  avail estabelec then
        assign l-estabelec = yes
               c-char-2    = estabelec.char-2.
    else
        assign l-estabelec = no
               c-char-2    = "".    

    {app/ap0050.i3}
        
    assign p-erro = l-erro.    
end.
    
/* Fim de Include */

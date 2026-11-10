/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX275 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX275 MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX275.P
**
**  decl-hist-proc-imp - Declara‡Æo Comunica‡Æo Processo Importa‡Æo
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY decl-hist-proc-imp
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME decl-hist-proc-imp

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

def var i-pos             as integer no-undo.
def var c-idiom           as char format "x(12)"  no-undo.
def var c-cod-idiom-usuar as char format "x(12)"  no-undo.
def var c-idiom-usuar     as char format "x(12)"  no-undo.
def var c-proc  like processo-imp.nr-proc-imp     no-undo.           
def var c-est   like processo-imp.cod-estabel     no-undo.
def var i-emit  like processo-imp.cod-exportador  no-undo.
def var i-decl  like decl-cliente.de-codigo       no-undo.
def var i-iti   like processo-imp.cod-itiner      no-undo.  
def var i-seq   like decl-hist-proc-imp.sequencia no-undo.   

{include/boini.i}
{cxbo/bocx275.i RowObject}

def temp-table tt-idioma 
      field cod-idioma as char format "x(12)"
      index idioma cod-idioma.

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

procedure setConstraint1:
end procedure.

procedure setConstraint2:
/*
** procedure utilizada no browser de declar‡äes por pontos do processo de importa‡Æo
*/
def input parameter p-rowid as rowid no-undo.

find historico-proc-imp where rowid(historico-proc-imp) = p-rowid no-lock no-error.

end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock where
                {&TABLE-NAME}.cod-estabel = historico-proc-imp.cod-estabel and
                {&TABLE-NAME}.nr-proc-imp = historico-proc-imp.nr-proc-imp and
                {&TABLE-NAME}.cod-itiner  = historico-proc-imp.cod-itiner and
                {&TABLE-NAME}.sequencia   = historico-proc-imp.sequencia.                             
    end case.
    assign l-query    = true
           i-bo-query = i-abertura.
end procedure.
 
{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
{include/bonav.i}
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
{include/boexecre.i}
{include/boexedel.i}
{include/bovalupt.i}
{include/bovaldel.i}

procedure findCodigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-cod-estabel as char no-undo.
    def input parameter c-nr-proc-imp as char no-undo.
    def input parameter i-cod-itiner as integer no-undo.
    def input parameter i-sequencia as integer no-undo.
    def input parameter i-de-codigo as integer no-undo.
    def output parameter c-return as char no-undo.
        
    run startMethod("find":U).
 
    find {&TABLE-NAME} where {&TABLE-NAME}.cod-estabel = c-cod-estabel and
                             {&TABLE-NAME}.nr-proc-imp = c-nr-proc-imp and
                             {&TABLE-NAME}.cod-itiner = i-cod-itiner and
                             {&TABLE-NAME}.sequencia = i-sequencia and
                             {&TABLE-NAME}.de-codigo = i-de-codigo 
                             no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.                           
    end.
    else do:
       run setCurrent.
    end.
    run endMethod("find":U).
end procedure.

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
     
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.

procedure executeUpdate:
    /*
    **  Executa Update
    */
    buffer-copy RowObject except r-rowid cod-estabel nr-proc-imp cod-itiner sequencia de-codigo to {&TABLE-NAME}.
end procedure.

procedure validateCreate:
    /*
    **  Valida Update
    */
    def input parameter table for RowObject.
    def output parameter table for tt-bo-erro.    
    def output parameter r-chave as rowid no-undo.
 
    run InitializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    
    find first rowObject no-error.    
    
    if rowObject.cod-estabel = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-estabel 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.    
    end.
    else
        if not can-find(estabelec where estabelec.cod-estabel = rowObject.cod-estabel) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgadm estabelec 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.        
        end.
        
    if rowObject.nr-proc-imp = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} nr-proc-imp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.    
    end.
    else 
        if not can-find(processo-imp where processo-imp.nr-proc-imp = rowObject.nr-proc-imp) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex processo-imp 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.        
        end.
        
    if rowObject.cod-itiner = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-itiner 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.    
    end.
        if not can-find(itinerario where itinerario.cod-itiner = rowObject.cod-itiner) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex itinerario 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.        
        end.        
        
    if not can-find(historico-proc-imp where historico-proc-imp.cod-estabel = rowObject.cod-estabel and
                                             historico-proc-imp.nr-proc-imp = rowObject.nr-proc-imp and
                                             historico-proc-imp.cod-itiner  = rowObject.cod-itiner and
                                             historico-proc-imp.sequencia   = rowObject.sequencia) then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-table.i mgcex historico-proc-imp 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 2
               tt-bo-erro.mensagem     = return-value.                                             
    end.                                             
        
    if rowObject.de-codigo = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} de-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.    
    end.
    else
        if not can-find(decl-padrao where decl-padrao.de-codigo = rowObject.de-codigo) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex decl-padrao 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.        
        end.        
        
    if can-find(first {&TABLE-NAME} where {&TABLE-NAME}.cod-estabel = rowObject.cod-estabel and
                                          {&TABLE-NAME}.nr-proc-imp = rowObject.nr-proc-imp and
                                          {&TABLE-NAME}.cod-itiner  = rowObject.cod-itiner  and
                                          {&TABLE-NAME}.de-codigo   = rowObject.de-codigo) then do:
       assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-table.i mgcex {&TABLE-NAME} 1}
       run utp/ut-msgs.p (input "msg",
                          input 8,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 8
              tt-bo-erro.mensagem     = return-value.                                          
    end.

    run validateFields.

    find first tt-bo-erro
        no-lock no-error.
    if not avail tt-bo-erro then do:
        run executeCreate.
        assign r-chave = to-rowid(return-value).            
    end.    
end procedure.
 
procedure validateFields:

    find first rowObject no-error.
 
end procedure.

procedure getCharField:
    define input parameter c-field as char.
    define output parameter c-value as char.
	
    case c-field:
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "nr-proc-imp" then c-value = RowObject.nr-proc-imp.
        when "e-mail-despachante" then c-value = RowObject.e-mail-despachante.
        when "e-mail-emitente" then c-value = RowObject.e-mail-emitente.
        when "e-mail-agente" then c-value = RowObject.e-mail-agente.
        when "e-mail-repres" then c-value = RowObject.e-mail-repres.
        when "e-mail-fabricante" then c-value = RowObject.e-mail-fabricante.	       
        when "e-mail-outros" then c-value = RowObject.e-mail-outros.	       
        when "texto" then c-value = RowObject.texto.	       
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        otherwise return error.
    end case.
end procedure.

procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "cod-itiner" then c-value = RowObject.cod-itiner.
        when "sequencia" then c-value  = RowObject.sequencia.
        when "de-codigo" then c-value  = RowObject.de-codigo.
        when "int-1" then c-value      = RowObject.int-1.
        when "int-2" then c-value      = RowObject.int-2.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.        
        otherwise return error.
    end case.
end procedure.

procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "decl-emitida" then c-value = RowObject.decl-emitida.
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.        
        otherwise return error.
    end case.
end procedure.


procedure retornaTexto:
/*
** Procedure criada para retornar o texto da declara‡Æo.
*/

def input  parameter c-nr-proc-imp     like processo-imp.nr-proc-imp.
def input  parameter c-cod-estabel     like processo-imp.cod-estabel.
def input  parameter i-cod-emitente    like emitente.cod-emitente.
def input  parameter c-cod-idioma      as char format "x(12)".
def input  parameter i-de-codigo       like decl-cliente.de-codigo. 
def input  parameter c-idiom-usuar     as char format "x(12)".
def output parameter c-e-mail-ag       as char format "x(40)".
def output parameter c-e-mail-desp     as char format "x(40)".
def output parameter c-e-mail-emit     as char format "x(40)".
def output parameter c-e-mail-fab      as char format "x(40)".
def output parameter c-e-mail-rep      as char format "x(40)".  
def output parameter c-texto           as char format "x(2000)".

assign c-proc            = c-nr-proc-imp 
       c-est             = c-cod-estabel
       i-emit            = i-cod-emitente
       c-idiom           = c-cod-idioma
       i-decl            = i-de-codigo
       c-cod-idiom-usuar = c-idiom-usuar.

    find processo-imp where
         processo-imp.cod-estabel = c-est and
         processo-imp.nr-proc-imp = c-proc
         no-lock no-error.
    if   avail processo-imp then do:
         find  emitente where 
               emitente.cod-emitente = processo-imp.cod-exportador 
               no-lock no-error.
         &if defined(bf-mat-comex) &then                   
         &else
             if  avail emitente then 
                 assign c-e-mail-emit = emitente.e-mail.
             find emitente where 
                 emitente.cod-emitente = processo-imp.cod-despachante
                 no-lock no-error.
             if  avail emitente then
                 assign c-e-mail-desp =  emitente.e-mail.
             find emitente where
                 emitente.cod-emitente = processo-imp.cod-fabricante no-lock no-error.
             if  avail emitente then
                 assign c-e-mail-fab = emitente.e-mail.
             find emitente where
                 emitente.cod-emitente = processo-imp.cod-agente no-lock no-error.
             if    avail emitente then 
                   assign c-e-mail-ag = emitente.e-mail.
             find emitente-cex where 
                  emitente-cex.cod-emitente = processo-imp.cod-exportador
                  no-lock no-error.
         &endif
         if  avail emitente-cex then do:
             create tt-idioma.
             assign tt-idioma.cod-idioma = emitente-cex.cod-idioma.
             &if defined(bf-mat-comex) &then                   
             &else              
                 find repres where
                     repres.cod-rep = emitente-cex.cod-repres no-lock no-error.
                 if  avail repres then 
                     assign c-e-mail-rep = repres.e-mail.     
             &endif
         end.            
         find tt-idioma where
              tt-idioma.cod-idioma = c-cod-idiom-usuar
              no-error.
         if   not avail tt-idioma then do:  
              create tt-idioma.
              assign tt-idioma.cod-idioma = c-cod-idiom-usuar.
         end.
         find tt-idioma where
              tt-idioma.cod-idioma = processo-imp.cod-idioma
              no-error.
         if   not avail tt-idioma then do:          
              create tt-idioma.
              assign tt-idioma.cod-idioma = processo-imp.cod-idioma.
         end.     
         
         for   each emitente-cex no-lock:
               if   emitente-cex.cod-emitente  = processo-imp.cod-despachante then do:
                    find   tt-idioma where
                           tt-idioma.cod-idioma = emitente-cex.cod-idioma
                           no-error.
                    if     not avail tt-idioma then do:          
                           create tt-idioma.
                           assign tt-idioma.cod-idioma = emitente-cex.cod-idioma.
                    end.
               end.
               else if   emitente-cex.cod-emitente  = processo-imp.cod-fabricante then do:
                         find   tt-idioma where
                                tt-idioma.cod-idioma = emitente-cex.cod-idioma
                                no-error.
                         if     not avail tt-idioma then do:          
                                create tt-idioma.
                                assign tt-idioma.cod-idioma = emitente-cex.cod-idioma.
                         end.
                    end.
                    else if   emitente-cex.cod-emitente  = processo-imp.cod-agente then do:
                              find   tt-idioma where
                                     tt-idioma.cod-idioma = emitente-cex.cod-idioma
                                     no-error.
                              if     not avail tt-idioma then do:          
                                     create tt-idioma.
                                     assign tt-idioma.cod-idioma = emitente-cex.cod-idioma.
                              end.
                         end.
                               
         end.
         
         for each tt-idioma:
             find decl-cliente where 
                  decl-cliente.cod-emitente   = processo-imp.cod-exportador and
                  decl-cliente.de-codigo      = i-decl                    and
                  decl-cliente.cod-idioma     = tt-idioma.cod-idioma         
                  no-lock no-error.
             if  avail decl-cliente then do:
                 assign i-pos = length(decl-cliente.texto).
                 if   c-texto <> " " then 
                      assign c-texto = c-texto + chr(10) + chr(10) + trim(decl-cliente.texto).                
                 else assign c-texto = trim(decl-cliente.texto).                                                                            
             end.
             else do:
                  find decl-cliente where
                       decl-cliente.cod-emitente = 0      and
                       decl-cliente.de-codigo    = i-decl and
                       decl-cliente.cod-idioma   = tt-idioma.cod-idioma
                       no-lock no-error.
                  if   avail decl-cliente then do:
                       assign i-pos = length(decl-cliente.texto).
                       if   c-texto <> " " then 
                            assign c-texto = c-texto + chr(10) + chr(10) + trim(decl-cliente.texto).                
                      else  assign c-texto = trim(decl-cliente.texto).
                  end.         
             end. 
         end.
    end.      
end procedure.

procedure validaDeclaracao:
/*
** Procedure para tela de declara‡Æo.
*/

def input  parameter c_est         like decl-hist-proc-imp.cod-estabel.
def input  parameter c_proc        like decl-hist-proc-imp.nr-proc-imp.
def input  parameter i_iti         like decl-hist-proc-imp.cod-itiner.
def input  parameter i_decl        like decl-hist-proc-imp.de-codigo.
def output parameter table for tt-bo-erro.

assign c-est         = c_est
       c-proc        = c_proc
       i-iti         = i_iti
       i-decl        = i_decl.

for each tt-bo-erro:
    delete tt-bo-erro.
end.       
       
find decl-hist-proc-imp where 
     decl-hist-proc-imp.cod-estabel = c-est  and
     decl-hist-proc-imp.nr-proc-imp = c-proc and
     decl-hist-proc-imp.cod-itiner  = i-iti  and
     decl-hist-proc-imp.de-codigo   = i-decl
     no-lock no-error.
if   avail decl-hist-proc-imp then do:
     assign i-seq-erro = i-seq-erro + 1.
     {utp/ut-table.i mgcex decl-hist-proc-imp 1}
     run utp/ut-msgs.p (input "msg",
                        input 8,
                        input return-value).
     create tt-bo-erro.
     assign tt-bo-erro.i-sequen     = i-seq-erro
            tt-bo-erro.cd-erro      = 8
            tt-bo-erro.mensagem     = return-value.
end.


end procedure.

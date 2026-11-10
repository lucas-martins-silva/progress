/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX280 2.00.00.014 } /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX280 MUT}
&ENDIF

/*******************************************************************************
**
**  bocx280.P
**
**  decl-hist-embarq-imp - Declara‡Æo Comunica‡Æo embarque Importa‡Æo
**
*******************************************************************************/

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY decl-hist-embarq-imp
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME decl-hist-embarq-imp

def var c-emb   like embarque-imp.embarque    no-undo.
def var c-est   like embarque-imp.cod-estabel no-undo.
def var i-emit  like emitente.cod-emitente    no-undo.
def var i-decl  like decl-hist-embarq-imp.de-codigo  no-undo.
def var c-cod-idiom-usuar as char format "x(12)" no-undo.
def var i-iti   like decl-hist-embarq-imp.cod-itiner no-undo.
def var c-idiom-usuar as char format "x(12)" no-undo.
def var i-pos   as integer no-undo.

{include/boini.i}
{cxbo/bocx280.i RowObject}

def temp-table tt-idioma NO-UNDO
      field cod-idioma as char format "x(12)"
      index idioma cod-idioma.

DEFINE TEMP-TABLE tt-campo-erro NO-UNDO
    FIELD campo       AS CHARACTER.

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

procedure setConstraint1:
end procedure.

procedure setConstraint2:
    /*
    ** procedure utilizada no browser de declar‡äes por pontos do embarque de importa‡Æo
    */
    def input parameter p-rowid as rowid no-undo.
    
    find historico-embarque where rowid(historico-embarque) = p-rowid no-lock no-error.

end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 THEN
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock where
                {&TABLE-NAME}.cod-estabel = historico-embarque.cod-estabel and
                {&TABLE-NAME}.embarque = historico-embarque.embarque and
                {&TABLE-NAME}.cod-itiner  = historico-embarque.cod-itiner and
                {&TABLE-NAME}.sequencia   = historico-embarque.sequencia.   
        when 3 THEN
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock where
                {&TABLE-NAME}.cod-estabel = historico-embarque.cod-estabel and
                {&TABLE-NAME}.embarque    = historico-embarque.embarque and
                {&TABLE-NAME}.cod-itiner  = historico-embarque.cod-itiner.   
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
    def input parameter c-embarque as char no-undo.
    def input parameter i-cod-itiner as integer no-undo.
    def input parameter i-sequencia as integer no-undo.
    def input parameter i-de-codigo as integer no-undo.
    def output parameter c-return as char no-undo.
        
    run startMethod("find":U).
 
    find {&TABLE-NAME} where {&TABLE-NAME}.cod-estabel = c-cod-estabel and
                             {&TABLE-NAME}.embarque = c-embarque and
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
    buffer-copy RowObject except r-rowid cod-estabel embarque cod-itiner to {&TABLE-NAME}.
end procedure.

procedure validateCreate:
    /*
    **  Valida Create
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
        
    if rowObject.embarque = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} embarque 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.    
    end.
    else 
        if not can-find(embarque-imp where embarque-imp.embarque = rowObject.embarque) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex embarque-imp 1}
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
                                          {&TABLE-NAME}.embarque = rowObject.embarque and
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
	EMPTY TEMP-TABLE tt-campo-erro.

    /* Verifica se o ponto de controle da decl. pertence ao acompanhamento */
    IF NOT CAN-FIND(FIRST historico-embarque 
                    WHERE historico-embarque.cod-estabel = RowObject.cod-estabel
                      AND historico-embarque.embarque    = RowObject.embarque
                      AND historico-embarque.cod-itiner  = RowObject.cod-itiner
                      AND historico-embarque.sequencia   = RowObject.sequencia) THEN DO: 
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece pre-processador em chamada de includes */
        {utp/ut-field.i mgcex historico-embarque cod-pto-contr 1}
        /******************************************/
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg":u,
                           input 54738,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 54738
               tt-bo-erro.mensagem     = return-value.
        create tt-campo-erro.
        assign tt-campo-erro.campo = "cod-pto-contr":U.
    END.

    if CAN-FIND(FIRST decl-hist-embarq-imp WHERE decl-hist-embarq-imp.de-codigo = rowObject.de-codigo) AND (rowObject.descricao = ? or trim(rowObject.descricao) = "":U) then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex historico-embarque descricao 1}
        /******************************************/
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg":u,
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
        create tt-campo-erro.
        assign tt-campo-erro.campo = "descricao":U.
    end.
 
end procedure.

procedure getCharField:
    define input parameter c-field as char.
    define output parameter c-value as char.
	
    case c-field:
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "embarque" then c-value = RowObject.embarque.
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
        when "descricao" then c-value = RowObject.descricao.
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

def input  parameter c-embarque        like embarque-imp.embarque.
def input  parameter c-cod-estabel     like embarque-imp.cod-estabel.
def input  parameter i-cod-emitente    like emitente.cod-emitente.
def input  parameter i-de-codigo       like decl-cliente.de-codigo. 
def input  parameter c-idiom-usuar     as char format "x(12)".
def output parameter c-e-mail-ag       as char format "x(40)".
def output parameter c-e-mail-desp     as char format "x(40)".
def output parameter c-e-mail-emit     as char format "x(40)".
def output parameter c-e-mail-fab      as char format "x(40)".
def output parameter c-e-mail-rep      as char format "x(40)".  
def output parameter c-texto           as char format "x(2000)".

assign c-emb             = c-embarque 
       c-est             = c-cod-estabel
       i-emit            = i-cod-emitente
       i-decl            = i-de-codigo
       c-cod-idiom-usuar = c-idiom-usuar.

    find first embarque-imp 
         where embarque-imp.cod-estabel = c-est 
           and embarque-imp.embarque    = c-emb no-lock no-error.
    if   avail embarque-imp then do:
         find first ordens-embarque 
              where ordens-embarque.cod-estabel = embarque-imp.cod-estabel 
                and ordens-embarque.embarque    = embarque-imp.embarque no-lock no-error.
         if   avail ordens-embarque then do:
              find processo-imp 
                  where processo-imp.cod-estabel = ordens-embarque.cod-estabel 
                    and processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp no-lock no-error.
              if   avail processo-imp then do:     
                   &if defined(bf-mat-comex) &then                                                   
                       find first cont-emit 
                            where cont-emit.cod-emitente = i-emit no-lock no-error.
                       assign c-e-mail-emit = if avail cont-emit then cont-emit.e-mail else "". 
                   &else
                       find first emitente 
                            where emitente.cod-emitente = i-emit no-lock no-error.
                       assign c-e-mail-emit = if avail emitente then emitente.e-mail else "".
                   &endif
                    
                   &if defined(bf-mat-comex) &then                                                   
                       find first cont-emit 
                            where cont-emit.cod-emitente = embarque-imp.cod-despachante no-lock no-error.
                       assign c-e-mail-desp = if avail cont-emit then cont-emit.e-mail else "". 
                   &else                   
                       find first emitente 
                            where emitente.cod-emitente = embarque-imp.cod-despachante no-lock no-error.
                       assign c-e-mail-desp =  if avail emitente then emitente.e-mail else "".
                   &endif    
                    
                   &if defined(bf-mat-comex) &then                                                   
                       find first cont-emit 
                            where cont-emit.cod-emitente = processo-imp.cod-fabricante no-lock no-error.
                       assign c-e-mail-fab = if avail cont-emit then cont-emit.e-mail else "". 
                   &else                                    
                       find first emitente 
                            where emitente.cod-emitente = processo-imp.cod-fabricante no-lock no-error.
                       assign c-e-mail-fab = if avail emitente then emitente.e-mail else "".
                   &endif
                    
                   &if defined(bf-mat-comex) &then 
                        find first cont-emit where
                                   cont-emit.cod-emitente = processo-imp.cod-agente no-lock no-error.
                        assign c-e-mail-ag = if avail cont-emit then cont-emit.e-mail else "". 
                   &else                                      
                        find first emitente 
                             where emitente.cod-emitente = processo-imp.cod-agente no-lock no-error.
                         assign c-e-mail-ag = if avail emitente then emitente.e-mail else "".
                   &endif
                     
                   find first emitente-cex 
                        where emitente-cex.cod-emitente = i-emit no-lock no-error.
                   if   avail emitente-cex then do:
                        create tt-idioma.
                        assign tt-idioma.cod-idioma = emitente-cex.cod-idioma.
                        find repres where
                             repres.cod-rep = emitente-cex.cod-repres no-lock no-error.
                        if   avail repres then 
                             &if defined(bf-mat-comex) &then                                                   
                             &else                   
                                assign c-e-mail-rep = repres.e-mail.     
                             &endif
                   end.            
                   find tt-idioma where
                        tt-idioma.cod-idioma = c-cod-idiom-usuar no-error.
                   if   not avail tt-idioma then do:  
                        create tt-idioma.
                        assign tt-idioma.cod-idioma = c-cod-idiom-usuar.
                   end.
                   find tt-idioma where
                        tt-idioma.cod-idioma = processo-imp.cod-idioma no-error.
                   if   not avail tt-idioma then do:          
                        create tt-idioma.
                        assign tt-idioma.cod-idioma = processo-imp.cod-idioma.
                   end.     
                 
                   for   each emitente-cex no-lock:
                         if   emitente-cex.cod-emitente  = embarque-imp.cod-despachante then do:
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
                            decl-cliente.cod-emitente   = i-emit                    and
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
                                 else assign c-texto = trim(decl-cliente.texto).
                            end.         
                       end. 
                   end.
              end.
         end.
    end.      
end procedure.

procedure validaDeclaracao:
/*
** Procedure para tela de declara‡Æo.
*/

def input  parameter c_est         like decl-hist-embarq-imp.cod-estabel.
def input  parameter c_emb         like decl-hist-embarq-imp.embarque.
def input  parameter i_iti         like decl-hist-embarq-imp.cod-itiner.
def input  parameter i_decl        like decl-hist-embarq-imp.de-codigo.
def output parameter table for tt-bo-erro.

assign c-est         = c_est
       c-emb         = c_emb
       i-iti         = i_iti
       i-decl        = i_decl.
       
for each tt-bo-erro:
    delete tt-bo-erro.
end.       
       
find decl-hist-embarq-imp where 
     decl-hist-embarq-imp.cod-estabel = c-est  and
     decl-hist-embarq-imp.embarque    = c-emb and
     decl-hist-embarq-imp.cod-itiner  = i-iti  and
     decl-hist-embarq-imp.de-codigo   = i-decl
     no-lock no-error.
if   avail decl-hist-embarq-imp then do:
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

PROCEDURE pi-valida-decl-acomp:
    DEFINE INPUT PARAM TABLE FOR RowObject.
    DEFINE OUTPUT PARAM TABLE FOR tt-bo-erro.

    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.

    FIND FIRST RowObject NO-ERROR.
    IF AVAIL RowObject THEN DO:
        IF CAN-FIND(FIRST {&TABLE-NAME} 
                    WHERE {&TABLE-NAME}.cod-estabel = rowObject.cod-estabel 
                      AND {&TABLE-NAME}.embarque = rowObject.embarque 
                      AND {&TABLE-NAME}.cod-itiner  = rowObject.cod-itiner  
                      AND {&TABLE-NAME}.de-codigo   = rowObject.de-codigo
                      AND ROWID({&TABLE-NAME}) <> rowObject.r-rowid) THEN DO:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex {&TABLE-NAME} 1}
            RUN utp/ut-msgs.p (INPUT "msg",
                               INPUT 8,
                               INPUT RETURN-VALUE).

            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = RETURN-VALUE.
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE getFieldErrors:
/*------------------------------------------------------------------------------------------
Purpose: Retornar uma temp-table com informa‡äes dos erros ocorridos durante altera‡Æo/cria‡Æo.
Parameters:  (output) (temp-table) tt-campo-erro: Nome do campo em que ocorreu o erro.
Notes: 
------------------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER TABLE FOR tt-campo-erro.

   RETURN "OK":U.
END PROCEDURE.

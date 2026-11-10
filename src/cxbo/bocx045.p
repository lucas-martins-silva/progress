/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX045 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX045 MUT}
&ENDIF

/*
**  BOCX045.P
**
**  trad-cond-pagto - Cadastro de Tradu‡äes de Condi‡äes de Pagamento
**
**  Ultima altera‡Æo : 05/05/99 - GeraBO - Brv9587
*/

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

def var c-cod-cond-pag as integer no-undo.
def var c-idioma as char no-undo.
def var c-cod-cond-pagi as integer no-undo.
def var c-idiomai as char no-undo.
def var c-cod-cond-pagf as integer no-undo.
def var c-idiomaf as char no-undo.
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY trad-cond-pagto
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME trad-cond-pagto

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
   &GLOBAL-DEFINE v9indrep  INDEXED-REPOSITION
&endif 
 
{include/boini.i}
 
{cxbo/bocx045.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
procedure setConstraint1:


end procedure.

procedure setConstraint2:
def input parameter p-cod-cond-pag as char no-undo.
def input parameter p-idioma as char no-undo.

assign c-cod-cond-pag = integer(p-cod-cond-pag)
       c-idioma = p-idioma.
end procedure.

procedure setConstraint3:
def input parameter p-cod-cond-pagi as char no-undo.
def input parameter p-cod-cond-pagf as char no-undo.

assign c-cod-cond-pagi = integer(p-cod-cond-pagi)
       c-cod-cond-pagf = integer(p-cod-cond-pagf).
end procedure.

procedure setConstraint4:
def input parameter p-idiomai as char no-undo.
def input parameter p-idiomaf as char no-undo.

assign c-idiomai = p-idiomai
       c-idiomaf = p-idiomaf.
end procedure.

def var i-cod-cond-pag-ini as integer no-undo.
def var i-cod-cond-pag-fim as integer no-undo.
def var c-cod-idioma-ini   as char no-undo.
def var c-cod-idioma-fim   as char no-undo.

procedure setConstraint5:
def input parameter p-cod-cond-pag-ini as integer no-undo.
def input parameter p-cod-cond-pag-fim as integer no-undo.
def input parameter p-cod-idioma-ini   as char no-undo.
def input parameter p-cod-idioma-fim   as char no-undo.

assign i-cod-cond-pag-ini = p-cod-cond-pag-ini
       i-cod-cond-pag-fim = p-cod-cond-pag-fim
       c-cod-idioma-ini   = p-cod-idioma-ini
       c-cod-idioma-fim   = p-cod-idioma-fim.

end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock use-index pk-tr-cond-pagto
                where {&TABLE-NAME}.cod-cond-pag >= c-cod-cond-pag 
                  and {&TABLE-NAME}.cod-idioma   >= c-idioma {&v9indrep}.
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME}
                where {&TABLE-NAME}.cod-cond-pag >= c-cod-cond-pagi
                  and {&TABLE-NAME}.cod-cond-pag <= c-cod-cond-pagf
                    no-lock by {&TABLE-NAME}.cod-cond-pag {&v9indrep}.
        when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME}
                where {&TABLE-NAME}.cod-idioma   >= c-idiomai
                  and {&TABLE-NAME}.cod-idioma   <= c-idiomaf
                    no-lock by {&TABLE-NAME}.cod-idioma {&v9indrep}.
        when 5 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} use-index pk-tr-cond-pagto
                where {&TABLE-NAME}.cod-cond-pag >= i-cod-cond-pag-ini
                  and {&TABLE-NAME}.cod-cond-pag <= i-cod-cond-pag-fim
                  and {&TABLE-NAME}.cod-idioma   >= c-cod-idioma-ini
                  and {&TABLE-NAME}.cod-idioma   <= c-cod-idioma-fim
                    no-lock by {&TABLE-NAME}.cod-cond-pag {&v9indrep}.
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
/*{include/boexeupt.i}*/
{include/boexedel.i}
{include/bovalupt.i}
{include/bovaldel.i}
 
procedure executeUpdate:
    /*
    **  Executa Update
    */
    buffer-copy RowObject except r-rowid cod-idioma cod-cond-pag to {&TABLE-NAME}.
end procedure.
 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.

procedure findCh_tr_cond_pagto:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    
    def input parameter c-cod-idioma as char no-undo.
    def input parameter i-cod-cond-pag as inte no-undo.
    def output parameter table for RowObject.
 
    find trad-cond-pagto where
        trad-cond-pagto.cod-idioma = c-cod-idioma
        and trad-cond-pagto.cod-cond-pag = i-cod-cond-pag
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
    end.
    else do:
       run setCurrent.
    end.
    run endMethod("find").
end procedure.
 
procedure findPk_tr_cond_pagto:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter i-cod-cond-pag as inte no-undo.
    def input parameter c-cod-idioma as char no-undo.
    def output parameter c-return as char no-undo.
 
    find trad-cond-pagto where
        trad-cond-pagto.cod-cond-pag = i-cod-cond-pag
        and trad-cond-pagto.cod-idioma = c-cod-idioma
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
    run endMethod ("find").
end procedure.
 
procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").
    if rowObject.cod-cond-pag = ? then do:
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-cond-pag 1}
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-idioma = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tr-descricao = ? or rowObject.tr-descricao = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    run endMethod ("validateFields").
 
end procedure.
 
procedure validateCreate:
    /*
    **  Valida cria‡Æo da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
 
    run initializeValidate.
    run startMethod ("validateCreate").
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    ASSIGN i-seq-erro = 0.
 
    find first rowObject
        no-lock no-error.
    if rowObject.cod-cond-pag = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-cond-pag 1}
        create tt-bo-erro.
        ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else
        IF RowObject.cod-cond-pag <> 0 AND
           not can-find(cond-pagto where cond-pagto.cod-cond-pag = rowObject.cod-cond-pag) then do:
                 assign i-seq-erro = i-seq-erro + 1.
                 {utp/ut-table.i mgadm cond-pagto 1}
                 create tt-bo-erro.
                 ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
                 run utp/ut-msgs.p (input "msg",
                                    input 2,
                                    input return-value).
                 assign tt-bo-erro.i-sequen = i-seq-erro
                        tt-bo-erro.cd-erro  = 2
                        tt-bo-erro.mensagem = return-value.
             end.

    if rowObject.cod-idioma = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-idioma 1}
        create tt-bo-erro.
        ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
               
    end.
    else do:
        &if defined(bf-mat-comex) &then                                    
            if not can-find(idioma where idioma.id-codigo = rowObject.cod-idioma) then do:
                assign i-seq-erro = i-seq-erro + 1.
                run utp/ut-msgs.p (input "msg",
                                   input 4774,
                                   input " ").
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 4774
                       tt-bo-erro.mensagem = return-value.
            end.
        &else
            if not can-find(idioma where idioma.cod_idioma = rowObject.cod-idioma) then do:
                assign i-seq-erro = i-seq-erro + 1.
                run utp/ut-msgs.p (input "msg",
                                   input 4774,
                                   input " ").
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 4774
                       tt-bo-erro.mensagem = return-value.
            end.        
        &endif
    end.         
 
    if rowObject.tr-descricao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} tr-descricao 1}
        create tt-bo-erro.
        ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find trad-cond-pagto where
            trad-cond-pagto.cod-cond-pag = rowObject.cod-cond-pag
        and trad-cond-pagto.cod-idioma = rowObject.cod-idioma
            no-lock no-error.
        if avail trad-cond-pagto then do:
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
    end.
 
    run validateFields.
    
    find first tt-bo-erro
        no-lock no-error.
 
    if not avail tt-bo-erro then do:
       run executeCreate.
       assign r-chave = to-rowid(return-value).
    end.
 
    run endMethod ("validateCreate").
end procedure.

procedure validateCodigo:

    def input parameter c-cod-cond-pag as char no-undo.
    def output parameter table for tt-bo-erro.
    def var i as integer no-undo.
    
    run startMethod("validateCodigo").
    assign i = int(c-cod-cond-pag) no-error.
    if  error-status:error then do:
       assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-field.i mgcex trad-cond-pagto cod-cond-pag 1}
       run utp/ut-msgs.p (input "msg",
                          input 16963,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 16963
              tt-bo-erro.mensagem     = return-value.
    end.
    run startMethod("validateCodigo").           
            
end procedure.

 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "cod-idioma" then c-value = RowObject.cod-idioma.
        when "tr-descricao" then c-value = RowObject.tr-descricao.
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
        when "cod-cond-pag" then c-value = RowObject.cod-cond-pag.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
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
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        otherwise return error.
    end case.
end procedure.
 

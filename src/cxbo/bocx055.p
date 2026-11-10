/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX055 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX055 MUT}
&ENDIF

/*
**  BOCX055.P
**
**  trad-gerais - Cadastro de Tradu‡äes Gerais
**
**  Ultima altera‡Æo : 05/05/99 - GeraBO - Brv9587
*/

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

def var c-idioma   as char no-undo. 
def var c-texto-ini as char no-undo.
def var c-texto-fim as char no-undo.
def var c-idioma-ini as char no-undo.
def var c-idioma-fim as char no-undo.

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY trad-gerais
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME trad-gerais
 
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
   &GLOBAL-DEFINE v9indrep  INDEXED-REPOSITION
&endif 
 
{include/boini.i}
 
{cxbo/bocx055.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
procedure setConstraint1:


end procedure.

procedure setConstraint2:
def input parameter p-texto  as char no-undo.
def input parameter p-idioma as char no-undo.
 
assign c-idioma    = p-idioma
       c-texto-ini = p-texto.
end procedure. 

procedure setConstraint3:
def input parameter p-texto-ini as char no-undo.
def input parameter p-texto-fim as char no-undo.
 
assign c-texto-fim = p-texto-fim
       c-texto-ini = p-texto-ini.
end procedure. 

procedure setConstraint4:
def input parameter p-idioma-ini as char no-undo.
def input parameter p-idioma-fim as char no-undo.
 
assign c-idioma-fim = p-idioma-fim
       c-idioma-ini = p-idioma-ini.
end procedure.

procedure setConstraint5:
def input parameter p-texto-ini  as char no-undo.
def input parameter p-texto-fim  as char no-undo.
def input parameter p-idioma-ini as char no-undo.
def input parameter p-idioma-fim as char no-undo.
 
assign c-idioma-ini = p-idioma-ini
       c-idioma-fim = p-idioma-fim
       c-texto-ini  = p-texto-ini
       c-texto-fim  = p-texto-fim.
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                                              {&v9indrep}.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where trad-gerais.texto >= c-texto-ini and 
                                                                  trad-gerais.cod-idioma >= c-idioma  
                                                                  no-lock use-index pk-tr-texto
                                                                  {&v9indrep}.
        when 3 then
            open query {&QUERY-NAME} 
            for each {&TABLE-NAME} where trad-gerais.texto >= c-texto-ini and 
                                         trad-gerais.texto <= c-texto-fim no-lock by trad-gerais.texto
                                         {&v9indrep}.
        when 4 then
            open query {&QUERY-NAME} 
            for each {&TABLE-NAME} where trad-gerais.cod-idioma >= c-idioma-ini and 
                                         trad-gerais.cod-idioma <= c-idioma-fim no-lock by trad-gerais.cod-idioma
                                         {&v9indrep}.
        when 5 then
            open query {&QUERY-NAME} 
            for each {&TABLE-NAME} where trad-gerais.texto >= c-texto-ini and
                                         trad-gerais.texto <= c-texto-fim and 
                                         trad-gerais.cod-idioma >= c-idioma-ini and
                                         trad-gerais.cod-idioma <= c-idioma-fim no-lock 
                                         use-index pk-tr-texto
                                         {&v9indrep}.                                         
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
    buffer-copy RowObject except cod-idioma texto r-rowid to {&TABLE-NAME}.

end procedure.

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.

procedure findCh_cod_idioma:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").                   
    def input parameter c-cod-idioma as char no-undo.
    def output parameter table for RowObject.
 
    find first trad-gerais where
        trad-gerais.cod-idioma = c-cod-idioma
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
    run endMethod ("find").                   
end procedure.
 
procedure findPk_tr_texto:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-texto as char no-undo.
    def input parameter c-cod-idioma as char no-undo.
    def output parameter c-return as char no-undo.
 
    find first trad-gerais where
        trad-gerais.texto = c-texto
        and trad-gerais.cod-idioma = c-cod-idioma
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
    if rowObject.cod-idioma = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-field.i mgcex {&TABLE-NAME} cod-idioma 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.texto-trad = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} texto-trad 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
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
 
    find first rowObject
        no-lock no-error.
    if rowObject.cod-idioma = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-idioma 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
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
                                 input return-value).
              create tt-bo-erro.
              assign tt-bo-erro.i-sequen  = i-seq-erro
                     tt-bo-erro.cd-erro   = 4774
                     tt-bo-erro.mensagem  = return-value.
           end.           
       &else
           if not can-find(idioma where idioma.cod_idioma = rowObject.cod-idioma) then do:
              assign i-seq-erro = i-seq-erro + 1.
              run utp/ut-msgs.p (input "msg",
                                 input 4774,
                                 input return-value).
              create tt-bo-erro.
              assign tt-bo-erro.i-sequen  = i-seq-erro
                     tt-bo-erro.cd-erro   = 4774
                     tt-bo-erro.mensagem  = return-value.
           end.                  
       &endif
    end.

    if rowObject.texto = ? or rowObject.texto = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-field.i mgcex {&TABLE-NAME} texto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find trad-gerais where
            trad-gerais.texto = rowObject.texto
        and trad-gerais.cod-idioma = rowObject.cod-idioma
            no-lock no-error.
        if avail trad-gerais then do:
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
    
    /** Verifica duplicidade dos registros **/
 
    if can-find(first trad-gerais where
                trad-gerais.texto = rowObject.texto
            and trad-gerais.cod-idioma = rowObject.cod-idioma) then do:
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

    find first tt-bo-erro
        no-lock no-error.
 
    if not avail tt-bo-erro then do:
       run executeCreate.
       assign r-chave = to-rowid(return-value).
    end.
 
    run endMethod ("validateCreate").
end procedure.
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "cod-idioma" then c-value = RowObject.cod-idioma.
        when "texto" then c-value = RowObject.texto.
        when "texto-trad" then c-value = RowObject.texto-trad.
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
 

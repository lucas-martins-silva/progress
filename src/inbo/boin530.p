/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN530 2.00.00.019}  /*** "010019" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin530 MUT}
&ENDIF

/*
**  BOIN530.P
**
**  rep-parada-ctrab - Reporte Parada in
**
**  Ultima altera‡Æo : 22/06/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY rep-parada-ctrab
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME rep-parada-ctrab
 
 
 
{include/boini.i}
{cdp/cdcfgman.i}
 
{inbo/boin530.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

/******* Define variaveis *********/

/*def var r-rep-parada-ctrab as rowid   no-undo.*/
 
procedure setConstraint1:
 
end procedure.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
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
{include/boexeupt.i}

{include/bovalupt.i}
{include/bovaldel.i}
{cdp/cd0666.i}
 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.
 
procedure findId:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-cod-ctrab as char no-undo.
    def input parameter de-val-refer-inic-parada as deci no-undo.
    def output parameter c-return as char no-undo.
 
    find rep-parada-ctrab where
        rep-parada-ctrab.cod-ctrab = c-cod-ctrab
        and rep-parada-ctrab.val-refer-inic-parada = de-val-refer-inic-parada
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i movind {&TABLE-NAME} 1}
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
    if rowObject.cod-ctrab = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-ctrab 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-model-turno = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-model-turno 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-parada = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-parada 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-usuar-reporte = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-usuar-reporte 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dat-fim-parada = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} dat-fim-parada 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dat-inic-parada = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} dat-inic-parada 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dat-reporte = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} dat-reporte 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.hra-reporte = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} hra-reporte 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.num-turno = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} num-turno 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-fim = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-fim 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-inic = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-inic 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-tempo-ext = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-tempo-ext 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-tempo-parada = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-tempo-parada 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.val-refer-fim-parada = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} val-refer-fim-parada 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.val-refer-inic-parada = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} val-refer-inic-parada 1}
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
 
    run validateFields.
 
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find rep-parada-ctrab where
            rep-parada-ctrab.cod-ctrab = rowObject.cod-ctrab
        and rep-parada-ctrab.val-refer-inic-parada = rowObject.val-refer-inic-parada
            no-lock no-error.
        if avail rep-parada-ctrab then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i movind {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
        end.
        else do:
             run executeCreate.
             assign r-chave = to-rowid(return-value).
        end.
    end.
 
    run endMethod ("validateCreate").
end procedure.
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "cod-ctrab" then c-value = RowObject.cod-ctrab.
        when "cod-equipe" then c-value = RowObject.cod-equipe.
        when "cod-model-turno" then c-value = RowObject.cod-model-turno.
        when "cod-parada" then c-value = RowObject.cod-parada.
        when "cod-usuar-reporte" then c-value = RowObject.cod-usuar-reporte.
        when "hra-reporte" then c-value = RowObject.hra-reporte.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "qtd-segs-fim" then c-value = RowObject.qtd-segs-fim.
        when "qtd-segs-inic" then c-value = RowObject.qtd-segs-inic.
        when "qtd-tempo-ext" then c-value = RowObject.qtd-tempo-ext.
        when "qtd-tempo-parada" then c-value = RowObject.qtd-tempo-parada.
        when "val-refer-fim-parada" then c-value = RowObject.val-refer-fim-parada.
        when "val-refer-inic-parada" then c-value = RowObject.val-refer-inic-parada.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "num-id-parada-geral" then c-value = RowObject.num-id-parada-geral.
        when "num-om-progda" then c-value = RowObject.num-om-progda.
        when "num-turno" then c-value = RowObject.num-turno.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "dat-fim-parada" then c-value = RowObject.dat-fim-parada.
        when "dat-inic-parada" then c-value = RowObject.dat-inic-parada.
        when "dat-reporte" then c-value = RowObject.dat-reporte.
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


/******************* PROCEDURES DE NEGOCIO - EX TRIGGERS **********************/

{inbo/boin530.i1} /* Procedures Negocio rep-oper-ctrab ***/
{inbo/boin536.i5} /* AtualizarTempoRepOper */
{inbo/boin536.i6} /* pi-sfc-tempo-paradas-maq e pi-sfc-tempo-paradas-mod */
{sfc/sf9002.i}    /* Pi-converte-data-segs-valor */
{sfc/sf9000.i} /* pi-formatted-time-to-sec, pi-sec-to-formatted-time */

PROCEDURE verificarParadaCtrab:
    
    def  input param p-cod-ctrab     as char no-undo.
    def  input param p-val-refer     like rep-parada-ctrab.val-refer-inic-parada no-undo.
    def output param p-existe-parada as log no-undo.

    find first rep-parada-ctrab
        where rep-parada-ctrab.cod-ctrab              = p-cod-ctrab
          and rep-parada-ctrab.val-refer-inic-parada <= p-val-refer
          and rep-parada-ctrab.val-refer-fim-parada  >  p-val-refer no-lock no-error.
    if  avail rep-parada-ctrab then
        assign p-existe-parada = yes.
    else
        assign p-existe-parada = no.

END PROCEDURE.

PROCEDURE retornarParadaCtrab:
    
    def  input param p-cod-ctrab     as char no-undo.
    def  input param p-val-refer     like rep-parada-ctrab.val-refer-inic-parada no-undo.
    def output param p-rw-rep-parada as rowid no-undo.

    find first rep-parada-ctrab
        where rep-parada-ctrab.cod-ctrab              = p-cod-ctrab
          and rep-parada-ctrab.val-refer-inic-parada <= p-val-refer
          and rep-parada-ctrab.val-refer-fim-parada  >  p-val-refer no-lock no-error.
          
    if  avail rep-parada-ctrab then
        assign p-rw-rep-parada = rowid(rep-parada-ctrab).
    else
        assign p-rw-rep-parada = ?.

END PROCEDURE.


&IF DEFINED(bf_man_205) &THEN
procedure getDsParadaTempoSetup:
    define input  param p-cod-ctrab         like rep-parada-ctrab.cod-ctrab             no-undo.
    define input  param p-cod-parada        like rep-parada-ctrab.cod-parada            no-undo.
    define input  param p-val-inic-parada   like rep-parada-ctrab.val-refer-inic-parada no-undo.
    define input  param p-val-fim-parada    like rep-parada-ctrab.val-refer-fim-parada  no-undo.
    define output param p-des-parada        like motiv-parada.des-parada                no-undo.
    define output param p-tempo-setup       like rep-parada-ctrab.qtd-tempo-parada      no-undo.

    find first rep-parada-ctrab
        where rep-parada-ctrab.cod-ctrab              = p-cod-ctrab
          and rep-parada-ctrab.cod-parada             = p-cod-parada
          and rep-parada-ctrab.val-refer-inic-parada >= p-val-inic-parada
          and rep-parada-ctrab.val-refer-fim-parada  <= p-val-fim-parada 
        no-lock no-error.
    if avail rep-parada-ctrab then do:
        find first motiv-parada
            where motiv-parada.cod-parada   = rep-parada-ctrab.cod-parada
              and motiv-parada.parada-setup = yes
            no-lock no-error.
        if avail motiv-parada then do:
            assign p-des-parada  = motiv-parada.des-parada
                   p-tempo-setup = rep-parada-ctrab.qtd-tempo-parada.
            return "OK":U.
        end.
        else do:
            return "NOK":U.
        end.
    end.
    else do:
        return "NOK":U.
    end.

end procedure.
&ENDIF

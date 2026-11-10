/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD028 2.00.00.012}  /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad028 MUT}
&ENDIF

/*
**  BOAD028.P
**
**  bordero-ap - Temporario de  Borderos e Cheques - AP
**
**  Ultima altera‡Æo : 31/03/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY bordero-ap
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME bordero-ap
 
{include/boini.i}
 
 
{adbo/boad028.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
DEFINE VAR c-selecao   as char no-undo.
&IF "{&mguni_version}" >= "2.07A" &THEN
DEFINE VAR i-ep-codigo LIKE empresa.ep-codigo no-undo.
&ELSE
DEFINE VAR i-ep-codigo as int no-undo.
&ENDIF


/****************varáveis usadas no open-query2*******************/
DEFINE VAR cod-portador     as integer no-undo.
DEFINE VAR cod-estabel-ini  as char no-undo.
DEFINE VAR cod-estabel-fim  as char no-undo.
DEFINE VAR cod-esp-ini      as char no-undo.
DEFINE VAR cod-esp-fim      as char no-undo.
DEFINE VAR nr-docto-ini     as char no-undo.
DEFINE VAR nr-docto-fim     as char no-undo.
DEFINE VAR dt-transacao-ini as date no-undo.
DEFINE VAR dt-transacao-fim as date no-undo.
DEFINE VAR dt-vencimen-ini  as date no-undo.
DEFINE VAR dt-vencimen-fim  as date no-undo.
DEFINE VAR nr-bordero-ini   as integer no-undo.
DEFINE VAR nr-bordero-fim   as integer no-undo.

/****************************************************************/

Procedure piEliminaBordero:
    def input  param p-ep-codigo   like bordero-ap.ep-codigo.
    def input  param p-cod-fornec  like bordero-ap.cod-fornec.
    def input  param p-cod-estabel like bordero-ap.cod-estabel.
    def input  param p-cod-esp     like bordero-ap.cod-esp.
    def input  param p-serie       like bordero-ap.serie.
    def input  param p-nr-docto    like bordero-ap.nr-docto.
    def input  param p-parcela     like bordero-ap.parcela.
    def output param p-eliminou    as   logical.

    find first bordero-ap
         where bordero-ap.ep-codigo   = p-ep-codigo
         and   bordero-ap.cod-fornec  = p-cod-fornec
         and   bordero-ap.cod-estabel = p-cod-estabel
         and   bordero-ap.cod-esp     = p-cod-esp
         and   bordero-ap.serie       = p-serie
         and   bordero-ap.nr-docto    = p-nr-docto
         and   bordero-ap.parcela     = p-parcela exclusive-lock no-error.
    if avail bordero-ap then do:
        delete bordero-ap.
        assign p-eliminou = yes.
    end.
    else
        assign p-eliminou = no.
            
    RETURN "OK":U. 
end procedure.

Procedure setConstraint2:
   /*** Carrega variáveis p/ o Open-query(2,3,4,5) ***/   
   def input parameter p-ep-codigo-usuar as char no-undo.
   def input parameter p-selecao as char no-undo.      
   assign c-selecao = p-selecao.     
   assign &IF "{&mguni_version}" >= "2.07A" &THEN
          i-ep-codigo = p-ep-codigo-usuar.
          &ELSE
          i-ep-codigo = int(p-ep-codigo-usuar).
          &ENDIF
   assign cod-estabel-ini    = entry(1, c-selecao)
          cod-estabel-fim       = entry(2, c-selecao)
          cod-esp-ini           = entry(3, c-selecao)
          cod-esp-fim           = entry(4, c-selecao)
          nr-docto-ini          = entry(5, c-selecao)
          nr-docto-fim          = entry(6, c-selecao) 
          dt-transacao-ini      = date(entry(7, c-selecao))
          dt-transacao-fim      = date(entry(8, c-selecao))
          dt-vencimen-ini       = date(entry(9, c-selecao))
          dt-vencimen-fim       = date(entry(10, c-selecao))
          nr-bordero-ini        = integer(entry(11, c-selecao))
          nr-bordero-fim        = integer(entry(12, c-selecao))
          cod-portador          = integer(entry(13, c-selecao)).                    
end procedure.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
        when 2 then
            if nr-bordero-ini = nr-bordero-fim then do:
                open query {&QUERY-NAME} for each {&TABLE-NAME}                                             
                           where bordero-ap.ep-codigo     = i-ep-codigo      and
                                 bordero-ap.portador      = cod-portador     and 
                                 bordero-ap.nr-bordero    = nr-bordero-ini   and
                                 bordero-ap.cod-estabel  >= cod-estabel-ini  and
                                 bordero-ap.cod-estabel  <= cod-estabel-fim  and
                                 bordero-ap.cod-esp      >= cod-esp-ini      and 
                                 bordero-ap.cod-esp      <= cod-esp-fim      and
                                 bordero-ap.nr-docto     >= nr-docto-ini     and
                                 bordero-ap.nr-docto     <= nr-docto-fim     and
                                 bordero-ap.dt-transacao >= dt-transacao-ini and
                                 bordero-ap.dt-transacao <= dt-transacao-fim and
                                 bordero-ap.dt-vencto    >= dt-vencimen-ini  and                             
                                 bordero-ap.dt-vencto    <= dt-vencimen-fim  
                                 no-lock by nr-bordero by dt-transacao INDEXED-REPOSITION.   
            end.
            else do:
                open query {&QUERY-NAME} for each {&TABLE-NAME}                                             
                           where bordero-ap.ep-codigo     = i-ep-codigo      and
                                 bordero-ap.portador      = cod-portador     and 
                                 bordero-ap.cod-estabel  >= cod-estabel-ini  and
                                 bordero-ap.cod-estabel  <= cod-estabel-fim  and
                                 bordero-ap.cod-esp      >= cod-esp-ini      and 
                                 bordero-ap.cod-esp      <= cod-esp-fim      and
                                 bordero-ap.nr-docto     >= nr-docto-ini     and
                                 bordero-ap.nr-docto     <= nr-docto-fim     and
                                 bordero-ap.dt-transacao >= dt-transacao-ini and
                                 bordero-ap.dt-transacao <= dt-transacao-fim and
                                 bordero-ap.dt-vencto    >= dt-vencimen-ini  and                             
                                 bordero-ap.dt-vencto    <= dt-vencimen-fim  and
                                 bordero-ap.nr-bordero   >= nr-bordero-ini   and
                                 bordero-ap.nr-bordero   <= nr-bordero-fim                               
                                 no-lock by nr-bordero by dt-transacao INDEXED-REPOSITION.               
            end.                     
        when 3 then
            if nr-bordero-ini = nr-bordero-fim then do:
                  open query {&QUERY-NAME} for each {&TABLE-NAME}                                             
                       where bordero-ap.ep-codigo     = i-ep-codigo      and
                             bordero-ap.portador      = cod-portador     and 
                             bordero-ap.nr-bordero    = nr-bordero-ini   and                             
                             bordero-ap.cod-estabel  >= cod-estabel-ini  and
                             bordero-ap.cod-estabel  <= cod-estabel-fim  and
                             bordero-ap.cod-esp      >= cod-esp-ini      and 
                             bordero-ap.cod-esp      <= cod-esp-fim      and
                             bordero-ap.nr-docto     >= nr-docto-ini     and
                             bordero-ap.nr-docto     <= nr-docto-fim     and
                             bordero-ap.dt-transacao >= dt-transacao-ini and
                             bordero-ap.dt-transacao <= dt-transacao-fim and
                             bordero-ap.dt-vencto    >= dt-vencimen-ini  and                             
                             bordero-ap.dt-vencto    <= dt-vencimen-fim  
                             no-lock by dt-transacao by vl-docto INDEXED-REPOSITION.
            end.
            else do: 
                  open query {&QUERY-NAME} for each {&TABLE-NAME}                                             
                       where bordero-ap.ep-codigo     = i-ep-codigo      and
                             bordero-ap.portador      = cod-portador     and 
                             bordero-ap.cod-estabel  >= cod-estabel-ini  and
                             bordero-ap.cod-estabel  <= cod-estabel-fim  and
                             bordero-ap.cod-esp      >= cod-esp-ini      and 
                             bordero-ap.cod-esp      <= cod-esp-fim      and
                             bordero-ap.nr-docto     >= nr-docto-ini     and
                             bordero-ap.nr-docto     <= nr-docto-fim     and
                             bordero-ap.dt-transacao >= dt-transacao-ini and
                             bordero-ap.dt-transacao <= dt-transacao-fim and
                             bordero-ap.dt-vencto    >= dt-vencimen-ini  and                             
                             bordero-ap.dt-vencto    <= dt-vencimen-fim  and
                             bordero-ap.nr-bordero   >= nr-bordero-ini   and
                             bordero-ap.nr-bordero   <= nr-bordero-fim                               
                             no-lock by dt-transacao by vl-docto INDEXED-REPOSITION.
            end.            
        when 4 then
            if nr-bordero-ini = nr-bordero-fim then do:
                open query {&QUERY-NAME} for each {&TABLE-NAME}                                             
                           where bordero-ap.ep-codigo     = i-ep-codigo      and
                                 bordero-ap.portador      = cod-portador     and 
                                 bordero-ap.nr-bordero    = nr-bordero-ini   and
                                 bordero-ap.cod-estabel  >= cod-estabel-ini  and
                                 bordero-ap.cod-estabel  <= cod-estabel-fim  and
                                 bordero-ap.cod-esp      >= cod-esp-ini      and 
                                 bordero-ap.cod-esp      <= cod-esp-fim      and
                                 bordero-ap.nr-docto     >= nr-docto-ini     and
                                 bordero-ap.nr-docto     <= nr-docto-fim     and
                                 bordero-ap.dt-transacao >= dt-transacao-ini and
                                 bordero-ap.dt-transacao <= dt-transacao-fim and
                                 bordero-ap.dt-vencto    >= dt-vencimen-ini  and                             
                                 bordero-ap.dt-vencto    <= dt-vencimen-fim  
                                 no-lock by dt-vencto by vl-docto INDEXED-REPOSITION.            
            end.
            else do:
                open query {&QUERY-NAME} for each {&TABLE-NAME}                                             
                           where bordero-ap.ep-codigo     = i-ep-codigo      and
                                 bordero-ap.portador      = cod-portador     and 
                                 bordero-ap.cod-estabel  >= cod-estabel-ini  and
                                 bordero-ap.cod-estabel  <= cod-estabel-fim  and
                                 bordero-ap.cod-esp      >= cod-esp-ini      and 
                                 bordero-ap.cod-esp      <= cod-esp-fim      and
                                 bordero-ap.nr-docto     >= nr-docto-ini     and
                                 bordero-ap.nr-docto     <= nr-docto-fim     and
                                 bordero-ap.dt-transacao >= dt-transacao-ini and
                                 bordero-ap.dt-transacao <= dt-transacao-fim and
                                 bordero-ap.dt-vencto    >= dt-vencimen-ini  and                             
                                 bordero-ap.dt-vencto    <= dt-vencimen-fim  and
                                 bordero-ap.nr-bordero   >= nr-bordero-ini   and
                                 bordero-ap.nr-bordero   <= nr-bordero-fim                               
                                 no-lock by dt-vencto by vl-docto INDEXED-REPOSITION.
            end.                 
        when 5 then
            if nr-bordero-ini = nr-bordero-fim then do:
                open query {&QUERY-NAME} for each {&TABLE-NAME}                                             
                           where bordero-ap.ep-codigo     = i-ep-codigo      and
                                 bordero-ap.portador      = cod-portador     and 
                                 bordero-ap.nr-bordero    = nr-bordero-ini   and
                                 bordero-ap.cod-estabel  >= cod-estabel-ini  and
                                 bordero-ap.cod-estabel  <= cod-estabel-fim  and
                                 bordero-ap.cod-esp      >= cod-esp-ini      and 
                                 bordero-ap.cod-esp      <= cod-esp-fim      and
                                 bordero-ap.nr-docto     >= nr-docto-ini     and
                                 bordero-ap.nr-docto     <= nr-docto-fim     and
                                 bordero-ap.dt-transacao >= dt-transacao-ini and
                                 bordero-ap.dt-transacao <= dt-transacao-fim and
                                 bordero-ap.dt-vencto  >= dt-vencimen-ini    and                             
                                 bordero-ap.dt-vencto  <= dt-vencimen-fim    
                                 no-lock by vl-docto by dt-transacao INDEXED-REPOSITION.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
            end.
            else do:
                open query {&QUERY-NAME} for each {&TABLE-NAME}                                             
                           where bordero-ap.ep-codigo     = i-ep-codigo      and
                                 bordero-ap.portador      = cod-portador     and 
                                 bordero-ap.nr-bordero   >= nr-bordero-ini   and
                                 bordero-ap.nr-bordero   <= nr-bordero-fim   and
                                 bordero-ap.cod-estabel  >= cod-estabel-ini  and
                                 bordero-ap.cod-estabel  <= cod-estabel-fim  and
                                 bordero-ap.cod-esp      >= cod-esp-ini      and 
                                 bordero-ap.cod-esp      <= cod-esp-fim      and
                                 bordero-ap.nr-docto     >= nr-docto-ini     and
                                 bordero-ap.nr-docto     <= nr-docto-fim     and
                                 bordero-ap.dt-transacao >= dt-transacao-ini and
                                 bordero-ap.dt-transacao <= dt-transacao-fim and
                                 bordero-ap.dt-vencto  >= dt-vencimen-ini    and                             
                                 bordero-ap.dt-vencto  <= dt-vencimen-fim    
                                 no-lock by vl-docto by dt-transacao INDEXED-REPOSITION.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
            end.
    end case.
    assign l-query = true
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
{include/boexedel.i}
{include/bovalupt.i}
{include/bovaldel.i}

procedure findCodigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input parameter i-ep-codigo   LIKE empresa.ep-codigo no-undo.
&ELSE
    def input parameter i-ep-codigo   as inte no-undo.
&ENDIF
    def input parameter i-cod-fornec  as inte no-undo.
    def input parameter c-cod-estabel as char no-undo.
    def input parameter c-cod-esp     as char no-undo.
    def input parameter c-serie       as char no-undo.
    def input parameter c-nr-docto    as char no-undo.
    def input parameter c-parcela     as char no-undo.
    def output parameter c-return     as char no-undo.
 
    find bordero-ap where
            bordero-ap.ep-codigo   = i-ep-codigo
        and bordero-ap.cod-fornec  = i-cod-fornec
        and bordero-ap.cod-estabel = c-cod-estabel
        and bordero-ap.cod-esp     = c-cod-esp
        and bordero-ap.serie       = c-serie
        and bordero-ap.nr-docto    = c-nr-docto
        and bordero-ap.parcela     = c-parcela
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i movadm {&TABLE-NAME} 1}
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
 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */ 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.
 
procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").
    if rowObject.cod-esp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-estabel = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-fornec = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ct-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.emitiu = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ep-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.historico = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.lancamento = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nominal = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-bordero = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-cheque = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-docto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.parcela = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.pedido = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.portador = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.referencia = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.sc-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.serie = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tp-transacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.transacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-desconto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-docto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-juros = ? then do:
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
 
    find first rowObject
        no-lock no-error.
    if rowObject.cod-esp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} cod-esp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-estabel = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} cod-estabel 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-fornec = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} cod-fornec 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ct-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} ct-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.emitiu = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} emitiu 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ep-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} ep-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.historico = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} historico 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.lancamento = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} lancamento 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nominal = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} nominal 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-bordero = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} nr-bordero 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-cheque = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} nr-cheque 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-docto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} nr-docto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.parcela = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} parcela 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.pedido = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} pedido 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.portador = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} portador 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.referencia = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} referencia 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.sc-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} sc-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.serie = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} serie 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tp-transacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} tp-transacao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.transacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} transacao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-desconto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} vl-desconto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-docto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} vl-docto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-juros = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} vl-juros 1}
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
        find bordero-ap
             where bordero-ap.ep-codigo   = rowObject.ep-codigo
             and   bordero-ap.cod-fornec  = rowObject.cod-fornec
             and   bordero-ap.cod-estabel = rowObject.cod-estabel
             and   bordero-ap.cod-esp     = rowObject.cod-esp
             and   bordero-ap.serie       = rowObject.serie
             and   bordero-ap.nr-docto    = rowObject.nr-docto
             and   bordero-ap.parcela     = rowObject.parcela
             no-lock no-error.
        if avail bordero-ap then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i movadm {&TABLE-NAME} 1}
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
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        &IF "{&mguni_version}" >= "2.07A" &THEN
            when "ep-codigo" then c-value = RowObject.ep-codigo.
        &ENDIF
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "cod-esp" then c-value = RowObject.cod-esp.
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "conta-debito" then c-value = RowObject.conta-debito.
        when "ct-codigo" then c-value = RowObject.ct-codigo.
        when "docto-ir" then c-value = RowObject.docto-ir.
        when "esp-ir" then c-value = RowObject.esp-ir.
        when "historico" then c-value = RowObject.historico.
        when "literal" then c-value = RowObject.literal.
        when "nr-cheque" then c-value = RowObject.nr-cheque.
        when "nr-docto" then c-value = RowObject.nr-docto.
        when "parc-ir" then c-value = RowObject.parc-ir.
        when "parcela" then c-value = RowObject.parcela.
        when "pedido" then c-value = RowObject.pedido.
        when "referencia" then c-value = RowObject.referencia.
        when "sc-codigo" then c-value = RowObject.sc-codigo.
        when "serie" then c-value = RowObject.serie.
        when "serie-ir" then c-value = RowObject.serie-ir.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "vl-desconto" then c-value = RowObject.vl-desconto.
        when "vl-docto" then c-value = RowObject.vl-docto.
        when "vl-juros" then c-value = RowObject.vl-juros.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "cod-fornec" then c-value = RowObject.cod-fornec.
        when "cod-ret" then c-value = RowObject.cod-ret.
        &IF "{&mguni_version}" < "2.07A" &THEN
            when "ep-codigo" then c-value = RowObject.ep-codigo.
        &ENDIF
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "lancamento" then c-value = RowObject.lancamento.
        when "nominal" then c-value = RowObject.nominal.
        when "nr-bordero" then c-value = RowObject.nr-bordero.
        when "port-transf" then c-value = RowObject.port-transf.
        when "portador" then c-value = RowObject.portador.
        when "tipo" then c-value = RowObject.tipo.
        when "tp-codigo" then c-value = RowObject.tp-codigo.
        when "tp-transacao" then c-value = RowObject.tp-transacao.
        when "transacao" then c-value = RowObject.transacao.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        when "dt-transacao" then c-value = RowObject.dt-transacao.
        when "dt-vencto" then c-value = RowObject.dt-vencto.
        when "u-data-1" then c-value = RowObject.u-data-1.
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "emitiu" then c-value = RowObject.emitiu.
        when "ir-antec" then c-value = RowObject.ir-antec.
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        otherwise return error.
    end case.
end procedure.
 

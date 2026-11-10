/********************************************************************************  
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN535 2.00.00.043 } /*** "010043" 03/06/2025 14:03:15 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin535 MUT}
&ENDIF
           
/*
**  BOIN535.P
**
**  split-operac - Operaá∆o Ch∆o de F†brica
**
**  Ultima alteraá∆o : 30/07/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY split-operac
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME split-operac
 
 
{cdp/cdcfgman.i}                    /* VariŸvel preprocessador bf_man_sfc_lc **/
{include/boini.i}
{method/dbotterr.i} /*rowErrors*/
 
{inbo/boin535.i RowObject}

def var h-servid-rpc as handle no-undo. 
{btb/btb008za.i0}
 
def var c-item-ini        as char                         no-undo.
def var c-item-fim        as char init "ZZZZZZZZZZZZZZZZ" no-undo.
def var c-refer-ini       as char                         no-undo.
def var c-refer-fim       as char init "ZZZZZZZZ"         no-undo.
def var i-op-ini          as int                          no-undo.
def var i-op-fim          as int  init "999999999"        no-undo.
def var d-pri-ini         as int                          no-undo. 
def var d-pri-fim         as int  init "999"              no-undo.
def var dt-imc-ini        as date                         no-undo.
def var dt-imc-fim        as date init "12/31/3999"       no-undo.
def var dt-fmt-ini        as date                         no-undo.
def var dt-fmt-fim        as date init "12/31/3999"       no-undo.
def var c-cod-ctrab       as char                         no-undo.
def var dt-inic-valid     as date                         no-undo.
def var c-cod-area        as char                         no-undo.
def var i-selecao         as int                          no-undo.
def var c-gm-codigo       as char                         no-undo.
def var l-altern          as logical                      no-undo.

DEF VAR d-dat-data-aux          AS DATE                   NO-UNDO.
DEF VAR i-qtd-segs-aux          AS DECIMAL DECIMALS 0     NO-UNDO.
DEF VAR d-dat-corte-parada      AS DATE INIT TODAY        NO-UNDO.
DEF VAR i-qtd-segs-corte-parada AS DECIMAL DECIMALS 0     NO-UNDO.
DEF VAR l-cons-parada-prog      AS LOG                    NO-UNDO.
DEF VAR l-cons-parada-real      AS LOG                    NO-UNDO.
DEF VAR de-tempo-aux            AS DECIMAL DECIMALS 4     NO-UNDO.
DEF VAR c-cod-calend            LIKE area-produc.cd-calen NO-UNDO.
DEF VAR h-boin469e              AS HANDLE                 NO-UNDO.
DEFINE VARIABLE l-piCalculaRedePert AS LOGICAL INIT NO    NO-UNDO.

def temp-table tt-split-operac NO-UNDO like split-operac
    field r-rowid as rowid.

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

DEFINE BUFFER bf-tt-split-operac FOR tt-split-operac.



ASSIGN l-cons-parada-prog      = YES
       l-cons-parada-real      = YES
       d-dat-corte-parada      = TODAY
       i-qtd-segs-corte-parada = TIME.

procedure setConstraint1:
    def input param p-item-ini as char no-undo.
    def input param p-item-fim as char no-undo.
    
    assign c-item-ini = p-item-ini
           c-item-fim = p-item-fim.
           
end procedure.
 
procedure setConstraint2:
    def input param p-op-ini   as int no-undo.
    def input param p-op-fim   as int no-undo.
    
    assign i-op-ini   = p-op-ini
           i-op-fim   = p-op-fim.
end procedure.

procedure setConstraint3:
    def input param p-pri-ini as int no-undo.
    def input param p-pri-fim as int no-undo.
    
    assign d-pri-ini = p-pri-ini
           d-pri-fim = p-pri-fim.
end procedure.

procedure setConstraint4:
    def input param p-imc-ini as date no-undo.
    def input param p-imc-fim as date no-undo.
    
    assign dt-imc-ini = p-imc-ini
           dt-imc-fim = p-imc-fim.
end procedure.

procedure setConstraint5:
    def input param p-fmt-ini as date no-undo.
    def input param p-fmt-fim as date no-undo.
    
    assign dt-fmt-ini = p-fmt-ini
           dt-fmt-fim = p-fmt-fim.
end procedure.

procedure setConstraint6:
    def input param p-cod-area  as char no-undo.
    def input param p-selecao   as int  no-undo.
    def input param p-gm-codigo as char no-undo.
    def input param p-cod-ctrab as char no-undo.
    def input param p-altern    as log  no-undo.
        
    assign c-cod-area  = p-cod-area
           i-selecao   = p-selecao
           c-gm-codigo = p-gm-codigo
           c-cod-ctrab = p-cod-ctrab
           l-altern    = p-altern.

end procedure.

procedure setConstraint7:
    def input param p-ref-ini  as char no-undo.
    def input param p-ref-fim  as char no-undo.
    def input param p-item-ini as char no-undo.
    def input param p-item-fim as char no-undo.
    
    assign c-refer-ini  = p-ref-ini
           c-refer-fim  = p-ref-fim
           c-item-ini   = p-item-ini
           c-item-fim   = p-item-fim.
        
end procedure.


     
procedure openQueryStatic:
    
    def input param c-param as char.
    
    case c-param:
        when "Item" then
            run openQueryItem.
        when "Ordem" then
            run openQueryOrdem.
        when "Prioridade" then
            run openQueryPriori.
        when "Inicio" then
            run openQueryInicio.
        when "Fim" then
            run openQueryFim.
        when "itemRefer" then
            run openQueryItemRefer.
    end.                                                

end procedure.
    
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    
    case i-abertura:
        when 1 THEN
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                                where {&TABLE-NAME}.cod-area-produc  = c-cod-area
                                  and {&table-name}.ind-estado-split = i-selecao
                                  and {&TABLE-NAME}.gm-codigo        = c-gm-codigo
                                  and ({&TABLE-NAME}.cod-ctrab = "" or
                                       {&TABLE-NAME}.cod-ctrab = c-cod-ctrab)
                                  and ((l-altern = no and {&table-name}.int-1 = 0) or l-altern)
                                  and {&TABLE-NAME}.cod-item-op >= c-item-ini
                                  and {&TABLE-NAME}.cod-item-op <= c-item-fim
                                   by {&TABLE-NAME}.cod-item-op INDEXED-REPOSITION.
        when 2 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                                where {&TABLE-NAME}.cod-area-produc  = c-cod-area
                                  and {&table-name}.ind-estado-split = i-selecao
                                  and {&TABLE-NAME}.gm-codigo        = c-gm-codigo
                                  and ({&TABLE-NAME}.cod-ctrab = "" or
                                       {&TABLE-NAME}.cod-ctrab = c-cod-ctrab)
                                  and ((l-altern = no and {&table-name}.int-1 = 0) or l-altern)
                                  and {&TABLE-NAME}.nr-ord-produ >= i-op-ini
                                  and {&TABLE-NAME}.nr-ord-produ <= i-op-fim
                                   by {&TABLE-NAME}.nr-ord-produ INDEXED-REPOSITION.
        when 3 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                                where {&TABLE-NAME}.cod-area-produc  = c-cod-area
                                  and {&table-name}.ind-estado-split = i-selecao
                                  and {&TABLE-NAME}.gm-codigo        = c-gm-codigo
                                  and ({&TABLE-NAME}.cod-ctrab = "" or
                                       {&TABLE-NAME}.cod-ctrab = c-cod-ctrab)
                                  and ((l-altern = no and {&table-name}.int-1 = 0) or l-altern)
                                  and {&TABLE-NAME}.val-priorid-inter >= d-pri-ini
                                  and {&TABLE-NAME}.val-priorid-inter <= d-pri-fim
                                   by {&TABLE-NAME}.val-priorid-inter INDEXED-REPOSITION.
        when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                                where {&TABLE-NAME}.cod-area-produc  = c-cod-area
                                  and {&table-name}.ind-estado-split = i-selecao
                                  and {&TABLE-NAME}.gm-codigo        = c-gm-codigo
                                  and ({&TABLE-NAME}.cod-ctrab = "" or
                                       {&TABLE-NAME}.cod-ctrab = c-cod-ctrab)
                                  and ((l-altern = no and {&table-name}.int-1 = 0) or l-altern)
                                  and {&TABLE-NAME}.dat-imc >= dt-imc-ini
                                  and {&TABLE-NAME}.dat-imc <= dt-imc-fim
                                   by {&TABLE-NAME}.dat-imc INDEXED-REPOSITION.
        when 5 then                              
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                                where {&TABLE-NAME}.cod-area-produc  = c-cod-area
                                  and {&table-name}.ind-estado-split = i-selecao
                                  and {&TABLE-NAME}.gm-codigo        = c-gm-codigo
                                  and ({&TABLE-NAME}.cod-ctrab = "" or
                                       {&TABLE-NAME}.cod-ctrab = c-cod-ctrab)
                                  and ((l-altern = no and {&table-name}.int-1 = 0) or l-altern)
                                  and {&TABLE-NAME}.dat-fmt >= dt-fmt-ini
                                  and {&TABLE-NAME}.dat-fmt <= dt-fmt-fim
                                   by {&TABLE-NAME}.dat-fmt INDEXED-REPOSITION.   
       when 6 THEN
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                        where {&TABLE-NAME}.cod-area-produc  = c-cod-area
                          and {&table-name}.ind-estado-split = i-selecao
                          and {&TABLE-NAME}.gm-codigo        = c-gm-codigo
                          and ({&TABLE-NAME}.cod-ctrab = "" or
                               {&TABLE-NAME}.cod-ctrab = c-cod-ctrab)
                          and ((l-altern = no and {&table-name}.int-1 = 0) or l-altern)
                          and {&TABLE-NAME}.cod-item-op >= c-item-ini
                          and {&TABLE-NAME}.cod-item-op <= c-item-fim 
                          by {&TABLE-NAME}.cod-item-op INDEXED-REPOSITION.                               
    end case.                       
    assign l-query    = true
           i-bo-query = i-abertura.

    return "OK":U.
       
end procedure.

PROCEDURE linkToarea-produc-ctrab :

    def input param p-handle as handle no-undo.
    
    run getKey in p-handle (output c-cod-ctrab, output dt-inic-valid).
    
    return "NOK":U.

END PROCEDURE.
 
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
    def input parameter i-nr-ord-produ as inte no-undo.
    def input parameter i-num-operac-sfc as inte no-undo.
    def input parameter i-num-split-operac as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find FIRST split-operac where
        split-operac.nr-ord-produ = i-nr-ord-produ
        and split-operac.num-operac-sfc = i-num-operac-sfc
        and split-operac.num-split-operac = i-num-split-operac
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
    if rowObject.cod-item-op = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-item-op 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-roteiro = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-roteiro 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.gm-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} gm-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-estado-split = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} ind-estado-split 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.it-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} it-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.log-reporte-cp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} log-reporte-cp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.log-split-critic = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} log-split-critic 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.log-split-finaliz = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} log-split-finaliz 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.log-split-rep = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} log-split-rep 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-ord-produ = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} nr-ord-produ 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.num-operac-sfc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} num-operac-sfc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.num-split-operac = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} num-split-operac 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.op-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} op-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-capac-operac = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-capac-operac 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-operac-aprov = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-operac-aprov 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-operac-refgda = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-operac-refgda 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-operac-reptda = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-operac-reptda 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-operac-retrab = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-operac-retrab 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-pallet-produt = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-pallet-produt 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-previs-operac = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-previs-operac 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-fim-operac = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-fim-operac 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-fim-setup = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-fim-setup 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-fmc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-fmc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-fmt = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-fmt 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-imc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-imc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-imc-setup = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-imc-setup 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-imt = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-imt 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-imt-setup = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-imt-setup 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-inic-operac = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-inic-operac 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-inic-setup = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-inic-setup 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-produt-dispon = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-produt-dispon 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-progdo-dispon = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-progdo-dispon 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-progdo-fim-operac = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-progdo-fim-operac 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-progdo-inic-operac = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-progdo-inic-operac 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-progdo-inic-setup = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-progdo-inic-setup 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tempo-folga = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tempo-folga 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tempo-pad-carga = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tempo-pad-carga 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tempo-pad-maq = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tempo-pad-maq 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tempo-pad-mod = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tempo-pad-mod 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tempo-pad-operac = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tempo-pad-operac 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tempo-pad-pos-operac = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tempo-pad-pos-operac 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tempo-pad-setup = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tempo-pad-setup 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tempo-real-extra = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tempo-real-extra 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tempo-real-maq = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tempo-real-maq 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tempo-real-mod = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tempo-real-mod 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tempo-real-operac = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tempo-real-operac 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tempo-real-pos-operac = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tempo-real-pos-operac 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tempo-real-prepar = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tempo-real-prepar 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.val-perc-avanco = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} val-perc-avanco 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.val-perc-operac = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} val-perc-operac 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.val-priorid-inter = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} val-priorid-inter 1}
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
    **  Valida criaá∆o da tabela/duplicidade de registro.
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
        find FIRST split-operac where
            split-operac.nr-ord-produ = rowObject.nr-ord-produ
        and split-operac.num-operac-sfc = rowObject.num-operac-sfc
        and split-operac.num-split-operac = rowObject.num-split-operac
            no-lock no-error.
        if avail split-operac then do:
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
        when "cod-area-produc" then c-value = RowObject.cod-area-produc.
        when "cod-ctrab" then c-value = RowObject.cod-ctrab.
        when "cod-ferr-prod" then c-value = RowObject.cod-ferr-prod.
        when "cod-grp-setup" then c-value = RowObject.cod-grp-setup.
        when "cod-item-op" then c-value = RowObject.cod-item-op.
        when "cod-roteiro" then c-value = RowObject.cod-roteiro.
        when "gm-codigo" then c-value = RowObject.gm-codigo.
        when "it-codigo" then c-value = RowObject.it-codigo.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "qtd-capac-operac" then c-value = RowObject.qtd-capac-operac.
        when "qtd-carga-batch" then c-value = RowObject.qtd-carga-batch.
        when "qtd-ferr-prod" then c-value = RowObject.qtd-ferr-prod.
        when "qtd-operac-aprov" then c-value = RowObject.qtd-operac-aprov.
        when "qtd-operac-refgda" then c-value = RowObject.qtd-operac-refgda.
        when "qtd-operac-reptda" then c-value = RowObject.qtd-operac-reptda.
        when "qtd-operac-retrab" then c-value = RowObject.qtd-operac-retrab.
        when "qtd-pallet-produt" then c-value = RowObject.qtd-pallet-produt.
        when "qtd-previs-operac" then c-value = RowObject.qtd-previs-operac.
        when "qtd-segs-fim-operac" then c-value = RowObject.qtd-segs-fim-operac.
        when "qtd-segs-fim-setup" then c-value = RowObject.qtd-segs-fim-setup.
        when "qtd-segs-fmc" then c-value = RowObject.qtd-segs-fmc.
        when "qtd-segs-fmt" then c-value = RowObject.qtd-segs-fmt.
        when "qtd-segs-imc" then c-value = RowObject.qtd-segs-imc.
        when "qtd-segs-imc-setup" then c-value = RowObject.qtd-segs-imc-setup.
        when "qtd-segs-imt" then c-value = RowObject.qtd-segs-imt.
        when "qtd-segs-imt-setup" then c-value = RowObject.qtd-segs-imt-setup.
        when "qtd-segs-inic-operac" then c-value = RowObject.qtd-segs-inic-operac.
        when "qtd-segs-inic-setup" then c-value = RowObject.qtd-segs-inic-setup.
        when "qtd-segs-produt-dispon" then c-value = RowObject.qtd-segs-produt-dispon.
        when "qtd-segs-progdo-dispon" then c-value = RowObject.qtd-segs-progdo-dispon.
        when "qtd-segs-progdo-fim-operac" then c-value = RowObject.qtd-segs-progdo-fim-operac.
        when "qtd-segs-progdo-inic-operac" then c-value = RowObject.qtd-segs-progdo-inic-operac.
        when "qtd-segs-progdo-inic-setup" then c-value = RowObject.qtd-segs-progdo-inic-setup.
        when "tempo-folga" then c-value = RowObject.tempo-folga.
        when "tempo-pad-carga" then c-value = RowObject.tempo-pad-carga.
        when "tempo-pad-maq" then c-value = RowObject.tempo-pad-maq.
        when "tempo-pad-mod" then c-value = RowObject.tempo-pad-mod.
        when "tempo-pad-operac" then c-value = RowObject.tempo-pad-operac.
        when "tempo-pad-pos-operac" then c-value = RowObject.tempo-pad-pos-operac.
        when "tempo-pad-setup" then c-value = RowObject.tempo-pad-setup.
        when "tempo-real-extra" then c-value = RowObject.tempo-real-extra.
        when "tempo-real-maq" then c-value = RowObject.tempo-real-maq.
        when "tempo-real-mod" then c-value = RowObject.tempo-real-mod.
        when "tempo-real-operac" then c-value = RowObject.tempo-real-operac.
        when "tempo-real-pos-operac" then c-value = RowObject.tempo-real-pos-operac.
        when "tempo-real-prepar" then c-value = RowObject.tempo-real-prepar.
        when "val-perc-avanco" then c-value = RowObject.val-perc-avanco.
        when "val-perc-operac" then c-value = RowObject.val-perc-operac.
        when "val-priorid-inter" then c-value = RowObject.val-priorid-inter.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "ind-estado-split" then c-value = RowObject.ind-estado-split.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "nr-ord-produ" then c-value = RowObject.nr-ord-produ.
        when "num-operac-sfc" then c-value = RowObject.num-operac-sfc.
        when "num-split-operac" then c-value = RowObject.num-split-operac.
        when "op-codigo" then c-value = RowObject.op-codigo.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "dat-fim-operac" then c-value = RowObject.dat-fim-operac.
        when "dat-fim-setup" then c-value = RowObject.dat-fim-setup.
        when "dat-fmc" then c-value = RowObject.dat-fmc.
        when "dat-fmt" then c-value = RowObject.dat-fmt.
        when "dat-imc" then c-value = RowObject.dat-imc.
        when "dat-imc-setup" then c-value = RowObject.dat-imc-setup.
        when "dat-imt" then c-value = RowObject.dat-imt.
        when "dat-imt-setup" then c-value = RowObject.dat-imt-setup.
        when "dat-inic-operac" then c-value = RowObject.dat-inic-operac.
        when "dat-inic-setup" then c-value = RowObject.dat-inic-setup.
        when "dat-produt-dispon" then c-value = RowObject.dat-produt-dispon.
        when "dat-progda-dispon" then c-value = RowObject.dat-progda-dispon.
        when "dat-progda-fim-operac" then c-value = RowObject.dat-progda-fim-operac.
        when "dat-progda-inic-operac" then c-value = RowObject.dat-progda-inic-operac.
        when "dat-progda-inic-setup" then c-value = RowObject.dat-progda-inic-setup.
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
        when "log-reporte-cp" then c-value = RowObject.log-reporte-cp.
        when "log-split-critic" then c-value = RowObject.log-split-critic.
        when "log-split-finaliz" then c-value = RowObject.log-split-finaliz.
        when "log-split-rep" then c-value = RowObject.log-split-rep.
        otherwise return error.
    end case.
end procedure.
 
procedure findOperOrd:
    define output parameter c-desc as char.
 
    find first oper-ord of RowObject NO-LOCK NO-ERROR.
    if avail oper-ord then
       assign c-desc = oper-ord.descricao.
       
end procedure.


procedure getDescVarias:
    def output param p-desc-area  as char.
    def output param p-desc-ctrab as char.
    def output param p-desc-item  as char.
    def output param p-desc-rot   as char.
    def output param p-desc-op    as char.                
    def output param p-desc-gm    as char.    
    
    if avail RowObject then do:
       find first area-produc
            where area-produc.cod-area-produc = RowObject.cod-area-produc no-lock no-error.
       assign p-desc-area = if avail area-produc then area-produc.des-area-produc else "":U.
       
       find first ctrab
            where ctrab.cod-ctrab = RowObject.cod-ctrab no-lock no-error.
       assign p-desc-ctrab = if avail ctrab then ctrab.des-ctrab else "":U.           

       find first item
            where item.it-codigo = RowObject.cod-item-op no-lock no-error.
       assign p-desc-item = if avail item then item.desc-item else "":U.
           
       find first rot-fabric
            where rot-fabric.cod-roteiro = RowObject.cod-roteiro no-lock no-error.
       assign p-desc-rot = if avail rot-fabric then rot-fabric.descricao else "":U.
                  
       find first operacao
            where operacao.it-codigo   = RowObject.it-codigo
              and operacao.cod-roteiro = RowObject.cod-roteiro
              and operacao.op-codigo   = RowObject.op-codigo no-lock no-error.
       assign p-desc-op = if avail operacao then operacao.descricao else "":U.
                         
       find first grup-maquina
            where grup-maquina.gm-codigo = RowObject.gm-codigo no-lock no-error.
       assign p-desc-gm = if avail grup-maquina then grup-maquina.descricao else "":U.
                                
    end.


end procedure.

Procedure extrairOpAltern:

    def input param p-gm-codigo as char.
    def input-output param table for tt-split-operac.
    
    for each  op-altern 
        where op-altern.gm-codigo = p-gm-codigo no-lock:
        
        find first operacao of op-altern no-lock no-error.
        if not avail operacao then next.

        for each  oper-ord no-lock
            where oper-ord.it-codigo   = operacao.it-codigo
              and oper-ord.cod-roteiro = operacao.cod-roteiro
              and oper-ord.op-codigo   = operacao.op-codigo
              and oper-ord.estado      = 1:

            for each split-operac where 
                     split-operac.nr-ord-produ   = oper-ord.nr-ord-produ and
                     split-operac.num-operac-sfc = oper-ord.num-operac-sfc no-lock:

                find first tt-split-operac
                     where tt-split-operac.nr-ord-produ     = split-operac.nr-ord-produ
                       and tt-split-operac.num-operac-sfc   = split-operac.num-operac-sfc
                       and tt-split-operac.num-split-operac = split-operac.num-split-operac no-error.
                if not avail tt-split-operac then do:
                    create tt-split-operac.
                    buffer-copy split-operac to tt-split-operac
                    assign tt-split-operac.gm-codigo = op-altern.gm-codigo
                           tt-split-operac.cod-ctrab = ""
                           tt-split-operac.int-1     = 10  /*** Identifica operacao alternativa ***/
                           tt-split-operac.r-rowid   = rowid(split-operac).
                           
              
                end.
            end.
        end.
    end.

    for each  grup-maq-altern
        where grup-maq-altern.gm-altern = p-gm-codigo no-lock:

        for each  oper-ord
            where oper-ord.gm-codigo = grup-maq-altern.gm-codigo
              and oper-ord.estado    = 1 no-lock:

            for each split-operac where 
                     split-operac.nr-ord-produ   = oper-ord.nr-ord-produ and
                     split-operac.num-operac-sfc = oper-ord.num-operac-sfc no-lock:

                find first tt-split-operac
                     where tt-split-operac.nr-ord-produ     = split-operac.nr-ord-produ
                       and tt-split-operac.num-operac-sfc   = split-operac.num-operac-sfc
                       and tt-split-operac.num-split-operac = split-operac.num-split-operac no-error.
                if not avail tt-split-operac then do:
                    create tt-split-operac.
                    buffer-copy split-operac to tt-split-operac
                    assign tt-split-operac.gm-codigo = grup-maq-altern.gm-altern
                           tt-split-operac.cod-ctrab = ""
                           tt-split-operac.int-1     = 10  /*** Identifica operacao alternativa ***/
                           tt-split-operac.r-rowid   = rowid(split-operac).
                end.
            end.
        end.
    end.

end procedure.

PROCEDURE verificarReporteCtrab:
    
    def  input param p-cod-ctrab       as char no-undo.
    def  input param p-val-refer       like rep-oper-ctrab.val-refer-inic-rep no-undo.
    def output param p-existe-rep-inic as log no-undo.

    def var v-dat-aux       like split-operac.dat-inic-operac      no-undo.
    def var v-qtd-segs-aux  like split-operac.qtd-segs-inic-operac no-undo.

    if p-val-refer = 0 then return.
    
    find first rep-oper-ctrab
        where rep-oper-ctrab.cod-ctrab           = p-cod-ctrab
          and rep-oper-ctrab.val-refer-inic-rep <= p-val-refer
          and rep-oper-ctrab.val-refer-fim-rep  >  p-val-refer no-lock no-error.

    if  avail rep-oper-ctrab then
        assign p-existe-rep-inic = yes.
    else do:
        find ctrab where ctrab.cod-ctrab = p-cod-ctrab NO-LOCK NO-ERROR.
        if not available ctrab then return.
        run pi-converte-valor-data-segs (INPUT p-val-refer,
                                         output v-dat-aux,
                                         output v-qtd-segs-aux).
        find first split-operac
             where split-operac.gm-codigo        = ctrab.gm-codigo
               and split-operac.ind-estado-split = 4
               and split-operac.cod-ctrab        = p-cod-ctrab
               and (split-operac.dat-inic-operac  < v-dat-aux or
                   (split-operac.dat-inic-operac = v-dat-aux and
                    split-operac.qtd-segs-inic-operac <= v-qtd-segs-aux)) 
                    no-lock no-error. 
        if available split-operac then        
            assign p-existe-rep-inic = yes.
    end.     

END PROCEDURE.

PROCEDURE retornarSplitReporte:
    
    def  input param p-cod-ctrab       as char no-undo.
    def  input param p-val-refer       like rep-oper-ctrab.val-refer-inic-rep no-undo.
    def output param p-rw-split-operac as rowid no-undo.

    def var v-dat-aux       like split-operac.dat-inic-operac      no-undo.
    def var v-qtd-segs-aux  like split-operac.qtd-segs-inic-operac no-undo.

    find first rep-oper-ctrab
        where rep-oper-ctrab.cod-ctrab           = p-cod-ctrab
          and rep-oper-ctrab.val-refer-inic-rep <= p-val-refer
          and rep-oper-ctrab.val-refer-fim-rep  >  p-val-refer no-lock no-error.

    if  avail rep-oper-ctrab then do:
        find FIRST split-operac
            where split-operac.nr-ord-produ     = rep-oper-ctrab.nr-ord-produ
              and split-operac.num-operac-sfc   = rep-oper-ctrab.num-operac-sfc
              and split-operac.num-split-operac = rep-oper-ctrab.num-split-operac no-lock no-error.
        if  avail split-operac then
            assign p-rw-split-operac = rowid(split-operac).
        else
            assign p-rw-split-operac = ?.
    end.
    else do:
        find ctrab where ctrab.cod-ctrab = p-cod-ctrab NO-LOCK NO-ERROR.
        if not available ctrab then return.
        run pi-converte-valor-data-segs (p-val-refer,
                                         output v-dat-aux,
                                         output v-qtd-segs-aux).
        find first split-operac
             where split-operac.gm-codigo        = ctrab.gm-codigo
               and split-operac.ind-estado-split = 4
               and split-operac.cod-ctrab        = p-cod-ctrab
               and (split-operac.dat-inic-operac  < v-dat-aux or
                   (split-operac.dat-inic-operac = v-dat-aux and
                    split-operac.qtd-segs-inic-operac <= v-qtd-segs-aux)) 
                    no-lock no-error. 
        if  avail split-operac then
            assign p-rw-split-operac = rowid(split-operac).
        else
            assign p-rw-split-operac = ?.
    end.
    
END PROCEDURE.

/*******************************************************************************/

/*** Procedimentos de Negocio ******/

{inbo/boin535.i1}  /*** Procedures negocio split operac ***/
{inbo/boin535.i2}  /*** CalcularTempoPadrao ***/
{inbo/boin535.i3}  /*** AlterarEstadoSplit AtualizaTempoPadrao CalculaDataInicioSetup***/ 
{inbo/boin535.i4}  /*** Unir e dividir split ***/
{inbo/boin535.i5}  /*** AlterarGrupoMaquinaSplit ***/
{inbo/boin535.i6}  /*** Iniciar reporte de operaá∆o SFC ***/
{sfc/sf9002.i}     /*** pi-converte-valor-data-segs ***/

/*******************************************************************************/


PROCEDURE validarSplitOperac:
          
DEF INPUT  PARAM p-cod-area-produc LIKE area-produc-ctrab.cod-area-produc.
DEF INPUT  PARAM p-cod-ctrab       LIKE area-produc-ctrab.cod-ctrab.
DEF INPUT  PARAM p-gm-codigo       LIKE area-produc-ctrab.gm-codigo.
DEF OUTPUT PARAM p-erro as LOGICAL no-undo.

    IF CAN-FIND(FIRST split-operac NO-LOCK WHERE 
                      split-operac.cod-ctrab = p-cod-ctrab       AND
                      split-operac.gm-codigo = p-gm-codigo       AND
                     (split-operac.ind-estado-split = 1 OR
                      split-operac.ind-estado-split = 2 OR
                      split-operac.ind-estado-split = 3 OR
                      split-operac.ind-estado-split = 4))  THEN DO:
        
           ASSIGN p-erro = YES.
    END. 
    ELSE ASSIGN p-erro = NO.
        
END PROCEDURE.



PROCEDURE validarDelSplitOperac:
          
DEF INPUT  PARAM p-cod-area-produc LIKE area-produc-ctrab.cod-area-produc.
DEF INPUT  PARAM p-cod-ctrab       LIKE area-produc-ctrab.cod-ctrab.
DEF INPUT  PARAM p-gm-codigo       LIKE area-produc-ctrab.gm-codigo.
DEF INPUT PARAM  p-dat-refer       LIKE area-produc-ctrab.dat-inic-valid.
DEF OUTPUT PARAM p-erro            as LOGICAL no-undo.

    IF CAN-FIND(FIRST split-operac NO-LOCK WHERE 
                      split-operac.cod-ctrab = p-cod-ctrab       AND
                      split-operac.gm-codigo = p-gm-codigo       AND
                      split-operac.cod-area-produc = p-cod-area-produc AND 
                     (split-operac.ind-estado-split = 1 OR
                      split-operac.ind-estado-split = 2 OR
                      split-operac.ind-estado-split = 3 OR
                      split-operac.ind-estado-split = 4))  THEN DO:
           ASSIGN p-erro = YES.
    END. 
    ELSE IF CAN-FIND(FIRST split-operac NO-LOCK WHERE 
                           split-operac.gm-codigo = p-gm-codigo       AND
                           split-operac.cod-area-produc = p-cod-area-produc AND 
                          (split-operac.ind-estado-split = 1 OR
                           split-operac.ind-estado-split = 2 OR
                           split-operac.ind-estado-split = 3 OR
                           split-operac.ind-estado-split = 4))  THEN DO: 

           IF CAN-FIND (FIRST area-produc-ctrab USE-INDEX grp-maq WHERE 
                              area-produc-ctrab.gm-codigo       = p-gm-codigo       AND
                              area-produc-ctrab.cod-area-produc = p-cod-area-produc AND
                              area-produc-ctrab.cod-ctrab      <> p-cod-ctrab       AND
                              area-produc-ctrab.dat-inic-valid <= p-dat-refer       AND
                              area-produc-ctrab.dat-fim-valid   > p-dat-refer) THEN 
               ASSIGN p-erro = NO.
           ELSE 
               ASSIGN p-erro = YES.
    END.
END PROCEDURE.

PROCEDURE filtraReferenciaTTSplitOperac:
    def INPUT-OUTPUT parameter table for tt-split-operac.

    FOR EACH tt-split-operac:
        
        IF tt-split-operac.it-codigo < c-item-ini 
        OR tt-split-operac.it-codigo > c-item-fim THEN 
            DELETE tt-split-operac.

        IF tt-split-operac.nr-ord-produ > 0 THEN DO:
            FIND first ord-prod NO-LOCK
                where ord-prod.nr-ord-produ   = tt-split-operac.nr-ord-produ NO-ERROR.
            IF AVAIL ord-prod THEN 
                IF  ord-prod.cod-refer     < c-refer-ini
                OR  ord-prod.cod-refer     > c-refer-fim THEN 
                    DELETE tt-split-operac.
        END.
        /*Elimina conforme referencias enviadas pelo setconstraint7*/

    END.

END PROCEDURE.

PROCEDURE piCalculaRedePert:
    DEF INPUT PARAMETER pNrOrdProdu AS INTEGER               NO-UNDO.
    DEF INPUT PARAMETER pDtIMC      AS DATE                  NO-UNDO.
    DEF INPUT PARAMETER pQtdSegIMC  LIKE op-sfc.qtd-segs-imc NO-UNDO.  
    DEF INPUT PARAMETER pDtFMT      AS DATE                  NO-UNDO.
    DEF INPUT PARAMETER pQtdSegFMT  LIKE op-sfc.qtd-segs-imc NO-UNDO.  
    DEF OUTPUT PARAMETER TABLE FOR tt-split-operac.

    ASSIGN l-piCalculaRedePert = YES.

    EMPTY TEMP-TABLE tt-split-operac.

    IF NOT VALID-HANDLE(h-boin469e) THEN
        RUN inbo/boin469e.p PERSISTENT SET h-boin469e.
    
    /*Busca a Ordem do Ch∆o de Fabrica*/
    FIND op-sfc NO-LOCK
        WHERE op-sfc.nr-ord-produ = pNrOrdProdu NO-ERROR.

    RUN piCriaSplits.
    
    IF pDtFMT <> ? THEN
        RUN piCalculoRedePertBackward.
    IF pDtIMC <> ? THEN
        RUN piCalculoRedePertForward.
    
    ASSIGN l-piCalculaRedePert = NO.
    delete procedure h-boin469e.
END.

PROCEDURE piCriaSplits:

    DEFINE VARIABLE de-fator AS DECIMAL    NO-UNDO.


    EMPTY TEMP-TABLE tt-split-operac.

    FOR EACH split-operac OF op-sfc NO-LOCK:
        CREATE tt-split-operac.
        BUFFER-COPY split-operac TO tt-split-operac.
        ASSIGN /*Fim Mais Tarde*/
               tt-split-operac.dat-fmt       = op-sfc.dat-fmt
               tt-split-operac.qtd-segs-fmt  = op-sfc.qtd-segs-fmt
               tt-split-operac.dat-imt       = ?
               tt-split-operac.qtd-segs-imt  = ?
               /*Inicio Mais Cedo*/
               tt-split-operac.dat-imc       = op-sfc.dat-imc
               tt-split-operac.qtd-segs-imc  = op-sfc.qtd-segs-imc
               tt-split-operac.dat-fmc       = ?
               tt-split-operac.qtd-segs-fmc  = ?
               /*Variavel de Controle Overlap e Transporte*/
               tt-split-operac.tempo-pad-mod = 0.
    END.

    FOR EACH oper-ord OF op-sfc NO-LOCK:
        find grup-maquina 
            WHERE grup-maquina.gm-codigo = oper-ord.gm-codigo no-lock no-error.

        FIND FIRST bf-tt-split-operac 
            WHERE bf-tt-split-operac.nr-ord-produ = oper-ord.nr-ord-produ
              AND bf-tt-split-operac.it-codigo    = oper-ord.it-codigo   
              AND bf-tt-split-operac.cod-roteiro  = oper-ord.cod-roteiro 
              AND bf-tt-split-operac.op-codigo    = oper-ord.op-codigo    NO-ERROR.
        IF NOT AVAIL bf-tt-split-operac THEN DO:
            case oper-ord.un-med-tempo:
                when 1 then
                    assign de-fator = 3600.
                when 2 then
                    assign de-fator = 60.
                when 3 then
                    assign de-fator = 1.
                when 4 then
                    assign de-fator = 86400.
            end case.

            CREATE bf-tt-split-operac.
            ASSIGN bf-tt-split-operac.nr-ord-produ         = oper-ord.nr-ord-produ
                   bf-tt-split-operac.num-operac-sfc       = oper-ord.num-operac-sfc
                   bf-tt-split-operac.it-codigo            = oper-ord.it-codigo   
                   bf-tt-split-operac.cod-roteiro          = oper-ord.cod-roteiro 
                   bf-tt-split-operac.op-codigo            = oper-ord.op-codigo   
                   /*Fim Mais Tarde*/
                   bf-tt-split-operac.dat-fmt              = op-sfc.dat-fmt        
                   bf-tt-split-operac.qtd-segs-fmt         = op-sfc.qtd-segs-fmt   
                   bf-tt-split-operac.dat-imt              = ?                     
                   bf-tt-split-operac.qtd-segs-imt         = ?
                   /*Inicio Mais Cedo*/
                   bf-tt-split-operac.dat-imc              = op-sfc.dat-imc
                   bf-tt-split-operac.qtd-segs-imc         = op-sfc.qtd-segs-imc
                   bf-tt-split-operac.dat-fmc              = ?
                   bf-tt-split-operac.qtd-segs-fmc         = ?
                   /*Tempos Padroes*/
                   bf-tt-split-operac.tempo-pad-maq        = oper-ord.tempo-maquin         * de-fator
                   bf-tt-split-operac.tempo-pad-mod        = oper-ord.tempo-homem          * de-fator
                   bf-tt-split-operac.tempo-pad-pos-operac = oper-ord.qtd-tempo-pos-proces * de-fator
                   bf-tt-split-operac.tempo-pad-setup      = oper-ord.tempo-prepar         * de-fator
                   bf-tt-split-operac.tempo-pad-carga      = bf-tt-split-operac.tempo-pad-maq + bf-tt-split-operac.tempo-pad-setup
                   bf-tt-split-operac.qtd-capac-operac     = oper-ord.qtd-capac-operac
                   bf-tt-split-operac.tempo-pad-operac     = IF NOT AVAIL grup-maquina THEN MAX(bf-tt-split-operac.tempo-pad-mod,
                                                                                                bf-tt-split-operac.tempo-pad-maq)
                                                             ELSE
                                                             if grup-maquina.ind-tip-ctrab = 4 then
                                                             bf-tt-split-operac.tempo-pad-mod else 
                                                             bf-tt-split-operac.tempo-pad-maq
                   bf-tt-split-operac.qtd-carga-batch      = oper-ord.qtd-carga-batch
                   /*Variavel de Controle Overlap e Transporte*/
                   bf-tt-split-operac.tempo-pad-mod        = 0.
        END.
    END.
END.

PROCEDURE piCalculoRedePertBackward:

    IF NOT VALID-HANDLE(h-boin469e) THEN
        RUN inbo/boin469e.p PERSISTENT SET h-boin469e.

    REPEAT:
        IF NOT CAN-FIND(FIRST tt-split-operac WHERE tt-split-operac.dat-imt = ?) THEN LEAVE.
        FOR EACH tt-split-operac:

            ASSIGN d-dat-data-aux = tt-split-operac.dat-fmt
                   i-qtd-segs-aux = tt-split-operac.qtd-segs-fmt.
            
            FOR EACH pert-ordem NO-LOCK
                WHERE pert-ordem.nr-ord-produ = tt-split-operac.nr-ord-produ
                  AND pert-ordem.it-predec    = tt-split-operac.it-codigo
                  AND pert-ordem.rot-predec   = tt-split-operac.cod-roteiro
                  AND pert-ordem.op-predec    = tt-split-operac.op-codigo:
                FIND bf-tt-split-operac 
                    WHERE bf-tt-split-operac.nr-ord-produ = pert-ordem.nr-ord-produ
                      AND bf-tt-split-operac.it-codigo    = pert-ordem.it-codigo   
                      AND bf-tt-split-operac.cod-roteiro  = pert-ordem.cod-roteiro 
                      AND bf-tt-split-operac.op-codigo    = pert-ordem.op-codigo    NO-ERROR.
                IF NOT AVAIL bf-tt-split-operac THEN NEXT.

                IF bf-tt-split-operac.dat-imt <> ? AND 
                   ((d-dat-data-aux > bf-tt-split-operac.dat-imt) OR 
                    (d-dat-data-aux = bf-tt-split-operac.dat-imt AND i-qtd-segs-aux > bf-tt-split-operac.qtd-segs-imt)) THEN
                    ASSIGN d-dat-data-aux = bf-tt-split-operac.dat-imt
                           i-qtd-segs-aux = bf-tt-split-operac.qtd-segs-imt.

                IF bf-tt-split-operac.dat-imt = ? THEN
                    ASSIGN d-dat-data-aux = ?
                           i-qtd-segs-aux = ?.
            END.

            IF d-dat-data-aux <> ? AND tt-split-operac.dat-imt = ? THEN DO:
                ASSIGN tt-split-operac.dat-fmt      = d-dat-data-aux
                       tt-split-operac.qtd-segs-fmt = i-qtd-segs-aux
                       tt-split-operac.dat-imt      = ?
                       tt-split-operac.qtd-segs-imt = ?
                       de-tempo-aux                 = IF tt-split-operac.tempo-pad-mod <> 0 THEN 
                                                      tt-split-operac.tempo-pad-mod / 3600
                                                      ELSE
                                                      (tt-split-operac.tempo-pad-setup + tt-split-operac.tempo-pad-operac +
                                                       tt-split-operac.tempo-pad-pos-operac) / 3600
                       c-cod-area                   = ?
                       c-cod-calend                 = ?.

                IF tt-split-operac.gm-codigo <> "" OR tt-split-operac.cod-ctrab <> "" THEN DO:
                    Run piCalculaDataHoraTempo IN h-boin469e
                                              (INPUT        c-cod-area,
                                               INPUT        tt-split-operac.gm-codigo,
                                               INPUT        tt-split-operac.cod-ctrab,
                                               INPUT        c-cod-calend,
                                               INPUT-OUTPUT tt-split-operac.dat-fmt,
                                               INPUT-OUTPUT tt-split-operac.qtd-segs-fmt,
                                               INPUT-OUTPUT tt-split-operac.dat-imt,
                                               INPUT-OUTPUT tt-split-operac.qtd-segs-imt,
                                               INPUT-OUTPUT de-tempo-aux,
                                               INPUT        l-cons-parada-prog,
                                               INPUT        l-cons-parada-real,
                                               INPUT        d-dat-corte-parada,     
                                               INPUT        i-qtd-segs-corte-parada).

                    IF tt-split-operac.tempo-pad-mod <> 0 THEN DO:
                        ASSIGN tt-split-operac.dat-fmt      = ?
                               tt-split-operac.qtd-segs-fmt = ?
                               de-tempo-aux                 = (tt-split-operac.tempo-pad-setup + tt-split-operac.tempo-pad-operac +
                                                               tt-split-operac.tempo-pad-pos-operac) / 3600.

                        Run piCalculaDataHoraTempo IN h-boin469e
                                                  (INPUT        c-cod-area,
                                                   INPUT        tt-split-operac.gm-codigo,
                                                   INPUT        tt-split-operac.cod-ctrab,
                                                   INPUT        c-cod-calend,
                                                   INPUT-OUTPUT tt-split-operac.dat-fmt,
                                                   INPUT-OUTPUT tt-split-operac.qtd-segs-fmt,
                                                   INPUT-OUTPUT tt-split-operac.dat-imt,
                                                   INPUT-OUTPUT tt-split-operac.qtd-segs-imt,
                                                   INPUT-OUTPUT de-tempo-aux,
                                                   INPUT        l-cons-parada-prog,
                                                   INPUT        l-cons-parada-real,
                                                   INPUT        d-dat-corte-parada,     
                                                   INPUT        i-qtd-segs-corte-parada).

                    END.
                END.
                ELSE DO: /*A Data de Inicio dever† ser descontado tempo corrido, Operaá∆o externa*/
                    ASSIGN de-tempo-aux                 = TRUNCATE((tt-split-operac.tempo-pad-pos-operac +
                                                                    tt-split-operac.tempo-pad-setup      +
                                                                    tt-split-operac.tempo-pad-operac) / 86400,0)
                           tt-split-operac.dat-imt      = tt-split-operac.dat-fmt - de-tempo-aux
                           de-tempo-aux                 = (tt-split-operac.tempo-pad-pos-operac +
                                                           tt-split-operac.tempo-pad-setup      +
                                                           tt-split-operac.tempo-pad-operac) MOD 86400
                           tt-split-operac.qtd-segs-imt = tt-split-operac.qtd-segs-fmt - de-tempo-aux.
                    IF tt-split-operac.qtd-segs-imt < 0 THEN
                        ASSIGN tt-split-operac.dat-imt      = tt-split-operac.dat-imt - 1
                               tt-split-operac.qtd-segs-imt = 86400 + tt-split-operac.qtd-segs-imt.
                    
                    /*Ajuste de Data e Hora, pois s∆o horas corridas e podem cair em um fim de 
                      semana ou num periodo que n∆o seja de produá∆o*/
                    ASSIGN d-dat-data-aux = ?
                           i-qtd-segs-aux = ?
                           de-tempo-aux   = 0.2 / 3600. /*Menos de um Segundo*/.
                    
                    Run piCalculaDataHoraTempo IN h-boin469e
                                              (INPUT        ?,
                                               INPUT        ?,
                                               INPUT        ?,
                                               INPUT        ?,
                                               INPUT-OUTPUT tt-split-operac.dat-imt,     
                                               INPUT-OUTPUT tt-split-operac.qtd-segs-imt,
                                               INPUT-OUTPUT d-dat-data-aux,   
                                               INPUT-OUTPUT i-qtd-segs-aux,   
                                               INPUT-OUTPUT de-tempo-aux,
                                               INPUT        l-cons-parada-prog,
                                               INPUT        l-cons-parada-real,
                                               INPUT        d-dat-corte-parada,     
                                               INPUT        i-qtd-segs-corte-parada).

                    ASSIGN tt-split-operac.dat-imt      = d-dat-data-aux              
                           tt-split-operac.qtd-segs-imt = i-qtd-segs-aux.
                END.

                FOR EACH pert-ordem NO-LOCK
                    WHERE pert-ordem.nr-ord-produ = tt-split-operac.nr-ord-produ
                      AND pert-ordem.it-codigo    = tt-split-operac.it-codigo
                      AND pert-ordem.cod-roteiro  = tt-split-operac.cod-roteiro
                      AND pert-ordem.op-codigo    = tt-split-operac.op-codigo:
                    FIND bf-tt-split-operac 
                        WHERE bf-tt-split-operac.nr-ord-produ = pert-ordem.nr-ord-produ
                          AND bf-tt-split-operac.it-codigo    = pert-ordem.it-predec
                          AND bf-tt-split-operac.cod-roteiro  = pert-ordem.rot-predec
                          AND bf-tt-split-operac.op-codigo    = pert-ordem.op-predec     NO-ERROR.
                    IF NOT AVAIL bf-tt-split-operac THEN NEXT.
                    
                    ASSIGN bf-tt-split-operac.dat-fmt      = tt-split-operac.dat-imt
                           bf-tt-split-operac.qtd-segs-fmt = tt-split-operac.qtd-segs-imt.

                    IF pert-ordem.overlap <> 0 OR pert-ordem.transporte <> 0 THEN
                    DO: /*Calcula Overlap e tempo de transporte*/
                        ASSIGN d-dat-data-aux = ?
                               i-qtd-segs-aux = ?
                               de-tempo-aux   = (bf-tt-split-operac.tempo-pad-setup + bf-tt-split-operac.tempo-pad-operac + 
                                                 bf-tt-split-operac.tempo-pad-pos-operac) / 3600
                               de-tempo-aux   = de-tempo-aux * (100 - pert-ordem.overlap) / 100
                               de-tempo-aux   = de-tempo-aux + pert-ordem.transporte.
                        /*Campo auxiliar usado para armazenar tempo diferente de processamento 
                          para considerar overlap e tempo de transporte*/
                        IF bf-tt-split-operac.tempo-pad-mod < de-tempo-aux * 3600 THEN
                            ASSIGN bf-tt-split-operac.tempo-pad-mod = de-tempo-aux * 3600.
                    END.
                END.
            END.
        END.
    END.

    IF l-piCalculaRedePert = NO AND VALID-HANDLE(h-boin469e) THEN
        DELETE PROCEDURE h-boin469e.  
END.

PROCEDURE piCalculoRedePertForward:

    IF NOT VALID-HANDLE(h-boin469e) THEN
        RUN inbo/boin469e.p PERSISTENT SET h-boin469e.

    REPEAT:
        IF NOT CAN-FIND(FIRST tt-split-operac WHERE tt-split-operac.dat-fmc = ?) THEN LEAVE.
        FOR EACH tt-split-operac:

            ASSIGN d-dat-data-aux = tt-split-operac.dat-imc
                   i-qtd-segs-aux = tt-split-operac.qtd-segs-imc.
            
            FOR EACH pert-ordem NO-LOCK
                WHERE pert-ordem.nr-ord-produ = tt-split-operac.nr-ord-produ
                  AND pert-ordem.it-codigo    = tt-split-operac.it-codigo
                  AND pert-ordem.cod-roteiro  = tt-split-operac.cod-roteiro
                  AND pert-ordem.op-codigo    = tt-split-operac.op-codigo:
                FIND bf-tt-split-operac 
                    WHERE bf-tt-split-operac.nr-ord-produ = pert-ordem.nr-ord-produ
                      AND bf-tt-split-operac.it-codigo    = pert-ordem.it-predec   
                      AND bf-tt-split-operac.cod-roteiro  = pert-ordem.rot-predec  
                      AND bf-tt-split-operac.op-codigo    = pert-ordem.op-predec    NO-ERROR.
                IF NOT AVAIL bf-tt-split-operac THEN NEXT.

                IF bf-tt-split-operac.dat-fmc <> ? AND 
                   ((d-dat-data-aux < bf-tt-split-operac.dat-fmc) OR 
                    (d-dat-data-aux = bf-tt-split-operac.dat-fmc AND i-qtd-segs-aux < bf-tt-split-operac.qtd-segs-fmc)) THEN
                    ASSIGN d-dat-data-aux = bf-tt-split-operac.dat-fmc
                           i-qtd-segs-aux = bf-tt-split-operac.qtd-segs-fmc.

                IF bf-tt-split-operac.dat-fmc = ? THEN
                    ASSIGN d-dat-data-aux = ?
                           i-qtd-segs-aux = ?.
            END.

            IF d-dat-data-aux <> ? AND tt-split-operac.dat-fmc = ? THEN DO:
                ASSIGN tt-split-operac.dat-imc      = d-dat-data-aux
                       tt-split-operac.qtd-segs-imc = i-qtd-segs-aux
                       tt-split-operac.dat-fmc      = ?
                       tt-split-operac.qtd-segs-fmc = ?
                       de-tempo-aux                 = IF tt-split-operac.tempo-pad-mod <> 0 THEN 
                                                      tt-split-operac.tempo-pad-mod / 3600
                                                      ELSE
                                                      (tt-split-operac.tempo-pad-setup + tt-split-operac.tempo-pad-operac +
                                                       tt-split-operac.tempo-pad-pos-operac) / 3600
                       c-cod-area                   = ?
                       c-cod-calend                 = ?.

                IF tt-split-operac.gm-codigo <> "" OR tt-split-operac.cod-ctrab <> "" THEN DO:
                    Run piCalculaDataHoraTempo IN h-boin469e
                                              (INPUT        c-cod-area,
                                               INPUT        tt-split-operac.gm-codigo,
                                               INPUT        tt-split-operac.cod-ctrab,
                                               INPUT        c-cod-calend,
                                               INPUT-OUTPUT tt-split-operac.dat-fmc,
                                               INPUT-OUTPUT tt-split-operac.qtd-segs-fmc,
                                               INPUT-OUTPUT tt-split-operac.dat-imc,
                                               INPUT-OUTPUT tt-split-operac.qtd-segs-imc,
                                               INPUT-OUTPUT de-tempo-aux,
                                               INPUT        l-cons-parada-prog,
                                               INPUT        l-cons-parada-real,
                                               INPUT        d-dat-corte-parada,     
                                               INPUT        i-qtd-segs-corte-parada).

                    IF tt-split-operac.tempo-pad-mod <> 0 THEN DO:
                        ASSIGN tt-split-operac.dat-imc      = ?
                               tt-split-operac.qtd-segs-imc = ?
                               de-tempo-aux                 = (tt-split-operac.tempo-pad-setup + tt-split-operac.tempo-pad-operac +
                                                               tt-split-operac.tempo-pad-pos-operac) / 3600.

                        Run piCalculaDataHoraTempo IN h-boin469e
                                                  (INPUT        c-cod-area,
                                                   INPUT        tt-split-operac.gm-codigo,
                                                   INPUT        tt-split-operac.cod-ctrab,
                                                   INPUT        c-cod-calend,
                                                   INPUT-OUTPUT tt-split-operac.dat-fmc,
                                                   INPUT-OUTPUT tt-split-operac.qtd-segs-fmc,
                                                   INPUT-OUTPUT tt-split-operac.dat-imc,
                                                   INPUT-OUTPUT tt-split-operac.qtd-segs-imc,
                                                   INPUT-OUTPUT de-tempo-aux,
                                                   INPUT        l-cons-parada-prog,
                                                   INPUT        l-cons-parada-real,
                                                   INPUT        d-dat-corte-parada,     
                                                   INPUT        i-qtd-segs-corte-parada).
                    END.
                END.
                ELSE DO: /*A Data de Inicio dever† ser descontado tempo corrido, Operaá∆o externa*/
                    ASSIGN de-tempo-aux                 = TRUNCATE((tt-split-operac.tempo-pad-pos-operac +
                                                                    tt-split-operac.tempo-pad-setup      +
                                                                    tt-split-operac.tempo-pad-operac) / 86400,0)
                           tt-split-operac.dat-fmc      = tt-split-operac.dat-imc + de-tempo-aux
                           de-tempo-aux                 = (tt-split-operac.tempo-pad-pos-operac +
                                                           tt-split-operac.tempo-pad-setup      +
                                                           tt-split-operac.tempo-pad-operac) MOD 86400
                           tt-split-operac.qtd-segs-fmc = tt-split-operac.qtd-segs-imc + de-tempo-aux.
                    IF tt-split-operac.qtd-segs-fmc > 86400 THEN
                        ASSIGN tt-split-operac.dat-fmc      = tt-split-operac.dat-fmc + 1
                               tt-split-operac.qtd-segs-fmc = tt-split-operac.qtd-segs-fmc MOD 86400.

                    /*Ajuste de Data e Hora, pois s∆o horas corridas e podem cair em um fim de 
                      semana ou num periodo que n∆o seja de produá∆o*/
                    ASSIGN d-dat-data-aux = ?
                           i-qtd-segs-aux = ?
                           de-tempo-aux   = 0.2 / 3600. /*Menos de um Segundo*/
                    
                    Run piCalculaDataHoraTempo IN h-boin469e
                                              (INPUT        ?,
                                               INPUT        ?,
                                               INPUT        ?,
                                               INPUT        ?,
                                               INPUT-OUTPUT d-dat-data-aux,
                                               INPUT-OUTPUT i-qtd-segs-aux,
                                               INPUT-OUTPUT tt-split-operac.dat-fmc,          
                                               INPUT-OUTPUT tt-split-operac.qtd-segs-fmc,     
                                               INPUT-OUTPUT de-tempo-aux,
                                               INPUT        l-cons-parada-prog,
                                               INPUT        l-cons-parada-real,
                                               INPUT        d-dat-corte-parada,     
                                               INPUT        i-qtd-segs-corte-parada).

                    ASSIGN tt-split-operac.dat-fmc      = d-dat-data-aux              
                           tt-split-operac.qtd-segs-fmc = i-qtd-segs-aux.

                END.

                FOR EACH pert-ordem NO-LOCK
                    WHERE pert-ordem.nr-ord-produ = tt-split-operac.nr-ord-produ
                      AND pert-ordem.it-predec    = tt-split-operac.it-codigo
                      AND pert-ordem.rot-predec   = tt-split-operac.cod-roteiro
                      AND pert-ordem.op-predec    = tt-split-operac.op-codigo:
                    FIND bf-tt-split-operac 
                        WHERE bf-tt-split-operac.nr-ord-produ = pert-ordem.nr-ord-produ
                          AND bf-tt-split-operac.it-codigo    = pert-ordem.it-codigo   
                          AND bf-tt-split-operac.cod-roteiro  = pert-ordem.cod-roteiro 
                          AND bf-tt-split-operac.op-codigo    = pert-ordem.op-codigo     NO-ERROR.
                    IF NOT AVAIL bf-tt-split-operac THEN NEXT.
                    
                    ASSIGN bf-tt-split-operac.dat-imc      = tt-split-operac.dat-fmc
                           bf-tt-split-operac.qtd-segs-imc = tt-split-operac.qtd-segs-fmc.

                    IF pert-ordem.overlap <> 0 OR pert-ordem.transporte <> 0 THEN
                    DO: /*Calcula Overlap e tempo de transporte*/
                        ASSIGN d-dat-data-aux = ?
                               i-qtd-segs-aux = ?
                               de-tempo-aux   = (bf-tt-split-operac.tempo-pad-setup + bf-tt-split-operac.tempo-pad-operac + 
                                                 bf-tt-split-operac.tempo-pad-pos-operac) / 3600
                               de-tempo-aux   = de-tempo-aux * (100 - pert-ordem.overlap) / 100
                               de-tempo-aux   = de-tempo-aux + pert-ordem.transporte.
                        /*Campo auxiliar usado para armazenar tempo diferente de processamento 
                          para considerar overlap e tempo de transporte*/
                        IF bf-tt-split-operac.tempo-pad-mod < de-tempo-aux * 3600 THEN
                            ASSIGN bf-tt-split-operac.tempo-pad-mod = de-tempo-aux * 3600.
                    END.
                END.
            END.
        END.
    END.

    IF l-piCalculaRedePert = NO AND VALID-HANDLE(h-boin469e) THEN
        DELETE PROCEDURE h-boin469e.    
END.


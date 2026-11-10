/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX150B 2.00.00.006} /*** "010006" 07/10/2024 16:59:54 ***/
/*******************************************************************************
**
**  BOCX150B.P
**
**  historico-proc-imp - Historico dos processos
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY tt-historico
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-historico

{include/boini.i}
{cxbo/bocx150.i RowObject}
{cxbo/bocx150.i tt-historico}
{cxbo/bocx150.i tt-historico-tmp}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

DEFINE TEMP-TABLE tt-hist-proc no-undo
    field i-sequencia as integer
    field r-hist  as rowid 
    index codigo is unique primary
        i-sequencia.        

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

DEFINE BUFFER b-historico-proc-imp FOR historico-proc-imp.

DEFINE BUFFER b-processo-imp FOR processo-imp.

DEFINE BUFFER b-itinerario FOR itinerario.

&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN    
    {cxbo/bocx351.i tt-licenciam-import-oc}
&ENDIF


def var c-nr-proc-imp     as char no-undo. 
def var i-cod-itiner      as integer no-undo.
def var c-cod-pto-contr   as integer no-undo.
def var c-nr-proc-imp-fim as char    initial "ZZZZZZZZZZZZZZZZZ" no-undo. /* formato maior que o do campo nr-proc-imp */
def var i-cod-itiner-fim  as integer initial 999.999             no-undo. /* formato maior que o do campo cod-itiner  */

def var i-sit-ini         as integer no-undo.
def var i-sit-fim         as integer no-undo.
def var c-proc-aux-ini    as char    no-undo.
def var c-proc-aux-fim    as char    no-undo.
def var i-it-aux-ini      as integer no-undo.
def var i-it-aux-fim      as integer no-undo.

def var i-atraso          as integer no-undo init 1.
def var i-situacao        as integer no-undo init 1. /* verificar como serÿ feito o todos */
def var da-data-ini       as date    no-undo init &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
def var da-data-fim       as date    no-undo init 12/31/9999.
def var c-est-ini         as char    no-undo init "".
&IF "{&mguni_version}" >= "2.071" &THEN
def var c-est-fim         as char    no-undo init "ZZZZZ".
&ELSE
def var c-est-fim         as char    no-undo init "zzz".
&ENDIF
def var c-proc-ini        as char    no-undo init "".
def var c-proc-fim        as char    no-undo init "zzzzzzzzzzzz".
def var i-exp-ini         as integer no-undo init 0.
def var i-exp-fim         as integer no-undo init 999999999.
def var i-itiner-ini      as integer no-undo init 0.
def var i-itiner-fim      as integer no-undo init 99999.
def var i-pto-emb-ini     as integer no-undo init 0.
def var i-pto-emb-fim     as integer no-undo init 99999.
def var i-pto-des-ini     as integer no-undo init 0.
def var i-pto-des-fim     as integer no-undo init 99999.
def var i-local           as integer no-undo init 0.
def var i-grupo-ini       as integer no-undo init 0.
def var i-grupo-fim       as integer no-undo init 99.
def var c-fam-ini         as char    no-undo init "".
def var c-fam-fim         as char no-undo init "zzzzzzzz".
def var c-item-ini        like item.it-codigo.
def var c-item-fim        like item.it-codigo.
def var l-li-ok           as logical no-undo.

procedure setConstraint1:
end procedure. 

procedure setConstraint2:
def input parameter p-atraso      as integer no-undo.
def input parameter p-situacao    as integer no-undo.
def input parameter p-data-ini    as date    no-undo.
def input parameter p-data-fim    as date    no-undo.
def input parameter p-est-ini     as char    no-undo.
def input parameter p-est-fim     as char    no-undo.
def input parameter p-proc-ini    as char    no-undo.
def input parameter p-proc-fim    as char    no-undo.
def input parameter p-exp-ini     as integer no-undo.
def input parameter p-exp-fim     as integer no-undo.
def input parameter p-itiner-ini  as integer no-undo.
def input parameter p-itiner-fim  as integer no-undo.
def input parameter p-pto-emb-ini as integer no-undo.
def input parameter p-pto-emb-fim as integer no-undo.
def input parameter p-pto-des-ini as integer no-undo.
def input parameter p-pto-des-fim as integer no-undo.
def input parameter p-local       as integer no-undo.
def input parameter p-grupo-ini   as integer no-undo.
def input parameter p-grupo-fim   as integer no-undo.
def input parameter p-fam-ini     as char    no-undo.
def input parameter p-fam-fim     as char    no-undo.
def input parameter p-item-ini    as char no-undo.
def input parameter p-item-fim    as char no-undo.

assign i-atraso      = p-atraso
       i-situacao    = p-situacao
       da-data-ini   = p-data-ini
       da-data-fim   = p-data-fim
       c-proc-ini    = p-proc-ini
       c-proc-fim    = p-proc-fim
       c-est-ini     = p-est-ini
       c-est-fim     = p-est-fim
       i-exp-ini     = p-exp-ini
       i-exp-fim     = p-exp-fim
       i-itiner-ini  = p-itiner-ini
       i-itiner-fim  = p-itiner-fim
       i-pto-emb-ini = p-pto-emb-ini
       i-pto-emb-fim = p-pto-emb-fim
       i-pto-des-ini = p-pto-des-ini
       i-pto-des-fim = p-pto-des-fim
       i-local       = p-local
       i-grupo-ini   = p-grupo-ini
       i-grupo-fim   = p-grupo-fim
       c-fam-ini     = p-fam-ini
       c-fam-fim     = p-fam-fim
       c-item-ini    = p-item-ini
       c-item-fim    = p-item-fim.

    for each processo-imp where 
             processo-imp.cod-estabel    >= c-est-ini    and
             processo-imp.cod-estabel    <= c-est-fim    and
             processo-imp.nr-proc-imp    >= c-proc-ini   and
             processo-imp.nr-proc-imp    <= c-proc-fim   
             no-lock:

        if i-itiner-ini <> 0 or i-itiner-fim <> 99999 then do:
            if processo-imp.cod-itiner     < i-itiner-ini or
               processo-imp.cod-itiner     > i-itiner-fim then
            next.
        end.          

        if i-exp-ini <> 0 or i-exp-ini <> 999999999 then do:
            if processo-imp.cod-exportador < i-exp-ini or
               processo-imp.cod-exportador > i-exp-fim then
                next.
        end.

        if i-situacao <> 5 then do:
            if processo-imp.situacao <> i-situacao then
                next.
        end.

        if i-pto-emb-ini <> 0     or 
           i-pto-emb-fim <> 99999 or
           i-pto-des-ini <> 0     or
           i-pto-des-fim <> 99999 then do:
            find itinerario 
                where itinerario.cod-itiner = processo-imp.cod-itiner no-lock no-error.
            if avail itinerario then do:
                if itinerario.pto-embarque < i-pto-emb-ini or
                   itinerario.pto-embarque > i-pto-des-ini then
                    next.
                if itinerario.pto-desembarque < i-pto-des-ini or
                   itinerario.pto-desembarque > i-pto-des-fim then
                    next.          
            end.
        end.
        run createTempTable1. /* pelo historico-proc-imp */
    end.    
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                use-index codigo.
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
{include/boprebro.i}

procedure validateParametros:
    def input parameter p-data-ini    as char    no-undo.
    def input parameter p-data-fim    as char    no-undo.
    def input parameter p-est-ini     as char    no-undo.
    def input parameter p-est-fim     as char    no-undo.
    def input parameter p-proc-ini    as char    no-undo.
    def input parameter p-proc-fim    as char    no-undo.
    def input parameter p-exp-ini     as char    no-undo.
    def input parameter p-exp-fim     as char    no-undo.
    def input parameter p-itiner-ini  as char    no-undo.
    def input parameter p-itiner-fim  as char    no-undo.
    def input parameter p-pto-emb-ini as char    no-undo.
    def input parameter p-pto-emb-fim as char    no-undo.
    def input parameter p-pto-des-ini as char    no-undo.
    def input parameter p-pto-des-fim as char    no-undo.
    def input parameter p-local       as char    no-undo.
    def input parameter p-grupo-ini   as char    no-undo.
    def input parameter p-grupo-fim   as char    no-undo.
    def input parameter p-fam-ini     as char    no-undo.
    def input parameter p-fam-fim     as char    no-undo.
    def input parameter p-item-ini    as char    no-undo.
    def input parameter p-item-fim    as char    no-undo.
    def output parameter table for tt-bo-erro.
    

def var i-teste as integer no-undo.
    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.
if  p-est-ini > p-est-fim then do:
    assign i-seq-erro = i-seq-erro + 1.
    {utp/ut-field.i mgadm estabelec cod-estabel 1}
    /* inicial maior que final */
    run utp/ut-msgs.p (input "msg",
                       input 142,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen = i-seq-erro
           tt-bo-erro.cd-erro  = 142
           tt-bo-erro.mensagem = return-value.
end.           

if  p-data-ini > p-data-fim then do:
    assign i-seq-erro = i-seq-erro + 1.
    {utp/ut-liter.i Data_Chegada *}
    /* inicial maior que final */
    run utp/ut-msgs.p (input "msg",
                       input 142,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen = i-seq-erro
           tt-bo-erro.cd-erro  = 142
           tt-bo-erro.mensagem = return-value.
end.

if  p-proc-ini > p-proc-fim then do:
    assign i-seq-erro = i-seq-erro + 1.
    {utp/ut-field.i mgcex processo-imp nr-proc-imp 1}
    /* inicial maior que final */
    run utp/ut-msgs.p (input "msg",
                       input 142,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen = i-seq-erro
           tt-bo-erro.cd-erro  = 142
           tt-bo-erro.mensagem = return-value.
end.

assign i-teste = int(p-exp-ini) no-error.
if  error-status:error then do:
    assign i-seq-erro = i-seq-erro + 1
           p-exp-ini = "0".
    {utp/ut-liter.i Fornecedor_inicial}       
    run utp/ut-msgs.p (input "msg",
                       input 16963,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen     = i-seq-erro
           tt-bo-erro.cd-erro      = 16963
           tt-bo-erro.mensagem     = return-value.
end.

assign i-teste = int(p-exp-fim) no-error.
if  error-status:error then do:
    assign i-seq-erro = i-seq-erro + 1
           p-exp-fim = "0".
   {utp/ut-liter.i Fornecedor_final}
    run utp/ut-msgs.p (input "msg",
                       input 16963,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen     = i-seq-erro
           tt-bo-erro.cd-erro      = 16963
           tt-bo-erro.mensagem     = return-value.
end.

if  p-exp-ini > p-exp-fim then do:
    assign i-seq-erro = i-seq-erro + 1.
    {utp/ut-liter.i Fornecedor *}
    /* inicial maior que final */
    run utp/ut-msgs.p (input "msg",
                       input 142,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen = i-seq-erro
           tt-bo-erro.cd-erro  = 142
           tt-bo-erro.mensagem = return-value.
end.

assign i-teste = int(p-itiner-ini) no-error.
if  error-status:error then do:
    assign i-seq-erro = i-seq-erro + 1
           p-itiner-ini = "0".
   {utp/ut-liter.i Itinerÿrio_inicial}
    run utp/ut-msgs.p (input "msg",
                       input 16963,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen     = i-seq-erro
           tt-bo-erro.cd-erro      = 16963
           tt-bo-erro.mensagem     = return-value.
end.

assign i-teste = int(p-itiner-fim) no-error.
if  error-status:error then do:
    assign i-seq-erro = i-seq-erro + 1
           p-itiner-fim = "0".
   {utp/ut-liter.i Itinerÿrio_final}
    run utp/ut-msgs.p (input "msg",
                       input 16963,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen     = i-seq-erro
           tt-bo-erro.cd-erro      = 16963
           tt-bo-erro.mensagem     = return-value.
end.

if  p-itiner-ini > p-itiner-fim then do:
    assign i-seq-erro = i-seq-erro + 1.
    {utp/ut-field.i mgcex processo-imp cod-itiner 1}
    /* inicial maior que final */
    run utp/ut-msgs.p (input "msg",
                       input 142,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen = i-seq-erro
           tt-bo-erro.cd-erro  = 142
           tt-bo-erro.mensagem = return-value.
end.

assign i-teste = int(p-pto-emb-ini) no-error.
if  error-status:error then do:
    assign i-seq-erro = i-seq-erro + 1
           p-pto-emb-ini = "0".
   {utp/ut-liter.i Pto_Emb_inicial}
    run utp/ut-msgs.p (input "msg",
                       input 16963,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen     = i-seq-erro
           tt-bo-erro.cd-erro      = 16963
           tt-bo-erro.mensagem     = return-value.
end.

assign i-teste = int(p-pto-emb-fim) no-error.
if  error-status:error then do:
    assign i-seq-erro = i-seq-erro + 1
           p-pto-emb-fim = "0".
   {utp/ut-liter.i Pto_Emb_final}
    run utp/ut-msgs.p (input "msg",
                       input 16963,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen     = i-seq-erro
           tt-bo-erro.cd-erro      = 16963
           tt-bo-erro.mensagem     = return-value.
end.

if  p-pto-emb-ini > p-pto-emb-fim then do:
    assign i-seq-erro = i-seq-erro + 1.
    {utp/ut-field.i mgcex itinerario pto-embarque 1}
    /* inicial maior que final */
    run utp/ut-msgs.p (input "msg",
                       input 142,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen = i-seq-erro
           tt-bo-erro.cd-erro  = 142
           tt-bo-erro.mensagem = return-value.
end.

assign i-teste = int(p-pto-des-ini) no-error.
if  error-status:error then do:
    assign i-seq-erro = i-seq-erro + 1
           p-pto-des-ini = "0".
   {utp/ut-liter.i Pto_Desemb_inicial}
    run utp/ut-msgs.p (input "msg",
                       input 16963,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen     = i-seq-erro
           tt-bo-erro.cd-erro      = 16963
           tt-bo-erro.mensagem     = return-value.
end.

assign i-teste = int(p-pto-des-fim) no-error.
if  error-status:error then do:
    assign i-seq-erro = i-seq-erro + 1
           p-pto-emb-fim = "0".
   {utp/ut-liter.i Pto_Desemb_final}
    run utp/ut-msgs.p (input "msg",
                       input 16963,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen     = i-seq-erro
           tt-bo-erro.cd-erro      = 16963
           tt-bo-erro.mensagem     = return-value.
end.

if  p-pto-des-ini > p-pto-des-fim then do:
    assign i-seq-erro = i-seq-erro + 1.
    {utp/ut-field.i mgcex itinerario pto-desembarque 1}
    /* inicial maior que final */
    run utp/ut-msgs.p (input "msg",
                       input 142,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen = i-seq-erro
           tt-bo-erro.cd-erro  = 142
           tt-bo-erro.mensagem = return-value.
end.

assign i-teste = int(p-grupo-ini) no-error.
if  error-status:error then do:
    assign i-seq-erro = i-seq-erro + 1
           p-grupo-ini = "0".
   {utp/ut-liter.i Grupo_Est_inicial}
    run utp/ut-msgs.p (input "msg",
                       input 16963,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen     = i-seq-erro
           tt-bo-erro.cd-erro      = 16963
           tt-bo-erro.mensagem     = return-value.
end.

assign i-teste = int(p-grupo-fim) no-error.
if  error-status:error then do:
    assign i-seq-erro = i-seq-erro + 1
           p-grupo-fim = "0".
   {utp/ut-liter.i Grupo_Est_final}
    run utp/ut-msgs.p (input "msg",
                       input 16963,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen     = i-seq-erro
           tt-bo-erro.cd-erro      = 16963
           tt-bo-erro.mensagem     = return-value.
end.

if  p-grupo-ini > p-grupo-fim then do:
    assign i-seq-erro = i-seq-erro + 1.
    {utp/ut-field.i mgind item ge-codigo 1}
    /* inicial maior que final */
    run utp/ut-msgs.p (input "msg",
                       input 142,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen = i-seq-erro
           tt-bo-erro.cd-erro  = 142
           tt-bo-erro.mensagem = return-value.
end.

if  p-fam-ini > p-fam-fim then do:
    assign i-seq-erro = i-seq-erro + 1.
    {utp/ut-field.i mgind item fm-codigo 1}
    /* inicial maior que final */
    run utp/ut-msgs.p (input "msg",
                       input 142,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen = i-seq-erro
           tt-bo-erro.cd-erro  = 142
           tt-bo-erro.mensagem = return-value.
end.

if  p-item-ini > p-item-fim then do:
    assign i-seq-erro = i-seq-erro + 1.
    {utp/ut-field.i mgind item it-codigo 1}
    /* inicial maior que final */
    run utp/ut-msgs.p (input "msg",
                       input 142,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen = i-seq-erro
           tt-bo-erro.cd-erro  = 142
           tt-bo-erro.mensagem = return-value.
end.

assign i-teste = int(p-local) no-error.
if  error-status:error then do:
    assign i-seq-erro = i-seq-erro + 1
           p-local = "0".
   {utp/ut-liter.i Localiza»’o}
    run utp/ut-msgs.p (input "msg",
                       input 16963,
                       input return-value).
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen     = i-seq-erro
           tt-bo-erro.cd-erro      = 16963
           tt-bo-erro.mensagem     = return-value.
end.
if p-local <> "0" then do:
   if not can-find(pto-itiner where 
                   pto-itiner.cod-pto-contr = int(p-local)) then do:
      assign i-seq-erro = i-seq-erro + 1.
     {utp/ut-table.i mgcex pto-contr 1}
      run utp/ut-msgs.p (input "msg",
                         input 2,
                        input return-value).
      create tt-bo-erro.
      assign tt-bo-erro.i-sequen = i-seq-erro
             tt-bo-erro.cd-erro  = 2
             tt-bo-erro.mensagem = return-value.
     end.
  end.  
end procedure.

procedure createTempTable1:
/*
**
** Cria‡Æo temp-table com os valores filtrados pelos parƒmetros.
**
*/    
    def var l-ok    as logical no-undo.
    
    assign l-ok = no.

    find first historico-proc-imp where 
               historico-proc-imp.cod-estabel = processo-imp.cod-estabel and
               historico-proc-imp.nr-proc-imp = processo-imp.nr-proc-imp and 
               historico-proc-imp.cod-itiner  = processo-imp.cod-itiner  
               no-lock no-error.
    if avail historico-proc-imp then do:
        find  last b-historico-proc-imp where 
                   b-historico-proc-imp.cod-estabel   = historico-proc-imp.cod-estabel and
                   b-historico-proc-imp.nr-proc-imp   = historico-proc-imp.nr-proc-imp and
                   b-historico-proc-imp.cod-itiner    = historico-proc-imp.cod-itiner  
                   no-lock no-error.
        if b-historico-proc-imp.dt-efetiva <> ? then do: 
            if b-historico-proc-imp.dt-efetiva < da-data-ini or
               b-historico-proc-imp.dt-efetiva > da-data-fim then
                leave.
            if i-atraso = 1 and
               b-historico-proc-imp.dt-efetiva <= b-historico-proc-imp.dt-previsao then
                leave.                                
            else 
                if i-atraso = 2  and
                   b-historico-proc-imp.dt-efetiva >= b-historico-proc-imp.dt-previsao then
                    leave.       
        end.
        else do:
            if b-historico-proc-imp.dt-ult-previsao < da-data-ini or
                b-historico-proc-imp.dt-ult-previsao > da-data-fim then 
                next.
            if i-atraso = 1 and
               b-historico-proc-imp.dt-ult-previsao <= b-historico-proc-imp.dt-previsao then
                leave.
            else 
                if i-atraso = 2 and
                   b-historico-proc-imp.dt-ult-previsao >= b-historico-proc-imp.dt-previsao then
                    leave.      
        end.        
        if i-local <> 0 then do:     
            find last b-historico-proc-imp where 
                b-historico-proc-imp.cod-estabel = historico-proc-imp.cod-estabel and
                b-historico-proc-imp.nr-proc-imp = historico-proc-imp.nr-proc-imp and
                b-historico-proc-imp.cod-itiner  = historico-proc-imp.cod-itiner  and
                b-historico-proc-imp.dt-efetiva  <> ?                                                    
                no-lock no-error.        
            if avail b-historico-proc-imp then do:
                if b-historico-proc-imp.cod-pto-contr <> i-local then 
                    leave.
            end.
        end. 
        for  each ordem-compra where 
                  ordem-compra.num-pedido  = processo-imp.num-pedido and
                 (ordem-compra.it-codigo  >= c-item-ini              and
                  ordem-compra.it-codigo  <= c-item-fim)
                 no-lock:
             assign l-ok = yes.
             if  i-grupo-ini <> 0  or
                 i-grupo-fim <> 99 or
                 c-fam-ini <> ""   or
                 c-fam-fim <> "zzzzzzzz" then do:     
                find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
                if   avail item then do:
                     if item.ge-codigo < i-grupo-ini or
                        item.ge-codigo > i-grupo-fim then 
                        leave.
                     if item.fm-codigo < c-fam-ini or
                        item.fm-codigo > c-fam-fim then
                        leave.   
                end.
             end.
        end.
        if l-ok then do:
            create tt-historico.
            buffer-copy historico-proc-imp to tt-historico.
            assign tt-historico.r-rowid = rowid(historico-proc-imp).
        end.        
    end.
end procedure.

procedure serverSendRows :
    /*
    **  Disponivel no smart data object da V9, e foi reimplementado dentro
    **  da versao 8. Faz consultas utilizando a querie dentro da smartquery,
    **  possibilitando que clientes WebSpeed acessem esta mesma smart-query
    **  e facilitara a migracao destes programas para os Smart Data Objects.
    */
    define input  parameter piStartRow     as  integer   no-undo.
    define input  parameter pcRowIdent     as  character no-undo.
    define input  parameter plNext         as  logical   no-undo.
    define input  parameter piRowsToReturn as  integer   no-undo.
    define output parameter piRowsReturned as  integer   no-undo.
    define output parameter table          for RowObject.

    define variable hQuery        as handle    no-undo.
    define variable hBuffer       as handle    no-undo.
    define variable hRowObject    as handle    no-undo.
    define variable hDataQuery    as handle    no-undo.
    define variable cRowIdent     as character no-undo.
    define variable rRowIDs       as rowid     extent 10 no-undo.
    define variable lOK           as logical   no-undo.
    define variable iRow          as integer   no-undo.

    for each rowObject:
        delete rowObject.
    end.
    IF true THEN DO:
        IF pcRowIdent NE ? AND pcRowIdent NE "":U THEN DO:
            rRowIDs = ?.
            reposition {&query-name} to rowid to-rowid(pcRowIdent).
            get next {&query-name}.
        END.
        ELSE IF piStartRow NE ? AND piStartRow NE 0 THEN DO:
            REPOSITION  {&query-name} TO ROW piStartRow.

            GET next {&query-name}.
        END.
        IF plNext THEN
            GET next {&query-name}.
        DO WHILE true:
            if available({&first-table-in-query})  and piRowsReturned < piRowsToReturn then do:
                create rowObject.
		  buffer-copy {&table-name} to rowObject.
		  assign rowObject.r-rowid = {&table-name}.r-rowid.
                GET NEXT {&query-name}.
                piRowsReturned = piRowsReturned + 1.
            end.
            else
                leave.
        END.
        IF piRowsReturned > 0 THEN DO:
            {&open-query}
            IF piStartRow = ? OR piStartRow = 0 THEN DO:
                get first {&query-name}.
                get prev {&query-name}.
            END.
            ELSE
                REPOSITION  {&query-name} TO ROW (piStartRow).
        END.
    END.
    RETURN.
end procedure.

procedure criarTTprocesso:
/*
** Cria temp-table filtrada conforme parƒmetros do programa de Posi‡Æo Processos Importa‡Æo - IM0550
*/
def input parameter p-atraso       as integer no-undo.
def input parameter p-situacao     as integer no-undo.
def input parameter p-local        as integer no-undo.
def input parameter p-data-ini     like historico-embarque.dt-efetiva no-undo.
def input parameter p-data-fim     like historico-embarque.dt-efetiva no-undo.
def input parameter p-est-ini      like estabelec.cod-estabel no-undo.
def input parameter p-est-fim      like estabelec.cod-estabel no-undo.
def input parameter p-proc-ini     like processo-imp.nr-proc-imp no-undo.
def input parameter p-proc-fim     like processo-imp.nr-proc-imp no-undo.
def input parameter p-exp-ini      like emitente.cod-emitente no-undo.
def input parameter p-exp-fim      like emitente.cod-emitente no-undo.
def input parameter p-itiner-ini   like itinerario.cod-itiner no-undo.
def input parameter p-itiner-fim   like itinerario.cod-itiner no-undo.
def input parameter p-pto-emb-ini  like pto-contr.cod-pto-contr no-undo.
def input parameter p-pto-emb-fim  like pto-contr.cod-pto-contr no-undo.
def input parameter p-pto-des-ini  like pto-contr.cod-pto-contr no-undo.
def input parameter p-pto-des-fim  like pto-contr.cod-pto-contr no-undo.
def input parameter p-grupo-ini    like grup-estoque.ge-codigo no-undo.
def input parameter p-grupo-fim    like grup-estoque.ge-codigo no-undo.
def input parameter p-fam-ini      like familia.fm-codigo no-undo.
def input parameter p-fam-fim      like familia.fm-codigo no-undo.
def input parameter p-item-ini     like item.it-codigo no-undo.
def input parameter p-item-fim     like item.it-codigo no-undo.
&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN
    DEFINE INPUT PARAMETER pPtoSolicLiIni   LIKE itinerario.cdn-pto-solic-licenciam-import NO-UNDO.
    DEFINE INPUT PARAMETER pPtoSolicLiFim   LIKE itinerario.cdn-pto-solic-licenciam-import NO-UNDO.
    DEFINE INPUT PARAMETER pLicencImportIni LIKE licenciam-import-oc.licenca-import        NO-UNDO.
    DEFINE INPUT PARAMETER pLicencImportFim LIKE licenciam-import-oc.licenca-import        NO-UNDO.
&ELSE
    def input parameter p-decl-ini     like embarque-imp.declaracao-import no-undo.
    def input parameter p-decl-fim     like embarque-imp.declaracao-import no-undo.
&ENDIF 

&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN    
    DEFINE VARIABLE i-pto-solic-li    LIKE itinerario.cdn-pto-solic-licenciam-import NO-UNDO.

    DEFINE VARIABLE h-bocx351 AS HANDLE NO-UNDO.
    IF NOT VALID-HANDLE(h-bocx351) THEN
        RUN cxbo/bocx351.p PERSISTENT SET h-bocx351.
&ENDIF
    
    

    def var i-cod-itiner   like itinerario.cod-itiner   no-undo.       
    def var i-pto-embarque like pto-contr.cod-pto-contr no-undo.
    def var l-ok           as logical                   no-undo.

    for each tt-historico:
        delete tt-historico.
    end.

    /* Embarque */
    for each processo-imp where processo-imp.cod-estabel >= p-est-ini and
                                processo-imp.cod-estabel <= p-est-fim and
                                processo-imp.nr-proc-imp >= p-proc-ini and
                                processo-imp.nr-proc-imp <= p-proc-fim NO-LOCK:                                    

        assign l-ok = yes.

        if p-situacao <> 5 then
            if processo-imp.situacao <> p-situacao
                then next.               

        /* Itinerario */
        if processo-imp.cod-itiner < p-itiner-ini or
           processo-imp.cod-itiner > p-itiner-fim
            then next.           

        &IF "{&BF_MAT_VERSAO_EMS}" < "2.062" &THEN
            if  p-decl-ini <> "" or
                p-decl-fim <> "zzzzzzzzzzzzzzzzzzzz" then
                if  processo-imp.declaracao-import < p-decl-ini or
                    processo-imp.declaracao-import > p-decl-fim then
                    next.                               
        &ENDIF 

        

        /* Historico */
        find last historico-proc-imp
            where historico-proc-imp.cod-estabel = processo-imp.cod-estabel and
                  historico-proc-imp.nr-proc-imp = processo-imp.nr-proc-imp
                  no-lock no-error.
        if not avail historico-proc-imp then next.

        /* Processos */
        if p-atraso = 1 then /* atrasados */
            if historico-proc-imp.dt-ult-previsao <= historico-proc-imp.dt-previsao then next.
        if p-atraso = 2 then /* adiantados */
            if historico-proc-imp.dt-ult-previsao >= historico-proc-imp.dt-previsao then next.

        for each tt-historico-tmp:
            delete tt-historico-tmp.
        end.

        create tt-historico-tmp.
        buffer-copy historico-proc-imp to tt-historico-tmp.
        assign tt-historico-tmp.r-rowid = rowid(historico-proc-imp).

        find itinerario where itinerario.cod-itiner = historico-proc-imp.cod-itiner no-lock no-error.
        if not avail itinerario then next.
        else do:
            assign i-cod-itiner  = itinerario.cod-itiner
                   i-pto-embarque = itinerario.pto-embarque
                   &if "{&BF_MAT_VERSAO_EMS}":U >= "2.062":U &then
                   i-pto-solic-li = itinerario.cdn-pto-solic-licenciam-import
                   &endif.

            if  itinerario.pto-embarque < p-pto-emb-ini 
            or  itinerario.pto-embarque > p-pto-emb-fim then
                next.
            if  itinerario.pto-embarque < p-pto-des-ini 
            or  itinerario.pto-embarque > p-pto-des-fim then 
                next.

            &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN     
            
                if  pPtoSolicLiIni <> 0  
                or  pPtoSolicLiFim <> 99999 then do:

                    if  itinerario.cdn-pto-solic-licenciam-import < pPtoSolicLiIni 
                    or  itinerario.cdn-pto-solic-licenciam-import > pPtoSolicLiFim then
                        next.
                end.
            &ENDIF

        end.

        /* Licenciamento Importacao */
        &if '{&bf_mat_versao_ems}':U >= '2.062':U  &then
           
        find first historico-proc-imp
            where historico-proc-imp.cod-estabel   = processo-imp.cod-estabel
            and   historico-proc-imp.nr-proc-imp   = processo-imp.nr-proc-imp
            and   historico-proc-imp.cod-itiner    = i-cod-itiner         
            and   historico-proc-imp.cod-pto-contr = i-pto-solic-li no-lock no-error.
        
        if  not avail historico-proc-imp then do:

            assign i-pto-solic-li = 0.

            if  pPtoSolicLiIni <> 0  
            or  pPtoSolicLiFim <> 99999 then
               next.
        end.

        &endif.
        
        if p-local <> 0 then
            find historico-proc-imp
                where historico-proc-imp.cod-estabel   = processo-imp.cod-estabel and
                      historico-proc-imp.nr-proc-imp   = processo-imp.nr-proc-imp and 
                      historico-proc-imp.cod-itiner    = i-cod-itiner and        
                      historico-proc-imp.cod-pto-contr = i-local              
                      no-lock no-error.
        else do:
            find historico-proc-imp
                where historico-proc-imp.cod-estabel   = processo-imp.cod-estabel and
                      historico-proc-imp.nr-proc-imp   = processo-imp.nr-proc-imp and 
                      historico-proc-imp.cod-itiner    = i-cod-itiner and
                      historico-proc-imp.cod-pto-contr = i-pto-embarque
                      no-lock no-error.
        end.        
        if avail historico-proc-imp then do:
            if historico-proc-imp.dt-efetiva <> ? then
                if historico-proc-imp.dt-efetiva < da-data-ini or
                   historico-proc-imp.dt-efetiva > da-data-fim then
                    next.
            else
                if historico-proc-imp.dt-ult-previsao <> ? then
                    if historico-proc-imp.dt-ult-previsao < da-data-ini or 
                       historico-proc-imp.dt-ult-previsao > da-data-fim then
                        next.
        end.

        if processo-imp.cod-exportador < p-exp-ini or
           processo-imp.cod-exportador > p-exp-fim then next.

        if p-item-ini <> "" or
           p-item-fim <> "zzzzzzzzzzzzzzzz" then
            assign l-ok = no.

        assign l-li-ok = no.

        for each ordem-compra no-lock 
            where ordem-compra.num-pedido = processo-imp.num-pedido:

            assign l-ok = no.

            if  ordem-compra.it-codigo < p-item-ini 
            or  ordem-compra.it-codigo > p-item-fim then
                next.

            find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
            if  not avail item then 
                next.

            if  item.ge-codigo < p-grupo-ini 
            or  item.ge-codigo > p-grupo-fim then 
                next.

            if  item.fm-codigo < p-fam-ini 
            or  item.fm-codigo > p-fam-fim then
                next.           

            assign l-ok = yes.

            &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN     
                IF pLicencImportIni <> "" 
                OR pLicencImportFim <> "ZZZZZZZZZZZZZZZZZZZZ" THEN DO:
                    RUN piRetornaLi IN h-bocx351(INPUT 1,
                                                 INPUT YES,
                                                 INPUT ordem-compra.num-pedido,
                                                 INPUT ?,
                                                 INPUT ?,
                                                 INPUT ?,
                                                 INPUT YES,
                                                 INPUT YES,
                                                 INPUT ordem-compra.numero-ordem,
                                                 INPUT ordem-compra.numero-ordem,
                                                 INPUT ordem-compra.it-codigo,
                                                 INPUT ordem-compra.it-codigo,
                                                 INPUT "",
                                                 INPUT "ZZZZZZZZ",
                                                 INPUT "",
                                                 INPUT "ZZZZZZZZZZZZZZZZZZZZ",
                                                 OUTPUT TABLE tt-licenciam-import-oc).
                    FIND FIRST tt-licenciam-import-oc
                        WHERE tt-licenciam-import-oc.licenca-import >= pLicencImportIni
                        AND   tt-licenciam-import-oc.licenca-import <= pLicencImportFim NO-ERROR.
                    IF  NOT AVAIL tt-licenciam-import-oc THEN
                        NEXT.
                END.
            &ENDIF
            assign l-li-ok = yes.                
        end.

        if  not l-ok
        &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then          
        or  not l-li-ok 
        &endif then
            next.

        create tt-historico.
        buffer-copy tt-historico-tmp to tt-historico.

    end.
    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN    
        IF VALID-HANDLE(h-bocx351) THEN
            DELETE PROCEDURE h-bocx351.  
    &ENDIF


end procedure.

/* BOCX150B.P */

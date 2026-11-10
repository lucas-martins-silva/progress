/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX230 2.00.00.027 } /*** "010027" 07/10/2024 16:59:55 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX230 MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX230.P
**
**  historico-embarque - Historico Embarque
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY historico-embarque
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME historico-embarque

{include/boini.i}
{cxbo/bocx230.i RowObject}
{cxbo/bocx230.i tt-historico-embarque}
DEFINE TEMP-TABLE tt-previsoes NO-UNDO LIKE mgcex.historico-embarque
       FIELD numero-ordem AS INT
       FIELD num-pedido   AS INT
       FIELD r-rowid  AS rowid.
           
DEFINE TEMP-TABLE tt-embarques NO-UNDO LIKE mgcex.historico-embarque
       FIELD r-rowid  AS rowid.

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

def var c-embarque    as char    no-undo.
def var i-cod-itiner  as integer no-undo. 
def var c-cod-estabel as char    no-undo.
DEF VAR l-seq-nac     AS INTEGER NO-UNDO.
def var h-bocx220     as handle  no-undo.
DEF VAR h-bocx407     AS HANDLE  NO-UNDO.

{cdp/cd4300.i3}  /* include tratamento atributo livre */
{cdp/cdcfgmat.i} /* Definiá∆o de prÇ-processadores    */

/* definicao de temp-table e variaveis usadas no mÇtodo efetivaPontoControle ---*/
{cxbo/bocx220.i ttEmbarqueImp}
def var cEstabel     like embarque-imp.cod-estabel         no-undo.
def var cEmbarque    like embarque-imp.embarque            no-undo.
def var iPonto       like historico-embarque.cod-pto-contr no-undo.

DEF BUFFER b-historico-embarque FOR historico-embarque.

procedure setConstraint1:
end procedure. 


procedure setConstraint2:
    def input parameter p-embarque as char no-undo.
    
    assign c-embarque = p-embarque.
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.    
        when 2 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                where historico-embarque.embarque >= c-embarque.                        
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
/* {include/boexeupt.i} */
{include/boexedel.i}
/* {include/bovalupt.i} */
{include/bovaldel.i}

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
     
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.


procedure findPrev2:
    /*
    **  Localiza bloco de registro anterior na tabela. 
    **  O bloco È formado pelos registros com mesmo embarque e mesmo cod-itiner.
    */
    def output parameter table for RowObject .

   assign c-embarque    = {&Table-name}.embarque
          i-cod-itiner  = {&table-name}.cod-itiner
          c-cod-estabel = {&table-name}.cod-estabel.

   find first {&table-name} where
              historico-embarque.cod-estabel = c-cod-estabel   and
              historico-embarque.embarque    = c-embarque and
              historico-embarque.cod-itiner  = i-cod-itiner no-lock no-error.

    find prev {&TABLE-NAME}
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg",
                           input 7998,
                           input "").
    end.
    else run setCurrent.
end procedure.
 
 
procedure findNext2:
    /*
    **  Localiza proximo bloco de registro na tabela.
    **  O bloco È formado pelos registros com mesmo embarque e mesmo cod-itiner.
    */
    def output parameter table for RowObject.

    assign c-embarque    = {&table-name}.embarque
           i-cod-itiner  = {&table-name}.cod-itiner
           c-cod-estabel = {&table-name}.cod-estabel.

    find last {&table-name} where 
        historico-embarque.cod-estabel = c-cod-estabel   and
        historico-embarque.embarque    = c-embarque and
        historico-embarque.cod-itiner  = i-cod-itiner 
        no-lock no-error.

    find next {&TABLE-NAME} no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg",
                           input 7999,
                           input "").
    end.
    else run setCurrent.
end procedure.


procedure findFirstEmbarque:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter p-cod-estabel   like estabelec.cod-estabel no-undo.
    def input parameter p-embarque      like embarque-imp.embarque no-undo.
    def output parameter c-return as char no-undo.    
 
    find first historico-embarque
        where historico-embarque.cod-estabel = p-cod-estabel 
          and historico-embarque.embarque    = p-embarque no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else
        run setCurrent.
end procedure.

procedure findLastEmbarque:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter p-cod-estabel   like estabelec.cod-estabel no-undo.
    def input parameter p-embarque      like embarque-imp.embarque no-undo.
    def output parameter c-return as char no-undo.    
 
    find last historico-embarque
        where historico-embarque.cod-estabel = p-cod-estabel 
          and historico-embarque.embarque    = p-embarque no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else
        run setCurrent.
end procedure.


procedure findCh-itiner:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-estabel       as char    no-undo.
    def input parameter c-embarque      as char    no-undo.
    def input parameter i-cod-itiner    as integer no-undo.
    def input parameter i-cod-pto-contr as integer no-undo.
    def output parameter c-return as char no-undo.
    
    run startMethod("find":U).
 
    FOR FIRST historico-embarque 
        WHERE historico-embarque.cod-estabel   = c-estabel
          AND historico-embarque.embarque      = c-embarque 
          AND historico-embarque.cod-itiner    = i-cod-itiner   
          AND historico-embarque.cod-pto-contr = i-cod-pto-contr NO-LOCK: END.

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

procedure findPto-Controle-por-sequencia:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-cod-estabel   LIKE embarque-imp.cod-estabel     no-undo.
    def input parameter c-embarque      LIKE embarque-imp.embarque        no-undo.
    def input parameter i-cod-itiner    as integer                        no-undo.
    def input parameter i-seq           LIKE historico-embarque.sequencia no-undo.
    def output parameter c-return       as char                           no-undo.

    run startMethod("find":U).

    find historico-embarque where
         historico-embarque.cod-estabel   = c-cod-estabel and
         historico-embarque.embarque      = c-embarque    and
         historico-embarque.cod-itiner    = i-cod-itiner  and
         historico-embarque.sequencia     = i-seq no-lock no-error.
    if not avail historico-embarque then do:
        {utp/ut-table.i mgcex historico-embarque 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
       run setCurrent.
    end.

    run endMethod("find":U).
end procedure.


procedure executeUpdate:
    /*
    **  Executa Update
    */
      
    buffer-copy RowObject except cod-itiner cod-pto-contr r-rowid to {&TABLE-NAME}.
end procedure.


/* Procedure RetornaDataPartida */
{cxbo/bocx230.i1}
/********************************/

procedure validateFields:
    
    find first rowObject no-lock no-error.
 
    run startMethod ("validateFields").    
     
    run endMethod ("validateFields"). 
end procedure.


procedure validateUpdate:
    /*
    **  Valida Update
    */
    def input parameter table for RowObject.
    def input parameter r-chave as rowid no-undo.
    def output parameter table for tt-bo-erro.
    
    run startMethod("validateUpdate":U).
     
    run InitializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.     
    
    find first rowObject 
         no-lock no-error.    
    
    run validateFields.    
    
    find first tt-bo-erro
        no-lock no-error.
    if not avail tt-bo-erro then do:
        find {&TABLE-NAME} where
            rowid({&TABLE-NAME}) = r-chave            
            exclusive-lock no-error no-wait.
            
        if locked({&table-name}) then do:
            assign i-seq-erro = i-seq-erro + 1.    
            run utp/ut-msgs.p (input "msg",
	                       input 16096,
 			       input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
  	           tt-bo-erro.cd-erro  = 16096
 	           tt-bo-erro.mensagem = return-value.                
        end.
        else 
	    if avail {&table-name} then
                run executeUpdate.            
    end.    
    run endMethod("validateUpdate":U).    
end procedure.


procedure validateCreate:
    /*
    **  Valida criaá∆o da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
    
    def var i-auto-num as integer no-undo.
    def var c-return as char no-undo.
    
    run startMethod("validateCreate":U).
 
    run initializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    find first rowObject no-error.            
    
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
    else if not can-find(itinerario where itinerario.cod-itiner = rowObject.cod-itiner) then do:
             assign i-seq-erro = i-seq-erro + 1.
             {utp/ut-table.i mgcex itinerario 1}
             run utp/ut-msgs.p (input "msg",
                                input 2,
                                input return-value).
             create tt-bo-erro.
             assign tt-bo-erro.i-sequen = i-seq-erro
                    tt-bo-erro.cd-erro  = 2
                    tt-bo-erro.mensagem = return-value.
         end.
         else do:
           if rowObject.cod-pto-contr = 0 then do:
             assign i-seq-erro = i-seq-erro + 1.
             {utp/ut-field.i mgcex {&TABLE-NAME} cod-pto-contr 1}
             run utp/ut-msgs.p (input "msg",
                                input 265,
                                input return-value).
             create tt-bo-erro.
             assign tt-bo-erro.i-sequen     = i-seq-erro
                    tt-bo-erro.cd-erro      = 265
                    tt-bo-erro.mensagem     = return-value.
           end.
           else if not can-find(pto-itiner where pto-itiner.cod-itiner = rowObject.cod-itiner and
                                                 pto-itiner.sequencia  = rowObject.sequencia  and
                                                 pto-itiner.cod-pto-contr = rowObject.cod-pto-contr) then do:
             {utp/ut-table.i mgcex pto-itiner 1}
             assign c-return = return-value.                                                                           
             assign i-seq-erro = i-seq-erro + 1.
             {utp/ut-table.i mgcex itinerario 1}
             run utp/ut-msgs.p (input "msg",
                                input 15783,
                                input c-return + "~~" + return-value).
             create tt-bo-erro.
             assign tt-bo-erro.i-sequen = i-seq-erro
                    tt-bo-erro.cd-erro  = 15783
                    tt-bo-erro.mensagem = return-value.
           end.                  
         end.         
         
    run validateFields.
    
    if can-find(first tt-bo-erro) then do:   
     if can-find({&TABLE-NAME} where
                 {&TABLE-NAME}.embarque      = rowObject.embarque    and
                 {&TABLE-NAME}.cod-estabel   = rowObject.cod-estabel and
                 {&TABLE-NAME}.cod-itiner    = rowObject.cod-itiner  and
                 {&TABLE-NAME}.sequencia     = rowObject.sequencia   and
                 {&TABLE-NAME}.cod-pto-contr = rowObject.cod-pto-contr) then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-table.i mgcex historico-embarque 1}
        run utp/ut-msgs.p (input "msg",
                           input 8,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 8
               tt-bo-erro.mensagem     = return-value.
     end.
    end. 
            
    find first tt-bo-erro
        no-lock no-error.        
 
    if not avail tt-bo-erro then do:
         run executeCreate.
         assign r-chave = to-rowid(return-value).
    end. 
    run endMethod("validateCreate":U). 
end procedure.


procedure getCharField:
    define input parameter c-field as char.
    define output parameter c-value as char.
	
    case c-field:
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "embarque" then c-value = RowObject.embarque.
        when "id-meio-transp" then c-value = RowObject.id-meio-transp.
        when "observacao" then c-value = RowObject.observacao.
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        WHEN "descricao" THEN c-value = RowObject.descricao.
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
        when "sequencia" then c-value = RowObject.sequencia.
        when "cod-pto-contr" then c-value = RowObject.cod-pto-contr.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.        
        WHEN "nr-dias" THEN c-value = RowObject.nr-dias.
        otherwise return error.
    end case.
end procedure.

 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "dt-previsao" then c-value = RowObject.dt-previsao.
        when "dt-ult-previsao" then c-value = RowObject.dt-ult-previsao.
        when "dt-efetiva" then c-value = RowObject.dt-efetiva.
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


procedure pi-cria-tt-previsoes:
    def input param p-cod-estab-ini         like estabelec.cod-estabel.
    def input param p-cod-estab-fim         like estabelec.cod-estabel.
    def input param p-cod-proc-imp-ini      like processo-imp.nr-proc-imp.
    def input param p-cod-proc-imp-fim      like processo-imp.nr-proc-imp.
    def input param p-cod-fornec-ini        like fornecedor.cod-fornec.
    def input param p-cod-fornec-fim        like fornecedor.cod-fornec.
    def input param p-cod-ped-compra-ini    like pedido-compr.num-pedido.
    def input param p-cod-ped-compra-fim    like pedido-compr.num-pedido.
    def input param p-cod-ord-compra-ini    like ordem-compra.numero-ordem.
    def input param p-cod-ord-compra-fim    like ordem-compra.numero-ordem.
    def input param p-cod-incoterm-ini      like incoterm-itiner.cod-incoterm.
    def input param p-cod-incoterm-fim      like incoterm-itiner.cod-incoterm.
    def input param p-cod-item-ini          like item.it-codigo.
    def input param p-cod-item-fim          like item.it-codigo.
    def input param p-data-embarque-ini     as   DATE FORMAT "99/99/9999"  NO-UNDO.
    def input param p-data-embarque-fim     as   DATE FORMAT "99/99/9999" NO-UNDO.
    def input param p-cod-itinerario-ini    like itinerario.cod-itiner.
    def input param p-cod-itinerario-fim    like itinerario.cod-itiner.
    def input param p-sit-emb               as integer.
    def output parameter                    table for tt-previsoes.
    
    
    DEF VARIABLE   i-itiner-historico       LIKE historico-embarque.cod-itiner NO-UNDO.    
    def variable    v-cod-pto-contr         like historico-embarque.cod-pto-contr.
    def variable    v-cod-pto-contr2        like historico-embarque.cod-pto-contr.
    def variable    v-dt-pto-emb            as   date no-undo.
    def variable    l-efetivou              as   logical init no no-undo.
    def variable    l-ok                    as   logical init no no-undo.
            
    for each tt-previsoes:
        delete tt-previsoes.
    end.      

    embarque:
    for each  embarque-imp no-lock
        where embarque-imp.cod-estabel  >= p-cod-estab-ini
        and   embarque-imp.cod-estabel  <= p-cod-estab-fim:
        assign v-cod-pto-contr   = 0
               v-cod-pto-contr2  = 0
               l-ok              = no
               v-dt-pto-emb      = ?
               l-efetivou        = no.
        
        if not(embarque-imp.cod-incoterm >= p-cod-incoterm-ini and   
               embarque-imp.cod-incoterm <= p-cod-incoterm-fim) 
            then next.

        if p-sit-emb <> 3 then
           if embarque-imp.situacao <> p-sit-emb 
           then next.
        
        if can-find(first ordens-embarque no-lock
                    where ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                    and   ordens-embarque.embarque    = embarque-imp.embarque) then do:  
            ordens:
            for each  ordens-embarque FIELDS(numero-ordem cod-estabel nr-proc-imp)  no-lock
                where ordens-embarque.cod-estabel    = embarque-imp.cod-estabel
                and   ordens-embarque.embarque       = embarque-imp.embarque
                and   ordens-embarque.nr-proc-imp   >= p-cod-proc-imp-ini
                and   ordens-embarque.nr-proc-imp   <= p-cod-proc-imp-fim
                and   ordens-embarque.numero-ordem  >= p-cod-ord-compra-ini
                and   ordens-embarque.numero-ordem  <= p-cod-ord-compra-fim:
                
                
                FOR first  ordem-compra FIELDS(num-pedido it-codigo numero-ordem) no-lock
                     where ordem-compra.numero-ordem = ordens-embarque.numero-ordem:
                END.
                if not avail ordem-compra then next embarque.
                
                FOR  first pedido-compr FIELDS(num-pedido cod-emitente) NO-LOCK where 
                           pedido-compr.num-pedido   = ordem-compra.num-pedido:
                END.
                if not avail pedido-compr then NEXT embarque.
                
                IF NOT(pedido-compr.num-pedido >= p-cod-ped-compra-ini AND
                       pedido-compr.num-pedido <= p-cod-ped-compra-fim) THEN NEXT .
                
                if not(pedido-compr.cod-emitente >= p-cod-fornec-ini  and
                       pedido-compr.cod-emitente <= p-cod-fornec-fim) then next embarque.

                if not(ordem-compra.it-codigo >= p-cod-item-ini  and
                       ordem-compra.it-codigo <= p-cod-item-fim) then next embarque.
                
                FOR  first processo-imp FIELDS(cod-estabel nr-proc-imp) no-lock
                     where processo-imp.cod-estabel  = ordens-embarque.cod-estabel
                     and   processo-imp.nr-proc-imp  = ordens-embarque.nr-proc-imp
                     and   processo-imp.num-pedido   = ordem-compra.num-pedido:
                END.
                if not avail processo-imp then next embarque.
                    
                FOR  FIRST historico-embarque WHERE
                           historico-embarque.cod-estabel = embarque-imp.cod-estabel AND
                           historico-embarque.embarque    = embarque-imp.embarque NO-LOCK:
                END.

                if not avail historico-embarque then next embarque.

                ASSIGN i-itiner-historico = historico-embarque.cod-itiner.

                if not (historico-embarque.cod-itiner >= p-cod-itinerario-ini and
                        historico-embarque.cod-itiner <= p-cod-itinerario-fim)
                then next embarque.

                RELEASE historico-embarque.

                FOR  first itinerario FIELDS(cod-itiner pto-embarque) no-lock 
                     where itinerario.cod-itiner = i-itiner-historico :
                END.
                if not avail itinerario then next.

                ASSIGN i-itiner-historico = 0.

                FOR  last  historico-embarque 
                     where historico-embarque.cod-estabel   = embarque-imp.cod-estabel and
                           historico-embarque.embarque      = embarque-imp.embarque no-lock:
                END.

                if not avail historico-embarque then next embarque.
                
                FOR  first historico-embarque no-lock
                     where historico-embarque.cod-estabel     = embarque-imp.cod-estabel
                       and historico-embarque.embarque        = embarque-imp.embarque
                       and historico-embarque.cod-itiner      = itinerario.cod-itiner
                       and historico-embarque.cod-pto-contr   = embarque-imp.cdn-pto-embarq:
                END.
                
                if avail historico-embarque then do:  

                    assign v-dt-pto-emb = if historico-embarque.dt-efetiva <> ? then
                                             historico-embarque.dt-efetiva 
                                          else historico-embarque.dt-ult-previsao.
                end.
                
                for each  historico-embarque FIELDS(cod-pto-contr dt-efetiva char-1 char-2) no-lock
                    where historico-embarque.cod-estabel    = embarque-imp.cod-estabel
                    and   historico-embarque.embarque       = embarque-imp.embarque: 
                    if historico-embarque.cod-pto-contr     = embarque-imp.cdn-pto-embarq then do:
                        ASSIGN v-cod-pto-contr = historico-embarque.cod-pto-contr.
                        if historico-embarque.dt-efetiva <> ? THEN DO:
                            assign l-efetivou = yes.
                        END.
                        ELSE DO:
                            assign v-cod-pto-contr2 = historico-embarque.cod-pto-contr.
                            leave.
                        END.
                    end.
                end.   
                    
                find historico-embarque
                    where historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
                    and   historico-embarque.embarque      = embarque-imp.embarque 
                    and   historico-embarque.cod-itiner    = itinerario.cod-itiner 
                    and   historico-embarque.cod-pto-contr = if v-cod-pto-contr = 0 
                                                             then v-cod-pto-contr2
                                                             else v-cod-pto-contr
                          no-lock no-error.

                if avail historico-embarque THEN do:
                   
                   IF historico-embarque.dt-ult-previsao >= p-data-embarque-ini and
                      historico-embarque.dt-ult-previsao <= p-data-embarque-fim  then do:

                       if l-efetivou = yes THEN next embarque.

                       find first tt-previsoes no-lock 
                            where tt-previsoes.embarque              = historico-embarque.embarque
                            and   tt-previsoes.cod-estabel           = historico-embarque.cod-estabel
                            and   tt-previsoes.cod-itiner            = historico-embarque.cod-itiner
                            and   tt-previsoes.sequencia             = historico-embarque.sequencia
                            no-error.
                       
                       if not avail tt-previsoes then do: 
                          create tt-previsoes.
                          buffer-copy historico-embarque to tt-previsoes.
                          assign tt-previsoes.cod-pto-contr     = v-cod-pto-contr 
                                 tt-previsoes.dt-ult-previsao   = v-dt-pto-emb
                                 tt-previsoes.numero-ordem      = ordem-compra.numero-ordem
                                 tt-previsoes.num-pedido        = ordem-compra.num-pedido
                                 tt-previsoes.r-rowid           = rowid(historico-embarque).
    
                       END.
                   END.
                end.

            end.                
        end.
        else do:

            create tt-previsoes.
            buffer-copy embarque-imp to tt-previsoes.
            assign tt-previsoes.cod-pto-contr     = v-cod-pto-contr
                   tt-previsoes.dt-ult-previsao   = v-dt-pto-emb
                   tt-previsoes.numero-ordem      = 99999999
                   tt-previsoes.num-pedido        = 99999999
                   tt-previsoes.r-rowid           = rowid(embarque-imp).
        end.
    end.

end.


procedure pi-cria-tt-embarques:
    def input param p-cod-estab-ini         like estabelec.cod-estabel.
    def input param p-cod-estab-fim         like estabelec.cod-estabel.
    def input param p-cod-proc-imp-ini      like processo-imp.nr-proc-imp.
    def input param p-cod-proc-imp-fim      like processo-imp.nr-proc-imp.
    def input param p-cod-fornec-ini        like fornecedor.cod-fornec.
    def input param p-cod-fornec-fim        like fornecedor.cod-fornec.
    def input param p-cod-ped-compra-ini    like pedido-compr.num-pedido.
    def input param p-cod-ped-compra-fim    like pedido-compr.num-pedido.
    def input param p-cod-ord-compra-ini    like ordem-compra.numero-ordem.
    def input param p-cod-ord-compra-fim    like ordem-compra.numero-ordem.
    def input param p-cod-incoterm-ini      like incoterm-itiner.cod-incoterm.
    def input param p-cod-incoterm-fim      like incoterm-itiner.cod-incoterm.
    def input param p-cod-item-ini          like item.it-codigo.
    def input param p-cod-item-fim          like item.it-codigo.
    def input param p-data-embarque-ini     as   DATE FORMAT "99/99/9999".
    def input param p-data-embarque-fim     as   DATE FORMAT "99/99/9999".
    def input param p-cod-itinerario-ini    like itinerario.cod-itiner.
    def input param p-cod-itinerario-fim    like itinerario.cod-itiner.
    def input param p-sit-emb               as integer.
    def output parameter                    table for tt-embarques.
    
    DEF VARIABLE   i-itiner-historico       LIKE historico-embarque.cod-itiner NO-UNDO.    
    def variable    v-cod-pto-contr         like historico-embarque.cod-pto-contr no-undo.
    def variable    v-dt-pto-emb            as   date                             no-undo.
    def variable    l-ok                    as   logical                          no-undo.
            
    for each tt-embarques:
        delete tt-embarques.
    end.      

    embarque:
    for each  embarque-imp no-lock
        where embarque-imp.cod-estabel  >= p-cod-estab-ini
        and   embarque-imp.cod-estabel  <= p-cod-estab-fim:
        assign l-ok = no.
        
        if not(embarque-imp.cod-incoterm >= p-cod-incoterm-ini and   
               embarque-imp.cod-incoterm <= p-cod-incoterm-fim) 
        then next.
        
        if p-sit-emb <> 3 then
           if embarque-imp.situacao <> p-sit-emb 
           then next.
        
        /***************** inicio da inclusao **************/
        FOR  FIRST historico-embarque WHERE                                               
                   historico-embarque.cod-estabel = embarque-imp.cod-estabel AND          
                   historico-embarque.embarque    = embarque-imp.embarque NO-LOCK:        
        END.                                                                              
                                                                                          
        IF NOT AVAIL historico-embarque THEN next embarque.                               
                                                                                          
        ASSIGN i-itiner-historico = historico-embarque.cod-itiner.                        
                                                                                          
        if not (historico-embarque.cod-itiner >= p-cod-itinerario-ini and                 
                historico-embarque.cod-itiner <= p-cod-itinerario-fim) then next embarque.
                                                                                          
        RELEASE historico-embarque.                                                       

        FOR first itinerario FIELDS(cod-itiner pto-embarque) where                      
                  itinerario.cod-itiner = i-itiner-historico NO-LOCK:                   
        END.                                                                            
        if not avail itinerario then next.                                              
                                                                                        
        assign v-cod-pto-contr = 0                                                      
               i-itiner-historico = 0.                                                  
                                                                                        
        FOR  first historico-embarque where                                             
                   historico-embarque.cod-estabel     = embarque-imp.cod-estabel and    
                   historico-embarque.embarque        = embarque-imp.embarque    and    
                   historico-embarque.cod-itiner      = itinerario.cod-itiner    and    
                   historico-embarque.cod-pto-contr   = embarque-imp.cdn-pto-embarq NO-LOCK:
        END.                                                                            
                                                                                        
        if avail historico-embarque THEN do:                                            
            assign v-dt-pto-emb = if historico-embarque.dt-efetiva <> ? then            
                                     historico-embarque.dt-efetiva                      
                                  else historico-embarque.dt-ult-previsao.              
        end.                                                                            
                                                                                        
        for each  historico-embarque FIELDS(cod-pto-contr dt-efetiva) where             
                  historico-embarque.cod-estabel = embarque-imp.cod-estabel and         
                  historico-embarque.embarque    = embarque-imp.embarque    and         
                  historico-embarque.cod-itiner  = itinerario.cod-itiner NO-LOCK:       
                                                                                        
            if historico-embarque.dt-efetiva     <> ? then do:                          
                if historico-embarque.cod-pto-contr   = embarque-imp.cdn-pto-embarq then    
                    assign l-ok = yes.                                                  
                assign v-cod-pto-contr = historico-embarque.cod-pto-contr.              
            end.                                                                        
            else leave.                                                                 
        end.                                                                            
        /****************** fim inclusao ************/

        ordens:
        for each  ordens-embarque FIELDS(numero-ordem cod-estabel nr-proc-imp) no-lock
            where ordens-embarque.cod-estabel    = embarque-imp.cod-estabel
            and   ordens-embarque.embarque       = embarque-imp.embarque
            and   ordens-embarque.nr-proc-imp   >= p-cod-proc-imp-ini
            and   ordens-embarque.nr-proc-imp   <= p-cod-proc-imp-fim
            and   ordens-embarque.numero-ordem  >= p-cod-ord-compra-ini
            and   ordens-embarque.numero-ordem  <= p-cod-ord-compra-fim:
            
            FOR first ordem-compra FIELDS(num-pedido it-codigo) where 
                      ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:
            END.
            if not avail ordem-compra then next embarque.
             
            FOR first pedido-compr FIELDS(num-pedido cod-emitente) where 
                      pedido-compr.num-pedido   = ordem-compra.num-pedido NO-LOCK:
            END.
                 
            if not avail pedido-compr then next embarque.
            
            IF NOT(pedido-compr.num-pedido >= p-cod-ped-compra-ini AND
                   pedido-compr.num-pedido <= p-cod-ped-compra-fim) THEN NEXT.

            if not(pedido-compr.cod-emitente >= p-cod-fornec-ini and
                   pedido-compr.cod-emitente <= p-cod-fornec-fim) THEN next embarque.
            
            if not (ordem-compra.it-codigo >= p-cod-item-ini and
                    ordem-compra.it-codigo <= p-cod-item-fim) then next embarque.
            
            FOR  first processo-imp FIELDS(cod-estabel nr-proc-imp) where 
                       processo-imp.cod-estabel  = ordens-embarque.cod-estabel and   
                       processo-imp.nr-proc-imp  = ordens-embarque.nr-proc-imp and   
                       processo-imp.num-pedido   = ordem-compra.num-pedido NO-LOCK:
            END.

            if not avail processo-imp then next embarque.

            /*********
            FOR  FIRST historico-embarque WHERE
                       historico-embarque.cod-estabel = embarque-imp.cod-estabel AND
                       historico-embarque.embarque    = embarque-imp.embarque NO-LOCK:
            END.

            IF NOT AVAIL historico-embarque THEN next embarque.
            
            ASSIGN i-itiner-historico = historico-embarque.cod-itiner.

            if not (historico-embarque.cod-itiner >= p-cod-itinerario-ini and
                    historico-embarque.cod-itiner <= p-cod-itinerario-fim) then next embarque.
            
            RELEASE historico-embarque.            
            

            FOR first itinerario FIELDS(cod-itiner pto-embarque) where 
                      itinerario.cod-itiner = i-itiner-historico NO-LOCK:
            END.
            if not avail itinerario then next.

            assign v-cod-pto-contr = 0
                   i-itiner-historico = 0.
                
            FOR  first historico-embarque where 
                       historico-embarque.cod-estabel     = embarque-imp.cod-estabel and 
                       historico-embarque.embarque        = embarque-imp.embarque    and 
                       historico-embarque.cod-itiner      = itinerario.cod-itiner    and 
                       historico-embarque.cod-pto-contr   = itinerario.pto-embarque NO-LOCK:
            END.

            if avail historico-embarque THEN do:  
                assign v-dt-pto-emb = if historico-embarque.dt-efetiva <> ? then
                                         historico-embarque.dt-efetiva 
                                      else historico-embarque.dt-ult-previsao.
            end.

            for each  historico-embarque FIELDS(cod-pto-contr dt-efetiva) where 
                      historico-embarque.cod-estabel = embarque-imp.cod-estabel and   
                      historico-embarque.embarque    = embarque-imp.embarque    and  
                      historico-embarque.cod-itiner  = itinerario.cod-itiner NO-LOCK:

                if historico-embarque.dt-efetiva     <> ? then do:
                    if historico-embarque.cod-pto-contr   = itinerario.pto-embarque then 
                        assign l-ok = yes.
                    assign v-cod-pto-contr = historico-embarque.cod-pto-contr.
                end.
                else leave.
            end.  
            ******************************************/
            if l-ok = yes then do:
                FOR  first historico-embarque where 
                           historico-embarque.cod-estabel     = embarque-imp.cod-estabel and   
                           historico-embarque.embarque        = embarque-imp.embarque    and
                           historico-embarque.cod-itiner      = itinerario.cod-itiner    and 
                           historico-embarque.cod-pto-contr   = v-cod-pto-contr NO-LOCK:
                END.
                if avail historico-embarque and
                         historico-embarque.dt-efetiva <> ? and 
                         historico-embarque.dt-efetiva >= p-data-embarque-ini and
                         historico-embarque.dt-efetiva <= p-data-embarque-fim THEN do:

                   find first tt-embarques exclusive-lock 
                        where tt-embarques.embarque              = historico-embarque.embarque
                        and   tt-embarques.cod-estabel           = historico-embarque.cod-estabel
                        and   tt-embarques.cod-itiner            = historico-embarque.cod-itiner
                        and   tt-embarques.sequencia             = historico-embarque.sequencia
                        no-error.
                   
                   if not avail tt-embarques then do:
                      create tt-embarques.
                      buffer-copy historico-embarque to tt-embarques.
                      assign tt-embarques.cod-pto-contr     = v-cod-pto-contr
                             tt-embarques.dt-ult-previsao   = v-dt-pto-emb
                             tt-embarques.r-rowid           = rowid(historico-embarque).
                   end.                         
                end.
            end.                
        end.            
    end.
end.


PROCEDURE efetivaPontoControle:
    /* Verifica se o ponto de controle a efetivar Ç o mesmo para todos os embarques
    ** associados ao ve°culo de transporte. Caso n∆o seja, retorna mensagem de erro.
    ** Se for, efetiva o ponto de controle de todos os embarques associados ao ve°culo
    ** de transporte ---*/

    def input  parameter pDtEfetiva  like historico-embarque.dt-efetiva     no-undo.
    def input  parameter table for ttEmbarqueImp.
    def output parameter table for tt-bo-erro.
    
    def var dt-previsao-old as date no-undo.
    def var dt-ult-prev-old as date no-undo.
    def var dt-efetiva-old  as date no-undo.

    def var dt-pto-ant       as date    no-undo.
    def var i-intervalo-adic as integer no-undo.    

    def var l-first as logical  no-undo initial yes.
    def buffer bHistoricoEmb    for historico-embarque.

    DEFINE BUFFER b-historico-embarque FOR historico-embarque.

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    assign i-seq-erro = 0.

    if  pDtEfetiva = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex historico-embarque dt-efetiva 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 18032,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen  = i-seq-erro
               tt-bo-erro.cd-erro   = 18032
               tt-bo-erro.mensagem  = return-value.
        return "NOK":U.
    end.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    for each ttEmbarqueImp:
        
        /* Verifica qual Ç o ponto de controle a ser efetivado para cada embarque ---*/
        find first historico-embarque of ttEmbarqueImp
             where historico-embarque.dt-efetiva = ? no-lock no-error.

        IF AVAIL historico-embarque THEN DO:

            IF  l-first THEN DO:
                ASSIGN iPonto  = historico-embarque.cod-pto-contr
                       l-first = NO.
                NEXT.
            END.

            /* Verifica a existància de pontos de controle diferentes para os embarques do mesmo ve°culo ---*/
            IF  NOT l-first THEN DO:
                IF  iPonto <> historico-embarque.cod-pto-contr THEN DO:
                    ASSIGN i-seq-erro = i-seq-erro + 1.
                    RUN utp/ut-msgs.p (INPUT "msg":U,
                                       INPUT 26725,
                                       INPUT historico-embarque.embarque).
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.i-sequen  = i-seq-erro
                           tt-bo-erro.cd-erro   = 26725
                           tt-bo-erro.mensagem  = RETURN-VALUE.
                    RETURN "NOK":U.
                END.
            END.
        END.
    END.
    
    RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.

    efetivaPontoControle:
    DO  TRANSACTION:

        FOR EACH ttEmbarqueImp:
            /* Verifica se a data informada (pDtEfetiva) Ç menor que a do ponto de controle anterior ---*/
            FIND LAST  historico-embarque OF ttEmbarqueImp
                 WHERE historico-embarque.dt-efetiva <> ? NO-LOCK NO-ERROR.

            IF AVAIL historico-embarque THEN DO:
                IF  historico-embarque.dt-efetiva > pDtEfetiva THEN DO:
                    ASSIGN i-seq-erro = i-seq-erro + 1.
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-data-efetiva AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Data_Efetiva" *}
                    ASSIGN c-lbl-liter-data-efetiva = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-do-ponto-anterior AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "a_do_ponto_anterior" *}
                    ASSIGN c-lbl-liter-a-do-ponto-anterior = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p (INPUT "msg":U,
                                       INPUT 7744,
                                       INPUT c-lbl-liter-data-efetiva + "~~" + c-lbl-liter-a-do-ponto-anterior).
                    CREATE tt-bo-erro.
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
                    ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-verifique-o-ponto-de-controle AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Verifique_o_ponto_de_controle" *}
                    ASSIGN c-lbl-liter-verifique-o-ponto-de-controle = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-do-embarque AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "do_embarque" *}
                    ASSIGN c-lbl-liter-do-embarque = TRIM(RETURN-VALUE).
                    ASSIGN tt-bo-erro.i-sequen  = i-seq-erro
                           tt-bo-erro.cd-erro   = 7744
                           tt-bo-erro.mensagem  = c-lbl-liter
                           tt-bo-erro.errorhelp = c-lbl-liter-verifique-o-ponto-de-controle + " "
                                                + STRING(historico-embarque.cod-pto-contr)
                                                + " " + c-lbl-liter-do-embarque + " "
                                                + historico-embarque.embarque + ".".
                    UNDO efetivaPontoControle, RETURN "NOK":U.
                END.
            END.

            /* Verifica qual Ç o ponto de controle a ser efetivado para cada embarque ---*/
            FIND FIRST historico-embarque OF ttEmbarqueImp
                 WHERE historico-embarque.dt-efetiva = ? EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL historico-embarque THEN DO:
                /*********************************** Frank ********************************************/
                ASSIGN dt-previsao-old = historico-embarque.dt-previsao
                       dt-ult-prev-old = historico-embarque.dt-ult-previsao
                       dt-efetiva-old  = historico-embarque.dt-efetiva.

                IF dt-efetiva-old = ? THEN
                    ASSIGN dt-efetiva-old = dt-ult-prev-old.

                ASSIGN historico-embarque.dt-efetiva  = pDtEfetiva.

                IF  historico-embarque.id-meio-transp = "" THEN
                    ASSIGN historico-embarque.id-meio-transp = SUBSTRING(ttEmbarqueImp.char-1,1,20).
                ELSE DO:
                    RUN gravaMeioTransporte IN h-bocx220 (INPUT ttEmbarqueImp.cod-estabel,
                                                          INPUT ttEmbarqueImp.embarque).
                END.

                /*
                ** Se estiver parametrizado para recalcular dt ultima previs∆o 
                */
                FIND pto-contr
                    WHERE pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr no-lock no-error.

                IF  ((AVAIL pto-contr AND pto-contr.log-1 = NO)        OR
                     (not avail pto-contr))                            AND
                     (historico-embarque.dt-efetiva <> dt-efetiva-old) THEN DO:

                    IF historico-embarque.dt-efetiva <> ? THEN
                        ASSIGN i-intervalo-adic = INTEGER(historico-embarque.dt-efetiva)
                                                - INTEGER(dt-efetiva-old).
                    ELSE
                        ASSIGN i-intervalo-adic = INTEGER(historico-embarque.dt-ult-previsao)
                                                - INTEGER(dt-efetiva-old).

                    /*
                    ** Atualiza alteraá∆o para todo o acompanhamento
                    */

                    FOR EACH  b-historico-embarque FIELDS(dt-efetiva dt-ult-previsao) USE-INDEX codigo
                        WHERE b-historico-embarque.cod-estabel = historico-embarque.cod-estabel AND
                              b-historico-embarque.embarque    = historico-embarque.embarque    AND
                              b-historico-embarque.cod-itiner  = historico-embarque.cod-itiner  AND
                              b-historico-embarque.sequencia   > historico-embarque.sequencia   EXCLUSIVE-LOCK:

                        IF b-historico-embarque.dt-efetiva <> ? THEN LEAVE.

                        ASSIGN b-historico-embarque.dt-ult-previsao = b-historico-embarque.dt-ult-previsao
                                                                    + i-intervalo-adic.
                    END.
                END.
                /******************************* Frank *****************************************************/
            END.

            /* Verifica se o ponto efetivado era o £ltimo ponto de controle do embarque ---*/
            IF  NOT CAN-FIND(FIRST bHistoricoEmb OF ttEmbarqueImp
                             WHERE bHistoricoEmb.dt-efetiva = ? NO-LOCK) THEN DO:
                
                FIND embarque-imp 
                    WHERE embarque-imp.cod-estabel = ttEmbarqueImp.cod-estabel AND
                          embarque-imp.embarque    = ttEmbarqueImp.embarque    EXCLUSIVE-LOCK NO-ERROR.

                IF AVAIL embarque-imp THEN
                    ASSIGN embarque-imp.situacao  = 2. /* Encerra o embarque */
            END.
        END.
    END.  /*--- fim do bloco efetivaPontoControle ---*/

    DELETE PROCEDURE h-bocx220.
    ASSIGN h-bocx220 = ?.

    RETURN "OK":U.

END PROCEDURE.


procedure openQueryprev:
    open query brprev for each tt-previsoes no-lock.    
end procedure.


procedure openQueryemb:
    open query bremb for each tt-embarques  no-lock.    
end procedure.


procedure trazrowidhistemb:
    define input  param p-cod-estab-idx  like historico-embarque.cod-estabel no-undo.
    define input  param p-embarque-idx   like historico-embarque.embarque    no-undo.
    define input  param p-cod-itiner-idx like historico-embarque.cod-itiner  no-undo.
    define output param p-rowid-idx      as   rowid                          no-undo.
    
    find first historico-embarque no-lock
         where historico-embarque.cod-estabel   = p-cod-estab-idx
         and   historico-embarque.embarque      = p-embarque-idx
         and   historico-embarque.cod-itiner    = p-cod-itiner-idx
         no-error.
    if avail historico-embarque then do:
       assign p-rowid-idx                       = rowid(historico-embarque).
       return "OK".
    end.       
    else return "NOK".
end.


procedure trazembarque:
    DEFINE INPUT  PARAMETER p-rowid     as rowid.
    DEFINE OUTPUT PARAMETER p-embarque  like historico-embarque.embarque.

    find first historico-embarque no-lock 
         where rowid(historico-embarque) = p-rowid no-error.
    if avail historico-embarque then
    do:
        assign p-embarque  = historico-embarque.embarque. 
    end.
end.


/* busca a temptable com os dados do embarque*/
PROCEDURE pi-retora-tt-historico-embarque:
    DEF INPUT PARAM p-cod-estabel LIKE historico-embarque.cod-estabel NO-UNDO.
    DEF INPUT PARAM p-embarque    LIKE historico-embarque.embarque    NO-UNDO.
    DEF INPUT PARAM p-cod-itiner  LIKE historico-embarque.cod-itiner  NO-UNDO.
    DEF INPUT PARAM p-pto-contr   LIKE historico-embarque.cod-pto-contr NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-historico-embarque.

        
    FOR FIRST historico-embarque NO-LOCK
        WHERE historico-embarque.cod-estabel   = p-cod-estabel 
        AND   historico-embarque.embarque      = p-embarque
        AND   historico-embarque.cod-itiner    = p-cod-itiner
        AND   historico-embarque.cod-pto-contr = p-pto-contr:

        BUFFER-COPY historico-embarque TO tt-historico-embarque.
        ASSIGN tt-historico-embarque.r-Rowid = ROWID(historico-embarque).

    END.
END.


/* BOCX230.P */


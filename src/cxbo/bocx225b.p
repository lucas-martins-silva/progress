/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX225B 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX225B MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX225B.P
**
**  ordens-embarque - Ordens Embarque
**
*******************************************************************************/

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.004
&scoped-define FIRST-TABLE-IN-QUERY tt-pedido-compr
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-pedido-compr

{include/boini.i}
{inbo/boin295.i RowObject}
{inbo/boin295.i tt-pedido-compr}
{cdp/cd4300.i3} /* Atributos livres */
{ccp/cc9019.i50} /* Atributos livres cotacao-item.char-1 */

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

def var r-chave-emb as rowid   no-undo.
def var de-ord-emb  as decimal no-undo.

procedure setConstraint1:
end procedure. 

procedure setConstraint2:
    def input parameter r-chave  as rowid no-undo.    
    
    &if '{&bf_mat_versao_ems}' >= '2.04' &then
        DEFINE INPUT PARAMETER v-cod-proces-imp-f      AS CHARACTER    nO-UNDO.
        DEFINE INPUT PARAMETER v-cod-proces-imp-i      AS CHARACTER    NO-UNDO.
        DEFINE INPUT PARAMETER v-num-ped-compra-f      AS INTEGER      NO-UNDO.
        DEFINE INPUT PARAMETER v-num-ped-compra-i      AS INTEGER      NO-UNDO.
        DEFINE INPUT PARAMETER v-num-ordem-compra-f    AS INTEGER      NO-UNDO.
        DEFINE INPUT PARAMETER v-num-ordem-compra-i    AS INTEGER      NO-UNDO.
        DEFINE INPUT PARAMETER v-cod-item-f            AS CHARACTER    NO-UNDO.
        DEFINE INPUT PARAMETER v-cod-item-i            AS CHARACTER    NO-UNDO.
        DEFINE INPUT PARAMETER v-dat-pedido-f          AS DATE         NO-UNDO.
        DEFINE INPUT PARAMETER v-dat-pedido-i          AS DATE         NO-UNDO.
    &endif
    
    for each tt-pedido-compr:
        delete tt-pedido-compr.
    end. 

    DEFINE VARIABLE i-pto-embarq AS INTEGER     NO-UNDO.

    assign r-chave-emb  = r-chave.
    for first embarque-imp fields(cod-estabel cod-incoterm cdn-pto-embarq) 
        where rowid(embarque-imp) = r-chave-emb no-lock: end.
    if  avail embarque-imp then do:
         for each processo-imp 
             fields(cod-estabel nr-proc-imp situacao cod-itiner num-pedido) where 
             processo-imp.cod-estabel = embarque-imp.cod-estabel 
             &if '{&bf_mat_versao_ems}' >= '2.04' &then
                and
                processo-imp.nr-proc-imp >= v-cod-proces-imp-i      and
                processo-imp.nr-proc-imp <= v-cod-proces-imp-f      
             &endif
             no-lock:

             if processo-imp.situacao >= 3 then 
                next.
             &if '{&bf_mat_versao_ems}' >= '2.04' &then
                IF processo-imp.num-pedido < v-num-ped-compra-i OR
                   processo-imp.num-pedido > v-num-ped-compra-f THEN NEXT.
             &endif
             
             FIND first itinerario where 
                 itinerario.cod-itiner = processo-imp.cod-itiner NO-LOCK NO-ERROR.

             ASSIGN i-pto-embarq = IF embarque-imp.cdn-pto-embarq > 0 THEN embarque-imp.cdn-pto-embarq ELSE itinerario.pto-embarque.
             
             FIND first historico-proc-imp where 
                 historico-proc-imp.cod-estabel   = processo-imp.cod-estabel and
                 historico-proc-imp.nr-proc-imp   = processo-imp.nr-proc-imp and
                 historico-proc-imp.cod-itiner    = processo-imp.cod-itiner  and
                 historico-proc-imp.cod-pto-contr = i-pto-embarq NO-LOCK NO-ERROR.
             IF AVAIL historico-proc-imp THEN
                 if historico-proc-imp.dt-efetiva = ? then
                    next.
             
             for first pedido-compr  
                 where pedido-compr.num-pedido = processo-imp.num-pedido 
                 &if defined(bf-mat-comex) &then                                             
                   and pedido-compr.situacao = "I" 
                 &else
                   and pedido-compr.situacao = 1                        
                 &endif   no-lock:
                 
                 &if '{&bf_mat_versao_ems}' >= '2.04' &then                   
                     IF pedido-compr.data-pedido < v-dat-pedido-i OR
                        pedido-compr.data-pedido > v-dat-pedido-f THEN NEXT.
                 &endif
                 
                 for each ordem-compra where
                     ordem-compra.num-pedido  = pedido-compr.num-pedido and
                     &if '{&bf_mat_versao_ems}' >= '2.04' &then
                         ordem-compra.numero-ordem >= v-num-ordem-compra-i  AND
                         ordem-compra.numero-ordem <= v-num-ordem-compra-f  AND
                     &endif
                     &if defined(bf-mat-comex) &then                                                                         
                       ordem-compra.situacao = "C" 
                     &else
                       ordem-compra.situacao = 2 
                     &endif 
                     no-lock:        
                     
                     &if '{&bf_mat_versao_ems}' >= '2.04' &then
                         IF ordem-compra.it-codigo < v-cod-item-i OR
                            ordem-compra.it-codigo > v-cod-item-f THEN NEXT.
                     &endif
                     
                     for first cotacao-item fields(char-1) where
                         cotacao-item.numero-ordem = ordem-compra.numero-ordem and
                         cotacao-item.cot-aprovada  no-lock: end.
                     if  avail cotacao-item then do:
                         &if defined(bf-mat-comex) &then
                           assign i-mapa-cotacao-i50  = int(substring(cotacao-item.char-1,6,2))
                                  c-cod-incoterm-i50  = substring(cotacao-item.char-1,8,3)
                                  i-cod-pto-contr-i50 = int(substring(cotacao-item.char-1,11,5)).
                         &else
                           {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                           {ccp/cc9019.i51 "yes"}
                         &endif
                            
                         if c-cod-incoterm-i50 <> embarque-imp.cod-incoterm then 
                            next.
                     end.
                     else next.    
                          
                     for each prazo-compra fields(numero-ordem parcela quantidade) where  
                         &if defined(bf-mat-comex) &then                                                                         
                           prazo-compra.situacao = "C" and
                         &else
                           prazo-compra.situacao = 2 and                              
                         &endif
                           prazo-compra.numero-ordem = ordem-compra.numero-ordem
                         no-lock:
                         assign de-ord-emb = 0.
                         
                         for each ordens-embarque fields(quantidade) where
                             ordens-embarque.numero-ordem = prazo-compra.numero-ordem and
                             ordens-embarque.parcela      = prazo-compra.parcela
                             no-lock:
                             assign de-ord-emb = de-ord-emb + ordens-embarque.quantidade.    
                         end.                  
                         
                         if de-ord-emb <> prazo-compra.quantidade then do:
                            find tt-pedido-compr where
                                 tt-pedido-compr.r-rowid = rowid(pedido-compr)
                                 no-error.
                            if   not avail tt-pedido-compr then do:
                                 create tt-pedido-compr.
                                 buffer-copy pedido-compr to tt-pedido-compr.
                                 assign tt-pedido-compr.r-rowid = rowid(pedido-compr).
                            end.
                         end.     
                     end.          
                 end.
             end.
         end.             
    end.    
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.    
        when 2 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.                
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
/*{include/bosersen.i}*/
{include/boprebro.i}

PROCEDURE retornaTTpedidocompr:
    
    def output parameter table for tt-pedido-compr.
    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
    
END PROCEDURE.

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
            reposition {&query-name} to rowid to-rowid(pcRowIdent) no-error.
            get next {&query-name}.
        END.
        ELSE IF piStartRow NE ? AND piStartRow NE 0 THEN DO:
            REPOSITION  {&query-name} TO ROW piStartRow no-error.
            GET next {&query-name}.
        END.
        IF plNext THEN
            GET next {&query-name}.
        DO WHILE true:
            if available({&first-table-in-query})  and piRowsReturned < piRowsToReturn then do:
                create rowObject.
                buffer-copy {&table-name} to rowObject.
                assign rowObject.r-rowid = rowid(tt-pedido-compr).
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
                REPOSITION  {&query-name} TO ROW (piStartRow) no-error.
        END.
    END.
    RETURN.
end procedure.

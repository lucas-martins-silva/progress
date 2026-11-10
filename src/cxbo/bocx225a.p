/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX225A 2.00.00.020 } /*** 010020 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX225A MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX225A.P
**
**  ordens-embarque - Ordens Embarque
**
*******************************************************************************/

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY ordem-compra
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-ordem-compra

{include/boini.i}

/*{inbo/boin274.i RowObject}*/

DEFINE TEMP-TABLE RowObject no-undo like ordem-compra
                  field d-data  as date format "99/99/9999"
                  field r-rowid   as rowid.

{cdp/cd4300.i3} /* Atributos livres */
{ccp/cc9019.i50} /* Atributos livres cotacao-item.char-1 */

DEFINE TEMP-TABLE tt-ordem-compra no-undo like ordem-compra
                  field d-data  as date format "99/99/9999"
                  field r-rowid   as rowid.

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

def var i-num-pedido like pedido-compr.num-pedido no-undo.
def var r-embarque   as rowid no-undo.

procedure setConstraint1:
end procedure.

procedure setConstraint2:
/*
** recebe numero do embarque e executa a procedure que vai montar a temp-table de ordens.
*/
    def input parameter r-chave as rowid no-undo.

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
    
    assign r-embarque = r-chave.
    &if '{&bf_mat_versao_ems}' >= '2.04' &then
        run criaTTordens(INPUT v-cod-proces-imp-f,  
                         INPUT v-cod-proces-imp-i,  
                         INPUT v-num-ped-compra-f,  
                         INPUT v-num-ped-compra-i,  
                         INPUT v-num-ordem-compra-f,
                         INPUT v-num-ordem-compra-i,
                         INPUT v-cod-item-f,        
                         INPUT v-cod-item-i,        
                         INPUT v-dat-pedido-f,      
                         INPUT v-dat-pedido-i).
    &else     
        run criaTTordens.
    &endif    
end procedure.

procedure setConstraint3:
/*
** recebe numero do pedido para filtrar ordens de compra de um determinado pedido de compra
*/
   def input parameter p-num-pedido like pedido-compr.num-pedido.

   assign i-num-pedido = p-num-pedido.

end procedure.

procedure setConstraint4:
/*
** recebe numero do embarque e executa a procedure que vai montar a temp-table de ordens.
*/
    def input parameter r-chave as rowid no-undo.
    
    assign r-embarque = r-chave.
    run criaTTordens.
   
end procedure.

procedure criaTTordens:


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

    def var de-ord-emb     as decimal no-undo.
    def var de-total       as decimal no-undo.
    def var r-cotacao-item as rowid   no-undo.
    def var i-pto-embarq   as int     no-undo.

    for each  tt-ordem-compra:
        delete tt-ordem-compra.
    end.    
    
    for first embarque-imp fields (cod-estabel cod-incoterm cdn-pto-embarq) where 
              rowid(embarque-imp) = r-embarque no-lock:         
        
        for each processo-imp fields (cod-estabel nr-proc-imp cod-itiner num-pedido situacao)  
            where processo-imp.cod-estabel = embarque-imp.cod-estabel
            &if '{&bf_mat_versao_ems}' >= '2.04' &then
               AND   processo-imp.nr-proc-imp >= v-cod-proces-imp-i 
               AND   processo-imp.nr-proc-imp <= v-cod-proces-imp-f 
            &endif
            no-lock:

            if processo-imp.situacao >= 3 then next.

            &if '{&bf_mat_versao_ems}' >= '2.04' &then
                IF processo-imp.num-pedido < v-num-ped-compra-i OR
                   processo-imp.num-pedido > v-num-ped-compra-f THEN NEXT.
            &endif
                                     
            FOR FIRST itinerario FIELDS(pto-embarque) 
                WHERE itinerario.cod-itiner = processo-imp.cod-itiner NO-LOCK: END.

            ASSIGN i-pto-embarq = IF embarque-imp.cdn-pto-embarq > 0 THEN embarque-imp.cdn-pto-embarq ELSE itinerario.pto-embarque.

            FIND FIRST historico-proc-imp NO-LOCK
                 WHERE historico-proc-imp.cod-estabel   = processo-imp.cod-estabel  
                   AND historico-proc-imp.nr-proc-imp   = processo-imp.nr-proc-imp  
                   AND historico-proc-imp.cod-itiner    = processo-imp.cod-itiner   
                   AND historico-proc-imp.cod-pto-contr = i-pto-embarq NO-ERROR.
            IF AVAIL historico-proc-imp THEN
                if historico-proc-imp.dt-efetiva = ? then next.
            
            for first pedido-compr fields (num-pedido cod-emitente data-pedido) 
               where pedido-compr.num-pedido = processo-imp.num-pedido 
               &if defined(bf-mat-comex) &then                                             
                 and pedido-compr.situacao = "I"
               &else
                 and pedido-compr.situacao = 1 
               &endif
               no-lock:

               &if '{&bf_mat_versao_ems}' >= '2.04' &then               
                  IF pedido-compr.data-pedido < v-dat-pedido-i OR
                     pedido-compr.data-pedido > v-dat-pedido-f THEN NEXT.
               &endif
               
               /* filtra ordens de determinado pedido - setconstraint3 */
               if i-num-pedido <> 0 and 
                  pedido-compr.num-pedido <> i-num-pedido then
                  next. 

               for each ordem-compra
                   where ordem-compra.num-pedido = pedido-compr.num-pedido 
                   &if '{&bf_mat_versao_ems}' >= '2.04' &then
                      AND   ordem-compra.numero-ordem >= v-num-ordem-compra-i
                      AND   ordem-compra.numero-ordem <= v-num-ordem-compra-f
                   &endif
                   &if defined(bf-mat-comex) &then                                             
                     and ordem-compra.situacao = "C"                            
                   &else
                     and ordem-compra.situacao = 2          
                   &endif
                   no-lock:

                   &if '{&bf_mat_versao_ems}' >= '2.04' &then                    
                       IF ordem-compra.it-codigo < v-cod-item-i OR
                          ordem-compra.it-codigo > v-cod-item-f THEN NEXT.
                   &endif
                   
                   for each cotacao-item fields(cotacao-item.char-1 aliquota-icm)
                       where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                       and   cotacao-item.cod-emitente = pedido-compr.cod-emitente
                       and   cotacao-item.cot-aprovada no-lock:
                          &if defined(bf-mat-comex) &then
                              assign i-mapa-cotacao-i50  = int(substring(cotacao-item.char-1,6,2))
                                     c-cod-incoterm-i50  = substring(cotacao-item.char-1,8,3)
                                     i-cod-pto-contr-i50 = int(substring(cotacao-item.char-1,11,5)).
                          &else
                              {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                              {ccp/cc9019.i51 "yes"}
                          &endif
                          leave.                            
                   end.
                                                                       
                   if c-cod-incoterm-i50 <> embarque-imp.cod-incoterm then 
                      next.
                                      
                   assign de-total   = 0
                          de-ord-emb = 0.
                   
                   for each prazo-compra fields (numero-ordem quantidade quant-saldo parcela) where
                       &if defined(bf-mat-comex) &then                                                                             
                         prazo-compra.situacao = "C" and
                       &else
                         prazo-compra.situacao = 2 and      
                       &endif  
                         prazo-compra.numero-ordem = ordem-compra.numero-ordem
                       no-lock:
                         
                       assign de-total = de-total + prazo-compra.quantidade. /*quant-saldo*/     
                       
                       for each ordens-embarque fields (quantidade)
                           where ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                           and   ordens-embarque.parcela      = prazo-compra.parcela
                           no-lock:
                           assign de-ord-emb = de-ord-emb + ordens-embarque.quantidade.
                       end.                  
                   end.

                   if de-total > de-ord-emb then do:
                      find tt-ordem-compra where 
                           tt-ordem-compra.r-rowid = rowid(ordem-compra) no-error.
                      if not avail tt-ordem-compra then do:
                          create tt-ordem-compra.
                          buffer-copy ordem-compra to tt-ordem-compra.
                          assign tt-ordem-compra.r-rowid = rowid(ordem-compra).
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
            open query {&QUERY-NAME} for each {&TABLE-NAME} NO-LOCK
                BY {&table-name}.numero-ordem.
        when 3 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.    
        when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                BY {&table-name}.it-codigo
                BY {&table-name}.numero-ordem.
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

PROCEDURE serverSendRows :

    /*
    **  Disponivel no smart data object da V9, e foi reimplementado dentro
    **  da versao 8. Faz consultas utilizando a querie dentro da smartquery,
    **  possibilitando que clientes WebSpeed acessem esta mesma smart-query
    **  e facilitara a migracao destes programas para os Smart Data Objects.
    */
    DEFine input  parameter piStartRow     as  integer   no-undo.
    DEFine input  parameter pcRowIdent     as  character no-undo.
    DEFine input  parameter plNext         as  logical   no-undo.
    DEFine input  parameter piRowsToReturn as  integer   no-undo.
    DEFine output parameter piRowsReturned as  integer   no-undo.
    DEFine output parameter table          for RowObject.
 
    DEFine variable hQuery        as handle    no-undo.
    DEFine variable hBuffer       as handle    no-undo.
    DEFine variable hRowObject    as handle    no-undo.
    DEFine variable hDataQuery    as handle    no-undo.
    DEFine variable cRowIdent     as character no-undo.
    DEFine variable rRowIDs       as rowid     extent 10 no-undo.
    DEFine variable lOK           as logical   no-undo.
    DEFine variable iRow          as integer   no-undo.
 
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
                /* assign rowobject.r-rowid = {&table-name}.r-rowid. */
                assign rowObject.r-rowid = rowid({&table-name}).
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
END PROCEDURE.

PROCEDURE retornaTTordemcompra:
    
    def output parameter table for tt-ordem-compra.
    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
        BY {&table-name}.numero-ordem.
    
END PROCEDURE.

procedure criaTTordem-compra:
    
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
    def output parameter                    table for tt-ordem-compra.

    def var de-ord-emb     as decimal no-undo.
    def var de-total       as decimal no-undo.
    def var r-cotacao-item as rowid   no-undo.
    def var v-data         as date    no-undo.
    
    for each  tt-ordem-compra:
        delete tt-ordem-compra.
    end.    
    
    for each processo-imp FIELDS(cod-estabel situacao cod-itiner nr-proc-imp num-pedido)
        where processo-imp.cod-estabel >= p-cod-estab-ini
        and   processo-imp.cod-estabel <= p-cod-estab-fim
        and   processo-imp.nr-proc-imp >= p-cod-proc-imp-ini
        and   processo-imp.nr-proc-imp <= p-cod-proc-imp-fim
        no-lock:
        
        for first param-imp field (hist-processo) no-lock
            where param-imp.cod-estabel = processo-imp.cod-estabel: 
            
            if processo-imp.situacao >= 3 then
               next.
            
            FIND FIRST itinerario 
                 WHERE itinerario.cod-itiner = processo-imp.cod-itiner NO-LOCK NO-ERROR.

            IF AVAIL itinerario THEN DO:
               FIND FIRST historico-proc-imp where
                          historico-proc-imp.cod-estabel   = processo-imp.cod-estabel and
                          historico-proc-imp.nr-proc-imp   = processo-imp.nr-proc-imp and 
                          historico-proc-imp.cod-itiner    = processo-imp.cod-itiner  and 
                          historico-proc-imp.cod-pto-contr = itinerario.pto-embarque  NO-LOCK NO-ERROR.
               IF AVAIL historico-proc-imp THEN
                  if param-imp.hist-processo = yes and 
                     historico-proc-imp.dt-efetiva = ? THEN next.
               
            end.           
                    
            find pedido-compr 
                where pedido-compr.num-pedido = processo-imp.num-pedido
                no-lock no-error.
            if avail pedido-compr then do:
               if pedido-compr.num-pedido < p-cod-ped-compra-ini or
                  pedido-compr.num-pedido > p-cod-ped-compra-fim 
               then next.
               
               if pedido-compr.cod-emitente < p-cod-fornec-ini or
                  pedido-compr.cod-emitente > p-cod-fornec-fim 
               then next. 
               
               &if defined(bf-mat-comex) &then                                             
                   if pedido-compr.situacao <> "I" then
                      next.
               &else
                   if pedido-compr.situacao <> 1 then
                      next.                  
               &endif
                
               for each ordem-compra where 
                   ordem-compra.num-pedido = pedido-compr.num-pedido and
                   &if defined(bf-mat-comex) &then                                             
                     ordem-compra.situacao = "C"  
                   &else
                     ordem-compra.situacao = 2                        
                   &endif  no-lock:
                   
                   if ordem-compra.numero-ordem < p-cod-ord-compra-ini or
                      ordem-compra.numero-ordem > p-cod-ord-compra-fim
                   then next.
                   
                   if ordem-compra.it-codigo < p-cod-item-ini or
                      ordem-compra.it-codigo > p-cod-item-fim
                   then next.                               
                    
                   for each cotacao-item fields(cotacao-item.cot-aprovada cotacao-item.char-1)
                       where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                       and   cotacao-item.cod-emitente = pedido-compr.cod-emitente 
                       no-lock:
                       
                       if substring(cotacao-item.char-1,21,20) < p-cod-incoterm-ini or
                          substring(cotacao-item.char-1,21,20) > p-cod-incoterm-fim 
                       then next.
                       
                       if cotacao-item.cot-aprovada then do:                          
                          &if defined(bf-mat-comex) &then
                              assign i-mapa-cotacao-i50  = int(substring(cotacao-item.char-1,6,2))
                                     c-cod-incoterm-i50  = substring(cotacao-item.char-1,8,3)
                                     i-cod-pto-contr-i50 = int(substring(cotacao-item.char-1,11,5)).
                          &else
                              {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                              {ccp/cc9019.i51 "yes"}
                          &endif
                          leave.
                       end.                            
                   end.                                
                                      
                   assign de-total   = 0
                          de-ord-emb = 0.
                    
                   for each prazo-compra fields (quant-saldo numero-ordem quantidade parcela) where
                       &if defined(bf-mat-comex) &then                                                                             
                         prazo-compra.situacao = "C" and                         
                       &else
                         prazo-compra.situacao = 2 and                                                   
                       &endif  
                         prazo-compra.numero-ordem = ordem-compra.numero-ordem
                       no-lock:  
                       ASSIGN de-total = de-total + prazo-compra.quantidade.     
                       for each ordens-embarque fields (quantidade)
                           where ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                           and   ordens-embarque.parcela      = prazo-compra.parcela
                           no-lock:
                           assign de-ord-emb = de-ord-emb + ordens-embarque.quantidade.
                       end.                  
                   end.
                   
                   if de-total > de-ord-emb then do:
                      find tt-ordem-compra 
                         where tt-ordem-compra.r-rowid = rowid(ordem-compra)
                         no-error.
                      if not avail tt-ordem-compra then do:
                         create tt-ordem-compra.
                         buffer-copy ordem-compra to tt-ordem-compra.
                         assign tt-ordem-compra.r-rowid = rowid(ordem-compra).
                      end.
                   end.
                   find tt-ordem-compra 
                        where tt-ordem-compra.r-rowid = rowid(ordem-compra)
                        no-error.
                   if avail tt-ordem-compra then do:
                        run DataEntrega in this-procedure (input  tt-ordem-compra.numero-ordem,
                                                           output v-data).
                        assign tt-ordem-compra.d-data = v-data.
                   end.
               end.
            end.
        end.    
    end.
end procedure.
procedure DataEntrega:
    DEF INPUT  PARAMETER p-numero-ordem like ordem-compra.numero-ordem      NO-UNDO.
    DEF OUTPUT PARAMETER p-data-entrega like prazo-compra.data-entrega      NO-UNDO.
    
    def var i-quant like ordens-embarque.quantidade no-undo.    
    def buffer      bf-ordens-embarque  for  ordens-embarque                .
    
    find first prazo-compra no-lock 
       where prazo-compra.numero-ordem = p-numero-ordem
       and   prazo-compra.situacao     = &if defined(bf-mat-comex) 
                                         &then "C"
                                         &else  2
                                         &endif
       no-error.
    if avail prazo-compra then do:  
       assign p-data-entrega = prazo-compra.data-entrega. 
       repeat:
           find first ordens-embarque no-lock
               where ordens-embarque.numero-ordem = p-numero-ordem
               and   ordens-embarque.parcela      = prazo-compra.parcela no-error.
               assign i-quant = 0.
           if avail ordens-embarque then do:     
               for each  bf-ordens-embarque no-lock
                   where bf-ordens-embarque.numero-ordem = ordens-embarque.numero-ordem
                   and   bf-ordens-embarque.parcela      = ordens-embarque.parcela:
                   assign i-quant = i-quant + bf-ordens-embarque.quantidade.
               end.        
                           
               if  i-quant = prazo-compra.quantidade then do:
                   find next prazo-compra no-lock 
                       where prazo-compra.numero-ordem = p-numero-ordem no-error.       
                   if avail prazo-compra then
                      assign p-data-entrega = prazo-compra.data-entrega.    
                   else leave.   
               end.
               else leave.
                                                      
           end.                    
           else leave.     
       end.
    end.
end.

Procedure trazrowidordemcompra:
    DEF INPUT  PARAMETER p-numero-ordem like ordem-compra.numero-ordem NO-UNDO.
    DEF OUTPUT PARAMETER p-rowid        as   rowid                     NO-UNDO.
    FIND FIRST ordem-compra no-lock
         WHERE ordem-compra.numero-ordem = p-numero-ordem no-error.
    IF AVAIL ordem-compra THEN
    DO:
        ASSIGN p-rowid = rowid(ordem-compra).
    end.     
end.

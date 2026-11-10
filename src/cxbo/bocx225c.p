/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX225C 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX225C MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX225.P
**
**  ordens-embarque - Ordens Embarque
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY ordens-embarque
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME ordens-embarque

{include/boini.i}
{cxbo/bocx225.i RowObject}
{cxbo/bocx225.i tt-ordens} /* Para elimina‡Æo das ordens embarque */


DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

def var c-embarque     as char    no-undo. 
def var c-est          as char    no-undo.
def var i-numero-ordem as integer no-undo.
def var l-atual        as logical no-undo.
def var i-pto-emb      as integer no-undo.

procedure setConstraint1:
end procedure. 

procedure setConstraint2:
    def input parameter p-embarque   as char no-undo.
    def input parameter p-cod-est    as char no-undo.

    assign c-embarque  = p-embarque
           c-est       = p-cod-est.
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.    
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                where ordens-embarque.embarque    = c-embarque and
                      ordens-embarque.cod-estabel = c-est.                        
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
{include/boexedel.i}
/* {include/bovaldel.i} */

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
     
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.

 
procedure validateFields:
    
    find first rowObject no-lock no-error.
 
    run startMethod ("validateFields").    
     
    run endMethod ("validateFields").
 
end procedure.

procedure validateDelete:
    /*
    **  Valida Delete
    */
    def input-output parameter r-chave as rowid.
    def output parameter table for tt-bo-erro.
 
    run InitializeValidate.
 
    find {&TABLE-NAME} where
        rowid({&TABLE-NAME}) = r-chave
        exclusive-lock no-error.
    if avail {&TABLE-NAME} then do:
        find processo-imp where 
             processo-imp.nr-proc-imp = {&TABLE-NAME}.nr-proc-imp and
             processo-imp.cod-estabel = {&TABLE-NAME}.cod-estabel 
             exclusive-lock no-error.
        if  avail processo-imp then do:                 
        
            for each tt-ordens:
                delete tt-ordens.
            end.
 
            for each decl-hist-embarq-imp where
                     decl-hist-embarq-imp.cod-estabel = {&TABLE-NAME}.cod-estabel and
                     decl-hist-embarq-imp.embarque    = {&TABLE-NAME}.embarque    and
                     decl-hist-embarq-imp.cod-itiner  = processo-imp.cod-itiner
                     exclusive-lock:
                delete decl-hist-embarq-imp.     
            end.             
            for each  historico-embarque where
                      historico-embarque.cod-estabel = {&TABLE-NAME}.cod-estabel and
                      historico-embarque.embarque    = {&TABLE-NAME}.embarque    and
                      historico-embarque.cod-itiner  = processo-imp.cod-itiner
                      exclusive-lock:                  
                delete historico-embarque.     
            end.
            for each desp-embarque where
                     desp-embarque.cod-estabel = {&TABLE-NAME}.cod-estabel and
                     desp-embarque.embarque    = {&TABLE-NAME}.embarque
                     exclusive-lock:
                delete desp-embarque.
            end.
            run executeDelete.
            
            find itinerario where
                 itinerario.cod-itiner = processo-imp.cod-itiner no-lock no-error.
            IF AVAIL itinerario THEN
                assign i-pto-emb = itinerario.pto-embarque.
            
            find first param-imp where
                       param-imp.cod-estabel = processo-imp.cod-estabel no-lock no-error.
            if   avail param-imp then do:           

                 find ordem-compra where
                      ordem-compra.num-pedido = processo-imp.num-pedido no-lock no-error.
                 if   avail ordem-compra then do:
                      for each prazo-compra where
                               prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:
                          find ordens-embarque where
                               ordens-embarque.nr-proc-imp  = processo-imp.nr-proc-imp  and
                               ordens-embarque.cod-estabel  = processo-imp.cod-estabel  and
                               ordens-embarque.numero-ordem = prazo-compra.numero-ordem and       
                               ordens-embarque.parcela      = prazo-compra.parcela 
                               no-lock no-error.
                          if   avail ordens-embarque then do:
                               create tt-ordens.
                               buffer-copy ordens-embarque to tt-ordens.
                          end.  
                      end.         
                 end.     
                 find first tt-ordens no-error.
                 if   avail tt-ordens then do:
                     if   param-imp.hist-processo then
                          assign processo-imp.situacao = 2.
                     else do:
                          find embarque-imp where
                               embarque-imp.cod-estabel = tt-ordens.cod-estabel and
                               embarque-imp.embarque    = tt-ordens.embarque no-lock no-error.
                          if   avail embarque-imp then do:
                               IF embarque-imp.cdn-pto-embarq > 0 THEN
                                   ASSIGN i-pto-emb = embarque-imp.cdn-pto-embarq.
                               find historico-embarque where
                                    historico-embarque.cod-estabel   = embarque-imp.cod-estabel and
                                    historico-embarque.embarque      = embarque-imp.embarque    and
                                    historico-embarque.cod-itiner    = processo-imp.cod-itiner  and
                                    historico-embarque.cod-pto-contr = i-pto-emb
                                    no-lock no-error.
                               if   avail historico-embarque then do:
                                    if    historico-embarque.dt-efetiva <> ? then 
                                          assign processo-imp.situacao = 2.
                               end.
                          end.     
                     end.    
                 end.    
                 else assign processo-imp.situacao = 1.                                                   
            end.    
        end.        
    end.
 
    if l-query then
        get next {&QUERY-NAME}
            no-lock no-wait.
    else
        find next {&TABLE-NAME}
            no-lock no-error.

    if not avail {&TABLE-NAME} then do:
       if l-query then
           get prev {&QUERY-NAME}
               no-lock no-wait.
       else
           find prev {&TABLE-NAME}
               no-lock no-error.
    end.
    assign r-chave = rowid({&TABLE-NAME}).
    return "".
end procedure.



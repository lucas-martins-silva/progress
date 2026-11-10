/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX295 2.00.00.025 } /*** "010025" 07/10/2024 16:59:55 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx295 MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX295.P
**
**  invoice-emb-imp - Invoice
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY invoice-emb-imp
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME invoice-emb-imp

{include/boini.i}
{cxbo/bocx295.i RowObject}
{cdp/cdcfgmat.i} /* Include pre-processadores Magnus */
{cdp/cd4300.i3}  /* Include para desmembrar atributos livres */
{ccp/cc9019.i50} /* Include para atributos livres (cotacao-item). */

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

def var c-invoice      as char    no-undo.
def var c-estabel      as char    no-undo.
def var c-embarque     as char    no-undo.
def var de-valor-emb   as decimal no-undo.
def var de-valor-inv   as decimal no-undo.
def var de-unit        as decimal no-undo.
def var dat-tipo-dia   like calen-coml.tipo-dia no-undo. /*CD9020.i7*/

/* Miniflexibiliza‡Æo Cƒmbio */
{cdp/cdcfgfin.i}

def temp-table tt-documentos NO-UNDO
    field nr-documento  as character
    field tipo          as integer
    field dt-trans      as date.

&if defined(bf-mat-comex) &then
    def var da-partida as date format "99/99/9999" no-undo.
    def var da-inicio as date format "99/99/9999" no-undo.
    def var da-vencto-ant   as date format "99/99/9999" no-undo.
&endif

procedure setConstraint1:
end procedure.

procedure setConstraint2:
    def input parameter p-invoice as char no-undo.

    assign c-invoice    = p-invoice.
    
end procedure.

procedure setConstraint3:
    def input parameter c-est as char no-undo.
    def input parameter c-emb as char no-undo.

    assign c-estabel  = c-est
           c-embarque = c-emb.
    
end procedure.

procedure setConstraint4:
    def input parameter r-estab as rowid no-undo.

    find embarque-imp where rowid(embarque-imp) = r-estab no-lock no-error.
        
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.    
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                              {&TABLE-NAME}.nr-invoice >= c-invoice
                                              no-lock.
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                              {&TABLE-NAME}.cod-estabel = c-estabel and
                                              {&TABLE-NAME}.embarque    = c-embarque
                                              no-lock.                                                  
        when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} of embarque-imp 
                 no-lock by invoice-emb-imp.cod-estabel.
    end case.
    assign l-query    = true
           i-bo-query = i-abertura.
end procedure.
 
{include/bostrmet.i}
{include/boendmet.i}
&if defined(bf-mat-comex) &then
&else
    {include/bocomver.i}
    {include/bogetver.i}
&endif
{include/bonav.i}
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
{include/boexecre.i} 
/* {include/boexeupt.i} */
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
 
procedure findInvoice:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-cod-estabel as char no-undo.
    def input parameter c-embarque    as char no-undo.
    def input parameter c-nr-invoice  as char no-undo.
    def input parameter c-parcela     as char no-undo.
    def output parameter c-return     as char no-undo.
    
    run startMethod ("find":U).
         
    find {&table-name} where {&table-name}.cod-estabel = c-cod-estabel and
                             {&table-name}.embarque    = c-embarque    and
                             {&table-name}.nr-invoice  = c-nr-invoice  and
                             {&table-name}.parcela     = c-parcela 
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
    run endMethod   ("find":U).    
end procedure.

procedure executeUpdate:
    /*
    **  Executa Update
    */
    
    buffer-copy RowObject except r-rowid cod-estabel embarque nr-invoice parcela to {&TABLE-NAME}.
end procedure.

procedure validateFields:
    /*
    **  Valida Fields
    */
    
    run startMethod("validateFields":U).
    
    find first rowObject  no-lock no-error.
    
    if rowObject.dt-vencim = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} dt-vencim 1}
        run utp/ut-msgs.p (input "msg",
                           input 7965,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 7965
               tt-bo-erro.mensagem     = return-value.
    end.
    
    if not can-find(moeda where moeda.mo-codigo = rowObject.mo-codigo) then do:
       assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-table.i mguni moeda 1}
       run utp/ut-msgs.p (input "msg",
                          input 2,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen = i-seq-erro
              tt-bo-erro.cd-erro  = 2
              tt-bo-erro.mensagem = return-value.
    end.           
    
    if rowObject.vl-invoice = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} vl-invoice 1}
        run utp/ut-msgs.p (input "msg",
                           input 7965,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 7965
               tt-bo-erro.mensagem     = return-value.
    end.

    run endMethod("validateFields":U).
end procedure.

procedure validateCreate:
    /*
    **  Valida cria‡Æo da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
    
    run startMethod("validateCreate":U).    
 
    run initializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    find first rowObject no-error.
    
    if rowObject.cod-estabel = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-estabel 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else do:
         if not can-find(estabelec where estabelec.cod-estabel = rowObject.cod-estabel) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgadm estabelec 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
         end. 
    end.
    
    if rowObject.embarque = "" then do:
       assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-field.i mgcex {&TABLE-NAME} embarque 1}
       run utp/ut-msgs.p (input "msg",
                          input 265,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 265
              tt-bo-erro.mensagem     = return-value.
    end.             
    else do:
         if  not can-find(embarque-imp where 
                          embarque-imp.cod-estabel = RowObject.cod-estabel AND
                          embarque-imp.embarque = rowObject.embarque) then do:
             assign i-seq-erro = i-seq-erro + 1.
             {utp/ut-table.i mgcex embarque-imp 1}
             run utp/ut-msgs.p (input "msg",
                                input 2,
                                input return-value).
             create tt-bo-erro.
             assign tt-bo-erro.i-sequen = i-seq-erro
                    tt-bo-erro.cd-erro  = 2
                    tt-bo-erro.mensagem = return-value.  
         end.
    end.
    
    if rowObject.nr-invoice = "" then do:
       assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-field.i mgcex {&TABLE-NAME} nr-invoice 1}
       run utp/ut-msgs.p (input "msg",
                          input 265,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 265
              tt-bo-erro.mensagem     = return-value.
    end.
    
    if rowObject.parcela = "" then do:
       assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-field.i mgcex {&TABLE-NAME} parcela 1}
       run utp/ut-msgs.p (input "msg",
                          input 265,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 265
              tt-bo-erro.mensagem     = return-value.
    end.    
    
    run validateFields.
    
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find {&table-name} where
             {&table-name}.cod-estabel = rowObject.cod-estabel and
             {&table-name}.embarque    = rowObject.embarque    and
             {&table-name}.nr-invoice  = rowObject.nr-invoice  and
             {&table-name}.parcela     = rowObject.parcela
            no-lock no-error.
        if avail {&table-name} then do:
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
    
    find first tt-bo-erro
        no-lock no-error.
 
    if not avail tt-bo-erro then do:
        run executeCreate.
        assign r-chave = to-rowid(return-value).
    end.
    run endMethod("validateCreate":U).
end procedure.

procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "embarque"    then c-value = RowObject.embarque.
        when "nr-invoice"  then c-value = RowObject.nr-invoice.
        when "parcela"     then c-value = RowObject.parcela.
        when "char-1"      then c-value = RowObject.char-1.
        when "char-2"      then c-value = RowObject.char-2.
        when "check-sum"   then c-value = RowObject.check-sum.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:        
        when "vl-invoice" then c-value = RowObject.vl-invoice.
        when "dec-1"      then c-value = RowObject.dec-1.
        when "dec-2"      then c-value = RowObject.dec-2.
        otherwise return error.
    end case.
end procedure.

procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "mo-codigo" then c-value = RowObject.mo-codigo.
        when "int-1"     then c-value = RowObject.int-1.
        when "int-2"     then c-value = RowObject.int-2.        
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "dt-vencim" then c-value = RowObject.dt-vencim.
        when "data-1"    then c-value = RowObject.data-1.
        when "data-2"    then c-value = RowObject.data-2.        
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


procedure inicializarFaturaordem:
    /*
    ** Sugere valor para a cria‡Æo das faturas
    */ 
    def input  parameter p-cod-estabel like estabelec.cod-estabel      no-undo.
    def input  parameter p-embarque    like embarque-imp.embarque      no-undo.
    def output parameter p-vl-invoice  like invoice-emb-imp.vl-invoice no-undo.
    def output parameter p-dt-vencim   like invoice-emb-imp.dt-vencim  no-undo.
    def output parameter p-mo-codigo   like invoice-emb-imp.mo-codigo  no-undo.
     
    def var de-preco-total    like cotacao-item.preco-unit    no-undo.
    def var de-preco-unit     like cotacao-item.preco-unit    no-undo.
    def var da-data-efetiva   as   date                       no-undo.
    def var i-ind             as   integer                    no-undo.
    def var i-avanco          as   int                        no-undo.    
    def var de-vl-invoice     like invoice-emb-imp.vl-invoice no-undo.
    def var de-vl-invoice-aux like invoice-emb-imp.vl-invoice no-undo.
    def var de-vl-inv-parc    like invoice-emb-imp.vl-invoice no-undo.
    def var de-vl-inv-acul    like invoice-emb-imp.vl-invoice no-undo.
    def var de-parcela        like invoice-emb-imp.vl-invoice no-undo.
    def var da-dt-vencim      like invoice-emb-imp.dt-vencim  no-undo.    
    def var da-data           as   date                       no-undo extent 12.
    def var da-partida        as   date                       no-undo.    
    def var de-total-ordens   like cotacao-item.preco-unit    no-undo.
    def var i-mo-codigo       like cotacao-item.mo-codigo     no-undo.
    def var i-cod-cond-pag    like cotacao-item.cod-cond-pag  no-undo.
    def var i-cod-emitente    like emitente.cod-emitente      no-undo.
    
    {cxbo/bocx295.i1} /* C lculo valor faturas/data de partida */    
            
    for each invoice-emb-imp fields(mo-codigo vl-invoice)
        where invoice-emb-imp.cod-estabel = p-cod-estabel
          and invoice-emb-imp.embarque    = p-embarque
          no-lock:
        assign de-vl-invoice-aux = invoice-emb-imp.vl-invoice.      
        if invoice-emb-imp.mo-codigo <> i-mo-codigo then do:
            run cdp/cd0812.p (input invoice-emb-imp.mo-codigo,
                              input i-mo-codigo,
                              input invoice-emb-imp.vl-invoice,
                              input today,
                              output de-vl-invoice-aux).
            if de-vl-invoice-aux = 0 or
               de-vl-invoice-aux = ? then
                assign de-vl-invoice-aux = invoice-emb-imp.vl-invoice.
        end.
        assign de-vl-invoice = de-vl-invoice + de-vl-invoice-aux.
    end.
    
    find cond-pagto
        where cond-pagto.cod-cond-pag = i-cod-cond-pag no-lock no-error.
    if avail cond-pagto then do:
    
        assign da-data    = today
               da-partida = da-data-efetiva.               

        find emitente
            where emitente.cod-emitente = i-cod-emitente no-lock no-error.
               
        {cdp/cd9020.i7 p-cod-estabel a} /* calculo data de vencimento */
        
        assign de-vl-inv-parc = 0
               de-vl-inv-acul = 0.
        
        do  i-ind = 1 to cond-pagto.num-parcelas:
            
            if p-vl-invoice <> 0 then leave.
               
            assign de-parcela     = round(de-total-ordens * (cond-pagto.per-pg-dup[i-ind] / 100), 2).
            
            assign de-vl-inv-acul = de-vl-inv-acul + de-parcela.
    
            if de-vl-inv-acul > de-vl-invoice then
                assign de-vl-inv-parc = de-vl-inv-acul - de-vl-invoice.            
    
            if de-vl-inv-parc <> 0 then 
                assign p-vl-invoice = de-vl-inv-parc
                       p-dt-vencim  = da-data[i-ind]
                       p-mo-codigo  = i-mo-codigo.                       
                      
        end.
    end.
    
    RETURN "OK":U.    
end procedure.


procedure pi-busca-documentos:
    def input  parameter p-cod-estabel as  character no-undo.
    def input  parameter p-nr-embarque as  character no-undo.
    def input  parameter p-dt-trans    as  date      no-undo.
    def output parameter table         for tt-documentos.
    
    &if defined(BF_FIN_MODUL_CAMBIO) &then
        find first param-global no-lock no-error.
        if param-global.modulo-mec = yes then do:
            for each invoice-emb-imp
               where invoice-emb-imp.cod-estabel = p-cod-estabel
               and   invoice-emb-imp.embarque    = p-nr-embarque no-lock:
                
                create tt-documentos.
                assign tt-documentos.nr-documento = invoice-emb-imp.nr-invoice
                       tt-documentos.tipo         = 7
                       tt-documentos.dt-trans     = p-dt-trans.
            end.    
        end.
    &endif

    RETURN "OK":U.
end procedure.


procedure calculaValorInvoice:
    /*
    ** Calcula valor total da invoice
    */
    def input parameter  p-cod-estabel as char no-undo.
    def input parameter  p-embarque    as char no-undo.
    def output parameter p-total-ordens like cotacao-item.preco-unit no-undo.
    def output parameter p-mo-codigo   like moeda.mo-codigo no-undo.
    def output parameter table for tt-bo-erro.
    
    def var i-mo-codigo      like cotacao-item.mo-codigo  no-undo.
    def var i-cod-emitente   like emitente.cod-emitente   no-undo.
    DEF VAR de-vl-desp-aux   LIKE desp-embarque.val-desp       NO-UNDO.
    DEF VAR i-seq            AS INT FORMAT "999" NO-UNDO.
    DEF VAR de-pre-unit-for-sem-ipi LIKE ordem-compra.pre-unit-for NO-UNDO.
    
    /*
    ** Calcula valor total do material
    */ 
    for each ordens-embarque fields (numero-ordem qt-do-forn)
        where ordens-embarque.cod-estabel = p-cod-estabel
          and ordens-embarque.embarque    = p-embarque no-lock:
        for first ordem-compra fields (preco-fornec mo-codigo cod-emitente pre-unit-for aliquota-ipi)
            where ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:
            
            assign de-pre-unit-for-sem-ipi = (ordem-compra.pre-unit-for * 100) / (100 + ordem-compra.aliquota-ipi)
                   p-total-ordens          = p-total-ordens
                                           + (ordens-embarque.qt-do-forn * de-pre-unit-for-sem-ipi)
                   p-mo-codigo             = ordem-compra.mo-codigo
                   i-cod-emitente          = ordem-compra.cod-emitente.
        end.
    end.
    
    /* 
    ** Calcula valor total das despesas pagas ao fornecedor do material
    */

    FOR FIRST historico-embarque FIELDS(cod-itiner)
        WHERE historico-embarque.cod-estabel = p-cod-estabel
        AND   historico-embarque.embarque    = p-embarque NO-LOCK  :
    END.
    
    FOR FIRST embarque-imp FIELDS(cdn-pto-desembar)
        WHERE embarque-imp.cod-estabel = p-cod-estabel
          AND embarque-imp.embarque    = p-embarque NO-LOCK:
    END.

    FOR FIRST itinerario FIELDS(cod-itiner) NO-LOCK
        WHERE itinerario.cod-itiner =  historico-embarque.cod-itiner:

        FIND FIRST pto-itiner NO-LOCK
            WHERE  pto-itiner.cod-itiner    = itinerario.cod-itiner 
            AND    pto-itiner.cod-pto-contr = embarque-imp.cdn-pto-desembar  NO-ERROR.
        IF AVAIL pto-itiner THEN DO:
    
            FIND FIRST historico-embarque NO-LOCK
                 WHERE historico-embarque.cod-estabel    = p-cod-estabel
                 AND   historico-embarque.embarque       = p-embarque   
                 AND   historico-embarque.cod-itiner     = pto-itiner.cod-itiner 
                 AND   historico-embarque.cod-pto-contr  = pto-itiner.cod-pto-contr NO-ERROR.
            IF AVAIL historico-embarque  THEN
                assign i-seq = historico-embarque.sequencia.
        END.

        FOR EACH historico-embarque NO-LOCK
                 WHERE historico-embarque.cod-estabel    = p-cod-estabel
                 AND   historico-embarque.embarque       = p-embarque   
                 AND   historico-embarque.cod-itiner     = itinerario.cod-itiner  
                 AND   historico-embarque.sequencia      <= i-seq :
            
            FOR EACH  desp-embarque FIELDS (cod-emitente-desp val-desp mo-codigo cod-pto-contr)
                WHERE desp-embarque.cod-estabel   = p-cod-estabel 
                AND   desp-embarque.embarque      = p-embarque    
                AND   desp-embarque.cod-itiner    = historico-embarque.cod-itiner 
                AND   desp-embarque.cod-pto-contr = historico-embarque.cod-pto-contr  NO-LOCK:
                IF desp-embarque.mo-codigo <>  p-mo-codigo     THEN DO:
                   run cdp/cd0812.p (input desp-embarque.mo-codigo,
                                     input p-mo-codigo,
                                     input desp-embarque.val-desp,
                                     input today,
                                     output de-vl-desp-aux).
                   IF desp-embarque.cod-emitente-desp = i-cod-emitente THEN 
                       ASSIGN p-total-ordens = p-total-ordens + de-vl-desp-aux.
                END.
                ELSE DO:
                   if desp-embarque.cod-emitente-desp = i-cod-emitente then 
                       assign p-total-ordens = p-total-ordens + desp-embarque.val-desp.
                END.
            END.
        END.
    END.
    
    assign p-total-ordens = round(p-total-ordens,2).

end procedure.


procedure validarTotalInvoice:
    /*
    **  Valida o valor da fatura e consiste com o valor total do embarque.
    ** (valor total das faturas tem que ser <= valor total do embarque)
    */
    def input parameter p-cod-estabel as char no-undo.
    def input parameter p-embarque    as char no-undo.
    def output parameter table for tt-bo-erro.
    
    def var de-total-ordens  like invoice-emb-imp.vl-invoice no-undo.
    def var i-mo-codigo      like cotacao-item.mo-codigo     no-undo.

    def var c-return1        as   char no-undo.
    def var c-return2        as   char no-undo.
    def var c-return3        as   char no-undo. 
    def var de-total-invoice like cotacao-item.preco-unit no-undo.
    def var de-valor-aux     like cotacao-item.preco-unit no-undo.
    
    run calculaValorInvoice (input p-cod-estabel,
                             input p-embarque,
                             output de-total-ordens,
                             output i-mo-codigo,
                             output table tt-bo-erro).

    for each invoice-emb-imp fields(mo-codigo vl-invoice)
        where invoice-emb-imp.cod-estabel = p-cod-estabel and
              invoice-emb-imp.embarque    = p-embarque no-lock:
        assign de-valor-aux = invoice-emb-imp.vl-invoice.
        if invoice-emb-imp.mo-codigo <> i-mo-codigo then do:
            run cdp/cd0812.p (input invoice-emb-imp.mo-codigo,
                              input i-mo-codigo,
                              input invoice-emb-imp.vl-invoice,
                              input today,
                              output de-valor-aux).
            if de-valor-aux = 0 or
               de-valor-aux = ? then
                assign de-valor-aux = invoice-emb-imp.vl-invoice.
        end.
        assign de-total-invoice = de-total-invoice + de-valor-aux.
    end.
    
    assign de-total-invoice = round(de-total-invoice,2).
     
    /*
    ** Compara valor calculada para a invoice com o valor informado
    */
    if de-total-invoice <> de-total-ordens then do:
        {utp/ut-liter.i Moeda * L}
        assign c-return3 = return-value.
        {utp/ut-liter.i Valor_total_das_faturas * L}        
        assign c-return1 = trim(return-value) + " (" + trim(string(de-total-invoice,">>>>>,>>>,>>9.99")) + ") ".
        {utp/ut-liter.i nao * L}
        assign c-return1 = c-return1 + return-value.
        {utp/ut-liter.i valor_total_das_ordens_do_embarque * L}
        assign c-return2 = trim(return-value) + " (" + trim(string(de-total-ordens,">>>>>,>>>,>>9.99")) +
                           ") (" + c-return3 + " " + string(i-mo-codigo) + ").".
        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        assign tt-bo-erro.parametros = c-return1 + "~~" + c-return2.
        run utp/ut-msgs.p (input "msg",
                           input 18783,
                           input c-return1 + "~~" + c-return2).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 18783
               tt-bo-erro.mensagem = return-value.
        RETURN "NOK":U.
    end.

    RETURN "OK":U.
end procedure.


procedure geraFaturaEmbarque:
    /*
    ** Gera Faturas automaticamente para o Embarque
    */
    def input parameter p-cod-estabel like estabelec.cod-estabel      no-undo.
    def input parameter p-embarque    like embarque-imp.embarque      no-undo.
    def input parameter p-nr-invoice  like invoice-emb-imp.nr-invoice no-undo.
    def output parameter table for tt-bo-erro.
    
    def var de-preco-total    like cotacao-item.preco-unit    no-undo.
    def var de-preco-unit     like cotacao-item.preco-unit    no-undo.
    def var da-data-efetiva   as   date                       no-undo.
    def var i-ind             as   integer                    no-undo.
    def var i-avanco          as   int                        no-undo.    
    def var de-parcela        like invoice-emb-imp.vl-invoice no-undo.
    def var da-dt-vencim      like invoice-emb-imp.dt-vencim  no-undo.    
    def var da-data           as   date                       no-undo extent 12.
    def var da-partida        as   date                       no-undo.    
    def var de-total-ordens   like cotacao-item.preco-unit    no-undo.
    def var i-mo-codigo       like cotacao-item.mo-codigo     no-undo.
    def var i-cod-cond-pag    like cotacao-item.cod-cond-pag  no-undo.
    def var i-cod-emitente    like emitente.cod-emitente      no-undo.
    def var i-parcela         as   integer                    no-undo.
    
    {cxbo/bocx295.i1} /* C lculo valor faturas/data de partida */
    
    find cond-pagto
        where cond-pagto.cod-cond-pag = i-cod-cond-pag no-lock no-error.
    if avail cond-pagto then do:
    
        assign da-data    = today
               da-partida = da-data-efetiva.

        find emitente
            where emitente.cod-emitente = i-cod-emitente no-lock no-error.
               
        {cdp/cd9020.i7 p-cod-estabel a} /* calculo data de vencimento */        
        
        assign i-parcela      = 0.
        
        do  i-ind = 1 to cond-pagto.num-parcelas:            
            
            assign de-parcela     = de-total-ordens * (cond-pagto.per-pg-dup[i-ind] / 100)
                   i-parcela      = i-parcela + 1.

            if de-parcela <> 0 then do:
                create invoice-emb-imp.
                assign invoice-emb-imp.cod-estabel = p-cod-estabel
                       invoice-emb-imp.dt-vencim   = da-data[i-ind]
                       invoice-emb-imp.embarque    = p-embarque
                       invoice-emb-imp.mo-codigo   = i-mo-codigo                        
                       invoice-emb-imp.nr-invoice  = p-nr-invoice
                       invoice-emb-imp.parcela     = string(i-parcela)
                       invoice-emb-imp.vl-invoice  = de-parcela. 
            end.

        end.
    end.
    
    RETURN "OK":U.
end procedure.

/* BOCX295.P */


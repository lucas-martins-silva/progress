/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX305 2.00.00.050 } /*** "010050" 19/08/2026 16:23:25 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx305 MUT}
&ENDIF

/*******************************************************************************
** 
**  BOCX305.P
**
**  desp-cot-ordem - Despesas das Ordens por Grupo
**
*******************************************************************************/

{cdp/cdcfgmat.i} /* Definiá∆o de prÇ-processadores */
{cdp/cdcfgdis.i}

{utp/ut-glob.i}
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.005
&scoped-define FIRST-TABLE-IN-QUERY desp-cot-ordem
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME desp-cot-ordem
&scoped-define VALIDA-DESPESA no

{include/boini.i}
{cxbo/bocx305.i RowObject}
{cxbo/bocx095a.i}
{cxbo/bocx085.i tt-cotacao-item-cex}

{cdp/cd4300.i3} /* include tratamento atributo livre */
{cxbo/bocx250.i50} /* include tratamento atributo livre param-imp.char-1 */

{imp/im0091.i} /* include definic∆o temp-table tt-desp-rateio */
{imp/imapi006.i} /* tt-desp-ja-recalc */
{imp/imapi001.i}
def var l-desp-imposto as logical no-undo.

def var c-cod-agrup  like cot-ordem.cod-agrup no-undo.
def var i-mapa-ordem like cot-ordem.mapa-ordem no-undo.
def var l-gera-auto  as   logical no-undo.
DEF VAR l-passou       AS   LOGICAL NO-UNDO.
DEF VAR pr-rowid       AS ROWID NO-UNDO.
DEF VAR l-calculavalor AS LOGICAL NO-UNDO.
DEF VAR de-valor-calcula-im0015 LIKE desp-imp.val-desp NO-UNDO.
DEF VAR c-return-value AS CHAR NO-UNDO.
define variable c-parametro as character  no-undo.
define variable l-auto      as logical    no-undo.
def var h-bocx095c          as handle     no-undo.
DEFINE VARIABLE c-lbl-liter-2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lbl-liter-nao-encontrada-tabela-de-preco AS CHARACTER NO-UNDO.

DEFINE VARIABLE l-nt2024002   AS LOGICAL  NO-UNDO.
ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo).

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
define buffer bf{&TABLE-NAME} for {&TABLE-NAME}.

procedure setConstraint1:
end procedure. 

procedure setConstraint2:
def input parameter p-cod-agrup like cot-ordem.cod-agrup no-undo.
def input parameter p-mapa-ordem like cot-ordem.mapa-ordem no-undo.

assign c-cod-agrup  = p-cod-agrup
       i-mapa-ordem = p-mapa-ordem.
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.    
        when 2 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                where {&TABLE-NAME}.cod-agrup  = c-cod-agrup and
                      {&TABLE-NAME}.mapa-ordem = i-mapa-ordem.            
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
/* {include/bovaldel.i} */

procedure findDespesa:

    def input parameter c-cod-agrup     as char     no-undo.
    def input parameter i-mapa-ordem    as integer  no-undo.    
    def input parameter i-cod-emitente  as integer  no-undo.
    def input parameter i-cod-desp      as integer  no-undo.
    def output parameter c-return       as char     no-undo.

    find {&TABLE-NAME} 
        where {&TABLE-NAME}.cod-agrup         = c-cod-agrup and        
              {&TABLE-NAME}.mapa-ordem        = i-mapa-ordem and
              {&TABLE-NAME}.cod-emitente-desp = i-cod-emitente and
              {&TABLE-NAME}.cod-desp          = i-cod-desp
              no-lock no-error.
    if not avail {&TABLE-NAME} then
        find {&TABLE-NAME} 
            where {&TABLE-NAME}.cod-agrup         = c-cod-agrup and        
                  {&TABLE-NAME}.mapa-ordem        = i-mapa-ordem and
                  {&TABLE-NAME}.cod-emitente-desp = 0 and
                  {&TABLE-NAME}.cod-desp          = i-cod-desp
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

end procedure.

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
     
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.

procedure executeUpdate:
    /*
    **  Executa Update
    */    
    buffer-copy RowObject except r-rowid cod-agrup mapa-ordem cod-desp sequencia
        to {&TABLE-NAME}.
    
end procedure.

procedure validateCreatechave:
    /*
    ** Valida criaá∆o dos campos chaves do registro
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def var c-return1 as char no-undo.    
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    
    find first rowObject no-error.
    
    IF  NOT l-gera-auto THEN
        RUN validateImport.
    
    find first cot-ordem 
        where cot-ordem.cod-agrup    = rowObject.cod-agrup
          and cot-ordem.mapa-ordem   = rowObject.mapa-ordem
          and cot-ordem.cod-emitente = rowObject.cod-emitente-desp
          no-lock no-error.          
    if not avail cot-ordem then
       find first cot-ordem 
            where cot-ordem.cod-agrup    = rowObject.cod-agrup
              and cot-ordem.mapa-ordem   = rowObject.mapa-ordem
              no-lock no-error.
    if not l-gera-auto then    
        if rowObject.cod-emitente-desp = 0 then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex {&TABLE-NAME} cod-emitente-desp 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.        
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.    
        end.
        else do:
            find emitente where emitente.cod-emitente = rowObject.cod-emitente-desp no-lock no-error.
            if not avail emitente then do:
                assign i-seq-erro = i-seq-erro + 1.
               {utp/ut-field.i mgcex {&TABLE-NAME} cod-emitente-desp 1}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = return-value.
                run utp/ut-msgs.p (input "msg",
                                   input 2,
                                   input return-value).
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 2
                       tt-bo-erro.mensagem = return-value.        
            end.
            else do:
                 {cdp/cd2502.i} /* Se Ç fornecedor ou ambos */        
            end.        
        end.
    
    if rowObject.cod-desp = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-desp 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.    
    end.    
    else
        if not can-find(desp-imp where desp-imp.cod-desp = rowObject.cod-desp) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex desp-imp cod-desp 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.        
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.                
        end.
        
    if rowObject.mo-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} mo-codigo 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.    
    end.    
    else
        if not can-find(moeda where moeda.mo-codigo = rowObject.mo-codigo) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mguni moeda mo-codigo 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        end.

    /*frank - 09/05/05*/
    &if defined(bf-mat-comex) &then
        {cxbo/bocx085.i3} /* Validaá∆o Moeda */
    &else
       &IF "{&bf_mat_versao_ems}" < "2.04" &THEN
          {cxbo/bocx085.i3} /* Validaá∆o Moeda */
       &endif
    &endif
    /*fim frank - 09/05/05*/
    /* Validaá∆o Tabela de Preáo */            
        
    IF  NOT l-passou 
    and not l-desp-imposto 
    THEN DO:
        if rowObject.cod-cond-pag = ? OR rowObject.cod-cond-pag = 0 THEN DO:
            {cxbo/bocx085.i2 rowObject.nr-tab 
                             rowObject.cod-emitente-desp 
                             cot-ordem.cod-itiner 
                             cot-ordem.cod-incoterm
                             rowObject.cod-desp
                             ?
                             &VALIDA-DESPESA}
        END.
        ELSE DO:
           {cxbo/bocx085.i2 rowObject.nr-tab 
                             rowObject.cod-emitente-desp 
                             cot-ordem.cod-itiner 
                             cot-ordem.cod-incoterm
                             rowObject.cod-desp
                             rowObject.cod-cond-pag}   
               
        END.
    END.

end procedure.

PROCEDURE despesaImposto:
    DEFINE  INPUT PARAMETER p-cod-desp     LIKE rowObject.cod-desp   NO-UNDO.
    DEFINE  INPUT PARAMETER p-cod-agrup    LIKE rowObject.cod-agrup  NO-UNDO.
    DEFINE  INPUT PARAMETER p-mapa-ordem   LIKE rowObject.mapa-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER p-desp-imposto AS LOGICAL                NO-UNDO.

    if  not avail cot-ordem then
        find first cot-ordem
            where cot-ordem.cod-agrup    = rowObject.cod-agrup
              and cot-ordem.mapa-ordem   = rowObject.mapa-ordem no-lock no-error.                            

    find ordem-compra 
        where ordem-compra.numero-ordem = cot-ordem.numero-ordem no-lock no-error.
    IF AVAIL ordem-compra THEN DO:
        FIND FIRST param-imp 
             WHERE param-imp.cod-estabel = ordem-compra.cod-estabel no-lock no-error.
        FIND FIRST param-imp-trib 
             WHERE param-imp-trib.cod-estabel = ordem-compra.cod-estabel no-lock no-error.
    END.
    
    assign p-desp-imposto = no.

    /* Verifica se a despesa corresponde a um imposto */
    if  int(substr(param-imp.char-1,21,20)) = p-cod-desp
    or  param-imp.cdn-despes-impto-ipi      = p-cod-desp
    or  param-imp.cdn-despes-impto-pis      = p-cod-desp
    or  param-imp.cdn-despes-impto-cofins   = p-cod-desp
    or  param-imp.cdn-despes-impto-icms     = p-cod-desp
    OR (l-nt2024002 AND AVAIL param-imp-trib AND param-imp-trib.cdn-despes-impto-IBSUF  = p-cod-desp)
    OR (l-nt2024002 AND AVAIL param-imp-trib AND param-imp-trib.cdn-despes-impto-IBSMun = p-cod-desp)
    OR (l-nt2024002 AND AVAIL param-imp-trib AND param-imp-trib.cdn-despes-impto-CBS    = p-cod-desp)
    OR (l-nt2024002 AND AVAIL param-imp-trib AND param-imp-trib.cdn-despes-impto-IS     = p-cod-desp) then   
        assign p-desp-imposto = yes.

END PROCEDURE.

procedure validateCreate:

    /*
    **  Valida criaá∆o da tabela/duplicidade de registro.
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
    
    run validateCreatechave(input table rowObject,
                            output table tt-bo-erro).


    IF rowobject.cod-emitente-desp <> 0 AND rowobject.cod-pto-contr = 0 THEN DO:
        for first emitente-cex fields(cod-emitente cod-pto-contr nr-tab )
            where emitente-cex.cod-emitente = rowObject.cod-emitente-desp no-lock:
        end.
        IF AVAIL emitente-cex THEN
            ASSIGN RowObject.cod-pto-contr =  emitente-cex.cod-pto-contr.
    END.
    ELSE do:
        ASSIGN l-passou = YES.
    END.
    run validateFields.
    
    if not can-find(first tt-bo-erro) then do:
        find last {&table-name} where {&table-name}.cod-agrup  = rowObject.cod-agrup and
                                      {&table-name}.mapa-ordem = rowObject.mapa-ordem no-lock no-error.
        if avail {&table-name} then
            assign rowObject.sequencia = {&table-name}.sequencia + 1.
        else 
            assign rowObject.sequencia = 1.                                  
    end.
      
    find first tt-bo-erro no-error.
    if not avail tt-bo-erro then do:
        if can-find({&table-name} 
            where {&table-name}.cod-agrup         = rowObject.cod-agrup and
                  {&table-name}.mapa-ordem        = rowObject.mapa-ordem and
                  {&table-name}.cod-desp          = rowObject.cod-desp) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex {&TABLE-NAME} 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
        end.
    end. 
    
    find first tt-bo-erro no-error. 
    if not avail tt-bo-erro then do:

        /*--- Eng. Cotaá∆o Autom†tica ---*/
        /* (Fornecedor padr∆o do cd2756) */
        
        FIND tt-despesas-im001 NO-LOCK WHERE
            tt-despesas-im001.seq = rowObject.sequencia NO-ERROR.
              
        IF l-gera-auto 
        AND AVAILABLE tt-despesas-im001 THEN DO:

            if  rowObject.cod-emitente-desp = 0 then
                for first desp-imp fields(cod-desp cod-emitente )
                    where desp-imp.cod-desp = rowObject.cod-desp no-lock: end.

            if avail desp-imp then
                assign rowObject.cod-emitente-desp = tt-despesas-im001.cod-emitente.
                
            IF rowObject.cod-emitente-desp = ? THEN
               ASSIGN rowObject.cod-emitente-desp = 0.
        
            find emitente
                where emitente.cod-emitente =  rowobject.cod-emitente-desp no-lock no-error.
            if avail emitente then
                assign rowobject.cod-cond-pag = emitente.cod-cond-pag.
            
            /* (Tabela de Preáo do cd2756) */
            if rowObject.cod-emitente-desp <> 0 then
            for first emitente-cex fields(cod-emitente nr-tab cod-pto-contr )
                where emitente-cex.cod-emitente = rowObject.cod-emitente-desp no-lock:
            end.
            if avail emitente-cex then
                assign rowObject.nr-tab = tt-despesas-im001.nr-tab.
                                          
            RELEASE tb-pr-cex.
            RELEASE desp-tb-pr-cex.
            
            if tt-despesas-im001.nr-tab <> "":U then do:
                find tb-pr-cex no-lock
                    where tb-pr-cex.cod-emitente = tt-despesas-im001.cod-emitente
                      and tb-pr-cex.cod-itiner   = cot-ordem.cod-itiner
                      and tb-pr-cex.cod-incoterm = cot-ordem.cod-incoterm
                      and tb-pr-cex.nr-tab       = tt-despesas-im001.nr-tab no-error.
                if avail tb-pr-cex then do:
                    find desp-tb-pr-cex no-lock
                        where desp-tb-pr-cex.cod-emitente = tb-pr-cex.cod-emitente
                          and desp-tb-pr-cex.cod-itiner   = tb-pr-cex.cod-itiner
                          and desp-tb-pr-cex.cod-incoterm = tb-pr-cex.cod-incoterm
                          and desp-tb-pr-cex.nr-tab       = tb-pr-cex.nr-tab
                          and desp-tb-pr-cex.cod-desp     = tt-despesas-im001.cod-desp 
                          and desp-tb-pr-cex.cod-cond-pag = rowobject.cod-cond-pag no-error.

                end.
            end.
            
            IF AVAIL tb-pr-cex THEN DO:
                assign rowObject.mo-codigo = tb-pr-cex.mo-codigo.
                IF NOT CAN-FIND(FIRST desp-tb-pr-cex WHERE desp-tb-pr-cex.cod-emitente = tb-pr-cex.cod-emitente AND
                                                           desp-tb-pr-cex.cod-itiner   = tb-pr-cex.cod-itiner   AND
                                                           desp-tb-pr-cex.cod-incoterm = tb-pr-cex.cod-incoterm AND
                                                           desp-tb-pr-cex.nr-tab       = tb-pr-cex.nr-tab       AND
                                                           desp-tb-pr-cex.cod-desp     = Rowobject.cod-desp)    THEN
                    ASSIGN rowobject.nr-tab = "".
            END.
            ELSE
                ASSIGN rowobject.nr-tab = "".
        
            assign l-desp-imposto = no.

            /* Atualiza dados das despesas correspondentes aos impostos */
            if  int(substr(param-imp.char-1,21,20)) = desp-imp.cod-desp then do:
                if  param-imp.log-cotac-autom-impto-import then
                    assign rowObject.cod-emitente-desp = int(substr(param-imp.char-1,1,20)). /* emitente despesa correspondente ao II */
                assign l-desp-imposto = yes.
            end.
            else 
                 if  param-imp.cdn-despes-impto-ipi = desp-imp.cod-desp then do:
                     if  param-imp.log-cotac-autom-ipi then
                         assign rowObject.cod-emitente-desp = param-imp.cdn-fornec-ipi.
                     assign l-desp-imposto = yes. 
                 end.
                 else
                      if  param-imp.cdn-despes-impto-pis = desp-imp.cod-desp then do:
                          if  param-imp.log-cotac-autom-pis then
                              assign rowObject.cod-emitente-desp = param-imp.cdn-fornec-pis.
                          assign l-desp-imposto = yes.
                      end.
                      else 
                           if  param-imp.cdn-despes-impto-cofins = desp-imp.cod-desp then do:
                               if  param-imp.log-cotac-autom-cofins then
                                   assign rowObject.cod-emitente-desp = param-imp.cdn-fornec-cofins.
                               assign l-desp-imposto = yes.
                           end.
                           else 
                                if  param-imp.cdn-despes-impto-icms = desp-imp.cod-desp then do: 
                                    if  param-imp.log-cotac-autom-icms then
                                        assign rowObject.cod-emitente-desp = param-imp.cdn-fornec-icms.
                                    assign l-desp-imposto = yes.
                                end.
                                ELSE
                                    IF l-nt2024002 
                                    AND AVAIL param-imp-trib
                                    AND param-imp-trib.cdn-despes-impto-IBSUF = desp-imp.cod-desp THEN DO:
                                        IF param-imp-trib.log-cotac-autom-IBSUF then
                                            ASSIGN rowObject.cod-emitente-desp = param-imp-trib.cdn-fornec-IBSUF.
                                        ASSIGN l-desp-imposto = YES.
                                    END.
                                    ELSE
                                        IF l-nt2024002 
                                        AND AVAIL param-imp-trib
                                        AND param-imp-trib.cdn-despes-impto-CBS = desp-imp.cod-desp THEN DO:   
                                            IF param-imp-trib.log-cotac-autom-CBS then
                                                ASSIGN rowObject.cod-emitente-desp = param-imp-trib.cdn-fornec-CBS.
                                            ASSIGN l-desp-imposto = YES.
                                        END.
                                        ELSE
                                            IF l-nt2024002 
                                            AND AVAIL param-imp-trib
                                            AND param-imp-trib.cdn-despes-impto-IBSMun = desp-imp.cod-desp THEN DO:
                                                IF param-imp-trib.log-cotac-autom-IBSMun then
                                                    ASSIGN rowObject.cod-emitente-desp = param-imp-trib.cdn-fornec-IBSMun.
                                                ASSIGN l-desp-imposto = YES.
                                            END.
                                            ELSE
                                               IF l-nt2024002 
                                               AND AVAIL param-imp-trib
                                               AND param-imp-trib.cdn-despes-impto-IS = desp-imp.cod-desp THEN DO:
                                                   IF param-imp-trib.log-cotac-autom-IS then
                                                       ASSIGN rowObject.cod-emitente-desp = param-imp-trib.cdn-fornec-IS.
                                                   ASSIGN l-desp-imposto = YES.
                                               END. 

            IF  l-desp-imposto THEN DO:
                for first cotacao-item fields (mo-codigo)
                    where cotacao-item.numero-ordem = cot-ordem.numero-ordem
                    and   cotacao-item.cod-emitente = cot-ordem.cod-emitente
                    and   cotacao-item.it-codigo    = ordem-compra.it-codigo
                    and   cotacao-item.seq-cotac    = cot-ordem.seq-cotac no-lock: end.
                if  avail cotacao-item then
                    assign rowObject.mo-codigo = cotacao-item.mo-codigo.
    
                find emitente
                    where emitente.cod-emitente = rowObject.cod-emitente-desp no-lock no-error.
                if  avail emitente then
                    assign rowObject.cod-cond-pag = emitente.cod-cond-pag.
                
                assign rowObject.perc-descto     = 0
                       rowObject.taxa-financ     = yes
                       rowObject.perc-taxa       = 0
                       rowObject.nr-dias-taxa    = 30
                       rowObject.nr-tab          = ""
                       rowObject.log-recalc-val  = NO
                       rowObject.log-gerac-autom = YES.
            END.
            else do:
                if available tb-pr-cex and
                   available desp-tb-pr-cex then do:
                    assign rowObject.perc-descto  = desp-tb-pr-cex.perc-descto
                           rowObject.taxa-financ  = tb-pr-cex.taxa-financ
                           rowObject.perc-taxa    = tb-pr-cex.perc-taxa
                           rowObject.nr-dias-taxa = tb-pr-cex.nr-dias-taxa.
                end.
                else if tt-despesas-im001.nr-tab = "":U and
                        rowObject.cod-emitente-desp <> 0 then do:

                    find emitente-cex no-lock where
                        emitente-cex.cod-emitente = rowObject.cod-emitente-desp no-error.
                    if avail emitente-cex then
                        assign rowObject.mo-codigo = emitente-cex.mo-codigo.

                    
                end.
            end.

            if  rowObject.cod-emitente-desp <> 0
            and rowObject.cod-cond-pag      <> 0
            and rowObject.cod-pto-contr     <> 0 THEN DO:

                IF  l-desp-imposto THEN
                    ASSIGN rowObject.log-gerac-autom = yes.
                ELSE IF rowObject.nr-tab <> "" THEN
                    ASSIGN rowObject.log-gerac-autom = yes.
            END.

            /* Valida novamente com os novos conte£dos dos campos */
            run validateCreatechave in this-procedure (input  table rowObject,
                                                       output table tt-bo-erro).
        /*------*/
        END.
        find first tt-bo-erro no-error.

        if not avail tt-bo-erro then
            run executeCreate.

        assign r-chave = to-rowid(return-value).

        IF  AVAIL rowObject 
        AND NOT l-gera-auto THEN
            run imp/imapi006.p(input "desp-cot-ordem":U,  
                               input r-chave,
                               input rowObject.cod-desp,
                               input 0,
                               input table tt-cotacao-item-cex,
                               input-output table tt-desp-ja-recalc).
        
    end.
    run endMethod("validateCreate").        
end procedure.

procedure validateUpdate:
    /*
    **  Valida Update
    */
    def input parameter table for RowObject.
    def input parameter r-chave as rowid no-undo.
    def output parameter table for tt-bo-erro.
 
    DEF VAR l-alterou-valor AS LOG NO-UNDO.
    
    run InitializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    
    find first RowObject no-error.

    find first cot-ordem 
        where cot-ordem.cod-agrup    = rowObject.cod-agrup 
          and cot-ordem.mapa-ordem   = rowObject.mapa-ordem 
          and cot-ordem.cod-emitente = rowObject.cod-emitente-desp 
          no-lock no-error.
    if not avail cot-ordem then    
        find first cot-ordem 
            where cot-ordem.cod-agrup    = rowObject.cod-agrup
              and cot-ordem.mapa-ordem   = rowObject.mapa-ordem 
              no-lock no-error.    
 
    run validateFields.

    RUN validateImport.

    find first tt-bo-erro
        no-lock no-error.
    if not avail tt-bo-erro then do:
        find {&TABLE-NAME} where
            rowid({&TABLE-NAME}) = r-chave
            exclusive-lock no-error.

        ASSIGN l-alterou-valor = (   (rowObject.val-desp         <> desp-cot-ordem.val-desp)
                                  or (rowObject.cod-incoterm-rat <> desp-cot-ordem.cod-incoterm-rat)).

        run executeUpdate.

        IF  l-alterou-valor THEN
            RUN imp/imapi006.p(INPUT "desp-cot-ordem":U,  
                               INPUT ROWID(desp-cot-ordem),
                               INPUT desp-cot-ordem.cod-desp,
                               INPUT 0,
                               INPUT TABLE tt-cotacao-item-cex,
                               INPUT-OUTPUT TABLE tt-desp-ja-recalc).
    end.
end procedure.

PROCEDURE validateDelete:

    DEFINE INPUT-OUTPUT PARAMETER r-chave AS ROWID.
    DEFINE OUTPUT       PARAMETER TABLE FOR tt-bo-erro.

    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.

    RUN InitializeValidate.

    &IF DEFINED(LOCKCONTROL) > 0 &THEN
        FIND {&TABLE-NAME} WHERE ROWID({&TABLE-NAME}) = r-chave NO-LOCK NO-ERROR.
    &ELSE
        FIND {&TABLE-NAME} WHERE ROWID({&TABLE-NAME}) = r-chave EXCLUSIVE-LOCK NO-ERROR.
    &ENDIF    

    RUN validateImport.
    
    IF  AVAIL {&TABLE-NAME} 
    AND NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:

        RUN imp/imapi006.p(INPUT "desp-cot-ordem":U,
                           INPUT RowObject.r-rowid,
                           INPUT RowObject.cod-desp,
                           INPUT 0,
                           INPUT TABLE tt-cotacao-item-cex,
                           INPUT-OUTPUT TABLE tt-desp-ja-recalc).

        RUN executeDelete.
    END.

    IF l-query THEN GET NEXT {&QUERY-NAME} NO-LOCK NO-WAIT.
    ELSE FIND NEXT {&TABLE-NAME} NO-LOCK NO-ERROR.

    IF NOT AVAIL {&TABLE-NAME} THEN DO:
       IF l-query THEN GET PREV {&QUERY-NAME} NO-LOCK NO-WAIT.
       ELSE FIND PREV {&TABLE-NAME} NO-LOCK NO-ERROR.
    END.

    ASSIGN r-chave = ROWID({&TABLE-NAME}).

    RETURN "".
END PROCEDURE.
 
procedure validateFields:
    def var c-return1 as char no-undo.
    def var i-cod-itiner like itinerario.cod-itiner no-undo.
       
    
    find first rowObject no-lock no-error.
    
    run startMethod ("validateFields").

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    RUN despesaImposto (INPUT rowObject.cod-desp,
                        INPUT rowObject.cod-agrup,
                        INPUT rowObject.mapa-ordem,  
                       OUTPUT l-desp-imposto).

    IF NOT l-passou THEN DO:
        if rowObject.cod-pto-contr = 0 then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex {&TABLE-NAME} cod-pto-contr 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.
            run utp/ut-msgs.p (input "msg",
                               input 265,
                              input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.    
        end.
        else do:
            if not can-find(pto-contr where pto-contr.cod-pto-contr = rowObject.cod-pto-contr) then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-table.i mgcex pto-contr 1}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = return-value.            
                run utp/ut-msgs.p (input "msg",
                                   input 2,
                                   input return-value).
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 2
                       tt-bo-erro.mensagem     = return-value.            
            end.
            if avail cot-ordem then do:
                if not can-find(pto-itiner where pto-itiner.cod-itiner    = cot-ordem.cod-itiner and
                                                 pto-itiner.cod-pto-contr = rowObject.cod-pto-contr) then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    {utp/ut-table.i mgcex pto-itiner 1}
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = return-value.            
                    run utp/ut-msgs.p (input "msg",
                                       input 2,
                                       input return-value).
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 2
                           tt-bo-erro.mensagem     = return-value.            
                end.
            end.            
            else do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-table.i mgcex cot-ordem 1}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = return-value.            
                run utp/ut-msgs.p (input "msg",
                                   input 2,
                                   input return-value).
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 2
                       tt-bo-erro.mensagem     = return-value.
            end.            
        end.
    END.
    if rowObject.cod-cond-pag <> 0 then
        if not can-find(cond-pagto where cond-pagto.cod-cond-pag = rowObject.cod-cond-pag) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-liter.i Condiá∆o_pagamento mim L}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.            
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        end.
        
    if rowObject.perc-descto > 100 then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 507,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 507
               tt-bo-erro.mensagem     = return-value.
    end.
    
    if rowObject.cod-comprado = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-comprado 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                          input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.

    end.
    else
        if not can-find(comprador where comprador.cod-comprado = rowObject.cod-comprado) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-liter.i Comprador mim L}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.            
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        end.    

    if rowObject.data-cotacao-desp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} data-cotacao-desp 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.

    end.

    if rowObject.dias-validade = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} dias-validade 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.

    end.
    
    if not l-gera-auto AND not l-desp-imposto AND rowObject.val-desp = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} val-desp 1}
        ASSIGN c-return-value  = RETURN-VALUE + " " + string(RowObject.cod-desp).
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input c-return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    /*  Validaá∆o do Tipo de Despesa da Despesa de Importaá∆o */
    if not can-find(first tipo-rec-desp no-lock 
                    where tipo-rec-desp.tp-codigo = RowObject.tp-despesa) then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex desp-cot-ordem tp-despesa 1}
        /******************************************/
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg":U,
                           input 3866,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 3866
               tt-bo-erro.mensagem     = return-value.            
    end.
    else
        if can-find(first tipo-rec-desp no-lock 
                    where tipo-rec-desp.tp-codigo = RowObject.tp-despesa and
                          tipo-rec-desp.tipo = 1) then do:
            assign i-seq-erro = i-seq-erro + 1.
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
               pre-processador em chamada de includes */
            {utp/ut-field.i mgcex desp-cot-ordem tp-despesa 1}
            /******************************************/
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.
            run utp/ut-msgs.p (input "msg":U,
                               input 4995,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 4995
                   tt-bo-erro.mensagem     = return-value.  
        end.
    /* Fim da validaá∆o por tipo de despesa */

    /* Engenharia Rateio Incoterm */
    run ValidateIncotermRateio.

    assign rowObject.data-atualiz = TODAY
           rowObject.hora-atualiz = STRING(TIME,'HH:MM:SS'). /* Grava a hora da atualizaá∆o */

     
    run endMethod ("validateFields").
 
end procedure.

procedure setValidate:
/* 
** recebe yes quando for inclusao atraves da geracao automatica de despesas pela bocx300
*/
def input parameter p-gera-auto as logical no-undo.

assign l-gera-auto = p-gera-auto.
end procedure.

PROCEDURE SetTTdespcotordem:
    /* Procedure executada apartir do programa im0015 do botao calcula despesa
    */

    DEF INPUT PARAMETER p-rowid AS ROWID NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER TABLE FOR RowObject.
    DEF INPUT PARAMETER p-calculavalor AS LOGICAL NO-UNDO.
    DEF OUTPUT PARAMETER  p-valor-calcula-im0015 LIKE desp-imp.val-desp NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    ASSIGN pr-rowid       = p-rowid
           l-calculavalor = p-calculavalor
           l-auto         = yes.
    
    /*frank0*/    
    RUN geravalorformula (INPUT-OUTPUT TABLE RowObject,
                          OUTPUT TABLE tt-bo-erro).
    ASSIGN p-valor-calcula-im0015 = de-valor-calcula-im0015.

END.

PROCEDURE AtualizaValDespDespCotOrdem:
/* Procedure criada apra ataulizar a inforrmaá∆o do valor das despesas quando 
   selicionado o botao Calcula Valor no im0015.
*/

def input parameter c-cod-agrup     as char     no-undo.
def input parameter i-mapa-ordem    as integer  no-undo.    
DEF INPUT PARAMETER i-sequencia     AS INTEGER  NO-UNDO.
def input parameter i-cod-emitente-desp  as integer  no-undo.
def input parameter i-cod-desp      as integer  no-undo.
DEF INPUT PARAMETER p-val-desp      LIKE desp-imp.val-desp NO-UNDO.

FIND desp-cot-ordem EXCLUSIVE-LOCK WHERE
     desp-cot-ordem.cod-agrup          = c-cod-agrup         AND
     desp-cot-ordem.mapa-ordem         = i-mapa-ordem        AND
     desp-cot-ordem.sequencia          = i-sequencia         AND
     desp-cot-ordem.cod-emitente-desp  = i-cod-emitente-desp AND
     desp-cot-ordem.cod-desp           = i-cod-desp          NO-ERROR.

IF AVAIL desp-cot-ordem  
AND p-val-desp <> ? THEN
    ASSIGN desp-cot-ordem.val-desp       = p-val-desp
           desp-cot-ordem.log-recalc-val = NO.
           


END PROCEDURE.



procedure geraValorformula:
    /*
    ** Calcula valor da despesa
    */
    def input-output parameter table for rowObject.    
    /*
    def input parameter c-cod-agrup         like cot-ordem.cod-agrup     no-undo.
    def input parameter i-mapa-ordem        like cot-ordem.mapa-ordem    no-undo.
    def input parameter i-cod-desp          like desp-imp.cod-desp       no-undo.
    def input parameter i-cod-emitente-desp like emitente.cod-emitente   no-undo.
    def input parameter c-nr-tab            like tb-pr-cex.nr-tab        no-undo.
    def input parameter p-mo-codigo         like moeda.mo-codigo         no-undo.
    def output parameter p-valor-despesa    like desp-cot-ordem.val-desp no-undo.
    */
    def output parameter table for tt-bo-erro.
    
    def var de-valor-despesa     like desp-cot-ordem.val-desp no-undo.
    def var de-valor-despesa-tot like desp-cot-ordem.val-desp no-undo.
    def var de-valor-aux         like desp-cot-ordem.val-desp no-undo.
    def var de-quant-total       like prazo-compra.quantidade no-undo.    
    DEF VAR de-val-desp-ant      like desp-cot-ordem.val-desp no-undo.
    def var c-cod-incoterm-rat   as character format "x(3)":U no-undo.
    
    for each tt-parametros:
        delete tt-parametros.
    end.
    
    for each tt-parametros-imp:
        delete tt-parametros-imp.
    end.
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    
    IF l-calculavalor THEN
       FIND FIRST RowObject WHERE
                  RowObject.r-rowid = pr-rowid NO-ERROR.
    ELSE
       find first rowObject no-error.
    
    find first cot-ordem 
        where cot-ordem.cod-agrup  = rowObject.cod-agrup
          and cot-ordem.mapa-ordem = rowObject.mapa-ordem no-lock no-error.    

    find ordem-compra
        where ordem-compra.numero-ordem = cot-ordem.numero-ordem no-lock no-error.
    
    find param-imp 
        where param-imp.cod-estabel = ordem-compra.cod-estabel no-lock no-error.

    {cdp/cd4300.i4 "yes" param-imp.char-1}
    {cxbo/bocx250.i51 "yes"}

    find first desp-imp no-lock
         where desp-imp.cod-desp = rowObject.cod-desp no-error.
    if  avail desp-imp then do:

        assign c-cod-incoterm-rat = desp-imp.cod-incoterm-rat.

        if  RowObject.cod-incoterm-rat = ""
        or  RowObject.cod-incoterm-rat = ? then do:

            assign RowObject.cod-incoterm-rat = c-cod-incoterm-rat.
            
            if  l-auto then do:

                run ValidateIncotermRateio.
                if  can-find (first tt-bo-erro) then
                    assign RowObject.cod-incoterm-rat = "".
                    
                else do:
                
                    find first bf{&TABLE-NAME}
                        where  bf{&TABLE-NAME}.cod-agrup         = rowObject.cod-agrup
                          and  bf{&TABLE-NAME}.mapa-ordem        = rowObject.mapa-ordem
                          and  bf{&TABLE-NAME}.sequencia         = rowObject.sequencia
                          and  bf{&TABLE-NAME}.cod-emitente-desp = rowObject.cod-emitente-desp
                          and  bf{&TABLE-NAME}.cod-desp          = rowObject.cod-desp exclusive-lock no-error.    
                    if  avail  bf{&TABLE-NAME} then
                        assign bf{&TABLE-NAME}.cod-incoterm-rat = c-cod-incoterm-rat.
                end.
                assign l-auto = no.
            end.
        end.
    end.

    if rowObject.cod-desp = i-desp-ii-i50 then do: 
        /* 
        ** Imposto de Importaá∆o 
        */
        run calculaValorII (input param-imp.cod-estabel,
                            input rowObject.cod-agrup,
                            input rowObject.mapa-ordem,
                            input rowObject.cod-desp,
                            output de-valor-despesa-tot).
        
    end.
    /*--- Eng geracao Impto Padrao ---*/
    else
        if  rowObject.cod-desp = param-imp.cdn-despes-impto-ipi then do:
            /* 
            ** IPI 
            */ 
            run calculaValorIPI (input param-imp.cod-estabel,
                                 input rowObject.cod-agrup,
                                 input rowObject.mapa-ordem,
                                 input rowObject.cod-desp,
                                 output de-valor-despesa-tot).

        end.
        else 
            if  rowObject.cod-desp = param-imp.cdn-despes-impto-pis 
            or  rowObject.cod-desp = param-imp.cdn-despes-impto-cofins then do:
                /* 
                ** PIS e COFINS
                */ 
        
                run calculaValorPisCofins (input param-imp.cod-estabel,
                                           input rowObject.cod-agrup,
                                           input rowObject.mapa-ordem,
                                           input rowObject.cod-desp,
                                           output de-valor-despesa-tot).
            end.
            else 
                if  rowObject.cod-desp = param-imp.cdn-despes-impto-icms then do:
                    /* 
                    ** ICMS 
                    */ 
                    run calculaValorICMS (input param-imp.cod-estabel,
                                          input rowObject.cod-agrup,
                                          input rowObject.mapa-ordem,
                                          input rowObject.cod-desp,
                                          output de-valor-despesa-tot).
                end.
                ELSE DO:
                    ASSIGN de-val-desp-ant = rowobject.val-desp.
                    run cxbo/bocx095c.p persistent set h-bocx095c.
                    run setCotacaoGrupoDespesaImportacao in h-bocx095c (input cot-ordem.cod-agrup,
                                                                        input cot-ordem.mapa-ordem,
                                                                        input cot-ordem.cod-itiner,
                                                                        input cot-ordem.cod-incoterm,
                                                                        input rowObject.cod-emitente-desp,
                                                                        input rowObject.cod-desp,
                                                                        input rowObject.nr-tab,
                                                                        input rowObject.mo-codigo,
                                                                        today,
                                                                        INPUT 1,
                                                                        INPUT ?,
                                                                        input rowobject.cod-cond-pag).
                    /* Calcular valor da despesa */                                               
                    run CalculaDespesa in h-bocx095c (output de-valor-despesa-tot,
                                                      output TABLE tt-bo-erro).
                    delete procedure h-bocx095c.
                    ASSIGN h-bocx095c = ?.
                    if not can-find(first tt-bo-erro) then do:
                        assign rowObject.val-desp      = de-valor-despesa-tot
                               de-valor-calcula-im0015 = de-valor-despesa-tot.
                    END.
                END.
    
    IF de-valor-despesa-tot <> 0 THEN
       assign rowObject.val-desp      = de-valor-despesa-tot
              de-valor-calcula-im0015 = de-valor-despesa-tot. 
    
    /*
    ** Atualizaá∆o das informaá‰es iniciais
    */ 
    {cxbo/bocx085.i6 cot-ordem.cod-itiner cot-ordem.cod-incoterm rowObject.cod-emitente-desp rowObject.cod-desp}
    
    /*
    ** Verifica se existe outra despesa cotada para o mesmo fornecedor
    */
    find first desp-cot-ordem 
        where desp-cot-ordem.cod-agrup         = rowObject.cod-agrup
          and desp-cot-ordem.mapa-ordem        = rowObject.mapa-ordem
          and desp-cot-ordem.cod-emitente-desp = rowObject.cod-emitente-desp no-lock no-error.    
    if avail desp-cot-ordem then
        assign rowObject.cod-cond-pag  = desp-cot-ordem.cod-cond-pag
               rowObject.cod-comprado  = desp-cot-ordem.cod-comprado
               rowObject.cod-cond-pag  = desp-cot-ordem.cod-cond-pag
               rowObject.contato       = desp-cot-ordem.contato
               rowObject.dias-validade = desp-cot-ordem.dias-validade
               rowObject.motivo-apr    = desp-cot-ordem.motivo-apr
               rowObject.nr-dias-taxa  = desp-cot-ordem.nr-dias-taxa
               rowObject.perc-descto   = desp-cot-ordem.perc-descto
               rowObject.perc-taxa     = desp-cot-ordem.perc-taxa
               rowObject.taxa-financ   = desp-cot-ordem.taxa-financ.
    
    
    FIND desp-cot-ordem WHERE ROWID(desp-cot-ordem) = rowobject.r-rowid NO-LOCK NO-ERROR.

    if avail tb-pr-cex and avail desp-tb-pr-cex then
        assign rowObject.nr-tab       = tb-pr-cex.nr-tab
               rowObject.cod-cond-pag = desp-tb-pr-cex.cod-cond-pag
               rowObject.perc-descto  = desp-tb-pr-cex.perc-descto
               rowObject.taxa-financ  = tb-pr-cex.taxa-financ
               rowObject.perc-taxa    = tb-pr-cex.perc-taxa
               rowObject.nr-dias-taxa = tb-pr-cex.nr-dias-taxa.


    IF  AVAIL desp-cot-ordem
    AND rowObject.val-desp <> desp-cot-ordem.val-desp THEN 
        RUN imp/imapi006.p(INPUT "desp-cot-ordem":U,
                           INPUT RowObject.r-rowid,
                           INPUT RowObject.cod-desp,
                           INPUT 0,
                           INPUT TABLE tt-cotacao-item-cex,
                           INPUT-OUTPUT TABLE tt-desp-ja-recalc).

    VALIDATE Rowobject.

end procedure.

procedure calculaValorII:
/*
**  Calcula Valor do Imposto de Importaá∆o
*/
    def input parameter p-cod-estabel like estabelec.cod-estabel no-undo.
    def input parameter p-cod-agrup   like cot-ordem.cod-agrup   no-undo.
    def input parameter p-mapa-ordem  like cot-ordem.mapa-ordem  no-undo.
    def input parameter p-cod-desp    like desp-imp.cod-desp     no-undo.
    def output parameter p-valor-despesa like cotacao-item-cex.val-desp no-undo.
    
    def var h-im0091 as handle no-undo.

    /* Imposto de Importaá∆o */
    run imp/im0091.p persistent set h-im0091.
    run setaValorinicial in h-im0091 (input today,
                                      input p-cod-estabel).
    /*frank1*/
    run rateioGrupoordens in h-im0091(input p-cod-agrup,
                                      input p-mapa-ordem,
                                      input p-cod-desp,
                                      output table tt-desp-rateio).
    run getDespII in h-im0091(output p-valor-despesa).
    run cdp/cd0812.p (input 0,
                      input rowObject.mo-codigo,
                      input p-valor-despesa,
                      input rowObject.data-cotacao-desp,
                      output p-valor-despesa).
    run getTTbo-erro in h-im0091(output table tt-bo-erro).
    delete procedure h-im0091.
    
end procedure.

procedure calculaValorIPI:
/*
**  Calcula Valor do IPI
*/
    def input  parameter p-cod-estabel like estabelec.cod-estabel no-undo.
    def input  parameter p-cod-agrup   like cot-ordem.cod-agrup   no-undo.
    def input  parameter p-mapa-ordem  like cot-ordem.mapa-ordem  no-undo.
    def input  parameter p-cod-desp    like desp-imp.cod-desp     no-undo.
    def output parameter p-valor-despesa like cotacao-item-cex.val-desp no-undo.
    
    def var h-im0091 as handle no-undo.

    /* IPI */
    run imp/im0091.p persistent set h-im0091.
    run setaValorinicialIPI in h-im0091 (input today,
                                         input p-cod-estabel).
    run rateioGrupoordens in h-im0091(input p-cod-agrup,
                                      input p-mapa-ordem,
                                      input p-cod-desp,
                                      output table tt-desp-rateio).
    run getDespIPI in h-im0091(output p-valor-despesa).
    run cdp/cd0812.p (input 0,
                      input rowObject.mo-codigo,
                      input p-valor-despesa,
                      input rowObject.data-cotacao-desp,
                      output p-valor-despesa).
    run getTTbo-erro in h-im0091(output table tt-bo-erro).
    delete procedure h-im0091.
end procedure.

procedure calculaValorICMS:
/*
**  Calcula Valor do ICMS
*/
    def input  parameter p-cod-estabel   like estabelec.cod-estabel     no-undo.
    def input  parameter p-cod-agrup     like cot-ordem.cod-agrup       no-undo.
    def input  parameter p-mapa-ordem    like cot-ordem.mapa-ordem      no-undo.
    def input  parameter p-cod-desp      like desp-imp.cod-desp         no-undo.
    def output parameter p-valor-despesa like cotacao-item-cex.val-desp no-undo.
    
    def var h-im0091 as handle no-undo.

    /* ICMS */
    run imp/im0091.p persistent set h-im0091.
    run setaValorinicialICMS in h-im0091 (input today,
                                          input p-cod-estabel).
    run rateioGrupoordens in h-im0091(input p-cod-agrup,
                                      input p-mapa-ordem,
                                      input p-cod-desp,
                                      output table tt-desp-rateio).
    run getDespICMS in h-im0091(output p-valor-despesa).
    run cdp/cd0812.p (input 0,
                      input rowObject.mo-codigo,
                      input p-valor-despesa,
                      input rowObject.data-cotacao-desp,
                      output p-valor-despesa).
    run getTTbo-erro in h-im0091(output table tt-bo-erro).
    delete procedure h-im0091.
end procedure.

procedure calculaValorPisCofins:
/*
**  Calcula Valor do PIS ou COFINS
*/
    def input  parameter p-cod-estabel like estabelec.cod-estabel no-undo.
    def input  parameter p-cod-agrup   like cot-ordem.cod-agrup   no-undo.
    def input  parameter p-mapa-ordem  like cot-ordem.mapa-ordem  no-undo.
    def input  parameter p-cod-desp    like desp-imp.cod-desp     no-undo.
    def output parameter p-valor-despesa like cotacao-item-cex.val-desp no-undo.
    
    def var h-im0091 as handle no-undo.

    run imp/im0091.p persistent set h-im0091.
    run setaValorinicialPisCofins in h-im0091 (input today,
                                               input p-cod-estabel,
                                               (rowObject.cod-desp = param-imp.cdn-despes-impto-pis)).
    run rateioGrupoordens in h-im0091(input p-cod-agrup,
                                      input p-mapa-ordem,
                                      input p-cod-desp,
                                      output table tt-desp-rateio).

    IF  p-cod-desp = param-imp.cdn-despes-impto-pis THEN DO:
        run getDespPis in h-im0091(output p-valor-despesa).
        run cdp/cd0812.p (input 0,
                          input rowObject.mo-codigo,
                          input p-valor-despesa,
                          input rowObject.data-cotacao-desp,
                          output p-valor-despesa).
    END.
    IF  p-cod-desp = param-imp.cdn-despes-impto-cofins THEN DO:
        run getDespCofins in h-im0091(output p-valor-despesa).
        run cdp/cd0812.p (input 0,
                          input rowObject.mo-codigo,
                          input p-valor-despesa,
                          input rowObject.data-cotacao-desp,
                          output p-valor-despesa).
    END.

    run getTTbo-erro in h-im0091(output table tt-bo-erro).
    delete procedure h-im0091.
end procedure.


procedure piCalculaValorDespesa:
/*
** Calcula valor da despesa conforme engenharia Cotaá∆o Autom†tica
*/
&if defined(bf-mat-comex) &then
&else

    define input  parameter prowid-desp-cot-ordem as rowid   no-undo.
    define input  parameter prowid-cot-ordem      as rowid   no-undo.
    define output parameter d-valor-despesa       as decimal no-undo.
    define output parameter table for tt-bo-erro.

    def var d-valor-aux as decimal no-undo.

    for first cot-ordem fields(numero-ordem cod-emitente cod-itiner cod-incoterm mapa-ordem
                               &if defined(bf-mat-comex) &then data-1 &else seq-cotac &endif)
        where rowid(cot-ordem) = prowid-cot-ordem no-lock:
    end.
    
    for first desp-cot-ordem fields(nr-tab cod-desp cod-emitente-desp mo-codigo)
        where rowid(desp-cot-ordem) = prowid-desp-cot-ordem no-lock:
    end.
    
    if  avail cot-ordem and 
        avail desp-cot-ordem and
        desp-cot-ordem.nr-tab <> "":U then do:

        for first ordem-compra fields(numero-ordem it-codigo qt-solic)
            where ordem-compra.numero-ordem = cot-ordem.numero-ordem no-lock:
        end.
        
        for each tt-bo-erro:
            delete tt-bo-erro.
        end.

        run cxbo/bocx095c.p persistent set h-bocx095c.
        run setCotacaoGrupoDespesaImportacao in h-bocx095c (input cot-ordem.cod-agrup,
                                                            input cot-ordem.mapa-ordem,
                                                            input cot-ordem.cod-itiner,
                                                            input cot-ordem.cod-incoterm,
                                                            input desp-cot-ordem.cod-emitente-desp,
                                                            input desp-cot-ordem.cod-desp,
                                                            input desp-cot-ordem.nr-tab,
                                                            input desp-cot-ordem.mo-codigo,
                                                            today,
                                                            INPUT 1,
                                                            INPUT ?,
                                                            input desp-cot-ordem.cod-cond-pag).
        /* Calcular valor da despesa */                                               
        run CalculaDespesa in h-bocx095c (output d-valor-despesa,
                                          output TABLE tt-bo-erro).
        if can-find(first tt-bo-erro) then
            assign d-valor-despesa = 0.
        delete procedure h-bocx095c.
        ASSIGN h-bocx095c = ?.
    
        /* Repassar o valor calculado para a tabela desp-cot-ordem */
        find first desp-cot-ordem where rowid(desp-cot-ordem) = prowid-desp-cot-ordem exclusive-lock no-wait no-error.
        assign desp-cot-ordem.val-desp = d-valor-despesa.
        release desp-cot-ordem.
    end.
    else
        leave.

&endif
end procedure.

procedure getCharField:
    define input parameter c-field as char.
    define output parameter c-value as char.
	
    case c-field:
        when "cod-agrup":U then c-value = rowObject.cod-agrup.
        when "contato":U then c-value = rowObject.contato.
        when "cod-comprado":U then c-value = rowObject.cod-comprado.
        when "contato":U then c-value = rowObject.contato.
        when "cod-comprado":U then c-value = rowObject.cod-comprado.
        when "aprovador":U then c-value = rowObject.aprovador.
        when "usuario":U then c-value = rowObject.usuario.
        when "motivo-apr":U then c-value = rowObject.motivo-apr.
        when "hora-atualiz":U then c-value = rowObject.hora-atualiz.
        when "nr-tab" then c-value = RowObject.nr-tab.
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "perc-taxa":U then c-value = rowObject.perc-taxa.
        when "perc-descto":U then c-value = rowObject.perc-descto.
        when "val-desp":U then c-value = rowObject.val-desp.
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        otherwise return error.
    end case.
end procedure.

procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "mapa-ordem":U then c-value = rowObject.mapa-ordem.
        when "sequencia":U then c-value = rowObject.sequencia.
        when "mo-codigo":U then c-value = rowObject.mo-codigo.
        when "cod-cond-pag":U then c-value = rowObject.cod-cond-pag.
        when "nr-dias-taxa":U then c-value = rowObject.nr-dias-taxa.
        when "dias-validade":U then c-value = rowObject.dias-validade.
        when "cod-desp":U then c-value = RowObject.cod-desp.
        when "cod-emitente-desp":U then c-value = RowObject.cod-emitente-desp.
        when "cod-pto-contr":U then c-value = rowObject.cod-pto-contr.        
        when "int-1":U    then c-value = RowObject.int-1.
        when "int-2":U    then c-value = RowObject.int-2.        
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-cotacao-desp":U then c-value = rowObject.data-cotacao-desp.
        when "data-atualiz":U then c-value = rowObject.data-atualiz.
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.                                   
        otherwise return error.
    end case.
end procedure.

procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "taxa-financ":U then c-value = rowObject.taxa-financ.
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.        
        otherwise return error.
    end case.
end procedure.


PROCEDURE validateImport:
    DEFINE VARIABLE l-permite-alter-cotac        AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-permite-alter-cotac-despes AS LOGICAL    NO-UNDO.

    FIND FIRST RowObject NO-ERROR.

    /* Somente faz essa validaá∆o para despesas cotadas automaticamente pelo sistema */
    IF RowObject.log-gerac-autom THEN DO:

        /* Verifica se despesa permite alteraá∆o */
        FOR FIRST desp-imp FIELDS(log-permite-alter-cotac)
            WHERE desp-imp.cod-desp = RowObject.cod-desp NO-LOCK:
            ASSIGN l-permite-alter-cotac = desp-imp.log-permite-alter-cotac.
        END.

        /* Verifica se usu†rio possui permiss∆o de alteraá∆o */
        FOR FIRST usuar-import FIELDS(log-permite-alter-cotac-despes)
            WHERE usuar-import.cod-usuar = c-seg-usuario NO-LOCK:
            ASSIGN l-permite-alter-cotac-despes = usuar-import.log-permite-alter-cotac-despes.
        END.

        IF  NOT l-permite-alter-cotac 
        AND NOT l-permite-alter-cotac-despes THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            create tt-bo-erro.
            assign tt-bo-erro.parametros   = c-seg-usuario + "~~" + STRING(rowObject.cod-desp).

            run utp/ut-msgs.p (input "msg",
                               input 30099,
                               input c-seg-usuario + "~~" + STRING(rowObject.cod-desp)).

            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 30099
                   tt-bo-erro.mensagem     = RETURN-VALUE.
        END.

    END.
END PROCEDURE.

PROCEDURE enableIncotermRat:

    DEFINE INPUT  PARAMETER piMapa      AS INTEGER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcAgrup     AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER icod-desp   AS INTEGER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-habilita AS LOGICAL    NO-UNDO.

    {cdp/cd4300.i3}  /* include tratamento atributo livre */
    {cxbo/bocx250.i50} /* include tratamento atributo livre */

    ASSIGN pl-habilita = YES.

    blk_cot_ordem:
    FOR EACH cot-ordem 
       WHERE cot-ordem.cod-agrup    = pcAgrup
       AND   cot-ordem.mapa-ordem   = piMapa NO-LOCK:

        find FIRST ordem-compra 
             where ordem-compra.numero-ordem = cot-ordem.numero-ordem no-lock no-error.

        FIND FIRST param-imp NO-LOCK
             WHERE param-imp.cod-estabel = ordem-compra.cod-estabel  NO-ERROR.

        FIND FIRST param-imp-trib 
             WHERE param-imp-trib.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
             
        IF AVAIL param-imp THEN DO:
            {cdp/cd4300.i4 "yes" param-imp.char-1}
    
            /*--- busca despesa de importacao ---*/
            {cxbo/bocx250.i51 "yes"}
    
            IF  icod-desp = i-desp-ii-i50                     /* Despesa p/ o II */ 
            OR  icod-desp = param-imp.cdn-despes-impto-pis    /* Despesa p/ o PIS */    
            OR  icod-desp = param-imp.cdn-despes-impto-cofins /* Despesa p/ o COFINS */ 
            OR  icod-desp = param-imp.cdn-despes-impto-ipi    /* Despesa p/ o IPI */ 
            OR  icod-desp = param-imp.cdn-despes-impto-icms   /* Despesa p/ o ICMS */ 
            OR (l-nt2024002 AND AVAIL param-imp-trib AND icod-desp = param-imp-trib.cdn-despes-impto-IBSUF)
            OR (l-nt2024002 AND AVAIL param-imp-trib AND icod-desp = param-imp-trib.cdn-despes-impto-IBSMun)
            OR (l-nt2024002 AND AVAIL param-imp-trib AND icod-desp = param-imp-trib.cdn-despes-impto-CBS)     
            OR (l-nt2024002 AND AVAIL param-imp-trib AND icod-desp = param-imp-trib.cdn-despes-impto-IS)
            THEN DO:
    
                ASSIGN pl-habilita = NO.
    
                LEAVE blk_cot_ordem.
    
            END.                    

        END.

    END.

    IF pl-habilita THEN DO:

        FIND FIRST desp-imp NO-LOCK
             WHERE desp-imp.cod-desp = icod-desp NO-ERROR.

        IF AVAIL desp-imp THEN DO:
            IF desp-imp.tipo = 3
            OR desp-imp.tipo = 6
            OR desp-imp.tipo = 9 THEN
               ASSIGN pl-habilita  = NO.
            ELSE ASSIGN pl-habilita  = YES.
        END.                               

    END.

    RETURN "OK":U.

END PROCEDURE.

procedure ValidateIncotermRateio:


    /* Engenharia Rateio Incoterm */
    IF  rowObject.cod-incoterm-rat = ? 
    OR  rowObject.cod-incoterm-rat = "?" THEN DO:
        create tt-bo-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "C¢digo_Incoterm_de_Rateio_Inv†lido" *}
        assign tt-bo-erro.parametros = RETURN-VALUE.
        run utp/ut-msgs.p (input "msg":U,
                           input 17006,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 17006
               tt-bo-erro.mensagem     = return-value
               tt-bo-erro.errorhelp    = return-value.
    end.

    IF  rowObject.cod-incoterm-rat <> ?
    AND rowObject.cod-incoterm-rat <> "?"
    AND rowObject.cod-incoterm-rat <> "" THEN DO:
    
         IF NOT CAN-FIND(FIRST inco-cx
                         WHERE inco-cx.cod-incoterm = rowObject.cod-incoterm-rat) THEN DO:
                                                      
              ASSIGN c-parametro = rowObject.cod-incoterm-rat.
               
              CREATE tt-bo-erro.
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Incoterm" *}
              assign tt-bo-erro.parametros = RETURN-VALUE.
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Incoterm" *}
              run utp/ut-msgs.p (input "msg":U,
                                 input 2,
                                 input RETURN-VALUE).
    
              assign tt-bo-erro.i-sequen     = i-seq-erro
                     tt-bo-erro.cd-erro      = 2
                     tt-bo-erro.mensagem     = return-value.
         END.
         ELSE DO:

             IF CAN-FIND(FIRST desp-incoterm
                         WHERE desp-incoterm.cod-desp     = RowObject.cod-desp
                         AND   desp-incoterm.cod-incoterm = rowObject.cod-incoterm-rat) THEN DO: 
                                                            
                create tt-bo-erro.
                assign tt-bo-erro.parametros = rowObject.cod-incoterm-rat
                                               + "~~" + string(RowObject.cod-desp).
                run utp/ut-msgs.p (input "msg":U,
                                   input 30164,
                                   input tt-bo-erro.parametros).

                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 30164
                       tt-bo-erro.mensagem     = return-value.
                                                            
                run utp/ut-msgs.p (input "help":U,
                                   input 30164,
                                   input tt-bo-erro.parametros).

                assign tt-bo-erro.errorhelp = return-value.
             END.                                                            

         END.                                                 

        END.
end procedure.

PROCEDURE setDespesas:
    DEFINE INPUT PARAMETER TABLE FOR tt-despesas-im001.
END PROCEDURE.

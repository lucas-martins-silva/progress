/*******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX225E 2.00.00.073 } /*** "010073" 15/10/2026 10:28:37 ***/

/*&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx225e MUT}
&ENDIF*/

/*******************************************************************************
**
**  BOCX225E.P
**
**  ordens-embarque - Ordens Embarque 
**
**  Espec°fica para os programas IM0100C.W - Peso e Cubagem e IM0100D.W - Impostos
**
*******************************************************************************/

&SCOPED-DEFINE BOVERSION 1.1
&SCOPED-DEFINE PRVERSION 2.00.00.030
&SCOPED-DEFINE FIRST-TABLE-IN-QUERY ordens-embarque
&SCOPED-DEFINE QUERY-NAME qTable
&SCOPED-DEFINE TABLE-NAME ordens-embarque

{cdp/cdcfgmat.i}                            /* Include Pre-processadores                                                                        */
{include/boini.i}                           /* l-version, lExistsCustomBO, cCustomBOName, l-query, i-bo-query, i-seq-erro, c-return, tt-bo-erro */
{cxbo/bocx225.i RowObject}                  /* RowObjet                                                                                         */
{cxbo/bocx225.i tt-ordens-embarque}         /* Para carregar tt auxiliar                                                                        */
{cxbo/bocx225e.i tt-ordens-desemb}          /* TT programa im0100C e im0100d                                                                    */
{cxbo/bocx225e.i tt-ordens-desemb-param}    /* TT programa im0100C e im0100d                                                                    */
{cxbo/bocx225e.i tt-ordens-desemb-aux-2}    /* TT programa im0100C e im0100d                                                                    */
{include/i-epc200.i bocx225e}               /* Temp-table tt-epc                                                                                */
{dibo/bodi01141.i tt-relacto-tributo}

DEFINE QUERY {&QUERY-NAME} FOR ordens-embarque SCROLLING.

{cdp/cd4300.i3} /* Include Tratamento Atributo Livre */

DEFINE VARIABLE c-item-ini         AS   CHARACTER             NO-UNDO.
DEFINE VARIABLE c-item-fim         AS   CHARACTER             NO-UNDO.
DEFINE VARIABLE c-class-fiscal-ini AS   CHARACTER             NO-UNDO.
DEFINE VARIABLE c-class-fiscal-fim AS   CHARACTER             NO-UNDO.
DEFINE VARIABLE i-numero-ordem-ini AS   INTEGER               NO-UNDO.
DEFINE VARIABLE i-numero-ordem-fim AS   INTEGER               NO-UNDO.
DEFINE VARIABLE c-cod-estabel      LIKE estabelec.cod-estabel NO-UNDO.
DEFINE VARIABLE c-embarque         LIKE embarque-imp.embarque NO-UNDO.
DEFINE VARIABLE h-reapi433         AS HANDLE                             NO-UNDO.
DEFINE VARIABLE cClassTrib         LIKE relac-class-trib.cod-cclass-trib NO-UNDO.
DEFINE VARIABLE cCST               LIKE relac-class-trib.cod-cst         NO-UNDO.
DEFINE VARIABLE cClassTribReg      LIKE relac-class-trib.cod-cclass-trib NO-UNDO.
DEFINE VARIABLE cCSTReg            LIKE relac-class-trib.cod-cst         NO-UNDO.
DEFINE VARIABLE h-cdapi1005        AS HANDLE                             NO-UNDO.
DEFINE VARIABLE h-imapi017         AS HANDLE                             NO-UNDO.
DEFINE VARIABLE l-nt2024002        AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE h-bocx407          AS HANDLE                             NO-UNDO.
DEFINE VARIABLE i-embarque-old     LIKE ordens-embarque.embarque         NO-UNDO.
DEFINE VARIABLE plIsGovEntity      AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE plGovEntityType    AS INTEGER                            NO-UNDO.

DEFINE BUFFER btt-ordens-desemb FOR tt-ordens-desemb.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).

PROCEDURE setConstraint1:
/*------------------------------------------------------------------------------
  Purpose: Restricaoo de abertura para a query    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.
END PROCEDURE.  

PROCEDURE setConstraint2:
/*------------------------------------------------------------------------------
  Purpose: Restricaoo de abertura para a query        
  Parameters: INPUT - p-cod-estabel (character) - codigo do estabelecimento
              INPUT - p-embarque (character) - codigo do embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-embarque    LIKE embarque-imp.embarque NO-UNDO.

    ASSIGN c-cod-estabel = p-cod-estabel
           c-embarque    = p-embarque.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintParam:
/*------------------------------------------------------------------------------
  Purpose: Restricaoo de abertura para a query        
  Parameters: INPUT - pi-numero-ordem-ini (integer) - codigo do estabelecimento
              INPUT - pi-numero-ordem-fim (integer) - codigo do embarque
              INPUT - pc-item-ini (character) - faixa inicial do codigo do item       
              INPUT - pc-item-fim (character) - faixa final do codigo do item      
              INPUT - pc-class-fiscal-ini (character) - faixa inicial da classificao fiscal
              INPUT - pc-class-fiscal-fim (character) - faixa final da classificao fiscal
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-numero-ordem-ini LIKE ordem-compra.numero-ordem.
    DEFINE INPUT PARAMETER pi-numero-ordem-fim LIKE ordem-compra.numero-ordem.
    DEFINE INPUT PARAMETER pc-item-ini         LIKE ITEM.it-codigo.
    DEFINE INPUT PARAMETER pc-item-fim         LIKE ITEM.it-codigo.
    DEFINE INPUT PARAMETER pc-class-fiscal-ini LIKE classif-fisc.class-fiscal.
    DEFINE INPUT PARAMETER pc-class-fiscal-fim LIKE classif-fisc.class-fiscal.

    ASSIGN i-numero-ordem-ini    =  pi-numero-ordem-ini
           i-numero-ordem-fim    =  pi-numero-ordem-fim
           c-item-ini            =  pc-item-ini        
           c-item-fim            =  pc-item-fim        
           c-class-fiscal-ini    =  pc-class-fiscal-ini
           c-class-fiscal-fim    =  pc-class-fiscal-fim.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQuery:
/*------------------------------------------------------------------------------
  Purpose: Abertura da Query, passando como parametro qual abertura sera utilizada    
  Parameters:  INPUT - i-abertura (integer) - indica qual abertura sera realizada na query
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-abertura AS INTEGER NO-UNDO.

    CASE i-abertura:
        WHEN 1 THEN DO:
            OPEN QUERY {&QUERY-NAME} FOR EACH ordens-embarque NO-LOCK.
        END.
        WHEN 2 THEN 
            OPEN QUERY {&QUERY-NAME} FOR EACH ordens-embarque NO-LOCK
                 WHERE ordens-embarque.cod-estabel = c-cod-estabel
                   AND ordens-embarque.embarque    = c-embarque.
    END CASE.

    ASSIGN l-query    = TRUE
           i-bo-query = i-abertura.

    RETURN "OK":U.
END PROCEDURE.
 
{include/bostrmet.i} /* startMethod                                       */ 
{include/boendmet.i} /* endMethod                                         */ 
{include/bocomver.i} /* compareVersion                                    */ 
{include/bogetver.i} /* getVersion                                        */ 
{include/bonav.i}    /* findFirst, findPrev, findNext, findLast, getRowid */ 
{include/bofind.i}   /* findRowid                                         */ 
{include/bosetcur.i} /* setCurrent                                        */ 
{include/bogetcur.i} /* getCurrent                                        */ 
{include/bosersen.i} /* serverSendRows                                    */ 
{include/boprebro.i} /* prevBrowseNavigation                              */ 


PROCEDURE findCodigo:
/*------------------------------------------------------------------------------
  Purpose: Procura pelo indice, caso nao ache, retorna mensagem de erro padrao do EMS.
  Parameters:  INPUT - i-numero-ordem (integer) - numero da ordem de compra
               INPUT - c-nr-proc-impt (character) - numero do processo de importacao
               INPUT - c-return (character) - status do processamento ("" = OK)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER i-numero-ordem AS INTEGER      NO-UNDO.
    DEFINE INPUT  PARAMETER c-nr-proc-imp  AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER c-return       AS CHARACTER    NO-UNDO.
    
    RUN startMethod("find":U).
    
    FIND FIRST ordens-embarque 
         WHERE ordens-embarque.numero-ordem = i-numero-ordem 
           AND ordens-embarque.nr-proc-imp  = c-nr-proc-imp NO-LOCK NO-ERROR.

    IF NOT AVAIL ordens-embarque THEN DO:
        {utp/ut-table.i mgcex ordens-embarque 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
        ASSIGN c-return = RETURN-VALUE.
    END.
    ELSE DO:
        RUN setCurrent.
    END.
    RUN endMethod("find":U).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE findEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Procura a primeira ordem do embarque, caso nao ache, retorna mensagem de erro padrao do EMS.
  Parameters:  INPUT - c-cod-estabel (character) - codigo do estabelecimento 
               INPUT - c-embarque (character) - numero do embarque
               INPUT - c-return (character) - status do processamento ("" = OK)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER c-embarque    AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-return      AS CHARACTER NO-UNDO.
    
    RUN startMethod("find":U).    
    
    FIND FIRST ordens-embarque 
         WHERE ordens-embarque.cod-estabel = c-cod-estabel 
           AND ordens-embarque.embarque    = c-embarque NO-LOCK NO-ERROR.

    IF NOT AVAIL ordens-embarque THEN DO:
        {utp/ut-table.i mgcex ordens-embarque 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
        ASSIGN c-return = RETURN-VALUE.
    END.
    ELSE DO:
        RUN setCurrent.
    END.
    
    RUN endMethod("find":U).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE findProcesso:
/*------------------------------------------------------------------------------
  Purpose: Procura a primeira ordem do embarque, caso nao ache, retorna mensagem de erro padrao do EMS.
  Parameters:  INPUT - i-numero-ordem (integer) - numero da ordem de compra
               INPUT - c-nr-proc-impt (character) - numero do processo de importacao
               INPUT - c-return (character) - status do processamento ("" = OK)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-nr-proc-imp LIKE processo-imp.nr-proc-imp NO-UNDO.
    DEFINE OUTPUT PARAMETER c-return      AS CHARACTER                  NO-UNDO.

    FIND FIRST ordens-embarque
         WHERE ordens-embarque.nr-proc-imp  = c-nr-proc-imp NO-LOCK NO-ERROR.

    IF NOT AVAIL ordens-embarque THEN DO:
        {utp/ut-table.i mgcex ordens-embarque 1}
        RUN utp/ut-msgs.p (INPUT "msg":u,
                           INPUT 2,
                           INPUT RETURN-VALUE).
        ASSIGN c-return = RETURN-VALUE.
    END.
    ELSE DO:
       RUN setCurrent.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getCharField:
/*------------------------------------------------------------------------------
  Purpose: Retorna o valor do campo do registro corrente - CHARACTER.
  Parameters: INPUT - c-field (character) - nome do campo
              OUTPUT - c-value (chracter) - valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS CHARACTER NO-UNDO.
	
    IF NOT AVAILABLE RowObject THEN 
        RETURN ERROR.
	
    CASE c-field:
        WHEN "cod-estabel":U         THEN c-value = RowObject.cod-estabel.
        WHEN "nr-proc-imp":U         THEN c-value = RowObject.nr-proc-imp.
        WHEN "embarque":U            THEN c-value = RowObject.embarque.
        WHEN "identific-container":U THEN c-value = RowObject.identific-container.
        WHEN "caracter-container":U  THEN c-value = RowObject.caracter-container.
        WHEN "char-1":U              THEN c-value = RowObject.char-1.
        WHEN "char-2":U              THEN c-value = RowObject.char-2.
        WHEN "check-sum":U           THEN c-value = RowObject.check-sum.
        WHEN "tipo-container"        THEN c-value = RowObject.tipo-container.
        WHEN "nr-ato-concessorio"    THEN c-value = RowObject.nr-ato-concessorio.
        OTHERWISE RETURN ERROR.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.
 
PROCEDURE getDecField:
/*------------------------------------------------------------------------------
  Purpose: Retorna o valor do campo do registro corrente - DECIMAL.
  Parameters: INPUT - c-field (character) - nome do campo
              OUTPUT - c-value (decimal) - valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS DECIMAL   NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN ERROR.
 
    CASE c-field:
        WHEN "quantidade":U          THEN c-value = RowObject.quantidade.
        WHEN "qt-do-forn":U          THEN c-value = RowObject.qt-do-forn.
        WHEN "dec-1":U               THEN c-value = RowObject.dec-1.
        WHEN "dec-2":U               THEN c-value = RowObject.dec-2.
        WHEN "peso-bruto":U          THEN c-value = RowObject.peso-bruto.
        WHEN "peso-liquido":U        THEN c-value = RowObject.peso-liquido.
        WHEN "aliquota-ipi":U        THEN c-value = RowObject.aliquota-ipi.
        WHEN "aliquota-icms":U       THEN c-value = RowObject.aliquota-icms.
        WHEN "aliquota-ii":U         THEN c-value = RowObject.aliquota-ii.
        WHEN "val-cub-unit":U        THEN c-value = RowObject.val-cub-unit.
        WHEN "val-aliq-ext-pis":U    THEN c-value = RowObject.val-aliq-ext-pis.
        WHEN "val-aliq-ext-cofins":U THEN c-value = RowObject.val-aliq-ext-cofins.
        WHEN "val-cub-tot":U         THEN c-value = RowObject.val-cub-tot.
        WHEN "val-peso-embal":U      THEN c-value = RowObject.val-peso-embal.
        WHEN "val-tax-siscomex":U    THEN c-value = RowObject.val-tax-siscomex.
        OTHERWISE RETURN ERROR.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getIntField:
/*------------------------------------------------------------------------------
  Purpose: Retorna o valor do campo do registro corrente - INTEGER.
  Parameters: INPUT - c-field (character) - nome do campo
              OUTPUT - c-value (integer) - valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS INTEGER   NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN ERROR.
 
    CASE c-field:
        WHEN "numero-ordem":U        THEN c-value = RowObject.numero-ordem.
        WHEN "parcela":U             THEN c-value = RowObject.parcela.    
        WHEN "int-1":U               THEN c-value = RowObject.int-1.
        WHEN "int-2":U               THEN c-value = RowObject.int-2.
        WHEN "cd-trib-ipi":U         THEN c-value = RowObject.cd-trib-ipi.
        WHEN "cd-trib-icms":U        THEN c-value = RowObject.cd-trib-icms.
        WHEN "cd-trib-ii":U          THEN c-value = RowObject.cd-trib-ii.
        WHEN "idi-tributac-pis":U    THEN c-value = RowObject.idi-tributac-pis.
        WHEN "idi-tributac-cofins":U THEN c-value = RowObject.idi-tributac-cofins.
        WHEN "num-adic":U            THEN c-value = RowObject.num-adic.
        OTHERWISE RETURN ERROR.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.
 
PROCEDURE getDateField:
/*------------------------------------------------------------------------------
  Purpose: Retorna o valor do campo do registro corrente - DATE.
  Parameters: INPUT - c-field (character) - nome do campo
              OUTPUT - c-value (date) - valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS DATE      NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN ERROR.
 
    CASE c-field:
        WHEN "data-1":U THEN c-value = RowObject.data-1.
        WHEN "data-2":U THEN c-value = RowObject.data-2.        
        OTHERWISE RETURN ERROR.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getLogField:
/*------------------------------------------------------------------------------
  Purpose: Retorna o valor do campo do registro corrente - LOGICAL.
  Parameters: INPUT - c-field (character) - nome do campo
              OUTPUT - c-value (logical) - valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS LOGICAL   NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN ERROR.
 
    CASE c-field:
        WHEN "log-1":U                    THEN c-value = RowObject.log-1.
        WHEN "log-2":U                    THEN c-value = RowObject.log-2.
        WHEN "log-suspens-impto-import":U THEN c-value = RowObject.log-suspens-impto-import.
        WHEN "log-suspens-ipi-import":U   THEN c-value = RowObject.log-suspens-ipi-import.
        WHEN "log-ja-gravad":U            THEN c-value = RowObject.log-ja-gravad.
        WHEN "log-aplica-desc-icms":U     THEN c-value = RowObject.log-aplica-desc-icms.
        OTHERWISE RETURN ERROR.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE loadOrdensDesemb:
/*------------------------------------------------------------------------------
  Purpose: Cria e seta valores para a temp-table tt-ordens-desemb com base na tt-ordens-embarque
  Parameters: INPUT TABLE - tt-ordens-embarque - TT base
              INPUT - p-nat-operacao - codigo da natureza de operacao    
              INPUT - p-usuario - codigo do usuario          
              INPUT - p-recarrega        
              INPUT - p-icms-diferido    
              INPUT - p-total            
              INPUT - p-recarrega-II     
              INPUT - p-recarrega-ipi    
              INPUT - p-recarrega-icms   
              INPUT - p-recarrega-pis    
              INPUT - p-recarrega-cof  
              INPUT - p-recarrega-IBSUF
              INPUT - p-recarrega-IBSMun
              INPUT - p-recarrega-CBS
              INPUT - p-recarrega-IS
              INPUT - p-recarrega-p-bruto
              INPUT - p-recarrega-p-liqui
              INPUT - p-recarrega-cubagem
              OUTPUT TABLE - tt-ordens-desemb - TT com os campos preenchidos
              OUTPUT TABLE - tt-bo-erro - TT com erros ocorridos durante o processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE  FOR tt-ordens-embarque.
    DEFINE INPUT  PARAMETER p-nat-operacao      LIKE natur-oper.nat-operacao NO-UNDO.
    DEFINE INPUT  PARAMETER p-usuario           LIKE param-re.usuario        NO-UNDO.
    DEFINE INPUT  PARAMETER p-recarrega         AS LOGICAL                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-icms-diferido     AS LOGICAL                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-total             AS LOGICAL                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-recarrega-II      AS LOGICAL                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-recarrega-ipi     AS LOGICAL                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-recarrega-icms    AS LOGICAL                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-recarrega-pis     AS LOGICAL                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-recarrega-cof     AS LOGICAL                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-recarrega-IBSUF   AS LOGICAL                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-recarrega-IBSMun  AS LOGICAL                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-recarrega-CBS     AS LOGICAL                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-recarrega-IS      AS LOGICAL                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-recarrega-p-bruto AS LOGICAL                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-recarrega-p-liqui AS LOGICAL                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-recarrega-cubagem AS LOGICAL                   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-ordens-desemb.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    DEFINE VARIABLE c-trib-ipi          AS   CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-trib-icms         AS   CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-trib-pis          AS   CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-trib-cofins       AS   CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-class-fiscal-esp  AS   CHARACTER INITIAL ""       NO-UNDO.
    DEFINE VARIABLE de-valor-un-pis     AS   DECIMAL                    NO-UNDO.
    DEFINE VARIABLE de-valor-vol-pis    AS   DECIMAL                    NO-UNDO.
    DEFINE VARIABLE de-valor-un-cofins  AS   DECIMAL                    NO-UNDO.
    DEFINE VARIABLE de-valor-vol-cofins AS   DECIMAL                    NO-UNDO.
    DEFINE VARIABLE de-peso-total       AS   DECIMAL                    NO-UNDO.
    DEFINE VARIABLE de-volume-total     AS   DECIMAL                    NO-UNDO.
    DEFINE VARIABLE de-red-pis          AS   DECIMAL FORMAT ">>9.99":U  NO-UNDO. /* Valor Reducao PIS          */
    DEFINE VARIABLE de-red-cofins       AS   DECIMAL FORMAT ">>9.99":U  NO-UNDO. /* Valor Reducao COFINS       */
    DEFINE VARIABLE d-qtd-embal         AS   DECIMAL                    NO-UNDO.
    DEFINE VARIABLE h-im9048            AS   HANDLE                     NO-UNDO.
    DEFINE VARIABLE h-bodi425           AS   HANDLE                     NO-UNDO.
    DEFINE VARIABLE h-boin356           AS   HANDLE                     NO-UNDO.
    DEFINE VARIABLE i-trib-ipi          AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE i-trib-ii           AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE i-trib-ii-nat       AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE i-trib-ii-item      AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE i-trib-icms         AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE i-trib-pis          AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE i-trib-cofins       AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE l-gravado           AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE l-recarrega-II      AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE l-recarrega-ipi     AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE l-recarrega-icms    AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE l-recarrega-pis     AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE l-recarrega-cof     AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE l-recarrega-p-bruto AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE l-recarrega-p-liqui AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE l-recarrega-cubagem AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE l-emb               AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE de-aliq-ii          AS   DECIMAL FORMAT ">>9.9999"  NO-UNDO.
    DEFINE VARIABLE de-aliq-ipi         LIKE item.aliquota-ipi          NO-UNDO.
    DEFINE VARIABLE de-aliq-icms        LIKE item.aliquota-ipi          NO-UNDO.
    DEFINE VARIABLE de-aliq-pis         AS   DECIMAL FORMAT ">>9.9999"  NO-UNDO.
    DEFINE VARIABLE de-aliq-cofins      AS   DECIMAL FORMAT ">>9.9999"  NO-UNDO.
    DEFINE VARIABLE l-retorno           AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE i-cont-prg          AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE l-im0100d           AS   LOGICAL                    NO-UNDO.

    {cxbo/bocx225e.i1} /* Variaveis atributos livres */

    EMPTY TEMP-TABLE tt-ordens-desemb.
    
    IF NOT VALID-HANDLE(h-im9048)    THEN RUN imp/im9048.p     PERSISTENT SET h-im9048. /* Tratamento PIS/COFINS */
    IF NOT VALID-HANDLE(h-boin356)   THEN RUN inbo/boin356ab.p PERSISTENT SET h-boin356.
    IF NOT VALID-HANDLE(h-bodi425)   THEN RUN dibo/bodi425.p   PERSISTENT SET h-bodi425.
    IF NOT VALID-HANDLE(h-reapi433)  THEN RUN rep/reapi433.p   PERSISTENT SET h-reapi433.    
    IF NOT VALID-HANDLE(h-imapi017)  THEN RUN imp/imapi017.p   PERSISTENT SET h-imapi017.
    IF NOT VALID-HANDLE(h-cdapi1005) THEN RUN cdp/cdapi1005.p  PERSISTENT SET h-cdapi1005.
    
    /* Verifica  se existe natureza de operaá∆o informada, quando existe 
       se refere ao objeto im0100d, quando n∆o existe se refere ao objeto im0100c. */

    IF p-usuario <> "" THEN DO:
        FIND FIRST natur-oper 
             WHERE natur-oper.nat-operacao = p-nat-operacao NO-LOCK NO-ERROR.
    END.
    
    ASSIGN l-recarrega-II      = p-recarrega-II
           l-recarrega-ipi     = p-recarrega-ipi
           l-recarrega-icms    = p-recarrega-icms
           l-recarrega-pis     = p-recarrega-pis
           l-recarrega-cof     = p-recarrega-cof
           l-recarrega-p-bruto = p-recarrega-p-bruto
           l-recarrega-p-liqui = p-recarrega-p-liqui
           l-recarrega-cubagem = p-recarrega-cubagem.
    
    
    FIND FIRST tt-ordens-embarque NO-LOCK NO-ERROR.
    IF AVAILABLE tt-ordens-embarque THEN
    RUN pi-verifica-ente-governamental (INPUT tt-ordens-embarque.cod-estabel).
    
    FOR FIRST estabelec FIELDS (cod-estabel cod-emitente estado pais cidade char-1) 
        WHERE estabelec.cod-estabel = tt-ordens-embarque.cod-estabel NO-LOCK:
    END.

    FOR FIRST emitente FIELDS (contrib-icms natureza cod-emitente cod-gr-forn)
        WHERE emitente.cod-emitente = estabelec.cod-emitente NO-LOCK:
    END.

    FOR EACH tt-ordens-embarque NO-LOCK:

        /* Inicio chamada UPC - evento ClassFiscalEsp */
        for each tt-epc  
           where tt-epc.cod-event = "ClassFiscalEsp":
            delete tt-epc.
        end.
        
        create tt-epc.
        assign tt-epc.cod-event     = "ClassFiscalEsp":U
               tt-epc.cod-parameter = "cod-estabel":U
               tt-epc.val-parameter = tt-ordens-embarque.cod-estabel.
        create tt-epc.
        assign tt-epc.cod-event     = "ClassFiscalEsp":U
               tt-epc.cod-parameter = "embarque":U
               tt-epc.val-parameter = tt-ordens-embarque.embarque.
        create tt-epc.
        assign tt-epc.cod-event     = "ClassFiscalEsp":U
               tt-epc.cod-parameter = "numero-ordem":U
               tt-epc.val-parameter = string(tt-ordens-embarque.numero-ordem).
        create tt-epc.
        assign tt-epc.cod-event     = "ClassFiscalEsp":U
               tt-epc.cod-parameter = "parcela":U
               tt-epc.val-parameter = string(tt-ordens-embarque.parcela).
        create tt-epc.
        
        {include/i-epc201.i "ClassFiscalEsp"} 
        
        FOR FIRST tt-epc 
            where tt-epc.cod-event     = "ClassFiscalEsp":U
            AND   tt-epc.cod-parameter = "class-fiscal-esp":U:

            ASSIGN c-class-fiscal-esp = tt-epc.val-parameter.
        END.
        /* Fim chamada UPC - evento ClassFiscalEsp */
        
        IF p-usuario = "" THEN DO: /*PESO E CUBAGEM*/
            {cxbo/bocx225e.i3 NO tt-ordens-embarque} /* busca valores */
        END.
        ELSE DO:                  /*IMPOSTOS*/
            {cxbo/bocx225e.i4 NO tt-ordens-embarque} /* busca valores */
        END.
    
         /* Verifica se j† foram informados valores para o item nas ordens de embarque */
        ASSIGN l-gravado = l-ja-gravado.
    
        FOR FIRST ordem-compra FIELDS (it-codigo narrativa cod-emitente)
            WHERE ordem-compra.numero-ordem = tt-ordens-embarque.numero-ordem NO-LOCK:
        END.
    
        FOR FIRST cotacao-item FIELDS(numero-ordem cot-aprovada it-codigo char-1)
            WHERE cotacao-item.numero-ordem = tt-ordens-embarque.numero-ordem
              AND cotacao-item.cot-aprovada NO-LOCK:
        END.
    
        FOR FIRST item FIELDS (it-codigo un peso-bruto peso-liquido tipo-contr
                               cd-trib-ipi cd-trib-icm aliquota-ipi char-1 char-2 
                               largura comprim class-fiscal desc-item cod-servico)
            WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK:
        END.

        IF AVAIL item THEN DO:

            CREATE tt-ordens-desemb.
            BUFFER-COPY tt-ordens-embarque TO tt-ordens-desemb.

            ASSIGN tt-ordens-desemb.aliquota-ii    = 0
                   tt-ordens-desemb.aliquota-ipi   = 0
                   tt-ordens-desemb.aliquota-icms  = 0
                   tt-ordens-desemb.dec-1          = 0  //val-aliq-ext-pis
                   tt-ordens-desemb.dec-2          = 0. //val-aliq-ext-cofins
        
            ASSIGN tt-ordens-desemb.de-quantidade = tt-ordens-embarque.quantidade.

            
            
            /******************************************************
            * Busca default's para os novos campos na abertura do *
            * programa, caso nenhuma informacao tenha sido salva  *
            ******************************************************/
            IF  l-recarrega-II           
            OR  l-recarrega-IPI          
            OR  (NOT l-gravado AND c-suspensao-II  = "":U  AND c-suspensao-IPI = "":U) THEN DO:
                
                IF  AVAIL natur-oper THEN DO:
                    IF natur-oper.log-suspens-impto-import THEN
                        ASSIGN c-suspensao-II  = "1":U.
                    ELSE
                        ASSIGN c-suspensao-II  = "":U.

                    IF natur-oper.log-suspens-ipi-import   THEN
                        ASSIGN c-suspensao-IPI = "1":U.
                    ELSE
                        ASSIGN c-suspensao-IPI = "":U.
                END.

                IF c-suspensao-II  = "":U OR c-suspensao-IPI = "":U THEN DO:
                    
                    IF  AVAIL item THEN
                        FIND FIRST item-mat
                             WHERE item-mat.it-codigo = item.it-codigo NO-LOCK NO-ERROR.

                    IF AVAIL item-mat THEN DO:
                        
                        IF  c-suspensao-II  = "":U THEN DO:

                            IF  item-mat.log-suspens-impto-import THEN
                                ASSIGN c-suspensao-II = "1":U.
                            ELSE
                                ASSIGN c-suspensao-II = "":U.
                        END.

                        IF c-suspensao-IPI = "":U THEN DO:

                            IF  item-mat.log-suspens-ipi-import   THEN
                                ASSIGN c-suspensao-IPI = "1":U.
                            ELSE
                                ASSIGN c-suspensao-IPI = "":U.
                        END.
                    END.
                END.
            END.

            /******************************************************
            * Atribuicao aos novos campos da tela (IM0100B)       *
            ******************************************************/
            IF  c-suspensao-II  = "1":U THEN
                ASSIGN tt-ordens-desemb.l-suspensao-II  = YES.
            ELSE
                ASSIGN tt-ordens-desemb.l-suspensao-II  = NO.

            IF  c-suspensao-IPI = "1":U THEN
                ASSIGN tt-ordens-desemb.l-suspensao-IPI = YES.
            ELSE
                ASSIGN tt-ordens-desemb.l-suspensao-IPI = NO.
            
            /*
            ** Item
            */
            ASSIGN tt-ordens-desemb.c-it-codigo     = item.it-codigo
                   tt-ordens-desemb.c-desc-item     = item.desc-item
                   tt-ordens-desemb.c-un            = item.un
                   tt-ordens-desemb.c-un-item       = item.un
                   tt-ordens-desemb.c-class-fiscal  = IF c-class-fiscal-esp <> "" THEN c-class-fiscal-esp ELSE item.class-fiscal.
    
            FOR FIRST item-fornec FIELDS (unid-med-for cod-embal ) 
                WHERE item-fornec.it-codigo    = tt-ordens-desemb.c-it-codigo
                  AND item-fornec.cod-emitente = ordem-compra.cod-emitente NO-LOCK:

                ASSIGN tt-ordens-desemb.c-un-fornec = item-fornec.unid-med-for.
            END.
           
            IF item.tipo-contr = 4 THEN DO: /* DÇbito Direto */
                
                IF item.it-codigo = "" THEN
                    ASSIGN tt-ordens-desemb.c-desc-item = ordem-compra.narrativa.
                
                /* Itens debito direto nao possuem unidade de medida do fornecedor */
                ASSIGN tt-ordens-desemb.c-un-fornec     = item.un
                       tt-ordens-desemb.cod-nbs         = TRIM(SUBSTRING(item.char-1,342,20)).

                IF AVAIL cotacao-item THEN DO:
                    {ccp/cc9019.i50}
                    {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                    {ccp/cc9019.i51 "yes"}
                   
                    IF c-class-fiscal-i50 <> "" THEN
                       ASSIGN tt-ordens-desemb.c-class-fiscal = IF c-class-fiscal-esp <> "" THEN c-class-fiscal-esp ELSE c-class-fiscal-i50.
                    
                    IF SUBSTRING(cotacao-item.char-1,101,20) <> "" THEN
                        ASSIGN tt-ordens-desemb.cod-nbs = TRIM(SUBSTRING(cotacao-item.char-1,101,20)).
                END.
            END.
           
            IF (tt-ordens-embarque.cod-natur-of <> "" AND 
                tt-ordens-embarque.cod-natur-of <> ? ) THEN DO: 
                ASSIGN tt-ordens-desemb.c-nat-fiscal       = tt-ordens-embarque.cod-natur-of.
            END.
            ELSE DO:
                ASSIGN tt-ordens-desemb.c-nat-fiscal       = p-nat-operacao.
            END.
            
    
            /* A partir da versao 2.05, foi dividido as informaá‰es de Peso e Cubagem em uma tela(im0100c) e Imposto
            em outra (im0100d) - Peso e Cubagem - calcula - Peso Bruto, Peso Liquido , Total Cubagem Impostos - II, ICMS, IPI entre outros...
            */
            FIND FIRST prazo-compra
                 WHERE prazo-compra.numero-ordem = tt-ordens-embarque.numero-ordem
                   AND prazo-compra.parcela      = tt-ordens-embarque.parcela NO-LOCK NO-ERROR.

            IF AVAIL prazo-compra AND VALID-HANDLE(h-boin356) AND VALID-HANDLE(h-bodi425) THEN DO:
                
               RUN piRetornaQtdeEmbalagem IN h-bodi425(INPUT IF p-total THEN tt-ordens-embarque.quantidade ELSE 1, 
                                                       INPUT prazo-compra.it-codigo, 
                                                       INPUT ordem-compra.cod-emitente,
                                                       OUTPUT d-qtd-embal).
               
               RUN retornaPesoTotal IN h-boin356 (INPUT ROWID(prazo-compra), 
                                                  INPUT IF p-total THEN tt-ordens-embarque.quantidade ELSE 1, 
                                                  INPUT d-qtd-embal, 
                                                  OUTPUT de-peso-total).

               IF NOT l-emb THEN
                   RUN retornaVolumeTotal IN h-boin356 (INPUT ROWID(prazo-compra), 
                                                         INPUT IF p-total THEN tt-ordens-embarque.quantidade ELSE 1, 
                                                         OUTPUT de-volume-total).
               ELSE
                   RUN retornaVolumeTotal IN h-boin356 (INPUT ROWID(prazo-compra), 
                                                        INPUT IF d-qtd-embal <> 0 THEN d-qtd-embal ELSE tt-ordens-embarque.quantidade,
                                                        OUTPUT de-volume-total).
            END.
            
            IF  p-usuario = "" THEN DO:
                
                IF l-recarrega-p-bruto THEN
                    ASSIGN tt-ordens-desemb.de-peso-bruto        = de-peso-total
                           tt-ordens-desemb.de-peso-bruto-unit   = de-peso-total.
                ELSE
                    ASSIGN tt-ordens-desemb.de-peso-bruto        = de-peso-bruto-i1 
                           tt-ordens-desemb.de-peso-bruto-unit   = de-peso-bruto-i1.
                
                 IF l-recarrega-p-liqui THEN
                     ASSIGN tt-ordens-desemb.de-peso-liquido      = item.peso-liquido
                            tt-ordens-desemb.de-peso-liquido-unit = item.peso-liquido.
                 ELSE
                     ASSIGN tt-ordens-desemb.de-peso-liquido      = de-peso-liquido-i1 
                            tt-ordens-desemb.de-peso-liquido-unit = de-peso-liquido-i1.
                
                
                
                IF  l-recarrega-cubagem THEN
                    ASSIGN tt-ordens-desemb.de-cubagem   = de-volume-total
                           tt-ordens-desemb.val-cub-unit = de-volume-total / IF d-qtd-embal <> 0 THEN d-qtd-embal ELSE tt-ordens-embarque.quantidade 
                           tt-ordens-desemb.val-cub-tot  = de-volume-total.
                ELSE
                    ASSIGN tt-ordens-desemb.de-cubagem   = de-cub-tot-i1
                           tt-ordens-desemb.val-cub-unit = de-cub-unit-i1
                           tt-ordens-desemb.val-cub-tot  = de-cub-tot-i1.
                
                
                ASSIGN tt-ordens-desemb.de-peso-embal = tt-ordens-desemb.de-peso-bruto - tt-ordens-desemb.de-peso-liquido.
            END.
            ELSE DO:
                /*
                ** Tributacao II
                */
                IF l-recarrega-II OR NOT l-gravado THEN DO:
                    
                    ASSIGN i-trib-ii-item = INTEGER(TRIM(SUBSTRING(ITEM.char-2,20,2))).
                    ASSIGN i-trib-ii-nat  = IF AVAIL natur-oper THEN INTEGER(SUBSTRING(natur-oper.char-1,10,2)) ELSE 0.
            
                    RUN imp/im9041.p (INPUT  i-trib-ii-item,
                                      INPUT  i-trib-ii-nat,
                                      OUTPUT i-trib-ii).
                END.
                ELSE
                    ASSIGN i-trib-ii = i-trib-ii-i1.
            

                ASSIGN tt-ordens-desemb.i-trib-ii  = i-trib-ii
                       tt-ordens-desemb.c-trib-ii  = SUBSTRING({ininc/i10in172.i 04 i-trib-ii},1,1).
        
                /*
                ** Aliquota II
                */ 
                IF l-recarrega-II OR NOT l-gravado THEN DO:

                    IF tt-ordens-desemb.aliquota-ii = 0 THEN
                        RUN imp/im9042.p (INPUT tt-ordens-desemb.numero-ordem, OUTPUT de-aliq-ii).
                    ELSE
                        ASSIGN de-aliq-ii = tt-ordens-desemb.aliquota-ii.
                END.    
                ELSE
                    ASSIGN de-aliq-ii = de-aliq-ii-i1.
                
                ASSIGN tt-ordens-desemb.de-aliq-ii = de-aliq-ii.
                       
                /*
                ** Tributacao IPI
                */
                IF l-recarrega-ipi OR NOT l-gravado THEN DO:
                    
                    RUN cdp/cd4303.p (INPUT  item.cd-trib-ipi,
                                      INPUT  IF AVAIL natur-oper THEN natur-oper.cd-trib-ipi ELSE 0,
                                      OUTPUT i-trib-ipi).
                    
                END.
                ELSE
                    ASSIGN i-trib-ipi = i-trib-ipi-i1.
        
                ASSIGN tt-ordens-desemb.i-trib-ipi = i-trib-ipi
                       tt-ordens-desemb.c-trib-ipi = SUBSTRING({ininc/i10in172.i 04 i-trib-ipi},1,1).
        
                /*
                ** Aliquota IPI 
                */ 

                IF l-recarrega-ipi OR NOT l-gravado THEN DO:

                    IF tt-ordens-desemb.aliquota-ipi = 0 THEN DO:

                        RUN imp/im9043.p (INPUT  p-usuario,
                                          INPUT  tt-ordens-desemb.numero-ordem,
                                          INPUT  tt-ordens-desemb.c-it-codigo,
                                          OUTPUT de-aliq-ipi).
                    END.
                    ELSE
                        ASSIGN de-aliq-ipi = tt-ordens-desemb.aliquota-ipi.
                END.
                ELSE
                    ASSIGN de-aliq-ipi = de-aliq-ipi-i1.
        
                ASSIGN tt-ordens-desemb.de-aliq-ipi = de-aliq-ipi.
        
                /*
                ** Tributacao ICMS
                */
                IF p-icms-diferido THEN
                    ASSIGN i-trib-icms = 3.
                ELSE
                    IF l-recarrega-icms OR NOT l-gravado THEN DO:

                        IF AVAIL natur-oper THEN
                            RUN cdp/cd4302.p (INPUT item.cd-trib-icm,
                                              INPUT natur-oper.cd-trib-icm,
                                              OUTPUT i-trib-icms).
                        ELSE
                            ASSIGN i-trib-icms = item.cd-trib-icm.
                    END.
                    ELSE
                        ASSIGN i-trib-icms = i-trib-icms-i1.
                
                ASSIGN tt-ordens-desemb.i-trib-icms = i-trib-icms
                       tt-ordens-desemb.c-trib-icms = SUBSTRING({ininc/i07in122.i 04 i-trib-icms},1,1).
        
                /*
                ** Aliquota ICMS
                */
                IF p-icms-diferido THEN
                    ASSIGN de-aliq-icms = 0.
                ELSE
                    IF l-recarrega-icms OR NOT l-gravado THEN DO:
                        IF tt-ordens-desemb.aliquota-icms = 0 THEN DO:
                            
                            run cdp/cd4301.p ( (IF AVAIL emitente THEN emitente.contrib-icms ELSE YES),
                                               (IF AVAIL emitente THEN emitente.natureza     ELSE 2 /*"J"*/),
                                                estabelec.estado,
                                                estabelec.pais,
                                                estabelec.estado,
                                                tt-ordens-desemb.c-it-codigo,
                                                IF AVAIL natur-oper THEN natur-oper.aliquota-icm ELSE 0,
                                                OUTPUT de-aliq-icms).
                        END.
                        ELSE
                            ASSIGN de-aliq-icms = tt-ordens-desemb.aliquota-icms.
                    END.
                    ELSE
                        ASSIGN de-aliq-icms = de-aliq-icms-i1.
                                         
                ASSIGN tt-ordens-desemb.de-aliq-icms = de-aliq-icms.
                
                /* Aplica Desconto ICMS Desonerado */
                IF l-recarrega-icms OR NOT l-gravado THEN 
                   ASSIGN tt-ordens-desemb.l-aplica-desc-icms  = NO. 
                ELSE
                   ASSIGN tt-ordens-desemb.l-aplica-desc-icms  = tt-ordens-embarque.log-aplica-desc-icms.                
            
                /* Tributacao PIS */

                IF l-recarrega-pis OR NOT l-gravado THEN DO:
                    
                    IF tt-ordens-desemb.dec-1 = 0 THEN DO:
                        
                        RUN pi-tributa-aliquota-pis-importacao IN h-im9048 (BUFFER natur-oper,
                                                                            BUFFER item,
                                                                            INPUT  tt-ordens-embarque.cod-estabel,
                                                                            INPUT  TODAY,
                                                                            INPUT  NO,
                                                                            INPUT  tt-ordens-embarque.embarque,
                                                                            INPUT  tt-ordens-embarque.numero-ordem,
                                                                            INPUT  tt-ordens-embarque.parcela,
                                                                            OUTPUT i-trib-pis,
                                                                            OUTPUT de-aliq-pis,
                                                                            OUTPUT de-valor-un-pis,
                                                                            OUTPUT de-valor-vol-pis, 
                                                                            OUTPUT de-red-pis). /* Valor Reducao PIS */
                    END.
                    ELSE
                        ASSIGN de-aliq-pis = tt-ordens-desemb.dec-1
                               i-trib-pis  = i-trib-pis-i1. 
                END.
                ELSE 
                    ASSIGN i-trib-pis = i-trib-pis-i1.

                IF i-trib-pis <> 0 THEN 
                    ASSIGN tt-ordens-desemb.i-trib-pis = i-trib-pis
                           tt-ordens-desemb.c-trib-pis = SUBSTRING({ininc/i07in122.i 04 i-trib-pis},1,1).
                
                /* Aliquota PIS */
                IF l-recarrega-pis OR NOT l-gravado THEN 
                    ASSIGN de-aliq-pis = de-aliq-pis.
                ELSE
                    ASSIGN de-aliq-pis = de-aliq-pis-i1.

                ASSIGN tt-ordens-desemb.de-aliq-pis = de-aliq-pis.

                /* Tributacao COFINS */
                IF l-recarrega-cof OR NOT l-gravado THEN DO:
                    
                    IF tt-ordens-desemb.dec-2 = 0 THEN DO:

                        RUN pi-tributa-aliquota-cofins-importacao IN h-im9048 (BUFFER natur-oper,
                                                                               BUFFER ITEM,
                                                                               INPUT tt-ordens-embarque.cod-estabel,
                                                                               INPUT TODAY,
                                                                               INPUT NO,
                                                                               INPUT tt-ordens-embarque.embarque,    
                                                                               INPUT tt-ordens-embarque.numero-ordem,
                                                                               INPUT tt-ordens-embarque.parcela,     
                                                                               OUTPUT i-trib-cofins,
                                                                               OUTPUT de-aliq-cofins,
                                                                               OUTPUT de-valor-un-cofins,
                                                                               OUTPUT de-valor-vol-cofins, 
                                                                               OUTPUT de-red-cofins). /* Valor Reducao COFINS */
                    END.
                    ELSE
                        ASSIGN de-aliq-cofins = tt-ordens-desemb.dec-2 
                               i-trib-cofins  = i-trib-cofins-i1. 
                END.
                ELSE 
                    ASSIGN i-trib-cofins = i-trib-cofins-i1.

                IF i-trib-cofins <> 0 THEN
                    ASSIGN tt-ordens-desemb.i-trib-cofins = i-trib-cofins
                           tt-ordens-desemb.c-trib-cofins = SUBSTRING({ininc/i07in122.i 04 i-trib-cofins},1,1).

                /* Aliquota COFINS */
                IF l-recarrega-cof OR NOT l-gravado THEN 
                    ASSIGN de-aliq-cofins = de-aliq-cofins.
                ELSE
                    ASSIGN de-aliq-cofins = de-aliq-cofins-i1.

                ASSIGN tt-ordens-desemb.de-aliq-cofins = de-aliq-cofins.
                
                /* Reforma Tribut†ria */
                IF l-nt2024002 THEN DO:
                    /*Necess†rio na criaá∆o para que seja feita a busca pelo configurador e/ou da tabela ordens-embarque-trib caso j† gravado*/
                    ASSIGN tt-ordens-desemb.c-trib-IBSUF  = ""
                           tt-ordens-desemb.c-trib-IBSMun = ""
                           tt-ordens-desemb.c-trib-CBS    = ""
                           tt-ordens-desemb.c-trib-IS     = "".
                    
                    IF p-recarrega-IBSUF OR p-recarrega-IBSMun OR p-recarrega-CBS OR p-recarrega-IS THEN
                        ASSIGN tt-ordens-desemb.c-nat-fiscal = p-nat-operacao.
                           
                    RUN pi-busca-cClassTrib-CST-Aliq (INPUT p-recarrega-IBSUF,
                                                      INPUT p-recarrega-IBSMun,
                                                      INPUT p-recarrega-CBS,
                                                      INPUT p-recarrega-IS).
                END.
            END.

            ASSIGN tt-ordens-desemb.cdn-adicao       = tt-ordens-embarque.num-adic
                   tt-ordens-desemb.de-taxa-siscomex = tt-ordens-embarque.val-tax-siscomex
                   tt-ordens-desemb.seq-item         = INT(SUBSTR(tt-ordens-embarque.char-1, 80, 4)).
        END.
    END.
    
    /* Reforma Tribut†ria */
    IF  l-nt2024002 
    AND p-nat-operacao <> "" 
    AND CAN-FIND(FIRST tt-ordens-embarque) THEN DO:

        ASSIGN l-im0100d = NO.
        DO  i-cont-prg = 1 TO 10:
            IF  program-name(i-cont-prg) matches "*im0100d*" THEN DO:
                ASSIGN l-im0100d = YES.
                LEAVE.
            END.
        END.
    
        IF  NOT VALID-HANDLE(h-bocx407) THEN
            RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.
            
        FIND FIRST tt-ordens-embarque NO-LOCK NO-ERROR.
        RUN pi-valida-integracao-di IN h-bocx407(INPUT tt-ordens-embarque.embarque,
                                                 INPUT tt-ordens-embarque.cod-estabel,
                                                 OUTPUT l-retorno).

        RUN pi-busca-tributacaoRT IN h-imapi017 (INPUT p-recarrega-IBSUF,
                                                 INPUT p-recarrega-IBSMun,
                                                 INPUT p-recarrega-CBS,
                                                 INPUT p-recarrega-IS,
                                                 INPUT NOT l-retorno OR (l-retorno AND NOT l-im0100d),
                                                 INPUT-OUTPUT TABLE tt-ordens-desemb).
        RUN pi-verifica-cod-trib.
    END.    

    IF VALID-HANDLE(h-im9048) THEN DO:
        DELETE PROCEDURE h-im9048.
        ASSIGN h-im9048 = ?.
    END.

    IF VALID-HANDLE(h-boin356) THEN DO:
      DELETE PROCEDURE h-boin356.
      ASSIGN h-boin356 = ?.
    END.

    IF VALID-HANDLE(h-bodi425) THEN DO:
      DELETE PROCEDURE h-bodi425.
      ASSIGN h-bodi425 = ?.
    END.

    IF VALID-HANDLE(h-reapi433) THEN DO:
        DELETE PROCEDURE h-reapi433.
        ASSIGN h-reapi433 = ?.
    END.
    
    IF VALID-HANDLE(h-imapi017) THEN DO:
        DELETE PROCEDURE h-imapi017.
        ASSIGN h-imapi017 = ?.
    END.
    
    IF VALID-HANDLE(h-bocx407) THEN DO:
        DELETE PROCEDURE h-bocx407.
        ASSIGN h-bocx407 = ?.
    END.
    
    IF VALID-HANDLE(h-cdapi1005) THEN DO:
        DELETE PROCEDURE h-cdapi1005.
        ASSIGN h-cdapi1005 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE loadOrdensNatFiscal:
/*------------------------------------------------------------------------------
  Purpose: Cria e seta valores para a temp-table tt-ordens-desemb com base na tt-ordens-embarque
  Parameters: INPUT TABLE - tt-ordens-embarque - TT base
              INPUT - p-nat-operacao - codigo da natureza de operacao    
              INPUT - p-usuario - codigo do usuario          
              INPUT - p-icms-diferido    
              OUTPUT TABLE - tt-ordens-desemb - TT com os campos preenchidos
              OUTPUT TABLE - tt-bo-erro - TT com erros ocorridos durante o processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE  FOR tt-ordens-embarque.
    DEFINE INPUT  PARAMETER p-nat-operacao      LIKE natur-oper.nat-operacao NO-UNDO.
    DEFINE INPUT  PARAMETER p-usuario           LIKE param-re.usuario        NO-UNDO.
    DEFINE INPUT  PARAMETER p-icms-diferido     AS LOGICAL                   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-ordens-desemb.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    DEFINE VARIABLE c-trib-ipi          AS   CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-trib-icms         AS   CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-trib-pis          AS   CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-trib-cofins       AS   CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-class-fiscal-esp  AS   CHARACTER INITIAL ""       NO-UNDO.
    DEFINE VARIABLE de-valor-un-pis     AS   DECIMAL                    NO-UNDO.
    DEFINE VARIABLE de-valor-vol-pis    AS   DECIMAL                    NO-UNDO.
    DEFINE VARIABLE de-valor-un-cofins  AS   DECIMAL                    NO-UNDO.
    DEFINE VARIABLE de-valor-vol-cofins AS   DECIMAL                    NO-UNDO.
    DEFINE VARIABLE de-peso-total       AS   DECIMAL                    NO-UNDO.
    DEFINE VARIABLE de-volume-total     AS   DECIMAL                    NO-UNDO.
    DEFINE VARIABLE de-red-pis          AS   DECIMAL FORMAT ">>9.99":U  NO-UNDO. /* Valor Reducao PIS          */
    DEFINE VARIABLE de-red-cofins       AS   DECIMAL FORMAT ">>9.99":U  NO-UNDO. /* Valor Reducao COFINS       */
    DEFINE VARIABLE d-qtd-embal         AS   DECIMAL                    NO-UNDO.
    DEFINE VARIABLE h-im9048            AS   HANDLE                     NO-UNDO.
    DEFINE VARIABLE h-bodi425           AS   HANDLE                     NO-UNDO.
    DEFINE VARIABLE h-boin356           AS   HANDLE                     NO-UNDO.
    DEFINE VARIABLE i-trib-ipi          AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE i-trib-ii           AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE i-trib-ii-nat       AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE i-trib-ii-item      AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE i-trib-icms         AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE i-trib-pis          AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE i-trib-cofins       AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE l-gravado           AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE l-emb               AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE de-aliq-ii          AS   DECIMAL FORMAT ">>9.9999"  NO-UNDO.
    DEFINE VARIABLE de-aliq-ipi         LIKE item.aliquota-ipi          NO-UNDO.
    DEFINE VARIABLE de-aliq-icms        LIKE item.aliquota-ipi          NO-UNDO.
    DEFINE VARIABLE de-aliq-pis         AS   DECIMAL FORMAT ">>9.9999"  NO-UNDO.
    DEFINE VARIABLE de-aliq-cofins      AS   DECIMAL FORMAT ">>9.9999"  NO-UNDO.

    {cxbo/bocx225e.i1} /* Variaveis atributos livres */

    EMPTY TEMP-TABLE tt-ordens-desemb.
    
    IF NOT VALID-HANDLE(h-im9048)    THEN RUN imp/im9048.p     PERSISTENT SET h-im9048. /* Tratamento PIS/COFINS */
    IF NOT VALID-HANDLE(h-boin356)   THEN RUN inbo/boin356ab.p PERSISTENT SET h-boin356.
    IF NOT VALID-HANDLE(h-bodi425)   THEN RUN dibo/bodi425.p   PERSISTENT SET h-bodi425.
    IF NOT VALID-HANDLE(h-reapi433)  THEN RUN rep/reapi433.p   PERSISTENT SET h-reapi433.    
    IF NOT VALID-HANDLE(h-imapi017)  THEN RUN imp/imapi017.p   PERSISTENT SET h-imapi017.
    IF NOT VALID-HANDLE(h-cdapi1005) THEN RUN cdp/cdapi1005.p  PERSISTENT SET h-cdapi1005.
    
    /* Verifica  se existe natureza de operaá∆o informada, quando existe 
       se refere ao objeto im0100d, quando n∆o existe se refere ao objeto im0100c. */
    
    FIND FIRST natur-oper 
             WHERE natur-oper.nat-operacao = p-nat-operacao NO-LOCK NO-ERROR.
   
    FIND FIRST tt-ordens-embarque NO-LOCK NO-ERROR.
    IF AVAILABLE tt-ordens-embarque THEN
    RUN pi-verifica-ente-governamental (INPUT tt-ordens-embarque.cod-estabel).
    
    FOR FIRST estabelec FIELDS (cod-estabel cod-emitente estado pais cidade char-1) 
        WHERE estabelec.cod-estabel = tt-ordens-embarque.cod-estabel NO-LOCK:
    END.

    FOR FIRST emitente FIELDS (contrib-icms natureza cod-emitente cod-gr-forn)
        WHERE emitente.cod-emitente = estabelec.cod-emitente NO-LOCK:
    END.

    FOR EACH tt-ordens-embarque NO-LOCK:

                        /*IMPOSTOS*/
        {cxbo/bocx225e.i4 NO tt-ordens-embarque} /* busca valores */
       
    
        FOR FIRST ordem-compra FIELDS (it-codigo narrativa cod-emitente)
            WHERE ordem-compra.numero-ordem = tt-ordens-embarque.numero-ordem NO-LOCK:
        END.
    
        FOR FIRST cotacao-item FIELDS(numero-ordem cot-aprovada it-codigo char-1)
            WHERE cotacao-item.numero-ordem = tt-ordens-embarque.numero-ordem
              AND cotacao-item.cot-aprovada NO-LOCK:
        END.
    
        FOR FIRST item FIELDS (it-codigo un peso-bruto peso-liquido tipo-contr
                               cd-trib-ipi cd-trib-icm aliquota-ipi char-1 char-2 
                               largura comprim class-fiscal desc-item cod-servico)
            WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK:
        END.

        IF AVAIL item THEN DO:

            CREATE tt-ordens-desemb.
            BUFFER-COPY tt-ordens-embarque TO tt-ordens-desemb.

            ASSIGN tt-ordens-desemb.aliquota-ii   = 0
                   tt-ordens-desemb.aliquota-ipi  = 0
                   tt-ordens-desemb.aliquota-icms = 0
                   tt-ordens-desemb.dec-1         = 0  //val-aliq-ext-pis
                   tt-ordens-desemb.dec-2         = 0. //val-aliq-ext-cofins
        
            ASSIGN tt-ordens-desemb.de-quantidade = tt-ordens-embarque.quantidade.

            
            
            /******************************************************
            * Busca default's para os novos campos na abertura do *
            * programa, caso nenhuma informacao tenha sido salva  *
            ******************************************************/

            
                
            IF  AVAIL natur-oper THEN DO:
                IF natur-oper.log-suspens-impto-import THEN
                    ASSIGN c-suspensao-II  = "1":U.
                ELSE
                    ASSIGN c-suspensao-II  = "":U.

                IF natur-oper.log-suspens-ipi-import   THEN
                    ASSIGN c-suspensao-IPI = "1":U.
                ELSE
                    ASSIGN c-suspensao-IPI = "":U.
            END.

            IF c-suspensao-II  = "":U OR c-suspensao-IPI = "":U THEN DO:
                
                IF  AVAIL item THEN
                    FIND FIRST item-mat
                         WHERE item-mat.it-codigo = item.it-codigo NO-LOCK NO-ERROR.

                IF AVAIL item-mat THEN DO:
                    
                    IF  c-suspensao-II  = "":U THEN DO:

                        IF  item-mat.log-suspens-impto-import THEN
                            ASSIGN c-suspensao-II = "1":U.
                        ELSE
                            ASSIGN c-suspensao-II = "":U.
                    END.

                    IF c-suspensao-IPI = "":U THEN DO:

                        IF  item-mat.log-suspens-ipi-import   THEN
                            ASSIGN c-suspensao-IPI = "1":U.
                        ELSE
                            ASSIGN c-suspensao-IPI = "":U.
                    END.
                END.
            END.
            

            /******************************************************
            * Atribuicao aos novos campos da tela (IM0100B)       *
            ******************************************************/
            IF  c-suspensao-II  = "1":U THEN
                ASSIGN tt-ordens-desemb.l-suspensao-II  = YES.
            ELSE
                ASSIGN tt-ordens-desemb.l-suspensao-II  = NO.

            IF  c-suspensao-IPI = "1":U THEN
                ASSIGN tt-ordens-desemb.l-suspensao-IPI = YES.
            ELSE
                ASSIGN tt-ordens-desemb.l-suspensao-IPI = NO.
            
            /*
            ** Item
            */
            ASSIGN tt-ordens-desemb.c-it-codigo     = item.it-codigo
                   tt-ordens-desemb.c-desc-item     = item.desc-item
                   tt-ordens-desemb.c-un            = item.un
                   tt-ordens-desemb.c-un-item       = item.un
                   tt-ordens-desemb.c-class-fiscal  = IF c-class-fiscal-esp <> "" THEN c-class-fiscal-esp ELSE item.class-fiscal.
    
            FOR FIRST item-fornec FIELDS (unid-med-for cod-embal ) 
                WHERE item-fornec.it-codigo    = tt-ordens-desemb.c-it-codigo
                  AND item-fornec.cod-emitente = ordem-compra.cod-emitente NO-LOCK:

                ASSIGN tt-ordens-desemb.c-un-fornec = item-fornec.unid-med-for.
            END.
           
            IF item.tipo-contr = 4 THEN DO: /* DÇbito Direto */
                
                IF item.it-codigo = "" THEN
                    ASSIGN tt-ordens-desemb.c-desc-item = ordem-compra.narrativa.
                
                /* Itens debito direto nao possuem unidade de medida do fornecedor */
                ASSIGN tt-ordens-desemb.c-un-fornec     = item.un
                       tt-ordens-desemb.cod-nbs         = TRIM(SUBSTRING(item.char-1,342,20)).

                IF AVAIL cotacao-item THEN DO:
                    {ccp/cc9019.i50}
                    {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                    {ccp/cc9019.i51 "yes"}
                   
                    IF c-class-fiscal-i50 <> "" THEN
                       ASSIGN tt-ordens-desemb.c-class-fiscal = IF c-class-fiscal-esp <> "" THEN c-class-fiscal-esp ELSE c-class-fiscal-i50.
                    
                    IF SUBSTRING(cotacao-item.char-1,101,20) <> "" THEN
                        ASSIGN tt-ordens-desemb.cod-nbs = TRIM(SUBSTRING(cotacao-item.char-1,101,20)).
                END.
            END.

            ASSIGN tt-ordens-desemb.c-nat-fiscal = p-nat-operacao.
            
    
            /* A partir da versao 2.05, foi dividido as informaá‰es de Peso e Cubagem em uma tela(im0100c) e Imposto
            em outra (im0100d) - Peso e Cubagem - calcula - Peso Bruto, Peso Liquido , Total Cubagem Impostos - II, ICMS, IPI entre outros...
            */
            
            
            /*
                ** Tributacao II
                */

          
                
            ASSIGN i-trib-ii-item = INTEGER(TRIM(SUBSTRING(ITEM.char-2,20,2))).
            ASSIGN i-trib-ii-nat  = INTEGER(SUBSTRING(natur-oper.char-1,10,2)).

           
            RUN imp/im9041.p (INPUT  i-trib-ii-item,
                              INPUT  i-trib-ii-nat,
                              OUTPUT i-trib-ii).
           
        

            ASSIGN tt-ordens-desemb.i-trib-ii  = i-trib-ii
                   tt-ordens-desemb.c-trib-ii  = SUBSTRING({ininc/i10in172.i 04 i-trib-ii},1,1).

            
            /*
            ** Aliquota II
            */ 
           IF tt-ordens-desemb.aliquota-ii = 0 THEN
                RUN imp/im9042.p (INPUT tt-ordens-desemb.numero-ordem, OUTPUT de-aliq-ii).
            ELSE
                ASSIGN de-aliq-ii = tt-ordens-desemb.aliquota-ii.
            
            
            ASSIGN tt-ordens-desemb.de-aliq-ii = de-aliq-ii.
                   
            /*
            ** Tributacao IPI
            */
           
                
                RUN cdp/cd4303.p (INPUT  item.cd-trib-ipi,
                                  INPUT  natur-oper.cd-trib-ipi,
                                  OUTPUT i-trib-ipi).
                
            
    
            ASSIGN tt-ordens-desemb.i-trib-ipi = i-trib-ipi
                   tt-ordens-desemb.c-trib-ipi = SUBSTRING({ininc/i10in172.i 04 i-trib-ipi},1,1).

           
            /*
            ** Aliquota IPI 
            */ 
           
           IF tt-ordens-desemb.aliquota-ipi = 0 THEN DO:

                    RUN imp/im9043.p (INPUT  p-usuario,
                                      INPUT  tt-ordens-desemb.numero-ordem,
                                      INPUT  tt-ordens-desemb.c-it-codigo,
                                      OUTPUT de-aliq-ipi).
                END.
                ELSE
                    ASSIGN de-aliq-ipi = tt-ordens-desemb.aliquota-ipi.
            
    
            ASSIGN tt-ordens-desemb.de-aliq-ipi = de-aliq-ipi.

           /*
            ** Tributacao ICMS
            */
            IF p-icms-diferido THEN
                ASSIGN i-trib-icms = 3.
            ELSE
               RUN cdp/cd4302.p (INPUT ITEM.cd-trib-icm,
                                      INPUT natur-oper.cd-trib-icm,
                                      OUTPUT i-trib-icms).
                
            
            ASSIGN tt-ordens-desemb.i-trib-icms = i-trib-icms
                   tt-ordens-desemb.c-trib-icms = SUBSTRING({ininc/i07in122.i 04 i-trib-icms},1,1).
    
            /*
            ** Aliquota ICMS
            */
            IF p-icms-diferido THEN
                ASSIGN de-aliq-icms = 0.
            ELSE
                
                    IF tt-ordens-desemb.aliquota-icms = 0 THEN DO:
                        
                        run cdp/cd4301.p ( (IF AVAIL emitente THEN emitente.contrib-icms ELSE YES),
                                           (IF AVAIL emitente THEN emitente.natureza     ELSE 2 /*"J"*/),
                                            estabelec.estado,
                                            estabelec.pais,
                                            estabelec.estado,
                                            tt-ordens-desemb.c-it-codigo,
                                            natur-oper.aliquota-icm,
                                            OUTPUT de-aliq-icms).
                    END.
                    ELSE
                        ASSIGN de-aliq-icms = tt-ordens-desemb.aliquota-icms.
               
                                     
            ASSIGN tt-ordens-desemb.de-aliq-icms = de-aliq-icms.
            
            /* Aplica Desconto ICMS Desonerado */
            
               ASSIGN tt-ordens-desemb.l-aplica-desc-icms  = NO. 
                   
        
            /* Tributacao PIS */

            
                
            IF tt-ordens-desemb.dec-1 = 0 THEN DO:
                
                RUN pi-tributa-aliquota-pis-importacao IN h-im9048 (BUFFER natur-oper,
                                                                    BUFFER item,
                                                                    INPUT  tt-ordens-embarque.cod-estabel,
                                                                    INPUT  TODAY,
                                                                    INPUT  NO,
                                                                    INPUT  tt-ordens-embarque.embarque,
                                                                    INPUT  tt-ordens-embarque.numero-ordem,
                                                                    INPUT  tt-ordens-embarque.parcela,
                                                                    OUTPUT i-trib-pis,
                                                                    OUTPUT de-aliq-pis,
                                                                    OUTPUT de-valor-un-pis,
                                                                    OUTPUT de-valor-vol-pis, 
                                                                    OUTPUT de-red-pis). /* Valor Reducao PIS */
            END.
            ELSE
                ASSIGN de-aliq-pis = tt-ordens-desemb.dec-1
                       i-trib-pis  = i-trib-pis-i1. 
          

            IF i-trib-pis <> 0 THEN 
                ASSIGN tt-ordens-desemb.i-trib-pis = i-trib-pis
                       tt-ordens-desemb.c-trib-pis = SUBSTRING({ininc/i07in122.i 04 i-trib-pis},1,1).
            
            /* Aliquota PIS */
            
            ASSIGN tt-ordens-desemb.de-aliq-pis = de-aliq-pis.

            /* Tributacao COFINS */
            
                
            IF tt-ordens-desemb.dec-2 = 0 THEN DO:

                RUN pi-tributa-aliquota-cofins-importacao IN h-im9048 (BUFFER natur-oper,
                                                                       BUFFER ITEM,
                                                                       INPUT tt-ordens-embarque.cod-estabel,
                                                                       INPUT TODAY,
                                                                       INPUT NO,
                                                                       INPUT tt-ordens-embarque.embarque,    
                                                                       INPUT tt-ordens-embarque.numero-ordem,
                                                                       INPUT tt-ordens-embarque.parcela,     
                                                                       OUTPUT i-trib-cofins,
                                                                       OUTPUT de-aliq-cofins,
                                                                       OUTPUT de-valor-un-cofins,
                                                                       OUTPUT de-valor-vol-cofins, 
                                                                       OUTPUT de-red-cofins). /* Valor Reducao COFINS */
            END.
            ELSE
                ASSIGN de-aliq-cofins = tt-ordens-desemb.dec-2
                       i-trib-cofins  = i-trib-cofins-i1. 
            

            IF i-trib-cofins <> 0 THEN
                ASSIGN tt-ordens-desemb.i-trib-cofins = i-trib-cofins
                       tt-ordens-desemb.c-trib-cofins = SUBSTRING({ininc/i07in122.i 04 i-trib-cofins},1,1).

            /* Aliquota COFINS */
            
              
            ASSIGN tt-ordens-desemb.de-aliq-cofins = de-aliq-cofins.
            
            /* Reforma Tribut†ria */
            IF l-nt2024002 THEN
                RUN pi-busca-cClassTrib-CST-Aliq (INPUT YES,
                                                  INPUT YES,
                                                  INPUT YES,
                                                  INPUT YES).
        
        END.

        ASSIGN tt-ordens-desemb.cdn-adicao       = tt-ordens-embarque.num-adic
               tt-ordens-desemb.de-taxa-siscomex = tt-ordens-embarque.val-tax-siscomex
               tt-ordens-desemb.seq-item         = INT(SUBSTR(tt-ordens-embarque.char-1, 80, 4)).
       
    END.

    /* Reforma Tribut†ria */
    IF l-nt2024002 THEN DO:
        RUN pi-busca-tributacaoRT IN h-imapi017 (INPUT YES, 
                                                 INPUT YES, 
                                                 INPUT YES,
                                                 INPUT YES,
                                                 INPUT YES,
                                                 INPUT-OUTPUT TABLE tt-ordens-desemb).
    END.

    IF VALID-HANDLE(h-im9048) THEN DO:
        DELETE PROCEDURE h-im9048.
        ASSIGN h-im9048 = ?.
    END.

    IF VALID-HANDLE(h-boin356) THEN DO:
      DELETE PROCEDURE h-boin356.
      ASSIGN h-boin356 = ?.
    END.

    IF VALID-HANDLE(h-bodi425) THEN DO:
      DELETE PROCEDURE h-bodi425.
      ASSIGN h-bodi425 = ?.
    END.

    IF VALID-HANDLE(h-reapi433) THEN DO:
        DELETE PROCEDURE h-reapi433.
        ASSIGN h-reapi433 = ?.
    END.
    
    IF VALID-HANDLE(h-imapi017) THEN DO:
        DELETE PROCEDURE h-imapi017.
        ASSIGN h-imapi017 = ?.
    END.

    IF VALID-HANDLE(h-cdapi1005) THEN DO:
        DELETE PROCEDURE h-cdapi1005.
        ASSIGN h-cdapi1005 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE updateOrdensEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Grava os valore informados na tt-ordens-desemb na tabela ordens-embarque
  Parameters: INPUT TABLE - tt-ordens-embarque - TT base
              INPUT - p-peso (integer) - 1 = peso unitario
              INPUT - p-cubagem (integer) - 1 - Unit†rio 2 - Total          
              INPUT - p-usuario (character) - Definir im0100c(no) ou im0100d (yes)       
              OUTPUT TABLE - tt-bo-erro - TT com erros ocorridos durante o processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-ordens-desemb.
    DEFINE INPUT PARAMETER p-peso    AS   INTEGER          NO-UNDO.
    DEFINE INPUT PARAMETER p-cubagem AS   INTEGER          NO-UNDO. 
    DEFINE INPUT PARAMETER p-usuario LIKE param-re.usuario NO-UNDO. 
    DEF OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    {cxbo/bocx225e.i1} /* variaveis atributos libres */

    FOR EACH tt-ordens-desemb NO-LOCK:
        
        IF  p-peso = 1 THEN
            ASSIGN tt-ordens-desemb.de-peso-bruto     = tt-ordens-desemb.de-peso-bruto   * tt-ordens-desemb.quantidade
                   tt-ordens-desemb.de-peso-liquido   = tt-ordens-desemb.de-peso-liquido * tt-ordens-desemb.quantidade.
        
        IF  p-cubagem = 1 /* Unit†rio */ THEN
            ASSIGN tt-ordens-desemb.val-cub-tot = tt-ordens-desemb.val-cub-unit * tt-ordens-desemb.quantidade.
        
        ASSIGN tt-ordens-desemb.de-peso-embal = tt-ordens-desemb.peso-bruto - tt-ordens-desemb.peso-liquido.
        
        IF tt-ordens-desemb.c-trib-ii = SUBSTRING("Tributado":U,1,1) THEN
            ASSIGN tt-ordens-desemb.i-trib-ii = 1.
        
        IF tt-ordens-desemb.c-trib-ii = SUBSTRING("Isento":U,1,1) THEN
            ASSIGN tt-ordens-desemb.i-trib-ii = 2.

        CASE tt-ordens-desemb.c-trib-ipi:
            WHEN SUBSTRING("Tributado":U,1,1) THEN
                ASSIGN tt-ordens-desemb.i-trib-ipi = 1.
            WHEN SUBSTRING("Isento":U,1,1) THEN
                ASSIGN tt-ordens-desemb.i-trib-ipi = 2.
            WHEN SUBSTRING("Outros":U,1,1) THEN
                ASSIGN tt-ordens-desemb.i-trib-ipi = 3.
            WHEN SUBSTRING("Reduzido":U,1,1) THEN
                ASSIGN tt-ordens-desemb.i-trib-ipi = 4.
        END CASE.

        CASE tt-ordens-desemb.c-trib-icms:
            WHEN SUBSTRING("Tributado":U,1,1) THEN
                ASSIGN tt-ordens-desemb.i-trib-icms = 1.
            WHEN SUBSTRING("Isento":U,1,1) THEN
                ASSIGN tt-ordens-desemb.i-trib-icms = 2.
            WHEN SUBSTRING("Outros":U,1,1) THEN
                ASSIGN tt-ordens-desemb.i-trib-icms = 3.
            WHEN SUBSTRING("Reduzido":U,1,1) THEN
                ASSIGN tt-ordens-desemb.i-trib-icms = 4.
        END CASE.

        CASE tt-ordens-desemb.c-trib-pis:
            WHEN SUBSTRING("Tributado":U,1,1) THEN
                ASSIGN tt-ordens-desemb.i-trib-pis = 1.
            WHEN SUBSTRING("Isento":U,1,1) THEN
                ASSIGN tt-ordens-desemb.i-trib-pis = 2.
            WHEN SUBSTRING("Outros":U,1,1) THEN
                ASSIGN tt-ordens-desemb.i-trib-pis = 3.
        END CASE.

        CASE tt-ordens-desemb.c-trib-cofins:
            WHEN SUBSTRING("Tributado":U,1,1) THEN
                ASSIGN tt-ordens-desemb.i-trib-cofins = 1.
            WHEN SUBSTRING("Isento":U,1,1) THEN
                ASSIGN tt-ordens-desemb.i-trib-cofins = 2.
            WHEN SUBSTRING("Outros":U,1,1) THEN
                ASSIGN tt-ordens-desemb.i-trib-cofins = 3.
        END CASE.
        
        FIND FIRST ordens-embarque
             WHERE ordens-embarque.cod-estabel  = tt-ordens-desemb.cod-estabel
               AND ordens-embarque.embarque     = tt-ordens-desemb.embarque
               AND ordens-embarque.numero-ordem = tt-ordens-desemb.numero-ordem
               AND ordens-embarque.parcela      = tt-ordens-desemb.parcela       EXCLUSIVE-LOCK NO-ERROR.

        ASSIGN de-peso-bruto-i1   = tt-ordens-desemb.de-peso-bruto
               de-peso-liquido-i1 = tt-ordens-desemb.de-peso-liquido
               i-trib-ii-i1       = tt-ordens-desemb.i-trib-ii
               de-aliq-ii-i1      = tt-ordens-desemb.de-aliq-ii
               i-trib-ipi-i1      = tt-ordens-desemb.i-trib-ipi
               de-aliq-ipi-i1     = tt-ordens-desemb.de-aliq-ipi
               i-trib-icms-i1     = tt-ordens-desemb.i-trib-icms
               de-aliq-icms-i1    = tt-ordens-desemb.de-aliq-icms
               i-trib-pis-i1      = tt-ordens-desemb.i-trib-pis
               de-aliq-pis-i1     = tt-ordens-desemb.de-aliq-pis
               i-trib-cofins-i1   = tt-ordens-desemb.i-trib-cofins
               de-aliq-cofins-i1  = tt-ordens-desemb.de-aliq-cofins
               de-cub-unit-i1     = tt-ordens-desemb.val-cub-unit
               de-cub-tot-i1      = tt-ordens-desemb.val-cub-tot
               de-peso-embal-i1   = tt-ordens-desemb.de-peso-embal. 
        
        IF  tt-ordens-desemb.l-suspensao-II  THEN
            ASSIGN c-suspensao-II = "1":U.
        ELSE
            ASSIGN c-suspensao-II = "":U.

        IF  tt-ordens-desemb.l-suspensao-IPI THEN
            ASSIGN c-suspensao-IPI = "1":U.
        ELSE
            ASSIGN c-suspensao-IPI = "":U.
             
        ASSIGN l-ja-gravado = YES.

        IF  p-usuario = "" THEN DO:  /*PESO E CUBAGEM*/
            {cxbo/bocx225e.i3 YES ordens-embarque} /* grava valores */
        END.
        ELSE DO:                  /*IMPOSTOS*/
            {cxbo/bocx225e.i4 YES ordens-embarque} /* grava valores */
        END.

        ASSIGN ordens-embarque.num-adic              = tt-ordens-desemb.cdn-adicao
               ordens-embarque.val-tax-siscomex      = tt-ordens-desemb.de-taxa-siscomex
               OVERLAY(ordens-embarque.Char-1,80,04) = STRING(tt-ordens-desemb.seq-item)
               ordens-embarque.log-aplica-desc-icms  = tt-ordens-desemb.l-aplica-desc-icms
               ordens-embarque.cod-natur-of  	     = tt-ordens-desemb.c-nat-fiscal.
        
        /* Reforma Tribut†ria */
        IF  p-usuario <> "" THEN DO: /*IMPOSTOS*/
            IF l-nt2024002 THEN DO:
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSUF",  INPUT "C-CLASS-TRIB", INPUT tt-ordens-desemb.cClassTrib-IBSUF).
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSUF",  INPUT "CST",          INPUT tt-ordens-desemb.cCST-IBSUF).
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSUF",  INPUT "COD-TRIB",     INPUT tt-ordens-desemb.c-trib-IBSUF).
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSUF",  INPUT "ALIQUOTA",     INPUT tt-ordens-desemb.de-aliq-IBSUF).
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSUF",  INPUT "ALIQ-RED",     INPUT tt-ordens-desemb.de-aliq-red-IBSUF).
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSMUN", INPUT "C-CLASS-TRIB", INPUT tt-ordens-desemb.cClassTrib-IBSMun).
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSMUN", INPUT "CST",          INPUT tt-ordens-desemb.cCST-IBSMun).
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSMUN", INPUT "COD-TRIB",     INPUT tt-ordens-desemb.c-trib-IBSMun).
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSMUN", INPUT "ALIQUOTA",     INPUT tt-ordens-desemb.de-aliq-IBSMun).
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSMUN", INPUT "ALIQ-RED",     INPUT tt-ordens-desemb.de-aliq-red-IBSMun).
                RUN pi-grava-ordens-embarque-trib (INPUT "CBS",    INPUT "C-CLASS-TRIB", INPUT tt-ordens-desemb.cClassTrib-CBS).
                RUN pi-grava-ordens-embarque-trib (INPUT "CBS",    INPUT "CST",          INPUT tt-ordens-desemb.cCST-CBS).
                RUN pi-grava-ordens-embarque-trib (INPUT "CBS",    INPUT "COD-TRIB",     INPUT tt-ordens-desemb.c-trib-CBS).
                RUN pi-grava-ordens-embarque-trib (INPUT "CBS",    INPUT "ALIQUOTA",     INPUT tt-ordens-desemb.de-aliq-CBS).
                RUN pi-grava-ordens-embarque-trib (INPUT "CBS",    INPUT "ALIQ-RED",     INPUT tt-ordens-desemb.de-aliq-red-CBS).
                
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSUF",  INPUT "C-CLASS-TRIB-REG", INPUT tt-ordens-desemb.cClassTribReg-IBSUF).
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSUF",  INPUT "CST-REG",          INPUT tt-ordens-desemb.cCSTReg-IBSUF).
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSUF",  INPUT "ALIQ-EFETIVA-REG", INPUT tt-ordens-desemb.de-aliq-Reg-IBSUF).
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSMUN", INPUT "C-CLASS-TRIB-REG", INPUT tt-ordens-desemb.cClassTribReg-IBSMun).
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSMUN", INPUT "CST-REG",          INPUT tt-ordens-desemb.cCSTReg-IBSMun).
                RUN pi-grava-ordens-embarque-trib (INPUT "IBSMUN", INPUT "ALIQ-EFETIVA-REG", INPUT tt-ordens-desemb.de-aliq-Reg-IBSMun).
                RUN pi-grava-ordens-embarque-trib (INPUT "CBS",    INPUT "C-CLASS-TRIB-REG", INPUT tt-ordens-desemb.cClassTribReg-CBS).
                RUN pi-grava-ordens-embarque-trib (INPUT "CBS",    INPUT "CST-REG",          INPUT tt-ordens-desemb.cCSTReg-CBS).
                RUN pi-grava-ordens-embarque-trib (INPUT "CBS",    INPUT "ALIQ-EFETIVA-REG", INPUT tt-ordens-desemb.de-aliq-Reg-CBS).
                
                IF plIsGovEntity THEN DO:
                    RUN pi-grava-ordens-embarque-trib (INPUT "IBSUF", INPUT "PERC-RED-GOV",INPUT STRING(tt-ordens-desemb.perc-red-gov-ibsuf)).
                    RUN pi-grava-ordens-embarque-trib (INPUT "IBSMUN",INPUT "PERC-RED-GOV",INPUT STRING(tt-ordens-desemb.perc-red-gov-ibsmun)).
                    RUN pi-grava-ordens-embarque-trib (INPUT "CBS",   INPUT "PERC-RED-GOV",INPUT STRING(tt-ordens-desemb.perc-red-gov-cbs)).
                END.
                
                FOR FIRST ordem-compra WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:
                    IF CAN-FIND(FIRST ITEM WHERE ITEM.it-codigo = ordem-compra.it-codigo
                                           AND SUBSTRING(item.char-1,289,1) = "S" /* Incide IS */ ) THEN DO:
                        RUN pi-grava-ordens-embarque-trib (INPUT "IS", INPUT "C-CLASS-TRIB",  INPUT tt-ordens-desemb.cClassTrib-IS).
                        RUN pi-grava-ordens-embarque-trib (INPUT "IS", INPUT "CST",           INPUT tt-ordens-desemb.cCST-IS).
                        RUN pi-grava-ordens-embarque-trib (INPUT "IS", INPUT "COD-TRIB",      INPUT tt-ordens-desemb.c-trib-IS).
                        RUN pi-grava-ordens-embarque-trib (INPUT "IS", INPUT "ALIQUOTA",      INPUT tt-ordens-desemb.de-aliq-IS).
                        RUN pi-grava-ordens-embarque-trib (INPUT "IS", INPUT "ALIQ-ESPEC-UN", INPUT tt-ordens-desemb.de-aliq-espec-IS).
                        RUN pi-grava-ordens-embarque-trib (INPUT "IS", INPUT "QTDE-TRIBUT",   INPUT tt-ordens-desemb.de-qtde-trib-IS).
                        RUN pi-grava-ordens-embarque-trib (INPUT "IS", INPUT "UN-TRIBUT",     INPUT tt-ordens-desemb.c-un-trib-IS).
                    END.
                END.
            END.
        END.
 
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE countNumOrdensEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Retorna o n£mero de ordens de determinado embarque
  Parameters: INPUT  - pc-cod-estabel (character) - codigo do estabelecimento
              INPUT - pc-embarque (character) - codigo do embarque
              INPUT - pi-num-ordens (integer) - numero de ordens do embarque          
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabel LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER pc-embarque    LIKE embarque-imp.embarque NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-num-ordens  AS   INTEGER               NO-UNDO.
   
    FOR EACH ordens-embarque
        WHERE ordens-embarque.cod-estabel = pc-cod-estabel
          AND ordens-embarque.embarque    = pc-embarque NO-LOCK:
        ASSIGN pi-num-ordens = pi-num-ordens + 1.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE cria-tt-ordens-desemb-param:
/*------------------------------------------------------------------------------
  Purpose: Procedure respons†vel por carregar o browse 
           com os registros selecionados no programa de parÉmetros (IM0100B1.W)
  Parameters: INPUT TABLE - tt-ordens-desemb-aux-2 
              INPUT-OUTPUT TABLE - tt-ordens-desemb
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-ordens-desemb-aux-2.
    DEFINE INPUT-OUTPUT PARAMETER TABLE  FOR tt-ordens-desemb.
    
    FOR EACH tt-ordens-desemb-aux-2
       WHERE tt-ordens-desemb-aux-2.numero-ordem   >= i-numero-ordem-ini 
         AND tt-ordens-desemb-aux-2.numero-ordem   <= i-numero-ordem-fim 
         AND tt-ordens-desemb-aux-2.c-it-codigo    >= c-item-ini
         AND tt-ordens-desemb-aux-2.c-it-codigo    <= c-item-fim
         AND tt-ordens-desemb-aux-2.c-class-fiscal >= c-class-fiscal-ini
         AND tt-ordens-desemb-aux-2.c-class-fiscal <= c-class-fiscal-fim NO-LOCK:

        /*Carrega na temp-table tt-ordens-desemb-param os registros informados na faixa*/
        CREATE tt-ordens-desemb-param.
        BUFFER-COPY tt-ordens-desemb-aux-2 TO tt-ordens-desemb-param.
    END.

    /*Elimina os registros j† existentes no browser*/
    EMPTY TEMP-TABLE tt-ordens-desemb.

    /*Cria os registros na temp-table reponsavel por carregar o browser, 
      mas somente com os registros selecionados na tela de ParÉmetros   */
    FOR EACH tt-ordens-desemb-param:
        CREATE tt-ordens-desemb.
        BUFFER-COPY tt-ordens-desemb-param TO tt-ordens-desemb.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-zerar-taxa-siscomex:
/*------------------------------------------------------------------------------
  Purpose: Zerar Taxa Siscomex
  Parameters: INPUT - pc-cod-estabel(character) - codigo do estabelecimento 
              INPUT - pc-embarque(character) - codigo do embarque 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-embarque    LIKE embarque-imp.embarque NO-UNDO.

    FOR EACH ordens-embarque 
        WHERE ordens-embarque.cod-estabel = pc-cod-estabel
          AND ordens-embarque.embarque    = pc-embarque EXCLUSIVE-LOCK:

        ASSIGN ordens-embarque.val-tax-siscomex = 0.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validaNatOperItem :
/*------------------------------------------------------------------------------
  Purpose:     Valida a natureza fiscal (nat-of) informada para o item em relaá∆o 
               a natureza de operaá∆o do documento (nat-operacao).
  
  Parameters:  nat.operacao do documento -----------> p-c-nat-operacao;
               nat.fiscal do item a ser inclu°do ---> p-c-nat-of;
               C¢digo do item a ser inclu°do -------> p-c-it-codigo;
               
  Notes:       
------------------------------------------------------------------------------*/


    /* Recebe como parÉmetro a chave do documento e a natureza fiscal do item a ser inclu°do. */
    DEFINE INPUT  PARAMETER p-c-nat-operacao   LIKE item-doc-est.nat-operacao NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-nat-of         LIKE item-doc-est.nat-of       NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-it-codigo      LIKE item-doc-est.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER p-i-cod-erro       AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.
    

    DEFINE VARIABLE l-gera-ficha-auto         AS LOGICAL                      NO-UNDO.
    DEFINE VARIABLE i-cod-erro                AS INTEGER                      NO-UNDO.
    
    DEFINE BUFFER b-natur-oper-doc  FOR natur-oper. /* Buffer para natureza de operaá∆o do documento, cabeáalho nota (nat-operacao). */
    DEFINE BUFFER b-natur-oper-item FOR natur-oper. /* Buffer para natureza fiscal do item (nat-of). */

    FOR EACH tt-bo-erro.
        DELETE tt-bo-erro.
    END.

    IF p-i-cod-erro = 1 THEN DO:
        i-cod-erro = 56866.
    END.
    ELSE DO:
        i-cod-erro = 56867.
    END.


    /* Busca a natureza de operaá∆o informada para o documento... */
    FIND b-natur-oper-doc WHERE b-natur-oper-doc.nat-operacao = p-c-nat-operacao NO-LOCK NO-ERROR.
    
    /* Valida se a natureza fiscal informada para Item Ç existente... */
    FIND b-natur-oper-item WHERE b-natur-oper-item.nat-operacao = p-c-nat-of NO-LOCK NO-ERROR.
    IF  AVAILABLE b-natur-oper-item and
        AVAIL b-natur-oper-doc THEN DO:
        
        
        IF  b-natur-oper-item.tipo-compra <> b-natur-oper-doc.tipo-compra THEN DO:
            /* O tipo de compra da natureza fiscal deve ser igual ao tipo de compra da natureza do documento */
                    {utp/ut-liter.i O_'tipo_compra'_da_natureza_fiscal_informada_deve_ser_igual_ao_'tipo_compra'_da_natureza_de_operaá∆o_do_embarque *}
                   
                    assign i-seq-erro = i-seq-erro + 1.       
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = trim(return-value).
                    run utp/ut-msgs.p (input "msg":U,
                                       input i-cod-erro,
                                       input "").
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = i-cod-erro
                           tt-bo-erro.mensagem     =  RETURN-VALUE.
                    RETURN "NOK":U.
        END.

        IF  b-natur-oper-item.transf <> b-natur-oper-doc.transf THEN DO:
            /* 'Operaá∆o Tranferància' divergentes */
                    {utp/ut-liter.i A_natureza_fiscal_informada_n∆o_possui_o_indicador_'Operaá∆o_Tranferància'_como_a_natureza_do_embarque *}
                    assign i-seq-erro = i-seq-erro + 1.       
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = trim(return-value).
                    run utp/ut-msgs.p (input "msg":U,
                                       INPUT i-cod-erro,
                                       input "").
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = i-cod-erro
                           tt-bo-erro.mensagem     =  RETURN-VALUE.
                    RETURN "NOK":U.
        END.

        IF (b-natur-oper-item.tp-oper-terc <> b-natur-oper-doc.tp-oper-terc) OR (b-natur-oper-item.terceiros <> b-natur-oper-doc.terceiros) THEN DO:
            /* 'Tipo Oper Terceiros' divergentes */
                    {utp/ut-liter.i A_natureza_fiscal_informada_para_n∆o_possui_o_mesmo_'tipo_de_operaá∆o_com_terceiros'_da_natureza_do_embarque *}
                    assign i-seq-erro = i-seq-erro + 1.       
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = trim(return-value).
                    run utp/ut-msgs.p (input "msg":U,
                                       input i-cod-erro,
                                       input "").
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = i-cod-erro
                           tt-bo-erro.mensagem     =  RETURN-VALUE.
                    RETURN "NOK":U.
        END.

        IF  SUBSTRING(b-natur-oper-item.char-1,1,5) <> SUBSTRING(b-natur-oper-doc.char-1,1,5) /* tipo entrega */
            OR b-natur-oper-item.ind-entfut <> b-natur-oper-doc.ind-entfut                    /* nota faturamento */
            OR b-natur-oper-item.ind-est-qtd <> b-natur-oper-doc.ind-est-qtd THEN DO:         /* nota remessa */
            /* 'Operaá‰es de entrega futura/Faturamento antecipado' divergentes */
                    {utp/ut-liter.i A_natureza_fiscal_informada_n∆o_possui_a_mesma_'Operaá∆o_de_entrega_futura/Faturamento_antecipado'_da_natureza_do_embarque *}

                    assign i-seq-erro = i-seq-erro + 1.       
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = trim(return-value).
                    run utp/ut-msgs.p (input "msg":U,
                                       INPUT i-cod-erro,
                                       input "").
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = i-cod-erro
                           tt-bo-erro.mensagem     =  RETURN-VALUE.
                    RETURN "NOK":U.
        END.

        IF  b-natur-oper-item.int-1 <> b-natur-oper-doc.int-1 THEN DO:
            /* 'Nota Pr¢pria' divergentes */
                    {utp/ut-liter.i A_natureza_fiscal_informada_n∆o_possui_o_indicador_'Nota_Pr¢pria'_como_a_natureza_do_embarque *}

                    assign i-seq-erro = i-seq-erro + 1.       
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = trim(return-value).
                    run utp/ut-msgs.p (input "msg":U,
                                       input i-cod-erro,
                                      input "").
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = i-cod-erro
                           tt-bo-erro.mensagem     =  RETURN-VALUE.
                    RETURN "NOK":U.
        END.

        IF  b-natur-oper-item.log-oper-triang <> b-natur-oper-doc.log-oper-triang THEN DO:
            /* 'Operaá∆o Tringular' divergentes */
            {utp/ut-liter.i A_natureza_fiscal_informada_n∆o_possui_o_indicador_'Operaá∆o_Tringular'_como_a_natureza_do_embarque *}
             assign i-seq-erro = i-seq-erro + 1.       
             create tt-bo-erro.
             assign tt-bo-erro.parametros = trim(return-value).
             run utp/ut-msgs.p (input "msg":U,
                               input i-cod-erro,
                              input "").
             assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = i-cod-erro
                   tt-bo-erro.mensagem     =  RETURN-VALUE.
             RETURN "NOK":U.
        END.
        
        IF  b-natur-oper-item.imp-nota <> b-natur-oper-doc.imp-nota THEN DO:
            /* Gerar Nota Faturamento */
            {utp/ut-liter.i A_natureza_fiscal_informada_n∆o_possui_o_indicador_'Gerar_Nota_Faturamento'_como_a_natureza_do_embarque *}
            assign i-seq-erro = i-seq-erro + 1.       
            create tt-bo-erro.
            assign tt-bo-erro.parametros = trim(return-value).
            run utp/ut-msgs.p (input "msg":U,
                               input i-cod-erro,
                               input  "").
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = i-cod-erro
                   tt-bo-erro.mensagem     =  RETURN-VALUE.
            RETURN "NOK":U.
        END.

        IF  b-natur-oper-item.nota-rateio <> b-natur-oper-doc.nota-rateio THEN DO:
            /* Nota Rateio */
            {utp/ut-liter.i A_natureza_fiscal_informada_n∆o_possui_o_indicador_'Nota_Rateio'_como_a_natureza_do_embarque *}
            assign i-seq-erro = i-seq-erro + 1.       
            create tt-bo-erro.
            assign tt-bo-erro.parametros = trim(return-value).
            run utp/ut-msgs.p (input "msg":U,
                               input i-cod-erro,
                               input "").
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = i-cod-erro
                   tt-bo-erro.mensagem     =  RETURN-VALUE.
            RETURN "NOK":U.
        END.    

        IF  b-natur-oper-item.log-2 <> b-natur-oper-doc.log-2 THEN DO:
            /* Nota ComÇrcio */
            {utp/ut-liter.i A_natureza_fiscal_informada_n∆o_possui_o_indicador_'Nota_ComÇrcio'_como_a_natureza_do_embarque *}
            assign i-seq-erro = i-seq-erro + 1.       
            create tt-bo-erro.
            assign tt-bo-erro.parametros = trim(return-value).
            run utp/ut-msgs.p (input "msg":U,
                               input i-cod-erro,
                              input  "").
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = i-cod-erro
                   tt-bo-erro.mensagem     =  RETURN-VALUE.
            RETURN "NOK":U.
        END.

        IF  b-natur-oper-item.int-2 <> b-natur-oper-doc.int-2 THEN DO:
            /* Venda Ambulante */
            {utp/ut-liter.i A_natureza_fiscal_informada_n∆o_possui_o_indicador_'Venda_Ambulante'_como_a_natureza_do_embarque *}
            assign i-seq-erro = i-seq-erro + 1.       
            create tt-bo-erro.
            assign tt-bo-erro.parametros = trim(return-value).
            run utp/ut-msgs.p (input "msg":U,
                               input i-cod-erro,
                               input  "").
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = i-cod-erro
                   tt-bo-erro.mensagem     =  RETURN-VALUE.
            RETURN "NOK":U.
        END.

        IF  SUBSTR(b-natur-oper-item.char-2,88,5) <> SUBSTR(b-natur-oper-doc.char-2,88,5) THEN DO:
            /* Gerar Devol. Somente de Valor */
            {utp/ut-liter.i A_natureza_fiscal_informadan∆o_possui_o_indicador_'Gerar_Devol._Somente_de_Valor'_como_a_natureza_do_embarque *}
            assign i-seq-erro = i-seq-erro + 1.       
            create tt-bo-erro.
            assign tt-bo-erro.parametros = trim(return-value).
            run utp/ut-msgs.p (input "msg":U,
                               input i-cod-erro,
                               input  "").
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = i-cod-erro
                   tt-bo-erro.mensagem     =  RETURN-VALUE.
            RETURN "NOK":U.
        END.
        
        IF  b-natur-oper-item.log-natur-operac-draw <> b-natur-oper-doc.log-natur-operac-draw THEN DO:
            /* Natureza Drawback */
            {utp/ut-liter.i A_natureza_fiscal_informadan∆o_possui_o_indicador_'Natureza_Drawback'_como_a_natureza_do_embarque *}
            assign i-seq-erro = i-seq-erro + 1.       
            create tt-bo-erro.
            assign tt-bo-erro.parametros = trim(return-value).
            run utp/ut-msgs.p (input "msg":U,
                               input i-cod-erro,
                               input "").
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = i-cod-erro
                   tt-bo-erro.mensagem     =  RETURN-VALUE.
            RETURN "NOK":U.
        END.

        IF  b-natur-oper-item.log-memorando <> b-natur-oper-doc.log-memorando THEN DO:
            /* Memorando Exportaá∆o */
            {utp/ut-liter.i A_natureza_fiscal_informada_n∆o_possui_o_indicador_'Memorando_Exportaá∆o'_como_a_natureza_do_embarque *}
            assign i-seq-erro = i-seq-erro + 1.       
            create tt-bo-erro.
            assign tt-bo-erro.parametros = trim(return-value).
            run utp/ut-msgs.p (input "msg":U,
                               input i-cod-erro,
                              input  "").
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = i-cod-erro
                   tt-bo-erro.mensagem     =  RETURN-VALUE.
            RETURN "NOK":U.
        END.
        
        /* Aquisiá∆o rural */
        IF  (SUBSTRING(b-natur-oper-item.char-1,176,1) <> "0") <> (SUBSTRING(b-natur-oper-doc.char-1,176,1) <> "0") THEN DO:
            {utp/ut-liter.i O_indicador_'Comercializaá∆o_Produá∆o_Rural'_deve_estar_configurado_da_mesma_forma_para_todas_as_naturezas_de_operaá∆o_do_embarque_(CD0606) *}
            assign i-seq-erro = i-seq-erro + 1.       
            create tt-bo-erro.
            assign tt-bo-erro.parametros = trim(return-value).
            run utp/ut-msgs.p (input "msg":U,
                               input i-cod-erro,
                               input "").
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = i-cod-erro
                   tt-bo-erro.mensagem     =  RETURN-VALUE.
            RETURN "NOK":U.
        END.
        /*********************/
    END.
    ELSE DO:
         assign i-seq-erro = i-seq-erro + 1.       
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 56868.
                
        RETURN "NOK":U.                                   
    END.
    
    

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-busca-cClassTrib-CST-Aliq:
/*------------------------------------------------------------------------------
  Purpose: Faz a busca do cClassTrib, CST e aliquota dos novos tributos.
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-recarrega-IBSUF  AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-recarrega-IBSMun AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-recarrega-CBS    AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-recarrega-IS     AS LOGICAL NO-UNDO.
    
    FOR EACH ordens-embarque-trib
       WHERE ordens-embarque-trib.cod-estabel  = tt-ordens-desemb.cod-estabel
         AND ordens-embarque-trib.embarque     = tt-ordens-desemb.embarque
         AND ordens-embarque-trib.numero-ordem = tt-ordens-desemb.numero-ordem
         AND ordens-embarque-trib.parcela      = tt-ordens-desemb.parcela NO-LOCK:
           
        /* cClassTrib */
        CASE ordens-embarque-trib.nom-trib:
            WHEN "IBSUF" THEN DO:
                CASE ordens-embarque-trib.cod-campo:
                    WHEN "C-CLASS-TRIB" THEN
                        ASSIGN tt-ordens-desemb.cClassTrib-IBSUF = ordens-embarque-trib.cod-conteudo.
                    WHEN "CST" THEN
                        ASSIGN tt-ordens-desemb.cCST-IBSUF = ordens-embarque-trib.cod-conteudo.
                    WHEN "COD-TRIB" THEN
                        ASSIGN tt-ordens-desemb.c-trib-IBSUF = ordens-embarque-trib.cod-conteudo.
                    WHEN "ALIQUOTA" THEN
                        ASSIGN tt-ordens-desemb.de-aliq-IBSUF = DECIMAL(ordens-embarque-trib.cod-conteudo).
                    WHEN "ALIQ-RED" THEN
                        ASSIGN tt-ordens-desemb.de-aliq-red-IBSUF = DECIMAL(ordens-embarque-trib.cod-conteudo).
                    WHEN "C-CLASS-TRIB-REG" THEN
                        ASSIGN tt-ordens-desemb.cClassTribReg-IBSUF = ordens-embarque-trib.cod-conteudo.
                    WHEN "CST-REG" THEN
                        ASSIGN tt-ordens-desemb.cCSTReg-IBSUF = ordens-embarque-trib.cod-conteudo.
                    WHEN "ALIQ-EFETIVA-REG" THEN
                        ASSIGN tt-ordens-desemb.de-aliq-Reg-IBSUF = DECIMAL(ordens-embarque-trib.cod-conteudo).
                    WHEN "PERC-RED-GOV" THEN
                        IF plIsGovEntity AND ordens-embarque-trib.cod-conteudo <> "" THEN
                            ASSIGN tt-ordens-desemb.perc-red-gov-ibsuf = DECIMAL(ordens-embarque-trib.cod-conteudo).
                END CASE.
            END.
            WHEN "IBSMUN" THEN DO:
                CASE ordens-embarque-trib.cod-campo:
                    WHEN "C-CLASS-TRIB" THEN
                        ASSIGN tt-ordens-desemb.cClassTrib-IBSMun = ordens-embarque-trib.cod-conteudo.
                    WHEN "CST" THEN
                        ASSIGN tt-ordens-desemb.cCST-IBSMun = ordens-embarque-trib.cod-conteudo.
                    WHEN "COD-TRIB" THEN
                        ASSIGN tt-ordens-desemb.c-trib-IBSMun = ordens-embarque-trib.cod-conteudo.
                    WHEN "ALIQUOTA" THEN
                        ASSIGN tt-ordens-desemb.de-aliq-IBSMun = DECIMAL(ordens-embarque-trib.cod-conteudo).
                    WHEN "ALIQ-RED" THEN
                        ASSIGN tt-ordens-desemb.de-aliq-red-IBSMun = DECIMAL(ordens-embarque-trib.cod-conteudo).
                    WHEN "C-CLASS-TRIB-REG" THEN
                        ASSIGN tt-ordens-desemb.cClassTribReg-IBSMun = ordens-embarque-trib.cod-conteudo.
                    WHEN "CST-REG" THEN
                        ASSIGN tt-ordens-desemb.cCSTReg-IBSMun = ordens-embarque-trib.cod-conteudo.
                    WHEN "ALIQ-EFETIVA-REG" THEN
                        ASSIGN tt-ordens-desemb.de-aliq-Reg-IBSMun = DECIMAL(ordens-embarque-trib.cod-conteudo).
                    WHEN "PERC-RED-GOV" THEN
                        IF plIsGovEntity AND ordens-embarque-trib.cod-conteudo <> "" THEN
                            ASSIGN tt-ordens-desemb.perc-red-gov-ibsmun = DECIMAL(ordens-embarque-trib.cod-conteudo).                    
                END CASE.
            END.
            WHEN "CBS" THEN DO:
                CASE ordens-embarque-trib.cod-campo:
                    WHEN "C-CLASS-TRIB" THEN
                        ASSIGN tt-ordens-desemb.cClassTrib-CBS = ordens-embarque-trib.cod-conteudo.
                    WHEN "CST" THEN
                        ASSIGN tt-ordens-desemb.cCST-CBS = ordens-embarque-trib.cod-conteudo.
                    WHEN "COD-TRIB" THEN
                        ASSIGN tt-ordens-desemb.c-trib-CBS = ordens-embarque-trib.cod-conteudo.
                    WHEN "ALIQUOTA" THEN
                        ASSIGN tt-ordens-desemb.de-aliq-CBS = DECIMAL(ordens-embarque-trib.cod-conteudo).
                    WHEN "ALIQ-RED" THEN
                        ASSIGN tt-ordens-desemb.de-aliq-red-CBS = DECIMAL(ordens-embarque-trib.cod-conteudo).
                    WHEN "C-CLASS-TRIB-REG" THEN
                        ASSIGN tt-ordens-desemb.cClassTribReg-CBS = ordens-embarque-trib.cod-conteudo.
                    WHEN "CST-REG" THEN
                        ASSIGN tt-ordens-desemb.cCSTReg-CBS = ordens-embarque-trib.cod-conteudo.
                    WHEN "ALIQ-EFETIVA-REG" THEN
                        ASSIGN tt-ordens-desemb.de-aliq-Reg-CBS = DECIMAL(ordens-embarque-trib.cod-conteudo).
                    WHEN "PERC-RED-GOV" THEN
                        IF plIsGovEntity AND ordens-embarque-trib.cod-conteudo <> "" THEN
                            ASSIGN tt-ordens-desemb.perc-red-gov-cbs = DECIMAL(ordens-embarque-trib.cod-conteudo).
                END CASE.
            END.
            WHEN "IS" THEN DO:
                CASE ordens-embarque-trib.cod-campo:
                    WHEN "C-CLASS-TRIB" THEN
                        ASSIGN tt-ordens-desemb.cClassTrib-IS = ordens-embarque-trib.cod-conteudo.
                    WHEN "CST" THEN
                        ASSIGN tt-ordens-desemb.cCST-IS = ordens-embarque-trib.cod-conteudo.
                    WHEN "COD-TRIB" THEN
                        ASSIGN tt-ordens-desemb.c-trib-IS = ordens-embarque-trib.cod-conteudo.
                    WHEN "ALIQUOTA" THEN
                        ASSIGN tt-ordens-desemb.de-aliq-IS = DECIMAL(ordens-embarque-trib.cod-conteudo).
                    WHEN "ALIQ-ESPEC-UN" THEN
                        ASSIGN tt-ordens-desemb.de-aliq-espec-IS = DECIMAL(ordens-embarque-trib.cod-conteudo).
                    WHEN "QTDE-TRIBUT" THEN
                        ASSIGN tt-ordens-desemb.de-qtde-trib-IS = DECIMAL(ordens-embarque-trib.cod-conteudo).
                    WHEN "UN-TRIBUT" THEN
                        ASSIGN tt-ordens-desemb.c-un-trib-IS = ordens-embarque-trib.cod-conteudo.
                END CASE.
            END.
        END CASE.
    END.
              
    IF tt-ordens-desemb.cClassTrib-IBSUF  = "" OR p-recarrega-IBSUF
    OR tt-ordens-desemb.cClassTrib-IBSMun = "" OR p-recarrega-IBSMun
    OR tt-ordens-desemb.cClassTrib-CBS    = "" OR p-recarrega-CBS
    OR ((tt-ordens-desemb.cClassTrib-IS   = "" OR p-recarrega-IS) 
         AND SUBSTRING(item.char-1,289,1) = "S" /* Incide IS */ ) THEN 
        RUN pi-sugere-cClassTrib. 

    IF tt-ordens-desemb.de-aliq-IBSUF  = 0 OR p-recarrega-IBSUF  OR (plIsGovEntity AND tt-ordens-desemb.perc-red-gov-ibsuf = 0)
    OR tt-ordens-desemb.de-aliq-IBSMun = 0 OR p-recarrega-IBSMun OR (plIsGovEntity AND tt-ordens-desemb.perc-red-gov-ibsmun = 0)
    OR tt-ordens-desemb.de-aliq-CBS    = 0 OR p-recarrega-CBS    OR (plIsGovEntity AND tt-ordens-desemb.perc-red-gov-cbs = 0)
    OR ((tt-ordens-desemb.de-aliq-IS      = 0 OR p-recarrega-IS)
         AND SUBSTRING(item.char-1,289,1) = "S" /* Incide IS */ ) THEN
        RUN pi-sugere-aliquotas (INPUT p-recarrega-IBSUF,
                                 INPUT p-recarrega-IBSMun,
                                 INPUT p-recarrega-CBS,
                                 INPUT p-recarrega-IS).
 
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-grava-ordens-embarque-trib:
/*------------------------------------------------------------------------------
  Purpose: Cria/atualiza a tabela de extens∆o ordens-embarque-trib
  Parameters: p-nom-trib - nome do tributo
              p-cod-campo - nome do campo
              p-cod-conteudo - valor/conteudo do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nom-trib      AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-campo     AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-conteudo  AS CHAR  NO-UNDO.

    IF LOOKUP(p-cod-campo,"ALIQ-EFETIVA-REG,C-CLASS-TRIB-REG,CST-REG,ALIQ-RED,PERC-RED-GOV") > 0 
    AND (p-cod-conteudo = "" OR p-cod-conteudo = "0") THEN DO:
        FOR FIRST ordens-embarque-trib
            WHERE ordens-embarque-trib.cod-estabel  = tt-ordens-desemb.cod-estabel
              AND ordens-embarque-trib.embarque     = tt-ordens-desemb.embarque
              AND ordens-embarque-trib.numero-ordem = tt-ordens-desemb.numero-ordem
              AND ordens-embarque-trib.parcela      = tt-ordens-desemb.parcela 
              AND ordens-embarque-trib.nom-trib     = p-nom-trib 
              AND ordens-embarque-trib.cod-campo    = p-cod-campo EXCLUSIVE-LOCK:
            DELETE ordens-embarque-trib NO-ERROR.
        END.
    END.
    ELSE DO:
        FIND FIRST ordens-embarque-trib
             WHERE ordens-embarque-trib.cod-estabel  = tt-ordens-desemb.cod-estabel
               AND ordens-embarque-trib.embarque     = tt-ordens-desemb.embarque
               AND ordens-embarque-trib.numero-ordem = tt-ordens-desemb.numero-ordem
               AND ordens-embarque-trib.parcela      = tt-ordens-desemb.parcela 
               AND ordens-embarque-trib.nom-trib     = p-nom-trib 
               AND ordens-embarque-trib.cod-campo    = p-cod-campo EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL ordens-embarque-trib THEN DO:
            CREATE ordens-embarque-trib.
            ASSIGN ordens-embarque-trib.cod-estabel  = tt-ordens-desemb.cod-estabel
                   ordens-embarque-trib.embarque     = tt-ordens-desemb.embarque
                   ordens-embarque-trib.numero-ordem = tt-ordens-desemb.numero-ordem
                   ordens-embarque-trib.parcela      = tt-ordens-desemb.parcela
                   ordens-embarque-trib.nom-trib     = p-nom-trib
                   ordens-embarque-trib.cod-campo    = p-cod-campo.
        END.
        ASSIGN ordens-embarque-trib.cod-conteudo = p-cod-conteudo.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-sugere-cClassTrib:
/*------------------------------------------------------------------------------
  Purpose: Faz a busca da sugest∆o do cClassTrib e CST.
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

    IF  i-embarque-old <> tt-ordens-desemb.embarque THEN DO:
        ASSIGN i-embarque-old = tt-ordens-desemb.embarque.
        RUN emptyCache IN h-reapi433.
        RUN emptyCache IN h-cdapi1005.
    END.

    RUN emptyTtRelacClassTrib IN h-reapi433. 
    RUN setUtilizarCache      IN h-reapi433 (INPUT YES).
    RUN setTipoDocto          IN h-reapi433 (INPUT 1). /*Entrada*/
    RUN setDtIniValidade      IN h-reapi433 (INPUT TODAY).
    RUN setCodEstabel         IN h-reapi433 (INPUT tt-ordens-desemb.cod-estabel).
    RUN setNatOperacao        IN h-reapi433 (INPUT tt-ordens-desemb.c-nat-fiscal).
    RUN setItCodigo           IN h-reapi433 (INPUT ITEM.it-codigo).
    RUN setClassifFiscal      IN h-reapi433 (INPUT tt-ordens-desemb.c-class-fiscal).
    RUN setCodNbs             IN h-reapi433 (INPUT tt-ordens-desemb.cod-nbs).
    RUN setCodGrupEmit        IN h-reapi433 (INPUT IF AVAIL emitente THEN emitente.cod-gr-forn ELSE 0).
    RUN setCodEmitente        IN h-reapi433 (INPUT ordem-compra.cod-emitente).
    RUN setCFOP               IN h-reapi433 (INPUT IF AVAIL natur-oper THEN natur-oper.cod-cfop ELSE "").
    RUN setIndTributo         IN h-reapi433 (INPUT 1). /* 1-IBS/CBS, 2-IS */
    RUN buscarRelacClassTrib  IN h-reapi433. 
      
    RUN getCSTcClassTribAndReg IN h-reapi433 (OUTPUT cClassTrib,
                                              OUTPUT cCST,       
                                              OUTPUT cClassTribReg,       
                                              OUTPUT cCSTReg).       
    
    ASSIGN tt-ordens-desemb.cClassTrib-IBSUF    = cClassTrib
           tt-ordens-desemb.cCST-IBSUF          = cCST
           tt-ordens-desemb.cClassTribReg-IBSUF = cClassTribReg
           tt-ordens-desemb.cCSTReg-IBSUF       = cCSTReg.
    
    ASSIGN tt-ordens-desemb.cClassTrib-IBSMun    = cClassTrib
           tt-ordens-desemb.cCST-IBSMun          = cCST
           tt-ordens-desemb.cClassTribReg-IBSMun = cClassTribReg
           tt-ordens-desemb.cCSTReg-IBSMun       = cCSTReg.
    
    ASSIGN tt-ordens-desemb.cClassTrib-CBS    = cClassTrib
           tt-ordens-desemb.cCST-CBS          = cCST
           tt-ordens-desemb.cClassTribReg-CBS = cClassTribReg
           tt-ordens-desemb.cCSTReg-CBS       = cCSTReg.

    IF SUBSTRING(item.char-1,289,1) = "S" /* Incide IS */ THEN
        ASSIGN tt-ordens-desemb.cClassTrib-IS = cClassTrib
               tt-ordens-desemb.cCST-IS       = cCST.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-sugere-aliquotas:
/*------------------------------------------------------------------------------
  Purpose: Faz a busca da sugest∆o das aliquotas do CBS, IBS UF e IBS Mun.
  Parameters: p-recarrega-IBSUF - recarrega a sugest∆o de aliquota IBSUF 
              p-recarrega-IBSMun - recarrega a sugest∆o de aliquota IBSMun 
              p-recarrega-CBS - recarrega a sugest∆o de aliquota CBS
              p-recarrega-IS - recarrega a sugest∆o de aliquota IS
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-recarrega-IBSUF  AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-recarrega-IBSMun AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-recarrega-CBS    AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-recarrega-IS     AS LOGICAL NO-UNDO.

    DEFINE VARIABLE i-cont                    AS INTEGER NO-UNDO.
    DEFINE VARIABLE deQtdeTribIS              AS DECIMAL NO-UNDO.
   
    IF  i-embarque-old <> tt-ordens-desemb.embarque THEN DO:
        ASSIGN i-embarque-old = tt-ordens-desemb.embarque.
        RUN emptyCache IN h-reapi433.
        RUN emptyCache IN h-cdapi1005.
    END.

    RUN emptyTtRelactoTributo IN h-cdapi1005. 
    RUN setUtilizarCache      IN h-cdapi1005 (INPUT YES).
    RUN setNbs                IN h-cdapi1005 (INPUT tt-ordens-desemb.cod-nbs).
    RUN setDados              IN h-cdapi1005 (INPUT 1, /*Entrada*/
                                              INPUT TODAY,
                                              INPUT tt-ordens-desemb.cod-estabel,
                                              INPUT tt-ordens-desemb.c-nat-fiscal,
                                              INPUT ITEM.it-codigo,
                                              INPUT tt-ordens-desemb.c-class-fiscal,
                                              INPUT IF AVAIL emitente THEN emitente.cod-gr-forn ELSE 0,
                                              INPUT ordem-compra.cod-emitente,
                                              INPUT IF AVAIL natur-oper THEN natur-oper.cod-cfop ELSE "*",
                                              INPUT item.cod-servico,
                                              INPUT estabelec.cidade,   /*cidade*/
                                              INPUT estabelec.estado).  /*UF*/
    RUN gerattcombinacao      IN h-cdapi1005.

    //1-CBS, 2-IBS UF, 3-IBS Mun, 4-IS
    DO  i-cont = 1 TO 4:
        EMPTY TEMP-TABLE tt-relacto-tributo.  
        
        IF  i-cont < 4
        OR (i-cont = 4 AND SUBSTRING(item.char-1,289,1) = "S") THEN DO:
            RUN setIndTributo         IN h-cdapi1005 (INPUT i-cont). /* 1-CBS, 2-IBS UF, 3-IBS Mun, 4-IS */
            RUN buscarRelactotributo  IN h-cdapi1005.
            RUN getTtRelactoTributo   IN h-cdapi1005 (OUTPUT TABLE tt-relacto-tributo).  
        END.
        
        FOR FIRST tt-relacto-tributo:
           IF  i-cont = 1 /*CBS*/ THEN DO:
               IF tt-ordens-desemb.de-aliq-CBS = 0 OR p-recarrega-CBS THEN DO:
                   ASSIGN tt-ordens-desemb.de-aliq-CBS = tt-relacto-tributo.aliquota.
                   IF tt-ordens-desemb.cClassTribReg-CBS <> "" THEN
                       ASSIGN tt-ordens-desemb.de-aliq-Reg-CBS = tt-relacto-tributo.aliquota.
                   ELSE
                       ASSIGN tt-ordens-desemb.de-aliq-Reg-CBS = 0.
               END.
               
               IF tt-ordens-desemb.de-aliq-red-CBS = 0 OR p-recarrega-CBS THEN 
                   ASSIGN tt-ordens-desemb.de-aliq-red-CBS = tt-relacto-tributo.perc-red.
                   
               IF plIsGovEntity AND(tt-ordens-desemb.perc-red-gov-cbs = 0 OR p-recarrega-CBS) THEN
                   ASSIGN tt-ordens-desemb.perc-red-gov-cbs = tt-relacto-tributo.perc-red-aliq-gov.
           END.
           ELSE 
           IF i-cont = 2 /*IBS UF*/ THEN DO:
               IF tt-ordens-desemb.de-aliq-IBSUF = 0 OR p-recarrega-IBSUF THEN DO:
                   ASSIGN tt-ordens-desemb.de-aliq-IBSUF = tt-relacto-tributo.aliquota.
                   IF tt-ordens-desemb.cClassTribReg-IBSUF <> "" THEN
                       ASSIGN tt-ordens-desemb.de-aliq-Reg-IBSUF = tt-relacto-tributo.aliquota.
                   ELSE
                       ASSIGN tt-ordens-desemb.de-aliq-Reg-IBSUF = 0.
               END.
               
               IF tt-ordens-desemb.de-aliq-red-IBSUF = 0 OR p-recarrega-IBSUF THEN
                   ASSIGN tt-ordens-desemb.de-aliq-red-IBSUF = tt-relacto-tributo.perc-red.
                   
               IF plIsGovEntity AND(tt-ordens-desemb.perc-red-gov-ibsuf = 0 OR p-recarrega-IBSUF) THEN
                   ASSIGN tt-ordens-desemb.perc-red-gov-ibsuf = tt-relacto-tributo.perc-red-aliq-gov.
           END.
           ELSE 
           IF i-cont = 3 /* IBS Mun*/ THEN DO:
               IF tt-ordens-desemb.de-aliq-IBSMun = 0 OR p-recarrega-IBSMun THEN DO:
                   ASSIGN tt-ordens-desemb.de-aliq-IBSMun = tt-relacto-tributo.aliquota.
                   IF tt-ordens-desemb.cClassTribReg-IBSMun <> "" THEN
                       ASSIGN tt-ordens-desemb.de-aliq-Reg-IBSMun = tt-relacto-tributo.aliquota.
                   ELSE
                       ASSIGN tt-ordens-desemb.de-aliq-Reg-IBSMun = 0.
               END.
               
               IF tt-ordens-desemb.de-aliq-red-IBSMun = 0 OR p-recarrega-IBSMun THEN
                   ASSIGN tt-ordens-desemb.de-aliq-red-IBSMun = tt-relacto-tributo.perc-red.
                   
               IF plIsGovEntity AND (tt-ordens-desemb.perc-red-gov-ibsmun = 0 OR p-recarrega-IBSMun) THEN
                   ASSIGN tt-ordens-desemb.perc-red-gov-ibsmun = tt-relacto-tributo.perc-red-aliq-gov.
           END.    
           ELSE 
           IF i-cont = 4 /* IS */ 
           AND SUBSTRING(item.char-1,289,1) = "S" /* Incide IS */ THEN DO:
               IF tt-ordens-desemb.de-aliq-IS = 0 OR p-recarrega-IS THEN DO:
                   ASSIGN tt-ordens-desemb.de-aliq-IS       = tt-relacto-tributo.aliquota
                          tt-ordens-desemb.de-aliq-espec-IS = tt-relacto-tributo.aliq-esp-por-unid-aprop-is
                          tt-ordens-desemb.c-un-trib-IS     = SUBSTRING(item.char-1,290,2).
                   
                   RUN converteQtdeTribIS IN h-imapi017(INPUT  item.it-codigo,
                                                        INPUT  tt-ordens-desemb.de-quantidade,
                                                        OUTPUT deQtdeTribIS).
                   
                   ASSIGN tt-ordens-desemb.de-qtde-trib-IS = deQtdeTribIS.
               END.
           END.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-verifica-cod-trib:
    FOR EACH tt-ordens-desemb:        
        IF tt-ordens-desemb.c-trib-CBS = "0" OR tt-ordens-desemb.c-trib-CBS = "" THEN
            ASSIGN tt-ordens-desemb.c-trib-CBS = "1".
        
        IF tt-ordens-desemb.c-trib-IBSUF = "0" OR tt-ordens-desemb.c-trib-IBSUF = "" THEN
            ASSIGN tt-ordens-desemb.c-trib-IBSUF = "1".
            
        IF tt-ordens-desemb.c-trib-IBSMun = "0" OR tt-ordens-desemb.c-trib-IBSMun = "" THEN
            ASSIGN tt-ordens-desemb.c-trib-IBSMun = "1".
        
        IF tt-ordens-desemb.c-trib-IS = "0" OR tt-ordens-desemb.c-trib-IS = "" THEN
            ASSIGN tt-ordens-desemb.c-trib-IS = "1".
    END.            
END PROCEDURE.

PROCEDURE pi-verifica-ente-governamental:

    DEFINE INPUT PARAMETER p-cod-estabel
        LIKE estabelec.cod-estabel NO-UNDO.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = p-cod-estabel
         NO-ERROR.

    IF AVAILABLE estabelec AND
       LENGTH(estabelec.char-1) >= 400 AND
       SUBSTRING(estabelec.char-1,400,1) >= "1" AND
       SUBSTRING(estabelec.char-1,400,1) <= "9" THEN DO:

        ASSIGN plIsGovEntity   = YES
               plGovEntityType = INT(SUBSTRING(estabelec.char-1,400,1)).
    END.
    ELSE
        ASSIGN plIsGovEntity   = NO
               plGovEntityType = 0.
END PROCEDURE.

/* BOCX225E.P */


/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.   
*******************************************************************************/
{include/i-prgvrs.i BOCX225 2.00.01.065 } /*** "010165" 27/02/2026 08:48:33 ***/
      
/*&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx225 MUT}
&ENDIF*/

/*******************************************************************************
**
**  BOCX225.P
**
**  ordens-embarque - Ordens Embarque
**
*******************************************************************************/

&SCOPED-DEFINE BOVERSION 1.1
&SCOPED-DEFINE PRVERSION 2.00.01.053
&SCOPED-DEFINE FIRST-TABLE-IN-QUERY ordens-embarque
&SCOPED-DEFINE QUERY-NAME qTable
&SCOPED-DEFINE TABLE-NAME ordens-embarque

{cdp/cdcfgdis.i}                    /* Include Pre-processadores                                                                        */
{cdp/cdcfgmat.i}                    /* Include Pre-processadores                                                                        */
{utp/ut-glob.i}                     /* Variaveis Globais                                                                                */
{include/boini.i}                   /* l-version, lExistsCustomBO, cCustomBOName, l-query, i-bo-query, i-seq-erro, c-return, tt-bo-erro */
{cxbo/bocx225.i RowObject}          
{imp/im7777a.i2}                    /* TT Eliminacao das ordens embarque - tt-desp, tt-cot-desp, bfprazo-compra225                      */
{cxbo/bocx225.i tt-ordens}          /* Para eliminacao das ordens embarque                                                              */
{cxbo/bocx315.i tt-pedido-drb-item}
{cdp/cd4300.i3}                    /* Variaveis para desmembrar variaveis livres                                                        */
{ccp/cc9019.i50}                   /* Desmembrar atributos livres cotacao-item                                                          */
{imp/im0045ab.i50}                 /* Desmembrar atributos livres ordens-embarque                                                       */
{include/i-epc200.i bocx225}       /* Defini‡Æo tt-epc e dos programas de EPCs                                                          */

{cxbo/bocx230.i tt-historico-embarque}

DEFINE VARIABLE c-time                  AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-cod-idiom-usuar       AS CHARACTER FORMAT "x(12)":U       NO-UNDO.
DEFINE VARIABLE c-cod-estabel           AS CHARACTER FORMAT "x(05)":U       NO-UNDO.
DEFINE VARIABLE c-identific-container   AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-cod-estab             AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-cod-incoterm-rat      AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-nr-proc-imp           AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-item-ini              AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-item-fim              AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-cod-estabel-imp       AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-cod-uf                AS CHARACTER FORMAT "x(2)":U        NO-UNDO.
DEFINE VARIABLE c-lbl-liter             AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-lbl-liter-e           AS CHARACTER   extent 3             NO-UNDO.
DEFINE VARIABLE da-ult-previsao         AS DATE                             NO-UNDO.
DEFINE VARIABLE d-qtd-embal             AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE de-peso-total           AS DECIMAL                          NO-UNDO.    
DEFINE VARIABLE de-volume-total         AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE h-bocx150               AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-bocx230a              AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-bocx351               AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-bodi425               AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-boin356               AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-im9025                AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-bocx140               AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-bocx110               AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-bocx00488             AS HANDLE                           NO-UNDO.
DEFINE VARIABLE i-nr-dias-pto-solic-li  AS INTEGER                          NO-UNDO.
DEFINE VARIABLE i-sequencia             AS INTEGER                          NO-UNDO.
DEFINE VARIABLE i-numero-ordem          AS INTEGER                          NO-UNDO.
DEFINE VARIABLE i-numero-ordem-ini      AS INTEGER                          NO-UNDO.
DEFINE VARIABLE i-numero-ordem-fim      AS INTEGER                          NO-UNDO.
DEFINE VARIABLE i-parcela-ini           AS INTEGER                          NO-UNDO.
DEFINE VARIABLE i-parcela-fim           AS INTEGER                          NO-UNDO.
DEFINE VARIABLE l-create-hist           AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-acompan               AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-quebra-di             AS LOGICAL  INITIAL NO              NO-UNDO.
DEFINE VARIABLE l-necessita-li          AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-emb                   AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-criou-ordens-embarque AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-recalculo             AS LOGICAL  INITIAL NO              NO-UNDO.
DEFINE VARIABLE r-historico-embarque    AS ROWID                            NO-UNDO.
DEFINE VARIABLE i-via-transp            LIKE embarque-imp.cod-via-transp    NO-UNDO.
DEFINE VARIABLE c-embarque              LIKE embarque-imp.embarque          NO-UNDO.
DEFINE VARIABLE c-est                   LIKE embarque-imp.cod-estabel       NO-UNDO.
DEFINE VARIABLE c-embarque-imp          LIKE embarque-imp.embarque          NO-UNDO.
DEFINE VARIABLE i-nova-parcela          LIKE prazo-compra.parcela           NO-UNDO.
DEFINE VARIABLE vd-cod-duimp-dts        LIKE duimp-item.cod-duimp-dts       NO-UNDO.
DEFINE VARIABLE l-nt2024002             AS LOGICAL                          NO-UNDO.

DEFINE BUFFER b-prazo-compra    FOR prazo-compra.
DEFINE BUFFER b-ordens-embarque FOR ordens-embarque.

{method/dbotterr.i}

{cxbo/bocx351.i tt-licenciam-import-oc}

DEFINE TEMP-TABLE tt-idioma NO-UNDO
    FIELD cod-idioma AS CHARACTER FORMAT "x(12)":U
    INDEX idioma IS UNIQUE PRIMARY
        cod-idioma.

DEFINE TEMP-TABLE pTableOrd NO-UNDO LIKE ordens-embarque
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE pTableOrd2 NO-UNDO LIKE ordens-embarque
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE pDelOrdem NO-UNDO
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-prazo NO-UNDO LIKE prazo-compra. 

DEFINE TEMP-TABLE tt-embarque NO-UNDO
    FIELD embarque AS CHARACTER FORMAT "x(16)":U.

DEFINE TEMP-TABLE tt-embarque-aux NO-UNDO
    FIELD embarque AS CHARACTER FORMAT "x(16)":U
    INDEX codigo embarque.

DEFINE TEMP-TABLE tt-ordens-nac NO-UNDO LIKE ordens-embarque
    FIELD c-it-codigo       LIKE  ITEM.it-codigo
    FIELD de-quantidade-nac AS    DECIMAL format ">>>>>,>>9.9999":U
    FIELD i-parcela-nova    AS    INTEGER 
    FIELD de-quant-nova     LIKE  prazo-compra.quantidade
    FIELD de-qt-fn-nova     LIKE  prazo-compra.quantidade
    FIELD r-rowid           AS    ROWID.

DEFINE TEMP-TABLE tt-ordens-embarque-aux     NO-UNDO LIKE tt-ordens-nac.
DEFINE TEMP-TABLE tt-ordens-embarque-selecao NO-UNDO LIKE tt-ordens-nac.
DEFINE TEMP-TABLE tt-ordens-embarque1        NO-UNDO LIKE ordens-embarque
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ordens-embarque2 NO-UNDO LIKE ordens-embarque.

{imp/im0545h.i} /* tt-saldo-embarque */

DEFINE QUERY {&QUERY-NAME} FOR ordens-embarque SCROLLING.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-nt2024002":U AND funcao.ativo).

PROCEDURE setConstraint1:
/*------------------------------------------------------------------------------
  Purpose: Restricaoo de abertura para a query    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.
END PROCEDURE. 

procedure setConstraint2:
/*------------------------------------------------------------------------------
  Purpose: Restricaoo de abertura para a query        
  Parameters: INPUT - p-cod (character) - numero da ordem de compra
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod  AS CHARACTER NO-UNDO.

    ASSIGN i-numero-ordem = INT(p-cod).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraint3:
/*------------------------------------------------------------------------------
  Purpose: Restricaoo de abertura para a query        
  Parameters: INPUT - r-rowid (rowid) - rowid da tabela embarque-imp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-rowid AS ROWID NO-UNDO.

    FIND FIRST embarque-imp WHERE ROWID(embarque-imp) = r-rowid NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraint4:
/*------------------------------------------------------------------------------
  Purpose: Restricaoo de abertura para a query        
  Parameters: INPUT - p-embarque (character) - codigo do embarque
              INPUT - p-cod-est (character)  - codigo do estabelecimento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-embarque   LIKE embarque-imp.embarque    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-est    LIKE embarque-imp.cod-estabel NO-UNDO.

    ASSIGN c-embarque  = p-embarque
           c-est       = p-cod-est.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraint5:
/*------------------------------------------------------------------------------
  Purpose: Restricaoo de abertura para a query        
  Parameters: INPUT - p-embarque (character) - codigo do embarque
              INPUT - p-cod-est (character)  - codigo do estabelecimento
              INPUT - p-identific-container  - codigo do container  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-embarque               LIKE embarque-imp.embarque      NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel            LIKE embarque-imp.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER p-identific-container    AS CHARACTER                    NO-UNDO.
    
    ASSIGN c-embarque            = p-embarque
           c-cod-estabel         = p-cod-estabel 
           c-identific-container = p-identific-container.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintSelecao:
/*------------------------------------------------------------------------------
  Purpose: Restricaoo de abertura para a query        
  Parameters: INPUT - pc-cod-estabel (character) - codigo do estabelecimento
              INPUT - pc-embarque (character)  - codigo do embarque
              INPUT - pi-numero-ordem-ini (integer)  - numero da ordem inicial 
              INPUT - pi-numero-ordem-fim (integer) - numero da ordem final
              INPUT - pi-parcela-ini (integer) - numero da parcela inicial
              INPUT - pi-parcela-fim (integer) - numero da parcela final
              INPUT - pc-item-ini (character) - codigo do item inicial
              INPUT - pc-item-fim (character) - codigo do item final
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-embarque         AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pi-numero-ordem-ini AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pi-numero-ordem-fim AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pi-parcela-ini      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pi-parcela-fim      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pc-item-ini         AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-item-fim         AS CHARACTER NO-UNDO.

    ASSIGN c-cod-estabel-imp   = pc-cod-estabel
           c-embarque-imp      = pc-embarque
           i-numero-ordem-ini  = pi-numero-ordem-ini
           i-numero-ordem-fim  = pi-numero-ordem-fim
           i-parcela-ini       = pi-parcela-ini
           i-parcela-fim       = pi-parcela-fim
           c-item-ini          = pc-item-ini
           c-item-fim          = pc-item-fim.

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
                WHERE ordens-embarque.cod-estabel = c-est
                  AND ordens-embarque.embarque    = c-embarque.
        WHEN 3 THEN
            OPEN QUERY {&QUERY-NAME} FOR EACH ordens-embarque OF embarque-imp
                 NO-LOCK BY invoice-emb-imp.cod-estabel.
        WHEN 4 THEN
            OPEN QUERY {&QUERY-NAME} FOR EACH ordens-embarque NO-LOCK
                 WHERE ordens-embarque.cod-estabel = c-est
                   AND ordens-embarque.embarque    = c-embarque.
        WHEN 5 THEN
            OPEN QUERY {&QUERY-NAME} FOR EACH ordens-embarque NO-LOCK
                 WHERE ordens-embarque.cod-estabel         = c-cod-estabel
                   AND ordens-embarque.embarque            = c-embarque
                   AND ordens-embarque.identific-container = "":U.
        WHEN 6 THEN
            OPEN QUERY {&QUERY-NAME} FOR EACH ordens-embarque NO-LOCK
                 WHERE ordens-embarque.cod-estabel         = c-cod-estabel
                   AND ordens-embarque.embarque            = c-embarque 
                   AND (ordens-embarque.identific-container = c-identific-container AND
                       ordens-embarque.identific-container <> "").
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
{include/boexecre.i} /* executeCreate                                     */
{include/boexedel.i} /* executeDelete                                     */

PROCEDURE initializeValidate:
/*------------------------------------------------------------------------------
  Purpose: Inicializa Validate
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     
    RUN startMethod ("initializeValidade":U).
 
    RUN endMethod   ("initializeValidade":U).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE findCodigo:
/*------------------------------------------------------------------------------
  Purpose: Procura pelo indice, caso nao ache, retorna mensagem de erro padrao do EMS.
  Parameters:  INPUT - i-numero-ordem (integer) - numero da ordem de compra
               INPUT - c-nr-proc-imp  (character) - codigo do proceso de importacao
               OUTPUT - c-return (character) - status do processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER i-numero-ordem AS INTEGER       NO-UNDO.
    DEFINE INPUT  PARAMETER c-nr-proc-imp  AS CHARACTER     NO-UNDO.
    DEFINE OUTPUT PARAMETER c-return       AS CHARACTER     NO-UNDO.
    
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

PROCEDURE setQuebraOrdensDi:
/*------------------------------------------------------------------------------
  Purpose: Seta configuracao de quebra da DI
  Parameters:  INPUT - p-quebra-di (logical) - informa se di sera dividida
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-quebra-di AS LOGICAL NO-UNDO.

    ASSIGN l-quebra-di = p-quebra-di.

    RETURN "OK":U.
END PROCEDURE. 

PROCEDURE findEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Procura a primeira ordem do embarque, caso nao ache, retorna mensagem de erro padrao do EMS
  Parameters:  INPUT - p-quebra-di (character) - codigo do estabelecimento
               INPUT - c-embarque (character) - codigo do embarque
               OUTPUT - c-return (character) - status do processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-cod-estabel LIKE embarque-imp.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER c-embarque    LIKE embarque-imp.embarque    NO-UNDO.
    DEFINE OUTPUT PARAMETER c-return      AS CHARACTER                  NO-UNDO.
    
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
  Purpose: Procura a primeira ordem do embarque, caso nao ache, retorna mensagem de erro padrao do EMS
  Parameters:  INPUT - c-nr-proc-imp (character) - codigo do processo de importacao
               OUTPUT - c-return (character) - status do processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-nr-proc-imp LIKE processo-imp.nr-proc-imp NO-UNDO.
    DEFINE OUTPUT PARAMETER c-return      AS CHARACTER                  NO-UNDO.

    FIND FIRST ordens-embarque
         WHERE ordens-embarque.nr-proc-imp  = c-nr-proc-imp NO-LOCK NO-ERROR.

    IF NOT AVAIL ordens-embarque THEN DO:
        {utp/ut-table.i mgcex ordens-embarque 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
        ASSIGN c-return = RETURN-VALUE.
        RETURN "NOK":U.
    END.
    ELSE DO:
       RUN setCurrent.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE executeUpdate:
/*------------------------------------------------------------------------------
  Purpose: Atualiza registro realizando copia da RowObject para a tabela ordens-embarque
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    BUFFER-COPY RowObject EXCEPT r-rowid numero-ordem nr-proc-imp cod-estabel embarque TO ordens-embarque.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE eliminaEmbarquePrazCompra:
/*------------------------------------------------------------------------------
  Purpose: Elimina tabela eq-embarq-praz-compra relacionada a ordens-embarque
  Parameters:  INPUT - p-cod-estabel (character) - codigo do estabelecimento
               INPUT - p-embarque (character) - codigo do embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel AS CHARACTER               NO-UNDO.
    DEFINE INPUT PARAMETER p-embarque    LIKE embarque-imp.embarque NO-UNDO.

    FIND FIRST ordens-embarque 
         WHERE ordens-embarque.cod-estabel = p-cod-estabel 
           AND ordens-embarque.embarque    = p-embarque NO-LOCK NO-ERROR.
    
    IF AVAIL ordens-embarque THEN DO:
        
        FOR FIRST ordem-compra FIELDS(num-pedido numero-ordem) 
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK: 

            FOR EACH eq-embarq-praz-compra 
                WHERE eq-embarq-praz-compra.num-pedido   = ordem-compra.num-pedido   
                  AND eq-embarq-praz-compra.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:
                DELETE eq-embarq-praz-compra.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE validateUpdate:
/*------------------------------------------------------------------------------
  Purpose: Valida alteracao do registro
  Parameters:  INPUT TABLE - RowObject - TempTable com o registro que sera alterado/validado
               INPUT - r-chave (rowid) - rowid do registro
               OUTPUT TABLE - tt-bo-erro - TempTable com os erros que ocorreram durante o processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR RowObject.
    DEFINE INPUT  PARAMETER r-chave AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.
    
    RUN startMethod("validateUpdate":U).
 
    RUN InitializeValidate.
 
    EMPTY TEMP-TABLE tt-bo-erro.
    
    RUN validateFields.
    
    FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-bo-erro THEN DO:

        FIND FIRST ordens-embarque WHERE ROWID(ordens-embarque) = r-chave EXCLUSIVE-LOCK NO-ERROR NO-WAIT.

        IF LOCKED(ordens-embarque) THEN DO:

            RUN criaTTBoErro(INPUT 16096, INPUT "").
        END.
        ELSE 
            IF AVAIL ordens-embarque THEN
                RUN executeUpdate.          
    END.

    RUN endMethod("validateUpdate":U).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateCreate:
/*------------------------------------------------------------------------------
  Purpose: Valida cria¯Êo da tabela/duplicidade de registro
  Parameters:  INPUT TABLE - RowObject - TempTable com o registro que sera alterado/validado
               OUTPUT TABLE - tt-bo-erro - TempTable com os erros que ocorreram durante o processamento
               OUTPUT - r-chave (rowid) - rowid do registro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR RowObject.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.
    DEFINE OUTPUT PARAMETER r-chave AS ROWID NO-UNDO.
    
    RUN startMethod("validateCreate":U).
 
    RUN initializeValidate.

    EMPTY TEMP-TABLE tt-bo-erro.
 
    FIND FIRST rowObject EXCLUSIVE-LOCK NO-ERROR.
    
    IF rowObject.numero-ordem = 0 THEN DO:

        {utp/ut-field.i mgcex ordens-embarque numero-ordem 1}
        RUN criaTTBoErro(INPUT 7965, INPUT RETURN-VALUE).
    END.
    ELSE DO:

       IF NOT CAN-FIND(ordem-compra WHERE ordem-compra.numero-ordem = rowObject.numero-ordem) THEN DO:
           
           {utp/ut-field.i mgcex ordens-embarque numero-ordem 1}
           RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE).
       END.
    END. 
    
    RUN validateFields.
    
    FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-bo-erro THEN DO:
        
        FIND FIRST ordens-embarque 
             WHERE ordens-embarque.nr-proc-imp = rowObject.nr-proc-imp NO-LOCK NO-ERROR.
        
        IF AVAIL ordens-embarque THEN DO:

            {utp/ut-table.i mgcex ordens-embarque 1}
            RUN criaTTBoErro(INPUT 8, INPUT RETURN-VALUE).
        END.
    END.
    
    FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.
 
    IF NOT AVAIL tt-bo-erro THEN DO:
       RUN executeCreate.
       ASSIGN r-chave = TO-ROWID(RETURN-VALUE).
    END.
    RUN endMethod("validateCreate":U). 

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateEmbarqueOrdem:
/*------------------------------------------------------------------------------
  Purpose: Verfica se o embarque possui eq-embarq-praz-compra
  Parameters:  INPUT - p-cod-estabel (character) - codigo do estabelecimento
               INPUT - p-embarque (character) - codigo do embarque
               OUTPUT - pl-embarque (logical) - rowid do registro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER p-embarque    AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-embarque   AS LOGICAL    NO-UNDO.

    ASSIGN pl-embarque = NO.
    
    FIND FIRST ordens-embarque 
         WHERE ordens-embarque.cod-estabel = p-cod-estabel 
           AND ordens-embarque.embarque    = p-embarque NO-LOCK NO-ERROR.

    IF AVAIL ordens-embarque THEN DO:
        FOR FIRST ordem-compra FIELDS(num-pedido numero-ordem) 
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:
            
            IF CAN-FIND (FIRST eq-embarq-praz-compra 
                         WHERE eq-embarq-praz-compra.num-pedido   = ordem-compra.num-pedido   
                           AND eq-embarq-praz-compra.numero-ordem = ordem-compra.numero-ordem ) THEN
                ASSIGN pl-embarque = YES.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateEliminacaoOrdem:
/*------------------------------------------------------------------------------
  Purpose: Validar a elimina‡Æo de uma ordem do embarque, verificando a sua integra‡Æo com outras tabelas.
  Parameters:  INPUT - p-cod-estabel (character) - codigo do estabelecimento
               INPUT - p-embarque (character) - codigo do embarque
               OUTPUT - c-mensagem (character) - mensagem com eventual erro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel AS CHARACTER                  NO-UNDO.
    DEFINE INPUT  PARAMETER p-embarque    LIKE embarque-imp.embarque    NO-UNDO.
    DEFINE OUTPUT PARAMETER c-mensagem    AS CHARACTER FORMAT "X(60)":U NO-UNDO.
    
    DEFINE VARIABLE l-entrou              AS LOGICAL                    NO-UNDO.
    
    IF NOT VALID-HANDLE (h-bocx00488) THEN
        RUN cxbo/bocx00488.p PERSISTENT SET h-bocx00488.
        
    IF VALID-HANDLE(h-bocx00488) then do:
        ASSIGN vd-cod-duimp-dts = 0.
        RUN piValidaEmbarqueDuimp in h-bocx00488 (input  p-cod-estabel,
                                                  input  p-embarque,
                                                  output vd-cod-duimp-dts).
        IF vd-cod-duimp-dts <> 0 THEN
            ASSIGN c-mensagem = "DUIMP No:":U + STRING(vd-cod-duimp-dts).            
    END.
    
    IF  VALID-HANDLE (h-bocx00488) THEN DO:
        DELETE PROCEDURE h-bocx00488.
        ASSIGN h-bocx00488 = ?.
    END.
    
    FIND FIRST ordens-embarque 
         WHERE ordens-embarque.cod-estabel = p-cod-estabel 
           AND ordens-embarque.embarque    = p-embarque NO-LOCK NO-ERROR.

    IF AVAIL ordens-embarque THEN DO:
        
        FIND FIRST ordem-compra 
             WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.

        IF NOT AVAIL ordem-compra THEN LEAVE.

        FIND FIRST invoice-emb-imp 
             WHERE invoice-emb-imp.cod-estabel = ordens-embarque.cod-estabel 
               AND invoice-emb-imp.embarque    = ordens-embarque.embarque NO-LOCK NO-ERROR.

        IF AVAIL invoice-emb-imp THEN
            ASSIGN c-mensagem = IF c-mensagem = '' THEN "Faturas do Embarque":U ELSE TRIM(c-mensagem) + ", Faturas do Embarque":U.

        FOR EACH embarq-import-docto
           WHERE embarq-import-docto.cod-estab  = p-cod-estabel 
             AND embarq-import-docto.cod-embarq = p-embarque    NO-LOCK:
            
            ASSIGN l-entrou = YES.
            
            FIND FIRST docum-est 
                 WHERE docum-est.serie-docto  = embarq-import-docto.cod-ser-docto             
                   AND docum-est.nro-docto    = embarq-import-docto.cod-docto                 
                   AND docum-est.cod-emitente = embarq-import-docto.cdn-emitente              
                   AND docum-est.nat-operacao = embarq-import-docto.cod-natur-operac NO-LOCK NO-ERROR.
                 
            IF AVAIL docum-est THEN DO:
                IF AVAIL invoice-emb-imp THEN
                    ASSIGN c-mensagem = TRIM(c-mensagem) + ", Nota Fiscal":U. 
                ELSE
                    ASSIGN c-mensagem = TRIM(c-mensagem) + "Nota Fiscal":U. 
                     
                IF docum-est.ap-atual THEN
                     ASSIGN c-mensagem = trim(c-mensagem) + ", T¡tulo no Contas a Pagar":U. 
                LEAVE.
            END.
        END.

        IF NOT l-entrou THEN DO:
            FOR EACH docum-est 
               WHERE docum-est.cod-estabel  = p-cod-estabel 
                 AND docum-est.cod-emitente = ordem-compra.cod-emitente NO-LOCK:
        
                {cdp/cd4300.i4   "yes" docum-est.char-1}
                {rep/re1001a.i51 "yes"}
        
                IF c-embarque = ordens-embarque.embarque THEN DO:
                    IF AVAIL invoice-emb-imp THEN
                        ASSIGN c-mensagem = TRIM(c-mensagem) + ", Nota Fiscal":U. 
                    ELSE
                        ASSIGN c-mensagem = TRIM(c-mensagem) + "Nota Fiscal":U. 
    
                    IF docum-est.ap-atual THEN
                        ASSIGN c-mensagem = trim(c-mensagem) + ", T¡tulo no Contas a Pagar":U. 
                    LEAVE.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE Return_numRowsReturned:
/*------------------------------------------------------------------------------
  Purpose: Conta o numero de ordens para um embarque
  Parameters:  INPUT - c-cod-estabel (character) - codigo do estabelecimento
               INPUT - c-embarque (character) - codigo do embarque
               OUTPUT - inumRowsReturned (integer) - quantidade de ordens
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-cod-estabel    LIKE embarque-imp.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER c-embarque       LIKE embarque-imp.embarque    NO-UNDO.
    DEFINE OUTPUT PARAMETER inumRowsReturned AS INTEGER                    NO-UNDO.

    DEFINE VARIABLE i-cont AS INTEGER INITIAL 0 NO-UNDO.

    FOR EACH ordens-embarque 
       WHERE ordens-embarque.cod-estabel = c-cod-estabel 
         AND ordens-embarque.embarque    = c-embarque    NO-LOCK:
             ASSIGN i-cont = i-cont + 1.
    END.

    ASSIGN inumRowsReturned = i-cont.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE validateFields:
/*------------------------------------------------------------------------------
  Purpose: Posiciona rowObject e executa metodos para validacao dos campos
  Parameters: <none> 
  Notes:       
------------------------------------------------------------------------------*/
    
    FIND FIRST rowObject NO-LOCK NO-ERROR.
 
    RUN startMethod ("validateFields":U).    
     
    RUN endMethod ("validateFields":U).
 
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
        WHEN "cod-natur-of"          THEN c-value = RowObject.cod-natur-of.
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

PROCEDURE pi-recebe-idioma:
/*------------------------------------------------------------------------------
  Purpose: receber o idioma do usu˜rio.
  Parameters: INPUT - c_cod_idiom_usuar (character) - Idioma do usuario
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c_cod_idiom_usuar AS CHARACTER FORMAT "x(12)":U NO-UNDO.

    ASSIGN c-cod-idiom-usuar = c_cod_idiom_usuar.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE calcularTotalembarque:
/*------------------------------------------------------------------------------
  Purpose: Calcula o valor total das ordens de um embarque na moeda 0
  Parameters: INPUT - p-cod-estabel (character) - codigo do estabelecimento
              INPUT - p-embarque (character) - codigo do embarque
              OUTPUT - i-mo-codigo-orig (integer) - codigo da moeda
              OUTPUT - de-valor-ordens (decimal) - valor calculado pela procedure
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel    LIKE embarque-imp.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER p-embarque       LIKE embarque-imp.embarque     NO-UNDO.
    DEFINE OUTPUT PARAMETER i-mo-codigo-orig LIKE cotacao-item.mo-codigo    NO-UNDO.
    DEFINE OUTPUT PARAMETER de-valor-ordens  LIKE cotacao-item.preco-unit   NO-UNDO.
    
    DEFINE VARIABLE de-valor-aux  LIKE cotacao-item.preco-unit NO-UNDO.
    DEFINE VARIABLE de-quantidade LIKE prazo-compra.quantidade NO-UNDO. 
    DEFINE VARIABLE i-mo-codigo   LIKE cotacao-item.mo-codigo  NO-UNDO.
    DEFINE VARIABLE l-primeira    AS LOGICAL INITIAL NO        NO-UNDO.

    FOR EACH ordens-embarque FIELDS(numero-ordem quantidade)
       WHERE ordens-embarque.cod-estabel = p-cod-estabel 
         AND ordens-embarque.embarque    = p-embarque NO-LOCK:

        FOR FIRST ordem-compra FIELDS(num-pedido numero-ordem it-codigo cod-emitente)
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:

            ASSIGN de-quantidade = ordens-embarque.quantidade.

            FOR FIRST cotacao-item FIELDS(mo-codigo preco-unit) 
                WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                  AND cotacao-item.it-codigo    = ordem-compra.it-codigo    
                  AND cotacao-item.cod-emitente = ordem-compra.cod-emitente 
                  AND cotacao-item.cot-aprovada NO-LOCK :

                IF NOT l-primeira THEN DO:
                   ASSIGN i-mo-codigo = cotacao-item.mo-codigo
                          l-primeira  = YES.
                END.

                ASSIGN de-valor-aux = cotacao-item.preco-unit.

                IF cotacao-item.mo-codigo <> i-mo-codigo THEN DO:
                    RUN cdp/cd0812.p (INPUT  cotacao-item.mo-codigo,
                                      INPUT  i-mo-codigo,
                                      INPUT  cotacao-item.preco-unit,
                                      INPUT  TODAY,
                                      OUTPUT de-valor-aux).

                    IF de-valor-aux = 0 OR de-valor-aux = ? THEN
                        ASSIGN de-valor-aux = cotacao-item.preco-unit.
                END.
                ASSIGN de-valor-ordens = de-valor-ordens + 
                                        (de-valor-aux * de-quantidade).
            END.
        END.
    END.
    ASSIGN i-mo-codigo-orig = i-mo-codigo.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateDelete:
/*------------------------------------------------------------------------------
  Purpose: Valida Delete
  Parameters: INPUT-OUTPUT - r-chave (rowid) - rowid do registro
              OUTPUT TABLE - tt-bo-erro - TempTable com erros ocorridos durante o processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER r-chave AS ROWID NO-UNDO.
    DEFINE OUTPUT       PARAMETER TABLE FOR tt-bo-erro.
    
    DEFINE VARIABLE de-soma-quantidade AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999":U NO-UNDO.
    DEFINE VARIABLE de-taxa-siscomex   AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999":U NO-UNDO.
    DEFINE VARIABLE h-bocx315          AS HANDLE                                 NO-UNDO.
    DEFINE VARIABLE i-nr-ordens        AS INTEGER                                NO-UNDO.
    DEFINE VARIABLE i-pto-embarque     LIKE pto-contr.cod-pto-contr              NO-UNDO.
    
    DEFINE BUFFER bfeq-embarq-praz-compra FOR eq-embarq-praz-compra.
    
    IF NOT VALID-HANDLE(h-bocx150) THEN
        RUN cxbo/bocx150.p PERSISTENT SET h-bocx150.

    IF NOT VALID-HANDLE(h-bocx140) THEN
    	RUN cxbo/bocx140.p PERSISTENT SET h-bocx140.

    IF NOT VALID-HANDLE(h-bocx315) THEN
        RUN cxbo/bocx315.p PERSISTENT SET h-bocx315.
        
    IF NOT VALID-HANDLE (h-bocx00488) THEN
        RUN cxbo/bocx00488.p PERSISTENT SET h-bocx00488.
 
    {imp/im0045.i50} /* tratamento atributo livre */
    
    EMPTY TEMP-TABLE tt-desp.
    EMPTY TEMP-TABLE tt-cot-desp.
    EMPTY TEMP-TABLE tt-bo-erro.
    
    RUN InitializeValidate.
    
    FIND FIRST ordens-embarque 
         WHERE ROWID(ordens-embarque) = r-chave EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL ordens-embarque THEN DO:

        IF TRIM(SUBSTRING(ordens-embarque.char-1,1,20)) <> "" THEN DO:

           FOR FIRST ordem-compra NO-LOCK
               WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem,
               FIRST pedido-drb NO-LOCK
               WHERE pedido-drb.cod-estabel        = ordens-embarque.cod-estabel
                 AND pedido-drb.nr-ato-concessorio = TRIM(SUBSTRING(ordens-embarque.char-1,1,20)), /* numero do ato concessorio antigo (antes de ser alterado) */
               FIRST pedido-drb-item NO-LOCK
               WHERE pedido-drb-item.cod-estabel   = pedido-drb.cod-estabel
                 AND pedido-drb-item.nr-pedido-drb = pedido-drb.nr-pedido-drb
                 AND pedido-drb-item.it-codigo     = ordem-compra.it-codigo:

              CREATE tt-pedido-drb-item.
              BUFFER-COPY pedido-drb-item TO tt-pedido-drb-item.
              ASSIGN tt-pedido-drb-item.qtd-alocada-import = pedido-drb-item.qtd-alocada-import - ordens-embarque.quantidade
                     tt-pedido-drb-item.r-rowid            = ROWID(pedido-drb-item).

              RUN openQueryStatic IN h-bocx315 (INPUT "Main":U).
              RUN goToKey         IN h-bocx315 (INPUT tt-pedido-drb-item.cod-estabel,
                                                INPUT tt-pedido-drb-item.nr-pedido-drb,
                                                INPUT tt-pedido-drb-item.it-codigo).
              IF RETURN-VALUE = "OK":U THEN DO:
                  RUN emptyRowErrors  IN h-bocx315.
                  RUN emptyRowObject  IN h-bocx315.
                  RUN setRecord       IN h-bocx315 (INPUT TABLE tt-pedido-drb-item).
                  RUN updateRecord    IN h-bocx315.
              END.
              DELETE tt-pedido-drb-item.
           END.
        END.

        IF  CAN-FIND(FIRST decla-import-ord
                     WHERE decla-import-ord.cod-embarq  = ordens-embarque.embarque
                       AND decla-import-ord.num-ordem   = ordens-embarque.numero-ordem
                       AND decla-import-ord.num-parcela = ordens-embarque.parcela
                       AND decla-import-ord.cod-estab   = ordens-embarque.cod-estabel) THEN DO:
            FOR FIRST decla-import-ord NO-LOCK
                WHERE decla-import-ord.cod-embarq  = ordens-embarque.embarque    
                  AND decla-import-ord.num-ordem   = ordens-embarque.numero-ordem
                  AND decla-import-ord.num-parcela = ordens-embarque.parcela     
                  AND decla-import-ord.cod-estab   = ordens-embarque.cod-estabel,
                FIRST decla-import NO-LOCK
                WHERE decla-import.num-di-ems = decla-import-ord.num-di-ems:

                IF  decla-import.cod-di-siscomex <> ""
                AND CAN-FIND(FIRST docum-est
                             WHERE docum-est.declaracao-import = decla-import.cod-di-siscomex) THEN DO:
                    
                    {utp/ut-liter.i "ExclusÆo_nÆo_permitida" *}
                    ASSIGN c-lbl-liter = TRIM(RETURN-VALUE) + '!':U.
                    {utp/ut-liter.i "Ordem_Embarque_possui_relacionamento_ativo_com_Declara‡Æo_de_Importa‡Æo_e_Nota_Gerada_no_Recebimento" *}

                    RUN criaTTBoErro(INPUT 17006, INPUT c-lbl-liter + "~~":U + TRIM(RETURN-VALUE) + '!':U).

                    UNDO, RETURN.
                END. /* IF  decla-import.cod-di-siscomex ... */
            END. /* FOR FIRST decla-import-ord */
        END. /* IF  CAN-FIND(FIRST decla-import-ord */

        FOR FIRST processo-imp 
            WHERE processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp 
              AND processo-imp.cod-estabel = ordens-embarque.cod-estabel NO-LOCK:
        END.

        IF NOT AVAIL processo-imp THEN
            NEXT.

        EMPTY TEMP-TABLE tt-ordens.

        FOR FIRST embarque-imp FIELDS(cdn-pto-desembar cdn-pto-chegad) NO-LOCK
            WHERE embarque-imp.cod-estabel = ordens-embarque.cod-estabel
              AND embarque-imp.embarque = ordens-embarque.embarque: END.
            
        FOR FIRST historico-embarque FIELDS(dt-efetiva embarque) 
            WHERE historico-embarque.cod-estabel   = ordens-embarque.cod-estabel 
              AND historico-embarque.embarque      = ordens-embarque.embarque    
              AND historico-embarque.cod-itiner    = processo-imp.cod-itiner     
              AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad NO-LOCK: 
        END.

        IF AVAIL historico-embarque THEN DO:
            IF historico-embarque.dt-efetiva <> ? THEN DO:

                RUN criaTTBoErro(INPUT 27733, INPUT historico-embarque.embarque + "~~":U + STRING(embarque-imp.cdn-pto-chegad)).
                
                UNDO, RETURN.
            END.
        END.
        
        IF VALID-HANDLE(h-bocx00488) then do:
            ASSIGN vd-cod-duimp-dts = 0.
            RUN piValidaEmbarqueDuimp in h-bocx00488 (INPUT  embarque-imp.cod-estabel,
                                                      INPUT  embarque-imp.embarque,
                                                      OUTPUT vd-cod-duimp-dts).
            IF vd-cod-duimp-dts <> 0 THEN DO:
                {utp/ut-liter.i "Desvincula‡Æo" *}
                ASSIGN c-lbl-liter-e[1] = TRIM(RETURN-VALUE).
                {utp/ut-liter.i "Embarque_j " *}
                ASSIGN c-lbl-liter-e[2] = TRIM(RETURN-VALUE).
                {utp/ut-liter.i "…_DUIMP_No." *}
                ASSIGN c-lbl-liter-e[3] = TRIM(RETURN-VALUE).
                RUN criaTTBoErro(INPUT 27414,
                                 INPUT c-lbl-liter-e[1] + "~~":U 
                                     + c-lbl-liter-e[2] + "~~":U
                                     + c-lbl-liter-e[3] + STRING(vd-cod-duimp-dts)).
                                     
                UNDO, RETURN.
            END.
        END.

        FOR EACH b-ordens-embarque
           WHERE b-ordens-embarque.cod-estabel  = ordens-embarque.cod-estabel 
             AND b-ordens-embarque.embarque     = ordens-embarque.embarque NO-LOCK USE-INDEX embarque:

            ASSIGN i-nr-ordens = i-nr-ordens + 1.
        END.            
        
        IF i-nr-ordens = 1 THEN DO:
            
            ASSIGN c-meio-transporte = FILL(" ",20).

            FIND FIRST embarque-imp 
                 WHERE embarque-imp.cod-estabel = ordens-embarque.cod-estabel
                   AND embarque-imp.embarque    = ordens-embarque.embarque EXCLUSIVE-LOCK NO-ERROR.
            
            IF AVAIL embarque-imp THEN DO:                    
                
                {imp/im0045.i51 no}
                {cdp/cd4300.i4  no embarque-imp.char-1}

                ASSIGN embarque-imp.cdn-pto-despch        = 0 
                       embarque-imp.cdn-pto-embarq        = 0
                       embarque-imp.cdn-pto-desembar      = 0
                       embarque-imp.cdn-pto-chegad        = 0
                       OVERLAY(embarque-imp.char-1,81,5)  = "":U. /* pto eadi */
                       OVERLAY(embarque-imp.char-1,86,5)  = "":U. /* pto recebimento */
            END.
            FOR EACH decl-hist-embarq-imp 
               WHERE decl-hist-embarq-imp.cod-estabel = ordens-embarque.cod-estabel 
                 AND decl-hist-embarq-imp.embarque    = ordens-embarque.embarque
                 AND decl-hist-embarq-imp.cod-itiner  = processo-imp.cod-itiner EXCLUSIVE-LOCK USE-INDEX codigo:

                DELETE decl-hist-embarq-imp.
            END.
            FOR EACH historico-embarque 
                WHERE historico-embarque.cod-estabel = ordens-embarque.cod-estabel 
                  AND historico-embarque.embarque    = ordens-embarque.embarque EXCLUSIVE-LOCK USE-INDEX codigo:

                DELETE historico-embarque.
            END.
            FOR EACH desp-embarque 
               WHERE desp-embarque.cod-estabel = ordens-embarque.cod-estabel 
                 AND desp-embarque.embarque    = ordens-embarque.embarque EXCLUSIVE-LOCK USE-INDEX despesa:

                DELETE desp-embarque.
            END.
        END.
        ELSE DO:

            RUN geraTTDespesasordem(INPUT ordens-embarque.cod-estabel,
                                    INPUT ordens-embarque.embarque).
            FOR EACH tt-cot-desp 
               WHERE tt-cot-desp.numero-ordem = ordens-embarque.numero-ordem
                 AND tt-cot-desp.parcela      = ordens-embarque.parcela:
                
                FIND FIRST desp-embarque
                     WHERE desp-embarque.cod-estabel = ordens-embarque.cod-estabel
                       AND desp-embarque.embarque    = ordens-embarque.embarque
                       AND desp-embarque.cod-desp    = tt-cot-desp.cod-desp EXCLUSIVE-LOCK NO-ERROR.
                
                IF AVAIL desp-embarque THEN DO:
                    ASSIGN desp-embarque.val-desp = desp-embarque.val-desp - tt-cot-desp.val-rateio.
                    
                    IF desp-embarque.val-desp <= 0 THEN
                        DELETE desp-embarque.
                END.
            END.
        END.
        
        /* **** Acertar o Valor do Rateio proporcional da Taxa Siscomex **** */
        FIND FIRST param-imp 
             WHERE param-imp.cod-estabel = ordens-embarque.cod-estabel NO-LOCK NO-ERROR.

        ASSIGN de-soma-quantidade = 0.

        IF ordens-embarque.val-tax-siscomex > 0 THEN DO:

            FOR EACH b-ordens-embarque
               WHERE b-ordens-embarque.cod-estabel  = ordens-embarque.cod-estabel 
                 AND b-ordens-embarque.embarque     = ordens-embarque.embarque
                 AND b-ordens-embarque.num-adic     = ordens-embarque.num-adic NO-LOCK USE-INDEX embarque:

                ASSIGN de-soma-quantidade = de-soma-quantidade + b-ordens-embarque.quantidade.
            END.
            
            ASSIGN de-taxa-siscomex = (ordens-embarque.val-tax-siscomex * ordens-embarque.quantidade) / de-soma-quantidade.
            
            FIND FIRST desp-embarque 
                 WHERE desp-embarque.cod-estabel = ordens-embarque.cod-estabel
                   AND desp-embarque.embarque    = ordens-embarque.embarque
                   AND desp-embarque.cod-desp    = param-imp.cdn-despes-siscomex EXCLUSIVE-LOCK NO-ERROR.

            IF  AVAIL desp-embarque THEN
               ASSIGN desp-embarque.val-desp = desp-embarque.val-desp - de-taxa-siscomex.
            
            FOR EACH b-ordens-embarque 
               WHERE b-ordens-embarque.cod-estabel  = ordens-embarque.cod-estabel 
                 AND b-ordens-embarque.embarque     = ordens-embarque.embarque
                 AND b-ordens-embarque.num-adic     = ordens-embarque.num-adic EXCLUSIVE-LOCK USE-INDEX embarque:

                ASSIGN b-ordens-embarque.val-tax-siscomex = b-ordens-embarque.val-tax-siscomex - de-taxa-siscomex.
            END.
        END.
        
        FIND FIRST prazo-compra  
             WHERE prazo-compra.numero-ordem    = ordens-embarque.numero-ordem
               AND prazo-compra.parcela         = ordens-embarque.parcela EXCLUSIVE-LOCK NO-ERROR.
       
        IF AVAIL prazo-compra AND prazo-compra.data-entrega-ant <> ? THEN DO:
             
             IF prazo-compra.data-entrega <> prazo-compra.data-entrega-ant THEN DO:
                 FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem EXCLUSIVE-LOCK NO-ERROR.  

                    /* Criar Registro na tabela alt-ped */
                    {cxbo/bocx140.i03 today 
                       c-seg-usuario 
                       ordem-compra.num-pedido
                       ordem-compra.numero-ordem 
                       prazo-compra.parcela
                       prazo-compra.data-entrega
                       ?
                       ?
                       ordem-compra.cod-emitente
                       ordem-compra.gera-edi
                       ordem-compra.num-pedido
                       prazo-compra.data-entrega-ant}   
             END. 
             ASSIGN prazo-compra.data-entrega = prazo-compra.data-entrega-ant.
        END.
                
        IF CAN-FIND(FIRST ordens-embarque-trib WHERE ordens-embarque-trib.cod-estabel  = ordens-embarque.cod-estabel
                                               AND   ordens-embarque-trib.embarque     = ordens-embarque.embarque
                                               AND   ordens-embarque-trib.numero-ordem = ordens-embarque.numero-ordem
                                               AND   ordens-embarque-trib.parcela      = ordens-embarque.parcela) THEN DO:
            FOR EACH ordens-embarque-trib WHERE ordens-embarque-trib.cod-estabel  = ordens-embarque.cod-estabel
                                          AND   ordens-embarque-trib.embarque     = ordens-embarque.embarque
                                          AND   ordens-embarque-trib.numero-ordem = ordens-embarque.numero-ordem
                                          AND   ordens-embarque-trib.parcela      = ordens-embarque.parcela
                                          EXCLUSIVE-LOCK:
                DELETE ordens-embarque-trib.
            END.
        END.
        
        FOR EACH ct-trib-item-doc-est EXCLUSIVE-LOCK
            WHERE ct-trib-item-doc-est.cod-embarq  = ordens-embarque.embarque
            AND   ct-trib-item-doc-est.num-ordem   = ordens-embarque.numero-ordem
            AND   ct-trib-item-doc-est.num-parcela = ordens-embarque.parcela
            AND   ct-trib-item-doc-est.cod-estab   = ordens-embarque.cod-estab:
            DELETE ct-trib-item-doc-est.
        END.

        RUN executeDelete.

        {cxbo/bocx225.i3}
        
        /*
        ** Verifica/atualiza situacao do processo
        */
        RUN atualizaSituacaoProcesso IN h-bocx140 (INPUT processo-imp.cod-estabel,
                                                   INPUT processo-imp.nr-proc-imp,
                                                   OUTPUT TABLE tt-bo-erro). 
        

        IF CAN-FIND(FIRST tt-bo-erro) THEN
            RETURN "NOK":U.
        ELSE
            RETURN "OK":U.
    END.
    
 
    IF l-query THEN
        GET NEXT {&QUERY-NAME} NO-LOCK NO-WAIT.
    ELSE
        FIND NEXT ordens-embarque NO-LOCK NO-ERROR.

    IF NOT AVAIL ordens-embarque THEN DO:
       IF l-query THEN
           GET PREV {&QUERY-NAME} NO-LOCK NO-WAIT.
       ELSE
           FIND PREV ordens-embarque NO-LOCK NO-ERROR.
    END.
    ASSIGN r-chave = ROWID(ordens-embarque).

    RETURN "".

    FINALLY:
        IF  VALID-HANDLE(h-bocx140) THEN DO:
    	    DELETE PROCEDURE h-bocx140.
            ASSIGN h-bocx140 = ?.
        END.

        IF VALID-HANDLE (h-bocx150) THEN DO:
            DELETE PROCEDURE h-bocx150.
            ASSIGN h-bocx150 = ?.
        END.

        IF VALID-HANDLE(h-bocx315) THEN DO:
            DELETE PROCEDURE h-bocx315.
            ASSIGN h-bocx315 = ?.
        END.
        
        IF  VALID-HANDLE (h-bocx00488) THEN DO:
            DELETE PROCEDURE h-bocx00488.
            ASSIGN h-bocx00488 = ?.
        END.
    END FINALLY.
END PROCEDURE.

PROCEDURE geraTTDespesasordem:
/*------------------------------------------------------------------------------
  Purpose: Prepara temp-table para que as despesas (desp-embarque) que sejam referentes a ordem que est˜ 
           sendo eliminada, sejam eliminadas de maneira proporcional a quantidade que est˜ sendo eliminada
  Parameters: INPUT - p-cod-estabel (character) - codigo do estabelecimento
              INPUT - p-embarque (character) - codigo do embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel LIKE ordens-embarque.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-embarque    LIKE embarque-imp.embarque       NO-UNDO.
    
    DEFINE VARIABLE i-cod-desp-maior  LIKE desp-imp.cod-desp         NO-UNDO.
    DEFINE VARIABLE i-num-ordem-maior LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE VARIABLE de-maior-valor    LIKE cotacao-item-cex.val-desp NO-UNDO.
    DEFINE VARIABLE de-total-rateio   LIKE cotacao-item-cex.val-desp NO-UNDO.
    DEFINE VARIABLE de-conv-val-cex   LIKE cotacao-item-cex.val-desp NO-UNDO.
    
    FOR EACH desp-embarque
       WHERE desp-embarque.cod-estabel = p-cod-estabel
         AND desp-embarque.embarque    = p-embarque no-lock USE-INDEX despesa:
        
        FOR EACH b-ordens-embarque
           WHERE b-ordens-embarque.cod-estabel = p-cod-estabel
             AND b-ordens-embarque.embarque    = p-embarque NO-LOCK USE-INDEX embarque:
            
            FOR FIRST ordem-compra FIELDS(num-pedido numero-ordem cod-emitente it-codigo)
                WHERE ordem-compra.numero-ordem = b-ordens-embarque.numero-ordem NO-LOCK: 
            END.
            
            FOR FIRST cotacao-item FIELDS(char-1 data-cotacao seq-cotac)
                WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                  AND cotacao-item.cot-aprovada NO-LOCK: 
            END.
            
            {ccp/cc9019.i50}
            {cdp/cd4300.i4 "yes" cotacao-item.char-1}
            {ccp/cc9019.i51 "yes"}
            
            FOR FIRST cotacao-item-cex FIELDS(val-desp mo-codigo)
                WHERE cotacao-item-cex.numero-ordem      = b-ordens-embarque.numero-ordem 
                  AND cotacao-item-cex.cod-emitente      = ordem-compra.cod-emitente
                  AND cotacao-item-cex.it-codigo         = ordem-compra.it-codigo
                  AND cotacao-item-cex.seq-cotac         = cotacao-item.seq-cotac
                  AND cotacao-item-cex.data-cotacao      = cotacao-item.data-cotacao
                  AND cotacao-item-cex.mapa-cotacao      = i-mapa-cotacao-i50
                  AND cotacao-item-cex.cod-incoterm      = c-cod-incoterm-i50
                  AND cotacao-item-cex.cod-itiner        = desp-embarque.cod-itiner
                  AND cotacao-item-cex.cod-emitente-desp = desp-embarque.cod-emitente-desp
                  AND cotacao-item-cex.cod-desp          = desp-embarque.cod-desp NO-LOCK:

                FIND FIRST tt-desp
                     WHERE tt-desp.cod-desp = desp-embarque.cod-desp NO-ERROR.
                
                IF NOT AVAIL tt-desp THEN DO:
                    CREATE tt-desp.
                    ASSIGN tt-desp.cod-desp    = desp-embarque.cod-desp
                           tt-desp.val-tot-emb = desp-embarque.val-desp.
                END.            
                ASSIGN tt-desp.quant-total = tt-desp.quant-total + b-ordens-embarque.quantidade
                       tt-desp.l-cotada    = YES.
                
                ASSIGN de-conv-val-cex = cotacao-item-cex.val-desp.

                IF cotacao-item-cex.mo-codigo <> desp-embarque.mo-codigo THEN DO:
                    RUN cdp/cd0812.p (INPUT  cotacao-item-cex.mo-codigo,
                                      INPUT  desp-embarque.mo-codigo,
                                      INPUT  cotacao-item-cex.val-desp,
                                      INPUT  TODAY,
                                      OUTPUT de-conv-val-cex).
                    IF de-conv-val-cex = 0 OR de-conv-val-cex = ? THEN 
                        ASSIGN de-conv-val-cex = cotacao-item-cex.val-desp.
                END.
                
                CREATE tt-cot-desp.
                ASSIGN tt-cot-desp.cod-desp     = desp-embarque.cod-desp
                       tt-cot-desp.numero-ordem = b-ordens-embarque.numero-ordem
                       tt-cot-desp.parcela      = b-ordens-embarque.parcela
                       tt-cot-desp.quantidade   = b-ordens-embarque.quantidade
                       tt-desp.val-tot-desp     = tt-desp.val-tot-desp +
                                                 (de-conv-val-cex * b-ordens-embarque.quantidade)
                       tt-cot-desp.val-desp     = de-conv-val-cex.
            END.
        END.
    END.
    
    ASSIGN de-maior-valor    = 0
           de-total-rateio   = 0
           i-cod-desp-maior  = 0.
           
    /* Rateio dos valores */
    FOR EACH tt-cot-desp 
          BY tt-cot-desp.cod-desp:
    
        IF i-cod-desp-maior <> tt-cot-desp.cod-desp THEN
            ASSIGN de-maior-valor = 0.

        ASSIGN i-cod-desp-maior = tt-cot-desp.cod-desp.
        
        FIND FIRST tt-desp
             WHERE tt-desp.cod-desp = tt-cot-desp.cod-desp NO-ERROR.
        
        IF tt-desp.l-cotada THEN
            ASSIGN tt-cot-desp.val-rateio = (tt-desp.val-tot-emb * (tt-cot-desp.val-desp * tt-cot-desp.quantidade)) / 
                                            (tt-desp.val-tot-desp).

        ASSIGN tt-desp.val-tot-rateio = tt-desp.val-tot-rateio + tt-cot-desp.val-rateio.

        IF de-maior-valor < tt-cot-desp.val-rateio THEN
            ASSIGN tt-desp.maior-ordem   = tt-cot-desp.numero-ordem
                   tt-desp.maior-parcela = tt-cot-desp.parcela
                   de-maior-valor        = tt-cot-desp.val-rateio.
    END.
    
    /* Acerto do valor do rateio por causa do arredondamento */
    FOR EACH tt-desp USE-INDEX codigo:

        FIND FIRST tt-cot-desp 
             WHERE tt-cot-desp.cod-desp     = tt-desp.cod-desp
               AND tt-cot-desp.numero-ordem = tt-desp.maior-ordem
               AND tt-cot-desp.parcela      = tt-desp.maior-parcela NO-ERROR.

        ASSIGN tt-cot-desp.val-rateio  = tt-cot-desp.val-rateio + (tt-desp.val-tot-emb - tt-desp.val-tot-rateio).
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE AtualizaEmbarqueAtoConcessorio:
/*------------------------------------------------------------------------------
  Purpose: Arualiza embarques relacionados ao ato concessorio 
  Parameters: INPUT - p-cod-estabel (character) - codigo do estabelecimento
              INPUT - p-embarque (character) - codigo do embarque
              INPUT - c-ato-concessorio (character) - codigo ato concessorio
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-cod-estabel     LIKE ordens-embarque.cod-estabel NO-UNDO.
    DEFINE INPUT PARAM p-embarque        LIKE ordens-embarque.embarque    NO-UNDO.
    DEFINE INPUT PARAM c-ato-concessorio AS CHARACTER                     NO-UNDO.

    FOR EACH b-ordens-embarque 
       WHERE b-ordens-embarque.cod-estabel = p-cod-estabel
         AND b-ordens-embarque.embarque    = p-embarque NO-LOCK:

        RUN AtualizaOrdEmbAtoConce (INPUT b-ordens-embarque.numero-ordem,
                                    INPUT b-ordens-embarque.parcela,
                                    INPUT c-ato-concessorio).
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getAtoConcessorioEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Retorna ato concessorio do embarque
  Parameters: INPUT - p-cod-estabel (character) - codigo do estabelecimento
              INPUT - p-embarque (character) - codigo do embarque
              OUTPUT - c-ato-concessorio (character) - codigo ato concessorio
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM p-cod-estabel     LIKE ordens-embarque.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAM p-embarque        LIKE ordens-embarque.embarque    NO-UNDO.
    DEFINE OUTPUT PARAM c-ato-concessorio AS CHARACTER                     NO-UNDO.

    FIND FIRST param-imp 
         WHERE param-imp.cod-estabel = p-cod-estabel NO-LOCK NO-ERROR.
    
    IF  (AVAIL param-imp AND SUBSTRING(param-imp.char-1,249,1) = "S":U) 
    AND i-pais-impto-usuario <> 1 THEN DO:

        FOR FIRST b-ordens-embarque NO-LOCK
            WHERE b-ordens-embarque.cod-estabel = p-cod-estabel
              AND b-ordens-embarque.embarque    = p-embarque:

            IF TRIM(SUBSTRING(b-ordens-embarque.char-1,1,20)) <> "" THEN
                ASSIGN c-ato-concessorio = TRIM(SUBSTRING(b-ordens-embarque.char-1,1,20)).
        END.
    END.
    ELSE 
        ASSIGN c-ato-concessorio = "".

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE AtualizaOrdEmbAtoConce:
/*------------------------------------------------------------------------------
  Purpose: Atualiza a quantidade do ato concessorio relacionado a ordem/embarque
  Parameters: INPUT - i-num-ordem (integer) - codigo da ordem de compra
              INPUT - i-parcela (integer) - numero da parcela da ordem de compra
              OUTPUT - c-ato-concessorio (character) - codigo ato concessorio
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAM i-num-ordem       LIKE ordens-embarque.numero-ordem NO-UNDO.
   DEFINE INPUT PARAM i-parcela         LIKE ordens-embarque.parcela      NO-UNDO.
   DEFINE INPUT PARAM c-ato-concessorio AS CHARACTER                      NO-UNDO.

   DEFINE VARIABLE h-bocx315 AS HANDLE NO-UNDO.

   IF NOT VALID-HANDLE(h-bocx315) THEN
       RUN cxbo/bocx315.p PERSISTENT SET h-bocx315.

   FIND FIRST ordens-embarque 
        WHERE ordens-embarque.numero-ordem = i-num-ordem 
          AND ordens-embarque.parcela      = i-parcela EXCLUSIVE-LOCK no-error.

   IF AVAIL ordens-embarque THEN DO:

      IF  TRIM(SUBSTRING(ordens-embarque.char-1,1,20)) <> "" 
      AND TRIM(SUBSTRING(ordens-embarque.char-1,1,20)) <> c-ato-concessorio THEN DO:
          
          FOR FIRST ordem-compra NO-LOCK
              WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem,
              FIRST pedido-drb NO-LOCK
              WHERE pedido-drb.cod-estabel = ordens-embarque.cod-estabel
                AND pedido-drb.nr-ato-concessorio = trim(SUBSTRING(ordens-embarque.char-1,1,20)), /* numero do ato concessorio antigo (antes de ser alterado) */
              FIRST pedido-drb-item NO-LOCK
              WHERE pedido-drb-item.cod-estabel   = pedido-drb.cod-estabel
                AND pedido-drb-item.nr-pedido-drb = pedido-drb.nr-pedido-drb
                AND pedido-drb-item.it-codigo     = ordem-compra.it-codigo:

              CREATE tt-pedido-drb-item.
              BUFFER-COPY pedido-drb-item TO tt-pedido-drb-item.
              ASSIGN tt-pedido-drb-item.qtd-alocada-import = pedido-drb-item.qtd-alocada-import - ordens-embarque.quantidade
                     tt-pedido-drb-item.r-rowid            = ROWID(pedido-drb-item).
              
              RUN openQueryStatic IN h-bocx315 (INPUT "Main":U).
              RUN goToKey         IN h-bocx315 (INPUT tt-pedido-drb-item.cod-estabel,
                                                INPUT tt-pedido-drb-item.nr-pedido-drb,
                                                INPUT tt-pedido-drb-item.it-codigo).
              IF RETURN-VALUE = "OK":U THEN DO:
                  RUN emptyRowErrors  IN h-bocx315.
                  RUN emptyRowObject  IN h-bocx315.
                  RUN setRecord       IN h-bocx315 (INPUT TABLE tt-pedido-drb-item).
                  RUN updateRecord    IN h-bocx315.
              END.
              DELETE tt-pedido-drb-item.
          END.
      END.

      {imp/im0045ab.i50}
      ASSIGN c-nr-ato-concessorio = c-ato-concessorio.
      {imp/im0045ab.i51 "no"}
      {cdp/cd4300.i4 "no" ordens-embarque.char-1}
   END.

   IF VALID-HANDLE(h-bocx315) THEN DO:
       DELETE PROCEDURE h-bocx315.
       ASSIGN h-bocx315 = ?.
   END.

   RETURN "OK":U.
END PROCEDURE.

{imp/im9025.i1} /* Procedure pi-calculaQtdeDisponivel */
{imp/im9025.i2} /* Procedure pi-calculaQtdeDisponivelFornec */

/*******************************************************************************
** Objetivo: - C˜lculo da quantidade disponðvel;
**           - Cria¯Êo das Ordens de Embarque;
**           - Cria¯Êo Hist¢rico Embarque;
**           - Cria¯Êo das Despesas do Embarque;
**           - Atualiza¯Êo Situa¯Êo Processo Importa¯Êo. 
**
********************************************************************************/

PROCEDURE setCreatehist:
/*------------------------------------------------------------------------------
  Purpose: Indica que nao sera criado historico do processo de importacao
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN l-create-hist = NO.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validavinculacaoordens:
/*------------------------------------------------------------------------------
  Purpose: Verifica se a ordem de compra j  est  vinculada ao outro embarque
  Parameters: INPUT - p-embarque (character) - codigo do embarque
              INPUT - p-cod-estabel (character) - codigo do estabelecimento
              INPUT - p-numero-ordem (integer) - numero da ordem de compra
              INPUT - p-parcela (integer) - numero da parcela da ordem de compra
              OUTPUT TABLE - tt-bo-erro - TempTable com os erros ocorridos durante o processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-embarque     LIKE ordens-embarque.embarque     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel  LIKE ordens-embarque.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER p-numero-ordem LIKE ordens-embarque.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAMETER p-parcela      LIKE ordens-embarque.parcela      NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro. 
    
    EMPTY TEMP-TABLE tt-bo-erro.
    
    IF NOT VALID-HANDLE (h-bocx00488) THEN
        RUN cxbo/bocx00488.p PERSISTENT SET h-bocx00488.
    
    IF VALID-HANDLE(h-bocx00488) then do:
        assign vd-cod-duimp-dts = 0.
        RUN piValidaEmbarqueDuimp in h-bocx00488 (input  p-cod-estabel,
                                                  input  p-embarque,
                                                  output vd-cod-duimp-dts).
        IF vd-cod-duimp-dts <> 0 THEN DO:
            {utp/ut-liter.i "Vincula‡Æo" *}
            ASSIGN c-lbl-liter-e[1] = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Embarque_j " *}
            ASSIGN c-lbl-liter-e[2] = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "…_DUIMP_No." *}
            ASSIGN c-lbl-liter-e[3] = TRIM(RETURN-VALUE).
            RUN criaTTBoErro(INPUT 27414,
                             input c-lbl-liter-e[1] + "~~":U 
                                 + c-lbl-liter-e[2] + "~~":U
                                 + c-lbl-liter-e[3] + string(vd-cod-duimp-dts)).
        END.
    end.
    
    IF  VALID-HANDLE (h-bocx00488) THEN DO:
        DELETE PROCEDURE h-bocx00488.
        ASSIGN h-bocx00488 = ?.
    END.

    IF p-parcela = 0 THEN DO:
        FOR EACH prazo-compra 
           WHERE prazo-compra.numero-ordem = p-numero-ordem 
             AND prazo-compra.situacao = 2 NO-LOCK:
            
            FIND FIRST ordens-embarque 
                 WHERE ordens-embarque.cod-estabel  = p-cod-estabel 
                   AND ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                   AND ordens-embarque.parcela      = prazo-compra.parcela NO-LOCK NO-ERROR.

            IF AVAIL ordens-embarque THEN DO:
                IF ordens-embarque.embarque <> p-embarque THEN DO:
                    IF ordens-embarque.quantidade < prazo-compra.quantidade THEN DO:

                        RUN criaTTBoErro(INPUT 29623, INPUT STRING(ordens-embarque.parcela)      + "~~":U + 
                                                            STRING(ordens-embarque.numero-ordem) + "~~":U + 
                                                            ordens-embarque.embarque).
                        
                        FOR EACH tt-epc WHERE tt-epc.cod-event = "parcelaEmbarqueGrendene":U:
                           DELETE tt-epc.
                        END.
                    
                        {include/i-epc200.i2 &CodEvent='"parcelaEmbarqueGrendene"'
                                             &CodParameter='"handle-tt-bo-erro"'
                                             &ValueParameter="STRING(buffer tt-bo-erro:HANDLE)"}
                                            
                        {include/i-epc201.i "parcelaEmbarqueGrendene"}

                        IF c-nom-prog-upc-mg97 <> "cxbo/gbocx225.p":U THEN DO:
                           UNDO, RETURN.
                        END.
                    END.
                END.
            END.
        END.
    END.
    ELSE DO:
        
        IF  CAN-FIND(FIRST ordens-embarque 
                     WHERE ordens-embarque.cod-estabel  = p-cod-estabel  
                       AND ordens-embarque.numero-ordem = p-numero-ordem 
                       AND ordens-embarque.parcela      = p-parcela)      THEN DO:
            
            FIND FIRST ordens-embarque 
                 WHERE ordens-embarque.cod-estabel  = p-cod-estabel  
                   AND ordens-embarque.numero-ordem = p-numero-ordem 
                   AND ordens-embarque.parcela      = p-parcela      NO-LOCK NO-ERROR.        

            IF AVAIL ordens-embarque THEN DO:
                
                IF ordens-embarque.embarque <> p-embarque THEN DO:

                    RUN criaTTBoErro(INPUT 29623, INPUT STRING(ordens-embarque.parcela)      + "~~":U + 
                                                        STRING(ordens-embarque.numero-ordem) + "~~":U + 
                                                        ordens-embarque.embarque).

                    FOR EACH tt-epc WHERE tt-epc.cod-event = "parcelaEmbarqueGrendene":U:
                        DELETE tt-epc.
                    END.
                
                    {include/i-epc200.i2 &CodEvent='"parcelaEmbarqueGrendene"'
                                         &CodParameter='"handle-tt-bo-erro"'
                                         &ValueParameter="STRING(buffer tt-bo-erro:HANDLE)"}
                                         
                    {include/i-epc201.i "parcelaEmbarqueGrendene"}

                    IF c-nom-prog-upc-mg97 <> "cxbo/gbocx225.p":U THEN DO:
                        UNDO, RETURN.
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE createOrdensEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Criacao das Ordens Embarque via Ordens de Compra.
  Parameters: INPUT - r-embarque (rowid) - rowid do embarque
              INPUT - p-numero-ordem (integer) - numero da ordem de compra
              INPUT - de-quant (decimal) - quantidade a ser criada a ordens-embarque
              OUTPUT TABLE - tt-bo-erro - TempTable com os erros ocorridos durante o processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER r-embarque        AS ROWID                       NO-UNDO.
    DEFINE INPUT  PARAMETER p-numero-ordem    LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAMETER de-quant          LIKE prazo-compra.quantidade   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.
    
    DEFINE VARIABLE c-msg            AS   CHARACTER                  NO-UNDO.
    DEFINE VARIABLE v-data           AS   DATE                       NO-UNDO.
    DEFINE VARIABLE v-parcela        AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE v-ordem          AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE l-existe-hist    AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE de-quant-disp    LIKE prazo-compra.quantidade    NO-UNDO.
    DEFINE VARIABLE de-quant-falta   LIKE ordens-embarque.quantidade NO-UNDO.
    DEFINE VARIABLE de-quant-parcela LIKE ordens-embarque.quantidade NO-UNDO.
    DEFINE VARIABLE de-conv-val-cex  LIKE cotacao-item-cex.val-desp  NO-UNDO.
    DEFINE VARIABLE i-pto-embarque   LIKE pto-contr.cod-pto-contr    NO-UNDO.
    DEFINE VARIABLE i-pto-chegada    LIKE pto-contr.cod-pto-contr    NO-UNDO.
    DEFINE VARIABLE i-cod-itiner     LIKE itinerario.cod-itiner      NO-UNDO.
    DEFINE VARIABLE i-num-pedido     LIKE pedido-compr.num-pedido    NO-UNDO.
    DEFINE VARIABLE i-numero-ordem   LIKE ordem-compra.numero-ordem  NO-UNDO.
    DEFINE VARIABLE c-it-codigo      LIKE ordem-compra.it-codigo     NO-UNDO.
    DEFINE VARIABLE i-mo-ordem       LIKE moeda.mo-codigo            NO-UNDO.

    EMPTY TEMP-TABLE tt-bo-erro.
    
    ASSIGN i-seq-erro = 0.

    FOR FIRST embarque-imp FIELDS(cod-estabel embarque contabilizado)
        WHERE ROWID(embarque-imp) = r-embarque NO-LOCK: END.

    IF NOT AVAIL embarque-imp THEN DO:

        {utp/ut-table.i mgcex embarque-imp 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE).
        
        UNDO, RETURN.
    END.

    FOR FIRST ordem-compra FIELDS(cod-estabel numero-ordem it-codigo mo-codigo num-pedido)
        WHERE ordem-compra.numero-ordem = p-numero-ordem NO-LOCK: END.

    IF NOT AVAIL ordem-compra THEN DO:
        
        {utp/ut-table.i mgind ordem-compra 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE + "~~":U + STRING(p-numero-ordem)).

        UNDO, RETURN.
    END.
    
    /* Licenciamento Importacao */ 
    ASSIGN l-necessita-li = NO.

    FIND FIRST param-imp 
         WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

    IF AVAIL param-imp AND SUBSTRING(param-imp.char-1,167,1) = "S":U THEN
        ASSIGN l-necessita-li = YES.
    ELSE
        IF CAN-FIND(FIRST item
                    WHERE item.it-codigo = ordem-compra.it-codigo
                      AND item.log-necessita-li) THEN
            ASSIGN l-necessita-li = YES.

    ASSIGN i-numero-ordem = ordem-compra.numero-ordem
           c-it-codigo    = ordem-compra.it-codigo
           i-mo-ordem     = ordem-compra.mo-codigo
           c-cod-estab    = ordem-compra.cod-estabel.
           
    IF NOT VALID-HANDLE (h-bocx00488) THEN
        RUN cxbo/bocx00488.p PERSISTENT SET h-bocx00488.
        
    IF VALID-HANDLE(h-bocx00488) then do:        
        assign vd-cod-duimp-dts = 0.
        RUN piValidaEmbarqueDuimp in h-bocx00488 (input  embarque-imp.cod-estabel,
                                                  input  embarque-imp.embarque,
                                                  output vd-cod-duimp-dts).        
        IF vd-cod-duimp-dts <> 0 THEN DO:
            {utp/ut-liter.i "Vincula‡Æo" *}
            ASSIGN c-lbl-liter-e[1] = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Embarque_j " *}
            ASSIGN c-lbl-liter-e[2] = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "…_DUIMP_No." *}
            ASSIGN c-lbl-liter-e[3] = TRIM(RETURN-VALUE).
            RUN criaTTBoErro(INPUT 27414,
                             input c-lbl-liter-e[1] + "~~":U 
                                 + c-lbl-liter-e[2] + "~~":U
                                 + c-lbl-liter-e[3] + string(vd-cod-duimp-dts)).
                                 
            UNDO, RETURN.
        END.
    end.

    /* Quantidade disponivel */
    RUN pi-calculaQtdeDisponivel(INPUT ordem-compra.numero-ordem, OUTPUT de-quant-disp).
    
    IF de-quant > de-quant-disp THEN DO:
        
        {utp/ut-liter.i quantidade_disponðvel_para_aloca¯Êo_da_ordem * L}
        RUN criaTTBoErro(INPUT 1221, INPUT RETURN-VALUE + " " + STRING(ordem-compra.numero-ordem)).

        UNDO, RETURN.
    END.

    FIND FIRST processo-imp 
         WHERE processo-imp.num-pedido  = ordem-compra.num-pedido NO-LOCK NO-ERROR.

    IF NOT AVAIL processo-imp THEN DO:
        
        {utp/ut-table.i mgcex processo-imp 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE + "~~":U + STRING(ordem-compra.num-pedido)).

        UNDO, RETURN.
    END.
    
    /* Verifica se processo esta encerrado/embarcado total  */
    IF processo-imp.situacao >= 3 THEN DO:
        
        {utp/ut-table.i mgcex processo-imp 1}
        RUN criaTTBoErro(INPUT 15239, INPUT RETURN-VALUE + " " + processo-imp.nr-proc-imp).
        
        UNDO, RETURN.
    END.

    /* Verifica se itinerario do processo e o mesmo do outro itinerario ja informado */
    FOR FIRST historico-embarque FIELDS(cod-itiner embarque)
        WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
          AND historico-embarque.embarque    = embarque-imp.embarque NO-LOCK: END.
    
    IF AVAIL historico-embarque THEN DO:
        ASSIGN l-existe-hist = YES.
        
        IF historico-embarque.cod-itiner <> processo-imp.cod-itiner THEN DO:

            RUN criaTTBoErro(INPUT 17751, INPUT processo-imp.nr-proc-imp).

            UNDO, RETURN.
        END.
    END.    

    /* Verfica se o exportador e o mesmo de todas as ordens informadas */ 
    FOR FIRST ordens-embarque FIELDS(numero-ordem)
        WHERE ordens-embarque.cod-estabel  = embarque-imp.cod-estabel 
          AND ordens-embarque.embarque     = embarque-imp.embarque NO-LOCK: 

        FOR FIRST ordem-compra FIELDS(cod-emitente mo-codigo num-pedido) 
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK: 

            IF processo-imp.cod-exportador <> ordem-compra.cod-emitente THEN DO:

                RUN criaTTBoErro(INPUT 17888, INPUT "").
                
                UNDO, RETURN.
            END.

            IF i-mo-ordem <> ordem-compra.mo-codigo THEN DO:

                RUN criaTTBoErro(INPUT 26194, INPUT STRING(i-mo-ordem) + "~~":U + STRING(i-numero-ordem) + "~~":U + STRING(ordem-compra.mo-codigo)).
                
                UNDO, RETURN.
            END.
        END.
    END.

    FOR FIRST itinerario FIELDS(cod-itiner pto-despacho pto-embarque pto-desembarque pto-chegada)
        WHERE itinerario.cod-itiner = processo-imp.cod-itiner NO-LOCK: END.     

    IF NOT AVAIL itinerario THEN DO:

        {utp/ut-table.i mgcex itinerario 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE + "~~":U + STRING(processo-imp.cod-itiner)).
        
        UNDO, RETURN.
    END.
    ELSE DO: /* Valida pontos de controle obrigat¢rios do itiner rio */

        IF itinerario.pto-despacho = 0 OR itinerario.pto-desembarque = 0 
        OR itinerario.pto-embarque = 0 OR itinerario.pto-chegada = 0 THEN DO:

            {utp/ut-table.i mgcex itinerario 1}
            RUN criaTTBoErro(INPUT 54826, INPUT STRING(itinerario.cod-itiner)).

            UNDO, RETURN.
        END.
    END.

    ASSIGN i-pto-embarque = IF l-existe-hist  THEN embarque-imp.cdn-pto-embarq ELSE itinerario.pto-embarque
           i-pto-chegada  = IF l-existe-hist  THEN embarque-imp.cdn-pto-chegad ELSE itinerario.pto-chegada
           i-cod-itiner   = itinerario.cod-itiner
           i-num-pedido   = processo-imp.num-pedido.
    
    FOR FIRST historico-embarque FIELDS(dt-efetiva embarque) 
        WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
          AND historico-embarque.embarque      = embarque-imp.embarque    
          AND historico-embarque.cod-itiner    = itinerario.cod-itiner    
          AND historico-embarque.cod-pto-contr = i-pto-chegada  NO-LOCK: 
    END.

    IF AVAIL historico-embarque THEN DO:
        
        IF historico-embarque.dt-efetiva <> ? THEN DO:

            RUN criaTTBoErro(INPUT 27733, INPUT historico-embarque.embarque + "~~":U + STRING(i-pto-chegada)).

            UNDO, RETURN.
        END.
    END.

    IF NOT VALID-HANDLE(h-boin356) THEN
        RUN inbo/boin356ab.p PERSISTENT SET h-boin356.
    IF NOT VALID-HANDLE(h-bodi425) THEN
        RUN dibo/bodi425.p PERSISTENT SET h-bodi425.
    IF NOT VALID-HANDLE (h-bocx230a) THEN
        RUN cxbo/bocx230a.p PERSISTENT SET h-bocx230a.
    
    FIND FIRST param-imp
         WHERE param-imp.cod-estabel = c-cod-estab NO-LOCK NO-ERROR.
         
    IF l-nt2024002 THEN
        FIND FIRST param-imp-trib
             WHERE param-imp-trib.cod-estabel = c-cod-estab NO-LOCK NO-ERROR.
    
    /* ** CRIACAO ORDENS DO EMBARQUE ** */
    FOR EACH prazo-compra FIELDS(quantidade quant-saldo numero-ordem parcela data-entrega qtd-sal-forn it-codigo char-2)
        WHERE prazo-compra.situacao      = 2 
          AND prazo-compra.numero-ordem  = i-numero-ordem NO-LOCK:

        ASSIGN de-quant-falta = prazo-compra.quantidade.

        FOR EACH ordens-embarque FIELDS(quantidade)  
           WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
             AND ordens-embarque.parcela      = prazo-compra.parcela NO-LOCK:

            ASSIGN de-quant-falta = de-quant-falta - ordens-embarque.quantidade.
        END.

        IF de-quant > 0 THEN DO:
            
            IF de-quant-falta <= 0 THEN NEXT.
        
            IF de-quant > de-quant-falta THEN
                ASSIGN de-quant-parcela = de-quant-falta.
            ELSE
                ASSIGN de-quant-parcela = de-quant.
        
            ASSIGN de-quant = de-quant - de-quant-falta.
            
            /*  Despesas do Embarque */
            FOR EACH cotacao-item FIELDS(cotacao-item.cot-aprovada cotacao-item.data-cotacao cotacao-item.seq-cotac cotacao-item.char-1)
                WHERE cotacao-item.numero-ordem = prazo-compra.numero-ordem
                  AND cotacao-item.cod-emitente = processo-imp.cod-exportador
                  AND cotacao-item.it-codigo    = c-it-codigo NO-LOCK:

                IF cotacao-item.cot-aprovada THEN DO:

                    {ccp/cc9019.i50}
                    {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                    {ccp/cc9019.i51 "yes"}
                    
                    /*** Cotacao Despesas Adicionais do Item*/
                    FOR EACH cotacao-item-cex 
                       WHERE cotacao-item-cex.numero-ordem  = prazo-compra.numero-ordem 
                         AND cotacao-item-cex.cod-emitente  = processo-imp.cod-exportador
                         AND cotacao-item-cex.it-codigo     = c-it-codigo
                         AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                         AND cotacao-item-cex.mapa-cotacao  = i-mapa-cotacao-i50 
                         AND cotacao-item-cex.cod-incoterm  = TRIM(c-cod-incoterm-i50) NO-LOCK:

                        IF  AVAIL param-imp THEN
                            IF cotacao-item-cex.cod-desp = INT(SUBSTR(param-imp.char-1,21,20)) 
                            OR cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-ipi     
                            OR cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-pis     
                            OR cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-cofins  
                            OR cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-icms THEN
                                NEXT.

                        IF l-nt2024002 THEN DO:
                            IF  AVAIL param-imp-trib THEN
                                IF cotacao-item-cex.cod-desp = param-imp-trib.cdn-despes-impto-CBS     
                                OR cotacao-item-cex.cod-desp = param-imp-trib.cdn-despes-impto-IBSMun     
                                OR cotacao-item-cex.cod-desp = param-imp-trib.cdn-despes-impto-IBSUF  
                                OR cotacao-item-cex.cod-desp = param-imp-trib.cdn-despes-impto-IS THEN
                                    NEXT.
                        END.
                        
                        FIND FIRST desp-imp 
                             WHERE desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.

                        IF NOT desp-imp.inc-val-embal       AND
                           NOT desp-imp.inc-val-frete       AND
                           NOT desp-imp.inc-val-outras-desp AND
                           NOT desp-imp.inc-val-seguro then
                            NEXT.
                          
                        IF l-existe-hist THEN DO:
                            /*se existir historico-embarque, valida se o ponto de controle que incide despesa nas cotacao-item-cex existe no historico-embarque */
                            IF NOT CAN-FIND(FIRST historico-embarque 
                                            WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
                                              AND historico-embarque.embarque      = embarque-imp.embarque 
                                              AND historico-embarque.cod-itiner    = processo-imp.cod-itiner 
                                              AND historico-embarque.cod-pto-contr = cotacao-item-cex.cod-pto-contr) THEN DO:

                                {utp/ut-liter.i "Hist¢rico_do_embarque" *}
                                RUN criaTTBoErro(INPUT 25197, 
                                                 INPUT STRING(cotacao-item-cex.cod-pto-contr) + "~~":U + 
                                                       STRING(cotacao-item-cex.numero-ordem)  + "~~":U + 
                                                       STRING(cotacao-item-cex.cod-desp)      + "~~":U + RETURN-VALUE).
                                UNDO, RETURN.
                            END.
                        END.
                        ELSE DO:
                            /*Valida se o ponto de controle que incide despesa nas cotacao-item-cex existe no itinerario do processo-imp */
                            IF NOT CAN-FIND(FIRST pto-itiner 
                                            WHERE pto-itiner.cod-itiner    = processo-imp.cod-itiner 
                                              AND pto-itiner.cod-pto-contr = cotacao-item-cex.cod-pto-contr) THEN DO:

                                {utp/ut-liter.i "Itiner rio_do_Processo" *}
                                RUN criaTTBoErro(INPUT 25197, 
                                                 INPUT STRING(cotacao-item-cex.cod-pto-contr) + "~~":U + 
                                                       STRING(cotacao-item-cex.numero-ordem)  + "~~":U + 
                                                       STRING(cotacao-item-cex.cod-desp)      + "~~":U + RETURN-VALUE).
                                UNDO, RETURN.
                            END.
                        END.
                    
                        FIND FIRST desp-embarque
                             WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                               AND desp-embarque.embarque          = embarque-imp.embarque
                               AND desp-embarque.cod-itiner        = processo-imp.cod-itiner
                               AND desp-embarque.cod-pto-contr     = cotacao-item-cex.cod-pto-contr
                               AND desp-embarque.cod-desp          = cotacao-item-cex.cod-desp
                               AND desp-embarque.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp EXCLUSIVE-LOCK NO-ERROR.

                        IF NOT AVAIL desp-embarque THEN DO:
                            /* Valida se existem dois fornecedores(emitente) diferentes para a mesma despesa */
                            IF CAN-FIND (FIRST desp-embarque 
                                         WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                                           AND desp-embarque.embarque          = embarque-imp.embarque
                                           AND desp-embarque.cod-itiner        = processo-imp.cod-itiner
                                           AND desp-embarque.cod-pto-contr     = cotacao-item-cex.cod-pto-contr
                                           AND desp-embarque.cod-desp          = cotacao-item-cex.cod-desp) THEN DO:

                                {utp/ut-liter.i "Emitente" *}
                                RUN criaTTBoErro(INPUT 25219, INPUT STRING(cotacao-item-cex.cod-desp) + "~~":U + STRING(cotacao-item-cex.numero-ordem) + "~~":U + RETURN-VALUE).
                                
                                UNDO, RETURN.
                            END.
                        
                            /* Valida se existe a mesma despesa para pontos de controle deferentes */
                            IF CAN-FIND (FIRST desp-embarque 
                                         WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                                           AND desp-embarque.embarque          = embarque-imp.embarque
                                           AND desp-embarque.cod-itiner        = processo-imp.cod-itiner
                                           AND desp-embarque.cod-desp          = cotacao-item-cex.cod-desp) THEN DO:
                                
                                {utp/ut-liter.i "Ponto_de_Controle" *}
                                RUN criaTTBoErro(INPUT 25219, INPUT STRING(cotacao-item-cex.cod-desp) + "~~":U + STRING(cotacao-item-cex.numero-ordem) + "~~":U + RETURN-VALUE).

                                UNDO, RETURN.
                            END.

                            CREATE desp-embarque.
                            ASSIGN desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                                   desp-embarque.embarque          = embarque-imp.embarque
                                   desp-embarque.cod-itiner        = processo-imp.cod-itiner
                                   desp-embarque.cod-pto-contr     = cotacao-item-cex.cod-pto-contr
                                   desp-embarque.cod-desp          = cotacao-item-cex.cod-desp
                                   desp-embarque.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp
                                   desp-embarque.cod-cond-pag      = cotacao-item-cex.cod-cond-pag
                                   desp-embarque.mo-codigo         = cotacao-item-cex.mo-codigo.

                            FIND FIRST desp-imp
                                 WHERE desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.

                            IF AVAIL desp-imp THEN
                               ASSIGN desp-embarque.descricao = desp-imp.descricao.

                        END.
                        ELSE DO:
                            /* Valida se existe a mesma despesa com moedas diferentes */
                            IF desp-embarque.mo-codigo <> cotacao-item-cex.mo-codigo THEN DO:
                                
                                {utp/ut-liter.i "Moeda" *}
                                RUN criaTTBoErro(INPUT 25219, INPUT STRING(cotacao-item-cex.cod-desp) + "~~":U + STRING(cotacao-item-cex.numero-ordem) + "~~":U + RETURN-VALUE).

                                UNDO, RETURN.
                            END.
                        END.

                        RUN GetRateioIncoterm (OUTPUT c-cod-incoterm-rat).

                        
                        ASSIGN desp-embarque.cod-incoterm-rat = c-cod-incoterm-rat.

                        /*--- Sugestao da incoterm rateio com base da despesa do pedido ----*/

                        FOR FIRST ordem-compra FIELDS(num-pedido)
                            WHERE ordem-compra.numero-ordem = cotacao-item-cex.numero-ordem NO-LOCK: END.

                        IF  AVAIL ordem-compra THEN

                            FOR FIRST despes-ped-compra FIELDS(cod-incoterm-rat)
                                WHERE despes-ped-compra.num-pedido        = ordem-compra.num-pedido
                                  AND despes-ped-compra.cod-desp          = cotacao-item-cex.cod-desp
                                  AND despes-ped-compra.mo-codigo         = cotacao-item-cex.mo-codigo
                                  AND despes-ped-compra.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp
                                  AND despes-ped-compra.cod-pto-contr     = cotacao-item-cex.cod-pto-contr
                                  AND despes-ped-compra.tp-despesa        = cotacao-item-cex.tp-despesa NO-LOCK:

                                ASSIGN desp-embarque.cod-incoterm-rat = despes-ped-compra.cod-incoterm-rat.
                            END.

                        ASSIGN de-conv-val-cex = cotacao-item-cex.val-desp.

                        IF cotacao-item-cex.mo-codigo <> desp-embarque.mo-codigo THEN DO:
                            RUN cdp/cd0812.p (INPUT  cotacao-item-cex.mo-codigo,
                                              INPUT  desp-embarque.mo-codigo,
                                              INPUT  cotacao-item-cex.val-desp,
                                              INPUT  TODAY,
                                              OUTPUT de-conv-val-cex).

                            IF de-conv-val-cex = 0 OR de-conv-val-cex = ? THEN
                                ASSIGN de-conv-val-cex = cotacao-item-cex.val-desp.
                        END.

                        IF desp-imp.tipo = 1 THEN /* valor fixo */
                            ASSIGN desp-embarque.val-desp = de-conv-val-cex.
                        ELSE
                            ASSIGN desp-embarque.val-desp = desp-embarque.val-desp + (de-conv-val-cex * de-quant-parcela).                                                    
                    END.
                END.
            END.

            /* Criacao das ordens-embarque */
            FIND FIRST ordens-embarque
                 WHERE ordens-embarque.cod-estabel  = processo-imp.cod-estabel  
                   AND ordens-embarque.nr-proc-imp  = processo-imp.nr-proc-imp  
                   AND ordens-embarque.embarque     = embarque-imp.embarque     
                   AND ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                   AND ordens-embarque.parcela      = prazo-compra.parcela      EXCLUSIVE-LOCK NO-ERROR.

            ASSIGN l-criou-ordens-embarque = NO.

            IF NOT AVAIL ordens-embarque THEN DO:

                CREATE ordens-embarque.
                ASSIGN ordens-embarque.cod-estabel  = processo-imp.cod-estabel
                       ordens-embarque.embarque     = embarque-imp.embarque
                       ordens-embarque.numero-ordem = prazo-compra.numero-ordem
                       ordens-embarque.parcela      = prazo-compra.parcela
                       ordens-embarque.nr-proc-imp  = processo-imp.nr-proc-imp
                       ordens-embarque.quantidade   = 0
                       l-criou-ordens-embarque      = YES
                       &IF  "{&bf_mat_versao_ems}":U >= "2.09":U &THEN
                           ordens-embarque.nr-ato-concessorio = prazo-compra.cod-ato-concessor
                       &ELSE
                           OVERLAY(ordens-embarque.char-1,1,20) = SUBSTRING(prazo-compra.char-2,11,30)
                       &ENDIF
                       .
            END.

            {cxbo/bocx225.i2} /*Parcela fixada (parcela nao sera re-planejada) --> prazo-compra.int-2 = 2*/
            
            ASSIGN ordens-embarque.quantidade = ordens-embarque.quantidade + de-quant-parcela.

            /* Atualizar pesos somente apos criar ordens-embarque */
            IF  l-criou-ordens-embarque THEN DO:

                FOR FIRST ordem-compra FIELDS(num-pedido cod-emitente )
                    WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK: END.

                IF VALID-HANDLE(h-boin356) AND VALID-HANDLE(h-bodi425) THEN DO:

                    RUN piRetornaQtdeEmbalagem IN h-bodi425(INPUT ordens-embarque.quantidade, 
                                                            INPUT prazo-compra.it-codigo, 
                                                            INPUT ordem-compra.cod-emitente,
                                                            OUTPUT d-qtd-embal).
                    
                    RUN retornaPesoTotal IN h-boin356 (INPUT ROWID(prazo-compra), 
                                                       INPUT ordens-embarque.quantidade, 
                                                       INPUT d-qtd-embal, 
                                                       OUTPUT de-peso-total).
                    IF NOT l-emb THEN
                        RUN retornaVolumeTotal IN h-boin356 (INPUT ROWID(prazo-compra), 
                                                             INPUT ordens-embarque.quantidade, 
                                                             OUTPUT de-volume-total).
                    ELSE
                        RUN retornaVolumeTotal IN h-boin356 (INPUT ROWID(prazo-compra), 
                                                             INPUT IF d-qtd-embal <> 0 THEN d-qtd-embal ELSE ordens-embarque.quantidade,
                                                             OUTPUT de-volume-total).
                END.
                    
                FOR FIRST item FIELDS (peso-liquido peso-bruto altura largura comprim)
                    WHERE item.it-codigo = c-it-codigo NO-LOCK:
                    
                    ASSIGN ordens-embarque.peso-liquido = item.peso-liquido * ordens-embarque.quantidade
                           ordens-embarque.peso-bruto   = de-peso-total
                           ordens-embarque.val-cub-tot  = de-volume-total.
                END.
            END.

            FOR FIRST item-fornec FIELDS(fator-conver num-casa-dec)
                WHERE item-fornec.it-codigo    = c-it-codigo 
                  AND item-fornec.cod-emitente = processo-imp.cod-exportador NO-LOCK: END.
                   
            IF AVAIL item-fornec THEN 
                ASSIGN ordens-embarque.qt-do-forn = prazo-compra.qtd-sal-forn.
            ELSE
                ASSIGN ordens-embarque.qt-do-forn = ordens-embarque.quantidade.
        END.
       
        ASSIGN v-data = prazo-compra.data-entrega.
    
    END. /* FOR EACH prazo-compra */

    /*******************************************************************************************************/

    /* 
    ** Teste para atualizar o status do processo-imp. Se o parametro gera hist processo estiver setado
    ** atualiza, senao so atualiza se houver historico do embarque e a data de embarque estiver efetivada 
    */         
    FOR FIRST param-imp FIELDS(hist-processo)
        WHERE param-imp.cod-estabel = embarque-imp.cod-estabel NO-LOCK: END.
    IF NOT AVAIL param-imp THEN DO:

        {utp/ut-table.i mgcex param-imp 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE).

        UNDO, RETURN.
    END.
    
    IF param-imp.hist-processo THEN
        RUN pi-atualizaSitProc(INPUT i-num-pedido).
    ELSE DO:

        FOR FIRST historico-embarque FIELDS(dt-efetiva)
            WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
              AND historico-embarque.embarque      = embarque-imp.embarque
              AND historico-embarque.cod-itiner    = i-cod-itiner
              AND historico-embarque.cod-pto-contr = i-pto-embarque NO-LOCK: END.

        IF AVAIL historico-embarque THEN
            IF historico-embarque.dt-efetiva <> ? THEN
                RUN pi-atualizaSitProc (INPUT i-num-pedido).
    END.

    IF NOT l-create-hist THEN DO:

        ASSIGN l-create-hist = YES.

        IF NOT CAN-FIND (FIRST historico-embarque NO-LOCK
                         WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
                           AND historico-embarque.embarque      = embarque-imp.embarque    
                           AND historico-embarque.cod-itiner    = processo-imp.cod-itiner 
                           AND historico-embarque.cod-pto-contr = i-pto-chegada) THEN DO:

            RUN pi-createHistEmbarque (INPUT embarque-imp.cod-estabel,
                                       INPUT embarque-imp.embarque,
                                       INPUT processo-imp.nr-proc-imp,
                                       INPUT v-data,
                                       INPUT processo-imp.cod-itiner,
                                       INPUT processo-imp.cod-exportador,
                                       INPUT processo-imp.cod-despachante,
                                       INPUT processo-imp.cod-agente,
                                       INPUT processo-imp.cod-fabricante,
                                       INPUT param-imp.hist-processo,
                                       INPUT i-pto-chegada,
                                       INPUT c-cod-idiom-usuar,
                                       OUTPUT TABLE tt-bo-erro).

            /* Licenciamento Importacao */
            IF NOT l-necessita-li THEN 
                RUN piEliminaPtoLI IN THIS-PROCEDURE.
        END.
        
        FIND FIRST tt-bo-erro 
             WHERE tt-bo-erro.cd-erro = 25196 EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL tt-bo-erro THEN DO:
            
            {utp/ut-liter.i de_chegada} 
            ASSIGN c-msg = TRIM(RETURN-VALUE) + " "  + STRING(i-pto-chegada) + "~~":U + STRING(i-numero-ordem) + "~~":U + STRING(processo-imp.cod-itiner).

            RUN utp/ut-msgs.p (input "msg":U, input 25196, input c-msg).

            ASSIGN tt-bo-erro.parametros   = c-msg
                   tt-bo-erro.cd-erro      = 25196
                   tt-bo-erro.mensagem     = RETURN-VALUE.

            FOR EACH ordens-embarque EXCLUSIVE-LOCK
               WHERE ordens-embarque.numero-ordem = i-numero-ordem
                 AND ordens-embarque.cod-estabel  = processo-imp.cod-estabel
                 AND ordens-embarque.embarque     = embarque-imp.embarque:
                DELETE ordens-embarque.
            END.
            UNDO, LEAVE.        
        END.
        
        FOR FIRST historico-embarque FIELDS(dt-ult-previsao) 
            WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
              AND historico-embarque.embarque      = embarque-imp.embarque    
              AND historico-embarque.cod-itiner    = processo-imp.cod-itiner 
              AND historico-embarque.cod-pto-contr = i-pto-chegada NO-LOCK: END.

        IF AVAIL historico-embarque THEN DO:
            FOR EACH ordens-embarque FIELDS(numero-ordem parcela)  
               WHERE ordens-embarque.cod-estabel  = processo-imp.cod-estabel
                 AND ordens-embarque.embarque     = embarque-imp.embarque NO-LOCK:

                IF v-parcela  = ordens-embarque.parcela AND v-ordem = ordens-embarque.numero-ordem THEN 
                    NEXT.

                FIND FIRST prazo-compra  
                     WHERE prazo-compra.numero-ordem = ordens-embarque.numero-ordem 
                       AND prazo-compra.parcela      = ordens-embarque.parcela EXCLUSIVE-LOCK NO-ERROR.

                IF AVAIL prazo-compra THEN DO: 
                    IF ( historico-embarque.dt-ult-previsao <> prazo-compra.data-entrega ) THEN DO:
                        
                        FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem EXCLUSIVE-LOCK NO-ERROR.  

                        /* Criar Registro na tabela alt-ped */
                        {cxbo/bocx140.i03 today 
                                          c-seg-usuario 
                                          ordem-compra.num-pedido
                                          ordem-compra.numero-ordem 
                                          prazo-compra.parcela
                                          prazo-compra.data-entrega
                                          ?
                                          ?
                                          ordem-compra.cod-emitente
                                          ordem-compra.gera-edi
                                          ordem-compra.num-pedido
                                          historico-embarque.dt-ult-previsao}   
                    END.

                    ASSIGN prazo-compra.data-entrega-ant = prazo-compra.data-entrega
                           prazo-compra.data-entrega = historico-embarque.dt-ult-previsao.
                END.
            END.
        END.
    END. /* NOT l-create-hist */

    RUN piAtualizaEmbarqueImp (INPUT embarque-imp.cod-estabel,
                               INPUT embarque-imp.embarque,   
                               INPUT processo-imp.cod-itiner,
                               INPUT processo-imp.nr-proc-imp).

    
    
    /* Licenciamento Importacao */
    IF l-necessita-li THEN 
        RUN piCriaPtoLI IN THIS-PROCEDURE.
    
    /*--- Chamada UPC ---*/
    FOR EACH tt-epc WHERE tt-epc.cod-event = "AfterCreateOrdensEmbarque":U.
        DELETE tt-epc.
    END.

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AfterCreateOrdensEmbarque":U
           tt-epc.cod-parameter = "ordem-compra.numero-ordem":U
           tt-epc.val-parameter = STRING(p-numero-ordem).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AfterCreateOrdensEmbarque":U
           tt-epc.cod-parameter = "row-embarque-imp":U
           tt-epc.val-parameter = STRING(r-embarque).

    /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i '"AfterCreateOrdensEmbarque"'}
    
    RETURN "OK":U.

    FINALLY:
        IF VALID-HANDLE(h-bocx230a) THEN DO:
            DELETE PROCEDURE h-bocx230a.
            ASSIGN h-bocx230a = ?.
        END.
    
        IF VALID-HANDLE(h-boin356) THEN DO:
            DELETE PROCEDURE h-boin356.
            ASSIGN h-boin356 = ?.
        END.
        
        IF VALID-HANDLE(h-bodi425) THEN DO:
            DELETE PROCEDURE h-bodi425.
            ASSIGN h-bodi425 = ?.
        END.
        
        IF  VALID-HANDLE (h-bocx00488) THEN DO:
            DELETE PROCEDURE h-bocx00488.
            ASSIGN h-bocx00488 = ?.
        END.
    END FINALLY.
END PROCEDURE.


PROCEDURE createPedidosembarque:
/*------------------------------------------------------------------------------
  Purpose: Cria‡Æo das Ordens Embarque via Pedido de Compra
  Parameters: INPUT - r-embarque (rowid) - rowid do embarque
              INPUT - p-num-pedido (integer) - numero da ordem de compra
              OUTPUT TABLE - tt-bo-erro - TempTable com os erros ocorridos durante o processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER r-embarque        AS   ROWID                   NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-pedido      LIKE pedido-compr.num-pedido NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    DEFINE VARIABLE de-quant-disp LIKE prazo-compra.quantidade NO-UNDO.

    DEFINE BUFFER b-ordem-compra FOR ordem-compra.

    ASSIGN l-create-hist = NO.       
     
    IF NOT VALID-HANDLE (h-bocx00488) THEN
        RUN cxbo/bocx00488.p PERSISTENT SET h-bocx00488.
        
    IF VALID-HANDLE(h-bocx00488) then do:
        ASSIGN vd-cod-duimp-dts = 0.
        RUN piValidaEmbarqueDuimp in h-bocx00488 (INPUT  embarque-imp.cod-estabel,
                                                  INPUT  embarque-imp.embarque,
                                                  OUTPUT vd-cod-duimp-dts).
        IF vd-cod-duimp-dts <> 0 THEN DO:
            {utp/ut-liter.i "Vincula‡Æo" *}
            ASSIGN c-lbl-liter-e[1] = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Pedido_do_embarque_j " *}
            ASSIGN c-lbl-liter-e[2] = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "…_DUIMP_No." *}
            ASSIGN c-lbl-liter-e[3] = TRIM(RETURN-VALUE).
            RUN criaTTBoErro(INPUT 27414,
                             INPUT c-lbl-liter-e[1] + "~~":U 
                                 + c-lbl-liter-e[2] + "~~":U
                                 + c-lbl-liter-e[3] + STRING(vd-cod-duimp-dts)).
                                 
            UNDO, RETURN.
        END.
    END.
    
    IF  VALID-HANDLE (h-bocx00488) THEN DO:
        DELETE PROCEDURE h-bocx00488.
        ASSIGN h-bocx00488 = ?.
    END.

    FOR EACH b-ordem-compra 
       WHERE b-ordem-compra.num-pedido = p-num-pedido NO-LOCK:
        
        RUN pi-calculaQtdeDisponivel (INPUT b-ordem-compra.numero-ordem,
                                      OUTPUT de-quant-disp).
        IF de-quant-disp > 0 THEN
            RUN createOrdensembarque (INPUT r-embarque,
                                      INPUT b-ordem-compra.numero-ordem,
                                      INPUT de-quant-disp,
                                      OUTPUT TABLE tt-bo-erro).
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE AddOrdemEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Atualiza o identificar container a ordem selecionada no browser.
  Parameters: INPUT - pIdentificContainer (character) - codigo do container
              INPUT - pTipoContainer (character) - tipo do container
              INPUT - pDtPrevDev (date) - data de previsao
              INPUT - pDtDevol (date) - data de devolucao
              INPUT-OUTPUT TABLE - pDelOrdem -
              INPUT - pRowidOrdensEmbarque (rowid) - rowid da ordem a ser atualizada
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT        PARAMETER pIdentificContainer  AS CHARACTER  NO-UNDO.
   DEFINE INPUT        PARAMETER pTipoContainer       AS CHARACTER  NO-UNDO.
   DEFINE INPUT        PARAMETER pDtPrevDev           AS DATE       NO-UNDO.
   DEFINE INPUT        PARAMETER pDtDevol             AS DATE       NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER TABLE FOR pDelOrdem.   
   DEFINE INPUT PARAMETER pRowidOrdensEmbarque        AS ROWID      NO-UNDO.
   
   FIND FIRST ordens-embarque 
        WHERE ROWID(ordens-embarque) = pRowidOrdensEmbarque EXCLUSIVE-LOCK NO-ERROR.

   IF AVAIL ordens-embarque THEN DO:

      CREATE pDelOrdem.
      ASSIGN pDelOrdem.r-rowid = ROWID(ordens-embarque)
             ordens-embarque.identific-container   = pIdentificContainer
             OVERLAY(ordens-embarque.char-1,21,20) = pTipoContainer
             OVERLAY(ordens-embarque.char-1,84,10) = IF pDtPrevDev = ? THEN "" ELSE STRING(pDtPrevDev,"99/99/9999":U)
             OVERLAY(ordens-embarque.char-1,94,10) = IF pDtDevol   = ? THEN "" ELSE STRING(pDtDevol,"99/99/9999":U).
   END. 

   RETURN "OK":U.
END PROCEDURE.


PROCEDURE DelOrdemEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Elimina o identificar container a ordem selecionada no browser.
  Parameters: INPUT - pRowidOrdensEmbarque (rowid) - rowid da ordem a ser atualizada
              INPUT-OUTPUT TABLE - pDelOrdem -
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT        PARAMETER pRowidOrdensEmbarque AS ROWID NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER TABLE FOR pDelOrdem.
   
   FIND FIRST ordens-embarque 
        WHERE ROWID(ordens-embarque) = pRowidOrdensEmbarque EXCLUSIVE-LOCK NO-ERROR.

   IF AVAIL ordens-embarque THEN DO:

      CREATE pDelOrdem.
      ASSIGN pDelOrdem.r-rowid = ROWID(ordens-embarque)
             ordens-embarque.identific-container   = ""
             OVERLAY(ordens-embarque.char-1,21,20) = ""
             OVERLAY(ordens-embarque.char-1,84,10) = ""
             OVERLAY(ordens-embarque.char-1,94,10) = "".
   END.

   RETURN "OK":U.
END PROCEDURE.

PROCEDURE AddAllOrdemEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Autaliza todas as ordens com o identificar container as ordens contidas no browser.
  Parameters: INPUT - pIdentificContainer (character) - codigo do container
              INPUT - pTipoContainer (character) - tipo do container
              INPUT - pDtPrevDev (date) - data de previsao
              INPUT - pDtDevol (date) - data de devolucao
              INPUT-OUTPUT TABLE - pDelOrdem -
              INPUT TABLE - pTableOrd -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER pIdentificContainer   AS CHARACTER   NO-UNDO.
    DEFINE INPUT        PARAMETER pTipoContainer        AS CHARACTER   NO-UNDO.
    DEFINE INPUT        PARAMETER pDtPrevDev            AS DATE        NO-UNDO.
    DEFINE INPUT        PARAMETER pDtDevol              AS DATE        NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR pDelOrdem. 
    DEFINE INPUT        PARAMETER TABLE FOR pTableOrd.
   
    FOR EACH pTableOrd NO-LOCK,
        EACH ordens-embarque 
       WHERE ROWID(ordens-embarque) = pTableOrd.r-rowid EXCLUSIVE-LOCK:

             CREATE pDelOrdem.
             ASSIGN pDelOrdem.r-rowid = ROWID(ordens-embarque)
                    ordens-embarque.identific-container   = pIdentificContainer
                    OVERLAY(ordens-embarque.char-1,21,20) = pTipoContainer
                    OVERLAY(ordens-embarque.char-1,84,10) = IF pDtPrevDev = ? THEN "" ELSE STRING(pDtPrevDev,"99/99/9999":U)
                    OVERLAY(ordens-embarque.char-1,94,10) = IF pDtDevol   = ? THEN "" ELSE STRING(pDtDevol,"99/99/9999":U).
    END.

    EMPTY TEMP-TABLE pTableOrd.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE DelAllOrdemEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Autaliza todas as ordens com o identificar container as ordens contidas no browser.
  Parameters: INPUT TABLE - pTableOrd -
              INPUT-OUTPUT TABLE - pDelOrdem -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER TABLE FOR pTableOrd.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR pDelOrdem.
   
    FOR EACH pTableOrd NO-LOCK,
        EACH ordens-embarque 
       WHERE ROWID(ordens-embarque) = pTableOrd.r-rowid EXCLUSIVE-LOCK:

             CREATE pDelOrdem.
             ASSIGN pDelOrdem.r-rowid = ROWID(ordens-embarque)
                    ordens-embarque.identific-container   = ""
                    OVERLAY(ordens-embarque.char-1,21,20) = ""
                    OVERLAY(ordens-embarque.char-1,84,10) = ""
                    OVERLAY(ordens-embarque.char-1,94,10) = "".
    END.

    EMPTY TEMP-TABLE pTableOrd.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE GravaCaracteristica:
/*------------------------------------------------------------------------------
  Purpose: Grava caracteristica na ordem selecionada na tela(im0045h).
  Parameters: INPUT TABLE - pTableOrd -
              INPUT-OUTPUT TABLE - pDelOrdem -
  Notes:       
------------------------------------------------------------------------------*/
      DEFINE INPUT PARAMETER pRowid AS ROWID      NO-UNDO.
      DEFINE INPUT PARAMETER pCarac AS CHARACTER  NO-UNDO.
      
      FIND FIRST ordens-embarque 
           WHERE ROWID(ordens-embarque) = pRowid EXCLUSIVE-LOCK NO-ERROR.

      IF AVAIL ordens-embarque THEN DO:
           ASSIGN ordens-embarque.caracter-container = pCarac.
      END.
      ELSE 
          ASSIGN ordens-embarque.caracter-container = "".

      RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCriaOrdensEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Cria identificador do container para o embarque e estabelecimento que estao 
           sendo sugeridos na tela.
  Parameters: INPUT - pIdentificContainer (character) - codigo do container
              INPUT - pTipoContainer (character) - tipo do container
              INPUT - pDtPrevDev (date) - data de previsao
              INPUT - pDtDevol (date) - data de devolucao
              INPUT TABLE - pTableOrd -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pIdentificContainer AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pTipoContainer      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pDtPrevDev          AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER pDtDevol            AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR pTableOrd.
    
    FOR EACH pTableOrd NO-LOCK,
        EACH ordens-embarque 
       WHERE ROWID(ordens-embarque) = pTableOrd.r-rowid EXCLUSIVE-LOCK:
        
        ASSIGN ordens-embarque.identific-container   = pIdentificContainer
               OVERLAY(ordens-embarque.char-1,21,20) = pTipoContainer
               OVERLAY(ordens-embarque.char-1,84,10) = IF pDtPrevDev = ? THEN "" ELSE STRING(pDtPrevDev,"99/99/9999":U)
               OVERLAY(ordens-embarque.char-1,94,10) = IF pDtDevol   = ? THEN "" ELSE STRING(pDtDevol,"99/99/9999":U).
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCriaOrdensEmbarque2:
/*------------------------------------------------------------------------------
  Purpose: Cria identificador do container para o embarque e estabelecimento que estao 
           sendo sugeridos na tela.
  Parameters: INPUT - pIdentificContainer (character) - codigo do container
              INPUT - pTipoContainer (character) - tipo do container
              INPUT TABLE - pDelOrdem -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pIdentificContainer AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pTipoContainer      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR pDelOrdem.
    
    FOR EACH pDelOrdem NO-LOCK,
        EACH ordens-embarque 
       WHERE ROWID(ordens-embarque) = pDelOrdem.r-rowid EXCLUSIVE-LOCK:

        ASSIGN ordens-embarque.identific-container   = pIdentificContainer
               OVERLAY(ordens-embarque.char-1,21,20) = pTipoContainer.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE EncontraOrdensComContainer:
/*------------------------------------------------------------------------------
  Purpose: Procura no embarque as ordens que possui container 
  Parameters: INPUT - p-embarque (character) - codigo do embarque
              INPUT - p-cod-estabel (character) - codigo do estabelecimento
              INPUT - p-identific-container - codigo do container
              INPUT-OUTPUT TABLE - pDelOrdem -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-embarque            LIKE embarque-imp.embarque  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel         AS CHARACTER                NO-UNDO.
    DEFINE INPUT  PARAMETER p-identific-container AS CHARACTER                NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR pDelOrdem.  
    
    EMPTY TEMP-TABLE pDelOrdem.
    
    FOR EACH ordens-embarque NO-LOCK 
       WHERE ordens-embarque.embarque             = p-embarque 
         AND ordens-embarque.cod-estabel          = p-cod-estabel 
         AND (ordens-embarque.identific-container = p-identific-container AND ordens-embarque.identific-container <> ""):
        
        CREATE pDelOrdem.
        ASSIGN pDelOrdem.r-rowid = ROWID(ordens-embarque).
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE Eliminatemptable:
/*------------------------------------------------------------------------------
  Purpose: Elimina a temp-table  pDelOrdem.
  Parameters: INPUT-OUTPUT TABLE - pDelOrdem 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR pDelOrdem.
    
    EMPTY TEMP-TABLE pDelOrdem.
        
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCancelaAlteracao:
/*------------------------------------------------------------------------------
  Purpose: Desfaz as altera¯´es no programa im0045h.
  Parameters: INPUT - pSituacao (logical)     
              INPUT - pAntIdent (character)     
              INPUT - pAntTipo  (character)     
              INPUT - pAntDataPrevDev (date)
              INPUT - pAntDataDevol (date) 
              INPUT-OUTPUT TABLE - pDelOrdem
              INPUT TABLE - pTableOrd.
              INPUT TABLE - pTableOrd2
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER pSituacao 	  AS LOGICAL        NO-UNDO.
    DEFINE INPUT        PARAMETER pAntIdent 	  AS CHARACTER      NO-UNDO.
    DEFINE INPUT        PARAMETER pAntTipo  	  AS CHARACTER      NO-UNDO.
    DEFINE INPUT        PARAMETER pAntDataPrevDev AS DATE           NO-UNDO.
    DEFINE INPUT        PARAMETER pAntDataDevol   AS DATE           NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR pDelOrdem.
    DEFINE INPUT        PARAMETER TABLE FOR pTableOrd.
    DEFINE INPUT        PARAMETER TABLE FOR pTableOrd2.    

    FOR EACH pDelOrdem NO-LOCK,
        EACH ordens-embarque
       WHERE ROWID(ordens-embarque) = pDelOrdem.r-rowid EXCLUSIVE-LOCK:

         IF ordens-embarque.identific-container <> pAntIdent THEN DO:
            ASSIGN ordens-embarque.identific-container   = pAntIdent
                   OVERLAY(ordens-embarque.char-1,21,20) = pAntTipo
                   OVERLAY(ordens-embarque.char-1,84,10) = STRING(pAntDataPrevDev, "99/99/9999":U)
                   OVERLAY(ordens-embarque.char-1,94,10) = STRING(pAntDataDevol, "99/99/9999":U).
         END.
         ELSE DO:
            ASSIGN ordens-embarque.identific-container   = ""
                   OVERLAY(ordens-embarque.char-1,21,20) = ""
                   OVERLAY(ordens-embarque.char-1,84,10) = ""
                   OVERLAY(ordens-embarque.char-1,94,10) = "".
         END.
    END.

    EMPTY TEMP-TABLE pDelOrdem.
    EMPTY TEMP-TABLE pTableOrd.
    EMPTY TEMP-TABLE pTableOrd2.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-createHistEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Criacao do registro de Acompanhamento do Embarque
  Parameters:  INPUT - p-cod-estabel (character) - codigo do estabelecimento
               INPUT - p-embarque (character) - codigo do embarqye      
               INPUT - p-nr-proc-imp (character) - numero do processo de importacao   
               INPUT - p-dt-emissao (date) - data de emissao utilizada para criacao dos pontos de controle    
               INPUT - p-cod-itiner (integer) - codigo do itinerario    
               INPUT - p-cod-exportador (integer) - codigo do exportador
               INPUT - p-cod-despachante (integer) - codigo do despachante
               INPUT - p-cod-agente (integer) - codigo do agente de cargas 
               INPUT - p-cod-fabricante (integer) - codigo do fabricante
               INPUT - p-hist-processo (logical) - indica se cria histrico para o processo de importacao
               INPUT - p-pto-chegada (integer) - codigo do ponto de chegada do itinerario   
               INPUT - c-cod-idiom-usuar (character) - codigo do idioma do usuario
               OUTPUT TABLE - tt-bo-erro - TempTable com os erros ocorridos durante o processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel     LIKE embarque-imp.cod-estabel     NO-UNDO.
    DEFINE INPUT  PARAMETER p-embarque        LIKE embarque-imp.embarque        NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-proc-imp     LIKE processo-imp.nr-proc-imp     NO-UNDO.
    DEFINE INPUT  PARAMETER p-dt-emissao      LIKE processo-imp.dt-emissao      NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-itiner      LIKE processo-imp.cod-itiner      NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-exportador  LIKE processo-imp.cod-exportador  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-despachante LIKE processo-imp.cod-despachante NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-agente      LIKE processo-imp.cod-agente      NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-fabricante  LIKE processo-imp.cod-fabricante  NO-UNDO.
    DEFINE INPUT  PARAMETER p-hist-processo   LIKE param-imp.hist-processo      NO-UNDO.
    DEFINE INPUT  PARAMETER p-pto-chegada     LIKE itinerario.pto-chegada       NO-UNDO.
    DEFINE INPUT  PARAMETER c-cod-idiom-usuar AS   CHARACTER FORMAT "x(12)":U   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    DEFINE VARIABLE dt-emissao LIKE processo-imp.dt-emissao NO-UNDO.
    DEFINE VARIABLE i-pos      AS INTEGER                   NO-UNDO.
    DEFINE VARIABLE c-msg      AS CHARACTER                 NO-UNDO.
    DEFINE VARIABLE i-nrdias   AS INTEGER                   NO-UNDO.

    EMPTY TEMP-TABLE tt-idioma.

    ASSIGN c-msg = "".

    IF NOT VALID-HANDLE(h-bocx110) THEN
        RUN cxbo/bocx110.p PERSISTENT SET h-bocx110.

    IF NOT CAN-FIND (FIRST historico-embarque 
                     WHERE historico-embarque.cod-estabel = p-cod-estabel 
                       AND historico-embarque.embarque    = p-embarque    
                       AND historico-embarque.cod-itiner  = p-cod-itiner) THEN DO:

        IF p-hist-processo THEN DO:

            FOR EACH historico-proc-imp
               WHERE historico-proc-imp.cod-estabel = p-cod-estabel 
                 AND historico-proc-imp.nr-proc-imp = p-nr-proc-imp NO-LOCK:
                
                RUN incluiCamposEmitente (INPUT p-cod-estabel,
                                          INPUT p-embarque,   
                                          INPUT p-nr-proc-imp).
                
                FIND FIRST pto-contr 
                     WHERE pto-contr.cod-pto-contr = historico-proc-imp.cod-pto-contr NO-LOCK NO-ERROR.
                     
    
                FOR FIRST pto-itiner 
                    WHERE pto-itiner.cod-itiner    = p-cod-itiner
                      AND pto-itiner.cod-pto-contr = pto-contr.cod-pto-contr NO-LOCK: END.
    
                CREATE historico-embarque.
                BUFFER-COPY historico-proc-imp EXCEPT historico-proc-imp.nr-proc-imp TO historico-embarque.
                ASSIGN historico-embarque.embarque  = p-embarque
                       historico-embarque.descricao = pto-contr.descricao
                       historico-embarque.log-1     = not(pto-contr.log-1)
                       historico-embarque.nr-dias   = IF AVAIL pto-itiner THEN pto-itiner.nr-dias ELSE 0. 
            END.
    
            FOR EACH decl-hist-proc-imp
               WHERE decl-hist-proc-imp.cod-estabel = p-cod-estabel
                 AND decl-hist-proc-imp.nr-proc-imp = p-nr-proc-imp NO-LOCK:

                CREATE decl-hist-embarq-imp.
                BUFFER-COPY decl-hist-proc-imp EXCEPT decl-hist-proc-imp.nr-proc-imp TO decl-hist-embarq-imp.
                ASSIGN decl-hist-embarq-imp.embarque = p-embarque.
            END.
            
            FOR EACH decl-itiner 
               WHERE decl-itiner.cod-itiner = p-cod-itiner NO-LOCK:
                
                FIND FIRST historico-embarque 
                     WHERE historico-embarque.cod-pto-contr = decl-itiner.cod-pto-contr
                       AND historico-embarque.embarque      = p-embarque 
                       AND historico-embarque.cod-estabel   = p-cod-estabel
                       AND historico-embarque.cod-itiner    = p-cod-itiner NO-LOCK NO-ERROR.
                            
                FIND FIRST decl-hist-proc-imp 
                     WHERE decl-hist-proc-imp.cod-estabel = p-cod-estabel
                       AND decl-hist-proc-imp.cod-itiner  = p-cod-itiner
                       AND decl-hist-proc-imp.sequencia   = historico-embarque.sequencia 
                       AND decl-hist-proc-imp.de-codigo   = decl-itiner.de-codigo EXCLUSIVE-LOCK NO-ERROR.
            
                FIND FIRST decl-hist-embarq-imp 
                     WHERE decl-hist-embarq-imp.sequencia   = historico-embarque.sequencia 
                       AND decl-hist-embarq-imp.cod-estabel = p-cod-estabel
                       AND decl-hist-embarq-imp.embarque    = p-embarque 
                       AND decl-hist-embarq-imp.cod-itiner  = p-cod-itiner
                       AND decl-hist-embarq-imp.sequencia   = historico-embarque.sequencia
                       AND decl-hist-embarq-imp.de-codigo   = decl-itiner.de-codigo EXCLUSIVE-LOCK NO-ERROR.
    
              																					  										  	
                IF NOT AVAIL decl-hist-embarq-imp THEN DO:
                    
                    CREATE decl-hist-embarq-imp.
                    ASSIGN decl-hist-embarq-imp.cod-estabel = p-cod-estabel
                           decl-hist-embarq-imp.embarque    = p-embarque
                           decl-hist-embarq-imp.cod-itiner  = p-cod-itiner
                           decl-hist-embarq-imp.sequencia   = historico-embarque.sequencia
                           decl-hist-embarq-imp.de-codigo   = decl-itiner.de-codigo
                           decl-hist-embarq-imp.int-1       = decl-itiner.emite-decl-docum
                           decl-hist-embarq-imp.int-2       = decl-itiner.dias-tolerancia.
                END.
    
                           
                IF decl-itiner.emite-emitente THEN DO:
                    {imp/im9026.i2 p-cod-exportador e-mail-emitente}
                END.
                IF decl-itiner.emite-despachante THEN DO:
                    {imp/im9026.i2 p-cod-despachante e-mail-despachante}
                END.
                IF decl-itiner.emite-agentecarga THEN DO:
                    {imp/im9026.i2 p-cod-agente e-mail-agente}
                END.
                IF decl-itiner.emite-representante THEN DO:

                    FOR FIRST emitente-cex FIELDS(cod-repres cod-idioma)
                        WHERE emitente-cex.cod-emitente = p-cod-exportador NO-LOCK: END.

                    IF AVAIL emitente-cex THEN DO:
                        FIND FIRST repres 
                             WHERE repres.cod-rep = emitente-cex.cod-repres NO-LOCK NO-ERROR.

                        IF AVAIL repres THEN
                            ASSIGN decl-hist-embarq-imp.e-mail-repres = repres.e-mail.            

                        FIND FIRST tt-idioma 
                             WHERE tt-idioma.cod-idioma = emitente-cex.cod-idioma NO-ERROR.

                        IF NOT AVAIL tt-idioma THEN DO:
                            CREATE tt-idioma.
                            ASSIGN tt-idioma.cod-idioma = emitente-cex.cod-idioma.
                        END.     
                    END.           
                END.      
                IF decl-itiner.emite-fabricante THEN DO:
                    {imp/im9026.i2 p-cod-fabricante e-mail-fabricante}
                END.
                
                IF decl-itiner.emite-outros THEN DO:

                    ASSIGN decl-hist-embarq-imp.e-mail-outros = decl-itiner.destinatario-outros.    
                    
                    FIND FIRST processo-imp WHERE processo-imp.nr-proc-imp = p-nr-proc-imp NO-LOCK NO-ERROR.

                    IF AVAIL processo-imp THEN DO:

                        FIND FIRST tt-idioma 
                             WHERE tt-idioma.cod-idioma = processo-imp.cod-idioma NO-ERROR.

                        IF NOT AVAIL tt-idioma THEN DO:

                            CREATE tt-idioma.
                            ASSIGN tt-idioma.cod-idioma = processo-imp.cod-idioma.
                        END.
                    END.
                END.
                
                FOR EACH tt-idioma:

                    FOR FIRST decl-cliente FIELDS(texto)
                        WHERE decl-cliente.cod-emitente = p-cod-exportador 
                          AND decl-cliente.de-codigo    = decl-itiner.de-codigo 
                          AND decl-cliente.cod-idioma   = tt-idioma.cod-idioma NO-LOCK: END.

                    IF AVAIL decl-cliente THEN DO:

                        ASSIGN i-pos = LENGTH(decl-cliente.texto).

                        IF decl-hist-embarq-imp.texto <> " ":U THEN 
                            ASSIGN decl-hist-embarq-imp.texto = decl-hist-embarq-imp.texto + CHR(10) + CHR(10) + TRIM(decl-cliente.texto).
                        ELSE 
                            ASSIGN decl-hist-embarq-imp.texto = TRIM(decl-cliente.texto).
                    END.
                    ELSE DO:

                        FOR FIRST decl-cliente FIELDS(texto) 
                            WHERE decl-cliente.cod-emitente = 0 
                              AND decl-cliente.de-codigo    = decl-itiner.de-codigo 
                              AND decl-cliente.cod-idioma   = tt-idioma.cod-idioma NO-LOCK: END.

                        IF AVAIL decl-cliente THEN DO:

                            ASSIGN i-pos = LENGTH(decl-cliente.texto).

                            IF decl-hist-embarq-imp.texto <> "" THEN 
                                ASSIGN decl-hist-embarq-imp.texto = decl-hist-embarq-imp.texto + CHR(10) + CHR(10) + TRIM(decl-cliente.texto).
                            ELSE 
                                ASSIGN decl-hist-embarq-imp.texto = TRIM(decl-cliente.texto).
                        END.
                    END.
                END.
            END.
        END.
        ELSE DO: 

            ASSIGN dt-emissao = p-dt-emissao.

            FOR FIRST pto-itiner FIELDS(sequencia cod-pto-contr nr-dias)
                WHERE pto-itiner.cod-itiner    = p-cod-itiner 
                  AND pto-itiner.cod-pto-contr = p-pto-chegada NO-LOCK: END.

            IF NOT AVAIL pto-itiner THEN DO:

                RUN criaTTBoErro(INPUT 25196, INPUT "").
                RUN pi-delete-dbos IN THIS-PROCEDURE.
                UNDO, LEAVE.
            END.
            ELSE DO:

                RUN incluiCamposEmitente (INPUT p-cod-estabel,
                                          INPUT p-embarque,   
                                          INPUT p-nr-proc-imp).
                
                FIND FIRST pto-contr 
                     WHERE pto-contr.cod-pto-contr = pto-itiner.cod-pto-contr NO-LOCK NO-ERROR.
                     
    
                RUN pi-busca-uf(INPUT pto-contr.cod-pto-contr, OUTPUT c-cod-uf).
    
                CREATE historico-embarque.
                ASSIGN historico-embarque.cod-itiner          = p-cod-itiner
                       historico-embarque.cod-estabel         = p-cod-estabel
                       historico-embarque.embarque            = p-embarque
                       historico-embarque.dt-previsao         = dt-emissao /*+ pto-itiner.nr-dias*/
                       historico-embarque.dt-ult-previsao     = historico-embarque.dt-previsao
                       historico-embarque.sequencia           = pto-itiner.sequencia
                       historico-embarque.cod-pto-contr       = pto-itiner.cod-pto-contr
                       historico-embarque.descricao           = pto-contr.descricao
                       historico-embarque.log-1               = NOT(pto-contr.log-1)
                       historico-embarque.nr-dias             = pto-itiner.nr-dias 
                       dt-emissao                             = historico-embarque.dt-previsao
                       OVERLAY(historico-embarque.char-1,1,2) = c-cod-uf.
                
                FOR EACH decl-itiner 
                   WHERE decl-itiner.cod-itiner     = p-cod-itiner 
                     AND decl-itiner.cod-pto-contr  = pto-itiner.cod-pto-contr NO-LOCK:

                    CREATE decl-hist-embarq-imp.
                    ASSIGN decl-hist-embarq-imp.cod-estabel = p-cod-estabel
                           decl-hist-embarq-imp.embarque    = p-embarque
                           decl-hist-embarq-imp.cod-itiner  = p-cod-itiner
                           decl-hist-embarq-imp.sequencia   = pto-itiner.sequencia
                           decl-hist-embarq-imp.de-codigo   = decl-itiner.de-codigo
                           decl-hist-embarq-imp.int-1       = decl-itiner.emite-decl-docum
                           decl-hist-embarq-imp.int-2       = decl-itiner.dias-tolerancia.
                           
                    IF decl-itiner.emite-emitente THEN DO:
                        {imp/im9026.i2 p-cod-exportador e-mail-emitente}
                    END.
                    IF decl-itiner.emite-despachante THEN DO:
                        {imp/im9026.i2 p-cod-despachante e-mail-despachante}
                    END.
                    IF decl-itiner.emite-agentecarga THEN DO:
                        {imp/im9026.i2 p-cod-agente e-mail-agente}
                    END.
                    IF decl-itiner.emite-representante THEN DO:
                        FOR FIRST emitente-cex FIELDS(cod-repres cod-idioma)
                            WHERE emitente-cex.cod-emitente = p-cod-exportador NO-LOCK: END.
                        IF AVAIL emitente-cex THEN DO:
                            FIND FIRST repres 
                                 WHERE repres.cod-rep = emitente-cex.cod-repres NO-LOCK NO-ERROR.
                            IF AVAIL repres THEN
                                ASSIGN decl-hist-embarq-imp.e-mail-repres = repres.e-mail.            
                            FIND FIRST tt-idioma 
                                 WHERE tt-idioma.cod-idioma = emitente-cex.cod-idioma NO-ERROR.
                            IF NOT AVAIL tt-idioma THEN DO:
                                CREATE tt-idioma.
                                ASSIGN tt-idioma.cod-idioma = emitente-cex.cod-idioma.
                            END.     
                        END.           
                    END.      
                    IF decl-itiner.emite-fabricante THEN DO:
                        {imp/im9026.i2 p-cod-fabricante e-mail-fabricante}
                    END.
                    IF decl-itiner.emite-outros THEN DO:
                        
                        ASSIGN decl-hist-embarq-imp.e-mail-outros = decl-itiner.destinatario-outros.    

                        FIND FIRST processo-imp WHERE processo-imp.nr-proc-imp = p-nr-proc-imp NO-LOCK NO-ERROR.

                        IF AVAIL processo-imp THEN DO:
                            FIND FIRST tt-idioma 
                                 WHERE tt-idioma.cod-idioma = processo-imp.cod-idioma NO-ERROR.
                            IF NOT AVAIL tt-idioma THEN DO:
                                CREATE tt-idioma.
                                ASSIGN tt-idioma.cod-idioma = processo-imp.cod-idioma.
                            END.
                        END.
                    END.
                    FOR EACH tt-idioma:
                        FOR FIRST decl-cliente FIELDS(texto)
                            WHERE decl-cliente.cod-emitente = p-cod-exportador 
                              AND decl-cliente.de-codigo    = decl-itiner.de-codigo 
                              AND decl-cliente.cod-idioma   = tt-idioma.cod-idioma NO-LOCK: END.
                        
                        IF AVAIL decl-cliente THEN DO:

                            ASSIGN i-pos = LENGTH(decl-cliente.texto).

                            IF decl-hist-embarq-imp.texto <> " ":U THEN 
                                ASSIGN decl-hist-embarq-imp.texto = decl-hist-embarq-imp.texto + CHR(10) + CHR(10) + TRIM(decl-cliente.texto).
                            ELSE 
                                ASSIGN decl-hist-embarq-imp.texto = TRIM(decl-cliente.texto).
                        END.
                        ELSE DO:
                            FOR FIRST decl-cliente FIELDS(texto) 
                                WHERE decl-cliente.cod-emitente = 0 
                                  AND decl-cliente.de-codigo    = decl-itiner.de-codigo 
                                  AND decl-cliente.cod-idioma   = tt-idioma.cod-idioma NO-LOCK: END.

                            IF AVAIL decl-cliente THEN DO:

                                ASSIGN i-pos = LENGTH(decl-cliente.texto).

                                IF decl-hist-embarq-imp.texto <> "" THEN 
                                    ASSIGN decl-hist-embarq-imp.texto = decl-hist-embarq-imp.texto + CHR(10) + CHR(10) + TRIM(decl-cliente.texto).
                                ELSE 
                                    ASSIGN decl-hist-embarq-imp.texto = TRIM(decl-cliente.texto).
                            END.
                        END.
                    END.
                END.
            END.
            
            /**** Atualiza ptos de controle antes da chegada ***/
    
            ASSIGN dt-emissao = p-dt-emissao.
            FIND FIRST pto-itiner
                 WHERE pto-itiner.cod-itiner    = p-cod-itiner 
                   AND pto-itiner.cod-pto-contr = p-pto-chegada NO-LOCK NO-ERROR.

            IF AVAIL pto-itiner THEN DO:

                ASSIGN i-nrdias = pto-itiner.nr-dias.

                REPEAT:
                    FIND PREV pto-itiner NO-LOCK 
                        WHERE pto-itiner.cod-itiner = p-cod-itiner NO-ERROR.

                    FIND FIRST pto-contr NO-LOCK 
                        WHERE pto-contr.cod-pto-contr = pto-itiner.cod-pto-contr NO-ERROR.

                    IF AVAIL pto-itiner THEN DO:
    
                        RUN pi-busca-uf(INPUT pto-itiner.cod-pto-contr, OUTPUT c-cod-uf).
    
                        CREATE historico-embarque.
                        ASSIGN historico-embarque.cod-itiner          = p-cod-itiner
                               historico-embarque.cod-estabel         = p-cod-estabel
                               historico-embarque.embarque            = p-embarque
                               historico-embarque.dt-previsao         = dt-emissao - i-nrdias
                               historico-embarque.dt-ult-previsao     = historico-embarque.dt-previsao
                               historico-embarque.sequencia           = pto-itiner.sequencia
                               historico-embarque.cod-pto-contr       = pto-itiner.cod-pto-contr
                               historico-embarque.descricao           = pto-contr.descricao WHEN AVAIL pto-contr
                               historico-embarque.log-1               = NOT(pto-contr.log-1) WHEN AVAIL pto-contr
                               historico-embarque.nr-dias             = pto-itiner.nr-dias
                               dt-emissao                             = historico-embarque.dt-previsao
                               i-nrdias                               = pto-itiner.nr-dias
                               OVERLAY(historico-embarque.char-1,1,2) = c-cod-uf.  
    
                        IF pto-itiner.cod-pto-contr = p-pto-chegada THEN DO:

                            FOR EACH ordens-embarque FIELDS(numero-ordem parcela)
                               WHERE ordens-embarque.cod-estabel = p-cod-estabel 
                                 AND ordens-embarque.embarque    = p-embarque NO-LOCK:

                                FOR EACH prazo-compra 
                                   WHERE prazo-compra.numero-ordem = ordens-embarque.numero-ordem 
                                     AND prazo-compra.parcela      = ordens-embarque.parcela EXCLUSIVE-LOCK:

                                    IF prazo-compra.data-entrega <> dt-emissao THEN DO:
                                        
                                        FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem EXCLUSIVE-LOCK NO-ERROR.
                                            
                                        /* Criar Registro na tabela alt-ped */
                                        {cxbo/bocx140.i03 today
                                                          c-seg-usuario 
                                                          ordem-compra.num-pedido
                                                          ordem-compra.numero-ordem 
                                                          prazo-compra.parcela
                                                          prazo-compra.data-entrega
                                                          ?
                                                          ?
                                                          ordem-compra.cod-emitente
                                                          ordem-compra.gera-edi
                                                          ordem-compra.num-pedido
                                                          dt-emissao}   
                                    END.

                                    ASSIGN prazo-compra.data-entrega = dt-emissao.
                                END.
                            END.
                        END.
                        FOR EACH decl-itiner 
                           WHERE decl-itiner.cod-itiner     = p-cod-itiner 
                             AND decl-itiner.cod-pto-contr  = pto-itiner.cod-pto-contr NO-LOCK:

                            CREATE decl-hist-embarq-imp.
                            ASSIGN decl-hist-embarq-imp.cod-estabel = p-cod-estabel
                                   decl-hist-embarq-imp.embarque    = p-embarque
                                   decl-hist-embarq-imp.cod-itiner  = p-cod-itiner
                                   decl-hist-embarq-imp.sequencia   = pto-itiner.sequencia
                                   decl-hist-embarq-imp.de-codigo   = decl-itiner.de-codigo
                                   decl-hist-embarq-imp.int-1       = decl-itiner.emite-decl-docum
                                   decl-hist-embarq-imp.int-2       = decl-itiner.dias-tolerancia.
                                   
                            IF decl-itiner.emite-emitente THEN DO:
                                {imp/im9026.i2 p-cod-exportador e-mail-emitente}
                            END.
                            IF decl-itiner.emite-despachante THEN DO:
                                {imp/im9026.i2 p-cod-despachante e-mail-despachante}
                            END.
                            IF decl-itiner.emite-agentecarga THEN DO:
                                {imp/im9026.i2 p-cod-agente e-mail-agente}
                            END.
                            IF decl-itiner.emite-representante THEN DO:
                                
                                FIND FIRST emitente-cex 
                                     WHERE emitente-cex.cod-emitente = p-cod-exportador NO-LOCK NO-ERROR.

                                IF AVAIL emitente-cex THEN DO:
                                    
                                    FIND FIRST repres 
                                         WHERE repres.cod-rep = emitente-cex.cod-repres NO-LOCK NO-ERROR.
                                    
                                    IF AVAIL repres THEN
                                        ASSIGN decl-hist-embarq-imp.e-mail-repres = repres.e-mail.            

                                    FIND FIRST tt-idioma 
                                         WHERE tt-idioma.cod-idioma = emitente-cex.cod-idioma NO-ERROR.
                                    
                                    IF NOT AVAIL tt-idioma THEN DO:
                                        CREATE tt-idioma.
                                        ASSIGN tt-idioma.cod-idioma = emitente-cex.cod-idioma.
                                    END.     
                                END.
                            END.
                            IF decl-itiner.emite-fabricante THEN DO:
                                {imp/im9026.i2 p-cod-fabricante e-mail-fabricante}
                            END.
                            IF decl-itiner.emite-outros THEN DO:

                                ASSIGN decl-hist-embarq-imp.e-mail-outros = decl-itiner.destinatario-outros.

                                FIND FIRST processo-imp WHERE processo-imp.nr-proc-imp = p-nr-proc-imp NO-LOCK NO-ERROR.

                                IF AVAIL processo-imp THEN DO:

                                    FIND FIRST tt-idioma 
                                         WHERE tt-idioma.cod-idioma = processo-imp.cod-idioma NO-ERROR.

                                    IF NOT AVAIL tt-idioma THEN DO:
                                        CREATE tt-idioma.
                                        ASSIGN tt-idioma.cod-idioma = processo-imp.cod-idioma.
                                    END.
                                END.
                            END.
                            FOR EACH tt-idioma:
                                
                                FOR FIRST decl-cliente FIELDS(texto)
                                    WHERE decl-cliente.cod-emitente = p-cod-exportador 
                                      AND decl-cliente.de-codigo    = decl-itiner.de-codigo 
                                      AND decl-cliente.cod-idioma   = tt-idioma.cod-idioma NO-LOCK: END.
                                
                                IF AVAIL decl-cliente THEN DO:
                                    ASSIGN i-pos = LENGTH(decl-cliente.texto).

                                    IF decl-hist-embarq-imp.texto <> " ":U THEN 
                                        ASSIGN decl-hist-embarq-imp.texto = decl-hist-embarq-imp.texto + CHR(10) + CHR(10) + TRIM(decl-cliente.texto).
                                    ELSE 
                                        ASSIGN decl-hist-embarq-imp.texto = TRIM(decl-cliente.texto).
                                END.
                                ELSE DO:

                                    FOR FIRST decl-cliente FIELDS(texto) 
                                        WHERE decl-cliente.cod-emitente = 0 
                                          AND decl-cliente.de-codigo    = decl-itiner.de-codigo 
                                          AND decl-cliente.cod-idioma   = tt-idioma.cod-idioma NO-LOCK: END.

                                    IF AVAIL decl-cliente THEN DO:
                                        
                                        ASSIGN i-pos = LENGTH(decl-cliente.texto).

                                        IF decl-hist-embarq-imp.texto <> "" THEN 
                                            ASSIGN decl-hist-embarq-imp.texto = decl-hist-embarq-imp.texto + CHR(10) + CHR(10) + TRIM(decl-cliente.texto).
                                        ELSE 
                                            ASSIGN decl-hist-embarq-imp.texto = TRIM(decl-cliente.texto).
                                    END.
                                END.
                            END.
                        END.
                    END.
                    ELSE LEAVE. 
                END. /*repeat*/
            END.
            
            /**** Atualiza ptos de controle depois da chegada ***/
            ASSIGN dt-emissao = p-dt-emissao.

            FIND FIRST pto-itiner
                 WHERE pto-itiner.cod-itiner = p-cod-itiner 
                   AND pto-itiner.cod-pto-contr = p-pto-chegada NO-LOCK NO-ERROR.

            IF AVAIL pto-itiner THEN DO:
                
                REPEAT:
                    FIND NEXT pto-itiner no-lock WHERE pto-itiner.cod-itiner = p-cod-itiner NO-ERROR.
                    
                    FIND FIRST pto-contr NO-LOCK 
                         WHERE pto-contr.cod-pto-contr = pto-itiner.cod-pto-contr NO-ERROR.

                    IF AVAIL pto-itiner THEN DO:
    
                        RUN pi-busca-uf(INPUT pto-itiner.cod-pto-contr, OUTPUT c-cod-uf).
    
                        CREATE historico-embarque.
                        ASSIGN historico-embarque.cod-itiner          = p-cod-itiner
                               historico-embarque.cod-estabel         = p-cod-estabel
                               historico-embarque.embarque            = p-embarque
                               historico-embarque.dt-previsao         = dt-emissao + pto-itiner.nr-dias
                               historico-embarque.dt-ult-previsao     = historico-embarque.dt-previsao
                               historico-embarque.sequencia           = pto-itiner.sequencia
                               historico-embarque.cod-pto-contr       = pto-itiner.cod-pto-contr
                               historico-embarque.descricao           = pto-contr.descricao WHEN AVAIL pto-contr
                               historico-embarque.log-1               = NOT(pto-contr.log-1) WHEN AVAIL pto-contr
                               historico-embarque.nr-dias             = pto-itiner.nr-dias 
                               dt-emissao                             = historico-embarque.dt-previsao
                               OVERLAY(historico-embarque.char-1,1,2) = c-cod-uf.  
    
                        IF pto-itiner.cod-pto-contr = p-pto-chegada THEN DO:

                            FOR EACH ordens-embarque 
                               WHERE ordens-embarque.cod-estabel = p-cod-estabel 
                                 AND ordens-embarque.embarque    = p-embarque NO-LOCK:

                                FOR EACH prazo-compra 
                                   WHERE prazo-compra.numero-ordem = ordens-embarque.numero-ordem 
                                     AND prazo-compra.parcela      = ordens-embarque.parcela EXCLUSIVE-LOCK:

                                    IF prazo-compra.data-entrega <> dt-emissao THEN DO:
                                        
                                        FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem EXCLUSIVE-LOCK NO-ERROR.
                                        /* Criar Registro na tabela alt-ped */
                                        {cxbo/bocx140.i03 today
                                                          c-seg-usuario 
                                                          ordem-compra.num-pedido
                                                          ordem-compra.numero-ordem 
                                                          prazo-compra.parcela
                                                          prazo-compra.data-entrega
                                                          ?
                                                          ?
                                                          ordem-compra.cod-emitente
                                                          ordem-compra.gera-edi
                                                          ordem-compra.num-pedido
                                                          dt-emissao}   
                                    END. 
                                    ASSIGN prazo-compra.data-entrega = dt-emissao.
                                END.
                            END.
                        END.
                        FOR EACH decl-itiner 
                           WHERE decl-itiner.cod-itiner     = p-cod-itiner 
                             AND decl-itiner.cod-pto-contr  = pto-itiner.cod-pto-contr NO-LOCK:

                            CREATE decl-hist-embarq-imp.
                            ASSIGN decl-hist-embarq-imp.cod-estabel = p-cod-estabel
                                   decl-hist-embarq-imp.embarque    = p-embarque
                                   decl-hist-embarq-imp.cod-itiner  = p-cod-itiner
                                   decl-hist-embarq-imp.sequencia   = pto-itiner.sequencia
                                   decl-hist-embarq-imp.de-codigo   = decl-itiner.de-codigo
                                   decl-hist-embarq-imp.int-1       = decl-itiner.emite-decl-docum
                                   decl-hist-embarq-imp.int-2       = decl-itiner.dias-tolerancia.
                                   
                            IF decl-itiner.emite-emitente THEN DO:
                                {imp/im9026.i2 p-cod-exportador e-mail-emitente}
                            END.
                            IF decl-itiner.emite-despachante THEN DO:
                                {imp/im9026.i2 p-cod-despachante e-mail-despachante}
                            END.
                            IF decl-itiner.emite-agentecarga THEN DO:
                                {imp/im9026.i2 p-cod-agente e-mail-agente}
                            END.
                            IF decl-itiner.emite-representante THEN DO:

                                FIND FIRST emitente-cex 
                                     WHERE emitente-cex.cod-emitente = p-cod-exportador NO-LOCK NO-ERROR.

                                IF AVAIL emitente-cex THEN DO:
                                    
                                    FIND FIRST repres 
                                         WHERE repres.cod-rep = emitente-cex.cod-repres NO-LOCK NO-ERROR.
                                    
                                    IF AVAIL repres THEN
                                        ASSIGN decl-hist-embarq-imp.e-mail-repres = repres.e-mail.            
                                    FIND FIRST tt-idioma 
                                         WHERE tt-idioma.cod-idioma = emitente-cex.cod-idioma NO-ERROR.

                                    IF NOT AVAIL tt-idioma THEN DO:
                                        CREATE tt-idioma.
                                        ASSIGN tt-idioma.cod-idioma = emitente-cex.cod-idioma.
                                    END.
                                END.
                            END.

                            IF decl-itiner.emite-fabricante THEN DO:
                                {imp/im9026.i2 p-cod-fabricante e-mail-fabricante}
                            END.
                            IF decl-itiner.emite-outros THEN DO:
                                
                                ASSIGN decl-hist-embarq-imp.e-mail-outros = decl-itiner.destinatario-outros.    

                                FIND FIRST processo-imp WHERE processo-imp.nr-proc-imp = p-nr-proc-imp NO-LOCK NO-ERROR.

                                IF AVAIL processo-imp THEN DO:
                                    FIND FIRST tt-idioma 
                                         WHERE tt-idioma.cod-idioma = processo-imp.cod-idioma NO-ERROR.

                                    IF NOT AVAIL tt-idioma THEN DO:
                                        CREATE tt-idioma.
                                        ASSIGN tt-idioma.cod-idioma = processo-imp.cod-idioma.
                                    END.
                                END.
                            END.

                            FOR EACH tt-idioma:

                                FOR FIRST decl-cliente FIELDS(texto) 
                                    WHERE decl-cliente.cod-emitente = p-cod-exportador 
                                      AND decl-cliente.de-codigo    = decl-itiner.de-codigo 
                                      AND decl-cliente.cod-idioma   = tt-idioma.cod-idioma NO-LOCK: END.

                                IF AVAIL decl-cliente THEN DO:

                                    ASSIGN i-pos = LENGTH(decl-cliente.texto).

                                    IF decl-hist-embarq-imp.texto <> " ":U THEN 
                                        ASSIGN decl-hist-embarq-imp.texto = decl-hist-embarq-imp.texto + CHR(10) + CHR(10) + TRIM(decl-cliente.texto).
                                    ELSE 
                                        ASSIGN decl-hist-embarq-imp.texto = TRIM(decl-cliente.texto).
                                END.
                                ELSE DO:

                                    FOR FIRST decl-cliente FIELDS(texto) 
                                        WHERE decl-cliente.cod-emitente = 0 
                                          AND decl-cliente.de-codigo    = decl-itiner.de-codigo 
                                          AND decl-cliente.cod-idioma   = tt-idioma.cod-idioma NO-LOCK: END.

                                    IF AVAIL decl-cliente THEN DO:

                                        ASSIGN i-pos = LENGTH(decl-cliente.texto).

                                        IF decl-hist-embarq-imp.texto <> "" THEN 
                                            ASSIGN decl-hist-embarq-imp.texto = decl-hist-embarq-imp.texto + CHR(10) + CHR(10) + TRIM(decl-cliente.texto).
                                        ELSE 
                                            ASSIGN decl-hist-embarq-imp.texto = TRIM(decl-cliente.texto).
                                    END.
                                END.
                            END.
                        END.
                    END.
                    ELSE LEAVE.
                END.
            END. /*repeat*/
        END.     

        RUN piAtualizaEmbarqueImp (INPUT p-cod-estabel,
                                   INPUT p-embarque,   
                                   INPUT p-cod-itiner,
                                   INPUT p-nr-proc-imp).    
    END.
    
    RUN pi-delete-dbos IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-atualizaSitProc:
/*------------------------------------------------------------------------------
  Purpose: Atualiza¯Êo da Situa¯Êo do Processo
  Parameters:  INPUT - p-num-pedido (integer) - numero do pedido de compra
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    DEFINE VARIABLE de-quant-disp LIKE prazo-compra.quantidade NO-UNDO.

    FOR EACH ordem-compra
       WHERE ordem-compra.num-pedido = p-num-pedido NO-LOCK:
        /* Quantidade disponivel */
        RUN pi-calculaQtdeDisponivel(INPUT ordem-compra.numero-ordem,
                                     OUTPUT de-quant-disp).
        IF de-quant-disp > 0 THEN
            LEAVE.
    END.
    
    FIND FIRST processo-imp
         WHERE processo-imp.num-pedido = p-num-pedido EXCLUSIVE-LOCK NO-ERROR.
    
    IF de-quant-disp > 0 THEN
        ASSIGN processo-imp.situacao = 2. /* Embarcado parcial */
    ELSE 
        ASSIGN processo-imp.situacao = 3. /* Embarcado total */

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE DataEntrega:
/*------------------------------------------------------------------------------
  Purpose: Retorna data de entrega da ordem/parcela passadas como parametro 
  Parameters:  INPUT - p-numero-ordem (integer) - numero da ordem de compra   
               INPUT - p-parcela (integer) - numero da parcela da ordem de compra
               OUTPUT - p-data-entrega - data de entrega da parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAMETER p-parcela      LIKE prazo-compra.parcela      NO-UNDO.
    DEFINE OUTPUT PARAMETER p-data-entrega LIKE prazo-compra.data-entrega NO-UNDO.
    
    FIND FIRST prazo-compra  
         WHERE prazo-compra.numero-ordem = p-numero-ordem
           AND prazo-compra.parcela      = p-parcela  NO-LOCK NO-ERROR.

    IF AVAIL prazo-compra THEN DO:
       ASSIGN p-data-entrega = prazo-compra.data-entrega.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE validaembarque:
/*------------------------------------------------------------------------------
  Purpose: Verifica se existe o embarque passado como parametro 
  Parameters:  INPUT - p-cod-embarque (character) - codigo do embarque
               OUTPUT - p-ok (logical) - determina se existe ou nao o embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-embarque LIKE embarque-imp.embarque   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-ok           AS   LOGICAL INITIAL YES     NO-UNDO.
    
    IF CAN-FIND(FIRST embarque-imp 
                WHERE embarque-imp.embarque = p-cod-embarque) THEN 
        ASSIGN p-ok = NO.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE ValidaNovaDataEntrega:
/*------------------------------------------------------------------------------
  Purpose: Procedure criado para validar a nova data de entrega para                                      
           nova parcela, pois nÆo pode ser menor que a data de entrega                                    
           da parcela anterior.                                                                           
           A procedure ‚ executada apartir dos programas im0045a e im0044, e as valida‡äes foram retiradas
           da boin356vl.p na procedure validateFieldsBusinessLogic.                                       
  Parameters:  INPUT - p-numero-ordem (integer) - numero da ordem de compra
               INPUT - p-data-entrega (date) - data de entrega
               OUTPUT TABLE - tt-bo-erro - erros ocorridos durante o processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-numero-ordem    LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAMETER p-data-entrega    LIKE prazo-compra.data-entrega NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    DEFINE VARIABLE dt-entrega AS INTEGER NO-UNDO.
    DEFINE VARIABLE dt-ressup  AS INTEGER NO-UNDO.

    EMPTY TEMP-TABLE tt-bo-erro.
    
    FIND FIRST ordem-compra 
         WHERE ordem-compra.numero-ordem = p-numero-ordem NO-LOCK NO-ERROR. 

    FIND FIRST pedido-compr 
         WHERE pedido-compr.num-pedido   = ordem-compra.num-pedido NO-LOCK NO-ERROR.

    FIND FIRST prazo-compra 
         WHERE prazo-compra.numero-ordem = p-numero-ordem NO-LOCK NO-ERROR.

    IF AVAIL prazo-compra THEN DO:
        FIND FIRST item 
             WHERE item.it-codigo = prazo-compra.it-codigo NO-LOCK NO-ERROR.
        
        IF AVAIL item THEN
           FOR FIRST item-uni-estab FIELDS(it-codigo cod-estabel res-int-comp res-for-comp) 
                WHERE item-uni-estab.cod-estabel = ordem-compra.cod-estabel 
                  AND item-uni-estab.it-codigo   = item.it-codigo NO-LOCK:
           END.
    END.

    IF AVAIL pedido-compr THEN DO:
        IF p-data-entrega < pedido-compr.data-pedido THEN DO:
            
            /* Data deve ser maior ou igual a Data de Implanta‡Æo do Pedido - (antes 322) */
            {utp/ut-liter.i "Prazo_Compra" *}
            RUN criaTTBoErro(INPUT 5668, INPUT RETURN-VALUE).
            
            UNDO, RETURN.
        END.
    END.
    ELSE DO:
        IF p-data-entrega < ordem-compra.data-emissao THEN DO:

            {utp/ut-liter.i "Prazo_Compra" *}
            RUN criaTTBoErro(INPUT 6719, INPUT RETURN-VALUE).

            UNDO, RETURN.
        END.
    END.
    
    IF CAN-FIND(FIRST prazo-compra 
                WHERE prazo-compra.numero-ordem = p-numero-ordem 
                  AND prazo-compra.data-entrega > p-data-entrega 
                  AND prazo-compra.situacao    <> 4) /* Eliminada */  THEN DO:

        ASSIGN i-seq-erro = i-seq-erro + 1.
        
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.parametros = "".
        
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 3997,
                           INPUT RETURN-VALUE).

        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 3997
               tt-bo-erro.mensagem     = RETURN-VALUE
               tt-bo-erro.errorSubType = "INFORMATION":U.

        IF AVAIL prazo-compra THEN
            ASSIGN dt-entrega = prazo-compra.data-entrega - TODAY.
        
        IF AVAIL item-uni-estab THEN
            ASSIGN dt-ressup =  item-uni-estab.res-int-comp + item-uni-estab.res-for-comp.
        ELSE
            IF AVAIL item THEN
               ASSIGN dt-ressup = item.res-int-comp + item.res-for-comp.
            
        IF dt-ressup > dt-entrega AND (AVAIL prazo-compra AND prazo-compra.situacao <> 6) /* Recebida */ THEN DO:

             ASSIGN i-seq-erro = i-seq-erro + 1.
             CREATE tt-bo-erro.             

             RUN utp/ut-msgs.p (INPUT "msg":U,
                                INPUT 26505,
                                INPUT "").             
             
             ASSIGN tt-bo-erro.i-sequen     = i-seq-erro 
                    tt-bo-erro.cd-erro      = 26505
                    tt-bo-erro.mensagem     = RETURN-VALUE
                    tt-bo-erro.errorsubtype = "INFORMATION":U.
             
             {utp/ut-liter.i "(Ressupr_Compras_+_Ressupr_Fornec)" *}
             ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
        END.   
    END.
    
    IF ordem-compra.nr-contrato <> 0 THEN DO:

        FOR FIRST contrato-for FIELDS(dt-ini-validade dt-ter-validade) 
            WHERE contrato-for.nr-contrato = ordem-compra.nr-contrato NO-LOCK: 
        END.

        IF AVAIL contrato-for THEN
            IF  p-data-entrega < contrato-for.dt-ini-validade 
            OR  p-data-entrega > contrato-for.dt-ter-validade THEN DO:

                RUN criaTTBoErro(INPUT 17538, INPUT "").
                
                UNDO, RETURN.
            END. 
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE createOrdensEmbarquebyparcela:
/*------------------------------------------------------------------------------
  Purpose: Criacao das Ordens Embarque via Ordens de Compra.
  Parameters:  INPUT - r-embarque (rowid) - rowid do embarque  
               INPUT - p-numero-ordem (integer) - numero da ordem de compra
               INPUT - p-parcela (integer) - numero da parcela da ordem de compra    
               INPUT - de-quant (decimal) - quantidade a ser criada ordens-embarque
               OUTPUT TABLE - tt-bo-erro - erros ocorridos durante o processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER r-embarque        AS ROWID                       NO-UNDO.
    DEFINE INPUT  PARAMETER p-numero-ordem    LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAMETER p-parcela         LIKE prazo-compra.parcela      NO-UNDO.
    DEFINE INPUT  PARAMETER de-quant          LIKE prazo-compra.quantidade   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.
    
    DEFINE VARIABLE de-quant-disp    LIKE prazo-compra.quantidade    NO-UNDO.
    DEFINE VARIABLE de-quant-falta   LIKE ordens-embarque.quantidade NO-UNDO.
    DEFINE VARIABLE de-quant-parcela LIKE ordens-embarque.quantidade NO-UNDO.
    DEFINE VARIABLE de-conv-val-cex  LIKE cotacao-item-cex.val-desp  NO-UNDO.
    DEFINE VARIABLE i-pto-embarque   LIKE pto-contr.cod-pto-contr    NO-UNDO.
    DEFINE VARIABLE i-pto-chegada    LIKE pto-contr.cod-pto-contr    NO-UNDO.
    DEFINE VARIABLE i-cod-itiner     LIKE itinerario.cod-itiner      NO-UNDO.
    DEFINE VARIABLE i-num-pedido     LIKE pedido-compr.num-pedido    NO-UNDO.
    DEFINE VARIABLE i-numero-ordem   LIKE ordem-compra.numero-ordem  NO-UNDO.
    DEFINE VARIABLE c-it-codigo      LIKE ordem-compra.it-codigo     NO-UNDO.
    DEFINE VARIABLE i-parcela        LIKE prazo-compra.parcela       NO-UNDO.
    DEFINE VARIABLE l-existe-hist    AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE i-mo-ordem       LIKE moeda.mo-codigo            NO-UNDO.
    DEFINE VARIABLE c-msg            AS   CHARACTER                  NO-UNDO.

    EMPTY TEMP-TABLE tt-bo-erro.
    
    ASSIGN i-seq-erro = 0.
    
    IF NOT VALID-HANDLE(h-boin356) THEN
        RUN inbo/boin356ab.p PERSISTENT SET h-boin356.
    IF NOT VALID-HANDLE(h-bodi425) THEN
        RUN dibo/bodi425.p   PERSISTENT SET h-bodi425.
    IF NOT VALID-HANDLE (h-bocx00488) THEN
        RUN cxbo/bocx00488.p PERSISTENT SET h-bocx00488.

    FOR FIRST embarque-imp FIELDS(cod-estabel embarque cdn-pto-chegad cdn-pto-embarq)
        WHERE ROWID(embarque-imp) = r-embarque NO-LOCK: END.

    IF NOT AVAIL embarque-imp THEN DO:

        {utp/ut-table.i mgcex embarque-imp 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE).
        RUN pi-delete-dbos IN THIS-PROCEDURE.

        UNDO, RETURN.
    END.

    FOR FIRST ordem-compra FIELDS(numero-ordem it-codigo mo-codigo num-pedido cod-emitente cod-estabel gera-edi)
        WHERE ordem-compra.numero-ordem = p-numero-ordem NO-LOCK: END.

    IF NOT AVAIL ordem-compra THEN DO:
        
        {utp/ut-table.i mgind ordem-compra 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE + "~~":U + STRING(p-numero-ordem)).
        RUN pi-delete-dbos IN THIS-PROCEDURE.
        
        UNDO, RETURN.
    END.

    IF NOT CAN-FIND (FIRST prazo-compra 
                     WHERE prazo-compra.numero-ordem = p-numero-ordem 
                       AND prazo-compra.parcela      = p-parcela) THEN DO:
        
        {utp/ut-table.i mgind prazo-compra 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE + "~~":U + STRING(p-numero-ordem)).
        RUN pi-delete-dbos IN THIS-PROCEDURE.

        UNDO, RETURN.
    END.

    IF VALID-HANDLE(h-bocx00488) then do:
        assign vd-cod-duimp-dts = 0.
        RUN piValidaEmbarqueDuimp in h-bocx00488 (input  embarque-imp.cod-estabel,
                                                  input  embarque-imp.embarque,
                                                  output vd-cod-duimp-dts).
        IF vd-cod-duimp-dts <> 0 THEN DO:
            {utp/ut-liter.i "Vincula‡Æo" *}
            ASSIGN c-lbl-liter-e[1] = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Embarque_j " *}
            ASSIGN c-lbl-liter-e[2] = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "…_DUIMP_No." *}
            ASSIGN c-lbl-liter-e[3] = TRIM(RETURN-VALUE).
            RUN criaTTBoErro(INPUT 27414,
                             input c-lbl-liter-e[1] + "~~":U 
                                 + c-lbl-liter-e[2] + "~~":U
                                 + c-lbl-liter-e[3] + string(vd-cod-duimp-dts)).
            RUN pi-delete-dbos IN THIS-PROCEDURE.
                                 
            UNDO, RETURN.
        END.
    end.
    
    /* Licenciamento Importacao */ 
    IF  NOT VALID-HANDLE (h-bocx230a) THEN
        RUN cxbo/bocx230a.p PERSISTENT SET h-bocx230a.
    
    ASSIGN l-necessita-li = NO.
    
    FIND FIRST param-imp 
         WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
    
    IF AVAIL param-imp AND SUBSTRING(param-imp.char-1,167,1) = "S":U THEN
        ASSIGN l-necessita-li = YES.
    ELSE
        IF CAN-FIND (FIRST item
                     WHERE item.it-codigo = ordem-compra.it-codigo
                       AND item.log-necessita-li) THEN
            ASSIGN l-necessita-li = YES.
    
    ASSIGN i-numero-ordem = ordem-compra.numero-ordem
           c-it-codigo    = ordem-compra.it-codigo
           i-mo-ordem     = ordem-compra.mo-codigo
           i-parcela      = p-parcela
           c-cod-estab    = ordem-compra.cod-estabel.

    FOR FIRST processo-imp
        WHERE processo-imp.num-pedido  = ordem-compra.num-pedido NO-LOCK: END.

    IF NOT AVAIL processo-imp THEN DO:

        {utp/ut-table.i mgcex processo-imp 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE + "~~":U + STRING(ordem-compra.num-pedido)).
        RUN pi-delete-dbos IN THIS-PROCEDURE.

        UNDO, RETURN.
    END.
    
    /*  Verifica se processo esta encerrado/embarcado total */
    IF processo-imp.situacao >= 3 THEN DO:
        
        {utp/ut-table.i mgcex processo-imp 1}
        RUN criaTTBoErro(INPUT 15239, INPUT return-value + " " + processo-imp.nr-proc-imp).
        RUN pi-delete-dbos IN THIS-PROCEDURE.

        UNDO, RETURN.
    END.

    /* Verifica se itinerario do processo e o mesmo do outro itinerario ja informado  */
    FOR FIRST historico-embarque
        WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
          AND historico-embarque.embarque    = embarque-imp.embarque NO-LOCK: END.

    IF AVAIL historico-embarque THEN DO:

        ASSIGN l-existe-hist = YES.
        
        IF historico-embarque.cod-itiner <> processo-imp.cod-itiner THEN DO:

            RUN criaTTBoErro(INPUT 17751, INPUT processo-imp.nr-proc-imp).
            RUN pi-delete-dbos IN THIS-PROCEDURE.

            UNDO, RETURN.
        END.
    END.

    /* Verfica se o exportador e o mesmo de todas as ordens informadas */ 
    FOR FIRST ordens-embarque FIELDS(numero-ordem)
        WHERE ordens-embarque.cod-estabel  = embarque-imp.cod-estabel 
        AND   ordens-embarque.embarque     = embarque-imp.embarque NO-LOCK:

        FOR FIRST ordem-compra FIELDS(numero-ordem it-codigo mo-codigo num-pedido cod-estabel cod-emitente gera-edi) 
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:

            IF processo-imp.cod-exportador <> ordem-compra.cod-emitente THEN DO:

                RUN criaTTBoErro(INPUT 17888, INPUT "").
                RUN pi-delete-dbos IN THIS-PROCEDURE.

                UNDO, RETURN.
            END.
            IF i-mo-ordem <> ordem-compra.mo-codigo THEN DO:

                RUN criaTTBoErro(INPUT 26194, INPUT STRING(i-mo-ordem) + "~~":U + STRING(i-numero-ordem) + "~~":U + STRING(ordem-compra.mo-codigo)).
                RUN pi-delete-dbos IN THIS-PROCEDURE.

                UNDO, RETURN.
            END.
        END.
    END.

    FOR FIRST itinerario 
        WHERE itinerario.cod-itiner = processo-imp.cod-itiner NO-LOCK: END.

    IF NOT AVAIL itinerario THEN DO:
        
        {utp/ut-table.i mgcex itinerario 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE + "~~":U + STRING(processo-imp.cod-itiner)).
        RUN pi-delete-dbos IN THIS-PROCEDURE.

        UNDO, RETURN.
    END.
    ELSE DO: /* Valida pontos de controle obrigat¢rios do itiner rio */
        IF itinerario.pto-despacho = 0 OR itinerario.pto-desembarque = 0 
        OR itinerario.pto-embarque = 0 OR itinerario.pto-chegada = 0 THEN DO:

            RUN criaTTBoErro(INPUT 54826, INPUT STRING(itinerario.cod-itiner)).
            RUN pi-delete-dbos IN THIS-PROCEDURE.

            UNDO, RETURN.
        END.
    END.
    
    FOR FIRST historico-embarque fields(dt-efetiva embarque) 
        WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
          AND historico-embarque.embarque      = embarque-imp.embarque    
          AND historico-embarque.cod-itiner    = itinerario.cod-itiner    
          AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad NO-LOCK: 
    END.
    IF AVAIL historico-embarque THEN DO:
        IF historico-embarque.dt-efetiva <> ? THEN DO:

            RUN criaTTBoErro(INPUT 27733, INPUT historico-embarque.embarque + "~~":U + string(embarque-imp.cdn-pto-chegad)).
            RUN pi-delete-dbos IN THIS-PROCEDURE.

            UNDO, RETURN.
        END.
    END.

    ASSIGN i-pto-embarque = IF l-existe-hist THEN embarque-imp.cdn-pto-embarq ELSE itinerario.pto-embarque
           i-pto-chegada  = IF l-existe-hist THEN embarque-imp.cdn-pto-chegad ELSE itinerario.pto-chegada
           i-cod-itiner   = itinerario.cod-itiner
           i-num-pedido   = processo-imp.num-pedido.
    
    FIND FIRST param-imp
         WHERE param-imp.cod-estabel = c-cod-estab NO-LOCK NO-ERROR.        

    IF l-nt2024002 THEN
        FIND FIRST param-imp-trib
             WHERE param-imp-trib.cod-estabel = c-cod-estab NO-LOCK NO-ERROR.        
        
    /* Criacao ordens do embarque  */

    FOR FIRST prazo-compra FIELDS(quantidade quant-saldo numero-ordem parcela data-entrega qtd-sal-forn  it-codigo 
                                  &IF  "{&bf_mat_versao_ems}":U >= "2.09":U &THEN cod-ato-concessor &ELSE char-2 &ENDIF)
        WHERE prazo-compra.numero-ordem  = i-numero-ordem 
          AND prazo-compra.parcela       = i-parcela 
          AND prazo-compra.situacao      = 2 /* Confirmada */ :
        
        ASSIGN de-quant-falta   = 0
               de-quant-parcela = 0.
        
        FOR EACH ordens-embarque FIELDS(quantidade)  
           WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
             AND ordens-embarque.parcela      = prazo-compra.parcela NO-LOCK:
            ASSIGN de-quant-falta = de-quant-falta + ordens-embarque.quantidade.
        END.
        
        ASSIGN de-quant-parcela = de-quant + de-quant-falta.
        
        FOR EACH ordens-embarque FIELDS(quantidade)  
           WHERE ordens-embarque.embarque     <> embarque-imp.embarque
             AND ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
             AND ordens-embarque.parcela      = prazo-compra.parcela NO-LOCK:
            ASSIGN de-quant-parcela = de-quant-parcela - ordens-embarque.quantidade.
        END.
      
        IF de-quant-parcela > 0 THEN DO:
            
            /* Despesas do Embarque */
            FOR EACH cotacao-item FIELDS(cot-aprovada data-cotacao seq-cotac char-1)
               WHERE cotacao-item.numero-ordem = prazo-compra.numero-ordem
                 AND cotacao-item.cod-emitente = processo-imp.cod-exportador
                 AND cotacao-item.it-codigo    = c-it-codigo NO-LOCK:

                IF cotacao-item.cot-aprovada THEN DO:
                    {ccp/cc9019.i50}
                    {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                    {ccp/cc9019.i51 "yes"}
                    
                    /* Cotacao Despesas Adicionais do Item */
                    for each cotacao-item-cex 
                        where cotacao-item-cex.numero-ordem  = prazo-compra.numero-ordem 
                          and cotacao-item-cex.cod-emitente  = processo-imp.cod-exportador
                          and cotacao-item-cex.it-codigo     = c-it-codigo
                          and cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                          and cotacao-item-cex.mapa-cotacao  = i-mapa-cotacao-i50 
                          and cotacao-item-cex.cod-incoterm  = c-cod-incoterm-i50 no-lock:

                        
                        IF  AVAIL param-imp THEN
                            IF  cotacao-item-cex.cod-desp = INT(SUBSTR(param-imp.char-1,21,20)) 
                            OR  cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-ipi
                            OR  cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-pis
                            OR  cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-cofins
                            OR  cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-icms THEN
                                NEXT.

                        IF l-nt2024002 THEN DO:
                            IF  AVAIL param-imp-trib THEN
                                IF cotacao-item-cex.cod-desp = param-imp-trib.cdn-despes-impto-CBS     
                                OR cotacao-item-cex.cod-desp = param-imp-trib.cdn-despes-impto-IBSMun     
                                OR cotacao-item-cex.cod-desp = param-imp-trib.cdn-despes-impto-IBSUF  
                                OR cotacao-item-cex.cod-desp = param-imp-trib.cdn-despes-impto-IS THEN
                                    NEXT.
                        END.
                      
                        FIND FIRST desp-imp 
                             WHERE desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.
                        IF NOT desp-imp.inc-val-embal       AND
                           NOT desp-imp.inc-val-frete       AND
                           NOT desp-imp.inc-val-outras-desp AND
                           NOT desp-imp.inc-val-seguro      THEN
                            NEXT.
                          
                        IF l-existe-hist THEN DO:
                            /* Se existir historico-embarque, valida se o ponto de controle que incide despesa nas cotacao-item-cex existe no historico-embarque */
                            IF NOT CAN-FIND(historico-embarque 
                                            WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
                                              AND historico-embarque.embarque      = embarque-imp.embarque 
                                              AND historico-embarque.cod-itiner    = processo-imp.cod-itiner 
                                              AND historico-embarque.cod-pto-contr = cotacao-item-cex.cod-pto-contr) THEN DO:

                                {utp/ut-liter.i "Hist¢rico_do_embarque" *}
                                RUN criaTTBoErro(INPUT 25197, INPUT STRING(cotacao-item-cex.cod-pto-contr) + "~~":U + 
                                                                    STRING(cotacao-item-cex.numero-ordem)  + "~~":U + 
                                                                    STRING(cotacao-item-cex.cod-desp)      + "~~":U + 
                                                                    RETURN-VALUE).
                                RUN pi-delete-dbos IN THIS-PROCEDURE.

                                UNDO, RETURN.
                            END.
                        END.
                        ELSE DO:
                            /* Valida se o ponto de controle que incide despesa nas cotacao-item-cex existe no itinerario do processo-imp */
                            IF NOT CAN-FIND(pto-itiner 
                                            WHERE pto-itiner.cod-itiner    = processo-imp.cod-itiner 
                                              AND pto-itiner.cod-pto-contr = cotacao-item-cex.cod-pto-contr) THEN DO:

                                {utp/ut-liter.i "Itiner rio_do_Processo" *}
                                RUN criaTTBoErro(INPUT 25197, INPUT STRING(cotacao-item-cex.cod-pto-contr) + "~~":U + 
                                                                    STRING(cotacao-item-cex.numero-ordem)  + "~~":U + 
                                                                    STRING(cotacao-item-cex.cod-desp)      + "~~":U + 
                                                                    RETURN-VALUE).
                                RUN pi-delete-dbos IN THIS-PROCEDURE.

                                UNDO, RETURN.
                            END.
                        END.
                    
                        FIND FIRST desp-embarque
                             WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                               AND desp-embarque.embarque          = embarque-imp.embarque
                               AND desp-embarque.cod-itiner        = processo-imp.cod-itiner
                               AND desp-embarque.cod-pto-contr     = cotacao-item-cex.cod-pto-contr
                               AND desp-embarque.cod-desp          = cotacao-item-cex.cod-desp
                               AND desp-embarque.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp EXCLUSIVE-LOCK NO-ERROR.

                        IF NOT AVAIL desp-embarque THEN DO:            
                            /* Valida se existem dois fornecedores(emitente) diferentes para a mesma despesa */
                            IF CAN-FIND (desp-embarque 
                                         WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                                           AND desp-embarque.embarque          = embarque-imp.embarque
                                           AND desp-embarque.cod-itiner        = processo-imp.cod-itiner
                                           AND desp-embarque.cod-pto-contr     = cotacao-item-cex.cod-pto-contr
                                           AND desp-embarque.cod-desp          = cotacao-item-cex.cod-desp) THEN DO:
                                
                                {utp/ut-liter.i "Emitente" *}
                                RUN criaTTBoErro(INPUT 25219, INPUT STRING(cotacao-item-cex.cod-desp)     + "~~":U + 
                                                                    STRING(cotacao-item-cex.numero-ordem) + "~~":U + 
                                                                    RETURN-VALUE).
                                RUN pi-delete-dbos IN THIS-PROCEDURE.

                                UNDO, RETURN.
                            END.
                        
                            /* Valida se existe a mesma despesa para pontos de controle deferentes */
                            IF CAN-FIND (desp-embarque 
                                         WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                                           AND desp-embarque.embarque          = embarque-imp.embarque
                                           AND desp-embarque.cod-itiner        = processo-imp.cod-itiner
                                           AND desp-embarque.cod-desp          = cotacao-item-cex.cod-desp) THEN DO:                    
                                
                                {utp/ut-liter.i "Ponto_de_Controle" *}
                                RUN criaTTBoErro(INPUT 25219, INPUT STRING(cotacao-item-cex.cod-desp)     + "~~":U + 
                                                                    STRING(cotacao-item-cex.numero-ordem) + "~~":U + 
                                                                    RETURN-VALUE).
                                RUN pi-delete-dbos IN THIS-PROCEDURE.

                                UNDO, RETURN.
                            END.
                        
                            CREATE desp-embarque.
                            ASSIGN desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                                   desp-embarque.embarque          = embarque-imp.embarque
                                   desp-embarque.cod-itiner        = processo-imp.cod-itiner
                                   desp-embarque.cod-pto-contr     = cotacao-item-cex.cod-pto-contr
                                   desp-embarque.cod-desp          = cotacao-item-cex.cod-desp
                                   desp-embarque.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp
                                   desp-embarque.cod-cond-pag      = cotacao-item-cex.cod-cond-pag
                                   desp-embarque.mo-codigo         = cotacao-item-cex.mo-codigo.
                        END.
                        ELSE DO:
                            /* Valida se existe a mesma despesa com moedas diferentes */
                            IF desp-embarque.mo-codigo <> cotacao-item-cex.mo-codigo THEN DO:

                                {utp/ut-liter.i "Moeda" *}
                                RUN criaTTBoErro(INPUT 25219, INPUT STRING(cotacao-item-cex.cod-desp)     + "~~":U +
                                                                    STRING(cotacao-item-cex.numero-ordem) + "~~":U + 
                                                                    RETURN-VALUE).
                                RUN pi-delete-dbos IN THIS-PROCEDURE.

                                UNDO, RETURN.
                            END.
                        END.

                        RUN GetRateioIncoterm (OUTPUT c-cod-incoterm-rat).

                        
                        ASSIGN desp-embarque.cod-incoterm-rat = c-cod-incoterm-rat.

                        /*--- Sugestao da incoterm rateio com base da despesa do pedido ----*/
                        FOR FIRST ordem-compra FIELDS(numero-ordem it-codigo mo-codigo num-pedido cod-estabel cod-emitente gera-edi) 
                            WHERE ordem-compra.numero-ordem = cotacao-item-cex.numero-ordem NO-LOCK: END.
                        
                        IF  AVAIL ordem-compra THEN
                            FOR FIRST despes-ped-compra FIELDS(cod-incoterm-rat)
                                WHERE despes-ped-compra.num-pedido        = ordem-compra.num-pedido
                                  AND despes-ped-compra.cod-desp          = cotacao-item-cex.cod-desp
                                  AND despes-ped-compra.mo-codigo         = cotacao-item-cex.mo-codigo
                                  AND despes-ped-compra.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp
                                  AND despes-ped-compra.cod-pto-contr     = cotacao-item-cex.cod-pto-contr
                                  AND despes-ped-compra.tp-despesa        = cotacao-item-cex.tp-despesa NO-LOCK:

                                ASSIGN desp-embarque.cod-incoterm-rat = despes-ped-compra.cod-incoterm-rat.
                            END.
                        
                        ASSIGN de-conv-val-cex = cotacao-item-cex.val-desp.

                        IF cotacao-item-cex.mo-codigo <> desp-embarque.mo-codigo THEN DO:

                            RUN cdp/cd0812.p (INPUT  cotacao-item-cex.mo-codigo,
                                              INPUT  desp-embarque.mo-codigo,
                                              INPUT  cotacao-item-cex.val-desp,
                                              INPUT  TODAY,
                                              OUTPUT de-conv-val-cex).

                            IF de-conv-val-cex = 0 OR de-conv-val-cex = ? THEN 
                                ASSIGN de-conv-val-cex = cotacao-item-cex.val-desp.
                        END.

                        IF desp-imp.tipo = 1 THEN /* valor fixo */
                            ASSIGN desp-embarque.val-desp = de-conv-val-cex.
                        ELSE
                            ASSIGN desp-embarque.val-desp = desp-embarque.val-desp + 
                                                           (de-conv-val-cex * de-quant-parcela).                                                    
                    END.
                END.
            END.

            /* Criacao das ordens-embarque */
            FIND FIRST ordens-embarque
                 WHERE ordens-embarque.cod-estabel  = processo-imp.cod-estabel  
                   AND ordens-embarque.nr-proc-imp  = processo-imp.nr-proc-imp  
                   AND ordens-embarque.embarque     = embarque-imp.embarque     
                   AND ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                   AND ordens-embarque.parcela      = prazo-compra.parcela      EXCLUSIVE-LOCK NO-ERROR.

            ASSIGN l-criou-ordens-embarque = NO.

            IF  NOT AVAIL ordens-embarque THEN DO:
                CREATE ordens-embarque.
                ASSIGN ordens-embarque.quantidade = 0
                       l-criou-ordens-embarque    = YES
                       ordens-embarque.quantidade = ordens-embarque.quantidade + de-quant-parcela.
            END.
            ELSE 
                ASSIGN ordens-embarque.quantidade = ordens-embarque.quantidade + de-quant.
            
            ASSIGN ordens-embarque.cod-estabel  = processo-imp.cod-estabel
                   ordens-embarque.embarque     = embarque-imp.embarque
                   ordens-embarque.numero-ordem = prazo-compra.numero-ordem
                   ordens-embarque.parcela      = prazo-compra.parcela
                   ordens-embarque.nr-proc-imp  = processo-imp.nr-proc-imp 
                   &IF  "{&bf_mat_versao_ems}":U >= "2.09":U &THEN
                       ordens-embarque.nr-ato-concessorio = prazo-compra.cod-ato-concessor
                   &ELSE
                       OVERLAY(ordens-embarque.char-1,1,20) = SUBSTRING(prazo-compra.char-2,11,30)
                   &ENDIF
                   .

            /* Atualizar pesos somente apos criar ordens-embarque */
            IF  l-criou-ordens-embarque THEN DO:
                
                FOR FIRST ordem-compra fields(numero-ordem it-codigo mo-codigo num-pedido cod-estabel cod-emitente gera-edi)
                    WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK: END.

                IF VALID-HANDLE(h-boin356) AND VALID-HANDLE(h-bodi425) THEN DO:
                    
                    RUN piRetornaQtdeEmbalagem IN h-bodi425(INPUT  ordens-embarque.quantidade, 
                                                            INPUT  prazo-compra.it-codigo, 
                                                            INPUT  ordem-compra.cod-emitente,
                                                            OUTPUT d-qtd-embal).

                    RUN retornaPesoTotal IN h-boin356 (INPUT  ROWID(prazo-compra), 
                                                       INPUT  ordens-embarque.quantidade, 
                                                       INPUT  d-qtd-embal, 
                                                       OUTPUT de-peso-total).

                    IF NOT l-emb THEN
                        RUN retornaVolumeTotal IN h-boin356 (INPUT  ROWID(prazo-compra), 
                                                             INPUT  ordens-embarque.quantidade, 
                                                             OUTPUT de-volume-total).
                    ELSE
                        RUN retornaVolumeTotal IN h-boin356 (INPUT  ROWID(prazo-compra), 
                                                             INPUT  IF d-qtd-embal <> 0 THEN d-qtd-embal ELSE ordens-embarque.quantidade,
                                                             OUTPUT de-volume-total).
                END.
                

                FOR FIRST item FIELDS (peso-liquido peso-bruto altura largura comprim)
                    WHERE item.it-codigo = c-it-codigo NO-LOCK:
                    
                    ASSIGN ordens-embarque.peso-liquido = item.peso-liquido * ordens-embarque.quantidade
                           ordens-embarque.peso-bruto   = de-peso-total
                           ordens-embarque.val-cub-tot  = de-volume-total.
                END.
            END.

            {cxbo/bocx225.i2} /*Parcela fixada (parcela nao sera re-planejada)*/
            
            FOR FIRST item-fornec FIELDS(fator-conver num-casa-dec)
                WHERE item-fornec.it-codigo    = c-it-codigo 
                  AND item-fornec.cod-emitente = processo-imp.cod-exportador NO-LOCK: END.
                   
            IF AVAIL item-fornec THEN DO:

                IF de-quant-parcela = prazo-compra.quantidade THEN
                    ASSIGN ordens-embarque.qt-do-forn = prazo-compra.qtd-sal-forn.
                ELSE
                    ASSIGN ordens-embarque.qt-do-forn = ordens-embarque.quantidade
                                                      * (item-fornec.fator-conver / 
                                                      IF item-fornec.num-casa-dec = 0 THEN 1
                                                      ELSE EXP(10,item-fornec.num-casa-dec)).
            END.
            ELSE
                ASSIGN ordens-embarque.qt-do-forn = ordens-embarque.quantidade.
        END.
    END.

    /*******************************************************************************************************/

    /* 
    ** teste para atualizar o status do processo-imp. Se o parametro gera hist processo estiver setado
    ** atualiza, senao so atualiza se houver historico do embarque e a data de embarque estiver efetivada 
    */         
    FOR FIRST param-imp FIELDS(hist-processo)
        WHERE param-imp.cod-estabel = embarque-imp.cod-estabel NO-LOCK: END.

    IF NOT AVAIL param-imp THEN DO:

        {utp/ut-table.i mgcex param-imp 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE).
        RUN pi-delete-dbos IN THIS-PROCEDURE.

        UNDO, RETURN.
    END.

    IF param-imp.hist-processo THEN
        RUN pi-atualizaSitProc(INPUT i-num-pedido).
    ELSE DO:
        FIND FIRST historico-embarque
             WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
               AND historico-embarque.embarque      = embarque-imp.embarque
               AND historico-embarque.cod-itiner    = i-cod-itiner
               AND historico-embarque.cod-pto-contr = i-pto-embarque NO-LOCK NO-ERROR.

        IF AVAIL historico-embarque THEN
            IF historico-embarque.dt-efetiva <> ? THEN
                RUN pi-atualizaSitProc (INPUT i-num-pedido).
    END.
        
    FIND FIRST prazo-compra  
         WHERE prazo-compra.numero-ordem = p-numero-ordem 
           AND prazo-compra.parcela      = p-parcela NO-LOCK NO-ERROR.

    IF AVAIL prazo-compra THEN DO:

       IF NOT CAN-FIND (FIRST historico-embarque NO-LOCK
                        WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
                          AND historico-embarque.embarque      = embarque-imp.embarque    
                          AND historico-embarque.cod-itiner    = processo-imp.cod-itiner 
                          AND historico-embarque.cod-pto-contr = i-pto-chegada) THEN DO:

           IF NOT l-create-hist THEN DO:

               ASSIGN l-create-hist = YES.
               RUN pi-createHistEmbarque (INPUT  embarque-imp.cod-estabel,
                                          INPUT  embarque-imp.embarque,
                                          INPUT  processo-imp.nr-proc-imp,
                                          INPUT  prazo-compra.data-entrega, /*processo-imp.dt-emissao */
                                          INPUT  processo-imp.cod-itiner,
                                          INPUT  processo-imp.cod-exportador,
                                          INPUT  processo-imp.cod-despachante,
                                          INPUT  processo-imp.cod-agente,
                                          INPUT  processo-imp.cod-fabricante,
                                          INPUT  param-imp.hist-processo,
                                          INPUT  i-pto-chegada,
                                          INPUT  c-cod-idiom-usuar,
                                          OUTPUT TABLE tt-bo-erro).
               
               IF NOT l-necessita-li THEN
                   RUN piEliminaPtoLI IN THIS-PROCEDURE.
           END.

           FIND FIRST tt-bo-erro 
                WHERE tt-bo-erro.cd-erro = 25196 EXCLUSIVE-LOCK NO-ERROR.
           
           IF AVAIL tt-bo-erro THEN DO:
              
               ASSIGN i-seq-erro = tt-bo-erro.i-sequen
                      c-msg      = "".
              
              {utp/ut-liter.i de_chegada} 
              ASSIGN c-msg                 = TRIM(RETURN-VALUE)     + " " 
                                           + STRING(i-pto-chegada)  + "~~":U
                                           + STRING(i-numero-ordem) + "~~":U
                                           + STRING(processo-imp.cod-itiner)
                     tt-bo-erro.parametros = c-msg.        

              RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 25196, INPUT c-msg).

              ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                     tt-bo-erro.cd-erro      = 25196
                     tt-bo-erro.mensagem     = RETURN-VALUE.
              
              FOR EACH ordens-embarque 
                 WHERE ordens-embarque.numero-ordem = i-numero-ordem
                   AND ordens-embarque.cod-estabel  = processo-imp.cod-estabel
                   AND ordens-embarque.embarque     = embarque-imp.embarque EXCLUSIVE-LOCK:
                  DELETE ordens-embarque.
              END.                
              UNDO, LEAVE.
           END.
       END.
       ELSE DO:
           
           FIND FIRST historico-embarque 
                WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
                  AND historico-embarque.embarque      = embarque-imp.embarque    
                  AND historico-embarque.cod-itiner    = processo-imp.cod-itiner 
                  AND historico-embarque.cod-pto-contr = i-pto-chegada NO-LOCK NO-ERROR.

           IF AVAIL historico-embarque THEN DO:
              
               FIND CURRENT prazo-compra EXCLUSIVE-LOCK NO-ERROR. 
               
               IF  prazo-compra.data-entrega <> historico-embarque.dt-ult-previsao THEN DO:
                   FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem EXCLUSIVE-LOCK NO-ERROR.
                   /* Criar Registro na tabela alt-ped */    
                   {cxbo/bocx140.i03 today
                                     c-seg-usuario 
                                     ordem-compra.num-pedido
                                     ordem-compra.numero-ordem 
                                     prazo-compra.parcela
                                     prazo-compra.data-entrega
                                     ?
                                     ?
                                     ordem-compra.cod-emitente
                                     ordem-compra.gera-edi
                                     ordem-compra.num-pedido
                                     historico-embarque.dt-ult-previsao}
               END.
               
              
               ASSIGN prazo-compra.data-entrega-ant = prazo-compra.data-entrega
                      prazo-compra.data-entrega = historico-embarque.dt-ult-previsao.
           END.
       END.

       RUN piAtualizaEmbarqueImp (INPUT embarque-imp.cod-estabel,
                                  INPUT embarque-imp.embarque,   
                                  INPUT processo-imp.cod-itiner,
                                  INPUT processo-imp.nr-proc-imp).
       
       IF l-necessita-li THEN 
           RUN piCriaPtoLI IN THIS-PROCEDURE.
    
       RUN pi-delete-dbos IN THIS-PROCEDURE.
    END.

    /*--- Chamada UPC ---*/
    FOR EACH tt-epc WHERE tt-epc.cod-event = "AfterCreateOrdensEmbarque":U.
        DELETE tt-epc.
    END.
    
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AfterCreateOrdensEmbarque":U
           tt-epc.cod-parameter = "ordem-compra.numero-ordem":U
           tt-epc.val-parameter = string(p-numero-ordem).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AfterCreateOrdensEmbarque":U
           tt-epc.cod-parameter = "row-embarque-imp":U
           tt-epc.val-parameter = string(r-embarque).

    /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i '"AfterCreateOrdensEmbarque"'}
    
    /*--- Fim chamada UPC ---*/

END PROCEDURE.


PROCEDURE createOrdensEmbarqueNovaParcela:
/*------------------------------------------------------------------------------
  Purpose: Criacao das Ordens Embarque via Ordens de Compra.
  Parameters:  INPUT - r-embarque (rowid) - rowid do embarque  
               INPUT - p-numero-ordem (integer) - numero da ordem de compra
               INPUT - de-quant (decimal) - quantidade da parcela
               INPUT - p-nova-qtde (decimal) - quantidade a ser criada parcela/ordens-embarque
               INPUT - p-data-entrega (date) - data de entrega da nova parcela/ordens-embarque
               OUTPUT TABLE - tt-bo-erro - erros ocorridos durante o processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER r-embarque        AS ROWID                       NO-UNDO.
    DEFINE INPUT  PARAMETER p-numero-ordem    LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAMETER de-quant          LIKE prazo-compra.quantidade   NO-UNDO.
    DEFINE INPUT  PARAMETER p-nova-qtde       LIKE prazo-compra.quantidade   NO-UNDO.
    DEFINE INPUT  PARAMETER p-data-entrega    AS   DATE                      NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    DEFINE VARIABLE de-quant-disp    LIKE prazo-compra.quantidade    NO-UNDO.
    DEFINE VARIABLE de-quant-falta   LIKE ordens-embarque.quantidade NO-UNDO.
    DEFINE VARIABLE de-quant-parcela LIKE ordens-embarque.quantidade NO-UNDO.
    DEFINE VARIABLE de-conv-val-cex  LIKE cotacao-item-cex.val-desp  NO-UNDO.
    DEFINE VARIABLE i-pto-embarque   LIKE pto-contr.cod-pto-contr    NO-UNDO.
    DEFINE VARIABLE i-pto-chegada    LIKE pto-contr.cod-pto-contr    NO-UNDO.
    DEFINE VARIABLE i-cod-itiner     LIKE itinerario.cod-itiner      NO-UNDO.
    DEFINE VARIABLE i-num-pedido     LIKE pedido-compr.num-pedido    NO-UNDO.
    DEFINE VARIABLE i-numero-ordem   LIKE ordem-compra.numero-ordem  NO-UNDO.
    DEFINE VARIABLE c-it-codigo      LIKE ordem-compra.it-codigo     NO-UNDO.
    DEFINE VARIABLE l-existe-hist    AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE i-mo-ordem       LIKE moeda.mo-codigo            NO-UNDO.
    DEFINE VARIABLE v-data           AS   DATE                       NO-UNDO.
    DEFINE VARIABLE v-parcela        AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE v-ordem          AS   INTEGER                    NO-UNDO.
    DEFINE VARIABLE v-nova-qtde      LIKE prazo-compra.quantidade    NO-UNDO.
    DEFINE VARIABLE v-qtde-emb       LIKE prazo-compra.quantidade    NO-UNDO.
    DEFINE VARIABLE v-diferenca      LIKE prazo-compra.quantidade    NO-UNDO.
    DEFINE VARIABLE c-msg            AS   CHARACTER                  NO-UNDO.
    DEFINE VARIABLE l-ordem-emb      AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE l-passou         AS   LOGICAL                    NO-UNDO.

    EMPTY TEMP-TABLE tt-bo-erro.
    EMPTY TEMP-TABLE tt-prazo.

    ASSIGN i-seq-erro = 0.
    
    IF NOT VALID-HANDLE(h-boin356) THEN
        RUN inbo/boin356ab.p PERSISTENT SET h-boin356.
    IF NOT VALID-HANDLE(h-bodi425) THEN
        RUN dibo/bodi425.p   PERSISTENT SET h-bodi425.
    IF NOT VALID-HANDLE (h-bocx00488) THEN
        RUN cxbo/bocx00488.p PERSISTENT SET h-bocx00488.

    FOR FIRST embarque-imp FIELDS(cod-estabel embarque cdn-pto-chegad cdn-pto-embarq)
        WHERE ROWID(embarque-imp) = r-embarque NO-LOCK: END.

    IF NOT AVAIL embarque-imp THEN DO:

        {utp/ut-table.i mgcex embarque-imp 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE).

        UNDO, RETURN.
    END.
    
    IF VALID-HANDLE(h-bocx00488) then do:
        assign vd-cod-duimp-dts = 0.
        RUN piValidaEmbarqueDuimp in h-bocx00488 (input  embarque-imp.cod-estabel,
                                                  input  embarque-imp.embarque,
                                                  output vd-cod-duimp-dts).
        IF vd-cod-duimp-dts <> 0 THEN DO:
            {utp/ut-liter.i "Vincula‡Æo" *}
            ASSIGN c-lbl-liter-e[1] = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Embarque_j " *}
            ASSIGN c-lbl-liter-e[2] = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "…_DUIMP_No." *}
            ASSIGN c-lbl-liter-e[3] = TRIM(RETURN-VALUE).
            RUN criaTTBoErro(INPUT 27414,
                             input c-lbl-liter-e[1] + "~~":U 
                                 + c-lbl-liter-e[2] + "~~":U
                                 + c-lbl-liter-e[3] + string(vd-cod-duimp-dts)).
                                 
            UNDO, RETURN.
        END.
    end.
    

    FOR FIRST ordem-compra FIELDS(numero-ordem it-codigo mo-codigo num-pedido cod-estabel cod-emitente gera-edi)
        WHERE ordem-compra.numero-ordem = p-numero-ordem NO-LOCK: END.

    IF NOT AVAIL ordem-compra THEN DO:
        
        {utp/ut-table.i mgind ordem-compra 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE + "~~":U + STRING(p-numero-ordem)).
        
        UNDO, RETURN.
    END.
    
    IF NOT VALID-HANDLE (h-bocx230a) THEN
        RUN cxbo/bocx230a.p PERSISTENT SET h-bocx230a.
    
    ASSIGN l-necessita-li = NO.
    
    FIND FIRST param-imp 
         WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
    
    IF AVAIL param-imp AND SUBSTRING(param-imp.char-1,167,1) = "S":U THEN
        ASSIGN l-necessita-li = YES.
    ELSE
        IF CAN-FIND (FIRST item
                     WHERE item.it-codigo = ordem-compra.it-codigo
                       AND item.log-necessita-li) THEN
            ASSIGN l-necessita-li = YES.
    
    ASSIGN i-numero-ordem = ordem-compra.numero-ordem
           c-it-codigo    = ordem-compra.it-codigo
           i-mo-ordem     = ordem-compra.mo-codigo
           c-cod-estab    = ordem-compra.cod-estabel.

    /* Quantidade disponivel */
    RUN pi-calculaQtdeDisponivel(INPUT ordem-compra.numero-ordem, OUTPUT de-quant-disp).
    
    IF de-quant > de-quant-disp THEN DO:
        {utp/ut-liter.i quantidade_disponðvel_para_aloca¯Êo_da_ordem * L}

        RUN criaTTBoErro(INPUT 1221, INPUT TRIM(RETURN-VALUE) + " " + STRING(ordem-compra.numero-ordem)).
        
        UNDO, RETURN.
    END.

    FIND FIRST processo-imp 
         WHERE processo-imp.num-pedido  = ordem-compra.num-pedido NO-LOCK NO-ERROR.

    IF NOT AVAIL processo-imp THEN DO:

        {utp/ut-table.i mgcex processo-imp 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE + "~~":U + STRING(ordem-compra.num-pedido)).
        
        UNDO, RETURN.
    END.

    /*  Verifica se processo esta encerrado/embarcado total  */
    IF processo-imp.situacao >= 3 THEN DO:

        {utp/ut-table.i mgcex processo-imp 1}
        RUN criaTTBoErro(INPUT 15239, INPUT RETURN-VALUE + " ":U + processo-imp.nr-proc-imp).

        UNDO, RETURN.
    END.

    /* Verifica se itinerario do processo e o mesmo do outro itinerario ja informado */
    FOR FIRST historico-embarque FIELDS(cod-itiner)
        WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
          AND historico-embarque.embarque    = embarque-imp.embarque  NO-LOCK: END.

    IF AVAIL historico-embarque THEN DO:
        ASSIGN l-existe-hist = YES.

        IF historico-embarque.cod-itiner <> processo-imp.cod-itiner THEN DO:

            RUN criaTTBoErro(INPUT 17751, INPUT processo-imp.nr-proc-imp).

            UNDO, RETURN.
        END.
    END.

    /* Verfica se o exportador e o mesmo de todas as ordens informadas */ 
    FOR FIRST ordens-embarque FIELDS(numero-ordem) 
        WHERE ordens-embarque.cod-estabel  = embarque-imp.cod-estabel 
          AND ordens-embarque.embarque     = embarque-imp.embarque NO-LOCK:

        FOR FIRST ordem-compra FIELDS(numero-ordem it-codigo mo-codigo num-pedido cod-estabel cod-emitente gera-edi) 
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:

            IF processo-imp.cod-exportador <> ordem-compra.cod-emitente THEN DO:

                RUN criaTTBoErro(INPUT 17888, INPUT "":U).

                UNDO, RETURN.
            END.
            IF i-mo-ordem <> ordem-compra.mo-codigo THEN DO:

                RUN criaTTBoErro(INPUT 26194, INPUT STRING(i-mo-ordem)     + "~~":U + 
                                                    STRING(i-numero-ordem) + "~~":U + 
                                                    STRING(ordem-compra.mo-codigo)).
                UNDO, RETURN.
            END.
        END.
    END.

    FOR FIRST itinerario FIELDS(cod-itiner pto-despacho pto-embarque pto-desembarque pto-chegada) 
        WHERE itinerario.cod-itiner = processo-imp.cod-itiner NO-LOCK: END.

    IF NOT AVAIL itinerario THEN DO:

        {utp/ut-table.i mgcex itinerario 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE + "~~":U + STRING(processo-imp.cod-itiner)).
        
        UNDO, RETURN.
    END.
    ELSE DO: /* Valida pontos de controle obrigat¢rios do itiner rio */
        IF itinerario.pto-despacho = 0 OR itinerario.pto-desembarque = 0 
        OR itinerario.pto-embarque = 0 OR itinerario.pto-chegada = 0 THEN DO:

            RUN criaTTBoErro(INPUT 54826, INPUT STRING(itinerario.cod-itiner)).
            
            UNDO, RETURN.
        END.
    END.
    
    FOR FIRST historico-embarque FIELDS(dt-efetiva embarque) 
        WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
          AND historico-embarque.embarque      = embarque-imp.embarque    
          AND historico-embarque.cod-itiner    = itinerario.cod-itiner    
          AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad NO-LOCK: 
    END.

    IF AVAIL historico-embarque THEN DO:
        IF historico-embarque.dt-efetiva <> ? THEN DO:

            RUN criaTTBoErro(INPUT 27733, INPUT historico-embarque.embarque + "~~":U + STRING(embarque-imp.cdn-pto-chegad)).
            
            UNDO, RETURN.
        END.
    END.

    ASSIGN i-pto-embarque = IF l-existe-hist THEN embarque-imp.cdn-pto-embarq ELSE itinerario.pto-embarque
           i-pto-chegada  = IF l-existe-hist THEN embarque-imp.cdn-pto-chegad ELSE itinerario.pto-chegada
           i-cod-itiner   = itinerario.cod-itiner
           i-num-pedido   = processo-imp.num-pedido.
       
    /* Criacao ordens do embarque  */
    
    ASSIGN v-nova-qtde      = 0
           l-ordem-emb      = NO
           de-quant-falta   = 0
           de-quant-disp    = 0
           l-passou         = NO
           de-quant         = p-nova-qtde.
    
    FIND FIRST param-imp
         WHERE param-imp.cod-estabel = c-cod-estab NO-LOCK NO-ERROR.

    IF l-nt2024002 THEN
        FIND FIRST param-imp-trib
             WHERE param-imp-trib.cod-estabel = c-cod-estab NO-LOCK NO-ERROR.
        
    FOR EACH prazo-compra FIELDS(quantidade quant-saldo numero-ordem parcela data-entrega it-codigo char-2) 
       WHERE prazo-compra.situacao     = 2 
        AND prazo-compra.numero-ordem  = i-numero-ordem NO-LOCK
        BREAK BY prazo-compra.numero-ordem
              BY prazo-compra.parcela:

        ASSIGN v-qtde-emb   = 0
               v-nova-qtde  = 0.

        FOR EACH ordens-embarque FIELDS(quantidade) NO-LOCK 
           WHERE ordens-embarque.cod-estabel  = processo-imp.cod-estabel  
             AND ordens-embarque.nr-proc-imp  = processo-imp.nr-proc-imp  
             AND ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
             AND ordens-embarque.parcela      = prazo-compra.parcela:
            ASSIGN v-qtde-emb    = v-qtde-emb  + ordens-embarque.quantidade.
        END.                          /*quantidade*/
        IF v-qtde-emb  = prazo-compra.quant-saldo THEN
           NEXT.   

        ASSIGN v-qtde-emb = 0.
        
        FOR EACH ordens-embarque FIELDS(quantidade) NO-LOCK 
           WHERE ordens-embarque.cod-estabel  = processo-imp.cod-estabel  
             AND ordens-embarque.embarque     <> embarque-imp.embarque
             AND ordens-embarque.nr-proc-imp  = processo-imp.nr-proc-imp  
             AND ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
             AND ordens-embarque.parcela      = prazo-compra.parcela:
            
            ASSIGN v-qtde-emb = v-qtde-emb  + ordens-embarque.quantidade.
        END.
        
        IF prazo-compra.quantidade > v-qtde-emb  THEN  /*quant-saldo*/
           ASSIGN v-diferenca = prazo-compra.quant-saldo - v-qtde-emb.
        ELSE 
            ASSIGN v-diferenca = 0. 
        
        FIND FIRST ordens-embarque  
             WHERE ordens-embarque.cod-estabel  = processo-imp.cod-estabel  
               AND ordens-embarque.nr-proc-imp  = processo-imp.nr-proc-imp  
               AND ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
               AND ordens-embarque.parcela      = prazo-compra.parcela  NO-LOCK NO-ERROR.
        
                 /*quantidade*/
        IF AVAIL ordens-embarque  AND (prazo-compra.quant-saldo /*- v-diferenca*/) < ordens-embarque.quantidade THEN 
            NEXT.
        ELSE 
            IF AVAIL ordens-embarque THEN DO:
                 IF ordens-embarque.embarque <> embarque-imp.embarque THEN 
                     ASSIGN v-qtde-emb =  (v-qtde-emb  + ordens-embarque.quantidade).

                 ASSIGN l-ordem-emb = yes.
            END.
            ELSE DO:
                ASSIGN l-ordem-emb = NO.
            END.

        IF NOT CAN-FIND (FIRST ordens-embarque 
                         WHERE ordens-embarque.cod-estabel  = processo-imp.cod-estabel  
                           AND ordens-embarque.nr-proc-imp  = processo-imp.nr-proc-imp  
                           AND ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                           AND ordens-embarque.parcela      = prazo-compra.parcela) AND
           NOT FIRST-OF(prazo-compra.numero-ordem)                               
        THEN                                                /*quantidade*/                               /*quantidade*/
            ASSIGN v-nova-qtde = v-nova-qtde + (prazo-compra.quant-saldo - IF v-diferenca <> prazo-compra.quant-saldo THEN v-diferenca ELSE 0).
        ELSE                                                /*quantidade*/
            ASSIGN v-nova-qtde = v-nova-qtde + (prazo-compra.quant-saldo - v-qtde-emb).     
        
        ASSIGN l-passou = YES.
        
        IF v-nova-qtde >= p-nova-qtde THEN                /*quantidade*/
           ASSIGN v-nova-qtde = (p-nova-qtde + prazo-compra.quant-saldo) - v-nova-qtde.
        
        IF FIRST-OF(prazo-compra.numero-ordem) THEN DO:

            FOR FIRST ordens-embarque FIELDS(quantidade) NO-LOCK 
                WHERE ordens-embarque.cod-estabel  = processo-imp.cod-estabel  
                  AND ordens-embarque.nr-proc-imp  = processo-imp.nr-proc-imp  
                  AND ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                  AND ordens-embarque.parcela      = prazo-compra.parcela 
                  AND ordens-embarque.embarque     = embarque-imp.embarque :

                ASSIGN v-nova-qtde = v-nova-qtde + ordens-embarque.quantidade - v-qtde-emb.
            END.
        END.

        ASSIGN de-quant-disp = de-quant-disp + (v-nova-qtde - v-qtde-emb).

        IF NOT FIRST-OF(prazo-compra.numero-ordem) THEN DO:

            IF ((v-nova-qtde - v-qtde-emb) > (p-nova-qtde) AND l-ordem-emb = NO) 
            OR de-quant-disp > p-nova-qtde THEN 
                LEAVE.
        END.
                                                           /*quantidade*/
        ASSIGN de-quant-disp = de-quant-disp - prazo-compra.quant-saldo.
                    
        ASSIGN de-quant-falta = v-nova-qtde /*(prazo-compra.quantidade - v-diferenca)*/
               v-nova-qtde    = v-nova-qtde + v-qtde-emb.

        IF NOT FIRST-OF(prazo-compra.numero-ordem) THEN DO:

            FOR EACH ordens-embarque FIELDS(quantidade) NO-LOCK 
                WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                  AND ordens-embarque.parcela      = prazo-compra.parcela:
                  IF NOT FIRST-OF(prazo-compra.numero-ordem) THEN
                    ASSIGN de-quant-falta = de-quant-falta - ordens-embarque.quantidade.
            END.
        END.

        IF de-quant > 0 THEN DO:
        
            IF de-quant-falta <= 0 THEN NEXT.
        
            IF de-quant > de-quant-falta THEN
                ASSIGN de-quant-parcela = de-quant-falta.
            ELSE 
                ASSIGN de-quant-parcela = de-quant.
        
            ASSIGN de-quant = de-quant - de-quant-falta.
            
            /* Despesas do Embarque */
            FOR EACH cotacao-item FIELDS(cot-aprovada data-cotacao seq-cotac char-1)
               WHERE cotacao-item.numero-ordem = prazo-compra.numero-ordem
                 AND cotacao-item.cod-emitente = processo-imp.cod-exportador
                 AND cotacao-item.it-codigo    = c-it-codigo NO-LOCK:

                IF cotacao-item.cot-aprovada THEN DO:
                    
                    {ccp/cc9019.i50}
                    {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                    {ccp/cc9019.i51 "yes"}
                    
                    /* Cotacao Despesas Adicionais do Item  */
                    FOR EACH cotacao-item-cex 
                       WHERE cotacao-item-cex.numero-ordem = prazo-compra.numero-ordem 
                         AND cotacao-item-cex.cod-emitente = processo-imp.cod-exportador
                         AND cotacao-item-cex.it-codigo    = c-it-codigo
                         AND cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac           
                         AND cotacao-item-cex.mapa-cotacao = i-mapa-cotacao-i50 
                         AND cotacao-item-cex.cod-incoterm = c-cod-incoterm-i50 NO-LOCK:

                        
                        IF  AVAIL param-imp THEN
                            IF  cotacao-item-cex.cod-desp = INT(SUBSTR(param-imp.char-1,21,20)) 
                            OR  cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-ipi
                            OR  cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-pis
                            OR  cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-cofins
                            OR  cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-icms THEN
                                NEXT.
                       
                        IF l-nt2024002 THEN DO:
                            IF  AVAIL param-imp-trib THEN
                                IF cotacao-item-cex.cod-desp = param-imp-trib.cdn-despes-impto-CBS     
                                OR cotacao-item-cex.cod-desp = param-imp-trib.cdn-despes-impto-IBSMun     
                                OR cotacao-item-cex.cod-desp = param-imp-trib.cdn-despes-impto-IBSUF  
                                OR cotacao-item-cex.cod-desp = param-imp-trib.cdn-despes-impto-IS THEN
                                    NEXT.
                        END.
                        
                        FIND FIRST desp-imp 
                             WHERE desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.
                        
                        IF NOT desp-imp.inc-val-embal       AND
                           NOT desp-imp.inc-val-frete       AND
                           NOT desp-imp.inc-val-outras-desp AND
                           NOT desp-imp.inc-val-seguro      THEN
                            NEXT.
                          
                        IF l-existe-hist THEN DO:
                            /*se existir historico-embarque, valida se o ponto de controle que incide despesa nas cotacao-item-cex existe no historico-embarque */
                            IF NOT CAN-FIND(historico-embarque 
                                            WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
                                              AND historico-embarque.embarque      = embarque-imp.embarque 
                                              AND historico-embarque.cod-itiner    = processo-imp.cod-itiner 
                                              AND historico-embarque.cod-pto-contr = cotacao-item-cex.cod-pto-contr) THEN DO:

                                {utp/ut-liter.i "Hist¢rico_do_embarque" *}
                                RUN criaTTBoErro(INPUT 25197, INPUT STRING(cotacao-item-cex.cod-pto-contr) + "~~":U + 
                                                                    STRING(cotacao-item-cex.numero-ordem)  + "~~":U + 
                                                                    STRING(cotacao-item-cex.cod-desp)      + "~~":U + 
                                                                    RETURN-VALUE).
                                UNDO, RETURN.
                            END.
                        END.
                        ELSE DO:
                            /*Valida se o ponto de controle que incide despesa nas cotacao-item-cex existe no itinerario do processo-imp */
                            IF NOT CAN-FIND(pto-itiner 
                                            WHERE pto-itiner.cod-itiner    = processo-imp.cod-itiner 
                                              AND pto-itiner.cod-pto-contr = cotacao-item-cex.cod-pto-contr) THEN DO:

                                {utp/ut-liter.i "Itiner rio_do_Processo" *}
                                RUN criaTTBoErro(INPUT 25197, INPUT STRING(cotacao-item-cex.cod-pto-contr) + "~~":U + 
                                                                    STRING(cotacao-item-cex.numero-ordem)  + "~~":U + 
                                                                    STRING(cotacao-item-cex.cod-desp)      + "~~":U + 
                                                                    RETURN-VALUE).        
                                UNDO, RETURN.
                            END.
                        END.
                    
                        FIND FIRST desp-embarque
                             WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                               AND desp-embarque.embarque          = embarque-imp.embarque
                               AND desp-embarque.cod-itiner        = processo-imp.cod-itiner
                               AND desp-embarque.cod-pto-contr    = cotacao-item-cex.cod-pto-contr
                               AND desp-embarque.cod-desp          = cotacao-item-cex.cod-desp
                               AND desp-embarque.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp EXCLUSIVE-LOCK NO-ERROR.

                        IF NOT AVAIL desp-embarque THEN DO:
                            /* Valida se existem dois fornecedores(emitente) diferentes para a mesma despesa */
                            IF CAN-FIND (desp-embarque 
                                         WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                                           AND desp-embarque.embarque          = embarque-imp.embarque
                                           AND desp-embarque.cod-itiner        = processo-imp.cod-itiner
                                           AND desp-embarque.cod-pto-contr     = cotacao-item-cex.cod-pto-contr
                                           AND desp-embarque.cod-desp          = cotacao-item-cex.cod-desp) THEN DO:

                                {utp/ut-liter.i "Emitente" *}
                                RUN criaTTBoErro(INPUT 25219, INPUT STRING(cotacao-item-cex.cod-desp)     + "~~":U + 
                                                                    STRING(cotacao-item-cex.numero-ordem) + "~~":U + 
                                                                    RETURN-VALUE).
                                UNDO, RETURN.
                            END.
                        
                            /* Valida se existe a mesma despesa para pontos de controle deferentes */
                            IF CAN-FIND (desp-embarque 
                                             WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                                               AND desp-embarque.embarque          = embarque-imp.embarque
                                               AND desp-embarque.cod-itiner        = processo-imp.cod-itiner
                                               AND desp-embarque.cod-desp          = cotacao-item-cex.cod-desp) THEN DO:

                                {utp/ut-liter.i "Ponto_de_Controle" *}
                                RUN criaTTBoErro(INPUT 25219, INPUT STRING(cotacao-item-cex.cod-desp)     + "~~":U + 
                                                                    STRING(cotacao-item-cex.numero-ordem) + "~~":U + 
                                                                    RETURN-VALUE).
                                UNDO, RETURN.
                            END.
                        
                            CREATE desp-embarque.
                            ASSIGN desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                                   desp-embarque.embarque          = embarque-imp.embarque
                                   desp-embarque.cod-itiner        = processo-imp.cod-itiner
                                   desp-embarque.cod-pto-contr     = cotacao-item-cex.cod-pto-contr
                                   desp-embarque.cod-desp          = cotacao-item-cex.cod-desp
                                   desp-embarque.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp
                                   desp-embarque.cod-cond-pag      = cotacao-item-cex.cod-cond-pag
                                   desp-embarque.mo-codigo         = cotacao-item-cex.mo-codigo.
                        END.
                        ELSE DO:

                            /* Valida se existe a mesma despesa com moedas diferentes */
                            IF desp-embarque.mo-codigo <> cotacao-item-cex.mo-codigo THEN DO:

                                {utp/ut-liter.i "Moeda" *}
                                RUN criaTTBoErro(INPUT 25219, INPUT STRING(cotacao-item-cex.cod-desp)     + "~~":U + 
                                                                    STRING(cotacao-item-cex.numero-ordem) + "~~":U + 
                                                                    RETURN-VALUE).
                                UNDO, RETURN.
                            END.
                        END.

                        RUN GetRateioIncoterm (OUTPUT c-cod-incoterm-rat).
                        
                        ASSIGN desp-embarque.cod-incoterm-rat = c-cod-incoterm-rat.

                        /*--- Sugestao da incoterm rateio com base da despesa do pedido ----*/
                        FOR FIRST ordem-compra fields(numero-ordem it-codigo mo-codigo num-pedido cod-estabel cod-emitente gera-edi) 
                            WHERE ordem-compra.numero-ordem = cotacao-item-cex.numero-ordem NO-LOCK: END.

                        IF  AVAIL ordem-compra THEN
                            FOR FIRST despes-ped-compra FIELDS(cod-incoterm-rat)
                                WHERE despes-ped-compra.num-pedido        = ordem-compra.num-pedido
                                  AND despes-ped-compra.cod-desp          = cotacao-item-cex.cod-desp
                                  AND despes-ped-compra.mo-codigo         = cotacao-item-cex.mo-codigo
                                  AND despes-ped-compra.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp
                                  AND despes-ped-compra.cod-pto-contr     = cotacao-item-cex.cod-pto-contr
                                  AND despes-ped-compra.tp-despesa        = cotacao-item-cex.tp-despesa NO-LOCK:

                                ASSIGN desp-embarque.cod-incoterm-rat = despes-ped-compra.cod-incoterm-rat.
                            END.

                        ASSIGN de-conv-val-cex = cotacao-item-cex.val-desp.

                        IF cotacao-item-cex.mo-codigo <> desp-embarque.mo-codigo THEN DO:

                            RUN cdp/cd0812.p (INPUT  cotacao-item-cex.mo-codigo,
                                              INPUT  desp-embarque.mo-codigo,
                                              INPUT  cotacao-item-cex.val-desp,
                                              INPUT  TODAY,
                                              OUTPUT de-conv-val-cex).
                            
                            IF de-conv-val-cex = 0 OR de-conv-val-cex = ? THEN 
                                ASSIGN de-conv-val-cex = cotacao-item-cex.val-desp.
                        END.

                        IF desp-imp.tipo = 1 THEN /* valor fixo */
                            ASSIGN desp-embarque.val-desp = de-conv-val-cex.
                        ELSE
                            ASSIGN desp-embarque.val-desp = desp-embarque.val-desp + 
                                                           (de-conv-val-cex * de-quant-parcela).                                                    
                    END.
                END.
            END.

            /* Criacao das ordens-embarque */
            IF l-quebra-di THEN DO:
                
                FIND LAST b-prazo-compra 
                    WHERE b-prazo-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK NO-ERROR.
                
                IF AVAIL b-prazo-compra THEN
                    ASSIGN i-nova-parcela = b-prazo-compra.parcela + 1.
                ELSE 
                    ASSIGN i-nova-parcela = 1.

                FIND FIRST ordens-embarque
                     WHERE ordens-embarque.cod-estabel  = processo-imp.cod-estabel  
                       AND ordens-embarque.nr-proc-imp  = processo-imp.nr-proc-imp  
                       AND ordens-embarque.embarque     = embarque-imp.embarque     
                       AND ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                       AND ordens-embarque.parcela      = i-nova-parcela   EXCLUSIVE-LOCK NO-ERROR.
            END.         
            ELSE
                FIND FIRST ordens-embarque
                     WHERE ordens-embarque.cod-estabel  = processo-imp.cod-estabel  
                       AND ordens-embarque.nr-proc-imp  = processo-imp.nr-proc-imp  
                       AND ordens-embarque.embarque     = embarque-imp.embarque     
                       AND ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                       AND ordens-embarque.parcela      = prazo-compra.parcela      EXCLUSIVE-LOCK NO-ERROR.

            ASSIGN l-criou-ordens-embarque = NO.

            IF  NOT AVAIL ordens-embarque THEN DO:
                CREATE ordens-embarque.
                ASSIGN ordens-embarque.quantidade = 0
                       l-criou-ordens-embarque    = YES.
            END.

            ASSIGN ordens-embarque.cod-estabel  = processo-imp.cod-estabel
                   ordens-embarque.embarque     = embarque-imp.embarque
                   ordens-embarque.numero-ordem = prazo-compra.numero-ordem
                   ordens-embarque.parcela      = IF l-quebra-di THEN i-nova-parcela ELSE prazo-compra.parcela
                   ordens-embarque.nr-proc-imp  = processo-imp.nr-proc-imp
                   ordens-embarque.quantidade   = ordens-embarque.quantidade + de-quant-parcela
                   &IF  "{&bf_mat_versao_ems}":U >= "2.09":U &THEN
                       ordens-embarque.nr-ato-concessorio = prazo-compra.cod-ato-concessor
                   &ELSE
                       OVERLAY(ordens-embarque.char-1,1,20) = SUBSTRING(prazo-compra.char-2,11,30)
                   &ENDIF
                   .

            /* Atualizar pesos somente apos criar ordens-embarque */
            IF  l-criou-ordens-embarque THEN DO:

                FOR FIRST ordem-compra FIELDS(numero-ordem it-codigo mo-codigo num-pedido cod-estabel cod-emitente gera-edi) 
                    WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK: END.

                IF VALID-HANDLE(h-boin356) AND VALID-HANDLE(h-bodi425) THEN DO:
                    
                    RUN piRetornaQtdeEmbalagem IN h-bodi425(INPUT  ordens-embarque.quantidade, 
                                                            INPUT  prazo-compra.it-codigo, 
                                                            INPUT  ordem-compra.cod-emitente,
                                                            OUTPUT d-qtd-embal).

                    RUN retornaPesoTotal IN h-boin356 (INPUT  ROWID(prazo-compra), 
                                                       INPUT  ordens-embarque.quantidade, 
                                                       INPUT  d-qtd-embal, 
                                                       OUTPUT de-peso-total).

                    IF NOT l-emb THEN
                        RUN retornaVolumeTotal IN h-boin356 (INPUT  ROWID(prazo-compra), 
                                                             INPUT  ordens-embarque.quantidade, 
                                                             OUTPUT de-volume-total).
                    ELSE
                        RUN retornaVolumeTotal IN h-boin356 (INPUT  ROWID(prazo-compra), 
                                                             INPUT  IF d-qtd-embal <> 0 THEN d-qtd-embal ELSE ordens-embarque.quantidade,
                                                             OUTPUT de-volume-total).
                END.

                FOR FIRST item FIELDS (peso-liquido peso-bruto altura largura comprim)
                    WHERE item.it-codigo = c-it-codigo NO-LOCK:

                    ASSIGN ordens-embarque.peso-liquido = item.peso-liquido * ordens-embarque.quantidade
                           ordens-embarque.peso-bruto   = de-peso-total
                           ordens-embarque.val-cub-tot  = de-volume-total.
                END.
            END.

            {cxbo/bocx225.i2}
            
            ASSIGN v-data     = prazo-compra.data-entrega
                   v-parcela  = prazo-compra.parcela
                   v-ordem    = prazo-compra.numero-ordem.            
            
            FOR FIRST item-fornec FIELDS(fator-conver num-casa-dec)
                WHERE item-fornec.it-codigo    = c-it-codigo 
                  AND item-fornec.cod-emitente = processo-imp.cod-exportador NO-LOCK: END.
                   
            IF AVAIL item-fornec THEN
                ASSIGN ordens-embarque.qt-do-forn = ordens-embarque.quantidade
                                                  * (item-fornec.fator-conver / 
                                                  IF item-fornec.num-casa-dec = 0 THEN 1
                                                  ELSE EXP(10,item-fornec.num-casa-dec)).          
            ELSE ASSIGN ordens-embarque.qt-do-forn = ordens-embarque.quantidade.
        END.
    END.

    /*******************************************************************************************************/

    /* 
    ** Teste para atualizar o status do processo-imp. Se o parametro gera hist processo estiver setado
    ** atualiza, senao so atualiza se houver historico do embarque e a data de embarque estiver efetivada 
    */         
    FOR FIRST param-imp FIELDS(hist-processo)
        WHERE param-imp.cod-estabel = embarque-imp.cod-estabel NO-LOCK: END.
    IF NOT AVAIL param-imp THEN DO:

        {utp/ut-table.i mgcex param-imp 1}
        RUN criaTTBoErro(INPUT 2, INPUT RETURN-VALUE).
        
        UNDO, RETURN.
    END.
    
    IF AVAIL param-imp THEN DO: 
       IF param-imp.hist-processo THEN
          RUN pi-atualizaSitProc(INPUT i-num-pedido).
       ELSE DO:
          FIND FIRST historico-embarque
               WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                 AND historico-embarque.embarque      = embarque-imp.embarque
                 AND historico-embarque.cod-itiner    = i-cod-itiner
                 AND historico-embarque.cod-pto-contr = i-pto-embarque NO-LOCK NO-ERROR.
          
          IF AVAIL historico-embarque AND historico-embarque.dt-efetiva <> ? THEN
             RUN pi-atualizaSitProc (INPUT i-num-pedido).
       END.
    END.
    
    ASSIGN v-nova-qtde  = 0.
    
    IF NOT l-create-hist THEN DO:
        
        ASSIGN l-create-hist = YES.

        /***** Averiguando a menor data *****/
        FOR EACH  prazo-compra FIELDS(quantidade quant-saldo &IF  "{&bf_mat_versao_ems}":U >= "2.09":U &THEN cod-ato-concessor &ELSE char-2 &ENDIF)  
            WHERE prazo-compra.numero-ordem = i-numero-ordem NO-LOCK:

            IF prazo-compra.quantidade > p-nova-qtde THEN
                                                /*quantidade*/
               ASSIGN v-diferenca = prazo-compra.quant-saldo - p-nova-qtde.
            ELSE 
                ASSIGN v-diferenca = 0.                   /*quantidade*/
            
            ASSIGN v-nova-qtde = v-nova-qtde + (prazo-compra.quant-saldo - v-diferenca).
            
            IF v-nova-qtde > p-nova-qtde THEN 
                LEAVE.
        END.

        FIND FIRST historico-embarque NO-LOCK
             WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
               AND historico-embarque.embarque      = embarque-imp.embarque    
               AND historico-embarque.cod-itiner    = processo-imp.cod-itiner 
               AND historico-embarque.cod-pto-contr = i-pto-chegada NO-ERROR.
        
        IF NOT AVAIL historico-embarque THEN DO:

            RUN pi-createHistEmbarque (INPUT embarque-imp.cod-estabel,
                                       INPUT embarque-imp.embarque,
                                       INPUT processo-imp.nr-proc-imp,
                                       INPUT v-data,
                                       INPUT processo-imp.cod-itiner,
                                       INPUT processo-imp.cod-exportador,
                                       INPUT processo-imp.cod-despachante,
                                       INPUT processo-imp.cod-agente,
                                       INPUT processo-imp.cod-fabricante,
                                       INPUT param-imp.hist-processo,
                                       INPUT i-pto-chegada,
                                       INPUT c-cod-idiom-usuar,
                                       OUTPUT TABLE tt-bo-erro).
            
            
            
            IF NOT l-necessita-li THEN
                RUN piEliminaPtoLI IN THIS-PROCEDURE.
        END.
        
        FIND FIRST tt-bo-erro 
             WHERE tt-bo-erro.cd-erro = 25196 EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL tt-bo-erro THEN DO:
            ASSIGN i-seq-erro = tt-bo-erro.i-sequen
                   c-msg      = "".
            {utp/ut-liter.i de_chegada} 
            ASSIGN c-msg = TRIM(RETURN-VALUE)     + " " 
                         + STRING(i-pto-chegada)  + "~~":U
                         + STRING(i-numero-ordem) + "~~":U
                         + STRING(processo-imp.cod-itiner).

            ASSIGN tt-bo-erro.parametros = c-msg.        
            
            RUN utp/ut-msgs.p (input "msg":U,
                               input 25196,
                               input c-msg).

            ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 25196
                   tt-bo-erro.mensagem     = RETURN-VALUE.

            FOR EACH ordens-embarque EXCLUSIVE-LOCK
               WHERE ordens-embarque.numero-ordem = i-numero-ordem
                 AND ordens-embarque.cod-estabel  = processo-imp.cod-estabel
                 AND ordens-embarque.embarque     = embarque-imp.embarque:
                DELETE ordens-embarque.
            END.
            UNDO, LEAVE.
        END.

        FIND FIRST historico-embarque NO-LOCK
             WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
               AND historico-embarque.embarque      = embarque-imp.embarque    
               AND historico-embarque.cod-itiner    = processo-imp.cod-itiner 
               AND historico-embarque.cod-pto-contr = i-pto-chegada NO-ERROR.

        IF AVAIL historico-embarque THEN DO:

            FOR EACH ordens-embarque NO-LOCK 
               WHERE ordens-embarque.cod-estabel  = processo-imp.cod-estabel
                 AND  ordens-embarque.embarque     = embarque-imp.embarque:

                FIND FIRST prazo-compra EXCLUSIVE-LOCK 
                     WHERE prazo-compra.numero-ordem = ordens-embarque.numero-ordem 
                       AND prazo-compra.parcela      = ordens-embarque.parcela NO-ERROR.

                IF AVAIL prazo-compra THEN DO:
                     
                    IF prazo-compra.data-entrega <> historico-embarque.dt-ult-previsao THEN DO:

                        FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem EXCLUSIVE-LOCK NO-ERROR.
                        /* Criar Registro na tabela alt-ped */
                        {cxbo/bocx140.i03 today
                                          c-seg-usuario 
                                          ordem-compra.num-pedido
                                          ordem-compra.numero-ordem 
                                          prazo-compra.parcela
                                          prazo-compra.data-entrega
                                          ?
                                          ?
                                          ordem-compra.cod-emitente
                                          ordem-compra.gera-edi
                                          ordem-compra.num-pedido
                                          historico-embarque.dt-ult-previsao} 
                    END.
                    
                    ASSIGN prazo-compra.data-entrega-ant = prazo-compra.data-entrega
                           prazo-compra.data-entrega = historico-embarque.dt-ult-previsao.
                END.
            END.
        END.
    END.

    RUN piAtualizaEmbarqueImp (INPUT embarque-imp.cod-estabel,
                               INPUT embarque-imp.embarque,   
                               INPUT processo-imp.cod-itiner,
                               INPUT processo-imp.nr-proc-imp).
    
    IF l-necessita-li THEN 
        RUN piCriaPtoLI IN THIS-PROCEDURE.
    
    
    
    /*--- Chamada UPC ---*/
    FOR EACH tt-epc WHERE tt-epc.cod-event = "AfterCreateOrdensEmbarque".
        DELETE tt-epc.
    END.
    
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AfterCreateOrdensEmbarque":U
           tt-epc.cod-parameter = "ordem-compra.numero-ordem":U
           tt-epc.val-parameter = string(p-numero-ordem).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AfterCreateOrdensEmbarque":U
           tt-epc.cod-parameter = "row-embarque-imp":U
           tt-epc.val-parameter = string(r-embarque).

    /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i '"AfterCreateOrdensEmbarque"'}
    
    /*--- Fim chamada UPC ---*/


    RETURN "OK":U.

    FINALLY:
        IF  VALID-HANDLE (h-bocx230a) THEN DO:
            DELETE PROCEDURE h-bocx230a.
            ASSIGN h-bocx230a = ?.
        END.
        
        IF VALID-HANDLE(h-boin356) THEN DO:
            DELETE PROCEDURE h-boin356.
            ASSIGN h-boin356 = ?.
        END.
        
        IF VALID-HANDLE(h-bodi425) THEN DO:
            DELETE PROCEDURE h-bodi425.
            ASSIGN h-bodi425 = ?.
        END.
        
        IF  VALID-HANDLE (h-bocx00488) THEN DO:
            DELETE PROCEDURE h-bocx00488.
            ASSIGN h-bocx00488 = ?.
        END.
    END FINALLY.

END PROCEDURE.

PROCEDURE RetornaDataParcelaNaoEmbarcada:
/*------------------------------------------------------------------------------
  Purpose: Procura a data de entrega da primeira parcela nao embarcada 
           (parcela da ordem nao relacionada a um embaque) 
  Parameters:  INPUT - p-cod-estabel (character) - codigo do estabelecimento do embarque
               INPUT - p-embarque (character) - codigo do embarque
               INPUT - p-numero-ordem (integer) - numero da ordem de compra
               OUTPUT - p-data-entrega (date) - data de entrega da parcela nao embarcada
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel     LIKE embarque-imp.cod-estabel    NO-UNDO.
    DEFINE INPUT  PARAMETER p-embarque        LIKE embarque-imp.embarque       NO-UNDO.
    DEFINE INPUT  PARAMETER p-numero-ordem    LIKE ordem-compra.numero-ordem   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-data-entrega    AS DATE                          NO-UNDO.
    
    DEFINE BUFFER bf-ordens-embarque FOR ordens-embarque.
    
    DEFINE VARIABLE v-data  AS DATE                          NO-UNDO.
    DEFINE VARIABLE i-quant LIKE ordens-embarque.quantidade  NO-UNDO.

    FIND FIRST prazo-compra NO-LOCK
         WHERE prazo-compra.numero-ordem = p-numero-ordem NO-ERROR.

    IF AVAIL prazo-compra THEN DO: 

       ASSIGN v-data = prazo-compra.data-entrega. 

       REPEAT:
          FOR FIRST ordens-embarque FIELDS(numero-ordem parcela quantidade) 
              WHERE ordens-embarque.numero-ordem = p-numero-ordem
                AND ordens-embarque.parcela      = prazo-compra.parcela NO-LOCK: END.

          IF AVAIL ordens-embarque THEN DO:
             ASSIGN i-quant = 0.

             FOR EACH bf-ordens-embarque NO-LOCK
                WHERE bf-ordens-embarque.numero-ordem = ordens-embarque.numero-ordem
                  AND bf-ordens-embarque.parcela      = ordens-embarque.parcela:
                 ASSIGN i-quant = i-quant + ordens-embarque.quantidade.
             END.
             IF i-quant = prazo-compra.quantidade THEN DO:

                FIND NEXT prazo-compra NO-LOCK 
                    WHERE prazo-compra.numero-ordem = p-numero-ordem NO-ERROR.
                
                IF AVAIL prazo-compra THEN
                    ASSIGN v-data = prazo-compra.data-entrega.
                ELSE 
                    LEAVE.
             END.
             ELSE   
                 LEAVE.
          END.
          ELSE
              LEAVE.
       END.
    END.
    ASSIGN p-data-entrega = v-data.       

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE retorna_dados_embarque:
/*------------------------------------------------------------------------------
  Purpose: Retorna o estabelecimento e o codigo do embarque
  Parameters:  INPUT - r-rowid (rowid) - rowid do registro que se deseja as informacoes
               OUTPUT - c-cod-estabel (character) - codigo do estabelecimento
               OUTPUT - c-embarque (character) - codigo do embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER r-rowid       AS   ROWID                    NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cod-estabel LIKE embarque-imp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER c-embarque    LIKE embarque-imp.embarque    NO-UNDO.
    
    FOR FIRST embarque-imp FIELDS(cod-estabel embarque)  
        WHERE ROWID(embarque-imp) = r-rowid NO-LOCK: END.

    IF AVAIL embarque-imp THEN DO:
        ASSIGN c-cod-estabel = embarque-imp.cod-estabel 
               c-embarque    = embarque-imp.embarque.
    END.   
    ELSE ASSIGN c-cod-estabel = "" 
                c-embarque    = "".

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE retorna_qtde_alocada:
/*------------------------------------------------------------------------------
  Purpose: Retorna se o valor passado como parametro e possivel de ser alocado
  Parameters:  INPUT - p-numero-ordem (integer) - numero da ordem de compra
               INPUT - p-parcela (integer) - numero da parcela
               INPUT - p-qtde-in (decimal) - quantidade que se deseja alocar
               OUTPUT - p-qtde-out (decimal) - quantidade disponivel para alocar
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT   PARAMETER p-numero-ordem LIKE ordem-compra.numero-ordem   NO-UNDO.
    DEFINE INPUT   PARAMETER p-parcela      LIKE prazo-compra.parcela        NO-UNDO.
    DEFINE INPUT   PARAMETER p-qtde-in      LIKE ordens-embarque.quantidade  NO-UNDO.
    DEFINE OUTPUT  PARAMETER p-qtde-out     LIKE ordens-embarque.quantidade  NO-UNDO.
    
    DEFINE VARIABLE v-qtde-out LIKE ordens-embarque.quantidade  NO-UNDO.
    
    ASSIGN v-qtde-out = 0.
    
    FOR EACH ordens-embarque FIELDS(quantidade) NO-LOCK 
       WHERE ordens-embarque.numero-ordem = p-numero-ordem
         AND ordens-embarque.parcela      = p-parcela:

        ASSIGN v-qtde-out = v-qtde-out + ordens-embarque.quantidade.
    END.

    ASSIGN p-qtde-out = p-qtde-in - v-qtde-out.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE procuraEmbarqueCompras:
/*------------------------------------------------------------------------------
  Purpose: Verifica se existe embarque para o pedido/ordem/parela passados como parametro
  Parameters:  INPUT - num-pedido (integer) - numero do pedido de compra
               INPUT - numero-ordem (integer) - numero da ordem de compra
               INPUT - parcela (integer) - numero da parcela de compra
               OUTPUT TABLE - tt-embarque - TempTable com os embarques encontrados
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER num-pedido   LIKE ordem-compra.num-pedido        NO-UNDO.
    DEFINE INPUT PARAMETER numero-ordem LIKE ordens-embarque.numero-ordem   NO-UNDO.
    DEFINE INPUT PARAMETER parcela      LIKE ordens-embarque.parcela        NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-embarque.

    EMPTY TEMP-TABLE tt-embarque.

    IF numero-ordem <> ? AND parcela <> ? THEN
        FOR EACH ordens-embarque
           WHERE ordens-embarque.numero-ordem = numero-ordem
             AND ordens-embarque.parcela = parcela NO-LOCK 
              BY ordens-embarque.embarque:

            FIND FIRST tt-embarque 
                 WHERE tt-embarque.embarque = ordens-embarque.embarque NO-ERROR.

            IF NOT AVAIL tt-embarque THEN DO:
                CREATE tt-embarque.
                ASSIGN tt-embarque.embarque = ordens-embarque.embarque.
            END.
        END.
    ELSE
        IF numero-ordem <> ? THEN
            FOR EACH ordens-embarque
               WHERE ordens-embarque.numero-ordem = numero-ordem NO-LOCK
                  BY ordens-embarque.embarque:

                FIND FIRST tt-embarque 
                     WHERE tt-embarque.embarque = ordens-embarque.embarque NO-ERROR.

                IF NOT AVAIL tt-embarque THEN DO:
                    CREATE tt-embarque.
                    ASSIGN tt-embarque.embarque = ordens-embarque.embarque.
                END.
            END.
        ELSE
            IF num-pedido <> ? THEN DO:          
                FOR EACH ordem-compra
                    WHERE ordem-compra.num-pedido = num-pedido NO-LOCK:
                    
                    FOR EACH ordens-embarque
                       WHERE ordens-embarque.numero-ordem = ordem-compra.numero-ordem NO-LOCK
                          BY ordens-embarque.embarque:
                        
                        FIND FIRST tt-embarque-aux 
                             WHERE tt-embarque-aux.embarque = ordens-embarque.embarque NO-ERROR.

                        IF NOT AVAIL tt-embarque-aux THEN DO:
                            CREATE tt-embarque-aux.
                            ASSIGN tt-embarque-aux.embarque = ordens-embarque.embarque.
                        END.
                    END.
                END.
                FOR EACH tt-embarque-aux.
                    CREATE tt-embarque.
                    ASSIGN tt-embarque.embarque = tt-embarque-aux.embarque.
                END.
            END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE findOrdensEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Procura ordens-embarque com o parametro passado
  Parameters:  INPUT - i-numero-ordem (integer) - numero da ordem de compra
               OUTPUT - c-return (character) - retorno de erro caso nao ache o registro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM i-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAM c-return       AS CHARACTER                   NO-UNDO.

    RUN startMethod("find":U).
    
    FIND FIRST ordens-embarque 
         WHERE ordens-embarque.numero-ordem = i-numero-ordem NO-LOCK NO-ERROR.

    IF NOT AVAIL ordens-embarque THEN DO:
        {utp/ut-table.i mgcex ordens-embarque 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
        ASSIGN c-return = RETURN-VALUE.
    END.
    ELSE
        RUN SetCurrent.

    RUN EndMethod("find":U).
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE findOrdensEmbarqueParcela:
/*------------------------------------------------------------------------------
  Purpose: Procura ordens-embarque com os parametros passados
  Parameters:  INPUT - i-numero-ordem (integer) - numero da ordem de compra
               INPUT - i-parcela (integer) - numero da parcela da ordem de compra
               OUTPUT - c-return (character) - retorno de erro caso nao ache o registro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM i-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAM i-parcela      LIKE prazo-compra.parcela      NO-UNDO. 
    DEFINE OUTPUT PARAM c-return       AS CHARACTER                   NO-UNDO.

    RUN startMethod("find":U).
    
    FIND FIRST ordens-embarque 
         WHERE ordens-embarque.numero-ordem = i-numero-ordem 
           AND ordens-embarque.parcela      = i-parcela NO-LOCK NO-ERROR.

    IF NOT AVAIL ordens-embarque THEN DO:
        {utp/ut-table.i mgcex ordens-embarque 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
        ASSIGN c-return = RETURN-VALUE.
    END.
    ELSE
        RUN SetCurrent.

    RUN EndMethod("find":U).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE GetRateioIncoterm:
/*------------------------------------------------------------------------------
  Purpose: Retorna Incoterm de rateio da cotacao posicionada 
  Parameters:  OUTPUT - pc-cod-incoterm-rat - codigo da incoterm de rateio
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pc-cod-incoterm-rat AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE l-rateio AS LOGICAL NO-UNDO.

    ASSIGN l-rateio = NO.

    FIND FIRST cot-ordem 
         WHERE cot-ordem.numero-ordem = cotacao-item-cex.numero-ordem 
           AND cot-ordem.cod-emitente = cotacao-item-cex.cod-emitente 
           AND cot-ordem.seq-cotac    = cotacao-item-cex.seq-cotac    
           AND cot-ordem.mapa-aprovado NO-LOCK NO-ERROR.

    IF AVAIL cot-ordem THEN DO:

        FIND FIRST desp-cot-ordem NO-LOCK
             WHERE desp-cot-ordem.cod-agrup         = cot-ordem.cod-agrup
             AND   desp-cot-ordem.mapa-ordem        = cot-ordem.mapa-ordem
             AND   desp-cot-ordem.cod-desp          = cotacao-item-cex.cod-desp
             AND   desp-cot-ordem.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp NO-ERROR.

        IF AVAIL desp-cot-ordem THEN DO:

            IF desp-cot-ordem.cod-incoterm-rat <> "" THEN DO:
                
                ASSIGN pc-cod-incoterm-rat = desp-cot-ordem.cod-incoterm-rat 
                       l-rateio            = YES.                         
            END.
        END.
    END.

    IF NOT l-rateio THEN
       ASSIGN pc-cod-incoterm-rat = desp-imp.cod-incoterm-rat. 
                                                             
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE incluiCamposEmitente:
/*------------------------------------------------------------------------------
  Purpose: Preenche campos do embarque com os mesmos do processo de importacao, caso
           eles estejam sem informacao
  Parameters:  INPUT - p-cod-estabel (character) - codigo do estabelecimento
               INPUT - p-embarque (chracter) - codigo do embarque
               INPUT - p-nr-proc-imp (character) - codigo do processo de importacao
  Notes:       
------------------------------------------------------------------------------*/
     DEFINE INPUT PARAMETER p-cod-estabel     LIKE embarque-imp.cod-estabel     NO-UNDO.
     DEFINE INPUT PARAMETER p-embarque        LIKE embarque-imp.embarque        NO-UNDO.
     DEFINE INPUT PARAMETER p-nr-proc-imp     LIKE processo-imp.nr-proc-imp     NO-UNDO.

     
     FOR FIRST processo-imp 
         WHERE processo-imp.cod-estabel = p-cod-estabel
           AND processo-imp.nr-proc-imp = p-nr-proc-imp NO-LOCK:
     END.

     IF AVAIL processo-imp THEN DO:

         FOR FIRST embarque-imp 
             WHERE embarque-imp.cod-estabel = p-cod-estabel
               AND embarque-imp.embarque    = p-embarque EXCLUSIVE-LOCK:

             IF embarque-imp.cdn-corretor-cambio-import = 0 OR embarque-imp.cdn-corretor-cambio-import = ? THEN
                ASSIGN embarque-imp.cdn-corretor-cambio-import = processo-imp.cdn-corretor-cambio-import.

             IF embarque-imp.cdn-despa-exter-import = 0 OR embarque-imp.cdn-despa-exter-import = ? THEN
                ASSIGN embarque-imp.cdn-despa-exter-import = processo-imp.cdn-despa-exter-import.

             IF embarque-imp.cdn-segurad-import = 0 OR embarque-imp.cdn-segurad-import = ? THEN
                ASSIGN embarque-imp.cdn-segurad-import = processo-imp.cdn-segurad-import.

             IF embarque-imp.cdn-corretor-import = 0 or embarque-imp.cdn-corretor-import = ? THEN
                ASSIGN embarque-imp.cdn-corretor-import = processo-imp.cdn-corretor-import.
         END.
     END.
     
     RETURN "OK":U.
END PROCEDURE.

PROCEDURE piNecessitaLiEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Verifica se o embarque possui itens que necessitam de licenciamento de importacao 
  Parameters:  INPUT - cCodEstabel (character) - codigo do estabelecimento
               INPUT - cEmbarque (character) - codigo do embarque
               OUTPUT TABLE - rowErrors - caso TT esteja preenchida embarque nao necessita de LI.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER cCodEstabel AS CHARACTER FORMAT "x(05)":U  NO-UNDO.
    DEFINE INPUT  PARAMETER cEmbarque   LIKE embarque-imp.embarque     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    DEFINE VARIABLE l-necessita-li     AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-possui-pto-li    AS LOGICAL NO-UNDO.

    EMPTY TEMP-TABLE rowErrors.

    ASSIGN l-necessita-li = NO.

    FIND FIRST param-imp 
         WHERE param-imp.cod-estabel = cCodEstabel NO-LOCK NO-ERROR.

    IF AVAIL param-imp AND SUBSTRING(param-imp.char-1,167,1) = "S":U THEN
        ASSIGN l-necessita-li = YES.
    ELSE
        FOR EACH ordens-embarque FIELDS (numero-ordem)
           WHERE ordens-embarque.cod-estabel = cCodEstabel
             AND ordens-embarque.embarque    = cEmbarque NO-LOCK,
           FIRST ordem-compra FIELDS (it-codigo)
           WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK,
           FIRST item FIELDS (log-necessita-li)
           WHERE item.it-codigo = ordem-compra.it-codigo 
             AND item.log-necessita-li NO-LOCK:

            ASSIGN l-necessita-li = YES.
            LEAVE.
        END.

    FOR FIRST historico-embarque FIELDS(cod-itiner)
        WHERE historico-embarque.cod-estabel = cCodEstabel
          AND historico-embarque.embarque    = cEmbarque NO-LOCK: END.

    IF AVAIL historico-embarque THEN DO:

        FOR FIRST itinerario FIELDS (cod-itiner cdn-pto-solic-licenciam-import)
            WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK: END.

        IF AVAIL itinerario THEN DO:
            
            IF  CAN-FIND(FIRST historico-embarque
                         WHERE historico-embarque.cod-estabel   = cCodEstabel
                           AND historico-embarque.embarque      = cEmbarque
                           AND historico-embarque.cod-itiner    = itinerario.cod-itiner
                           AND historico-embarque.cod-pto-contr = itinerario.cdn-pto-solic-licenciam-import) THEN 
                ASSIGN l-possui-pto-li = YES.
        END.
    END.

    IF l-possui-pto-li AND NOT l-necessita-li THEN DO:

        ASSIGN i-seq-erro = i-seq-erro + 1.    
        RUN utp/ut-msgs.p (INPUT "msg":U,
	                       INPUT 30441,
 		                   INPUT cEmbarque).
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = i-seq-erro
               RowErrors.ErrorNumber      = 30441
               RowErrors.ErrorDescription = RETURN-VALUE.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCriaPtoLI:
/*------------------------------------------------------------------------------
  Purpose: Cria ponto de controle no acompanhamento do embarque que necessita de
           Licenca de importacao
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    EMPTY TEMP-TABLE tt-historico-embarque.

    FOR FIRST historico-embarque FIELDS (cod-itiner)
        WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
          AND historico-embarque.embarque    = embarque-imp.embarque NO-LOCK: END.

    IF AVAIL historico-embarque THEN DO:

        FOR FIRST itinerario FIELDS (cdn-pto-solic-licenciam-import cod-itiner)
            WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK: END.

        IF AVAIL itinerario THEN DO:

            FOR FIRST historico-embarque FIELDS (cod-pto-contr)
                WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                  AND historico-embarque.embarque      = embarque-imp.embarque 
                  AND historico-embarque.cod-itiner    = itinerario.cod-itiner 
                  AND historico-embarque.cod-pto-contr = itinerario.cdn-pto-solic-licenciam-import NO-LOCK: END.

            IF NOT AVAIL historico-embarque THEN DO:

                IF itinerario.cdn-pto-solic-licenciam-import > 0 THEN DO:
                    
                    FIND FIRST pto-contr 
                         WHERE pto-contr.cod-pto-contr = itinerario.cdn-pto-solic-licenciam-import NO-LOCK NO-ERROR.
                                
                    FOR FIRST  pto-itiner FIELDS(sequencia cod-pto-contr nr-dias)
                        WHERE  pto-itiner.cod-itiner    = itinerario.cod-itiner 
                          AND  pto-itiner.cod-pto-contr = pto-contr.cod-pto-contr NO-LOCK: END.

                    /* Criacao do ponto de controle Solicita LI */
                    CREATE tt-historico-embarque.
                    ASSIGN tt-historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                           tt-historico-embarque.embarque      = embarque-imp.embarque
                           tt-historico-embarque.cod-itiner    = itinerario.cod-itiner
                           tt-historico-embarque.cod-pto-contr = itinerario.cdn-pto-solic-licenciam-import
                           tt-historico-embarque.descricao     = pto-contr.descricao
                           tt-historico-embarque.log-1         = NOT(pto-contr.log-1)
                           tt-historico-embarque.nr-dias       = pto-itiner.nr-dias 
                           tt-historico-embarque.dt-efetiva    = ?.
                    
                    /* Se houver registro no acompanhamento do embarque do ponto de controle anterior ao ponto
                       de solicitacao do licenciamento cadastrado no itinerario (cd2567) e o ponto posterior
                       ao mesmo nao estiver efetivado, o ponto Solicita LI sera gerado com a sequencia subsequente
                       ao ponto anterior ao do ponto Solicita LI, caso contrario, o ponto Solicita LI ser  gerado
                       imediatamente apos o ultimo ponto de controle efetivado para o embarque em questao */
                    
                    FIND FIRST pto-itiner 
                         WHERE pto-itiner.cod-pto-contr = itinerario.cdn-pto-solic-licenciam-import
                           AND pto-itiner.cod-itiner    = itinerario.cod-itiner NO-LOCK NO-ERROR.

                    IF AVAIL pto-itiner THEN DO:

                        ASSIGN i-nr-dias-pto-solic-li = pto-itiner.nr-dias.

                        /* Ponto anterior ao ponto de Solicitacao LI */
                        FIND PREV pto-itiner 
                            WHERE pto-itiner.cod-itiner = itinerario.cod-itiner NO-LOCK NO-ERROR.

                        IF AVAIL pto-itiner THEN DO:

                            /* Historico ponto anterior ao de Solicitacao LI */
                            FIND FIRST historico-embarque 
                                 WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                                   AND historico-embarque.embarque      = embarque-imp.embarque 
                                   AND historico-embarque.cod-itiner    = itinerario.cod-itiner 
                                   AND historico-embarque.cod-pto-contr = pto-itiner.cod-pto-contr NO-LOCK NO-ERROR.

                            IF AVAIL historico-embarque THEN DO:

                                ASSIGN i-sequencia = historico-embarque.sequencia.

                                IF historico-embarque.dt-efetiva <> ? THEN
                                    ASSIGN da-ult-previsao = historico-embarque.dt-efetiva.
                                ELSE
                                    ASSIGN da-ult-previsao = historico-embarque.dt-ult-previsao.

                                FIND NEXT historico-embarque 
                                    WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                                      AND historico-embarque.embarque      = embarque-imp.embarque 
                                      AND historico-embarque.cod-itiner    = itinerario.cod-itiner NO-LOCK NO-ERROR.

                                IF AVAIL historico-embarque AND historico-embarque.dt-efetiva = ? THEN 
                                    ASSIGN tt-historico-embarque.sequencia   = i-sequencia + 1
                                           tt-historico-embarque.dt-previsao = da-ult-previsao + i-nr-dias-pto-solic-li.
                            END.
                        END.
                            
                        IF tt-historico-embarque.sequencia = 0 THEN DO:

                            ASSIGN tt-historico-embarque.sequencia = 1.

                            FIND LAST historico-embarque 
                                WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
                                  AND historico-embarque.embarque    = embarque-imp.embarque 
                                  AND historico-embarque.cod-itiner  = itinerario.cod-itiner
                                  AND historico-embarque.dt-efetiva <> ? NO-LOCK NO-ERROR.

                            IF AVAIL historico-embarque THEN
                                ASSIGN tt-historico-embarque.sequencia   = historico-embarque.sequencia + 1
                                       tt-historico-embarque.dt-previsao = historico-embarque.dt-efetiva + i-nr-dias-pto-solic-li.
                        END.
                    END.

                    IF VALID-HANDLE(h-bocx230a) THEN
                        RUN validateCreate in h-bocx230a (INPUT  TABLE tt-historico-embarque,
                                                          OUTPUT TABLE tt-bo-erro APPEND,
                                                          OUTPUT r-historico-embarque).
                END. /* cdn-pto-solic-licenciam-import */
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piEliminaPtoLI:
/*------------------------------------------------------------------------------
  Purpose: Elimina o ponto de controle do acompanhamento do embarque que necessita de LI
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-ponto-base AS LOGICAL NO-UNDO.
    
    FOR FIRST historico-embarque FIELDS (cod-itiner)
        WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
          AND historico-embarque.embarque    = embarque-imp.embarque NO-LOCK: END.

    IF AVAIL historico-embarque THEN DO:

        FOR FIRST itinerario FIELDS(cdn-pto-solic-licenciam-import cod-itiner pto-chegada)
            WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK: END.

        IF AVAIL itinerario THEN DO:
            
            /* Verifica se o ponto de LI ‚ o ponto base na cota‡Æo */
            ASSIGN l-ponto-base = NO.

            FOR EACH ordens-embarque 
               WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                 AND ordens-embarque.embarque    = embarque-imp.embarque    NO-LOCK:

                FOR FIRST cotacao-item FIELDS(char-1)
                    WHERE cotacao-item.numero-ordem = ordens-embarque.numero-ordem 
                      AND cotacao-item.cot-aprovada NO-LOCK:

                    {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                    {ccp/cc9019.i51 "yes"}

                    IF i-cod-pto-contr-i50 = itinerario.cdn-pto-solic-licenciam-import THEN DO:
                       ASSIGN l-ponto-base = YES.
                       LEAVE.
                    END.
                END. 
            END.
   
            IF NOT l-ponto-base THEN DO:
                
                FIND FIRST historico-embarque 
                     WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                       AND historico-embarque.embarque      = embarque-imp.embarque 
                       AND historico-embarque.cod-itiner    = itinerario.cod-itiner 
                       AND historico-embarque.cod-pto-contr = itinerario.cdn-pto-solic-licenciam-import EXCLUSIVE-LOCK NO-ERROR.

                IF AVAIL historico-embarque THEN DO:

                    ASSIGN historico-embarque.dt-efetiva = ?
                           r-historico-embarque          = ROWID(historico-embarque).
    
                    IF VALID-HANDLE(h-bocx230a) THEN
                        RUN validateDelete in h-bocx230a (INPUT-OUTPUT r-historico-embarque,
                                                          OUTPUT TABLE tt-bo-erro APPEND).
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE createOrdensNac:
/*------------------------------------------------------------------------------
  Purpose: Criacao daS Temp Table's tt-ordens-nac e tt-ordens-embarque-aux.
  Parameters:  INPUT TABLE - tt-ordens-embarque1 - TT base para criacao
               OUTPUT TABLE - tt-ordens-nac -
               OUTPUT TABLE - tt-ordens-embarque-aux
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR tt-ordens-embarque1.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-ordens-nac.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-ordens-embarque-aux.

    EMPTY TEMP-TABLE tt-ordens-nac.
    EMPTY TEMP-TABLE tt-ordens-embarque-aux.
    
    FOR EACH tt-ordens-embarque1:

        FIND FIRST tt-ordens-nac 
             WHERE tt-ordens-nac.cod-estabel       = tt-ordens-embarque1.cod-estabel
               AND tt-ordens-nac.embarque          = tt-ordens-embarque1.embarque
               AND tt-ordens-nac.numero-ordem      = tt-ordens-embarque1.numero-ordem
               AND tt-ordens-nac.parcela           = tt-ordens-embarque1.parcela NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-ordens-nac THEN DO:

            CREATE tt-ordens-nac.
            BUFFER-COPY tt-ordens-embarque1 TO tt-ordens-nac.

            FIND FIRST ordem-compra 
                 WHERE ordem-compra.numero-ordem = tt-ordens-embarque1.numero-ordem NO-LOCK NO-ERROR.

            IF AVAIL ordem-compra THEN
                ASSIGN tt-ordens-nac.c-it-codigo = ordem-compra.it-codigo.

            IF i-pais-impto-usuario <> 1 THEN DO:
                IF SUBSTRING(tt-ordens-embarque1.char-1,1,20) <> "" /* DIT */ THEN
                    ASSIGN tt-ordens-nac.de-quantidade-nac = tt-ordens-embarque1.quantidade. 
            END.

            CREATE tt-ordens-embarque-aux.
            BUFFER-COPY tt-ordens-nac TO tt-ordens-embarque-aux.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE cria-tt-ordens-nac-selecao:
/*------------------------------------------------------------------------------
  Purpose: Cria tt-ordens-nac-selecao baseado em filtro (SetConstraint)
  Parameters:  INPUT TABLE - tt-ordens-embarque-aux - TT base para criacao
               OUTPUT TABLE - tt-ordens-nac - 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-ordens-embarque-aux.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-ordens-nac.

    EMPTY TEMP-TABLE tt-ordens-embarque-selecao.

    FOR EACH tt-ordens-embarque-aux
       WHERE tt-ordens-embarque-aux.cod-estabel   = c-cod-estabel-imp
         AND tt-ordens-embarque-aux.embarque      = c-embarque-imp
         AND tt-ordens-embarque-aux.numero-ordem >= i-numero-ordem-ini
         AND tt-ordens-embarque-aux.numero-ordem <= i-numero-ordem-fim
         AND tt-ordens-embarque-aux.parcela      >= i-parcela-ini
         AND tt-ordens-embarque-aux.parcela      <= i-parcela-fim
         AND tt-ordens-embarque-aux.c-it-codigo  >= c-item-ini
         AND tt-ordens-embarque-aux.c-it-codigo  <= c-item-fim:
        
        CREATE tt-ordens-embarque-selecao.
        BUFFER-COPY tt-ordens-embarque-aux TO tt-ordens-embarque-selecao.
    END.
     
    EMPTY TEMP-TABLE tt-ordens-nac.
     
    FOR EACH tt-ordens-embarque-selecao:
        CREATE tt-ordens-nac.
        BUFFER-COPY tt-ordens-embarque-selecao TO tt-ordens-nac.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE BuscaEqEmbarqPrazCompra:
/*------------------------------------------------------------------------------
  Purpose: Verfica se embaque possui a tabela eq-embarq-praz-compra
  Parameters:  INPUT - p-numero-ordem (integer) - numero da ordem de compra
               INPUT - p-parcela (integer) - numero da parcela da ordem de compra
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-numero-ordem LIKE ordens-embarque.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER p-parcela      LIKE ordens-embarque.parcela      NO-UNDO.   

    
    IF NOT CAN-FIND(FIRST eq-embarq-praz-compra                  
                    WHERE eq-embarq-praz-compra.numero-ordem = p-numero-ordem
                      AND eq-embarq-praz-compra.parcela      = p-parcela NO-LOCK) THEN
        RETURN "NOK":U.
    

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piAtualizaEmbarqueImp:
/*------------------------------------------------------------------------------
  Purpose: Atualiza informacoes do embarque de acordo com o processo de importacao
  Parameters:  INPUT - p-cod-estabel (character) - codigo do estabelecimento
               INPUT - p-embarque (character) - codigo do embarque
               INPUT - p-cod-itiner (integer) - codigo do itinerario do embarque
               INPUT - p-nr-proc-imp (character) - codigo do processo de importacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel     LIKE embarque-imp.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER p-embarque        LIKE embarque-imp.embarque        NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-itiner      LIKE itinerario.cod-itiner        NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-proc-imp     LIKE processo-imp.nr-proc-imp     NO-UNDO.

    
    FIND FIRST processo-imp
         WHERE processo-imp.cod-estabel = p-cod-estabel
           AND processo-imp.nr-proc-imp = p-nr-proc-imp NO-LOCK NO-ERROR.

    IF AVAIL processo-imp THEN DO:

        FIND FIRST embarque-imp
             WHERE embarque-imp.cod-estabel = p-cod-estabel
               AND embarque-imp.embarque    = p-embarque EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL embarque-imp THEN DO:
            IF embarque-imp.cdn-corretor-cambio-import = 0 THEN ASSIGN embarque-imp.cdn-corretor-cambio-import = processo-imp.cdn-corretor-cambio-import.
            IF embarque-imp.cdn-despa-exter-import     = 0 THEN ASSIGN embarque-imp.cdn-despa-exter-import     = processo-imp.cdn-despa-exter-import.
            IF embarque-imp.cdn-segurad-import         = 0 THEN ASSIGN embarque-imp.cdn-segurad-import         = processo-imp.cdn-segurad-import.
            IF embarque-imp.cdn-corretor-import        = 0 THEN ASSIGN embarque-imp.cdn-corretor-import        = processo-imp.cdn-corretor-import.
            IF embarque-imp.cod-despachante            = 0 THEN ASSIGN embarque-imp.cod-despachante            = processo-imp.cod-despachante.
            IF embarque-imp.cod-transportador          = 0 THEN ASSIGN embarque-imp.cod-transportador          = processo-imp.cod-transportador.

            /* Pontos Obrigat¢rios */
            FOR FIRST itinerario FIELDS(pto-despacho pto-embarque pto-desembarque pto-chegada int-1 cod-itiner char-1)
                WHERE itinerario.cod-itiner = p-cod-itiner NO-LOCK:
                IF embarque-imp.cdn-pto-despch   = 0 THEN ASSIGN embarque-imp.cdn-pto-despch   = itinerario.pto-despacho.
                IF embarque-imp.cdn-pto-embarq   = 0 THEN ASSIGN embarque-imp.cdn-pto-embarq   = itinerario.pto-embarque.
                IF embarque-imp.cdn-pto-desembar = 0 THEN ASSIGN embarque-imp.cdn-pto-desembar = itinerario.pto-desembarque.
                IF embarque-imp.cdn-pto-chegad   = 0 THEN ASSIGN embarque-imp.cdn-pto-chegad   = itinerario.pto-chegada.
                IF TRIM(SUBSTRING(embarque-imp.char-1,81,5)) = "":U THEN ASSIGN  OVERLAY(embarque-imp.char-1,81,5)  = STRING(itinerario.int-1).
                IF TRIM(SUBSTRING(embarque-imp.char-1,86,5)) = "":U THEN ASSIGN  OVERLAY(embarque-imp.char-1,86,5)  = TRIM(SUBSTRING(itinerario.char-1,1,5)).
            END.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE FindProcessoImp:
/*------------------------------------------------------------------------------
  Purpose: Procura ordens-embarque, caso nao ache, retorna mensagem de erro padrao do EMS
  Parameters:  INPUT - c-cod-estabel (character) - codigo do estabelecimento
               INPUT - p-nr-proc-imp (chracter) - codigo do processo de importacao
               OUTPUT - c-return (character) - status do processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-cod-estabel LIKE processo-imp.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER c-nr-proc-imp LIKE processo-imp.nr-proc-imp NO-UNDO.
    DEFINE OUTPUT PARAMETER c-return      AS   CHARACTER                NO-UNDO.

    RUN startMethod("find":U).

    FIND FIRST ordens-embarque
         WHERE ordens-embarque.cod-estabel  = c-cod-estabel
           AND ordens-embarque.nr-proc-imp  = c-nr-proc-imp NO-LOCK NO-ERROR.
    
    IF NOT AVAIL ordens-embarque THEN DO:
        {utp/ut-table.i mgcex ordens-embarque 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
        ASSIGN c-return = RETURN-VALUE.
    END.
    ELSE
        RUN SetCurrent.

    RUN EndMethod("find":U).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE ValidateSiscomex:
/*------------------------------------------------------------------------------
  Purpose: Verifica se embarque possui taxa sisxomex
  Parameters:  INPUT - p-cod-estabel (chracter) - codigo do estabelecimento
               INPUT - p-embarque (character) - codigo do embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-embarque    AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER b-ordens-embarque FOR ordens-embarque.
    
    FIND FIRST param-imp 
         WHERE param-imp.cod-estabel = p-cod-estabel NO-LOCK NO-ERROR.
    
   
    IF  param-imp.log-tax-siscomex
    AND CAN-FIND(FIRST ordens-embarque
                 WHERE ordens-embarque.cod-estabel      = p-cod-estabel
                   AND ordens-embarque.embarque         = p-embarque
                   AND ordens-embarque.val-tax-siscomex = 0)
    AND CAN-FIND(FIRST b-ordens-embarque
                 WHERE b-ordens-embarque.cod-estabel       = p-cod-estabel
                   AND b-ordens-embarque.embarque          = p-embarque
                   AND b-ordens-embarque.val-tax-siscomex <> 0) THEN
        RETURN "NOK":U.
    ELSE
        RETURN "OK":U.

END PROCEDURE.

PROCEDURE ValidateSeqAdicao:
/*------------------------------------------------------------------------------
  Purpose: Verifica consistencia da sequencia da adicao
  Parameters:  INPUT - p-cod-estabel (chracter) - codigo do estabelecimento
               INPUT - p-embarque (character) - codigo do embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-embarque    AS CHARACTER NO-UNDO.
    
    IF  CAN-FIND(FIRST ordens-embarque
                 WHERE ordens-embarque.cod-estabel              = p-cod-estabel
                   AND ordens-embarque.embarque                 = p-embarque
                   AND INT(SUBSTR(ordens-embarque.char-1,80,4)) = 0
                   AND ordens-embarque.num-adic                <> 0) THEN
        RETURN "NOK":U.
    ELSE
        RETURN "OK":U.
    
END PROCEDURE.

PROCEDURE validaNumAdicao:
/*------------------------------------------------------------------------------
  Purpose:  Verifica consistencia do numero da adicao
  Parameters:  INPUT - p-cod-estabel (chracter) - codigo do estabelecimento
               INPUT - p-embarque (character) - codigo do embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-embarque    AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER b-ordens-embarque FOR ordens-embarque.
    
   
    IF  CAN-FIND(FIRST ordens-embarque
                 WHERE ordens-embarque.cod-estabel = p-cod-estabel
                   AND ordens-embarque.embarque    = p-embarque
                   AND ordens-embarque.num-adic    = 0)
    AND CAN-FIND(FIRST b-ordens-embarque
                 WHERE b-ordens-embarque.cod-estabel = p-cod-estabel
                   AND b-ordens-embarque.embarque    = p-embarque
                   AND b-ordens-embarque.num-adic   <> 0) THEN
        RETURN "NOK":U.
    ELSE
        RETURN "OK":U.

END PROCEDURE.

PROCEDURE validaViaTranspPedxEmbarq:
/*------------------------------------------------------------------------------
  Purpose: Verifica se a via de transporte da ordem de compra ‚ a mesma do embarque 
           e se ‚ a primeira que ser  vinculada
  Parameters:  INPUT - p-embarque (character) - codigo do embarque
               INPUT - p-cod-estabel (chracter) - codigo do estabelecimento
               INPUT - p-tipo (integer)  - o que sera validado, pedido ou ordem
               INPUT - p-chave (integer) - 
               OUTPUT - p-via-transp-dif (logical) - 
               OUTPUT - p-primeira (logical) - 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-embarque         LIKE ordens-embarque.embarque     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel      LIKE ordens-embarque.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER p-tipo             AS INTEGER                        NO-UNDO. /* 1 = ordem  / 2 = pedido   */ 
    DEFINE INPUT  PARAMETER p-chave            AS INTEGER                        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-via-transp-dif   AS LOGICAL                        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-primeira         AS LOGICAL                        NO-UNDO.

    DEFINE VAR i-num-pedido LIKE ordem-compra.num-pedido NO-UNDO.

    ASSIGN p-via-transp-dif  = NO
           p-primeira        = NO. 

    FIND FIRST embarque-imp 
         WHERE embarque-imp.cod-estabel  =  p-cod-estabel  
           AND embarque-imp.embarque     =  p-embarque     NO-LOCK NO-ERROR.

    IF p-tipo = 1 THEN DO:
       FIND FIRST ordem-compra 
            WHERE ordem-compra.numero-ordem = p-chave NO-LOCK NO-ERROR. 

       ASSIGN i-num-pedido = ordem-compra.num-pedido.
    END.
    ELSE 
       ASSIGN i-num-pedido = p-chave.

    FIND FIRST pedido-compr 
         WHERE pedido-compr.num-pedido   = i-num-pedido NO-LOCK NO-ERROR.
    
    IF AVAIL pedido-compr THEN
        FIND FIRST processo-imp WHERE processo-imp.num-pedido = pedido-compr.num-pedido NO-LOCK NO-ERROR.

    IF AVAIL processo-imp THEN
        IF embarque-imp.cod-via-transp <> processo-imp.via-transp THEN DO:
        
            ASSIGN p-via-transp-dif = YES
                   i-via-transp     = processo-imp.via-transp.
        
            IF NOT CAN-FIND(FIRST ordens-embarque
                   WHERE ordens-embarque.cod-estabel = p-cod-estabel
                     AND ordens-embarque.embarque    = p-embarque) THEN 
                ASSIGN p-primeira = YES.
        END.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE piAtualizaViaTransp:
/*------------------------------------------------------------------------------
  Purpose: Grava no embarque a via de transporte
  Parameters:  INPUT - p-embarque (character) - codigo do embarque
               INPUT - p-cod-estabel (chracter) - codigo do estabelecimento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-embarque    LIKE embarque-imp.embarque        NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel LIKE embarque-imp.cod-estabel     NO-UNDO.

    FIND FIRST embarque-imp 
         WHERE embarque-imp.cod-estabel  =  p-cod-estabel  
           AND embarque-imp.embarque     =  p-embarque     EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL embarque-imp THEN DO:
        ASSIGN embarque-imp.cod-via-transp = i-via-transp.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE verificaOrdensEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Valida se existe ordens-embarque para determinada ordem e estabelecimento.
  Parameters:  INPUT - p-cod-estabel (chracter) - codigo do estabelecimento
               INPUT - p-embarque (character) - codigo do embarque
               OUTPUT - l-return (logical) - retorno do processamento 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM p-cod-estabel  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM p-numero-ordem AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAM l-return       AS LOGICAL   NO-UNDO.

    FIND FIRST ordens-embarque 
         WHERE ordens-embarque.cod-estabel  = p-cod-estabel
           AND ordens-embarque.numero-ordem = p-numero-ordem NO-LOCK NO-ERROR.

    IF NOT AVAIL ordens-embarque THEN
        ASSIGN l-return = NO.
    ELSE
        ASSIGN l-return = YES.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCalculaDespItiner:
/*------------------------------------------------------------------------------
  Purpose: Calcula as despesas referente ao itinerario do processo de importacao
  Parameters:  INPUT - pCodEstabel (chracter) - codigo do estabelecimento
               INPUT - pCodEmbarque (character) - codigo do embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pCodEstabel    LIKE embarque-imp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAM pCodEmbarque   LIKE embarque-imp.embarque    NO-UNDO.
    
    DEFINE VARIABLE de-peso-tot-bruto-itiner LIKE ordens-embarque.peso-bruto  NO-UNDO.
    DEFINE VARIABLE de-val-cub-tot-itiner    LIKE ordens-embarque.val-cub-tot NO-UNDO.
    DEFINE VARIABLE de-qtde-tot-itiner       LIKE ordens-embarque.quantidade  NO-UNDO.
    DEFINE VARIABLE de-val-desp-itiner       LIKE desp-embarque.val-desp      NO-UNDO.
    DEFINE VARIABLE de-conv-val-desp-itiner  LIKE desp-embarque.val-desp      NO-UNDO.
    DEFINE VARIABLE i-mo-ordem-itiner        LIKE ordem-compra.mo-codigo      NO-UNDO.
    DEFINE VARIABLE de-pre-unit-for          like cotacao-item.pre-unit-for   NO-UNDO.
    DEFINE VARIABLE de-preco-total           like cotacao-item.preco-unit     NO-UNDO.
    DEFINE VARIABLE de-preco-total-ordem     LIKE cotacao-item.preco-unit     NO-UNDO.
    DEFINE VARIABLE i-cod-itiner             LIKE processo-imp.cod-itiner     NO-UNDO.

    ASSIGN de-preco-total-ordem     = 0
           de-peso-tot-bruto-itiner = 0
           de-val-cub-tot-itiner    = 0
           de-qtde-tot-itiner       = 0
           de-pre-unit-for          = 0   
           de-preco-total           = 0   
           de-preco-total-ordem     = 0.   

    FOR EACH ordens-embarque NO-LOCK
        WHERE ordens-embarque.cod-estabel = pCodEstabel
        AND   ordens-embarque.embarque    = pCodEmbarque,
        EACH ordem-compra 
        WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK,
        FIRST cotacao-item
        WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
          AND cotacao-item.it-codigo    = ordem-compra.it-codigo
          AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
          AND cotacao-item.cot-aprovada NO-LOCK:

        ASSIGN i-mo-ordem-itiner = ordem-compra.mo-codigo.

        IF i-cod-itiner = 0 THEN
            FOR FIRST pedido-compr NO-LOCK
                WHERE pedido-compr.num-pedido = ordem-compra.num-pedido,
                FIRST processo-imp NO-LOCK
                WHERE processo-imp.num-pedido  = pedido-compr.num-pedido:
                ASSIGN i-cod-itiner = processo-imp.cod-itiner.
            END.

            ASSIGN de-pre-unit-for          = ((cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi)) /** preco sem ipi **/
                   de-preco-total           = de-pre-unit-for * ordens-embarque.qt-do-forn
                   de-preco-total-ordem     = de-preco-total-ordem + de-preco-total
                   de-peso-tot-bruto-itiner = de-peso-tot-bruto-itiner + ordens-embarque.peso-bruto
                   de-val-cub-tot-itiner    = de-val-cub-tot-itiner +    ordens-embarque.val-cub-tot
                   de-qtde-tot-itiner       = de-qtde-tot-itiner +       ordens-embarque.quantidade.
    END.

    bloco_desp_itiner:
    FOR EACH desp-itiner NO-LOCK
        WHERE desp-itiner.cod-itiner = i-cod-itiner:

        /*se for encontrada despesa no acompanhamento que nÆo foi gerada pela fun‡Æo de gera‡Æo autom tica pelo itiner rio o sistema nÆo deve gerar novamente*/
        IF CAN-FIND(FIRST desp-embarque
                    WHERE desp-embarque.cod-estabel       = pCodEstabel  
                    AND   desp-embarque.embarque          = pCodEmbarque    
                    AND   desp-embarque.cod-itiner        = desp-itiner.cod-itiner   
                    AND   desp-embarque.cod-pto-contr     = desp-itiner.cod-pto-contr
                    AND   desp-embarque.cod-desp          = desp-itiner.cod-desp
                    AND   NOT desp-embarque.log-2
                    AND   NOT l-recalculo) THEN
            NEXT.

        IF l-recalculo THEN DO:
            
            IF CAN-FIND(FIRST embarq-import-docto
                        WHERE embarq-import-docto.cod-estab  = pCodEstabel
                        AND   embarq-import-docto.cod-embarq = pCodEmbarque) THEN DO:

                FOR FIRST embarq-import-docto NO-LOCK
                    WHERE embarq-import-docto.cod-estab  = pCodEstabel
                    AND   embarq-import-docto.cod-embarq = pCodEmbarque,
                    EACH docum-est-cex NO-LOCK
                    WHERE docum-est-cex.cod-emitente = embarq-import-docto.cdn-emitente
                    AND   docum-est-cex.nat-operacao = embarq-import-docto.cod-natur-operac
                    AND   docum-est-cex.serie-docto  = embarq-import-docto.cod-ser-docto
                    AND   docum-est-cex.nro-docto    = embarq-import-docto.cod-docto
                    AND   docum-est-cex.cod-desp     = desp-itiner.cod-desp:
                    NEXT bloco_desp_itiner.
                END.
            END.
        END.
    
        IF CAN-FIND(FIRST desp-embarque
                    WHERE desp-embarque.cod-estabel       = pCodEstabel  
                    AND   desp-embarque.embarque          = pCodEmbarque    
                    AND   desp-embarque.cod-itiner        = desp-itiner.cod-itiner   
                    AND   desp-embarque.cod-pto-contr     = desp-itiner.cod-pto-contr
                    AND   desp-embarque.cod-desp          = desp-itiner.cod-desp) THEN DO:

            /*Se j  existe a despesa deve ser eliminada pois ela ser  recriada com o total das ordens do embarque*/
            FOR FIRST desp-embarque EXCLUSIVE-LOCK
                WHERE desp-embarque.cod-estabel       = pCodEstabel  
                AND   desp-embarque.embarque          = pCodEmbarque    
                AND   desp-embarque.cod-itiner        = desp-itiner.cod-itiner   
                AND   desp-embarque.cod-pto-contr     = desp-itiner.cod-pto-contr
                AND   desp-embarque.cod-desp          = desp-itiner.cod-desp: 
                DELETE desp-embarque.
            END.
        END.
        
        FOR FIRST dist-emitente NO-LOCK
            WHERE dist-emitente.cod-emitente = desp-itiner.cod-emitente: END.

        
        CREATE desp-embarque.
        ASSIGN desp-embarque.cod-estabel       = pCodEstabel  
               desp-embarque.embarque          = pCodEmbarque 
               desp-embarque.cod-itiner        = desp-itiner.cod-itiner
               desp-embarque.cod-pto-contr     = desp-itiner.cod-pto-contr
               desp-embarque.cod-desp          = desp-itiner.cod-desp
               desp-embarque.cod-emitente-desp = desp-itiner.cod-emitente
               desp-embarque.cod-cond-pag      = pedido-compr.cod-cond-pag
               desp-embarque.mo-codigo         = IF AVAIL dist-emitente THEN dist-emitente.mo-fatur ELSE 0
               desp-embarque.val-desp          = 0
               desp-embarque.log-2             = TRUE.
    
        IF CAN-FIND(FIRST funcao
                    WHERE funcao.cd-funcao = "spp-calcula-despes-itiner":U
                    AND   funcao.ativo) THEN DO:

            FOR FIRST desp-imp NO-LOCK
                WHERE desp-imp.cod-desp = desp-embarque.cod-desp:

                CASE desp-imp.tipo:
                    WHEN 1 OR
                    WHEN 2 THEN /* valor fixo e valor informado*/
                        ASSIGN desp-embarque.val-desp = 0.

                    WHEN 3 THEN DO: /*taxa sobre peso*/
                        ASSIGN desp-embarque.val-desp = (de-peso-tot-bruto-itiner * desp-itiner.dec-2) / 100.
                    END.

                    WHEN 4 THEN DO: /*Taxa sobre quantidade*/
                        ASSIGN desp-embarque.val-desp = (de-qtde-tot-itiner * desp-itiner.dec-2) / 100.
                    END.

                    WHEN 5 THEN DO: /*Valor Calculado*/
                        ASSIGN de-val-desp-itiner = (de-preco-total-ordem * desp-itiner.dec-2) / 100.

                        IF i-mo-ordem-itiner <> desp-embarque.mo-codigo THEN DO:

                            RUN cdp/cd0812.p (INPUT  i-mo-ordem-itiner,
                                              INPUT  desp-embarque.mo-codigo,
                                              INPUT  de-val-desp-itiner,
                                              INPUT  TODAY,
                                              OUTPUT de-conv-val-desp-itiner).

                            IF de-conv-val-desp-itiner = 0 OR de-conv-val-desp-itiner = ? THEN 
                                ASSIGN de-conv-val-desp-itiner = de-val-desp-itiner.
                        END.
                        ELSE 
                            ASSIGN de-conv-val-desp-itiner = de-val-desp-itiner.

                        ASSIGN desp-embarque.val-desp = de-conv-val-desp-itiner.
                    END.

                    WHEN 6 THEN DO: /*Taxa sobre cubagem*/
                        ASSIGN desp-embarque.val-desp = (de-val-cub-tot-itiner * desp-itiner.dec-2) / 100.
                    END.

                    OTHERWISE
                        ASSIGN desp-embarque.val-desp = 0. 
                END CASE.                                    
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-seta-recalculo:
/*------------------------------------------------------------------------------
  Purpose: Informa para BO se deve ou nao realizar o recalculo das despesas do itinerario
  Parameters:  INPUT - pRecalculo (logical)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pRecalculo AS LOGICAL NO-UNDO.

    ASSIGN l-recalculo = pRecalculo.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-saldos-embarq:
/*------------------------------------------------------------------------------
  Purpose: Verifica quanto de saldo o embarque possui
  Parameters:  INPUT - pcod-estabel (chracter) - codigo do estabelecimento
               INPUT - pembarque (character) - codigo do embarque
               OUTPUT TABLE - tt-saldo-embarque - TT com as informacoes de saldo do embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE ordens-embarque.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pembarque    LIKE ordens-embarque.embarque    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-saldo-embarque.

    EMPTY TEMP-TABLE tt-saldo-embarque.

    FOR EACH ordens-embarque NO-LOCK
       WHERE ordens-embarque.cod-estabel = pcod-estabel
         AND ordens-embarque.embarque = pembarque,
       FIRST prazo-compra NO-LOCK
       WHERE prazo-compra.numero-ordem = ordens-embarque.numero-ordem
         AND prazo-compra.parcela = ordens-embarque.parcela:

        CREATE tt-saldo-embarque.
        BUFFER-COPY ordens-embarque TO tt-saldo-embarque.
        BUFFER-COPY prazo-compra TO tt-saldo-embarque.

        ASSIGN tt-saldo-embarque.quantidade = ordens-embarque.quantidade
               tt-saldo-embarque.quant-alocada = prazo-compra.dec-1
               tt-saldo-embarque.quant-saldo = 0
               tt-saldo-embarque.r-rowid = ROWID(ordens-embarque).

        FOR EACH b-prazo-compra FIELDS(numero-ordem situacao quant-saldo) NO-LOCK
           WHERE b-prazo-compra.numero-ordem = ordens-embarque.numero-ordem
             AND b-prazo-compra.parcela = ordens-embarque.parcela
             AND b-prazo-compra.situacao <> 4:

            ASSIGN tt-saldo-embarque.quant-saldo = tt-saldo-embarque.quant-saldo + b-prazo-compra.quant-saldo.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-busca-uf:
/*------------------------------------------------------------------------------
  Purpose: Retorna a unidade de federacao do ponto de controle passado como parametro
  Parameters:  INPUT - pcod-pto-contr (integer) - codigo do ponto de controle
               OUTPUT - pcod-uf (character) - unidade de federacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcod-pto-contr LIKE pto-contr.cod-pto-contr NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-uf        AS CHARACTER                 NO-UNDO.

    DEFINE VARIABLE cReturn AS CHARACTER NO-UNDO.

    RUN findCodigo IN h-bocx110(INPUT pcod-pto-contr, OUTPUT cReturn).

    IF cReturn = "":U THEN DO:
        RUN getCharField IN h-bocx110 (INPUT "cod-uf":U, OUTPUT pcod-uf).
    END.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-delete-dbos:
/*------------------------------------------------------------------------------
  Purpose: Remover o handle da mem¢ria
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  VALID-HANDLE (h-bocx110) THEN DO:
        DELETE PROCEDURE h-bocx110.
        ASSIGN h-bocx110 = ?.
    END.

    IF VALID-HANDLE (h-bocx230a) THEN DO:
        DELETE PROCEDURE h-bocx230a.
        ASSIGN h-bocx230a = ?.
    END.
    
    IF VALID-HANDLE(h-boin356) THEN DO:
        DELETE PROCEDURE h-boin356.
        ASSIGN h-boin356 = ?.
    END.
    
    IF VALID-HANDLE(h-bodi425) THEN DO:
        DELETE PROCEDURE h-bodi425.
        ASSIGN h-bodi425 = ?.
    END.
    
    IF  VALID-HANDLE (h-bocx00488) THEN DO:
        DELETE PROCEDURE h-bocx00488.
        ASSIGN h-bocx00488 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE criaTTBoErro:
/*------------------------------------------------------------------------------
  Purpose: Criacao da temp-table de erros retornada na execucao das procedures
  Parameters: INPUT - pi-cod-error (integer) - codigo do erro
              INPUT - pc-parameters (character) - parametros da mensagem de erro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-cod-error  AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER pc-parameters AS CHARACTER  NO-UNDO.

    ASSIGN i-seq-erro = i-seq-erro + 1.
    
    RUN utp/ut-msgs.p (INPUT "msg":U, INPUT pi-cod-error, INPUT pc-parameters).

    CREATE tt-bo-erro.
    ASSIGN tt-bo-erro.i-sequen   = i-seq-erro
           tt-bo-erro.cd-erro    = pi-cod-error
           tt-bo-erro.mensagem   = RETURN-VALUE
           tt-bo-erro.parametros = pc-parameters
           tt-bo-erro.errortype  = "EMS":U.

    RUN utp/ut-msgs.p (INPUT "help":U, INPUT pi-cod-error, INPUT pc-parameters).

    ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "CodType":U, INPUT pi-cod-error, INPUT pc-parameters).
    
    CASE RETURN-VALUE:
        WHEN '1':U THEN
            ASSIGN tt-bo-erro.errorsubtype = "ERROR":U.
        WHEN '2':U THEN
            ASSIGN tt-bo-erro.errorsubtype = "WARNING":U.
        WHEN '3':U THEN
            ASSIGN tt-bo-erro.errorsubtype = "QUESTION":U.
        WHEN '4':U THEN
            ASSIGN tt-bo-erro.errorsubtype = "INFORMATION":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.



/* BOCX225.P */


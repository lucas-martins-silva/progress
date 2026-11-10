&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX220H 2.00.00.029 } /*** "010029" 08/12/2025 14:50:48 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx220h MUT}
&ENDIF


/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX220
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName tt-selecao-embarque
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
{cxbo/bocx220h.i RowObject}

{cxbo/bocx220h.i tt-selecao-embarque}
{cxbo/bocx220h.i tt-selecao-embarque-aux}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
{method/dboqry.i}

{cdp/cdcfgmat.i}
{cdp/cdcfgcex.i}
{utp/ut-glob.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE BUFFER bfEmbarque-imp FOR embarque-imp.
DEFINE BUFFER bfdocum-est    FOR docum-est.

DEFINE VARIABLE i-tipo-geracao              AS INTEGER            NO-UNDO.
DEFINE VARIABLE l-mostra-embarq-sem-despesa AS LOGICAL INITIAL NO NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no


/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 3.08
         WIDTH              = 41.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTtSelecaoEmbarque DBOProgram 
PROCEDURE carregaTtSelecaoEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabel            LIKE RowObject.cod-estabel         NO-UNDO. 
    DEFINE INPUT  PARAMETER pi-tipo-geracao           AS INTEGER                         NO-UNDO.
    DEFINE INPUT  PARAMETER pc-embarque-ini           LIKE embarque-imp.embarque         NO-UNDO. 
    DEFINE INPUT  PARAMETER pc-embarque-fim           LIKE embarque-imp.embarque         NO-UNDO.
    DEFINE INPUT  PARAMETER pi-num-di-ems-ini         AS INTEGER   FORMAT ">>>>>>>>9":U  NO-UNDO. 
    DEFINE INPUT  PARAMETER pi-num-di-ems-fim         AS INTEGER   FORMAT ">>>>>>>>9":U  NO-UNDO. 
    DEFINE INPUT  PARAMETER pl-desembarque-parcial    AS LOGICAL                         NO-UNDO. 
    DEFINE INPUT  PARAMETER pdt-nacionalizacao-ini    AS DATE      FORMAT "99/99/9999":U NO-UNDO. 
    DEFINE INPUT  PARAMETER pdt-nacionalizacao-fim    AS DATE      FORMAT "99/99/9999":U NO-UNDO. 
    DEFINE INPUT  PARAMETER pc-container-ini          AS CHAR      FORMAT "x(20)":U      NO-UNDO. 
    DEFINE INPUT  PARAMETER pc-container-fim          AS CHAR      FORMAT "x(20)":U      NO-UNDO. 
    DEFINE INPUT  PARAMETER pc-processo-ini           AS CHAR      FORMAT "x(12)":U      NO-UNDO. 
    DEFINE INPUT  PARAMETER pc-processo-fim           AS CHAR      FORMAT "x(12)":U      NO-UNDO. 
    DEFINE INPUT  PARAMETER pc-declaracao-imp-ini     AS CHAR      FORMAT "x(20)":U      NO-UNDO. 
    DEFINE INPUT  PARAMETER pc-declaracao-imp-fim     AS CHAR      FORMAT "x(20)":U      NO-UNDO. 
    DEFINE INPUT  PARAMETER pdt-di-ini                AS DATE      FORMAT "99/99/9999":U NO-UNDO. 
    DEFINE INPUT  PARAMETER pdt-di-fim                AS DATE      FORMAT "99/99/9999":U NO-UNDO. 
    DEFINE INPUT  PARAMETER pi-itinerario-ini         AS INTEGER   FORMAT ">>,>>9":U     NO-UNDO. 
    DEFINE INPUT  PARAMETER pi-itinerario-fim         AS INTEGER   FORMAT ">>,>>9":U     NO-UNDO. 
    DEFINE INPUT  PARAMETER pi-exportador-ini         AS INTEGER   FORMAT ">>>>>>>>9":U  NO-UNDO. 
    DEFINE INPUT  PARAMETER pi-exportador-fim         AS INTEGER   FORMAT ">>>>>>>>9":U  NO-UNDO. 
    DEFINE INPUT  PARAMETER pi-localizacao            AS INTEGER   FORMAT ">>,>>9":U     NO-UNDO. 
    DEFINE INPUT  PARAMETER pdt-chegada-ini           AS DATE      FORMAT "99/99/9999":U NO-UNDO. 
    DEFINE INPUT  PARAMETER pdt-chegada-fim           AS DATE      FORMAT "99/99/9999":U NO-UNDO. 
    DEFINE INPUT  PARAMETER pc-veiculo-transp-ini     AS CHARACTER FORMAT "x(20)":U      NO-UNDO. 
    DEFINE INPUT  PARAMETER pc-veiculo-transp-fim     AS CHARACTER FORMAT "x(20)":U      NO-UNDO. 
    DEFINE INPUT  PARAMETER pc-nr-conhecto-master-ini AS CHARACTER FORMAT "x(18)":U      NO-UNDO. 
    DEFINE INPUT  PARAMETER pc-nr-conhecto-master-fim AS CHARACTER FORMAT "x(18)":U      NO-UNDO. 
    DEFINE INPUT  PARAMETER pc-nr-conhecto-house-ini  AS CHARACTER FORMAT "x(18)":U      NO-UNDO. 
    DEFINE INPUT  PARAMETER pc-nr-conhecto-house-fim  AS CHARACTER FORMAT "x(18)":U      NO-UNDO. 
    DEFINE OUTPUT PARAMETER TABLE FOR tt-selecao-embarque.

    DEFINE VARIABLE i-sequencia  AS INTEGER  NO-UNDO.
    DEFINE VARIABLE i-cod-itiner AS INTEGER  NO-UNDO.
    DEFINE VARIABLE dt-efetiva   AS DATE     NO-UNDO.
    DEFINE VARIABLE l-erro       AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE i-aux        AS INTEGER  NO-UNDO.
    {cdp/cd4300.i3}
    {rep/re1001a.i50}

    EMPTY TEMP-TABLE tt-selecao-embarque-aux.
    EMPTY TEMP-TABLE tt-selecao-embarque.

    IF pi-tipo-geracao = 1 THEN DO: /* Embarque */
        ASSIGN pi-num-di-ems-ini = 0
               pi-num-di-ems-fim = 999999999
               pc-declaracao-imp-ini = "":U
               pc-declaracao-imp-fim = "ZZZZZZZZZZZZZZZZZZZZ":U.

    END.
    ELSE IF pi-tipo-geracao = 2          /* Declaraá∆o de Importaá∆o */
         OR pi-tipo-geracao = 3 THEN DO: /* DUIMP */
        
        IF pc-declaracao-imp-ini <> "":U THEN DO:
            
            /*Valida o valor do campo da DI Siscomex e DI EMS*/
            FIND FIRST decla-import 
                 WHERE decla-import.cod-di-siscomex = pc-declaracao-imp-ini NO-LOCK NO-ERROR.

            IF NOT AVAIL decla-import THEN DO:
                ASSIGN i-aux = INT(pc-declaracao-imp-ini) NO-ERROR.
                IF NOT ERROR-STATUS:ERROR THEN
                    FIND FIRST decla-import 
                         WHERE decla-import.num-di-ems = INT(pc-declaracao-imp-ini) NO-LOCK NO-ERROR.
            END.

            IF AVAIL decla-import THEN  DO: 
                ASSIGN pi-num-di-ems-ini     = decla-import.num-di-ems
                       pi-num-di-ems-fim     = decla-import.num-di-ems
                       pc-declaracao-imp-ini = decla-import.cod-di-siscomex
                       pc-declaracao-imp-fim = decla-import.cod-di-siscomex .

                FOR FIRST decla-import-embarq
                    WHERE decla-import-embarq.num-di-ems = decla-import.num-di-ems NO-LOCK:
                   ASSIGN pc-embarque-ini = decla-import-embarq.cod-embarq.
                END.
                FOR LAST decla-import-embarq
                     WHERE decla-import-embarq.num-di-ems = decla-import.num-di-ems NO-LOCK:
                    ASSIGN pc-embarque-fim = decla-import-embarq.cod-embarq.
                END.
             END. 
        END.
        ELSE
            ASSIGN pc-embarque-ini = "":U
                   pc-embarque-fim = "ZZZZZZZZZZZZ":U.
    END.

     FOR EACH embarque-imp NO-LOCK
        WHERE embarque-imp.situacao           = 1 /* Nao Encerrado */
          AND embarque-imp.cod-estabel        = pc-cod-estabel
          AND embarque-imp.embarque          >= pc-embarque-ini
          AND embarque-imp.embarque          <= pc-embarque-fim
          AND embarque-imp.declaracao-import >= pc-declaracao-imp-ini
          AND embarque-imp.declaracao-import <= pc-declaracao-imp-fim
        &IF "{&bf_mat_versao_ems}":U < "2.09":U &THEN
             AND embarque-imp.int-2 >= pi-num-di-ems-ini
             AND embarque-imp.int-2 <= pi-num-di-ems-fim
        &ELSE
             AND embarque-imp.num-di-ems >= pi-num-di-ems-ini
             AND embarque-imp.num-di-ems <= pi-num-di-ems-fim
        &ENDIF
        AND embarque-imp.cod-conhecto-master >= pc-nr-conhecto-master-ini
        AND embarque-imp.cod-conhecto-master <= pc-nr-conhecto-master-fim
        AND embarque-imp.cod-conhecto-house  >= pc-nr-conhecto-house-ini
        AND embarque-imp.cod-conhecto-house  <= pc-nr-conhecto-house-fim:
       
        /* num-di-ems */
        IF (pi-tipo-geracao = 2 OR pi-tipo-geracao = 3) AND embarque-imp.int-2 =  0 THEN NEXT.
        IF pi-tipo-geracao = 1 AND embarque-imp.int-2 <> 0 THEN NEXT.
        
        IF pi-tipo-geracao = 2
        OR pi-tipo-geracao = 3 THEN DO:
            FOR FIRST decla-import-embarq
                WHERE decla-import-embarq.cod-estab  = embarque-imp.cod-estabel
                  AND decla-import-embarq.cod-embarq = embarque-imp.embarque NO-LOCK: END.
            IF AVAIL decla-import-embarq 
            AND (   (pi-tipo-geracao = 3 
                     AND NOT CAN-FIND (FIRST decla-import 
                                       WHERE decla-import.num-di-ems       = decla-import-embarq.num-di-ems
                                         AND decla-import.num-seq-retif    = 99
                                         AND decla-import.cdd-siscomex-dts = decla-import-embarq.cdd-siscomex-dts))
                 OR (pi-tipo-geracao = 2 
                     AND NOT CAN-FIND (FIRST decla-import 
                                       WHERE decla-import.num-di-ems       = decla-import-embarq.num-di-ems
                                         AND decla-import.num-seq-retif    <> 99
                                         AND decla-import.cdd-siscomex-dts = decla-import-embarq.cdd-siscomex-dts))) THEN
                NEXT.
        END.
        
        IF  embarque-imp.data-di < pdt-di-ini
        OR  embarque-imp.data-di > pdt-di-fim THEN
            NEXT.
        
        ASSIGN l-erro = NO.

        FOR FIRST ordens-embarque FIELDS (numero-ordem nr-proc-imp identific-container)
            WHERE ordens-embarque.cod-estabel          = embarque-imp.cod-estabel
            AND   ordens-embarque.embarque             = embarque-imp.embarque
            AND   ordens-embarque.identific-container >= pc-container-ini
            AND   ordens-embarque.identific-container <= pc-container-fim
            AND   ordens-embarque.nr-proc-imp         >= pc-processo-ini
            and   ordens-embarque.nr-proc-imp         <= pc-processo-fim NO-LOCK: END.
        IF NOT AVAIL ordens-embarque THEN
            NEXT.

        FOR FIRST ordem-compra FIELDS (cod-emitente)
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:
        END.
        IF NOT AVAIL ordem-compra THEN
            NEXT.

        FOR EACH embarq-import-docto FIELDS (cod-estab cod-embarq cod-ser-docto cod-docto cdn-emitente cod-natur-operac)
           WHERE embarq-import-docto.cod-estab   = embarque-imp.cod-estabel
             AND embarq-import-docto.cod-embarq  = embarque-imp.embarque NO-LOCK,
           FIRST docum-est FIELDS(serie-docto nro-docto cod-emitente nat-operacao ce-atual char-1 idi-nf-simples-remes )
           WHERE docum-est.serie-docto  = embarq-import-docto.cod-ser-docto   
             AND docum-est.nro-docto    = embarq-import-docto.cod-docto       
             AND docum-est.cod-emitente = embarq-import-docto.cdn-emitente    
             AND docum-est.nat-operacao = embarq-import-docto.cod-natur-operac NO-LOCK:

           /* Desconsidera notas fiscais de simples remessa mae, porÇm deve considerar a nota m∆e onde
              a primeira remessa esteja sendo gerada com a nota m∆e "docum-est.char-1,209,1" = "S"*/
           IF  docum-est.idi-nf-simples-remes = 1
           AND TRIM(SUBSTRING(docum-est.char-1,209,1)) = "N":U THEN NEXT.
           
           IF docum-est.ce-atual THEN DO: 
               ASSIGN l-erro = NO.
               LEAVE.
           END.
           ELSE
               ASSIGN l-erro = YES.
        END.
        
        IF l-erro THEN
            NEXT.

        FOR FIRST processo-imp FIELDS (cod-exportador)
            WHERE processo-imp.cod-estabel     = embarque-imp.cod-estabel
              AND processo-imp.nr-proc-imp     = ordens-embarque.nr-proc-imp
              AND processo-imp.cod-exportador >= pi-exportador-ini
              AND processo-imp.cod-exportador <= pi-exportador-fim NO-LOCK: END.
        IF  NOT AVAIL processo-imp THEN
            NEXT.

        FOR FIRST historico-embarque FIELDS (cod-itiner id-meio-transp)
            WHERE historico-embarque.cod-estabel     = embarque-imp.cod-estabel
              AND historico-embarque.embarque        = embarque-imp.embarque
              AND historico-embarque.id-meio-transp >= pc-veiculo-transp-ini
              AND historico-embarque.id-meio-transp <= pc-veiculo-transp-fim
              AND historico-embarque.cod-itiner     >= pi-itinerario-ini
              AND historico-embarque.cod-itiner     <= pi-itinerario-fim NO-LOCK: END.
        IF NOT AVAIL historico-embarque THEN
            NEXT.

        ASSIGN i-cod-itiner = historico-embarque.cod-itiner.

        FOR FIRST itinerario FIELDS (cod-itiner pto-desembarque pto-chegada)
            WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK: END.
        IF NOT AVAIL itinerario THEN
            NEXT.

        FOR FIRST historico-embarque FIELDS (dt-efetiva sequencia)
            WHERE historico-embarque.cod-itiner    = itinerario.cod-itiner
              AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar
              AND historico-embarque.cod-estabel   = embarque-imp.cod-estabel
              AND historico-embarque.embarque      = embarque-imp.embarque 
              AND historico-embarque.dt-efetiva   >= pdt-nacionalizacao-ini
              AND historico-embarque.dt-efetiva   <= pdt-nacionalizacao-fim NO-LOCK: END.
        IF NOT AVAIL historico-embarque THEN
            NEXT.

        ASSIGN dt-efetiva  = historico-embarque.dt-efetiva
               i-sequencia = historico-embarque.sequencia
               l-erro      = YES.

        FOR EACH historico-embarque FIELDS (dt-efetiva cod-itiner cod-pto-contr)
           WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
             AND historico-embarque.embarque    = embarque-imp.embarque 
             AND historico-embarque.dt-efetiva <> ?
             AND historico-embarque.sequencia   > i-sequencia NO-LOCK USE-INDEX codigo:
            
            FOR EACH desp-embarque FIELDS (cod-desp)
               WHERE desp-embarque.cod-estabel   = embarque-imp.cod-estabel
                 AND desp-embarque.embarque      = embarque-imp.embarque
                 AND desp-embarque.cod-itiner    = historico-embarque.cod-itiner 
                 AND desp-embarque.cod-pto-contr = historico-embarque.cod-pto-contr 
                 AND NOT desp-embarque.log-despes-ja-recbda NO-LOCK USE-INDEX codigo:
            
                FOR FIRST desp-imp FIELDS (inc-val-frete inc-val-seguro inc-val-embal inc-val-outras-desp)
                    WHERE desp-imp.cod-desp = desp-embarque.cod-desp NO-LOCK: END.
                IF  AVAIL desp-imp
                AND (  desp-imp.inc-val-frete
                    OR desp-imp.inc-val-seguro
                    OR desp-imp.inc-val-embal
                    OR desp-imp.inc-val-outras-desp) THEN 
                    ASSIGN l-erro = NO.
            END.

            IF l-mostra-embarq-sem-despesa THEN ASSIGN l-erro = NO.
        END.
        
        IF l-erro THEN DO:
            IF pl-desembarque-parcial THEN DO:
                RUN carregaTtSelecaoEmbarqueParcial (INPUT embarque-imp.cod-estabel,
                                                     INPUT embarque-imp.embarque).
            END.
            NEXT.
        END.
        
        IF  pi-localizacao <> 0 THEN
            FOR FIRST historico-embarque FIELDS (dt-efetiva dt-ult-previsao)
                WHERE historico-embarque.cod-pto-contr = pi-localizacao
                  AND historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                  AND historico-embarque.embarque      = embarque-imp.embarque NO-LOCK: END.
        ELSE
            FOR FIRST historico-embarque FIELDS (cod-itiner dt-efetiva dt-ult-previsao)
                WHERE historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad
                  AND historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
                  AND historico-embarque.embarque      = embarque-imp.embarque NO-LOCK: END.

        IF NOT AVAIL historico-embarque THEN
            NEXT.
        
        IF historico-embarque.dt-efetiva <> ? THEN DO:
            IF historico-embarque.dt-efetiva < pdt-chegada-ini
            OR historico-embarque.dt-efetiva > pdt-chegada-fim THEN
                NEXT.
        END.
        ELSE
            IF historico-embarque.dt-ult-previsao < pdt-chegada-ini
            OR historico-embarque.dt-ult-previsao > pdt-chegada-fim THEN 
                NEXT.
        
        IF NOT CAN-FIND (FIRST tt-selecao-embarque 
                         WHERE tt-selecao-embarque.cod-estabel = embarque-imp.cod-estabel
                           AND tt-selecao-embarque.embarque    = embarque-imp.embarque) THEN DO:

            CREATE tt-selecao-embarque.
            ASSIGN tt-selecao-embarque.marca               = "":U
                   tt-selecao-embarque.cod-estabel         = embarque-imp.cod-estabel
                   tt-selecao-embarque.embarque            = embarque-imp.embarque
                   tt-selecao-embarque.declaracao-import   = embarque-imp.declaracao-import
                   tt-selecao-embarque.dt-nacionalizacao   = dt-efetiva
                   tt-selecao-embarque.cod-exportador      = processo-imp.cod-exportador
                   tt-selecao-embarque.cod-itiner          = i-cod-itiner
                   tt-selecao-embarque.cod-conhecto-master = embarque-imp.cod-conhecto-master
                   tt-selecao-embarque.cod-conhecto-house  = embarque-imp.cod-conhecto-house
                   tt-selecao-embarque.cod-incoterm        = embarque-imp.cod-incoterm
                   tt-selecao-embarque.r-rowid             = ROWID(embarque-imp) 
                   tt-selecao-embarque.embarque-original   = SUBSTR(embarque-imp.char-1,21,40).

            FIND FIRST decla-import-embarq
                 WHERE decla-import-embarq.cod-estab  = embarque-imp.cod-estabel
                   AND decla-import-embarq.cod-embarq = embarque-imp.embarque NO-LOCK NO-ERROR.

            IF AVAIL decla-import-embarq THEN
                ASSIGN tt-selecao-embarque.num-di-ems = decla-import-embarq.num-di-ems.

            IF pl-desembarque-parcial THEN DO:
                RUN carregaTtSelecaoEmbarqueParcial (INPUT embarque-imp.cod-estabel,
                                                     INPUT embarque-imp.embarque).
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTtSelecaoEmbarqueParcial DBOProgram 
PROCEDURE carregaTtSelecaoEmbarqueParcial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodEstabel  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pEmbarquePai AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE dt-efetiva       AS DATE     NO-UNDO.
    DEFINE VARIABLE i-cod-itiner     AS INTEGER  NO-UNDO.
    DEFINE VARIABLE i-sequencia      AS INTEGER  NO-UNDO.
    DEFINE VARIABLE l-erro           AS LOGICAL  NO-UNDO.
    {cdp/cd4300.i3}
    {rep/re1001a.i50}
    
    FOR EACH bfEmbarque-imp 
       WHERE bfEmbarque-imp.cod-estabel                = pCodEstabel
         AND TRIM(SUBSTR(bfEmbarque-imp.char-1,21,40)) = pEmbarquePai NO-LOCK USE-INDEX codigo:

        ASSIGN l-erro = NO.

        IF bfEmbarque-imp.situacao = 2 THEN /** Embarque Encerrado **/
            NEXT.
  
        FOR FIRST ordens-embarque FIELDS (nr-proc-imp numero-ordem)
            WHERE ordens-embarque.cod-estabel = bfEmbarque-imp.cod-estabel
              AND ordens-embarque.embarque    = bfEmbarque-imp.embarque NO-LOCK: END.
        IF NOT AVAIL ordens-embarque THEN
            NEXT.

        FOR FIRST ordem-compra FIELDS (cod-emitente)
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK: END.
        IF NOT AVAIL ordem-compra THEN
            NEXT.
        
        FOR EACH embarq-import-docto FIELDS (cod-estab cod-embarq cod-ser-docto cod-docto cdn-emitente cod-natur-operac)
           WHERE embarq-import-docto.cod-estab   = bfEmbarque-imp.cod-estabel
             AND embarq-import-docto.cod-embarq  = bfEmbarque-imp.embarque NO-LOCK,
           FIRST docum-est FIELDS(serie-docto nro-docto cod-emitente nat-operacao ce-atual char-1)
           WHERE docum-est.serie-docto  = embarq-import-docto.cod-ser-docto   
             AND docum-est.nro-docto    = embarq-import-docto.cod-docto       
             AND docum-est.cod-emitente = embarq-import-docto.cdn-emitente    
             AND docum-est.nat-operacao = embarq-import-docto.cod-natur-operac NO-LOCK:

            IF  docum-est.ce-atual 
            AND CAN-FIND( FIRST item-doc-est                                         /* tratamento para funá∆o de simples remessa           */
                          WHERE item-doc-est.serie-docto  = docum-est.serie-docto    /* considera apenas o documento que est† parametrizado */
                            AND item-doc-est.nro-docto    = docum-est.nro-docto      /* para baixar estoque                                 */
                            AND item-doc-est.cod-emitente = docum-est.cod-emitente
                            AND item-doc-est.nat-operacao = docum-est.nat-operacao 
                            AND item-doc-est.baixa-ce) THEN DO:
                ASSIGN l-erro = NO.
                LEAVE.
            END.
            ELSE
                ASSIGN l-erro = YES.
        END.

        IF l-erro THEN
            NEXT.
         
        FOR FIRST historico-embarque FIELDS(cod-itiner)
            WHERE historico-embarque.cod-estabel     = bfEmbarque-imp.cod-estabel
              AND historico-embarque.embarque        = bfEmbarque-imp.embarque NO-LOCK: END.
        IF NOT AVAIL historico-embarque THEN
            NEXT.
        
        ASSIGN i-cod-itiner = historico-embarque.cod-itiner.

        FOR FIRST itinerario FIELDS (cod-itiner pto-desembarque)
            WHERE  itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK: END.

        FOR FIRST historico-embarque FIELDS (dt-efetiva sequencia)
            WHERE historico-embarque.cod-estabel   = bfEmbarque-imp.cod-estabel
              AND historico-embarque.embarque      = bfEmbarque-imp.embarque
              AND historico-embarque.cod-itiner    = itinerario.cod-itiner
              AND historico-embarque.cod-pto-contr = bfEmbarque-imp.cdn-pto-desembar NO-LOCK: END.
        
        ASSIGN dt-efetiva   = historico-embarque.dt-efetiva
               i-sequencia  = historico-embarque.sequencia
               l-erro       = YES.
      
        /* Para Embarques filhos nao Ç feita a verificaá∆o de despesas, pois caso informe apenas em um 
           embarque depois Ç poss°vel fazer o rateio atravÇs do IM3101D (bot∆o do IM0101C) */
                
        FOR FIRST processo-imp FIELDS (cod-exportador)
            WHERE processo-imp.cod-estabel = bfEmbarque-imp.cod-estabel
              AND processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp NO-LOCK: END.
       
        IF NOT CAN-FIND(FIRST tt-selecao-embarque 
                        WHERE tt-selecao-embarque.embarque    = bfEmbarque-imp.embarque
                          AND tt-selecao-embarque.cod-estabel = bfEmbarque-imp.cod-estabel) THEN DO:

            CREATE tt-selecao-embarque.
            ASSIGN tt-selecao-embarque.marca               = ""
                   tt-selecao-embarque.cod-estabel         = bfEmbarque-imp.cod-estabel
                   tt-selecao-embarque.embarque            = bfEmbarque-imp.embarque
                   tt-selecao-embarque.declaracao-import   = bfEmbarque-imp.declaracao-import
                   tt-selecao-embarque.dt-nacionalizacao   = dt-efetiva
                   tt-selecao-embarque.cod-exportador      = processo-imp.cod-exportador
                   tt-selecao-embarque.cod-itiner          = i-cod-itiner
                   tt-selecao-embarque.cod-conhecto-master = bfembarque-imp.cod-conhecto-master
                   tt-selecao-embarque.cod-conhecto-house  = bfembarque-imp.cod-conhecto-house
                   tt-selecao-embarque.cod-incoterm        = bfEmbarque-imp.cod-incoterm
                   tt-selecao-embarque.r-rowid             = ROWID(bfEmbarque-imp) 
                   tt-selecao-embarque.embarque-original   = TRIM(SUBSTR(bfEmbarque-imp.char-1,21,40)).
        END.
        
        FIND FIRST decla-import-embarq
             WHERE decla-import-embarq.cod-estab  = embarque-imp.cod-estabel
             AND   decla-import-embarq.cod-embarq = embarque-imp.embarque NO-LOCK NO-ERROR.

        IF AVAIL decla-import-embarq THEN
            ASSIGN tt-selecao-embarque.num-di-ems = decla-import-embarq.num-di-ems.

        RUN carregaTtSelecaoEmbarqueParcial (INPUT bfEmbarque-imp.cod-estabel,
                                             INPUT bfEmbarque-imp.embarque).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "marca":U                 THEN ASSIGN pFieldValue = RowObject.marca.
        WHEN "embarque":U              THEN ASSIGN pFieldValue = RowObject.embarque.
        WHEN "cod-estabel":U           THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "declaracao-import":U     THEN ASSIGN pFieldValue = RowObject.declaracao-import.
        WHEN "cod-conhecto-master":U   THEN ASSIGN pFieldValue = RowObject.cod-conhecto-master.
        WHEN "cod-conhecto-house":U    THEN ASSIGN pFieldValue = RowObject.cod-conhecto-house.
        WHEN "embarque-original":U     THEN ASSIGN pFieldValue = RowObject.embarque-original.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE      NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-nacionalizacao":U THEN ASSIGN pFieldValue = RowObject.dt-nacionalizacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL   NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER   NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-exportador":U THEN ASSIGN pFieldValue = RowObject.cod-exportador.
        WHEN "cod-itiner":U THEN ASSIGN pFieldValue = RowObject.cod-itiner.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE RowObject.cod-estabel  NO-UNDO.
    DEFINE OUTPUT PARAMETER pembarque    LIKE RowObject.embarque     NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pembarque    = RowObject.embarque.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL   NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW       NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE RowObject.cod-estabel  NO-UNDO.
    DEFINE OUTPUT PARAMETER pembarque    LIKE RowObject.embarque     NO-UNDO.

    FIND FIRST bf{&TableName} WHERE 
        bf{&TableName}.cod-estabel = pcod-estabel AND 
        bf{&TableName}.embarque = pembarque NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf{&TableName} THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-set-mostra-embarq-sem-despesa DBOProgram 
PROCEDURE pi-set-mostra-embarq-sem-despesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-mostra-embarq-sem-despesa AS LOG NO-UNDO.

    ASSIGN l-mostra-embarq-sem-despesa = p-mostra-embarq-sem-despesa.                  
                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE BUFFER b-bc-param-ext FOR bc-param-ext. 

DEFINE NEW GLOBAL SHARED VAR c-tabela       AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR c-id-tabela    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE i-tipo-param AS INTEGER    NO-UNDO. /*1 - Char ; 2 - Data ; 3 - Decimal; 4 - Inteiro; 5 - Logico  */

/* Definicao da tabela de parametros */
DEFINE TEMP-TABLE tt-param-transacao NO-UNDO
            FIELD cCodEntidadeParamExt  AS CHARACTER    /* Armazena o nome tabela. Os valores pode ser: 
                                                         - bc-tipo-trans
                                                         - bc-ext-item
                                                         - bc-ext-familia */
            FIELD cCodChaveParamExt     AS CHARACTER    /* Guarda o nome da transacao utilizada
                                                         - wmsai001 
                                                         - wmsai003
                                                         - wmsai004*/
            FIELD cCodParamExt          AS CHARACTER    /* Nome do parametro 
                                                         - LEIT-QTD-DEVOL-PICK
                                                         - LEIT-QTD-ARMAZEN-TAR
                                                         - LEIT-QTD-AREA-PICK
                                                         - LEIT-QTD-AREA-NORMAL*/
            FIELD iParamInteiro         AS INTEGER      /* Valor do parametro 
                                                         - 1 pedir em tela
                                                         - 2 Por qtd
                                                         - 3 Por ean/dun
                                                         - 4 Por EMB/UN */
            FIELD cDescParam            AS CHARACTER    /* Descricao do parametro */
            FIELD lSobrescreveRegistro  AS LOGICAL      /* Permite sobrescrever */
            INDEX cCodEntidadeParamExt
                  cCodChaveParamExt
                  cCodParamExt.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fi-getDescParam Include 
FUNCTION fi-getDescParam RETURNS CHARACTER
  ( p-cCodParamExt AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fi-getDescParamDevolucao Include 
FUNCTION fi-getDescParamDevolucao RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fi-getDescParamDisp-Qtde Include 
FUNCTION fi-getDescParamDisp-Qtde RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fi-getDescParamImpressao Include 
FUNCTION fi-getDescParamImpressao RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fi-getDescParamInventario Include 
FUNCTION fi-getDescParamInventario RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fi-getDescParamNormal Include 
FUNCTION fi-getDescParamNormal RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fi-getDescParamPicking Include 
FUNCTION fi-getDescParamPicking RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fi-getDescParamPickPack-Endereco Include 
FUNCTION fi-getDescParamPickPack-Endereco RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fi-getDescParamPickPack-Etiqueta Include 
FUNCTION fi-getDescParamPickPack-Etiqueta RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fi-getDescParamPickPack-Tarefa Include 
FUNCTION fi-getDescParamPickPack-Tarefa RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fi-getDescParamTarefa Include 
FUNCTION fi-getDescParamTarefa RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fi-getDescParamUnidade Include 
FUNCTION fi-getDescParamUnidade RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fi-getDescParamGeraHistEtiqueta Include 
FUNCTION fi-getDescParamGeraHistEtiqueta RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 59.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-criaParametro Include 
PROCEDURE pi-criaParametro :
/*------------------------------------------------------------------------------
  Purpose:     Seleciona o tipo de entidade e executa o metodo correspondente
  Notes:       Sao tres tipos de entidades tratada nesse metodo:
                - bc-tipo-trans
                - bc-ext-item
                - bc-ext-familia
               Para cada entidade executa um metodo diferente

               Se a entidade for bc-tipo-trans, cria os parametros para as seguintes transacoes:
                 - WMSai001: LEIT-QTD-AREA-PICKIN e LEIT-QTD-AREA-NORMAL  
                 - WMSai003: LEIT-QTD-ARMAZEN-TAR
                 - WMSai004: LEIT-QTD-DEVOL-PICK
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-cInicial               AS CHARACTER  NO-UNDO. /*Item/familia inicial */
   DEFINE INPUT PARAMETER p-cFim                   AS CHARACTER  NO-UNDO. /*Item/Familia final   */
   DEFINE INPUT PARAMETER p-cCodEntidadeParamExt   AS CHARACTER  NO-UNDO. /*Entidade. (bc-tipo-trans) */
   DEFINE INPUT PARAMETER p-cCodChaveParamExt      AS CHARACTER  NO-UNDO. /*Transacao (wmsai001) */
   DEFINE INPUT PARAMETER p-cCodParamExt           AS CHARACTER  NO-UNDO. /*Parametro  */
   DEFINE INPUT PARAMETER p-iParamInteiro          AS INTEGER    NO-UNDO. /*Valor do parametro*/
   DEFINE INPUT PARAMETER p-lSobrescreveRegistro   AS LOGICAL    NO-UNDO. /*Permite sobrescrever*/

   /* Seleciona conforme o tipo de entidade */
   CASE p-cCodEntidadeParamExt:   
      /* Se a entidade for bc-tipo-trans */
      WHEN "BC-TIPO-TRANS" THEN DO:
          /* WMSAI001 e WMSAI009 */
          IF p-cCodParamExt = "LEIT-QTD-AREA-PICKIN" OR p-cCodParamExt = "LEIT-QTD-AREA-NORMAL" THEN DO:
             ASSIGN i-tipo-param = 4. /* Integer */
             RUN pi-setEntidadeBcTipoTrans (INPUT "WMSai001",
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).

             /* Replica o(s) parametro(s) tambem para a transaá∆o WMSai009 (Picking ~\ Packing Simultaneos) */
             ASSIGN i-tipo-param = 4. /* Integer */
             RUN pi-setEntidadeBcTipoTrans (INPUT "WMSai009",
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).
          END.

          IF p-cCodParamExt = "LE-ENDERECO-DOCA" THEN DO:
             ASSIGN i-tipo-param = 5. /* Logico */
             RUN pi-setEntidadeBcTipoTrans (INPUT "WMSai001",
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).
             
          END.

          /* WMEnt003 */
          IF p-cCodParamExt = "LEIT-QTD-ARMAZEN-TAR" THEN DO:
             ASSIGN i-tipo-param = 4. /* Integer */
             RUN pi-setEntidadeBcTipoTrans (INPUT "WMEnt003",
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).
          END.

          IF p-cCodParamExt = "GERA_HISTORICO" THEN DO:
             ASSIGN i-tipo-param = 5. /* Logico */
             RUN pi-setEntidadeBcTipoTrans (INPUT "WMEnt003",
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).

             RUN pi-setEntidadeBcTipoTrans (INPUT "WMSai001",
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).

             RUN pi-setEntidadeBcTipoTrans (INPUT "WMSai004",
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).

             RUN pi-setEntidadeBcTipoTrans (INPUT "WMSai009",
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).
          END.

          /* WMSAI004 */
          IF p-cCodParamExt = "LEIT-QTD-DEVOL-PICK" THEN DO:
             ASSIGN i-tipo-param = 4. /* Integer */
             RUN pi-setEntidadeBcTipoTrans (INPUT "WMSai004",
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).
          END.
          
          /* Parametros da Transaá∆o de Picking ~\ Packing Simult∆neos - Inicio */
          /* WMSAI009 */
          IF p-cCodParamExt = "LER-ENDERECO-ITEM" THEN DO:
             ASSIGN i-tipo-param = 5. /* Logico */
             RUN pi-setEntidadeBcTipoTrans (INPUT "WMSai009",
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).
          END.

          /* WMSAI009 */
          IF p-cCodParamExt = "LER-ETIQUETA-PACKING" THEN DO:
             ASSIGN i-tipo-param = 5. /* Logico */
             RUN pi-setEntidadeBcTipoTrans (INPUT "WMSai009",
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).
          END.

          /* WMSAI009 */
          IF p-cCodParamExt = "LER-TAREFAS-PROCESSO" THEN DO:
             ASSIGN i-tipo-param = 5. /* Logico */
             RUN pi-setEntidadeBcTipoTrans (INPUT "WMSai009",
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).
          END.
          
          /* Parametros da Transaá∆o de Picking ~\ Packing Simult∆neos - Final */
          /* WMOut003 - mk */
          IF p-cCodParamExt = "LEIT-QTD-INVENTARIO" THEN DO:
             ASSIGN i-tipo-param = 4. /* Inteiro */
             RUN pi-setEntidadeBcTipoTrans (INPUT "WMOut003",
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).
          END.

          /* WMOut004 - mk */
          IF p-cCodParamExt = "LEIT-QTD-IMPRESSAO" THEN DO:
             ASSIGN i-tipo-param = 4. /* Inteiro */
             RUN pi-setEntidadeBcTipoTrans (INPUT "WMOut004",
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).
          END.

          /* Parametro para habilitar unidade - mk */
          IF p-cCodParamExt = "HABILITA-UNIDADE" THEN DO:
             ASSIGN i-tipo-param = 5. /* Logico */
             RUN pi-setEntidadeBcTipoTrans (INPUT p-cCodChaveParamExt,
                                            INPUT p-cCodParamExt,
                                            INPUT p-iParamInteiro,
                                            INPUT p-lSobrescreveRegistro).
              
             IF p-cCodChaveParamExt    = "WMSai001" THEN
                RUN pi-setEntidadeBcTipoTrans (INPUT "WMSAI009",
                                               INPUT p-cCodParamExt,
                                               INPUT p-iParamInteiro,
                                               INPUT p-lSobrescreveRegistro).
          END.

          /* Parametro para definir display da quantidade - mk */
          IF p-cCodParamExt = "DISP-QTDE"
            AND (p-cCodChaveParamExt = "WMSai001" /* Picking */
             OR p-cCodChaveParamExt  = "WMSai003" /* Ressup  */
             OR p-cCodChaveParamExt  = "WMSai009" /* Picking~\Packing */
             OR p-cCodChaveParamExt  = "WMSai004" /* Devoluá∆o Picking */
             OR p-cCodChaveParamExt  = "WMEnt003") /* Armazenamento */ THEN DO:

            ASSIGN i-tipo-param = 4. /* Inteiro */
            RUN pi-setEntidadeBcTipoTrans (INPUT p-cCodChaveParamExt,
                                           INPUT p-cCodParamExt,
                                           INPUT p-iParamInteiro,
                                           INPUT p-lSobrescreveRegistro).
          END.
      END.

      WHEN "BC-EXT-ITEM" THEN DO:
         IF p-cCodParamExt = "HABILITA-UNIDADE"
            OR p-cCodParamExt = "LER-TAREFAS-PROCESSO"
            OR p-cCodParamExt = "LER-ETIQUETA-PACKING"
            OR p-cCodParamExt = "LER-ENDERECO-ITEM" THEN
            ASSIGN i-tipo-param = 5.
         ELSE
            ASSIGN i-tipo-param = 4. /* Integer */

         RUN pi-setEntidadeBcExtItem(INPUT p-cInicial,
                                     INPUT p-cFim,
                                     INPUT p-cCodParamExt,
                                     INPUT p-iParamInteiro,
                                     INPUT p-lSobrescreveRegistro).
      END.

      WHEN "BC-EXT-FAMILIA" THEN DO:
         IF p-cCodParamExt = "HABILITA-UNIDADE"
            OR p-cCodParamExt = "LER-TAREFAS-PROCESSO"
            OR p-cCodParamExt = "LER-ETIQUETA-PACKING"
            OR p-cCodParamExt = "LER-ENDERECO-ITEM" THEN
            ASSIGN i-tipo-param = 5.
         ELSE
            ASSIGN i-tipo-param = 4. /* Integer */
         
         RUN pi-setEntidadeBcExtFamilia(INPUT p-cInicial,
                                        INPUT p-cFim,
                                        INPUT p-cCodParamExt,
                                        INPUT p-iParamInteiro,
                                        INPUT p-lSobrescreveRegistro).
      END.
   END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-setEntidadeBcExtFamilia Include 
PROCEDURE pi-setEntidadeBcExtFamilia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-cInicial               AS CHARACTER  NO-UNDO. /*Item/familia inicial */
   DEFINE INPUT PARAMETER p-cFim                   AS CHARACTER  NO-UNDO. /*Item/Familia final   */
   DEFINE INPUT PARAMETER p-cCodParamExt           AS CHARACTER  NO-UNDO. /*Parametro  */
   DEFINE INPUT PARAMETER p-iParamInteiro          AS INTEGER    NO-UNDO. /*Valor do parametro*/
   DEFINE INPUT PARAMETER p-lSobrescreveRegistro   AS LOGICAL    NO-UNDO. /*Permite sobrescrever*/

   /* Limpa a tabela */
   EMPTY TEMP-TABLE tt-param-transacao.

   FOR EACH bc-ext-familia
      WHERE bc-ext-familia.fm-codigo >= p-cInicial
        AND bc-ext-familia.fm-codigo <= p-cFim NO-LOCK:

      CREATE tt-param-transacao.
      ASSIGN tt-param-transacao.cCodEntidadeParamExt = "bc-ext-familia"
             tt-param-transacao.cCodChaveParamExt    = bc-ext-familia.fm-codigo
             tt-param-transacao.cCodParamExt         = p-cCodParamExt
             tt-param-transacao.iParamInteiro        = p-iParamInteiro
             tt-param-transacao.lSobrescreveRegistro = p-lSobrescreveRegistro.

       /* Busca a descricao do parametro conforme o tipo */
       ASSIGN tt-param-transacao.cDescParam   = fi-getDescParam(INPUT p-cCodParamExt).
   END.

   CASE i-tipo-param:
      WHEN 4 THEN DO: /* Integer */
         RUN pi-setTableBcParamExt-int (INPUT TABLE tt-param-transacao).
      END.

      WHEN 5 THEN DO: /* Logico */
         RUN pi-setTableBcParamExt-log (INPUT TABLE tt-param-transacao).
      END.
   END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-setEntidadeBcExtItem Include 
PROCEDURE pi-setEntidadeBcExtItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-cInicial               AS CHARACTER  NO-UNDO. /*Item/familia inicial */
   DEFINE INPUT PARAMETER p-cFim                   AS CHARACTER  NO-UNDO. /*Item/Familia final   */
   DEFINE INPUT PARAMETER p-cCodParamExt           AS CHARACTER  NO-UNDO. /*Parametro  */
   DEFINE INPUT PARAMETER p-iParamInteiro          AS INTEGER    NO-UNDO. /*Valor do parametro*/
   DEFINE INPUT PARAMETER p-lSobrescreveRegistro   AS LOGICAL    NO-UNDO. /*Permite sobrescrever*/

   /* Limpa a tabela */
   EMPTY TEMP-TABLE tt-param-transacao.

   FOR EACH bc-ext-item
      WHERE bc-ext-item.it-codigo >= p-cInicial
        AND bc-ext-item.it-codigo <= p-cFim NO-LOCK:

      CREATE tt-param-transacao.
      ASSIGN tt-param-transacao.cCodEntidadeParamExt = "bc-ext-item"
             tt-param-transacao.cCodChaveParamExt    = bc-ext-item.it-codigo
             tt-param-transacao.cCodParamExt         = p-cCodParamExt
             tt-param-transacao.iParamInteiro        = p-iParamInteiro
             tt-param-transacao.lSobrescreveRegistro = p-lSobrescreveRegistro.

      /* Busca a descricao do parametro conforme o tipo */
      ASSIGN tt-param-transacao.cDescParam   = fi-getDescParam(INPUT p-cCodParamExt).
   END.

   CASE i-tipo-param:
      WHEN 4 THEN DO: /* Integer */
         RUN pi-setTableBcParamExt-int (INPUT TABLE tt-param-transacao).
      END.

      WHEN 5 THEN DO: /* Logico */
         RUN pi-setTableBcParamExt-log (INPUT TABLE tt-param-transacao).
      END.
   END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-setEntidadeBcTipoTrans Include 
PROCEDURE pi-setEntidadeBcTipoTrans PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Gera os quatro parametros iniciais para a transacao informada
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-cCodChaveParamExt      AS CHARACTER  NO-UNDO. /*Transacao (wmsai001, wmsai003 ou wmsai004) */
   DEFINE INPUT PARAMETER p-cCodParamExt           AS CHARACTER  NO-UNDO. /*Parametro  */
   DEFINE INPUT PARAMETER p-iParamInteiro          AS INTEGER    NO-UNDO. /*Valor do parametro*/
   DEFINE INPUT PARAMETER p-lSobrescreveRegistro   AS LOGICAL    NO-UNDO. /*Permite sobrescrever*/
    
   EMPTY TEMP-TABLE tt-param-transacao NO-ERROR.

   CREATE tt-param-transacao.
   ASSIGN tt-param-transacao.cCodEntidadeParamExt = "bc-tipo-trans"
          tt-param-transacao.cCodChaveParamExt    = p-cCodChaveParamExt /*wmsai001, wmsai003, wmsai004 ou wmsai009*/
          tt-param-transacao.cCodParamExt         = p-cCodParamExt
          tt-param-transacao.iParamInteiro        = p-iParamInteiro
          tt-param-transacao.lSobrescreveRegistro = p-lSobrescreveRegistro.

   /* Busca a descricao do parametro conforme o tipo */
   ASSIGN tt-param-transacao.cDescParam   = fi-getDescParam(INPUT p-cCodParamExt).

   /* Executa o metodo de criacao do registro na bc-param-ext - bravo */
   CASE i-tipo-param:
      WHEN 4 THEN DO: /* Integer */
         RUN pi-setTableBcParamExt-int (INPUT TABLE tt-param-transacao).
      END.

      WHEN 5 THEN DO: /* Logico */
         RUN pi-setTableBcParamExt-log (INPUT TABLE tt-param-transacao).
      END.
   END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-setTableBcParamExt-int Include 
PROCEDURE pi-setTableBcParamExt-int PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Cria/altera o registro na tabela b-bc-param-ext
  Parameters:  <none>
  Notes:       Altera apenas parar inteiro
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER TABLE FOR tt-param-transacao.

   FOR EACH tt-param-transacao TRANSACTION.
      /* Procura pelo registro na bc-param-ext */
      FIND FIRST b-bc-param-ext EXCLUSIVE-LOCK
           WHERE b-bc-param-ext.cod-entidade-param-ext   = tt-param-transacao.cCodEntidadeParamExt 
             AND b-bc-param-ext.cod-chave-param-ext      = tt-param-transacao.cCodChaveParamExt
             AND b-bc-param-ext.cod-param-ext            = tt-param-transacao.cCodParamExt NO-ERROR.
      IF AVAIL b-bc-param-ext THEN DO: /* Se achou o registro, verifica se pode atualizar. Se nao pode, vai para o proximo */
         IF tt-param-transacao.lSobrescreveRegistro = NO THEN DO:
            /* Sai - do Transaction */
            NEXT. 
         END.
      END.
      ELSE DO:
         /* Cria um novo registro */
         CREATE b-bc-param-ext.
      END.

      /* Atualiza os registros */
      ASSIGN b-bc-param-ext.cod-entidade-param-ext   = tt-param-transacao.cCodEntidadeParamExt
             b-bc-param-ext.cod-chave-param-ext      = tt-param-transacao.cCodChaveParamExt
             b-bc-param-ext.cod-param-ext            = tt-param-transacao.cCodParamExt
             b-bc-param-ext.desc-param               = tt-param-transacao.cDescParam   
             b-bc-param-ext.param-inteiro            = tt-param-transacao.iParamInteiro
             b-bc-param-ext.log-1                    = TRUE /*Padrao datasul*/
             b-bc-param-ext.ind-tipo-dado            = 4.   /*tipo inteiro*/ 
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-setTableBcParamExt-log Include 
PROCEDURE pi-setTableBcParamExt-log PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Cria/altera o registro na tabela b-bc-param-ext
  Parameters:  <none>
  Notes:       Altera apenas parar inteiro
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER TABLE FOR tt-param-transacao.
       
   DEFINE VARIABLE l-param-log AS LOGICAL INITIAL NO NO-UNDO.
   
   IF tt-param-transacao.iParamInteiro = 1 THEN
      ASSIGN l-param-log = YES.
   ELSE
      ASSIGN l-param-log = NO.

   FOR EACH tt-param-transacao TRANSACTION.
      /* Procura pelo registro na bc-param-ext */
      FIND FIRST b-bc-param-ext
          WHERE b-bc-param-ext.cod-entidade-param-ext   = tt-param-transacao.cCodEntidadeParamExt 
            AND b-bc-param-ext.cod-chave-param-ext      = tt-param-transacao.cCodChaveParamExt
            AND b-bc-param-ext.cod-param-ext            = tt-param-transacao.cCodParamExt EXCLUSIVE-LOCK NO-ERROR.
      IF AVAIL b-bc-param-ext THEN DO: /* Se achou o registro, verifica se pode atualizar. Se nao pode, vai para o proximo */
         IF tt-param-transacao.lSobrescreveRegistro = NO THEN DO:
            /* Sai - do Transaction */
            NEXT. 
         END.
      END.
      ELSE DO:
         /* Cria um novo registro */
         CREATE b-bc-param-ext.
      END.
       
      /* Atualiza os registros */
      ASSIGN b-bc-param-ext.cod-entidade-param-ext   = tt-param-transacao.cCodEntidadeParamExt
             b-bc-param-ext.cod-chave-param-ext      = tt-param-transacao.cCodChaveParamExt
             b-bc-param-ext.cod-param-ext            = tt-param-transacao.cCodParamExt
             b-bc-param-ext.desc-param               = tt-param-transacao.cDescParam   
             b-bc-param-ext.param-logico             = l-param-log
             b-bc-param-ext.log-1                    = TRUE /*Padrao datasul*/
             b-bc-param-ext.ind-tipo-dado            = 5.   /*tipo logico*/ 
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fi-getDescParam Include 
FUNCTION fi-getDescParam RETURNS CHARACTER
  ( p-cCodParamExt AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna a descricao do parametro conforme selecao
    Notes:  
------------------------------------------------------------------------------*/
   /* Busca a descricao conforme o tipo de parametro */
   CASE p-cCodParamExt:
      /* Busca a descricao do Tipo de leitura na †rea de picking */
      WHEN "LEIT-QTD-AREA-PICKIN" THEN DO:
         RETURN fi-getDescParamPicking().
      END.

      /* Busca a descricao do Tipo de leitura na †rea de picking */
      WHEN "LE-ENDERECO-DOCA" THEN DO:
         RETURN fi-getDescParamPicking(). /* FLAVIOC */
      END.

      /* Busca a descricao do Tipo de leitura na area normal */
      WHEN "LEIT-QTD-AREA-NORMAL" THEN DO:
         RETURN fi-getDescParamNormal().
      END.

      /* Busca a descricao do Tipo de leitura no armazenamento por tarefa */
      WHEN "LEIT-QTD-ARMAZEN-TAR" THEN DO:
         RETURN fi-getDescParamTarefa().
      END.

      /* Busca a descricao do Tipo de leitura na devolucao de picking */
      WHEN "LEIT-QTD-DEVOL-PICK" THEN DO:
         RETURN fi-getDescParamDevolucao().
      END.
      
      /* Busca a descricao do Parametro para Leitura do Endereco do Item*/
      WHEN "LER-ENDERECO-ITEM" THEN DO:
         RETURN fi-getDescParamPickPack-Endereco().
      END.

      /* Busca a descricao do Parametro para Leitura da Etiqueta de Packing do Item*/
      WHEN "LER-ETIQUETA-PACKING" THEN DO:
         RETURN fi-getDescParamPickPack-Etiqueta().
      END.

      /* Busca a descricao do Parametro para Leitura das Tarefas em Processo do Item*/
      WHEN "LER-TAREFAS-PROCESSO" THEN DO:
         RETURN fi-getDescParamPickPack-Tarefa().
      END.

      /* Busca a descricao do Parametro para Leitura no Inventario - mk*/
      WHEN "LEIT-QTD-INVENTARIO" THEN DO:
         RETURN fi-getDescParamInventario().
      END.

      /* Busca a descricao do Parametro para Leitura na Impress∆o de Etiquetas - mk*/
      WHEN "LEIT-QTD-IMPRESSAO" THEN DO:
         RETURN fi-getDescParamImpressao().
      END.

      /* Busca a descricao do Parametro para habilitar a unidade*/
      WHEN "HABILITA-UNIDADE" THEN DO:
         RETURN fi-getDescParamUnidade().
      END.

      /* Busca a descricao do Parametro para tipo de display da quantidade*/
      WHEN "DISP-QTDE" THEN DO:
         RETURN fi-getDescParamDisp-Qtde().
      END.
      
      /* Busca a descricao do Parametro para gerar historico etiqueta serial*/
      WHEN "GERA_HISTORICO" THEN DO:
         RETURN fi-getDescParamGeraHistEtiqueta().
      END.
   END CASE.
   RETURN "".
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fi-getDescParamDevolucao Include 
FUNCTION fi-getDescParamDevolucao RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna a descricao do Tipo de leitura da qtd na devolucao
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cDescParam AS CHARACTER  NO-UNDO.

   /* Monta a descricao */
   ASSIGN cDescParam = "Este parÉmetro tem por finalidade configurar o " + 
                        "tipo de leitura da quantidade quando executada a transaá∆o de " + 
                        "devoluá∆o de picking, opá∆o de devoluá∆o por item x quantidade. " + 
                        CHR(10) + "A rotina de devoluá∆o de picking, com leitura do item x " + 
                        "quantidade verifica este parÉmetro na seguinte ordem: se cadastrado " + 
                        "na extens∆o do item, assume o valor parametrizado na tabela de extens∆o " + 
                        "do item. Caso n∆o exista na extens∆o do item, verifica a extens∆o da " + 
                        "fam°lia do item. Se cadastrado, assume o valor parametrizado na tabela da fam°lia do item. " + 
                        "Se n∆o existir em nenhuma das duas tabelas, assume o valor cadastrado para o " + 
                        "parÉmetro na transaá∆o WMSai004." + CHR(10) + 
                        "Os valores poss°veis para o parÉmetro s∆o:" + CHR(10) + 
                        "1 - Pede em tela." + CHR(10) + 
                        "2 - Por Quantidade" + CHR(10) +
                        "3 - Por EAN/DUM" + CHR(10) +
                        "4 - Por Emb/Un".

   RETURN cDescParam.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fi-getDescParamDisp-Qtde Include 
FUNCTION fi-getDescParamDisp-Qtde RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna a descricao do Tipo de leitura da qtd por tarefa
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cDescParam AS CHARACTER  NO-UNDO.

   /* Monta a descricao */
   ASSIGN cDescParam =  "Este parÉmetro tem por finalidade configurar a forma de visualizaá∆o da " + 
                        "quantidade na transaá∆o correspondete . " + CHR(10) + 
                        "A rotina de visualizaá∆o da quantidade verifica " + 
                        "este parÉmetro na seguinte ordem: se cadastrado na extens∆o do item, assume o " + 
                        "valor parametrizado na tabela de extens∆o do item. Caso n∆o exista na extens∆o do " + 
                        " item, verifica a extens∆o da fam°lia do item. Se cadastrado, assume o valor " + 
                        "parametrizado na tabela da fam°lia do item. Se n∆o existir em nenhuma das duas tabelas, " + 
                        "assume o valor cadastrado para o parÉmetro na transaá∆o que o mesmo esta configurado." + CHR(10) + 
                        "Os valores poss°veis para o parÉmetro s∆o:" + CHR(10) + "2 - Por Quantidade" +
                        CHR(10) + "4 - Por Emb/Un".

   RETURN cDescParam.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fi-getDescParamImpressao Include 
FUNCTION fi-getDescParamImpressao RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna a descricao do Tipo de leitura da qtd por tarefa
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cDescParam AS CHARACTER  NO-UNDO.

   /* Monta a descricao */
   ASSIGN cDescParam =  "Este parÉmetro tem por finalidade configurar o tipo de leitura da " + 
                        "quantidade quando executada a rotina de impress∆o (BC9026). " + CHR(10) + 
                        "Os valores poss°veis para o parÉmetro s∆o:" + CHR(10) + "2 - Por Quantidade" + 
                        CHR(10) + "4 - Por Emb/Un".

   RETURN cDescParam.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fi-getDescParamInventario Include 
FUNCTION fi-getDescParamInventario RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna a descricao do Tipo de leitura da qtd por tarefa
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cDescParam AS CHARACTER  NO-UNDO.

   /* Monta a descricao */
   ASSIGN cDescParam =  "Este parÉmetro tem por finalidade configurar o tipo de leitura da " + 
                        "quantidade quando executada a transaá∆o de invent†rio, " + 
                        "opá∆o de leitura por item x quantidade. " + CHR(10) + 
                        "A rotina de inventario, com leitura do item x quantidade verifica " + 
                        "este parÉmetro na seguinte ordem: se cadastrado na extens∆o do item, assume o " + 
                        "valor parametrizado na tabela de extens∆o do item. Caso n∆o exista na extens∆o do " + 
                        " item, verifica a extens∆o da fam°lia do item. Se cadastrado, assume o valor " + 
                        "parametrizado na tabela da fam°lia do item. Se n∆o existir em nenhuma das duas tabelas, " + 
                        "assume o valor cadastrado para o parÉmetro na transaá∆o WMEnt003." + CHR(10) + 
                        "Os valores poss°veis para o parÉmetro s∆o:" + CHR(10) + "1 - Pede em tela." + CHR(10) + 
                        "2 - Por Quantidade" + CHR(10) + "4 - Por Emb/Un".

   RETURN cDescParam.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fi-getDescParamNormal Include 
FUNCTION fi-getDescParamNormal RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna a descricao do Tipo de leitura da qtd na †rea normal
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cDescParam AS CHARACTER  NO-UNDO.

   /* Monta a descricao */
   ASSIGN cDescParam =  "Este parÉmetro tem por finalidade configurar o tipo de leitura " + 
                        "da quantidade do serial na †rea normal para a transaá∆o de Picking." + 
                        CHR(10) + "A rotina de picking com leitura da quantidade na †rea normal " + 
                        "verifica este parÉmetro na seguinte ordem: se cadastrado na extens∆o do item, " + 
                        "assume o valor parametrizado na tabela de extens∆o do item. " + 
                        "Caso n∆o exista na extens∆o do item, verifica a extens∆o da fam°lia do item. " + 
                        "Se cadastrado, assume o valor parametrizado na tabela da fam°lia do item. " + 
                        "Se n∆o existir em nenhuma das duas tabelas, assume o valor cadastrado para o " + 
                        "parÉmetro na transaá∆o WMSai001." + CHR(10) + 
                        "Os valores poss°veis para o parÉmetro s∆o:" + CHR(10) + "1 - Pede em tela." + 
                        CHR(10) + "2 - Por Quantidade" + CHR(10) + "3 - Por EAN/DUM" + CHR(10) + "4 - Por Emb/Un" + CHR(100) + CHR(10) +
                        "P.S. Mesmo que seja selecionada a opá∆o 'Pedir em Tela', quando a  coleta  for" + CHR(10) +
                        "        por  serial e  a quantidade  do  serial  for  igual a quantidade parametrizada" + CHR(10) +
                        "        nos dados de sa°da do item, o sistema n∆o far† a solicitaá∆o em tela.".

   RETURN cDescParam.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fi-getDescParamPicking Include 
FUNCTION fi-getDescParamPicking RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna a descricao do Tipo de leitura da qtd na †rea de picking
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cDescParam AS CHARACTER  NO-UNDO.

   /* Monta a descricao */
   ASSIGN cDescParam =  "Este parÉmetro tem por finalidade configurar o tipo de " + 
                        "leitura da quantidade do serial na †rea de picking para a transaá∆o de Picking. " + CHR(10) + 
                        "A rotina de picking com leitura da quantidade na †rea de picking verifica este " + 
                        "parÉmetro na seguinte ordem: se cadastrado na extens∆o do item, assume o valor " + 
                        "parametrizado na tabela de extens∆o do item. Caso n∆o exista na extens∆o do item, " + 
                        "verifica a extens∆o da fam°lia do item. Se cadastrado, assume o valor parametrizado " + 
                        "na tabela da fam°lia do item. Se n∆o existir em nenhuma das duas tabelas, assume " + 
                        "o valor cadastrado para o parÉmetro na transaá∆o WMSai001." + CHR(10) + 
                        "Os valores poss°veis para o parÉmetro s∆o:" + CHR(10) + "1 - Pede em tela." + 
                        CHR(10) + "2 - Por Quantidade" + CHR(10) + "3 - Por EAN/DUM" + CHR(10) + "4 - Por Emb/Un" + CHR(10) + CHR(10) +
                        "P.S. Mesmo que seja selecionada a opá∆o 'Pedir em Tela', quando a  coleta  for" + CHR(10) +
                        "        por  serial e  a quantidade  do  serial  for  igual a quantidade parametrizada" + CHR(10) +
                        "        nos dados de sa°da do item, o sistema n∆o far† a solicitaá∆o em tela.".
   
   RETURN cDescParam.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fi-getDescParamPickPack-Endereco Include 
FUNCTION fi-getDescParamPickPack-Endereco RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna a descricao do Tipo de leitura da qtd por tarefa
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cDescParam AS CHARACTER  NO-UNDO.
   
   /* Monta a descricao */
   ASSIGN cDescParam =  "Este parÉmetro faz parte da configuraá∆o da transaá∆o de Picking e" +
                        "Packing SimultÉneos (WMSai009). Sua finalidade Ç informar se ser† necess†ria a " + 
                        "leitura do endereáo para os itens separados ou se o mesmo ser† retornado automaticamente " +
                        "Ö partir da etiqueta do item." + CHR(10) + 
                        "Os valores poss°veis para o parÉmetro s∆o:" + CHR(10) + 
                        "YES - Efetua Leitura do Endereáo." + CHR(10) + 
                        "NO - Retorna Automaticamente o Endereáo do Item".
   
   RETURN cDescParam.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fi-getDescParamPickPack-Etiqueta Include 
FUNCTION fi-getDescParamPickPack-Etiqueta RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna a descricao do Tipo de leitura da qtd por tarefa
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cDescParam AS CHARACTER  NO-UNDO.

   /* Monta a descricao */
   ASSIGN cDescParam =  "Este parÉmetro faz parte da cofiguraá∆o da transaá∆o de Picking e" + 
                        "Packing SimultÉneos (WMSai009). Sua finalidade Ç informar se ser† necess†ria a " + 
                        "leitura da Etiqueta de Packing para itens que n∆o sofrem Packing. " + 
                        "Caso o parÉmetro n∆o obrigue esta leitura, n∆o haver† relaá∆o entre a etiqueta de " +
                        "packing e o item separado." + CHR(10) + 
                        "Os valores poss°veis para o parÉmetro s∆o:" + CHR(10) + "YES - Efetua Leitura do Etiqueta de Packing." + CHR(10) + 
                        "NO - N∆o Obriga a Leitura da Etiqueta de Packing".

   RETURN cDescParam.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fi-getDescParamPickPack-Tarefa Include 
FUNCTION fi-getDescParamPickPack-Tarefa RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna a descricao do Tipo de leitura da qtd por tarefa
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cDescParam AS CHARACTER  NO-UNDO.

   /* Monta a descricao */
   ASSIGN cDescParam =  "Este parÉmetro faz parte da cofiguraá∆o da transaá∆o de Picking e" + 
                        "Packing SimultÉneos (WMSai009). Sua finalidade Ç informar se as tarefas Em Processo " + 
                        "do usu†rio ser∆o lidas juntamente com as Tarefas P£blicas. " +
                        "Isto visa facilitar o processo de separaá∆o dos itens caso seja necess†ria a leitura " +
                        "de outra embalagem durante o processo." + CHR(10) +
                        "Os valores poss°veis para o parÉmetro s∆o:" + CHR(10) + "YES - Là as Tarefas em Processo juntamente com as Tarefas P£blicas." + CHR(10) + 
                        "NO - As Tarefas em Processo n∆o ser∆o lidas juntamente com as Tarefas P£blicas".

   RETURN cDescParam.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fi-getDescParamTarefa Include 
FUNCTION fi-getDescParamTarefa RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna a descricao do Tipo de leitura da qtd por tarefa
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cDescParam AS CHARACTER  NO-UNDO.

   /* Monta a descricao */
   ASSIGN cDescParam =  "Este parÉmetro tem por finalidade configurar o tipo de leitura da " + 
                        "quantidade quando executada a transaá∆o de armazenamento por tarefa, " + 
                        "opá∆o de leitura por item x quantidade. " + CHR(10) + 
                        "A rotina de armazenamento por tarefa, com leitura do item x quantidade verifica " + 
                        "este parÉmetro na seguinte ordem: se cadastrado na extens∆o do item, assume o " + 
                        "valor parametrizado na tabela de extens∆o do item. Caso n∆o exista na extens∆o do " + 
                        " item, verifica a extens∆o da fam°lia do item. Se cadastrado, assume o valor " + 
                        "parametrizado na tabela da fam°lia do item. Se n∆o existir em nenhuma das duas tabelas, " + 
                        "assume o valor cadastrado para o parÉmetro na transaá∆o WMEnt003." + CHR(10) + 
                        "Os valores poss°veis para o parÉmetro s∆o:" + CHR(10) + "1 - Pede em tela." + CHR(10) + 
                        "2 - Por Quantidade" + CHR(10) + "3 - Por EAN/DUM" + CHR(10) + "4 - Por Emb/Un".

   RETURN cDescParam.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fi-getDescParamUnidade Include 
FUNCTION fi-getDescParamUnidade RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna a descricao do Tipo de leitura da qtd por tarefa
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cDescParam AS CHARACTER  NO-UNDO.

   /* Monta a descricao */
   ASSIGN cDescParam =  "Este parÉmetro tem por finalidade configurar o campo de unidade " + 
                        " se o mesmo estar† habilitado ou nao, quando o tipo de leitura da quantidae " + 
                        "For por Embalagens e Unidades. " + CHR(10) + 
                        "A rotina de habilitar o campo de unidade verifica " + 
                        "este parÉmetro na seguinte ordem: se cadastrado na extens∆o do item, assume o " + 
                        "valor parametrizado na tabela de extens∆o do item. Caso n∆o exista na extens∆o do " + 
                        " item, verifica a extens∆o da fam°lia do item. Se cadastrado, assume o valor " + 
                        "parametrizado na tabela da fam°lia do item. Se n∆o existir em nenhuma das duas tabelas, " + 
                        "assume o valor cadastrado para o parÉmetro na transaá∆o que o mesmo esta configurado." + CHR(10) + 
                        "Os valores poss°veis para o parÉmetro s∆o:" + CHR(10) + "Sim - Habilita." + CHR(10) + 
                        "N∆o - N∆o Habilita".

   RETURN cDescParam.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fi-getDescParamImpressao Include 
FUNCTION fi-getDescParamGeraHistEtiqueta RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna a descricao do Tipo de leitura da qtd por tarefa
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cDescParam AS CHARACTER  NO-UNDO.

   /* Monta a descricao */
   ASSIGN cDescParam =  "Este parÉmetro tem por finalidade gerar o hist¢rico  " + 
                        "da movimentaá∆o da etiqueta Serial. Para isso o campo Param L¢gico (BC0116) deve estar marcado." + CHR(10). 

   RETURN cDescParam.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

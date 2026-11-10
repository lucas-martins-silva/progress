&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOFunction 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN089WM 2.00.00.011 } /*** "010011" 25/09/2025 09:40:21  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin089wm MUT}
&ENDIF


/*:T--------------------------------------------------------------------------
    File       : dbofun.p
    Purpose    : O DBO Function (Datasul Business Objects) Ç um programa 
                 PROGRESS que contÇm a l¢gica de neg¢cio.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName  doc-fisico
&GLOBAL-DEFINE DBOVersion  20000001
&GLOBAL-DEFINE DBOCustomFunctions doc-fisico
&GLOBAL-DEFINE TableName doc-fisico
&GLOBAL-DEFINE TableLabel doc-fisico

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin089.i RowObject}
{utp/ut-glob.i}

DEFINE TEMP-TABLE tt-fornec-docto NO-UNDO
    FIELD nro-docto        AS CHARACTER FORMAT "x(16)":U
    FIELD serie            AS CHARACTER FORMAT "X(05)":U
    FIELD cod-emitente     AS INTEGER   FORMAT ">>>>>>>>9":U
    FIELD tipo-nota        AS INTEGER   FORMAT ">9":U
    FIELD nome-abrev       AS CHARACTER FORMAT "x(12):U"
    FIELD data-transacao   AS DATE.

DEFINE VARIABLE raw-param  AS RAW NO-UNDO.
 
DEFINE TEMP-TABLE tt-param
    FIELD destino            AS INTEGER 
    FIELD arquivo            AS CHAR 
    FIELD usuario            AS CHAR 
    FIELD data-exec          AS DATE 
    FIELD hora-exec          AS INTEGER 
    FIELD classifica         AS INTEGER 
    FIELD c-cod-estabel-ini  AS CHAR 
    FIELD c-cod-estabel-fim  AS CHAR 
    FIELD i-cod-emitente-ini AS INTEGER 
    FIELD i-cod-emitente-fim AS INTEGER 
    FIELD c-nro-docto-ini    AS CHAR 
    FIELD c-nro-docto-fim    AS CHAR 
    FIELD c-serie-docto-ini  AS CHAR 
    FIELD c-serie-docto-fim  AS CHAR 
    FIELD i-tipo-nota-ini    AS INTEGER 
    FIELD i-tipo-nota-fim    AS INTEGER 
    FIELD da-dt-trans-ini    AS DATE 
    FIELD da-dt-trans-fim    AS DATE.
    
DEFINE TEMP-TABLE tt-digita
    FIELD r-doc-fisico       AS ROWID.
    
DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita         AS RAW.

DEFINE VARIABLE hdboad098na AS HANDLE      NO-UNDO.
DEFINE VARIABLE hdbosc075   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.

DEFINE VARIABLE l-erro      AS LOGICAL     NO-UNDO.

DEFINE BUFFER bfwm-etiqueta FOR wm-etiqueta.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOFunction
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOFunction
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOFunction ASSIGN
         HEIGHT             = 12.71
         WIDTH              = 38.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOFunction 
/* ************************* Included-Libraries *********************** */

{method/dbofun.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOFunction 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE conferenciaWMS DBOFunction 
PROCEDURE conferenciaWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pnro-docto      AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER pserie          AS CHARACTER NO-UNDO. 
   DEFINE INPUT  PARAMETER ptipo-nota      AS INTEGER   NO-UNDO.
   DEFINE INPUT  PARAMETER pcod-emitente   AS INTEGER   NO-UNDO.
   DEFINE INPUT  PARAMETER pcod-usuario    AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER patualiza-docto AS LOGICAL   NO-UNDO.
   DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

   EMPTY TEMP-TABLE RowErrors.
    
   FIND FIRST doc-fisico NO-LOCK 
        WHERE doc-fisico.nro-docto    = pnro-docto
          AND doc-fisico.serie-docto  = pserie
          AND doc-fisico.tipo-nota    = ptipo-nota
          AND doc-fisico.cod-emitente = pcod-emitente NO-ERROR.
   IF AVAIL doc-fisico THEN DO:
      FOR EACH it-doc-fisico OF doc-fisico NO-LOCK:
         IF it-doc-fisico.quantidade <> it-doc-fisico.quant-conf THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="35925"
                                        &ErrorType="EMS"
                                        &ErrorParameters="it-doc-fisico.it-codigo + pnro-docto"}
            RETURN "NOK":U.
         END.    
      END.
      /*se usuario for do recebimento*/
      IF patualiza-docto = YES THEN DO:
         FIND param-re NO-LOCK
            WHERE param-re.usuario = pcod-usuario NO-ERROR.
         IF AVAIL param-re THEN DO:
            FOR EACH it-doc-fisico 
               WHERE it-doc-fisico.serie-docto  = doc-fisico.serie-docto
                 AND it-doc-fisico.nro-docto    = doc-fisico.nro-docto
                 AND it-doc-fisico.cod-emitente = doc-fisico.cod-emitente
                 AND it-doc-fisico.tipo-nota    = doc-fisico.tipo-nota NO-LOCK:            
               FOR EACH rat-lote 
                  WHERE rat-lote.cod-emitente  = it-doc-fisico.cod-emitente 
                    AND rat-lote.serie-docto   = it-doc-fisico.serie-docto
                    AND rat-lote.nro-docto     = it-doc-fisico.nro-docto 
                    AND rat-lote.nat-operacao  = " " 
                    AND rat-lote.sequencia     = it-doc-fisico.sequencia 
                    AND rat-lote.tipo-nota     = it-doc-fisico.tipo-nota EXCLUSIVE-LOCK :
      
                   /* zera o campo rat-lote.int-2 para que todos os registros sejam apresentados
                     na p†gina Estoque do Recebimento Fiscal. Caso o valor armazenado neste campo
                     fosse 1 (um) o registro n∆o era apresentado ao modificar o item.*/
                   ASSIGN rat-lote.int-2 = 0.
                END.
            END.                   
            /*executar o re2005a.p*/
            RUN rep/re2005a.p (ROWID(doc-fisico),
                               INPUT ?,
                               OUTPUT l-erro).
            IF l-erro THEN DO:
               {method/svc/errors/inserr.i &ErrorNumber="36012"
                                           &ErrorType="EMS"
                                           &ErrorParameters="pnro-docto"}
            END.
         END.
      END.
   END.
   ELSE DO:
      {method/svc/errors/inserr.i &ErrorNumber="30511"
                                  &ErrorType="EMS"
                                  &ErrorParameters="pnro-docto"}
      RETURN "NOK":U.
   END.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fechaContagemWMS DBOFunction 
PROCEDURE fechaContagemWMS :
DEFINE INPUT  PARAMETER p-id-etiqueta AS DECIMAL   NO-UNDO.
    
    DEFINE VARIABLE d-id-agrupador AS DECIMAL     NO-UNDO.

    FOR FIRST wm-etiqueta EXCLUSIVE-LOCK
        WHERE wm-etiqueta.id-etiqueta = p-id-etiqueta:
            ASSIGN wm-etiqueta.log-confer = YES
                   wm-etiqueta.log-reportada = YES.
        IF ind-sit-agrupador = 1 THEN
            ASSIGN d-id-agrupador = wm-etiqueta.id-agrupador.
    END.
    IF d-id-agrupador <> 0 THEN DO:
        FOR FIRST wm-etiqueta
            WHERE wm-etiqueta.id-etiqueta = d-id-agrupador EXCLUSIVE-LOCK:
            IF NOT CAN-FIND(FIRST bfwm-etiqueta WHERE
                                  bfwm-etiqueta.id-agrupador  = wm-etiqueta.id-etiqueta    AND
                                  bfwm-etiqueta.log-reportada = NO  NO-LOCK) THEN DO:
                  ASSIGN wm-etiqueta.log-reportada = YES.
            END.
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFornecDoctos DBOFunction 
PROCEDURE getFornecDoctos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pnro-docto  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pserie      AS CHARACTER NO-UNDO. 
    DEFINE OUTPUT PARAMETER TABLE FOR tt-fornec-docto.
    
    EMPTY TEMP-TABLE tt-fornec-docto. 
    FOR EACH doc-fisico NO-LOCK
        WHERE doc-fisico.nro-docto   = pnro-docto
        AND   doc-fisico.serie-docto = pserie: 

        CREATE tt-fornec-docto.
        ASSIGN tt-fornec-docto.nro-docto      = doc-fisico.nro-docto
               tt-fornec-docto.serie          = doc-fisico.serie-docto
               tt-fornec-docto.cod-emitente   = doc-fisico.cod-emitente
               tt-fornec-docto.tipo-nota      = doc-fisico.tipo-nota
               tt-fornec-docto.data-transacao = doc-fisico.dt-trans.

        IF NOT VALID-HANDLE(hdboad098na) THEN
            RUN adbo/boad098na.p PERSISTENT SET hdboad098na.
        RUN openQueryStatic IN hdboad098na (INPUT "Main":U).
        RUN gotoKey         IN hdboad098na (INPUT doc-fisico.cod-emitente).
        RUN getCharField    IN hdboad098na (INPUT "nome-abrev":U,
                                          OUTPUT tt-fornec-docto.nome-abrev) NO-ERROR.
    END.

    IF VALID-HANDLE(hdboad098na) THEN 
        DELETE OBJECT hdboad098na.

    FIND FIRST tt-fornec-docto NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-fornec-docto THEN DO:
        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gravaContagemWMS DBOFunction 
PROCEDURE gravaContagemWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pnro-docto     AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pserie         AS CHARACTER NO-UNDO. 
    DEFINE INPUT  PARAMETER ptipo-nota     AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-emitente  AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pit-codigo     AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER plote          AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-refer     AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER i-qtd-conf     AS DECIMAL   NO-UNDO.
    DEFINE INPUT  PARAMETER inum-seq       AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE l-atualizou-conf       AS LOGICAL INITIAL NO NO-UNDO.

    DO TRANS:
        FOR EACH it-doc-fisico EXCLUSIVE-LOCK
            WHERE it-doc-fisico.nro-docto    = pnro-docto
            AND   it-doc-fisico.serie-docto  = pserie
            AND   it-doc-fisico.cod-emitente = pcod-emitente
            AND   it-doc-fisico.tipo-nota    = ptipo-nota
            AND   it-doc-fisico.it-codigo    = pit-codigo
            AND   it-doc-fisico.cod-refer    = pcod-refer
            AND   it-doc-fisico.sequencia    = inum-seq: 
            ASSIGN it-doc-fisico.quant-conf = it-doc-fisico.quant-conf + i-qtd-conf
                   l-atualizou-conf         = YES.
        END.
        IF l-atualizou-conf = NO THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-Documento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Documento_Recebimento_F°sico" *}
            ASSIGN c-lbl-liter-Documento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="34497"
                                        &ErrorType="EMS"
                                        &ErrorParameters="pit-codigo + c-lbl-liter-Documento"}
            UNDO, RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reabreContagemWMS DBOFunction 
PROCEDURE reabreContagemWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pnro-docto     AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pserie         AS CHARACTER NO-UNDO. 
    DEFINE INPUT  PARAMETER ptipo-nota     AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-emitente  AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER psequencia-item AS INTEGER  NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST param-estoq NO-LOCK NO-ERROR.
    IF AVAIL param-estoq AND
       SUBSTR(param-estoq.char-2,6,1) = "1" THEN DO:
        DO TRANS:
            FIND FIRST doc-fisico NO-LOCK
                WHERE doc-fisico.nro-docto    = pnro-docto
                AND   doc-fisico.serie-docto  = pserie
                AND   doc-fisico.tipo-nota    = ptipo-nota
                AND   doc-fisico.cod-emitente = pcod-emitente NO-ERROR.
            IF AVAIL doc-fisico THEN DO:
                IF doc-fisico.log-1 = YES THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="7183"
                                                &ErrorType="EMS"}
                    UNDO, RETURN "NOK":U.
                END.
                IF psequencia-item <> 0  THEN DO:
                    FOR EACH it-doc-fisico OF doc-fisico EXCLUSIVE-LOCK
                        WHERE it-doc-fisico.sequencia = psequencia-item:
                        ASSIGN it-doc-fisico.quant-conf = 0.
                    END.
                END.
                ELSE DO:
                    FOR EACH it-doc-fisico OF doc-fisico EXCLUSIVE-LOCK:
                        ASSIGN it-doc-fisico.quant-conf = 0.
                    END.
                END.
                IF NOT VALID-HANDLE(hdbosc075) THEN
                    RUN scbo/bosc075.p PERSISTENT SET hdbosc075.
                RUN openQueryStatic IN hdbosc075 (INPUT "Main":U) NO-ERROR. 
                RUN setConferenciaCarga IN hdbosc075 (INPUT doc-fisico.nro-docto,                  
                                                      INPUT doc-fisico.serie-docto,                
                                                      INPUT doc-fisico.tipo-nota,                  
                                                      INPUT doc-fisico.cod-emitente,               
                                                      INPUT doc-fisico.dt-trans,  
                                                      INPUT NO,
                                                      INPUT psequencia-item). 

                IF RETURN-VALUE = "OK":U THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-Reabertura AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Reabertura_da_Contagem" *}
                    ASSIGN c-lbl-liter-Reabertura = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="31481"
                                                &ErrorType="EMS"
                                                &ErrorParameters="c-lbl-liter-Reabertura"}
                END.
                IF VALID-HANDLE(hdbosc075) THEN 
                    DELETE OBJECT hdbosc075.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


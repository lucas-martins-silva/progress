&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V11IN295 2.00.00.029 } /*** "010029" 30/05/2025 16:42:56  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v11in295 MUT}
&ENDIF

/*------------------------------------------------------------------------
  File:
  Description: from VIEWER.W - Template for SmartViewer Objects
  Input Parameters: <none>
  Output Parameters:<none>
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{include/i-vrtab.i transporte}
{include/i-vrtab.i responsavel}
{include/i-vrtab.i moeda}

{cdp/cdcfgmat.i}

/* Parameters Definitions ---                                           */

/* Global Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE i-moeda-g AS INTEGER INITIAL 0             NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-conv-g  AS LOGICAL INITIAL YES           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE da-conv-g AS DATE    FORMAT "99/99/9999":U NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE da-date       AS   DATE                      NO-UNDO.
DEFINE VARIABLE de-preco-unit AS   DECIMAL                   NO-UNDO.
DEFINE VARIABLE de-indice     AS   DECIMAL                   NO-UNDO.
DEFINE VARIABLE i-qdt-ordens  AS   INTEGER FORMAT ">>>9":U   NO-UNDO.
DEFINE VARIABLE i-qdt-aberto  AS   INTEGER FORMAT ">>>9":U   NO-UNDO.
DEFINE VARIABLE l-aberto      AS   LOGICAL                   NO-UNDO.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES pedido-compr
&Scoped-define FIRST-EXTERNAL-TABLE pedido-compr


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pedido-compr.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS pedido-compr.responsavel 
&Scoped-define ENABLED-TABLES pedido-compr
&Scoped-define FIRST-ENABLED-TABLE pedido-compr
&Scoped-Define ENABLED-OBJECTS RECT-2 
&Scoped-Define DISPLAYED-FIELDS pedido-compr.responsavel 
&Scoped-define DISPLAYED-TABLES pedido-compr
&Scoped-define FIRST-DISPLAYED-TABLE pedido-compr
&Scoped-Define DISPLAYED-OBJECTS c-Envio de-aberto c-transporte de-atraso ~
c-origem i-qtd-ordens de-total i-qtd-aberto date-data-movto c-moeda ~
c-numero-nota 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-Envio AS CHARACTER FORMAT "X(10)":U 
     LABEL "Envio" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(10)":U 
     LABEL "Moeda" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-numero-nota AS CHARACTER FORMAT "X(16)":U 
     LABEL "Nota Ult Rec" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-origem AS CHARACTER FORMAT "X(10)":U 
     LABEL "Origem" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-transporte AS CHARACTER FORMAT "X(15)":U 
     LABEL "Transporte" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE date-data-movto AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Ult Rec" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-aberto AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Aberto" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-atraso AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Atraso" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-total AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Total" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-qtd-aberto AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Qtd Aberto" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-qtd-ordens AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Qtd Ordens" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.14 BY 5.29.


/* ************************  Frame Definitions  *********************** */
&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
DEFINE FRAME f-main
     de-aberto AT ROW 1.13 COL 67.72 COLON-ALIGNED
     c-Envio AT ROW 3.17 COL 41 COLON-ALIGNED
     pedido-compr.responsavel AT ROW 1.17 COL 14.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     c-transporte AT ROW 2.17 COL 14.29 COLON-ALIGNED
     c-origem AT ROW 4.17 COL 41 COLON-ALIGNED
     de-atraso AT ROW 2.17 COL 67.72 COLON-ALIGNED
     i-qtd-ordens AT ROW 3.17 COL 14.29 COLON-ALIGNED
     de-total AT ROW 3.17 COL 67.72 COLON-ALIGNED
     i-qtd-aberto AT ROW 4.17 COL 14.29 COLON-ALIGNED
     date-data-movto AT ROW 1.13 COL 41 COLON-ALIGNED
     c-moeda AT ROW 5.17 COL 14.29 COLON-ALIGNED
     c-numero-nota AT ROW 2.17 COL 41 COLON-ALIGNED
     RECT-2 AT ROW 1 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .
&ELSE
DEFINE FRAME f-main
     c-Envio AT ROW 1.13 COL 67.72 COLON-ALIGNED
     pedido-compr.responsavel AT ROW 1.17 COL 14.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     de-aberto AT ROW 1.17 COL 45 COLON-ALIGNED
     c-transporte AT ROW 2.17 COL 14.29 COLON-ALIGNED
     de-atraso AT ROW 2.17 COL 45 COLON-ALIGNED
     c-origem AT ROW 2.17 COL 67.72 COLON-ALIGNED
     i-qtd-ordens AT ROW 3.17 COL 14.29 COLON-ALIGNED
     de-total AT ROW 3.17 COL 45 COLON-ALIGNED
     i-qtd-aberto AT ROW 4.17 COL 14.29 COLON-ALIGNED
     date-data-movto AT ROW 4.17 COL 45 COLON-ALIGNED
     c-moeda AT ROW 5.17 COL 14.29 COLON-ALIGNED
     c-numero-nota AT ROW 5.17 COL 45 COLON-ALIGNED
     RECT-2 AT ROW 1 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .
&ENDIF

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.pedido-compr
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 5.58
         WIDTH              = 84.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-Envio IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-numero-nota IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-origem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-transporte IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN date-data-movto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-aberto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-atraso IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-qtd-aberto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-qtd-ordens IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

 {utp/ut-field.i mgind pedido-compr ind-via-envio 1}
  ASSIGN c-envio:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

 {utp/ut-field.i mgind pedido-compr ind-orig-entrada 1}
  ASSIGN c-origem:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "pedido-compr"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "pedido-compr"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &IF DEFINED(ADM-MODIFY-FIELDS) &THEN
      DISABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&FRAME-NAME}.
  &ENDIF
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */

    FIND LAST recebimento  
        WHERE recebimento.num-pedido = pedido-compr.num-pedido 
          AND recebimento.cod-movto = 1 NO-LOCK NO-ERROR.

    FIND FIRST emitente 
         WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK NO-ERROR.
    
    FIND FIRST transporte  
         WHERE transporte.cod-transp = pedido-compr.cod-transp NO-LOCK NO-ERROR.
    
    ASSIGN i-qtd-ordens = 0
           i-qtd-aberto = 0
           de-aberto    = 0
           de-total     = 0
           de-atraso    = 0.
    
    FOR EACH ordem-compra 
       WHERE ordem-compra.num-pedido = pedido-compr.num-pedido 
         AND ordem-compra.situacao  <> 4 NO-LOCK:
        
        ASSIGN i-qtd-ordens = i-qtd-ordens + 1
               l-aberto     = NO.
        
        FOR FIRST item FIELDS(it-codigo un)
            WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK:
        END.
        
        FOR EACH prazo-compra  
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
            
            IF prazo-compra.situacao = 4 THEN
                NEXT.
            
            IF l-conv-g THEN
                ASSIGN da-date = ordem-compra.data-cotacao.
            ELSE
                ASSIGN da-date = da-conv-g.

            FOR FIRST cotacao-item FIELDS(aliquota-ipi cot-aprovada cod-emitente it-codigo numero-ordem cod-emitente un codigo-ipi) 
                WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                  AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                  AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                  AND cotacao-item.cot-aprovada NO-LOCK:

                {cdp/cd9950.i item.un cotacao-item.un cotacao-item.cod-emitente} // retorna de-indice
            END.

            IF de-indice = 0 OR de-indice = ? THEN ASSIGN de-indice = 1.
            /* Pre‡o calculado por conta de arredondamento */
            IF AVAIL cotacao-item THEN DO:
                IF cotacao-item.codigo-ipi THEN // IPI Incluso
                    ASSIGN de-preco-unit = ordem-compra.preco-fornec * de-indice.
                ELSE
                    ASSIGN de-preco-unit = (ordem-compra.preco-fornec * (1 + (cotacao-item.aliquota-ipi / 100)) ) * de-indice.
            END.
            ELSE DO:
                ASSIGN de-preco-unit = 0.
            END.
            
            IF ordem-compra.mo-codigo <> i-moeda-g THEN 
               RUN cdp/cd0812.p (INPUT  ordem-compra.mo-codigo,
                                 INPUT  i-moeda-g,
                                 INPUT  de-preco-unit,
                                 INPUT  da-date,
                                 OUTPUT de-preco-unit).
            
            IF de-preco-unit = ? THEN 
               ASSIGN de-preco-unit = 0.
            
            ASSIGN de-total = de-total + ROUND((prazo-compra.quantidade * de-preco-unit),5).
            
            IF prazo-compra.quant-saldo > 0 AND ( prazo-compra.situacao <> 4 AND  prazo-compra.situacao <> 6) THEN
                ASSIGN l-aberto = YES
                       de-aberto = de-aberto + ROUND((prazo-compra.quant-saldo * de-preco-unit),5).
            
            /*Situa‡Æo:1- NÆo confirmada, 2- Confirmada, 3- Cotada, 4- Eliminada, 5- Em cota‡Æo, 6- Recebida */
            IF prazo-compra.data-entrega < TODAY AND prazo-compra.situacao = 2 THEN 
                ASSIGN de-atraso = de-atraso + ROUND((prazo-compra.quant-saldo * de-preco-unit),5).
        END.
        IF l-aberto THEN
            ASSIGN i-qtd-aberto = i-qtd-aberto + 1.
   END.
   
   IF de-atraso < 0 THEN
       ASSIGN de-atraso = 0.
   
   IF i-moeda-g = 0 THEN DO:
       {utp/ut-liter.i Corrente}
       ASSIGN c-moeda = TRIM(RETURN-VALUE).
   END.
   ELSE DO:

       FOR FIRST moeda  
           WHERE moeda.mo-codigo = i-moeda-g NO-LOCK:
           
           ASSIGN c-moeda = moeda.descricao.
       END.
   END.

   FIND FIRST transporte  
        WHERE transporte.cod-transp = pedido-compr.cod-transp NO-LOCK NO-ERROR.
   
   IF AVAIL transporte THEN 
       ASSIGN c-transporte = transporte.nome-abrev.
   ELSE
       ASSIGN c-transporte = "".

   DISP c-transporte WITH FRAME {&FRAME-NAME}.

  FIND LAST recebimento 
      WHERE recebimento.num-pedido = pedido-compr.num-pedido NO-LOCK NO-ERROR.

  IF AVAIL recebimento THEN DO:
      ASSIGN date-data-movto = recebimento.data-movto
             c-numero-nota   = recebimento.numero-nota.  
  END. 
  ELSE DO: 
     ASSIGN date-data-movto = ?
            c-numero-nota   = "".  
  END. 

  DISP date-data-movto
       c-numero-nota WITH FRAME {&FRAME-NAME}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  DO WITH FRAME {&FRAME-NAME}:

     RUN utp/ut-liter.p (INPUT {diinc/i07di159.i 04 pedido-compr.ind-via-envio}, INPUT "", INPUT "").

     ASSIGN c-envio:SCREEN-VALUE  = RETURN-VALUE.

     RUN utp/ut-liter.p (INPUT {diinc/i07di159.i 04 pedido-compr.ind-orig-entrada}, INPUT "", INPUT "").
     
     ASSIGN c-origem:SCREEN-VALUE = RETURN-VALUE.
  END.

  FIND FIRST param-global NO-LOCK NO-ERROR.

  IF CONNECTED("mgcex":U) AND param-global.modulo-07 AND (emitente.natureza = 3 OR emitente.natureza = 4) THEN DO:
      
      ASSIGN de-aberto:HIDDEN = YES
             de-atraso:HIDDEN = YES
             de-total:HIDDEN  = YES.
  END.
  ELSE DO:
      
      ASSIGN de-aberto:HIDDEN = NO
             de-atraso:HIDDEN = NO
             de-total:HIDDEN  = NO.

      DISP de-aberto
           de-atraso
           de-total WITH FRAME {&FRAME-NAME}.
  END.
  
  /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &IF DEFINED(ADM-MODIFY-FIELDS) &THEN
      ENABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&FRAME-NAME}.
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  {utp/ut-liter.i Transporte}
  ASSIGN c-transporte:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i Qtd_Ordens}
  ASSIGN i-qtd-ordens:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i Qtd_Aberto}
  ASSIGN i-qtd-aberto:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-field.i mgind pedido-compr i-moeda 1}
  ASSIGN c-moeda:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i Valor_Aberto}
  ASSIGN de-aberto:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i Valor_Atraso}
  ASSIGN de-atraso:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i Valor_Total}
  ASSIGN de-total:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i Data_Ult_Rec}
  ASSIGN date-data-movto:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i Nota_Ult_Rec}
  ASSIGN c-numero-nota:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i Envio}
  ASSIGN c-envio:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i Origem}
  ASSIGN c-origem:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  ASSIGN i-moeda-g = 0.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  FOR FIRST responsavel 
       WHERE pedido-compr.responsavel = responsavel.cod-resp NO-LOCK:

        ASSIGN gr-responsavel = ROWID(responsavel).
  END.

  FOR FIRST moeda 
      WHERE i-moeda-g = moeda.mo-codigo NO-LOCK:

        ASSIGN gr-moeda = rowid(moeda).
  END.

  FOR FIRST transporte
      WHERE transporte.cod-transp = pedido-compr.cod-transp NO-LOCK:
	  
          ASSIGN gr-transporte = rowid(transporte).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF  NOT FRAME {&FRAME-NAME}:VALIDATE() THEN
      RETURN 'ADM-ERROR':U.

  /* Ponha aqui a valida‡Æo de chave duplicada */

  /* Ponha aqui as demais valida‡äes */

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "pedido-compr"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


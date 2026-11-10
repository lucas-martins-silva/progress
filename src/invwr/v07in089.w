&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
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
{include/i-prgvrs.i V07IN089 2.00.00.013 } /*** "010013" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v07in089 MUT}
&ENDIF

    CREATE WIDGET-POOL.
    &Scop adm-attribute-dlg support/viewerd.w

    def var v-row-parent as rowid no-undo.

    {rep/re2001a.i}   /**  Temp-table tt-inicializa  **/
    {cdp/cd4300.i3}   /**  Variaveis para CD4300.I4  **/
    {cdp/cd0604.i50}  /**  Variaveis para CD0604     **/

    def new global shared var l-re1001a-inclui as logical no-undo.
    def new global shared var l-mudou-frete as logical no-undo.
    def new global shared var l-mudou-frete1 as logical no-undo.

    def var de-despesa-nota-it  as decimal no-undo init 0.
    def var de-tot-desconto-it  as decimal no-undo init 0.
    def var de-tot-peso-it      as decimal no-undo init 0.
    def var de-valor-mercad-it  as decimal no-undo init 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES doc-fisico
&Scoped-define FIRST-EXTERNAL-TABLE doc-fisico


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR doc-fisico.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS doc-fisico.tot-peso doc-fisico.tot-desconto ~
doc-fisico.despesa-nota doc-fisico.valor-mercad 
&Scoped-define ENABLED-TABLES doc-fisico
&Scoped-define FIRST-ENABLED-TABLE doc-fisico
&Scoped-Define ENABLED-OBJECTS RECT-3 rt-button FILL-IN-1 fi-tot-nota ~
fi-tot-itens fi-diferenca 
&Scoped-Define DISPLAYED-FIELDS doc-fisico.tot-peso doc-fisico.tot-desconto ~
doc-fisico.despesa-nota doc-fisico.valor-mercad 
&Scoped-define DISPLAYED-TABLES doc-fisico
&Scoped-define FIRST-DISPLAYED-TABLE doc-fisico
&Scoped-Define DISPLAYED-OBJECTS fi-tot-peso-it fi-tot-peso-dif ~
fi-tot-desconto-it fi-tot-desconto-dif fi-despesa-nota-it ~
fi-despesa-nota-dif fi-valor-mercad-it fi-valor-mercad-dif FILL-IN-1 ~
fi-tot-nota fi-tot-itens fi-diferenca 

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
DEFINE VARIABLE fi-despesa-nota-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-despesa-nota-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-diferenca AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 15.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-desconto-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-desconto-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-itens AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 23.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-nota AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 21.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-peso-dif AS DECIMAL FORMAT "->>>>,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-peso-it AS DECIMAL FORMAT "->>>>,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-valor-mercad-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-valor-mercad-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.86 BY 13.25.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 61.72 BY 1
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     doc-fisico.tot-peso AT ROW 6.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-tot-peso-it AT ROW 6.25 COL 38.57 COLON-ALIGNED NO-LABEL
     fi-tot-peso-dif AT ROW 6.25 COL 59.72 COLON-ALIGNED NO-LABEL
     doc-fisico.tot-desconto AT ROW 7.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-tot-desconto-it AT ROW 7.25 COL 38.57 COLON-ALIGNED NO-LABEL
     fi-tot-desconto-dif AT ROW 7.25 COL 59.72 COLON-ALIGNED NO-LABEL
     doc-fisico.despesa-nota AT ROW 8.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-despesa-nota-it AT ROW 8.25 COL 38.57 COLON-ALIGNED NO-LABEL
     fi-despesa-nota-dif AT ROW 8.25 COL 59.72 COLON-ALIGNED NO-LABEL
     doc-fisico.valor-mercad AT ROW 9.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-valor-mercad-it AT ROW 9.25 COL 38.57 COLON-ALIGNED NO-LABEL
     fi-valor-mercad-dif AT ROW 9.25 COL 59.72 COLON-ALIGNED NO-LABEL
     FILL-IN-1 AT ROW 5.08 COL 17.72 COLON-ALIGNED NO-LABEL
     fi-tot-nota AT ROW 5.08 COL 44.15 RIGHT-ALIGNED NO-LABEL
     fi-tot-itens AT ROW 5.08 COL 40.86 COLON-ALIGNED NO-LABEL
     fi-diferenca AT ROW 5.08 COL 63.57 COLON-ALIGNED NO-LABEL
     RECT-3 AT ROW 1 COL 1
     rt-button AT ROW 5 COL 19.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.doc-fisico
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
         HEIGHT             = 13.25
         WIDTH              = 85.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-despesa-nota-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-despesa-nota-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-desconto-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-desconto-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-nota IN FRAME f-main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-tot-peso-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-peso-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-mercad-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-mercad-it IN FRAME f-main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME doc-fisico.despesa-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.despesa-nota V-table-Win
ON LEAVE OF doc-fisico.despesa-nota IN FRAME f-main /* Despesas Nota */
DO:
    assign  fi-despesa-nota-dif:screen-value = string(input doc-fisico.despesa-nota  -
                                                      input fi-despesa-nota-it).         
    assign  fi-despesa-nota-dif:fgcolor =
                   if input frame {&frame-name} fi-despesa-nota-dif <> 0 then 12 else ?.                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME doc-fisico.tot-desconto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.tot-desconto V-table-Win
ON LEAVE OF doc-fisico.tot-desconto IN FRAME f-main /* Total Descto */
DO:
    assign  fi-tot-desconto-dif:screen-value = string(input doc-fisico.tot-desconto  -
                                                      input fi-tot-desconto-it).
    assign  fi-tot-desconto-dif:fgcolor =
                   if input frame {&frame-name} fi-tot-desconto-dif <> 0 then 12 else ?.                                                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME doc-fisico.tot-peso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.tot-peso V-table-Win
ON LEAVE OF doc-fisico.tot-peso IN FRAME f-main /* Peso Total */
DO:
    IF doc-fisico.tipo-nota = 3
    AND CAN-FIND(FIRST doc-orig-nfe 
                 WHERE doc-orig-nfe.idi-situacao  = 6  /* Digitada Receb. Fisico */
                   AND doc-orig-nfe.idi-orig-trad = 2
                   AND doc-orig-nfe.cod-emitente  = doc-fisico.cod-emitente
                   AND doc-orig-nfe.cod-estabel   = doc-fisico.cod-estabel
                   AND doc-orig-nfe.serie-docto   = doc-fisico.serie-docto
                   AND doc-orig-nfe.nro-docto     = doc-fisico.nro-docto
                   AND doc-orig-nfe.dt-emissao    = doc-fisico.dt-emissao) THEN DO:
        if fi-tot-peso-it:SCREEN-VALUE = "" then
            assign fi-tot-peso-it:screen-value = string(input doc-fisico.tot-peso). 

        assign fi-tot-peso-dif:screen-value     = string(input doc-fisico.tot-peso      -
                                                 input doc-fisico.tot-peso).
    END.
    ELSE
        assign fi-tot-peso-dif:screen-value     = string(input doc-fisico.tot-peso      -
                                                input fi-tot-peso-it).
   assign fi-tot-peso-dif:fgcolor          = 
                 if input frame {&frame-name} fi-tot-peso-dif <> 0 then 12 else ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME doc-fisico.valor-mercad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.valor-mercad V-table-Win
ON LEAVE OF doc-fisico.valor-mercad IN FRAME f-main /* Valor Total Merc */
DO:
   assign fi-valor-mercad-dif:screen-value = string(input doc-fisico.valor-mercad  -
                                                    input fi-valor-mercad-it).
   assign fi-valor-mercad-dif:fgcolor =
                   if input frame {&frame-name} fi-valor-mercad-dif <> 0 then 12 else ?.                                                    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
&ENDIF

    {utp/ut-liter.i Total_da_Nota MRE L}
    assign fi-tot-nota:screen-value in frame {&FRAME-NAME}  = return-value.

    {utp/ut-liter.i Total_dos_÷tens MRE L}
    assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

    {utp/ut-liter.i Diferenáa MRE L}
    assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.

    find param-re where
        param-re.usuario = c-seg-usuario
        no-lock no-error.

    find first param-global
        no-lock no-error.

    find first param-fasb where
        param-fasb.ep-codigo = param-global.empresa-prin
        no-lock no-error.

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
  {src/adm/template/row-list.i "doc-fisico"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "doc-fisico"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    {utp/ut-liter.i Total_da_Nota MRE L}
    assign fi-tot-nota:screen-value in frame {&FRAME-NAME}  = return-value.

    {utp/ut-liter.i Total_dos_÷tens MRE L}
    assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

    {utp/ut-liter.i Diferenáa MRE L}
    assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

    {include/i-valid.i}

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then
        return 'ADM-ERROR':U.

    /**  Se for inclus∆o, os campos despesa-nota,tot-desconto,
    ***  valor-mercad,tot-peso ser∆o atualizados a partir dos
    ***  valores informados na viewer v16in090.w
    **/
    if l-re1001a-inclui then
        RUN pi-atualiza-totais.

    if l-re1001a-inclui = no then do with frame {&FRAME-NAME}:

        /**  Diferenca no Peso Total
        **/
        run rep/re8885.p (input rowid(doc-fisico),
                          input input fi-tot-peso-it,
                          input input doc-fisico.tot-peso,
                          input 5501,
                          input input fi-tot-peso-dif = 0, /**  Se for igual elimina sen∆o cria  **/
                          input 0,                         /**  Zero para erros do documento     **/
                          input 1).                        /**  Erro                             **/

        /**  Diferenca no Total de Desconto
        **/
        run rep/re8885.p (input rowid(doc-fisico),
                          input input fi-tot-desconto-it,
                          input input doc-fisico.tot-desconto,
                          input 5511,
                          input input fi-tot-desconto-dif = 0, /**  Se for igual a zero elimina sen∆o cria  **/
                          input 0,                             /**  Zero para erros do documento            **/
                          input 1).                            /**  Erro                                    **/

        /**  Diferenca no Total das Despesas
        **/
        run rep/re8885.p (input rowid(doc-fisico),
                          input input fi-despesa-nota-it,
                          input input doc-fisico.despesa-nota,
                          input 5500,
                          input input fi-despesa-nota-dif = 0, /**  Se for igual a zero elimina sen∆o cria  **/
                          input 0,                             /**  Zero para erros do documento            **/
                          input 1).                            /**  Erro                                    **/

        /**  Diferenca no valor das Mercadorias
        **/
        run rep/re8885.p (input rowid(doc-fisico),
                          input input fi-valor-mercad-it,
                          input input doc-fisico.valor-mercad,
                          input 5502,
                          input input fi-valor-mercad-dif = 0, /**  Se for igual a zero elimina sen∆o cria  **/
                          input 0,                             /**  Zero para erros do documento            **/
                          input 1).                            /**  Erro                                    **/

    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    {utp/ut-liter.i Total_da_Nota MRE L}
    assign fi-tot-nota:screen-value in frame {&FRAME-NAME}  = return-value.

    {utp/ut-liter.i Total_dos_÷tens MRE L}
    assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

    {utp/ut-liter.i Diferenáa MRE L}
    assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.

    if l-re1001a-inclui = no and
        avail doc-fisico then do with frame {&FRAME-NAME}:
        assign fi-despesa-nota-it:screen-value  = string(de-despesa-nota-it)
               fi-tot-desconto-it:screen-value  = string(de-tot-desconto-it)
               fi-tot-peso-it:screen-value      = string(de-tot-peso-it)
               fi-valor-mercad-it:screen-value  = string(de-valor-mercad-it)
               fi-tot-peso-it                   = de-tot-peso-it.
        
        IF  doc-fisico.tipo-nota        = 3
        AND fi-tot-peso-it:SCREEN-VALUE = "" 
        AND CAN-FIND(FIRST doc-orig-nfe 
                     WHERE doc-orig-nfe.idi-situacao  = 6  /* Digitada Receb. Fisico */
                       AND doc-orig-nfe.idi-orig-trad = 2
                       AND doc-orig-nfe.cod-emitente  = doc-fisico.cod-emitente
                       AND doc-orig-nfe.cod-estabel   = doc-fisico.cod-estabel
                       AND doc-orig-nfe.serie-docto   = doc-fisico.serie-docto
                       AND doc-orig-nfe.nro-docto     = doc-fisico.nro-docto
                       AND doc-orig-nfe.dt-emissao    = doc-fisico.dt-emissao) THEN
            ASSIGN fi-tot-peso-it:SCREEN-VALUE = STRING(INPUT doc-fisico.tot-peso)
                   de-tot-peso-it              = doc-fisico.tot-peso. 

        RUN pi-calculo-diferenca.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    IF adm-new-record THEN DO:       
        ASSIGN doc-fisico.tot-peso    :screen-value in frame {&FRAME-NAME} = string(0)
               doc-fisico.tot-desconto:screen-value in frame {&FRAME-NAME} = string(0)      
               doc-fisico.despesa-nota:screen-value in frame {&FRAME-NAME} = string(0)      
               doc-fisico.valor-mercad:SCREEN-VALUE in frame {&FRAME-NAME} = string(0).
    END.

    {utp/ut-liter.i Total_da_Nota MRE L}
    assign fi-tot-nota:screen-value in frame {&FRAME-NAME}  = return-value.

    {utp/ut-liter.i Total_dos_÷tens MRE L}
    assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

    {utp/ut-liter.i Diferenáa MRE L}
    assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.

    do with frame {&FRAME-NAME}:
        assign doc-fisico.tot-peso:sensitive       = no
               doc-fisico.tot-desconto:sensitive   = no
               doc-fisico.despesa-nota:sensitive   = no
               doc-fisico.valor-mercad:sensitive   = no.
    end.

    if l-re1001a-inclui = no and
        avail doc-fisico then
        run pi-habilita-campos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit V-table-Win 
PROCEDURE local-exit :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'exit':U ) .

  assign l-mudou-frete1 = no.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-docto V-table-Win 
PROCEDURE pi-atualiza-docto :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    do with frame {&FRAME-NAME}:

        if input doc-fisico.tot-peso      = 0 then
            assign doc-fisico.tot-peso:screen-value      = fi-tot-peso-it:screen-value.
        if input doc-fisico.tot-desconto  = 0 then
            assign doc-fisico.tot-desconto:screen-value  = fi-tot-desconto-it:screen-value .
        if input doc-fisico.despesa-nota  = 0 then
            assign doc-fisico.despesa-nota:screen-value  = fi-despesa-nota-it:screen-value .
        if input doc-fisico.valor-mercad  = 0 then
            assign doc-fisico.valor-mercad:screen-value  = fi-valor-mercad-it:screen-value .

        /* Se o Rateia Descto Total desmarcado ent∆o recalcula o desconto com o informado nos itens */
        IF param-re.rateia-desc = NO THEN
            ASSIGN doc-fisico.tot-desconto:SCREEN-VALUE = fi-tot-desconto-it:SCREEN-VALUE.

    end.

    /*****run pi-atualiza-docto in h_v18in090 (input de-icm-fonte).*****/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    define input parameter v-row-parent-externo as rowid no-undo.

    assign v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-totais V-table-Win 
PROCEDURE pi-atualiza-totais :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    RUN pi-retorna-totais IN h_v06in089
        (output table tt-inicializa).

    find first tt-inicializa
        no-error.

    assign doc-fisico.despesa-nota  = tt-inicializa.despesa-nota
           doc-fisico.tot-peso      = tt-inicializa.tot-peso
           doc-fisico.tot-desconto  = tt-inicializa.tot-desconto
           doc-fisico.valor-mercad  = tt-inicializa.valor-mercad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calculo-diferenca V-table-Win 
PROCEDURE pi-calculo-diferenca :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    do with frame {&FRAME-NAME}:

        assign fi-tot-peso-dif:screen-value     = IF  doc-fisico.tipo-nota        = 3
                                                  AND CAN-FIND(FIRST doc-orig-nfe 
                                                               WHERE doc-orig-nfe.idi-situacao  = 6  /* Digitada Receb. Fisico */
                                                                 AND doc-orig-nfe.idi-orig-trad = 2
                                                                 AND doc-orig-nfe.cod-emitente  = doc-fisico.cod-emitente
                                                                 AND doc-orig-nfe.cod-estabel   = doc-fisico.cod-estabel
                                                                 AND doc-orig-nfe.serie-docto   = doc-fisico.serie-docto
                                                                 AND doc-orig-nfe.nro-docto     = doc-fisico.nro-docto
                                                                 AND doc-orig-nfe.dt-emissao    = doc-fisico.dt-emissao) THEN 
                                                       string(input doc-fisico.tot-peso - input doc-fisico.tot-peso)
                                                  ELSE string(input doc-fisico.tot-peso - input fi-tot-peso-it)
               fi-tot-desconto-dif:screen-value = string(input doc-fisico.tot-desconto  -
                                                         input fi-tot-desconto-it)
               fi-despesa-nota-dif:screen-value = string(input doc-fisico.despesa-nota  -
                                                         input fi-despesa-nota-it)
               fi-valor-mercad-dif:screen-value = string(input doc-fisico.valor-mercad  -
                                                         input fi-valor-mercad-it).
        assign fi-tot-peso-dif:fgcolor =
                    if input frame {&frame-name} fi-tot-peso-dif <> 0 then 12 else ?
               fi-tot-desconto-dif:fgcolor =
                    if input frame {&frame-name} fi-tot-desconto-dif <> 0 then 12 else ?
               fi-despesa-nota-dif:fgcolor =
                    if input frame {&frame-name} fi-despesa-nota-dif <> 0 then 12 else ?
               fi-valor-mercad-dif:fgcolor =
                    if input frame {&frame-name} fi-valor-mercad-dif <> 0 then 12 else ?.

    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos V-table-Win 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    do with frame {&FRAME-NAME}:

        assign doc-fisico.tot-peso:sensitive       = yes
               doc-fisico.tot-desconto:sensitive   = yes
               doc-fisico.valor-mercad:sensitive   = yes.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campos V-table-Win 
PROCEDURE pi-inicializa-campos :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input param table for tt-inicializa.

    find first tt-inicializa
        no-error.

    if tt-inicializa.despesa-nota <> ? then do with frame {&FRAME-NAME}:
        assign doc-fisico.despesa-nota:screen-value = string(tt-inicializa.despesa-nota).
        apply 'leave'  to doc-fisico.despesa-nota.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-totais V-table-Win 
PROCEDURE pi-retorna-totais :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def output param table for tt-inicializa.

    run pi-recria-tt-inicializa.

    assign tt-inicializa.despesa-nota = input frame {&FRAME-NAME} doc-fisico.despesa-nota
           tt-inicializa.tot-peso     = input frame {&FRAME-NAME} doc-fisico.tot-peso
           tt-inicializa.tot-desconto = input frame {&FRAME-NAME} doc-fisico.tot-desconto
           tt-inicializa.valor-mercad = input frame {&FRAME-NAME} doc-fisico.valor-mercad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-total-item V-table-Win 
PROCEDURE pi-total-item :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input param rw-doc-fisico as rowid no-undo.
    def var valor-frete-aux like doc-fisico.valor-frete no-undo.

    /**  Totalizacao dos Itens
    **/
    find doc-fisico where
        rowid(doc-fisico) = rw-doc-fisico
        exclusive-lock no-error.

    do with frame {&FRAME-NAME}:
        /*****8900*****/
        for each it-doc-fisico
            use-index documento where
            it-doc-fisico.serie-docto  = doc-fisico.serie-docto  and
            it-doc-fisico.nro-docto    = doc-fisico.nro-docto    and
            it-doc-fisico.tipo-nota    = doc-fisico.tipo-nota    and
            it-doc-fisico.cod-emitente = doc-fisico.cod-emitente
            exclusive-lock:

            accum it-doc-fisico.peso-liquido   (total).
            accum it-doc-fisico.desconto[1]    (total).
            accum it-doc-fisico.despesas[1]    (total).
            accum it-doc-fisico.preco-total[1] (total).
            accum it-doc-fisico.vl-frete       (total).

            assign fi-tot-peso-it:screen-value      = string(accum total it-doc-fisico.peso-liquido)
                   fi-tot-desconto-it:screen-value  = string(accum total it-doc-fisico.desconto[1])
                   fi-despesa-nota-it:screen-value  = string(accum total it-doc-fisico.despesas[1])
                   fi-valor-mercad-it:screen-value  = string(accum total it-doc-fisico.preco-total[1])
                   de-despesa-nota-it               = accum total it-doc-fisico.despesas[1]
                   de-tot-desconto-it               = accum total it-doc-fisico.desconto[1]
                   de-tot-peso-it                   = accum total it-doc-fisico.peso-liquido
                   de-valor-mercad-it               = accum total it-doc-fisico.preco-total[1]
                   fi-tot-peso-it                   = accum total it-doc-fisico.peso-liquido.

            IF  doc-fisico.tipo-nota        = 3
            AND fi-tot-peso-it:SCREEN-VALUE = "" 
            AND CAN-FIND(FIRST doc-orig-nfe 
                         WHERE doc-orig-nfe.idi-situacao  = 6  /* Digitada Receb. Fisico */
                           AND doc-orig-nfe.idi-orig-trad = 2
                           AND doc-orig-nfe.cod-emitente  = doc-fisico.cod-emitente
                           AND doc-orig-nfe.cod-estabel   = doc-fisico.cod-estabel
                           AND doc-orig-nfe.serie-docto   = doc-fisico.serie-docto
                           AND doc-orig-nfe.nro-docto     = doc-fisico.nro-docto
                           AND doc-orig-nfe.dt-emissao    = doc-fisico.dt-emissao) THEN
                assign fi-tot-peso-it:screen-value = string(input doc-fisico.tot-peso)
                       it-doc-fisico.peso-liquido  = doc-fisico.tot-peso.
            
            if  l-mudou-frete = yes then
                valor-frete-aux  = accum total it-doc-fisico.vl-frete.

            if  l-mudou-frete1 = yes then
                valor-frete-aux  = accum total it-doc-fisico.vl-frete.
        end.

        if  l-mudou-frete = yes and 
            doc-fisico.valor-frete = 0 then
            assign doc-fisico.valor-frete = valor-frete-aux.

        if  l-mudou-frete1 = yes and
            doc-fisico.valor-frete = 0 then       
            assign  doc-fisico.valor-frete = valor-frete-aux.  

        if  l-mudou-frete1 = yes and
            doc-fisico.valor-outras = 0 then do:
            assign  doc-fisico.valor-outras =  doc-fisico.despesa-nota
                                            - (valor-frete-aux 
                                            +  doc-fisico.valor-seguro).  
        end.
    end. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro
  ainda n∆o foi criado.
------------------------------------------------------------------------------*/

    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

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
  {src/adm/template/snd-list.i "doc-fisico"}

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


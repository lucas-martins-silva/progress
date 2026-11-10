&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V01AD176 2.00.01.046 } /*** "010146" 25/06/2025 16:21:12 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01AD176 MUT}
&ENDIF




/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-opcao      as char    no-undo.

/*************Multiplanta********************/
def var i-tipo-movto as integer no-undo.

{utp/ut-glob.i}
{cdp/cd7300.i1}
{cdp/cdapi227.i}
/************Fim*****************************/

{bhp/bh9999.i1}

def var h-menu             as handle no-undo.
def var h-ind-encomenda    as handle no-undo.
def var h-frete-auto       as handle no-undo. 
def var h-Ret-icms         as handle no-undo.
def var h-Diferimento      as handle no-undo. 
def var h-Produtor         as handle no-undo.
def var h-Devol-comp       as handle no-undo.
def var h-Benef-Consig     as handle NO-UNDO. 
def var h-Deposito-Armazem as handle NO-UNDO. 
def var h-Triangular       as handle NO-UNDO. 
def var h-diversos         as handle NO-UNDO.
def var h-Ajuste           as handle NO-UNDO.  
def VAR h-Tributos         as handle NO-UNDO.
def var h-menu-item-var-01 as handle no-undo.
def var h-menu-item-var-02 as handle no-undo.
def var h-menu-item-var-03 as handle no-undo.
def var h-menu-item-var-04 as handle no-undo.
def var h-menu-item-var-05 as handle no-undo.
def var h-menu-item-var-06 as handle no-undo.
def var h-menu-item-var-07 as handle no-undo.
def var h-menu-item-var-08 as handle no-undo.
def var h-menu-item-var-09 as handle no-undo.
def var h-menu-item-var-10 as handle no-undo.
def var h-menu-item-var-11 as handle no-undo.
def var h-menu-item-var-12 as handle no-undo.
def var h-menu-item-var-13 as handle no-undo.
def var h-menu-item-var-14 as handle no-undo.
def var h-menu-item-var-15 as handle no-undo.
def var h-menu-item-var-16 as handle no-undo.
def var h-menu-item-var-17 as handle no-undo.
def var h-menu-item-var-18 as handle no-undo.
def var h-menu-item-var-19 as handle no-undo.
def var h-menu-item-var-20 as handle no-undo.
def var h-menu-item-var-21 as handle no-undo.
def var h-menu-item-var-22 as handle no-undo.
def var h-menu-item-var-23 as handle no-undo.
def var h-menu-item-var-26 as handle no-undo.
def var h-menu-item-var-27 as handle no-undo.
def var h-menu-item-var-28 as handle no-undo.
def var h-menu-item-var-29 as handle no-undo.

def var h-menu-item-var-31 as handle no-undo.
def var h-menu-item-var-32 as handle no-undo.
def var h-menu-item-var-33 as handle no-undo.
def var h-menu-item-var-34 as handle no-undo.
def var h-menu-item-var-35 as handle no-undo.
def var h-menu-item-var-36 as handle no-undo.
def var h-menu-item-var-37 as handle no-undo.
def var h-menu-item-var-38 as handle no-undo.
def var h-menu-item-var-39 as handle no-undo.
def var h-menu-item-var-40 as handle no-undo.
def var h-menu-item-var-44 as handle no-undo.
def var h-menu-item-var-45 as handle no-undo.
def var h-menu-item-var-46 as handle no-undo.
def var h-menu-item-var-47 as handle no-undo.
def var h-menu-item-var-48 as handle no-undo.
def var h-menu-item-var-49 as handle no-undo.
def var h-menu-item-var-50 as handle no-undo.
def var h-menu-item-var-51 as handle no-undo.
def var h-menu-item-var-52 as handle no-undo.
def var h-menu-item-var-53 as handle no-undo.
def var h-menu-item-var-54 as handle no-undo.
def var h-menu-item-var-55 as handle no-undo.
def var h-menu-item-var-56 as handle no-undo.
def var h-menu-item-var-57 as handle no-undo.
def var h-menu-item-var-58 as handle no-undo.
def var h-menu-item-var-59 as handle no-undo.
def var h-menu-item-var-60 as handle no-undo.
def var h-menu-item-var-61 as handle no-undo.
def var h-menu-item-var-62 as handle no-undo.
def var h-menu-item-var-63 as handle no-undo.
def var h-menu-item-var-64 as handle no-undo.
def var h-menu-item-var-65 as handle no-undo.
def var h-menu-item-var-66 as handle no-undo.
def var h-menu-item-var-67 as handle no-undo.
def var h-menu-item-var-68 as handle no-undo.
def var h-menu-item-var-69 as handle no-undo.
def var h-menu-item-var-70 as handle no-undo.
def var h-menu-item-var-71 as handle no-undo.
def var h-menu-item-var-72 as handle no-undo.
def var h-menu-item-var-73 as handle no-undo.
def var h-menu-item-var-74 as handle no-undo.
def var h-menu-item-var-75 as handle no-undo.
def var h-menu-item-var-76 as handle no-undo.

def var h-menu-item-rule-01 as handle no-undo.
def var h-menu-item-rule-02 as handle no-undo.
def var h-menu-item-rule-03 as handle no-undo.
def var h-menu-item-rule-04 as handle no-undo.
def var h-menu-item-rule-05 as handle no-undo.
def var h-menu-item-rule-06 as handle no-undo.
def var h-menu-item-rule-07 as handle no-undo.
def var h-menu-item-rule-08 as handle no-undo.
def var h-menu-item-rule-09 as handle no-undo.
def var h-menu-item-rule-10 as handle no-undo.
def var h-menu-item-rule-11 as handle no-undo.
def var h-menu-item-rule-12 as handle no-undo.
def var h-menu-item-rule-13 as handle no-undo.
def var h-menu-item-rule-14 as handle no-undo.
def var h-menu-item-rule-15 as handle no-undo.

def var l-texto-habilitado as logical initial no no-undo.
def var l-seta-mensagens   as logical initial no no-undo.
def var l-montar-menu      as logical initial no no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES mensagem
&Scoped-define FIRST-EXTERNAL-TABLE mensagem


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR mensagem.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS mensagem.descricao mensagem.log-2 
&Scoped-define ENABLED-TABLES mensagem
&Scoped-define FIRST-ENABLED-TABLE mensagem
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-7 
&Scoped-Define DISPLAYED-FIELDS mensagem.cod-mensagem mensagem.descricao ~
mensagem.log-2 mensagem.texto-mensag 
&Scoped-define DISPLAYED-TABLES mensagem
&Scoped-define FIRST-DISPLAYED-TABLE mensagem

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS mensagem.cod-mensagem ~
mensagem.texto-mensag mensagem.log-2
&Scoped-define ADM-ASSIGN-FIELDS mensagem.texto-mensag mensagem.log-2 
&Scoped-define ADM-MODIFY-FIELDS mensagem.texto-mensag mensagem.log-2

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
DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 1.33.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 8.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     mensagem.cod-mensagem AT ROW 1.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     mensagem.descricao AT ROW 3.17 COL 20.14 COLON-ALIGNED FORMAT "X(20)"
          VIEW-AS FILL-IN 
          SIZE 20.57 BY 1
     mensagem.log-2 AT ROW 3.17 COL 51.71 HELP
          "Mensagem Fiscal a ser gerada no campo infAdFisco (NF-e)"
          LABEL "Mensagem Fiscal"
          VIEW-AS TOGGLE-BOX
          SIZE 20.29 BY .83
     mensagem.texto-mensag AT ROW 4.5 COL 6 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
          SIZE 80 BY 6.5
          FONT 1
     RECT-6 AT ROW 1.25 COL 2
     RECT-7 AT ROW 2.88 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.mensagem
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 10.42
         WIDTH              = 89.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN mensagem.cod-mensagem IN FRAME F-Main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN mensagem.descricao IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR TOGGLE-BOX mensagem.log-2 IN FRAME F-Main
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR EDITOR mensagem.texto-mensag IN FRAME F-Main
   NO-ENABLE 1 2 3                                                      */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

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
  {src/adm/template/row-list.i "mensagem"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "mensagem"}

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
  HIDE FRAME F-Main.
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

  /* Code placed here will execute PRIOR to standard behavior. */
            
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  find last mensagem no-lock no-error.
  if  avail mensagem and mensagem.cod-mensagem < 999 then
      disp (mensagem.cod-mensagem + 1)
          @ mensagem.cod-mensagem with frame {&frame-name}.
  assign c-opcao = "incluir".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  assign c-opcao = " ".

  if input frame {&frame-name} mensagem.cod-mensagem = 0 then do:
     {utp/ut-table.i mgadm mensagem 1}
     run utp/ut-msgs.p (input "show", input 36, input return-value).
     APPLY "ENTRY" TO MENSAGEM.COD-MENSAGEM IN FRAME {&FRAME-NAME}.
     RETURN "ADM-ERROR":U.
  end.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /********************Multiplanta***********************/
  assign c-transacao = "ADM023".
  {cdp/cd7300.i5 "001" c-transacao}

  assign i-tipo-movto = if mensagem.cod-mensagem:sensitive in frame {&frame-name} = yes
                           then 1 else 2.

  run pi-cria-tt-dados (input i-tipo-movto).

  {cdp/cd7300.i6 "001" c-transacao}
  /******************Fim-Multiplanta********************/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  assign c-opcao = " ".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record:
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST natur-oper 
         WHERE natur-oper.cod-mensagem = mensagem.cod-mensagem NO-LOCK NO-ERROR.
    IF AVAIL natur-oper THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-mensagem AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Mensagem" *}
        ASSIGN c-lbl-liter-mensagem = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-natureza-de-operac AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Natureza_de_Opera‡Æo" *}
        ASSIGN c-lbl-liter-natureza-de-operac = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p(INPUT "show", INPUT 5 , INPUT c-lbl-liter-mensagem + "~~" + c-lbl-liter-natureza-de-operac).
        
        RETURN "ADM-ERROR".
    END.

    /* se tiver cadastro no programa HTML Relacionamento x Mensagem */
    FIND FIRST sit-tribut-relacto
         WHERE sit-tribut-relacto.cdn-tribut = 27
           AND sit-tribut-relacto.cdn-sit-tribut = mensagem.cod-mensagem NO-LOCK NO-ERROR.

    IF AVAIL sit-tribut-relacto THEN DO:
        DEFINE VARIABLE c-lbl-liter-cadastro-mensagem AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "O_registro" *}
        ASSIGN c-lbl-liter-cadastro-mensagem = TRIM(RETURN-VALUE).
        
        DEFINE VARIABLE c-lbl-liter-programa-rel-mensagem AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "o_programa_HTML_de_Relacionamento_x_Mensagem" *}
        ASSIGN c-lbl-liter-programa-rel-mensagem = TRIM(RETURN-VALUE).
        
        RUN utp/ut-msgs.p(INPUT "show", INPUT 8699, INPUT c-lbl-liter-cadastro-mensagem + "~~" + c-lbl-liter-programa-rel-mensagem).
        RETURN "ADM-ERROR".
    END.

    FIND FIRST param-compra NO-LOCK NO-ERROR.
    IF AVAIL param-compra AND 
             param-compra.cod-mensagem = mensagem.cod-mensagem THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-mensagem-compras AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Mensagem" *}
        ASSIGN c-lbl-liter-mensagem-compras = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-param-compras AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Parƒmetros_de_Compras" *}
        ASSIGN c-lbl-liter-param-compras = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p(INPUT "show", INPUT 5 , INPUT c-lbl-liter-mensagem-compras + "~~" + c-lbl-liter-param-compras).
        
        RETURN "ADM-ERROR".
    END.
/*****[ BANCOS HISTàRICOS ]**********************************************************************************/
    if  not available(param-global) then
        find first param-global no-lock no-error.
    
    if  param-global.modulo-bh = yes
    then do:
        {bhp/bh9999.i 1 Messagem mensagem.cod-mensagem '' '' '' '' ''}
        if  return-value <> "OK"
        then return "ADM-ERROR".
    end.
/************************************************************************************************************/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  
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
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  if  l-montar-menu then
      run pi-seta-mensagens (input no,
                             input yes).
  
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
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  if  l-montar-menu then
      run pi-seta-mensagens (input yes,
                             input yes).

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
  assign c-opcao = " ".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-reset-record V-table-Win 
PROCEDURE local-reset-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'reset-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if  c-opcao = "incluir" then 
      RUN dispatch IN THIS-PROCEDURE ('add-record':U).

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
  assign c-opcao = " ".
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a valida‡Æo de chave duplicada */
  DO WITH FRAME {&FRAME-NAME}:
     IF  mensagem.cod-mensagem:SENSITIVE IN FRAME {&FRAME-NAME} = yes
     AND CAN-FIND(mensagem
            WHERE mensagem.cod-mensagem = INTEGER(mensagem.cod-mensagem:SCREEN-VALUE)) THEN DO:
         {utp/ut-table.i mgadm mensagem 1}
         run utp/ut-msgs.p (input "show", input 1, input return-value).
         APPLY "ENTRY" TO MENSAGEM.COD-MENSAGEM IN FRAME {&FRAME-NAME}.
         RETURN "ADM-ERROR":U.
     END.
  END.

  /* Ponha aqui as demais valida‡äes */
  IF INPUT FRAME {&FRAME-NAME} MENSAGEM.DESCRICAO = "" THEN DO:
     RUN UTP/UT-MSGS.P (INPUT "SHOW", INPUT 190, input "").
     apply 'entry' to mensagem.descricao in frame {&frame-name}.
     return 'adm-error':U.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter i-tipo-movto as integer.

    if  param-global.modulo-mp
    and tt-replica-msg.log-replica-msg  = yes then do:
        create tt-mensagem-aux.
        buffer-copy mensagem to tt-mensagem-aux.
        create tt-dados-env.
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 70
               tt-dados-env.ind-tipo-movto = i-tipo-movto
               tt-dados-env.identif-msg    = string(mensagem.cod-mensagem).
        raw-transfer tt-mensagem-aux to tt-dados-env.conteudo-msg.
        assign i-seq = i-seq + 1.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-codigo V-table-Win 
PROCEDURE pi-grava-codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param c-codigo-mensagem as char no-undo.

if  mensagem.texto-mensag:insert-string(c-codigo-mensagem) in frame {&frame-name} then.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-mensagens V-table-Win 
PROCEDURE pi-seta-mensagens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-l-seta-mensagens as logical no-undo.
def input param p-l-montar-menu    as logical no-undo.

assign l-seta-mensagens = p-l-seta-mensagens
       l-montar-menu    = p-l-montar-menu.

if  l-seta-mensagens then do:

    create menu h-menu
        assign popup-only = yes
               sensitive  = yes.

    /* Inicio Menu Dep¢sito Fechado/Armaz‚m Geral */
    create SUB-MENU h-Deposito-Armazem
        assign label     = "Dep¢sito Fechado/Armaz‚m Geral"
               name      = 'Deposito-Armazem'
               parent    = h-menu.       
  
    {utp/ut-liter.i "S‚rie da Nota Fiscal Remessa Dep¢sito Fechado/Armaz‚m Geral (##64)"}

    create menu-item h-menu-item-var-64
        assign label     = trim(return-value)
               name      = 'Menu-Item-##64'
               parent    = h-Deposito-Armazem
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##64").
        end.

    {utp/ut-liter.i "Nr da Nota Fiscal Remessa Dep¢sito Fechado/Armaz‚m Geral (##20)"}

    create menu-item h-menu-item-var-20
        assign label     = trim(return-value)
               name      = 'Menu-Item-##20'
               parent    = h-Deposito-Armazem
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##20").
        end.
    
    {utp/ut-liter.i "Data da Nota Fiscal Remessa Dep¢sito Fechado/Armaz‚m Geral (##21)"}

    create menu-item h-menu-item-var-21
        assign label     = trim(return-value)
               name      = 'Menu-Item-##21'
               parent    = h-Deposito-Armazem
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##21").
        end.

    {utp/ut-liter.i "Nome do Cliente Nota Fiscal de Venda (##65)"}

    create menu-item h-menu-item-var-65
        assign label     = trim(return-value)
               name      = 'Menu-Item-##65'
               parent    = h-Deposito-Armazem
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##65").
        end.

    {utp/ut-liter.i "Endere‡o do Cliente Nota Fiscal de Venda (##66)"}

    create menu-item h-menu-item-var-66
        assign label     = trim(return-value)
               name      = 'Menu-Item-##66'
               parent    = h-Deposito-Armazem
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##66").
        end.

    {utp/ut-liter.i "Inscri‡Æo Estadual do Cliente Nota Fiscal de Venda (##67)"}

    create menu-item h-menu-item-var-67
        assign label     = trim(return-value)
               name      = 'Menu-Item-##67'
               parent    = h-Deposito-Armazem
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##67").
        end.

    {utp/ut-liter.i "CNPJ do Cliente Nota Fiscal de Venda (##68)"}

    create menu-item h-menu-item-var-68
        assign label     = trim(return-value)
               name      = 'Menu-Item-##68'
               parent    = h-Deposito-Armazem
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##68").
        end.

    {utp/ut-liter.i "Data da Sa¡da da Mercadoria (##69)"}

    create menu-item h-menu-item-var-69
        assign label     = trim(return-value)
               name      = 'Menu-Item-##69'
               parent    = h-Deposito-Armazem
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##69").
        end.

    {utp/ut-liter.i "Nr da Nota Fiscal de Venda (##70)"}

    create menu-item h-menu-item-var-70
        assign label     = trim(return-value)
               name      = 'Menu-Item-##70'
               parent    = h-Deposito-Armazem
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##70").
        end.

    {utp/ut-liter.i "S‚rie da Nota Fiscal de Venda (##71)"}

    create menu-item h-menu-item-var-71
        assign label     = trim(return-value)
               name      = 'Menu-Item-##71'
               parent    = h-Deposito-Armazem
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##71").
        end.

    {utp/ut-liter.i "Data da EmissÆo da Nota Fiscal de Venda (##72)"}

    create menu-item h-menu-item-var-72
        assign label     = trim(return-value)
               name      = 'Menu-Item-##72'
               parent    = h-Deposito-Armazem
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##72").
        end.

    /* Fim Menu Dep¢sito Fechado/Armaz‚m Geral */

    /* Inicio Menu Beneficiamento/Consigna‡Æo */
    create SUB-MENU h-Benef-Consig
        assign label     = "Beneficiamento/Consigna‡Æo"
               name      = 'Benef-Consig'
               parent    = h-menu.

    {utp/ut-liter.i "N£mero da Nota Fiscal de Remessa de Entrega Futura (##01)"}

    create menu-item h-menu-item-var-01
        assign label     = trim(return-value)
               name      = 'Menu-Item-##01'
               parent    = h-Benef-Consig
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##01").
        end.
    
    {utp/ut-liter.i "Data da Nota Fiscal de Remessa de Entrega Futura (##02)"}

    create menu-item h-menu-item-var-02
        assign label     = trim(return-value)
               name      = 'Menu-Item-##02'
               parent    = h-Benef-Consig
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##02").
        end.

    {utp/ut-liter.i "Data da Nota Fiscal de Faturamento de Consigna‡Æo Mercantil (##16)"}

    create menu-item h-menu-item-var-16
        assign label     = trim(return-value)
               name      = 'Menu-Item-##16'
               parent    = h-Benef-Consig
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##16").
        end.
    
    {utp/ut-liter.i "N£mero da Nota Fiscal de Faturamento de Consigna‡Æo Mercantil (##17)"}

    create menu-item h-menu-item-var-17
        assign label     = trim(return-value)
               name      = 'Menu-Item-##17'
               parent    = h-Benef-Consig
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##17").
        end.

    {utp/ut-liter.i "Nr da Nota Fiscal Retorno/Devolu‡Æo/Reajuste de Beneficiamento/Consigna‡Æo (##20)"}

    create menu-item h-menu-item-var-20
        assign label     = trim(return-value)
               name      = 'Menu-Item-##20'
               parent    = h-Benef-Consig
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##20").
        end.

    {utp/ut-liter.i "S‚rie da Nota Fiscal Retorno/Devolu‡Æo/Reajuste de Beneficiamento/Consigna‡Æo (##64)"}

    create menu-item h-menu-item-var-64
        assign label     = trim(return-value)
               name      = 'Menu-Item-##64'
               parent    = h-Benef-Consig
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##64").
        end.

    {utp/ut-liter.i "Data da Nota Fiscal Retorno/Devolu‡Æo/Reajuste de Beneficiamento/Consigna‡Æo (##21)"}

    create menu-item h-menu-item-var-21
        assign label     = trim(return-value)
               name      = 'Menu-Item-##21'
               parent    = h-Benef-Consig
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##21").
        end.

    {utp/ut-liter.i "Nome do Fornecedor da Nota Fiscal Retorno Beneficiamento (##60)"}

    create menu-item h-menu-item-var-60
        assign label     = trim(return-value)
               name      = 'Menu-Item-##60'
               parent    = h-Benef-Consig
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##60").
        end.

    {utp/ut-liter.i "Endere‡o do Fornecedor da Nota Fiscal Retorno Beneficiamento (##61)"}

    create menu-item h-menu-item-var-61
        assign label     = trim(return-value)
               name      = 'Menu-Item-##61'
               parent    = h-Benef-Consig
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##61").
        end.

    {utp/ut-liter.i "Inscri‡Æo Estadual do Fornecedor da Nota Fiscal Retorno Beneficiamento (##62)"}

    create menu-item h-menu-item-var-62
        assign label     = trim(return-value)
               name      = 'Menu-Item-##62'
               parent    = h-Benef-Consig
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##62").
        end.

    {utp/ut-liter.i "CNPJ do Fornecedor da Nota Fiscal Retorno Beneficiamento (##63)"}

    create menu-item h-menu-item-var-63
        assign label     = trim(return-value)
               name      = 'Menu-Item-##63'
               parent    = h-Benef-Consig
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##63").
        end.

    /* Fim Menu Beneficiamento/Consigna‡Æo */

    /* Inicio Menu Opera‡Æo Triangular */
    create SUB-MENU h-Triangular
        assign label     = "Opera‡Æo Triangular"
               name      = 'Op-Triangular'
               parent    = h-menu.

    {utp/ut-liter.i "Data de emissÆo da nota fiscal fatura para o cliente em oper. triang. (##03)"}

    create menu-item h-menu-item-var-03
        assign label     = trim(return-value)
               name      = 'Menu-Item-##03'
               parent    = h-Triangular
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##03").
        end.

    {utp/ut-liter.i "S‚rie da nota fiscal fatura para o cliente em opera‡Æo triangular (##04)"}

    create menu-item h-menu-item-var-04
        assign label     = trim(return-value)
               name      = 'Menu-Item-##04'
               parent    = h-Triangular
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##04").
        end.

    {utp/ut-liter.i "N£mero da nota fiscal fatura para o cliente em opera‡Æo triangular (##05)"}

    create menu-item h-menu-item-var-05
        assign label     = trim(return-value)
               name      = 'Menu-Item-##05'
               parent    = h-Triangular
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##05").
        end.

    {utp/ut-liter.i "RazÆo social do cliente em opera‡Æo triangular (##06)"}

    create menu-item h-menu-item-var-06
        assign label     = trim(return-value)
               name      = 'Menu-Item-##06'
               parent    = h-Triangular
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##06").
        end.

    {utp/ut-liter.i "CGC do cliente em opera‡Æo triangular (##07)"}

    create menu-item h-menu-item-var-07
        assign label     = trim(return-value)
               name      = 'Menu-Item-##07'
               parent    = h-Triangular
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##07").
        end.

    {utp/ut-liter.i "Endere‡o do cliente em opera‡Æo triangular (##08)"}

    create menu-item h-menu-item-var-08
        assign label     = trim(return-value)
               name      = 'Menu-Item-##08'
               parent    = h-Triangular
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##08").
        end.

    {utp/ut-liter.i "Inscri‡Æo Estadual do Cliente em opera‡Æo triangular (##22)"}

    create menu-item h-menu-item-var-22
        assign label     = trim(return-value)
               name      = 'Menu-Item-##22'
               parent    = h-Triangular
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##22").
        end.
   
    {utp/ut-liter.i "Dt de EmissÆo da nota de remessa para o beneficiador em oper. triang. (##09)"}

    create menu-item h-menu-item-var-09
        assign label     = trim(return-value)
               name      = 'Menu-Item-##09'
               parent    = h-Triangular
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##09").
        end.

    {utp/ut-liter.i "S‚rie da nota fiscal de remessa para o beneficiador em oper. triang. (##10)"}

    create menu-item h-menu-item-var-10
        assign label     = trim(return-value)
               name      = 'Menu-Item-##10'
               parent    = h-Triangular
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##10").
        end.

    {utp/ut-liter.i "N£mero da nota fiscal de remessa para o beneficiador em oper. triang. (##11)"}

    create menu-item h-menu-item-var-11
        assign label     = trim(return-value)
               name      = 'Menu-Item-##11'
               parent    = h-Triangular
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##11").
        end.

    {utp/ut-liter.i "RazÆo Social do beneficiador em oper. triang. (##12)"}

    create menu-item h-menu-item-var-12
        assign label     = trim(return-value)
               name      = 'Menu-Item-##12'
               parent    = h-Triangular
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##12").
        end.

    {utp/ut-liter.i "CGC do beneficiador em opera‡Æo triangular (##13)"}

    create menu-item h-menu-item-var-13
        assign label     = trim(return-value)
               name      = 'Menu-Item-##13'
               parent    = h-Triangular
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##13").
        end.

    {utp/ut-liter.i "Endere‡o do beneficiador em opera‡Æo triangular (##14)"}

    create menu-item h-menu-item-var-14
        assign label     = trim(return-value)
               name      = 'Menu-Item-##14'
               parent    = h-Triangular
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##14").
        end.

    {utp/ut-liter.i "Inscri‡Æo Estadual do beneficiador em opera‡Æo triangular (##23)"}

    create menu-item h-menu-item-var-23
        assign label     = trim(return-value)
               name      = 'Menu-Item-##23'
               parent    = h-Triangular
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##23").
        end.
    /* Fim Menu Opera‡Æo Triangular */
   
    /* Inicio Menu Tributos */
    create SUB-MENU h-Tributos
        assign label     = "Tributos"
               name      = 'Tributos'
               parent    = h-menu.

    {utp/ut-liter.i "Valor do INSS na Reten‡Æo para a seguridade social (##15)"}

    create menu-item h-menu-item-var-15
        assign label     = trim(return-value)
               name      = 'Menu-Item-##15'
               parent    = h-Tributos
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##15").
        end.
    
    {utp/ut-liter.i "Valor IPI Suspenso (##37)"}

    create menu-item h-menu-item-var-37
        assign label     = trim(return-value)
               name      = 'Menu-Item-##37'
               parent    = h-Tributos
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##37").
        end.

    {utp/ut-liter.i "Valor FCP (##40)"}

    create menu-item h-menu-item-var-40
       assign label     = trim(return-value)
              name      = 'Menu-Item-##40'
              parent    = h-Tributos
              sensitive = yes
       triggers:
           on choose persistent run pi-grava-codigo in this-procedure (input "##40").
       end.
       {utp/ut-liter.i "Desconto de ICMS (##76)"}

       create menu-item h-menu-item-var-76
           assign label     = trim(return-value)
                  name      = 'Menu-Item-##76'
                  parent    = h-Tributos
                  sensitive = yes
           triggers:
               on choose persistent run pi-grava-codigo in this-procedure (input "##76").
           end.

       assign mensagem.texto-mensag:popup-menu in frame {&frame-name} = h-menu.
    /* Fim Menu Tributos */

    /* Inicio Menu Devolu‡Æo Compra */
    create SUB-MENU h-Devol-comp
        assign label     = "Devolu‡Æo Compra/Venda"
               name      = 'Devol-comp'
               parent    = h-menu.

    {utp/ut-liter.i "Nr da nota do emitente (##18)"}

    create menu-item h-menu-item-var-18
        assign label     = trim(return-value)
               name      = 'Menu-Item-##18'
               parent    = h-Devol-comp
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##18").
        end.

    {utp/ut-liter.i "Data da nota do emitente (##19)"}
    
    create menu-item h-menu-item-var-19
        assign label     = trim(return-value)
               name      = 'Menu-Item-##19'
               parent    = h-Devol-comp
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##19").
        end.
    /* Fim Menu Devolu‡Æo Compra*/

    /* Inicio Menu Diferimento */
    create SUB-MENU h-Diferimento
        assign label     = "Diferimento"
               name      = 'Dife'
               parent    = h-menu.

    {utp/ut-liter.i "N£mero do Inciso do Diferimento Parcial/Total (##26)"}

    create menu-item h-menu-item-var-26
        assign label     = trim(return-value)
               name      = 'Menu-Item-##26'
               parent    = h-Diferimento
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##26").
        end.

    {utp/ut-liter.i "Valor do Diferimento Parcial/Total (##27)"}

    create menu-item h-menu-item-var-27
        assign label     = trim(return-value)
               name      = 'Menu-Item-##27'
               parent    = h-Diferimento
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##27").
        end.

    {utp/ut-liter.i "Valor do ICMS Sem Diferimento (##28)"}

    create menu-item h-menu-item-var-28
        assign label     = trim(return-value)
               name      = 'Menu-Item-##28'
               parent    = h-Diferimento
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##28").
        end.
    
    {utp/ut-liter.i "Base de c lculo do ICMS (##29)"}

    create menu-item h-menu-item-var-29
        assign label     = trim(return-value)
               name      = 'Menu-Item-##29'
               parent    = h-Diferimento
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##29").
        end.
        
    /* Fim Menu Diferimento */

    /* Inicio Menu Reten‡Æo de ICMS */
    create SUB-MENU h-Ret-icms
        assign label     = "Reten‡Æo ICMS"
               name      = 'Ret-icms'
               parent    = h-menu.

    {utp/ut-liter.i "Reten‡Æo ICMS Transp - Valor Servi‡o (##31)"}

    create menu-item h-menu-item-var-31
        assign label     = trim(return-value)
               name      = 'Menu-Item-##31'
               parent    = h-Ret-icms
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##31").
        end.

    {utp/ut-liter.i "Reten‡Æo ICMS Transp - Al¡quota ICMS (##32)"}

    create menu-item h-menu-item-var-32
        assign label     = trim(return-value)
               name      = 'Menu-Item-##32'
               parent    = h-Ret-icms
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##32").
        end.

    {utp/ut-liter.i "Reten‡Æo ICMS Transp - Base Calc ICMS (##33)"}

    create menu-item h-menu-item-var-33
        assign label     = trim(return-value)
               name      = 'Menu-Item-##33'
               parent    = h-Ret-icms
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##33").
        end.

    {utp/ut-liter.i "Reten‡Æo ICMS Transp - Valor ICMS (##34)"}

    create menu-item h-menu-item-var-34
        assign label     = trim(return-value)
               name      = 'Menu-Item-##34'
               parent    = h-Ret-icms
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##34").
        end.

    {utp/ut-liter.i "Reten‡Æo ICMS Transp - CFOP (##35)"}

    create menu-item h-menu-item-var-35
        assign label     = trim(return-value)
               name      = 'Menu-Item-##35'
               parent    = h-Ret-icms
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##35").
        end.

    {utp/ut-liter.i "Reten‡Æo ICMS Transp - C¢digo Munic¡pio (##36)"}

    create menu-item h-menu-item-var-36
        assign label     = trim(return-value)
               name      = 'Menu-Item-##36'
               parent    = h-Ret-icms
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##36").
        end.
    /* Fim Menu Reten‡Æo de ICMS */

    /* Inicio Menu Produtor */
    create SUB-MENU h-Produtor
        assign label     = "NF Produtor"
               name      = 'nf-produtor'
               parent    = h-menu.

    {utp/ut-liter.i "Gera‡Æo NF Produtor - % Incentivo (##38)"}

    create menu-item h-menu-item-var-38
        assign label     = trim(return-value)
               name      = 'Menu-Item-##38'
               parent    = h-Produtor
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##38").
        end.

    {utp/ut-liter.i "Gera‡Æo NF Produtor - Valor Incentivo (##39)"}
    
    create menu-item h-menu-item-var-39
        assign label     = trim(return-value)
               name      = 'Menu-Item-##39'
               parent    = h-Produtor
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##39").
        end.
	/* Fim Menu Produtor */

    /* Menu Frete Autonomo */
    create SUB-MENU h-frete-auto
        assign label     = "Frete Autonomo"
               name      = 'frete-auto'
               parent    = h-menu.

    {utp/ut-liter.i "Frete Autonomo - Valor Servi‡o (##44)"}

    create menu-item h-menu-item-var-44
        assign label     = trim(return-value)
               name      = 'Menu-Item-##44'
               parent    = h-frete-auto
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##44").
        end.

    {utp/ut-liter.i "Frete Autonomo - Aliquota ICMS (##45)"}

    create menu-item h-menu-item-var-45
        assign label     = trim(return-value)
               name      = 'Menu-Item-##45'
               parent    = h-frete-auto
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##45").
        end.

    {utp/ut-liter.i "Frete Autonomo - % Redu‡Æo ICMS (##46)"}
                           
    create menu-item h-menu-item-var-46
        assign label     = trim(return-value)
               name      = 'Menu-Item-##46'
               parent    = h-frete-auto
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##46").
        end.

    {utp/ut-liter.i "Frete Autonomo - % Cred Presumido (##47)"}

    create menu-item h-menu-item-var-47
        assign label     = trim(return-value)
               name      = 'Menu-Item-##47'
               parent    = h-frete-auto
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##47").
        end.

    {utp/ut-liter.i "Frete Autonomo - Base Calc ICMS (##48)"}

    create menu-item h-menu-item-var-48
        assign label     = trim(return-value)
               name      = 'Menu-Item-##48'
               parent    = h-frete-auto
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##48").
        end.

    {utp/ut-liter.i "Frete Autonomo - Vl Credito Presumido (##49)"}

    create menu-item h-menu-item-var-49
        assign label     = trim(return-value)
               name      = 'Menu-Item-##49'
               parent    = h-frete-auto
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##49").
        end.

    {utp/ut-liter.i "Frete Autonomo - Vl ICMS Tributado (##50)"}

    create menu-item h-menu-item-var-50
        assign label     = trim(return-value)
               name      = 'Menu-Item-##50'
               parent    = h-frete-auto
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##50").
        end.

    /* Fim  Menu Frete Autonomo */

    /* Inicio Menu Ajuste */
    create SUB-MENU h-Ajuste
        assign label     = "C¢digo De Ajuste"
               name      = 'cod-ajust'
               parent    = h-menu.

    {utp/ut-liter.i "CFOP para Descri‡Æo Complementar do C¢digo de Ajuste (##56)"}

    create menu-item h-menu-item-var-56
        assign label     = trim(return-value)
               name      = 'Menu-Item-##56'
               parent    = h-Ajuste
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##56").
        end.

    assign mensagem.texto-mensag:popup-menu in frame {&frame-name} = h-menu.

    {utp/ut-liter.i "Descri‡Æo do Item para Descri‡Æo Complementar do C¢digo de Ajuste (##57)"}

    create menu-item h-menu-item-var-57
        assign label     = trim(return-value)
               name      = 'Menu-Item-##57'
               parent    = h-Ajuste
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##57").
        end.

    assign mensagem.texto-mensag:popup-menu in frame {&frame-name} = h-menu.

    {utp/ut-liter.i "C¢digo Informa‡Æo Adicional (##59)"}

    create MENU-ITEM h-menu-item-var-59
        assign label     = trim(return-value)
               name      = 'Menu-Item-##59'
               parent    = h-Ajuste
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##59").
        end.

    assign mensagem.texto-mensag:popup-menu in frame {&frame-name} = h-menu.

    {utp/ut-liter.i "Nr da nota do fornecedor (##73)"}

    create MENU-ITEM h-menu-item-var-73
        assign label     = trim(return-value)
               name      = 'Menu-Item-##73'
               parent    = h-Ajuste
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##73").
        end.

    assign mensagem.texto-mensag:popup-menu in frame {&frame-name} = h-menu.

    {utp/ut-liter.i "Data da nota do fornecedor (##74)"}

    create MENU-ITEM h-menu-item-var-74
        assign label     = trim(return-value)
               name      = 'Menu-Item-##74'
               parent    = h-Ajuste
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##74").
        end.

    assign mensagem.texto-mensag:popup-menu in frame {&frame-name} = h-menu.

    {utp/ut-liter.i "CNPJ do fornecedor (##75)"}

    create MENU-ITEM h-menu-item-var-75
        assign label     = trim(return-value)
               name      = 'Menu-Item-##75'
               parent    = h-Ajuste
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##75").
        end.

    assign mensagem.texto-mensag:popup-menu in frame {&frame-name} = h-menu.

    /* Fim Menu ajuste */

    /* Inicio Menu de Industrializa‡Æo */
    create SUB-MENU h-ind-encomenda
        assign label     = "Industrializa‡Æo Por Encomenda"
               name      = 'ind-encomenda'
               parent    = h-menu.
    
    {utp/ut-liter.i "Industrializa‡Æo por Encomenda - Valor MÆo-de-Obra (##51)"}

    create menu-item h-menu-item-var-51
        assign label     = trim(return-value)
               name      = 'Menu-Item-##51'
               parent    = h-ind-encomenda
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##51").
        end.

    assign mensagem.texto-mensag:popup-menu in frame {&frame-name} = h-menu.

    {utp/ut-liter.i "Industrializa‡Æo por Encomenda - Valor Total Insumos Aplicados na Produ‡Æo (##52)"}

    create menu-item h-menu-item-var-52
        assign label     = trim(return-value)
               name      = 'Menu-Item-##52'
               parent    = h-ind-encomenda
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##52").
        end.

    assign mensagem.texto-mensag:popup-menu in frame {&frame-name} = h-menu.

    {utp/ut-liter.i "Industrializa‡Æo por Encomenda - Valor ICMS Insumos Pr¢prios (##53)"}

    create menu-item h-menu-item-var-53
        assign label     = trim(return-value)
               name      = 'Menu-Item-##53'
               parent    = h-ind-encomenda
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##53").
        end.

    assign mensagem.texto-mensag:popup-menu in frame {&frame-name} = h-menu.
    /* Fim Menu de Industrializa‡Æo */
    
    /* Inicio Menu Diversos */
    create SUB-MENU h-diversos
        assign label     = "Diversos"
               name      = 'diversos'
               parent    = h-menu.

    {utp/ut-liter.i "Placa NF-e - Informa‡äes Complementares (##54)"}

    create menu-item h-menu-item-var-54
        assign label     = trim(return-value)
               name      = 'Menu-Item-##54'
               parent    = h-diversos
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##54").
        end.

    assign mensagem.texto-mensag:popup-menu in frame {&frame-name} = h-menu.

    {utp/ut-liter.i "UF Placa NF-e - Informa‡äes Complementares (##55)"}

    create menu-item h-menu-item-var-55
        assign label     = trim(return-value)
               name      = 'Menu-Item-##55'
               parent    = h-diversos
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##55").
        end.

    assign mensagem.texto-mensag:popup-menu in frame {&frame-name} = h-menu.

    {utp/ut-liter.i "N£mero do Pedido da Nota (##58)"}

    create menu-item h-menu-item-var-58
        assign label     = trim(return-value)
               name      = 'Menu-Item-##58'
               parent    = h-diversos
               sensitive = yes
        triggers:
            on choose persistent run pi-grava-codigo in this-procedure (input "##58").
        end.

    assign mensagem.texto-mensag:popup-menu in frame {&frame-name} = h-menu.
    /* Fim Menu Diversos */
end.

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
  {src/adm/template/snd-list.i "mensagem"}

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


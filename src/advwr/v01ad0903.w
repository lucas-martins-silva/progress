&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgfis            PROGRESS
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
{include/i-prgvrs.i V01AD0903 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01ad0903 MUT}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

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
&Scoped-define EXTERNAL-TABLES dwf-cta-ctbl
&Scoped-define FIRST-EXTERNAL-TABLE dwf-cta-ctbl


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR dwf-cta-ctbl.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS dwf-cta-ctbl.ind-tip-orig-aplic-recur ~
dwf-cta-ctbl.ind-tip-mutac-patrim-liq 
&Scoped-define ENABLED-TABLES dwf-cta-ctbl
&Scoped-define FIRST-ENABLED-TABLE dwf-cta-ctbl
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS dwf-cta-ctbl.cdn-empresa ~
dwf-cta-ctbl.cod-cta-ctbl dwf-cta-ctbl.des-tit-ctbl ~
dwf-cta-ctbl.ind-tip-orig-aplic-recur dwf-cta-ctbl.ind-tip-mutac-patrim-liq 
&Scoped-define DISPLAYED-TABLES dwf-cta-ctbl
&Scoped-define FIRST-DISPLAYED-TABLE dwf-cta-ctbl


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
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 2.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 2.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     dwf-cta-ctbl.cdn-empresa AT ROW 1.17 COL 18.29 COLON-ALIGNED
          LABEL "C¢d. Empresa":R21
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88 
     dwf-cta-ctbl.cod-cta-ctbl AT ROW 2.25 COL 18.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88 
     dwf-cta-ctbl.des-tit-ctbl AT ROW 2.25 COL 40 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 46 BY .88 
     dwf-cta-ctbl.ind-tip-orig-aplic-recur AT ROW 3.75 COL 26 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 60 BY 1 TOOLTIP "Tipo Origem da Aplica‡Æo de Recursos"
     dwf-cta-ctbl.ind-tip-mutac-patrim-liq AT ROW 5 COL 26 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 60 BY 1 TOOLTIP "Tipo Muta‡Æo Patrim“nio L¡quido"
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgfis.dwf-cta-ctbl
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
         HEIGHT             = 5.29
         WIDTH              = 89.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

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

/* SETTINGS FOR FILL-IN dwf-cta-ctbl.cdn-empresa IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN dwf-cta-ctbl.cod-cta-ctbl IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dwf-cta-ctbl.des-tit-ctbl IN FRAME f-main
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
  {src/adm/template/row-list.i "dwf-cta-ctbl"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "dwf-cta-ctbl"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /*:T Ponha na pi-validate todas as valida‡äes */
    /*:T NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /*:T Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

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
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */
    
/*:T    Segue um exemplo de valida‡Æo de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

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
  {src/adm/template/snd-list.i "dwf-cta-ctbl"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR list-items-combo-1
        AS CHAR
        FORMAT "x(500)"
        NO-UNDO.
    DEF VAR list-items-combo-2
        AS CHAR
        FORMAT "x(500)"
        NO-UNDO.

  &if integer(entry(1,PROVERSION,".")) >= 9 &then
  IF AVAIL dwf-cta-ctbl THEN DO:
         IF dwf-cta-ctbl.ind-tip-orig-aplic-recur = "" OR dwf-cta-ctbl.ind-tip-orig-aplic-recur = ? THEN DO:
            /*Faz* um refresh pois na navega‡Æo ele nÆo estava atualizando o valor do combo-box.*/
            ASSIGN list-items-combo-1 = dwf-cta-ctbl.ind-tip-orig-aplic-recur:LIST-ITEM-PAIRS IN FRAME f-main
                   dwf-cta-ctbl.ind-tip-orig-aplic-recur:LIST-ITEM-PAIRS IN FRAME f-main = ","
                   dwf-cta-ctbl.ind-tip-orig-aplic-recur:SCREEN-VALUE IN FRAME f-main = "".
 
        END.
       
        IF dwf-cta-ctbl.ind-tip-mutac-patrim-liq = "" OR dwf-cta-ctbl.ind-tip-mutac-patrim-liq  = ? THEN DO:
           ASSIGN list-items-combo-2 = dwf-cta-ctbl.ind-tip-mutac-patrim-liq:LIST-ITEM-PAIRS IN FRAME f-main
                  dwf-cta-ctbl.ind-tip-mutac-patrim-liq:LIST-ITEM-PAIRS IN FRAME f-main = ","
                  dwf-cta-ctbl.ind-tip-mutac-patrim-liq:SCREEN-VALUE IN FRAME f-main = "".
       END.
   END.
     
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
   
   IF AVAIL dwf-cta-ctbl THEN DO:
       IF dwf-cta-ctbl.ind-tip-orig-aplic-recur = "" OR dwf-cta-ctbl.ind-tip-orig-aplic-recur = ? THEN DO:
           /*Faz* um refresh pois na navega‡Æo ele nÆo estava atualizando o valor do combo-box.*/
           ASSIGN dwf-cta-ctbl.ind-tip-orig-aplic-recur:LIST-ITEM-PAIRS IN FRAME f-main = list-items-combo-1.
       END.
  
       IF dwf-cta-ctbl.ind-tip-mutac-patrim-liq = "" OR dwf-cta-ctbl.ind-tip-mutac-patrim-liq = ? THEN DO:
          ASSIGN dwf-cta-ctbl.ind-tip-mutac-patrim-liq:LIST-ITEM-PAIRS IN FRAME f-main = list-items-combo-2.
      END.
  END.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    &if integer(entry(1,PROVERSION,".")) >= 9 &then
        
        ASSIGN dwf-cta-ctbl.cdn-empresa:tab-stop in frame f-main = no
               dwf-cta-ctbl.cod-cta-ctbl:tab-stop in frame f-main = no
               dwf-cta-ctbl.des-tit-ctbl:tab-stop in frame f-main = no.

        ASSIGN dwf-cta-ctbl.ind-tip-orig-aplic-recur:LIST-ITEM-PAIRS in frame f-main = ",," +
                                                                                       "111 - Resultado l¡quido do exerc¡cio,111," +
                                                                                       "112 - Deprecia‡Æo,112," +
                                                                                       "113 - Amortiza‡Æo,113," +
                                                                                       "114 - Varia‡äes monet rias e cambiais de longo prazo,114," +
                                                                                       "115 - Outros,115," +
                                                                                       "121 - Aumento em dinheiro,121," +
                                                                                       "122 - Aumento com outros bens,122," +
                                                                                       "131 - Novos empr‚stimos,131," +
                                                                                       "132 - Outros,132," +
                                                                                       "211 - Distribui‡Æo de dividendos,211," +
                                                                                       "221 - Contas a receber de longo prazo,221," +
                                                                                       "231 - Aquisi‡Æo de imobilizado,231," +
                                                                                       "241 - Gastos com novas pesquisas,241," +
                                                                                       "242 - Gastos com reorganiza‡Æo,242," +
                                                                                       "249 - Outros gastos,249," +
                                                                                       "251 - Transferˆncia do exig¡vel para o circulante,251," +
                                                                                       "261 - Outras,261," +
                                                                                       "311 - Ativo circulante no in¡cio do exerc¡cio anterior,311," +
                                                                                       "321 - Passivo circulante no final do exerc¡cio anterior,321," +
                                                                                       "331 - Ativo circulante no in¡cio do exerc¡cio,331," +
                                                                                       "341 - Passivo circulante no final do exerc¡cio,341".
    
        
        ASSIGN dwf-cta-ctbl.ind-tip-mutac-patrim-liq:LIST-ITEM-PAIRS in frame f-main = ",," +
                                                                                       "11 - Saldos no inicio do per¡odo,11," +
                                                                                       "21 - Ajustes de exerc¡cios anteriores,21," +
                                                                                       "22 - Reversäes e transferˆncias de reservas e lucros,22," +
                                                                                       "23 - Aumentos de capital,23," +
                                                                                       "24 - Redu‡äes de capital,24," +
                                                                                       "25 - Destina‡äes do lucro l¡quido do per¡odo,25," +
                                                                                       "26 - Reavalia‡äes de ativos,26," +
                                                                                       "27 - Resultado l¡quido do per¡odo,27," +
                                                                                       "28 - Compensa‡äes de preju¡zos,28," +
                                                                                       "29 - Lucros distribu¡dos,29," +
                                                                                       "31 - Saldos no final do per¡odo,31," +
                                                                                       "41 - Saldos no inicio do per¡odo,41," +
                                                                                       "51 - Ajustes de exerc¡cios anteriores,51," +
                                                                                       "52 - Reversäes e transferˆncias de reservas e lucros,52," +
                                                                                       "53 - Aumentos de capital,53," +
                                                                                       "54 - Redu‡äes de capital,54," +
                                                                                       "55 - Destina‡äes do lucro l¡quido do per¡odo,55," +
                                                                                       "56 - Reavalia‡äes de ativos,56," +
                                                                                       "57 - Resultado l¡quido do per¡odo,57," +
                                                                                       "58 - Compensa‡äes de preju¡zos,58," +
                                                                                       "59 - Lucros distribu¡dos,59," +
                                                                                       "61 - Saldos no final do per¡odo,61".

    &endif


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


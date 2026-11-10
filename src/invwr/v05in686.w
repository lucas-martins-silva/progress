&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V05IN686 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V05IN686 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def var v-row-parent as rowid no-undo.
def var i-politica   as integer no-undo.

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
&Scoped-define EXTERNAL-TABLES fam-uni-estab
&Scoped-define FIRST-EXTERNAL-TABLE fam-uni-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR fam-uni-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS fam-uni-estab.int-1 ~
fam-uni-estab.res-int-comp fam-uni-estab.res-for-comp ~
fam-uni-estab.res-cq-comp fam-uni-estab.ressup-fabri ~
fam-uni-estab.res-cq-fabri fam-uni-estab.qt-min-res-fabr ~
fam-uni-estab.var-tempo-res-fabr fam-uni-estab.var-qtd-res-fabr ~
fam-uni-estab.horiz-fixo 
&Scoped-define ENABLED-TABLES fam-uni-estab
&Scoped-define FIRST-ENABLED-TABLE fam-uni-estab
&Scoped-Define ENABLED-OBJECTS RECT-29 RECT-30 RECT-34 
&Scoped-Define DISPLAYED-FIELDS fam-uni-estab.int-1 ~
fam-uni-estab.res-int-comp fam-uni-estab.res-for-comp ~
fam-uni-estab.res-cq-comp fam-uni-estab.ressup-fabri ~
fam-uni-estab.res-cq-fabri fam-uni-estab.qt-min-res-fabr ~
fam-uni-estab.var-tempo-res-fabr fam-uni-estab.var-qtd-res-fabr ~
fam-uni-estab.horiz-fixo 
&Scoped-define DISPLAYED-TABLES fam-uni-estab
&Scoped-define FIRST-DISPLAYED-TABLE fam-uni-estab
&Scoped-Define DISPLAYED-OBJECTS cb-classe-repro cb-emis-ordem cb-div-ordem ~
l-demanda-fam i-prioridade i-horiz-lib 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cb-classe-repro cb-emis-ordem cb-div-ordem ~
l-demanda-fam i-horiz-lib 
&Scoped-define ADM-MODIFY-FIELDS cb-classe-repro cb-emis-ordem cb-div-ordem ~
l-demanda-fam i-horiz-lib 

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
DEFINE VARIABLE cb-classe-repro AS CHARACTER FORMAT "X(30)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "item1" 
     DROP-DOWN-LIST
     SIZE 20.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-div-ordem AS CHARACTER FORMAT "X(50)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "item1" 
     DROP-DOWN-LIST
     SIZE 20.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-emis-ordem AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "item1" 
     DROP-DOWN-LIST
     SIZE 20.43 BY 1 NO-UNDO.

DEFINE VARIABLE i-horiz-lib AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-prioridade AS INTEGER FORMAT "99" INITIAL 99 
     LABEL "Prioridade":R12 
     VIEW-AS FILL-IN 
     SIZE 3.29 BY .79.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38.57 BY 7.92.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47 BY 2.92.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47 BY 4.75.

DEFINE VARIABLE l-demanda-fam AS LOGICAL INITIAL no 
     LABEL "Represa Demanda" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 TOOLTIP "Represa Demanda" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-classe-repro AT ROW 1.5 COL 16 COLON-ALIGNED
     cb-emis-ordem AT ROW 2.75 COL 16 COLON-ALIGNED
     cb-div-ordem AT ROW 4 COL 16 COLON-ALIGNED
     fam-uni-estab.int-1 AT ROW 5.29 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     l-demanda-fam AT ROW 6.29 COL 18
     i-prioridade AT ROW 7.29 COL 16 COLON-ALIGNED HELP
          "Zero ‚ a maior prioridade"
     fam-uni-estab.res-int-comp AT ROW 1.5 COL 56.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fam-uni-estab.res-for-comp AT ROW 2.5 COL 56.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fam-uni-estab.res-cq-comp AT ROW 2.5 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fam-uni-estab.ressup-fabri AT ROW 4.54 COL 56.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fam-uni-estab.res-cq-fabri AT ROW 4.54 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fam-uni-estab.qt-min-res-fabr AT ROW 5.54 COL 56.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fam-uni-estab.var-tempo-res-fabr AT ROW 6.54 COL 56.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fam-uni-estab.var-qtd-res-fabr AT ROW 6.54 COL 64.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     i-horiz-lib AT ROW 7.54 COL 56.57 COLON-ALIGNED
     fam-uni-estab.horiz-fixo AT ROW 7.54 COL 64.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     " /" VIEW-AS TEXT
          SIZE 1.57 BY .96 AT ROW 6.54 COL 64.72
     " /" VIEW-AS TEXT
          SIZE 1.57 BY .96 AT ROW 7.54 COL 64.43
     RECT-29 AT ROW 1 COL 1
     RECT-30 AT ROW 1 COL 40
     RECT-34 AT ROW 4.08 COL 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.fam-uni-estab
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
         HEIGHT             = 7.96
         WIDTH              = 86.14.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-classe-repro IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-div-ordem IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-emis-ordem IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN i-horiz-lib IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN i-prioridade IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-demanda-fam IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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


  {utp/ut-field.i mgind fam-uni-estab emissao-ord 1}
  assign cb-emis-ordem:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind fam-uni-estab classe-repro 1}
  assign cb-classe-repro:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind fam-uni-estab div-ordem 1}
  assign cb-div-ordem:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Prioridade_MRP MPL}
  ASSIGN fam-uni-estab.int-1:LABEL IN FRAME {&frame-name} = RETURN-VALUE
         fam-uni-estab.int-1:FORMAT IN FRAME {&frame-name} = ">>9".


  {utp/ut-liter.i Horizonte_Liber_/_Fixo * R}
  assign i-horiz-lib:label = trim(return-value).

  {utp/ut-liter.i Represa_Demanda * R}
  assign l-demanda-fam:label = return-value.

  {utp/ut-liter.i Var_Tempo_/_Qtd_Ressup * R}
  assign fam-uni-estab.var-tempo-res-fabr:label = trim(return-value).


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
  {src/adm/template/row-list.i "fam-uni-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "fam-uni-estab"}

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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    if int(i-horiz-lib) > fam-uni-estab.horiz-fixo then do:
          run utp/ut-msgs.p( input "Show" ,
                             input 26550 ,
                             input string(i-horiz-lib) + "~~" + string(fam-uni-estab.horiz-fixo)).
          APPLY "ENTRY" to i-horiz-lib in frame {&frame-name}.
          return "ADM-ERROR":U.
    end.


     assign fam-uni-estab.emissao-ord  = {ininc/i03in122.i 06 cb-emis-ordem}
            fam-uni-estab.classe-repro = {ininc/i06in122.i 06 cb-classe-repro}
            fam-uni-estab.div-ordem    = {ininc/i12in122.i 06 cb-div-ordem}
            fam-uni-estab.prioridade   = INPUT frame {&frame-name} i-prioridade.


     assign substring(fam-uni-estab.char-1,129,3)  = string(i-horiz-lib, ">>9").   /* horizonte de libera‡Æo*/

     if input frame {&frame-name} l-demanda-fam = yes then
        assign substring(fam-uni-estab.char-1,132,1) = "1" . /* represa demanda */
     else
        assign substring(fam-uni-estab.char-1,132,1) = "2" .



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
    
    ASSIGN i-prioridade:SENSITIVE IN frame {&frame-name} = NO.

 DISABLE {&ADM-CREATE-FIELDS} {&ADM-ASSIGN-FIELDS} WITH FRAME {&FRAME-NAME}.    

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

  if avail fam-uni-estab then do with frame {&frame-name}: 
     assign cb-emis-ordem      = {ininc/i03in122.i 04 fam-uni-estab.emissao-ord}
            cb-classe-repro    = {ininc/i06in122.i 04 fam-uni-estab.classe-repro}
            cb-div-ordem       = {ininc/i12in122.i 04 fam-uni-estab.div-ordem}
            i-horiz-lib        = int(substring(fam-uni-estab.char-1,129,3))
            i-prioridade       = fam-uni-estab.prioridade.

      if substring(fam-uni-estab.char-1,132,1) = "1" then
         assign l-demanda-fam = yes.
      else 
         assign l-demanda-fam = no.

   end.         
   else do:
       assign cb-classe-repro    = {ininc/i06in122.i 04 1}
              cb-div-ordem       = {ininc/i12in122.i 04 1}
              cb-emis-ordem      = {ininc/i03in122.i 04 1}
              i-prioridade       = 99.
   end. 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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
    &if  defined(ADM-MODIFY-FIELDS) &then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    ASSIGN i-prioridade:SENSITIVE IN frame {&frame-name} = YES.

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

  find first param-global no-lock no-error. 

  do  with frame {&frame-name}:
      assign cb-classe-repro:list-items  = {ininc/i06in122.i 03}
             cb-div-ordem:list-items     = {ininc/i12in122.i 03}
             cb-emis-ordem:list-items    = {ininc/i03in122.i 03}.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "fam-uni-estab"}

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


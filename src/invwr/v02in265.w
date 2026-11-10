&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V02IN265 2.00.00.003}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN265 MUT}
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

/* global variable definitions */
                            
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var rw-ord-taref as rowid no-undo.    
def var rw-afericao as rowid no-undo.                          
def buffer b-ord-afericao for ord-afericao.
def buffer b-ord-taref for ord-taref.
def var de-vl-padrao  like ord-afericao.vl-padrao.
def var de-vl-leitura like ord-afericao.vl-leit-ant.
def var de-vl-desvio  like ord-afericao.vl-desv-ant.
def var de-vl-desv-ant like ord-afericao.vl-desv-ant.
def var de-vl-desv-apos like ord-afericao.vl-desv-apos.

def var v-row-parent as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ord-afericao
&Scoped-define FIRST-EXTERNAL-TABLE ord-afericao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-afericao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-afericao.data ord-afericao.cd-tecnico ~
ord-afericao.vl-leit-ant ord-afericao.vl-leit-apos ord-afericao.observacao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}data ~{&FP2}data ~{&FP3}~
 ~{&FP1}cd-tecnico ~{&FP2}cd-tecnico ~{&FP3}~
 ~{&FP1}vl-leit-ant ~{&FP2}vl-leit-ant ~{&FP3}~
 ~{&FP1}vl-leit-apos ~{&FP2}vl-leit-apos ~{&FP3}~
 ~{&FP1}observacao ~{&FP2}observacao ~{&FP3}
&Scoped-define ENABLED-TABLES ord-afericao
&Scoped-define FIRST-ENABLED-TABLE ord-afericao
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS ord-afericao.nr-leitura ~
ord-afericao.vl-padrao ord-afericao.data ord-afericao.cd-tecnico ~
ord-afericao.vl-leit-ant ord-afericao.vl-desv-ant ord-afericao.vl-leit-apos ~
ord-afericao.vl-desv-apos ord-afericao.observacao 
&Scoped-Define DISPLAYED-OBJECTS c-tecn-mi-nome-compl 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS ord-afericao.nr-leitura 
&Scoped-define ADM-ASSIGN-FIELDS ord-afericao.vl-padrao 

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
DEFINE VARIABLE c-tecn-mi-nome-compl AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.43 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.43 BY 5.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-afericao.nr-leitura AT ROW 1.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .88
     ord-afericao.vl-padrao AT ROW 2.67 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.86 BY .88
     ord-afericao.data AT ROW 2.63 COL 50 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ord-afericao.cd-tecnico AT ROW 3.67 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     c-tecn-mi-nome-compl AT ROW 3.67 COL 30 COLON-ALIGNED NO-LABEL
     ord-afericao.vl-leit-ant AT ROW 4.67 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.86 BY .88
     ord-afericao.vl-desv-ant AT ROW 4.71 COL 56.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.86 BY .88
     ord-afericao.vl-leit-apos AT ROW 5.67 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.86 BY .88
     ord-afericao.vl-desv-apos AT ROW 5.63 COL 56.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.86 BY .88
     ord-afericao.observacao AT ROW 6.67 COL 20 COLON-ALIGNED FORMAT "x(30)"
          VIEW-AS FILL-IN 
          SIZE 36 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ord-afericao
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 6.79
         WIDTH              = 86.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-tecn-mi-nome-compl IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-afericao.nr-leitura IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN ord-afericao.observacao IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN ord-afericao.vl-desv-ant IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-afericao.vl-desv-apos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-afericao.vl-padrao IN FRAME f-main
   NO-ENABLE 2                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ord-afericao.cd-tecnico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-afericao.cd-tecnico V-table-Win
ON F5 OF ord-afericao.cd-tecnico IN FRAME f-main /* T‚cnico */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in428.w"
                  &tabela=ord-afericao
                  &atributo=cd-tecnico}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-afericao.cd-tecnico V-table-Win
ON LEAVE OF ord-afericao.cd-tecnico IN FRAME f-main /* T‚cnico */
DO:
  {include/leave.i &tabela=tecn-mi 
                 &atributo-ref=nome-compl
                 &variavel-ref=c-tecn-mi-nome-compl
                 &where="tecn-mi.cd-tecnico = input frame {&frame-name} ord-afericao.cd-tecnico"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-afericao.cd-tecnico V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ord-afericao.cd-tecnico IN FRAME f-main /* T‚cnico */
DO:
  apply 'F5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-afericao.nr-leitura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-afericao.nr-leitura V-table-Win
ON ENTRY OF ord-afericao.nr-leitura IN FRAME f-main /* Leitura */
DO:
   find /*last*/ ord-taref where rowid(ord-taref) = v-row-parent no-lock no-error.
   if available ord-taref then do:
      if avail ord-afericao then 
      ord-afericao.vl-padrao:screen-value in frame {&frame-name} = if avail ord-taref then string(ord-taref.vl-padrao) else "".
      if ord-taref.inf-padrao = yes then 
         enable ord-afericao.vl-padrao with frame {&frame-name}.
      else
         disable ord-afericao.vl-padrao with frame {&frame-name}.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-afericao.vl-leit-ant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-afericao.vl-leit-ant V-table-Win
ON LEAVE OF ord-afericao.vl-leit-ant IN FRAME f-main /* Leitura Antes */
DO:
    assign de-vl-padrao  = input frame {&frame-name} ord-afericao.vl-padrao
           de-vl-leitura = input frame {&frame-name} ord-afericao.vl-leit-ant.
    if  (de-vl-leitura - de-vl-padrao) < 0 then
      assign ord-afericao.vl-desv-ant:screen-value in frame {&frame-name} = string((de-vl-leitura - de-vl-padrao) * -1)
             de-vl-desv-ant                                               = (de-vl-leitura - de-vl-padrao) * -1.
    else
      assign ord-afericao.vl-desv-ant:screen-value in frame {&frame-name} = string(de-vl-leitura - de-vl-padrao)
             de-vl-desv-ant                                               = de-vl-leitura - de-vl-padrao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-afericao.vl-leit-apos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-afericao.vl-leit-apos V-table-Win
ON LEAVE OF ord-afericao.vl-leit-apos IN FRAME f-main /* Leitura Ap¢s */
DO:
    assign de-vl-padrao  = input frame {&frame-name} ord-afericao.vl-padrao
           de-vl-leitura = input frame {&frame-name} ord-afericao.vl-leit-apos.
    if  (de-vl-leitura - de-vl-padrao) < 0 then
        assign ord-afericao.vl-desv-apos:screen-value in frame {&frame-name} = string((de-vl-leitura - de-vl-padrao) * -1)
               de-vl-desv-apos                                               = (de-vl-leitura - de-vl-padrao) * -1.
    else
        assign ord-afericao.vl-desv-apos:screen-value in frame {&frame-name} = string(de-vl-leitura - de-vl-padrao)
                  de-vl-desv-apos                                            = de-vl-leitura - de-vl-padrao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  if ord-afericao.cd-tecnico:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "ord-afericao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-afericao"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
 
  display today @ ord-afericao.data
          with frame {&frame-name}.
  /* Code placed here will execute AFTER standard behavior.    */
  find last ord-afericao where ord-afericao.nr-ord-produ = ord-taref.nr-ord-produ
                         and ord-afericao.cd-tarefa = ord-taref.cd-tarefa no-lock no-error.
   if avail ord-afericao then do:
      ord-afericao.nr-leitura:screen-value in frame {&frame-name} = string(ord-afericao.nr-leitura + 1).
   end.
   else
     ord-afericao.nr-leitura:screen-value in frame {&frame-name} = "1".
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
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.

    /* Ponha aqui a valida‡Æo de chave duplicada */
    if  ord-afericao.nr-leitura:sensitive in frame {&frame-name} = yes
    and can-find (b-ord-afericao
                  where b-ord-afericao.nr-ord-produ = ord-afericao.nr-ord-produ
                  and   b-ord-afericao.cd-tarefa =  ord-afericao.cd-tarefa
                  and   b-ord-afericao.nr-leitura = input frame {&frame-name} ord-afericao.nr-leitura)
    then do:
        {utp/ut-table.i mgind ord-afericao 1}
        run utp/ut-msgs.p (input "show",
                           input 1,
                           input return-value).
        return 'adm-error'.
    end.

    /* Ponha aqui as demais valida‡äes */

    find tecn-mi
        where tecn-mi.cd-tecnico = input frame {&frame-name} ord-afericao.cd-tecnico
        no-error.
    if  not avail tecn-mi then do:
        {utp/ut-table.i mgind tecn-mi 1}
        run utp/ut-msgs.p (input "show",
                           input 558,
                           input return-value).
        return 'adm-error'.
    end.
    if  tecn-mi.sit-tecn = 02 then do:
        {utp/ut-field.i mgind tecn-mi cd-tecnico 1}
        run utp/ut-msgs.p (input "show",
                           input  469,
                           input return-value).
        return 'adm-error'.
    end.

    /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
    find ord-taref
        where rowid(ord-taref) = v-row-parent
        no-error.
    if  available ord-taref  then do:
        assign ord-afericao.nr-ord-produ = ord-taref.nr-ord-produ
               ord-afericao.cd-tarefa    = ord-taref.cd-tarefa.
    end. 
    if  avail ord-afericao then
        assign ord-afericao.vl-desv-ant  = de-vl-desv-ant
               ord-afericao.vl-desv-apos = de-vl-desv-apos.

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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

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

def input parameter v-row-parent-externo as rowid no-undo.

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
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ord-afericao"}

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



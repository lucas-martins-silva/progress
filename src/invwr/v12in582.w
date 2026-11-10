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
{include/i-prgvrs.i V12IN582 2.00.00.006 } /*** 010006 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v12in582 MUT}
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
def var v-row-parent as rowid no-undo.

{cnp/cn0601.i1}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item-contrat
&Scoped-define FIRST-EXTERNAL-TABLE item-contrat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-contrat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-contrat.cod-depos ~
item-contrat.qtd-minima item-contrat.log-control-event ~
item-contrat.log-libera item-contrat.log-ind-multa item-contrat.tp-despesa ~
item-contrat.perc-multa-dia item-contrat.perc-multa-limite ~
item-contrat.val-fatur-minimo item-contrat.ind-tipo-control-val ~
item-contrat.ind-tipo-control 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-depos ~{&FP2}cod-depos ~{&FP3}~
 ~{&FP1}qtd-minima ~{&FP2}qtd-minima ~{&FP3}~
 ~{&FP1}tp-despesa ~{&FP2}tp-despesa ~{&FP3}~
 ~{&FP1}perc-multa-dia ~{&FP2}perc-multa-dia ~{&FP3}~
 ~{&FP1}perc-multa-limite ~{&FP2}perc-multa-limite ~{&FP3}~
 ~{&FP1}val-fatur-minimo ~{&FP2}val-fatur-minimo ~{&FP3}
&Scoped-define ENABLED-TABLES item-contrat
&Scoped-define FIRST-ENABLED-TABLE item-contrat
&Scoped-Define ENABLED-OBJECTS rt-key RECT-14 RECT-12 RECT-15 
&Scoped-Define DISPLAYED-FIELDS item-contrat.cod-depos ~
item-contrat.ind-sit-item item-contrat.qtd-minima item-contrat.un ~
item-contrat.log-control-event item-contrat.log-libera ~
item-contrat.log-ind-multa item-contrat.tp-despesa ~
item-contrat.perc-multa-dia item-contrat.perc-multa-limite ~
item-contrat.val-fatur-minimo item-contrat.ind-tipo-control-val ~
item-contrat.ind-tipo-control 
&Scoped-Define DISPLAYED-OBJECTS c-desc-depos c-desc-despesa c-tit-sit ~
c-tit-control c-tit-tipo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS item-contrat.ind-sit-item 

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
DEFINE VARIABLE c-desc-depos AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-despesa AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 32.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-control AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15.86 BY .67 NO-UNDO.

DEFINE VARIABLE c-tit-sit AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8.72 BY .67 NO-UNDO.

DEFINE VARIABLE c-tit-tipo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12.29 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 27.57 BY 3.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 27.57 BY 3.25.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 1.75.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 8.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-contrat.cod-depos AT ROW 1.25 COL 15.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-depos AT ROW 1.29 COL 22.43 COLON-ALIGNED NO-LABEL
     item-contrat.ind-sit-item AT ROW 2 COL 60 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "NÆo emitido", 1,
"Emitido", 2,
"Cancelado", 3,
"Atendido", 4
          SIZE 25 BY 2.5
     item-contrat.qtd-minima AT ROW 2.25 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     item-contrat.un AT ROW 2.25 COL 31.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     item-contrat.log-control-event AT ROW 3.21 COL 17
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     item-contrat.log-libera AT ROW 3.21 COL 36.57
          VIEW-AS TOGGLE-BOX
          SIZE 9.29 BY .75
     item-contrat.log-ind-multa AT ROW 3.21 COL 46.29
          VIEW-AS TOGGLE-BOX
          SIZE 9.86 BY .83
     item-contrat.tp-despesa AT ROW 4 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-despesa AT ROW 4 COL 20 COLON-ALIGNED HELP
          "Descri‡Æo do c¢digo de despesa ou receita" NO-LABEL
     item-contrat.perc-multa-dia AT ROW 5 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     item-contrat.perc-multa-limite AT ROW 5 COL 41 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     item-contrat.val-fatur-minimo AT ROW 6 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     item-contrat.ind-tipo-control-val AT ROW 6.5 COL 60 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Qtd e Pre‡o Fixo", 1,
"Qtd Aberta e Pre‡o Fixo", 2,
"Limite Custo", 3
          SIZE 25 BY 2.25
     item-contrat.ind-tipo-control AT ROW 7.75 COL 18 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Medi‡Æo", 1,
"Ordem", 2,
"Programa‡Æo", 3
          SIZE 37 BY .83
     c-tit-sit AT ROW 1.25 COL 57 COLON-ALIGNED NO-LABEL
     c-tit-control AT ROW 5.75 COL 57 COLON-ALIGNED NO-LABEL
     c-tit-tipo AT ROW 7 COL 16 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     RECT-14 AT ROW 1.5 COL 58
     RECT-12 AT ROW 6 COL 58
     RECT-15 AT ROW 7.25 COL 17
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-contrat
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 8.33
         WIDTH              = 86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-depos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-despesa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-control IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-sit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-tipo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET item-contrat.ind-sit-item IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item-contrat.un IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME item-contrat.log-ind-multa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-contrat.log-ind-multa V-table-Win
ON VALUE-CHANGED OF item-contrat.log-ind-multa IN FRAME f-main /* Multa */
DO:
  if input frame {&frame-name} item-contrat.log-ind-multa = yes then do:
     enable item-contrat.perc-multa-dia
            item-contrat.perc-multa-limite with frame {&frame-name}.
  end.
  else do:
     display 0 @ item-contrat.perc-multa-dia with frame {&frame-name}.
     display 0 @ item-contrat.perc-multa-limite with frame {&frame-name}.
     disable item-contrat.perc-multa-dia
             item-contrat.perc-multa-limite with frame {&frame-name}.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-contrat.tp-despesa
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

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
  {src/adm/template/row-list.i "item-contrat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-contrat"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  if avail item-contrat then do:
     find deposito where deposito.cod-depos = item-contrat.cod-depos no-lock no-error.
     assign c-desc-depos = if avail deposito then deposito.nome else "".
     
     find tipo-rec-desp where tipo-rec-desp.tp-codigo = item-contrat.tp-despesa no-lock no-error.
     assign c-desc-despesa = if avail tipo-rec-desp then tipo-rec-desp.descricao else "".
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

     FIND FIRST param-contrat NO-LOCK NO-ERROR.
     IF AVAIL param-contrat 
          AND param-contrat.controle-aditivo THEN
         RUN pi-atualizaCamposAditivo.
  

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
  
  if adm-new-record = yes then
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  {utp/ut-liter.i Situa‡Æo * R}
  assign c-tit-sit = return-value.
  disp c-tit-sit with frame {&frame-name}.   
  
  {utp/ut-liter.i Controle_Pre‡o/Qtde * R}
  assign c-tit-control = return-value.
  disp c-tit-control with frame {&frame-name}.  
  
  {utp/ut-liter.i Tipo_de_Controle * R}
  assign c-tit-tipo = return-value.
  disp c-tit-tipo with frame {&frame-name}.  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizaCamposAditivo V-table-Win 
PROCEDURE pi-atualizaCamposAditivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR c-valor-alter AS CHAR FORMAT "X(100)" NO-UNDO.

 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.qtd-minima",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.qtd-minima:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).


 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.perc-multa-dia",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.perc-multa-dia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).

 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.perc-multa-limite",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.perc-multa-limite:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).

 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.val-fatur-minimo",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.val-fatur-minimo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).
   
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
  {src/adm/template/snd-list.i "item-contrat"}

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



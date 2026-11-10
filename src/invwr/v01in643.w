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
{include/i-prgvrs.i V01IN643 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN643 MUT}
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
def var c-arq-aux    as char  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-sw
&Scoped-define FIRST-EXTERNAL-TABLE param-sw


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-sw.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-sw.diretorio param-sw.pedidos ~
param-sw.compara param-sw.dt-periodo 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}diretorio ~{&FP2}diretorio ~{&FP3}
&Scoped-define ENABLED-TABLES param-sw
&Scoped-define FIRST-ENABLED-TABLE param-sw
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-1 RECT-2 tb-pl-venda ~
tb-pr-venda RECT-3 
&Scoped-Define DISPLAYED-FIELDS param-sw.diretorio param-sw.pedidos ~
param-sw.compara param-sw.dt-periodo 
&Scoped-Define DISPLAYED-OBJECTS tb-pl-venda fi-cd-plano-pl tb-pr-venda ~
fi-cd-plano-pr fi-texto1 fi-texto2 fi-texto3 

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
DEFINE VARIABLE fi-cd-plano-pl AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cd-plano-pr AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-texto1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE fi-texto2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE fi-texto3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .5 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 1.46.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 1.75.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 9.5.

DEFINE VARIABLE tb-pl-venda AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE tb-pr-venda AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-sw.diretorio AT ROW 1.75 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51.14 BY .88
     tb-pl-venda AT ROW 4 COL 9
     fi-cd-plano-pl AT ROW 4 COL 45 COLON-ALIGNED
     tb-pr-venda AT ROW 5 COL 9
     fi-cd-plano-pr AT ROW 5 COL 45 COLON-ALIGNED
     param-sw.pedidos AT ROW 6 COL 9
          VIEW-AS TOGGLE-BOX
          SIZE 18.86 BY .83
     param-sw.compara AT ROW 7 COL 9
          VIEW-AS TOGGLE-BOX
          SIZE 20.86 BY .83
     param-sw.dt-periodo AT ROW 9 COL 9 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "In¡cio", 1,
"T‚rmino", 2
          SIZE 23 BY 1
     fi-texto1 AT ROW 1.25 COL 1 COLON-ALIGNED NO-LABEL
     fi-texto2 AT ROW 3 COL 1 COLON-ALIGNED NO-LABEL
     fi-texto3 AT ROW 8.29 COL 1 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
     RECT-1 AT ROW 1.5 COL 2
     RECT-2 AT ROW 3.25 COL 2
     RECT-3 AT ROW 8.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-sw
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
         HEIGHT             = 9.5
         WIDTH              = 85.
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

/* SETTINGS FOR FILL-IN fi-cd-plano-pl IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cd-plano-pr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-texto1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-texto2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-texto3 IN FRAME f-main
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

&Scoped-define SELF-NAME fi-cd-plano-pl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-plano-pl V-table-Win
ON F5 OF fi-cd-plano-pl IN FRAME f-main
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in318.w
                     &campo=fi-cd-plano-pl
                     &campozoom=cd-plano}    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-plano-pl V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cd-plano-pl IN FRAME f-main
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-plano-pr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-plano-pr V-table-Win
ON F5 OF fi-cd-plano-pr IN FRAME f-main
DO:
   {include/zoomvar.i &prog-zoom=inzoom/z01in313.w
                      &campo=fi-cd-plano-pr
                      &campozoom=cd-plano}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-plano-pr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cd-plano-pr IN FRAME f-main
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-pl-venda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pl-venda V-table-Win
ON VALUE-CHANGED OF tb-pl-venda IN FRAME f-main
DO:
  if input frame {&frame-name} tb-pl-venda = no then 
    assign fi-cd-plano-pl:sensitive in frame {&frame-name} = no
           fi-cd-plano-pl:screen-value in frame {&frame-name} = "0".
  else
    assign fi-cd-plano-pl:sensitive in frame {&frame-name} = yes.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-pr-venda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-venda V-table-Win
ON VALUE-CHANGED OF tb-pr-venda IN FRAME f-main
DO:
    if input frame {&frame-name} tb-pr-venda = no then 
    assign fi-cd-plano-pr:sensitive in frame {&frame-name}    = no
           fi-cd-plano-pr:screen-value in frame {&frame-name} = "0".
  else
    assign fi-cd-plano-pr:sensitive in frame {&frame-name} = yes.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

  if fi-cd-plano-pl:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.
  if fi-cd-plano-pr:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.

  {utp/ut-liter.i Transferˆncia * R}
  assign fi-texto1 = return-value.
  
  {utp/ut-liter.i Demanda * R}
  assign fi-texto2 = return-value.

  {utp/ut-field.i mgind param-sw dt-periodo 01}
  assign fi-texto3 = return-value.
  
  {utp/ut-field.i mgind param-sw pl-venda 01}
  assign tb-pl-venda:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind param-sw pr-venda 01}
  assign tb-pr-venda:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind param-sw cd-plano-pr 01}
  assign fi-cd-plano-pr:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind param-sw cd-plano-pl 01}
  assign fi-cd-plano-pl:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "param-sw"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-sw"}

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

  {utp/ut-liter.i Transferˆncia * R}
  assign fi-texto1 = return-value.
  
  {utp/ut-liter.i Demanda * R}
  assign fi-texto2 = return-value.

  {utp/ut-field.i mgind param-sw dt-periodo 01}
  assign fi-texto3 = return-value.
  
  assign tb-pl-venda    = no
         tb-pr-venda    = no
         fi-cd-plano-pl = 0
         fi-cd-plano-pr = 0.

  display fi-texto1
          fi-texto2
          fi-texto3
          tb-pl-venda
          tb-pr-venda
          fi-cd-plano-pl
          fi-cd-plano-pr
          with frame {&frame-name}.
          
  /* Code placed here will execute AFTER standard behavior.    */

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
    /* {include/i-valid.i}*/
    
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
  assign fi-cd-plano-pl = input frame {&frame-name} fi-cd-plano-pl
         fi-cd-plano-pr = input frame {&frame-name} fi-cd-plano-pr
         tb-pl-venda    = input frame {&frame-name} tb-pl-venda
         tb-pr-venda    = input frame {&frame-name} tb-pr-venda.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    
    if RETURN-VALUE = 'ADM-ERROR':U then 
       return 'ADM-ERROR':U.
    
    assign c-arq-aux = input frame {&frame-name} param-sw.diretorio
           c-arq-aux = replace(c-arq-aux, "/", "\").
    if  r-index(c-arq-aux, "\") > 0 then do:       
        assign file-info:file-name = substring(c-arq-aux,1,r-index(c-arq-aux, "\")).
        if  file-info:full-pathname = ? or not file-info:file-type matches "*D*" then do:
            run utp/ut-msgs.p (input "show", 
                               input 15798, 
                               input "").
            apply 'entry' to param-sw.diretorio in frame {&frame-name}.
            return error.
        end.
    end.
              
  
  if input frame {&frame-name} tb-pl-venda = yes then do:
      find first pl-prod 
        where pl-prod.cd-plano = input frame {&frame-name} fi-cd-plano-pl
        no-lock no-error.
      if not avail pl-prod then do:
         {utp/ut-table.i mgind pl-prod 01}
         run utp/ut-msgs.p (input "show",
                            input 56,
                            input return-value).
          apply 'entry' to fi-cd-plano-pl in frame {&frame-name}.
          return error.
      end.
  end.
  
  if input frame {&frame-name} tb-pr-venda = yes then do:
      find first pl-mest 
        where pl-mest.cd-plano = input frame {&frame-name} fi-cd-plano-pr
        no-lock no-error.
      if not avail pl-mest then do:
         {utp/ut-table.i mgind pl-mest 01}
         run utp/ut-msgs.p (input "show",
                            input 56,
                            input return-value).
          apply 'entry' to fi-cd-plano-pr in frame {&frame-name}.
          return error.
      end.
  end.
          
  assign param-sw.cd-plano-pl =  fi-cd-plano-pl
         param-sw.cd-plano-pr =  fi-cd-plano-pr
         param-sw.pl-venda    =  tb-pl-venda
         param-sw.pr-venda    =  tb-pr-venda.


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

  find first param-sw no-error.
  if not avail param-sw then 
       assign tb-pl-venda    = no
              tb-pr-venda    = no
              fi-cd-plano-pl = 0
              fi-cd-plano-pr = 0.
  else assign tb-pl-venda    = param-sw.pl-venda
              tb-pr-venda    = param-sw.pr-venda
              fi-cd-plano-pl = param-sw.cd-plano-pl
              fi-cd-plano-pr = param-sw.cd-plano-pr.
    
  if avail param-sw and param-sw.pl-venda = yes 
      then assign fi-cd-plano-pl:sensitive in frame {&frame-name} = yes.
      else assign fi-cd-plano-pl:sensitive in frame {&frame-name} = no.

  if avail param-sw and param-sw.pr-venda = yes
      then assign fi-cd-plano-pr:sensitive in frame {&frame-name} = yes.
      else assign fi-cd-plano-pr:sensitive in frame {&frame-name} = no.


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
  {src/adm/template/snd-list.i "param-sw"}

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



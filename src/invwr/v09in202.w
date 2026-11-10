&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmnt            PROGRESS
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
{include/i-prgvrs.i V09IN202 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V09IN202 MUT}
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

{cdp/cdcfgmnt.i}

/* global variable definitions */

def new global shared var v-row-parent as rowid no-undo.
def new global shared var gr-manut     as rowid no-undo.
def new global shared var gr-man-equip as rowid no-undo.

/*def new global shared var h-viewer2 as handle no-undo.*/

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def temp-table tt-manut like manut.

def var hProgramZoom                      as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES man-equip
&Scoped-define FIRST-EXTERNAL-TABLE man-equip


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR man-equip.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS man-equip.forma-aloc-esp ~
man-equip.para-equipto man-equip.horas-prod man-equip.horas-parada ~
man-equip.hr-extr-norm man-equip.dias-manut man-equip.cd-equip-res ~
man-equip.cd-planejado 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}horas-prod ~{&FP2}horas-prod ~{&FP3}~
 ~{&FP1}horas-parada ~{&FP2}horas-parada ~{&FP3}~
 ~{&FP1}cd-equip-res ~{&FP2}cd-equip-res ~{&FP3}~
 ~{&FP1}cd-planejado ~{&FP2}cd-planejado ~{&FP3}
&Scoped-define ENABLED-TABLES man-equip
&Scoped-define FIRST-ENABLED-TABLE man-equip
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-27 RECT-25 RECT-26 RECT-29 
&Scoped-Define DISPLAYED-FIELDS man-equip.forma-aloc-esp ~
man-equip.para-equipto man-equip.horas-prod man-equip.horas-parada ~
man-equip.hr-extr-norm man-equip.dias-manut man-equip.cd-equip-res ~
man-equip.cd-planejado 
&Scoped-Define DISPLAYED-OBJECTS c-desc-equipe c-desc-planeja ~
c-forma-aloc-esp c-hr-extr-norm 

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
cd-causa-padr||y|mgind.man-equip.cd-causa-padr
cd-equipto||y|mgind.man-equip.cd-equipto
cd-interv-padr||y|mgind.man-equip.cd-interv-padr
cd-manut||y|mgind.man-equip.cd-manut
cd-parada||y|mgind.man-equip.cd-parada
cd-pend-padr||y|mgind.man-equip.cd-pend-padr
cd-sint-padr||y|mgind.man-equip.cd-sint-padr
cd-tipo||y|mgind.man-equip.cd-tipo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "cd-causa-padr,cd-equipto,cd-interv-padr,cd-manut,cd-parada,cd-pend-padr,cd-sint-padr,cd-tipo"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-equipe AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-planeja AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-forma-aloc-esp AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 26.29 BY .63 NO-UNDO.

DEFINE VARIABLE c-hr-extr-norm AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 23.72 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 67 BY 1.63.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38 BY 1.63.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 67 BY 1.63.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34.86 BY 1.63.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 10.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     man-equip.forma-aloc-esp AT ROW 2.42 COL 23.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Backward", 1,
"Forward", 2
          SIZE 56 BY .83
     man-equip.para-equipto AT ROW 3.96 COL 16.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Parada Total", 1,
"Parada Parcial", 2,
"Opera‡Æo Normal", 3
          SIZE 63 BY 1.08
     man-equip.horas-prod AT ROW 5.63 COL 64.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     man-equip.horas-parada AT ROW 5.88 COL 19.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     man-equip.hr-extr-norm AT ROW 7.75 COL 10.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Normal", 1,
"Hora-extra", 2
          SIZE 32.14 BY .75
     man-equip.dias-manut AT ROW 7.75 COL 47.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Todos", 1,
"éteis", 2,
"NÆo éteis", 3
          SIZE 32.43 BY .75
     man-equip.cd-equip-res AT ROW 9.17 COL 24.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-desc-equipe AT ROW 9.17 COL 37.14 COLON-ALIGNED NO-LABEL
     man-equip.cd-planejado AT ROW 10.17 COL 24.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-desc-planeja AT ROW 10.17 COL 38.72 COLON-ALIGNED NO-LABEL
     c-forma-aloc-esp AT ROW 1.58 COL 13.72 COLON-ALIGNED NO-LABEL
     c-hr-extr-norm AT ROW 7 COL 5.14 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1.14
     RECT-27 AT ROW 1.83 COL 13.86
     RECT-25 AT ROW 3.63 COL 13.86
     RECT-26 AT ROW 7.25 COL 6.14
     RECT-29 AT ROW 7.25 COL 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.man-equip
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
         HEIGHT             = 10.5
         WIDTH              = 85.86.
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

/* SETTINGS FOR FILL-IN c-desc-equipe IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-planeja IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-forma-aloc-esp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-hr-extr-norm IN FRAME f-main
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

&Scoped-define SELF-NAME man-equip.cd-equip-res
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-equip-res V-table-Win
ON F5 OF man-equip.cd-equip-res IN FRAME f-main /* Equipe Respons vel */
DO:
    assign l-implanta = no.
    {include/zoomvar.i  &prog-zoom=inzoom/z01in094.w
                        &campo=man-equip.cd-equip-res
                        &campozoom=cd-equipe}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-equip-res V-table-Win
ON LEAVE OF man-equip.cd-equip-res IN FRAME f-main /* Equipe Respons vel */
DO:
    {include/leave.i  &tabela=equipe
                      &atributo-ref=desc-equipe
                      &variavel-ref=c-desc-equipe
                      &where="equipe.cd-equipe = input frame {&frame-name}  
                                                 man-equip.cd-equip-res"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-equip-res V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-equip.cd-equip-res IN FRAME f-main /* Equipe Respons vel */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-equip.cd-planejado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-planejado V-table-Win
ON F5 OF man-equip.cd-planejado IN FRAME f-main /* Planejador */
DO:
    assign l-implanta = no.
    &if defined (bf_mnt_ems203) &then
    {method/ZoomFields.i 
           &ProgramZoom="mnzoom\z01mn060.w"
           &FieldZoom1="cd-planejado"
           &FieldScreen1="man-equip.cd-planejado"
           &Frame1="f-main"
           &FieldZoom2="nome"
           &FieldScreen2="c-desc-planeja"
           &Frame2="f-main"}
   &else
    {include/zoomvar.i  &prog-zoom=inzoom/z01in321.w
                        &campo=man-equip.cd-planejado
                        &campozoom=cd-planejado}    
   &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-planejado V-table-Win
ON LEAVE OF man-equip.cd-planejado IN FRAME f-main /* Planejador */
DO:
&if defined (bf_mnt_ems203) &then
  {include/leave.i  &tabela=mnt-planejador 
                      &atributo-ref=nome
                      &variavel-ref=c-desc-planeja
                      &where="mnt-planejador.cd-planejado = input frame {&frame-name}  
                                                 man-equip.cd-planejado"}
&else
  {include/leave.i  &tabela=planejad
                      &atributo-ref=nome
                      &variavel-ref=c-desc-planeja
                      &where="planejad.cd-planejado = input frame {&frame-name}  
                                                 man-equip.cd-planejado"}
&endif                                                 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-equip.cd-planejado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-equip.cd-planejado IN FRAME f-main /* Planejador */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  { utp/ut-rtlbl.i mgind man-equip hr-extr-norm   c-hr-extr-norm }
  { utp/ut-rtlbl.i mgind man-equip forma-aloc-esp c-forma-aloc-esp }

  if  man-equip.cd-equip-res:load-mouse-pointer ("image/lupa.cur") 
  in frame {&frame-name}  then.
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  {src/adm/template/row-list.i "man-equip"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "man-equip"}

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
  
  /* Ponha aqui as demais valida‡äes */
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

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
    if  avail man-equip then do:
        find equipe
            where equipe.cd-equipe = man-equip.cd-equip-res
            no-lock no-error.
        assign c-desc-equipe = if  avail equipe then equipe.desc-equip else "":U.
        displ  c-desc-equipe with frame {&frame-name}.
        apply "leave" to man-equip.cd-planejado.
    end.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */

    { utp/ut-rtlbl.i mgind man-equip hr-extr-norm   c-hr-extr-norm }
    { utp/ut-rtlbl.i mgind man-equip forma-aloc-esp c-forma-aloc-esp }

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
  
  if manut.forma-aloc-esp = tt-manut.forma-aloc-esp then
     disable man-equip.forma-aloc-esp with frame {&frame-name}.
  
  if manut.cd-equip-res = tt-manut.cd-equip-res then
     disable man-equip.cd-equip-res with frame {&frame-name}.
     
  if manut.cd-planejado = tt-manut.cd-planejado then
     disable man-equip.cd-planejado with frame {&frame-name}.
  
  if manut.horas-parada = tt-manut.horas-parada then
     disable man-equip.horas-parada with frame {&frame-name}.
    
  if manut.hr-extr-norm = tt-manut.hr-extr-norm then
     disable man-equip.hr-extr-norm with frame {&frame-name}.
    
  if manut.para-equipto = tt-manut.para-equipto then
     disable man-equip.para-equipto with frame {&frame-name}.
    
  if manut.horas-prod = tt-manut.horas-prod then
     disable man-equip.horas-prod with frame {&frame-name}.
     
  if manut.dias-manut = tt-manut.dias-manut then
     disable man-equip.dias-manut with frame {&frame-name}.
       

/**** ****/     
  if not param-global.modulo-pi then
     disable man-equip.forma-aloc-esp with frame {&frame-name}.
 
 &if defined (bf_mnt_ems203) &then
 &else       
  if not param-mi.trb-equip then
     disable man-equip.cd-equip-res with frame {&frame-name}.   
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
    find first tt-manut
        no-lock no-error.
    find manut
        where manut.cd-manut = tt-manut.cd-manut
        no-lock no-error.
    find man-equip
        where rowid(man-equip) = gr-man-equip
        no-lock no-error.
    find first param-mi
        no-lock no-error.
    find first param-global
        no-lock no-error.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    /* Code placed here will execute AFTER standard behavior.    */

    { utp/ut-rtlbl.i mgind man-equip hr-extr-norm   c-hr-extr-norm }
    { utp/ut-rtlbl.i mgind man-equip forma-aloc-esp c-forma-aloc-esp }

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dado-inicial V-table-Win 
PROCEDURE pi-dado-inicial :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input param table for tt-manut.

    find first tt-manut
        no-lock no-error.
    find manut
        where manut.cd-manut = tt-manut.cd-manut
        no-lock no-error.
    find man-equip
        where rowid(man-equip) = gr-man-equip
        no-lock no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-valor V-table-Win 
PROCEDURE pi-mostra-valor :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    if  manut.forma-aloc-esp <> tt-manut.forma-aloc-esp then
        assign man-equip.forma-aloc-esp:screen-value  in frame {&frame-name} =
                                        string(manut.forma-aloc-esp).

    if  manut.cd-equip-res <> tt-manut.cd-equip-res then
        assign man-equip.cd-equip-res:screen-value  in frame {&frame-name} =
                                        string(manut.cd-equip-res).

    if  manut.cd-planejad <> tt-manut.cd-planejad then
        assign man-equip.cd-planejad:screen-value in frame {&frame-name} =
                                        string(manut.cd-planejad).

    if  manut.horas-parada <> tt-manut.horas-parada then
        assign man-equip.horas-parada:screen-value in frame {&frame-name} =
                                        string(manut.horas-parada).

    if  manut.hr-extr-norm <> tt-manut.hr-extr-norm then
        assign man-equip.hr-extr-norm:screen-value in frame {&frame-name} =
                                        string(manut.hr-extr-norm).

    if  manut.para-equipto <> tt-manut.para-equipto then
        assign man-equip.para-equipto:screen-value in frame {&frame-name} =
                                        string(manut.para-equipto).

    if  manut.horas-prod <> tt-manut.horas-prod then
        assign man-equip.horas-prod:screen-value in frame {&frame-name} =
                                        string(manut.horas-prod).   

    if  manut.dias-manut <> tt-manut.dias-manut then
        assign man-equip.dias-manut:screen-value in frame {&frame-name} =
                                        string(manut.dias-manut).   

    {include/leave.i &tabela=equipe
                     &atributo-ref=desc-equipe
                     &variavel-ref=c-desc-equipe
                     &where="equipe.cd-equipe = input frame {&frame-name}
                                                man-equip.cd-equip-res"}

&if defined (bf_mnt_ems203) &then
  {include/leave.i  &tabela=mnt-planejador 
                      &atributo-ref=nome
                      &variavel-ref=c-desc-planeja
                      &where="mnt-planejador.cd-planejado = input frame {&frame-name}  
                                                 man-equip.cd-planejado"}
&else
  {include/leave.i  &tabela=planejad
                      &atributo-ref=nome
                      &variavel-ref=c-desc-planeja
                      &where="planejad.cd-planejado = input frame {&frame-name}  
                                                 man-equip.cd-planejado"}
&endif                                                 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
 {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

  if  man-equip.cd-equip-res:sensitive in frame {&frame-name} = yes 
      and  not can-find (equipe where equipe.cd-equipe = input frame {&frame-name} 
                                                             man-equip.cd-equip-res)
  then do: 
      {include/i-vldprg.i}  /* posiciona pagina */
      {utp/ut-table.i mgind equipe 1}
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to man-equip.cd-equip-res.
      return 'ADM-ERROR'.
  end.
  
     
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cd-causa-padr" "man-equip" "cd-causa-padr"}
  {src/adm/template/sndkycas.i "cd-equipto" "man-equip" "cd-equipto"}
  {src/adm/template/sndkycas.i "cd-interv-padr" "man-equip" "cd-interv-padr"}
  {src/adm/template/sndkycas.i "cd-manut" "man-equip" "cd-manut"}
  {src/adm/template/sndkycas.i "cd-parada" "man-equip" "cd-parada"}
  {src/adm/template/sndkycas.i "cd-pend-padr" "man-equip" "cd-pend-padr"}
  {src/adm/template/sndkycas.i "cd-sint-padr" "man-equip" "cd-sint-padr"}
  {src/adm/template/sndkycas.i "cd-tipo" "man-equip" "cd-tipo"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "man-equip"}

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



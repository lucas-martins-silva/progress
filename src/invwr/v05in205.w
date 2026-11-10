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
{include/i-prgvrs.i V05IN205 2.00.00.018}  /*** 010018 ***/


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
def new global shared var h-viewer2 as handle no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Vari vel definida para utliza‡Æo de thinZooms */
def var hProgramZoom    as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES manut
&Scoped-define FIRST-EXTERNAL-TABLE manut


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR manut.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS manut.forma-aloc-esp manut.para-equipto ~
manut.horas-parada manut.horas-prod manut.hr-extr-norm manut.dias-manut ~
manut.cd-equip-res manut.cd-planejado 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}horas-parada ~{&FP2}horas-parada ~{&FP3}~
 ~{&FP1}horas-prod ~{&FP2}horas-prod ~{&FP3}~
 ~{&FP1}cd-equip-res ~{&FP2}cd-equip-res ~{&FP3}~
 ~{&FP1}cd-planejado ~{&FP2}cd-planejado ~{&FP3}
&Scoped-define ENABLED-TABLES manut
&Scoped-define FIRST-ENABLED-TABLE manut
&Scoped-Define ENABLED-OBJECTS RECT-26 RECT-27 RECT-28 RECT-29 rt-mold 
&Scoped-Define DISPLAYED-FIELDS manut.forma-aloc-esp manut.para-equipto ~
manut.horas-parada manut.horas-prod manut.hr-extr-norm manut.dias-manut ~
manut.cd-equip-res manut.cd-planejado 
&Scoped-Define DISPLAYED-OBJECTS FI-dia-semana c-desc-equipe c-nome-planej ~
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
     SIZE 40.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-forma-aloc-esp AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 24.29 BY .63 NO-UNDO.

DEFINE VARIABLE c-hr-extr-norm AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 23.14 BY .63 NO-UNDO.

DEFINE VARIABLE c-nome-planej AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE FI-dia-semana AS CHARACTER FORMAT "X(17)":U 
      VIEW-AS TEXT 
     SIZE 16.86 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36 BY 1.46.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72.86 BY 1.46.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72.86 BY 1.46.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34.86 BY 1.46.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 10.13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     FI-dia-semana AT ROW 6.75 COL 44.72 COLON-ALIGNED NO-LABEL
     manut.forma-aloc-esp AT ROW 1.75 COL 20 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Backward", 1,
"Forward", 2
          SIZE 48.14 BY .83
     manut.para-equipto AT ROW 3.75 COL 12 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Parada Total", 1,
"Parada Parcial", 2,
"Opera‡Æo Normal", 3
          SIZE 63 BY .75
     manut.horas-parada AT ROW 5.5 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     manut.horas-prod AT ROW 5.5 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     manut.hr-extr-norm AT ROW 7.54 COL 9 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Normal", 1,
"Hora-extra", 2
          SIZE 33 BY .75
     manut.dias-manut AT ROW 7.5 COL 48.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Todos", 1,
"éteis", 2,
"NÆo éteis", 3
          SIZE 30 BY .63
     manut.cd-equip-res AT ROW 9 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-desc-equipe AT ROW 9 COL 37.72 COLON-ALIGNED NO-LABEL
     manut.cd-planejado AT ROW 10 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-nome-planej AT ROW 10 COL 39.29 COLON-ALIGNED NO-LABEL
     c-forma-aloc-esp AT ROW 1.29 COL 10 COLON-ALIGNED NO-LABEL
     c-hr-extr-norm AT ROW 6.75 COL 7 COLON-ALIGNED NO-LABEL
     RECT-26 AT ROW 7.04 COL 7
     RECT-27 AT ROW 1.42 COL 7
     RECT-28 AT ROW 3.42 COL 7
     RECT-29 AT ROW 7 COL 45
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.manut
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
         HEIGHT             = 10.13
         WIDTH              = 85.86.
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

/* SETTINGS FOR FILL-IN c-desc-equipe IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-forma-aloc-esp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-hr-extr-norm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-planej IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FI-dia-semana IN FRAME f-main
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

&Scoped-define SELF-NAME manut.cd-equip-res
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-equip-res V-table-Win
ON F5 OF manut.cd-equip-res IN FRAME f-main /* Equipe Respons vel */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i  &prog-zoom=inzoom/z01in094.w
                        &campo=MANUT.cd-equip-res
                        &campozoom=cd-equipe}      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-equip-res V-table-Win
ON LEAVE OF manut.cd-equip-res IN FRAME f-main /* Equipe Respons vel */
DO:
    {include/leave.i  &tabela=equipe
                      &atributo-ref=desc-equipe
                      &variavel-ref=c-desc-equipe
                      &where="equipe.cd-equipe = input frame {&frame-name}  
                                                 MANUT.cd-equip-res"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-equip-res V-table-Win
ON MOUSE-SELECT-DBLCLICK OF manut.cd-equip-res IN FRAME f-main /* Equipe Respons vel */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME manut.cd-planejado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-planejado V-table-Win
ON F5 OF manut.cd-planejado IN FRAME f-main /* Planejador */
DO:
    assign l-implanta = yes.
    &if defined (bf_mnt_ems203) &then
       {method/zoomfields.i 
           &ProgramZoom="mnzoom~\z01mn060.w"
           &FieldZoom1="cd-planejado"
           &FieldScreen1="manut.cd-planejado"
           &Frame1="f-main"
           &FieldZoom2="nome"
           &FieldScreen2="c-nome-planej"
           &Frame2="f-main"}
    &else
       {include/zoomvar.i  &prog-zoom=inzoom/z01in321.w
                           &campo=manut.cd-planejado
                           &campozoom=cd-planejado
                           &campo2=c-nome-planej 
                           &campozoom2=nome}
    &endif                       

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-planejado V-table-Win
ON LEAVE OF manut.cd-planejado IN FRAME f-main /* Planejador */
DO:
  &if defined (bf_mnt_ems203) &then
     {include/leave.i 
        &tabela=mnt-planejador
        &atributo-ref=nome
        &variavel-ref=c-nome-planej
        &where="mnt-planejador.cd-planejado = input frame {&frame-name} manut.cd-planejado"}.
  &else
     {include/leave.i 
        &tabela=planejad
        &atributo-ref=nome
        &variavel-ref=c-nome-planej
        &where="planejad.cd-planejado = input frame {&frame-name} manut.cd-planejado"}.

  &endif      

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-planejado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF manut.cd-planejado IN FRAME f-main /* Planejador */
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

  { utp/ut-liter.i Dia_V lido_da_Semana_para_In¡cio_da_Manuten‡Æo *}
  assign manut.dias-manut:help  = return-value. 
  if  manut.cd-equip-res:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  if  manut.cd-planejado:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  
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
  {src/adm/template/row-list.i "manut"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "manut"}

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
  /* Code placed here will execute AFTER standard behavior.    */
  { utp/ut-rtlbl.i mgind manut hr-extr-norm   c-hr-extr-norm }  
  { utp/ut-rtlbl.i mgind manut FORMA-ALOC-ESP c-forma-aloc-esp }  
  { utp/ut-liter.i Dias_da_Semana mmi r}
  assign fi-dia-semana:screen-value in frame {&frame-name} = return-value.  


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
    if  avail manut then do: 
        find first equipe
            where equipe.cd-equipe = manut.cd-equip-res no-lock no-error.
        if avail equipe then
            assign c-desc-equipe = equipe.desc-equip    
                   c-desc-equipe:screen-value in frame {&frame-name} =  equipe.desc-equip
                   manut.cd-equip-res:screen-value in frame {&frame-name} = string(equipe.cd-equipe).
        else
            assign c-desc-equipe:screen-value in frame {&frame-name} = "".        
        &if defined (bf_mnt_ems203) &then    
           find first mnt-planejador
               where mnt-planejador.cd-planejado = manut.cd-planejado no-lock no-error.
           assign c-nome-planej = if avail mnt-planejador then mnt-planejador.nome else "":U.
        &else
           find first planejad
               where planejad.cd-planejado = manut.cd-planejado no-lock no-error.
           assign c-nome-planej = if avail planejad then planejad.nome else "":U.
        &endif   
    end.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    /* Code placed here will execute AFTER standard behavior.    */

  { utp/ut-rtlbl.i mgind manut hr-extr-norm   c-hr-extr-norm }  
  { utp/ut-rtlbl.i mgind manut FORMA-ALOC-ESP c-forma-aloc-esp }  
  { utp/ut-liter.i Dias_da_Semana mmi r}
  assign fi-dia-semana:screen-value in frame {&frame-name} = return-value.  

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
  if avail param-global then 
     if not param-global.modulo-pi then
        disable manut.forma-aloc-esp with frame {&frame-name}.
        

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
  find first param-global  no-lock  no-error. 
  find first param-mi      no-lock  no-error.
   if gr-manut <> ? then do:
      find manut where rowid(manut) = gr-manut no-lock  no-error.
      if not avail manut then do:
         find first manut no-lock  no-error.
      end.
      if avail manut then do:
         assign gr-manut     = rowid(manut)
                v-row-parent = rowid(manut).
      end.
      else
         assign gr-manut     = ?
                v-row-parent = ? .
   end.
   else do:
      find first manut no-lock  no-error.
      if avail manut then
         assign gr-manut     = rowid(manut)
                v-row-parent = rowid(manut).
      else
         assign gr-manut     = ?
                v-row-parent = ? .
   end.
  
   if adm-new-record and avail manut then do:
      find equipe
            where equipe.cd-equipe = manut.cd-equip-res
            no-lock no-error.
      assign c-desc-equipe:screen-value in frame {&frame-name} = 
             if avail equipe then equipe.desc-equip else "":U.
   end.
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  { utp/ut-rtlbl.i mgind manut hr-extr-norm   c-hr-extr-norm }  
  { utp/ut-rtlbl.i mgind manut FORMA-ALOC-ESP c-forma-aloc-esp }  
  { utp/ut-liter.i Dias_da_Semana mmi r}
  assign fi-dia-semana:screen-value in frame {&frame-name} = return-value.  
  
  
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
  define input parameter r-grup-manut as rowid.
     
   find grup-manut where rowid (grup-manut) = r-grup-manut no-lock no-error. 
   assign  
         manut.cd-equip-res:screen-value  in frame {&frame-name} =  string(grup-manut.cd-equip-res)  
         manut.horas-parada:screen-value  in frame {&frame-name} =  string(grup-manut.horas-parada)  
         manut.hr-extr-norm:screen-value  in frame {&frame-name} =  string(grup-manut.hr-extr-norm)  
         manut.para-equipto:screen-value  in frame {&frame-name} =  string(grup-manut.para-equipto)
         manut.dias-manut:screen-value    in frame {&frame-name} =  string(grup-manut.dias-manut).   

         {include/leave.i  &tabela=equipe
                           &atributo-ref=desc-equipe
                           &variavel-ref=c-desc-equipe
                           &where="equipe.cd-equipe = input frame {&frame-name}
                                        manut.cd-equip-res"}
                                   
                                               
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

/*valida a EQUIPE*/
   if  manut.cd-equip-res:sensitive = yes
   and input frame {&frame-name} manut.cd-equip-res <> "" 
   and not can-find (equipe where equipe.cd-equipe =
                     input frame {&frame-name} manut.cd-equip-res)
   then do:
     {include/i-vldprg.i}   /* posiciona pagina */
     {utp/ut-table.i mgind equipe 1}

       run utp/ut-msgs.p(input "show",
                         input 2,
                         input return-value).
       apply 'entry' to manut.cd-equip-res in frame {&frame-name}.
       return 'ADM-ERROR'.
   end.
    
  /* Valida‡Æo Planejador*/
  
   if  input frame {&frame-name} manut.cd-planejad <> ""
   and 
   &if defined (bf_mnt_ems203) &then
      not can-find (mnt-planejador where mnt-planejador.cd-planejad =
                        input frame {&frame-name} manut.cd-planejad)
      then do:
      {include/i-vldprg.i}   /* posiciona pagina */
      {utp/ut-table.i mgmnt mnt-planejador 1}
   &else
      not can-find (planejad where planejad.cd-planejad =
                        input frame {&frame-name} manut.cd-planejad)
      then do:
      {include/i-vldprg.i}   /* posiciona pagina */
      {utp/ut-table.i mgind planejad 1}
   &endif   
       run utp/ut-msgs.p(input "show",
                         input 2,
                         input return-value).
       apply 'entry' to manut.cd-planejado in frame {&frame-name}.
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
  {src/adm/template/snd-list.i "manut"}

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



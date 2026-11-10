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
{include/i-prgvrs.i V04IN204 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04IN204 MUT}
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
   def new global shared var v-row-parent as rowid no-undo.
   
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var h_v02in204 as handle no-undo.
def var r_manut2   as rowid  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES man-tag-fam
&Scoped-define FIRST-EXTERNAL-TABLE man-tag-fam


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR man-tag-fam.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS man-tag-fam.dt-inicio man-tag-fam.dt-termino ~
man-tag-fam.parada man-tag-fam.gera-parada man-tag-fam.cd-parada ~
man-tag-fam.flexib-antec man-tag-fam.flexib-prorr man-tag-fam.dur-man ~
man-tag-fam.gera-pred man-tag-fam.cons-dur-man 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}dt-inicio ~{&FP2}dt-inicio ~{&FP3}~
 ~{&FP1}dt-termino ~{&FP2}dt-termino ~{&FP3}~
 ~{&FP1}cd-parada ~{&FP2}cd-parada ~{&FP3}~
 ~{&FP1}flexib-antec ~{&FP2}flexib-antec ~{&FP3}~
 ~{&FP1}flexib-prorr ~{&FP2}flexib-prorr ~{&FP3}~
 ~{&FP1}dur-man ~{&FP2}dur-man ~{&FP3}
&Scoped-define ENABLED-TABLES man-tag-fam
&Scoped-define FIRST-ENABLED-TABLE man-tag-fam
&Scoped-Define ENABLED-OBJECTS RECT-28 RECT-29 RECT-30 rt-mold 
&Scoped-Define DISPLAYED-FIELDS man-tag-fam.dt-inicio ~
man-tag-fam.dt-termino man-tag-fam.parada man-tag-fam.gera-parada ~
man-tag-fam.cd-parada man-tag-fam.flexib-antec man-tag-fam.flexib-prorr ~
man-tag-fam.dur-man man-tag-fam.gera-pred man-tag-fam.cons-dur-man 
&Scoped-Define DISPLAYED-OBJECTS c-gera-parada c-desc-parada 

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
DEFINE VARIABLE c-desc-parada AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-gera-parada AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 23 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 1.88.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.57 BY 3.88.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.57 BY 1.46.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 9.79.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     man-tag-fam.dt-inicio AT ROW 1.13 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     man-tag-fam.dt-termino AT ROW 1.13 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     man-tag-fam.parada AT ROW 3.42 COL 4
          VIEW-AS TOGGLE-BOX
          SIZE 24.43 BY .67
     man-tag-fam.gera-parada AT ROW 3.54 COL 32 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Antecipada", 1,
"Prorrogada", 2,
"Parada + Pr¢xima", 3
          SIZE 50 BY .67
     man-tag-fam.cd-parada AT ROW 5.21 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-gera-parada AT ROW 2.75 COL 31 COLON-ALIGNED NO-LABEL
     c-desc-parada AT ROW 5.21 COL 33 COLON-ALIGNED NO-LABEL
     man-tag-fam.flexib-antec AT ROW 6.96 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     man-tag-fam.flexib-prorr AT ROW 6.96 COL 42 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     man-tag-fam.dur-man AT ROW 6.96 COL 72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     man-tag-fam.gera-pred AT ROW 9 COL 10
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .67
     man-tag-fam.cons-dur-man AT ROW 9 COL 45
          VIEW-AS TOGGLE-BOX
          SIZE 36.29 BY .83
     RECT-28 AT ROW 2.96 COL 30
     RECT-29 AT ROW 2.46 COL 2
     RECT-30 AT ROW 6.67 COL 2
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.man-tag-fam
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
         HEIGHT             = 9.92
         WIDTH              = 85.72.
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

/* SETTINGS FOR FILL-IN c-desc-parada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-gera-parada IN FRAME f-main
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

&Scoped-define SELF-NAME man-tag-fam.cd-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-parada V-table-Win
ON F5 OF man-tag-fam.cd-parada IN FRAME f-main /* Parada */
DO:
    assign l-implanta = yes.
    {include/zoom.i &prog-zoom="inzoom/z01in211.w"
                    &tabela=man-tag-fam
                    &atributo=cd-parada}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-parada V-table-Win
ON LEAVE OF man-tag-fam.cd-parada IN FRAME f-main /* Parada */
DO:
  {include/leave.i &tabela=mi-parada
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-parada
                   &where="mi-parada.cd-parada = input frame {&frame-name} 
                                                 man-tag-fam.cd-parada"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.cd-parada V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-tag-fam.cd-parada IN FRAME f-main /* Parada */
DO:
    APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-tag-fam.parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-tag-fam.parada V-table-Win
ON VALUE-CHANGED OF man-tag-fam.parada IN FRAME f-main /* Manuten‡Æo Parada */
DO:
   if  input frame {&frame-name} man-tag-fam.parada = no  then do:
       assign  man-tag-fam.cd-parada:screen-value   = ""
               c-desc-parada                     = ""
               man-tag-fam.gera-parada:screen-value = "1".
       disable man-tag-fam.cd-parada   with frame {&frame-name}.
       disable man-tag-fam.gera-parada with frame {&frame-name}.
       display c-desc-parada        with frame {&frame-name}.        
   end.
   else do: 
       enable  man-tag-fam.cd-parada   with frame {&frame-name}.
       enable  man-tag-fam.gera-parada with frame {&frame-name}.
       display c-desc-parada        with frame {&frame-name}. 
   end.  
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

 if  man-tag-fam.cd-parada:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  { utp/ut-rtlbl.i mgind man-tag-fam gera-parada c-gera-parada }


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
  {src/adm/template/row-list.i "man-tag-fam"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "man-tag-fam"}

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
  { utp/ut-rtlbl.i mgind man-eq-tag gera-parada c-gera-parada }

  if  input frame {&frame-name} man-tag-fam.parada = no  then do:
      assign  man-tag-fam.cd-parada:screen-value   in frame {&frame-name} = ""
              c-desc-parada:screen-value           in frame {&frame-name} = ""
              man-tag-fam.gera-parada:screen-value in frame {&frame-name} = "1".
      disable man-tag-fam.cd-parada   
              man-tag-fam.gera-parada with frame {&frame-name}.
  end.
  else do: 
      enable  man-tag-fam.cd-parada   
              man-tag-fam.gera-parada with frame {&frame-name}.
  end.
        
  /* Data de Corte INICIAL */
     display  today  @  man-tag-fam.dt-inicio  with frame {&frame-name}.

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
  if  available man-tag-fam then do:
      find mi-parada where mi-parada.cd-parada = man-tag-fam.cd-parada no-lock no-error.
      assign  c-desc-parada = if avail mi-parada then mi-parada.descricao else "":U.
  end.
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  
  /* Code placed here will execute AFTER standard behavior.    */
  { utp/ut-rtlbl.i mgind man-tag-fam gera-parada c-gera-parada }  

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
 
 
  if  input frame {&frame-name} man-tag-fam.parada = no  then do:
      assign  man-tag-fam.cd-parada:screen-value   in frame {&frame-name} = ""
              c-desc-parada:screen-value           in frame {&frame-name} = ""
              man-tag-fam.gera-parada:screen-value in frame {&frame-name} = "1".
      disable man-tag-fam.cd-parada   
              man-tag-fam.gera-parada with frame {&frame-name}.
  end.
  else do: 
      enable  man-tag-fam.cd-parada   
              man-tag-fam.gera-parada with frame {&frame-name}.
  end.
  
  run pi-passa-manut in h_v02in204 (output r_manut2) no-error.
  find first manut where rowid(manut) = r_manut2 no-lock no-error.
  
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
  { utp/ut-rtlbl.i mgind man-eq-tag gera-parada c-gera-parada }
 
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


  /* Code placed here will execute AFTER standard behavior.    */


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
  define input parameter r-manut as rowid.  
  find manut where rowid(manut) = r-manut no-lock no-error.
  if avail manut then
    assign
      man-tag-fam.dt-inicio:screen-value    in frame {&frame-name} =  string(manut.dt-inicio)   
      man-tag-fam.dt-termino:screen-value   in frame {&frame-name} =  string(manut.dt-termino)   
      man-tag-fam.parada:checked            in frame {&frame-name} =  manut.parada              
      man-tag-fam.gera-parada:screen-value  in frame {&frame-name} =  string(manut.gera-parada)  
      man-tag-fam.flexib-antec:screen-value in frame {&frame-name} =  string(manut.flexib-antec) 
      man-tag-fam.flexib-prorr:screen-value in frame {&frame-name} =  string(manut.flexib-prorr) 
      man-tag-fam.cd-parada:screen-value    in frame {&frame-name} =  manut.cd-parada    
      man-tag-fam.dur-man:screen-value      in frame {&frame-name} =  string(manut.dur-man)
      man-tag-fam.cons-dur-man:checked      in frame {&frame-name} =  manut.cons-dur-man .

  {include/leave.i &tabela=mi-parada
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-parada
                   &where="mi-parada.cd-parada = input frame {&frame-name} 
                                                 man-tag-fam.cd-parada"}
  
  if  input frame {&frame-name} man-tag-fam.parada = no  then do:
      assign  man-tag-fam.cd-parada:screen-value   in frame {&frame-name} = ""
              c-desc-parada:screen-value           in frame {&frame-name} = ""
              man-tag-fam.gera-parada:screen-value in frame {&frame-name} = "1".
      disable man-tag-fam.cd-parada   
              man-tag-fam.gera-parada with frame {&frame-name}.
  end.
  else do: 
      enable  man-tag-fam.cd-parada   
              man-tag-fam.gera-parada with frame {&frame-name}.
  end.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param h_viewer as handle no-undo.

assign h_v02in204 = h_viewer.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/

  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
  if  man-tag-fam.cd-parada:sensitive in frame {&frame-name} = yes 
  and ( input frame {&frame-name} man-tag-fam.cd-parada = "" 
       or not can-find (mi-parada where mi-parada.cd-parada = input frame {&frame-name} 
                                   man-tag-fam.cd-parada))
  then do: 
      {utp/ut-table.i mgind mi-parada 1}
      {include/i-vldprg.i}  /* posiciona pagina */
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to man-tag-fam.cd-parada.
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
  {src/adm/template/snd-list.i "man-tag-fam"}

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



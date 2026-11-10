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
{include/i-prgvrs.i V07IN203 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V07IN203 MUT}
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
   def new global shared var v-row-parent as rowid  no-undo.
   def new global shared var gr-man-fam as rowid  no-undo.        
   
/* Parameters Definitions ---                                           */
   def temp-table tt-manut like manut.


/* Local Variable Definitions ---                                 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES man-fam
&Scoped-define FIRST-EXTERNAL-TABLE man-fam


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR man-fam.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS man-fam.cd-causa-padr man-fam.cd-sint-padr ~
man-fam.cd-interv-padr man-fam.tp-dia man-fam.faixa-tempo ~
man-fam.faixa-utiliz man-fam.situacao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cd-causa-padr ~{&FP2}cd-causa-padr ~{&FP3}~
 ~{&FP1}cd-sint-padr ~{&FP2}cd-sint-padr ~{&FP3}~
 ~{&FP1}cd-interv-padr ~{&FP2}cd-interv-padr ~{&FP3}~
 ~{&FP1}faixa-tempo ~{&FP2}faixa-tempo ~{&FP3}~
 ~{&FP1}faixa-utiliz ~{&FP2}faixa-utiliz ~{&FP3}
&Scoped-define ENABLED-TABLES man-fam
&Scoped-define FIRST-ENABLED-TABLE man-fam
&Scoped-Define ENABLED-OBJECTS RECT-30 rt-mold p-urgencia RECT-28 RECT-27 ~
rs-urgencia 
&Scoped-Define DISPLAYED-FIELDS man-fam.cd-tipo man-fam.cd-causa-padr ~
man-fam.cd-sint-padr man-fam.cd-interv-padr man-fam.tp-dia man-fam.controle ~
man-fam.faixa-tempo man-fam.faixa-utiliz man-fam.situacao 
&Scoped-Define DISPLAYED-OBJECTS c-desc-manut c-desc-causa c-desc-sint ~
c-desc-interv rs-urgencia c-controle c-tp-dia c-situacao c-urgencia 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS man-fam.controle 

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
DEFINE VARIABLE c-controle AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 27 BY .63 NO-UNDO.

DEFINE VARIABLE c-desc-causa AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-interv AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-manut AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-sint AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 15.14 BY .63 NO-UNDO.

DEFINE VARIABLE c-tp-dia AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 14.43 BY .63 NO-UNDO.

DEFINE VARIABLE c-urgencia AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 27 BY .63 NO-UNDO.

DEFINE VARIABLE rs-urgencia AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          " ", 1,
" ", 2,
" ", 3
     SIZE 55.14 BY 1.04 NO-UNDO.

DEFINE RECTANGLE p-urgencia
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.43 BY 1.67.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57 BY 2.88.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 22 BY 1.33.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 22.14 BY 3.08.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 10.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     man-fam.cd-tipo AT ROW 1.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     c-desc-manut AT ROW 1.17 COL 37 COLON-ALIGNED NO-LABEL
     man-fam.cd-causa-padr AT ROW 2.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-desc-causa AT ROW 2.17 COL 37 COLON-ALIGNED NO-LABEL
     man-fam.cd-sint-padr AT ROW 3.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-desc-sint AT ROW 3.17 COL 37 COLON-ALIGNED NO-LABEL
     man-fam.cd-interv-padr AT ROW 4.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-desc-interv AT ROW 4.17 COL 37 COLON-ALIGNED NO-LABEL
     man-fam.tp-dia AT ROW 6.29 COL 5 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Util", 1,
"Corrido", 2
          SIZE 18 BY .75
     man-fam.controle AT ROW 6.46 COL 32 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Faixa Tempo", 1,
"Utiliz Equipto", 2,
"Ambos", 3
          SIZE 52 BY .79
     man-fam.faixa-tempo AT ROW 7.63 COL 42.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     man-fam.faixa-utiliz AT ROW 7.63 COL 67.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     man-fam.situacao AT ROW 7.96 COL 2.57 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Ativa", 1,
"Suspensa", 2,
"Eliminada", 3
          SIZE 14.86 BY 2.58
     rs-urgencia AT ROW 9.54 COL 29.29 NO-LABEL
     c-controle AT ROW 5.63 COL 27 COLON-ALIGNED NO-LABEL
     c-tp-dia AT ROW 5.75 COL 1 COLON-ALIGNED NO-LABEL
     c-situacao AT ROW 7.29 COL 2.57 NO-LABEL
     c-urgencia AT ROW 8.88 COL 27 COLON-ALIGNED NO-LABEL
     RECT-30 AT ROW 7.67 COL 1.86
     rt-mold AT ROW 1 COL 1
     p-urgencia AT ROW 9.08 COL 28
     RECT-28 AT ROW 6 COL 2
     RECT-27 AT ROW 5.92 COL 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.man-fam
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
         HEIGHT             = 10.04
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

/* SETTINGS FOR FILL-IN c-controle IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-causa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-interv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-manut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-sint IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-situacao IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-tp-dia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-urgencia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN man-fam.cd-tipo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET man-fam.controle IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN 
       p-urgencia:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       rs-urgencia:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME man-fam.cd-causa-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.cd-causa-padr V-table-Win
ON F5 OF man-fam.cd-causa-padr IN FRAME f-main /* Causa */
DO:
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="inzoom/z01in040.w"
                   &tabela=man-fam
                   &atributo=cd-causa-padr}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.cd-causa-padr V-table-Win
ON LEAVE OF man-fam.cd-causa-padr IN FRAME f-main /* Causa */
DO:
   {include/leave.i &tabela=causa-padrao
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-causa
                    &where="causa-padrao.cd-causa-padr = input frame {&frame-name} 
                                                         man-fam.cd-causa-padr"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.cd-causa-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-fam.cd-causa-padr IN FRAME f-main /* Causa */
DO:
   APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-fam.cd-interv-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.cd-interv-padr V-table-Win
ON F5 OF man-fam.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
    assign l-implanta = yes.
    {include/zoom.i &prog-zoom="inzoom/z01in153.w"
                    &tabela=man-fam
                    &atributo=cd-interv-padr}      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.cd-interv-padr V-table-Win
ON LEAVE OF man-fam.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
  {include/leave.i &tabela=interv-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-interv
                   &where="interv-padrao.cd-interv-padr = input frame {&frame-name} 
                                                          man-fam.cd-interv-padr"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.cd-interv-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-fam.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
    APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-fam.cd-sint-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.cd-sint-padr V-table-Win
ON F5 OF man-fam.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
    assign l-implanta = yes.
    {include/zoom.i &prog-zoom="inzoom/z01in408.w"
                    &tabela=man-fam
                    &atributo=cd-sint-padr}      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.cd-sint-padr V-table-Win
ON LEAVE OF man-fam.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
   {include/leave.i &tabela=sint-padrao
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-sint
                    &where="sint-padrao.cd-sint-padr = input frame {&frame-name} 
                                                       man-fam.cd-sint-padr"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.cd-sint-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-fam.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
    APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-fam.cd-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.cd-tipo V-table-Win
ON LEAVE OF man-fam.cd-tipo IN FRAME f-main /* Tipo Manutená∆o */
DO:
  {include/leave.i &tabela=tipo-manut
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-manut
                   &where="tipo-manut.cd-tipo = input frame {&frame-name} 
                                                man-fam.cd-tipo"}
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


  if  man-fam.cd-tipo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  if  man-fam.cd-causa-padr:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  if  man-fam.cd-sint-padr:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  if  man-fam.cd-interv-padr:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.

  { utp/ut-rtlbl.i mgind man-fam situacao c-situacao }
  { utp/ut-rtlbl.i mgind man-fam controle c-controle }
  { utp/ut-rtlbl.i mgind man-fam tp-dia   c-tp-dia }
&if defined (bf_mnt_ems204) &then
  { utp/ut-rtlbl.i mgind man-fam urgencia c-urgencia }
&endif

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
  {src/adm/template/row-list.i "man-fam"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "man-fam"}

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
  { utp/ut-rtlbl.i mgind man-fam  situacao c-situacao }
  { utp/ut-rtlbl.i mgind man-fam  controle c-controle }
  { utp/ut-rtlbl.i mgind man-fam  tp-dia   c-tp-dia } 
&if defined (bf_mnt_ems204) &then
  { utp/ut-rtlbl.i mgind man-fam  urgencia   c-urgencia } 
 &endif
 
  case input frame {&frame-name}  man-fam.controle:
     when 1 then DO:
         disable man-fam.faixa-utiliz  with frame {&frame-name}.
         enable  man-fam.faixa-tempo  with frame {&frame-name}.
         enable  man-fam.tp-dia       with frame {&frame-name}.         
     end.
     
     when 2 then DO:
         disable man-fam.faixa-tempo with frame {&frame-name}.
         disable man-fam.tp-dia       with frame {&frame-name}.     
         enable  man-fam.faixa-utiliz with frame {&frame-name}.
     end.
     
     when 3 then DO:
         enable  man-fam.faixa-tempo with frame {&frame-name}.
         enable  man-fam.faixa-utiliz with frame {&frame-name}.
         enable  man-fam.tp-dia       with frame {&frame-name}.     
      end. 
  end case.    

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
&if defined (bf_mnt_ems204) &then
assign input frame {&FRAME-NAME} rs-urgencia.
&endif
    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
    nem na PI-validate. */  
    /* Dispatch standard ADM method. */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

&if defined (bf_mnt_ems204) &then
assign man-fam.urgencia = input frame {&FRAME-NAME} rs-urgencia.
&endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

    /* Code placed here will execute AFTER standard behavior.    */

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
    if  available man-fam then do:
        find tipo-manut
            where tipo-manut.cd-tipo = man-fam.cd-tipo
            no-lock no-error.
        assign c-desc-manut = if  avail tipo-manut then tipo-manut.descricao else "":U.
        disp c-desc-manut with frame {&frame-name}.

        find causa-padrao
            where causa-padrao.cd-causa-padr = man-fam.cd-causa-padr
            no-lock no-error.
        assign c-desc-causa = if  avail causa-padrao then causa-padrao.descricao else "":U.
        disp c-desc-causa with frame {&frame-name}.

        find sint-padrao
            where sint-padrao.cd-sint-padr = man-fam.cd-sint-padr
            no-lock no-error.
        assign c-desc-sint = if  avail sint-padrao then sint-padrao.descricao else "":U.
        disp c-desc-sint with frame {&frame-name}.

        find interv-padrao
            where interv-padrao.cd-interv-padr = man-fam.cd-interv-padr
            no-lock no-error.
        assign c-desc-interv = if  avail interv-padrao then interv-padrao.descricao else "":U.
        disp c-desc-interv with frame {&frame-name}.
    end.  

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) . 

    /* Code placed here will execute AFTER standard behavior.    */
    { utp/ut-rtlbl.i mgind man-fam situacao c-situacao }
    { utp/ut-rtlbl.i mgind man-fam controle c-controle }
    { utp/ut-rtlbl.i mgind man-fam tp-dia   c-tp-dia   }
&if defined (bf_mnt_ems204) &then
    { utp/ut-rtlbl.i mgind man-fam urgencia c-urgencia   }
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
    case input frame {&frame-name}  man-fam.controle:
        when 1 then DO:
            disable man-fam.faixa-utiliz with frame {&frame-name}.
            enable  man-fam.tp-dia       with frame {&frame-name}.
            enable  man-fam.faixa-tempo  with frame {&frame-name}.
        end.

        when 2 then DO:
            disable man-fam.faixa-tempo  with frame {&frame-name}.
            disable man-fam.tp-dia       with frame {&frame-name}.
            enable  man-fam.faixa-utiliz with frame {&frame-name}.
        end.

        when 3 then DO:
            enable  man-fam.faixa-tempo  with frame {&frame-name}.
            enable  man-fam.faixa-utiliz with frame {&frame-name}.
            enable  man-fam.tp-dia       with frame {&frame-name}.
        end.
    end case.

    if  manut.cd-tipo = tt-manut.cd-tipo then
        disable man-fam.cd-tipo with frame {&frame-name}.

    if  manut.cd-sint-padr = tt-manut.cd-sint-padr then
        disable man-fam.cd-sint-padr with frame {&frame-name}.

    if  manut.cd-causa-padr = tt-manut.cd-causa-padr then
        disable  man-fam.cd-causa-padr  with frame {&frame-name}.

    if  manut.cd-interv-padr = tt-manut.cd-interv-padr then
        disable  man-fam.cd-interv-padr with frame {&frame-name}.

    if  manut.situacao = tt-manut.situacao then
        disable  man-fam.situacao with frame {&frame-name}.

    if  manut.controle = tt-manut.controle then
        disable man-fam.controle with frame {&frame-name}.

    if  manut.faixa-tempo = tt-manut.faixa-tempo then
        disable  man-fam.faixa-tempo with frame {&frame-name}.

    if  manut.tp-dia = tt-manut.tp-dia then
        disable man-fam.tp-dia with frame {&frame-name}.

    if  manut.faixa-utiliz = tt-manut.faixa-utiliz then
        disable man-fam.faixa-utiliz   with frame {&frame-name}.
    
    &if defined (bf_mnt_ems204) &then
     if  manut.urgencia  =  tt-manut.urgencia   then
           disable rs-urgencia with frame {&frame-name}.
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

    { utp/ut-rtlbl.i mgind man-fam  situacao c-situacao }
    { utp/ut-rtlbl.i mgind man-fam  controle c-controle }
    { utp/ut-rtlbl.i mgind man-fam  tp-dia   c-tp-dia } 
    &if defined(bf_mnt_ems204) &then 
    { utp/ut-rtlbl.i mgind man-fam  urgencia c-urgencia } 
    rs-urgencia:radio-buttons in frame {&frame-name} = {ininc/i02in434.i 07}.
    assign p-urgencia:hidden  in frame {&frame-name} = no
           rs-urgencia:hidden in frame {&frame-name} = no.
    &endif
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
    def input param table for tt-manut.
    find first tt-manut
        no-lock no-error.

    find manut
        where manut.cd-manut = tt-manut.cd-manut
        no-lock no-error.
    
    
    find man-fam
        where rowid(man-fam) = gr-man-fam
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

    if  manut.cd-tipo <> tt-manut.cd-tipo then
        assign man-fam.cd-tipo:screen-value in frame {&frame-name} =
                                      string(manut.cd-tipo).

    if  manut.cd-sint-padr <> tt-manut.cd-sint-padr then
        assign man-fam.cd-sint-padr:screen-value in frame {&frame-name} =
                                      string(manut.cd-sint-padr).

    if  manut.cd-causa-padr <> tt-manut.cd-causa-padr then
        assign man-fam.cd-causa-padr:screen-value in frame {&frame-name} =
                                      string(manut.cd-causa-padr).

    if  manut.cd-interv-padr <> tt-manut.cd-interv-padr then
        assign man-fam.cd-interv-padr:screen-value in frame {&frame-name} =
                                      string(manut.cd-interv-padr).

    if  manut.situacao <> tt-manut.situacao then
        assign man-fam.situacao:screen-value in frame {&frame-name} =
                                      string(manut.situacao). 
 
    if  manut.controle <> tt-manut.controle then
        assign man-fam.controle:screen-value in frame {&frame-name} =
                                      string(manut.controle).

    if  manut.faixa-tempo <> tt-manut.faixa-tempo then
        assign man-fam.faixa-tempo:screen-value in frame {&frame-name} =
                                      string(manut.faixa-tempo).

    if  manut.tp-dia <> tt-manut.tp-dia then
        assign man-fam.tp-dia:screen-value in frame {&frame-name} =
                                      string(manut.tp-dia).

    if  manut.faixa-utiliz <> tt-manut.faixa-utiliz then
        assign man-fam.faixa-utiliz:screen-value in frame {&frame-name} =
                                      string(manut.faixa-utiliz).
    &if defined (bf_mnt_ems204) &then
    if  manut.urgencia   <>  tt-manut.urgencia   then
        assign rs-urgencia:screen-value   in frame {&frame-name} = string(manut.urgencia).
    &endif

    if  available man-fam then do:
        find tipo-manut
            where tipo-manut.cd-tipo = man-fam.cd-tipo
            no-lock no-error.
        assign c-desc-manut = if  avail tipo-manut then tipo-manut.descricao else "":U.
        disp c-desc-manut with frame {&frame-name}.

        find causa-padrao
            where causa-padrao.cd-causa-padr = man-fam.cd-causa-padr
            no-lock no-error.
        assign c-desc-causa = if  avail causa-padrao then causa-padrao.descricao else "":U.
        disp c-desc-causa with frame {&frame-name}.

        find sint-padrao
            where sint-padrao.cd-sint-padr = man-fam.cd-sint-padr
            no-lock no-error.
        assign c-desc-sint = if  avail sint-padrao then sint-padrao.descricao else "":U.
        disp c-desc-sint with frame {&frame-name}.

        find interv-padrao
            where interv-padrao.cd-interv-padr = man-fam.cd-interv-padr
            no-lock no-error.
        assign c-desc-interv = if  avail interv-padrao then interv-padrao.descricao else "":U.
        disp c-desc-interv with frame {&frame-name}.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 {include/i-vldfrm.i}  /* Validaá∆o de dicion†rio */
 /* OBSERCAÄAO= NAO PODE TER LINK DE GROUP-ASSIGN C/ A V10=> NAO GRAVA NADA */

 if  man-fam.cd-tipo:sensitive in frame {&frame-name} = yes 
      and  not can-find (tipo-manut where tipo-manut.cd-tipo = 
                   input frame {&frame-name} man-fam.cd-tipo )
  then do: 
      {include/i-vldprg.i}  /* posiciona pagina */
      {utp/ut-table.i mgind tipo-manut 1}
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to man-fam.cd-tipo.
      return 'ADM-ERROR'.
  end.   
  
  
  if  man-fam.cd-causa-padr:sensitive in frame {&frame-name} = yes 
      and ( input frame {&frame-name} man-fam.cd-causa-padr = "" 
      or not can-find ( causa-padrao where causa-padrao.cd-causa-padr = 
                       input frame {&frame-name} man-fam.cd-causa-padr ))
  then do: 
      {include/i-vldprg.i}  /* posiciona pagina */
      {utp/ut-table.i mgind causa-padrao 1}
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to man-fam.cd-causa-padr.
      return 'ADM-ERROR'.
  end.  
    
  
  if  man-fam.cd-sint-padr:sensitive in frame {&frame-name} = yes 
      and ( input frame {&frame-name} man-fam.cd-sint-padr = "" 
      or not can-find ( sint-padrao where sint-padrao.cd-sint-padr = 
                       input frame {&frame-name} man-fam.cd-sint-padr ))
  then do: 
      {include/i-vldprg.i}  /* posiciona pagina */
      {utp/ut-table.i mgind sint-padrao 1}
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to man-fam.cd-sint-padr.
      return 'ADM-ERROR'.
  end.     


  if  man-fam.cd-interv-padr:sensitive in frame {&frame-name} = yes 
      and ( input frame {&frame-name} man-fam.cd-interv-padr = "" 
      or not can-find ( interv-padrao where interv-padrao.cd-interv-padr = 
                       input frame {&frame-name} man-fam.cd-interv-padr ))
  then do: 
      {include/i-vldprg.i}  /* posiciona pagina */
      {utp/ut-table.i mgind interv-padrao 1}
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to man-fam.cd-interv-padr.
      return 'ADM-ERROR'.
  end.   
   
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
  {src/adm/template/snd-list.i "man-fam"}

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



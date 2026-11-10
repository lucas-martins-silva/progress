&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i V01IN083 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN083 MUT}
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key estab-dest c-3 IMAGE-16 IMAGE-14 c-4 ~
i-tipo-custo-1 IMAGE-9 IMAGE-10 i-tipo-custo-2 dt-custo-1 IMAGE-17 IMAGE-13 ~
dt-custo-2 ge-codigo-1 IMAGE-18 IMAGE-15 ge-codigo-2 fm-codigo-1 IMAGE-19 ~
IMAGE-12 fm-codigo-2 
&Scoped-Define DISPLAYED-OBJECTS estab-dest c-3 c-4 i-tipo-custo-1 ~
i-tipo-custo-2 dt-custo-1 dt-custo-2 ge-codigo-1 ge-codigo-2 fm-codigo-1 ~
fm-codigo-2 

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
DEFINE VARIABLE c-3 AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-4 AS CHARACTER FORMAT "X(3)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE dt-custo-1 AS DATE FORMAT "99/99/9999" INITIAL ? 
     LABEL "Data do Custo":R22 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE dt-custo-2 AS DATE FORMAT "99/99/9999" INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE estab-dest AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento Destino" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fm-codigo-1 AS CHARACTER FORMAT "x(8)" 
     LABEL "Fam¡lia de Material":R18 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .88 NO-UNDO.

DEFINE VARIABLE fm-codigo-2 AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .88 NO-UNDO.

DEFINE VARIABLE ge-codigo-1 AS INTEGER FORMAT "99" INITIAL 0 
     LABEL "Grupo de Estoque":R25 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE ge-codigo-2 AS INTEGER FORMAT "99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-tipo-custo-1 AS INTEGER FORMAT "99" INITIAL 0 
     LABEL "Tipo de Custo":R22 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-tipo-custo-2 AS INTEGER FORMAT "99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-12
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-13
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-14
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-15
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-16
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-17
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-18
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-19
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-9
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89.72 BY 6.27.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estab-dest AT ROW 1.15 COL 27 COLON-ALIGNED
     c-3 AT ROW 2.15 COL 27 COLON-ALIGNED
     c-4 AT ROW 2.15 COL 51 COLON-ALIGNED NO-LABEL
     i-tipo-custo-1 AT ROW 3.15 COL 27 COLON-ALIGNED HELP
          "Tipo do custo inicial"
     i-tipo-custo-2 AT ROW 3.15 COL 51 COLON-ALIGNED HELP
          "Tipo do custo inicial" NO-LABEL
     dt-custo-1 AT ROW 4.15 COL 27 COLON-ALIGNED HELP
          "Data do custo inicial"
     dt-custo-2 AT ROW 4.15 COL 51 COLON-ALIGNED HELP
          "Data do custo inicial" NO-LABEL
     ge-codigo-1 AT ROW 5.15 COL 27 COLON-ALIGNED HELP
          "Grupo de estoque inicial"
     ge-codigo-2 AT ROW 5.15 COL 51 COLON-ALIGNED HELP
          "Grupo de estoque inicial" NO-LABEL
     fm-codigo-1 AT ROW 6.15 COL 27 COLON-ALIGNED HELP
          "Fam¡lia inicial"
     fm-codigo-2 AT ROW 6.15 COL 51 COLON-ALIGNED HELP
          "Fam¡lia inicial" NO-LABEL
     rt-key AT ROW 1 COL 1
     IMAGE-16 AT ROW 2.15 COL 42
     IMAGE-14 AT ROW 2.15 COL 49.72
     IMAGE-9 AT ROW 3.15 COL 42
     IMAGE-10 AT ROW 3.15 COL 49.72
     IMAGE-17 AT ROW 4.15 COL 42
     IMAGE-13 AT ROW 4.15 COL 49.72
     IMAGE-18 AT ROW 5.15 COL 42
     IMAGE-15 AT ROW 5.15 COL 49.72
     IMAGE-19 AT ROW 6.15 COL 42
     IMAGE-12 AT ROW 6.15 COL 49.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 6.27
         WIDTH              = 89.72.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {utp/ut-liter.i Estabelecimento_Destino * L}
  assign estab-dest:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Estabelecimento * L}
  assign c-3:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Tipo_Custo * L}
  assign i-tipo-custo-1:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Data_Custo * L}
  assign dt-custo-1:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Grupo_Estoque * L}
  assign ge-codigo-1:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Fam¡lia_Material * L}
  assign fm-codigo-1:label in frame {&frame-name} = return-value.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita-campos V-table-Win 
PROCEDURE pi-desabilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  disable c-3 c-4 dt-custo-1 dt-custo-2 estab-dest fm-codigo-1 fm-codigo-2 ge-codigo-1 ge-codigo-2 i-tipo-custo-1 i-tipo-custo-2 with frame {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-display V-table-Win 
PROCEDURE pi-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  display estab-dest c-3 c-4 i-tipo-custo-1 i-tipo-custo-2 dt-custo-1 dt-custo-2 ge-codigo-1 ge-codigo-2 fm-codigo-1 fm-codigo-2 with frame {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-dados V-table-Win 
PROCEDURE pi-exporta-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define input parameter cd-transacao as character format "x(06)".
  define input parameter arquivo      as character format "x(50)".
  define input parameter dt-ult-at    as date format "99/99/9999".
  define input parameter hr-ult-at    as character.
  define input parameter us-ult-at    as character format "x(12)".
  define input parameter c-dir        as character no-undo.  
  
  define var c-11 as char.
  define var c-12 as char.
  define var c-13 as char.
  define var c-14 as char.
  define var c-15 as char.
  define var c-16 as char.  
  
  output to value(c-dir + "\" + arquivo).
  assign c-11 = string(input frame {&frame-name} i-tipo-custo-1)
         c-12 = string(input frame {&frame-name} i-tipo-custo-2)
         c-15 = string(input frame {&frame-name} ge-codigo-1)
         c-16 = string(input frame {&frame-name} ge-codigo-2).
         
  export input frame {&frame-name} estab-dest 
         input frame {&frame-name} c-3
         input frame {&frame-name} c-4
         c-11
         c-12
         input frame {&frame-name} dt-custo-1
         input frame {&frame-name} dt-custo-2
         c-15
         c-16
         input frame {&frame-name} fm-codigo-1
         input frame {&frame-name} fm-codigo-2.
  
  put skip(1).
  export arquivo.
  export "<ID-PARAM>".
  export cd-transacao.
  export dt-ult-at.
  export hr-ult-at.
  export us-ult-at.
  output close.          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos V-table-Win 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  enable  c-3 c-4 dt-custo-1 dt-custo-2 estab-dest fm-codigo-1 fm-codigo-2 ge-codigo-1 ge-codigo-2 i-tipo-custo-1 i-tipo-custo-2 with frame {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campos V-table-Win 
PROCEDURE pi-inicializa-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  assign estab-dest     = ""
         c-3            = ""
         c-4            = "zzz"
         i-tipo-custo-1 = 0
         i-tipo-custo-2 = 99
         dt-custo-1     = 01/01/0001
         dt-custo-2     = today
         ge-codigo-1    = 0
         ge-codigo-2    = 99
         fm-codigo-1    = ""
         fm-codigo-2    = "zzzzzzzz".
  display estab-dest c-3 c-4 i-tipo-custo-1 i-tipo-custo-2 dt-custo-1 dt-custo-2 ge-codigo-1 ge-codigo-2 fm-codigo-1 fm-codigo-2 with frame {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-campos V-table-Win 
PROCEDURE pi-limpa-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  clear frame {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-dados V-table-Win 
PROCEDURE pi-mostra-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define input parameter arquivo     as char format "x(50)" no-undo.
  define input parameter c-diretorio as char format "x(40)" no-undo.
  
  input from value(c-diretorio + "\" + arquivo) no-echo.
  set estab-dest c-3 c-4 i-tipo-custo-1 i-tipo-custo-2 dt-custo-1 dt-custo-2 ge-codigo-1 ge-codigo-2 fm-codigo-1 fm-codigo-2 with frame {&frame-name}.
  display  estab-dest c-3 c-4 i-tipo-custo-1 i-tipo-custo-2 dt-custo-1 dt-custo-2 ge-codigo-1 ge-codigo-2 fm-codigo-1 fm-codigo-2 with frame {&frame-name}.      

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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



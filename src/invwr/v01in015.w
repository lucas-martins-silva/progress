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
{include/i-prgvrs.i V01IN015 2.00.00.003 } /*** "010003" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in015 MUT}
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
def new global shared var gr-estrutura as rowid no-undo.          
/*def new global shared var de-quant          as decimal no-undo.*/

/* Parameters Definitions ---                                           */

{cdp/cdcfgman.i}
{cdp/cdcfgren.i} /*Include com PrÇ-Processador da Grendene*/

/* Local Variable Definitions ---                                       */
def buffer b-alternativo   for alternativo.
def buffer b-item          for item.
def buffer b-estrutura     for estrutura.
def var c-msg-erro as char format "x(2000)"     no-undo.
def var rw-parent as rowid no-undo.

def var de-quant-usada like alternativo.quant-usada no-undo.

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
&Scoped-define EXTERNAL-TABLES alternativo
&Scoped-define FIRST-EXTERNAL-TABLE alternativo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR alternativo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS alternativo.util-aloca alternativo.log-quant-fix ~
alternativo.fator-perda alternativo.quant-usada alternativo.observacao 
&Scoped-define ENABLED-TABLES alternativo
&Scoped-define FIRST-ENABLED-TABLE alternativo
&Scoped-define DISPLAYED-TABLES estrutura alternativo
&Scoped-define FIRST-DISPLAYED-TABLE estrutura
&Scoped-define SECOND-DISPLAYED-TABLE alternativo
&Scoped-Define ENABLED-OBJECTS de-quant-liquid rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS estrutura.it-codigo estrutura.sequencia ~
estrutura.es-codigo alternativo.ordem alternativo.al-codigo ~
alternativo.util-aloca alternativo.log-quant-fix alternativo.fator-perda alternativo.quant-usada ~
alternativo.observacao 
&Scoped-Define DISPLAYED-OBJECTS c-desc-item-pai c-desc-es c-descricao-item ~
fi-per-ppm c-un-item de-quant-liquid 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS alternativo.ordem alternativo.al-codigo 

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
DEFINE VARIABLE c-desc-es AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item-pai AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-item AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-item AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE de-quant-liquid AS DECIMAL FORMAT "->>,>>9.9999999999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-per-ppm AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL ? 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 91.43 BY 5.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 91.43 BY 5.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estrutura.it-codigo AT ROW 1.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item-pai AT ROW 1.17 COL 42.57 COLON-ALIGNED NO-LABEL
     estrutura.sequencia AT ROW 2.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     estrutura.es-codigo AT ROW 3.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-es AT ROW 3.17 COL 42.57 COLON-ALIGNED NO-LABEL
     alternativo.ordem AT ROW 4.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     alternativo.al-codigo AT ROW 5.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao-item AT ROW 5.17 COL 42.57 COLON-ALIGNED NO-LABEL
     alternativo.util-aloca AT ROW 6.63 COL 27
          VIEW-AS TOGGLE-BOX
          SIZE 23.72 BY .88
     alternativo.log-quant-fix AT ROW 6.63 COL 45
          LABEL "Quantidade Fixa"
          VIEW-AS TOGGLE-BOX
          SIZE 30 BY .88
     fi-per-ppm AT ROW 6.71 COL 65 COLON-ALIGNED
     alternativo.fator-perda AT ROW 7.58 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     alternativo.quant-usada AT ROW 8.71 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     c-un-item AT ROW 8.71 COL 41.86 COLON-ALIGNED NO-LABEL
     de-quant-liquid AT ROW 9.83 COL 25 COLON-ALIGNED HELP
          "Quantidade L°quida"
     alternativo.observacao AT ROW 10.96 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 6.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.alternativo
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
         HEIGHT             = 11.29
         WIDTH              = 92.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN alternativo.al-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN c-desc-es IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item-pai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estrutura.es-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-per-ppm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estrutura.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN alternativo.ordem IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN estrutura.sequencia IN FRAME f-main
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





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME alternativo.al-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alternativo.al-codigo V-table-Win
ON F5 OF alternativo.al-codigo IN FRAME f-main /* Componente Alternativo */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                     &campo=alternativo.al-codigo
                     &campozoom=it-codigo
                     &campo2=c-descricao-item
                     &campozoom2=desc-item
                     &campo3=c-un-item
                     &campozoom3=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alternativo.al-codigo V-table-Win
ON LEAVE OF alternativo.al-codigo IN FRAME f-main /* Componente Alternativo */
DO:
  {include/leave.i &tabela=item
                   &atributo-ref=desc-item
                   &variavel-ref=c-descricao-item
                   &atributo-ref2=un
                   &variavel-ref2=c-un-item
                   &where="item.it-codigo = input frame {&frame-name} alternativo.al-codigo"}

  &IF DEFINED (bf_man_per_ppm) &THEN
    if param-global.modulo-per-ppm then do:  
        find b-item where
             b-item.it-codigo = alternativo.al-codigo:screen-value in frame {&frame-name} no-lock no-error.
        if avail b-item then
            case b-item.tipo-formula:
                when 2 then
                    run pi-formata-campo (fi-per-ppm:handle, true, false, b-item.per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
                when 3 then
                    run pi-formata-campo (fi-per-ppm:handle, true, false, b-item.per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
                otherwise do:
                    run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
                end.
             end case.
    end.
  &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alternativo.al-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF alternativo.al-codigo IN FRAME f-main /* Componente Alternativo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-quant-liquid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-quant-liquid V-table-Win
ON LEAVE OF de-quant-liquid IN FRAME f-main
DO:
    ASSIGN de-quant-usada = ((INPUT FRAME {&frame-name} de-quant-liquid) /
                             ( 1 - ((INPUT FRAME {&frame-name} alternativo.fator-perda) / 100))). 

    disp de-quant-usada @ alternativo.quant-usada with frame {&FRAME-NAME}.                                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME alternativo.fator-perda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alternativo.fator-perda V-table-Win
ON LEAVE OF alternativo.fator-perda IN FRAME f-main /* Quantidade */
DO:
   assign de-quant-liquid = ((input frame {&FRAME-NAME} alternativo.quant-usada) - 
                            ((input frame {&FRAME-NAME} alternativo.quant-usada) * (input frame {&FRAME-NAME} alternativo.fator-perda)  / 100 )). 

   disp de-quant-liquid with frame {&FRAME-NAME}.                                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME alternativo.quant-usada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alternativo.quant-usada V-table-Win
ON LEAVE OF alternativo.quant-usada IN FRAME f-main /* Quantidade */
DO:
   assign de-quant-liquid = ((input frame {&FRAME-NAME} alternativo.quant-usada) - 
                            ((input frame {&FRAME-NAME} alternativo.quant-usada) * (input frame {&FRAME-NAME} alternativo.fator-perda)  / 100 )). 

   disp de-quant-liquid with frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME alternativo.log-quant-fix 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alternativo.log-quant-fix V-table-Win
ON VALUE-CHANGED OF alternativo.log-quant-fix  IN FRAME f-main /* D_MAN002 - Quantidade fixa para componentes de engenharia */
DO:
    if  alternativo.log-quant-fix:checked  in frame {&frame-name} = YES THEN DO:
        assign alternativo.fator-perda:SCREEN-VALUE in frame {&frame-name} = "0"
               alternativo.fator-perda:SENSITIVE in frame {&frame-name} = FALSE
               de-quant-liquid:SCREEN-VALUE in frame {&frame-name} = STRING(INPUT FRAME {&frame-name} alternativo.quant-usada)
               de-quant-liquid:SENSITIVE in frame {&frame-name} = FALSE.
    END.
    ELSE DO:
        assign  alternativo.fator-perda:SENSITIVE in frame {&frame-name} = TRUE
                de-quant-liquid:SENSITIVE in frame {&frame-name} = TRUE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if alternativo.al-codigo:load-mouse-pointer ("image/lupa.cur") then.

  {utp/ut-field.i mgind estrutura quant-liquid 01}
  assign de-quant-liquid:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Componente_Alternativo * L}
  assign alternativo.al-codigo:help in frame {&frame-name} = return-value.

  {utp/ut-liter.i Quantidade_L°quida * L}
  assign de-quant-liquid:help in frame {&frame-name} = return-value.

  find estrutura where rowid(estrutura) = gr-estrutura no-lock no-error.

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
  {src/adm/template/row-list.i "alternativo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "alternativo"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  find last param-en no-lock no-error.
  find last b-alternativo where b-alternativo.it-codigo = estrutura.it-codigo
                          AND   b-alternativo.sequencia = estrutura.sequencia
                          AND   b-alternativo.es-codigo = estrutura.es-codigo no-lock no-error.
  if  avail b-alternativo then 
     assign alternativo.ordem:screen-value in frame {&frame-name} = string(b-alternativo.ordem + param-en.num-var-estrutura).
  else
     assign alternativo.ordem:screen-value in frame {&frame-name} = string(param-en.num-var-estrutura).

  /* Code placed here will execute AFTER standard behavior.    */
  display c-desc-item-pai c-desc-es with frame {&frame-name}.




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
/*  {include/i-valid.i} */
    define variable c-erro as character no-undo.

  find estrutura where rowid(estrutura) = rw-parent no-lock no-error.

  {include/i-vldfrm.i}
  {include/i-vldprg.i} 
  if input frame {&FRAME-NAME} alternativo.quant-usada = 0 and
     input frame {&FRAME-NAME} de-quant-liquid = 0 then do:
     run utp/ut-msgs.p (input "show",   
                        input   1368,
                        input     "").  
     apply 'entry' to alternativo.quant-usada in frame {&FRAME-NAME}.
     return 'adm-error':U. 
  end.

  run pi-validate.
  if return-value = 'ADM-ERROR':U then 
    return 'ADM-ERROR':U.

  &IF DEFINED (bf_man_per_ppm) &THEN
    if param-global.modulo-per-ppm then do:
        find first b-item where
                   b-item.it-codigo = alternativo.al-codigo:screen-value in frame {&frame-name} no-lock no-error.
        if avail b-item      and
           estrutura.veiculo and
           b-item.tipo-formula <> 4 then do:

            run utp/ut-msgs.p (input "show",   
                               input 27305,
                               input "").
            return 'adm-error':u.

        end.
    end.
  &ENDIF

  /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    if return-value = 'ADM-ERROR':U then 
       return 'ADM-ERROR':U.

    /* Code placed here will execute AFTER standard behavior.    */


    do on error undo, leave:
        validate alternativo NO-ERROR. /*dts-mexico*/
    end.

    &if defined (CUSTOM_GRENDENE) &then

        assign c-erro = return-value.

        if c-erro <> "ok" then
            run pi-identifica-erro.

        if c-erro <> "alfr" and c-erro <> "ok" and return-value = 'ADM-ERROR' then return 'ADM-ERROR':U.

        run enp/gen0105b.p (input 1, input alternativo.al-codigo, input alternativo.quant-usada, input-output c-erro).

    &else
        run pi-identifica-erro.

        IF RETURN-VALUE = 'ADM-ERROR':u THEN RETURN 'ADM-ERROR':U. 

    &endif


    return "ok":U.    



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
  if avail estrutura then
     assign alternativo.it-codigo = estrutura.it-codigo
            alternativo.sequencia = estrutura.sequencia
            alternativo.es-codigo = estrutura.es-codigo.
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

    if  avail alternativo then do:
        find item 
            where item.it-codigo = alternativo.al-codigo no-lock no-error.

        assign c-un-item        = if avail item then item.un else "":U
               c-descricao-item = if avail item then item.desc-item else "":U.

        assign de-quant-liquid = alternativo.quant-usada - 
                                (alternativo.quant-usada * alternativo.fator-perda / 100).    
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
  run get-attribute ('adm-new-record').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  &IF DEFINED (bf_man_per_ppm) &THEN
    if param-global.modulo-per-ppm and 
       avail alternativo then do:  
        find b-item where
             b-item.it-codigo = alternativo.al-codigo no-lock no-error.
        if avail b-item then
            case b-item.tipo-formula:
                when 2 then
                    run pi-formata-campo (fi-per-ppm:handle in frame {&frame-name}, true, false, b-item.per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
                when 3 then
                    run pi-formata-campo (fi-per-ppm:handle, true, false, b-item.per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
                otherwise do:
                    run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
                end.
             end case.
    end.
  &ENDIF  
  
  if  alternativo.log-quant-fix:checked in frame {&frame-name} = yes then do:
        assign  alternativo.fator-perda:sensitive in frame {&frame-name} = false
                de-quant-liquid:sensitive in frame {&frame-name} = false.
  END.

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

  find estrutura where rowid(estrutura) = v-row-parent no-lock no-error.

  assign rw-parent = v-row-parent.

  find item where item.it-codigo = estrutura.it-codigo no-lock no-error.
  assign c-desc-item-pai = if avail item then item.desc-item else "".

  find item where item.it-codigo = estrutura.es-codigo no-lock no-error.
  assign c-desc-es = if avail item then item.desc-item else "".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  find first param-global no-lock.

  assign fi-per-ppm:visible in frame {&frame-name} = false.    

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campo V-table-Win 
PROCEDURE pi-formata-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pHandle      as handle no-undo.
def input param pVisible     as log    no-undo.
def input param pSensitive   as log    no-undo.
def input param pScreenValue as char   no-undo.
def input param pLabel       as char   no-undo.
def input param pFormat      as char   no-undo.

    if pVisible then
        assign pHandle:visible      = pVisible
               pHandle:sensitive    = pSensitive
               pHandle:format       = pFormat
               pHandle:screen-value = pScreenValue
               pHandle:label        = pLabel no-error.
    else
        assign pHandle:visible = pVisible no-error.

return 'ok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-identifica-erro V-table-Win 
PROCEDURE pi-identifica-erro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*assign c-msg-erro = ''.

if return-value = 'alfr':U then 
   apply 'entry' to alternativo.quant-usada in frame {&frame-name}.
else
   apply 'entry' to alternativo.al-codigo in frame {&frame-name}.      
*/

    {enp/en0116.i "show" 
               estrutura.es-codigo
               alternativo.ordem
               alternativo.al-codigo
               1}



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  def var c-label as char no-undo. 

  /*** Validaá∆o de chave duplicada ***/   
  if alternativo.ordem:sensitive in frame {&frame-name} = yes 
  and (can-find(first b-alternativo 
                where b-alternativo.it-codigo = estrutura.it-codigo
                and   b-alternativo.sequencia = estrutura.sequencia
                and   b-alternativo.es-codigo = estrutura.es-codigo
                and   b-alternativo.ordem     = input frame {&frame-name} alternativo.ordem)
  or   can-find(first b-alternativo 
                where b-alternativo.it-codigo = estrutura.it-codigo
                and   b-alternativo.sequencia = estrutura.sequencia
                and   b-alternativo.es-codigo = estrutura.es-codigo
                and   b-alternativo.al-codigo = input frame {&frame-name} alternativo.al-codigo)) then 
  do:
     {utp/ut-field.i mgind alternativo ordem 1}
     assign c-label = trim(return-value).
     {utp/ut-field.i mgind alternativo al-codigo 1}
     assign c-label = c-label + "/" + trim(return-value).
     run utp/ut-msgs.p (input "show",
                        input 1,
                        input c-label).
     apply "entry" to alternativo.ordem in frame {&frame-name}.                   
     return 'ADM-ERROR':U.
  end.

  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

  /*** item alternativo deve ser diferente de branco ***/
  if input frame {&frame-name} alternativo.al-codigo = " " then do:
     {utp/ut-field.i mgind alternativo al-codigo 1}
     run utp/ut-msgs.p (input "show",
                        input 164,
                        input return-value).
     apply "entry" to alternativo.al-codigo in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.

  find b-item 
       where b-item.it-codigo = input frame {&frame-name} alternativo.al-codigo 
       no-lock no-error.
  IF NOT avail b-item THEN DO:
     {utp/ut-field.i mgind alternativo al-codigo 1}
     run utp/ut-msgs.p (input "show",
                        input 56,
                        input return-value).
     apply "entry" to alternativo.al-codigo in frame {&frame-name}.                   
     return 'ADM-ERROR':U.
  END.
  /*** componente alternativo n∆o pode ser de dÇbito direto ***/
  if b-item.tipo-contr = 4 then do:
     {utp/ut-field.i mgind alternativo al-codigo 1}
     run utp/ut-msgs.p (input "show",
                        input 2352,
                        input return-value).
     apply "entry" to alternativo.al-codigo in frame {&frame-name}.                   
     return 'ADM-ERROR':U.
  end.

  /*** se componente for controlado por referància ent∆o somente   ***/
  /*** poder∆o ser informados componentes alternativos que possuam ***/
  /*** controle por referància, caso contr†rio AMBOS N«O poder∆o   ***/
  /*** ser controlados por referància.                             ***/
  find item where item.it-codigo = estrutura.es-codigo no-lock no-error.
  if (item.tipo-con-est = 4 and b-item.tipo-con-est <> 4) 
  or (item.tipo-con-est <> 4 and b-item.tipo-con-est = 4) then do:
     run utp/ut-msgs.p (input "show",
                        input 2361,
                        input "").
     apply "entry" to alternativo.al-codigo in frame {&frame-name}.                   
     return 'ADM-ERROR':U.
  end.

  /*** componente alternativo n∆o pode ser igual ao componente corrente ***/  
  if input frame {&frame-name} alternativo.al-codigo = estrutura.es-codigo then do:
     {utp/ut-field.i mgind alternativo al-codigo 1}
     assign c-label = return-value.
     {utp/ut-field.i mgind estrutura es-codigo 1}
     run utp/ut-msgs.p (input "show",
                        input 1737,
                        input c-label + "~~" + return-value).
     apply "entry" to alternativo.al-codigo in frame {&frame-name}.                   
     return 'ADM-ERROR':U.
  end.

  /*** componente alternativo n∆o pode ser igual ao item pai da estrutura ***/  
  if input frame {&frame-name} alternativo.al-codigo = estrutura.it-codigo then do:
     {utp/ut-field.i mgind alternativo al-codigo 1}
     assign c-label = return-value.
     {utp/ut-field.i mgidn estrutura it-codigo 1}
     run utp/ut-msgs.p (input "show",
                        input 1737,
                        input c-label + "~~" + return-value).
     apply "entry" to alternativo.al-codigo in frame {&frame-name}.                   
     return 'ADM-ERROR':U.
  end.

  /** Componente na estrutura com quantidade positiva n∆o pode ter alternativo com quantidade negativa **/
  if (&IF defined (bf_man_sfc_lc) &then estrutura.qtd-compon &else estrutura.quant-usada &endif  < 0) and
      input frame {&frame-name} alternativo.quant-usada > 0 then do:
     run utp/ut-msgs.p (input "show",
                        input 28516,
                        input '').
     apply "entry" to alternativo.quant-usada in frame {&frame-name}.                   
     return 'ADM-ERROR':U.
  end.

  /** Componente na estrutura com quantidade negativa n∆o pode ter alternativo com quantidade positiva **/
  if (&IF defined (bf_man_sfc_lc) &then estrutura.qtd-compon &else estrutura.quant-usada &endif  > 0) and
      input frame {&frame-name} alternativo.quant-usada < 0 then do:
     run utp/ut-msgs.p (input "show",
                        input 28517,
                        input '').
     apply "entry" to alternativo.quant-usada in frame {&frame-name}.                   
     return 'ADM-ERROR':U.
  end.


  RETURN "OK":U.



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
  {src/adm/template/snd-list.i "alternativo"}

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


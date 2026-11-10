&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0602 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0602 MBC}
&ENDIF




/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
{cdp/cdcfgint.i}

/* Local Variable Definitions ---                                       */
def var c-lit-programa as char    no-undo.
def var c-prog         as char    no-undo.
def var l-ok           as logical no-undo.
def var c-lit-progtxt  as char    no-undo.
def var c-lit-todos    as char    no-undo.

DEF TEMP-TABLE tt-tipo-etiqueta NO-UNDO
FIELD tabela      as char    format "x(30)"
FIELD tp-etiqueta as integer format "99"
FIELD sequencia   AS INTEGER
FIELD cod-layout  AS INTEGER
FIELD log-datasul AS LOGICAL
FIELD num-versao  AS INTEGER
FIELD num-layout-registro AS INTEGER
FIELD conteudo    AS RAW.

DEF TEMP-TABLE tt-tipo-etiqueta-aux NO-UNDO        LIKE tipo-etiqueta.
DEF TEMP-TABLE tt-seq-tipo-etiqueta-aux NO-UNDO    LIKE seq-tipo-etiqueta.

&IF '{&mgcld_version}' >= '2.02'
&THEN
DEF TEMP-TABLE tt-bc-layout-aux NO-UNDO               LIKE bc-layout.
DEF TEMP-TABLE tt-bc-layout-registro-aux NO-UNDO      LIKE bc-layout-registro.
DEF TEMP-TABLE tt-bc-layout-registro-item-aux NO-UNDO LIKE bc-layout-registro-item.
&ENDIF.

def var i             as int    no-undo.
def var c-arq         as char   no-undo.
def var c-arquiv      as char   no-undo.
def var c-importacao  as char   no-undo.
def var h-acomp       as handle no-undo.
def var c-imp-exp     as char   no-undo.

def var wh-pesquisa as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-12 RECT-13 IMAGE-7 IMAGE-8 RECT-1 ~
rs-imp-exp i-tp-etiq-ini i-tp-etiq-fim c-arquivo bt-arquivo bt-ok ~
bt-cancelar bt-ajuda c-texto 
&Scoped-Define DISPLAYED-OBJECTS rs-imp-exp i-tp-etiq-ini i-tp-etiq-fim ~
c-arquivo c-texto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image~\im-fold":U
     IMAGE-INSENSITIVE FILE "image~\ii-fold":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Diret¢rio" 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE c-texto AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo de Processo" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE i-tp-etiq-fim AS INTEGER FORMAT "9999":U INITIAL 9999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-tp-etiq-ini AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .75.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-las":U
     SIZE 3 BY .75.

DEFINE VARIABLE rs-imp-exp AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Exporta‡Æo", 1,
"Importa‡Æo", 2
     SIZE 35 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 68 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 1.75.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 3.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     rs-imp-exp AT ROW 2 COL 4 NO-LABEL
     i-tp-etiq-ini AT ROW 4 COL 11 COLON-ALIGNED
     i-tp-etiq-fim AT ROW 4 COL 37 COLON-ALIGNED NO-LABEL
     c-arquivo AT ROW 5.25 COL 11 COLON-ALIGNED
     bt-arquivo AT ROW 5.25 COL 65 HELP
          "Configura‡Æo da impressora"
     bt-ok AT ROW 6.96 COL 3
     bt-cancelar AT ROW 6.96 COL 14
     bt-ajuda AT ROW 6.96 COL 59
     c-texto AT ROW 1.25 COL 2 COLON-ALIGNED NO-LABEL
     RECT-12 AT ROW 1.5 COL 2
     RECT-13 AT ROW 3.5 COL 2
     IMAGE-7 AT ROW 4 COL 27
     IMAGE-8 AT ROW 4 COL 36
     RECT-1 AT ROW 6.75 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70.14 BY 7.33.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "Exporta‡Æo/Importa‡Æo Etiquetas"
         HEIGHT             = 7.33
         WIDTH              = 70.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Exporta‡Æo/Importa‡Æo Etiquetas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Exporta‡Æo/Importa‡Æo Etiquetas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-livre
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo w-livre
ON CHOOSE OF bt-arquivo IN FRAME f-cad
DO:
  
    {utp/ut-liter.i "Abrir Arquivo" * L}
    assign c-lit-programa = trim(return-value).
    SYSTEM-DIALOG GET-FILE c-prog
       FILTERS c-lit-progtxt "*.etq",
               c-lit-todos "*.*"
       DEFAULT-EXTENSION "*.etq"
       INITIAL-DIR replace(c-arquivo:screen-value in frame {&FRAME-NAME},"/","~\")
       RETURN-TO-START-DIR
       TITLE c-lit-programa
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        display c-prog @ c-arquivo with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-livre
ON CHOOSE OF bt-cancelar IN FRAME f-cad /* Cancelar */
DO:
  apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-livre
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
    
    assign file-info:file-name = input frame {&FRAME-NAME} c-arquivo.
    
    if rs-imp-exp:screen-value in frame {&FRAME-NAME} = "1" then do:

        if file-info:pathname = ? then do:
            run utp/ut-msgs.p (input "show",
                               input 4715,
                               input c-arquivo:screen-value in frame {&FRAME-NAME}).
            apply "entry" to c-arquivo in frame {&FRAME-NAME}.
            return no-apply.
        end.

        else do:

            if not file-info:file-type matches "*D*" then do:
                run utp/ut-msgs.p (input "show",
                                   input 4715,
                                   input c-arquivo:screen-value in frame {&FRAME-NAME}).
                apply "entry" to c-arquivo in frame {&FRAME-NAME}.
                return no-apply.
            end.
        end.
    end.

    else do:

        if file-info:pathname = ? then do:
            run utp/ut-msgs.p (input "show",
                               input 73,
                               input "").
            apply "entry" to c-arquivo in frame {&FRAME-NAME}.
            return no-apply.
        end.

        else do:

            if not file-info:file-type matches "*F*" then do:
                run utp/ut-msgs.p (input "show",
                                   input 73,
                                   input "").
                apply "entry" to c-arquivo in frame {&FRAME-NAME}.
                return no-apply.
            end.
        end.
    end.

    if rs-imp-exp:screen-value in frame {&FRAME-NAME} = "1" then
        run pi-exportacao.

    else
        run pi-importacao.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-arquivo w-livre
ON RETURN OF c-arquivo IN FRAME f-cad /* Diret¢rio */
DO:

  apply "choose" to bt-ok in frame {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-tp-etiq-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-etiq-fim w-livre
ON F5 OF i-tp-etiq-fim IN FRAME f-cad
DO:
    {include/zoomvar.i &prog-zoom="clzoom/z01cl015.w"
                       &campo=i-tp-etiq-fim
                       &campozoom=tipo-etiq}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-etiq-fim w-livre
ON MOUSE-SELECT-DBLCLICK OF i-tp-etiq-fim IN FRAME f-cad
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-tp-etiq-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-etiq-ini w-livre
ON F5 OF i-tp-etiq-ini IN FRAME f-cad /* Etiqueta */
DO:
    {include/zoomvar.i &prog-zoom="clzoom/z01cl015.w"
                       &campo=i-tp-etiq-ini
                       &campozoom=tipo-etiq}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-etiq-ini w-livre
ON MOUSE-SELECT-DBLCLICK OF i-tp-etiq-ini IN FRAME f-cad /* Etiqueta */
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-imp-exp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-imp-exp w-livre
ON VALUE-CHANGED OF rs-imp-exp IN FRAME f-cad
DO:
  
  if rs-imp-exp:screen-value in frame {&FRAME-NAME} = "1" then do:
      {utp/ut-liter.i Diret¢rio * L}
      assign i-tp-etiq-ini:sensitive in frame {&FRAME-NAME} = yes
             i-tp-etiq-fim:sensitive in frame {&FRAME-NAME} = yes
             bt-arquivo   :sensitive in frame {&FRAME-NAME} = no
             c-arquivo    :label     in frame {&FRAME-NAME} = trim(return-value).
  end.
  
  else do:
      {utp/ut-liter.i Arquivo * L}
      assign i-tp-etiq-ini:sensitive in frame {&FRAME-NAME} = no
             i-tp-etiq-fim:sensitive in frame {&FRAME-NAME} = no
             bt-arquivo   :sensitive in frame {&FRAME-NAME} = yes
             c-arquivo    :label     in frame {&FRAME-NAME} = trim(return-value).
  end.           

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

if i-tp-etiq-ini:load-mouse-pointer ("image~\lupa.cur") in frame {&FRAME-NAME} then.
if i-tp-etiq-fim:load-mouse-pointer ("image~\lupa.cur") in frame {&FRAME-NAME} then.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY rs-imp-exp i-tp-etiq-ini i-tp-etiq-fim c-arquivo c-texto 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE RECT-12 RECT-13 IMAGE-7 IMAGE-8 RECT-1 rs-imp-exp i-tp-etiq-ini 
         i-tp-etiq-fim c-arquivo bt-arquivo bt-ok bt-cancelar bt-ajuda c-texto 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
/*  run pi-before-initialize.*/

  {include/win-size.i}

{utp/ut9000.i "BC0602" "2.00.00.011"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  {utp/ut-rdset.i rs-imp-exp}
  
  {utp/ut-liter.i Etiqueta * L}
  assign i-tp-etiq-ini:label in frame {&FRAME-NAME} = trim(return-value).
  
  apply "value-changed" to rs-imp-exp in frame {&FRAME-NAME}.
  
  find first param-bc no-lock no-error.
  if avail param-bc then
      assign c-arquivo:screen-value in frame {&FRAME-NAME} = param-bc.nome-dir-etiq.

    {utp/ut-liter.i Tipo_de_Processo * L}
    assign c-texto:screen-value in frame {&FRAME-NAME} = trim(return-value). 
        
    {utp/ut-liter.i "Defini‡Æo Tipo Etiqueta" * L}
    assign c-lit-progtxt = trim(return-value) + " (*.etq)".
    
    {utp/ut-liter.i "Todos os arquivos" * L}
    assign c-lit-todos = trim(return-value) + " (*.*)".

/*  run pi-after-initialize.*/
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exportacao w-livre 
PROCEDURE pi-exportacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run utp/ut-acomp.p persistent set h-acomp.
    {utp/ut-liter.i "Exporta‡Æo de Etiquetas" * L}
    run pi-inicializar in h-acomp (input trim(return-value)).

    {utp/ut-liter.i Etiqueta * L}

    assign c-arq     = ""
           c-arq     = trim(c-arquivo:screen-value in frame {&FRAME-NAME})
           c-arq     = replace(c-arq,"/","~\")
           c-imp-exp = trim(return-value).

    if substring(c-arq,length(c-arq),1) <> "~\" then
        assign c-arq = c-arq + "~\".

    for each tt-tipo-etiqueta:
        delete tt-tipo-etiqueta.
    end.

do on stop undo, leave
   on quit undo, leave:
   
    for  each tipo-etiqueta
        where tipo-etiqueta.tipo-etiq >= integer(i-tp-etiq-ini:screen-value in frame {&FRAME-NAME})
          and tipo-etiqueta.tipo-etiq <= integer(i-tp-etiq-fim:screen-value in frame {&FRAME-NAME})
        no-lock:

        run pi-acompanhar in h-acomp (input c-imp-exp + ": " + string(tipo-etiqueta.tipo-etiq)).

        create tt-tipo-etiqueta.
        assign tt-tipo-etiqueta.tabela      = "tipo-etiqueta"
               tt-tipo-etiqueta.tp-etiqueta = tipo-etiqueta.tipo-etiq.
        create tt-tipo-etiqueta-aux.
        buffer-copy tipo-etiqueta to tt-tipo-etiqueta-aux.
        raw-transfer tt-tipo-etiqueta-aux to tt-tipo-etiqueta.conteudo.

        for  each seq-tipo-etiqueta
            where seq-tipo-etiqueta.tipo-etiq = tipo-etiqueta.tipo-etiq
            no-lock:
            
            create tt-tipo-etiqueta.
            assign tt-tipo-etiqueta.tabela          = "seq-tipo-etiqueta"
                    tt-tipo-etiqueta.tp-etiqueta    = seq-tipo-etiqueta.tipo-etiq
                    tt-tipo-etiqueta.sequencia      = seq-tipo-etiqueta.sequencia.
            create tt-seq-tipo-etiqueta-aux.
            buffer-copy seq-tipo-etiqueta to tt-seq-tipo-etiqueta-aux.
            raw-transfer tt-seq-tipo-etiqueta-aux to tt-tipo-etiqueta.conteudo.
        end.

        &IF '{&mgcld_version}' >= '2.02'
        &THEN
            &IF '{&mgcld_version}' >= '2.04'
            &THEN
            IF  tipo-etiq.ind-dimensao = 2 /* Etiquetas 2d */
            THEN DO:
                FOR EACH bc-layout NO-LOCK
                    WHERE bc-layout.cod-layout = tipo-etiq.cod-layout:
            &ELSE
            IF  tipo-etiq.int-2 = 2 /* Etiquetas 2d */
            THEN DO:
                FOR EACH bc-layout NO-LOCK
                    WHERE bc-layout.cod-layout = tipo-etiq.int-1:
            &ENDIF
                    CREATE  tt-tipo-etiqueta.
                    ASSIGN  tt-tipo-etiqueta.tabela         = "bc-layout"
                            tt-tipo-etiqueta.tp-etiqueta    = tipo-etiqueta.tipo-etiq
                            tt-tipo-etiqueta.cod-layout     = bc-layout.cod-layout
                            tt-tipo-etiqueta.log-datasul    = bc-layout.log-datasul
                            tt-tipo-etiqueta.num-versao     = bc-layout.num-versao.
    
                    CREATE  tt-bc-layout-aux.
                    BUFFER-COPY bc-layout to tt-bc-layout-aux.
                    RAW-TRANSFER tt-bc-layout-aux to tt-tipo-etiqueta.conteudo.
    
                    FOR  EACH bc-layout-registro NO-LOCK
                        WHERE bc-layout-registro.cod-layout  = bc-layout.cod-layout
                          AND bc-layout-registro.log-datasul = bc-layout.log-datasul
                          AND bc-layout-registro.num-versao  = bc-layout.num-versao:
    
                        CREATE  tt-tipo-etiqueta.
                        ASSIGN  tt-tipo-etiqueta.tabela         = "bc-layout-registro"
                                tt-tipo-etiqueta.tp-etiqueta    = tipo-etiqueta.tipo-etiq
                                tt-tipo-etiqueta.cod-layout     = bc-layout-registro.cod-layout
                                tt-tipo-etiqueta.log-datasul    = bc-layout-registro.log-datasul
                                tt-tipo-etiqueta.num-versao     = bc-layout-registro.num-versao
                                tt-tipo-etiqueta.sequencia      = bc-layout-registro.sequencia.
    
                        CREATE tt-bc-layout-registro-aux.
                        BUFFER-COPY bc-layout-registro TO tt-bc-layout-registro-aux.
                        RAW-TRANSFER tt-bc-layout-registro-aux TO tt-tipo-etiqueta.conteudo.
    
                        FOR  EACH bc-layout-registro-item NO-LOCK
                            WHERE bc-layout-registro-item.num-layout-registro  = bc-layout-registro.num-layout-registro:
    
                            CREATE  tt-tipo-etiqueta.
                            ASSIGN  tt-tipo-etiqueta.tabela                 = "bc-layout-registro-item"
                                    tt-tipo-etiqueta.tp-etiqueta            = tipo-etiqueta.tipo-etiq
                                    tt-tipo-etiqueta.num-layout-registro    = bc-layout-registro-item.num-layout-registro
                                    tt-tipo-etiqueta.sequencia              = bc-layout-registro-item.sequencia.
    
                            CREATE  tt-bc-layout-registro-item-aux.
                            BUFFER-COPY bc-layout-registro-item TO tt-bc-layout-registro-item-aux.
                            RAW-TRANSFER tt-bc-layout-registro-item-aux TO tt-tipo-etiqueta.conteudo.
                        END.
                    END.
                END.
            END.
        &ENDIF

        assign c-arquiv = ""
               c-arquiv = c-arq + "etiq-" + string(tipo-etiqueta.tipo-etiq,"9999") + ".etq".
        
        output to value(c-arquiv).
        
        for each tt-tipo-etiqueta:
            export tt-tipo-etiqueta.
        end.

        output close.
        
        for each tt-tipo-etiqueta:
            delete tt-tipo-etiqueta.
        end.

        for each tt-tipo-etiqueta-aux:
            delete tt-tipo-etiqueta-aux.
        end.
        
        for each tt-seq-tipo-etiqueta-aux:
            delete tt-seq-tipo-etiqueta-aux.
        end.
        
        &IF '{&mgcld_version}' >= '2.02'
        &THEN
        FOR EACH tt-bc-layout-aux.
            DELETE tt-bc-layout-aux.
        END.
        
        FOR EACH tt-bc-layout-registro-aux.
            DELETE tt-bc-layout-registro-aux.
        END.
        
        FOR EACH tt-bc-layout-registro-item-aux.
            DELETE tt-bc-layout-registro-item-aux.
        END.
        &ENDIF
    END.

    RUN pi-finalizar IN h-acomp.

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importacao w-livre 
PROCEDURE pi-importacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign c-arq     = ""
           c-arq     = trim(c-arquivo:screen-value in frame {&FRAME-NAME})
           c-arq     = replace(c-arq,"/","~\").

    if  substring(c-arq,length(c-arq) - 3) <> ".etq" then do:
        run utp/ut-msgs.p (input "show",
                           input 16931,
                           input "").
        apply "entry" to c-arquivo in frame {&FRAME-NAME}.
        return error.
    end.

    run utp/ut-acomp.p persistent set h-acomp.
    {utp/ut-liter.i "Importa‡Æo de Etiquetas" * L}
    run pi-inicializar in h-acomp (input trim(return-value)).

    {utp/ut-liter.i Etiqueta * L}
    assign c-imp-exp = trim(return-value).

    for each tt-tipo-etiqueta:
        delete tt-tipo-etiqueta.
    end.

    for each tt-tipo-etiqueta-aux:
        delete tt-tipo-etiqueta-aux.
    end.

    for each tt-seq-tipo-etiqueta-aux:
        delete tt-seq-tipo-etiqueta-aux.
    end.

    &IF '{&mgcld_version}' >= '2.02' &THEN
        FOR EACH tt-bc-layout-aux.
            DELETE tt-bc-layout-aux.
        END.
        FOR EACH tt-bc-layout-registro-aux.
            DELETE tt-bc-layout-registro-aux.
        END.
        FOR EACH tt-bc-layout-registro-item-aux.
            DELETE tt-bc-layout-registro-item-aux.
        END.
    &ENDIF
    
    input from value(c-arq).

    repeat:
        create tt-tipo-etiqueta.
        import tt-tipo-etiqueta.
    end.
 
do on stop undo, leave
   on quit undo, leave:
           
    for each tt-tipo-etiqueta:
    
        run pi-acompanhar in h-acomp (input c-imp-exp + ": " + string(tt-tipo-etiqueta.tp-etiqueta)).

        if  tt-tipo-etiqueta.tabela = "tipo-etiqueta" then do:
            find first tipo-etiqueta Exclusive-lock
                 where tipo-etiqueta.tipo-etiq = tt-tipo-etiqueta.tp-etiqueta no-error.
            if  avail tipo-etiqueta then do:
                run utp/ut-msgs.p (input "show",
                                   input 16934,
                                   input tt-tipo-etiqueta.tp-etiqueta).

                if  return-value = "yes" then do:
                    for each seq-tipo-etiqueta Exclusive-lock
                       where seq-tipo-etiqueta.tipo-etiq = tipo-etiqueta.tipo-etiq:
                        delete seq-tipo-etiqueta.
                    end.

                    create tt-tipo-etiqueta-aux.
                    raw-transfer tt-tipo-etiqueta.conteudo to tt-tipo-etiqueta-aux.
                    buffer-copy tt-tipo-etiqueta-aux to tipo-etiqueta.
                end.
                else do:
                    run pi-finalizar in h-acomp.
                    apply "entry" to c-arquivo in frame {&FRAME-NAME}.
                    return error.
                end.
            End.
            Else Do:
                 Create tipo-etiqueta.
                 Create tt-tipo-etiqueta-aux.
                 Raw-transfer tt-tipo-etiqueta.conteudo to tt-tipo-etiqueta-aux.
                 Buffer-copy tt-tipo-etiqueta-aux to tipo-etiqueta.
            End.
        End.
        Else 
            If  tt-tipo-etiqueta.tabela = "seq-tipo-etiqueta" Then Do:
                Find First seq-tipo-etiqueta Exclusive-lock
                     Where seq-tipo-etiqueta.tipo-etiq  = tt-tipo-etiqueta.tp-etiqueta
                       And seq-tipo-etiqueta.sequencia  = tt-tipo-etiqueta.sequencia No-error.
                If  Not Avail seq-tipo-etiqueta Then Do:
                    Create seq-tipo-etiqueta.
                    Assign seq-tipo-etiqueta.tipo-etiq = tt-tipo-etiqueta.tp-etiqueta
                           seq-tipo-etiqueta.sequencia = tt-tipo-etiqueta.sequencia.
                End.
                Create tt-seq-tipo-etiqueta-aux.
                Raw-transfer tt-tipo-etiqueta.conteudo TO tt-seq-tipo-etiqueta-aux.
                Buffer-copy tt-seq-tipo-etiqueta-aux Except tt-seq-tipo-etiqueta-aux.tipo-etiq tt-seq-tipo-etiqueta-aux.sequencia 
                                                         TO seq-tipo-etiqueta.
            End.
        &IF '{&mgcld_version}' >= '2.02' &THEN
        Else  
            If  tt-tipo-etiqueta.tabela = "bc-layout" Then Do:
                Find First bc-layout Exclusive-lock
                     Where bc-layout.cod-layout  = tt-tipo-etiqueta.cod-layout
                       And bc-layout.log-datasul = tt-tipo-etiqueta.log-datasul
                       And bc-layout.num-versao  = tt-tipo-etiqueta.num-versao No-error.
                If  Not Avail bc-layout Then Do: 
                    Create bc-layout.
                    Assign bc-layout.cod-layout  = tt-tipo-etiqueta.cod-layout
                           bc-layout.log-datasul = tt-tipo-etiqueta.log-datasul
                           bc-layout.num-versao  = tt-tipo-etiqueta.num-versao.
                End.
                Create tt-bc-layout-aux.
                Raw-transfer tt-tipo-etiqueta.conteudo To tt-bc-layout-aux.
                Buffer-copy tt-bc-layout-aux Except tt-bc-layout-aux.cod-layout
                                                    tt-bc-layout-aux.log-datasul
                                                    tt-bc-layout-aux.num-versao
                                                 To bc-layout.
            End.
        Else 
            If  tt-tipo-etiqueta.tabela = "bc-layout-registro" Then Do: 
                Find First bc-layout-registro Exclusive-lock
                     Where bc-layout-registro.cod-layout  = tt-tipo-etiqueta.cod-layout
                       And bc-layout-registro.log-datasul = tt-tipo-etiqueta.log-datasul
                       And bc-layout-registro.num-versao  = tt-tipo-etiqueta.num-versao
                       And bc-layout-registro.sequencia   = tt-tipo-etiqueta.sequencia No-error.
                If  Not Avail bc-layout-registro Then Do:
                    Create bc-layout-registro.
                    Assign bc-layout-registro.cod-layout  = tt-tipo-etiqueta.cod-layout
                           bc-layout-registro.log-datasul = tt-tipo-etiqueta.log-datasul
                           bc-layout-registro.num-versao  = tt-tipo-etiqueta.num-versao
                           bc-layout-registro.sequencia   = tt-tipo-etiqueta.sequencia.
                End.
                Create tt-bc-layout-registro-aux.
                Raw-transfer tt-tipo-etiqueta.conteudo To tt-bc-layout-registro-aux.
                Buffer-copy tt-bc-layout-registro-aux Except tt-bc-layout-registro-aux.cod-layout
                                                             tt-bc-layout-registro-aux.log-datasul
                                                             tt-bc-layout-registro-aux.num-versao
                                                             tt-bc-layout-registro-aux.sequencia
                                                          To bc-layout-registro.
            End.
        Else 
            If  tt-tipo-etiqueta.tabela = "bc-layout-registro-item" Then Do:
                Find First bc-layout-registro-item Exclusive-lock
                     Where bc-layout-registro-item.num-layout-registro = tt-tipo-etiqueta.num-layout-registro
                       And bc-layout-registro-item.sequencia           = tt-tipo-etiqueta.sequencia NO-ERROR.
                If  Not Avail bc-layout-registro-item Then Do:
                    Create bc-layout-registro-item.
                    Assign bc-layout-registro-item.num-layout-registro = tt-tipo-etiqueta.num-layout-registro
                           bc-layout-registro-item.sequencia           = tt-tipo-etiqueta.sequencia.
                End.
                Create tt-bc-layout-registro-item-aux.
                Raw-transfer tt-tipo-etiqueta.conteudo To tt-bc-layout-registro-item-aux.
                Buffer-copy tt-bc-layout-registro-item-aux Except tt-bc-layout-registro-item-aux.num-layout-registro
                                                                  tt-bc-layout-registro-item-aux.sequencia
                                                               To bc-layout-registro-item.
            End.
        &ENDIF
    End.

    Run pi-finalizar In h-acomp.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-livre, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  /*run pi-trata-state (p-issuer-hdl, p-state).*/
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



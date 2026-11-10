&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT4003G 2.00.00.008 } /*** "010008" 29/05/2025 09:23:33  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ggft4003g GGP}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{ggp/tt-erro.i}

DEF TEMP-TABLE tt-class NO-UNDO LIKE gg-classifica                
    FIELD desc-exame AS CHARACTER FORMAT "X(30)"
    INDEX ch-pri AS PRIMARY ind-local cod-exame cod-comp. 

def INPUT-OUTPUT  param table   for tt-class.  
DEF INPUT PARAM  c-nome-tabela  AS CHAR.

if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-cod-resp-orig c-cod-resp-dest bt-ok ~
bt-cancelar bt-ajuda RECT-1 RECT-11 RECT-12 
&Scoped-Define DISPLAYED-OBJECTS i-emitente c-emitente c-serie c-nr-docto ~
c-nat-oper c-desc-oper c-cod-resp-orig c-nome-resp-orig c-cod-resp-dest ~
c-nome-resp-dest 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 i-emitente 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-resp-dest AS CHARACTER FORMAT "x(12)" 
     LABEL "Resp Destino" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE c-cod-resp-orig AS CHARACTER FORMAT "x(12)" 
     LABEL "Resp Origem" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE c-desc-oper AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-emitente AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 39.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-oper AS CHARACTER FORMAT "X(06)":U 
     LABEL "Nat Opera‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-resp-dest AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88.

DEFINE VARIABLE c-nome-resp-orig AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88.

DEFINE VARIABLE c-nr-docto AS CHARACTER FORMAT "X(16)":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie AS CHARACTER FORMAT "X(05)":U 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 79.86 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 4.25.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 2.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     i-emitente AT ROW 1.25 COL 16 COLON-ALIGNED
     c-emitente AT ROW 1.25 COL 27 COLON-ALIGNED NO-LABEL
     c-serie AT ROW 2.21 COL 16 COLON-ALIGNED
     c-nr-docto AT ROW 3.17 COL 16 COLON-ALIGNED
     c-nat-oper AT ROW 4.13 COL 16 COLON-ALIGNED
     c-desc-oper AT ROW 4.13 COL 24 COLON-ALIGNED NO-LABEL
     c-cod-resp-orig AT ROW 5.67 COL 16 COLON-ALIGNED
     c-nome-resp-orig AT ROW 5.67 COL 32.57 COLON-ALIGNED HELP
          "Nome Completo do Responsavel" NO-LABEL
     c-cod-resp-dest AT ROW 6.67 COL 16 COLON-ALIGNED
     c-nome-resp-dest AT ROW 6.67 COL 32.57 COLON-ALIGNED HELP
          "Nome Completo do Responsavel" NO-LABEL
     bt-ok AT ROW 8.21 COL 2
     bt-cancelar AT ROW 8.21 COL 13
     bt-ajuda AT ROW 8.21 COL 68
     RECT-1 AT ROW 8 COL 1.14
     RECT-11 AT ROW 1 COL 1.14
     RECT-12 AT ROW 5.38 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.43 BY 9.08
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Classificador"
         HEIGHT             = 8.63
         WIDTH              = 80.57
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
         RESIZE             = no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* SETTINGS FOR FILL-IN c-desc-oper IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-emitente IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nat-oper IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-resp-dest IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-resp-orig IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nr-docto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-serie IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-emitente IN FRAME F-Main
   NO-ENABLE 1                                                          */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Classificador */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Classificador */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-window
ON CHOOSE OF bt-ajuda IN FRAME F-Main /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-window
ON CHOOSE OF bt-cancelar IN FRAME F-Main /* Cancelar */
DO:
  apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
  
    IF  INPUT FRAME {&frame-name} c-cod-resp-orig <> "" THEN DO:
        IF  NOT CAN-FIND(FIRST usuar_mestre NO-LOCK
                         WHERE usuar_mestre.cod_usuario = INPUT FRAME {&FRAME-NAME} c-cod-resp-orig) THEN DO: 

            {utp/ut-liter.i "Respons vel" * R}
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 31183,
                               INPUT RETURN-VALUE).

            APPLY "entry" TO c-cod-resp-orig IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
    END.

    IF  INPUT FRAME {&frame-name} c-cod-resp-dest <> "" THEN DO:
        IF  NOT CAN-FIND(FIRST usuar_mestre NO-LOCK
                         WHERE usuar_mestre.cod_usuario = INPUT FRAME {&FRAME-NAME} c-cod-resp-dest) THEN DO: 

            {utp/ut-liter.i "Respons vel" * R}
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 31183,
                               INPUT RETURN-VALUE).

            APPLY "entry" TO c-cod-resp-dest IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
       END.
    END.
    
    /*Origem*/
    FOR EACH tt-class EXCLUSIVE-LOCK                         
        WHERE tt-class.des-tipo-docto = c-nome-tabela
          AND tt-class.ind-local      = 1 : 

        ASSIGN tt-class.cod-usu-clas = INPUT FRAME {&FRAME-NAME} c-cod-resp-orig.
    END.

    /*Destino*/
    FOR EACH tt-class EXCLUSIVE-LOCK                         
        WHERE tt-class.des-tipo-docto = c-nome-tabela
          AND tt-class.ind-local      = 2 : 

        ASSIGN tt-class.cod-usu-clas = INPUT FRAME {&FRAME-NAME} c-cod-resp-dest.
    END.
                                         
    apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-resp-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-resp-dest w-window
ON f5 OF c-cod-resp-dest IN FRAME F-Main /* Resp Destino */
DO:
  {include/zoomvar.i &prog-zoom        = "inzoom/z01in391.w"
                           &campo      = c-cod-resp-dest
                           &campozoom  = cod-resp
                           &campo2     = c-nome-resp-dest
                           &campozoom2 = nome-resp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-resp-dest w-window
ON LEAVE OF c-cod-resp-dest IN FRAME F-Main /* Resp Destino */
DO:
  FIND FIRST usuar_mestre NO-LOCK
       WHERE usuar_mestre.cod_usuario = INPUT FRAME {&FRAME-NAME} c-cod-resp-dest NO-ERROR.
  IF AVAIL usuar_mestre THEN DO: 
      DISPLAY usuar_mestre.nom_usuario @ c-nome-resp-dest WITH FRAME {&frame-name}.
  END.
  ELSE DO:
      DISPLAY "" @ c-nome-resp-dest WITH FRAME {&frame-name}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-resp-dest w-window
ON MOUSE-SELECT-DBLCLICK OF c-cod-resp-dest IN FRAME F-Main /* Resp Destino */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-resp-orig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-resp-orig w-window
ON f5 OF c-cod-resp-orig IN FRAME F-Main /* Resp Origem */
DO:
  {include/zoomvar.i &prog-zoom        = "inzoom/z01in391.w"
                           &campo      = c-cod-resp-orig
                           &campozoom  = cod-resp
                           &campo2     = c-nome-resp-orig
                           &campozoom2 = nome-resp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-resp-orig w-window
ON LEAVE OF c-cod-resp-orig IN FRAME F-Main /* Resp Origem */
DO:
  FIND FIRST usuar_mestre NO-LOCK
       WHERE usuar_mestre.cod_usuario = INPUT FRAME {&FRAME-NAME} c-cod-resp-orig NO-ERROR.
  IF  AVAIL usuar_mestre THEN DO: 
      DISPLAY usuar_mestre.nom_usuario @ c-nome-resp-orig WITH FRAME {&frame-name}.
  END.
  ELSE DO:
      DISPLAY "" @ c-nome-resp-orig WITH FRAME {&frame-name}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-resp-orig w-window
ON MOUSE-SELECT-DBLCLICK OF c-cod-resp-orig IN FRAME F-Main /* Resp Origem */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
  THEN DELETE WIDGET w-window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window  _DEFAULT-ENABLE
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
  DISPLAY i-emitente c-emitente c-serie c-nr-docto c-nat-oper c-desc-oper 
          c-cod-resp-orig c-nome-resp-orig c-cod-resp-dest c-nome-resp-dest 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE c-cod-resp-orig c-cod-resp-dest bt-ok bt-cancelar bt-ajuda RECT-1 
         RECT-11 RECT-12 
      WITH FRAME F-Main IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW w-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  IF c-cod-resp-orig     :LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME {&FRAME-NAME} THEN.
  IF c-cod-resp-dest     :LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME {&FRAME-NAME} THEN.
  
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  FOR FIRST tt-class NO-LOCK 
      WHERE tt-class.des-tipo-docto = c-nome-tabela:
      
      IF  c-nome-tabela = "docum-est" THEN DO:
          
          FOR FIRST docum-est NO-LOCK 
              WHERE docum-est.cod-emitente  = tt-class.cod-emitente  
                AND docum-est.serie-docto         = tt-class.serie
                AND docum-est.nro-docto     = tt-class.num-docto
                AND docum-est.nat-operacao  = tt-class.nat-operacao:

              
              ASSIGN i-emitente = docum-est.cod-emitente 
                     c-serie    = docum-est.serie-docto         
                     c-nr-docto = docum-est.nro-docto   
                     c-nat-oper = docum-est.nat-operacao.
    
              DISPLAY i-emitente 
                      c-serie    
                      c-nr-docto 
                      c-nat-oper WITH FRAME {&FRAME-NAME}.
             
          END.                                                                               
      END.
      ELSE 
      IF  c-nome-tabela = "wt-docto"  THEN DO:
          FOR FIRST wt-docto NO-LOCK 
              WHERE wt-docto.seq-wt-docto = INT(tt-class.num-docto):
           
              {utp/ut-liter.i "Sequencia" * R}
              ASSIGN i-emitente = wt-docto.cod-emitente 
                     c-serie    = wt-docto.serie         
                     c-nr-docto = string(wt-docto.seq-wt-docto)   
                     c-nat-oper = wt-docto.nat-operacao
                     c-nr-docto:LABEL = RETURN-VALUE.
    
              DISPLAY i-emitente 
                      c-serie    
                      c-nr-docto 
                      c-nat-oper WITH FRAME {&FRAME-NAME}.
          END.
      END.

      IF tt-class.ind-local = 1  THEN
         ASSIGN c-cod-resp-orig = tt-class.cod-usu-clas.  /*Origem*/
      IF tt-class.ind-local = 2  THEN
         ASSIGN c-cod-resp-dest = tt-class.cod-usu-clas. /*Destino*/
        
      FIND FIRST emitente NO-LOCK
           WHERE emitente.cod-emitente = INPUT FRAME {&FRAME-NAME} i-emitente NO-ERROR.
      ASSIGN c-emitente = IF AVAIL emitente THEN emitente.nome-emit ELSE "".
      
    
      FIND FIRST natur-oper NO-LOCK
           WHERE natur-oper.nat-operacao = INPUT FRAME {&FRAME-NAME} c-nat-oper NO-ERROR.
      ASSIGN c-desc-oper = IF AVAIL natur-oper THEN natur-oper.denominacao ELSE "".
      
      DISP c-desc-oper 
           c-emitente 
           c-cod-resp-orig
           c-cod-resp-dest WITH FRAME {&FRAME-NAME} .
    
      APPLY "leave" TO c-cod-resp-orig IN FRAME {&FRAME-NAME}.
      APPLY "leave" TO c-cod-resp-dest IN FRAME {&FRAME-NAME}.
  END.
   
  /* Code placed here will execute AFTER standard behavior.    */
  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this JanelaDetalhe, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-window 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


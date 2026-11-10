&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
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
{include/i-prgvrs.i IM0994D 2.00.00.005 } /*** "010005" 24/11/2023 09:12:25  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0994d MIM}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEF INPUT PARAMETER hTelaPrinc   AS WIDGET-HANDLE.
DEF INPUT PARAMETER v-row-table  AS ROWID.
DEF INPUT PARAMETER wh-query     AS WIDGET-HANDLE.

/* Local Variable Definitions ---                                       */


define temp-table tt-param
    field destino            as integer
    field arquivo            as char
    field usuario            as char
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field c-cod-estabel-ini  as char
    field c-cod-estabel-fim  as char
    field i-cod-emitente-ini as integer
    field i-cod-emitente-fim as integer
    field c-nro-docto-ini    as char
    field c-nro-docto-fim    as char
    field c-serie-docto-ini  as char
    field c-serie-docto-fim  as char
    field c-nat-operacao-ini as char
    field c-nat-operacao-fim as char
    field da-dt-trans-ini    as date
    field da-dt-trans-fim    as date.
    
define temp-table tt-digita
    field r-docum-est        as rowid
    FIELD narrativa          AS CHAR.
    
def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita   as raw.
   


{rep/re0994c.i}

DEFINE VARIABLE c-narrativa AS CHARACTER   NO-UNDO.

DEFINE VARIABLE h-ecu0115 AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 bt-ok bt-cancelar bt-ajuda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_im0994d-v03 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_im0994dv01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_im0994dv02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q08in090 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Voltar" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-gera-comprov-retenc 
     IMAGE-UP FILE "image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Gera Comprovante de Retená∆o".

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "Confirmar" 
     SIZE 12 BY 1.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 88.29 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     bt-gera-comprov-retenc AT ROW 15.08 COL 27.14 HELP
      "Gera Comprovante de Retená∆o" WIDGET-ID 2
     bt-ok AT ROW 15.21 COL 2.29
     bt-cancelar AT ROW 15.21 COL 14.72
     bt-ajuda AT ROW 15.21 COL 76.86
     RECT-1 AT ROW 15 COL 1.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Confirmaá∆o de Faturas"
         HEIGHT             = 15.58
         WIDTH              = 89.14
         MAX-HEIGHT         = 21.13
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.13
         VIRTUAL-WIDTH      = 114.29
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
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON bt-gera-comprov-retenc IN FRAME F-Main
   NO-ENABLE                                                            */

ASSIGN 
           bt-gera-comprov-retenc:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Confirmaá∆o de Faturas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Confirmaá∆o de Faturas */
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
ON CHOOSE OF bt-cancelar IN FRAME F-Main /* Voltar */
DO:
  apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-gera-comprov-retenc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gera-comprov-retenc w-window
ON CHOOSE OF bt-gera-comprov-retenc IN FRAME F-Main
DO:
    RUN pi-gera-comprov-reten.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* Confirmar */
DO:
    run utp/ut-msgs.p (input "show":U, input 727, input "":U).
    if  return-value <> "yes" then do:
        return no-apply.
    end.

    run pi-devolve-tabelas in h_im0994dv01 (output table tt-total,
                                          output table tt-dupli-imp).

    run pi-retorna-narrativa in h_im0994d-v03 (output c-narrativa).

    run pi-atualiza-documento in this-procedure.

    apply "close" to this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/********************************************************************************** 
** define procedure externa para execuá∆o do programa de visualizaá∆o do relatorio
** necess†rio para a include  i-rptrm.i
**********************************************************************************/
PROCEDURE WinExec  EXTERNAL  "kernel32.dll":
  DEF INPUT PARAM prg_name      AS CHARACTER.
  DEF INPUT PARAM prg_style     AS SHORT.
END PROCEDURE.

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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'imp/im0994d-v02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_im0994dv02 ).
       RUN set-position IN h_im0994dv02 ( 1.13 , 1.43 ) NO-ERROR.
       /* Size in UIB:  ( 1.38 , 88.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/folder.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Gerais|Narrativa' + ',
                     FOLDER-TAB-TYPE = 1':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 2.75 , 1.57 ) NO-ERROR.
       RUN set-size IN h_folder ( 12.00 , 88.14 ) NO-ERROR.

       /* Initialize other pages that this page requires. */
       RUN init-pages IN THIS-PROCEDURE ('1':U) NO-ERROR.

       /* Links to SmartViewer h_im0994dv02. */
       RUN add-link IN adm-broker-hdl ( h_q08in090 , 'Record':U , h_im0994dv02 ).

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_im0994dv02 ,
             bt-gera-comprov-retenc:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             h_im0994dv02 , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'imp/im0994d-v01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_im0994dv01 ).
       RUN set-position IN h_im0994dv01 ( 4.13 , 3.14 ) NO-ERROR.
       /* Size in UIB:  ( 10.25 , 85.14 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'inqry/q08in090.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q08in090 ).
       RUN set-position IN h_q08in090 ( 14.75 , 60.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.79 , 8.29 ) */

       /* Links to SmartViewer h_im0994dv01. */
       RUN add-link IN adm-broker-hdl ( h_im0994dv02 , 'Acha-wh':U , h_im0994dv01 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_im0994dv01 ,
             h_folder , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'imp/im0994d-v03.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_im0994d-v03 ).
       RUN set-position IN h_im0994d-v03 ( 4.50 , 8.00 ) NO-ERROR.
       /* Size in UIB:  ( 9.75 , 77.00 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_im0994d-v03 ,
             h_folder , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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
  ENABLE RECT-1 bt-ok bt-cancelar bt-ajuda 
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
  hTelaPrinc:SENSITIVE = YES.
  
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

{utp/ut9000.i "IM0994D" "2.00.00.005"} /* 24/11/2023 09:12:25 */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  RUN init-pages IN THIS-PROCEDURE ("2":U).    
  
  RUN pi-reposiciona-query IN h_q08in090 (INPUT v-row-table). 
  
  hTelaPrinc:SENSITIVE = NO.
  /* Code placed here will execute AFTER standard behavior.    */

  IF i-pais-impto-usuario = 21 /*Equador*/ THEN 
      ASSIGN bt-gera-comprov-retenc:HIDDEN IN FRAME {&FRAME-NAME} = NO
             bt-gera-comprov-retenc:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-documento w-window 
PROCEDURE pi-atualiza-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def buffer b-docto for docum-est.
    
    find docum-est where rowid(docum-est) = v-row-table no-lock no-error.
    find param-re where param-re.usuario = c-seg-usuario no-lock no-error.
 
    find first tt-digita no-error.
    find first tt-param  no-error.
    if  avail tt-digita then 
        delete tt-digita.
    if  avail tt-param then 
        delete tt-param.
               
    if  available docum-est then do:
        create tt-param.
        assign tt-param.usuario         = c-seg-usuario
               tt-param.destino         = 3
               tt-param.data-exec       = today
               tt-param.hora-exec       = time
               tt-param.arquivo         = session:temp-directory 
                                        + "IM0994":U
                                        + ".tmp":U.
        for each tt-raw-digita:
            delete tt-raw-digita.
        end.

        create tt-digita.
        assign tt-digita.r-docum-est = rowid(docum-est)
               tt-digita.narrativa   = c-narrativa.

        raw-transfer tt-param  to raw-param.
        for each tt-digita:
            create tt-raw-digita.
            raw-transfer tt-digita to tt-raw-digita.raw-digita.
        end.

        run imp/im0994rp.p (input raw-param, 
                            input table tt-raw-digita,
                            input table tt-total, 
                            input table tt-dupli-imp).                                        

        {include/i-rptrm.i}

    end.
    RUN pi-cria-tt-docum-est IN wh-query.
    RUN dispatch IN wh-query ('open-query':U).
    /*Se o documento n∆o foi atualizado, reposiciona a query*/
    find docum-est where rowid(docum-est) = v-row-table no-lock no-error.
    if avail docum-est 
    and docum-est.CE-atual     =  no    
    and docum-est.AP-atual     =  no then 
        RUN pi-reposiciona-docum-est IN wh-query (INPUT v-row-table).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-comprov-reten w-window 
PROCEDURE pi-gera-comprov-reten :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-possui-retenc-aux AS LOGICAL NO-UNDO.
    
    ASSIGN l-possui-retenc-aux = NO.
    
    FIND docum-est WHERE ROWID(docum-est) = v-row-table NO-LOCK NO-ERROR.
    
    /*Verifica se possui retená∆o no documento*/
    FOR EACH impto-item-docto FIELDS(cdn-imposto) WHERE
             impto-item-docto.serie-docto  = docum-est.serie-docto    AND      
             impto-item-docto.nro-docto    = docum-est.nro-docto      AND      
             impto-item-docto.cod-emitente = docum-est.cod-emitente   AND      
             impto-item-docto.nat-operacao = docum-est.nat-operacao   NO-LOCK,
        FIRST tipo-tax NO-LOCK
        WHERE tipo-tax.cod-tax = impto-item-docto.cdn-imposto:
        
        IF tipo-tax.tipo = 1 /*Retená∆o*/ THEN DO:
            ASSIGN l-possui-retenc-aux = YES.
            LEAVE.                       
        END.
    END.
    
    IF NOT l-possui-retenc-aux THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 57441,
                           INPUT ""). /* Documento n∆o possui retená∆o */
    END.
    ELSE DO:
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        RUN local/ecu/ecu0115.w PERSISTENT SET h-ecu0115(INPUT ?,
                                                         INPUT ROWID(docum-est),
                                                         INPUT "ADD":U,
                                                         INPUT THIS-PROCEDURE,
                                                         INPUT 1,
                                                         INPUT h_im0994dv01). /* aqui vamos alterar */
    
        IF  VALID-HANDLE (h-ecu0115) THEN DO:    
            RUN initializeInterface    IN h-ecu0115.
            WAIT-FOR CLOSE OF h-ecu0115 FOCUS CURRENT-WINDOW.
        END. 
    
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator w-window 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN "adm/objects/folder.w *RTB-SmObj* ".
  RUN "rep/re0994c-v01.w *RTB-SmObj* ".
  RUN "inqry/q08in090.w *RTB-SmObj* ".
  RUN "rep/re0994c-b01.w *RTB-SmObj* ".
  RUN "rep/re0994-v01.w *RTB-SmObj* ".
  RUN "rep/re0994c-b02.w *RTB-SmObj* ".

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
     Tables specified for this SmartWindow, and there are no
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


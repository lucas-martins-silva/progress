&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movadm           PROGRESS
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
{include/i-prgvrs.i Z16AD260 2.00.00.001}  /*** 010001 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i z16ad260 MUT}
&ENDIF

{cdp/cdcfgfin.i}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

def input  param p-cod-estabel  as char  no-undo.
def input  param p-cod-fornec   as inte  no-undo.
def input  param p-da-movto     as date  no-undo.
def input  param p-moeda        as inte  no-undo.
def output param p-row-tit-ap   as rowid no-undo.
def output param p-log-cancela  as logi  no-undo.

def var i-cod-fornec     as integer no-undo.
def var i-port-ini       as integer no-undo.
def var i-port-fim       as integer no-undo.
def var i-dt-emissao-ini as date    no-undo.
def var i-dt-emissao-fim as date    no-undo.
def var l-cancela        as logical no-undo.

def buffer b-emitente for emitente.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tit-ap

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 tit-ap.cod-estabel tit-ap.cod-esp ~
tit-ap.cod-fornec tit-ap.serie tit-ap.nr-docto tit-ap.parcela tit-ap.moeda ~
tit-ap.cotacao-dia tit-ap.vl-orig-me tit-ap.vl-saldo-me tit-ap.portador ~
tit-ap.nr-bordero tit-ap.nr-cheque tit-ap.dt-emissao tit-ap.dt-transacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH tit-ap ~
      WHERE tit-ap.ep-codigo          = i-ep-codigo-usuario ~
 AND tit-ap.cod-estabel   = p-cod-estabel ~
 AND tit-ap.cod-fornec    = i-cod-fornec ~
 AND tit-ap.dt-transacao <= p-da-movto ~
 AND tit-ap.portador     >= i-port-ini ~
 AND tit-ap.portador     <= i-port-fim ~
 AND tit-ap.dt-emissao   >= i-dt-emissao-ini ~
 AND tit-ap.dt-emissao   <= i-dt-emissao-fim ~
 AND tit-ap.moeda = p-moeda  ~
 AND tit-ap.valor-saldo   > 0 ~
 AND tit-ap.tipo = 1 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 tit-ap
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 tit-ap


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-8 RECT-9 rs-opcao BROWSE-1 RECT-1 bt-ok ~
bt-cancelar bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS rs-opcao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

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

DEFINE VARIABLE rs-opcao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Documentos Fornecedor", 1,
"Documentos Matriz", 2
     SIZE 78.43 BY 1.08
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 80 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 10.42.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 78.86 BY 1.29
     BGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      tit-ap SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 w-window _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      tit-ap.cod-estabel
      tit-ap.cod-esp
      tit-ap.cod-fornec FORMAT ">>>>>>>>>>9"
      tit-ap.serie
      tit-ap.nr-docto
      tit-ap.parcela
      tit-ap.moeda
      tit-ap.cotacao-dia
      tit-ap.vl-orig-me
      tit-ap.vl-saldo-me FORMAT "->>>,>>>,>>>,>>9.99"
      tit-ap.portador
      tit-ap.nr-bordero
      tit-ap.nr-cheque
      tit-ap.dt-emissao
      tit-ap.dt-transacao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78.72 BY 8.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rs-opcao AT ROW 1.29 COL 1.72 NO-LABEL
     BROWSE-1 AT ROW 2.54 COL 1.72
     bt-ok AT ROW 11.71 COL 2
     bt-cancelar AT ROW 11.71 COL 12.43
     bt-ajuda AT ROW 11.71 COL 70.29
     RECT-8 AT ROW 1 COL 1
     RECT-9 AT ROW 1.17 COL 1.57
     RECT-1 AT ROW 11.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.57 BY 12.08.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Documentos do Fornecedor / Matriz"
         HEIGHT             = 12.21
         WIDTH              = 80.43
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* BROWSE-TAB BROWSE-1 rs-opcao F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "movadm.tit-ap"
     _Where[1]         = "movadm.tit-ap.ep-codigo          = i-ep-codigo-usuario
 AND movadm.tit-ap.cod-estabel   = p-cod-estabel
 AND movadm.tit-ap.cod-fornec    = i-cod-fornec
 AND movadm.tit-ap.dt-transacao <= p-da-movto
 AND movadm.tit-ap.portador     >= i-port-ini
 AND movadm.tit-ap.portador     <= i-port-fim
 AND movadm.tit-ap.dt-emissao   >= i-dt-emissao-ini
 AND movadm.tit-ap.dt-emissao   <= i-dt-emissao-fim
 AND movadm.tit-ap.moeda = p-moeda 
 AND movadm.tit-ap.valor-saldo   > 0
 AND movadm.tit-ap.tipo = 1"
     _FldNameList[1]   = movadm.tit-ap.cod-estabel
     _FldNameList[2]   = movadm.tit-ap.cod-esp
     _FldNameList[3]   > movadm.tit-ap.cod-fornec
"tit-ap.cod-fornec" ? ">>>>>>>>>>9" "integer" ? ? ? ? ? ? no ?
     _FldNameList[4]   = movadm.tit-ap.serie
     _FldNameList[5]   = movadm.tit-ap.nr-docto
     _FldNameList[6]   = movadm.tit-ap.parcela
     _FldNameList[7]   = movadm.tit-ap.moeda
     _FldNameList[8]   = movadm.tit-ap.cotacao-dia
     _FldNameList[9]   = movadm.tit-ap.vl-orig-me
     _FldNameList[10]   > movadm.tit-ap.vl-saldo-me
"tit-ap.vl-saldo-me" ? "->>>,>>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[11]   = movadm.tit-ap.portador
     _FldNameList[12]   = movadm.tit-ap.nr-bordero
     _FldNameList[13]   = movadm.tit-ap.nr-cheque
     _FldNameList[14]   = movadm.tit-ap.dt-emissao
     _FldNameList[15]   = movadm.tit-ap.dt-transacao
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Documentos do Fornecedor / Matriz */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Documentos do Fornecedor / Matriz */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 w-window
ON MOUSE-SELECT-DBLCLICK OF BROWSE-1 IN FRAME F-Main
DO:

    apply 'choose' to bt-ok in frame {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 w-window
ON ROW-DISPLAY OF BROWSE-1 IN FRAME F-Main
DO:

    if  avail tit-ap then do:

        assign tit-ap.cod-estabel:fgcolor  in browse {&browse-name} = 0
               tit-ap.cod-esp:fgcolor      in browse {&browse-name} = 0
               tit-ap.cod-fornec:fgcolor   in browse {&browse-name} = 0
               tit-ap.serie:fgcolor        in browse {&browse-name} = 0
               tit-ap.nr-docto:fgcolor     in browse {&browse-name} = 0
               tit-ap.parcela:fgcolor      in browse {&browse-name} = 0
               tit-ap.moeda:fgcolor        in browse {&browse-name} = 0
               tit-ap.cotacao-dia:fgcolor  in browse {&browse-name} = 0
               tit-ap.vl-orig-me:fgcolor   in browse {&browse-name} = 0
               tit-ap.vl-saldo-me:fgcolor  in browse {&browse-name} = 0
               tit-ap.portador:fgcolor     in browse {&browse-name} = 0
               tit-ap.nr-bordero:fgcolor   in browse {&browse-name} = 0
               tit-ap.nr-cheque:fgcolor    in browse {&browse-name} = 0
               tit-ap.dt-emissao:fgcolor   in browse {&browse-name} = 0
               tit-ap.dt-transacao:fgcolor in browse {&browse-name} = 0.

        /*--- Identifica que a AN j† est† sendo Usada ---*/    
        find first l-ant-ap no-lock
             where l-ant-ap.ep-codigo     = tit-ap.ep-codigo
             and   l-ant-ap.cod-estabel   = tit-ap.cod-estabel
             and   l-ant-ap.cod-fornec    = tit-ap.cod-fornec
             and   l-ant-ap.serie-ant     = tit-ap.serie
             and   l-ant-ap.cod-esp-ant   = tit-ap.cod-esp
             and   l-ant-ap.nr-docto-ant  = tit-ap.nr-docto
             and   l-ant-ap.parcela-ant   = tit-ap.parcela no-error.

        if  avail l-ant-ap then do:
            assign tit-ap.cod-estabel:fgcolor  in browse {&browse-name} = 9
                   tit-ap.cod-esp:fgcolor      in browse {&browse-name} = 9
                   tit-ap.cod-fornec:fgcolor   in browse {&browse-name} = 9
                   tit-ap.serie:fgcolor        in browse {&browse-name} = 9
                   tit-ap.nr-docto:fgcolor     in browse {&browse-name} = 9
                   tit-ap.parcela:fgcolor      in browse {&browse-name} = 9
                   tit-ap.moeda:fgcolor        in browse {&browse-name} = 9
                   tit-ap.cotacao-dia:fgcolor  in browse {&browse-name} = 9
                   tit-ap.vl-orig-me:fgcolor   in browse {&browse-name} = 9
                   tit-ap.vl-saldo-me:fgcolor  in browse {&browse-name} = 9
                   tit-ap.portador:fgcolor     in browse {&browse-name} = 9
                   tit-ap.nr-bordero:fgcolor   in browse {&browse-name} = 9
                   tit-ap.nr-cheque:fgcolor    in browse {&browse-name} = 9
                   tit-ap.dt-emissao:fgcolor   in browse {&browse-name} = 9
                   tit-ap.dt-transacao:fgcolor in browse {&browse-name} = 9.
        end.

    end.

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

    assign p-log-cancela = yes.

    apply "close" to this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:

    if  avail tit-ap then do:
        if  tit-ap.moeda <> 0 then do:
            find first l-ant-ap 
                 where l-ant-ap.ep-codigo    = tit-ap.ep-codigo   
                 and   l-ant-ap.cod-estabel  = tit-ap.cod-estabel 
                 and   l-ant-ap.fornec-ant   = tit-ap.cod-fornec
                 and   l-ant-ap.cod-esp-ant  = tit-ap.cod-esp     
                 and   l-ant-ap.serie-ant    = tit-ap.serie       
                 and   l-ant-ap.nr-docto-ant = tit-ap.nr-docto    
                 and   l-ant-ap.parcela-ant  = tit-ap.parcela 
                 no-lock no-error.

            if  avail l-ant-ap then do:
                run utp/ut-msgs.p (input "show",
                                   input 17713,
                                   input "").        
                return no-apply.
            end.

            /*--- Data informada deve ser maior que o £ltimo c†lculo efetuado ---*/
            if  p-da-movto < tit-ap.data-2 then do:
                run utp/ut-msgs.p (input "show",
                                   input 17721,
                                   input string(p-da-movto, "99/99/9999") + "~~" +
                                         string(tit-ap.data-2, "99/99/9999")).
                return no-apply.
            end.
        end.

        assign p-row-tit-ap  = rowid(tit-ap)
               p-log-cancela = no.
    end.

    apply "close" to this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-opcao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-opcao w-window
ON VALUE-CHANGED OF rs-opcao IN FRAME F-Main
DO:

    assign i-cod-fornec = p-cod-fornec.

    if  input frame {&FRAME-NAME} rs-opcao = 2 then do:
        find first emitente
             where emitente.cod-emitente = p-cod-fornec
             and   emitente.identific   <> 1 no-lock no-error.

        if  avail emitente then do:
            find first b-emitente
                 where b-emitente.nome-abrev   = emitente.nome-matriz
                 and   b-emitente.identific   <> 1 no-lock no-error.

            if  avail b-emitente then 
                assign i-cod-fornec = b-emitente.cod-emitente.

        end.        
    end.

    {&OPEN-QUERY-BROWSE-1}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

{utp/ut-liter.i Valor_Original}
assign tit-ap.vl-orig-me:label in browse BROWSE-1 = return-value.

{utp/ut-liter.i Data_Emiss∆o}
assign tit-ap.dt-emissao:label in browse BROWSE-1 = return-value.

{utp/ut-liter.i Data_Transaá∆o}
assign tit-ap.dt-transacao:label in browse BROWSE-1 = return-value.

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window _DEFAULT-ENABLE
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
  DISPLAY rs-opcao 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE RECT-8 RECT-9 rs-opcao BROWSE-1 RECT-1 bt-ok bt-cancelar bt-ajuda 
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
  def var c-string1 as char no-undo.
  def var c-string2 as char no-undo.

  {include/win-size.i}

{utp/ut9000.i "Z16AD260" "2.00.00.001"}

  assign i-cod-fornec     = p-cod-fornec
         i-port-ini       = 0
         i-port-fim       = 99999
         i-dt-emissao-ini = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF 
         i-dt-emissao-fim = 12/31/9999.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tit-ap"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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



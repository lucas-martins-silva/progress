&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME w-livre

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-historico NO-UNDO LIKE historico-proc-imp
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0550BR 2.00.00.013 } /*** 010013 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0550br MIM}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif

/* ***************************  Definitions  ************************** */
{cdp/cdcfgmat.i}
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var i-atraso      as integer no-undo.
def var i-situacao    as integer no-undo.
def var d-data-ini    as date    no-undo.
def var d-data-fim    as date    no-undo.
def var c-est-ini     as char    no-undo.
def var c-est-fim     as char    no-undo.
def var c-proc-ini    as char    no-undo.
def var c-proc-fim    as char    no-undo.
def var i-exp-ini     as integer no-undo.
def var i-exp-fim     as integer no-undo.
def var i-itiner-ini  as integer no-undo.
def var i-itiner-fim  as integer no-undo.
def var i-pto-emb-ini as integer no-undo.
def var i-pto-emb-fim as integer no-undo.
def var i-pto-des-ini as integer no-undo.
def var i-pto-des-fim as integer no-undo.
def var i-local       as integer no-undo.
def var i-grupo-ini   as integer no-undo.
def var i-grupo-fim   as integer no-undo.
def var c-fam-ini     as char    no-undo.
def var c-fam-fim     as char    no-undo.
def var c-item-ini    as char    no-undo.
def var c-item-fim    as char    no-undo.
&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN
    DEFINE VARIABLE iPtoSolicLiIni   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iPtoSolicLiFim   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cLicencImportIni AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLicencImportFim AS CHARACTER  NO-UNDO.
&ELSE
    def var c-decl-ini    as char    no-undo.
    def var c-decl-fim    as char    no-undo.
&ENDIF 

def var h-bocx150b as handle no-undo.
def var h-bocx115  as handle no-undo.
def var h-bocx140  as handle no-undo.

def var i-cod-emitente    like emitente.cod-emitente      no-undo.
def var i-pto-embarque    like itinerario.pto-embarque    no-undo.
def var i-pto-desembarque like itinerario.pto-desembarque no-undo.
def var c-return          as char                         no-undo.
def var l-ok              as logical                      no-undo.
def var cSituacao         as char                         no-undo.

def new global shared var gr-historico-proc-imp as rowid no-undo.
def new global shared var gr-par-processo-imp   as rowid no-undo.
def new global shared var gr-par-ordem-compra   as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-historico

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-historico.cod-estabel ~
tt-historico.nr-proc-imp ~
fnFornecedor(input tt-historico.nr-proc-imp) @ i-cod-emitente ~
tt-historico.cod-itiner ~
fnPtos(input tt-historico.cod-itiner, input "embarque") @ i-pto-embarque ~
fnPtos(input tt-historico.cod-itiner, input "desembarque") @ i-pto-desembarque ~
fnSituacao(input tt-historico.nr-proc-imp) @ cSituacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-historico NO-LOCK ~
    BY tt-historico.cod-estabel ~
       BY tt-historico.nr-proc-imp ~
        BY tt-historico.cod-itiner ~
         BY tt-historico.sequencia
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-historico NO-LOCK ~
    BY tt-historico.cod-estabel ~
       BY tt-historico.nr-proc-imp ~
        BY tt-historico.cod-itiner ~
         BY tt-historico.sequencia.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-historico
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-historico


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btParametros rt-button 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnFornecedor w-livre 
FUNCTION fnFornecedor RETURNS INTEGER
  ( input inr-proc-imp as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPtos w-livre 
FUNCTION fnPtos RETURNS INTEGER
  ( input icod-itiner as integer, input cpto as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSituacao w-livre 
FUNCTION fnSituacao RETURNS CHARACTER
  ( input inr-proc-imp as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btParametros 
     IMAGE-UP FILE "image~\im-brows":U
     LABEL "Parametros" 
     SIZE 4 BY 1.25 TOOLTIP "Parƒmetros"
     FONT 4.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89.72 BY 1.46
     BGCOLOR 7 .

DEFINE BUTTON btDetalhe AUTO-GO DEFAULT 
     LABEL "Detalhe" 
     SIZE 10 BY 1
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-historico SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 w-livre _STRUCTURED
  QUERY brSon1 DISPLAY
      tt-historico.cod-estabel format "x(05)":U
      tt-historico.nr-proc-imp FORMAT "X(12)":U
      fnFornecedor(input tt-historico.nr-proc-imp) @ i-cod-emitente COLUMN-LABEL "Fornecedor"
      tt-historico.cod-itiner FORMAT ">>,>>9":U
      fnPtos(input tt-historico.cod-itiner, input "embarque") @ i-pto-embarque COLUMN-LABEL "Embarq"
      fnPtos(input tt-historico.cod-itiner, input "desembarque") @ i-pto-desembarque COLUMN-LABEL "Nacionaliz"
      fnSituacao(input tt-historico.nr-proc-imp) @ cSituacao COLUMN-LABEL "Situa‡Æo" FORMAT "x(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78.57 BY 12.88
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     btParametros AT ROW 1.17 COL 2 HELP
          "Consultas relacionadas"
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.46.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.25 COL 2
     btDetalhe AT ROW 14.13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4 ROW 3
         SIZE 83 BY 15
         FONT 1
         DEFAULT-BUTTON btDetalhe.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-historico T "?" NO-UNDO mgcex historico-proc-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "Template Livre <Insira complemento>"
         HEIGHT             = 17.21
         WIDTH              = 90.29
         MAX-HEIGHT         = 20.17
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 20.17
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
/*{include/w-livre.i}*/
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME f-cad:HANDLE.

/* SETTINGS FOR FRAME f-cad
                                                                        */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.tt-historico"
     _OrdList          = "Temp-Tables.tt-historico.cod-estabel|yes,Temp-Tables.tt-historico.nr-proc-imp|yes,Temp-Tables.tt-historico.cod-itiner|yes,Temp-Tables.tt-historico.sequencia|yes"
     _FldNameList[1]   = Temp-Tables.tt-historico.cod-estabel
     _FldNameList[2]   = Temp-Tables.tt-historico.nr-proc-imp
     _FldNameList[3]   > "_<CALC>"
"fnFornecedor(input tt-historico.nr-proc-imp) @ i-cod-emitente" "Fornecedor" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[4]   = Temp-Tables.tt-historico.cod-itiner
     _FldNameList[5]   > "_<CALC>"
"fnPtos(input tt-historico.cod-itiner, input ""embarque"") @ i-pto-embarque" "Embarq" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[6]   > "_<CALC>"
"fnPtos(input tt-historico.cod-itiner, input ""desembarque"") @ i-pto-desembarque" "Nacionaliz" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[7]   > "_<CALC>"
"fnSituacao(input tt-historico.nr-proc-imp) @ cSituacao" "Situa‡Æo" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Template Livre <Insira complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Template Livre <Insira complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 w-livre
ON MOUSE-SELECT-DBLCLICK OF brSon1 IN FRAME fPage1
DO:
    apply "choose" to btDetalhe in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe w-livre
ON CHOOSE OF btDetalhe IN FRAME fPage1 /* Detalhe */
DO:
    if avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} then do:    
        assign gr-historico-proc-imp = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.r-rowid.
        run imp/im0550.w.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME btParametros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParametros w-livre
ON CHOOSE OF btParametros IN FRAME f-cad /* Parametros */
DO:    
    RUN imp/im0550pr.w (output i-atraso, 
                        output i-situacao, 
                        output d-data-ini,
                        output d-data-fim,
                        output c-est-ini, 
                        output c-est-fim, 
                        output c-proc-ini, 
                        output c-proc-fim, 
                        output i-exp-ini, 
                        output i-exp-fim, 
                        output i-itiner-ini,  
                        output i-itiner-fim,  
                        output i-pto-emb-ini, 
                        output i-pto-emb-fim, 
                        output i-pto-des-ini, 
                        output i-pto-des-fim, 
                        output i-local,       
                        output i-grupo-ini,   
                        output i-grupo-fim,   
                        output c-fam-ini,     
                        output c-fam-fim,     
                        output c-item-ini,    
                        output c-item-fim,
                        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN
                            OUTPUT iPtoSolicLiIni,
                            OUTPUT iPtoSolicLiFim,
                            OUTPUT cLicencImportIni,
                            OUTPUT cLicencImportFim,
                        &ELSE
                            output c-decl-ini,
                            output c-decl-fim,
                        &ENDIF
                        output l-ok,
                        input h-bocx150b).
    run pi-atualiza-consulta.                        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
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
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.17 , 74.14 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             btParametros:HANDLE IN FRAME f-cad , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
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
  ENABLE btParametros rt-button 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  ENABLE brSon1 btDetalhe 
      WITH FRAME fPage1 IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-fPage1}
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

  delete procedure h-bocx150b.
  delete procedure h-bocx115.
  delete procedure h-bocx140.

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
    def var h-boin274 as handle no-undo.

    /* Code placed here will execute PRIOR to standard behavior. */
    /* run pi-before-initialize.*/

    {include/win-size.i}

{utp/ut9000.i "IM0550BR" "2.00.00.012"}

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .    

    RUN cxbo/bocx150b.p persistent set h-bocx150b.
    RUN cxbo/bocx115.p  persistent set h-bocx115.
    RUN cxbo/bocx140.p  persistent set h-bocx140.    

    if gr-par-processo-imp <> ? then do:

        run findRowid in h-bocx140(input gr-par-processo-imp).
        run getCharfield in h-bocx140(input "nr-proc-imp",output c-proc-ini).
        run getCharfield in h-bocx140(input "nr-proc-imp",output c-proc-fim).
        run getCharfield in h-bocx140(input "cod-estabel",output c-est-ini).
        run getCharfield in h-bocx140(input "cod-estabel",output c-est-fim).
        run getIntfield in h-bocx140(input "cod-exportador",output i-exp-ini).
        run getIntfield in h-bocx140(input "cod-exportador",output i-exp-fim).

        assign i-atraso   = 3
               i-situacao = 5
               d-data-ini = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
               d-data-fim = 12/31/9999          
               i-itiner-ini = 0 
               i-itiner-fim = 99999
               i-pto-emb-ini = 0
               i-pto-emb-fim = 99999
               i-pto-des-ini = 0
               i-pto-des-fim = 99999
               i-local       = 0
               i-grupo-ini   = 0
               i-grupo-fim   = 99
               c-fam-ini     = ""
               c-fam-fim     = "zzzzzzzz"
               c-item-ini    = ""
               c-item-fim    = "zzzzzzzzzzzzzzzz"    
               &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN
                    iPtoSolicLiIni   = 0
                    iPtoSolicLiFim   = 99999
                    cLicencImportIni = ""
                    cLicencImportFim = "ZZZZZZZZZZZZZZZZZZZZ"
                &ELSE
                    c-decl-ini    = ""
                    c-decl-fim    = "zzzzzzzzzzzzzzzzzzzz"
                &ENDIF 
               l-ok          = yes.

        if gr-par-ordem-compra <> ? then do:
            run inbo/boin274.p persistent set h-boin274.
            run openquery in h-boin274 (input 1).
            run findRowid in h-boin274(input gr-par-ordem-compra).
            run getCharfield in h-boin274(input "it-codigo",output c-item-ini).
            run getCharfield in h-boin274(input "it-codigo",output c-item-fim).            
            delete procedure h-boin274.
        end.

        run pi-atualiza-consulta.

        assign gr-par-processo-imp = ?
               gr-par-ordem-compra = ?.        
    end.    
    enable btDetalhe with frame {&frame-name}.
    &IF '{&mgdis_version}' < '2.06f' &THEN
        /*Tecnica para implementar valida‡Æo produto Estendido*/
        {cdp/cdapi558.i1}
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-consulta w-livre 
PROCEDURE pi-atualiza-consulta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var iRowsReturned as integer no-undo.

    if l-ok then do:                        
        run criarTTprocesso in h-bocx150b (input i-atraso,
                                           input i-situacao,
                                           input i-local,
                                           input d-data-ini,
                                           input d-data-fim,
                                           input c-est-ini,
                                           input c-est-fim,
                                           input c-proc-ini,
                                           input c-proc-fim,
                                           input i-exp-ini,
                                           input i-exp-fim,
                                           input i-itiner-ini,
                                           input i-itiner-fim,
                                           input i-pto-emb-ini,
                                           input i-pto-emb-fim,
                                           input i-pto-des-ini,
                                           input i-pto-des-fim,
                                           input i-grupo-ini,
                                           input i-grupo-fim,
                                           input c-fam-ini,
                                           input c-fam-fim,
                                           input c-item-ini,
                                           input c-item-fim,
                                           &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN
                                                iPtoSolicLiIni,
                                                iPtoSolicLiFim,
                                                cLicencImportIni,
                                                cLicencImportFim
                                           &ELSE
                                                INPUT c-decl-ini,
                                                INPUT c-decl-fim
                                           &ENDIF 
                                           ).

        RUN OpenQuery in h-bocx150b (input 2).

        /*--- Posiciona DBO filho no primeiro registro, caso necess rio ---*/
        RUN findFirst IN h-bocx150b.

             /*--- Retorna faixa de registro do DBO Filho ---*/
        RUN serverSendRows IN h-bocx150b (INPUT ?,
                                          INPUT ?,
                                          INPUT NO,
                                          INPUT 40,
                                          OUTPUT iRowsReturned,
                                          OUTPUT TABLE tt-historico).

        {&OPEN-QUERY-brSon1}
        APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator w-livre 
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
  RUN panel/p-exihel.w.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-historico"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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
/*
 *   run pi-trata-state (p-issuer-hdl, p-state).*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnFornecedor w-livre 
FUNCTION fnFornecedor RETURNS INTEGER
  ( input inr-proc-imp as char ) :  
  def var icod-fornecedor as int no-undo.

  RUN findPk_nr_processo in h-bocx140 (input inr-proc-imp, output c-return).
      if c-return = "" then 
         RUN getIntField in h-bocx140 (input "cod-exportador", output icod-fornecedor).
  RETURN icod-fornecedor.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPtos w-livre 
FUNCTION fnPtos RETURNS INTEGER
  ( input icod-itiner as integer, input cpto as char ) :
  def var ipto as integer no-undo.
  RUN findCodigo in h-bocx115 (input icod-itiner, output c-return).
  if cpto = "embarque" and c-return = "" then
     RUN getIntField in h-bocx115 (input "pto-embarque", output ipto).
  if cpto = "desembarque" and c-return = "" then
     RUN getIntField in h-bocx115 (input "pto-desembarque", output ipto).   
  RETURN ipto.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSituacao w-livre 
FUNCTION fnSituacao RETURNS CHARACTER
  ( input inr-proc-imp as char ) :
  def var csituacao as char no-undo.
  def var isituacao as int no-undo.
  RUN findPk_nr_processo in h-bocx140 (input inr-proc-imp, output c-return).
      if c-return = "" then 
         RUN getIntField in h-bocx140 (input "situacao", output isituacao).
  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
      ASSIGN cAuxTraducao001 = {cxinc/i01cx140.i 04 isituacao}.
      run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                          INPUT "",
                          INPUT "").
      ASSIGN  csituacao = RETURN-VALUE.
  &else
      ASSIGN csituacao = {cxinc/i01cx140.i 04 isituacao}.
  &endif
  RETURN csituacao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


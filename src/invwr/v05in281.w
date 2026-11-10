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
{include/i-prgvrs.i V05IN281 2.00.00.034 } /*** "010034" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v05in281 MUT}
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
{cdp/cdcfgman.i}
/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var l-ordem       as logical no-undo.
def var l-sem-op-ext  as logical no-undo.
def var l-com-op-ext  as logical NO-UNDO.
DEF VAR l-num-op-rep  AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-cp
&Scoped-define FIRST-EXTERNAL-TABLE param-cp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-cp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-cp.pede-item param-cp.ver-req ~
param-cp.ord-sum param-cp.rep-item param-cp.tp-sum param-cp.aloca-ord ~
param-cp.aloca-altern param-cp.aloca-reserva param-cp.gera-rast-lote ~
param-cp.gera-op-aut 
&Scoped-define ENABLED-TABLES param-cp
&Scoped-define FIRST-ENABLED-TABLE param-cp
&Scoped-Define ENABLED-OBJECTS rs-interface-manut-reserva RECT-17 RECT-18 ~
RECT-20 RECT-21 RECT-22 RECT-23 RECT-24 RECT-25 rs-verifica-repetitivo ~
tg-req-mater-nao-previs tg-usa-mater-altern-reporte tg-ficha-ord ~
tg-valor-desmontagem tg-num-op-rep tg-ordem tg-com-op-ext tg-sem-op-ext ~
tg-valida-movimentacao-orfa tg-consiste-mob-ggf-zerado cb-alter-benef 
&Scoped-Define DISPLAYED-FIELDS param-cp.pede-item param-cp.ver-req ~
param-cp.ord-sum param-cp.rep-item param-cp.tp-sum param-cp.aloca-ord ~
param-cp.aloca-altern param-cp.aloca-reserva param-cp.gera-rast-lote ~
param-cp.gera-op-aut 
&Scoped-define DISPLAYED-TABLES param-cp
&Scoped-define FIRST-DISPLAYED-TABLE param-cp
&Scoped-Define DISPLAYED-OBJECTS rs-interface-manut-reserva ~
rs-verifica-repetitivo tg-req-mater-nao-previs tg-usa-mater-altern-reporte ~
tg-ficha-ord tg-valor-desmontagem tg-num-op-rep tg-ordem tg-com-op-ext ~
tg-sem-op-ext tg-valida-movimentacao-orfa tg-consiste-mob-ggf-zerado ~
cb-alter-benef fill-interface-reservas fill-ord-sum fill-tp-sum ~
fill-aloca-ord 

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
DEFINE VARIABLE cb-alter-benef AS CHARACTER FORMAT "X(16)":U 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEM-PAIRS "N∆o Altera","0",
                     "Altera N∆o Confirmada","1",
                     "Altera Confirmada","2"
     DROP-DOWN-LIST
     TOOLTIP "Ajuste OC"
     SIZE 17.29 BY 1 NO-UNDO.

DEFINE VARIABLE fill-aloca-ord AS CHARACTER FORMAT "X(256)":U INITIAL "Alocaá∆o Ordens" 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fill-interface-reservas AS CHARACTER FORMAT "X(256)":U INITIAL "Interface Manut. Reservas (Reporte)" 
      VIEW-AS TEXT 
     SIZE 27.43 BY .63 NO-UNDO.

DEFINE VARIABLE fill-ord-sum AS CHARACTER FORMAT "X(256)":U INITIAL "Num Ordens Por Req Sum†ria" 
      VIEW-AS TEXT 
     SIZE 21.43 BY .63 NO-UNDO.

DEFINE VARIABLE fill-tp-sum AS CHARACTER FORMAT "X(256)":U INITIAL "Sumariza" 
      VIEW-AS TEXT 
     SIZE 12.43 BY .63 NO-UNDO.

DEFINE VARIABLE rs-interface-manut-reserva AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Simplificada", 1,
"Detalhada", 2
     SIZE 28 BY .67 TOOLTIP "Simplificada (Padr∆o); Detalhada (Melhorada)" NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31.14 BY 3.83.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31.14 BY 1.88.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31.14 BY 1.21.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.57 BY 1.54.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.57 BY 4.33.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.72 BY 1.88.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.57 BY 3.33.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31.14 BY 1.54.

DEFINE VARIABLE rs-verifica-repetitivo AS LOGICAL INITIAL no 
     LABEL "Verifica REQ no Reporte Ass°ncrono" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .75 NO-UNDO.

DEFINE VARIABLE tg-com-op-ext AS LOGICAL INITIAL no 
     LABEL "OP Interna com Operaá∆o Externa" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-consiste-mob-ggf-zerado AS LOGICAL 
     LABEL "Consiste reporte MOB/GGF zerado" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.72 BY .83 TOOLTIP "Indica se o sistema deve apresentar uma mensagem caso seja efetuado um reporte de MOB/GGF com horas zeradas" NO-UNDO.

DEFINE VARIABLE tg-ficha-ord AS LOGICAL INITIAL no 
     LABEL "Gera somente uma ficha de CQ por Item/Dep/Localiz/Lote" 
     VIEW-AS TOGGLE-BOX
     SIZE 46 BY .83 NO-UNDO.

DEFINE VARIABLE tg-num-op-rep AS LOGICAL INITIAL no 
     LABEL "Numeraá∆o OP Repetitiva pela Ordem Autom." 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .75.

DEFINE VARIABLE tg-ordem AS LOGICAL INITIAL no 
     LABEL "Gera Ordem Compra de Beneficiamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-req-mater-nao-previs AS LOGICAL INITIAL no 
     LABEL "Requisita Mat. N∆o Previsto na Reserva" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .75 NO-UNDO.

DEFINE VARIABLE tg-sem-op-ext AS LOGICAL INITIAL no 
     LABEL "OP Externa ou Int/Ext sem Operaá∆o Externa" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-usa-mater-altern-reporte AS LOGICAL INITIAL no 
     LABEL "Usa Mat. Alternativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .75 NO-UNDO.

DEFINE VARIABLE tg-valida-movimentacao-orfa AS LOGICAL INITIAL no 
     LABEL "Valida Movimentaá∆o ‡rf∆" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .75 NO-UNDO.

DEFINE VARIABLE tg-valor-desmontagem AS LOGICAL  
     LABEL "Valoriza Desmontagem com valor Informado" 
     VIEW-AS TOGGLE-BOX
     SIZE 46 BY .83 TOOLTIP "Determina se o movimento de DIV de Desmontagem gerado no CP0318 dever† ser valorizado ao informado" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     rs-interface-manut-reserva AT ROW 1.79 COL 2.43 HELP
          "Simplificada (Padr∆o)~; Detalhada (Melhorada)" NO-LABEL
     param-cp.pede-item AT ROW 3.04 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 23.72 BY .75
     param-cp.ver-req AT ROW 3.75 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 21.57 BY .75
     rs-verifica-repetitivo AT ROW 4.5 COL 2
     tg-req-mater-nao-previs AT ROW 5.21 COL 2
     tg-usa-mater-altern-reporte AT ROW 5.92 COL 2
     param-cp.ord-sum AT ROW 7.54 COL 2.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Uma", 1,
"V†rias", 2
          SIZE 17.57 BY .75
     param-cp.rep-item AT ROW 8.25 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 30 BY .75
     param-cp.tp-sum AT ROW 9.83 COL 2.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Per°odos", 1,
"Datas", 2
          SIZE 21.14 BY .75
     tg-ficha-ord AT ROW 11 COL 2 WIDGET-ID 2
     tg-valor-desmontagem AT ROW 11.79 COL 2
     param-cp.aloca-ord AT ROW 1.79 COL 34.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
          "Opcional", 1,
          "Obrigat¢ria", 2
          SIZE 25.86 BY .75
     param-cp.aloca-altern AT ROW 3.04 COL 34.14
          VIEW-AS TOGGLE-BOX
          SIZE 19.14 BY .75
     param-cp.aloca-reserva AT ROW 3.83 COL 34.14
          VIEW-AS TOGGLE-BOX
          SIZE 17.14 BY .75
     param-cp.gera-rast-lote AT ROW 4.63 COL 34.14
          VIEW-AS TOGGLE-BOX
          SIZE 30.29 BY .75
     param-cp.gera-op-aut AT ROW 5.42 COL 34.14
          VIEW-AS TOGGLE-BOX
          SIZE 24.14 BY .75
     tg-num-op-rep AT ROW 6.21 COL 34.14
     tg-ordem AT ROW 7.63 COL 34.14
     tg-com-op-ext AT ROW 8.38 COL 34.14
     tg-sem-op-ext AT ROW 9.13 COL 34.14
     tg-valida-movimentacao-orfa AT ROW 9.88 COL 34.14
     tg-consiste-mob-ggf-zerado AT ROW 11.75 COL 35.72
     cb-alter-benef AT ROW 7.54 COL 63 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     fill-interface-reservas AT ROW 1 COL 2.86 NO-LABEL
     fill-ord-sum AT ROW 6.92 COL 2.86 NO-LABEL
     fill-tp-sum AT ROW 9.17 COL 2.86 NO-LABEL
     fill-aloca-ord AT ROW 1 COL 33.57 COLON-ALIGNED NO-LABEL
     RECT-17 AT ROW 2.92 COL 1.29
     RECT-18 AT ROW 7.25 COL 1.29
     RECT-20 AT ROW 9.5 COL 1.29
     RECT-21 AT ROW 1.21 COL 33.43
     RECT-22 AT ROW 2.92 COL 33.43
     RECT-23 AT ROW 10.92 COL 1.29
     RECT-24 AT ROW 7.42 COL 33.43
     RECT-25 AT ROW 1.21 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-cp
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
         HEIGHT             = 11.88
         WIDTH              = 85.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fill-aloca-ord IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fill-interface-reservas IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fill-ord-sum IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fill-tp-sum IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       tg-num-op-rep:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME rs-interface-manut-reserva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-interface-manut-reserva V-table-Win
ON VALUE-CHANGED OF rs-interface-manut-reserva IN FRAME f-main
DO:
    IF rs-interface-manut-reserva:SCREEN-VALUE IN FRAME f-main = "1" THEN
        ASSIGN tg-req-mater-nao-previs:SENSITIVE     IN FRAME f-main = NO
               tg-req-mater-nao-previs:CHECKED       IN FRAME f-main = NO.
    ELSE
        ASSIGN tg-req-mater-nao-previs:SENSITIVE      IN FRAME f-main = YES
               tg-req-mater-nao-previs:CHECKED        IN FRAME f-main = tg-req-mater-nao-previs.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-ordem V-table-Win
ON VALUE-CHANGED OF tg-ordem IN FRAME f-main /* Gera Ordem Compra de Beneficiamento */
DO:

  find current param-cp exclusive-lock no-error.
  if input frame {&frame-name} tg-ordem = yes then
     assign tg-sem-op-ext:sensitive in frame {&frame-name} = yes
            tg-com-op-ext:sensitive in frame {&frame-name} = yes.
  else
     assign tg-sem-op-ext:checked   in frame {&frame-name} = no
            tg-com-op-ext:checked   in frame {&frame-name} = no
            tg-sem-op-ext:sensitive in frame {&frame-name} = no
            tg-com-op-ext:sensitive in frame {&frame-name} = no
            substring(param-cp.char-2,5,1) = "2"
            substring(param-cp.char-2,6,1) = "2".


 find current param-cp no-lock no-error.          

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

{utp/ut-liter.i Numeraá∆o_OP_Repetitiva_pela_Ordem_Autom. * r}
assign tg-num-op-rep:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Gera_somente_uma_ficha_de_CQ_por_Item/Dep/Localiz/Lote * r}
assign tg-ficha-ord:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Valoriza_Desmontagem_com_valor_informado * r}
assign tg-valor-desmontagem:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Consiste_reporte_MOB_GGF_zerado * r}
assign tg-consiste-mob-ggf-zerado:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Gera_Ordem_Compra_de_Beneficiamento * r}
assign tg-ordem:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i OP_Externa_ou_Int/Ext_sem_Operaá∆o_Externa * r}
assign tg-sem-op-ext:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i OP_Interna_com_Operaá∆o_Externa * r}
assign tg-com-op-ext:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Verifica_REQ_no_Reporte_Ass°ncrono * r}
assign rs-verifica-repetitivo:label in frame {&frame-name} = trim(return-value).

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
  {src/adm/template/row-list.i "param-cp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-cp"}

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

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-rtlbl.i mgind param-cp ord-sum   fill-ord-sum}
  {utp/ut-rtlbl.i mgind param-cp tp-sum    fill-tp-sum}
  {utp/ut-rtlbl.i mgind param-cp aloca-ord fill-aloca-ord}

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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  

    assign l-ordem       = input frame {&frame-name} tg-ordem
           l-sem-op-ext  = input frame {&frame-name} tg-sem-op-ext
           l-com-op-ext  = input frame {&frame-name} tg-com-op-ext
           l-num-op-rep  = INPUT FRAME {&FRAME-NAME} tg-num-op-rep.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

    find first param-cp exclusive-lock no-error.

    if l-ordem then
       assign substring(param-cp.char-2,4,1) = "1". /* SIM */
    else 
       assign substring(param-cp.char-2,4,1) = "2". /* N«O */

    if l-sem-op-ext then
       assign substring(param-cp.char-2,5,1) = "1". /* SIM */
    else 
       assign substring(param-cp.char-2,5,1) = "2". /* N«O */

    if l-com-op-ext then
       assign substring(param-cp.char-2,6,1) = "1". /* SIM */
    else 
       assign substring(param-cp.char-2,6,1) = "2". /* N«O */

    if INPUT FRAME {&FRAME-NAME} rs-verifica-repetitivo then
       assign substring(param-cp.char-2,10,1) = "1". /* SIM */
    else 
       assign substring(param-cp.char-2,10,1) = "2". /* N«O */

    /* No EMS 2.00, o parametro param-cp.log-1 guarda o flag "Numeraá∆o Autom†tica no Reporte";
       A partir da release 2.04, a numeracao automatica Ç guardado em param-cp.log-num-rep-aut,
       e o param-cp.log-1 passa a guardar o flag "Numeraá∆o OP Repetitiva pela Ordem Autom."
       A partir da release 2.06, o campo param-cp.log-seq-ord-repet substitui o param-cp.log-1 */
       
    ASSIGN param-cp.log-seq-ord-repet = l-num-op-rep.
        
    ASSIGN param-cp.pede-item      = INPUT FRAME {&frame-name} param-cp.pede-item 
           param-cp.ver-req        = INPUT FRAME {&frame-name} param-cp.ver-req
           param-cp.ord-sum        = INPUT FRAME {&frame-name} param-cp.ord-sum
           param-cp.rep-item       = INPUT FRAME {&frame-name} param-cp.rep-item
           param-cp.tp-sum         = INPUT FRAME {&frame-name} param-cp.tp-sum
           param-cp.aloca-ord      = INPUT FRAME {&frame-name} param-cp.aloca-ord
           param-cp.aloca-altern   = INPUT FRAME {&frame-name} param-cp.aloca-altern
           param-cp.aloca-reserva  = INPUT FRAME {&frame-name} param-cp.aloca-reserva         
           param-cp.gera-rast-lote = INPUT FRAME {&frame-name} param-cp.gera-rast-lote
           param-cp.gera-op-aut    = INPUT FRAME {&frame-name} param-cp.gera-op-aut
           .

    assign param-cp.log-ficha-ord = tg-ficha-ord:checked in frame {&frame-name}
           param-cp.log-finaliza-op = tg-valida-movimentacao-orfa:checked in frame f-main.

    ASSIGN param-cp.idi-interfac-manut-reserva   = INT(rs-interface-manut-reserva:SCREEN-VALUE IN FRAME f-main)
           param-cp.log-req-mater-nao-previs     = tg-req-mater-nao-previs:CHECKED IN FRAME f-main 
           param-cp.log-usa-mater-altern-reporte = tg-usa-mater-altern-reporte:CHECKED IN FRAME f-main.

    find first param-cp no-lock no-error.
    RUN pi-assign-param-manuf.

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

   find first param-cp exclusive-lock no-error.

   assign tg-ficha-ord:checked in frame {&frame-name} = param-cp.log-ficha-ord.

   if substring(param-cp.char-2,4,1) = "1" then
      assign tg-ordem = yes
             tg-sem-op-ext:sensitive in frame {&frame-name} = yes
             tg-com-op-ext:sensitive in frame {&frame-name} = YES.
   else 
      assign tg-ordem      = no
             tg-sem-op-ext = no
             tg-com-op-ext = no
             substring(param-cp.char-2,5,1) = "2"
             substring(param-cp.char-2,6,1) = "2"
             tg-sem-op-ext:sensitive in frame {&frame-name} = no
             tg-com-op-ext:sensitive in frame {&frame-name} = no.

   if substring(param-cp.char-2,5,1) = "1" then
      assign tg-sem-op-ext = yes.
   else 
      assign tg-sem-op-ext = no.

   if substring(param-cp.char-2,6,1) = "1" then
      assign tg-com-op-ext = yes.
   else 
      assign tg-com-op-ext = no.

   if substring(param-cp.char-2,10,1) = "2" then
      assign rs-verifica-repetitivo:sensitive in frame {&frame-name} = yes
             rs-verifica-repetitivo = NO.
   else 
      assign rs-verifica-repetitivo:sensitive in frame {&frame-name} = yes
             rs-verifica-repetitivo = YES.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

   RUN pi-trata-param-manuf.

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-rtlbl.i mgind param-cp ord-sum   fill-ord-sum}
  {utp/ut-rtlbl.i mgind param-cp tp-sum    fill-tp-sum}
  {utp/ut-rtlbl.i mgind param-cp aloca-ord fill-aloca-ord} 

  /* No EMS 2.00, o parametro param-cp.log-1 guarda o flag "Numeraá∆o Autom†tica no Reporte";
     A partir da release 2.04, a numeracao automatica Ç guardado em param-cp.log-num-rep-aut,
     e o param-cp.log-1 passa a guardar o flag "Numeraá∆o OP Repetitiva pela Ordem Autom."
     A partir da release 2.06, o campo param-cp.log-seq-ord-repet substitui o param-cp.log-1 */

  assign tg-num-op-rep:CHECKED  IN FRAME {&FRAME-NAME} = param-cp.log-seq-ord-repet. 
  
  assign tg-ficha-ord:checked in frame {&frame-name} = param-cp.log-ficha-ord.
  
  ASSIGN rs-interface-manut-reserva:SCREEN-VALUE IN FRAME f-main = STRING(param-cp.idi-interfac-manut-reserva).

  ASSIGN tg-req-mater-nao-previs = param-cp.log-req-mater-nao-previs.
                                                          
  ASSIGN tg-usa-mater-altern-reporte = param-cp.log-usa-mater-altern-reporte.
  
  assign tg-valida-movimentacao-orfa = param-cp.log-finaliza-op.

  DISPLAY tg-req-mater-nao-previs tg-usa-mater-altern-reporte 
          tg-valida-movimentacao-orfa tg-valor-desmontagem 
          tg-consiste-mob-ggf-zerado cb-alter-benef WITH FRAME f-main.
                                                          
  APPLY "value-changed" TO rs-interface-manut-reserva IN FRAME f-main.
                                                          
  find current param-cp no-lock no-error.

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
 
  {utp/ut-rtlbl.i mgind param-cp ord-sum   fill-ord-sum}
  {utp/ut-rtlbl.i mgind param-cp tp-sum    fill-tp-sum}
  {utp/ut-rtlbl.i mgind param-cp aloca-ord fill-aloca-ord} 

  {utp/ut-liter.i Gera_Rastr._Batch mcp l}
  assign gera-rast-lote:label in frame {&frame-name} = trim (return-value).

  ASSIGN tg-num-op-rep:HIDDEN IN FRAME {&FRAME-NAME} = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign-param-manuf V-table-Win 
PROCEDURE pi-assign-param-manuf :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

   FOR FIRST param-manuf
       WHERE param-manuf.cod-entid = "param-cp"
         AND param-manuf.cod-param = "val-desmontag-inform" EXCLUSIVE-LOCK:
   END.
  
   ASSIGN param-manuf.param-logico = tg-valor-desmontagem:CHECKED IN FRAME {&FRAME-NAME}.

   RELEASE param-manuf.

   FOR FIRST param-manuf
       WHERE param-manuf.cod-entid = "param-cp"
         AND param-manuf.cod-param = "consiste-mob-ggf-zerado" EXCLUSIVE-LOCK:
   END.

   ASSIGN param-manuf.param-logico = tg-consiste-mob-ggf-zerado:CHECKED IN FRAME {&FRAME-NAME}.

   FOR FIRST param-manuf
       WHERE param-manuf.cod-entid = "param-cp"
         AND param-manuf.cod-param = "alter-ord-benefic" EXCLUSIVE-LOCK:
   END.

   ASSIGN param-manuf.param-inteiro = int(cb-alter-benef:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

   RELEASE param-manuf.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-param-manuf V-table-Win 
PROCEDURE pi-trata-param-manuf :
/*------------------------------------------------------------------------------
  Purpose: Criar os registros da param-manuf caso n∆o existam
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

 FOR FIRST param-manuf
     WHERE param-manuf.cod-entid = "param-cp"
       AND param-manuf.cod-param = "val-desmontag-inform" NO-LOCK:
 END.

 IF NOT AVAIL param-manuf THEN DO:

     CREATE param-manuf.
     ASSIGN param-manuf.cod-entid = "param-cp"                      
            param-manuf.cod-param = "val-desmontag-inform"
            param-manuf.dsl-help-msg = "Define se o movimento de DIV gerado pela desmontagem (CP0318) deve ser valorizado ao informado ou conforme o preáo mÇdio do item no per°odo (antigo parÉmetro 'Consiste valor Retorno')"
            param-manuf.desc-param = "Valoriza Desmontagem com valor informado"
            param-manuf.titulo = "Val. Desmont. val. Inf.".
 END.

 ASSIGN tg-valor-desmontagem = param-manuf.param-logico.

 FOR FIRST param-manuf
     WHERE param-manuf.cod-entid = "param-cp"
       AND param-manuf.cod-param = "consiste-mob-ggf-zerado" NO-LOCK:
 END.

 IF NOT AVAIL param-manuf THEN DO:

     CREATE param-manuf.
     ASSIGN param-manuf.cod-entid = "param-cp"                      
            param-manuf.cod-param = "consiste-mob-ggf-zerado"
            param-manuf.dsl-help-msg = "Determina se o sistema deve exibir uma mensagem de erro durante a tentativa de criar um reporte de GGF ou MOB com horas zeradas"
            param-manuf.desc-param = "Consiste apontamento MOB/GGF zerado".
 END.

 ASSIGN tg-consiste-mob-ggf-zerado = param-manuf.param-logico.

 FOR FIRST param-manuf
     WHERE param-manuf.cod-entid = "param-cp"
       AND param-manuf.cod-param = "alter-ord-benefic" NO-LOCK:
 END.

 IF NOT AVAIL param-manuf THEN DO:

     CREATE param-manuf.
     ASSIGN param-manuf.cod-entid = "param-cp"                      
            param-manuf.cod-param = "alter-ord-benefic"
            param-manuf.dsl-help-msg = "Determina se o sistema ir† alterar a ordem de compra relacionada Ö ordem de produá∆o de beneficiamento. Podendo 1-N∆o alterar, 2-Alterar n∆o confirmadas ou 3-Altera confirmadas"
            param-manuf.desc-param = "Determina a forma de tratamento das ordens de beneficiamento".
 END.

 ASSIGN cb-alter-benef = string(param-manuf.param-inteiro).

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
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "param-cp"}

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


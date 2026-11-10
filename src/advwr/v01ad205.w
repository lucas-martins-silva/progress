&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mguni            PROGRESS
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
{include/i-prgvrs.i V01AD205 2.00.00.045 } /*** "010045" 26/02/2024 17:18:00 ***/
{cdp/cdcfgfin.i}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01ad205 MUT}
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

{include/i_fncrowid.i}
{cdp/cd4300.i3}  /*Vari†veis para o cd4300.i4 */
{cdp/cd0101.i50} /*Vari†veis para o cd0101.i51*/

def new global shared var v_rec_catal_img AS &IF "{&ROWID_READY}" = "YES" &THEN ROWID &ELSE RECID &ENDIF no-undo.
                                             
DEFINE NEW GLOBAL SHARED VARIABLE g-segur-estab AS LOGICAL NO-UNDO.

def var c-conta-contab         as char no-undo.
def var c-conta                as char no-undo.
def var c-sub-conta            as char no-undo.
def var h_v02ad205             as handle no-undo.
def var c-retorna              as char no-undo.
def var l-resposta             as logical no-undo.
def var i-tamanho              as integer no-undo.
def var i-posicao              as integer no-undo.
def var l-alt-serie            as logical init no no-undo.
def var l-bancos-ja-conectados as logical init no no-undo.

def var c-return       as char no-undo.
def var c-office       as char no-undo.
def var l-conec-uni    as logical no-undo.
def var l-conec-bas    as logical no-undo.

def buffer b-tab-ocor for tab-ocor.
DEF BUFFER b_param-global FOR param-global.

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{btb/btb009za.i} /* Define tt_erros_conexao */
{include/i_dbvers.i}
{include/i_prdvers.i}

&IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
    {cdp/cd9590.i}   /*Unidade de Neg¢cio*/
&ENDIF

DEF VAR h-btb009za AS HANDLE.
def var l_erro as logical no-undo.
Def New Global Shared Var h-btb432za As Handle No-undo.

&IF "{&EMSFND_VERSION}" < "1.00" &THEN
   {btb/btb432za.i}
&ENDIF

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
&Scoped-define EXTERNAL-TABLES param-global
&Scoped-define FIRST-EXTERNAL-TABLE param-global


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-global.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-global.grupo param-global.empresa-prin ~
param-global.formato-id-pessoal param-global.formato-cep ~
param-global.formato-id-federal param-global.label-cgc ~
param-global.bloqueio-cgc param-global.tp-estr-banco ~
param-global.id-estadual-obrigatorio param-global.id-federal-obrigatorio ~
param-global.cod-catal-img-banco 
&Scoped-define ENABLED-TABLES param-global
&Scoped-define FIRST-ENABLED-TABLE param-global
&Scoped-Define ENABLED-OBJECTS RECT-19 RECT-20 RECT-24 RECT-25 RECT-29 ~
RECT-30 RECT-31 RECT-32 RECT-33 rt-key RECT-43 l-segur-estab l-altera-emit ~
cb-venc-dom rs-cons-conta cb-venc-fer cb-venc-sab ~
i-ult-emit l-valida-cidade l-utiliza-serie l-atua-ifrs 
&Scoped-Define DISPLAYED-FIELDS param-global.grupo ~
param-global.empresa-prin param-global.formato-id-pessoal ~
param-global.formato-cep param-global.formato-id-federal ~
param-global.label-cgc param-global.bloqueio-cgc param-global.tp-estr-banco ~
param-global.id-estadual-obrigatorio param-global.id-federal-obrigatorio ~
param-global.cod-catal-img-banco 
&Scoped-define DISPLAYED-TABLES param-global
&Scoped-define FIRST-DISPLAYED-TABLE param-global
&Scoped-Define DISPLAYED-OBJECTS c-razao-social l-segur-estab l-altera-emit ~
cb-venc-dom rs-cons-conta cb-venc-fer cb-venc-sab ~
i-ult-emit tg-valida-rest-ems5 l-valida-cidade l-utiliza-serie ~
l-valid-cred-cli c-des-cat-imag-bco l-atua-ifrs 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-venc-dom cb-venc-fer cb-venc-sab ~
l-valid-cred-cli 

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
DEFINE VARIABLE cb-venc-dom AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-venc-fer AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-venc-sab AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-des-cat-imag-bco AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE c-razao-social AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 45.43 BY .88.

DEFINE VARIABLE fi-dados-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13.14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-dados-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12.29 BY .63 NO-UNDO.

DEFINE VARIABLE fi-dados-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15.72 BY .63 NO-UNDO.

DEFINE VARIABLE fi-dados-4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-dados-5 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13.72 BY .63 NO-UNDO.

DEFINE VARIABLE i-ult-emit AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE rs-cons-conta AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "", 1,
"", 2
     SIZE 21.14 BY 1.75 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15.57 BY 2.33.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 22 BY 2.33.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 3.5.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28 BY 3.5.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 4.67.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 1.33.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 1.63.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 2.21.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37.72 BY 1.21.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 1.25.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 2.25.

DEFINE VARIABLE l-altera-emit AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-atua-ifrs AS LOGICAL INITIAL no 
     LABEL "Utiliza IFRS" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.


DEFINE VARIABLE l-segur-estab AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.72 BY .83 NO-UNDO.

DEFINE VARIABLE l-utiliza-serie AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-valid-cred-cli AS LOGICAL INITIAL no 
     LABEL "Avalia Cliente Intellector" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE l-valida-cidade AS LOGICAL INITIAL no 
     LABEL "Valida Cidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE tg-valida-rest-ems5 AS LOGICAL INITIAL no 
     LABEL "Valida Restriá‰es EMS 5 on-line" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.29 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-global.grupo AT ROW 1.17 COL 26.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 50.57 BY .88
     param-global.empresa-prin AT ROW 2.17 COL 26.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-razao-social AT ROW 2.17 COL 32 COLON-ALIGNED NO-LABEL
     param-global.formato-id-pessoal AT ROW 3.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.14 BY .88
     param-global.formato-cep AT ROW 3.67 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     param-global.formato-id-federal AT ROW 4.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.14 BY .88
     param-global.label-cgc AT ROW 4.67 COL 61.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 23.86 BY .88
     l-segur-estab AT ROW 6.04 COL 2.29 WIDGET-ID 2
     l-altera-emit AT ROW 6.04 COL 50     
     cb-venc-dom AT ROW 8.88 COL 10 COLON-ALIGNED
     param-global.bloqueio-cgc AT ROW 9 COL 31 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Sem bloqueio", 1,
"Advertencia", 2,
"Com bloqueio", 3
          SIZE 18 BY 2.75
     param-global.tp-estr-banco AT ROW 9 COL 50.72 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "", 1,
"", 2
          SIZE 14.43 BY 1.75
     rs-cons-conta AT ROW 9 COL 66.29 NO-LABEL
     cb-venc-fer AT ROW 9.88 COL 10 COLON-ALIGNED
     cb-venc-sab AT ROW 10.88 COL 10 COLON-ALIGNED
     i-ult-emit AT ROW 11.04 COL 74.14 COLON-ALIGNED
     param-global.id-estadual-obrigatorio AT ROW 12.46 COL 4
          VIEW-AS TOGGLE-BOX
          SIZE 31.29 BY .75
     param-global.id-federal-obrigatorio AT ROW 12.46 COL 38.43
          VIEW-AS TOGGLE-BOX
          SIZE 18.57 BY .75
     tg-valida-rest-ems5 AT ROW 12.46 COL 60
     l-valida-cidade AT ROW 13.46 COL 4
     l-utiliza-serie AT ROW 13.46 COL 38.43
     l-valid-cred-cli AT ROW 13.46 COL 60 HELP
          "Realiza a avaliaá∆o e definiá∆o de limites de crÇdito do cliente no Intellector."
     param-global.cod-catal-img-banco AT ROW 14.67 COL 45.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-des-cat-imag-bco AT ROW 14.67 COL 58 COLON-ALIGNED NO-LABEL
     l-atua-ifrs AT ROW 14.75 COL 3.86 HELP
          "Utilizar o IFRS?"
     fi-dados-1 AT ROW 3.25 COL 2 NO-LABEL
     fi-dados-2 AT ROW 8.21 COL 49.14 COLON-ALIGNED NO-LABEL
     fi-dados-5 AT ROW 8.21 COL 64.72 COLON-ALIGNED NO-LABEL
     fi-dados-4 AT ROW 8.25 COL 2 NO-LABEL
     fi-dados-3 AT ROW 8.25 COL 29 COLON-ALIGNED NO-LABEL
     RECT-19 AT ROW 8.5 COL 50.29
     RECT-20 AT ROW 8.5 COL 66
     RECT-24 AT ROW 8.5 COL 29.72
     RECT-25 AT ROW 8.5 COL 1
     RECT-29 AT ROW 3.5 COL 1
     RECT-30 AT ROW 14.46 COL 1
     RECT-31 AT ROW 5.67 COL 1.72
     RECT-32 AT ROW 12.17 COL 1
     RECT-33 AT ROW 10.88 COL 50.29
     rt-key AT ROW 1 COL 1
     RECT-43 AT ROW 14.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mguni.param-global
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
         HEIGHT             = 14.79
         WIDTH              = 87.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-des-cat-imag-bco IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-razao-social IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-venc-dom IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR COMBO-BOX cb-venc-fer IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR COMBO-BOX cb-venc-sab IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN fi-dados-1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN fi-dados-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-dados-3 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-dados-4 IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN fi-dados-5 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-dados-5:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-valid-cred-cli IN FRAME f-main
   NO-ENABLE 3                                                          */
ASSIGN 
       l-valid-cred-cli:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       RECT-20:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       rs-cons-conta:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tg-valida-rest-ems5 IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       tg-valida-rest-ems5:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME param-global.cod-catal-img-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-img-banco V-table-Win
ON F5 OF param-global.cod-catal-img-banco IN FRAME f-main /* Cat†logo Imagens Banco */
DO:
  RUN btb/btb103ka.p.                     
  IF  v_rec_catal_img <> ? then do:
      FIND catal_img WHERE &IF {&ROWID_READY} = YES &THEN
                                ROWID(catal_img) = v_rec_catal_img
                            &ELSE
                                RECID(catal_img) = v_rec_catal_img
                            &ENDIF
                            NO-LOCK NO-ERROR.
      DISP catal_img.cod_catal_img @ param-global.cod-catal-img-banco WITH FRAME {&frame-name}.
  END. /* if v_rec_catal_img ... */                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-img-banco V-table-Win
ON LEAVE OF param-global.cod-catal-img-banco IN FRAME f-main /* Cat†logo Imagens Banco */
DO:
  {include/leave.i &tabela=catal_img    
                   &atributo-ref=des_catal_img
                   &variavel-ref=c-des-cat-imag-bco
                   &where="catal_img.cod_catal_img = INPUT FRAME {&frame-name} param-global.cod-catal-img-banco"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-img-banco V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-global.cod-catal-img-banco IN FRAME f-main /* Cat†logo Imagens Banco */
DO:
  APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-global.empresa-prin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.empresa-prin V-table-Win
ON F5 OF param-global.empresa-prin IN FRAME f-main /* Empresa Principal */
DO:
     assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad101.w
                       &campo=param-global.empresa-prin
                       &campozoom=ep-codigo}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.empresa-prin V-table-Win
ON LEAVE OF param-global.empresa-prin IN FRAME f-main /* Empresa Principal */
DO:
   {include/leave.i &tabela=empresa
                    &atributo-ref=razao-social
                    &variavel-ref=c-razao-social
                    &where="empresa.ep-codigo = input frame {&frame-name}
                     param-global.empresa-prin"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.empresa-prin V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-global.empresa-prin IN FRAME f-main /* Empresa Principal */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-global.formato-id-pessoal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.formato-id-pessoal V-table-Win
ON LEAVE OF param-global.formato-id-pessoal IN FRAME f-main /* formato ID pessoal */
DO:
  if  input frame {&frame-name} param-global.formato-id-pessoal <> "" then do:
      if  input frame {&frame-name} param-global.formato-id-pessoal <> param-global.formato-id-pessoal  then do:
          assign i-tamanho = 0.
          do  i-posicao =  1 to length(input frame {&frame-name} param-global.formato-id-pessoal): 
              if  INDEX("X9.-",substring(input frame {&frame-name} param-global.formato-id-pessoal,i-posicao,1)) = 0 then do:
                  /*"Informa letra diferente de X9."*/
                  run utp/ut-msgs.p (input "show", 
                                     input 16374,
                                     input string(input frame {&frame-name} param-global.empresa-prin)).
                  apply "entry" to param-global.formato-id-pessoal in frame {&frame-name}.
                  return "ADM-ERROR":U.
              end.     
          end.
      end.
  end.    
  else do:
      /* preenchimento obrigatorio */ 
      run utp/ut-msgs.p (input "show", 
                         input 16494,
                         input string(input frame {&frame-name} param-global.empresa-prin)).
      apply "entry" to param-global.formato-id-pessoal in frame {&frame-name}.
      return "ADM-ERROR":U.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-global.grupo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.grupo V-table-Win
ON ENTRY OF param-global.grupo IN FRAME f-main /* Grupo Empresarial */
DO:
  RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
       INPUT "modulo-bh").

 assign c-retorna = return-value. 

 if c-retorna = "Implantado" then
    enable param-global.tp-estr-banco with frame {&frame-name}.
 else
    disable param-global.tp-estr-banco with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-segur-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-segur-estab V-table-Win
ON VALUE-CHANGED OF l-segur-estab IN FRAME f-main
DO:
    IF l-segur-estab:CHECKED IN FRAME {&frame-name} = NO THEN DO:
       
       FIND FIRST param_seg_estab NO-LOCK
          WHERE param_seg_estab.des_valor = "SIM":U NO-ERROR.

       IF AVAILABLE param_seg_estab THEN DO:

          DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Seguranáa_por_Estabelecimento_n∆o_pode_ser_desativada!" * }
          ASSIGN cAuxTraducao002 = TRIM(RETURN-VALUE).
          {utp/ut-liter.i "Somente_ser†_poss°vel_desativar_a_Seguranáa_por_Estabelecimento_quando_todos_os_parÉmetros_por_modulo_estiverem_desativados_na_tela_'ParÉmetros_Seguranáa_por_Estabelecimento'_(Metadados)" *}                
          ASSIGN cAuxTraducao002 = cAuxTraducao002 + "~~" + TRIM(RETURN-VALUE).

          RUN utp/ut-msgs.p (INPUT 'show', 
                             INPUT 17006, 
                             INPUT cAuxTraducao002).

           ASSIGN l-segur-estab:CHECKED IN FRAME {&frame-name} = YES.
       END.
    END.    

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 54611,
                       input "").
    
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

  IF param-global.cod-catal-img-banco:LOAD-MOUSE-POINTER("image~\lupa.cur") IN FRAME {&frame-name} THEN.

  {utp/ut-liter.i Formatos * R}
  assign fi-dados-1:screen-value in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i "Estrutura BH" * C}
  assign fi-dados-2:screen-value in frame {&frame-name} = return-value.


  {utp/ut-rtlbl.i mgind param-global ind-venc-sab  fi-dados-4}

  {utp/ut-liter.i Vencimentos * R}
  assign fi-dados-4:screen-value in frame {&frame-name} = trim(return-value).

  if  param-global.empresa-prin:load-mouse-pointer("Image~\lupa.cur") then .

  assign param-global.tp-estr-banco:radio-buttons = {adinc/i04ad205.i 7}.

  &IF DEFINED (bf_dis_consiste_conta) &then

      {utp/ut-liter.i "Estrutura BH" * C}
      assign fi-dados-2:screen-value in frame {&frame-name} = trim(return-value).

      {utp/ut-liter.i Conta_Cont†bil}
      assign fi-dados-5:screen-value in frame {&frame-name} = trim(return-value).

  &ELSE

      {utp/ut-liter.i "Estrutura Bancos Hist¢ricos" * C}
      assign fi-dados-2:width        in frame {&frame-name} = 21.00
             fi-dados-2:screen-value in frame {&frame-name} = trim(return-value).

  &ENDIF

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
  {src/adm/template/row-list.i "param-global"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-global"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  FIND FIRST param-global NO-LOCK NO-ERROR.
  FIND FIRST b_param-global NO-LOCK NO-ERROR.

  &IF "{&EMSFND_VERSION}" < "1.00" &THEN
      IF INPUT FRAME {&FRAME-NAME} param-global.grupo <> b_param-global.grupo THEN DO:
         IF l-configur = YES  THEN DO:
             RUN utp/ut-msgs.p ( INPUT "show",
                                 INPUT 52103,
                                 INPUT "").
            
         END.
         ELSE DO:    
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-grupo-empresarial AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Grupo_Empresarial_Alterado_incorretamente" *}
            ASSIGN c-lbl-liter-grupo-empresarial = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-o-campo-grupo-empr AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "O_campo_Grupo_Empresarial_n∆o_pode_ser_alterado_porque_este_procedimento_gera_erro_de_Violaá∆o_de_Registro_de_Produto" *}
            ASSIGN c-lbl-liter-o-campo-grupo-empr = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p ( INPUT "show",
                                 INPUT 17242,
                                 INPUT c-lbl-liter-grupo-empresarial + "." + "~~" + c-lbl-liter-o-campo-grupo-empr + ".").
            APPLY "entry" TO param-global.grupo IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR":U.
         END. /* else */
      END. /* if */
  &ENDIF
        
  &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
     find first conta no-lock no-error.
     find first sub-conta no-lock no-error.
     find first conta-contab no-lock no-error.
  &ENDIF

  find empresa where empresa.ep-codigo = input frame {&frame-name} 
        param-global.empresa-prin no-lock no-error.

  if  not avail empresa then do:
      run utp/ut-msgs.p (input "show", 
                         input 12, 
                         input string(input frame {&frame-name} param-global.empresa-prin)).
      apply "entry" to param-global.empresa-prin in frame {&frame-name}.
      return "ADM-ERROR":U.
  end.  

  /* TESTA FORMATO CEP */
  if  input frame {&frame-name} param-global.formato-cep <> "" then do:
      if  input frame {&frame-name} param-global.formato-cep <> param-global.formato-cep  then do:
          assign i-tamanho = 0.
          do  i-posicao =  1 to length(input frame {&frame-name} param-global.formato-cep): 
              if  INDEX("X9.-",substring(input frame {&frame-name} param-global.formato-cep,i-posicao,1)) = 0 then do:
                  /*"Informa letra diferente de X9."*/
                  run utp/ut-msgs.p (input "show", 
                                     input 16374,
                                     input string(input frame {&frame-name} param-global.empresa-prin)).
                  apply "entry" to param-global.formato-cep in frame {&frame-name}.
                  return "ADM-ERROR":U.
              end.     
          end.         
      end.
  end.
  else do:
       /* preenchimento obrigatorio */ 
       run utp/ut-msgs.p (input "show", 
                          input 16492,
                          input "").
       apply "entry" to param-global.formato-cep in frame {&frame-name}.
       return "ADM-ERROR":U.
  end.     

  /* TESTA FORMATO CGC */
  if  input frame {&frame-name} param-global.formato-id-federal <> "" then do:
      if  input frame {&frame-name} param-global.formato-id-federal <> param-global.formato-id-federal  then do:
          assign i-tamanho = 0.
          do  i-posicao =  1 to length(input frame {&frame-name} param-global.formato-id-federal): 
              if  INDEX("X9.-/",substring(input frame {&frame-name} param-global.formato-id-federal,i-posicao,1)) = 0 then do:
                  /*"Informa letra diferente de X9."*/
                  run utp/ut-msgs.p (input "show", 
                                     input 16374,
                                     input string(input frame {&frame-name} param-global.empresa-prin)).
                  apply "entry" to param-global.formato-id-federal in frame {&frame-name}.
                  return "ADM-ERROR":U.
              end.     
          end.         
      end.
  end.
  else do:
       /* preenchimento obrigatorio */ 
       run utp/ut-msgs.p (input "show", 
                          input 16493,
                          input "").
       apply "entry" to param-global.formato-id-federal in frame {&frame-name}.
       return "ADM-ERROR":U.
  end.

  /* TESTA FORMATO CPF */
  if  input frame {&frame-name} param-global.formato-id-pessoal <> "" then do:
      if  input frame {&frame-name} param-global.formato-id-pessoal <> param-global.formato-id-pessoal  then do:
          assign i-tamanho = 0.
          do  i-posicao =  1 to length(input frame {&frame-name} param-global.formato-id-pessoal): 
              if  INDEX("X9.-",substring(input frame {&frame-name} param-global.formato-id-pessoal,i-posicao,1)) = 0 then do:
                  /*"Informa letra diferente de X9."*/
                  run utp/ut-msgs.p (input "show", 
                                     input 16374,
                                     input string(input frame {&frame-name} param-global.empresa-prin)).
                  apply "entry" to param-global.formato-id-pessoal in frame {&frame-name}.
                  return "ADM-ERROR":U.
              end.     
          end.
      end.
  end.    
  else do:
      /* preenchimento obrigatorio */ 
      run utp/ut-msgs.p (input "show", 
                         input 16494,
                         input string(input frame {&frame-name} param-global.empresa-prin)).
      apply "entry" to param-global.formato-id-pessoal in frame {&frame-name}.
      return "ADM-ERROR":U.
  end.

  /* BF_FIN_AUMENTO_DIGITO_CCUSTO -> N∆o mostra os campos ct-format, sc-format e formato-conta-contabil 
     Todas as l¢gicas envolvendo estes campos somente dever∆o ser aplicadas se n∆o houver o BF_FIN_AUMENTO_DIGITO_CCUSTO */
  &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
  
      /* ATENÄ«O: N∆o mudar a l¢gica abaixo */
      if  param-global.ct-format <> "" then do:
          if  input frame {&frame-name} param-global.ct-format <> param-global.ct-format  then do:
              if avail conta then do:
                 run utp/ut-msgs.p (input "show",
                                     input 8807,
                                     input ""). 
                 apply "entry" to param-global.ct-format in frame {&frame-name}.
                 return "ADM-ERROR":U.
              end.
              assign i-tamanho = 0.
              do  i-posicao =  1 to length(input frame {&frame-name} param-global.ct-format): 
                  if  INDEX("X9.",substring(input frame {&frame-name} param-global.ct-format,i-posicao,1)) = 0 then do:
                      /*"Informa letra diferente de X9."*/
                      run utp/ut-msgs.p (input "show", 
                                         input 16374,
                                         input string(input frame {&frame-name} param-global.empresa-prin)).
                      apply "entry" to param-global.ct-format in frame {&frame-name}.
                      return "ADM-ERROR":U.
                  end.     
                  if substring(input frame {&frame-name} param-global.ct-format,i-posicao,1) <> "." then 
                     assign i-tamanho = i-tamanho + 1.
                  if  i-tamanho > 8 then do:
                      /*"tamanho da conta ultrapassou 8 digitos"*/
                      run utp/ut-msgs.p (input "show", 
                                         input 16377,
                                         input string(input frame {&frame-name} param-global.empresa-prin)).
                      apply "entry" to param-global.ct-format in frame {&frame-name}.
                      return "ADM-ERROR":U.
    
                  end.       
              end.         
          end.     
        end.
        else if param-global.ct-format:screen-value <> "" then do:
            assign i-tamanho = 0.
            do  i-posicao =  1 to length(input frame {&frame-name} param-global.ct-format): 
                if  INDEX("X9.",substring(input frame {&frame-name} param-global.ct-format,i-posicao,1)) = 0 then do:
                    /*"Informa letra diferente de X9."*/
                    run utp/ut-msgs.p (input "show", 
                                       input 16374,
                                       input string(input frame {&frame-name} param-global.empresa-prin)).
                    apply "entry" to param-global.ct-format in frame {&frame-name}.
                    return error.
                end.     
                if substring(input frame {&frame-name} param-global.ct-format,i-posicao,1) <> "." then 
                   assign i-tamanho = i-tamanho + 1.
    
                if  i-tamanho > 8 then do:
                    /*"tamanho da conta ultrapassou 8 digitos"*/
                    run utp/ut-msgs.p (input "show", 
                                       input 16377,
                                       input string(input frame {&frame-name} param-global.empresa-prin)).
                    apply "entry" to param-global.ct-format in frame {&frame-name}.
                    return error.
                end.       
            end.
        end.
    
      /* ATENÄ«O: N∆o mudar a l¢gica abaixo */
      if  param-global.sc-format <> "" then do:
          if  input frame {&frame-name} param-global.sc-format <> param-global.sc-format then do: 
              if  avail sub-conta then do:
                  run utp/ut-msgs.p (input "show",
                                     input 8808,
                                     input ""). 
                  apply "entry" to param-global.sc-format in frame {&frame-name}.
                  return "ADM-ERROR":U.
              end.
              if  avail conta-contab then do:
                  run utp/ut-msgs.p (input "show",
                                     input 16378,
                                     input ""). 
                  apply "entry" to param-global.sc-format in frame {&frame-name}.
                  return "ADM-ERROR":U.
    
              end.
              do  i-posicao =  1 to length(input frame {&frame-name} param-global.sc-format): 
                  if  INDEX("X9.",substring(input frame {&frame-name} param-global.sc-format,i-posicao,1)) = 0 then do:
                      /*"Informa letra diferente de X9."*/
                      run utp/ut-msgs.p (input "show", 
                                         input 16374,
                                         input string(input frame {&frame-name} param-global.empresa-prin)).
                      apply "entry" to param-global.ct-format in frame {&frame-name}.
                      return "ADM-ERROR":U.
                  end.
              end.
          end.
      end.

  &ENDIF

  run pi-integra-ems50.
  if return-value = "ADM-ERROR":U then
      return "ADM-ERROR":U.      

  {cdp/cd4300.i4  "yes" param-global.char-2}             
  {cdp/cd0101.i51 "yes"}

  if (l-ut-ser
  and input frame {&FRAME-NAME} l-utiliza-serie = no)
  or (not l-ut-ser
  and input frame {&FRAME-NAME} l-utiliza-serie = yes)
  then
    assign l-alt-serie = yes.
  else 
    assign l-alt-serie = no.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  if  param-global.modulo-ft = yes
  and connected("mgdis") then do:
      run cdp/cd0101b.p (input l-alt-serie,
                         input input frame {&FRAME-NAME} l-utiliza-serie).
  end.   

  if  param-global.modulo-re
  and connected("mgind") then do:
      run cdp/cd0101j.p (input l-alt-serie,
                         input input frame {&FRAME-NAME} l-utiliza-serie).
  end.               
  /* BF_FIN_AUMENTO_DIGITO_CCUSTO -> N∆o mostra os campos ct-format, sc-format e formato-conta-contabil 
     Todas as l¢gicas envolvendo estes campos somente dever∆o ser aplicadas se n∆o houver o BF_FIN_AUMENTO_DIGITO_CCUSTO */
  &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
  
      assign param-global.formato-conta-contabil = param-global.ct-format 
                                                 + "." 
                                                 + param-global.sc-format.
    
      if  length(param-global.formato-conta-contabil) > 17 then do:
          /*"conta n∆o pode ser maior que 17"*/
          run utp/ut-msgs.p (input "show", 
                             input 16373,
                             input string(input frame {&frame-name} param-global.empresa-prin)).
          apply "entry" to param-global.ct-format in frame {&frame-name}.
          return error.
      end.

  &ENDIF

  assign input frame {&frame-name} cb-venc-sab
         param-global.ind-venc-sab = {adinc/i01ad205.i 06 cb-venc-sab}.                                             

  assign input frame {&frame-name} cb-venc-dom
         param-global.ind-venc-dom = {adinc/i01ad205.i 06 cb-venc-dom}.         

  assign input frame {&frame-name} cb-venc-fer
         param-global.ind-venc-fer = {adinc/i01ad205.i 06 cb-venc-fer}.       

  /*Atualizaá∆o da vari†vel no char-2*/   
  assign l-ut-ser = l-utiliza-serie:checked in frame {&FRAME-NAME}.
  {cdp/cd0101.i51 "no"}
  {cdp/cd4300.i4  "no" param-global.char-2}             

  /* Esta tabela Ç utilizada para gravar o c¢digo do £ltimo cliente cadastrado */
  if not avail tab-ocor then do:
     create tab-ocor.
     assign tab-ocor.cod-tab    = 098 
            tab-ocor.descricao  = "Inclui Emit" 
            tab-ocor.i-campo[1] = 0.
  end.
  if input frame {&frame-name} i-ult-emit <> tab-ocor.i-campo[1] then do:
     find first tab-ocor use-index descricao where
                tab-ocor.cod-tab   = 098 and
                tab-ocor.descricao = "Inclui Emit" 
                exclusive-lock no-error.
     assign tab-ocor.i-campo[1] = input frame {&frame-name} i-ult-emit.
  end.              

  if not avail b-tab-ocor then do:
     create b-tab-ocor.
     assign b-tab-ocor.cod-tab    = 098 
            b-tab-ocor.descricao  = "Altera Nome Abreviado"
            b-tab-ocor.cod-ocor   = 1 
            b-tab-ocor.log-1 = yes.
  end.
  if input frame {&frame-name} l-altera-emit <> b-tab-ocor.log-1 then do:
     find first b-tab-ocor use-index descricao where
                b-tab-ocor.cod-tab   = 098 and
                b-tab-ocor.descricao = "Altera Nome Abreviado" 
                exclusive-lock no-error.
     assign b-tab-ocor.log-1 = input frame {&frame-name} l-altera-emit.
  end.

  &IF DEFINED (bf_dis_consiste_conta) &THEN
      assign param-global.ind-cons-conta = input frame {&frame-name} rs-cons-conta.
  &ENDIF  

  &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
      assign param-global.dec-1 = int(input frame {&frame-name} l-valida-cidade).
  &ENDIF
  
  /*Valida Restriá‰es Unidade Neg¢cio e Intellector*/
  &if "{&bf_mat_versao_ems}" >= "2.062" &then
  
      &IF '{&bf_dis_versao_ems}' >= '2.08' &THEN 
          assign param-global.log-cr-clien = l-valid-cred-cli:checked in frame {&frame-name}. 
      &ELSE 
          assign overlay(param-global.char-2,32,1) = if l-valid-cred-cli:checked in frame {&frame-name} then "S" else "N".
      &ENDIF

      if l-unidade-negocio then do:
          &if "{&bf_mat_versao_ems}" <= "2.072" &then
              assign OVERLAY(param-global.char-2,31,1) = if tg-valida-rest-ems5:checked in frame {&frame-name}
                                                           then "2"
                                                           else "".
          &else
              assign param-global.log-validac-ems5 = tg-valida-rest-ems5:checked in frame {&frame-name}.
          &endif
      end.
  &endif.
  
  /*CD0101 - Campo: Atualiza IFRS - Aba ParÉmetros*/
  IF l-atua-ifrs:CHECKED IN FRAME {&FRAME-NAME} = YES THEN
      ASSIGN substring(param-global.char-2,34,1) = "S".
  ELSE DO:
      FOR FIRST para-fat EXCLUSIVE-LOCK:
          ASSIGN substring(para-fat.char-2,93,1) = "N". /*FT0301 - Campo: Atualiza Entrega Frete FOB para IFRS - Aba Geral*/ 
      END.
        ASSIGN substring(param-global.char-2,34,1) = "N".
  END.
  
  /*CD0101 - Campo: Seguranáa por Estabelecimento - Aba ParÉmetros*/
  ASSIGN OVERLAY(param-global.char-2, 37, 1) = IF l-segur-estab:CHECKED IN FRAME {&frame-name}
                                                  THEN "S"
                                                  ELSE "N".


  
  ASSIGN g-segur-estab = FALSE.
  RUN cdp/cd9150e.p.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
      disable l-valida-cidade with frame {&frame-name}.
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  if avail param-global then do:
     find empresa where empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
     assign c-razao-social = if avail empresa then empresa.razao-social else "".

     find catal_img where catal_img.cod_catal_img = param-global.cod-catal-img-banco no-lock no-error.
     assign c-des-cat-imag-bco = if avail catal_img then catal_img.des_catal_img else "".    
  end.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if   avail param-global then do with frame {&frame-name}:
       assign cb-venc-sab:screen-value   = {adinc/i01ad205.i 04 param-global.ind-venc-sab}
              cb-venc-dom:screen-value   = {adinc/i01ad205.i 04 param-global.ind-venc-dom}
              cb-venc-fer:screen-value   = {adinc/i01ad205.i 04 param-global.ind-venc-fer}.

       &IF DEFINED (bf_dis_consiste_conta) &THEN

           assign rs-cons-conta:screen-value = string(param-global.ind-cons-conta).

       &ENDIF

       &if "{&bf_mat_versao_ems}" >= "2.062" &then
           &IF '{&bf_dis_versao_ems}' >= '2.08' &THEN
                assign l-valid-cred-cli:checked in frame {&frame-name} = param-global.log-cr-clien. 
           &ELSE 
                assign l-valid-cred-cli:checked in frame {&frame-name} = substr(param-global.char-2,32,1) = "S":U.
           &ENDIF
       &ENDIF           
  end.
  else do:
       assign cb-venc-sab:screen-value = {adinc/i01ad205.i 04 1}
              cb-venc-dom:screen-value = {adinc/i01ad205.i 04 1}
              cb-venc-fer:screen-value = {adinc/i01ad205.i 04 1}.

       &IF "{&bf_mat_versao_ems}" >= "2.062" &then
           ASSIGN l-valid-cred-cli:checked in frame {&frame-name} = no.
       &ENDIF 

       &IF DEFINED (bf_dis_consiste_conta) &THEN

           assign rs-cons-conta:screen-value = "1".

       &ENDIF
  end.

  &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
    if avail param-global then
      assign l-valida-cidade:checked in frame {&frame-name} = (param-global.dec-1 = 1).
  &ELSE
    assign l-valida-cidade:visible in frame {&frame-name} = no.
  &ENDIF
  
  /*Valida Restriá‰es Unidade Neg¢cio*/
  &if "{&bf_mat_versao_ems}" >= "2.062" &then
      ASSIGN l-valid-cred-cli:HIDDEN    IN FRAME {&FRAME-NAME} = NO  
             l-valid-cred-cli:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

      if l-unidade-negocio then do:
          &if "{&bf_mat_versao_ems}" <= "2.072" &then
              assign tg-valida-rest-ems5:checked in frame {&frame-name} = if substring(param-global.char-2,31,1) = "2"
                                                                          then yes
                                                                          else no.
          &else
              assign tg-valida-rest-ems5:checked in frame {&frame-name} = if param-global.log-validac-ems5 
                                                                          then yes
                                                                          else no.
          &endif
      end.
  &else
      assign l-valid-cred-cli:HIDDEN       IN FRAME {&FRAME-NAME} = YES  
             l-valid-cred-cli:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
  &endif.
    
  /*CD0101 - Campo: Atualiza IFRS - Aba ParÉmetros*/
  IF SUBSTRING(param-global.char-2,34,1) = "S" THEN
      ASSIGN l-atua-ifrs:CHECKED IN FRAME {&FRAME-NAME} = YES.
  ELSE
      ASSIGN l-atua-ifrs:CHECKED IN FRAME {&FRAME-NAME} = NO.
  
  /*CD0101 - Campo: Seguranáa por Estabelecimento - Aba ParÉmetros*/
  ASSIGN l-segur-estab:CHECKED IN FRAME {&FRAME-NAME} = SUBSTRING(param-global.char-2, 37, 1) = "S".

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
      enable l-valida-cidade with frame {&frame-name}.
  &ENDIF
  
  /*Valida Restriá‰es Unidade Neg¢cio*/
  &if "{&bf_mat_versao_ems}" >= "2.062" &then
  
      ASSIGN l-valid-cred-cli:HIDDEN    IN FRAME {&FRAME-NAME} = NO  
             l-valid-cred-cli:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

      if l-unidade-negocio then do:
          &if "{&bf_mat_versao_ems}" <= "2.072" &then
              assign tg-valida-rest-ems5:checked in frame {&frame-name} = if substring(param-global.char-2,31,1) = "2"
                                                                          then yes
                                                                          else no.
          &else
              assign tg-valida-rest-ems5:checked in frame {&frame-name} = if param-global.log-validac-ems5 
                                                                          then yes
                                                                          else no.
          &endif
      end.

      &IF '{&bf_dis_versao_ems}' >= '2.08' &THEN
           assign l-valid-cred-cli:checked in frame {&frame-name} = param-global.log-cr-clien. 
      &ELSE 
           assign l-valid-cred-cli:checked in frame {&frame-name} = substr(param-global.char-2,32,1) = "S":U.
      &ENDIF
      
  &else
      assign l-valid-cred-cli:HIDDEN       IN FRAME {&FRAME-NAME} = YES  
             l-valid-cred-cli:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.

  &endif.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  do with frame {&frame-name}:
     assign cb-venc-sab:list-items = {adinc/i01ad205.i 03 1}
            cb-venc-dom:list-items = {adinc/i01ad205.i 03 1}
            cb-venc-fer:list-items = {adinc/i01ad205.i 03 1}.    
  end.   
  if   avail param-global then do with frame {&frame-name}:
       assign cb-venc-sab:screen-value = {adinc/i01ad205.i 04 param-global.ind-venc-sab}
              cb-venc-dom:screen-value = {adinc/i01ad205.i 04 param-global.ind-venc-dom}
              cb-venc-fer:screen-value = {adinc/i01ad205.i 04 param-global.ind-venc-fer}.

  end.
  else do:
       assign cb-venc-sab:screen-value = {adinc/i01ad205.i 04 1}
              cb-venc-dom:screen-value = {adinc/i01ad205.i 04 1}
              cb-venc-fer:screen-value = {adinc/i01ad205.i 04 1}.
  end.

  /* Esta tabela Ç utilizada para gravar o c¢digo do £ltimo emitente cadastrado
     e tambÇm grava um campo para definir se altera ou n∆o o nome abreviado do emitente */

  find first tab-ocor use-index descricao where
             tab-ocor.cod-tab   = 098 and
             tab-ocor.descricao = "Inclui Emit" 
             no-lock no-error.
  assign i-ult-emit = if avail tab-ocor then tab-ocor.i-campo[1] 
                      else 0.
  {utp/ut-field.i mgadm emitente cod-emitente 4}  
  assign i-ult-emit:format in frame {&frame-name} = return-value.

  find first b-tab-ocor use-index descricao where 
             b-tab-ocor.cod-tab   = 098 and
             b-tab-ocor.descricao = "Altera Nome Abreviado"
             no-lock no-error.
  assign l-altera-emit = if avail b-tab-ocor then b-tab-ocor.log-1
                         else yes.
  &IF DEFINED (bf_dis_consiste_conta) &then


    assign rs-cons-conta:hidden  in frame {&frame-name} = no
           fi-dados-5:hidden     in frame {&frame-name} = no
           rect-20:hidden        in frame {&frame-name} = no.

    assign rs-cons-conta:radio-buttons in frame {&frame-name} = {diinc/i01di192.i 7}.

  &ELSE

    assign rect-19:width in frame {&frame-name} = 37.72.

  &ENDIF

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ).

  {utp/ut-liter.i Formato_CNPJ *}
  assign param-global.formato-id-federal:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i CNPJ_Obrigat¢rio *}
  assign param-global.id-federal-obrigatorio:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Bloqueio_CNPJ *}
  assign fi-dados-3:screen-value in frame {&frame-name} = return-value.

  {utp/ut-liter.i Formato_CPF}
  assign param-global.formato-id-pessoal:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i S†bado *}
  assign cb-venc-sab:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Domingo *}
  assign cb-venc-dom:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Feriado *}
  assign cb-venc-fer:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Utiliza_SÇrie *}
  assign l-utiliza-serie:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Èltimo_Cliente/Fornecedor *}
  assign i-ult-emit:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Seguranáa_por_Estabelecimento *}
  assign l-segur-estab:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Altera_Nome_Abreviado_Emitente *}
  assign l-altera-emit:label in frame {&frame-name} = trim(return-value).


  {utp/ut-liter.i Valida_Cidade *}
  assign l-valida-cidade:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Avalia_Cliente_Intellector *}
  assign l-valid-cred-cli:label in frame {&frame-name} = trim(return-value).
  /* ATENÄ«O: N∆o tirar o assign abaixo */
  if  avail param-global then do:
      assign c-conta-contab = param-global.formato-conta-contabil
             c-conta        = param-global.ct-format
             c-sub-conta    = param-global.sc-format.
        /*Atualizaá∆o das vari†veis no char-2*/   
        {cdp/cd4300.i4  "yes" param-global.char-2}             
        {cdp/cd0101.i51 "yes"}
        assign l-utiliza-serie:checked in frame {&FRAME-NAME} = l-ut-ser.
  end.

  /*Valida Restriá‰es Unidade Neg¢cio*/
  &if "{&bf_mat_versao_ems}" >= "2.062" &then
      ASSIGN l-valid-cred-cli:HIDDEN    IN FRAME {&FRAME-NAME} = NO  
             l-valid-cred-cli:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

      if l-unidade-negocio then
          assign tg-valida-rest-ems5:hidden in frame {&FRAME-NAME}    = no
                 tg-valida-rest-ems5:sensitive in frame {&FRAME-NAME} = yes.
      else
          assign tg-valida-rest-ems5:hidden in frame {&FRAME-NAME}    = yes
                 tg-valida-rest-ems5:sensitive in frame {&FRAME-NAME} = no.
  &else
      assign tg-valida-rest-ems5:hidden    in frame {&FRAME-NAME} = yes
             tg-valida-rest-ems5:sensitive in frame {&FRAME-NAME} = NO
             l-valid-cred-cli:HIDDEN       IN FRAME {&FRAME-NAME} = YES  
             l-valid-cred-cli:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
  &endif.


  IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
      ASSIGN l-atua-ifrs:HIDDEN IN FRAME {&FRAME-NAME} = YES
             RECT-43:HIDDEN     IN FRAME {&FRAME-NAME} = YES.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formato-conta-integra V-table-Win 
PROCEDURE pi-formato-conta-integra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param l-integra as log  no-undo.

    /* BF_FIN_AUMENTO_DIGITO_CCUSTO -> N∆o mostra os campos ct-format, sc-format e formato-conta-contabil 
       Todas as l¢gicas envolvendo estes campos somente dever∆o ser aplicadas se n∆o houver o BF_FIN_AUMENTO_DIGITO_CCUSTO */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
        if  l-integra then do:
            assign param-global.ct-format:screen-value in frame {&frame-name} = "99999999"
                   param-global.sc-format:screen-value in frame {&frame-name} = "99999".
            disable param-global.ct-format   
                    param-global.sc-format with frame {&frame-name}.
            apply 'leave' to param-global.sc-format in frame {&FRAME-NAME}.
        end.
        else do:
            enable param-global.ct-format   
                   param-global.sc-format with frame {&frame-name}.
            apply 'leave' to param-global.sc-format in frame {&FRAME-NAME}.
        end.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-integra-ems50 V-table-Win 
PROCEDURE pi-integra-ems50 :
/*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
------------------------------------------------------------------------------*/

    do transaction:   

        /*******************************************************************************************
        ** EMS - 5.0 Integraá∆o "On-line" - Datasul-EMS 2.0
        ** Verifica se existe a funá∆o e se est† ativa para validar a CONTA e SUB-CONTA 
        *******************************************************************************************/
        if can-find(funcao where funcao.cd-funcao = "adm-fgl-ems-5.00"
        and funcao.ativo = yes) then do: 

            if search("prgfin/fgl/fgl906za.r") = ? and
               search("prgfin/fgl/fgl906za.py") = ?
            then do:
                run utp/ut-msgs.p (input "show",
                                   input 19138,
                                   input "prgfin/fgl/fgl906za.py").
                return 'adm-error'.
            end.
            else do:
                assign l-conec-uni = no
                       l-conec-bas = no.

                RUN btb/btb009za.p PERSISTENT SET h-btb009za.

                if  not connected("emsbas") 
                or  not connected("emsfin") 
                or  not connected("emsuni") then do: 
                /*    run pi-conecta-bco in h-btb009za (input 1,
                 *                                     input 2, /* 1 - conex∆o, 2 - desconexao */
                 *                                     input i-ep-codigo-usuario,
                 *                                     input "all",
                 *                                     output table tt_erros_conexao).
                 */
                    run pi-conecta-bco in h-btb009za (input 1,
                                                      input 1, /* 1 - conex∆o, 2 - desconexao */
                                                      input i-ep-codigo-usuario,
                                                      input "all",
                                                      output table tt_erros_conexao).

                    if  return-value <> "OK":U then do:
                        run utp/ut0666.w (input table tt_erros_conexao).
                        assign l-bancos-ja-conectados = no.
                        return 'adm-error'.
                    end.
                    else
                        assign l-bancos-ja-conectados = no.
                end.
                else
                    assign l-bancos-ja-conectados = yes.


                /*Verifica se no EMS5 h† o parÉmetro de integraá∆o com as ctas ctbls do EMS2*/
                run prgfin/fgl/fgl906za.py (input  1,
                                            output c-return).

                if  l-bancos-ja-conectados = no then do:
                    run pi-conecta-bco in h-btb009za (input 1,
                                                      input 2, /* 1 - conex∆o, 2 - desconexao */
                                                      input i-ep-codigo-usuario,
                                                      input "all",
                                                      output table tt_erros_conexao).
                    if return-value <> "OK":U then do:
                       run utp/ut0666.w (input table tt_erros_conexao).
                       return "ADM-ERROR":U.
                    end.                                    
                end.

                DELETE PROCEDURE h-btb009za.

                if c-return = "OK" then do:

                    /* BF_FIN_AUMENTO_DIGITO_CCUSTO -> N∆o mostra os campos ct-format, sc-format e formato-conta-contabil 
                    Todas as l¢gicas envolvendo estes campos somente dever∆o ser aplicadas se n∆o houver o BF_FIN_AUMENTO_DIGITO_CCUSTO */
                    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN

                        /*Caso tenha havido alteraá‰es na conta ou na sub-conta ser† emitido msg de erro*/
                        if  input frame {&frame-name} param-global.ct-format <> param-global.ct-format
                        or  input frame {&frame-name} param-global.sc-format <> param-global.sc-format then do:
                            run utp/ut-msgs.p (input "show",
                                               input 19134,
                                               input "").
                            apply "entry" to param-global.ct-format in frame {&frame-name}.
                            return "ADM-ERROR":U.
                        end.

                    &ENDIF

                end.
                else if c-return = "19135" then do:
                    run utp/ut-msgs.p (input "show",
                                       input 19135,
                                       input "").
                    return "ADM-ERROR":U.
                end.
            end.
        end.
        /********************************** FIM VALIDACAO *****************************************/
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-muda-valor V-table-Win 
PROCEDURE pi-muda-valor :
/*------------------------------------------------------------------------------
  Purpose: Esta procedure interna retorna se o toggle-box modulo-bh est† 
  habilitado ou n∆o.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter l-retorna as logical.

assign param-global.tp-estr-banco:sensitive in frame {&FRAME-NAME} = l-retorna.

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
  {src/adm/template/snd-list.i "param-global"}

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


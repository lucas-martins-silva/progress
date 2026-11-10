&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            MSS
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
{include/i-prgvrs.i V37AD107 2.00.00.046 } /*** 010046 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v37ad107 MUT}
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

{cdp/cdcfgdis.i}

&glob bf_mat_cd0602  yes   /* Validacao conta com tratamento empresa na include cd0602.i2 */

{cdp/cdcfgmat.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
def new global shared var gr-estabelec as rowid no-undo.

/* Parameters Definitions ---                                           */

{cdp/cd4300.i3}  /* Definicao de variŸveis para o CD4300.i4  */
{cdp/cd0602.i50} /* Definicao de variŸveis para o CD0602.i51 */


/* Local Variable Definitions ---                                       */
def var l-erro-conta            as logical no-undo.
def var i-trib-pis              as int  no-undo.
def var l-ciap-mri-ativo        as LOG  no-undo.
def var c-cod-estabel           as CHAR no-undo.

def var i-empresa like param-global.empresa-prin no-undo.

DEF BUFFER bf-estabelec FOR estabelec.

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.
DEF VAR h-boin879           AS HANDLE NO-UNDO.

define var c-formato-conta  as char no-undo.
define var c-formato-ccusto as char no-undo. 

def temp-table tt_log_erro no-undo
         field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
         field ttv_des_msg_ajuda as character format "x(40)"  label "Mensagem Ajuda" column-label "Mensagem Ajuda"
         field ttv_des_msg_erro  as character format "x(60)"  label "Mensagem Erro" column-label "Inconsistància".

/* Vari†veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Vari†veis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo.

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
&Scoped-define EXTERNAL-TABLES estabelec
&Scoped-define FIRST-EXTERNAL-TABLE estabelec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estabelec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estabelec.cod-cta-transit-icms-antec ~
estabelec.cod-ccusto-transit-icms-antec 
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define ENABLED-OBJECTS lbl-cod-cta-transit-icms-antecip ~
lbl-ccusto-transit-icms-antec lbl-cod-cta-pis-recup ~
lbl-cod-ccusto-pis-recup lbl-cod-cta-cofins-recup ~
lbl-cod-ccusto-cofins-recup 
&Scoped-Define DISPLAYED-FIELDS estabelec.cod-cta-transit-icms-antec ~
estabelec.cod-ccusto-transit-icms-antec 
&Scoped-define DISPLAYED-TABLES estabelec
&Scoped-define FIRST-DISPLAYED-TABLE estabelec
&Scoped-Define DISPLAYED-OBJECTS c-tit-ct-transit-icms-antec ~
c-tit-sc-transit-icms-antec cod-cta-pis-recup c-tit-ct-pis-recup ~
cod-ccusto-pis-recup c-tit-sc-pis-recup cod-cta-cofins-recup ~
c-tit-ct-cofins-recup cod-ccusto-cofins-recup c-tit-sc-cofins-recup ~
lbl-cod-cta-transit-icms-antecip lbl-ccusto-transit-icms-antec ~
lbl-cod-cta-pis-recup lbl-cod-ccusto-pis-recup lbl-cod-cta-cofins-recup ~
lbl-cod-ccusto-cofins-recup 

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
DEFINE VARIABLE c-tit-ct-cofins-recup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ct-pis-recup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ct-transit-icms-antec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-cofins-recup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-pis-recup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-transit-icms-antec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE cod-ccusto-cofins-recup AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 21.14 BY .88.

DEFINE VARIABLE cod-ccusto-pis-recup AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 21.14 BY .88.

DEFINE VARIABLE cod-cta-cofins-recup AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 21.14 BY .88.

DEFINE VARIABLE cod-cta-pis-recup AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 21.14 BY .88.

DEFINE VARIABLE lbl-ccusto-transit-icms-antec AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20.72 BY .67 NO-UNDO.

DEFINE VARIABLE lbl-cod-ccusto-cofins-recup AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE lbl-cod-ccusto-pis-recup AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20.14 BY .67 NO-UNDO.

DEFINE VARIABLE lbl-cod-cta-cofins-recup AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 18 BY .67 NO-UNDO.

DEFINE VARIABLE lbl-cod-cta-pis-recup AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14.86 BY .67 NO-UNDO.

DEFINE VARIABLE lbl-cod-cta-transit-icms-antecip AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 19.72 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estabelec.cod-cta-transit-icms-antec AT ROW 2.46 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-ct-transit-icms-antec AT ROW 2.46 COL 43.43 COLON-ALIGNED NO-LABEL
     estabelec.cod-ccusto-transit-icms-antec AT ROW 3.46 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     c-tit-sc-transit-icms-antec AT ROW 3.46 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     cod-cta-pis-recup AT ROW 4.79 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     c-tit-ct-pis-recup AT ROW 4.79 COL 43.43 COLON-ALIGNED NO-LABEL
     cod-ccusto-pis-recup AT ROW 5.79 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     c-tit-sc-pis-recup AT ROW 5.79 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     cod-cta-cofins-recup AT ROW 7.08 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     c-tit-ct-cofins-recup AT ROW 7.08 COL 43.43 COLON-ALIGNED NO-LABEL
     cod-ccusto-cofins-recup AT ROW 8.08 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     c-tit-sc-cofins-recup AT ROW 8.08 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     lbl-cod-cta-transit-icms-antecip AT ROW 2.58 COL 23.01 RIGHT-ALIGNED NO-LABEL WIDGET-ID 34
     lbl-ccusto-transit-icms-antec AT ROW 3.58 COL 22.72 RIGHT-ALIGNED NO-LABEL WIDGET-ID 36
     lbl-cod-cta-pis-recup AT ROW 4.92 COL 8.86 NO-LABEL WIDGET-ID 26
     lbl-cod-ccusto-pis-recup AT ROW 5.88 COL 3.86 NO-LABEL WIDGET-ID 28
     lbl-cod-cta-cofins-recup AT ROW 7.21 COL 5.72 NO-LABEL WIDGET-ID 30
     lbl-cod-ccusto-cofins-recup AT ROW 8.17 COL 3.72 NO-LABEL WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgcad.estabelec
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
         WIDTH              = 84.
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

/* SETTINGS FOR FILL-IN c-tit-ct-cofins-recup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-ct-pis-recup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-ct-transit-icms-antec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-sc-cofins-recup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-sc-pis-recup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-sc-transit-icms-antec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-ccusto-cofins-recup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-ccusto-pis-recup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-ccusto-transit-icms-antec IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cod-cta-cofins-recup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-cta-pis-recup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estabelec.cod-cta-transit-icms-antec IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN lbl-ccusto-transit-icms-antec IN FRAME f-main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN lbl-cod-ccusto-cofins-recup IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN lbl-cod-ccusto-pis-recup IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN lbl-cod-cta-cofins-recup IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN lbl-cod-cta-pis-recup IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN lbl-cod-cta-transit-icms-antecip IN FRAME f-main
   ALIGN-R                                                              */
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

&Scoped-define SELF-NAME cod-ccusto-cofins-recup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-ccusto-cofins-recup V-table-Win
ON ENTRY OF cod-ccusto-cofins-recup IN FRAME f-main
DO:
    
  IF adm-new-record AND adm-adding-record THEN  
     ASSIGN SELF:FORMAT = "x(20)". 

  ELSE DO:

      RUN utp/ut-msgs.p (INPUT "SHOW",
                         INPUT 53892, /*Utilizar bot„o 'Contas Impostos Recuperar'*/
                         INPUT "").
      RUN pi-set-color-label(INPUT 12,INPUT 4).
      APPLY "entry" TO estabelec.cod-cta-transit-icms-antec IN FRAME f-main.
      DISABLE cod-cta-pis-recup
        cod-ccusto-pis-recup
        cod-cta-cofins-recup
        cod-ccusto-cofins-recup with frame {&frame-name}.

      RETURN NO-APPLY.

  END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-ccusto-cofins-recup V-table-Win
ON F5 OF cod-ccusto-cofins-recup IN FRAME f-main
DO:
   IF adm-new-record AND adm-adding-record THEN DO:  
    
       run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                           input "",                  /* CODIGO DO PLANO CCUSTO */
                                           input "",                  /* UNIDADE DE NEGOCIO */
                                           input today,               /* DATA DE TRANSACAO */
                                           output v_cod_ccusto,       /* CODIGO CCUSTO */
                                           output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                           output table tt_log_erro). /* ERROS */ 
       
       IF v_titulo_ccusto <> "" THEN DO:
           ASSIGN cod-ccusto-cofins-recup:SCREEN-VALUE = v_cod_ccusto.
           ASSIGN c-tit-sc-cofins-recup:SCREEN-VALUE = v_titulo_ccusto.
       END.   
       
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-ccusto-cofins-recup V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cod-ccusto-cofins-recup IN FRAME f-main
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-ccusto-pis-recup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-ccusto-pis-recup V-table-Win
ON ENTRY OF cod-ccusto-pis-recup IN FRAME f-main
DO:
    
  IF adm-new-record AND adm-adding-record THEN
    ASSIGN SELF:FORMAT = "x(20)".

  ELSE DO:  
      
     RUN utp/ut-msgs.p (INPUT "SHOW",
                        INPUT 53892, /*Utilizar bot∆o 'Contas Impostos Recuperar'*/
                        INPUT "").
     RUN pi-set-color-label(INPUT 12,INPUT 2).
     APPLY "entry" TO estabelec.cod-cta-transit-icms-antec IN FRAME f-main.
     DISABLE cod-cta-pis-recup
        cod-ccusto-pis-recup
        cod-cta-cofins-recup
        cod-ccusto-cofins-recup with frame {&frame-name}.

     RETURN NO-APPLY.

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-ccusto-pis-recup V-table-Win
ON F5 OF cod-ccusto-pis-recup IN FRAME f-main
DO:
  IF adm-new-record AND adm-adding-record THEN DO: 
      run pi_zoom_ccusto in h_api_ccusto(input i-empresa,           /* EMPRESA EMS2 */
                                         input "",                  /* CODIGO DO PLANO CCUSTO */
                                         input "",                  /* UNIDADE DE NEGOCIO */
                                         input today,               /* DATA DE TRANSACAO */
                                         output v_cod_ccusto,       /* CODIGO CCUSTO */
                                         output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                         output table tt_log_erro). /* ERROS */ 
   
      IF v_titulo_ccusto <> "" THEN
        ASSIGN cod-ccusto-pis-recup:SCREEN-VALUE = v_cod_ccusto
               c-tit-sc-pis-recup:SCREEN-VALUE = v_titulo_ccusto.
         
      
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-ccusto-pis-recup V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cod-ccusto-pis-recup IN FRAME f-main
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-ccusto-transit-icms-antec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-transit-icms-antec V-table-Win
ON ENTRY OF estabelec.cod-ccusto-transit-icms-antec IN FRAME f-main /* Centro de custo Tran */
DO:
   ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-transit-icms-antec V-table-Win
ON F5 OF estabelec.cod-ccusto-transit-icms-antec IN FRAME f-main /* Centro de custo Tran */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
   
   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN estabelec.cod-ccusto-transit-icms-antec:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-tit-sc-transit-icms-antec:SCREEN-VALUE = v_titulo_ccusto.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-transit-icms-antec V-table-Win
ON LEAVE OF estabelec.cod-ccusto-transit-icms-antec IN FRAME f-main /* Centro de custo Tran */
DO:
    /*{cdp/cd9998.i}*/
    {cdp/cd0602.i4 estabelec.cod-ccusto-transit-icms-antec c-tit-sc-transit-icms-antec}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-ccusto-transit-icms-antec V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-ccusto-transit-icms-antec IN FRAME f-main /* Centro de custo Tran */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-cta-cofins-recup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-cta-cofins-recup V-table-Win
ON ENTRY OF cod-cta-cofins-recup IN FRAME f-main
DO:
    
  IF adm-new-record AND adm-adding-record THEN 
     ASSIGN SELF:FORMAT = "x(20)".

  ELSE DO:     
    
     RUN utp/ut-msgs.p (INPUT "SHOW",
                        INPUT 53892, /*Utilizar bot∆o 'Contas Impostos Recuperar'*/
                        INPUT "").
     RUN pi-set-color-label(INPUT 12,INPUT 3).
     APPLY "entry" TO estabelec.cod-cta-transit-icms-antec IN FRAME f-main.
     DISABLE cod-cta-pis-recup
        cod-ccusto-pis-recup
        cod-cta-cofins-recup
        cod-ccusto-cofins-recup with frame {&frame-name}.

     RETURN NO-APPLY.

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME cod-cta-cofins-recup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-cta-cofins-recup V-table-Win
ON LEAVE OF cod-cta-cofins-recup IN FRAME f-main
DO:
 
    ASSIGN cod-cta-cofins-recup:format in frame {&frame-name} = "x(20)":u.
    ASSIGN cod-cta-cofins-recup = cod-cta-cofins-recup:SCREEN-VALUE IN FRAME f-main.

    {cdp/cd0602.i3 cod-cta-cofins-recup c-tit-ct-cofins-recup
                   cod-ccusto-cofins-recup c-tit-sc-cofins-recup TRUE}
           
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-ccusto-cofins-recup V-table-Win
ON LEAVE OF cod-ccusto-cofins-recup IN FRAME f-main 
DO:
    ASSIGN cod-ccusto-cofins-recup:format in frame {&frame-name} = "x(20)":u.
    ASSIGN cod-ccusto-cofins-recup = cod-ccusto-cofins-recup:SCREEN-VALUE IN FRAME f-main.
    {cdp/cd0602.i4 cod-ccusto-cofins-recup c-tit-sc-cofins-recup}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-cta-cofins-recup V-table-Win
ON F5 OF cod-cta-cofins-recup IN FRAME f-main
DO:
         
   IF adm-new-record AND adm-adding-record THEN DO:   
     run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,           /* EMPRESA EMS2 */
                                                      input  "CEP",               /* M‡DULO */
                                                      input  "",                  /* PLANO DE CONTAS */
                                                      input  "(nenhum)",          /* FINALIDADES */
                                                      input  today,               /* DATA TRANSACAO */
                                                      output v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                      output v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                      output v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                      output table tt_log_erro).  /* ERROS */ 
     
     IF v_titulo_cta_ctbl <> "" THEN
           ASSIGN cod-cta-cofins-recup:SCREEN-VALUE = v_cod_cta_ctbl
                  c-tit-ct-cofins-recup:SCREEN-VALUE = v_titulo_cta_ctbl.
      

   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-cta-cofins-recup V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cod-cta-cofins-recup IN FRAME f-main
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-cta-pis-recup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-cta-pis-recup V-table-Win
ON ENTRY OF cod-cta-pis-recup IN FRAME f-main
DO:
    
  IF adm-new-record AND adm-adding-record THEN 
     ASSIGN SELF:FORMAT = "x(20)".

  ELSE DO:    
    
      RUN utp/ut-msgs.p (INPUT "SHOW",
                         INPUT 53892, /*Utilizar bot„o 'Contas Impostos Recuperar'*/
                         INPUT "").
      RUN pi-set-color-label(INPUT 12,INPUT 1).
      APPLY "entry" TO estabelec.cod-cta-transit-icms-antec IN FRAME f-main.
      DISABLE cod-cta-pis-recup
        cod-ccusto-pis-recup
        cod-cta-cofins-recup
        cod-ccusto-cofins-recup with frame {&frame-name}.

      RETURN NO-APPLY.

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-cta-pis-recup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-cta-pis-recup V-table-Win
ON LEAVE OF cod-cta-pis-recup IN FRAME f-main
DO:
 
    ASSIGN cod-cta-pis-recup:format in frame {&frame-name} = "x(20)":u.
    ASSIGN cod-cta-pis-recup = cod-cta-pis-recup:SCREEN-VALUE IN FRAME f-main.

    {cdp/cd0602.i3 cod-cta-pis-recup c-tit-ct-pis-recup
                   cod-ccusto-pis-recup c-tit-sc-pis-recup TRUE}
           
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-ccusto-pis-recup V-table-Win
ON LEAVE OF cod-ccusto-pis-recup IN FRAME f-main 
DO:
    ASSIGN cod-ccusto-pis-recup:format in frame {&frame-name} = "x(20)":u.
    ASSIGN cod-ccusto-pis-recup = cod-ccusto-pis-recup:SCREEN-VALUE IN FRAME f-main.
    {cdp/cd0602.i4 cod-ccusto-pis-recup c-tit-sc-pis-recup}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-cta-pis-recup V-table-Win
ON F5 OF cod-cta-pis-recup IN FRAME f-main
DO:
  IF adm-new-record AND adm-adding-record THEN DO:

        run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,           /* EMPRESA EMS2 */
                                                       input  "CEP",               /* M‡DULO */
                                                       input  "",                  /* PLANO DE CONTAS */
                                                       input  "(nenhum)",          /* FINALIDADES */
                                                       input  today,               /* DATA TRANSACAO */
                                                       output v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                       output v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                       output v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                       output table tt_log_erro).  /* ERROS */ 
    
       IF v_titulo_cta_ctbl <> "" THEN 
           ASSIGN cod-cta-pis-recup:SCREEN-VALUE = v_cod_cta_ctbl
                  c-tit-ct-pis-recup:SCREEN-VALUE = v_titulo_cta_ctbl.
      
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-cta-pis-recup V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cod-cta-pis-recup IN FRAME f-main
DO:
   APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-cta-transit-icms-antec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-transit-icms-antec V-table-Win
ON ENTRY OF estabelec.cod-cta-transit-icms-antec IN FRAME f-main /* Conta Transitoria Ic */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE estabelec.cod-ccusto-transit-icms-antec WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-transit-icms-antec V-table-Win
ON F5 OF estabelec.cod-cta-transit-icms-antec IN FRAME f-main /* Conta Transitoria Ic */
DO:
   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,           /* EMPRESA EMS2 */
                                                  input  "CEP",               /* M‡DULO */
                                                  input  "",                  /* PLANO DE CONTAS */
                                                  input  "(nenhum)",          /* FINALIDADES */
                                                  input  today,               /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro).  /* ERROS */ 

   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN estabelec.cod-cta-transit-icms-antec:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-tit-ct-transit-icms-antec:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-transit-icms-antec V-table-Win
ON LEAVE OF estabelec.cod-cta-transit-icms-antec IN FRAME f-main /* Conta Transitoria Ic */
DO:

    /* Include que faz o leave do campo usando a API de financas */
    {cdp/cd0602.i3 estabelec.cod-cta-transit-icms-antec c-tit-ct-transit-icms-antec
                   estabelec.cod-ccusto-transit-icms-antec c-tit-sc-transit-icms-antec TRUE}    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-cta-transit-icms-antec V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.cod-cta-transit-icms-antec IN FRAME f-main /* Conta Transitoria Ic */
DO:
   apply "F5" to self.
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

  if estabelec.cod-ccusto-transit-icms-antec:load-mouse-pointer("image~\lupa.cur") then .   
  if estabelec.cod-ccusto-transit-icms-antec:load-mouse-pointer("image~\lupa.cur") then .
  if cod-ccusto-pis-recup:load-mouse-pointer("image~\lupa.cur") then .
  if cod-ccusto-cofins-recup:load-mouse-pointer("image~\lupa.cur") then .  

  FIND FIRST param-global NO-LOCK NO-ERROR.
  IF  NOT AVAIL param-global THEN DO:
      BELL.
      RUN utp/ut-msgs.p (input "show", input 16, input "").
      RETURN 'adm-error'.
  END.

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
  {src/adm/template/row-list.i "estabelec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estabelec"}

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  RUN pi-set-color-label(9,0).
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
  /* Ponha na pi-validate todas as validaÓÔes */
  /* N“o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */

  IF i-pais-impto-usuario = 1 THEN DO:

    /* Todos os assignµs n“o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).

    IF  adm-new-record 
    AND (   cod-cta-pis-recup <> ""
         OR cod-cta-cofins-recup <> "") THEN DO:
          IF NOT CAN-FIND (FIRST estab-ctas-impto 
                           WHERE estab-ctas-impto.cod-estab = estabelec.cod-estabel
                           AND   estab-ctas-impto.num-impto = 03) THEN DO:
          
                 create estab-ctas-impto.
                 assign estab-ctas-impto.cod-estab = estabelec.cod-estabel
                        estab-ctas-impto.num-impto = 03
                        estab-ctas-impto.dat-inic-valid = 01/01/1800
                        estab-ctas-impto.dat-fim-valid = 12/30/9999
                        estab-ctas-impto.conta-imposto = cod-cta-pis-recup
                        estab-ctas-impto.cod-ccusto-impto = cod-ccusto-pis-recup.
          END.          
          IF NOT CAN-FIND (FIRST estab-ctas-impto 
                           WHERE estab-ctas-impto.cod-estab = estabelec.cod-estabel
                           AND   estab-ctas-impto.num-impto = 04) THEN DO:
             create estab-ctas-impto.
             assign estab-ctas-impto.cod-estab = estabelec.cod-estabel
                    estab-ctas-impto.num-impto = 04
                    estab-ctas-impto.dat-inic-valid = 01/01/1800
                    estab-ctas-impto.dat-fim-valid = 12/30/9999
                    estab-ctas-impto.conta-imposto = cod-cta-cofins-recup
                    estab-ctas-impto.cod-ccusto-impto = cod-ccusto-cofins-recup.

          END.
      END.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) . 

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Elimina handle's */
  if valid-handle(h_api_cta_ctbl) then
    delete object h_api_cta_ctbl.
  if valid-handle(h_api_ccusto) then
    delete object h_api_ccusto.    
  IF VALID-HANDLE(h-boin879) THEN
    DELETE OBJECT h-boin879.
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
  
  disable cod-cta-pis-recup
          cod-ccusto-pis-recup
          cod-cta-cofins-recup
          cod-ccusto-cofins-recup with frame {&frame-name}.
  
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
    RUN pi-desformata-campos.
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    if avail estabelec then do:
        assign i-empresa = estabelec.ep-codigo.
        assign c-cod-estabel = estabelec.cod-estabel.
    end.
    else do:
        /*******Busca empresa informada na viewer v17ad107.w (Folder Fiscal)********/
        run Get-Field-Screen-Value in adm-broker-hdl
         (input this-procedure, input "ep-codigo":U).
        ASSIGN i-empresa = RETURN-VALUE.

        run Get-Field-Screen-Value in adm-broker-hdl
         (input this-procedure, input "cod-estabel":U).                                                         
        assign c-cod-estabel = RETURN-VALUE.
    end.

    /* Retorna formato da conta contabil */
    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  TODAY,              /* DATA DE TRANSACAO */
                                                       output c-formato-conta,    /* FORMATO CONTA */
                                                       output table tt_log_erro). /* ERROS */
    /* Retorna formato do centro de custo */
    run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* PLANO CCUSTO */
                                                   input  TODAY,              /* DATA DE TRANSACAO */
                                                   output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */       
    
    
    IF estabelec.log-livre-1 = YES  AND NOT adm-new-record THEN DO:
        
        IF NOT VALID-HANDLE(h-boin879) THEN
           RUN inbo/boin879.p PERSISTENT SET h-boin879.
        RUN openQueryStatic IN h-boin879 (INPUT "Main":U).
    
        RUN goToKeyCustom IN h-boin879 ( INPUT estabelec.cod-estabel,
                                         INPUT 03,
                                         INPUT TODAY ).
        IF RETURN-VALUE = "OK":U THEN DO:            
            RUN getCharField IN h-boin879 ( INPUT "conta-imposto":U,
                                            OUTPUT cod-cta-pis-recup ).
            RUN getCharField IN h-boin879 ( INPUT "cod-ccusto-impto":U,
                                            OUTPUT cod-ccusto-pis-recup ).
        END.
  
        RUN goToKeyCustom IN h-boin879 ( INPUT estabelec.cod-estabel,
                                         INPUT 04,
                                         INPUT TODAY ).
        IF RETURN-VALUE = "OK":U THEN DO:   
            RUN getCharField IN h-boin879 ( INPUT "conta-imposto":U,
                                            OUTPUT cod-cta-cofins-recup ).
            RUN getCharField IN h-boin879 ( INPUT "cod-ccusto-impto":U,
                                            OUTPUT cod-ccusto-cofins-recup ).
        END.
    
    END.
    
    display cod-cta-pis-recup
            cod-ccusto-pis-recup
            cod-cta-cofins-recup
            cod-ccusto-cofins-recup with frame {&frame-name}.

                                                   
    /* Busca as descriªÑes */
    {cdp/cd0602.i3 estabelec.cod-cta-transit-icms-antec c-tit-ct-transit-icms-antec
                   estabelec.cod-ccusto-transit-icms-antec c-tit-sc-transit-icms-antec FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
        {cdp/cd0602.i4 estabelec.cod-ccusto-transit-icms-antec c-tit-sc-transit-icms-antec}
    end.
                   
    {cdp/cd0602.i3 cod-cta-pis-recup c-tit-ct-pis-recup
                   cod-ccusto-pis-recup c-tit-sc-pis-recup FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
        {cdp/cd0602.i4 cod-ccusto-pis-recup c-tit-sc-pis-recup}
    end.
                   
    {cdp/cd0602.i3 cod-cta-cofins-recup c-tit-ct-cofins-recup
                   cod-ccusto-cofins-recup c-tit-sc-cofins-recup FALSE}
    if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
        {cdp/cd0602.i4 cod-ccusto-cofins-recup c-tit-sc-cofins-recup}
    end.
    
    run pi-formata-campos.
    RUN pi-set-color-label(INPUT 9,INPUT 0).
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
       
  IF adm-new-record AND adm-adding-record THEN 
    run pi-desformata-campos.

  enable cod-cta-pis-recup
          cod-ccusto-pis-recup
          cod-cta-cofins-recup
          cod-ccusto-cofins-recup with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    if avail estabelec then do:
        assign i-empresa = estabelec.ep-codigo.
        assign c-cod-estabel = estabelec.cod-estabel.
    end.
    else do:
        /*******Busca empresa informada na viewer v17ad107.w (Folder Fiscal)********/
        run Get-Field-Screen-Value in adm-broker-hdl
         (input this-procedure, input "ep-codigo":U).
        ASSIGN i-empresa = RETURN-VALUE.

        run Get-Field-Screen-Value in adm-broker-hdl
         (input this-procedure, input "cod-estabel":U).                                                         
        assign c-cod-estabel = RETURN-VALUE.
    end.

    /* Handle da API Conta Cont†bil */
    run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
    /* Handle da API Centro Custo */
    run prgint\utb\utb742za.py persistent set h_api_ccusto.  

    
  /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  RUN pi-set-color-label(INPUT 9, INPUT 0).


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view V-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

    if avail estabelec then do:
        assign i-empresa = estabelec.ep-codigo.
        assign c-cod-estabel = estabelec.cod-estabel.
    end.
    else do:
        /*******Busca empresa informada na viewer v17ad107.w (Folder Fiscal)********/
        run Get-Field-Screen-Value in adm-broker-hdl
         (input this-procedure, input "ep-codigo":U).
        ASSIGN i-empresa = RETURN-VALUE.

        run Get-Field-Screen-Value in adm-broker-hdl
         (input this-procedure, input "cod-estabel":U).                                                         
        assign c-cod-estabel = RETURN-VALUE.
    end.

    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desformata-campos V-table-Win 
PROCEDURE pi-desformata-campos :
ASSIGN estabelec.cod-cta-transit-icms-antec    :format in frame {&frame-name} = "x(20)":u
       estabelec.cod-ccusto-transit-icms-antec :format in frame {&frame-name} = "x(20)":u
       cod-cta-pis-recup             :format in frame {&frame-name} = "x(20)":u
       cod-ccusto-pis-recup          :format in frame {&frame-name} = "x(20)":u
       cod-cta-cofins-recup          :format in frame {&frame-name} = "x(20)":u
       cod-ccusto-cofins-recup       :format in frame {&frame-name} = "x(20)":u.
             
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campos V-table-Win 
PROCEDURE pi-formata-campos :
run pi-desformata-campos.
    
  /* Formatando conta e centro de custo, somente se n∆o for "" os campos s∆o formatados */
  if c-formato-conta <> "" then do:
      if estabelec.cod-cta-transit-icms-antec:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-cta-transit-icms-antec:format in frame {&FRAME-NAME} = c-formato-conta.
        
      if cod-cta-pis-recup:screen-value in frame {&frame-name} <> "" then
        assign cod-cta-pis-recup:format          in frame {&FRAME-NAME} = c-formato-conta.
      
      if cod-cta-cofins-recup:screen-value in frame {&frame-name} <> "" then
        assign cod-cta-cofins-recup:format       in frame {&FRAME-NAME} = c-formato-conta.   
  end.
  if c-formato-ccusto <> "" then do:
      if estabelec.cod-ccusto-transit-icms-antec:screen-value in frame {&frame-name} <> "" then
        assign estabelec.cod-ccusto-transit-icms-antec:format in frame {&FRAME-NAME} = c-formato-ccusto.
        
      if cod-ccusto-pis-recup:screen-value in frame {&frame-name} <> "" then
        assign cod-ccusto-pis-recup:format          in frame {&FRAME-NAME} = c-formato-ccusto.
      
      if cod-ccusto-cofins-recup:screen-value in frame {&frame-name} <> "" then
        assign cod-ccusto-cofins-recup:format       in frame {&FRAME-NAME} = c-formato-ccusto.       
  end.           
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-set-color-label V-table-Win 
PROCEDURE pi-set-color-label :
/*------------------------------------------------------------------------------
  Purpose: Alterar cor dos labels de contas e centro de custo a recuperar.
           Campos com a cor alterada devem ser atualizados clicando no bot„o 
           bt-contas
  Parameters:  pi-color: 9-azul 12-Vermelho
               pi-type: Campo que deve ser alterado.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM pi-color AS INTEGER NO-UNDO.
DEFINE INPUT PARAM pi-type  AS INTEGER NO-UNDO.

  {utp/ut-liter.i Conta_Transit_ICMS_Antecip: *}
  assign lbl-cod-cta-transit-icms-antecip:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i C_Custo_Transit_ICMS_Antecip: *}
  assign lbl-ccusto-transit-icms-antec:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i Conta_PIS_Recuperar: *}
  assign lbl-cod-cta-pis-recup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.
  
  {utp/ut-liter.i Centro_Custo_PIS_Recuperar: *}
  assign lbl-cod-ccusto-pis-recup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i Conta_COFINS_Recuperar: *}
  assign lbl-cod-cta-cofins-recup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.
  
  {utp/ut-liter.i Centro_Custo_COFINS_Recup: *}
  assign lbl-cod-ccusto-cofins-recup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.


    CASE pi-type:
        WHEN 0 THEN DO:
          ASSIGN lbl-cod-cta-transit-icms-antecip:FGCOLOR IN FRAME f-main = pi-color /*9*/ 
                 lbl-ccusto-transit-icms-antec:FGCOLOR IN FRAME f-main = pi-color /*9*/
                 lbl-cod-cta-pis-recup:FGCOLOR IN FRAME f-main = pi-color /*9*/ 
                 lbl-cod-ccusto-pis-recup:FGCOLOR IN FRAME f-main = pi-color /*9*/
                 lbl-cod-cta-cofins-recup:FGCOLOR IN FRAME f-main = pi-color /*9*/
                 lbl-cod-ccusto-cofins-recup:FGCOLOR IN FRAME f-main = pi-color. /*9*/
        END.
        WHEN 1 THEN DO:
          ASSIGN lbl-cod-cta-pis-recup:FGCOLOR IN FRAME f-main = pi-color. /*12*/
        END.
        WHEN 2 THEN DO:
          ASSIGN lbl-cod-ccusto-pis-recup:FGCOLOR IN FRAME f-main = pi-color /*12*/.
        END.
        WHEN 3 THEN DO:
          ASSIGN lbl-cod-cta-cofins-recup:FGCOLOR IN FRAME f-main = pi-color /*12*/.
        END.
        WHEN 4 THEN DO:
          ASSIGN lbl-cod-ccusto-cofins-recup:FGCOLOR IN FRAME f-main = pi-color /*12*/.
        END.
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-campo V-table-Win 
PROCEDURE pi-seta-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                                 INPUT 'cod-estabel').
   ASSIGN c-cod-estabel = RETURN-VALUE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N“o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaÓÔes, pois neste ponto do programa o registro 
  ainda n“o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* ValidaÓ“o de dicionŸrio */

    assign l-erro-conta = no.

    find first param-global no-lock no-error.

    IF i-pais-impto-usuario = 1 THEN DO:

        if avail estabelec then do:
            assign i-empresa = estabelec.ep-codigo.
            assign c-cod-estabel = estabelec.cod-estabel.
        end.
        else do:
            /*******Busca empresa informada na viewer v17ad107.w (Folder Fiscal)********/
            run Get-Field-Screen-Value in adm-broker-hdl
             (input this-procedure, input "ep-codigo":U).
            ASSIGN i-empresa = RETURN-VALUE.
    
            run Get-Field-Screen-Value in adm-broker-hdl
             (input this-procedure, input "cod-estabel":U).                                                         
            assign c-cod-estabel = RETURN-VALUE.
        end.

        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-msg-conta AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Favor informar corretamente a conta!" *}
        ASSIGN c-msg-conta = TRIM(RETURN-VALUE).
            
        /* Validando contas e centro de custo */
        {cdp/cd0602.i estabelec.cod-cta-transit-icms-antec}
        if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
            {cdp/cd0602.i0 estabelec.cod-ccusto-transit-icms-antec}
        end.

        IF adm-new-record THEN DO:
            {cdp/cd0602.i cod-cta-pis-recup}
            if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
                {cdp/cd0602.i0 cod-ccusto-pis-recup}
            end.    

            {cdp/cd0602.i cod-cta-cofins-recup}
            if v_log_utz_ccusto then do: /* Conta utiliza centro de custo? */
                {cdp/cd0602.i0 cod-ccusto-cofins-recup} 
            end.
        END.
              

    END.

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
  {src/adm/template/snd-list.i "estabelec"}

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


&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V32AD098 2.00.00.060 } /*** "010060" 15/09/2025 08:42:59 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v32ad098 MUT}
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

/* Global Variable Definitions */
define new global shared variable v-row-parent as rowid no-undo.                                

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable c-label-1     as character no-undo.
define variable c-label-2     as character no-undo.
define variable i-ind-cre-cli as integer   no-undo.
define variable c-handle      as character no-undo.
define variable c-nome-matriz as character no-undo.
define variable i-ind-cre-ant as integer   no-undo.
define variable c-obs         as char      no-undo.
define variable l-chama-mp-dist-emitente  AS LOG no-undo.

DEFINE BUFFER b-emitente FOR emitente.

/* ===== Integra‡Æo Multiplanta ===== */
{cdp/cd7300.i1}
{pdp/pdapi206.i}
/* ================================== */

def temp-table tt-dados-env-EMI   like tt-dados-env.
def temp-table tt-replica-msg-EMI like tt-replica-msg.
def temp-table tt-control-env-EMI like tt-control-env.
def temp-table tt-integracao-EMI  like tt-integracao.
{cdp/cdcfgdis.i} /* Include para Pre-processadores */

&IF "{&BF_DIS_VERSAO_EMS}" >= "2.02" &THEN
    {cdp/cdapi274.i}  /* Definicao das Temp-Tables */
&ENDIF

/*************EAI***********************/
&IF '{&bf_dis_versao_ems}' >= "2.04":U &THEN 
  
 {method/dbotterr.i} /* RowErrors */
 define temp-table tt_log_erro no-undo
     field ttv_num_cod_erro  as integer   initial ?
     field ttv_des_msg_ajuda as character initial ?
     field ttv_des_msg_erro  as character initial ?.

 def new global shared var v_log_eai_habilit as logical no-undo. 
 def var h-eai-emit               as handle  no-undo.
 def var hShowMsg                 as handle  no-undo.

&ENDIF
/*************Fim*************************/

DEF STREAM s-teste.

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
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS emitente.ind-cre-cli emitente.ind-aval ~
emitente.ind-aval-embarque emitente.lim-credito emitente.moeda-libcre ~
emitente.dt-lim-cred emitente.lim-adicional emitente.dt-fim-cred ~
emitente.nr-peratr emitente.cdn-atraso-max emitente.nr-mesina emitente.nr-cheque-devol ~
emitente.vl-max-devol emitente.periodo-devol emitente.ind-abrange-aval ~
emitente.ind-lib-estoque 
&Scoped-define ENABLED-TABLES emitente
&Scoped-define FIRST-ENABLED-TABLE emitente
&Scoped-Define ENABLED-OBJECTS RECT-16 RECT-28 RECT-29 rt-key rt-mold ~
rt-mold-2 rt-mold-3 rt-mold-4 
&Scoped-Define DISPLAYED-FIELDS emitente.nome-abrev emitente.nome-emit ~
emitente.ind-cre-cli emitente.ind-aval emitente.ind-aval-embarque ~
emitente.lim-credito emitente.moeda-libcre emitente.dt-lim-cred ~
emitente.lim-adicional emitente.dt-fim-cred emitente.user-libcre ~
emitente.nr-peratr emitente.cdn-atraso-max emitente.nr-mesina emitente.nr-cheque-devol ~
emitente.vl-max-devol emitente.periodo-devol emitente.ind-abrange-aval ~
emitente.ind-lib-estoque 
&Scoped-define DISPLAYED-TABLES emitente
&Scoped-define FIRST-DISPLAYED-TABLE emitente
&Scoped-Define DISPLAYED-OBJECTS tg-aval-multi-emp d-moeda ~
tg-considera-ap-lim-cred de-perc-max-dup-venc i-num-dias-max-dup-venc l-desconsidera-antecip-na-dup-venc tg-desconsidera-ad-dupli-venc

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS emitente.user-libcre 
&Scoped-define ADM-MODIFY-FIELDS tg-aval-multi-emp tg-considera-ap-lim-cred de-perc-max-dup-venc i-num-dias-max-dup-venc l-desconsidera-antecip-na-dup-venc tg-desconsidera-ad-dupli-venc

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-abrange-aval AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12.86 BY .63 NO-UNDO.

DEFINE VARIABLE c-desc-ind-aval AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11.14 BY .63 NO-UNDO.

DEFINE VARIABLE c-desc-ind-aval-emb AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12.72 BY .63 NO-UNDO.

DEFINE VARIABLE c-desc-ind-cre AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12.43 BY .63 NO-UNDO.

DEFINE VARIABLE d-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 31.43 BY 1.92.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58 BY 5.5.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25.72 BY 1.92.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.71.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58 BY 5.25.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 31.29 BY 4.88.

DEFINE RECTANGLE rt-mold-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 31.29 BY 3.58.

DEFINE RECTANGLE rt-mold-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 31.29 BY 4.25.

DEFINE VARIABLE tg-aval-multi-emp AS LOGICAL INITIAL no 
     LABEL "Avalia‡Æo Multi-empresa" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 TOOLTIP "Avalia‡Æo Cr‚dito M£ltiplas Empresas".

DEFINE VARIABLE tg-considera-ap-lim-cred AS LOGICAL INITIAL no 
     LABEL "Considerar AP Limite Cr‚dito" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83.
	 
DEFINE VARIABLE de-perc-max-dup-venc AS decimal FORMAT ">>9.99":U 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88.	 

DEFINE VARIABLE i-num-dias-max-dup-venc AS integer FORMAT ">>9":U 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88.

DEFINE VARIABLE l-desconsidera-antecip-na-dup-venc AS LOGICAL INITIAL no 
     LABEL "Desconsidera Antecipa‡Æo nas Dup Venc" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83.

DEFINE VARIABLE tg-desconsidera-ad-dupli-venc AS LOGICAL INITIAL no 
     LABEL "Desconsidera AD Venc" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83.
	 
/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tg-aval-multi-emp AT ROW 15.25 COL 66 HELP
          "Avalia‡Æo Cr‚dito M£ltiplas Empresas"
     emitente.nome-abrev AT ROW 1.38 COL 23.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     emitente.nome-emit AT ROW 1.38 COL 40.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     emitente.ind-cre-cli AT ROW 3.42 COL 7.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
          "Normal", 1,
          "Autom tico", 2,
          "S¢ Imp Ped", 3,
          "Suspenso", 4,
          "Pg … Vista", 5
          SIZE 16.43 BY 3.79
     emitente.ind-aval AT ROW 8.71 COL 7.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "NÆo Avalia", 1,
"Somente Atrasos Duplicatas", 2,
"Limites e Atrasos Duplicatas", 3
          SIZE 23.29 BY 2.58
     emitente.ind-aval-embarque AT ROW 12.79 COL 7.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "NÆo Avalia", 1,
"Somente Atrasos Duplicatas", 2,
"Limites e Atrasos Duplicatas", 3
          SIZE 22.57 BY 2.42
     emitente.lim-credito AT ROW 3.33 COL 46 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     emitente.moeda-libcre AT ROW 3.33 COL 73.57 COLON-ALIGNED
          LABEL "Mo Lim Cr‚d":R11
          VIEW-AS FILL-IN 
          SIZE 3.29 BY .88
     emitente.dt-lim-cred AT ROW 4.33 COL 46 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     d-moeda AT ROW 3.33 COL 77 COLON-ALIGNED NO-LABEL
     emitente.lim-adicional AT ROW 5.33 COL 46 COLON-ALIGNED
          LABEL "Lim Cr‚d Adic":R22
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     emitente.dt-fim-cred AT ROW 6.33 COL 46 COLON-ALIGNED
          LABEL "Fim Lim Cr‚d Adic":R21
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
	 de-perc-max-dup-venc at row 6.33 col 82.57 colon-aligned	  
     tg-considera-ap-lim-cred AT ROW 7.25 COL 35    
     emitente.user-libcre AT ROW 4.33 COL 72 COLON-ALIGNED
          LABEL "Usu rio Ult Alt":R20
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     emitente.nr-peratr AT ROW 9.04 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     emitente.nr-cheque-devol AT ROW 9.04 COL 69.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     emitente.cdn-atraso-max AT ROW 10.04 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .88
     emitente.vl-max-devol AT ROW 10.04 COL 69.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     emitente.nr-mesina AT ROW 11.04 COL 47 COLON-ALIGNED
          LABEL "Meses Inativos":R23
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88 
     emitente.periodo-devol AT ROW 11.04 COL 69.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
	 i-num-dias-max-dup-venc at row 12.04 col 69.86 colon-aligned
     l-desconsidera-antecip-na-dup-venc AT ROW 13.04 COL 35
     tg-desconsidera-ad-dupli-venc AT ROW 13.04 COL 72
     emitente.ind-abrange-aval AT ROW 15.08 COL 34 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Cliente", 1,
"Matriz", 2
          SIZE 27.43 BY .75
     emitente.ind-lib-estoque AT ROW 14.5 COL 66
          VIEW-AS TOGGLE-BOX
          SIZE 24.14 BY .71
     c-desc-ind-cre AT ROW 2.79 COL 1.86 NO-LABEL
     c-desc-ind-aval AT ROW 7.83 COL 1.43 NO-LABEL
     c-desc-ind-aval-emb AT ROW 11.79 COL 2.14 NO-LABEL
     c-desc-abrange-aval AT ROW 13.96 COL 34 NO-LABEL
     RECT-16 AT ROW 14.25 COL 33
     RECT-28 AT ROW 8.42 COL 33
     RECT-29 AT ROW 14.25 COL 65.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3 COL 33
     rt-mold-2 AT ROW 2.96 COL 1
     rt-mold-3 AT ROW 8.17 COL 1
     rt-mold-4 AT ROW 11.96 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.emitente
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
         HEIGHT             = 15.29
         WIDTH              = 90.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-abrange-aval IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN c-desc-ind-aval IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN c-desc-ind-aval-emb IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN c-desc-ind-cre IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN d-moeda IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       d-moeda:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN emitente.dt-fim-cred IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN emitente.lim-adicional IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN emitente.moeda-libcre IN FRAME f-main
   EXP-LABEL                                                            */
ASSIGN 
       emitente.moeda-libcre:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN emitente.nome-abrev IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN emitente.nome-emit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-aval-multi-emp IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX tg-considera-ap-lim-cred IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN emitente.user-libcre IN FRAME f-main
   NO-ENABLE 2 EXP-LABEL                                                */
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

&Scoped-define SELF-NAME emitente.dt-fim-cred
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.dt-fim-cred V-table-Win
ON LEAVE OF emitente.dt-fim-cred IN FRAME f-main /* Fim Lim Cr‚d Adic */
DO:
  if date(emitente.dt-fim-cred:screen-value) <> emitente.dt-fim-cred then 
     assign emitente.user-libcre:screen-value = c-seg-usuario.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emitente.dt-lim-cred
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.dt-lim-cred V-table-Win
ON LEAVE OF emitente.dt-lim-cred IN FRAME f-main /* Dt Lim Cred */
DO:
  if date(emitente.dt-lim-cred:screen-value) <> emitente.dt-lim-cred then
     assign emitente.user-libcre:screen-value = c-seg-usuario.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emitente.ind-abrange-aval
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.ind-abrange-aval V-table-Win
ON VALUE-CHANGED OF emitente.ind-abrange-aval IN FRAME f-main /* Ab Aval */
DO:
 /***************************************************
  * Pre-processador de Usuario e Moeda de Credito   *
  ***************************************************/
  &if  defined (bf_dis_usu_moeda_cred)  &then

       find b-emitente
            where b-emitente.nome-abrev = emitente.nome-abrev:screen-value in frame {&frame-name} no-lock no-error.

       if  b-emitente.nome-matriz <> emitente.nome-abrev
       and emitente.ind-abrange-aval:screen-value in frame {&frame-name} = "2" then do:

           assign c-nome-matriz = b-emitente.nome-matriz.
           find first b-emitente
                where b-emitente.nome-abrev = c-nome-matriz no-lock no-error.

           if  avail b-emitente then do:
               find first moeda
                    where moeda.mo-codigo = b-emitente.moeda-libcre no-lock no-error.

               if  avail moeda then
                   assign emitente.moeda-libcre:screen-value in frame {&frame-name} = string(b-emitente.moeda-libcre)
                          d-moeda:screen-value               in frame {&frame-name} = moeda.descricao.
           end.
           assign emitente.moeda-libcre:sensitive in frame {&frame-name} = no.
       end.
       else
           assign emitente.moeda-libcre:sensitive in frame {&frame-name} = yes.
  &endif.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emitente.ind-cre-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.ind-cre-cli V-table-Win
ON VALUE-CHANGED OF emitente.ind-cre-cli IN FRAME f-main /* Cred */
DO:
    define variable c-return as character no-undo.

    Run pi-desabilita-campos.

    If  i-ind-cre-cli = 4 then do:
        &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
            run cmp/cm0102a.w (input-output c-obs, output c-return).
        &ELSE
            run pdp/pd0806a.w (input-output c-obs).
        &ENDIF

        find first ped-venda where
                   ped-venda.nome-abrev    = emitente.nome-abrev:Screen-value in frame {&frame-name} and
                   ped-venda.cod-sit-ped  <= 1 and
                   ped-venda.cod-sit-aval <> 4 no-lock no-error.
        If avail ped-venda then do:
           run utp/ut-msgs.p (input "show",
                              input 689,
                              input "").
        End.
    End.

    if  i-ind-cre-ant = 4
    and i-ind-cre-cli <> 4 then
        &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
            run cmp/cm0102a.w (input-output c-obs, output c-return).
        &ELSE
            run pdp/pd0806a.w (input-output c-obs).
        &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emitente.lim-adicional
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.lim-adicional V-table-Win
ON LEAVE OF emitente.lim-adicional IN FRAME f-main /* Lim Cr‚d Adic */
DO:
   If  decimal(emitente.lim-adicional:screen-value) = 0.00 then do:
       Disable emitente.dt-fim-cred with frame {&frame-name}.
       Assign emitente.dt-fim-cred:Screen-value = "".
   End.
   Else do:
       If not emitente.dt-fim-cred:Sensitive then do:
            Enable emitente.dt-fim-cred with frame {&frame-name}.
            Apply 'entry' to emitente.dt-fim-cred in frame {&frame-name}.
            Return no-apply.
       End.
   End.
   if decimal(emitente.lim-adicional:screen-value) <> emitente.lim-adicional then
      assign emitente.user-libcre:screen-value = c-seg-usuario.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emitente.lim-credito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.lim-credito V-table-Win
ON LEAVE OF emitente.lim-credito IN FRAME f-main /* Limite Cr‚dito */
DO:
   If decimal(emitente.lim-credito:screen-value) = 0.00 then do:
       Disable emitente.dt-lim-cred with frame {&frame-name}.
       Assign emitente.dt-lim-cred:Screen-value = "".
   End.
   Else do:
       If not emitente.dt-lim-cred:Sensitive then do:
            Enable emitente.dt-lim-cred with frame {&frame-name}.
            Apply 'entry' to emitente.dt-lim-cred in frame {&frame-name}.
            Return no-apply.
       End.
   End.
   if decimal(emitente.lim-credito:screen-value) <> emitente.lim-credito then 
      assign emitente.user-libcre:screen-value = c-seg-usuario.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emitente.moeda-libcre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.moeda-libcre V-table-Win
ON F5 OF emitente.moeda-libcre IN FRAME f-main /* Mo Lim Cr‚d */
DO:

  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="unzoom/z01un005.w"
                     &campo=emitente.moeda-libcre
                     &campozoom=mo-codigo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.moeda-libcre V-table-Win
ON LEAVE OF emitente.moeda-libcre IN FRAME f-main /* Mo Lim Cr‚d */
DO:
    find first moeda
         where moeda.mo-codigo = int(emitente.moeda-libcre:screen-value in frame {&frame-name}) no-lock no-error.
    if  avail moeda then
        assign d-moeda:screen-value in frame {&frame-name} = moeda.descricao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.moeda-libcre V-table-Win
ON MOUSE-SELECT-DBLCLICK OF emitente.moeda-libcre IN FRAME f-main /* Mo Lim Cr‚d */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-num-dias-max-dup-venc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-dias-max-dup-vencl V-table-Win
ON VALUE-CHANGED OF i-num-dias-max-dup-venc IN FRAME f-main /* Regra num max dias DP venc */
DO:
   IF i-num-dias-max-dup-venc:SCREEN-VALUE in frame f-main > "0" THEN DO:
      ENABLE l-desconsidera-antecip-na-dup-venc
             tg-desconsidera-ad-dupli-venc WITH FRAME {&FRAME-NAME}.
   END.
   ELSE DO:
      DISABLE l-desconsidera-antecip-na-dup-venc
              tg-desconsidera-ad-dupli-venc with frame {&frame-name}.

       ASSIGN l-desconsidera-antecip-na-dup-venc:Screen-value = "NO"
              tg-desconsidera-ad-dupli-venc:Screen-value = "NO".
   END.
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


  {utp/ut-liter.i "Cliente" * R}
  assign emitente.nome-abrev:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Perc_M x_Bloqueio_Cr‚dito * R} 
  assign de-perc-max-dup-venc:label in frame f-main = return-value.
  
  {utp/ut-liter.i Perc_%_M x_Duplicatas_Vencidas_para_Bloqueio_de_Cr‚dito MPD R} 
  assign de-perc-max-dup-venc:help  in frame f-main = return-value.
  
  {utp/ut-liter.i N£m_M x_Dias_Dup_Venc * R} 
  assign i-num-dias-max-dup-venc:label in frame f-main = return-value.
 
  {utp/ut-liter.i N£m_M x_Dias_Duplicatas_Vencidas_para_Bloqueio_de_Cr‚dito MPD R} 
  assign i-num-dias-max-dup-venc:help  in frame f-main = return-value.
  
  {utp/ut-liter.i Desconsidera_Antecipa‡Æo_nas_Duplicatas_Vencidas * R}
  assign l-desconsidera-antecip-na-dup-venc:label in frame f-main = return-value.
  
  {utp/ut-liter.i Desconsidera_Antecipa‡Æo_nas_Duplicatas_Vencidas * R}
  assign l-desconsidera-antecip-na-dup-venc:help in frame f-main = return-value.
  
  {utp/ut-liter.i Desconsidera_Aviso_de_D‚bito_Vencido MPD R}
  assign tg-desconsidera-ad-dupli-venc:LABEL in frame f-main = return-value.
  
  {utp/ut-liter.i Desconsidera_Aviso_de_D‚bito_Vencido MPD R}
  assign tg-desconsidera-ad-dupli-venc:help in frame f-main = return-value.
  
  {utp/ut-liter.i Meses_Inativos * R}
  assign emitente.nr-mesina:LABEL IN frame f-main = return-value.

  
 /***************************************************
  * Pre-processador de Usuario e Moeda de Credito   *
  ***************************************************/
  &if  defined (bf_dis_usu_moeda_cred)  &then
       assign emitente.moeda-libcre:hidden = no
              d-moeda:hidden               = no.
       if emitente.moeda-libcre:load-mouse-pointer ("image~\lupa.cur") in frame {&FRAME-NAME} then.
  &endif.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "emitente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "emitente"}

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

  DEFINE VARIABLE h-ut-integration AS HANDLE NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  apply 'leave' to emitente.lim-credito   in frame {&frame-name}.  
  apply 'leave' to emitente.lim-adicional in frame {&frame-name}.

  if  input emitente.lim-credito = 0 then do:
      if  int(emitente.ind-aval:screen-value          in frame {&frame-name}) = 3 or 
          int(emitente.ind-aval-embarque:screen-value in frame {&frame-name}) = 3 then do:

          apply "entry" to emitente.lim-credito.
          run utp/ut-msgs.p (input "show", input 710, input "").
          return 'adm-error'.

      end.
  end.
  else do:
      if  input emitente.dt-lim-cred = ? then do:
          {utp/ut-field.i mgadm emitente dt-lim-cred 1} assign c-label-1 = return-value.             
          {utp/ut-field.i mgadm emitente lim-credito 1} assign c-label-2 = return-value.

          apply "entry" to emitente.dt-lim-cred.
          run utp/ut-msgs.p (input "show", input 729, input c-label-1 + "~~" + c-label-2).
          return 'adm-error'.

      end.
  end.

  if  input emitente.lim-adicional <> 0 and 
      input emitente.dt-fim-cred = ? then do:

      {utp/ut-field.i mgadm emitente dt-fim-cred   1} assign c-label-1 = return-value.            
      {utp/ut-field.i mgadm emitente lim-adicional 1} assign c-label-2 = return-value.

      apply "entry" to emitente.dt-fim-cred.
      run utp/ut-msgs.p (input "show", input 729, input c-label-1 + "~~" + c-label-2).
      return 'adm-error'.

  end.

  /*** FO 1.960.297 - Avalia Cr‚dito Multi-empresa ***/
  &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &Then 
      FIND dist-emitente WHERE
           dist-emitente.cod-emitente = emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
      IF AVAIL dist-emitente THEN DO:
    
          &IF "{&BF_DIS_VERSAO_EMS}" >= "2.08" &Then 
              ASSIGN dist-emitente.log-avaliac-cr-multi-empres = tg-aval-multi-emp:CHECKED IN FRAME f-main.
          &Else
              ASSIGN dist-emitente.log-2 = tg-aval-multi-emp:CHECKED IN FRAME f-main. 
          &ENDIF
      END.
  &ENDIF

 /***************************************************
  * Pre-processador de Usuario e Moeda de Credito   *
  ***************************************************/
  &if  defined (bf_dis_usu_moeda_cred)  &then
       find first moeda
            where moeda.mo-codigo = int(emitente.moeda-libcre:screen-value in frame {&frame-name}) no-lock no-error.
       if  not avail moeda then do:
           apply "entry" to emitente.moeda-libcre.
           run utp/ut-msgs.p (input "show", input 151, input emitente.moeda-libcre:screen-value in frame {&frame-name}).
           return 'ADM-ERROR'.
       end.

       for each b-emitente
          where b-emitente.nome-matriz      = emitente.nome-abrev:screen-value in frame {&frame-name}
            and b-emitente.ind-abrange-aval = 2 exclusive-lock:

           assign b-emitente.moeda-libcre = int(emitente.moeda-libcre:screen-value in frame {&frame-name}).
       end.
       assign emitente.user-libcre:screen-value  = v_cod_usuar_corren.
  &else
       if decimal(emitente.lim-credito:screen-value)   = emitente.lim-credito    and
          decimal(emitente.lim-adicional:screen-value) = emitente.lim-adicional  and
          date(emitente.dt-lim-cred:screen-value)      = emitente.dt-lim-cred    and
          date(emitente.dt-fim-cred:screen-value)      = emitente.dt-fim-cred    then
             assign emitente.user-libcre:screen-value  = v_cod_usuar_corren.
  &endif.

  IF param-global.modulo-mp THEN DO:

      /* se o campo considera ap lim credito for alterado, chama multiplanta dis025 */

      &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &Then 
         &if "{&BF_DIS_VERSAO_EMS}" < "2.05" &THEN 
          FIND dist-emitente WHERE
               dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
          IF AVAIL dist-emitente THEN DO:
            IF SUBSTRING(dist-emitente.char-1,1,1) = "" /*yes*/ AND
               tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "NO" THEN
               ASSIGN l-chama-mp-dist-emitente = YES.
            ELSE IF substring(dist-emitente.char-1,1,1) = "2" /*no*/ AND
                    tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "YES" THEN
                    ASSIGN l-chama-mp-dist-emitente = YES.

          END.
        &ENDIF
      &ENDIF        

      &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &then
          FIND dist-emitente WHERE
               dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
          IF AVAIL dist-emitente THEN DO:
             IF dist-emitente.log-consid-ap-lim-cr <> 
                tg-considera-ap-lim-cred:CHECKED IN FRAME f-main  THEN
                ASSIGN l-chama-mp-dist-emitente = YES.

             IF dist-emitente.log-desconsid-ad-dup-venc <> 
                tg-desconsidera-ad-dupli-venc:CHECKED IN FRAME f-main  THEN
                ASSIGN l-chama-mp-dist-emitente = YES.

          END.
      &ENDIF
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( input 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  assign overlay(emitente.char-1,141,6) = trim(de-perc-max-dup-venc:screen-value in frame f-main).
  assign overlay(emitente.char-1,161,3) = trim(i-num-dias-max-dup-venc:screen-value in frame f-main).
  ASSIGN OVERLAY(emitente.char-1,164,1) = IF l-desconsidera-antecip-na-dup-venc:SCREEN-VALUE IN FRAME f-main = "YES" THEN "S" ELSE "N".

  &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &Then 
     &if "{&BF_DIS_VERSAO_EMS}" < "2.05" &THEN 
       FIND dist-emitente WHERE
            dist-emitente.cod-emitente = emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
       IF AVAIL dist-emitente THEN DO:
            IF tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "YES" THEN DO:
               ASSIGN OVERLAY(dist-emitente.char-1,1,1) = "".
               IF l-chama-mp-dist-emitente THEN
                  RUN pi-gera-multiplanta.
            END.     
            ELSE DO:
                   ASSIGN OVERLAY(dist-emitente.char-1,1,1) = "2".
                   IF l-chama-mp-dist-emitente THEN
                      RUN pi-gera-multiplanta.
            END.
       END.
    &ENDIF
  &ENDIF        

  &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &then
       FIND dist-emitente WHERE
            dist-emitente.cod-emitente = emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
       IF AVAIL dist-emitente THEN DO:
           IF tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "YES" THEN DO:
              ASSIGN dist-emitente.log-consid-ap-lim-cr = YES.
              IF l-chama-mp-dist-emitente THEN
                 RUN pi-gera-multiplanta.
           END.                       
           ELSE DO:
                  ASSIGN dist-emitente.log-consid-ap-lim-cr = NO.
                  IF l-chama-mp-dist-emitente THEN
                     RUN pi-gera-multiplanta.
           END.

           IF tg-desconsidera-ad-dupli-venc:SCREEN-VALUE IN FRAME f-main = "YES" THEN DO:
              ASSIGN dist-emitente.log-desconsid-ad-dup-venc = YES.
              IF l-chama-mp-dist-emitente THEN
                 RUN pi-gera-multiplanta.
           END.                       
           ELSE DO:
                  ASSIGN dist-emitente.log-desconsid-ad-dup-venc = NO.
                  IF l-chama-mp-dist-emitente THEN
                     RUN pi-gera-multiplanta.
           END.
       END.
  &ENDIF

  ASSIGN l-chama-mp-dist-emitente = NO.

  if emitente.ind-cre-cli = 4
  or (    i-ind-cre-ant = 4
      and emitente.ind-cre-cli <> 4)
  then
      assign emitente.observacoes = c-obs.

  if avail emitente and emitente.cdn-atraso-max > 0 then assign emitente.nr-dias-atraso = emitente.cdn-atraso-max.

  /* Projeto 751 - Conferˆncia de Dados de Integra‡Æo */
  /*&IF "{&BF_DIS_VERSAO_EMS}" < "2.071" &THEN
       ASSIGN emitente.data-1 = TODAY
              OVERLAY(emitente.char-2,68,8) = STRING(TIME,"HH:MM:SS").
  &else
       ASSIGN emitente.dt-atualiza = TODAY
              emitente.hra-atualiz = STRING(TIME,"HH:MM:SS").
  &endif*/
  /* Projeto 751 - Conferˆncia de Dados de Integra‡Æo */

  /* ================= Integra‡Æo Multiplanta ================ */
  for each tt-dados-env NO-LOCK:
      delete tt-dados-env.
  end.

  assign c-transacao  = "DIS014".

  {cdp/cd7300.i5 "001" c-transacao}

  run pi-cria-tt-dados(input 2).

  {cdp/cd7300.i6 "001" c-transacao}

  /* ========================================================= */    

  /*  Integracao EAI  */
  &IF '{&BF_DIS_VERSAO_EMS}' >= "2.04":U &THEN 
    IF v_log_eai_habilit THEN 
       if valid-handle (h-eai-emit) then do:
          empty temp-table tt_log_erro no-error.
          empty temp-table RowErrors   no-error. 
          run PITransUpsert IN h-eai-emit (input rowid(emitente),
                                           input "upd":U,
                                           output table tt_log_erro).
          find first tt_log_erro WHERE tt_log_erro.ttv_num_cod_erro <> 60 no-lock no-error.
            if avail tt_log_erro then do:
                OUTPUT STREAM s-teste TO VALUE('c:~\temp~\teste.txt').
                PUT STREAM s-teste
                    tt_log_erro.ttv_num_cod_erro SKIP
                    tt_log_erro.ttv_des_msg_erro FORMAT 'x(30000)' SKIP.

               create RowErrors.
               assign RowErrors.ErrorSequence     = RowErrors.ErrorSequence + 1 
                      RowErrors.ErrorNumber       = ttv_num_cod_erro
                      RowErrors.ErrorDescription  = ttv_des_msg_erro
                      RowErrors.ErrorHelp         = ttv_des_msg_erro.
               OUTPUT STREAM s-teste CLOSE.
            end.
            if can-find(first RowErrors) then do:
               {method/showmessage.i1}
               /*Transfere temp-table RowErrors para a tela de mensagens de erros*/
               {method/showmessage.i2 &Modal="Yes"}
               return 'ADM-ERROR':U.
            end.
       end.
  &ENDIF 
  
  RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.  

  RUN eai-integration in h-ut-integration (INPUT "Customer",          /* Nome da transa‡Æo     */
                                           INPUT ROWID(emitente),    /* Registro da transa‡Æo */
                                           INPUT "UPDATE",           /* Evento da transa‡Æo   */
                                           OUTPUT TABLE RowErrors).  /* Erros da transa‡Æo    */

  DELETE PROCEDURE h-ut-integration.
  
  if can-find(first RowErrors) then do:
     {method/showmessage.i1}     
     {method/showmessage.i2 &Modal="Yes"}
     return 'ADM-ERROR':U.
  end.

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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  Find first para-ped no-lock no-error.
  
  if avail emitente then 
	assign de-perc-max-dup-venc:screen-value in frame f-main = substring(emitente.char-1,141,6)
	       i-num-dias-max-dup-venc:screen-value in frame f-main = substring(emitente.char-1,161,3)
           l-desconsidera-antecip-na-dup-venc:CHECKED IN FRAME f-main = IF SUBSTRING(emitente.char-1,164,1) = "S" THEN YES ELSE NO.
  
  find first moeda
       where moeda.mo-codigo = int(emitente.moeda-libcre:screen-value in frame {&frame-name}) no-lock no-error.
  if  avail moeda then
      assign d-moeda:screen-value in frame {&frame-name} = moeda.descricao.


 &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &Then 
     &if "{&BF_DIS_VERSAO_EMS}" < "2.05" &THEN 
      FIND dist-emitente WHERE
           dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
      IF AVAIL dist-emitente THEN DO:
        IF substring(dist-emitente.char-1,1,1) = "" THEN
           ASSIGN tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "YES".
        ELSE IF substring(dist-emitente.char-1,1,1) = "2" THEN
           ASSIGN tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "NO".
      END.
    &ENDIF
  &ENDIF        

  &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &then
      FIND dist-emitente WHERE
           dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
      IF AVAIL dist-emitente THEN DO:
           IF dist-emitente.log-consid-ap-lim-cr = YES THEN
              ASSIGN tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "YES".
           ELSE
              ASSIGN tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "NO".

           IF dist-emitente.log-desconsid-ad-dup-venc = YES THEN
              ASSIGN tg-desconsidera-ad-dupli-venc:SCREEN-VALUE IN FRAME f-main = "YES".
           ELSE
              ASSIGN tg-desconsidera-ad-dupli-venc:SCREEN-VALUE IN FRAME f-main = "NO".
      END.
  &ENDIF

  /*** FO 1.960.297 - Avalia Cr‚dito Multi-empresa ***/
  &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &Then 
      FIND dist-emitente WHERE
           dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
      IF AVAIL dist-emitente THEN DO:

          &IF "{&BF_DIS_VERSAO_EMS}" >= "2.08" &Then 
              ASSIGN tg-aval-multi-emp:CHECKED IN FRAME f-main = dist-emitente.log-avaliac-cr-multi-empres.
          &Else
              ASSIGN tg-aval-multi-emp:CHECKED IN FRAME f-main = dist-emitente.log-2.
          &ENDIF
      END.
  &ENDIF

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

 /***************************************************
  * Pre-processador de Usuario e Moeda de Credito   *
  ***************************************************/
   
  &IF DEFINED(BF_DIS_USU_MOEDA_CRED) &THEN
  
  find b-emitente
       where b-emitente.nome-abrev = emitente.nome-abrev:screen-value in frame {&frame-name} no-lock no-error.

  &IF DEFINED(BF_DIS_VERSAO_EMS) &THEN
      &IF '{&BF_DIS_VERSAO_EMS}'  = '2.02' &THEN
          find first usu-gr-cli       /* Pesquisa por usuario e cliente */
               where usu-gr-cli.cod-usuario = c-seg-usuario
                 and usu-gr-cli.nome-abrev  = b-emitente.nome-abrev no-lock no-error.
          if   not avail usu-gr-cli then
               find first usu-gr-cli  /* Pesquisa por usuario e grupo   */
                    where usu-gr-cli.cod-usuario = c-seg-usuario
                      and (usu-gr-cli.cod-gr-cli = string(b-emitente.cod-gr-cli)
                        or usu-gr-cli.cod-gr-cli = "*")
                      and usu-gr-cli.nome-abrev  = "*" no-lock no-error.
      &ENDIF
      &IF '{&BF_DIS_VERSAO_EMS}' >= '2.03' and
          '{&BF_DIS_VERSAO_EMS}' <  '2.05' &THEN
          find b-emitente
               where b-emitente.nome-abrev = emitente.nome-abrev:screen-value in frame {&frame-name} no-lock no-error.
          find first usu-gr-cli       /* Pesquisa por usuario e cliente */
               where usu-gr-cli.cod-usuario = c-seg-usuario
                 and usu-gr-cli.nome-abrev  = b-emitente.nome-abrev
                 and usu-gr-cli.ind-funcao  = 1 /* Cr‚dito */ no-lock no-error.
          if  not avail usu-gr-cli then
              find first usu-gr-cli  /* Pesquisa por usuario e grupo   */
                   where usu-gr-cli.cod-usuario = c-seg-usuario
                     and (usu-gr-cli.cod-gr-cli = string(b-emitente.cod-gr-cli)
                       or usu-gr-cli.cod-gr-cli = "*")
                      and usu-gr-cli.nome-abrev  = "*"
                      and usu-gr-cli.ind-funcao  = 1 /* Cr‚dito */ no-lock no-error.
      &ENDIF
      &IF '{&BF_DIS_VERSAO_EMS}' >= '2.05' &THEN
          find first usu-gr-cli       /* Pesquisa por usuario e cliente */
               where usu-gr-cli.cod-usuario = c-seg-usuario
                 and usu-gr-cli.nome-abrev  = b-emitente.nome-abrev no-lock no-error.
          if   not avail usu-gr-cli then
               find first usu-gr-cli  /* Pesquisa por usuario e grupo   */
                    where usu-gr-cli.cod-usuario = c-seg-usuario
                      and (usu-gr-cli.cod-gr-cli = b-emitente.cod-gr-cli
                        or usu-gr-cli.cod-gr-cli = 0)
                      and usu-gr-cli.nome-abrev  = "*" no-lock no-error.
      &ENDIF
      
  &ENDIF

  if   not avail usu-gr-cli then do:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "aprova‡Æo" *}
       run utp/ut-msgs.p(input "show",
                        input 6660,
                        input c-seg-usuario + "~~" + RETURN-VALUE + " !").
       RUN get-link-handle IN adm-broker-hdl
          (INPUT THIS-PROCEDURE,
           INPUT "TableIO-source",
           OUTPUT c-handle).
       RUN pi-cancelar in widget-handle(c-handle).
       return "ADM-ERROR".
  end.
  &ENDIF
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  Run pi-desabilita-campos.

  &IF "{&BF_DIS_VERSAO_EMS}" < "2.04" &Then 
     ASSIGN tg-considera-ap-lim-cred:VISIBLE IN FRAME f-main = no.
  &ELSEIF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &Then
     ASSIGN tg-considera-ap-lim-cred:VISIBLE IN FRAME f-main = YES
            tg-desconsidera-ad-dupli-venc:VISIBLE IN FRAME f-main = YES.
  &ENDIF

  /*** FO 1.960.297 ***/
  &IF "{&BF_DIS_VERSAO_EMS}" < "2.062" &Then 
     ASSIGN tg-aval-multi-emp:VISIBLE IN FRAME f-main = NO.
  &ELSE
     ASSIGN tg-aval-multi-emp:VISIBLE IN FRAME f-main = YES.
  &ENDIF

  apply 'leave'         to emitente.lim-credito      in frame {&frame-name}.
  apply 'leave'         to emitente.lim-adicional    in frame {&frame-name}.
  apply 'value-changed' to emitente.ind-abrange-aval in frame {&frame-name}.

  assign c-obs         = emitente.observacoes
         i-ind-cre-ant = emitente.ind-cre-cli.

  /*Assign emitente.user-libcre:screen-value in frame {&frame-name} = {cdp/cd7777.i}.*/
  /* Obs.: A linha acima foi colocada em coment rios pois o campo estava com tratamento */
  /* inadequando, sendo considerado como £ltimo usu rio de altera‡Æo e nÆo como usu rio */
  /* respons vel pela atualiza‡Æo do cr‚dito                                            */

    &IF '{&bf_dis_versao_ems}' >= "2.04" &THEN
        IF CAN-FIND(FIRST funcao
                    WHERE funcao.cd-funcao = "spp-sgt":U
                    AND   funcao.ativo = TRUE NO-LOCK) THEN DISABLE emitente.ind-aval-embarque WITH FRAME {&frame-name}.
    &ENDIF
    
    /*CHAMADA UPC*/
    IF c-nom-prog-upc-mg97 <> "" THEN DO:
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "after-enable-fields",
                                        INPUT "VIEWER",
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME {&FRAME-NAME}:HANDLE,
                                        INPUT "emitente",
                                        INPUT ROWID(emitente)).
    END.
    /*FIM CHAMADA UPC*/

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

  /* Integracao EAI - */
  &IF '{&bf_dis_versao_ems}' >= "2.04":U &THEN 
    if v_log_eai_habilit then
       run adapters/xml/fi2/axsfi001.p persistent set h-eai-emit (output table tt_log_erro).

    ASSIGN emitente.ind-lib-estoque:HELP IN FRAME f-main = "Aloca pedido de venda sem considerar situa‡Æo de cr‚dito?".

  &ENDIF                   
                                                                   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  {utp/ut-rtlbl.i mgadm emitente ind-aval c-desc-ind-aval}
  {utp/ut-rtlbl.i mgadm emitente ind-aval-embarque c-desc-ind-aval-emb}
  {utp/ut-rtlbl.i mgadm emitente ind-abrange-aval c-desc-abrange-aval}
  /* Code placed here will execute AFTER standard behavior.    */
 
  // Label traduzindo utilizando a ut-liter pois a ut-rtlbl.i nÆo traduziu corretamente
  {utp/ut-liter.i Cr‚dito MPD R}
  ASSIGN c-desc-ind-cre:screen-value in FRAME f-main = " " + return-value
         c-desc-ind-cre = " " + return-value
         c-desc-ind-cre:width        in FRAME f-main = length(return-value) + 3.

  &IF "{&BF_DIS_VERSAO_EMS}" < "2.04" &Then 
     ASSIGN tg-considera-ap-lim-cred:VISIBLE IN FRAME f-main = no.
  &ELSEIF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &Then
     ASSIGN tg-considera-ap-lim-cred:VISIBLE IN FRAME f-main = YES
            tg-desconsidera-ad-dupli-venc:VISIBLE IN FRAME f-main = YES.
  &ENDIF

  &IF "{&BF_DIS_VERSAO_EMS}" < "2.062" &Then 
     ASSIGN tg-aval-multi-emp:VISIBLE IN FRAME f-main = NO.
  &ELSE
     ASSIGN tg-aval-multi-emp:VISIBLE IN FRAME f-main = YES
            tg-aval-multi-emp:CHECKED IN FRAME f-main = NO.
  &ENDIF

  FIND FIRST param-global NO-LOCK NO-ERROR.
  
  FIND FIRST user-coml
       WHERE user-coml.usuario = c-seg-usuario  NO-LOCK NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define input parameter i-tipo-movto as integer.

  if  param-global.modulo-mp and
      tt-replica-msg.log-replica-msg = yes then do: 
      create tt-info-aval-cred-aux.
      buffer-copy emitente to tt-info-aval-cred-aux no-error.      
      create tt-dados-env.
      assign tt-dados-env.num-sequencia  = i-seq
             tt-dados-env.cod-tipo-reg   = 21
             tt-dados-env.ind-tipo-movto = i-tipo-movto
             tt-dados-env.identif-msg    = string(emitente.cod-emitente).             
      raw-transfer tt-info-aval-cred-aux to tt-dados-env.conteudo-msg.
      assign i-seq = i-seq + 1.      
  end.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-dis025 V-table-Win 
PROCEDURE pi-cria-tt-dados-dis025 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&BF_DIS_VERSAO_EMS}" >= "2.02" &THEN 

  define input parameter i-tipo-movto as integer.

  if  param-global.modulo-mp and
      tt-replica-msg-EMI.log-replica-msg  = yes then do: 
       create tt-dist-emitente-aux.
       buffer-copy dist-emitente to tt-dist-emitente-aux.
       create tt-dados-env-EMI.                  
       assign tt-dados-env-EMI.num-sequencia  = i-seq 
              tt-dados-env-EMI.cod-tipo-reg   = 295 /* Dis-Emitente */ 
              tt-dados-env-EMI.ind-tipo-movto = i-tipo-movto
              tt-dados-env-EMI.identif-msg    = string(dist-emitente.cod-emitente).
       raw-transfer tt-dist-emitente-aux to tt-dados-env-EMI.conteudo-msg.    
       assign i-seq = i-seq + 1.                                     
  end.   

&ENDIF

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
    
    &IF '{&bf_dis_versao_ems}' >= '2.08':U &THEN
        IF param-global.log-cr-clien = YES THEN DO:
            IF AVAIL user-coml
            AND user-coml.log-lim-cred = YES THEN DO:
               ENABLE emitente.lim-credito
                      emitente.dt-lim-cred
                      emitente.lim-adicional
                      emitente.dt-fim-cred
                      emitente.moeda-libcre
					  de-perc-max-dup-venc
                      i-num-dias-max-dup-venc
                      l-desconsidera-antecip-na-dup-venc 
                      tg-desconsidera-ad-dupli-venc WITH FRAME {&FRAME-NAME}.
            END.
            ELSE DO:
               DISABLE emitente.lim-credito  
                       emitente.dt-lim-cred  
                       emitente.lim-adicional
                       emitente.dt-fim-cred  
                       emitente.moeda-libcre
					   de-perc-max-dup-venc
                       i-num-dias-max-dup-venc
                       l-desconsidera-antecip-na-dup-venc 
                       tg-desconsidera-ad-dupli-venc WITH FRAME {&FRAME-NAME}.
            END.
            ASSIGN i-ind-cre-cli = int(emitente.ind-cre-cli:SCREEN-VALUE IN FRAME {&frame-name}).
            IF i-ind-cre-cli <> 2 THEN 
                ENABLE emitente.ind-aval 
                       emitente.ind-aval-embarque WITH FRAME {&frame-name}.
            ELSE DO WITH FRAME {&FRAME-NAME}:
                ASSIGN  emitente.ind-aval:SCREEN-VALUE = "1"
                        emitente.ind-aval-embarque:SCREEN-VALUE = "1".

                DISABLE emitente.ind-aval
                        emitente.ind-aval-embarque.
            END.
        END.
        ELSE DO:
            ASSIGN i-ind-cre-cli = int(emitente.ind-cre-cli:SCREEN-VALUE IN FRAME {&frame-name}).
            IF i-ind-cre-cli <> 2 THEN DO:
                ENABLE emitente.ind-aval 
                       emitente.ind-aval-embarque
                       emitente.lim-credito
                       emitente.dt-lim-cred
                       emitente.lim-adicional
                       emitente.dt-fim-cred
					   de-perc-max-dup-venc
                       i-num-dias-max-dup-venc
                       l-desconsidera-antecip-na-dup-venc 
                       tg-desconsidera-ad-dupli-venc WITH FRAME {&FRAME-NAME}.
            END.
            ELSE DO WITH FRAME {&FRAME-NAME}:
                ASSIGN  emitente.ind-aval:SCREEN-VALUE = "1"
                        emitente.ind-aval-embarque:SCREEN-VALUE = "1"
                        emitente.lim-credito:SCREEN-VALUE = "0"
                        emitente.dt-lim-cred:SCREEN-VALUE = ?
                        emitente.lim-adicional:SCREEN-VALUE = "0"
                        emitente.dt-fim-cred:SCREEN-VALUE = ?
						de-perc-max-dup-venc:screen-value = "0"
						i-num-dias-max-dup-venc:screen-value = "0"
                        l-desconsidera-antecip-na-dup-venc:CHECKED = NO
                        tg-desconsidera-ad-dupli-venc:CHECKED = NO.

                DISABLE emitente.ind-aval
                        emitente.ind-aval-embarque
                        emitente.lim-credito
                        emitente.dt-lim-cred
                        emitente.lim-adicional
                        emitente.dt-fim-cred
						de-perc-max-dup-venc
						i-num-dias-max-dup-venc
                        l-desconsidera-antecip-na-dup-venc
                        tg-desconsidera-ad-dupli-venc.
            END.
        END.

        IF i-num-dias-max-dup-venc:SCREEN-VALUE in frame f-main > "0" THEN DO:
           ENABLE l-desconsidera-antecip-na-dup-venc
                  tg-desconsidera-ad-dupli-venc WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
           DISABLE l-desconsidera-antecip-na-dup-venc
		           tg-desconsidera-ad-dupli-venc with frame {&frame-name}.

           ASSIGN l-desconsidera-antecip-na-dup-venc:Screen-value = "NO"
		          tg-desconsidera-ad-dupli-venc:Screen-value = "NO".
        END.
    &ELSE   
        &IF '{&bf_dis_versao_ems}' >= '2.062':U &THEN                                     
            IF SUBSTRING(param-global.char-2,32,1) = "S" THEN DO:
                IF AVAIL user-coml
                AND SUBSTRING(user-coml.char-1,35,1) = "S" THEN DO:   
                   ENABLE emitente.lim-credito                                                 
                          emitente.dt-lim-cred                                                 
                          emitente.lim-adicional                                               
                          emitente.dt-fim-cred                                                 
                          emitente.moeda-libcre
						  de-perc-max-dup-venc
                          i-num-dias-max-dup-venc 
                          l-desconsidera-antecip-na-dup-venc 
                          tg-desconsidera-ad-dupli-venc WITH FRAME {&FRAME-NAME}.
                END.                                                                           
                ELSE DO:        
                   DISABLE emitente.lim-credito                                                 
                           emitente.dt-lim-cred                                                 
                           emitente.lim-adicional                                               
                           emitente.dt-fim-cred                                                 
                           emitente.moeda-libcre
						   de-perc-max-dup-venc 
						   i-num-dias-max-dup-venc 
                           l-desconsidera-antecip-na-dup-venc 
                           tg-desconsidera-ad-dupli-venc WITH FRAME {&FRAME-NAME}.                                               
                END.                                                                           
                ASSIGN i-ind-cre-cli = int(emitente.ind-cre-cli:SCREEN-VALUE IN FRAME {&frame-name}).
                IF i-ind-cre-cli <> 2 THEN 
                    ENABLE emitente.ind-aval 
                           emitente.ind-aval-embarque WITH FRAME {&frame-name}.
                ELSE DO WITH FRAME {&FRAME-NAME}:
                    ASSIGN  emitente.ind-aval:SCREEN-VALUE = "1"
                            emitente.ind-aval-embarque:SCREEN-VALUE = "1".
    
                    DISABLE emitente.ind-aval
                            emitente.ind-aval-embarque.
                END.
            END.
            ELSE DO:
                ASSIGN i-ind-cre-cli = int(emitente.ind-cre-cli:SCREEN-VALUE IN FRAME {&frame-name}).
                IF i-ind-cre-cli <> 2 THEN 
                    ENABLE emitente.ind-aval 
                           emitente.ind-aval-embarque
                           emitente.lim-credito
                           emitente.dt-lim-cred
                           emitente.lim-adicional
                           emitente.dt-fim-cred
						   de-perc-max-dup-venc 
						   i-num-dias-max-dup-venc
                           l-desconsidera-antecip-na-dup-venc 
                           tg-desconsidera-ad-dupli-venc WITH FRAME {&FRAME-NAME}.
                ELSE DO WITH FRAME {&FRAME-NAME}:
                    ASSIGN  emitente.ind-aval:SCREEN-VALUE = "1"
                            emitente.ind-aval-embarque:SCREEN-VALUE = "1"
                            emitente.lim-credito:SCREEN-VALUE = "0"
                            emitente.dt-lim-cred:SCREEN-VALUE = ?
                            emitente.lim-adicional:SCREEN-VALUE = "0"
                            emitente.dt-fim-cred:SCREEN-VALUE = ?
							de-perc-max-dup-venc:screen-value = "0"
							i-num-dias-max-dup-venc:screen-value = "0"
                            l-desconsidera-antecip-na-dup-venc:CHECKED = NO
                            tg-desconsidera-ad-dupli-venc:CHECKED = NO.
    
                    DISABLE emitente.ind-aval
                            emitente.ind-aval-embarque
                            emitente.lim-credito
                            emitente.dt-lim-cred
                            emitente.lim-adicional
                            emitente.dt-fim-cred
							de-perc-max-dup-venc
							i-num-dias-max-dup-venc
                            l-desconsidera-antecip-na-dup-venc
                            tg-desconsidera-ad-dupli-venc.
                END.
            END.

            IF i-num-dias-max-dup-venc:SCREEN-VALUE in frame f-main > "0" THEN DO:
            ENABLE l-desconsidera-antecip-na-dup-venc
                   tg-desconsidera-ad-dupli-venc WITH FRAME {&FRAME-NAME}.
            END.
            ELSE DO:
            DISABLE l-desconsidera-antecip-na-dup-venc
		            tg-desconsidera-ad-dupli-venc with frame {&frame-name}.

            ASSIGN l-desconsidera-antecip-na-dup-venc:Screen-value = "NO"
		           tg-desconsidera-ad-dupli-venc:Screen-value = "NO".
            END.
        &ELSE
            ASSIGN i-ind-cre-cli = int(emitente.ind-cre-cli:SCREEN-VALUE IN FRAME {&frame-name}).
            IF i-ind-cre-cli <> 2 THEN 
                ENABLE emitente.ind-aval 
                       emitente.ind-aval-embarque
                       emitente.lim-credito
                       emitente.dt-lim-cred
                       emitente.lim-adicional
                       emitente.dt-fim-cred 
					   de-perc-max-dup-venc 
					   i-num-dias-max-dup-venc 
                       l-desconsidera-antecip-na-dup-venc 
                       tg-desconsidera-ad-dupli-venc WITH FRAME {&FRAME-NAME}.
            ELSE DO WITH FRAME {&FRAME-NAME}:
                ASSIGN  emitente.ind-aval:SCREEN-VALUE = "1"
                        emitente.ind-aval-embarque:SCREEN-VALUE = "1"
                        emitente.lim-credito:SCREEN-VALUE = "0"
                        emitente.dt-lim-cred:SCREEN-VALUE = ?
                        emitente.lim-adicional:SCREEN-VALUE = "0"
                        emitente.dt-fim-cred:SCREEN-VALUE = ?
						de-perc-max-dup-venc:screen-value = "0"
						i-num-dias-max-dup-venc:screen-value = "0"
                        l-desconsidera-antecip-na-dup-venc:CHECKED = NO
                        tg-desconsidera-ad-dupli-venc:CHECKED = NO.

                DISABLE emitente.ind-aval
                        emitente.ind-aval-embarque
                        emitente.lim-credito
                        emitente.dt-lim-cred
                        emitente.lim-adicional
                        emitente.dt-fim-cred
						de-perc-max-dup-venc
						i-num-dias-max-dup-venc
                        l-desconsidera-antecip-na-dup-venc
                        tg-desconsidera-ad-dupli-venc.
            END.

            IF i-num-dias-max-dup-venc:SCREEN-VALUE in frame f-main > "0" THEN DO:
               ENABLE l-desconsidera-antecip-na-dup-venc
                      tg-desconsidera-ad-dupli-venc WITH FRAME {&FRAME-NAME}.
            END.
            ELSE DO:
               DISABLE l-desconsidera-antecip-na-dup-venc
		               tg-desconsidera-ad-dupli-venc with frame {&frame-name}.

               ASSIGN l-desconsidera-antecip-na-dup-venc:Screen-value = "NO"
		              tg-desconsidera-ad-dupli-venc:Screen-value = "NO".
            END.
        &ENDIF
    &ENDIF   
    
    &IF '{&bf_dis_versao_ems}' >= '2.04' &THEN
        IF CAN-FIND(FIRST funcao
                    WHERE funcao.cd-funcao = 'spp-sgt':U
                    AND   funcao.ativo = TRUE NO-LOCK) THEN DISABLE emitente.ind-aval-embarque WITH FRAME {&frame-name}.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-multiplanta V-table-Win 
PROCEDURE pi-gera-multiplanta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   IF param-global.modulo-mp = YES THEN DO:
       /* ================= Integra‡Æo Multiplanta ================ */
       for each tt-dados-env NO-LOCK:
           delete tt-dados-env.
       end.

       assign c-transacao  = "DIS025".

       {cdp/cd7300.i5 "001" c-transacao "-EMI"}

       run pi-cria-tt-dados-dis025(input 2).

       {cdp/cd7300.i6 "001" c-transacao "-EMI"}

       /* ========================================================= */    
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "emitente"}

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


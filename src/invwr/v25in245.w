&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V25IN245 2.00.00.045}  /*** 010045 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v25in245 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

    def buffer b-natur-oper     for natur-oper.

    def var l-terceiros         as log                       no-undo.
    def var v-row-parent        as rowid                     no-undo.
    def var l-novo-reg          as log initial no            no-undo. 
    def var c-tipo              as char                      no-undo.
    def var l-setou-campo       as log                       no-undo.

    def var c-lista-itens       as char format "x(150)"      no-undo.
    def var i-tp-oper-terc      as int                       no-undo.
    def var l-ind-bipi          as log                       no-undo.

    def var c-item1             as char                      no-undo.
    def var c-item2             as char                      no-undo.
    def var c-item3             as char                      no-undo.
    def var c-item4             as char                      no-undo.
    def var c-item5             as char                      no-undo.
    def var c-item6             as char                      no-undo.
    def var c-item7             as char                      no-undo.

    def var c-char-2            as char                      no-undo.
    def var c-char-2-aux        as char                      no-undo.

    def var l-nf-fat-ent-fut    as log                       no-undo.
    def var l-primeiro          as log init yes              no-undo.
    def var c-formato           as char                      no-undo.
    def var c-nat-operacao      like natur-oper.nat-operacao no-undo.
    
    {cdp/cdcfgdis.i} /* defini‡Æo de pr‚-processadores distribui‡Æo */
    {cdp/cdcfgmat.i} /* defini‡Æo de pr‚-processadores materiais */
    {cdp/cd9999.i4}  /* Seta Fun‡Æo Embalagem */
    
    /* Integra‡Æo M¢dulo Importa‡Æo */
    def var l-modulo-imp as logical no-undo.
    def var i-trib-ii    as integer no-undo.
    def var c-lista-ii   as char    no-undo format "x(100)".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES natur-oper
&Scoped-define FIRST-EXTERNAL-TABLE natur-oper


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR natur-oper.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS natur-oper.terceiros natur-oper.transf ~
natur-oper.venda-ativo natur-oper.dec-1 natur-oper.imp-nota ~
natur-oper.nat-comp natur-oper.nota-rateio natur-oper.log-2 ~
natur-oper.ind-imprenda 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}dec-1 ~{&FP2}dec-1 ~{&FP3}~
 ~{&FP1}nat-comp ~{&FP2}nat-comp ~{&FP3}
&Scoped-define ENABLED-TABLES natur-oper
&Scoped-define FIRST-ENABLED-TABLE natur-oper
&Scoped-Define ENABLED-OBJECTS rt-mold-3 rt-mold-2 i-int-2 l-nota-propria ~
l-inss rt-dev 
&Scoped-Define DISPLAYED-FIELDS natur-oper.terceiros natur-oper.transf ~
natur-oper.venda-ativo natur-oper.dec-1 natur-oper.imp-nota ~
natur-oper.nat-comp natur-oper.nota-rateio natur-oper.log-2 ~
natur-oper.ind-imprenda 
&Scoped-Define DISPLAYED-OBJECTS cb-trib-ii l-altera-vl-terc ~
cb-tp-oper-terc cb-ind-bipi i-int-2 c-desc-nat-comp c-cod-natur-oper-bonif ~
c-desc-natur-oper-bonif l-nota-propria cb-tipo-compra l-inss ~
l-log-natureza-bonif l-gera-dev-valor l-log-oper-triang tx-dev 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS natur-oper.transf 
&Scoped-define ADM-MODIFY-FIELDS l-altera-vl-terc cb-tp-oper-terc ~
cb-ind-bipi i-int-2 c-cod-natur-oper-bonif cb-tipo-compra ~
l-log-natureza-bonif 

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
DEFINE VARIABLE cb-ind-bipi AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 20.57 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-compra AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 17.29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tp-oper-terc AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 21.14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-trib-ii AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributa‡Æo II" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 17.57 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-natur-oper-bonif AS CHARACTER FORMAT "x(06)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE c-desc-nat-comp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-natur-oper-bonif AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25.43 BY .79 NO-UNDO.

DEFINE VARIABLE tx-dev AS CHARACTER FORMAT "X(256)":U INITIAL "Nota Fiscal de Devolu‡Æo" 
      VIEW-AS TEXT 
     SIZE 19.43 BY .67 NO-UNDO.

DEFINE RECTANGLE rt-dev
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 55 BY 2.04.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58 BY 10.46.

DEFINE RECTANGLE rt-mold-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 27.29 BY 10.46.

DEFINE VARIABLE i-int-2 AS LOGICAL INITIAL no 
     LABEL "int-2" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE l-altera-vl-terc AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.57 BY .83.

DEFINE VARIABLE l-gera-dev-valor AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 39.29 BY .83 NO-UNDO.

DEFINE VARIABLE l-inss AS LOGICAL INITIAL no 
     LABEL "Ret‚m INSS na Fonte" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-log-natureza-bonif AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-log-oper-triang AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.29 BY .83 NO-UNDO.

DEFINE VARIABLE l-nota-propria AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.29 BY .83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     natur-oper.terceiros AT ROW 1.25 COL 2.57
          VIEW-AS TOGGLE-BOX
          SIZE 24.57 BY .83
     cb-trib-ii AT ROW 1.54 COL 48.86 COLON-ALIGNED
     l-altera-vl-terc AT ROW 2 COL 2.57
     cb-tp-oper-terc AT ROW 2.54 COL 48.86 COLON-ALIGNED
     natur-oper.transf AT ROW 2.75 COL 2.57
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .83
     natur-oper.venda-ativo AT ROW 3.5 COL 2.57
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .83
     natur-oper.dec-1 AT ROW 3.54 COL 48.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     natur-oper.imp-nota AT ROW 4.25 COL 2.57
          VIEW-AS TOGGLE-BOX
          SIZE 19.86 BY .83
     cb-ind-bipi AT ROW 4.54 COL 48.86 COLON-ALIGNED
     i-int-2 AT ROW 5 COL 2.57
     natur-oper.nat-comp AT ROW 5.54 COL 48.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     c-desc-nat-comp AT ROW 5.54 COL 59.43 COLON-ALIGNED NO-LABEL
     natur-oper.nota-rateio AT ROW 5.75 COL 2.57
          VIEW-AS TOGGLE-BOX
          SIZE 16.14 BY .83
     natur-oper.log-2 AT ROW 6.5 COL 2.57
          VIEW-AS TOGGLE-BOX
          SIZE 22.29 BY .83
     c-cod-natur-oper-bonif AT ROW 6.54 COL 48.86 COLON-ALIGNED
     c-desc-natur-oper-bonif AT ROW 6.54 COL 58 COLON-ALIGNED NO-LABEL
     l-nota-propria AT ROW 7.25 COL 2.57
     cb-tipo-compra AT ROW 7.54 COL 48.86 COLON-ALIGNED
     natur-oper.ind-imprenda AT ROW 8 COL 2.57
          VIEW-AS TOGGLE-BOX
          SIZE 19.57 BY .83
     l-inss AT ROW 8.79 COL 2.57
     l-log-natureza-bonif AT ROW 9.58 COL 2.57
     l-gera-dev-valor AT ROW 9.58 COL 32.43
     l-log-oper-triang AT ROW 10.38 COL 2.57
     tx-dev AT ROW 8.63 COL 30.43 COLON-ALIGNED NO-LABEL
     rt-mold-3 AT ROW 1 COL 1
     rt-mold-2 AT ROW 1 COL 28.43
     rt-dev AT ROW 8.88 COL 30.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.natur-oper
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
 /* MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.*/
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 10.5
         WIDTH              = 85.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R, COLUMNS                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-natur-oper-bonif IN FRAME f-main
   NO-ENABLE 3                                                          */
ASSIGN 
       c-cod-natur-oper-bonif:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-nat-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-natur-oper-bonif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-ind-bipi IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-tipo-compra IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-tp-oper-terc IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-trib-ii IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-trib-ii:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX i-int-2 IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX l-altera-vl-terc IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX l-gera-dev-valor IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       l-gera-dev-valor:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-log-natureza-bonif IN FRAME f-main
   NO-ENABLE 3                                                          */
ASSIGN 
       l-log-natureza-bonif:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-log-oper-triang IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       l-log-oper-triang:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       rt-dev:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX natur-oper.transf IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN tx-dev IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       tx-dev:HIDDEN IN FRAME f-main           = TRUE
       tx-dev:PRIVATE-DATA IN FRAME f-main     = 
                "Nota Fiscal de Devolu‡Æo".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-cod-natur-oper-bonif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-natur-oper-bonif V-table-Win
ON f5 OF c-cod-natur-oper-bonif IN FRAME f-main
DO:
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
 
&if defined (bf_dis_desc_bonif) &then
  l-implanta = yes.   
     {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                       &campo=c-cod-natur-oper-bonif
                       &campozoom=nat-operacao}
&endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-natur-oper-bonif V-table-Win
ON LEAVE OF c-cod-natur-oper-bonif IN FRAME f-main
DO:
 {include/leave.i &tabela=b-natur-oper     
                  &atributo-ref=denominacao
                  &variavel-ref=c-desc-natur-oper-bonif
                  &where="b-natur-oper.nat-operacao = input frame {&frame-name} c-cod-natur-oper-bonif"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-natur-oper-bonif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-natur-oper-bonif IN FRAME f-main
DO:
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
 
&if defined (bf_dis_desc_bonif) &then

  apply "F5" to self.

&endif


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tp-oper-terc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tp-oper-terc V-table-Win
ON VALUE-CHANGED OF cb-tp-oper-terc IN FRAME f-main
DO:
   if l-altera-vl-terc:checked      in frame {&frame-name} = yes     and
      (cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item2 or 
       cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item4 or 
       cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item5 or 
       cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item6) 
   then assign natur-oper.dec-1:sensitive in frame {&frame-name} = yes.
   else assign natur-oper.dec-1:sensitive in frame {&frame-name} = no.

     apply "leave" to natur-oper.terceiros in frame {&frame-name}.         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-altera-vl-terc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-altera-vl-terc V-table-Win
ON VALUE-CHANGED OF l-altera-vl-terc IN FRAME f-main
DO:
   if l-altera-vl-terc:checked      in frame {&frame-name} = yes     and
      (cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item2 or 
       cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item4 or 
       cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item5 or 
       cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item6) 
   then assign natur-oper.dec-1:sensitive in frame {&frame-name} = yes.
   else assign natur-oper.dec-1:sensitive in frame {&frame-name}    = no
               natur-oper.dec-1:screen-value in frame {&frame-name} = string(0).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-log-oper-triang
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-log-oper-triang V-table-Win
ON VALUE-CHANGED OF l-log-oper-triang IN FRAME f-main
DO:
  
    &if defined (bf_mat_oper_triangular) &then

        if  input frame {&frame-name} l-log-oper-triang = yes 
        and natur-oper.terceiros:checked in frame {&frame-name} = no
        and natur-oper.transf:checked in frame {&frame-name} = no
        then do with frame {&frame-name}:
            enable natur-oper.nat-comp.
            assign natur-oper.nat-comp:format in frame {&FRAME-NAME} = "x.xx-xxx".      
        end.
        else 
            if  natur-oper.transf:checked in frame {&frame-name} = no then do with frame {&frame-name}:
                disable natur-oper.nat-comp.
                assign natur-oper.nat-comp:screen-value in frame {&frame-name} = ""
                       c-desc-nat-comp:screen-value in frame {&frame-name} = "".
        end.

    &endif
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.nat-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-comp V-table-Win
ON F5 OF natur-oper.nat-comp IN FRAME f-main /* Natureza Complementar */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                       &campo=natur-oper.nat-comp
                       &campozoom=nat-operacao}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-comp V-table-Win
ON LEAVE OF natur-oper.nat-comp IN FRAME f-main /* Natureza Complementar */
DO:
  {include/leave.i &tabela=b-natur-oper
                   &atributo-ref=denominacao
                   &variavel-ref=c-desc-nat-comp
                   &where="b-natur-oper.nat-operacao = input frame {&frame-name} natur-oper.nat-comp"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-comp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.nat-comp IN FRAME f-main /* Natureza Complementar */
DO:

    apply "F5" to self.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.terceiros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.terceiros V-table-Win
ON LEAVE OF natur-oper.terceiros IN FRAME f-main /* Opera‡Æo com Terceiros */
DO:
/*****************************************************************************
***** Pr‚ Processor para 2.04 tratamento se for opera‡Æo com terceiros   *****
***** e for "remessa benificiamento" ou "remessa consigna‡Æo"            *****
***** pedir a natureza complementar para o modulo de embalagem           ***** 
*****************************************************************************/
    find param-global no-lock no-error.

     if avail param-global and param-global.dec-2 = 1 and 
        l-embalagem then do:
        if natur-oper.terceiros:checked in frame {&frame-name} and
           (cb-tp-oper-terc:screen-value in frame {&frame-name} = "Remessa Beneficiamento" or
           cb-tp-oper-terc:screen-value in frame {&frame-name} = "Remessa Consigna‡Æo") then do:
                enable natur-oper.nat-comp with frame {&frame-name}.
        end.
        else disable natur-oper.nat-comp with frame {&frame-name}.    
     end.

/**************************FIM PREPROCESSOR 2.04*********************************/  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.terceiros V-table-Win
ON VALUE-CHANGED OF natur-oper.terceiros IN FRAME f-main /* Opera‡Æo com Terceiros */
DO:
  if input frame {&frame-name} natur-oper.terceiros = no then do:
     assign natur-oper.transf:sensitive   in frame {&frame-name} = yes
            cb-tp-oper-terc:sensitive     in frame {&frame-name} = no
            natur-oper.dec-1:sensitive    in frame {&frame-name} = no
            l-altera-vl-terc:sensitive    in frame {&frame-name} = no
            l-altera-vl-terc:checked      in frame {&frame-name} = no
            natur-oper.dec-1:screen-value in frame {&frame-name} = string(0).

     {utp/ut-liter.i Remessa_Beneficiamento mce R}
     assign cb-tp-oper-terc:screen-value = trim(return-value).
  end.
  else do:
      assign natur-oper.transf:sensitive in frame {&frame-name} = no
             l-altera-vl-terc:sensitive  in frame {&frame-name} = yes
             cb-tp-oper-terc:sensitive   in frame {&frame-name} = yes.
      if l-altera-vl-terc:checked      in frame {&frame-name} = yes and
         (cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item2 or 
          cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item4 or 
          cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item5 or 
          cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item6) 
      then assign natur-oper.dec-1:sensitive in frame {&frame-name} = yes.
      else assign natur-oper.dec-1:sensitive in frame {&frame-name} = no.
  end.
  
  &if defined (bf_mat_oper_triangular) &then
      if  input frame {&frame-name } l-log-oper-triang = yes 
      and input frame {&frame-name} natur-oper.terceiros = no then do with frame {&frame-name}:
          enable  natur-oper.nat-comp.
          assign natur-oper.nat-comp:format in frame {&FRAME-NAME} = "x.xx-xxx".      
      end.
      else do with frame {&FRAME-NAME}:
          disable natur-oper.nat-comp.
          display "" @ natur-oper.nat-comp.
      end.
  &endif
  
     apply "leave" to natur-oper.terceiros in frame {&frame-name}.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.transf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.transf V-table-Win
ON VALUE-CHANGED OF natur-oper.transf IN FRAME f-main /* Opera‡äes Transferˆncia */
DO:

  if natur-oper.transf:checked in frame {&frame-name} = no then do with frame {&frame-name}:
      enable  natur-oper.terceiros.
  end.
  else do with frame {&FRAME-NAME}:
      disable natur-oper.terceiros.
  end.    

  if  input frame {&frame-name} natur-oper.transf = yes 
  and param-global.modulo-mp 
  
  &if defined (bf_mat_oper_triangular) &then
      or (    input frame {&frame-name } l-log-oper-triang = yes 
          and input frame {&frame-name} natur-oper.transf = no )  
  &endif
     
  then do with frame {&frame-name}:
     
     enable  natur-oper.nat-comp.
     assign natur-oper.nat-comp:format in frame {&FRAME-NAME} = "x.xx-xxx".      
  end.
  else do with frame {&FRAME-NAME}:
      disable natur-oper.nat-comp.
      display "" @ natur-oper.nat-comp.
     
  end.
 

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

    {utp/ut-field.i mgind natur-oper tp-oper-terc 1}
    assign cb-tp-oper-terc:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Base_IPI * r}
     assign cb-ind-bipi:label in frame {&frame-name} = trim(return-value).

    
    {utp/ut-liter.i Varia‡Æo_Valor_Itens_Terceiros * L}
    assign natur-oper.dec-1:label in frame {&frame-name} = trim(return-value).

    assign natur-oper.dec-1:format in frame {&frame-name} = ">>9.99":U.

    {utp/ut-liter.i Venda_Ambulante * L}
    assign i-int-2:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Compra/Venda_Ativo * L}
    assign natur-oper.venda-ativo:label in frame {&frame-name} = trim(return-value)
           natur-oper.venda-ativo:help in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Nota_Comercio * L}
    assign natur-oper.log-2:label in frame {&frame-name} = trim(return-value).
                          
    {utp/ut-liter.i Nota_Pr¢pria * R}
    assign l-nota-propria:label in frame {&frame-name} = trim(return-value).
    
    if natur-oper.nat-comp:load-mouse-pointer("image/lupa.cur")
        in frame {&frame-name} then .

    {utp/ut-liter.i Ret‚m_INSS_na_Fonte * R}
    assign l-inss:label in frame {&FRAME-NAME} = return-value.

/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
 
    &if defined (bf_dis_desc_bonif) &then
        {utp/ut-liter.i Natureza_Bonifica‡Æo * R}
        assign l-log-natureza-bonif:label in frame {&frame-name} = return-value.
        {utp/ut-liter.i Natur_Oper_Bonif * R}
        assign c-cod-natur-oper-bonif:label in frame {&frame-name} = trim(return-value).
        if c-cod-natur-oper-bonif:load-mouse-pointer("image/lupa.cur")
        in frame {&frame-name} then.
    &endif
    
 /*********************************************************** 
 *  Pr‚-Processador para Opera‡Æo Triangular - release 2.03 *
 ***********************************************************/
     &if defined (bf_mat_oper_triangular) &then
        {utp/ut-liter.i Opera‡Æo_Triangular * R}
        assign l-log-oper-triang:label in frame {&frame-name} = return-value.
    &endif
 /**********************************************************/    
    
 /******************************************************
 * Pr‚-processador utilizado para fazer a tradu‡Æo     *
 * do label do combo-box cb-tipo-compra - release 2.03 *
 ******************************************************/         
 &if defined (bf_mat_natur_compra_re) &then
    {utp/ut-liter.i Tipo_Compra * R}
    assign cb-tipo-compra:label in frame {&frame-name} = trim(return-value).
 &endif
 /*****************************************************/

&if defined(bf_dis_versao_ems) &then
    &if {&bf_dis_versao_ems} >= 2.02 &then
        {utp/ut-liter.i Gera_Devolu‡Æo_Somente_de_Valor}
        assign l-gera-dev-valor:label in frame {&frame-name} = trim(return-value).    
    &endif
&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "natur-oper"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "natur-oper"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
  
 /*********************************************************** 
 *  Pr‚-Processador para Opera‡Æo Triangular - release 2.03 *
 ***********************************************************/
     &if defined (bf_mat_oper_triangular) &then
        assign l-log-oper-triang:checked in frame {&frame-name} = no.
     &endif
 /**********************************************************/


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .  

  
  {utp/ut-liter.i Venda_Ambulante * L}
  assign i-int-2:label in frame {&frame-name} = trim(return-value).
  assign i-int-2:checked in frame {&frame-name} = no.

  {utp/ut-liter.i Compra/Venda_Ativo * L}
  assign natur-oper.venda-ativo:label in frame {&frame-name} = trim(return-value)
         natur-oper.venda-ativo:help in frame {&frame-name} = trim(return-value).
  
  if {ininc/i06in245.i 06 c-tipo} = 2 then
      assign natur-oper.imp-nota:checked in frame {&frame-name} = no.

  if  l-terceiros then                    
      assign natur-oper.transf:checked in frame {&frame-name} = no.

  disable cb-tp-oper-terc with frame {&frame-name}.
  assign l-altera-vl-terc:sensitive in frame {&frame-name} = no.
  
  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i Altera_Valor_Itens_Terc * R}
  assign l-altera-vl-terc:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Ret‚m_INSS_na_Fonte * R}
  assign l-inss:label in frame {&FRAME-NAME} = return-value
         l-inss:checked in frame {&FRAME-NAME} = no.

/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
  
 &if defined (bf_dis_desc_bonif) &then
      assign l-log-natureza-bonif:hidden in frame {&frame-name}    = no
             c-cod-natur-oper-bonif:hidden in frame {&frame-name}  = no
             c-desc-natur-oper-bonif:hidden in frame {&frame-name} = no
             c-cod-natur-oper-bonif:screen-value in frame {&frame-name} = ""
             c-cod-natur-oper-bonif:format in frame {&frame-name} = "xxxxxx"
             l-log-natureza-bonif:checked in frame {&frame-name}    = no.
 &else
      assign l-log-natureza-bonif:hidden in frame {&frame-name}    = yes
             c-cod-natur-oper-bonif:hidden in frame {&frame-name}  = yes
             c-desc-natur-oper-bonif:hidden in frame {&frame-name} = yes.
 &endif
 
 /******************************************************
 * Pr‚-processador utilizado para esconder o combo-box *
 * cb-tipo-compra quando o release for menor que 2.03  *
 ******************************************************/         
 &if defined (bf_mat_natur_compra_re) &then
    assign cb-tipo-compra:hidden in frame {&frame-name} = no.
 &else 
    assign cb-tipo-compra:hidden in frame {&frame-name} = yes.  
 &endif
 /*****************************************************/         
 
  /* Integra‡Æo M¢dulo Importa‡Æo */
  if l-modulo-imp then
    assign cb-trib-ii:screen-value in frame {&frame-name} = {ininc/i10in172.i 04 1}.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  def var c-trib-ii as char format "x(10)" no-undo.
    
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}

/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
   
  &if defined (bf_dis_desc_bonif) &then
   assign input frame {&frame-name} l-log-natureza-bonif
         input frame {&frame-name} c-cod-natur-oper-bonif.
  &endif
  
/************************************************************/

 /*********************************************************** 
 *  Pr‚-Processador para Opera‡Æo Triangular - release 2.03 *
 ***********************************************************/
     &if defined (bf_mat_oper_triangular) &then
        assign input frame {&frame-name} l-log-oper-triang. 
     &endif
 /**********************************************************/

  if input frame {&frame-name} cb-tp-oper-terc = c-item1 then 
      assign i-tp-oper-terc = 1.
  if input frame {&frame-name} cb-tp-oper-terc = c-item2 then
      assign i-tp-oper-terc = 2.
  if input frame {&frame-name} cb-tp-oper-terc = c-item3 then
      assign i-tp-oper-terc = 3.
  if input frame {&frame-name} cb-tp-oper-terc = c-item4 then
      assign i-tp-oper-terc = 4.
  if input frame {&frame-name} cb-tp-oper-terc = c-item5 then
      assign i-tp-oper-terc = 5.
  if input frame {&frame-name} cb-tp-oper-terc = c-item6 then
      assign i-tp-oper-terc = 6.
/************************************************************ 
 *  Pr‚-Processador para o cb-tp-oper-terc = 7 (Drawback)   *
 *  release - 2.03                                          *
 ************************************************************/     
  &if defined (bf_dis_versao_ems) &then
     &if {&bf_dis_versao_ems} >= 2.03 &then
        if input frame {&frame-name} cb-tp-oper-terc = c-item7 then
           assign i-tp-oper-terc = 7.  
     &endif    
  &endif   
   
  assign input frame {&frame-name} l-nota-propria
         input frame {&frame-name} cb-ind-bipi
         input frame {&FRAME-NAME} l-inss
         input frame {&frame-name} l-altera-vl-terc.

  /************************************************************ 
  *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
  ************************************************************/
 
  &if defined (bf_dis_desc_bonif) &then
     if input frame {&frame-name} c-cod-natur-oper-bonif <> "" then do:
        find b-natur-oper where
             b-natur-oper.nat-operacao = input frame {&frame-name} c-cod-natur-oper-bonif no-lock no-error.
        if  not avail b-natur-oper then do: 
            {utp/ut-table.i mgind natur-oper 1}
            run utp/ut-msgs.p (input "show",
                               input 47,
                               input return-value).
            apply 'entry' to c-cod-natur-oper-bonif in frame {&frame-name}.
            return 'adm-error'.
        end.
     end.
  &endif
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  if RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.
      
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
      
   &if defined (bf_dis_desc_bonif) &then
    assign natur-oper.log-natureza-bonif   = l-log-natureza-bonif
           natur-oper.cod-natur-oper-bonif = c-cod-natur-oper-bonif.
   &endif
   
/************************************************************/   

 /*********************************************************** 
 *  Pr‚-Processador para Opera‡Æo Triangular - release 2.03 *
 ***********************************************************/
     &if defined (bf_mat_oper_triangular) &then
/*         if  not natur-oper.terceiro
 *          or (    natur-oper.terceiro
 *              and natur-oper.tp-oper-terc = 1) then */
             assign natur-oper.log-oper-triang = l-log-oper-triang. 
     &endif
 /**********************************************************/                   

   assign substring(natur-oper.char-2,71,5) = if l-inss 
                                              then "1    " else "2    "
          substr(natur-oper.char-2,36,5)    = if l-altera-vl-terc
                                              then "1    " else "2    "
          l-ind-bipi                        = {varinc/var00074.i 06 cb-ind-bipi} = 1
          substr(natur-oper.char-2,11,5)    = if l-ind-bipi 
                                              then "1    " else "2    "
          natur-oper.tp-oper-terc           = i-tp-oper-terc
          natur-oper.int-1                  = if l-nota-propria
                                              then 1
                                              else 0.

/*************************************************
 * Pr‚-processador utilizado para a grava‡Æo do  *
 * conte£do do combo-box cb-tipo-compra na base  *
 * de dados - release 2.03                       *
 ************************************************/         
 &if defined (bf_mat_natur_compra_re) &then
  if avail natur-oper then
    assign natur-oper.tipo-compra = {ininc/i09in245.i 06 cb-tipo-compra}.
 &endif
 /***********************************************/

 /*********************************************************** 
 *  Pr‚-Processador para versÆo EMS - release 2.02          *
 ***********************************************************/

  &if defined(bf_dis_versao_ems) &then
       &if {&bf_dis_versao_ems} >= 2.02 &then
           assign substr(natur-oper.char-2,88,5) = if  input frame {&frame-name} l-gera-dev-valor
                                                       then "1    " 
                                                       else "2    ".
       &endif
   &endif
 /**********************************************************/ 
 
  /* Integra‡Æo M¢dulo Importa‡Æo */
  if l-modulo-imp and avail natur-oper then do:
    assign input frame {&frame-name} cb-trib-ii.
    assign substring(natur-oper.char-1,10,2) = string({ininc/i10in172.i 06 cb-trib-ii},"99").
  end. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  
  if i-int-2:checked in frame {&FRAME-NAME} = no then
     assign natur-oper.int-2 = 0. 
  if i-int-2:checked in frame {&FRAME-NAME} = yes  then
     assign natur-oper.int-2 = 1. 

  if l-nota-propria:checked in frame {&FRAME-NAME} = yes then 
     assign natur-oper.int-1 = 1.
  else assign natur-oper.int-1 = 0.  


  /* Code placed here will execute AFTER standard behavior.    */

 /************************************************
 * Pr‚-processador utilizado para a grava‡Æo do  *
 * conte£do do combo-box cb-tipo-compra na base  *
 * de dados - release 2.03                       *
 ************************************************/         
 &if defined (bf_mat_natur_compra_re) &then
    assign input frame {&frame-name} cb-tipo-compra natur-oper.tipo-compra = 
           {ininc/i09in245.i 06 cb-tipo-compra}.
 &endif
 /***********************************************/

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
  
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
  
   &if defined (bf_dis_desc_bonif) &then
      assign l-log-natureza-bonif:hidden in frame {&frame-name}    = no
             c-cod-natur-oper-bonif:hidden in frame {&frame-name}  = no
             c-desc-natur-oper-bonif:hidden in frame {&frame-name} = no.
 &else
      assign l-log-natureza-bonif:hidden in frame {&frame-name}    = yes
             c-cod-natur-oper-bonif:hidden in frame {&frame-name}  = yes
             c-desc-natur-oper-bonif:hidden in frame {&frame-name} = yes.
      
 &endif
 
 /******************************************************
 * Pr‚-processador utilizado para esconder o combo-box *
 * cb-tipo-compra quando o release for menor que 2.03  *
 ******************************************************/         
 &if defined (bf_mat_natur_compra_re) &then
    assign cb-tipo-compra:hidden in frame {&frame-name} = no.
 &else 
    assign cb-tipo-compra:hidden in frame {&frame-name} = yes.  
 &endif
 /*****************************************************/

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

    assign l-novo-reg       = no
           l-setou-campo    = no
           l-nf-fat-ent-fut = no.
           
    assign l-inss:sensitive in frame {&FRAME-NAME} = no.

    &if defined(bf_dis_versao_ems) &then
         &if {&bf_dis_versao_ems} >= 2.02 &then
             assign l-gera-dev-valor:sensitive in frame {&frame-name} = no.
         &endif
    &endif    
               
  /* Code placed here will execute AFTER standard behavior.    */
  
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

 /*********************************************************** 
 *  Pr‚-Processador para Opera‡Æo Triangular - release 2.03 *
 ***********************************************************/
  &if defined(bf_mat_oper_triangular) &then
      assign l-log-oper-triang:sensitive in frame {&frame-name} = no. 
  &endif    
 /***********************************************************/       
 
  /* Integra‡Æo M¢dulo Importa‡Æo */
  if l-modulo-imp then do:
    disable cb-trib-ii with frame {&frame-name}.
  end.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if avail natur-oper then do with frame {&frame-name}:

     if trim(substring(natur-oper.char-2,11,1)) <> "" then
        assign cb-ind-bipi:screen-value = {varinc/var00074.i 04 int(substring(natur-oper.char-2,11,5))}.
     end.
     else assign cb-ind-bipi:screen-value = {varinc/var00074.i 04 01}.
    
  if avail natur-oper then do:
  
    if substring(natur-oper.char-2,71,5) = "1" then
       assign l-inss:checked in frame {&FRAME-NAME} = yes.
    else
       assign l-inss:checked in frame {&FRAME-NAME} = no.

     if natur-oper.int-2 = 0 then 
        assign i-int-2:checked in frame {&frame-name} = no.
     else do:
        if natur-oper.int-2 = 1 then 
           assign i-int-2:checked in frame {&frame-name} = yes.
     end.
  end.

  if  avail natur-oper then do with frame {&frame-name}:
       
      if substring(natur-oper.char-2,36,5) = "1    " then
         assign l-altera-vl-terc:checked = yes.
      else assign l-altera-vl-terc:checked = no.

      if  natur-oper.tp-oper-terc = 1 then do:
          {utp/ut-liter.i Remessa_Beneficiamento mce R}
          assign cb-tp-oper-terc:screen-value = trim(return-value).
      end.
     
      if  natur-oper.tp-oper-terc = 2 then do:
          {utp/ut-liter.i Retorno_Beneficiamento mce R}
          assign cb-tp-oper-terc:screen-value = trim(return-value).
      end.
     
      if  natur-oper.tp-oper-terc = 3 then do:
          {utp/ut-liter.i Remessa_Consigna‡Æo mce R}
          assign cb-tp-oper-terc:screen-value = trim(return-value).
      end.

      if  natur-oper.tp-oper-terc = 4 then do:
          {utp/ut-liter.i Faturamento_Consigna‡Æo mce R}
          assign cb-tp-oper-terc:screen-value = trim(return-value).
      end.

      if  natur-oper.tp-oper-terc = 5 then do:
          {utp/ut-liter.i Devolu‡Æo_Consigna‡Æo mce R}
          assign cb-tp-oper-terc:screen-value = trim(return-value).
      end.

      if  natur-oper.tp-oper-terc = 6 then do:
          {utp/ut-liter.i Reajuste_Pre‡o mce R}
          assign cb-tp-oper-terc:screen-value = trim(return-value).
      end.
/************************************************************ 
 *  Pr‚-Processador para o cb-tp-oper-terc = 7 (Drawback)   *
 *  release - 2.03, atualizar o screen-value = Drawback     *
 ************************************************************/      
      &if defined (bf_dis_versao_ems)  &then
        &if {&bf_dis_versao_ems} >= 2.03 &then
            if  natur-oper.tp-oper-terc = 7 then do:
                {utp/ut-liter.i Drawback mce R}
                assign cb-tp-oper-terc:screen-value = trim(return-value).
            end.      
        &endif
      &endif        
  end.
  else do with frame {&frame-name}:
        {utp/ut-liter.i Remessa_Beneficiamento mce R}
        assign cb-tp-oper-terc:screen-value = trim(return-value).
  end.
    
   find b-natur-oper where 
        b-natur-oper.nat-operacao = input frame {&frame-name} natur-oper.nat-comp no-lock no-error.

   if  avail b-natur-oper then do:
       assign c-desc-nat-comp:screen-value in frame {&frame-name} = if  available b-natur-oper 
                                                                        then b-natur-oper.denominacao
                                                                        else "":U.
   end.

   if  avail natur-oper then do:
       if  natur-oper.int-1 = 1 then
           assign l-nota-propria:checked in frame {&frame-name} = true.
       else
           assign l-nota-propria:checked in frame {&frame-name} = false.     
   end.

   assign l-nota-propria:sensitive in frame {&frame-name} = no
          i-int-2:sensitive        in frame {&frame-name} = no.

/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/

   &if defined (bf_dis_desc_bonif) &then
       if  avail natur-oper then do:
           do  with frame {&frame-name}:
               assign l-log-natureza-bonif:checked = natur-oper.log-natureza-bonif
                      c-cod-natur-oper-bonif:screen-value = natur-oper.cod-natur-oper-bonif.
           end.
       end.
       find b-natur-oper where 
            b-natur-oper.nat-operacao = input frame {&frame-name} c-cod-natur-oper-bonif no-lock no-error.
       assign c-desc-natur-oper-bonif:screen-value in frame {&frame-name} = if  available b-natur-oper 
                                                                                then b-natur-oper.denominacao
                                                                                else "":U.
  &endif
  
 /*********************************************************** 
 *  Pr‚-Processador para Opera‡Æo Triangular - release 2.03 *
 ***********************************************************/
     &if defined (bf_mat_oper_triangular) &then
        if avail natur-oper then 
            assign l-log-oper-triang:checked = natur-oper.log-oper-triang.
     &endif
 /**********************************************************/
  

/*****************************************************
 * Pr‚-processador utilizado para apresentar o valor *
 * caracter correspondente ao valor inteiro do campo *
 * indicador cb-tipo-compra - release 2.03           *
 ****************************************************/         
 &if defined (bf_mat_natur_compra_re) &then
    if avail natur-oper then 
       assign cb-tipo-compra:screen-value in frame {&frame-name} = {ininc/i09in245.i 04 natur-oper.tipo-compra}.
    else 
       assign cb-tipo-compra:screen-value in frame {&frame-name} = {ininc/i09in245.i 04 1}.   
 &endif
/**************************************************/

 /*********************************************************** 
 *  Pr‚-Processador para versÆo EMS - release 2.02          *
 ***********************************************************/

  &if defined(bf_dis_versao_ems) &then
       &if {&bf_dis_versao_ems} >= 2.02 &then
            if substring(natur-oper.char-2,88,5) = "1" then
               assign l-gera-dev-valor:checked in frame {&FRAME-NAME} = yes.
            else
               assign l-gera-dev-valor:checked in frame {&FRAME-NAME} = no.
       &endif
   &endif
 /**********************************************************/

/*****************************************************************************
***** Pr‚ Processor para 2.04 tratamento se for opera‡Æo com terceiros   *****
***** e for "remessa benificiamento" ou "remessa consigna‡Æo"            *****
***** pedir a natureza complementar para o modulo de embalagem           ***** 
*****************************************************************************/
    find param-global no-lock no-error.
     if avail param-global and param-global.dec-2 = 1 and 
        l-embalagem then do:
        if natur-oper.terceiros:checked in frame {&frame-name} and
           (cb-tp-oper-terc:screen-value in frame {&frame-name} = "Remessa Beneficiamento" or
           cb-tp-oper-terc:screen-value in frame {&frame-name} = "Remessa Consigna‡Æo") then do:
           assign natur-oper.nat-comp:screen-value in frame {&frame-name} = 
                  natur-oper.nat-comp.
        end.
        else disable natur-oper.nat-comp with frame {&frame-name}.    
     end.
/**************************FIM PREPROCESSOR 2.04*********************************/

  /* Integra‡Æo M¢dulo Importa‡Æo */
  if l-modulo-imp and avail natur-oper and not adm-new-record then do:
    assign i-trib-ii = integer(substring(natur-oper.char-1,10,2)).
    if i-trib-ii <> 0 then
        assign cb-trib-ii:screen-value in frame {&frame-name} = {ininc/i10in172.i 04 i-trib-ii}.
    else
        assign cb-trib-ii:screen-value in frame {&frame-name} = " ".
  end.

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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  

  if input frame {&frame-name} natur-oper.terceiros:checked = yes
     then assign natur-oper.transf:sensitive in frame {&frame-name} = no
                 l-altera-vl-terc:sensitive  in frame {&frame-name} = yes
                 cb-tp-oper-terc:sensitive   in frame {&frame-name} = yes.
     else assign natur-oper.transf:sensitive in frame {&frame-name} = yes
                 l-altera-vl-terc:sensitive  in frame {&frame-name} = no
                 l-altera-vl-terc:checked    in frame {&frame-name} = no
                 cb-tp-oper-terc:sensitive   in frame {&frame-name} = no.
                 
  if  input frame {&frame-name} natur-oper.transf:checked = yes then 
      assign natur-oper.terceiros:sensitive in frame {&frame-name} = no.

  if  (natur-oper.transf:checked in frame {&frame-name} = yes 
  and param-global.modulo-mp) 
  &if defined (bf_mat_oper_triangular) &then
      or  (    natur-oper.log-oper-triang
           and not natur-oper.terceiros )
  &endif       
  then
      assign natur-oper.nat-comp:sensitive in frame {&frame-name} = yes.
  else 
      assign natur-oper.nat-comp:sensitive in frame {&frame-name} = no.

  if l-altera-vl-terc:checked      in frame {&frame-name} = yes     and
     (cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item2 or
      cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item4 or
      cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item5 or
      cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item6)
  then assign natur-oper.dec-1:sensitive in frame {&frame-name} = yes.
  else assign natur-oper.dec-1:sensitive in frame {&frame-name} = no.

  if  avail natur-oper then do:
      if substring(natur-oper.char-2,36,5) = "1    " then
         assign l-altera-vl-terc:checked = yes.
      else assign l-altera-vl-terc:checked = no.
  end.

  &if defined(bf_dis_versao_ems) &then
       &if {&bf_dis_versao_ems} >= 2.02 &then
             if  avail natur-oper and
                       natur-oper.especie-doc = "NFD" then
                 assign l-gera-dev-valor:sensitive in frame {&frame-name} = yes.
             else  
                 assign l-gera-dev-valor:sensitive in frame {&frame-name} = no.
       &endif
  &endif
  
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
    &if defined (bf_dis_desc_bonif) &then
       assign l-log-natureza-bonif:sensitive in frame {&frame-name} = yes.
       assign c-cod-natur-oper-bonif:sensitive in frame {&frame-name} = yes.
       if natur-oper.cod-natur-oper-bonif = "" then do:
          assign c-cod-natur-oper-bonif:screen-value in frame {&frame-name} = ""
                 c-cod-natur-oper-bonif:format in frame {&frame-name} = "xxxxxx".
       end.
  &endif
  
/************************************************************/


 /*********************************************************** 
 *  Pr‚-Processador para Opera‡Æo Triangular - release 2.03 *
 ***********************************************************/
     &if defined (bf_mat_oper_triangular) &then
         assign l-log-oper-triang:sensitive in frame {&frame-name} = yes. 
     &endif
 /**********************************************************/


  assign l-nota-propria:sensitive in frame {&frame-name} = yes
         l-inss:sensitive         in frame {&FRAME-NAME} = yes.

  assign l-novo-reg = yes.
  run pi-inicializa-campo (yes).

  if not adm-new-record then do:
     apply "leave" to natur-oper.terceiros in frame {&frame-name}.
/*****************************************************************************
***** Pr‚ Processor para 2.04 tratamento se for opera‡Æo com terceiros   *****
***** e for "remessa benificiamento" ou "remessa consigna‡Æo"            *****
***** pedir a natureza complementar para o modulo de embalagem           ***** 
*****************************************************************************/
    find param-global no-lock no-error.
     if avail param-global and param-global.dec-2 = 1 and 
        l-embalagem then do:
        if natur-oper.terceiros:checked in frame {&frame-name} and
           (cb-tp-oper-terc:screen-value in frame {&frame-name} = "Remessa Beneficiamento" or
           cb-tp-oper-terc:screen-value in frame {&frame-name} = "Remessa Consigna‡Æo") then do:
           assign natur-oper.nat-comp:screen-value in frame {&frame-name} = 
                  natur-oper.nat-comp.
        end.
        else disable natur-oper.nat-comp with frame {&frame-name}.    
    end.
/**************************FIM PREPROCESSOR 2.04*********************************/ 
  end.
  
  /* Integra‡Æo M¢dulo Importa‡Æo */
  if l-modulo-imp then do:
    enable cb-trib-ii with frame {&frame-name}.
  end.   

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
      assign cb-ind-bipi:list-items = {varinc/var00074.i 03}.
end.

 /*********************************************************** 
 *  Pr‚-Processador para Opera‡Æo Triangular - release 2.03 *
 ***********************************************************/
     &if defined (bf_mat_oper_triangular) &then
        assign l-log-oper-triang:hidden in frame {&frame-name} = no. 
     &endif
 /**********************************************************/

 /*********************************************************** 
 *  Pr‚-Processador para versÆo EMS - release 2.02          *
 ***********************************************************/

     &if defined(bf_dis_versao_ems) &then
          &if {&bf_dis_versao_ems} >= 2.02 &then
              assign l-gera-dev-valor:hidden in frame {&frame-name} = no
                     rt-dev:hidden           in frame {&frame-name} = no
                     tx-dev:hidden           in frame {&frame-name} = no.

          &else
            assign l-gera-dev-valor:hidden in frame {&frame-name} = yes
                   rt-dev:hidden           in frame {&frame-name} = yes
                   tx-dev:hidden           in frame {&frame-name} = yes.
          &endif
      &else
        assign l-gera-dev-valor:hidden in frame {&frame-name} = yes
               rt-dev:hidden           in frame {&frame-name} = yes
               tx-dev:hidden           in frame {&frame-name} = yes.        
      &endif
 /**********************************************************/   

  {utp/ut-liter.i Remessa_Beneficiamento mce R}
  assign c-lista-itens = return-value + ","
         c-item1 = return-value.

  {utp/ut-liter.i Retorno_Beneficiamento mce R}
  assign c-lista-itens = c-lista-itens + return-value + ","
         c-item2 = return-value.

  {utp/ut-liter.i Remessa_Consigna‡Æo mce R}
  assign c-lista-itens = c-lista-itens + return-value + ","
         c-item3 = return-value.

  {utp/ut-liter.i Faturamento_Consigna‡Æo mce R}
  assign c-lista-itens = c-lista-itens + return-value + ","
         c-item4 = return-value.

  {utp/ut-liter.i Devolu‡Æo_Consigna‡Æo mce R}
  assign c-lista-itens = c-lista-itens + return-value + ","
         c-item5 = return-value.

  {utp/ut-liter.i Reajuste_Pre‡o mce R}
  assign c-lista-itens = c-lista-itens + return-value
         c-item6 = return-value.

/************************************************************ 
 *  Pr‚-Processador para o cb-tp-oper-terc = 7 (Drawback)   *
 *  release - 2.03 carrega o list-itens do combo-box com a  *
 *  op‡Æo Drawback                                          *
 ************************************************************/     
 &if defined (bf_dis_versao_ems) &then
  &if {&bf_dis_versao_ems} >= 2.03 &then
    {utp/ut-liter.i Drawback mce R}
    assign c-lista-itens =  c-lista-itens + "," + return-value
           c-item7 = return-value.
  &endif           
 &endif
 
  do with frame {&frame-name}:
      assign cb-tp-oper-terc:list-items = c-lista-itens.
  end.        
  
  assign l-altera-vl-terc:checked in frame {&frame-name} = false
         l-altera-vl-terc:sensitive in frame {&frame-name} = no.
 
/***************************************************
 * Pr‚-processador utilizado para a prepara‡Æo do  *
 * list-items da vari vel combo-box cb-tipo-compra *
 * na release 2.03                                 *
 **************************************************/         
 &if defined (bf_mat_natur_compra_re) &then
    assign cb-tipo-compra:list-items in frame {&frame-name} = {ininc/i09in245.i 03}.
 &endif
/**************************************************/

    /* Code placed here will execute AFTER standard behavior.    */
  
    assign l-nota-propria:sensitive in frame {&frame-name} = no
           l-inss:sensitive         in frame {&FRAME-NAME} = no.

  find first param-global no-lock no-error.
  
  {utp/ut-liter.i Altera_Valor_Itens_Terc * R}
  assign l-altera-vl-terc:label in frame {&frame-name} = return-value.
  
  if not adm-new-record then 
     disable natur-oper.nat-comp with frame {&frame-name}.
  else 
     if (natur-oper.transf:checked in frame {&frame-name} = yes 
     and param-global.modulo-mp) 
     &if defined (bf_mat_oper_triangular) &then
         or natur-oper.log-oper-triang
     &endif       
     then
        enable  natur-oper.nat-comp with frame {&frame-name}.
     else 
        disable natur-oper.nat-comp with frame {&frame-name}.



        
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
         
 &if defined (bf_dis_desc_bonif) &then
      assign l-log-natureza-bonif:hidden in frame {&frame-name}    = no
             c-cod-natur-oper-bonif:hidden in frame {&frame-name}  = no
             c-desc-natur-oper-bonif:hidden in frame {&frame-name} = no.
 &else
      assign l-log-natureza-bonif:hidden in frame {&frame-name}    = yes
             c-cod-natur-oper-bonif:hidden in frame {&frame-name}  = yes
             c-desc-natur-oper-bonif:hidden in frame {&frame-name} = yes.
      
 &endif
 
 /******************************************************
 * Pr‚-processador utilizado para esconder o combo-box *
 * cb-tipo-compra quando o release for menor que 2.03  *
 ******************************************************/         
 &if defined (bf_mat_natur_compra_re) &then
    assign cb-tipo-compra:hidden in frame {&frame-name} = no.
 &else 
    assign cb-tipo-compra:hidden in frame {&frame-name} = yes.  
 &endif
 /*****************************************************/  
 
    /* Integra‡Æo M¢dulo Importa‡Æo */
    if avail param-global and param-global.modulo-07 then do:
        assign c-lista-ii                                   = {ininc/i10in172.i 03}
               c-lista-ii                                   = c-lista-ii + "," + " ".
        assign l-modulo-imp                                 = yes
               cb-trib-ii:hidden in frame {&frame-name}     = no
               cb-trib-ii:list-items in frame {&frame-name} = c-lista-ii.
    end. 
  
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     define input parameter v-row-parent-externo as rowid no-undo.
     
     assign v-row-parent = v-row-parent-externo.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-esconde-campo-tela V-table-Win 
PROCEDURE pi-esconde-campo-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Esta procedure somente ‚ executada por um pr‚-processador "desc_bonif".
         NÆo eliminar esta procedure.      
------------------------------------------------------------------------------*/
 
 assign l-log-natureza-bonif:hidden in frame {&frame-name}    = yes
        c-cod-natur-oper-bonif:hidden in frame {&frame-name}  = yes
        c-desc-natur-oper-bonif:hidden in frame {&frame-name} = yes.       
              

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos V-table-Win 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param c-campo    as char no-undo.
    def input param l-habilita as log no-undo.
    
    if  c-campo = "nat-comp" then do:
        assign natur-oper.nat-comp:sensitive in frame {&FRAME-NAME} = l-habilita.
        
        if  l-habilita then 
            assign l-nf-fat-ent-fut                                  = yes
                   natur-oper.nat-comp:format in frame {&FRAME-NAME} = "x.xx-xxx".
        else
            assign l-nf-fat-ent-fut                                        = no
                   natur-oper.nat-comp:screen-value in frame {&FRAME-NAME} = ""
                   c-desc-nat-comp:screen-value     in frame {&FRAME-NAME} = "".
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-gera-dev-vl V-table-Win 
PROCEDURE pi-habilita-gera-dev-vl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param l-hab-gera-dev-vl as log no-undo.

    &if defined(bf_dis_versao_ems) &then
        &if {&bf_dis_versao_ems} >= 2.02 &then
            assign l-gera-dev-valor:sensitive in frame {&frame-name} = l-hab-gera-dev-vl
                   l-gera-dev-valor:checked   in frame {&frame-name} = no.
        &endif
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campo V-table-Win 
PROCEDURE pi-inicializa-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-seta-campo as logical no-undo.

    if  l-novo-reg then do:

        RUN Get-Field-Screen-Value IN adm-broker-hdl
            (INPUT THIS-PROCEDURE, INPUT "cb-tipo-nat-oper").
        assign c-tipo = return-value.

        assign input frame {&frame-name} cb-tp-oper-terc.
        assign l-altera-vl-terc:sensitive in frame {&frame-name} =
            if  natur-oper.terceiros:checked in frame {&frame-name} = yes 
                then yes
            else no.

        assign natur-oper.dec-1:sensitive in frame {&frame-name} =
           if l-altera-vl-terc:checked in frame {&frame-name} = true and
                 cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item2 
              or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item4  
              or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item5 
              or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item6 
              then yes
           else no.

        assign natur-oper.nat-comp:sensitive in frame {&frame-name} =
            if  l-nf-fat-ent-fut             /* Habilita para Fatur. Entrega Futura */
            or  (    param-global.modulo-mp 
                 and natur-oper.transf:checked in frame {&frame-name})
            &if defined (bf_mat_oper_triangular) &then
                or (    input frame {&frame-name} l-log-oper-triang
                    and not natur-oper.terceiros:checked in frame {&frame-name})
            &endif       
                then yes
                else no.
         
        assign natur-oper.ind-imprenda:sensitive in frame {&frame-name} =
            if param-global.modulo-ft 
                then yes
                else no.

        if  p-seta-campo 
        and adm-new-record 
        and not l-setou-campo then do:
            
            if {ininc/i06in245.i 06 c-tipo} = 2 then
                assign natur-oper.imp-nota:checked in frame {&frame-name} = no.
              
            if l-terceiros then                    
                assign natur-oper.transf:checked in frame {&frame-name} = no.

            assign natur-oper.transf:sensitive in frame {&frame-name} =
               if  not l-terceiros 
                 then yes
                 else no.

            assign l-setou-campo = yes.
        end.    
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

   if  l-nf-fat-ent-fut   /* Consiste Nat Comp para NF Faturamento Ent Fut */
   or  (    natur-oper.transf:checked in frame {&frame-name}
        and param-global.modulo-mp )
   then do:

        if input frame {&frame-name} natur-oper.nat-comp = "" then do:
            {include/i-vldprg.i} 
            /* mensagem: Natureza de Opera‡Æo complementar invalida */
            run utp/ut-msgs.p (input "show":U, input 5260, input return-value).
            apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        
        find first b-natur-oper where
             b-natur-oper.nat-operacao = input frame {&frame-name} natur-oper.nat-comp no-lock no-error.
             
        RUN Get-Field-Screen-Value IN adm-broker-hdl 
            (INPUT THIS-PROCEDURE, INPUT "cb-tipo-nat-oper").
            assign c-tipo         = return-value.

        if  not avail b-natur-oper then do:    
            {include/i-vldprg.i} 
            /* mensagem: Natureza de Opera‡Æo complementar invalida */
            run utp/ut-msgs.p (input "show":U, input 5260, input return-value).
            apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
            
        if  avail b-natur-oper 
        and b-natur-oper.tipo = {ininc/i06in245.i 06 c-tipo} then do:
            {include/i-vldprg.i} 
            /* mensagem: Natureza de Opera‡Æo complementar deve ser de tipo inverso */
            run utp/ut-msgs.p (input "show":U, input 15408, input return-value).
            apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        
        /* Faturamento Entrega Futura que baixa estoque */
        if  l-nf-fat-ent-fut
        and (   not b-natur-oper.terceiros
             or b-natur-oper.tp-oper-terc <> 1 ) then
        do:             
            {include/i-vldprg.i} 
            /* mensagem: Natureza Complementar Inv lida para Opera‡Æo Entrega Futura. */
            run utp/ut-msgs.p (input "show":U, input 25744, input return-value).
            apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.        
        
    end.
   
    &if defined (bf_mat_oper_triangular) &then
    
        assign i-tp-oper-terc = 0.

        if  natur-oper.terceiros:checked in frame {&frame-name} = yes
        and input frame {&frame-name} cb-tp-oper-terc = c-item1 then 
            assign i-tp-oper-terc = 1.

        if  input frame {&frame-name } l-log-oper-triang = yes
        and (    natur-oper.transf:checked in frame {&frame-name} = yes
              or (    natur-oper.terceiros:checked in frame {&frame-name} = yes
                  and i-tp-oper-terc <> 1 )) then do:
                {include/i-vldprg.i} 
                /* mensagem: Natureza de Opera‡Æo Inv lida */
                run utp/ut-msgs.p (input "show":U, input 19489, input return-value).
                apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
                return 'ADM-ERROR':U.
        end.            


        if  input frame {&frame-name } l-log-oper-triang = yes 
        and natur-oper.terceiros:checked in frame {&frame-name} = no then do:
             

            if  input frame {&frame-name} natur-oper.nat-comp = ""  then do:
                {include/i-vldprg.i} 
                /* mensagem: Natureza de Opera‡Æo nÆo cadastrada */
                run utp/ut-msgs.p (input "show":U, input 2050, input return-value).
                apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
        
            find first b-natur-oper where
                  b-natur-oper.nat-operacao = input frame {&frame-name} natur-oper.nat-comp no-lock no-error.

             if  not available b-natur-oper then do:    
                 {include/i-vldprg.i} 
                 /* mensagem: Natureza de Opera‡Æo nÆo cadastrada */
                 run utp/ut-msgs.p (input "show":U, input 2050, input return-value).
                 apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
                 return 'ADM-ERROR':U.
             end.

            RUN Get-Field-Screen-Value IN adm-broker-hdl 
            (INPUT THIS-PROCEDURE, INPUT "cb-tipo-nat-oper").
            assign c-tipo         = return-value.

            if  {ininc/i06in245.i 06 c-tipo} = 1 /* Entrada */
            and (    avail b-natur-oper
                 and not b-natur-oper.terceiros 
                 or  b-natur-oper.tipo = 1
                 or (    avail b-natur-oper
                     and b-natur-oper.tp-oper-terc <> 1
                     and b-natur-oper.tp-oper-terc <> 3)) then do:
                {include/i-vldprg.i} 
                /* mensagem: Natureza de Opera‡Æo de Entrega inv lida */
                run utp/ut-msgs.p (input "show":U, input 19079, input return-value).
                apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.

            if  {ininc/i06in245.i 06 c-tipo} = 2 /* Sa¡da */
            and (   b-natur-oper.terceiros
                 or b-natur-oper.tipo = 1 ) then do:
                /* mensagem: Natureza de Opera‡Æo de Entrega inv lida */
                run utp/ut-msgs.p (input "show":U, input 19491, input return-value).
                apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.            
        end.
    &endif       

   
              
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
     
    &if defined (bf_dis_desc_bonif) &then
        RUN Get-Field-Screen-Value IN adm-broker-hdl 
        (INPUT THIS-PROCEDURE, INPUT "nat-operacao").
        assign c-nat-operacao = trim(return-value).
        assign c-nat-operacao = replace(c-nat-operacao,".","").
        assign c-nat-operacao = replace(c-nat-operacao,"-","").
        if l-log-natureza-bonif:checked in frame {&frame-name} = yes and
           substring(input frame {&frame-name} c-cod-natur-oper-bonif,1,1) <> '' then do :        
            {include/i-vldprg.i} 
           /* mensagem: Indicador e C¢digo de Natureza Bonifica‡Æo nÆo podem ser preenchidos simultaneamentes */
                run utp/ut-msgs.p (input "show":U, input 17739, input return-value).
                apply "entry" to c-cod-natur-oper-bonif in frame {&frame-name}.
                return 'ADM-ERROR':U.
        end.
        else
           if l-log-natureza-bonif:checked in frame {&frame-name} = no and
              substring(input frame {&frame-name} c-cod-natur-oper-bonif,1,1) <> '' then do :
              find first b-natur-oper where
                   b-natur-oper.nat-operacao = input frame {&frame-name} c-cod-natur-oper-bonif
                   no-lock no-error.
              if not available b-natur-oper then do:    
                  {include/i-vldprg.i} 
                  /* mensagem: Natureza de Opera‡Æo invalida */
                  {utp/ut-field.i mgind natur-oper cod-natur-oper-bonif 1}
                  run utp/ut-msgs.p (input "show":U, input 56, input return-value).
                  apply "entry" to c-cod-natur-oper-bonif in frame {&frame-name}.
                  return 'ADM-ERROR':U.
              end.
              if available b-natur-oper then do:
                 if b-natur-oper.log-natureza-bonif = no then do:
                    {include/i-vldprg.i} 
                    /* mensagem: Natureza de Opera‡Æo informado nÆo ‚ de Bonifica‡Æo */
                    run utp/ut-msgs.p (input "show":U, input 17740, input return-value).
                    apply "entry" to c-cod-natur-oper-bonif in frame {&frame-name}.
                    return 'ADM-ERROR':U.
                 end.
              end.
        end.
        if avail natur-oper then do:
           if natur-oper.log-natureza-bonif = yes and
              l-log-natureza-bonif:checked in frame {&frame-name} = no then do:
              find first b-natur-oper where
                         b-natur-oper.cod-natur-oper-bonif = c-nat-operacao no-lock no-error.
              if avail b-natur-oper then do:
                 {include/i-vldprg.i} 
                 /* mensagem: Natureza de Operacao referenciada com natureza de bonificacao em outra natureza de operacao */
                 run utp/ut-msgs.p (input "show":U, input 17805, input return-value).
                 apply "entry" to l-log-natureza-bonif in frame {&frame-name}.
                 assign l-log-natureza-bonif:checked in frame {&frame-name} = yes.
                 return 'ADM-ERROR':U.
              end.
           end.
        end.      
  &endif
  
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "natur-oper"}

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

/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
 
&if defined (bf_dis_desc_bonif) &then
 
&else 
  if p-state = "update-begin" then 
     run pi-esconde-campo-tela.
&endif

/******************************************************
 * Pr‚-processador utilizado para esconder o combo-box *
 * cb-tipo-compra quando o release for menor que 2.03  *
 ******************************************************/         
 &if defined (bf_mat_natur_compra_re) &then
 &else 
    if p-state = "update-begin" then
    assign cb-tipo-compra:hidden in frame {&frame-name} = yes.  
 &endif
 /*****************************************************/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME






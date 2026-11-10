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
{include/i-prgvrs.i V42IN172 2.00.00.060 } /*** "010060" 17/09/2026 17:30:06 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v42in172 MUT}
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
def new global shared var v-row-parent as rowid no-undo.                      

/* Parameters Definitions ---                                           */
/* Local Variable Definitions ---                                       */
def var c-estruturada  as character init "000000000000" no-undo.

/**********Multiplanta*****************/

def var i-tipo-movto as integer no-undo.

{cdp/cd7300.i1}
{cdp/cdapi206.i2}

/**************Fim***********************/
def var c-handle1         as character no-undo.
def var wh-cd0903         as handle    no-undo.

def var de-ft-conv-fmcoml   as decimal no-undo.
def var de-ft-conversao     as decimal no-undo.
def var de-ft-conver        as decimal no-undo.


/*** Vari veis para integra‡Æo EMS x SISDOC ***/
def var c-nat-oper          as char             no-undo.
def var i-integracao-sisdoc as integer init ?   no-undo.
def var c-handle            as char             no-undo.
def var c-opcao-int         as char             no-undo.
def var i-retorno-erro      as integer init ?   no-undo.
def var c-formato           as char             no-undo.
def var l-ind-item-fat      as logical          no-undo.
DEF VAR wgh-label           AS WIDGET-HANDLE    NO-UNDO.


    /* 
    ** 5 => Quando parƒmetro "nao-integra" e o registro j  est  integrado **
    ** 6 => Erro de integra‡Æo no SISDOC                                  **
    ** 7 => Erro de integra‡Æo no EMS                                     ** */

/********* Fim vari veis para integra‡Æo ******/

/**** Pr‚-processadores de releases ****/
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
/*********************/

&if defined(bf_mat_uni_estab) &then

/**** Temp-table usadas na exporta‡Æo dos itens ****/
def temp-table tt-estabel no-undo
    field cod-estabel as char
    field log-exporta as log format "*/ "
    index codigo is primary unique cod-estabel
    index exporta log-exporta.

def temp-table tt-old-item no-undo like item
    use-index codigo.

def temp-table tt-old-item-mat no-undo like item-mat.
/***************************************************/

&endif

/* Integracao EAI */
{cdp/cd9043.i} /* Defini‡Æo da tabela de erros RowErrors */
DEF VAR hShowMsg AS HANDLE NO-UNDO.

&IF '{&BF_DIS_VERSAO_EMS}' >= "2.04":U &THEN
  DEFINE TEMP-TABLE tt-item-eai NO-UNDO LIKE ITEM.
  DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 
&ENDIF

&if "{&bf_mat_versao_ems}" >= "2.062" &then   
{cdp/cd9590.i}
&endif   

DEFINE VARIABLE hProgramZoom AS HANDLE NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.fm-cod-com item.ft-conv-fmcoml ~
item.dec-conv-fmcoml item.ft-conversao item.dec-ftcon item.fator-conver ~
item.fraciona item.lote-mulven item.cod-tax-serv item.ind-especifico 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS c-marca-item tg-copia-narrativa ~
c-cod-unid-negoc ft-conv-unid-tribut cb-orig-unid-trib RECT-19 
&Scoped-Define DISPLAYED-FIELDS item.fm-cod-com item.horiz-fixo ~
item.ft-conv-fmcoml item.dec-conv-fmcoml item.ft-conversao item.dec-ftcon ~
item.compr-fabric item.fator-conver item.fraciona item.lote-mulven ~
item.cod-tax-serv item.ind-especifico 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS c-desc-fam-coml c-un-fam c-un-fam-comerc ~
c-marca-item tg-copia-narrativa c-des-unid-negoc c-cod-unid-negoc ~
ft-conv-unid-tribut cb-orig-unid-trib 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS item.fm-cod-com combo-imp-desc 

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
DEFINE VARIABLE cb-orig-unid-trib AS CHARACTER FORMAT "X(256)":U 
     LABEL "Origem Unidade Tribut vel" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Unidade NCM","1",
                     "Unidade da Fam¡lia","2",
                     "Unidade de Faturamento","3",
                     "Peso l¡quido","4",
                     "Peso Bruto","5"
     DROP-DOWN-LIST
     SIZE 20.29 BY 1 NO-UNDO.

DEFINE VARIABLE combo-imp-desc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Forma descri‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 26.14 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-unid-negoc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fam-coml AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-marca-item AS CHARACTER FORMAT "X(35)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-fam AS CHARACTER FORMAT "X(03)":U 
     LABEL "c-un-fam" 
     VIEW-AS FILL-IN 
     SIZE 4.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-fam-comerc AS CHARACTER FORMAT "X(03)":U 
     LABEL "c-un-fam-comerc" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE ft-conv-unid-tribut AS DECIMAL FORMAT ">>>,>>>,>>9.9999999999":U INITIAL 0 
     LABEL "Ft Conv Unidade Tribut vel" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE text-6 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34.86 BY 1.63.

DEFINE VARIABLE tg-copia-narrativa AS LOGICAL INITIAL no 
     LABEL "Copia Narrativa do Item" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .75 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-desc-fam-coml AT ROW 2 COL 35.86 COLON-ALIGNED NO-LABEL
     c-un-fam AT ROW 1 COL 25 COLON-ALIGNED
     item.fm-cod-com AT ROW 2 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     c-un-fam-comerc AT ROW 3 COL 25 COLON-ALIGNED
     c-marca-item AT ROW 3 COL 38 COLON-ALIGNED
     item.horiz-fixo AT ROW 4 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     combo-imp-desc AT ROW 5 COL 25 COLON-ALIGNED
     tg-copia-narrativa AT ROW 5 COL 56 HELP
          "Copia narrativa do item para narrativa informada"
     item.ft-conv-fmcoml AT ROW 6 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     item.dec-conv-fmcoml AT ROW 6 COL 38.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 2.57 BY .88
     item.ft-conversao AT ROW 7 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     item.dec-ftcon AT ROW 6.96 COL 38.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 2.57 BY .88
     item.compr-fabric AT ROW 7 COL 45.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Comprado", 1,
"Fabricado", 2
          SIZE 32.57 BY .75
     item.fator-conver AT ROW 11 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     item.fraciona AT ROW 8.33 COL 44.14
          VIEW-AS TOGGLE-BOX
          SIZE 27.43 BY .75
     item.lote-mulven AT ROW 8 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.cod-tax-serv AT ROW 9 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     item.ind-especifico AT ROW 9.25 COL 44.14
          VIEW-AS TOGGLE-BOX
          SIZE 15.57 BY .75
     c-des-unid-negoc AT ROW 10 COL 31.43 COLON-ALIGNED NO-LABEL
     c-cod-unid-negoc AT ROW 10 COL 25 COLON-ALIGNED
     ft-conv-unid-tribut AT ROW 11 COL 25.29 COLON-ALIGNED HELP
          "Fator conversÆo da unidade do item p/ unidade tribut vel do NCM"
     text-6 AT ROW 6 COL 42.14 COLON-ALIGNED NO-LABEL
     cb-orig-unid-trib AT ROW 11 COL 64 COLON-ALIGNED HELP
          "Op‡äes para definir a unidade tribut vel"
     RECT-19 AT ROW 6.25 COL 43.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  {utp/ut-liter.i O_programa_deve_ser_executado_de_forma_persistente. *}
  RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17006, INPUT RETURN-VALUE).
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 11.04
         WIDTH              = 87.29.
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
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 11.04
       FRAME f-main:WIDTH            = 87.29.

ASSIGN 
       c-cod-unid-negoc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-des-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-des-unid-negoc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-fam-coml IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-marca-item:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-un-fam IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-fam-comerc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX combo-imp-desc IN FRAME f-main
   NO-DISPLAY NO-ENABLE 3                                               */
/* SETTINGS FOR RADIO-SET item.compr-fabric IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.fm-cod-com IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN item.horiz-fixo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN text-6 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
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

&Scoped-define SELF-NAME c-cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON F5 OF c-cod-unid-negoc IN FRAME f-main
DO:
  
    &if "{&bf_mat_versao_ems}" >= "2.062" &then   
   {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                         &FieldZoom1="cod-unid-negoc"
                         &FieldScreen1="c-cod-unid-negoc"
                         &Frame1="{&frame-name}"
                         &FieldZoom2="des-unid-negoc"
                         &FieldScreen2="c-des-unid-negoc"
                         &Frame2="{&frame-name}"
                         &EnableImplant="no"}
    &endif   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON LEAVE OF c-cod-unid-negoc IN FRAME f-main
DO:
  
    &if '{&BF_MAT_VERSAO_EMS}' >= '2.062':U &then 
        {include/leave.i &tabela=unid-negoc
                         &atributo-ref=des-unid-negoc
                         &variavel-ref=c-des-unid-negoc
                         &where="unid-negoc.cod-unid-negoc = input frame {&FRAME-NAME} c-cod-unid-negoc"}
    &endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-unid-negoc IN FRAME f-main
DO:
  
    APPLY 'F5':U TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.cod-tax-serv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-tax-serv V-table-Win
ON F5 OF item.cod-tax-serv IN FRAME f-main /* C¢digo Imposto Servi‡o */
DO:
 l-implanta = yes.
 {include/zoomvar.i &prog-zoom="dizoom/z01di217.w"
                    &campo=item.cod-tax-serv
                    &campozoom=cod-tax}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-tax-serv V-table-Win
ON mouse-select-dblclick OF item.cod-tax-serv IN FRAME f-main /* C¢digo Imposto Servi‡o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME combo-imp-desc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL combo-imp-desc V-table-Win
ON VALUE-CHANGED OF combo-imp-desc IN FRAME f-main /* Forma descri‡Æo */
DO:
    assign input frame {&frame-name} combo-imp-desc.
      
    CASE {ininc/i10in122.i 06 combo-imp-desc}:
        WHEN 4 OR
        WHEN 7 OR
        WHEN 9 THEN DO:
            IF  combo-imp-desc:SENSITIVE IN FRAME f-main THEN 
                ASSIGN tg-copia-narrativa:SENSITIVE IN FRAME f-main = YES.
            ELSE
                ASSIGN tg-copia-narrativa:SENSITIVE IN FRAME f-main = NO.
            END.
        OTHERWISE
            ASSIGN tg-copia-narrativa:SENSITIVE IN FRAME f-main = NO.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.fm-cod-com
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-cod-com V-table-Win
ON F5 OF item.fm-cod-com IN FRAME f-main /* Fam¡lia Comercial */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=dizoom/z01di050.w
                     &campo=item.fm-cod-com
                     &campozoom=fm-cod-com}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-cod-com V-table-Win
ON LEAVE OF item.fm-cod-com IN FRAME f-main /* Fam¡lia Comercial */
DO:
 {include/leave.i &tabela=fam-comerc
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-fam-coml
                   &where="fam-comerc.fm-cod-com = input frame {&frame-name}
                                                   item.fm-cod-com"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-cod-com V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.fm-cod-com IN FRAME f-main /* Fam¡lia Comercial */
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

  {utp/ut-rtlbl.i mgind item compr-fabric text-6}
  {utp/ut-liter.i Un_Fam_Material MFT L} 
  assign c-un-fam:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Un_Fam_Comercial MFT L} 
  assign c-un-fam-comerc:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind item ind-imp-desc 1}
  assign combo-imp-desc:label in frame {&frame-name} = return-value.


  if item.fm-cod-com:load-mouse-pointer   ("image~\lupa.cur") in frame {&frame-name} then.
  if item.cod-tax-serv:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  /*  if item.char-2:load-mouse-pointer   ("image~\lupa.cur") in frame {&frame-name} then. */

&if "{&bf_mat_versao_ems}" >= "2.062" &then   
c-cod-unid-negoc:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.  
{utp/ut-field.i mgind familia-mat cod-unid-negoc 1}
assign c-cod-unid-negoc:label in frame {&FRAME-NAME} = return-value.
&endif   

  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

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

  {utp/ut-rtlbl.i mgind item compr-fabric text-6}

  /*/*/*{utp/ut-field.i mgind natur-oper nat-operacao 1}
 *  *  *   assign item.char-2:label in frame {&frame-name} = return-value*/*/*/.

  {utp/ut-field.i mgind item ind-imp-desc 1}
  assign combo-imp-desc:label in frame {&frame-name} = return-value.


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE c-marca-item-aux AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE h-ut-integration AS HANDLE      NO-UNDO.

  do transaction:
    {include/i-valid.i}

    /* Code placed here will execute PRIOR to standard behavior. */
    assign input frame {&frame-name} combo-imp-desc.

    APPLY 'leave' TO c-cod-unid-negoc.
  
    &if "{&bf_dis_versao_ems}" >= "2.03" &then
        /* Cria temp-table para exporta‡Æo */
        run pi-cria-tt-old-item.  
    &endif

    &if '{&BF_MAT_VERSAO_EMS}' >= '2.062':U &then 
        ASSIGN INPUT FRAME {&frame-name} c-cod-unid-negoc.
    &endif
   
    IF i-pais-impto-usuario = 4 /*Mexico*/ OR i-pais-impto-usuario = 17 /*Colombia*/ THEN
        ASSIGN c-marca-item-aux = INPUT FRAME {&FRAME-NAME} c-marca-item.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    
    if RETURN-VALUE = 'ADM-ERROR':U then 
        RETURN 'ADM-ERROR':U.

/*/*/*   assign substring(item.char-2,13,8,"character") = input frame {&frame-name} item.char-2.*/*/*/

    find first pend-item where pend-item.it-codigo = item.it-codigo
                         and   pend-item.modulo    = "pd" exclusive-lock no-error.
    if  avail pend-item then 
        delete pend-item.                         

    /* Code placed here will execute AFTER standard behavior.    */

    IF i-pais-impto-usuario = 4 THEN
        ASSIGN OVERLAY(ITEM.char-2,278,35) = c-marca-item-aux
               OVERLAY(item.char-1,321,20) = STRING(DECIMAL(TRIM(ft-conv-unid-tribut:SCREEN-VALUE IN FRAME {&FRAME-NAME}))).
    IF i-pais-impto-usuario = 17 /*Colombia*/ THEN
        ASSIGN OVERLAY(ITEM.char-2,278,35) = c-marca-item-aux.

     assign item.ind-imp-desc = {ininc/i10in122.i 06 combo-imp-desc}.

    FOR FIRST item-dist 
        WHERE item-dist.it-codigo = ITEM.it-codigo EXCLUSIVE-LOCK:
    END.

    IF {ininc/i10in122.i 06 combo-imp-desc} = 4 
    OR {ininc/i10in122.i 06 combo-imp-desc} = 7 
    OR {ininc/i10in122.i 06 combo-imp-desc} = 9 THEN
        ASSIGN item-dist.log-cop-narrat = tg-copia-narrativa:CHECKED IN FRAME f-main.
    ELSE
        ASSIGN item-dist.log-cop-narrat = NO.

    RELEASE item-dist.

    ASSIGN item.cod-unid-negoc = c-cod-unid-negoc.
    
     /******* Integra‡Æo EMS x SISDOC ******/

     if i-integracao-sisdoc = ? then do:
        RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                    OUTPUT c-handle).
        run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
     end.
	      

     /***************** Fim Integra‡Æo EMS x SISDOC **************/


    /******************Multiplanta******************/

    assign c-transacao = "DIS005".
    {cdp/cd7300.i5 "001" c-transacao}

    assign i-tipo-movto = 2.
    run pi-cria-tt-dados (input i-tipo-movto).

    {cdp/cd7300.i6 "001" c-transacao}
    find first tt-dados-env no-error.
    if  avail tt-dados-env then
        delete tt-dados-env.

    /**************Fim-Multiplanta*****************/

    /*Api de Integra‡Æo*/
    RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.
    RUN eai-integration IN h-ut-integration (INPUT "Item",            /* Nome da transa‡Æo     */
                                             INPUT ROWID(ITEM),       /* Registro da transa‡Æo */
                                             INPUT "UPDATE",          /* Evento da transa‡Æo   */
                                             OUTPUT TABLE RowErrors). /* Erros da transa‡Æo    */
    DELETE PROCEDURE h-ut-integration.
    
    IF CAN-FIND(FIRST RowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
    END.
    /*Fim Api de Integra‡Æo*/

    /* Integra‡Æo Neogrid  */
    RUN utp/ut-neog.p.
    IF  RETURN-VALUE = "OK" THEN
        &IF '{&BF_DIS_VERSAO_EMS}' < '2.05' &THEN
        FOR EACH estabelec FIELDS (cod-emitente cod-estabel) NO-LOCK,
            FIRST emitente FIELDS (cod-emitente)
            WHERE emitente.cod-emitente        = estabelec.cod-emitente
            AND   SUBSTR(emitente.char-1,11,1) = "1" NO-LOCK:
        &ELSE
        FOR EACH estabelec FIELDS (cod-emitente cod-estabel) NO-LOCK,
            FIRST dist-emitente FIELDS (cod-emitente)
            WHERE dist-emitente.cod-emitente = estabelec.cod-emitente
            AND   dist-emitente.parceiro-b2b = YES NO-LOCK:
        &ENDIF
            RUN adapters/neogrid/enp/aneen005.p (input rowid(item),
                                                 INPUT estabelec.cod-estabel,
                                                 INPUT estabelec.cod-emitente,
                                                 INPUT "Update").
        END.

    /* Integra‡Æo CRM */
    RUN utp/ut-crm.p.
    IF  RETURN-VALUE = "YES" THEN
        RUN adapters/neogrid/enp/aneen055.p (input rowid (item),
                                             INPUT "",
                                             INPUT 0,
                                             INPUT "Update").

    /* Integracao EAI - Itens */
    &IF '{&bf_dis_versao_ems}' >= "2.04":U &THEN
      IF v_log_eai_habilit THEN DO:

        CREATE tt-item-eai.
        BUFFER-COPY ITEM TO tt-item-eai NO-ERROR.

        RUN adapters/xml/ma2/axsma003.p (input "upd":u,
                                         INPUT "cd0903.w":U,
                                         INPUT c-prg-vrs,
                                         INPUT TABLE tt-item-eai,
                                         OUTPUT TABLE RowErrors).  

        DELETE tt-item-eai.
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
           {method/showmessage.i1}
           {method/showmessage.i2 &modal="yes"}
           undo, return "ADM-ERROR":U.
        END.
      END.
    &ENDIF
    
      FIND FIRST pend-item
      WHERE pend-item.it-codigo = ITEM.it-codigo
      AND   pend-item.MODULO    = "MPD" EXCLUSIVE-LOCK NO-ERROR.
  
      IF AVAIL pend-item THEN
          DELETE pend-item.

    IF i-pais-impto-usuario = 1 THEN 
        ASSIGN OVERLAY(item.char-1,321,20) = STRING(DECIMAL(TRIM(ft-conv-unid-tribut:SCREEN-VALUE IN FRAME {&FRAME-NAME})))
               OVERLAY(item.char-1,341,1)  = TRIM(cb-orig-unid-trib:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

  end.  /* do transaction */  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

     /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  run pi-habilita(yes).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /******* Integra‡Æo EMS x SISDOC ******/

  if  i-integracao-sisdoc = ? then do:
      RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                  OUTPUT c-handle).
      run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
  end.

  if  i-integracao-sisdoc = 2 then
      assign c-opcao-int = "nao-integra".
  if  i-integracao-sisdoc = 3 then
      assign c-opcao-int = "elimina".

    

  /***** Fim Integra‡Æo EMS x SISDOC ****/


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
  
  ASSIGN c-cod-unid-negoc:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  IF i-pais-impto-usuario = 4 THEN DO:
      ASSIGN c-marca-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      DISABLE ft-conv-unid-tribut WITH FRAME {&FRAME-NAME}.
  END.
   IF i-pais-impto-usuario = 17 /*Colombia*/ THEN
      ASSIGN c-marca-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    
  IF i-pais-impto-usuario = 1 THEN 
      DISABLE ft-conv-unid-tribut cb-orig-unid-trib WITH FRAME {&FRAME-NAME}.

  APPLY "VALUE-CHANGED" TO combo-imp-desc. 

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

   if  avail item then do:
      for first fam-comerc fields(fm-cod-com descricao un) where fam-comerc.fm-cod-com = item.fm-cod-com no-lock:
      assign c-desc-fam-coml = fam-comerc.descricao
             c-un-fam-comerc = fam-comerc.un.
      end.
      if not avail fam-comer then
        assign c-desc-fam-coml = "":U.              

      for first familia where familia.fm-codigo = item.fm-codigo no-lock:
        assign c-un-fam = familia.un.
      end.

  end. 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


    if  avail item then do with frame {&frame-name}:

        FOR FIRST item-dist WHERE
            item-dist.it-codigo = ITEM.it-codigo NO-LOCK:
        END.
        ASSIGN tg-copia-narrativa:CHECKED IN FRAME f-main = item-dist.log-cop-narrat. 

        ASSIGN combo-imp-desc:screen-value = {ininc/i10in122.i 04 item.ind-imp-desc}.
      
        &if '{&BF_MAT_VERSAO_EMS}' >= '2.062':U &then 
            FIND unid-negoc
                WHERE unid-negoc.cod-unid-negoc = ITEM.cod-unid-negoc NO-LOCK NO-ERROR.
            ASSIGN c-cod-unid-negoc = ITEM.cod-unid-negoc
                   c-des-unid-negoc = IF  AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE "".
        &endif

        IF i-pais-impto-usuario = 4 OR i-pais-impto-usuario = 17 /*Colombia*/ THEN
            ASSIGN c-marca-item:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(ITEM.char-2,278,35).
    end.
    else do:
        ASSIGN combo-imp-desc:screen-value = {ininc/i10in122.i 04 1}.
      
        &if '{&BF_MAT_VERSAO_EMS}' >= '2.062':U &then 
            ASSIGN c-cod-unid-negoc = ""
                   c-des-unid-negoc = "".
        &ENDIF
    end.

    APPLY "VALUE-CHANGED" TO combo-imp-desc. 

    &if '{&BF_MAT_VERSAO_EMS}' >= '2.062':U &then 
    ASSIGN c-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-cod-unid-negoc
           c-des-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-des-unid-negoc.
    &ENDIF

    IF i-pais-impto-usuario = 1 THEN 
        ASSIGN ft-conv-unid-tribut:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(DECIMAL(TRIM(SUBSTRING(item.char-1,321,20))),">>>,>>>,>>9.9999999999")
               cb-orig-unid-trib  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF TRIM(SUBSTRING(item.char-1,341,1)) = "":U THEN "1" ELSE TRIM(SUBSTRING(item.char-1,341,1)).
    
    IF i-pais-impto-usuario = 4 THEN
        ASSIGN ft-conv-unid-tribut:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(DECIMAL(TRIM(SUBSTRING(item.char-1,321,20))),">>>,>>>,>>9.9999999999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

def var c-link-handle as char no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */

  /******* Integra‡Æo EMS x SISDOC ******/

  run get-attribute ('adm-new-record').
  if  not adm-new-record then do:
      if  i-integracao-sisdoc = ? then do:
          RUN Who-Is-The-Container IN adm-broker-hdl 
                            (INPUT  this-procedure,
                             OUTPUT c-handle).
          run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
      end.     
  end.  /* if not adm-new-record */

  /***** Fim Integra‡Æo EMS x SISDOC ****/

  IF i-pais-impto-usuario = 4 THEN DO:
      ASSIGN c-marca-item:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      ENABLE ft-conv-unid-tribut WITH FRAME {&FRAME-NAME}.
  END.  
  IF i-pais-impto-usuario = 17 /*Colombia*/ THEN 
      ASSIGN c-marca-item:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  IF i-pais-impto-usuario = 1 THEN 
      ENABLE ft-conv-unid-tribut cb-orig-unid-trib WITH FRAME {&FRAME-NAME}.

  ASSIGN c-cod-unid-negoc:SENSITIVE IN FRAME {&FRAME-NAME} = l-dis-unid-negoc.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.       
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  &endif
  
  
  APPLY "VALUE-CHANGED" TO combo-imp-desc. 

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  def var l-modif    as log no-undo.
  def var l-cancela  as log no-undo.
  def var l-cont-ant as log no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  &if "{&bf_dis_versao_ems}" >= "2.03" &then

      if  avail item then do:  
          assign l-modif = no.
          run cdp/cd0138a.w ( input item.it-codigo,
                              input-output l-modif,
                              output l-cont-ant,
                              output l-cancela,
                              output table tt-estabel ).

          session:set-wait-state("general":U).
          run cdp/cd0138b.p (input item.it-codigo,
                             input "M", /* Modifica‡Æo */
                             input l-modif,
                             input l-cont-ant,
                             input (not l-cancela),
                             input "cd0903.w":U,
                             input table tt-estabel,
                             input table tt-old-item,
                             input table tt-old-item-mat) no-error.
          session:set-wait-state("":U).                             
      end.

  &endif

  /* Code placed here will execute AFTER standard behavior.    */

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

  do  with frame {&frame-name}:
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao003 = {ininc/i10in122.i 03}.
          RUN utp/ut-lstit.p (input-output cauxtraducao003).
          ASSIGN  combo-imp-desc:LIST-ITEM-PAIRS = cAuxTraducao003.
      &else
          ASSIGN combo-imp-desc:list-items = {ininc/i10in122.i 03}.
      &endif
  end.    

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    DISABLE ft-conv-unid-tribut cb-orig-unid-trib WITH FRAME {&FRAME-NAME}.
                                                                      
    ASSIGN ft-conv-unid-tribut:HIDDEN IN FRAME  {&FRAME-NAME} = TRUE  
           cb-orig-unid-trib  :HIDDEN IN FRAME  {&FRAME-NAME} = TRUE  
           c-cod-unid-negoc   :VISIBLE IN FRAME {&FRAME-NAME} = YES   
           c-des-unid-negoc   :VISIBLE IN FRAME {&FRAME-NAME} = YES.  

    IF i-pais-impto-usuario = 4 THEN
        ASSIGN c-marca-item:VISIBLE IN FRAME {&FRAME-NAME} = YES
               ft-conv-unid-tribut:HIDDEN IN FRAME {&FRAME-NAME} = FALSE
               ft-conv-unid-tribut:COLUMN IN FRAME {&FRAME-NAME} = ft-conv-unid-tribut:COLUMN IN FRAME {&FRAME-NAME} + 39
               wgh-label = ft-conv-unid-tribut:SIDE-LABEL-HANDLE 
               wgh-label:COLUMN = wgh-label:COLUMN + 39.        
    IF i-pais-impto-usuario = 17 /*Colombia*/ THEN
        ASSIGN c-marca-item:VISIBLE IN FRAME {&FRAME-NAME} = YES.
    
    IF i-pais-impto-usuario = 1 THEN 
        ASSIGN ft-conv-unid-tribut:HIDDEN IN FRAME {&FRAME-NAME} = FALSE
               cb-orig-unid-trib  :HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */ 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if return-value = 'adm-error':U  then do:
     undo, return 'adm-error':U.
  end.
  /* Code placed here will execute AFTER standard behavior.    */

  run pi-habilita(yes).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Esta procedure ‚ espec¡fica do MULTIPLANTA.       
------------------------------------------------------------------------------*/

def input parameter i-tipo-movto as integer.

if  param-global.modulo-mp and
    tt-replica-msg.log-replica-msg  = yes then do: 
    create tt-item-aux.
    buffer-copy item to tt-item-aux.
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 3
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = item.it-codigo.
    raw-transfer tt-item-aux to tt-dados-env.conteudo-msg.                                    
    assign i-seq = i-seq + 1.                                     
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-old-item V-table-Win 
PROCEDURE pi-cria-tt-old-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&if "{&bf_dis_versao_ems}" >= "2.03" &then
    
    for each tt-old-item:
        delete tt-old-item.
    end.

    create tt-old-item.
    buffer-copy item to tt-old-item no-error.
    if  error-status:error then
        return "NOK":U.

&endif

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita V-table-Win 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter l-habilita as logical.
def var c-handle as char.

RUN get-link-handle IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT 'leandro-source',
     OUTPUT c-handle).

if  l-habilita = no then     
    RUN set-button-enable IN widget-handle(c-handle) ('no,no,yes').
else
    RUN set-button-enable IN widget-handle(c-handle) ('yes,yes,yes').    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {include/i-vldfrm.i}
    
    RUN Who-Is-The-Container IN adm-broker-hdl
        (INPUT this-procedure, OUTPUT c-handle1).
    assign wh-cd0903 = widget-handle(c-handle1).
    
    if input frame {&frame-name} c-un-fam:screen-value <> "" and
       input frame {&frame-name} c-un-fam:screen-value <> ? then do: 
    
       if not can-find(tab-unidade where 
                   tab-unidade.un = c-un-fam:screen-value in frame {&frame-name}) then do:
            {utp/ut-field.i mgind familia un 1}
            run utp/ut-msgs.p (input "show",
                               input 8226,
                               input return-value).
            run select-page in wh-cd0903 (1).                   
            apply "entry" to c-un-fam.
            return "adm-error".
       end.
    
    end.
    
    {utp/ut-field.i mgind item ind-item-fat 4}
    assign c-formato = return-value.
    RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure, INPUT "ind-item-fat").
    
    assign l-ind-item-fat = yes.
    assign l-ind-item-fat = if return-value = string(l-ind-item-fat,c-formato) 
                            then yes else no.
    
    /* Se for um item fatur vel */
    
    if l-ind-item-fat then do:
        assign de-ft-conv-fmcoml = input frame {&frame-name} item.ft-conv-fmcoml
               de-ft-conversao   = input frame {&frame-name} item.ft-conversao.
    
    
        if de-ft-conv-fmcoml <= 0  then do:
    
            {utp/ut-field.i mgind item ft-conv-fmcoml 1}
            run utp/ut-msgs.p (input "show",
                               input 5405,
                               input return-value).
    
            run select-page in wh-cd0903 (1).
            apply "entry":U to item.ft-conv-fmcoml.
            return "adm-error":U.
        end.
    
        if de-ft-conversao <= 0  then do:
            {utp/ut-field.i mgind item ft-conversao 1}
            run utp/ut-msgs.p (input "show",
                                 input 5405,
                                 input return-value).
            run select-page in wh-cd0903 (1).                    
            apply "entry":U to item.ft-conversao.
            return "adm-error":U.
        end.
    
        if i-pais-impto-usuario = 1 then do:
            assign de-ft-conver      = input frame {&frame-name} item.fator-conver.
            if de-ft-conver <= 0  then do:
                {utp/ut-field.i mgind item fator-conver 1}
                run utp/ut-msgs.p (input "show",
                                     input 5465,
                                     input return-value).
    
                run select-page in wh-cd0903 (1).                    
                apply "entry":U to item.fator-conver. 
                return "adm-error":U.
            end.
        end.
    end.
    
    if i-pais-impto-usuario = 1         
    and item.fraciona:checked in frame {&FRAME-NAME} = no
    and input frame {&frame-name} item.lote-mulven -
        int(input frame {&frame-name} item.lote-mulven) <> 0  
    then do:
       run utp/ut-msgs.p (input "show":u,
                          input 847,  /* Quantidade fracionada */
                          input "").
       run select-page in wh-cd0903 (1).
       apply "entry":U to item.lote-mulven.
       return 'ADM-ERROR':U.
    end.
    
    if  i-pais-impto-usuario = 1 
    and item.fraciona:checked in frame {&FRAME-NAME} = no
    and (item.lote-multipl - int(item.lote-multipl) <> 0) 
    then do:
       run utp/ut-msgs.p (input "show":u,
                          input 26120, 
                          input "").
       run select-page in wh-cd0903 (1).
       apply "entry":U to item.fraciona.
       return 'ADM-ERROR':U.
    end.
    
    &if "{&bf_mat_versao_ems}" >= "2.062" &then
    IF  l-dis-unid-negoc THEN DO:
        IF  NOT CAN-FIND(FIRST unid-negoc
                         WHERE unid-negoc.cod-unid-negoc = c-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
            {utp/ut-field.i mgind item cod-unid-negoc 1}
            run utp/ut-msgs.p (input "show",
                               input 2,
                               input return-value).
            run select-page in wh-cd0903 (1).
            apply "entry":U to c-cod-unid-negoc.
            return 'ADM-ERROR':U.
        END.
    END.
    &ENDIF
    
    /*IF  NOT CAN-FIND(FIRST fam-comerc 
                     WHERE fam-comerc.fm-cod-com = INPUT FRAME {&FRAME-NAME} ITEM.fm-cod-com) THEN DO:
        {utp/ut-field.i mgind item fm-cod-com 1}
        run utp/ut-msgs.p (input "show",
                           input 2,
                           input return-value).
        run select-page in wh-cd0903 (1).
        apply "entry":U to item.fm-cod-com.
        return 'ADM-ERROR':U.
    END.*/

    IF i-pais-impto-usuario = 1 THEN DO:

        RUN Get-Field-Screen-Value IN adm-broker-hdl
        ( INPUT this-procedure /* HANDLE */,
          INPUT "class-fiscal" /* CHARACTER */).
    
        /*Valida Unidade da Fam¡lia*/
        FIND FIRST classif-fisc NO-LOCK WHERE classif-fisc.class-fiscal = REPLACE(RETURN-VALUE,".","") NO-ERROR.
    
        IF      TRIM(cb-orig-unid-trib:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = "2":U
            AND (AVAIL classif-fisc AND SUBSTRING(classif-fisc.char-2,2,2) <> familia.un)
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 55205,
                               INPUT "da fam¡lia" + "~~" + familia.un + "~~" + SUBSTRING(classif-fisc.char-2,2,2)).
            RUN select-page IN wh-cd0903 (1).
            APPLY "entry":U TO cb-orig-unid-trib.
            RETURN 'ADM-ERROR':U.
        END.
    
        /*Valida "Peso L¡quido" ou "Peso Bruto"*/
        IF AVAIL classif-fisc
           AND TRIM(cb-orig-unid-trib:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = "4":U
            OR TRIM(cb-orig-unid-trib:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = "5":U
        THEN DO:
            IF TRIM(SUBSTRING(classif-fisc.char-2,2,2)) <> "":U AND TRIM(SUBSTRING(classif-fisc.char-2,2,2)) <> "KG":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   55208,
                                   INPUT "").
                RUN select-page IN wh-cd0903 (1).
                APPLY "entry":U TO cb-orig-unid-trib.
                RETURN 'ADM-ERROR':U.
            END.
            ELSE IF TRIM(SUBSTRING(classif-fisc.char-2,2,2)) = "":U AND item.un <> "KG":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   55209,
                                   INPUT "").
                RUN select-page IN wh-cd0903 (1).
                APPLY "entry":U TO cb-orig-unid-trib.
                RETURN 'ADM-ERROR':U.
            END.
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
  {src/adm/template/snd-list.i "item"}

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

  if  p-state = 'update-begin' then
      run pi-habilita (no).

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


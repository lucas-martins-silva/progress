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
{include/i-prgvrs.i V01IN163 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN163 MUT}
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
def new Global shared var c-seg-usuario as char format "x(12)" no-undo.
def buffer b-it-doc-fisico for it-doc-fisico.
def buffer b-prazo-compra  for prazo-compra.
def var r-nota-fiscal as rowid no-undo.
def var de-quantid as decimal no-undo.
def var l-aux as logical no-undo.
def var l-da-nota-dev as logical no-undo.
def var de-preco-unit as decimal no-undo.
def var de-preco-unit-min as decimal no-undo.
def var de-preco-unit-max as decimal no-undo.
def var l-erro as logical no-undo.

def new global shared var de-quantidade    as decimal no-undo.
def new global shared var de-quant-forn    as decimal no-undo.
def new global shared var de-indice        as decimal no-undo.
def new global shared var de-pre-unitario  as decimal no-undo.
def new global shared var l-inclui         as logical no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES it-doc-fisico
&Scoped-define FIRST-EXTERNAL-TABLE it-doc-fisico


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR it-doc-fisico.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS it-doc-fisico.it-codigo ~
it-doc-fisico.qt-do-forn it-doc-fisico.quantidade it-doc-fisico.cod-depos ~
it-doc-fisico.valor 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}it-codigo ~{&FP2}it-codigo ~{&FP3}~
 ~{&FP1}qt-do-forn ~{&FP2}qt-do-forn ~{&FP3}~
 ~{&FP1}quantidade ~{&FP2}quantidade ~{&FP3}~
 ~{&FP1}cod-depos ~{&FP2}cod-depos ~{&FP3}~
 ~{&FP1}valor ~{&FP2}valor ~{&FP3}
&Scoped-define ENABLED-TABLES it-doc-fisico
&Scoped-define FIRST-ENABLED-TABLE it-doc-fisico
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS it-doc-fisico.sequencia ~
it-doc-fisico.dt-nota-dev it-doc-fisico.it-codigo it-doc-fisico.qt-do-forn ~
it-doc-fisico.un it-doc-fisico.quantidade it-doc-fisico.cod-refer ~
it-doc-fisico.nr-ord-prod it-doc-fisico.cod-depos it-doc-fisico.cod-localiz ~
it-doc-fisico.lote it-doc-fisico.dt-vali-lote it-doc-fisico.valor 
&Scoped-Define DISPLAYED-OBJECTS c-nome-item c-item-do-forn c-nossa-unidade ~
c-nome-deposito de-prec-unitario 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS it-doc-fisico.qt-do-forn ~
it-doc-fisico.quantidade 

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
DEFINE VARIABLE c-item-do-forn AS CHARACTER FORMAT "X(20)" 
     LABEL "Item Fornecedor":R18 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-deposito AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-nossa-unidade AS CHARACTER FORMAT "X(02)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE VARIABLE de-prec-unitario AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Preáo Unit†rio":R17 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 9.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     it-doc-fisico.sequencia AT ROW 1.21 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     it-doc-fisico.dt-nota-dev AT ROW 1.21 COL 62.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     it-doc-fisico.it-codigo AT ROW 2.21 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-nome-item AT ROW 3.21 COL 20.29 COLON-ALIGNED NO-LABEL
     c-item-do-forn AT ROW 4.21 COL 20.29 COLON-ALIGNED
     it-doc-fisico.qt-do-forn AT ROW 5.21 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     it-doc-fisico.un AT ROW 6.21 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     it-doc-fisico.quantidade AT ROW 7.21 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-nossa-unidade AT ROW 8.21 COL 20.29 COLON-ALIGNED
     it-doc-fisico.cod-refer AT ROW 9.21 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     it-doc-fisico.nr-ord-prod AT ROW 3.21 COL 62.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     it-doc-fisico.cod-depos AT ROW 4.21 COL 62.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-nome-deposito AT ROW 4.21 COL 69.57 COLON-ALIGNED NO-LABEL
     it-doc-fisico.cod-localiz AT ROW 5.21 COL 62.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.14 BY .88
     it-doc-fisico.lote AT ROW 6.21 COL 62.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.14 BY .88
     it-doc-fisico.dt-vali-lote AT ROW 7.21 COL 62.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     de-prec-unitario AT ROW 8.21 COL 62.29 COLON-ALIGNED HELP
          "Preáo unit†rio interno incluso impostos, desconto, ipi e taxa"
     it-doc-fisico.valor AT ROW 9.21 COL 62.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.it-doc-fisico
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.46
         WIDTH              = 88.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-item-do-forn IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-deposito IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nossa-unidade IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-doc-fisico.cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-doc-fisico.cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-prec-unitario IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-doc-fisico.dt-nota-dev IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-doc-fisico.dt-vali-lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-doc-fisico.lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-doc-fisico.nr-ord-prod IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-doc-fisico.qt-do-forn IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN it-doc-fisico.quantidade IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN it-doc-fisico.sequencia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-doc-fisico.un IN FRAME f-main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME it-doc-fisico.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.cod-depos V-table-Win
ON F5 OF it-doc-fisico.cod-depos IN FRAME f-main /* Dep¢sito */
DO:

    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                       &campo=it-doc-fisico.cod-depos
                       &campozoom=cod-depos}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.cod-depos V-table-Win
ON LEAVE OF it-doc-fisico.cod-depos IN FRAME f-main /* Dep¢sito */
DO:

    {include/leave.i &tabela=deposito
                     &atributo-ref=nome-abrev
                     &variavel-ref=c-nome-deposito
                     &where="deposito.cod-depos = input frame {&frame-name} it-doc-fisico.cod-depos"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-doc-fisico.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
        apply "F5" to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.cod-refer V-table-Win
ON F5 OF it-doc-fisico.cod-refer IN FRAME f-main /* Referància */
DO:

    {include/zoomvar.i &prog-zoom="inzoom/z01in377.w"
                       &campo=it-doc-fisico.cod-refer
                       &campozoom=cod-refer}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-doc-fisico.cod-refer IN FRAME f-main /* Referància */
DO:
        apply "F5" to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-prec-unitario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-prec-unitario V-table-Win
ON LEAVE OF de-prec-unitario IN FRAME f-main /* Preáo Unit†rio */
DO:

    if param-re.tipo-arredonda = 1 then
        assign de-prec-unitario:screen-value in frame {&frame-name} = string(round(input frame {&frame-name} de-prec-unitario,2),">>>>>,>>>,>>9.99").
    else        
        assign de-prec-unitario:screen-value in frame {&frame-name} = string(round(input frame {&frame-name} de-prec-unitario,5),">>>>>,>>>,>>9.99999").

    assign it-doc-fisico.valor:screen-value in frame {&frame-name} = string(input frame {&frame-name} it-doc-fisico.qt-do-for * 
        input frame {&frame-name} de-prec-unitario,">>>>>,>>>,>>9.9999").


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.it-codigo V-table-Win
ON F5 OF it-doc-fisico.it-codigo IN FRAME f-main /* Item */
DO:

    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo=it-doc-fisico.it-codigo
                       &campozoom=it-codigo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.it-codigo V-table-Win
ON LEAVE OF it-doc-fisico.it-codigo IN FRAME f-main /* Item */
DO:

    {include/leave.i &tabela=item
                     &atributo-ref=descricao-1
                     &variavel-ref=c-nome-item
                     &where="item.it-codigo = input frame {&frame-name} it-doc-fisico.it-codigo"}

    assign it-doc-fisico.cod-localiz:screen-value in frame {&frame-name} = item.cod-localiz.                 
    /*display item.cod-localiz @ it-doc-fisico.cod-localiz with frame {&frame-name}.*/
    assign it-doc-fisico.cod-depos:screen-value in frame {&frame-name} = item.deposito-pad.
    /*display item.deposito-pad @ it-doc-fisico.cod-depos with frame {&frame-name}.*/
    if item.tipo-contr <> 4 then do:
        find item-fornec where item-fornec.cod-emitente = doc-fisico.cod-emitente and
                               item-fornec.it-codigo    = item.it-codigo no-lock no-error.
        if available item-fornec then do:
            assign c-item-do-forn:screen-value in frame {&frame-name} = item-fornec.item-do-forn.
            /*display item-fornec.item-do-forn @ c-item-do-forn with frame {&frame-name}.*/
            assign de-indice = item-fornec.fator-conver / exp(10,item-fornec.num-casa-dec).
        end.            
    end.
    find item-fornec where item-fornec.cod-emitente = doc-fisico.cod-emitente and
                           item-fornec.it-codigo    = item.it-codigo no-lock no-error.
    if available item-fornec then 
        assign it-doc-fisico.un:screen-value in frame {&frame-name} = item-fornec.unid-med-for.
        /*display item-fornec.unid-med-for @ it-doc-fisico.un with frame {&frame-name}.*/
    else
        assign it-doc-fisico.un:screen-value in frame {&frame-name} = item.un.        
        /*display item.un @ it-doc-fisico.un with frame {&frame-name}.*/

    assign c-nossa-unidade:screen-value in frame {&frame-name} = item.un.    
    /*display item.un @ c-nossa-unidade with frame {&frame-name}.*/

    if item.tipo-con-est = 4 then
        enable it-doc-fisico.cod-refer with frame {&frame-name}.

    if  item.loc-unica = no then
        enable it-doc-fisico.cod-localiz with frame {&frame-name}.
        else 
        disable it-doc-fisico.cod-localiz with frame {&frame-name}.


    if item.tipo-con-est <> 1 then 
        enable it-doc-fisico.lote with frame {&frame-name}.

    if item.tipo-con-est = 2 then do:
        assign it-doc-fisico.qt-do-forn = 1
               it-doc-fisico.quantidade = 1.
        display it-doc-fisico.qt-do-forn
                it-doc-fisico.quantidade  with frame {&FRAME-NAME}.
        disable it-doc-fisico.qt-do-forn 
                it-doc-fisico.quantidade with frame {&FRAME-NAME}.
    end.
    else do:
        assign it-doc-fisico.qt-do-forn:screen-value in frame {&FRAME-NAME} = STRING(0)
               it-doc-fisico.quantidade:screen-value in frame {&FRAME-NAME} = STRING(0).               
        enable it-doc-fisico.qt-do-forn 
               it-doc-fisico.quantidade with frame {&FRAME-NAME}.
    end. 

    find familia where familia.fm-codigo = item.fm-codigo no-lock no-error.            

    if param-global.modulo-cp then
        enable it-doc-fisico.nr-ord-prod with frame {&frame-name}.    

    if param-re.preco-unit then
        enable de-prec-unitario with frame {&frame-name}.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-doc-fisico.it-codigo IN FRAME f-main /* Item */
DO:
        apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.lote V-table-Win
ON LEAVE OF it-doc-fisico.lote IN FRAME f-main /* Lote/SÇrie */
DO:

    find first saldo-estoq where saldo-estoq.it-codigo = input frame {&frame-name} it-doc-fisico.it-codigo and
                                 saldo-estoq.lote = input frame {&frame-name} it-doc-fisico.lote no-lock no-error.
    if available saldo-estoq then
        assign it-doc-fisico.dt-vali-lote:screen-value in frame {&frame-name} = string(saldo-estoq.dt-vali-lote).
        /*display saldo-estoq.dt-vali-lote @ it-doc-fisico.dt-vali-lote with frame {&frame-name}.*/
    if item.tipo-con-est > 2 and not available saldo-estoq then do:
        enable it-doc-fisico.dt-vali-lote with frame {&frame-name}.
        apply "entry" to it-doc-fisico.dt-vali-lote in frame {&frame-name}.
        return no-apply.
    end.                                           

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.nr-ord-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.nr-ord-prod V-table-Win
ON F5 OF it-doc-fisico.nr-ord-prod IN FRAME f-main /* Ordem Produá∆o */
DO:

    {include/zoomvar.i &prog-zoom="inzoom/z01in271.w"
                       &campo=it-doc-fisico.nr-ord-prod
                       &campozoom=nr-ord-produ}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.nr-ord-prod V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-doc-fisico.nr-ord-prod IN FRAME f-main /* Ordem Produá∆o */
DO:
        apply "F5" to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.qt-do-forn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.qt-do-forn V-table-Win
ON LEAVE OF it-doc-fisico.qt-do-forn IN FRAME f-main /* Qtde Emitente */
DO:

    assign it-doc-fisico.quantidade:screen-value in frame {&frame-name} = string(input frame {&frame-name} it-doc-fisico.qt-do-forn 
            / de-indice,">>>>>,>>9.9999").
    /*display input frame {&frame-name} it-doc-fisico.qt-do-forn / de-indice @
        it-doc-fisico.quantidade with frame {&frame-name}.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.valor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.valor V-table-Win
ON LEAVE OF it-doc-fisico.valor IN FRAME f-main /* Valor Total */
DO:

    assign de-prec-unitario:screen-value in frame {&frame-name} = string(input frame {&frame-name} it-doc-fisico.valor / 
        input frame {&frame-name} it-doc-fisico.qt-do-for,">>>>>,>>>,>>9.9999").

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

    {utp/ut-liter.i Nossa_unidade * R}
    assign c-nossa-unidade:label in frame {&frame-name} = return-value.

    if it-doc-fisico.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.      
    if it-doc-fisico.cod-refer:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.      
    if it-doc-fisico.nr-ord-prod:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.          
    if it-doc-fisico.cod-depos:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "it-doc-fisico"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "it-doc-fisico"}

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    assign l-inclui = yes.

    find doc-fisico where rowid(doc-fisico) = v-row-parent no-error.
    find last b-it-doc-fisico where b-it-doc-fisico.cod-emitente = doc-fisico.cod-emitente and
                                    b-it-doc-fisico.nro-docto    = doc-fisico.nro-docto and
                                    b-it-doc-fisico.serie-docto  = doc-fisico.serie-docto and
                                    b-it-doc-fisico.tipo-nota    = doc-fisico.tipo-nota no-lock no-error.
    if available b-it-doc-fisico then
        display b-it-doc-fisico.sequencia + param-re.inc-seq @ it-doc-fisico.sequencia with frame {&frame-name}.
    else
        display param-re.seq-item-um @ it-doc-fisico.sequencia with frame {&frame-name}.
    if param-re.pd-seq then
        enable it-doc-fisico.sequencia with frame {&frame-name}.

    assign l-da-nota-dev = no.
    if doc-fisico.tipo-nota = 3 then do:
        assign l-da-nota-dev = yes.    
        enable it-doc-fisico.dt-nota-dev with frame {&frame-name}.
        apply "entry" to it-doc-fisico.dt-nota-dev in frame {&frame-name}.
        return error.            
    end.                

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

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     return 'ADM-ERROR':U.

    assign it-doc-fisico.sequencia = input frame {&frame-name} it-doc-fisico.sequencia.

    find doc-fisico where rowid(doc-fisico) = v-row-parent no-error.
    if available doc-fisico then do:
        assign it-doc-fisico.serie-docto  = doc-fisico.serie-docto
               it-doc-fisico.nro-docto    = doc-fisico.nro-docto
               it-doc-fisico.cod-emitente = doc-fisico.cod-emitente
               it-doc-fisico.tipo-nota    = doc-fisico.tipo-nota.
    end.

    if l-da-nota-dev <> yes then 
        assign it-doc-fisico.dt-nota-dev  = ?.

    if doc-fisico.tipo-nota = 1 then do:

        assign it-doc-fisico.cod-emitente = doc-fisico.cod-emitente
               it-doc-fisico.serie-docto  = doc-fisico.serie-docto
               it-doc-fisico.nro-docto    = doc-fisico.nro-docto
               it-doc-fisico.tipo-nota    = doc-fisico.tipo-nota.    

        assign de-quantidade = it-doc-fisico.quantidade.
        for each prazo-compra use-index planejamento where 
            prazo-compra.it-codigo   = it-doc-fisico.it-codigo and
            prazo-compra.situacao    = 2 and
            prazo-compra.quant-saldo > 0 no-lock:

            find ordem-compra where ordem-compra.numero-ordem = prazo-compra.numero-ordem no-lock no-error.

            if not avail ordem-compra or 
               ordem-compra.cod-emitente <> doc-fisico.cod-emitente then next.

            if (prazo-compra.data-entrega > doc-fisico.dt-trans + param-re.variacao) or
               (prazo-compra.data-entrega < doc-fisico.dt-trans - param-re.variacao) then next.
            /* calcula preco unitario da ordem de compra */

            run rep/reapi002.p (input rowid(ordem-compra),
                                input rowid(doc-fisico),
                                output de-preco-unit,
                                output l-erro).         

            if de-preco-unit = ? then next.
            assign de-preco-unit-min = de-preco-unit - (de-preco-unit * familia.var-pre-perm / 100)
                   de-preco-unit-max = de-preco-unit + (de-preco-unit * familia.var-pre-perm / 100).
            if input frame {&frame-name} de-prec-unitario < de-preco-unit-min or
               input frame {&frame-name} de-prec-unitario > de-preco-unit-max then next.
            find b-prazo-compra where rowid(b-prazo-compra) = rowid(prazo-compra) exclusive-lock no-error.
            create rat-ordem.
            assign rat-ordem.cod-emitente = doc-fisico.cod-emitente
                   rat-ordem.serie-docto  = doc-fisico.serie-docto
                   rat-ordem.nro-docto    = doc-fisico.nro-docto
                   rat-ordem.nat-operacao = " "
                   rat-ordem.num-pedido   = ordem-compra.num-pedido
                   rat-ordem.numero-ordem = ordem-compra.numero-ordem
                   rat-ordem.parcela      = prazo-compra.parcela
                   rat-ordem.sequencia    = input frame {&frame-name} it-doc-fisico.sequencia
                   rat-ordem.encerrada    = no.

            if prazo-compra.quant-saldo >= de-quantidade then do:
                assign rat-ordem.quantidade = de-quantidade 
                       de-quantidade = 0
                       rat-ordem.qtidade-forn = rat-ordem.quantidade * de-indice.
                leave.
            end.
            else
                assign rat-ordem.quantidade = prazo-compra.quant-saldo
                       de-quantidade = de-quantidade - prazo-compra.quant-saldo
                       rat-ordem.qtidade-forn = rat-ordem.quantidade * de-indice.
        end.
        assign l-erro = no.        

        run rep/re0901c.w (input rowid(doc-fisico), input rowid(it-doc-fisico), output l-erro).
        if l-erro = yes then 
            apply "close" to this-procedure.
    end.        

    assign de-pre-unitario = input frame {&frame-name} de-prec-unitario.

    assign it-doc-fisico.valor:screen-value in frame {&frame-name} = string(input frame {&frame-name} it-doc-fisico.qt-do-for * 
        input frame {&frame-name} de-prec-unitario,">>>>>,>>>,>>9.9999").


  /* Code placed here will execute AFTER standard behavior.    */

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

    if input frame {&frame-name} it-doc-fisico.sequencia = 0 then
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    find first param-global no-lock no-error.
    find param-re use-index ind-usu where param-re.usuario = c-seg-usuario no-lock no-error.

    if param-re.tipo-arredonda = 1 then
        assign de-prec-unitario:screen-value in frame {&frame-name} = string(round(input frame {&frame-name} de-prec-unitario,2),">>>>>,>>>,>>9.99").
    else        
        assign de-prec-unitario:screen-value in frame {&frame-name} = string(round(input frame {&frame-name} de-prec-unitario,5),">>>>>,>>>,>>9.99999").
    assign de-indice       = 1
           de-quantidade   = 0
           de-quant-forn   = 0
           de-pre-unitario = 0
           l-inclui        = no.


  /* Code placed here will execute AFTER standard behavior.    */

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

    if doc-fisico.tipo-nota = 1 then do:
        find first item where item.it-codigo = input frame {&frame-name} it-doc-fisico.it-codigo no-lock no-error.
        if not available item then do:
            {include/i-vldprg.i} 
            {utp/ut-table.i mgind item 1}        
            run utp/ut-msgs.p (input "show", 
                               input 47, 
                               input return-value).
            apply "entry" to it-doc-fisico.it-codigo in frame {&frame-name}.
            return error.
        end.
        if input frame {&frame-name} it-doc-fisico.qt-do-forn <= 0 then do:
            {include/i-vldprg.i} 
            {utp/ut-field.i mgind it-doc-fisico qt-do-forn 1}
            run utp/ut-msgs.p (input "show", 
                               input 255, 
                               input return-value).
            apply "entry" to it-doc-fisico.qt-do-forn in frame {&frame-name}.
            return error.
        end.
        if input frame {&frame-name} it-doc-fisico.quantidade = 0 then do:
            {include/i-vldprg.i} 
            {utp/ut-field.i mgind it-doc-fisico quantidade 1}
            run utp/ut-msgs.p (input "show", 
                               input 1491, 
                               input return-value).
            apply "entry" to it-doc-fisico.quantidade in frame {&frame-name}.
            return error.
        end.
        find referencia where referencia.cod-refer = input frame {&frame-name} it-doc-fisico.cod-refer no-lock no-error.
        if not available referencia then do:
            {include/i-vldprg.i} 
            {utp/ut-table.i mgind referencia 1}        
            run utp/ut-msgs.p (input "show", 
                               input 47, 
                               input return-value).
            apply "entry" to it-doc-fisico.cod-refer in frame {&frame-name}.
            return error.
        end.
        if param-global.modulo-cp and input frame {&frame-name} it-doc-fisico.nr-ord-prod <> 0 then do:
            find ord-prod where ord-prod.nr-ord-prod = input frame {&frame-name} it-doc-fisico.nr-ord-prod no-lock no-error.
            if not available ord-prod then do:
                {include/i-vldprg.i} 
                {utp/ut-table.i mgind ord-prod 1}        
                run utp/ut-msgs.p (input "show", 
                                   input 47, 
                                   input return-value).
                apply "entry" to it-doc-fisico.nr-ord-prod in frame {&frame-name}.
                return error.
            end.
            if ord-prod.cod-estabel <> doc-fisico.cod-estabel then do:
                {include/i-vldprg.i} 
                run utp/ut-msgs.p (input "show", 
                                   input 5496, 
                                   input "").
                apply "entry" to it-doc-fisico.nr-ord-prod in frame {&frame-name}.
                return error.
            end.
            if ord-prod.estado = 7 or ord-prod.estado = 8 then do:
                {include/i-vldprg.i} 
                run utp/ut-msgs.p (input "show", 
                                   input 5674, 
                                   input "").
                apply "entry" to it-doc-fisico.nr-ord-prod in frame {&frame-name}.
                return error.
            end.
            if item.tipo-requis = 2 then do:
                {include/i-vldprg.i} 
                run utp/ut-msgs.p (input "show", 
                                   input 5675, 
                                   input "").
                apply "entry" to it-doc-fisico.nr-ord-prod in frame {&frame-name}.
                return error.
            end.
            if param-global.modulo-mi then do:
                find ord-manut where ord-manut.nr-ord-prod = ord-prod.nr-ord-prod no-lock no-error.
                if available ord-manut then do:
                    if ord-manut.estado-om = 3 or ord-manut.estado-om = 4 then do:
                        {include/i-vldprg.i} 
                        run utp/ut-msgs.p (input "show", 
                                           input 5676, 
                                           input "").
                        apply "entry" to it-doc-fisico.nr-ord-prod in frame {&frame-name}.
                        return error.
                    end.
                end.
            end.
        end.
        /*find deposito where deposito.cod-depos = input frame {&frame-name} it-doc-fisico.cod-depos no-lock no-error.
 *         if not available deposito then do:
 *             {include/i-vldprg.i} 
 *             {utp/ut-table.i mgind deposito 1}        
 *             run utp/ut-msgs.p (input "show", 
 *                                input 47, 
 *                                input return-value).
 *             apply "entry" to it-doc-fisico.cod-depos in frame {&frame-name}.
 *             return error.
 *         end*/.
        if item.tipo-con-est <> 1 then do:
            if input frame {&frame-name} it-doc-fisico.lote = "" then do:
                {include/i-vldprg.i} 
                {utp/ut-field.i mgind it-doc-fisico lote 1}
                run utp/ut-msgs.p (input "show", 
                                   input 255, 
                                   input return-value).
                apply "entry" to it-doc-fisico.lote in frame {&frame-name}.
                return error.
            end.
            if available saldo-estoq and saldo-estoq.cod-refer <> input frame {&frame-name} it-doc-fisico.cod-refer then do:
                {include/i-vldprg.i} 
                run utp/ut-msgs.p (input "show", 
                                   input 1785, 
                                   input "").
                apply "entry" to it-doc-fisico.lote in frame {&frame-name}.
                return error.
            end.
        end.    
        if param-re.preco-unit then do:
            if param-re.tipo-arredonda = 1 and input frame {&frame-name} de-prec-unitario < 0.005 then do:
                {include/i-vldprg.i} 
                run utp/ut-msgs.p (input "show", 
                                   input 5677, 
                                   input "").
                apply "entry" to de-prec-unitario in frame {&frame-name}.
                return error.
            end.
            if input frame {&frame-name} de-prec-unitario <> 0 and
                input frame {&frame-name} it-doc-fisico.valor <> 
                round((input frame {&frame-name} it-doc-fisico.qt-do-forn *
                input frame {&frame-name} de-prec-unitario),2) then do:
                {include/i-vldprg.i} 
                run utp/ut-msgs.p (input "show", 
                                   input 5678, 
                                   input "").
                if return-value = "no" then
                    apply "close" to this-procedure.                                   
            end.
        end.
    end.            

    if l-da-nota-dev = yes then do:
        if input frame {&frame-name} it-doc-fisico.dt-nota-dev = ? then do:
            {include/i-vldprg.i} 
            {utp/ut-field.i mgind it-doc-fisico dt-nota-dev 1}
            run utp/ut-msgs.p (input "show", 
                               input 729, 
                               input return-value).
            apply "entry" to it-doc-fisico.dt-nota-dev in frame {&frame-name}.
            return error.
        end.
    end.            
    find deposito where deposito.cod-depos = input frame {&frame-name} it-doc-fisico.cod-depos no-lock no-error.
        if not available deposito then do:
            {include/i-vldprg.i} 
            {utp/ut-table.i mgind deposito 1}        
            run utp/ut-msgs.p (input "show", 
                               input 47, 
                               input return-value).
            apply "entry" to it-doc-fisico.cod-depos in frame {&frame-name}.
            return error.
        end.

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
  {src/adm/template/snd-list.i "it-doc-fisico"}

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



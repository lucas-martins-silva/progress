&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V03IN442 2.00.01.021 } /*** 010121 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v03in442 MUT}
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
def new global shared var gr-var-modelo as rowid no-undo.
def new global shared var gr-modelo-cf as rowid no-undo.

/* Parameters Definitions ---       
                                    */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
def buffer b-var-modelo for var-modelo.
def var rw-var-modelo as rowid no-undo.

DEF VAR c-VarCusto        AS CHAR NO-UNDO.
def var l-cancela         as log format "yes/no" no-undo.
def var c-formula         as char format "x(15000)" initial "" no-undo.
def var c-lista           as char initial "CSMP,CSMO,CSPR,CSOE,CSRF,CSGGF,CSTT" no-undo.
def var c-nome            as char no-undo.
def var c-lista-var       as char no-undo.
def var i-lista-var       as int  no-undo.
def var c-tipo-result-aux as char no-undo.
def var c-param-msg       as char no-undo.

{cdp/cdcfgman.i}

&IF DEFINED (bf_man_preco_config) &THEN
    {include/i-lgcode.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES var-modelo
&Scoped-define FIRST-EXTERNAL-TABLE var-modelo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR var-modelo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS var-modelo.sequencia var-modelo.ind-ativa ~
var-modelo.nome-var var-modelo.ind-tipo-var var-modelo.descricao ~
var-modelo.log-override var-modelo.nr-tabela var-modelo.gera-narrativa ~
var-modelo.abreviatura var-modelo.valor-dec-pad var-modelo.valor-char-pad 
&Scoped-define ENABLED-TABLES var-modelo
&Scoped-define FIRST-ENABLED-TABLE var-modelo
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 rt-key rt-mold tgFormPreco ~
tgLogTabPre 
&Scoped-Define DISPLAYED-FIELDS var-modelo.sequencia var-modelo.ind-ativa ~
var-modelo.nome-var var-modelo.ind-tipo-var var-modelo.descricao ~
var-modelo.log-override var-modelo.nr-tabela var-modelo.gera-narrativa ~
var-modelo.abreviatura var-modelo.valor-dec-pad var-modelo.valor-char-pad 
&Scoped-define DISPLAYED-TABLES var-modelo
&Scoped-define FIRST-DISPLAYED-TABLE var-modelo
&Scoped-Define DISPLAYED-OBJECTS tgFormPreco tgLogTabPre cb-tipo-result ~
c-tabela-res text-2 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS tgFormPreco tgLogTabPre 
&Scoped-define ADM-ASSIGN-FIELDS tgFormPreco tgLogTabPre 
&Scoped-define ADM-MODIFY-FIELDS tgFormPreco tgLogTabPre 

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
DEFINE VARIABLE cb-tipo-result AS CHARACTER FORMAT "X(19)" INITIAL "1" 
     LABEL "Tipo Resultado":R17 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.57 BY 1 NO-UNDO.

DEFINE VARIABLE c-tabela-res AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .88 NO-UNDO.

DEFINE VARIABLE text-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13.57 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.57 BY 1.42.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58 BY 1.21.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 12.25.

DEFINE VARIABLE tgFormPreco AS LOGICAL INITIAL no 
     LABEL "Formaá∆o de Preáo" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.43 BY .83 NO-UNDO.

DEFINE VARIABLE tgLogTabPre AS LOGICAL INITIAL no 
     LABEL "Som. Tabela Preáo" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     var-modelo.sequencia AT ROW 1.17 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     var-modelo.ind-ativa AT ROW 1.25 COL 60
          VIEW-AS TOGGLE-BOX
          SIZE 11.72 BY .83
     var-modelo.nome-var AT ROW 2.71 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tgFormPreco AT ROW 2.75 COL 46
     tgLogTabPre AT ROW 2.75 COL 68
     var-modelo.ind-tipo-var AT ROW 4.42 COL 31.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
          "Configuraá∆o", 1,
          "Custos", 2,
          "LeadTime", 3
          SIZE 40 BY .75
     var-modelo.descricao AT ROW 5.75 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     cb-tipo-result AT ROW 7.33 COL 28.14 COLON-ALIGNED
     var-modelo.log-override AT ROW 7.33 COL 60
          VIEW-AS TOGGLE-BOX
          SIZE 20.86 BY .83
     var-modelo.nr-tabela AT ROW 9 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .88
     c-tabela-res AT ROW 9 COL 35.14 COLON-ALIGNED NO-LABEL
     var-modelo.gera-narrativa AT ROW 10.5 COL 32
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .75
     var-modelo.abreviatura AT ROW 11.75 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     var-modelo.valor-dec-pad AT ROW 13.33 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 26.29 BY .88
     var-modelo.valor-char-pad AT ROW 13.33 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     text-2 AT ROW 3.75 COL 30.72 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 4 COL 30
     RECT-3 AT ROW 10.25 COL 30
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.var-modelo
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
         HEIGHT             = 13.71
         WIDTH              = 88.86.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-tabela-res IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tipo-result IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN text-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tgFormPreco IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR TOGGLE-BOX tgLogTabPre IN FRAME f-main
   1 2 3                                                                */
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

&Scoped-define SELF-NAME cb-tipo-result
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-result V-table-Win
ON VALUE-CHANGED OF cb-tipo-result IN FRAME f-main /* Tipo Resultado */
DO:

    if cb-tipo-result:screen-value in frame {&frame-name} = {ininc/i02in442.i 04 01} then do:
      assign var-modelo.valor-dec-pad:hidden        in frame {&frame-name} = no
             var-modelo.valor-dec-pad:sensitive     in frame {&frame-name} = yes
             var-modelo.valor-char-pad:screen-value in frame {&frame-name} = ""
             var-modelo.valor-char-pad:sensitive    in frame {&frame-name} = no
             var-modelo.valor-char-pad:hidden       in frame {&frame-name} = yes.
    end.
    else if cb-tipo-result:screen-value in frame {&frame-name} = {ininc/i02in442.i 04 02} or
            cb-tipo-result:screen-value in frame {&frame-name} = {ininc/i02in442.i 04 03} then do:
      assign var-modelo.valor-dec-pad:screen-value in frame {&frame-name} = "0"
             var-modelo.valor-dec-pad:sensitive    in frame {&frame-name} = no
             var-modelo.valor-dec-pad:hidden       in frame {&frame-name} = yes
             var-modelo.valor-char-pad:hidden      in frame {&frame-name} = no
             var-modelo.valor-char-pad:sensitive   in frame {&frame-name} = yes.
    end.
    else 
      assign var-modelo.valor-dec-pad:screen-value  in frame {&frame-name} = "0"
             var-modelo.valor-dec-pad:hidden        in frame {&frame-name} = yes
             var-modelo.valor-char-pad:screen-value in frame {&frame-name} = ""
             var-modelo.valor-char-pad:hidden       in frame {&frame-name} = yes.

    if  cb-tipo-result:screen-value in frame {&frame-name} = {ininc/i02in442.i 04 03} then
        enable var-modelo.nr-tabela 
               with frame {&frame-name}.  
    else do:
        disable var-modelo.nr-tabela with frame {&frame-name}.  
        assign var-modelo.nr-tabela:screen-value = string(0)
               c-tabela-res:screen-value = "".
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME var-modelo.gera-narrativa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL var-modelo.gera-narrativa V-table-Win
ON VALUE-CHANGED OF var-modelo.gera-narrativa IN FRAME f-main /* Gera Narrativa */
DO:
 if var-modelo.gera-narrativa:checked  in frame {&FRAME-NAME}= no then do:
    assign var-modelo.abreviatura:screen-value in frame {&frame-name} = "".
    assign var-modelo.abreviatura:sensitive in frame {&FRAME-NAME} = no.
 end.
 else if var-modelo.gera-narrativa:checked in frame {&FRAME-NAME} = yes then
         assign var-modelo.abreviatura:sensitive in frame {&FRAME-NAME} = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME var-modelo.ind-tipo-var
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL var-modelo.ind-tipo-var V-table-Win
ON VALUE-CHANGED OF var-modelo.ind-tipo-var IN FRAME f-main /* Tipo Vari†vel */
DO:
  &IF DEFINED (bf_man_preco_config) &THEN
    find first modelo-cf no-lock where
               rowid(modelo-cf) = v-row-parent no-error.

      IF adm-new-record THEN DO: 

        if var-modelo.ind-tipo-var:screen-value in frame {&frame-name} = "2" THEN DO: 
           IF not can-find (first var-modelo where
                            var-modelo.mo-codigo = modelo-cf.mo-codigo and
                            var-modelo.ind-preco = yes) THEN
              assign tgFormPreco:sensitive in frame {&frame-name} = yes.
           ELSE 
              assign  tgFormPreco:checked   in frame {&frame-name} = no
                      tgFormPreco:sensitive in frame {&frame-name} = no.
           IF NOT can-find (first var-modelo where
                            var-modelo.mo-codigo     = modelo-cf.mo-codigo and
                            var-modelo.log-tab-preco = yes) then
              assign tgLogTabPre:sensitive in frame {&frame-name} = yes.
           else do:

              assign  tgLogTabPre:checked   in frame {&frame-name} = no
                      tgLogTabPre:sensitive in frame {&frame-name} = no.

           end.
        END. /* END do IF var-modelo.ind-tipo-var = 2 */
      END. /* END do IF adm-new-record  */

      ELSE DO:
    /* Alteraá∆o de registros */

          if var-modelo.ind-tipo-var:screen-value in frame {&frame-name} = "1" or var-modelo.ind-tipo-var:screen-value in frame {&frame-name} = "3" THEN DO:
              assign  tgLogTabPre:checked   in frame {&frame-name} = no
                      tgLogTabPre:sensitive in frame {&frame-name} = no
                      tgformPreco:checked   in frame {&frame-name} = no
                      tgformPreco:sensitive in frame {&frame-name} = no.
          end.

          if var-modelo.ind-tipo-var:screen-value in frame {&frame-name} = "2" then do:  

             if not can-find (first var-modelo where
                                    var-modelo.mo-codigo = modelo-cf.mo-codigo and
                                    var-modelo.ind-preco = yes and
                                    rowid(var-modelo) <> gr-var-modelo) THEN 

                   assign tgFormPreco:sensitive in frame {&frame-name} = yes.
               else
                   assign tgFormPreco:checked   in frame {&frame-name} = no
                          tgFormPreco:sensitive in frame {&frame-name} = no.




              if not can-find (first var-modelo where
                                     var-modelo.mo-codigo     = modelo-cf.mo-codigo and
                                     var-modelo.log-tab-preco = yes and
                                     rowid(var-modelo) <> gr-var-modelo) then  
                    assign tgLogTabPre:sensitive in frame {&frame-name} = yes
                           tgLogTabPre:checked   in frame {&frame-name} = yes.
               else
                   assign tgLogTabPre:checked   in frame {&frame-name} = no
                          tgLogTabPre:sensitive in frame {&frame-name} = no.



                           
              
          end.
      end.
  &endIF
  
  if var-modelo.ind-tipo-var:screen-value in frame {&frame-name} = "3" then


      assign c-tipo-result-aux = cb-tipo-result:screen-value in frame {&frame-name}
             cb-tipo-result:screen-value in frame {&frame-name} = {ininc/i02in442.i 04 04}
             cb-tipo-result:sensitive    in frame {&frame-name} = no.
  else
      assign cb-tipo-result:screen-value in frame {&frame-name} = if c-tipo-result-aux <> "" then
                                                                     c-tipo-result-aux
                                                                  else
                                                                     {ininc/i02in442.i 04 01}
             cb-tipo-result:sensitive    in frame {&frame-name} = yes.

  apply 'value-changed' to cb-tipo-result.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME var-modelo.nome-var
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL var-modelo.nome-var V-table-Win
ON F5 OF var-modelo.nome-var IN FRAME f-main /* Vari†vel */
DO:

&IF DEFINED (bf_man_204) &THEN
   assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=mfzoom/z01mf450.w
                  &campo=var-modelo.nome-var
                  &campozoom=nome-var
                  &campo2=var-modelo.descricao
                  &campozoom2=descricao}
   assign l-implanta = no.  
&ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL var-modelo.nome-var V-table-Win
ON LEAVE OF var-modelo.nome-var IN FRAME f-main /* Vari†vel */
DO:
&IF DEFINED (bf_man_204) &THEN

  do with frame {&frame-name}:
    find var-pad-cf where var-pad-cf.nome-var = var-modelo.nome-var:screen-value no-lock no-error.
    if avail var-pad-cf then do:
        
        assign var-modelo.ind-tipo-var:screen-value   = string(var-pad-cf.ind-tipo-var)
               var-modelo.descricao:screen-value      = var-pad-cf.descricao
               cb-tipo-result:screen-value            = {ininc/i02in442.i 04 var-pad-cf.tipo-result}
               var-modelo.nr-tabela:screen-value      = string(var-pad-cf.nr-tabela)
               var-modelo.gera-narrativa:checked      = var-pad-cf.gera-narrativa
               var-modelo.abreviatura:screen-value    = var-pad-cf.abreviatura.

        {include/leave.i &tabela=tabela-res
                         &atributo-ref=descricao
                         &variavel-ref=c-tabela-res
                         &where="tabela-res.nr-tabela = input frame {&frame-name} var-modelo.nr-tabela"}
    end.
  end.             

  apply 'value-changed' to /*var-modelo.ind-tipo-var.*/ cb-tipo-result.
  

&ENDIF


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL var-modelo.nome-var V-table-Win
ON MOUSE-SELECT-DBLCLICK OF var-modelo.nome-var IN FRAME f-main /* Vari†vel */
DO:

  apply 'F5' to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME var-modelo.nr-tabela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL var-modelo.nr-tabela V-table-Win
ON F5 OF var-modelo.nr-tabela IN FRAME f-main /* Tabela Resultados */
DO:
   assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z02in418.w
                  &campo=var-modelo.nr-tabela
                  &campozoom=nr-tabela}
   assign l-implanta = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL var-modelo.nr-tabela V-table-Win
ON LEAVE OF var-modelo.nr-tabela IN FRAME f-main /* Tabela Resultados */
DO:
   {include/leave.i &tabela=tabela-res
                    &atributo-ref=descricao
                    &variavel-ref=c-tabela-res
                    &where="tabela-res.nr-tabela = input frame {&frame-name} var-modelo.nr-tabela"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL var-modelo.nr-tabela V-table-Win
ON MOUSE-SELECT-DBLCLICK OF var-modelo.nr-tabela IN FRAME f-main /* Tabela Resultados */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgFormPreco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgFormPreco V-table-Win
ON VALUE-CHANGED OF tgFormPreco IN FRAME f-main /* Formaá∆o de Preáo */
DO:
    if self:checked then
        assign tgLogTabPre:checked   in frame {&frame-name} = no
               tgLogTabPre:sensitive in frame {&frame-name} = no.
    else
        assign tgLogTabPre:sensitive in frame {&frame-name} = yes.
END.

&Scoped-define SELF-NAME tgLogTabPre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgLogTabPre V-table-Win
ON VALUE-CHANGED OF tgLogTabPre IN FRAME f-main /* Tabela de Preáo */
DO:
    if self:checked then
        assign tgFormPreco:checked   in frame {&frame-name} = no
               tgFormPreco:sensitive in frame {&frame-name} = no.
    else
        assign tgFormPreco:sensitive in frame {&frame-name} = yes.

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

if var-modelo.nr-tabela:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
if var-modelo.nome-var:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

&IF DEFINED (bf_man_preco_config) &THEN
    {utp/ut-liter.i Formaá∆o_de_Preáo}
    assign tgFormPreco:label in frame {&frame-name} = trim(return-value).
    {utp/ut-liter.i Som._Tabela_Preáo}
    assign tgLogTabPre:label in frame {&frame-name} = trim(return-value).
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
  {src/adm/template/row-list.i "var-modelo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "var-modelo"}

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
  {utp/ut-rtlbl.i mgind var-modelo ind-tipo-var text-2}
  assign cb-tipo-result:screen-value = {ininc/i02in442.i 04 01}.
  disable var-modelo.nr-tabela 
          with frame {&frame-name}.  
  assign var-modelo.nr-tabela:screen-value = string(0)
         c-tabela-res:screen-value = "".

  find modelo-cf where rowid(modelo-cf) = v-row-parent no-lock no-error.

/*** Modificada a l¢gica para buscar corretamente a sequància para bancos Oracle ******/
  FOR last b-var-modelo NO-LOCK
     where b-var-modelo.mo-codigo = modelo-cf.mo-codigo BY b-var-modelo.sequencia:
  END.

  if avail b-var-modelo then do:
     assign var-modelo.sequencia:screen-value in frame {&FRAME-NAME} =
                                 string(b-var-modelo.sequencia + 10).
  end.
  else
     assign var-modelo.sequencia:screen-value in frame {&FRAME-NAME} = "10".
/**************************************************************************************/  
/* no EMS 204 a l¢gica acima funciona, no ems205 n∆o por que os indices da tabela mudaram */
/*                                                                                    */
/*   IF NOT CAN-FIND (FIRST b-var-modelo                                              */
/*          where b-var-modelo.mo-codigo = modelo-cf.mo-codigo) THEN                  */
/*            assign var-modelo.sequencia:screen-value in frame {&FRAME-NAME} = "10". */
/*   ELSE  DO:                                                                        */
/*       FIND last b-var-modelo NO-LOCK                                               */
/*          where b-var-modelo.mo-codigo = modelo-cf.mo-codigo.                       */
/*                                                                                    */
/*       IF AVAIL b-var-modelo THEN                                                   */
/*          assign var-modelo.sequencia:screen-value in frame {&FRAME-NAME} =         */
/*                                      string(b-var-modelo.sequencia + 10).          */
/*   END.                                                                             */
/***************************************************************************************/

  assign var-modelo.valor-dec-pad:hidden       in frame {&frame-name} = no
         var-modelo.valor-dec-pad:sensitive    in frame {&frame-name} = yes
         var-modelo.valor-dec-pad:screen-value in frame {&frame-name} = "0"
         var-modelo.valor-char-pad:sensitive   in frame {&frame-name} = no
         var-modelo.valor-char-pad:hidden      in frame {&frame-name} = yes
         var-modelo.log-override:checked in frame {&frame-name} = yes.     

  /* EMS 205 */
  &IF DEFINED (bf_man_preco_config) &THEN

    if avail var-modelo and 
             var-modelo.ind-preco = yes then
          assign tgFormPreco:sensitive in frame {&frame-name} = YES
                 tgFormPreco:checked   in frame {&frame-name} = var-modelo.ind-preco.  
    else do:
      find first modelo-cf no-lock where
           rowid(modelo-cf) = v-row-parent no-error.
      if can-find (first var-modelo where
                         var-modelo.mo-codigo = modelo-cf.mo-codigo and
                         var-modelo.ind-preco = yes) then
          assign tgFormPreco:sensitive in frame {&frame-name} = no
                 tgFormPreco:checked   in frame {&frame-name} = no.

      /* Edith: e testar com o campo da tabela vai deixar os campos form.preco e tab. preco 
      habilitados, caso a ultima inclus∆o tenha sido do tipo custo, mas o default desta
      tela Ç vir marcado como vari†vel de configuraá∆o  */

      else if avail var-modelo and
                    var-modelo.ind-tipo-var = 2 then 
          ASSIGN tgFormPreco:sensitive in frame {&frame-name} = yes.
      else
          assign tgFormPreco:sensitive in frame {&frame-name} = no
                 tgFormPreco:checked   in frame {&frame-name} = no.
    end.

    if avail var-modelo and 
             var-modelo.log-tab-preco = yes then 
          assign tgLogTabPre:sensitive in frame {&frame-name} = yes 
                 tgLogTabPre:checked   in frame {&frame-name} = var-modelo.log-tab-preco.
    else do:
      find first modelo-cf no-lock where
           rowid(modelo-cf) = v-row-parent no-error.
      if can-find (first var-modelo where
                         var-modelo.mo-codigo     = modelo-cf.mo-codigo and
                         var-modelo.log-tab-preco = yes) then 
          assign tgLogTabPre:sensitive in frame {&frame-name} = no
                 tgLogTabPre:checked   in frame {&frame-name} = no.
      else if avail var-modelo and
                    var-modelo.ind-tipo-var = 2 then 
          assign tgLogTabPre:sensitive in frame {&frame-name} = yes.
      else
          assign tgLogTabPre:sensitive in frame {&frame-name} = no
                 tgLogTabPre:checked   in frame {&frame-name} = no.
    end.

  &ELSE
    assign tgFormPreco:visible in frame {&frame-name} = no
           tgLogTabPre:visible in frame {&frame-name} = no.
  &ENDIF  
  /** Habilita em tela os campos na inclus∆o de vari†veis **/
  assign var-modelo.ind-tipo-var:sensitive in frame {&frame-name} = yes
         cb-tipo-result:sensitive          in frame {&frame-name} = yes.  

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
  /*  {include/i-valid.i}*/
  /* Ponha na pi-validate todas as validaá‰es */

  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
    DEFINE VARIABLE l-preco AS LOGICAL    NO-UNDO.

    ASSIGN l-preco = tgFormPreco:CHECKED IN FRAME {&FRAME-NAME}.

 run pi-validate.
 if return-value = "adm-error" then
    return "adm-error".

 assign input frame {&frame-name} cb-tipo-result.

 if adm-new-record then do:

     find modelo-cf NO-LOCK
          where rowid(modelo-cf) = v-row-parent  no-error.
     if avail modelo-cf then do:

         find first var-modelo NO-LOCK
              where var-modelo.mo-codigo = modelo-cf.mo-codigo
                and var-modelo.sequencia = input frame {&frame-name} var-modelo.sequencia no-error.
         if  avail var-modelo then do:       
             run utp/ut-msgs.p(input "show",
                               input 5776,
                               input "").
             apply 'entry' to var-modelo.sequencia in frame {&frame-name}.
             return 'ADM-ERROR':U.   
         end.
     end. 

     find first b-var-modelo
          where b-var-modelo.mo-codigo = modelo-cf.mo-codigo
            and b-var-modelo.nome-var  = 
                var-modelo.nome-var:screen-value in frame {&frame-name} 
             no-lock no-error.
     if  avail b-var-modelo then do:
         {utp/ut-table.i mgind var-modelo 1}
         run utp/ut-msgs.p(input "show",
                           input 1,
                           input return-value).
         apply 'entry' to var-modelo.nome-var in frame {&frame-name}.
         return 'ADM-ERROR':U.
     end.
  /* fim se inclus∆o de novo registro */

/*************************************************************************************************************/
/* Validar inclus∆o/modificaá∆o de mais de uma vari†vel tipo custo: formaá∆o preáo ou som. tabela preáo      */
/* Ref. FO 922.324 */
 find modelo-cf NO-LOCK
      where rowid(modelo-cf) = v-row-parent  no-error.
 if avail modelo-cf then do:
    IF can-find (first var-modelo WHERE var-modelo.mo-codigo = modelo-cf.mo-codigo AND
                                       var-modelo.ind-tipo-var = 2 AND
                                       var-modelo.ind-preco = YES) THEN DO:
        IF  tgFormPreco:checked   in frame {&frame-name} THEN DO:
            {utp/ut-liter.i Formaá∆o_de_Preáo *}
            run utp/ut-msgs.p(input "show",
                              input 28945,
                              input return-value ).
            apply 'entry' to tgFormPreco in frame {&frame-name}.
            return 'ADM-ERROR'.
        END.
        ASSIGN tgFormPreco = NO. /* estava quardando o valor anterior e salvava errado */ 
    END.

    IF can-find (first var-modelo WHERE var-modelo.mo-codigo = modelo-cf.mo-codigo AND
                                        var-modelo.ind-tipo-var = 2 AND
                                        var-modelo.log-tab-preco = YES) THEN DO:
        IF tgLogTabPre:checked   in frame {&frame-name} THEN DO:
           {utp/ut-liter.i Som._Tabela_Preáo *}
           run utp/ut-msgs.p(input "show",
                             input 28945,
                             input return-value ).
           apply 'entry' to tgLogTabPre in frame {&frame-name}.
           return 'ADM-ERROR'.
        END.
        ASSIGN tgLogTabPre = NO. /* estava quardando o valor anterior e salvava errado */ 
    END.
 end.
 end.
/*************************************************************************************************************/
/* Fim validaá∆o                                                                                             */
/*************************************************************************************************************/ 

/* Testar o nome da vari†vel */
if index("01234567890",substring(var-modelo.nome-var:screen-value in frame {&frame-name},1,1)) <> 0 
    or var-modelo.nome-var:screen-value in frame {&frame-name} = '' then do:
     run utp/ut-msgs.p (input "show",
                        input 6829,
                        input "").              
     apply 'entry' to var-modelo.nome-var in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.
 if  lookup (input frame {&frame-name} var-modelo.nome-var, c-lista) <> 0 then do:
     run utp/ut-msgs.p (input "show",
                        input 16521,
                        input "").              
     apply 'entry' to var-modelo.nome-var in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.

/* Testar a Tabela de Resultados */
 if var-modelo.ind-tipo-var:screen-value in frame {&frame-name} = "2" and 
     (tgFormPreco:checked in frame {&frame-name} OR
      tgLogTabPre:checked in frame {&frame-name}) AND
    (cb-tipo-result:screen-value        in frame {&frame-name} <> {ininc/i02in442.i 04 01} AND
     cb-tipo-result:screen-value        in frame {&frame-name} <> {ininc/i02in442.i 04 04} AND
     cb-tipo-result:screen-value        in frame {&frame-name} <> {ininc/i02in442.i 04 05} AND
     cb-tipo-result:screen-value        in frame {&frame-name} <> {ininc/i02in442.i 04 06}) THEN DO:

     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE c-texto1 AS CHARACTER  NO-UNDO.
         DEFINE VARIABLE c-texto2 AS CHARACTER  NO-UNDO.
         DEFINE VARIABLE c-texto3 AS CHARACTER  NO-UNDO.
         DEFINE VARIABLE c-texto4 AS CHARACTER  NO-UNDO.
         RUN utp/ut-liter.p (trim({ininc/i02in442.i 04 01}), "*", "").
         assign c-texto1 = return-value.
         RUN utp/ut-liter.p (trim({ininc/i02in442.i 04 04}), "*", "").
         assign c-texto2 = return-value.
         RUN utp/ut-liter.p (trim({ininc/i02in442.i 04 05}), "*", "").
         assign c-texto3 = return-value.
         RUN utp/ut-liter.p (trim({ininc/i02in442.i 04 06}), "*", "").
         assign c-texto4 = return-value.
         {utp/ut-liter.i ou *}
         run utp/ut-msgs.p(input "show",
                           input 28665,
                           input cb-tipo-result + "~~" + 
                                 c-texto1 + ", " + c-texto2 + ", " +
                                 c-texto3 + " " + return-value + " " + c-texto4).
     &else
         ASSIGN c-param-msg = {ininc/i02in442.i 04 01} + ", " + {ininc/i02in442.i 04 04} + ", " + 
                              {ininc/i02in442.i 04 05} + " ou " + {ininc/i02in442.i 04 06}.
         run utp/ut-msgs.p(input "show",
                           input 28665,
                           input cb-tipo-result + "~~" + c-param-msg ).
     &endif


      apply 'entry' to cb-tipo-result in frame {&frame-name}.
      return 'ADM-ERROR'.
 END.
 if  cb-tipo-result:screen-value in frame {&frame-name} = {ininc/i02in442.i 04 03} then do:  
        find first tabela-res
           where tabela-res.nr-tabela = integer(var-modelo.nr-tabela:screen-value in frame {&frame-name})
           no-lock no-error.
        if not avail tabela-res then do:
             {utp/ut-table.i mgind tabela-res 1}
             run utp/ut-msgs.p(input "show",
                               input 56,
                               input return-value).
             apply 'entry' to var-modelo.nr-tabela in frame {&frame-name}.
             return 'ADM-ERROR'.
        end.
        else do:
            if var-modelo.valor-char-pad:screen-value in frame {&frame-name} <> "" then do:
                find c-tab-res where
                     c-tab-res.nr-tabela = integer(var-modelo.nr-tabela:screen-value in frame {&frame-name}) and
                     c-tab-res.descricao = var-modelo.valor-char-pad:screen-value in frame {&frame-name}
                     no-lock no-error.
                if not avail c-tab-res then do:
                    run utp/ut-msgs.p(input "show",
                                      input 26860,
                                      input var-modelo.valor-char-pad:screen-value in frame {&frame-name} + "~~" +
                                            var-modelo.nr-tabela:screen-value in frame {&frame-name}).
                    apply 'entry' to var-modelo.valor-char-pad in frame {&frame-name}.
                    return 'ADM-ERROR'.
                end.
            end.
        end.
 end.
 if (cb-tipo-result:screen-value            in frame {&frame-name} = {ininc/i02in442.i 04 01} or
     cb-tipo-result:screen-value            in frame {&frame-name} = {ininc/i02in442.i 04 02} or
     cb-tipo-result:screen-value            in frame {&frame-name} = {ininc/i02in442.i 04 03}) and 
    (var-modelo.valor-dec-pad:screen-value  in frame {&frame-name} = "?"  or
     var-modelo.valor-char-pad:screen-value in frame {&frame-name} = "?") then do:                   
     run utp/ut-msgs.p(input "show",
                       input 25976,
                       input "?").
     apply 'entry' to var-modelo.valor-dec-pad in frame {&frame-name}.
     return 'ADM-ERROR'.
 end.

 assign cb-tipo-result.

                  /*** VALIDAÄ«O VALORES = "AND, E, OR, OU ..." ****/

 def var c-liter-e   as char format "x(03)" no-undo.
 def var c-liter-ou  as char format "x(03)" no-undo.
 def var c-liter-cte as char format "x(10)" no-undo.
 def var c-liter-op  as char format "x(16)" no-undo.

 {utp/ut-liter.i E * r}
 assign c-liter-e = trim(return-value).
 {utp/ut-liter.i OU * r}
 assign c-liter-ou = trim(return-value).
 {utp/ut-liter.i Operador_L¢gico * r}
 assign c-liter-op = trim(return-value).

 {utp/ut-field.i mgind var-modelo nome-var 1}
 assign c-liter-cte = trim(return-value).

 if trim(input frame {&frame-name} var-modelo.nome-var) = c-liter-e then do:
    run utp/ut-msgs.p (input "show",
                       input 17031,
                       input c-liter-cte + "~~" + 
                             c-liter-op  + "~~" + 
                             c-liter-e).
    apply "entry" to var-modelo.nome-var in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end.
 if trim(input frame {&frame-name} var-modelo.nome-var) = c-liter-ou then do:
    run utp/ut-msgs.p (input "show",
                       input 17031,
                       input c-liter-cte + "~~" + 
                             c-liter-op  + "~~" + 
                             c-liter-ou).
    apply "entry" to var-modelo.nome-var in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end. 
 if trim(input frame {&frame-name} var-modelo.nome-var) = ">" then do:
    run utp/ut-msgs.p (input "show",
                       input 17031,
                       input c-liter-cte + "~~" + 
                             c-liter-op  + "~~" + 
                             ">").
    apply "entry" to var-modelo.nome-var in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end. 
 if trim(input frame {&frame-name} var-modelo.nome-var) = "<" then do:
    run utp/ut-msgs.p (input "show",
                       input 17031,
                       input c-liter-cte + "~~" + 
                             c-liter-op  + "~~" + 
                             "<").
    apply "entry" to var-modelo.nome-var in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end. 
 if trim(input frame {&frame-name} var-modelo.nome-var) = "=" then do:
    run utp/ut-msgs.p (input "show",
                       input 17031,
                       input c-liter-cte + "~~" + 
                             c-liter-op  + "~~" + 
                             "=").
    apply "entry" to var-modelo.nome-var in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end. 
 if trim(input frame {&frame-name} var-modelo.nome-var) = "<>" then do:
    run utp/ut-msgs.p (input "show",
                       input 17031,
                       input c-liter-cte + "~~" + 
                             c-liter-op  + "~~" + 
                             "<>").
    apply "entry" to var-modelo.nome-var in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end. 
 if trim(input frame {&frame-name} var-modelo.nome-var) = "<=" then do:
    run utp/ut-msgs.p (input "show",
                       input 17031,
                       input c-liter-cte + "~~" + 
                             c-liter-op  + "~~" + 
                             "<=").
    apply "entry" to var-modelo.nome-var in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end.
 if trim(input frame {&frame-name} var-modelo.nome-var) = ">=" then do:
    run utp/ut-msgs.p (input "show",
                       input 17031,
                       input c-liter-cte + "~~" + 
                             c-liter-op  + "~~" + 
                             ">=").
    apply "entry" to var-modelo.nome-var in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end.
/** Validaá∆o da descriá∆o **/
IF TRIM(INPUT FRAME {&FRAME-NAME} var-modelo.descricao) = "" THEN DO:
    run utp/ut-msgs.p(input "show",
                      input 190,
                      input ",").
    return 'ADM-ERROR':U.
END.

                              /*** FIM VALID. ***/

&IF DEFINED (bf_man_204) &THEN

  assign c-nome = var-modelo.nome-var:screen-value in frame {&frame-name}.

  assign c-nome = replace(c-nome," ","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 25960,
                        input "").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,">","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input ">").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,"<","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input "<").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,"-","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input "-").
      return 'ADM-ERROR':U.
  end.  

  assign c-nome = replace(c-nome,"+","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input "+").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,"/","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input "/").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,"*","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input "*").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,"=","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input "=").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,"[","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input "[").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,"]","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input "]").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,"(","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input "(").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,")","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input ")").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,":","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input ":").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,";","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input ";").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,"&","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input "&").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,".","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input ".").
      return 'ADM-ERROR':U.
  end.

  assign c-nome = replace(c-nome,",","0").
  if c-nome <> var-modelo.nome-var:screen-value in frame {&frame-name} then do:
      run utp/ut-msgs.p(input "show",
                        input 6665,
                        input ",").
      return 'ADM-ERROR':U.
  end.

  do with frame {&frame-name}:
    find var-pad-cf where var-pad-cf.nome-var = var-modelo.nome-var:screen-value no-lock no-error.
    if not avail var-pad-cf and 
           adm-new-record   then do:
        run utp/ut-msgs.p(input "show",
                          input 25957,
                          input "").
        if return-value = "yes" then do:
            create var-pad-cf.
            assign var-pad-cf.nome-var       = var-modelo.nome-var:screen-value
                   var-pad-cf.ind-tipo-var   = int(var-modelo.ind-tipo-var:screen-value)
                   var-pad-cf.descricao      = var-modelo.descricao:screen-value
                   var-pad-cf.nr-tabela      = int(var-modelo.nr-tabela:screen-value)
                   var-pad-cf.gera-narrativa = var-modelo.gera-narrativa:checked
                   var-pad-cf.abreviatura    = var-modelo.abreviatura:screen-value
                   var-pad-cf.tipo-result    = {ininc/i02in442.i 06 cb-tipo-result}.
        end.
    end.
  end.             

&ENDIF

   /* Dispatch standard ADM method. */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
   if RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */ 

  /* Code placed here will execute AFTER standard behavior.    */
   if  avail var-modelo then do:
      assign var-modelo.tipo-result = {ininc/i02in442.i 06 cb-tipo-result}.  
      &IF DEFINED (bf_man_preco_config) &THEN
          assign var-modelo.ind-preco     = tgFormPreco:checked in frame {&frame-name}.
                 var-modelo.log-tab-preco = tgLogTabPre:checked in frame {&frame-name}.
      &ENDIF
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  find modelo-cf where rowid(modelo-cf) = v-row-parent NO-LOCK no-error.
  if avail modelo-cf then
     assign var-modelo.mo-codigo = modelo-cf.mo-codigo.
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

   if avail var-modelo then do:
      find tabela-res 
         where tabela-res.nr-tabela = var-modelo.nr-tabela
         no-lock no-error.
      assign c-tabela-res = if avail tabela-res then tabela-res.descricao else "":U.

      do with frame {&frame-name}:
          /*alterado porque esta eliminando o sÇtimo registro do combo-box e estava dando erro no by-you*/
          /*if var-modelo.tipo-result <> 7 then do:
              assign c-lista-var = entry(1,{ininc/i02in442.i 03}).
              do i-lista-var = 2 to num-entries({ininc/i02in442.i 03}): 
                  if entry(i-lista-var,{ininc/i02in442.i 03}) <> {ininc/i02in442.i 04 07} then
                  c-lista-var = c-lista-var + "," + entry(i-lista-var,{ininc/i02in442.i 03}).
              end.
              &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                  run utp/ut-lstit.p (input-output c-lista-var).
                  assign cb-tipo-result:list-item-pairs = c-lista-var.
              &else
                  assign cb-tipo-result:list-items = c-lista-var.
              &endif
          end.
          else*/
              &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                  DEFINE VARIABLE cLista AS CHARACTER  NO-UNDO.
                  assign cLista = {ininc/i02in442.i 03}.
                  run utp/ut-lstit.p (input-output cLista).
                  assign cb-tipo-result:list-item-pairs = cLista.
              &else
                  assign cb-tipo-result:list-items = {ininc/i02in442.i 03}.
              &endif
      end.      

   end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */ 

  if  avail var-modelo then do with frame {&frame-name}:
      assign cb-tipo-result:screen-value = {ininc/i02in442.i 04 var-modelo.tipo-result}.
  end.
  else
      assign cb-tipo-result:screen-value = {ininc/i02in442.i 04 01}.

  if avail var-modelo then do:

    if var-modelo.tipo-result = 1 then do:
      assign var-modelo.valor-dec-pad:hidden       in frame {&frame-name} = no
             var-modelo.valor-dec-pad:sensitive    in frame {&frame-name} = yes
             var-modelo.valor-dec-pad:screen-value in frame {&frame-name} = string(var-modelo.valor-dec-pad)
             var-modelo.valor-char-pad:sensitive   in frame {&frame-name} = no
             var-modelo.valor-char-pad:hidden      in frame {&frame-name} = yes.
    end.
    else if var-modelo.tipo-result = 2 or
            var-modelo.tipo-result = 3 then do:
      assign var-modelo.valor-dec-pad:sensitive     in frame {&frame-name} = no
             var-modelo.valor-dec-pad:hidden        in frame {&frame-name} = yes
             var-modelo.valor-char-pad:hidden       in frame {&frame-name} = no
             var-modelo.valor-char-pad:sensitive    in frame {&frame-name} = yes
             var-modelo.valor-char-pad:screen-value in frame {&frame-name} = var-modelo.valor-char-pad.
    end.
    else 
      assign var-modelo.valor-dec-pad:hidden     in frame {&frame-name} = yes
             var-modelo.valor-char-pad:hidden    in frame {&frame-name} = yes.
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
  run get-attribute ('adm-new-record').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

   if adm-new-record = no then do:
      assign var-modelo.nome-var:sensitive in frame {&FRAME-NAME} = no
             var-modelo.sequencia:sensitive in frame {&FRAME-NAME} = no.
      if var-modelo.tipo-result = 7 then
          disable cb-tipo-result with frame {&frame-name}.
   end.
   else do:
      assign var-modelo.nome-var:sensitive in frame {&FRAME-NAME} = yes
             var-modelo.sequencia:sensitive in frame {&FRAME-NAME} = yes
             var-modelo.nr-tabela:sensitive in frame {&FRAME-NAME} = no.
   end.

   if avail var-modelo then do:   
       if var-modelo.ind-tipo-var = 3 then 
          assign var-modelo.ind-tipo-var:sensitive in frame {&frame-name} = no
                 cb-tipo-result:sensitive          in frame {&frame-name} = no.
       else
          assign var-modelo.ind-tipo-var:sensitive in frame {&frame-name} = yes
                 cb-tipo-result:sensitive          in frame {&frame-name} = yes.

       if var-modelo.tipo-result = 3 then
          assign var-modelo.nr-tabela:sensitive in frame {&FRAME-NAME} = yes.
       else assign var-modelo.nr-tabela:sensitive in frame {&FRAME-NAME} = no.

       if var-modelo.gera-narrativa = no then do:
          assign var-modelo.abreviatura:sensitive in frame {&FRAME-NAME} = no.
       end.
       else if var-modelo.gera-narrativa = yes then
               assign var-modelo.abreviatura:sensitive in frame {&FRAME-NAME} = yes.
   end.            

  &IF DEFINED (bf_man_preco_config) &THEN
    if avail var-modelo and 
             var-modelo.ind-preco = yes then 
          assign tgFormPreco:sensitive in frame {&frame-name} = yes
                 tgFormPreco:checked   in frame {&frame-name} = var-modelo.ind-preco.
    else do:
      find first modelo-cf no-lock where
           rowid(modelo-cf) = v-row-parent no-error.
      if can-find (first var-modelo where
                         var-modelo.mo-codigo = modelo-cf.mo-codigo and
                         var-modelo.ind-preco = yes) then
          assign tgFormPreco:sensitive in frame {&frame-name} = no
                 tgFormPreco:checked   in frame {&frame-name} = no.
      else if avail var-modelo and
                    var-modelo.ind-tipo-var = 2 then
          assign tgFormPreco:sensitive in frame {&frame-name} = yes.
      else
          assign tgFormPreco:sensitive in frame {&frame-name} = no
                 tgFormPreco:checked   in frame {&frame-name} = no.
    end.

    if avail var-modelo and 
             var-modelo.log-tab-preco = yes then 
          assign tgLogTabPre:sensitive in frame {&frame-name} = yes
                 tgLogTabPre:checked   in frame {&frame-name} = var-modelo.log-tab-preco.
    else do:
      find first modelo-cf no-lock where
           rowid(modelo-cf) = v-row-parent no-error.
      if can-find (first var-modelo where
                         var-modelo.mo-codigo     = modelo-cf.mo-codigo and
                         var-modelo.log-tab-preco = yes) then
          assign tgLogTabPre:sensitive in frame {&frame-name} = no
                 tgLogTabPre:checked   in frame {&frame-name} = no.
      else if avail var-modelo and
                    var-modelo.ind-tipo-var = 2 then
          assign tgLogTabPre:sensitive in frame {&frame-name} = yes.
      else
          assign tgLogTabPre:sensitive in frame {&frame-name} = no
                 tgLogTabPre:checked   in frame {&frame-name} = no.
    end.

  &ELSE
    assign tgFormPreco:visible in frame {&frame-name} = no
           tgLogTabPre:visible in frame {&frame-name} = no.
  &ENDIF  
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
  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      DEFINE VARIABLE cLista AS CHARACTER  NO-UNDO.
      assign cLista = {ininc/i02in442.i 03}.
      run utp/ut-lstit.p (input-output cLista).
      assign cb-tipo-result:list-item-pairs in frame {&frame-name} = cLista.
  &else
      assign cb-tipo-result:list-items in frame {&frame-name} = {ininc/i02in442.i 03}.
  &endif 
  
  find modelo-cf where rowid(modelo-cf) = gr-modelo-cf no-lock no-error.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if not adm-new-record and 
  
     cb-tipo-result:screen-value in frame {&frame-name} = {ininc/i02in442.i 04 07} THEN DO:
        assign cb-tipo-result:sensitive = no.

  END.
  {utp/ut-rtlbl.i mgmfg var-modelo ind-tipo-var text-2}
  {utp/ut-field.i mgmfg var-modelo tipo-result 1}
  assign cb-tipo-result:label in frame {&frame-name} = return-value.                  

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
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

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
def input parameter v-row-parent-externo as rowid no-undo.

assign v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  /*{include/i-vldfrm.i} /* Validaá∆o de dicion†rio */*/

if can-find (constante where 
        constante.nome-cte = var-modelo.nome-var:screen-value in frame {&frame-name}) then do:
        run utp/ut-msgs.p (input "show",
                           input 25052,
                           input "").
        return "adm-error".
end.

if var-modelo.ind-tipo-var:screen-value in frame {&frame-name} = "3" then do:
    if adm-new-record then do:
        find modelo-cf 
             where rowid(modelo-cf) = v-row-parent NO-LOCK NO-ERROR.
        if can-find (first var-modelo where
                           var-modelo.mo-codigo    = modelo-cf.mo-codigo and
                           var-modelo.ind-tipo-var = 3) then do:
            run utp/ut-msgs.p (input "show",
                               input 26021,
                               input "").
            return "adm-error".
        end.
    end.
end.
else do:
    if var-modelo.nome-var:screen-value in frame {&frame-name} = "leadtime" then do:
        {utp/ut-liter.i Nome_da_vari†vel *}
        run utp/ut-msgs.p (input "show",
                           input 17031,
                           input  Return-value  + "~~" + 
                           "LEADTIME"  + "~~" + 
                           "LEADTIME").
        return "adm-error".
    end.
end.                           

do with frame {&frame-name}:
    if var-modelo.nome:screen-value = "and"       or
       var-modelo.nome:screen-value = "or"        or
       var-modelo.nome:screen-value = "e"         or
       var-modelo.nome:screen-value = "ou"        or
       var-modelo.nome:screen-value = "n∆o"       or
       var-modelo.nome:screen-value = "not"       or
       var-modelo.nome:screen-value = "int"       or
       var-modelo.nome:screen-value = "dec"       or
       var-modelo.nome:screen-value = "str"       or
       var-modelo.nome:screen-value = "abs"       or
       var-modelo.nome:screen-value = "sqr"       or
       var-modelo.nome:screen-value = "ucase"     or
       var-modelo.nome:screen-value = "lcase"     or
       var-modelo.nome:screen-value = "len"       or
       var-modelo.nome:screen-value = "substring" or
       var-modelo.nome:screen-value = "search"    or
       var-modelo.nome:screen-value = "replace"   or
       var-modelo.nome:screen-value = "round"     or
       var-modelo.nome:screen-value = "trunc"     or
       var-modelo.nome:screen-value = "fat"       or
       var-modelo.nome:screen-value = "pi"        or
       var-modelo.nome:screen-value = "ang"       or
       var-modelo.nome:screen-value = "rad"       or
       var-modelo.nome:screen-value = "sin"       or
       var-modelo.nome:screen-value = "cos"       or
       var-modelo.nome:screen-value = "tan"       or
       var-modelo.nome:screen-value = "sec"       or
       var-modelo.nome:screen-value = "cosec"     or
       var-modelo.nome:screen-value = "mod"       or
       var-modelo.nome:screen-value = "cotan" then do:
           run utp/ut-msgs.p (input "show",
                              input 25259,
                              input var-modelo.nome:screen-value).
           return "adm-error".
    end.

    /* Validaá∆o dos nomes das vari†veis padr∆o de Custos */
    &IF DEFINED (bf_man_preco_config) &THEN
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            if var-modelo.nome:screen-value = "csmp"  or
               var-modelo.nome:screen-value = "csmo"  or
               var-modelo.nome:screen-value = "cspr"  or
               var-modelo.nome:screen-value = "csoe"  or
               var-modelo.nome:screen-value = "csrf"  or
               var-modelo.nome:screen-value = "csre"  or
               var-modelo.nome:screen-value = "csggf" or
               var-modelo.nome:screen-value = "cstt"  or
               var-modelo.nome:screen-value = "rmco"  or
               var-modelo.nome:screen-value = "dhco"  or
               var-modelo.nome:screen-value = "suco"  or
               var-modelo.nome:screen-value = "eoco"  or
               var-modelo.nome:screen-value = "scco"  or
               var-modelo.nome:screen-value = "ohco"  or
               var-modelo.nome:screen-value = "ttco"  then do:
                {utp/ut-liter.i CSMP,_CSMO,_CSPR,_CSOE,_CSRF,_CSGGF,_CSTT *}
                run utp/ut-msgs.p (input "show",
                                   input 26791,
                                   input return-value).
                return "adm-error".
            end.
        &else
            &IF "{&LANGUAGE-CODE}" = "POR" &THEN
                if var-modelo.nome:screen-value = "csmp"  or
                   var-modelo.nome:screen-value = "csmo"  or
                   var-modelo.nome:screen-value = "cspr"  or
                   var-modelo.nome:screen-value = "csoe"  or
                   var-modelo.nome:screen-value = "csrf"  or
                   var-modelo.nome:screen-value = "csggf" or
                   var-modelo.nome:screen-value = "cstt"  then do:
                    run utp/ut-msgs.p (input "show",
                                       input 26791,
                                       input "CSMP, CSMO, CSPR, CSOE, CSRF, CSGGF, CSTT").
                    return "adm-error".
                end.
            &ENDIF
    
            &IF "{&LANGUAGE-CODE}" = "ESP" &THEN
                if var-modelo.nome:screen-value = "csmp"  or
                   var-modelo.nome:screen-value = "csmo"  or
                   var-modelo.nome:screen-value = "cspr"  or
                   var-modelo.nome:screen-value = "csoe"  or
                   var-modelo.nome:screen-value = "csre"  or
                   var-modelo.nome:screen-value = "csggf" or
                   var-modelo.nome:screen-value = "cstt"  then do:
                    run utp/ut-msgs.p (input "show",
                                       input 26791,
                                       input "CSMP, CSMO, CSPR, CSOE, CSRE, CSGGF, CSTT").
                    return "adm-error".
                end.    
            &ENDIF
    
            &IF "{&LANGUAGE-CODE}" = "ING" &THEN
                if var-modelo.nome:screen-value = "rmco"  or
                   var-modelo.nome:screen-value = "dhco"  or
                   var-modelo.nome:screen-value = "suco"  or
                   var-modelo.nome:screen-value = "eoco"  or
                   var-modelo.nome:screen-value = "scco"  or
                   var-modelo.nome:screen-value = "ohco" or
                   var-modelo.nome:screen-value = "ttco"  then do:
                    run utp/ut-msgs.p (input "show",
                                       input 26791,
                                       input "RMCO, DHCO, SUCO, EOCO, SCCO, OHCO, TTCO").
                    return "adm-error".
                end.    
            &ENDIF
        &endif  /*FNC_MULTI_IDIOMA*/
    &ENDIF    

end. 

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
  {src/adm/template/snd-list.i "var-modelo"}

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


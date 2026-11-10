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
{include/i-prgvrs.i V01IN637 2.00.01.018 } /*** "010118" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in637 MCQ}
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
def var v-row-parent as rowid no-undo.
def var c-aux      as char   format "x(04)" init "9999" no-undo.
def var c-decimal  as char   format "x(05)" no-undo.
def var c-formato  as char   format "x(14)" no-undo.
DEF VAR i-cdn-versao LIKE exame.cdn-versao NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES it-comp-exame item-compon-test
&Scoped-define FIRST-EXTERNAL-TABLE it-comp-exame


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR it-comp-exame, item-compon-test.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS it-comp-exame.tipo-result ~
it-comp-exame.nr-decimais it-comp-exame.unidade it-comp-exame.result-min ~
it-comp-exame.compl-res it-comp-exame.result-max it-comp-exame.nr-tabela ~
item-compon-test.qti-test-realzdo it-comp-exame.situacao it-comp-exame.descricao 
&Scoped-define ENABLED-TABLES it-comp-exame item-compon-test
&Scoped-define FIRST-ENABLED-TABLE it-comp-exame
&Scoped-define SECOND-ENABLED-TABLE item-compon-test
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-6 RECT-7 rt-key 
&Scoped-Define DISPLAYED-FIELDS it-comp-exame.it-codigo ~
it-comp-exame.cod-exame it-comp-exame.cod-comp it-comp-exame.descricao ~
it-comp-exame.tipo-result it-comp-exame.nr-decimais it-comp-exame.unidade ~
it-comp-exame.result-min it-comp-exame.compl-res it-comp-exame.result-max ~
it-comp-exame.nr-tabela item-compon-test.qti-test-realzdo ~
it-comp-exame.situacao 
&Scoped-define DISPLAYED-TABLES it-comp-exame item-compon-test
&Scoped-define FIRST-DISPLAYED-TABLE it-comp-exame
&Scoped-define SECOND-DISPLAYED-TABLE item-compon-test
&Scoped-Define DISPLAYED-OBJECTS c-result c-desc-item c-desc-exame ~
c-des-nr-tabela c-situacao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS it-comp-exame.cod-exame ~
it-comp-exame.cod-comp it-comp-exame.descricao it-comp-exame.situacao 
&Scoped-define ADM-ASSIGN-FIELDS it-comp-exame.it-codigo ~
it-comp-exame.cod-exame it-comp-exame.cod-comp it-comp-exame.descricao 
&Scoped-define ADM-MODIFY-FIELDS it-comp-exame.descricao

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
DEFINE VARIABLE c-des-nr-tabela AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-exame AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-result AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11.29 BY .67 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 21.72 BY 1.83.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 7.79.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68.14 BY 1.38.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.57 BY 3.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-result AT ROW 5.08 COL 13.14 COLON-ALIGNED NO-LABEL
     it-comp-exame.it-codigo AT ROW 1.17 COL 27.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 1.17 COL 45.43 COLON-ALIGNED NO-LABEL
     it-comp-exame.cod-exame AT ROW 2.17 COL 27.86 COLON-ALIGNED FORMAT ">>>>>9"
          VIEW-AS FILL-IN 
          SIZE 7.86 BY .88
     c-desc-exame AT ROW 2.17 COL 35.86 COLON-ALIGNED NO-LABEL
     it-comp-exame.cod-comp AT ROW 3.17 COL 27.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     it-comp-exame.descricao AT ROW 3.17 COL 34.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 33.29 BY .88
     it-comp-exame.tipo-result AT ROW 5.67 COL 25 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Num‚rico", 1,
"Tabela", 2,
"Texto", 3,
"Faixa", 4
          SIZE 48.43 BY .96
     it-comp-exame.nr-decimais AT ROW 7.25 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.29 BY .88
     it-comp-exame.unidade AT ROW 7.29 COL 60.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     it-comp-exame.result-min AT ROW 8.25 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     it-comp-exame.compl-res AT ROW 8.29 COL 60.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     it-comp-exame.result-max AT ROW 9.25 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     it-comp-exame.nr-tabela AT ROW 10.25 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-des-nr-tabela AT ROW 10.25 COL 20 COLON-ALIGNED NO-LABEL
     item-compon-test.qti-test-realzdo AT ROW 11.25 COL 15 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN
          SIZE 14 BY .88
     it-comp-exame.situacao AT ROW 10.29 COL 63.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Ativo", 1,
"Inativo", 2
          SIZE 18 BY .83
     c-situacao AT ROW 9.46 COL 61 COLON-ALIGNED NO-LABEL
     RECT-4 AT ROW 9.63 COL 62
     RECT-6 AT ROW 4.71 COL 1
     RECT-7 AT ROW 5.42 COL 14.43
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.it-comp-exame,mgcad.item-compon-test
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
         HEIGHT             = 11.75
         WIDTH              = 85.57.
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

{utp/ut-liter.i N£mero_de_Testes * c}
ASSIGN item-compon-test.qti-test-realzdo:LABEL = RETURN-VALUE .

/* SETTINGS FOR FILL-IN c-des-nr-tabela IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-exame IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-result IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-situacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-comp-exame.cod-comp IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN it-comp-exame.cod-exame IN FRAME f-main
   NO-ENABLE 1 2 EXP-FORMAT                                             */
/* SETTINGS FOR FILL-IN it-comp-exame.descricao IN FRAME f-main
   NO-ENABLE 1 2 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN it-comp-exame.it-codigo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR RADIO-SET it-comp-exame.situacao IN FRAME f-main
   1                                                                    */
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

&Scoped-define SELF-NAME it-comp-exame.cod-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-comp-exame.cod-comp V-table-Win
ON F5 OF it-comp-exame.cod-comp IN FRAME f-main /* Componente */
DO:
  assign l-implanta = yes.  
  {include/zoomvar.i &prog-zoom="inzoom/z01in050.w"
                     &campo=it-comp-exame.cod-comp
                     &campozoom=cod-comp
                     &parametros="run pi-seta-inicial in wh-pesquisa (input
                     input frame {&frame-name} it-comp-exame.cod-exame, INPUT i-cdn-versao)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-comp-exame.cod-comp V-table-Win
ON LEAVE OF it-comp-exame.cod-comp IN FRAME f-main /* Componente */
DO:
  if adm-new-record then do:

      find first comp-exame
           WHERE comp-exame.cod-exame  = input frame {&frame-name} it-comp-exame.cod-exame and
                 comp-exame.cod-comp   = input frame {&frame-name} it-comp-exame.cod-comp  AND 
                 comp-exame.cdn-versao = i-cdn-versao no-lock no-error.
      if avail comp-exame then do:
          find first it-comp-exame no-lock
              where it-comp-exame.cod-exame = comp-exame.cod-exame 
              and   it-comp-exame.cod-comp  = comp-exame.cod-comp 
              and   it-comp-exame.it-codigo = input frame {&frame-name} it-comp-exame.it-codigo
              no-error.
          if avail it-comp-exame then
              assign it-comp-exame.descricao:screen-value in frame {&frame-name} = it-comp-exame.descricao.
          else
            assign it-comp-exame.descricao:screen-value in frame {&frame-name} = comp-exame.descricao.
      end.
      ELSE
          assign it-comp-exame.descricao:screen-value in frame {&frame-name} = "".

      find comp-exame where
           comp-exame.cod-exame = input frame {&frame-name} it-comp-exame.cod-exame and
           comp-exame.cod-comp   = input frame {&frame-name} it-comp-exame.cod-comp  AND
           comp-exame.cdn-versao = i-cdn-versao
           no-lock no-error.
      if avail comp-exame then do:
          assign it-comp-exame.tipo-result:screen-value in frame {&frame-name} = string(comp-exame.tipo-result).
          if comp-exame.tipo-result <> 1 and
             comp-exame.tipo-result <> 4 then do:
              assign it-comp-exame.nr-decimais:screen-value in frame {&FRAME-NAME} = "0"
                     it-comp-exame.result-min:screen-value  in frame {&FRAME-NAME} = "0"
                     it-comp-exame.result-max:screen-value  in frame {&FRAME-NAME} = "0".
              disable it-comp-exame.nr-decimais
                      it-comp-exame.result-min
                      it-comp-exame.result-max with frame {&FRAME-NAME}.
          end.
          else
              enable it-comp-exame.nr-decimais
                     it-comp-exame.result-min
                     it-comp-exame.result-max with frame {&FRAME-NAME}.  
            
          if comp-exame.tipo-result = 2 then
              enable it-comp-exame.nr-tabela
                     it-comp-exame.compl-res with frame {&FRAME-NAME}.
          else do:
              assign it-comp-exame.nr-tabela:screen-value  in frame {&FRAME-NAME} = "0"
                     it-comp-exame.compl-res:screen-value  in frame {&FRAME-NAME} = ""
                     c-des-nr-tabela:screen-value       in frame {&FRAME-NAME} = "".
              disable it-comp-exame.nr-tabela
                      it-comp-exame.compl-res with frame {&FRAME-NAME}.
          end.

          if comp-exame.tipo-result <> 3 then
              enable it-comp-exame.unidade with frame {&FRAME-NAME}.
          else do:
              assign  it-comp-exame.unidade:screen-value  in frame {&FRAME-NAME} = "".
              disable it-comp-exame.unidade with frame {&FRAME-NAME}.
          end.
          assign c-decimal = "." + substr(c-aux,1,int(comp-exame.nr-decimais)).
          if  c-decimal = "." then
              assign c-decimal = "".
          assign c-formato = "->,>>>,>>9" + c-decimal.
          assign it-comp-exame.result-min:format in frame {&FRAME-NAME} = c-formato
                 it-comp-exame.result-max:format in frame {&FRAME-NAME} = c-formato.
          disp comp-exame.nr-decimais      @ it-comp-exam.nr-decimais
               comp-exame.result-min       @ it-comp-exam.result-min
               comp-exame.result-max       @ it-comp-exam.result-max
               comp-exame.nr-tabela        @ it-comp-exam.nr-tabela
               comp-exame.unidade          @ it-comp-exam.unidade
               comp-exame.compl-res        @ it-comp-exam.compl-res
               comp-exame.qti-test-realzdo @ item-compon-test.qti-test-realzdo 
               with frame {&frame-name}.
          find tab-result where
               tab-result.nr-tabela = comp-exame.nr-tabela
               no-lock no-error.
          if avail tab-result then
              disp tab-result.descricao @ c-des-nr-tabela
                   with frame {&frame-name}.
          if comp-exame.log-1 then
               assign it-comp-exame.situacao:screen-value in frame {&frame-name} = "1".
          else 
               assign it-comp-exame.situacao:screen-value in frame {&frame-name} = "2".
      end.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-comp-exame.cod-comp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-comp-exame.cod-comp IN FRAME f-main /* Componente */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-comp-exame.cod-exame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-comp-exame.cod-exame V-table-Win
ON F5 OF it-comp-exame.cod-exame IN FRAME f-main /* Exame */
DO:
  assign l-implanta = yes.  
  {include/zoomvar.i &prog-zoom="inzoom/z01in164.w"
                     &campo=it-comp-exame.cod-exame
                     &campozoom=cod-exame
                     &parametros="run pi-seta-inicial in wh-pesquisa (input
                     input frame {&frame-name} it-comp-exame.it-codigo)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-comp-exame.cod-exame V-table-Win
ON LEAVE OF it-comp-exame.cod-exame IN FRAME f-main /* Exame */
DO:
  {include/leave.i &tabela=exame
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-exame
                   &where="exame.cod-exame = input frame {&FRAME-NAME} it-comp-exame.cod-exame and exame.cdn-sit-vers = 2"} 
                   
  ASSIGN i-cdn-versao = IF AVAIL exame THEN exame.cdn-versao ELSE 0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-comp-exame.cod-exame V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-comp-exame.cod-exame IN FRAME f-main /* Exame */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-comp-exame.nr-decimais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-comp-exame.nr-decimais V-table-Win
ON LEAVE OF it-comp-exame.nr-decimais IN FRAME f-main /* Decimais */
DO:
 
  if input frame {&FRAME-NAME} it-comp-exame.nr-decimais > 4 then do:
      run utp/ut-msgs.p (input "show",
                         input 17500,
                         input 4).
       
      apply "entry" to it-comp-exame.nr-decimais in frame {&frame-name}.
      return no-apply.
  end.                                   
  
  /* Coloca resultado m¡nimo e resultado m ximo em seu formato */
  assign c-decimal = "." + substr(c-aux,1,int(input frame {&FRAME-NAME} it-comp-exame.nr-decimais)).
  if  c-decimal = "." then
      assign c-decimal = "".
  
  assign c-formato = "->,>>>,>>9" + c-decimal.
  assign it-comp-exame.result-min:format in frame {&FRAME-NAME} = c-formato
         it-comp-exame.result-max:format in frame {&FRAME-NAME} = c-formato.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-comp-exame.nr-tabela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-comp-exame.nr-tabela V-table-Win
ON F5 OF it-comp-exame.nr-tabela IN FRAME f-main /* Tabela */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom\z01in416.w"
                  &tabela=it-comp-exame
                  &atributo=nr-tabela}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-comp-exame.nr-tabela V-table-Win
ON LEAVE OF it-comp-exame.nr-tabela IN FRAME f-main /* Tabela */
DO:
  assign l-implanta = yes.
  {include/leave.i &tabela=tab-result
                   &atributo-ref=descricao
                   &variavel-ref=c-des-nr-tabela
                   &where="tab-result.nr-tabela = input frame {&FRAME-NAME} it-comp-exame.nr-tabela"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-comp-exame.nr-tabela V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-comp-exame.nr-tabela IN FRAME f-main /* Tabela */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-comp-exame.tipo-result
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-comp-exame.tipo-result V-table-Win
ON VALUE-CHANGED OF it-comp-exame.tipo-result IN FRAME f-main /* Tp Result */
DO:
  
  if integer(it-comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) <> 1 and
     integer(it-comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) <> 4 then do:
      assign it-comp-exame.nr-decimais:screen-value in frame {&FRAME-NAME} = "0"
             it-comp-exame.result-min:screen-value  in frame {&FRAME-NAME} = "0"
             it-comp-exame.result-max:screen-value  in frame {&FRAME-NAME} = "0".
      disable it-comp-exame.nr-decimais
              it-comp-exame.result-min
              it-comp-exame.result-max with frame {&FRAME-NAME}.
  end.
  else do:
      enable it-comp-exame.nr-decimais
             it-comp-exame.result-min
             it-comp-exame.result-max with frame {&FRAME-NAME}.  
      if integer(it-comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) = 1 then
          disable it-comp-exame.nr-tabela with frame {&frame-name}.
  end.
  
  if integer(it-comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) = 2 then
      enable it-comp-exame.nr-tabela
             it-comp-exame.compl-res with frame {&FRAME-NAME}.
  else do:
      assign it-comp-exame.nr-tabela:screen-value  in frame {&FRAME-NAME} = "0"
             it-comp-exame.compl-res:screen-value  in frame {&FRAME-NAME} = ""
             c-des-nr-tabela:screen-value       in frame {&FRAME-NAME} = "".
      disable it-comp-exame.compl-res
              it-comp-exame.nr-tabela with frame {&frame-name}.
  end.

  if integer(it-comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) <> 3 then
      enable it-comp-exame.unidade with frame {&FRAME-NAME}.
  else do:
      assign it-comp-exame.unidade:screen-value  in frame {&FRAME-NAME} = "".
      disable it-comp-exame.unidade with frame {&FRAME-NAME}.
  end.
  
  /************************/
  if adm-new-record then do:
     if integer(it-comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) = 4 or 
        integer(it-comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) = 1 then do:
          if avail comp-exame then DO:
              assign c-decimal = "." + substr(c-aux,1,int(comp-exame.nr-decimais)).
              if  c-decimal = "." then
                  assign c-decimal = "".
              assign c-formato = "->,>>>,>>9" + c-decimal.
              assign it-comp-exame.result-min:format in frame {&FRAME-NAME} = c-formato
                     it-comp-exame.result-max:format in frame {&FRAME-NAME} = c-formato.
              disp comp-exame.nr-decimais @ it-comp-exam.nr-decimais
                   comp-exame.result-min  @ it-comp-exam.result-min
                   comp-exame.result-max  @ it-comp-exam.result-max
                   comp-exame.nr-tabela   @ it-comp-exam.nr-tabela
                   comp-exame.unidade     @ it-comp-exam.unidade
                   comp-exame.compl-res   @ it-comp-exam.compl-res
                   with frame {&frame-name}.
          end.
     end.
  end.
  /************************/
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

  if it-comp-exame.nr-tabela:load-mouse-pointer ("image/lupa.cur") in frame {&FRAME-NAME} then.
  if it-comp-exame.cod-exame:load-mouse-pointer ("image/lupa.cur") in frame {&FRAME-NAME} then.
  if it-comp-exame.cod-comp:load-mouse-pointer ("image/lupa.cur") in frame {&FRAME-NAME} then.

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
  {src/adm/template/row-list.i "it-comp-exame"}
  {src/adm/template/row-list.i "item-compon-test"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "it-comp-exame"}
  {src/adm/template/row-find.i "item-compon-test"}

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
  {utp/ut-field.i mgind it-comp-exame situacao 01}
  assign c-situacao:screen-value in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind comp-exame tipo-result 01}
  assign c-result:screen-value in frame {&frame-name} = return-value.
  
  /* Code placed here will execute AFTER standard behavior.    */
  find item  where rowid(item) = v-row-parent no-lock no-error.
  if avail item then 
      disp item.it-codigo @ it-comp-exame.it-codigo 
           item.desc-item @ c-desc-item 
           with frame {&frame-name}.
  assign it-comp-exame.nr-decimais:screen-value in frame {&frame-name}= "3"
         item-compon-test.qti-test-realzdo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1".   


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
    
    if adm-new-record then do:
        find first it-comp-exame where
             it-comp-exame.cod-exame = input frame {&frame-name} it-comp-exame.cod-exame and
             it-comp-exame.cod-comp  = input frame {&frame-name} it-comp-exame.cod-comp  and
             it-comp-exame.it-codigo = input frame {&frame-name} it-comp-exame.it-codigo
             no-lock no-error.
        if avail it-comp-exame then do:
            {utp/ut-table.i mgind it-comp-exame 1}
            run utp/ut-msgs.p (input "show", 
                               input 1, 
                               input return-value).
            apply 'entry' to it-comp-exame.cod-exame in frame {&frame-name}.
            return error.
        end.
    end.    
        
    find first it-exame where
         it-exame.cod-exame = input frame {&frame-name} it-comp-exame.cod-exame and
         it-exame.it-codigo = input frame {&frame-name} it-comp-exame.it-codigo
         no-lock no-error.
    if not avail it-exame then do:
        {utp/ut-table.i mgind it-exame 1}
        run utp/ut-msgs.p (input "show", 
                           input 2, 
                           input return-value).
        apply 'entry' to it-comp-exame.cod-exame in frame {&frame-name}.
        return error.
    end.
    find exame 
        WHERE exame.cod-exame = input frame {&frame-name} it-comp-exame.cod-exame 
        AND   exame.cdn-versao = i-cdn-versao no-lock no-error.
    if not avail exame then do:
        {utp/ut-table.i mgind exame 1}
        run utp/ut-msgs.p (input "show",
                           input 2,
                           input return-value).
        apply 'entry' to it-comp-exame.cod-exame in frame {&frame-name}.
        return error.
    end.
    find first comp-exame where 
         comp-exame.cod-exame   = input frame {&frame-name} it-comp-exame.cod-exame and
         comp-exame.cod-comp   = input frame {&frame-name} it-comp-exame.cod-comp  AND
         comp-exame.cdn-versao = exame.cdn-versao
         no-lock no-error.       
    if not avail comp-exame then do:
        {utp/ut-table.i mgind comp-exame 1}
        run utp/ut-msgs.p (input "show",
                           input 2,
                           input return-value).
        apply 'entry' to it-comp-exame.cod-comp in frame {&frame-name}.
        return error.
    end.
    if it-comp-exame.nr-tabela:sensitive in frame {&frame-name} then do:
        find tab-result where 
             tab-result.nr-tabela = input frame {&frame-name} it-comp-exame.nr-tabela
             no-lock no-error.       
        if not avail tab-result then do:
            {utp/ut-table.i mgind tab-result 1}
            run utp/ut-msgs.p (input "show",
                               input 2,
                               input return-value).
            apply 'entry' to it-comp-exame.nr-tabela in frame {&frame-name}.
            return error.
        end.
    end.

    IF INPUT FRAME {&FRAME-NAME} item-compon-test.qti-test-realzdo = 0 THEN DO:
            {utp/ut-liter.i "N£mero de Testes" *}
            run utp/ut-msgs.p (input "show",
                               input 36,
                               input TRIM(RETURN-VALUE)).
            apply 'entry' to item-compon-test.qti-test-realzdo in frame {&frame-name}.
            return error.
    END.


    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    ASSIGN item-compon-test.cod-item         = input frame {&frame-name} it-comp-exame.it-codigo
           item-compon-test.cdn-exam         = input frame {&frame-name} it-comp-exame.cod-exame
           item-compon-test.cdn-compon-exam  = input frame {&frame-name} it-comp-exame.cod-comp
           item-compon-test.qti-test-realzdo = input frame {&frame-name} item-compon-test.qti-test-realzdo.    

    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

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
  find item  where rowid(item) = v-row-parent no-lock no-error.
  if available item  then do:
      assign it-comp-exame.it-codigo = item.it-codigo.
  end.

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
  if avail it-comp-exame then
      assign c-decimal = "." + substr(c-aux,1,it-comp-exame.nr-decimais).
      
  if  c-decimal = "." then
      assign c-decimal = "".

  assign c-formato = "->,>>>,>>9" + c-decimal
         it-comp-exame.result-min:format in frame {&FRAME-NAME} = c-formato
         it-comp-exame.result-max:format in frame {&FRAME-NAME} = c-formato.
         
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  {utp/ut-field.i mgind it-comp-exame situacao 01}
  assign c-situacao:screen-value in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind comp-exame tipo-result 01}
  assign c-result:screen-value in frame {&frame-name} = return-value.
  /* Code placed here will execute AFTER standard behavior.    */
  if not adm-new-record and 
     avail it-comp-exame then do:
      find exame where
           exame.cod-exame = it-comp-exame.cod-exame AND
           exame.cdn-sit-vers = 2 /* Liberado */
           no-lock no-error.
      if avail exame then
          disp exame.descricao @ c-desc-exame 
               with frame {&frame-name}.
      
      find tab-result where
           tab-result.nr-tab  = it-comp-exame.nr-tab
           no-lock no-error.
      if avail tab-result then
          disp tab-result.descricao @ c-des-nr-tabela
               with frame {&frame-name}.
  END.

  IF adm-new-record = NO AND AVAIL it-comp-exame THEN DO:
      FIND item-compon-test WHERE item-compon-test.cod-item = it-comp-exame.it-codigo  
         AND item-compon-test.cdn-exam        = it-comp-exame.cod-exame
         AND item-compon-test.cdn-compon-exam = it-comp-exame.cod-comp EXCLUSIVE-LOCK NO-ERROR.

      IF AVAIL item-compon-test THEN
          DISP item-compon-test.qti-test-realzdo WITH FRAME {&FRAME-NAME}.
      ELSE
          ASSIGN item-compon-test.qti-test-realzdo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1".     

      apply 'LEAVE' to it-comp-exame.cod-exame in frame {&frame-name}.
      
  END.


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
    if adm-new-record = yes then do:
        &if  defined(ADM-MODIFY-FIELDS) &then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
        &endif
    end.
    find item  where rowid(item) = v-row-parent no-lock no-error.
    if avail item then 
        disp item.it-codigo @ it-comp-exame.it-codigo 
             item.desc-item @ c-desc-item 
             with frame {&frame-name}.
    if not adm-new-record and 
       avail it-comp-exame then
        apply "value-changed" to it-comp-exame.tipo-result in frame {&FRAME-NAME}.
        
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
    
/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvar_chave V-table-Win 
PROCEDURE salvar_chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if avail it-comp-exame then
        assign it-comp-exame.cod-exame  = input frame {&FRAME-NAME} it-comp-exame.cod-exame
               it-comp-exame.cod-comp   = input frame {&FRAME-NAME} it-comp-exame.cod-comp
               it-comp-exame.it-codigo  = input frame {&frame-name} it-comp-exame.it-codigo.

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
  {src/adm/template/snd-list.i "it-comp-exame"}
  {src/adm/template/snd-list.i "item-compon-test"}

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


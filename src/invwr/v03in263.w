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
{include/i-prgvrs.i V03IN263 2.00.00.051 } /*** 010051 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN263 MUT}
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

{cdp/cdcfgman.i}
{cdp/cdcfgren.i}

&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
def new global shared var gr-operacao  as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define buffer b-operacao for operacao.

def var c-item           like item.it-codigo.
def var c-rot-fabric     like rot-fabric.cod-roteiro.

def temp-table tt-oper-2 like operacao use-index codigo.

{database/tgin/twp/twin263.i1 operacao tt-oper-2}

/* define variable c-handle     as   handle. */
define variable c-aux        like item.it-codigo.
define variable c-campo      as   character.
define variable c-tipo-rowid as   character.
DEFINE VARIABLE pto          LIKE operacao.pto-controle.
DEFINE VARIABLE l-valida     AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE l-primeira   AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE l-primeira-vez AS LOGICAL INITIAL YES NO-UNDO.


def var i-nr-operacao  like oper-pad.nr-oper-pad no-undo.

def var c-handle  as char   no-undo.
def var h-handle2 as handle no-undo.
def var h-handle  as handle no-undo.
DEF VAR l-alterada AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR l-alterou-oper-pad AS LOGICAL INIT NO NO-UNDO.  /**FO-998390  Descobrir se foi alterada a operacao padrao no momento de alterar a revisao ferramenta.**/

/*
*Este objeto foi eliminado da 205, somente ficando esta vers∆o.
*/

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
&Scoped-define EXTERNAL-TABLES operacao
&Scoped-define FIRST-EXTERNAL-TABLE operacao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR operacao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS operacao.nr-oper-pad operacao.descricao ~
operacao.revisao operacao.tipo-oper operacao.data-inicio ~
operacao.data-termino operacao.refugo-op operacao.proporcao ~
operacao.gm-codigo operacao.fi-codigo operacao.pto-controle ~
operacao.cd-mob-dir 
&Scoped-define ENABLED-TABLES operacao
&Scoped-define FIRST-ENABLED-TABLE operacao
&Scoped-Define ENABLED-OBJECTS rt-mold rt-mold1 rt-mold2 rt-mold3 rt-mold4 
&Scoped-Define DISPLAYED-FIELDS operacao.nr-oper-pad operacao.descricao ~
operacao.revisao operacao.tipo-oper operacao.data-inicio ~
operacao.data-termino operacao.refugo-op operacao.proporcao ~
operacao.gm-codigo operacao.fi-codigo operacao.pto-controle ~
operacao.cd-mob-dir 
&Scoped-define DISPLAYED-TABLES operacao
&Scoped-define FIRST-DISPLAYED-TABLE operacao
&Scoped-Define DISPLAYED-OBJECTS c-oper-pad-descricao Fi-titulo-tipo ~
c-grup-maquina-descricao c-ficha-metodo-descricao c-pto-controle-descricao ~
c-desc-mob-dir 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS operacao.gm-codigo 

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
DEFINE VARIABLE c-desc-mob-dir AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-ficha-metodo-descricao AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-grup-maquina-descricao AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-oper-pad-descricao AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-pto-controle-descricao AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE Fi-titulo-tipo AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 12.57 BY .63 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 2.25.

DEFINE RECTANGLE rt-mold1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 19.57 BY 2.25.

DEFINE RECTANGLE rt-mold2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 33 BY 2.25.

DEFINE RECTANGLE rt-mold3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 31.72 BY 2.25.

DEFINE RECTANGLE rt-mold4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 4.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     operacao.nr-oper-pad AT ROW 1.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     c-oper-pad-descricao AT ROW 1.17 COL 29 COLON-ALIGNED NO-LABEL
     operacao.descricao AT ROW 2.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 35.43 BY .88
     operacao.revisao AT ROW 2.17 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     operacao.tipo-oper AT ROW 3.96 COL 4.43 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Interna", 1,
"Externa", 2
          SIZE 13.43 BY 1.63
     operacao.data-inicio AT ROW 3.67 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     Fi-titulo-tipo AT ROW 3.33 COL 2.72 NO-LABEL
     operacao.data-termino AT ROW 4.67 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     operacao.refugo-op AT ROW 3.67 COL 72.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     operacao.proporcao AT ROW 4.67 COL 72.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     operacao.gm-codigo AT ROW 6.13 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-grup-maquina-descricao AT ROW 6.13 COL 34.57 COLON-ALIGNED NO-LABEL
     operacao.fi-codigo AT ROW 7.13 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-ficha-metodo-descricao AT ROW 7.13 COL 27.57 COLON-ALIGNED NO-LABEL
     operacao.pto-controle AT ROW 8.13 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-pto-controle-descricao AT ROW 8.13 COL 25.57 COLON-ALIGNED NO-LABEL
     operacao.cd-mob-dir AT ROW 9.13 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     c-desc-mob-dir AT ROW 9.13 COL 30 COLON-ALIGNED HELP
          "Descriá∆o da m∆o-de-obra direta" NO-LABEL
     rt-mold AT ROW 1 COL 1
     rt-mold1 AT ROW 3.5 COL 1
     rt-mold2 AT ROW 3.5 COL 21.29
     rt-mold3 AT ROW 3.5 COL 55
     rt-mold4 AT ROW 5.96 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.operacao
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
         HEIGHT             = 9.46
         WIDTH              = 85.72.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-mob-dir IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ficha-metodo-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-grup-maquina-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-oper-pad-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-pto-controle-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Fi-titulo-tipo IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN operacao.gm-codigo IN FRAME f-main
   2                                                                    */
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

&Scoped-define SELF-NAME operacao.cd-mob-dir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.cd-mob-dir V-table-Win
ON F5 OF operacao.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in566.w" 
                     &campo=operacao.cd-mob-dir
                     &campozoom=cd-mob-dir
                     &campo2=c-desc-mob-dir
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.cd-mob-dir V-table-Win
ON LEAVE OF operacao.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
   {include/leave.i &tabela=tab-mob-dir 
                    &atributo-ref=descricao 
                    &variavel-ref=c-desc-mob-dir
                    &where="tab-mob-dir.cd-mob-dir = input frame {&frame-name} operacao.cd-mob-dir"}  


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.cd-mob-dir V-table-Win
ON MOUSE-SELECT-DBLCLICK OF operacao.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME operacao.fi-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.fi-codigo V-table-Win
ON F5 OF operacao.fi-codigo IN FRAME f-main /* Ficha MÇtodo */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in125.w" 
                     &campo=operacao.fi-codigo
                     &campozoom=fi-codigo
                     &campo2=c-ficha-metodo-descricao
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.fi-codigo V-table-Win
ON LEAVE OF operacao.fi-codigo IN FRAME f-main /* Ficha MÇtodo */
DO:
  {include/leave.i &tabela=ficha-metodo 
                   &atributo-ref=descricao 
                   &variavel-ref=c-ficha-metodo-descricao
                   &where="ficha-metodo.fi-codigo = input frame {&frame-name} operacao.fi-codigo"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.fi-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF operacao.fi-codigo IN FRAME f-main /* Ficha MÇtodo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME operacao.gm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.gm-codigo V-table-Win
ON F5 OF operacao.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in144.w" 
                     &campo=operacao.gm-codigo
                     &campozoom=gm-codigo
                     &campo2=c-grup-maquina-descricao
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.gm-codigo V-table-Win
ON LEAVE OF operacao.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:

  {include/leave.i &tabela=grup-maquina 
                   &atributo-ref=descricao 
                   &variavel-ref=c-grup-maquina-descricao 
                   &where="grup-maquina.gm-codigo = input frame {&frame-name} operacao.gm-codigo"} 

  &if defined (bf_man_sfc_lc) &then
      if  avail grup-maquina then do:
          run get-link-handle in adm-broker-hdl (input this-procedure,
                                              input 'tipo-target',
                                              output c-handle).

          if  num-entries(c-handle) = 1 then 
              assign h-handle = widget-handle(c-handle).
          else
             assign h-handle  = widget-handle(substring(c-handle,1,index(c-handle,",") - 1))
                    h-handle2 = widget-handle(substring(c-handle,index(c-handle,",") + 1)).

          if  valid-handle(h-handle) then
              run pi-grup-maquina in h-handle (input input frame {&frame-name} operacao.gm-codigo).

          if  valid-handle(h-handle2) then
              run pi-grup-maquina in h-handle2 (input input frame {&frame-name} operacao.gm-codigo).

      end.

      RUN get-field-screen-value in adm-broker-hdl (this-procedure, "fi-grup-maquina-aps").
      if return-value = "" and
         operacao.gm-codigo:screen-value in frame {&frame-name} <> "" then do:
          run get-link-handle in adm-broker-hdl (input this-procedure,
                                                 input 'ctrab-target',
                                                 output c-handle).
           if  num-entries(c-handle) = 1 then do:
               assign h-handle = widget-handle(c-handle).
               if  valid-handle(h-handle) then
                   run pi-atualiza-ctrab in h-handle (input input frame {&frame-name} operacao.gm-codigo).
           end.
      end.

  &endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.gm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF operacao.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME operacao.nr-oper-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.nr-oper-pad V-table-Win
ON F5 OF operacao.nr-oper-pad IN FRAME f-main /* Operaá∆o Padr∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in261.w"
                     &campo=operacao.nr-oper-pad
                     &campozoom=nr-oper-pad
                     &campo2=c-oper-pad-descricao
                     &campozoom2=descricao}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.nr-oper-pad V-table-Win
ON LEAVE OF operacao.nr-oper-pad IN FRAME f-main /* Operaá∆o Padr∆o */
DO:
   {include/leave.i &tabela=oper-pad
                    &atributo-ref=descricao
                    &variavel-ref=c-oper-pad-descricao 
                    &where="oper-pad.nr-oper-pad = input frame {&frame-name} operacao.nr-oper-pad"} 

   /* Caso seja informada uma operaá∆o padr∆o cadastrada ser∆o apresentados os */
   /* valores "defaults" para a operaá∆o corrente.                             */   
   IF adm-new-record = NO THEN DO: 

       IF AVAIL oper-pad THEN DO:
           IF i-nr-operacao = 0 AND l-primeira-vez THEN DO:
              ASSIGN  operacao.descricao:screen-value  = string(oper-pad.descricao) NO-ERROR.
              ASSIGN  l-primeira-vez = NO.
           END.
       END.
/*        ELSE DO:                                                                       */
/*            IF int(operacao.nr-oper-pad:screen-value in frame {&frame-name}) <> 0 THEN */
/*               ASSIGN  operacao.descricao:SCREEN-VALUE  = "" NO-ERROR.                 */
/*        END.                                                                           */

       ASSIGN adm-new-record = NO.       
       LEAVE.
   END.



   if  i-nr-operacao <> int(operacao.nr-oper-pad:screen-value in frame {&frame-name}) 
       OR l-alterada = YES then do:

           if  avail oper-pad then do with frame {&frame-name}:                   
               if  oper-pad.tipo-oper = 2 then do:
                   assign operacao.gm-codigo:screen-value  in frame {&frame-name} = ""
                          operacao.gm-codigo:sensitive     in frame {&frame-name} = no
                          operacao.cd-mob-dir:screen-value in frame {&frame-name} = ""
                          operacao.cd-mob-dir:sensitive    in frame {&frame-name} = NO
                          operacao.tipo-oper:screen-value  in frame {&frame-name} = "2".

                   RUN Who-Is-The-Container IN adm-broker-hdl 
                      (INPUT this-procedure, OUTPUT c-handle).

                   assign h-handle = widget-handle(c-handle).

                   run pi-desabilita-folder in h-handle (input 3).

                end.          
                else do:  
                   assign operacao.gm-codigo:screen-value in frame {&frame-name} = string(oper-pad.gm-codigo)
                          operacao.gm-codigo:sensitive    in frame {&frame-name} = yes
                          operacao.cd-mob-dir:sensitive   in frame {&frame-name} = yes
                          operacao.tipo-oper:screen-value in frame {&frame-name} = "1" NO-ERROR.       

                          if adm-new-record = yes OR l-alterada = YES then do:
                             assign operacao.cd-mob-dir:screen-value in frame {&frame-name} = ""
                                    operacao.cd-mob-dir:sensitive    in frame {&frame-name} = YES NO-ERROR.
                          end.

                   &if defined (bf_man_sfc_lc) &then
                   RUN Who-Is-The-Container IN adm-broker-hdl 
                       (INPUT this-procedure, OUTPUT c-handle).

                   assign h-handle = widget-handle(c-handle).

                   run pi-habilita-folder in h-handle (input 3).
                   &endif

                end.                              

                if operacao.nr-oper-pad:modified then do:
                   IF adm-new-record = YES OR l-alterada = YES THEN DO:                                          
                       assign operacao.tipo-oper:screen-value       = string(oper-pad.tipo-oper)
                                  operacao.descricao:screen-value       = string(oper-pad.descricao)
                                  operacao.revisao:screen-value         = string(oper-pad.revisao)
                                  operacao.data-inicio:screen-value     = string(oper-pad.data-inicio)
                                  operacao.data-termino:screen-value    = string(oper-pad.data-termino)
                                  operacao.refugo-op:screen-value       = string(oper-pad.refugo-op)
                                  operacao.proporcao:screen-value       = string(oper-pad.proporcao)
                                  operacao.fi-codigo:screen-value       = string(oper-pad.fi-codigo)
                                  operacao.pto-controle:screen-value    = string(oper-pad.pto-controle)
                                  operacao.cd-mob-dir:screen-value      = string(oper-pad.cd-mob-dir) 
                                  operacao.tipo-oper                    = oper-pad.tipo-oper
                                  operacao.descricao                    = oper-pad.descricao
                                  operacao.revisao                      = oper-pad.revisao
                                  operacao.data-inicio                  = oper-pad.data-inicio
                                  operacao.data-termino                 = oper-pad.data-termino
                                  operacao.refugo-op                    = oper-pad.refugo-op
                                  operacao.proporcao                    = oper-pad.proporcao
                                  operacao.fi-codigo                    = oper-pad.fi-codigo
                                  operacao.pto-controle                 = oper-pad.pto-controle
                                  operacao.cd-mob-dir                   = oper-pad.cd-mob-dir NO-ERROR.

                       find grup-maquina where grup-maquina.gm-codigo = oper-pad.gm-codigo    no-lock no-error.
                       find ficha-metodo where ficha-metodo.fi-codigo = oper-pad.fi-codigo    no-lock no-error.
                       find pto-controle where pto-controle.codigo    = oper-pad.pto-controle no-lock no-error.
                       find tab-mob-dir  where tab-mob-dir.cd-mob-dir = oper-pad.cd-mob-dir   no-lock no-error.

                       assign c-ficha-metodo-descricao:screen-value = if avail ficha-metodo then string(ficha-metodo.descricao) else "":U
                              c-pto-controle-descricao:screen-value = if avail pto-controle then string(pto-controle.descricao) else "":U
                              c-desc-mob-dir:screen-value           = if avail tab-mob-dir  then string(tab-mob-dir.descricao)  else "":U NO-ERROR.

                       if oper-pad.tipo-oper = 2 then
                          assign c-grup-maquina-descricao:screen-value = "".

                       else 
                          assign c-grup-maquina-descricao:screen-value = if avail grup-maquina then string(grup-maquina.descricao) else "":U.

                       /*** Inicializar os dados da outra viewer de cadastro de operaá∆o ***/
                       /*** com os dados da operaá∆o padr∆o.                             ***/

                       run get-link-handle in adm-broker-hdl (input this-procedure,
                                                              input 'oper-pad-target',
                                                              output c-handle).

                       if num-entries(c-handle) = 1 then 
                          assign h-handle = widget-handle(c-handle).
                       else
                          assign h-handle  = widget-handle(substring(c-handle,1,index(c-handle,",") - 1))
                                 h-handle2 = widget-handle(substring(c-handle,index(c-handle,",") + 1)).


                                 /*** fim ***/ 
                       if valid-handle(h-handle) then
                          run pi-default-oper-pad in h-handle (input rowid(oper-pad)).

                       &if defined (bf_man_sfc_lc) &then
                           if avail grup-maquina then do:
                              run get-link-handle in adm-broker-hdl (input  this-procedure,
                                                                     input  'tipo-target',
                                                                     output c-handle).

                              if num-entries(c-handle) = 1 then 
                                  assign h-handle = widget-handle(c-handle).
                              else
                                 assign h-handle  = widget-handle(substring(c-handle,1,index(c-handle,",") - 1))
                                        h-handle2 = widget-handle(substring(c-handle,index(c-handle,",") + 1)).

                              if valid-handle(h-handle) then
                                 run pi-oper-pad in h-handle (input input frame {&frame-name} operacao.nr-oper-pad).

                              if valid-handle(h-handle2) then
                                 run pi-oper-pad in h-handle2 (input input frame {&frame-name} operacao.nr-oper-pad).
                           end.
                       &endif                        

                   END.                   
                end.

                run notify ("pi-atualiza-narrativa, state-target").
           end.
           else do:

              /*assign operacao.tipo-oper:screen-value = "1" NO-ERROR.*/

              &if defined (bf_man_sfc_lc) &then
              RUN Who-Is-The-Container IN adm-broker-hdl 
                  (INPUT this-procedure, OUTPUT c-handle).

                   assign h-handle = widget-handle(c-handle).

                   run pi-habilita-folder in h-handle (input 3).
              &endif
           end.  
   end.
   assign i-nr-operacao = int(operacao.nr-oper-pad:screen-value in frame {&frame-name}) NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.nr-oper-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF operacao.nr-oper-pad IN FRAME f-main /* Operaá∆o Padr∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.nr-oper-pad V-table-Win
ON TAB OF operacao.nr-oper-pad IN FRAME f-main /* Operaá∆o Padr∆o */
DO:
  IF adm-new-record = YES OR l-alterada = YES THEN DO:
    ASSIGN l-alterou-oper-pad = YES.   /**FO-998390  Descobrir se foi alterada a operacao padrao no momento de alterar a revisao ferramenta.**/
    if avail oper-pad then do with frame {&frame-name}:

            if oper-pad.tipo-oper = 2 then 
               assign operacao.gm-codigo:screen-value  in frame {&frame-name} = ""
                      operacao.gm-codigo:sensitive     in frame {&frame-name} = no
                      operacao.cd-mob-dir:screen-value in frame {&frame-name} = ""
                      operacao.cd-mob-dir:sensitive    in frame {&frame-name} = NO
                      operacao.tipo-oper:screen-value  in frame {&frame-name} = "2" NO-ERROR.
            else  
               assign operacao.gm-codigo:screen-value  in frame {&frame-name} = string(oper-pad.gm-codigo)
                      operacao.gm-codigo:sensitive     in frame {&frame-name} = yes
                      operacao.cd-mob-dir:sensitive    in frame {&frame-name} = yes
                      operacao.cd-mob-dir:screen-value in frame {&frame-name} = string(oper-pad.cd-mob-dir)
                      operacao.tipo-oper:screen-value  in frame {&frame-name} = "1" NO-ERROR. 
              {include/leave.i &tabela=grup-maquina 
                   &atributo-ref=descricao 
                   &variavel-ref=c-grup-maquina-descricao 
                   &where="grup-maquina.gm-codigo = input frame {&frame-name} operacao.gm-codigo"} 
              {include/leave.i &tabela=tab-mob-dir 
                    &atributo-ref=descricao 
                    &variavel-ref=c-desc-mob-dir
                    &where="tab-mob-dir.cd-mob-dir = input frame {&frame-name} operacao.cd-mob-dir"}  


     end.
  END.
  ELSE DO: 
/*       IF int(operacao.nr-oper-pad:screen-value in frame {&frame-name}) <> 0 THEN  */
/*          ASSIGN  operacao.descricao:SCREEN-VALUE  = "" NO-ERROR.                  */

      /*ASSIGN operacao.descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".*/
             /*operacao.tipo-oper:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1" NO-ERROR.*/
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME operacao.pto-controle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.pto-controle V-table-Win
ON F5 OF operacao.pto-controle IN FRAME f-main /* Ponto Controle */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in364.w" 
                     &campo=operacao.pto-controle
                     &campozoom=codigo
                     &campo2=c-pto-controle-descricao
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.pto-controle V-table-Win
ON LEAVE OF operacao.pto-controle IN FRAME f-main /* Ponto Controle */
DO:
  {include/leave.i &tabela=pto-controle 
                   &atributo-ref=descricao
                   &variavel-ref=c-pto-controle-descricao 
                   &where="pto-controle.codigo = input frame {&frame-name} operacao.pto-controle"} 

      IF l-valida = YES THEN DO:
            ASSIGN pto = int(operacao.pto-controle:SCREEN-VALUE).                   
      END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.pto-controle V-table-Win
ON MOUSE-SELECT-DBLCLICK OF operacao.pto-controle IN FRAME f-main /* Ponto Controle */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME operacao.tipo-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.tipo-oper V-table-Win
ON VALUE-CHANGED OF operacao.tipo-oper IN FRAME f-main /* Tp Operaá∆o */
DO:
   if input frame {&frame-name} operacao.tipo-oper = 2 then do:

      assign operacao.pto-controle:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
             operacao.gm-codigo:screen-value       in frame {&frame-name} = " "
             operacao.cd-mob-dir:screen-value      in frame {&frame-name} = " "
             operacao.pto-controle:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = " "
             c-grup-maquina-descricao:screen-value in frame {&frame-name} = " "
             c-desc-mob-dir:screen-value           in frame {&frame-name} = " "
             c-pto-controle-descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
             operacao.gm-codigo:sensitive          in frame {&frame-name} = no
             operacao.cd-mob-dir:sensitive         in frame {&frame-name} = NO NO-ERROR.


      RUN Who-Is-The-Container IN adm-broker-hdl 
          (INPUT this-procedure, OUTPUT c-handle).

      assign h-handle = widget-handle(c-handle).

      run pi-desabilita-folder in h-handle (input 3).

   end.
   else do:      
       if int(operacao.nr-oper-pad:screen-value   in frame {&frame-name}) <> 0 then do:
          assign operacao.gm-codigo:screen-value  in frame {&frame-name} = if avail grup-maquina then string(oper-pad.gm-codigo) else "":U
                 operacao.gm-codigo:sensitive     in frame {&frame-name} = yes
                 operacao.cd-mob-dir:sensitive    in frame {&frame-name} = YES
                 operacao.pto-controle:SENSITIVE  IN FRAME {&FRAME-NAME} = YES
                 operacao.cd-mob-dir:screen-value in frame {&frame-name} = if avail grup-maquina then string(oper-pad.cd-mob-dir) else "":U NO-ERROR.

          {include/leave.i &tabela=grup-maquina 
                           &atributo-ref=descricao 
                           &variavel-ref=c-grup-maquina-descricao 
                           &where="grup-maquina.gm-codigo = input frame {&frame-name} operacao.gm-codigo"} 

          {include/leave.i &tabela=tab-mob-dir 
                           &atributo-ref=descricao 
                           &variavel-ref=c-desc-mob-dir
                           &where="tab-mob-dir.cd-mob-dir = input frame {&frame-name} operacao.cd-mob-dir"}  
       end.
       else  
          assign operacao.pto-controle:SENSITIVE  IN FRAME {&FRAME-NAME} = YES
                 operacao.gm-codigo:sensitive  in frame {&frame-name} = yes
                 operacao.cd-mob-dir:sensitive in frame {&frame-name} = YES NO-ERROR.

       &if defined (bf_man_sfc_lc) &then
       RUN Who-Is-The-Container IN adm-broker-hdl 
          (INPUT this-procedure, OUTPUT c-handle).

       assign h-handle = widget-handle(c-handle).

       run pi-habilita-folder in h-handle (input 3).
       &endif

   end.                   

   /*** Caso exista no programa um link do tipo "TIPO" entre esta viewer e outra (v08in263.w) ser∆o ***/
   /*** desabilitados campos desnecess†rios de acordo com o tipo de operaá∆o (interna/externa).     ***/

   run get-link-handle in adm-broker-hdl (input this-procedure,
                                          input 'tipo-target',
                                          output c-handle).

   if num-entries(c-handle) = 1 then 
      assign h-handle = widget-handle(c-handle).
   else
      assign h-handle  = widget-handle(substring(c-handle,1,index(c-handle,",") - 1))
             h-handle2 = widget-handle(substring(c-handle,index(c-handle,",") + 1)).

   if valid-handle(h-handle) then
      run pi-verifica-tipo-oper in h-handle (input input frame {&frame-name} operacao.tipo-oper).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  /* titulo do retangulo para o campo operacao.tipo-oper */
  {utp/ut-rtlbl.i mgind operacao tipo-oper fi-titulo-tipo}

  /* indicar os campos com opcao de zoom (F5) com alteracao do ponteiro do mouse */
  if operacao.fi-codigo:load-mouse-pointer    ("image\lupa.cur") then.
  if operacao.gm-codigo:load-mouse-pointer    ("image\lupa.cur") then.
  if operacao.pto-controle:load-mouse-pointer ("image\lupa.cur") then.
  if operacao.nr-oper-pad:load-mouse-pointer  ("image\lupa.cur") then.
  if operacao.cd-mob-dir:load-mouse-pointer   ("image\lupa.cur") then.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

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
  {src/adm/template/row-list.i "operacao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "operacao"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE altera-operacao V-table-Win 
PROCEDURE altera-operacao :
DEF INPUT PARAMETER l-altera AS LOGICAL NO-UNDO.
    IF l-altera = YES THEN DO:
        ASSIGN l-alterada = l-altera.
        APPLY "LEAVE" TO operacao.nr-oper-pad IN FRAME {&FRAME-NAME}.       
        APPLY "TAB" TO operacao.nr-oper-pad IN FRAME {&FRAME-NAME}.
        APPLY "Leave" TO operacao.pto-controle IN FRAME {&FRAME-NAME}.        
        APPLY "Leave" TO operacao.fi-codigo IN FRAME {&FRAME-NAME}.


        IF AVAIL oper-pad THEN DO:
            assign operacao.tipo-oper:screen-value       = string(oper-pad.tipo-oper)
                                  operacao.descricao:screen-value       = string(oper-pad.descricao)
                                  operacao.revisao:screen-value         = string(oper-pad.revisao)
                                  operacao.data-inicio:screen-value     = string(oper-pad.data-inicio)
                                  operacao.data-termino:screen-value    = string(oper-pad.data-termino)
                                  operacao.refugo-op:screen-value       = string(oper-pad.refugo-op)
                                  operacao.proporcao:screen-value       = string(oper-pad.proporcao)
                                  operacao.fi-codigo:screen-value       = string(oper-pad.fi-codigo)
                                  operacao.pto-controle:screen-value    = IF l-primeira THEN 
                                                                                string(oper-pad.pto-controle)
                                                                          ELSE 
                                                                                STRING(pto)
                                  operacao.cd-mob-dir:screen-value      = string(oper-pad.cd-mob-dir) 
                                  operacao.tipo-oper                    = oper-pad.tipo-oper
                                  operacao.descricao                    = oper-pad.descricao
                                  operacao.revisao                      = oper-pad.revisao
                                  operacao.data-inicio                  = oper-pad.data-inicio
                                  operacao.data-termino                 = oper-pad.data-termino
                                  operacao.refugo-op                    = oper-pad.refugo-op
                                  operacao.proporcao                    = oper-pad.proporcao
                                  operacao.fi-codigo                    = oper-pad.fi-codigo
                                  operacao.pto-controle                 = IF l-primeira THEN 
                                                                                oper-pad.pto-controle
                                                                          ELSE 
                                                                                pto
                                  operacao.cd-mob-dir                   = oper-pad.cd-mob-dir NO-ERROR.


                       find grup-maquina where grup-maquina.gm-codigo = oper-pad.gm-codigo    no-lock no-error.
                       find ficha-metodo where ficha-metodo.fi-codigo = oper-pad.fi-codigo    no-lock no-error.
                       find pto-controle where pto-controle.codigo    = oper-pad.pto-controle no-lock no-error.
                       find tab-mob-dir  where tab-mob-dir.cd-mob-dir = oper-pad.cd-mob-dir   no-lock no-error.

                       assign c-ficha-metodo-descricao:screen-value = if avail ficha-metodo then string(ficha-metodo.descricao) else "":U
                              c-pto-controle-descricao:screen-value = if avail pto-controle then string(pto-controle.descricao) else "":U
                              c-desc-mob-dir:screen-value           = if avail tab-mob-dir  then string(tab-mob-dir.descricao)  else "":U NO-ERROR.

                       if oper-pad.tipo-oper = 2 then
                          assign c-grup-maquina-descricao:screen-value = "".

                       else 
                          assign c-grup-maquina-descricao:screen-value = if avail grup-maquina then string(grup-maquina.descricao) else "":U.

                       run notify ("pi-atualiza-narrativa, state-target").  /**FO-998390  Quando alterada a Oper. Padrao tambem alterar a narrativa**/

                       /*** Inicializar os dados da outra viewer de cadastro de operaá∆o ***/
                       /*** com os dados da operaá∆o padr∆o.                             ***/

                       run get-link-handle in adm-broker-hdl (input this-procedure,
                                                              input 'oper-pad-target',
                                                              output c-handle).

                       if num-entries(c-handle) = 1 then 
                          assign h-handle = widget-handle(c-handle).
                       else
                          assign h-handle  = widget-handle(substring(c-handle,1,index(c-handle,",") - 1))
                                 h-handle2 = widget-handle(substring(c-handle,index(c-handle,",") + 1)).


                                 /*** fim ***/ 
                       if valid-handle(h-handle) then
                          run pi-default-oper-pad in h-handle (input rowid(oper-pad)).

                       &if defined (bf_man_sfc_lc) &then
                           if avail grup-maquina then do:
                              run get-link-handle in adm-broker-hdl (input  this-procedure,
                                                                     input  'tipo-target',
                                                                     output c-handle).

                              if num-entries(c-handle) = 1 then 
                                  assign h-handle = widget-handle(c-handle).
                              else
                                 assign h-handle  = widget-handle(substring(c-handle,1,index(c-handle,",") - 1))
                                        h-handle2 = widget-handle(substring(c-handle,index(c-handle,",") + 1)).

                              if valid-handle(h-handle) then
                                 run pi-oper-pad in h-handle (input input frame {&frame-name} operacao.nr-oper-pad).

                              if valid-handle(h-handle2) then
                                 run pi-oper-pad in h-handle2 (input input frame {&frame-name} operacao.nr-oper-pad).
                           end.
                       &endif  

                       ASSIGN l-primeira = NO.

        END.

    ASSIGN l-alterada = NO.
    END.
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

    &IF DEFINED(CUSTOM_GRENDENE) &THEN

        /* Dispatch standard ADM method.                             */
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    &ELSE

        /* Dispatch standard ADM method.                             */
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

       /* Code placed here will execute AFTER standard behavior.    */
       {utp/ut-rtlbl.i mgind operacao tipo-oper fi-titulo-tipo}
        display today @ operacao.data-inicio with frame {&frame-name}. 

    &ENDIF



  if adm-new-record = yes then 
     assign i-nr-operacao = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  apply 'entry' to operacao.nr-oper-pad in frame {&frame-name}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

  if input frame {&frame-name} operacao.tipo-oper = 2 then do:

     RUN Who-Is-The-Container IN adm-broker-hdl 
         (INPUT this-procedure, OUTPUT c-handle).

     assign h-handle = widget-handle(c-handle).

     run pi-desabilita-folder in h-handle (input 3).

  end.
  else do:
     &if defined (bf_man_sfc_lc) &then
     RUN Who-Is-The-Container IN adm-broker-hdl 
         (INPUT this-procedure, OUTPUT c-handle).

     assign h-handle = widget-handle(c-handle).

     run pi-habilita-folder in h-handle (input 3).
     &endif
  end.

  /* Code placed here will execute AFTER standard behavior.    */
  if  adm-new-record = no
  and operacao.nr-oper-pad:sensitive in frame {&frame-name} = yes then 
     apply 'entry' to operacao.nr-oper-pad in frame {&frame-name}. 

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

   DEFINE VARIABLE l-recur-sec AS LOGICAL INIT NO NO-UNDO.

   {include/i-valid.i}

    if  avail operacao then do:
        for each tt-oper-2:
            delete tt-oper-2.
        end.
        create tt-oper-2.
        buffer-copy operacao to tt-oper-2.
        if  not error-status:error then
            validate tt-oper-2.
    end.    
    assign c-aux = "c-codigo-pai".
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure,
         INPUT c-aux).
    assign c-aux = return-value.

    if  avail tt-oper-2 then do:
        assign tt-oper-2.pto-controle = input frame {&frame-name} operacao.pto-controle
               tt-oper-2.data-inicio  = input frame {&frame-name} operacao.data-inicio
               tt-oper-2.data-termino = input frame {&frame-name} operacao.data-termino.
               
        RUN get-link-handle IN adm-broker-hdl
            (INPUT THIS-PROCEDURE,
             INPUT 'group-assign-source',
             OUTPUT c-handle).
        run get-attribute in widget-handle(c-handle) ('campo').
        if  return-value = 'item' then 
            assign tt-oper-2.it-codigo = c-aux
                   tt-oper-2.cod-roteiro = "".
        else
            assign tt-oper-2.cod-roteiro  = c-aux
                   tt-oper-2.it-codigo    = "".

        RUN Get-Field-Screen-Value IN adm-broker-hdl
            (INPUT this-procedure,
             INPUT c-aux).
        assign c-aux = return-value.

        assign tt-oper-2.op-codigo = int(c-aux).

        run pi-validate-oper. 

        if return-value <> 'ok' and return-value <> '' then do:
            run pi-apresenta-erros.
            return "ADM-ERROR":U.
        end.

        IF tt-oper-2.gm-codigo <> input frame {&frame-name} operacao.gm-codigo THEN DO:
            /*Se o gm estiver sendo alterado, verifica se h† recur-sec-oper vinculado a esta operaá∆o. Se houver, e o mesmo
              tiver centro de trabalho vinculado, n∆o permite a alteraá∆o */
            FOR EACH recur-sec-operac NO-LOCK
               WHERE recur-sec-operac.num-id-operacao = tt-oper-2.num-id-operacao
                 AND recur-sec-operac.op-altern       = 0:
    
                IF recur-sec-operac.cod-ctrab <> "" THEN DO:
                    ASSIGN l-recur-sec = YES.
                    LEAVE.
                END.
            END.
    
            IF l-recur-sec THEN DO:
                run utp/ut-msgs.p (input "show",
                                   input 33921,
                                   input "":U).
                return "ADM-ERROR":U.
            END.
        END.
    end.
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

    assign operacao.gm-codigo:sensitive in frame {&frame-name} = yes
           gr-operacao = rowid(operacao).

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

  /* Code placed here will execute AFTER standard behavior.    */

  if avail oper-pad then DO:
     if adm-new-record = YES OR l-alterou-oper-pad = YES THEN DO:  /**FO-998390  Descobrir se foi alterada a operacao padrao no momento de alterar a revisao ferramenta.**/
         assign operacao.rev-ferramentas  = oper-pad.rev-ferramentas  * 10000
                operacao.rev-ficha-oper   = oper-pad.rev-ficha-oper   * 10000
                operacao.rev-item-consumo = oper-pad.rev-item-consumo * 10000
                l-alterou-oper-pad = NO. /**FO-998390  Descobrir se foi alterada a operacao padrao no momento de alterar a revisao ferramenta.**/
     END.
  END.

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

   if avail operacao then do with frame {&frame-name}:
      find oper-pad     where oper-pad.nr-oper-pad   = operacao.nr-oper-pad  no-lock no-error.
      find grup-maquina where grup-maquina.gm-codigo = operacao.gm-codigo    no-lock no-error.
      find ficha-metodo where ficha-metodo.fi-codigo = operacao.fi-codigo    no-lock no-error.
      find pto-controle where pto-controle.codigo    = operacao.pto-controle no-lock no-error.
      find tab-mob-dir  where tab-mob-dir.cd-mob-dir = operacao.cd-mob-dir   no-lock no-error.

      assign c-oper-pad-descricao     = if avail oper-pad     then oper-pad.descricao     else "":U
             c-grup-maquina-descricao = if avail grup-maquina then grup-maquina.descricao else "":U
             c-ficha-metodo-descricao = if avail ficha-metodo then ficha-metodo.descricao else "":U
             c-pto-controle-descricao = if avail pto-controle then pto-controle.descricao else "":U
             c-desc-mob-dir           = if avail tab-mob-dir  then tab-mob-dir.descricao  else "":U.

      if operacao.tipo-oper = 1 then
         assign operacao.gm-codigo:sensitive in frame {&frame-name}  = yes
                operacao.cd-mob-dir:sensitive in frame {&frame-name} = YES NO-ERROR.
      else   
         assign operacao.gm-codigo:sensitive in frame {&frame-name}  = no
                operacao.cd-mob-dir:sensitive in frame {&frame-name} = NO NO-ERROR.
   end.   

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
   /* Code placed here will execute AFTER standard behavior.    */

if avail operacao then 
   assign i-nr-operacao = int(operacao.nr-oper-pad:screen-value in frame {&frame-name}).

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

  if adm-new-record = yes or 
     (avail operacao and operacao.tipo-oper = 1) then 
     assign operacao.gm-codigo:sensitive in frame {&frame-name}  = yes
            operacao.cd-mob-dir:sensitive in frame {&frame-name} = yes.
  else
  if avail operacao and operacao.tipo-oper = 2 then 
     assign operacao.gm-codigo:sensitive in frame {&frame-name}  = no
            operacao.cd-mob-dir:sensitive in frame {&frame-name} = no.

  if avail operacao then 
     assign i-nr-operacao = operacao.nr-oper-pad.
  else
     assign i-nr-operacao = 0.

/*  if  param-global.modulo-sws = yes then 
 *       assign c-setup:sensitive in frame {&frame-name} = yes.
 *   else
 *       assign c-setup:sensitive in frame {&frame-name} = no.*/

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

  /* Code placed here will execute AFTER to standard behavior. */
  assign c-item = ""
         c-rot-fabric = "".

  if c-tipo-rowid = "item":U 
  then do:
     find item where rowid(item) = v-row-parent no-lock no-error.
     assign c-item = if avail item then item.it-codigo else "":U.
  end.
  else do:
     find rot-fabric where rowid(rot-fabric) = v-row-parent no-lock no-error.
     assign c-rot-fabric = if avail rot-fabric then rot-fabric.cod-roteiro else "":U.
  end.

  find first param-global no-lock no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apresenta-erros V-table-Win 
PROCEDURE pi-apresenta-erros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 {database/tgin/twp/twin263.i 'show':U}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-campo V-table-Win 
PROCEDURE pi-retorna-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output parameter i-nr-oper-pad like oper-pad.nr-oper-pad.

assign i-nr-oper-pad = input frame {&frame-name} operacao.nr-oper-pad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-variavel-como-item V-table-Win 
PROCEDURE pi-seta-variavel-como-item :
/*------------------------------------------------------------------------------
  Purpose: Inicializa a Variavel como Vinda do Item
  Parameters:  <none>
  Notes: Necessario saber se est† vindo do roteiro ou do item, pois no Oracle, 
         o rowid pode ser o mesmo para tabelas distintas.
         15/12/2000.
------------------------------------------------------------------------------*/
define input parameter pRowid as rowid no-undo.

   assign c-tipo-rowid = "item":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-variavel-como-roteiro V-table-Win 
PROCEDURE pi-seta-variavel-como-roteiro :
/*------------------------------------------------------------------------------
  Purpose: Inicializa a Variavel como Vinda do Roteiro
  Parameters:  <none>
  Notes: Necessario saber se est† vindo do roteiro ou do item, pois no Oracle, 
         o rowid pode ser o mesmo para tabelas distintas.
         15/12/2000.
------------------------------------------------------------------------------*/
define input parameter pRowid as rowid no-undo.

   assign c-tipo-rowid = "rot-fabric":U.

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
  def var c-label-item as char no-undo.
  def var i-cont       as int  no-undo.
  def var c-handle     as char no-undo.

  {include/i-vldfrm.i} /* Validaá∆o do dicion†rio */

  IF NOT AVAIL param-global THEN
      FIND FIRST param-global NO-LOCK NO-ERROR.

  /* Ponha aqui as demais validaá‰es */

  if input frame {&frame-name} operacao.nr-oper-pad <> 0 and
     not can-find(first oper-pad
                  where oper-pad.nr-oper-pad = input frame {&frame-name} operacao.nr-oper-pad)
  then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 1891,
                       input input frame {&frame-name} operacao.nr-oper-pad).

    return "ADM-ERROR":U.
  end.

  if input frame {&frame-name} operacao.pto-controle <> 0 and
     not can-find(first pto-controle
                  where pto-controle.codigo = input frame {&frame-name} operacao.pto-controle)
  then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 4586,
                       input input frame {&frame-name} operacao.pto-controle).
    apply "entry" to operacao.pto-controle in frame {&frame-name}.
    return "ADM-ERROR":U.
  end.

  /*** N∆o ser† permitido que exista mais de uma operaá∆o por item ou roteiro ***/
  /*** com o mesmo ponto de controle.                                         ***/

  if input frame {&frame-name} operacao.pto-controle <> 0 THEN DO:

       FOR EACH b-operacao FIELDS (data-inicio data-termino) 
          WHERE b-operacao.it-codigo    =  c-item
            AND b-operacao.cod-roteiro  =  c-rot-fabric
            AND b-operacao.pto-controle =  input frame {&frame-name} operacao.pto-controle
            AND rowid(b-operacao)       <> rowid(operacao) NO-LOCK:

           IF (input frame {&frame-name} operacao.data-inicio >= b-operacao.data-inicio 
              AND input frame {&frame-name} operacao.data-inicio < b-operacao.data-termino)

           OR (input frame {&frame-name} operacao.data-termino > b-operacao.data-inicio
               AND input frame {&frame-name} operacao.data-termino < b-operacao.data-termino)

           OR (input frame {&frame-name} operacao.data-inicio < b-operacao.data-inicio
               AND input frame {&frame-name} operacao.data-termino > b-operacao.data-termino) THEN DO: 

                  if c-rot-fabric <> "" then
                     {utp/ut-table.i mgind rot-fabric 1}
                  else
                     {utp/ut-table.i mgind item 1}
              
                  assign c-label-item = return-value.
              
                  {include/i-vldprg.i}
                  {utp/ut-table.i mgind pto-controle 1}
                  run utp/ut-msgs.p (input "show",
                                     input 1165,
                                     input return-value + "~~" + c-label-item).
                  ASSIGN l-valida = YES.
                  apply "entry" to operacao.pto-controle in frame {&frame-name}.
                  return "ADM-ERROR":U.     
           END.
       END.

        /*** Nío permite que a operaªío seja ponto de controle caso o grupo de maquina nao seja reportado no SFC. ***/
/*         IF  param-global.modulo-ch THEN DO:                                                                        */
/*             &IF DEFINED(bf_man_206b) &THEN                                                                         */
/*             IF INPUT FRAME {&FRAME-NAME} operacao.tipo-oper = 2 THEN DO:                                           */
/*             &ENDIF                                                                                                 */
/*                 FIND grup-maquina                                                                                  */
/*                     WHERE grup-maquina.gm-codigo = input frame {&frame-name} operacao.gm-codigo NO-LOCK NO-ERROR.  */
/*                 IF  NOT AVAIL grup-maquina                                                                         */
/*                 OR  NOT grup-maquina.log-pto-control THEN DO:                                                      */
/*                     {include/i-vldprg.i}                                                                           */
/*                     run utp/ut-msgs.p (input "show",                                                               */
/*                                        input 28176 ,                                                               */
/*                                        input "").                                                                  */
/*                     apply "entry" to operacao.pto-controle in frame {&frame-name}.                                 */
/*                     return "ADM-ERROR":U.                                                                          */
/*                 END.                                                                                               */
/*             &IF DEFINED(bf_man_206b) &THEN                                                                         */
/*             END.                                                                                                   */
/*             &ENDIF                                                                                                 */
/*         END.                                                                                                       */
  END.
  ELSE DO:
      IF AVAIL oper-pad THEN
          ASSIGN pto = oper-pad.pto-controle.
  END.



  /*** Se operaá∆o Ç interna o grupo de m†quina Ç obrigat¢rio ***/
  if input frame {&frame-name} operacao.tipo-oper = 1 
  and not(can-find(grup-maquina 
          where grup-maquina.gm-codigo = input frame {&frame-name} operacao.gm-codigo)) then do:

     {include/i-vldprg.i}
     {utp/ut-field.i mgind operacao gm-codigo 1}
     run utp/ut-msgs.p (input "show",
                        input 265,
                        input return-value).
     apply "entry" to operacao.gm-codigo in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.  

  if input frame {&frame-name} operacao.fi-codigo <> 0 and
     not can-find (first ficha-metodo where
                          ficha-metodo.fi-codigo = input frame {&frame-name} operacao.fi-codigo) then do:
     {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show",
                        input 2443,
                        input "").
     apply "entry" to operacao.fi-codigo in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.


  /*** Data de in°cio de validade n∆o deve ser maior ou igual a data fim validade ***/
  if input frame {&frame-name} operacao.data-inicio >
     input frame {&frame-name} operacao.data-termino then do:

     {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show",
                        input 137,
                        input '').
     apply "entry" to operacao.data-termino in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.

  /*** Descriá∆o n∆o pode ser branco ***/
  if input frame {&frame-name} operacao.descricao = "" then do:
     {include/i-vldprg.i}
     {utp/ut-field.i mgind operacao descricao 01}
     run utp/ut-msgs.p (input "show",
                        input 164,
                        input return-value).
     apply "entry" to operacao.descricao in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.

  /*** C¢digo da M∆o de Obra ***/

   if input frame {&frame-name} operacao.tipo-oper <> 2 then do:

        find tab-mob-dir where
             tab-mob-dir.cd-mob-dir = input frame {&frame-name} operacao.cd-mob-dir
             no-lock no-error.

        if  not avail tab-mob-dir and 
            input frame {&frame-name} operacao.cd-mob-dir <> "" then do:
            {include/i-vldprg.i}
            {utp/ut-field.i mgind tab-mob-dir cd-mob-dir 1}
            run utp/ut-msgs.p (input "show",
                               input 56,
                               input return-value).
            apply "entry" to operacao.cd-mob-dir in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
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
  {src/adm/template/snd-list.i "operacao"}

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


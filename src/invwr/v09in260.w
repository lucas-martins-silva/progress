&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
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
{include/i-prgvrs.i V09IN260 2.00.00.056 } /*** "010056" 16/05/2024 10:16:44  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v09in260 MUT}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

&Scop adm-attribute-dlg support/viewerd.w
{cdp/cdcfgman.i}   /* Variÿvel preprocessador bf_man_sfc_lc */ 
/* global variable definitions */
def new global shared var gr-ord-prod     as rowid no-undo.
def new global shared var gr-grup-maquina as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo. /* rowid tabela pai */

def var de-tempo-homem like oper-ord.tempo-homem      no-undo.
def var de-tempo-maquin like oper-ord.tempo-maquin    no-undo.
def var de-tempo-prepar like oper-ord.tempo-prepar    no-undo.
/*Alterado devido a Fo 1359.820*/
DEF VAR de-tempo-res-maq LIKE oper-ord.tempo-maquin   NO-UNDO.
DEF VAR de-tempo-ressup LIKE oper-ord.tempo-maquin    NO-UNDO.
def var c-gm-codigo     like oper-ord.gm-codigo       no-undo.
def var c-estado        as char no-undo.
DEF VAR l-alterada      AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR i-unid          LIKE oper-ord.nr-unidades     INITIAL 0 NO-UNDO.
def buffer b-oper-ord for oper-ord.
define variable h-boin533 as handle no-undo.
DEFINE VARIABLE v-oper-pad AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-adic AS LOGICAL    NO-UNDO.

{cpp/cp0302.i1}
{cpp/cpapi023.i}
{cdp/cd0666.i}

&IF DEFINED(bf_man_204) &THEN
  {cdp/cd9043.i} /* Defini‡Æo da tabela de erros RowErros */
  DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai_habilit AS LOGICAL NO-UNDO.
  {cpp/cpapi301.i}  /* defini‡Æo tt-ord-prod        */
&endif

DEFINE VARIABLE l-mudancas-sfc AS LOGICAL INITIAL NO  NO-UNDO.

DEFINE VARIABLE hPag2 AS HANDLE     NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES oper-ord
&Scoped-define FIRST-EXTERNAL-TABLE oper-ord


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR oper-ord.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS oper-ord.descricao oper-ord.fi-codigo ~
oper-ord.pto-controle 
&Scoped-define ENABLED-TABLES oper-ord
&Scoped-define FIRST-ENABLED-TABLE oper-ord
&Scoped-Define ENABLED-OBJECTS rt-mold fi-oper-pad cb-tipo-oper 
&Scoped-Define DISPLAYED-FIELDS oper-ord.op-codigo oper-ord.cod-roteiro ~
oper-ord.it-codigo oper-ord.descricao oper-ord.gm-codigo oper-ord.fi-codigo ~
oper-ord.pto-controle oper-ord.tempo-homem oper-ord.tempo-prepar 
&Scoped-define DISPLAYED-TABLES oper-ord
&Scoped-define FIRST-DISPLAYED-TABLE oper-ord
&Scoped-Define DISPLAYED-OBJECTS fi-oper-pad cb-tipo-oper cb-un-med-tempo ~
fi-tempo-maquin fi-tempo-ressup 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS oper-ord.op-codigo oper-ord.cod-roteiro ~
oper-ord.it-codigo 
&Scoped-define ADM-ASSIGN-FIELDS oper-ord.op-codigo oper-ord.cod-roteiro ~
oper-ord.it-codigo oper-ord.gm-codigo oper-ord.fi-codigo ~
oper-ord.tempo-homem oper-ord.tempo-prepar 

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
DEFINE VARIABLE cb-tipo-oper AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-un-med-tempo AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-oper-pad AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "":R18 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE VARIABLE fi-tempo-maquin AS DECIMAL FORMAT "->>>,>>>,>>9.999" INITIAL 0 
     LABEL "Tempo M quina":R16 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tempo-ressup AS DECIMAL FORMAT "->>>,>>>,>>9.99" INITIAL 0 
     LABEL "":R16 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 8.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     oper-ord.op-codigo AT ROW 1.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     oper-ord.cod-roteiro AT ROW 1.75 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     oper-ord.it-codigo AT ROW 2.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     fi-oper-pad AT ROW 2.75 COL 68 COLON-ALIGNED
     oper-ord.descricao AT ROW 3.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     cb-tipo-oper AT ROW 3.75 COL 68 COLON-ALIGNED
     oper-ord.gm-codigo AT ROW 4.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .88
     oper-ord.fi-codigo AT ROW 4.75 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     cb-un-med-tempo AT ROW 5.75 COL 21 COLON-ALIGNED
     oper-ord.pto-controle AT ROW 5.75 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     fi-tempo-maquin AT ROW 6.75 COL 21 COLON-ALIGNED
     oper-ord.tempo-homem AT ROW 6.75 COL 68 COLON-ALIGNED FORMAT ">>>>>>>>>9.999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     oper-ord.tempo-prepar AT ROW 7.75 COL 21 COLON-ALIGNED FORMAT ">>>>>>>>>9.999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fi-tempo-ressup AT ROW 7.75 COL 68 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.oper-ord
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
         HEIGHT             = 8.25
         WIDTH              = 88.29.
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
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 8.25
       FRAME f-main:WIDTH            = 88.29.

/* SETTINGS FOR COMBO-BOX cb-un-med-tempo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN oper-ord.cod-roteiro IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN oper-ord.fi-codigo IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-tempo-maquin IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tempo-ressup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN oper-ord.gm-codigo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN oper-ord.it-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN oper-ord.op-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN oper-ord.tempo-homem IN FRAME f-main
   NO-ENABLE 2 EXP-FORMAT                                               */
/* SETTINGS FOR FILL-IN oper-ord.tempo-prepar IN FRAME f-main
   NO-ENABLE 2 EXP-FORMAT                                               */
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

&Scoped-define SELF-NAME cb-tipo-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-oper V-table-Win
ON LEAVE OF cb-tipo-oper IN FRAME f-main
DO:

 run notify ('pi-busca-valor,state-target').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-oper V-table-Win
ON VALUE-CHANGED OF cb-tipo-oper IN FRAME f-main
DO:
   run notify ('pi-busca-valor,state-target').

   IF VALID-HANDLE(hPag2) THEN
       RUN mudancaTipoOper IN hPag2(INPUT cb-tipo-oper:lookup (cb-tipo-oper:screen-value)).

   if cb-tipo-oper:lookup (cb-tipo-oper:screen-value) = 1 then do:
       assign oper-ord.tempo-prepar:screen-value in frame {&frame-name} = string(de-tempo-prepar)
              oper-ord.tempo-homem:screen-value in frame {&frame-name}  = string(de-tempo-homem)
              fi-tempo-maquin:screen-value in frame {&frame-name} = if  avail(oper-ord) then string(oper-ord.tempo-maquin)
                      else "0.000"
              fi-tempo-ressup:screen-value in frame {&frame-name} = "0"
              oper-ord.gm-codigo:screen-value in frame {&frame-name}    = c-gm-codigo.

       assign cb-un-med-tempo:sensitive in frame {&frame-name}       = yes
              oper-ord.gm-codigo:sensitive in frame {&frame-name}    = yes
              oper-ord.tempo-prepar:sensitive in frame {&frame-name} = yes
              oper-ord.tempo-homem:sensitive in frame {&frame-name}  = yes
              fi-tempo-maquin:sensitive in frame {&frame-name} = yes
              oper-ord.pto-controle:SENSITIVE IN FRAME {&FRAME-NAME} = YES
              fi-tempo-ressup:sensitive in frame {&frame-name}       = no.         
    end.   
    else do:
           assign oper-ord.gm-codigo:screen-value in frame {&frame-name}    = ""
                /*oper-ord.tempo-prepar:screen-value in frame {&frame-name} = "0.000" */
                  oper-ord.tempo-homem:screen-value in frame {&frame-name}  = "0.000"
                  fi-tempo-maquin:screen-value in frame {&frame-name} = "0.000"
                  oper-ord.pto-controle:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
                  fi-tempo-ressup:screen-value in frame {&frame-name} = 
                      if  avail(oper-ord) then string(oper-ord.tempo-maquin)
                      else "0.000".

           assign /* cb-un-med-tempo:sensitive in frame {&frame-name}      = no */
                  oper-ord.gm-codigo:sensitive in frame {&frame-name}   = no
                  /* oper-ord.tempo-prepar:sensitive in frame {&frame-name} = no */
                  oper-ord.tempo-homem:sensitive  in frame {&frame-name} = no
                  fi-tempo-maquin:sensitive in frame {&frame-name} = no
                  oper-ord.pto-controle:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                  fi-tempo-ressup:sensitive in frame {&frame-name} = yes.                                                                     
    end.

    find first grup-maquina no-lock
         where grup-maquina.gm-codigo = oper-ord.gm-codigo:screen-value in frame {&frame-name} no-error.
    if  avail grup-maquina then
       assign gr-grup-maquina = rowid(grup-maquina).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-ord.cod-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.cod-roteiro V-table-Win
ON F5 OF oper-ord.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
   {include/zoomvar.i &prog-zoom="inzoom/z01in398.w"
                      &campo=oper-ord.cod-roteiro
                      &campozoom=cod-roteiro}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.cod-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-ord.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-ord.fi-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.fi-codigo V-table-Win
ON F5 OF oper-ord.fi-codigo IN FRAME f-main /* Ficha M‚todo */
DO:
  find first param-global no-lock no-error.
  if param-global.modulo-en then do:
     {include/zoomvar.i &prog-zoom="inzoom/z01in125.w"
                        &campo=oper-ord.fi-codigo
                        &campozoom=fi-codigo}.
  end.
  else do:
       run utp/ut-msgs.p (input "show",
                          input 2145,
                          input "").
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.fi-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-ord.fi-codigo IN FRAME f-main /* Ficha M‚todo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-oper-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-oper-pad V-table-Win
ON ENTRY OF fi-oper-pad IN FRAME f-main
DO:
/*   assign fi-oper-pad.                                         */
/*   if fi-oper-pad <> 0 then do:                                */
/*      find oper-pad where oper-pad.nr-oper-pad = fi-oper-pad   */
/*           no-lock no-error.                                   */
/*      if not avail oper-pad then do:                           */
/*         run utp/ut-msgs.p (input "show",                      */
/*                            input 1891,                        */
/*                            input "").                         */
/*      end.                                                     */
/*      else do:                                                 */
/*           run utp/ut-msgs.p (input "show",                    */
/*                              input 1921,                      */
/*                              input "").                       */
/*           if return-value = "yes" then do:                    */
/*              run pi-copia-op-padrao (input rowid (oper-pad)). */
/*              run notify ("pi-copia-op-padrao,state-target").  */
/*           end.                                                */
/*      end.                                                     */
/*   end.                                                        */
/*   assign fi-oper-pad = 0.                                     */
/*   disp fi-oper-pad with frame {&frame-name}.                  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-oper-pad V-table-Win
ON F5 OF fi-oper-pad IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in261.w"
                     &campo=fi-oper-pad
                     &campozoom=nr-oper-pad}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-oper-pad V-table-Win
ON LEAVE OF fi-oper-pad IN FRAME f-main
DO:
  DEF BUFFER b-ord-prod FOR ord-prod.

  assign fi-oper-pad.
  if fi-oper-pad <> 0 AND fi-oper-pad <> v-oper-pad then do:
     find oper-pad where oper-pad.nr-oper-pad = fi-oper-pad
          no-lock no-error.
     if AVAIL oper-pad THEN DO:
          run utp/ut-msgs.p (input "show",
                             input 1921,
                             input "").
          if return-value = "yes" then do:
             ASSIGN i-unid = oper-pad.nr-unidades.
             run pi-copia-op-padrao (input rowid (oper-pad)).
             run notify ("pi-copia-op-padrao,state-target").             


             IF NOT AVAIL ord-prod THEN
                FIND ord-prod WHERE ord-prod.nr-ord-produ = oper-ord.nr-ord-produ NO-LOCK NO-ERROR.

             IF AVAIL grup-maquina AND grup-maquina.ind-tempo-operac = 2 THEN
                ASSIGN oper-ord.tempo-homem:screen-value  in frame {&frame-name}   = STRING((oper-pad.tempo-homem))
                       fi-tempo-maquin:screen-value  in frame {&frame-name}  = STRING((oper-pad.tempo-maquin))   
                       l-alterada = YES.
             ELSE 
                ASSIGN oper-ord.tempo-homem:screen-value  in frame {&frame-name}   = STRING((oper-pad.tempo-homem / i-unid) * ord-prod.qt-ordem)
                       fi-tempo-maquin:screen-value  in frame {&frame-name}  = STRING((oper-pad.tempo-maquin / i-unid) * ord-prod.qt-ordem)
                       l-alterada = YES.
          end.
          ASSIGN fi-oper-pad = oper-pad.nr-oper-pad 
                 v-oper-pad = fi-oper-pad.
     end.
  end. 
  /*assign fi-oper-pad = 0
         fi-oper-pad:screen-value in frame {&frame-name} = "0".*/
  apply 'entry' to oper-ord.descricao.     

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-oper-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-oper-pad IN FRAME f-main
DO:
  apply 'F5' to fi-oper-pad.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-tempo-maquin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tempo-maquin V-table-Win
ON LEAVE OF fi-tempo-maquin IN FRAME f-main /* Tempo M quina */
DO:
    assign de-tempo-maquin = input frame {&frame-name} fi-tempo-maquin.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-tempo-ressup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tempo-ressup V-table-Win
ON LEAVE OF fi-tempo-ressup IN FRAME f-main
DO:
  assign de-tempo-ressup = input frame {&frame-name} fi-tempo-ressup.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-ord.gm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.gm-codigo V-table-Win
ON F5 OF oper-ord.gm-codigo IN FRAME f-main /* Grupo M quina */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in144.w"
                     &campo=oper-ord.gm-codigo
                     &campozoom=gm-codigo}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.gm-codigo V-table-Win
ON LEAVE OF oper-ord.gm-codigo IN FRAME f-main /* Grupo M quina */
DO:
  assign c-gm-codigo = input frame {&frame-name} oper-ord.gm-codigo.

  /*Atualiza o rowid para o zoom de centro de trabalho, na pag 2*/
find first grup-maquina no-lock
     where grup-maquina.gm-codigo = oper-ord.gm-codigo:screen-value in frame {&frame-name} no-error.
if  avail grup-maquina then
    assign gr-grup-maquina = rowid(grup-maquina).
ELSE
    ASSIGN gr-grup-maquina = ?.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.gm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-ord.gm-codigo IN FRAME f-main /* Grupo M quina */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-ord.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.it-codigo V-table-Win
ON F5 OF oper-ord.it-codigo IN FRAME f-main /* Item */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                     &campo=oper-ord.it-codigo
                     &campozoom=it-codigo}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-ord.it-codigo IN FRAME f-main /* Item */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-ord.pto-controle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.pto-controle V-table-Win
ON F5 OF oper-ord.pto-controle IN FRAME f-main /* Ponto Controle */
DO:
  find first param-global no-lock no-error.
  if param-global.modulo-en then do:
     {include/zoomvar.i &prog-zoom="inzoom/z01in364.w"
                        &campo=oper-ord.pto-controle
                        &campozoom=codigo}.
  end.
  else do:
       run utp/ut-msgs.p (input "show",
                          input 2145,
                          input "").
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.pto-controle V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-ord.pto-controle IN FRAME f-main /* Ponto Controle */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-ord.tempo-homem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.tempo-homem V-table-Win
ON LEAVE OF oper-ord.tempo-homem IN FRAME f-main /* Tempo Homem */
DO:
  assign de-tempo-homem = input frame {&frame-name} oper-ord.tempo-homem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-ord.tempo-prepar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.tempo-prepar V-table-Win
ON LEAVE OF oper-ord.tempo-prepar IN FRAME f-main /* Tempo Prepara‡Æo */
DO:
  assign de-tempo-prepar = input frame {&frame-name} oper-ord.tempo-prepar.
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

 {utp/ut-field.i mgind oper-ord tipo-oper 1}.
 assign cb-tipo-oper:label in frame {&frame-name} = trim(return-value).
 {utp/ut-field.i mgind oper-ord un-med-tempo 1}.
 assign cb-un-med-tempo:label in frame {&frame-name} = trim(return-value).
 {utp/ut-field.i mgind oper-pad nr-oper-pad 1}.
 assign fi-oper-pad:label in frame {&frame-name} = trim(return-value).
 {utp/ut-liter.i Tempo_Ressup mcp L}
 assign fi-tempo-ressup:label in frame {&frame-name} = trim(return-value).

 /***  Incializa»’o dos combos   ***/       

 {utp/ut-field.i mgind oper-ord un-med-tempo 5}
 assign cb-un-med-tempo = {ininc/i02in261.i 04 integer(return-value)}.

 {utp/ut-field.i mgind oper-ord tipo-oper 5}
 assign cb-tipo-oper = {ininc/i01in261.i 04 integer(return-value)}.

               /***   ***/ 

 if oper-ord.gm-codigo:load-mouse-pointer ("image/lupa.cur") then.
 if oper-ord.fi-codigo:load-mouse-pointer ("image/lupa.cur") then.
 if oper-ord.pto-controle:load-mouse-pointer ("image/lupa.cur") then.
 if fi-oper-pad:load-mouse-pointer ("image/lupa.cur") then.
 if oper-ord.cod-roteiro:load-mouse-pointer ("image/lupa.cur") then.
 if oper-ord.it-codigo:load-mouse-pointer ("image/lupa.cur") then.

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
  {src/adm/template/row-list.i "oper-ord"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "oper-ord"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaGrpMaq V-table-Win 
PROCEDURE atualizaGrpMaq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-gm-codigo LIKE oper-ord.gm-codigo NO-UNDO.

IF oper-ord.gm-codigo:SENSITIVE IN FRAME f-main THEN
    ASSIGN oper-ord.gm-codigo:SCREEN-VALUE IN FRAME f-main = p-gm-codigo.

RETURN "OK":U.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveGrpMaq V-table-Win 
PROCEDURE leaveGrpMaq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

APPLY "leave":U TO oper-ord.gm-codigo IN FRAME f-main.

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

  find ord-prod where rowid(ord-prod) = v-row-parent no-lock no-error.

  /* Inicializa sequencia da operacao conforme o intervalo de variacao de */
  /* operacoes na tabela de parametros de engenharia                      */

     find first param-en no-lock no-error.
     if  not avail param-en then do:
         run utp/ut-msgs.p (input 'show',
                            input 7597,
                            input '').
         return 'ADM-ERROR':U.
     end.

     for each  b-oper-ord
         where b-oper-ord.nr-ord-prod = ord-prod.nr-ord-prod
           and b-oper-ord.it-codigo   = ord-prod.it-codigo no-lock
            by b-oper-ord.op-codigo desc:
         leave.
     end.
     assign oper-ord.op-codigo:screen-value in frame {&frame-name} = if avail b-oper-ord 
                           then string(b-oper-ord.op-codigo + param-en.num-var-operacao)
                           else string(param-en.num-var-operacao).


  if  avail ord-prod then do :
      assign oper-ord.it-codigo:screen-value in frame {&frame-name} = ord-prod.it-codigo.
  end.
  assign fi-tempo-ressup:screen-value in frame {&frame-name} = "0.000"
         fi-tempo-maquin:screen-value in frame {&frame-name} = "0.000"
         fi-oper-pad:screen-value in frame {&frame-name} = "0"
         de-tempo-homem  = 0 
         de-tempo-maquin = 0
         de-tempo-prepar = 0
         c-gm-codigo     = "".

  /*valor inicial para o combo Tipo Opera‡Æo*/
  ASSIGN cb-tipo-oper:screen-value in frame {&frame-name} = {ININC/I01IN261.I 04 1}.
  APPLY "value-changed":U TO cb-tipo-oper IN FRAME f-main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST param-global NO-LOCK NO-ERROR.

DO TRANSACTION:
    DEFINE BUFFER b-pert-ordem FOR pert-ordem.
    /*Alterado FO*/ 
    DEFINE BUFFER bff1-oper-ord FOR oper-ord.

    DEFINE VARIABLE i-seq                  AS INTEGER                 NO-UNDO.
    DEFINE VARIABLE de-tempo-prepar-orig   LIKE oper-ord.tempo-prepar NO-UNDO.
    DEFINE VARIABLE de-fator               AS DEC                     NO-UNDO.
    DEFINE VARIABLE l-split-unico          AS LOGICAL                 NO-UNDO.
    DEFINE VARIABLE l-atualiza-prep-split  AS LOGICAL                 NO-UNDO.
    DEFINE VARIABLE c-gm-codigo            AS CHARACTER               NO-UNDO.
    

    ASSIGN i-seq                = 0
           de-tempo-prepar-orig = ?.

    IF AVAILABLE oper-ord THEN
        ASSIGN c-gm-codigo = oper-ord.gm-codigo.

    IF cb-tipo-oper:lookup (cb-tipo-oper:screen-value) IN FRAME {&FRAME-NAME} = 1 THEN DO:
       ASSIGN de-tempo-res-maq = INPUT FRAME {&FRAME-NAME} fi-tempo-maquin.
    END.
    ELSE DO:
        ASSIGN de-tempo-res-maq = INPUT FRAME {&FRAME-NAME} fi-tempo-ressup.
    END.
    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    /* Ponha na pi-validate todas as valida»„es */
    /* N’o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */

    /* alterado FO */
    FOR each bff1-oper-ord
        WHERE bff1-oper-ord.nr-ord-produ  = ord-prod.nr-ord-produ NO-LOCK:
        IF bff1-oper-ord.sequencia > i-seq THEN
            ASSIGN i-seq = bff1-oper-ord.sequencia. 
    END.
    ASSIGN i-seq                = i-seq + 1
           de-tempo-prepar-orig = oper-ord.tempo-prepar WHEN AVAIL oper-ord.
    
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    ASSIGN oper-ord.tempo-maquin     = de-tempo-res-maq.
           
    IF oper-ord.tipo-oper = 1 THEN 
       ASSIGN oper-ord.pto-controle = input frame {&frame-name} oper-ord.pto-controle.

    /* alterado FO */
    FIND FIRST ord-prod WHERE ord-prod.nr-ord-prod = oper-ord.nr-ord-prod NO-LOCK NO-ERROR.
    IF c-estado = "incluir" AND adm-new-record = YES THEN
        ASSIGN oper-ord.sequencia        = i-seq. 

    IF c-estado = "incluir" AND adm-new-record = YES AND i-unid <> ord-prod.qt-ordem AND i-unid <> 0 AND l-alterada = NO THEN DO:

        ASSIGN oper-ord.tempo-homem   = (oper-ord.tempo-homem / i-unid) * ord-prod.qt-ordem
               oper-ord.tempo-maquin  = (oper-ord.tempo-maquin / i-unid) * ord-prod.qt-ordem.

    END.

    ASSIGN l-split-unico = CAN-FIND(split-operac WHERE
                                    split-operac.nr-ord-produ = oper-ord.nr-ord-produ AND
                                    split-operac.num-operac-sfc = oper-ord.num-operac-sfc).

    IF ord-prod.rep-prod <> 4 AND param-global.modulo-ch then do:
        IF de-tempo-prepar-orig <> ? THEN DO:
            IF oper-ord.tempo-prepar <> de-tempo-prepar-orig THEN DO:
                case oper-ord.un-med-tempo:
                    when 1 then
                        assign de-fator = 3600.
                    when 2 then
                        assign de-fator = 60.
                    when 3 then
                        assign de-fator = 1.
                    when 4 then
                        assign de-fator = 24 * 3600.
                end case.
                
                /*Gravado sempre em segundos*/
                ASSIGN &IF DEFINED(bf_man_207) &THEN
                       oper-ord.qtd-tempo-prepar-orig      = truncate(oper-ord.tempo-prepar * de-fator,0)
                       &ELSE
                       OVERLAY(oper-ord.char-1,110,10)     = STRING(truncate(oper-ord.tempo-prepar * de-fator,0),"9999999999")
                       &ENDIF
                       l-atualiza-prep-split = YES.

            END.
        END.
    END.

    IF l-atualiza-prep-split OR 
       (ADM-NEW-RECORD = NO AND 
        l-split-unico = YES AND
        oper-ord.gm-codigo <> c-gm-codigo) THEN DO:

        FOR EACH split-operac EXCLUSIVE-LOCK
           WHERE split-operac.nr-ord-produ     = oper-ord.nr-ord-produ
             AND split-operac.num-operac-sfc   = oper-ord.num-operac-sfc:

            IF split-operac.ind-estado-split > 3 THEN NEXT.

            IF l-atualiza-prep-split = YES THEN
                ASSIGN overlay(split-operac.char-1,9,10) = "":U.

            IF (ADM-NEW-RECORD = NO AND 
                l-split-unico = YES AND
                oper-ord.gm-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> c-gm-codigo) THEN DO:

                ASSIGN split-operac.gm-codigo = oper-ord.gm-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
				       split-operac.cod-ctrab = oper-ord.cod-recurso.
            END.
        END.

    END.

    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    &IF DEFINED (bf_man_sfc_lc) &THEN
        find first op-sfc where 
                   op-sfc.nr-ord-produ = oper-ord.nr-ord-produ EXCLUSIVE-LOCK no-error.

        if oper-ord.num-operac-sfc = 0 then do:
           find last b-oper-ord use-index sfc where
                     b-oper-ord.nr-ord-produ = oper-ord.nr-ord-produ no-lock no-error.
             assign oper-ord.num-operac-sfc = if avail b-oper-ord then 
                                                b-oper-ord.num-operac-sfc + 1 else 1.
        end. 

        /*** Caso jÿ exista rede-pert cadastrada para o item corrente    
             pergunta se deseja substitui-la. ***/
        /*Diego*/
          if ord-prod.estado < 5 and
             c-estado = "incluir" AND 
             adm-new-record = YES then do:
              find first b-pert-ordem 
                   where b-pert-ordem.nr-ord-produ = oper-ord.nr-ord-produ no-lock no-error.
              if avail b-pert-ordem then do:
                 {utp/ut-table.i mgind ord-prod 1}
                 run utp/ut-msgs.p (input "show",
                                    input 2629,
                                    input return-value + "~~" + string(b-pert-ordem.nr-ord-produ)).
              end.
          //end.

                if not avail b-pert-ordem 
                or return-value = 'yes':U
                //or ((ord-prod.estado = 5 or ord-prod.estado = 6) and c-estado = "incluir")
                then do: 
    
               /*  if (ord-prod.estado = 5 or ord-prod.estado = 6) and c-estado = "incluir" then
                    run utp/ut-msgs.p (input "show",
                                       input 30369,
                                       input "").*/
    
                 RUN set-cursor IN adm-broker-hdl (INPUT "wait").
                 RUN pi-inclui-pert-ordem(INPUT ROWID(oper-ord)).
                 RUN set-cursor IN adm-broker-hdl (INPUT " ").
              end.
          END.

/* Ativ. 161116 */
         /*Diego*/
        /* verifica a existencia da sequencia para as novas opera‡äes que foram inseridas */

          IF c-estado = "incluir" AND adm-new-record = YES THEN DO:

               IF AVAIL ord-prod THEN DO:
                  FOR each b-oper-ord use-index codigo 
                      where b-oper-ord.nr-ord-produ = ord-prod.nr-ord-produ no-lock:   
                      
                      find first rede-pert use-index rede
                           where rede-pert.it-codigo    = b-oper-ord.it-codigo
                           AND   rede-pert.op-codigo    = b-oper-ord.op-codigo no-lock no-error.
                            IF NOT AVAIL rede-pert THEN
                                ASSIGN l-adic = YES.
                           
                  END.
                 /* IF l-adic THEN
                      run utp/ut-msgs.p (input "show":U,
                                         INPUT 32605,
                                         input "").*/
              END.
          END.

        IF ord-prod.rep-prod <> 4 AND param-global.modulo-ch then do:
           IF NOT VALID-HANDLE(h-boin533) THEN
               run inbo/boin533.p persistent set h-boin533.
           IF NOT AVAIL op-sfc THEN
               RUN gerarOrdemSFC IN h-boin533(BUFFER ord-prod).
           
           FIND FIRST op-sfc EXCLUSIVE-LOCK 
               WHERE op-sfc.nr-ord-produ = ord-prod.nr-ord-produ NO-ERROR.

           IF AVAIL op-sfc THEN 
           run GerarSplitOperac in h-boin533 (buffer op-sfc).
           IF VALID-HANDLE(h-boin533) THEN
               delete procedure h-boin533.
           
        end.
        /***Consiste a rede-pert***/
        IF AVAIL pert-ordem THEN DO:
            
            EMPTY TEMP-TABLE tt-gera-rede.
            
            create tt-gera-rede.
            assign tt-gera-rede.nr-ord-produ   = ord-prod.nr-ord-produ
                   tt-gera-rede.tipo-exec      = 4
                   tt-gera-rede.rw-pert-ordem  = rowid(pert-ordem)
                   tt-gera-rede.cod-prog-orig  = "v09in260.w"
                   tt-gera-rede.cod-versao-integracao = 001.
            
            run cpp/cpapi023.p (input-output table tt-gera-rede,
                                input-output table tt-erro,
                                input        true).
            
                if return-value <> 'ok':u or
                   temp-table tt-erro:has-records then do:
                    run cdp/cd0666.w (input table tt-erro).
                    undo, return 'ADM-ERROR':U.
                END.
        end.
        /***Consiste a rede-pert***/

        /* Execucao caso usuario possua integracao EAI */
          IF v_log_eai_habilit AND
             return-value <> "ADM-ERROR":U THEN DO:
             FIND FIRST ord-prod WHERE 
                        ord-prod.nr-ord-produ =  oper-ord.nr-ord-prod NO-LOCK NO-ERROR. 
             IF AVAIL ord-prod THEN DO: 
                CREATE tt-ord-prod.
                BUFFER-COPY ord-prod TO tt-ord-prod.
                RUN adapters/xml/ma2/axsma007.p (INPUT "upd",
                                                 INPUT "v01in260.w",
                                                 INPUT STRING(c-prg-vrs),
                                                 INPUT TABLE tt-ord-prod,
                                                 OUTPUT TABLE RowErrors).  
                DELETE tt-ord-prod. 
                 FIND FIRST RowErrors WHERE 
                            RowErrors.ErrorSubType = "ERROR":U NO-LOCK NO-ERROR.
                 IF AVAIL RowErrors THEN DO:
                     run utp/ut-msgs.p (input "show",
                                        input RowErrors.ErrorNumber,
                                        input RowErrors.ErrorDescription).                                            
                     UNDO, return 'ADM-ERROR':U.
                 END.
             END.
          END.
          /******verifica se a itegra‡Æo com PPIMultiTask esta ativa ******/
          FOR FIRST param-cp WHERE param-cp.log-integr-ppi-mes = YES NO-LOCK:
             run cpp/cpapi301b.p ( input rowid(ord-prod),
                                   input ord-prod.nr-ord-prod, 
                                   input 2).
             if return-value = "NOK" then do:
                 {utp/ut-liter.i Ordem_de_produ‡Æo *}
                 run utp/ut-msgs.p (input "show",
                                    input 54436,
                                    input RETURN-VALUE).
             end.
          END.
    &ENDIF                  
    /* Todos os assign‹s n’o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
END.

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

    assign input frame {&frame-name} cb-un-med-tempo
           oper-ord.un-med-tempo = {ininc/i02in261.i 06 cb-un-med-tempo}
           input frame {&frame-name} cb-tipo-oper
           oper-ord.tipo-oper = {ininc/i01in261.i 06 cb-tipo-oper}.

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

    find ord-prod  where rowid(ord-prod) = v-row-parent EXCLUSIVE-LOCK no-error.
    if available ord-prod  then
        assign oper-ord.nr-ord-prod = ord-prod.nr-ord-prod.

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

  /* Code placed here will execute AFTER standard behavior.    */

  if avail oper-ord then do:

     assign cb-un-med-tempo:screen-value in frame {&frame-name} = {ININC/I02IN261.I 04 oper-ord.un-med-tempo}
            cb-tipo-oper:screen-value in frame {&frame-name}    = {ININC/I01IN261.I 04 oper-ord.tipo-oper}
            de-tempo-homem  = oper-ord.tempo-homem
            de-tempo-maquin = oper-ord.tempo-maquin
            de-tempo-prepar = oper-ord.tempo-prepar
            c-gm-codigo     = oper-ord.gm-codigo.
     if oper-ord.tipo-oper = 1 THEN  DO:
         ASSIGN de-tempo-maquin = oper-ord.tempo-maquin
             fi-tempo-maquin:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(de-tempo-maquin).
     END.
     ELSE DO:
         ASSIGN de-tempo-ressup = oper-ord.tempo-maquin
               fi-tempo-ressup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(de-tempo-ressup).
     END.

    find first grup-maquina no-lock
         where grup-maquina.gm-codigo = oper-ord.gm-codigo:screen-value in frame {&frame-name} no-error.
    if  avail grup-maquina then
       assign gr-grup-maquina = rowid(grup-maquina).

     apply 'value-changed' to cb-tipo-oper in frame {&frame-name}.

     if oper-ord.tipo-oper = 2 THEN  DO:         
         ASSIGN oper-ord.pto-controle:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

     END.


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
    if adm-new-record = yes then
    &if  defined(ADM-MODIFY-FIELDS) &then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

apply 'value-changed' to cb-tipo-oper in frame {&frame-name}.

    IF AVAIL oper-ord THEN DO:
        IF oper-ord.tipo-oper = 1 THEN
            ASSIGN pto-controle:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
        ELSE
            ASSIGN pto-controle:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
    END.

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
DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
ASSIGN cAuxTraducao001 = {ininc/i02in261.i 03}.
RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
ASSIGN cb-un-med-tempo:LIST-ITEM-PAIRS in frame {&frame-name} = cAuxTraducao001.
&else
ASSIGN cb-un-med-tempo:list-items in frame {&frame-name} = {ININC/I02IN261.I 03}.
&endif
  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
      ASSIGN cAuxTraducao002 = {ininc/i01in261.i 03}.
      RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
      ASSIGN cb-tipo-oper:LIST-ITEM-PAIRS in frame {&frame-name} = cAuxTraducao002.
  &else
      ASSIGN cb-tipo-oper:list-items in frame {&frame-name} = {ININC/I01IN261.I 03}.
  &endif
  
    /*Verifica se funcao mudancas sfc est  implantada*/
    &IF DEFINED(bf_man_204) &THEN
        RUN sfc/sf9999.p(OUTPUT l-mudancas-sfc).
    &ENDIF

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    APPLY "leave":U TO oper-ord.gm-codigo IN FRAME f-main.

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copia-op-padrao V-table-Win 
PROCEDURE pi-copia-op-padrao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter r-oper-pad as rowid.
find oper-pad where rowid (oper-pad) = r-oper-pad no-lock no-error.

   assign oper-ord.descricao:screen-value    in frame {&frame-name} = oper-pad.descricao
          cb-tipo-oper:screen-value          in frame {&frame-name} = {ININC/i01in261.I 04 oper-pad.tipo-oper}
          /*oper-ord.gm-codigo:screen-value    in frame {&frame-name} = oper-pad.gm-codigo*/
          oper-ord.fi-codigo:screen-value    in frame {&frame-name} = string(oper-pad.fi-codigo)
          oper-ord.pto-controle:screen-value in frame {&frame-name} = string(oper-pad.pto-controle)
          cb-un-med-tempo:screen-value       in frame {&frame-name} = {ININC/I02IN261.I 04 oper-pad.un-med-tempo}
          oper-ord.tempo-prepar:screen-value in frame {&frame-name} = string(oper-pad.tempo-prepar)
          oper-ord.tempo-homem:screen-value  in frame {&frame-name} = string(oper-pad.tempo-homem).

   if cb-tipo-oper:lookup (cb-tipo-oper:screen-value) = 1 THEN DO:
       ASSIGN oper-ord.gm-codigo:SCREEN-VALUE    in frame {&frame-name} = oper-pad.gm-codigo.
       ASSIGN fi-tempo-maquin:screen-value       in frame {&frame-name} = string(oper-pad.tempo-maquin). /*ariane*/
   END.
   ELSE DO: 
       ASSIGN oper-ord.gm-codigo:screen-value    in frame {&FRAME-NAME} = ""
              oper-ord.gm-codigo:sensitive       in frame {&frame-name} = NO
              oper-ord.pto-controle:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
       ASSIGN fi-tempo-ressup:screen-value       in frame {&frame-name} = string(oper-pad.tempo-maquin). /*ariane*/
   END.

   find first grup-maquina no-lock
        where grup-maquina.gm-codigo = oper-ord.gm-codigo:screen-value in frame {&frame-name} no-error.
   if  avail grup-maquina then
       assign gr-grup-maquina = rowid(grup-maquina).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inclui-pert-ordem V-table-Win 
PROCEDURE pi-inclui-pert-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter r-oper-ord as rowid no-undo.
DEFINE BUFFER bf-oper-ord FOR oper-ord.

    FIND oper-ord 
        WHERE rowid(oper-ord) = r-oper-ord NO-LOCK NO-ERROR.
    
    FIND FIRST ord-prod 
        WHERE ord-prod.nr-ord-produ = oper-ord.nr-ord-produ NO-LOCK NO-ERROR.
    
    IF AVAIL oper-ord THEN DO:

        IF NOT CAN-FIND (FIRST pert-ordem
                         WHERE pert-ordem.nr-ord-produ = oper-ord.nr-ord-produ) OR
            ord-prod.estado < 5 THEN DO:
            
            RUN cpp/cp0302e1.p(INPUT ord-prod.nr-ord-produ).
            LEAVE.
        END.
        IF c-estado = "incluir" AND adm-new-record = YES THEN DO:
    
            FOR EACH bf-oper-ord FIELDS(log-operac-final) EXCLUSIVE-LOCK
                WHERE bf-oper-ord.nr-ord-produ = oper-ord.nr-ord-produ
                  AND ROWID(bf-oper-ord) <> r-oper-ord
                  AND bf-oper-ord.log-operac-final:
                ASSIGN bf-oper-ord.log-operac-final = FALSE.
            END.
            
                for first bf-oper-ord fields (cod-roteiro it-codigo
                                             op-codigo   
                                           &IF DEFINED (bf_man_sfc_lc) &THEN
                                             num-operac-sfc
                                           &ENDIF
                                             ) no-lock where
                          bf-oper-ord.nr-ord-produ = ord-prod.nr-ord-produ and
                          bf-oper-ord.sequencia    = oper-ord.sequencia - 1: 
        
                    create pert-ordem.
                    assign pert-ordem.nr-ord-produ       = ord-prod.nr-ord-produ
                           pert-ordem.cod-roteiro        = oper-ord.cod-roteiro        
                           pert-ordem.it-codigo          = oper-ord.it-codigo          
                           pert-ordem.op-codigo          = oper-ord.op-codigo          
                           pert-ordem.rot-predec         = bf-oper-ord.cod-roteiro     
                           pert-ordem.it-predec          = bf-oper-ord.it-codigo       
                           pert-ordem.op-predec          = bf-oper-ord.op-codigo       
                        &IF DEFINED (bf_man_sfc_lc) &THEN
                           pert-ordem.num-operac-predec  = bf-oper-ord.num-operac-sfc
                           pert-ordem.num-operac-suces   = oper-ord.num-operac-sfc   
                        &ENDIF
                           pert-ordem.overlap            = 0
                           pert-ordem.transporte         = 0.
                    
                END. /*for first bf-oper-ord*/
        END. /*IF c-estado = "incluir" AND*/
    END. /*IF AVAIL oper-ord*/
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-estado V-table-Win 
PROCEDURE pi-recebe-estado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter estado as char no-undo.

assign c-estado = estado.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N’o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida»„es, pois neste ponto do programa o registro 
  ainda n’o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida»’o de dicionÿrio */

    DEFINE VARIABLE c-gm-original AS CHARACTER  NO-UNDO.

/*/*    Segue um exemplo de valida»’o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/
    DEFINE BUFFER bf-oper-ord-ant FOR oper-ord.

    APPLY "leave":U TO oper-ord.gm-codigo IN FRAME f-main.   

 find ord-prod where rowid(ord-prod) = gr-ord-prod no-lock no-error.
 
  if cb-tipo-oper:lookup (cb-tipo-oper:screen-value) = 1 and ord-prod.tipo = 2 then do:
      run utp/ut-msgs.p (input "show",
                         input 15467,
                         input "").
      apply 'entry' to cb-tipo-oper.
      return 'ADM-ERROR':U.
  end.
 
  if input frame {&frame-name} oper-ord.it-codigo <> ord-prod.it-codigo then do:      
     if not f-fantasma (ord-prod.nr-ord-prod,
                       (input frame {&frame-name} oper-ord.it-codigo)) then do:
        run utp/ut-msgs.p (input "show",
                           input 2651,
                           input "").
        apply 'entry' to oper-ord.it-codigo.                   
        return 'ADM-ERROR':U.
     end.
  end.
  

  /*Valida‡äes de inclusÆo de opera‡äes em ordens iniciadas em ordens com reporte por opera‡Æo ou pto*/
  if (ord-prod.estado = 5 or ord-prod.estado = 6) and
     (ord-prod.rep-prod = 2 or ord-prod.rep-prod = 3) AND
      c-estado = "modificar"
   then do:
        /*Verifica se existe opera‡Æo reportada ap¢s a opera‡Æo que est  sendo incluida*/
        find first b-oper-ord where
                   b-oper-ord.nr-ord-prod = ord-prod.nr-ord-prod and
                   b-oper-ord.sequencia  > oper-ord.sequencia
                   no-lock no-error.
        if avail b-oper-ord and 
           can-find(first rep-oper where 
                          rep-oper.nr-ord-produ = b-oper-ord.nr-ord-produ and 
                          rep-oper.op-seq >= b-oper-ord.sequencia no-lock) or
           can-find(first movto-mat where 
                          movto-mat.nr-ord-produ = b-oper-ord.nr-ord-produ and 
                          movto-mat.op-seq >= b-oper-ord.sequencia and
                          movto-mat.esp-docto = 1 no-lock) or
           can-find(first movto-ggf where 
                          movto-ggf.nr-ord-produ = b-oper-ord.nr-ord-produ and 
                          movto-ggf.op-seq >= b-oper-ord.sequencia no-lock) or
           can-find(first movto-dir where 
                          movto-dir.nr-ord-produ = b-oper-ord.nr-ord-produ and 
                          movto-dir.op-seq >= b-oper-ord.sequencia no-lock)
        then do:
              /*Existe opera‡Æo iniciada ap¢s a que est  sendo incluida*/
              run utp/ut-msgs.p (input "show":U,
                                 input 30368,
                                 input "").
              apply 'entry' to oper-ord.op-codigo.
              return 'adm-error':U.
        end.
        /* Atividade: 196714
        if cb-tipo-oper:lookup (cb-tipo-oper:screen-value) = 2 then do:

             /*NÆo pode ser inclu¡da opera‡Æo externa em uma ordem iniciada*/
              run utp/ut-msgs.p (input "show":U,
                                 input 30377,
                                 input "").
              apply 'entry' to oper-ord.op-codigo.
              return 'adm-error':U.

        end.*/
  end.

  if c-estado = "incluir" then  

     if  can-find (first oper-ord 
         where oper-ord.op-codigo = input frame {&frame-name} oper-ord.op-codigo
         and   oper-ord.nr-ord-prod = ord-prod.nr-ord-prod
         and   oper-ord.it-codigo   = input frame {&frame-name} oper-ord.it-codigo
         and   oper-ord.cod-roteiro = input frame {&frame-name} oper-ord.cod-roteiro) then do:
         {include/i-vldprg.i} 
         run utp/ut-msgs.p (input "show",
                            input 2162,
                            input "").
         apply 'entry' to oper-ord.op-codigo.
         return 'adm-error':U.
     end.

   if  input frame {&frame-name} oper-ord.op-codigo = 0 then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show",
                         input 2438,
                         input "").
      apply 'entry' to oper-ord.op-codigo.
      return 'ADM-ERROR':U.
  end.

  if  input frame {&frame-name} oper-ord.descricao = "" then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show",
                         input 190,
                         input "").
      apply 'entry' to oper-ord.descricao.
      return 'ADM-ERROR':U.
  end.

  if input frame {&frame-name} oper-ord.fi-codigo <> 0 and 
     not can-find (ficha-metodo
        where ficha-metodo.fi-codigo = input frame {&frame-name} oper-ord.fi-codigo) then do:
        {include/i-vldprg.i} 
         run utp/ut-msgs.p (input "show",
                            input 2443,
                            input "").
         apply 'entry' to oper-ord.fi-codigo.
         return 'ADM-ERROR':U.
  end.

  if  {ininc/i01in261.i 06 cb-tipo-oper} = 1
  and oper-ord.gm-codigo:sensitive in frame {&frame-name} = YES THEN DO:

      IF not can-find (grup-maquina
                 where grup-maquina.gm-codigo = input frame {&frame-name} oper-ord.gm-codigo) then do:

         {include/i-vldprg.i} 
         run utp/ut-msgs.p (input "show",
                            input 611,
                            input "").
         apply 'entry' to oper-ord.gm-codigo.
         return 'ADM-ERROR':U.
      end. 
/*       &IF DEFINED(bf_man_204) &THEN                                                                                        */
/*       ELSE                                                                                                                 */
/*           IF l-mudancas-sfc THEN DO:                                                                                       */
/*                                                                                                                            */
/*               if adm-new-record = NO AND avail oper-ord AND                                                                */
/*                   oper-ord.gm-codigo <> INPUT FRAME {&frame-name} oper-ord.gm-codigo then do:                              */
/*                                                                                                                            */
/*                   RELEASE operacao.                                                                                        */
/*                   RELEASE op-altern.                                                                                       */
/*                                                                                                                            */
/*                   IF oper-ord.op-altern = 0 THEN                                                                           */
/*                       FIND FIRST operacao NO-LOCK                                                                          */
/*                           WHERE operacao.num-id-operacao = oper-ord.num-id-operacao NO-ERROR.                              */
/*                   ELSE                                                                                                     */
/*                       FIND FIRST op-altern NO-LOCK                                                                         */
/*                           WHERE op-altern.num-id-operacao = oper-ord.num-id-operacao                                       */
/*                             AND op-altern.op-altern       = oper-ord.op-altern NO-ERROR.                                   */
/*                                                                                                                            */
/*                   IF (NOT AVAIL op-altern AND NOT AVAIL operacao) THEN                                                     */
/*                       ASSIGN c-gm-original = oper-ord.gm-codigo.                                                           */
/*                   ELSE DO:                                                                                                 */
/*                       IF AVAIL operacao THEN                                                                               */
/*                           ASSIGN c-gm-original = operacao.gm-codigo.                                                       */
/*                       ELSE                                                                                                 */
/*                           ASSIGN c-gm-original = op-altern.gm-codigo.                                                      */
/*                   END.                                                                                                     */
/*                                                                                                                            */
/*                   IF c-gm-original <> INPUT FRAME {&frame-name} oper-ord.gm-codigo AND                                     */
/*                       NOT CAN-FIND(FIRST grup-maq-alter                                                                    */
/*                                   WHERE grup-maq-alter.gm-codigo = c-gm-original                                           */
/*                                     AND grup-maq-alter.gm-altern = INPUT FRAME {&frame-name} oper-ord.gm-codigo) THEN DO:  */
/*                        {include/i-vldprg.i}                                                                                */
/*                        run utp/ut-msgs.p (input "show",                                                                    */
/*                                           input 32438,                                                                     */
/*                                           input "").                                                                       */
/*                        apply 'entry' to oper-ord.gm-codigo.                                                                */
/*                        return 'ADM-ERROR':U.                                                                               */
/*                   END.                                                                                                     */
/*               END.                                                                                                         */
/*           END. /*IF l-mudancas-sfc*/                                                                                       */
/*       &ENDIF                                                                                                               */
  END.

  if input frame {&frame-name} oper-ord.pto-controle <> 0 and
     not can-find (pto-controle 
       where pto-controle.codigo = input frame {&frame-name} oper-ord.pto-controle) then do:
       {include/i-vldprg.i} 
       run utp/ut-msgs.p (input "show",
                          input 2444,
                          input "").
       apply 'entry' to oper-ord.pto-controle.
       return 'ADM-ERROR':U.
  end.

  if input frame {&frame-name} fi-oper-pad <> 0 then do:
     find oper-pad where oper-pad.nr-oper-pad = input frame {&frame-name} fi-oper-pad
          no-lock no-error.
     if not avail oper-pad then do:
       {include/i-vldprg.i} 
       run utp/ut-msgs.p (input "show",
                          input 1891,
                          input "").
       apply 'entry' to fi-oper-pad.
       return 'adm-error':U.
     end.
  end.

  if adm-new-record then do:  
     if input frame {&frame-name} oper-ord.pto-controle <> 0 and
        can-find (first oper-ord 
                  where oper-ord.pto-controle = input frame {&frame-name} oper-ord.pto-controle
                    and oper-ord.nr-ord-prod  = ord-prod.nr-ord-prod) then do:
        {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show",
                           input 1908,
                           input "").
        apply 'entry' to oper-ord.pto-controle.
        return 'adm-error':U.
     end.
  end.
  else do:
       if input frame {&frame-name} oper-ord.pto-controle <> 0 then do:

           find first b-oper-ord
               where b-oper-ord.pto-control = input frame {&frame-name} oper-ord.pto-controle
                 and b-oper-ord.nr-ord-prod = ord-prod.nr-ord-prod
                 and rowid (b-oper-ord) <> rowid (oper-ord) no-lock no-error.
           if avail b-oper-ord then do:
              {include/i-vldprg.i} 
              run utp/ut-msgs.p (input "show",
                                 input 1908,
                                 input "").
              apply 'entry' to oper-ord.pto-controle.
              return 'adm-error':U.
           end.
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
  {src/adm/template/snd-list.i "oper-ord"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaHandlePag2 V-table-Win 
PROCEDURE setaHandlePag2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-handle AS HANDLE NO-UNDO.

ASSIGN hPag2 = p-handle.

RETURN "OK":U.
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

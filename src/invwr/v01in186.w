&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME

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
{include/i-prgvrs.i V01IN186 2.00.00.022 } /*** "010022" 02/04/2025 15:07:17 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN186 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def new global shared var gr-conta-contab as rowid no-undo.
def new global shared var gr-lin-prod as rowid no-undo.
def new global shared var gr-planejad as rowid no-undo.

/** Unifica‡Æo de conceito **/
{cdp/cdunif001.i}
{cdp/cdunif001.i1}

&IF "{&mguni_version}" >= "2.071" &THEN
def var i-empresa-prin LIKE empresa.ep-codigo no-undo.
&ELSE
def var i-empresa-prin as integer no-undo.
&ENDIF
DEF VAR c-estab-prin AS CHARACTER NO-UNDO.

define variable l-param-logico as logical no-undo.

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
&Scoped-define EXTERNAL-TABLES lin-prod
&Scoped-define FIRST-EXTERNAL-TABLE lin-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR lin-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS lin-prod.descricao lin-prod.cd-planejado ~
lin-prod.sum-requis lin-prod.ct-ordem lin-prod.sc-ordem lin-prod.aloca-ord ~
lin-prod.deposito-pad lin-prod.var-transf lin-prod.var-req-menor ~
lin-prod.var-rep lin-prod.var-requis 
&Scoped-define ENABLED-TABLES lin-prod
&Scoped-define FIRST-ENABLED-TABLE lin-prod
&Scoped-Define ENABLED-OBJECTS RECT-1 rt-key rt-mold RECT-3 RECT-4 RECT-5 ~
RECT-9 c-desc-depos c-info-text 
&Scoped-Define DISPLAYED-FIELDS lin-prod.cod-estabel lin-prod.nr-linha ~
lin-prod.descricao lin-prod.cd-planejado lin-prod.sum-requis ~
lin-prod.ct-ordem lin-prod.sc-ordem lin-prod.aloca-ord ~
lin-prod.deposito-pad lin-prod.var-transf lin-prod.var-req-menor ~
lin-prod.var-rep lin-prod.var-requis 
&Scoped-define DISPLAYED-TABLES lin-prod
&Scoped-define FIRST-DISPLAYED-TABLE lin-prod
&Scoped-Define DISPLAYED-OBJECTS c-desc-estab FI-nome-planejador ~
c-desc-depos c-info-text 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS lin-prod.cod-estabel lin-prod.nr-linha 
&Scoped-define List-4 c-desc-depos lin-prod.deposito-pad ~
lin-prod.var-transf lin-prod.var-req-menor lin-prod.var-rep ~
lin-prod.var-requis 

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
DEFINE VARIABLE c-desc-depos AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-info-text AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 32 BY .67
     FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE FI-nome-planejador AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE fi-texto AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 2.42.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 4.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 5.75.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 3.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 3.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 2.54.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 12.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     lin-prod.cod-estabel AT ROW 1.38 COL 29.14 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 7.14 BY .88
     c-desc-estab AT ROW 1.38 COL 37.14 COLON-ALIGNED NO-LABEL
     lin-prod.nr-linha AT ROW 2.38 COL 29.14 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 4.86 BY .88
     lin-prod.descricao AT ROW 2.38 COL 34.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN
          SIZE 31.43 BY .88          
     lin-prod.sum-requis AT ROW 5.75 COL 8 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS
                "Processo", 1,
                "Ordem de Servi‡o", 2
          SIZE 20.29 BY 1.54          
     lin-prod.cd-planejado AT ROW 5.42 COL 42 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 16.43 BY .88
     FI-nome-planejador AT ROW 5.42 COL 59 COLON-ALIGNED NO-LABEL
     lin-prod.ct-ordem AT ROW 6.54 COL 42 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     lin-prod.sc-ordem AT ROW 6.54 COL 63.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     lin-prod.aloca-ord AT ROW 7.75 COL 44.86
          VIEW-AS TOGGLE-BOX
          SIZE 28 BY .75
     c-desc-depos AT ROW 10.92 COL 24.31 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     lin-prod.deposito-pad AT ROW 10.92 COL 16.60 COLON-ALIGNED WIDGET-ID 48
          LABEL "Dep¢sito F brica"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     lin-prod.var-rep AT ROW 13 COL 32 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     lin-prod.var-transf AT ROW 14.12 COL 32 COLON-ALIGNED WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     lin-prod.var-req-menor AT ROW 13 COL 72 COLON-ALIGNED WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     lin-prod.var-requis AT ROW 14.12 COL 72 COLON-ALIGNED WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 8 BY .88      
     fi-texto AT ROW 5 COL 5.14 COLON-ALIGNED NO-LABEL
     c-info-text AT ROW 9.25 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     "Requisi‡Æo" VIEW-AS TEXT
          SIZE 10.72 BY .67 AT ROW 12.21 COL 48 WIDGET-ID 34
     "% Varia‡Æo" VIEW-AS TEXT
          SIZE 10.72 BY .67 AT ROW 12.21 COL 7 WIDGET-ID 36
     "Reporte" VIEW-AS TEXT
          SIZE 7.29 BY .67 AT ROW 9.88 COL 5 WIDGET-ID 38
     "Geral" VIEW-AS TEXT
          SIZE 5.43 BY .67 AT ROW 4.17 COL 4.57 WIDGET-ID 40
     RECT-1 AT ROW 5.33 COL 6
     rt-key AT ROW 1.08 COL 1
     rt-mold AT ROW 3.75 COL 1
     RECT-3 AT ROW 4.5 COL 2.86 WIDGET-ID 10
     RECT-4 AT ROW 10.25 COL 3 WIDGET-ID 14
     RECT-5 AT ROW 12.5 COL 6 WIDGET-ID 18
     RECT-9 AT ROW 12.5 COL 46 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: lin-prod
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
         HEIGHT             = 15.54
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-desc-depos IN FRAME f-main
   4                                                                    */
/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lin-prod.cod-estabel IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lin-prod.deposito-pad IN FRAME f-main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR FILL-IN FI-nome-planejador IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-texto IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN lin-prod.nr-linha IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lin-prod.var-rep IN FRAME f-main
   4                                                                    */
/* SETTINGS FOR FILL-IN lin-prod.var-req-menor IN FRAME f-main
   4                                                                    */
/* SETTINGS FOR FILL-IN lin-prod.var-requis IN FRAME f-main
   4                                                                    */
/* SETTINGS FOR FILL-IN lin-prod.var-transf IN FRAME f-main
   4                                                                    */
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

&Scoped-define SELF-NAME lin-prod.cd-planejado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.cd-planejado V-table-Win
ON ENTRY OF lin-prod.cd-planejado IN FRAME f-main /* Planejador */
DO:
  find  planejad no-lock
  where planejad.cd-planejado = input frame {&frame-name} 
        lin-prod.cd-planejado no-error.        
  if avail planejad then assign fi-nome-planejador = planejad.nome.                 
                    else assign fi-nome-planejador = "".                  
  display fi-nome-planejador with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.cd-planejado V-table-Win
ON F5 OF lin-prod.cd-planejado IN FRAME f-main /* Planejador */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom = "inzoom/z01in321.w"
                  &tabela    = lin-prod
                  &atributo  = cd-planejado}
 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.cd-planejado V-table-Win
ON LEAVE OF lin-prod.cd-planejado IN FRAME f-main /* Planejador */
DO:
  find  planejad no-lock
  where planejad.cd-planejado = input frame {&frame-name} 
        lin-prod.cd-planejado no-error.        
  if avail planejad then 
     assign fi-nome-planejador = planejad.nome
            gr-planejad = rowid(planejad).                 
  else assign fi-nome-planejador = "".                  
  display fi-nome-planejador with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.cd-planejado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lin-prod.cd-planejado IN FRAME f-main /* Planejador */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lin-prod.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.cod-estabel V-table-Win
ON F5 OF lin-prod.cod-estabel IN FRAME f-main /* Estabel */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=lin-prod.cod-estabel
                     &campozoom=cod-estabel
                     &campo2=c-desc-estab
                     &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.cod-estabel V-table-Win
ON LEAVE OF lin-prod.cod-estabel IN FRAME f-main /* Estabel */
DO:
    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=c-desc-estab
                     &where="estabelec.cod-estabel = input frame {&frame-name} lin-prod.cod-estabel"}  

    if  param-global.ind-cons-conta = 2 then do:
        find estabelec where
             estabelec.cod-estabel = input frame {&frame-name} lin-prod.cod-estabel NO-LOCK no-error.
        if available estabelec then     
           assign i-empresa-prin = estabelec.ep-codigo
                  c-estab-prin   = estabelec.cod-estabel.
    end.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lin-prod.cod-estabel IN FRAME f-main /* Estabel */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lin-prod.ct-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.ct-ordem V-table-Win
ON ENTRY OF lin-prod.ct-ordem IN FRAME f-main /* Conta Ordem */
DO:
  ASSIGN lin-prod.ct-ordem:FORMAT IN FRAME {&frame-name} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.ct-ordem V-table-Win
ON F5 OF lin-prod.ct-ordem IN FRAME f-main /* Conta Ordem */
DO:
    FIND FIRST param-global NO-LOCK NO-ERROR.
    ASSIGN i-ep-codigo-usuario = param-global.empresa-prin
           l-implanta          = YES.
        
    if not valid-handle(h_api_cta_ctbl) then 
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        
    assign v_cod_finalid = {adinc/i05ad049.i 4 1} 
                           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 2}
                           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 3}
                           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5}
                           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 6}.

    find first estabelec where estabelec.cod-estabel = lin-prod.cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} no-lock no-error.
                           
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT estabelec.ep-codigo,
                                                   INPUT "CEP",
                                                   INPUT "",
                                                   INPUT v_cod_finalid,
                                                   INPUT TODAY,
                                                   OUTPUT v_cod_cta_ctbl,
                                                   OUTPUT v_des_cta_ctbl,
                                                   OUTPUT p-finalidade,
                                                   OUTPUT TABLE tt_log_erro).
    
    {cdp/cdunif001b.i1}
        
    IF v_cod_cta_ctbl <> "" THEN
        ASSIGN lin-prod.ct-ordem:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.
    
    if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.ct-ordem V-table-Win
ON LEAVE OF lin-prod.ct-ordem IN FRAME f-main /* Conta Ordem */
DO:
    /** Unifica‡Æo de Conceito **/
    if not valid-handle(h_api_cta_ctbl) then 
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.    
    if not valid-handle(h_api_ccusto) then 
        run prgint/utb/utb742za.py persistent set h_api_ccusto.
    
    EMPTY TEMP-TABLE tt_log_erro.
        
    find first estabelec
         where estabelec.cod-estabel = input frame {&frame-name} lin-prod.cod-estabel no-lock no-error.

    assign lin-prod.ct-ordem:format in frame {&frame-name} = 'x(20)'
           lin-prod.sc-ordem:format in frame {&frame-name} = 'x(20)'.
        
    if avail estabelec then do:
        {cdp/cdunif001a.i lin-prod.ct-ordem lin-prod.sc-ordem {&FRAME-NAME} today estabelec.ep-codigo estabelec.cod-estabel}
    end. 
    else do:
        {cdp/cdunif001a.i lin-prod.ct-ordem lin-prod.sc-ordem {&FRAME-NAME} today "''" "''"}
    end.


    if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.
    if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.ct-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lin-prod.ct-ordem IN FRAME f-main /* Conta Ordem */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lin-prod.deposito-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.deposito-pad V-table-Win
ON F5 OF lin-prod.deposito-pad IN FRAME f-main /* Dep¢sito F brica */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=lin-prod.deposito-pad
                     &campozoom=cod-depos
                     &campo2=c-desc-depos
                     &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.deposito-pad V-table-Win
ON LEAVE OF lin-prod.deposito-pad IN FRAME f-main /* Dep¢sito F brica */
DO:
  {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=c-desc-depos
                   &where="deposito.cod-depos = input frame {&frame-name} lin-prod.deposito-pad"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.deposito-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lin-prod.deposito-pad IN FRAME f-main /* Dep¢sito F brica */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lin-prod.nr-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.nr-linha V-table-Win
ON LEAVE OF lin-prod.nr-linha IN FRAME f-main /* Linha Produ‡Æo */
DO:
  /*if  input frame {&frame-name} lin-prod.nr-linha = 0 then do:
 *       {utp/ut-table.i mgind lin-prod 1}
 *       run utp/ut-msgs.p (input "show",
 *                          input 1491,
 *                          input return-value).
 *       apply "entry" to lin-prod.nr-linha in frame {&frame-name}.
 *       return no-apply.
 *   end.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lin-prod.sc-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.sc-ordem V-table-Win
ON F5 OF lin-prod.sc-ordem IN FRAME f-main /* C.Custo Ordem */
DO:
  FIND FIRST param-global NO-LOCK NO-ERROR.
  ASSIGN i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = YES.

    if not valid-handle(h_api_ccusto) then 
        run prgint/utb/utb742za.py persistent set h_api_ccusto.

    run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    if v_cod_ccusto <> "" then
        ASSIGN lin-prod.sc-ordem:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
        
    if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.sc-ordem V-table-Win
ON LEAVE OF lin-prod.sc-ordem IN FRAME f-main /* C.Custo Ordem */
DO:
   {cdp/cdunif001d.i lin-prod.sc-ordem {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lin-prod.sc-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lin-prod.sc-ordem IN FRAME f-main /* C.Custo Ordem */
DO:
  APPLY "F5":U TO SELF.
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

  {utp/ut-rtlbl.i mgind lin-prod sum-requis fi-texto}  

  if lin-prod.cd-planejado:load-mouse-pointer("image~\lupa.cur") then.
  if lin-prod.ct-ordem:load-mouse-pointer("image~\lupa.cur") then.
  if lin-prod.sc-ordem:load-mouse-pointer("image~\lupa.cur") then.
  if lin-prod.cod-estabel:load-mouse-pointer("image~\lupa.cur") then.
  if lin-prod.deposito-pad:load-mouse-pointer("image~\lupa.cur") then.

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
  {src/adm/template/row-list.i "lin-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "lin-prod"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-param-logico V-table-Win 
PROCEDURE check-param-logico :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  run set-fields-sensitive-status-no.

  FOR FIRST param-manuf WHERE 
            param-manuf.cod-entid = "param-cp" AND
            param-manuf.cod-param = "l-usa-param-linha" AND 
            param-manuf.param-logico = yes NO-LOCK:      
                assign l-param-logico = yes.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-rtlbl.i mgind lin-prod sum-requis fi-texto}

  /*Alterado devido a Fo. 1359.916*/
  IF AVAIL param-cp THEN 
    assign lin-prod.ct-ordem:screen-value in frame {&frame-name} = param-cp.ct-ordem
           lin-prod.sc-ordem:screen-value in frame {&frame-name} = param-cp.sc-ordem
           .
  
  /** if (lin-prod.conta-ordem eq "") then do:
     assign  lin-prod.ct-ordem = param-cp.ct-ordem
                        lin-prod.sc-ordem = param-cp.sc-ordem
                        .
     display lin-prod.ct-ordem with frame {&frame-name}
                        lin-prod.sc-ordem with frame {&frame-name}
                        .       
  end.**/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  APPLY "LEAVE" TO lin-prod.ct-ordem IN FRAME {&FRAME-NAME}.
  APPLY "LEAVE" TO lin-prod.sc-ordem IN FRAME {&FRAME-NAME}.

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.    
                
  DEFINE VARIABLE conta-ordem AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE ccusto-ordem AS CHARACTER   NO-UNDO.
  
  ASSIGN conta-ordem = input frame {&frame-name} lin-prod.ct-ordem
         ccusto-ordem = input frame {&frame-name} lin-prod.sc-ordem.
              
    find estabelec where
         estabelec.cod-estabel = input frame {&frame-name} lin-prod.cod-estabel NO-LOCK no-error.
    if available estabelec then     
       assign i-empresa-prin = estabelec.ep-codigo
              c-estab-prin   = estabelec.cod-estabel.
    else
        assign i-empresa-prin = ''.

  /* Ponha aqui a valida‡Æo de chave duplicada */
  find lin-prod 
       where lin-prod.cod-estabel = input frame {&frame-name} lin-prod.cod-estabel
         and lin-prod.nr-linha    = input frame {&frame-name} lin-prod.nr-linha EXCLUSIVE-LOCK no-error.
  if lin-prod.nr-linha:sensitive    in frame {&frame-name} and
     lin-prod.cod-estabel:sensitive in frame {&frame-name} and
     available lin-prod then do:
     {utp/ut-field.i mgind lin-prod nr-linha 1}  
     run utp/ut-msgs.p (input "show",
                        input 1,
                        input return-value).
     apply 'entry' to lin-prod.nr-linha.
     return 'ADM-ERROR':U. 
  end.      
  /* Ponha aqui as demais valida‡äes */  
  /*** Valida‡Æo do estabelecimento da ordem deve ser igual ao 
  **** estabeleciemnto da linha de produ‡Æo FO: 1070.090 *****/
  if ((avail lin-prod) and (lin-prod.sum-requis entered)) then do:
     find first ord-prod where ord-prod.nr-linha = lin-prod.nr-linha and
                ord-prod.cod-estabel             = lin-prod.cod-estabel and
     (ord-prod.estado <> 8 or (ord-prod.estado = 8 and not ord-prod.valorizada))
     no-lock no-error.
     if avail ord-prod then do:
        run utp/ut-msgs.p (input "show",
                           input 105,
                           input "").                    
        apply 'entry' to lin-prod.sum-requis.
        return 'ADM-ERROR':U.
     end.     
  end.    

  if input lin-prod.ct-ordem <> "" AND input lin-prod.ct-ordem <> ? then do:

        /** ORDEM **/
        empty temp-table tt_log_erro.
        if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT i-empresa-prin,
                                                       INPUT "",
                                                       input-output conta-ordem,
                                                       INPUT TODAY,
                                                       output p_des_titulo,
                                                       output v_num_tip_cta_ctbl,
                                                       output v_num_sit_cta_ctbl,
                                                       output v_ind_finalid_cta,
                                                       OUTPUT TABLE tt_log_erro).
                                                                                          
        /** Busca finalidade conforme m¢dulo CEP **/
        RUN pi_busca_dados_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        i-empresa-prin                     ,  /* EMPRESA EMS2          */ 
                                                              INPUT        "CEP"                  ,  /* M…DULO                */
                                                              INPUT        ""                     ,  /* PLANO DE CONTAS       */ 
                                                              INPUT        conta-ordem            ,  /* CONTA                 */ 
                                                              INPUT        TODAY                  ,  /* DATA TRANSACAO        */ 
                                                              OUTPUT       v_ind_finalid_cta      ,  /* FINALIDADES DA CONTA  */
                                                              OUTPUT table tt_log_erro APPEND     ). /* ERROS                 */                                                                                                                                                              
    
        if can-find (first tt_log_erro) then do:
            {cdp/cdunif001b.i1}
            APPLY "entry" TO lin-prod.ct-ordem IN FRAME {&frame-name}.
            if valid-handle(h_api_cta_ctbl) then
                delete object h_api_cta_ctbl.
            RETURN "adm-error".                           
        END.

        assign v_cod_finalid = {adinc/i05ad049.i 4 1} 
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 2}
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 3}
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5}
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 6}.
        run pi_valida_cta_ctbl_integr in h_api_cta_ctbl (INPUT i-empresa-prin,
                                                        INPUT "CEP",
                                                        INPUT "",
                                                        INPUT conta-ordem,
                                                        INPUT v_cod_finalid,
                                                        INPUT TODAY,
                                                        OUTPUT TABLE tt_log_erro).
        if can-find (first tt_log_erro) then do:
            {cdp/cdunif001b.i1}
            APPLY "entry" TO lin-prod.ct-ordem IN FRAME {&frame-name}.
            if valid-handle(h_api_cta_ctbl) then
                delete object h_api_cta_ctbl.
            RETURN "adm-error".                           
        END.

        IF  param-global.modulo-ce = yes THEN DO:    
                        DEFINE VARIABLE v_cod_des_finalidades AS CHARACTER.
                        RUN cdp/cdunif004.p (INPUT "1,2,3,5,6", OUTPUT v_cod_des_finalidades).
                        
                        IF  LOOKUP(STRING(v_ind_finalid_cta),v_cod_des_finalidades) = 0 THEN DO:
                                RUN utp/ut-msgs.p (input "show",
                                                                   input 107,
                                                                   input "").
                                APPLY "entry" TO lin-prod.ct-ordem IN FRAME {&frame-name}.
                                if valid-handle(h_api_cta_ctbl) then
                                    delete object h_api_cta_ctbl.
                                RETURN "adm-error".
                        END.    
                END. 

        if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT i-empresa-prin,
                                                           INPUT "",
                                                           INPUT "",
                                                           INPUT conta-ordem,
                                                           INPUT TODAY,
                                                           OUTPUT p_log_ccusto,
                                                           OUTPUT TABLE tt_log_erro).
                                                           
        if p_log_ccusto then do:
            /** CENTRO DE CUSTO APLICAÇÃO **/
            run pi_busca_dados_ccusto in h_api_ccusto (INPUT i-empresa-prin,
                                                       INPUT "",
                                                       input ccusto-ordem,
                                                       INPUT TODAY,
                                                       output p_des_titulo,
                                                       OUTPUT TABLE tt_log_erro).
            
            if can-find (first tt_log_erro no-lock) then do:
                {cdp/cdunif001b.i1}       
                APPLY "entry" TO lin-prod.sc-ordem IN FRAME {&frame-name}.
                if valid-handle(h_api_cta_ctbl) then
                    delete object h_api_cta_ctbl.
                if valid-handle(h_api_ccusto) then
                    delete object h_api_ccusto.
                RETURN "adm-error".
            end.
        END.

        if valid-handle(h_api_cta_ctbl) then
            delete object h_api_cta_ctbl.
        if valid-handle(h_api_ccusto) then
            delete object h_api_ccusto.

   END. ELSE DO:   
        {utp/ut-field.i mgind lin-prod ct-ordem 1}
        run utp/ut-msgs.p (input "show",
                           input 2,
                           input return-value).
        apply 'entry' to lin-prod.ct-ordem in frame {&frame-name}.
        return 'ADM-ERROR':U.                 
   END.

  if input frame {&frame-name} lin-prod.cod-estabel = "" then do:
     {utp/ut-table.i mgadm estabelec 01}
     run utp/ut-msgs.p (input "show",
                        input 265,
                        input return-value).
     apply 'entry' to lin-prod.cod-estabel in frame {&frame-name}.
     return 'ADM-ERROR':U.  
  end.
  else do:
     if not can-find(first estabelec 
                     where estabelec.cod-estabel = input frame {&frame-name} lin-prod.cod-estabel) then do:
        {utp/ut-table.i mgadm estabelec 01}
        run utp/ut-msgs.p (input "show",
                           input 56,
                           input return-value).
        apply 'entry' to lin-prod.cod-estabel in frame {&frame-name}.
        return 'ADM-ERROR':U.                     
     end.
  end.

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */
  if not can-find(first tt_log_erro) then 
     assign lin-prod.ct-ordem = conta-ordem
            lin-prod.sc-ordem = ccusto-ordem.

  apply 'value-changed' to lin-prod.ct-ordem in frame {&frame-name}.

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

  find first ord-prod
    where ord-prod.nr-linha = input frame {&frame-name} lin-prod.nr-linha
      and ord-prod.cod-estabel = input frame {&frame-name} lin-prod.cod-estabel
    no-lock no-error.
  if  avail ord-prod then do:
      run utp/ut-msgs.p (input "show",
                         input 6756,
                         input "").
      return no-apply.
  end. 

  find first item-uni-estab
     where item-uni-estab.nr-linha = input frame {&FRAME-NAME} lin-prod.nr-linha
       and item-uni-estab.cod-estabel = input frame {&frame-name} lin-prod.cod-estabel
     no-lock no-error.

  if avail item-uni-estab then do:
     run utp/ut-msgs.p (input "show",
                        input 26989,
                        input item-uni-estab.nr-linha).
     return no-apply.
  end.

  find first fam-uni-estab 
     where fam-uni-estab.nr-linha = input frame {&FRAME-NAME} lin-prod.nr-linha
       and fam-uni-estab.cod-estabel = input frame {&frame-name} lin-prod.cod-estabel
     no-lock no-error.

  if avail fam-uni-estab then do:
     run utp/ut-msgs.p (input "show",
                        input 26989,
                        input fam-uni-estab.nr-linha).
     return no-apply.
  end.



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
  {utp/ut-rtlbl.i mgind lin-prod sum-requis fi-texto}

  if avail lin-prod then do:
     find planejad no-lock where 
          planejad.cd-planejado = lin-prod.cd-planejado no-error.
     if avail planejad then 
        assign fi-nome-planejador = planejad.nome.
     else        
        assign fi-nome-planejador = "".

     find estabelec
          where estabelec.cod-estabel = lin-prod.cod-estabel no-lock no-error.
     assign c-desc-estab = if avail estabelec then estabelec.nome else "".  
				   
     find deposito no-lock where
		  deposito.cod-depos = lin-prod.deposito-pad no-error.
            if avail deposito then
        		assign c-desc-depos = deposito.nome.
        	 else 
        		assign c-desc-depos = "".
		
  end.      

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  apply 'value-changed' to lin-prod.ct-ordem in frame {&frame-name}.
        
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
  
  run set-fields-sensitive-status-no.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
    IF INPUT FRAME {&frame-name} lin-prod.ct-ordem <> "" THEN DO:
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT i-empresa-prin,
                                                           INPUT "",
                                                           INPUT "",
                                                           INPUT FRAME {&frame-name} lin-prod.ct-ordem,
                                                           INPUT today,
                                                           OUTPUT p_log_ccusto,
                                                           OUTPUT TABLE tt_log_erro).
                                                                                                           
        ASSIGN lin-prod.sc-ordem:SENSITIVE IN FRAME {&frame-name} = p_log_ccusto.
    END.

    if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.
        
    if l-param-logico then
        run set-fields-sensitive-status-yes.
    else 
        run set-fields-sensitive-status-no.
        
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

  /* Code placed here will execute AFTER standard behavior.    */
  find first param-cp     no-lock no-error.
  find first param-global no-lock no-error.
  if not avail(param-global) then do:
     run utp/ut-msgs.p (input "show",
                        input 16    ,
                        input ""    ).
     apply "close" to this-procedure.                        
     return.
  end.
  else do:
  
        if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

        EMPTY TEMP-TABLE tt_log_erro.
        run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (INPUT "",
                                                           INPUT "",
                                                           INPUT TODAY,
                                                           OUTPUT p_cod_format_cta_ctbl,
                                                           OUTPUT TABLE tt_log_erro).

        if valid-handle(h_api_cta_ctbl) then
            delete object h_api_cta_ctbl.
        if valid-handle(h_api_ccusto) then
            delete object h_api_ccusto.
                                                                                                          
     assign lin-prod.ct-ordem:format in frame {&frame-name} = p_cod_format_cta_ctbl
            l-implanta     = no
            i-empresa-prin = param-global.empresa-prin.
  end.

  assign lin-prod.ct-ordem:format in frame {&frame-name} = 'x(20)'.
  
  run set-fields-sensitive-status-no.
  run check-param-logico.
  
  if l-param-logico then 
        assign c-info-text = "Usa os parƒmetros da linha". 
  else  
        assign c-info-text = "Usa os parƒmetros da produ‡Æo". 

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

  find  planejad no-lock
        where planejad.cd-planejado = input frame {&frame-name} 
        lin-prod.cd-planejado no-error.        
  if avail planejad then 
     assign gr-planejad = rowid(planejad). 

  if avail param-global then do:
     if  param-global.ind-cons-conta = 2 then do:
         find estabelec where
              estabelec.cod-estabel = lin-prod.cod-estabel no-lock no-error.
         if available estabelec then     
            assign i-empresa-prin = estabelec.ep-codigo
                   c-estab-prin   = estabelec.cod-estabel.
     end.  
  end.

  /*find conta-contab where
       conta-contab.ep-codigo      = i-empresa-prin and 
       conta-contab.conta-contabil = input frame {&frame-name} lin-prod.conta-ordem
       no-lock no-error.
  if avail conta-contab then
     assign gr-conta-contab = rowid(conta-contab).*/



  /* Code placed here will execute AFTER standard behavior.    */
  if avail lin-prod then 
     assign gr-lin-prod = rowid(lin-prod) .

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

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "lin-prod"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-fields-sensitive-status-no V-table-Win 
PROCEDURE set-fields-sensitive-status-no :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

  assign lin-prod.deposito-pad:sensitive in frame {&frame-name} = no
         lin-prod.var-req-menor:sensitive = no
         lin-prod.var-rep:sensitive = no
         lin-prod.var-transf:sensitive = no
         lin-prod.var-requis:sensitive = no
         c-desc-depos:sensitive = no.
                 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-fields-sensitive-status-yes V-table-Win 
PROCEDURE set-fields-sensitive-status-yes :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

  assign lin-prod.deposito-pad:sensitive in frame {&frame-name} = yes
         lin-prod.var-req-menor:sensitive = yes
         lin-prod.var-rep:sensitive = yes
         lin-prod.var-transf:sensitive = yes
         lin-prod.var-requis:sensitive = yes.
                 
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


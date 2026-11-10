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
{include/i-prgvrs.i V29IN271 2.00.00.019 } /*** 010019 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v29in271 MUT}
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

def new global shared var v-row-parent as rowid no-undo.                                

{cdp/cdcfgman.i} /* Vari†vel preprocessador bf_man_sfc_lc */ 
{cdp/cdcfgmat.i} /* Vari†vel preprocessador bf_mat_conta_estab */ 

{cpp/cpapi013.i}
{cdp/cd0666.i}
{include/i-epc200.i1}

/** Unificaá∆o de conceito **/
{cdp/cdunif001.i}
{cdp/cdunif001.i1}

def var r-ord          as rowid   no-undo.
def var l-erro-ver     as logical no-undo.
def var c-param-aloc   as char format "x(20)".
def var i-moeda        as integer.
def var i-cont         as integer.
def var i-tmp-moe      as integer.
def var de-acum        like ext-ord.vl-mat-cre-m.
&IF "{&mguni_version}" >= "2.071" &THEN
def var i-empresa-prin LIKE empresa.ep-codigo no-undo.
&ELSE
def var i-empresa-prin as integer no-undo.
&ENDIF
def var h-cpapi013     as handle  no-undo.
def var h-cdapi024     as handle no-undo.
DEFINE VARIABLE h-boin533 AS HANDLE     NO-UNDO.
DEF VAR l-aux          AS logica NO-UNDO.
def var dateUnif       as date no-undo.

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
&Scoped-define EXTERNAL-TABLES ord-prod
&Scoped-define FIRST-EXTERNAL-TABLE ord-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-prod.calc-cs-mat ord-prod.ct-codigo ~
ord-prod.sc-codigo ord-prod.calc-cs-ggf ord-prod.calc-cs-mob ~
ord-prod.reporte-ggf ord-prod.reporte-mob 
&Scoped-define ENABLED-TABLES ord-prod
&Scoped-define FIRST-ENABLED-TABLE ord-prod
&Scoped-Define ENABLED-OBJECTS RECT-12 RECT-13 RECT-14 RECT-6 RECT-7 RECT-9 
&Scoped-Define DISPLAYED-FIELDS ord-prod.calc-cs-mat ord-prod.ct-codigo ~
ord-prod.sc-codigo ord-prod.calc-cs-ggf ord-prod.calc-cs-mob ~
ord-prod.reporte-ggf ord-prod.reporte-mob 
&Scoped-define DISPLAYED-TABLES ord-prod
&Scoped-define FIRST-DISPLAYED-TABLE ord-prod
&Scoped-Define DISPLAYED-OBJECTS l-estado c-texto1 c-texto2 c-texto4 ~
c-texto5 c-texto6 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS ord-prod.calc-cs-mat ord-prod.calc-cs-ggf ~
ord-prod.calc-cs-mob 
&Scoped-define ADM-MODIFY-FIELDS ord-prod.calc-cs-mat ord-prod.calc-cs-ggf ~
ord-prod.calc-cs-mob 

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
DEFINE VARIABLE c-texto1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE c-texto2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE c-texto4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE c-texto5 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE c-texto6 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 3.13.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40.86 BY 1.75.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41.14 BY 1.67.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 1.71.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 1.75.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32.72 BY 3.13.

DEFINE VARIABLE l-estado AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .79 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     l-estado AT ROW 1.5 COL 20.86
     ord-prod.calc-cs-mat AT ROW 1.96 COL 54.86 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Proporcional", 1,
"Total Requisitado", 2
          SIZE 27.72 BY 1.92
     ord-prod.ct-codigo AT ROW 2.33 COL 14.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     ord-prod.sc-codigo AT ROW 3.29 COL 14.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     ord-prod.calc-cs-ggf AT ROW 5.13 COL 4.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Proporcional", 1,
"Total", 2
          SIZE 34 BY 1.25
     ord-prod.calc-cs-mob AT ROW 5.38 COL 46.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Proporcional", 1,
"Total", 2
          SIZE 34 BY 1
     ord-prod.reporte-ggf AT ROW 7.63 COL 4.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Real", 1,
"Padr∆o", 2
          SIZE 37 BY .83
     ord-prod.reporte-mob AT ROW 7.75 COL 46.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Real", 1,
"Padr∆o", 2
          SIZE 37 BY .83
     c-texto1 AT ROW 1 COL 50.72 COLON-ALIGNED NO-LABEL
     c-texto2 AT ROW 4.5 COL 3 NO-LABEL
     c-texto4 AT ROW 4.63 COL 42.57 COLON-ALIGNED NO-LABEL
     c-texto5 AT ROW 6.79 COL 42.86 COLON-ALIGNED NO-LABEL
     c-texto6 AT ROW 6.83 COL 2.29 COLON-ALIGNED NO-LABEL
     RECT-12 AT ROW 1.25 COL 2
     RECT-13 AT ROW 7.04 COL 1.57
     RECT-14 AT ROW 7.08 COL 43.57
     RECT-6 AT ROW 4.88 COL 43.57
     RECT-7 AT ROW 4.88 COL 1.57
     RECT-9 AT ROW 1.25 COL 51.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-prod
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         WIDTH              = 84.72.
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

/* SETTINGS FOR FILL-IN c-texto1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto2 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-texto4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto6 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET ord-prod.calc-cs-ggf IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR RADIO-SET ord-prod.calc-cs-mat IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR RADIO-SET ord-prod.calc-cs-mob IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR TOGGLE-BOX l-estado IN FRAME f-main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ord-prod.calc-cs-ggf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.calc-cs-ggf V-table-Win
ON VALUE-CHANGED OF ord-prod.calc-cs-ggf IN FRAME f-main /* Calc Custo GGF */
DO:
  run pi-atualiza-estado.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-prod.calc-cs-mat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.calc-cs-mat V-table-Win
ON VALUE-CHANGED OF ord-prod.calc-cs-mat IN FRAME f-main /* Calc Custo Mat */
DO:
  run  pi-atualiza-estado .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-prod.calc-cs-mob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.calc-cs-mob V-table-Win
ON VALUE-CHANGED OF ord-prod.calc-cs-mob IN FRAME f-main /* Calc Custo MOB */
DO:
  run pi-atualiza-estado .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-prod.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.ct-codigo V-table-Win
ON ENTRY OF ord-prod.ct-codigo IN FRAME f-main /* Conta Ordem */
DO:
        ASSIGN ord-prod.ct-codigo:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.ct-codigo V-table-Win
ON F5 OF ord-prod.ct-codigo IN FRAME f-main /* Conta Ordem */
DO:
    assign i-ep-codigo-usuario = i-empresa-prin.
    assign l-implanta = yes.

    if not valid-handle(h_api_cta_ctbl) then 
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.    
        
    assign v_cod_finalid = {adinc/i05ad049.i 4 1} 
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 2}
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 3}
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5}
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 6}. 
        
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT i-empresa-prin,
                                                   INPUT "CEP",
                                                   INPUT "",
                                                   INPUT v_cod_finalid,
                                                   INPUT ord-prod.dt-emissao,
                                                   OUTPUT v_cod_cta_ctbl,
                                                   OUTPUT v_des_cta_ctbl,
                                                   OUTPUT p-finalidade,
                                                   OUTPUT TABLE tt_log_erro).
    
    {cdp/cdunif001b.i1}
        
    IF v_cod_cta_ctbl <> "" THEN
        ASSIGN ord-prod.ct-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.
        
    if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.ct-codigo V-table-Win
ON LEAVE OF ord-prod.ct-codigo IN FRAME f-main /* Conta Ordem */
DO:
    assign dateUnif = if avail ord-prod then ord-prod.dt-emissao else today.
   
    {cdp/cdunif001a.i ord-prod.ct-codigo ord-prod.sc-codigo {&FRAME-NAME} dateUnif i-empresa-prin ord-prod.cod-estabel}
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ord-prod.ct-codigo IN FRAME f-main /* Conta Ordem */
DO:
  apply "F5" to ord-prod.ct-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-prod.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.sc-codigo V-table-Win
ON F5 OF ord-prod.sc-codigo IN FRAME f-main /* Sub-Conta */
DO:
  assign i-ep-codigo-usuario = i-empresa-prin.
  assign l-implanta = yes.
  
    if not valid-handle(h_api_ccusto) then 
        run prgint/utb/utb742za.py persistent set h_api_ccusto.
    
    run pi_zoom_ccusto in h_api_ccusto (INPUT i-empresa-prin,
                                        INPUT "",
                                        INPUT ord-prod.cod-unid-negoc,
                                        INPUT ord-prod.dt-emissao,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    if v_cod_ccusto <> "" then
        ASSIGN ord-prod.sc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
        
    if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.     
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.sc-codigo V-table-Win
ON LEAVE OF ord-prod.sc-codigo IN FRAME f-main /* Sub-Conta */
DO:
   {cdp/cdunif001d.i ord-prod.sc-codigo {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.sc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ord-prod.sc-codigo IN FRAME f-main /* Sub-Conta */
DO:
  apply "F5" to ord-prod.sc-codigo.
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

if ord-prod.ct-codigo:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if ord-prod.sc-codigo:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

{utp/ut-rtlbl.i mgind ord-prod calc-cs-mat c-texto1}
{utp/ut-rtlbl.i mgind ord-prod calc-cs-ggf c-texto2}
{utp/ut-rtlbl.i mgind ord-prod calc-cs-mob c-texto4}

{utp/ut-rtlbl.i mgind ord-prod reporte-mob c-texto5}
{utp/ut-rtlbl.i mgind ord-prod reporte-ggf c-texto6}
{utp/ut-rdset.i ord-prod.calc-cs-mat}

{utp/ut-liter.i Ordem_Terminada * r}
assign l-estado:label in frame {&frame-name} = trim(return-value).

find first param-global no-lock.
find first param-estoq no-lock no-error.
find first param-cp no-lock.

&IF DEFINED (bf_man_sfc_lc) &THEN
    {inbo/boin536.i4} /* Fechar Operacao */
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
  {src/adm/template/row-list.i "ord-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-prod"}

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

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
       RETURN 'ADM-ERROR':U.

    /* Code placed here will execute AFTER standard behavior.    */
        
        apply "leave":U to ord-prod.ct-codigo in frame {&frame-name}.

    assign r-ord = rowid(ord-prod).
    find first ord-prod where 
         rowid(ord-prod) = r-ord  exclusive-lock no-error.

    do  with frame {&frame-name}:
        assign l-estado.
        if  l-estado and not(ord-prod.estado = 8)  then do:
            &IF DEFINED (bf_man_linha_estab) &THEN
            find first lin-prod
                where lin-prod.cod-estabel = ord-prod.cod-estabel
                  and lin-prod.nr-linha    = ord-prod.nr-linha
                no-lock no-error.
            &ELSE
            find first lin-prod
                where lin-prod.nr-linha = ord-prod.nr-linha
                no-lock no-error.            
            &ENDIF
            if  available(lin-prod) then
            if  lin-prod.sum-requis = 2 and param-cp.ver-req then do:
                run cpp/cp0311g.p (input rowid(ord-prod),
                                   output l-erro-ver,
                                   input "2", 
                                   input ord-prod.qt-reportada,
                                   input l-estado,
                                   input yes).
                if  l-erro-ver then
            end.

            for each reservas
                where reservas.nr-ord-produ = ord-prod.nr-ord-produ EXCLUSIVE-LOCK:
                run cdp/cd7000.p (input 0,
                                  input reservas.it-codigo,
                                  input ord-prod.cod-estabel).

                if not valid-handle (h-cpapi013) then
                    run cpp/cpapi013.p persistent set h-cpapi013 (input        table tt-alocacao,
                                                                  input        table tt-deposito,
                                                                  input-output table tt-erro,
                                                                  input        yes).

                run pi-desaloca-reserva in h-cpapi013 (input rowid(reservas)).

                assign reservas.estado = 2.
            end.


            assign ord-prod.estado = 8
                   ord-prod.valorizada = no
                   &IF DEFINED (bf_man_sfc_lc) &THEN
                    ord-prod.dt-efetiv-term =  TODAY
                    ord-prod.hr-efetiv-term =  STRING(TIME,"HH:MM:SS")                    
                   &endif.


            for each  oper-ord
                where oper-ord.nr-ord-prod = ord-prod.nr-ord-produ exclusive-lock:
                assign oper-ord.estado = 3.
            end.

            if  ord-prod.rep-prod NE 4 then do:
                &IF DEFINED (bf_man_sfc_lc) &THEN
                RUN inbo/boin533.p PERSISTENT SET h-boin533.
                if valid-handle (h-boin533) and
                   h-boin533:TYPE = "PROCEDURE":U and
                   h-boin533:FILE-NAME = "inbo/boin533.p":U then DO:
                   run alterarOrdemSFC in h-boin533 (buffer ord-prod).
                END.
                DELETE PROCEDURE h-boin533 NO-ERROR.
                &ENDIF
            END.
            RUN cdp/cd7000.p(INPUT 0, 
                             input ORD-PROD.IT-CODIGO,
                             input ORD-PROD.COD-ESTABEL).
        end.     
        if  not l-estado and ord-prod.estado = 8 then do:

            &IF DEFINED (bf_man_per_ppm) &THEN
                /** As ordens que possuem reservas em que o tipo de formulaá∆o 
                    do seu item foi alterado n∆o podem ser reabertas **/
                if param-global.modulo-per-ppm then
                    for first reservas no-lock where
                              reservas.nr-ord-produ = ord-prod.nr-ord-produ,
                        first item no-lock where
                              item.it-codigo     = reservas.it-codigo and
                              item.tipo-formula <> reservas.tipo-formula:
                        run utp/ut-msgs.p (input "show",
                                           input 27897,
                                           input string (ord-prod.nr-ord-produ) 
                                                 + "~~" + reservas.it-codigo).
                        return 'adm-error':u.
                    end.
            &ENDIF

            assign ord-prod.estado = 6
                   &IF DEFINED (bf_man_sfc_lc) &THEN
                     ord-prod.dt-efetiv-term =  date("")
                     ord-prod.hr-efetiv-term =  ""
                   &endif.                                   


            for each reservas use-index codigo
                where reservas.nr-ord-produ = ord-prod.nr-ord-produ EXCLUSIVE-LOCK:
                if  reservas.origem = 1 then do:
                    assign reservas.estado = 1.
                    run cdp/cd7000.p (0,
                                      reservas.it-codigo,
                                      ord-prod.cod-estabel).
                end.
            end.

            for each  oper-ord
                where oper-ord.nr-ord-prod = ord-prod.nr-ord-produ exclusive-lock:
                assign oper-ord.estado = 2.
            end.
            if  ord-prod.rep-prod NE 4 then do:
                &IF DEFINED (bf_man_sfc_lc) &THEN
                RUN inbo/boin533.p PERSISTENT SET h-boin533.
                run alterarOrdemSFC in h-boin533 (buffer ord-prod).
                for each  oper-ord
                    where oper-ord.nr-ord-prod = ord-prod.nr-ord-produ exclusive-lock:
                    RUN ReabrirOperacao (BUFFER oper-ord).
                end.                   
                DELETE PROCEDURE h-boin533.
                FOR EACH split-operac WHERE
                    split-operac.nr-ord-produ = oper-ord.nr-ord-produ EXCLUSIVE-LOCK:
                    ASSIGN split-operac.ind-estado-split = 4.
                END.
                &ENDIF
            END.

            if avail ord-manut then
               assign ord-prod.qt-reportada = 0
                      ord-prod.estado       = 6
                      ord-prod.qt-produzida = 0
                      ord-prod.calc-cs-mat  = 2.
        end.
        run cdp/cd7000.p (0,
                          ord-prod.it-codigo,
                          ord-prod.cod-estabel).

    end.
    if param-cp.log-integr-ppi-mes then do:
         run cpp/cpapi301b.p ( input rowid(ord-prod),
                               input ord-prod.nr-ord-prod, 
                               input 2).
         if return-value = "NOK" then do:
             {utp/ut-liter.i Ordem_de_produá∆o *}
             run utp/ut-msgs.p (input "show",
                                input 54436,
                                input RETURN-VALUE).
         end.                              
    end.


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

  &IF DEFINED(bf_man_206b) &THEN
    IF VALID-HANDLE(h-cdapi024) THEN DO:
        RUN pi-finalizar IN h-cdapi024.
        ASSIGN h-cdapi024 = ?.
    end.
&ENDIF

  if valid-handle (h-cpapi013) then
    run pi-finalizar in h-cpapi013.    

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
  disable all with frame {&frame-name}.
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

    ASSIGN ord-prod.ct-codigo:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    find first estabelec where estabelec.cod-estabel = ord-prod.cod-estabel no-lock no-error.
    if avail estabelec then
        assign i-empresa-prin = estabelec.ep-codigo.

    apply "leave":U to ord-prod.ct-codigo in frame {&frame-name}.
    
    if avail(ord-prod) then do :  
            assign l-estado = (ord-prod.estado = 8).
            disp l-estado with frame {&frame-name}.
            ASSIGN l-aux = l-estado.
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

  def var c-handle as char no-undo.

  run get-attribute ('adm-new-record').

  if avail(ord-prod) then do :  
     find ord-manut where 
          ord-manut.nr-ord-prod = ord-prod.nr-ord-prod
          no-lock no-error.
     if avail(ord-manut) then do :
        run utp/ut-msgs.p (input "show",
                           input 1203  ,
                           input ""    ).
        RUN Who-Is-The-Container IN adm-broker-hdl
                        (INPUT this-procedure,
                         OUTPUT c-handle).
        run pi-cancelar in widget-handle(c-handle).
        return "adm-error":u.
     end.                      

     IF ord-prod.origem = "MV":U THEN DO:
        run utp/ut-msgs.p (input "show",
                           input 29505 ,
                           input ""    ).
        RUN Who-Is-The-Container IN adm-broker-hdl
                        (INPUT this-procedure,
                         OUTPUT c-handle).
        run pi-cancelar in widget-handle(c-handle).
        return "adm-error":u.
     END.

     if l-estado = yes and ord-prod.valorizada = yes then do:
        run utp/ut-msgs.p (input "show",
                          input 27400,
                          input "").

        RUN Who-Is-The-Container IN adm-broker-hdl
                        (INPUT this-procedure,
                         OUTPUT c-handle).
        run pi-cancelar in widget-handle(c-handle).
        return 'adm-error':u.

     end.   

  end.   

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if param-global.modulo-mi = yes then
    find first ord-manut
         where ord-manut.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK no-error. 

  &IF DEFINED (bf_man_linha_estab) &THEN
  find first lin-prod
       where lin-prod.cod-estabel = ord-prod.cod-estabel
         and lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.  
  &ELSE
  find first lin-prod
       where lin-prod.nr-linha = ord-prod.nr-linha no-lock no-error.  
  &ENDIF

  if l-estado = yes and ord-prod.valorizada = yes then do:
     disable l-estado with frame {&frame-name}.
     disable ord-prod.calc-cs-mat with frame {&frame-name}.
     disable ord-prod.calc-cs-mob with frame {&frame-name}.
     disable ord-prod.calc-cs-ggf with frame {&frame-name}.
/*     assign ord-prod.reporte-ggf:sensitive in frame {&frame-name} = no
            ord-prod.reporte-mob:sensitive in frame {&frame-name} = no.  
     run utp/ut-msgs.p (input "show",
                        input 27400,
                        input "").*/
  end.   
  else
    enable l-estado with frame {&frame-name}.

  if avail lin-prod then   
     if avail ord-manut or lin-prod.sum-requis = 1 then do:
        disable ord-prod.calc-cs-mat with frame {&frame-name}.
        disable ord-prod.calc-cs-mob with frame {&frame-name}.
        disable ord-prod.calc-cs-ggf with frame {&frame-name}.
     end.

  run notify ('pi-atualiza-estado, group-assign-target').

  /* verifica se a ordem j† possui saldo */
  if avail param-estoq then do:

     do i-moeda = 1 to 3:
        assign i-tmp-moe = if i-moeda = 1 then 0                   
                              else if i-moeda = 2 then param-estoq.moeda1
                              else param-estoq.moeda2.

        for each ext-ord use-index ordem where 
                 ext-ord.nr-ord-prod = ord-prod.nr-ord-produ and
                 ext-ord.mo-codigo = i-tmp-moe no-lock:
           /* Material */
           if (ext-ord.vl-mat-deb-m   + ext-ord.vl-mat-cre-m   +
               ext-ord.vl-mat-deb-p   + ext-ord.vl-mat-cre-p   +
               ext-ord.vl-mat-deb-o   + ext-ord.vl-mat-cre-o) <> 0 then
           disable ord-prod.calc-cs-mat with frame {&frame-name}.

           /* M∆o-de-Obra Direta do Acabado */
           if (ext-ord.vl-mob-deb-m   + ext-ord.vl-mb-db-mes-m  +
               ext-ord.vl-mob-cre-m   + ext-ord.vl-mob-cre-m    +
               ext-ord.vl-mob-deb-p   + ext-ord.vl-mb-db-mes-p  +
               ext-ord.vl-mob-cre-p   + ext-ord.vl-mob-cre-p    +
               ext-ord.vl-mob-deb-o   + ext-ord.vl-mb-db-mes-o  +
               ext-ord.vl-mob-cre-o   + ext-ord.vl-mob-cre-o) <> 0  then
           disable ord-prod.calc-cs-mob with frame {&frame-name}.

           /* M∆o-de-Obra Direta do Componente */
           if (ext-ord.vl-mob-db-c-m  + ext-ord.vl-mob-cr-c-m   +
               ext-ord.vl-mob-db-c-p  + ext-ord.vl-mob-cr-c-p   +
               ext-ord.vl-mob-db-c-o  + ext-ord.vl-mob-cr-c-o) <> 0 then
           disable ord-prod.calc-cs-mob with frame {&frame-name}.

           /* Valor GGF do Componente */
           if (ext-ord.vl-ggf-db-c-m  + ext-ord.vl-ggf-cr-c-m +
               ext-ord.vl-ggf-db-c-p  + ext-ord.vl-ggf-cr-c-p +
               ext-ord.vl-ggf-db-c-o  + ext-ord.vl-ggf-cr-c-o) <> 0 then
           disable ord-prod.calc-cs-ggf with frame {&frame-name}.

           /* Valor GGF do Acabado */
           assign de-acum = 0.
           do i-cont = 1 to 6:
              assign de-acum = de-acum + ext-ord.vl-ggf-deb-m[i-cont] 
                                       + ext-ord.vl-ggf-deb-p[i-cont] 
                                       + ext-ord.vl-ggf-deb-o[i-cont] 
                                       + ext-ord.vl-ggf-cre-m[i-cont] 
                                       + ext-ord.vl-ggf-cre-p[i-cont]
                                       + ext-ord.vl-ggf-cre-o[i-cont].
           end.

           if de-acum <> 0 then    
              disable ord-prod.calc-cs-ggf with frame {&frame-name}.
        end.
     end. 
  end.

  if ord-prod.estado <> 1 then
    disable ord-prod.ct-codigo ord-prod.sc-codigo with frame {&frame-name}      .
        
        
        if ord-prod.ct-codigo:sensitive in frame {&frame-name} then do:
                apply "entry":U to ord-prod.ct-codigo in frame {&frame-name}.
        end.

 /*RUN notify IN THIS-PROCEDURE ('pi-atualiza,atualiza-target':U).*/

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

    assign i-empresa-prin = param-global.empresa-prin.
    &IF DEFINED (bf_mat_conta_estab) &THEN
        if avail ord-prod then do:
            find first estabelec
                 where estabelec.cod-estabel = ord-prod.cod-estabel no-lock no-error.
            if avail estabelec then
               run cdp/cd9970.p (input rowid(estabelec),
                                 output i-empresa-prin).
        end.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-estado V-table-Win 
PROCEDURE pi-atualiza-estado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
find ord-manut where ord-manut.nr-ord-produ = ord-prod.nr-ord-produ no-lock no-error.

assign ord-prod.reporte-ggf:sensitive in frame {&frame-name} = not avail ord-manut
       ord-prod.reporte-mob:sensitive in frame {&frame-name} = not avail ord-manut.     



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

  def var l-unid-neg as log    no-undo.
  def var c-conta    as char   no-undo.

  {utp/ut-liter.i atualizaá∆o * r}
  run utp/ut-msgs.p (input "show",
                     input 701,
                     input trim(return-value)).
  if return-value = "no" then return 'adm-error'.

  if ord-prod.ct-codigo:sensitive in frame {&frame-name} = yes then do:
  
    /* Retorna Dados da Conta. */
    if not valid-handle(h_api_cta_ctbl) then 
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.    

    assign c-conta = input frame {&frame-name} ord-prod.ct-codigo.
    {cdp/cdunif001c.i i-empresa-prin c-conta ord-prod.dt-emissao}

    if can-find(first tt_log_erro) then do:
      {cdp/cdunif001b.i1}
      apply "entry" to ord-prod.ct-codigo.
      return 'adm-error'.
    end.

    if v_num_sit_cta_ctbl <> 3 then do:
      run utp/ut-msgs.p (input "show",
                         input 638,
                         input ord-prod.ct-codigo:screen-value).
      apply "entry" to ord-prod.ct-codigo.
      return 'adm-error'.
    end.
    if v_num_tip_cta_ctbl <> 4 and v_num_tip_cta_ctbl <> 5 then do:
      run utp/ut-msgs.p (input "show",
                         input 638,
                         input ord-prod.ct-codigo:screen-value).
      apply "entry" to ord-prod.ct-codigo.
      return 'adm-error'.
    end.
    if param-global.modulo-ce = YES then do : 

        DEFINE VARIABLE v_cod_des_finalidades AS CHARACTER.
        RUN cdp/cdunif004.p (INPUT "1,2,3,5,6", OUTPUT v_cod_des_finalidades).
        if lookup(string(v_ind_finalid_cta),v_cod_des_finalidades)= 0 then do: 
               run utp/ut-msgs.p (input "show",
                         input 1884,
                         input ord-prod.ct-codigo:screen-value).
               apply "entry" to ord-prod.ct-codigo.
               return 'adm-error'.
            end.
         end.                  

    /* Validaá∆o Unidade de Neg¢cio */
    &if "{&mguni_version}" >= "2.06b" &then                                 

        if can-find(first funcao where funcao.cd-funcao = "ems2-unidade-negocio" and
                                       funcao.ativo     = yes) then do:
                                               
            &if "{&mguni_version}" <= "2.07a" &then
                assign l-unid-neg = substring(param-global.char-2,31,1) = "2".
            &else
                assign l-unid-neg = param-global.log-validac-ems5.
            &endif
            
            if l-unid-neg then do:                
                        
                if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.    
                run pi_valida_conta_contabil in h_api_cta_ctbl (input  i-empresa-prin,          /* EMPRESA EMS2 */
                                                                input  ord-prod.cod-estabel,    /* ESTABELECIMENTO EMS2 */
                                                                input  ord-prod.cod-unid-negoc, /* UNIDADE NEGÖCIO */
                                                                input  "",                                      /* PLANO CONTAS */ 
                                                                input  ord-prod.ct-codigo:screen-value,     /* CONTA */
                                                                input  "",                                      /* PLANO CCUSTO */ 
                                                                input  ord-prod.sc-codigo:screen-value,     /* CCUSTO */
                                                                input  ord-prod.dt-inicio,      /* DATA TRANSACAO */
                                                                output table tt_log_erro append). /* ERROS */
                                                                                                        
                if can-find(first tt_log_erro) then do:

                    for each tt_log_erro no-lock:

                        assign tt_log_erro.ttv_des_msg_erro = replace(tt_log_erro.ttv_des_msg_erro,"|","~~").

                        run utp/ut-msgs.p (input "show",
                                           input tt_log_erro.ttv_num_cod_erro,
                                           input tt_log_erro.ttv_des_msg_erro).

                        apply "entry" to ord-prod.ct-codigo.
                        return error.
                        
                    end.
                end.
            end.
        end. 

    &endif
    /* Fim Validaá∆o Unidade de Neg¢cio */

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
  {src/adm/template/snd-list.i "ord-prod"}

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


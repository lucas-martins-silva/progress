&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V24IN271 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v24in271 MUT}
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
def new global shared var gr-ord-prod  as rowid no-undo.                               
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var de-vl-mat-o1   as decimal no-undo.
def var de-vl-mob-o1   as decimal no-undo.
def var de-vl-ggf-o1   as decimal no-undo.
def var de-vl-mat-m1   as decimal no-undo.
def var de-vl-mob-m1   as decimal no-undo.
def var de-vl-ggf-m1   as decimal no-undo.
def var de-vl-mat-p1   as decimal no-undo.
def var de-vl-mob-p1   as decimal no-undo.
def var de-vl-ggf-p1   as decimal no-undo.
def var de-vl-mat-o2   as decimal no-undo.
def var de-vl-mob-o2   as decimal no-undo.
def var de-vl-ggf-o2   as decimal no-undo.
def var de-vl-mat-m2   as decimal no-undo.
def var de-vl-mob-m2   as decimal no-undo.
def var de-vl-ggf-m2   as decimal no-undo.
def var de-vl-mat-p2   as decimal no-undo.
def var de-vl-mob-p2   as decimal no-undo.
def var de-vl-ggf-p2   as decimal no-undo.
def var de-vl-mat-o3   as decimal no-undo.
def var de-vl-mob-o3   as decimal no-undo.
def var de-vl-ggf-o3   as decimal no-undo.
def var de-vl-mat-m3   as decimal no-undo.
def var de-vl-mob-m3   as decimal no-undo.
def var de-vl-ggf-m3   as decimal no-undo.
def var de-vl-mat-p3   as decimal no-undo.
def var de-vl-mob-p3   as decimal no-undo.
def var de-vl-ggf-p3   as decimal no-undo.

def var de-saldo-ext-ord as decimal no-undo.
def var c-conta-db     like movto-estoq.ct-codigo no-undo.
def var c-ccusto-db     like movto-estoq.sc-codigo no-undo.

&IF "{&mguni_version}" >= "2.071" &THEN
def var i-empresa-prin LIKE empresa.ep-codigo no-undo.
&ELSE
def var i-empresa-prin as integer no-undo.
&ENDIF

def var h-acomp as handle no-undo.

{cdp/cd0666.i}
{cep/ceapi001.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgman.i}

/** Unifica‡Æo de Conceito **/
{cdp/cdunif001.i}
{cdp/cdunif001.i1}

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
&Scoped-Define ENABLED-FIELDS ord-prod.nr-ord-produ 
&Scoped-define ENABLED-TABLES ord-prod
&Scoped-define FIRST-ENABLED-TABLE ord-prod
&Scoped-Define ENABLED-OBJECTS rt-key RECT-5 rt-mold 
&Scoped-Define DISPLAYED-FIELDS ord-prod.nr-ord-produ 
&Scoped-define DISPLAYED-TABLES ord-prod
&Scoped-define FIRST-DISPLAYED-TABLE ord-prod
&Scoped-Define DISPLAYED-OBJECTS rs-tp-oper c-conta-contab fi-ccusto ~
da-impl-saldo c-liter-transacao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS rs-tp-oper c-conta-contab fi-ccusto ~
da-impl-saldo 
&Scoped-define ADM-MODIFY-FIELDS rs-tp-oper c-conta-contab fi-ccusto ~
da-impl-saldo 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD retorna-valor V-table-Win 
FUNCTION retorna-valor RETURNS DECIMAL
  ( input c-campo as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-conta-contab AS CHARACTER FORMAT "X(17)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-liter-transacao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE da-impl-saldo AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ccusto AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE rs-tp-oper AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Implanta", 1,
"Estorna", 2
     SIZE 33 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 1.5.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-prod.nr-ord-produ AT ROW 2 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     rs-tp-oper AT ROW 2 COL 52 NO-LABEL
     c-conta-contab AT ROW 3.83 COL 16 COLON-ALIGNED
     fi-ccusto AT ROW 3.83 COL 36.29 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     da-impl-saldo AT ROW 3.83 COL 72 COLON-ALIGNED
     c-liter-transacao AT ROW 1.25 COL 47 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     RECT-5 AT ROW 1.5 COL 48
     rt-mold AT ROW 3.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ord-prod
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
         HEIGHT             = 4.13
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

/* SETTINGS FOR FILL-IN c-conta-contab IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-liter-transacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-impl-saldo IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-ccusto IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR RADIO-SET rs-tp-oper IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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

&Scoped-define SELF-NAME c-conta-contab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-contab V-table-Win
ON ENTRY OF c-conta-contab IN FRAME f-main
DO:
  ASSIGN c-conta-contab:FORMAT IN FRAME {&frame-name} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-contab V-table-Win
ON F5 OF c-conta-contab IN FRAME f-main
DO:
    /* TODO ver com mario questao da ordem */
    find first param-global no-lock no-error.
    assign i-empresa-prin = param-global.empresa-prin.
    &IF DEFINED (bf_mat_conta_estab) &THEN
        find first ord-prod 
             where ord-prod.nr-ord-prod = input frame {&frame-name} ord-prod.nr-ord-prod no-lock no-error.
        if avail ord-prod then do:  
           find first estabelec
                where estabelec.cod-estabel = ord-prod.cod-estabel no-lock no-error.
           if avail estabelec then 
              run cdp/cd9970.p (input rowid(estabelec),
                               output i-empresa-prin).
        end.                     
    &ENDIF
        
    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
	
    assign v_cod_finalid = {adinc/i05ad049.i 4 1} 
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 2}
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 3}
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5}
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 6}. 

    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT "",
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
		ASSIGN c-conta-contab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-contab V-table-Win
ON LEAVE OF c-conta-contab IN FRAME f-main
DO:
    find first param-global no-lock no-error.
    assign i-empresa-prin = param-global.empresa-prin.
    
	find first ord-prod 
		 where ord-prod.nr-ord-prod = input frame {&frame-name} ord-prod.nr-ord-prod no-lock no-error.
	if avail ord-prod then do:  
        find first estabelec
            where estabelec.cod-estabel = ord-prod.cod-estabel no-lock no-error.
        if avail estabelec then 
          run cdp/cd9970.p (input rowid(estabelec),
                           output i-empresa-prin).

        {cdp/cdunif001a.i c-conta-contab fi-ccusto {&FRAME-NAME} TODAY i-empresa-prin ord-prod.cod-estabel}
	end.
	else do:
		{cdp/cdunif001a.i c-conta-contab fi-ccusto {&FRAME-NAME} TODAY """" """"}
	end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto wWindow
ON LEAVE OF fi-ccusto IN FRAME f-main
DO:
   {cdp/cdunif001d.i fi-ccusto {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-contab V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta-contab IN FRAME f-main
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto V-table-Win
ON F5 OF fi-ccusto IN FRAME f-main
DO:
    assign i-empresa-prin = param-global.empresa-prin.
    &IF DEFINED (bf_mat_conta_estab) &THEN
        find first ord-prod 
             where ord-prod.nr-ord-prod = input frame {&frame-name} ord-prod.nr-ord-prod no-lock no-error.
        if avail ord-prod then do:  
           find first estabelec
                where estabelec.cod-estabel = ord-prod.cod-estabel no-lock no-error.
           if avail estabelec then 
              run cdp/cd9970.p (input rowid(estabelec),
                               output i-empresa-prin).
        end.                     
    &ENDIF

    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
    run pi_zoom_ccusto in h_api_ccusto (INPUT i-empresa-prin,
                                    INPUT "",
                                    INPUT "",
                                    INPUT today,
                                    OUTPUT v_cod_ccusto,
                                    OUTPUT v_des_ccusto,
                                    OUTPUT TABLE tt_log_erro).
    
    {cdp/cdunif001b.i1}

    if v_cod_ccusto <> "" then
        ASSIGN fi-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-ccusto IN FRAME f-main
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tp-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tp-oper V-table-Win
ON VALUE-CHANGED OF rs-tp-oper IN FRAME f-main
DO:
    assign input frame {&frame-name} rs-tp-oper.
    if  rs-tp-oper = 1 then do:
        assign da-impl-saldo = today.
        disp da-impl-saldo with frame {&frame-name}.
        enable c-conta-contab
               da-impl-saldo
               with frame {&frame-name}.
        apply "leave" to c-conta-contab in frame {&frame-name}.
        run notify ("pi-enable,group-assign-target").
    end.
    else do:
         disp "" @ c-conta-contab
              "" @ fi-ccusto
              "" @ da-impl-saldo            
              with frame {&frame-name}. 
         enable c-conta-contab
               da-impl-saldo
               with frame {&frame-name}.        
         apply "leave" to c-conta-contab in frame {&frame-name}.
         run notify ("pi-disable,group-assign-target").
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

    EMPTY TEMP-TABLE tt_log_erro.
    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (INPUT "",
                                                       INPUT "",
                                                       INPUT TODAY,
                                                       OUTPUT p_cod_format_cta_ctbl,
                                                       OUTPUT TABLE tt_log_erro).
												   

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

  find first param-global no-lock no-error.

  if c-conta-contab:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if fi-ccusto     :load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

  {utp/ut-liter.i Transa‡Æo * r}
  assign c-liter-transacao = return-value.

  disp c-liter-transacao with frame {&frame-name}.
  {utp/ut-rdset.i rs-tp-oper *}
  {utp/ut-liter.i Dt_Implant_Saldo * l}
  assign da-impl-saldo:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Conta_Implant * l}
  assign c-conta-contab:label in frame {&frame-name} = return-value.

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
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  run utp/ut-acomp.p persistent set h-acomp.

  {utp/ut-liter.i Implanta‡Æo_de_Saldos * r}
  run pi-inicializar in h-acomp (input return-value).
  {utp/ut-liter.i Gerando_movimenta‡Æo_de_estoque... *}
  run pi-acompanhar in h-acomp (input  Return-value ).

  for each tt-erro:
      delete tt-erro.
  end.

  for each tt-movto:
      delete tt-movto.
  end.

  case input frame {&frame-name} rs-tp-oper:
       when 1 then do:
            create tt-movto.
            assign tt-movto.cod-versao-integracao = 1
                   tt-movto.cod-prog-orig         = "cs0105"
                   tt-movto.cod-estabel           = ord-prod.cod-estabel
                   tt-movto.cod-depos             = item.deposito-pad
                   tt-movto.cod-localiz           = item.cod-localiz
                   tt-movto.it-codigo             = ""
                   tt-movto.tipo-trans            = 2
                   tt-movto.tipo-valor            = 1
                   tt-movto.esp-docto             = 4 /* DD */
                   tt-movto.serie-docto           = "imp"
                   tt-movto.nr-ord-prod           = ord-prod.nr-ord-prod
                   tt-movto.dt-trans              = da-impl-saldo
                   tt-movto.ct-codigo             = ord-prod.ct-codigo
                   tt-movto.sc-codigo             = ord-prod.sc-codigo
                   tt-movto.ct-db                 = c-conta-contab
                   tt-movto.sc-db                 = fi-ccusto
                   tt-movto.valor-mat-m[1]        = de-vl-mat-m1
                   tt-movto.valor-mat-m[2]        = de-vl-mat-m2
                   tt-movto.valor-mat-m[3]        = de-vl-mat-m3
                   tt-movto.valor-mat-o[1]        = de-vl-mat-o1
                   tt-movto.valor-mat-o[2]        = de-vl-mat-o2
                   tt-movto.valor-mat-o[3]        = de-vl-mat-o3
                   tt-movto.valor-mat-p[1]        = de-vl-mat-p1
                   tt-movto.valor-mat-p[2]        = de-vl-mat-p2
                   tt-movto.valor-mat-p[3]        = de-vl-mat-p3              
                   tt-movto.valor-mob-m[1]        = de-vl-mob-m1
                   tt-movto.valor-mob-m[2]        = de-vl-mob-m2
                   tt-movto.valor-mob-m[3]        = de-vl-mob-m3
                   tt-movto.valor-mob-o[1]        = de-vl-mob-o1
                   tt-movto.valor-mob-o[2]        = de-vl-mob-o2
                   tt-movto.valor-mob-o[3]        = de-vl-mob-o3
                   tt-movto.valor-mob-p[1]        = de-vl-mob-p1
                   tt-movto.valor-mob-p[2]        = de-vl-mob-p2
                   tt-movto.valor-mob-p[3]        = de-vl-mob-p3              
                   tt-movto.valor-ggf-m[1]        = de-vl-ggf-m1
                   tt-movto.valor-ggf-m[2]        = de-vl-ggf-m2
                   tt-movto.valor-ggf-m[3]        = de-vl-ggf-m3
                   tt-movto.valor-ggf-o[1]        = de-vl-ggf-o1
                   tt-movto.valor-ggf-o[2]        = de-vl-ggf-o2
                   tt-movto.valor-ggf-o[3]        = de-vl-ggf-o3
                   tt-movto.valor-ggf-p[1]        = de-vl-ggf-p1
                   tt-movto.valor-ggf-p[2]        = de-vl-ggf-p2
                   tt-movto.valor-ggf-p[3]        = de-vl-ggf-p3             
                   tt-movto.gera-saldo            = no
                   tt-movto.usuario               = c-seg-usuario.   
       end.       
       when 2 then do:         

           /* Busca o movimento que originou o d‚bito na ordem */
           find first movto-estoq where 
                      movto-estoq.nr-ord-prod = ord-prod.nr-ord-prod and
                      movto-estoq.esp-docto   = 4 /* DD    */        and
                      movto-estoq.tipo-trans  = 2 /* Sa¡da */
                      no-lock no-error.

           if avail(movto-estoq) then do :
              create tt-movto.
              buffer-copy movto-estoq to tt-movto.
              assign tt-movto.cod-versao-integracao = 1
                     tt-movto.esp-docto             = 36 /* EDD */
                     tt-movto.tipo-trans            = 1
                     tt-movto.r-mov-orig            = rowid(movto-estoq)
                     tt-movto.ct-db                 = c-conta-contab
                     tt-movto.sc-db                 = fi-ccusto
                     tt-movto.dt-trans              = da-impl-saldo.                                     
           end.
       end.        
  end.

  run cep/ceapi001.p (input-output table tt-movto,
                      input-output table tt-erro ,
                      input yes                  ).

  run pi-finalizar in h-acomp.

  find first tt-erro no-lock no-error.  
  if avail tt-erro then 
     run cdp/cd0666.w (input table tt-erro).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  def var c-handle as char no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').

  
   IF ord-prod.origem = "MV":U THEN DO:                
     run utp/ut-msgs.p (input "show",                  
                        input 29505 ,                  
                        input ""    ).                 
     RUN Who-Is-The-Container IN adm-broker-hdl        
                                (INPUT this-procedure, 
                                 OUTPUT c-handle).     
     run pi-cancela in widget-handle(c-handle).        
     return "adm-error":u.                             
  END.                                                 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  disable ord-prod.nr-ord-produ with frame {&frame-name}.

  ASSIGN c-conta-contab:FORMAT IN FRAME {&frame-name} = "x(20)".
  ASSIGN fi-ccusto:FORMAT IN FRAME {&frame-name} = "x(20)".
  
  assign input frame {&frame-name} rs-tp-oper.
  if  rs-tp-oper = 1 then do:
      assign da-impl-saldo = today.
      disp da-impl-saldo with frame {&frame-name}.
      enable c-conta-contab
             da-impl-saldo
             with frame {&frame-name}.
      apply "leave" to c-conta-contab in frame {&frame-name}.
      run notify ("pi-enable,group-assign-target").
  end.
  else do:
       disp "" @ c-conta-contab
            "" @ fi-ccusto
            "" @ da-impl-saldo
            with frame {&frame-name}.
                        
       enable c-conta-contab
             da-impl-saldo
             with frame {&frame-name}.
       apply "leave" to c-conta-contab in frame {&frame-name}.
       run notify ("pi-disable,group-assign-target").
  end.
  
  

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

  if rowid (ord-prod) <> gr-ord-prod then
     run notify ('pi-zera-valores, group-assign-target').

  assign gr-ord-prod = rowid (ord-prod).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes: 
------------------------------------------------------------------------------*/

find first param-estoq no-lock no-error.
find first param-global no-lock no-error.

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

case input frame {&frame-name} rs-tp-oper:
     when 1 then do: 
          assign de-vl-mat-o1 = retorna-valor ("de-vl-mat-o1")
                 de-vl-mat-m1 = retorna-valor ("de-vl-mat-m1")
                 de-vl-mat-p1 = retorna-valor ("de-vl-mat-p1")
                 de-vl-mob-o1 = retorna-valor ("de-vl-mob-o1")
                 de-vl-mob-m1 = retorna-valor ("de-vl-mob-m1")
                 de-vl-mob-p1 = retorna-valor ("de-vl-mob-p1")
                 de-vl-ggf-o1 = retorna-valor ("de-vl-ggf-o1")
                 de-vl-ggf-m1 = retorna-valor ("de-vl-ggf-m1")
                 de-vl-ggf-p1 = retorna-valor ("de-vl-ggf-p1")
                 
                 de-vl-mat-o2 = retorna-valor ("de-vl-mat-o2")
                 de-vl-mat-m2 = retorna-valor ("de-vl-mat-m2")
                 de-vl-mat-p2 = retorna-valor ("de-vl-mat-p2")
                 de-vl-mob-o2 = retorna-valor ("de-vl-mob-o2")
                 de-vl-mob-m2 = retorna-valor ("de-vl-mob-m2")
                 de-vl-mob-p2 = retorna-valor ("de-vl-mob-p2")
                 de-vl-ggf-o2 = retorna-valor ("de-vl-ggf-o2")
                 de-vl-ggf-m2 = retorna-valor ("de-vl-ggf-m2")
                 de-vl-ggf-p2 = retorna-valor ("de-vl-ggf-p2")
                 
                 de-vl-mat-o3 = retorna-valor ("de-vl-mat-o3")
                 de-vl-mat-m3 = retorna-valor ("de-vl-mat-m3")
                 de-vl-mat-p3 = retorna-valor ("de-vl-mat-p3")
                 de-vl-mob-o3 = retorna-valor ("de-vl-mob-o3")
                 de-vl-mob-m3 = retorna-valor ("de-vl-mob-m3")
                 de-vl-mob-p3 = retorna-valor ("de-vl-mob-p3")
                 de-vl-ggf-o3 = retorna-valor ("de-vl-ggf-o3")
                 de-vl-ggf-m3 = retorna-valor ("de-vl-ggf-m3")
                 de-vl-ggf-p3 = retorna-valor ("de-vl-ggf-p3").

          find item where
               item.it-codigo = ord-prod.it-codigo no-lock no-error.

          find first movto-estoq 
               where movto-estoq.nr-ord-prod = ord-prod.nr-ord-produ
                 and movto-estoq.serie-docto = "imp" no-lock no-error.
          if avail movto-estoq then do:
             run utp/ut-msgs.p (input "show",
                                input 1530,
                                input "").
             if return-value = "no" then return "adm-error".
          end.

          assign de-saldo-ext-ord = 0.
          for each  ext-ord
             where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ no-lock:
             assign de-saldo-ext-ord  = de-saldo-ext-ord +
                    ext-ord.vl-mat-deb-m + ext-ord.vl-mat-deb-o + ext-ord.vl-mat-deb-p +
                    ext-ord.vl-mob-deb-m + ext-ord.vl-mob-deb-o + ext-ord.vl-mob-deb-p +                      
                    ext-ord.vl-ggf-deb-m[1] + ext-ord.vl-ggf-deb-o[1]+ ext-ord.vl-ggf-deb-p[1].                             
          end.

          if de-saldo-ext-ord <> 0 then do: 
             run utp/ut-msgs.p (input "show",
                                input 1532,
                                input "").
             return "adm-error".
          end.

          if ord-prod.estado = 8 then
             if ord-prod.valorizada then do: 
                run utp/ut-msgs.p (input "show",
                                   input 1534,
                                   input "").
                return "adm-error".
             end.
             else do: 
                  run utp/ut-msgs.p (input "show",
                                     input 1535,
                                     input "").
                  return "adm-error".
             end.

                         
                         
         /* Retorna Dados da Conta. */
         if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
                 
         DEFINE VARIABLE c-conta AS CHARACTER   NO-UNDO.
         ASSIGN c-conta = input frame {&frame-name} c-conta-contab.
         {cdp/cdunif001c.i i-empresa-prin c-conta today}

          if can-find(first tt_log_erro) then do:
             {cdp/cdunif001b.i1}
             apply "entry" to c-conta-contab in frame {&frame-name}.
             return "adm-error".
          end.

          if v_num_tip_cta_ctbl = 6 then do: 
             run utp/ut-msgs.p (input "show",
                                input 911,
                                input "").
             apply "entry" to c-conta-contab in frame {&frame-name}.
             return "adm-error".
          end. 

          /*if LOOKUP(STRING(v_ind_finalid_cta),"0") > 0 then do: 
             run utp/ut-msgs.p (input "show",
                                input 445,
                                input "").
             apply "entry" to c-conta-contab in frame {&frame-name}.
             return "adm-error".
          end.*/
                  
           if not valid-handle(h_api_ccusto) then 
           	run prgint/utb/utb742za.py persistent set h_api_ccusto.
           
           /** CENTRO DE CUSTO **/
           IF fi-ccusto:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
               empty temp-table tt_log_erro.
               run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                          INPUT "",
                                                          input frame {&frame-name} fi-ccusto,
                                                          INPUT TODAY,
                                                          output p_des_titulo,
                                                          OUTPUT TABLE tt_log_erro).
           
               if can-find (first tt_log_erro) then do:
                   {cdp/cdunif001b.i1}
                   apply "entry" to fi-ccusto in frame {&frame-name}.
                   return 'ADM-ERROR':U.
               end.
           END.

     end. 

     when 2 then do:
          find first movto-estoq 
               where movto-estoq.nr-ord-prod =  ord-prod.nr-ord-produ
                 and movto-estoq.serie-docto <> "imp" no-lock no-error.
          if avail movto-estoq then do: 
             run utp/ut-msgs.p (input "show",
                                input 1637,
                                input "").
             return "adm-error".
          end.

          assign de-vl-mat-m1 =0 de-vl-mat-m2=0 de-vl-mat-m3=0
                 de-vl-mat-o1 =0 de-vl-mat-m2=0 de-vl-mat-m3=0
                 de-vl-mat-p1 =0 de-vl-mat-p2=0 de-vl-mat-p3=0

                 de-vl-mob-m1 =0 de-vl-mob-m2=0 de-vl-mob-m3=0
                 de-vl-mob-o1 =0 de-vl-mob-m2=0 de-vl-mob-m3=0
                 de-vl-mob-p1 =0 de-vl-mob-p2=0 de-vl-mob-p3=0 

                 de-vl-ggf-m1 =0 de-vl-ggf-m2=0 de-vl-ggf-m3=0
                 de-vl-ggf-o1 =0 de-vl-ggf-m2=0 de-vl-ggf-m3=0
                 de-vl-ggf-p1 =0 de-vl-ggf-p2=0 de-vl-ggf-p3=0 .

          for  each movto-estoq 
              where movto-estoq.nr-ord-prod = ord-prod.nr-ord-produ
                and movto-estoq.tipo-trans  = 2 
                no-lock:

              assign de-vl-mat-m1   = de-vl-mat-m1 + movto-estoq.valor-mat-m[1]
                     de-vl-mat-m2   = de-vl-mat-m2 + movto-estoq.valor-mat-m[2]   
                     de-vl-mat-m3   = de-vl-mat-m3 + movto-estoq.valor-mat-m[3]    
                     de-vl-mat-o1   = de-vl-mat-o1 + movto-estoq.valor-mat-o[1]   
                     de-vl-mat-o2   = de-vl-mat-o2 + movto-estoq.valor-mat-o[2]    
                     de-vl-mat-o3   = de-vl-mat-o3 + movto-estoq.valor-mat-o[3]   
                     de-vl-mat-p1   = de-vl-mat-p1 + movto-estoq.valor-mat-p[1]    
                     de-vl-mat-p2   = de-vl-mat-p2 + movto-estoq.valor-mat-p[2]   
                     de-vl-mat-p3   = de-vl-mat-p3 + movto-estoq.valor-mat-p[3]   

                     de-vl-mob-m1   = de-vl-mob-m1 + movto-estoq.valor-mob-m[1]   
                     de-vl-mob-m2   = de-vl-mob-m2 + movto-estoq.valor-mob-m[2]   
                     de-vl-mob-m3   = de-vl-mob-m3 + movto-estoq.valor-mob-m[3]    
                     de-vl-mob-o1   = de-vl-mob-o1 + movto-estoq.valor-mob-o[1]   
                     de-vl-mob-o2   = de-vl-mob-o2 + movto-estoq.valor-mob-o[2]   
                     de-vl-mob-o3   = de-vl-mob-o3 + movto-estoq.valor-mob-o[3]   
                     de-vl-mob-p1   = de-vl-mob-p1 + movto-estoq.valor-mob-p[1]    
                     de-vl-mob-p2   = de-vl-mob-p2 + movto-estoq.valor-mob-p[2]  
                     de-vl-mob-p3   = de-vl-mob-p3 + movto-estoq.valor-mob-p[3]    

                     de-vl-ggf-m1   = de-vl-ggf-m1 + movto-estoq.valor-ggf-m[1]    
                     de-vl-ggf-m2   = de-vl-ggf-m2 + movto-estoq.valor-ggf-m[2]   
                     de-vl-ggf-m3   = de-vl-ggf-m3 + movto-estoq.valor-ggf-m[3]   
                     de-vl-ggf-o1   = de-vl-ggf-o1 + movto-estoq.valor-ggf-o[1]    
                     de-vl-ggf-o2   = de-vl-ggf-o2 + movto-estoq.valor-ggf-o[2]    
                     de-vl-ggf-o3   = de-vl-ggf-o3 + movto-estoq.valor-ggf-o[3]          
                     de-vl-ggf-p1   = de-vl-ggf-p1 + movto-estoq.valor-ggf-p[1]  
                     de-vl-ggf-p2   = de-vl-ggf-p2 + movto-estoq.valor-ggf-p[2]   
                     de-vl-ggf-p3   = de-vl-ggf-p3 + movto-estoq.valor-ggf-p[3].                                                   
          end.

          if de-vl-mat-m1 = 0 and de-vl-mat-m2 = 0 and de-vl-mat-m3 = 0 and
             de-vl-mat-p1 = 0 and de-vl-mat-p2 = 0 and de-vl-mat-p3 = 0 and
             de-vl-mat-o1 = 0 and de-vl-mat-o2 = 0 and de-vl-mat-o3 = 0 and

             de-vl-mob-m1 = 0 and de-vl-mob-m2 = 0 and de-vl-mob-m3 = 0 and
             de-vl-mob-p1 = 0 and de-vl-mob-p2 = 0 and de-vl-mob-p3 = 0 and
             de-vl-mob-o1 = 0 and de-vl-mob-o2 = 0 and de-vl-mob-o3 = 0 and

             de-vl-ggf-m1 = 0 and de-vl-ggf-m2 = 0 and de-vl-ggf-m3 = 0 and
             de-vl-ggf-p1 = 0 and de-vl-ggf-p2 = 0 and de-vl-ggf-p3 = 0 and
             de-vl-ggf-o1 = 0 and de-vl-ggf-o2 = 0 and de-vl-ggf-o3 = 0  then do: 
             run utp/ut-msgs.p (input "show",
                                input 1643,
                                input "").
             return "adm-error".
          end.

          run utp/ut-msgs.p (input "show",
                             input 1649,
                             input "").
          if return-value = "no" then return "adm-error".

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION retorna-valor V-table-Win 
FUNCTION retorna-valor RETURNS DECIMAL
  ( input c-campo as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT c-campo).
  RETURN decimal (return-value).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .


  if valid-handle(h_api_ccusto) then
      delete procedure h_api_ccusto.
	  
  if valid-handle(h_api_cta_ctbl) then
      delete procedure h_api_cta_ctbl.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
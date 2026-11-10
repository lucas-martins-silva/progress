&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V04IN177 2.00.01.002}  /*** 010102 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v04in177 MUT}
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
def new global shared var v-row-parent as rowid  no-undo.                  
def new global shared var h-acomp      as handle no-undo.              

def var c-retorno as char no-undo.

{cdp/cdcfgman.i}

{csp/csapi002.i1}
{cdp/cd0666.i}

/*************Multiplanta********************/
def var i-tipo-movto as integer no-undo.
{cdp/cd7300.i1}
{cdp/cdapi216.i}

{mcinc/mcapi281.i}
def temp-table tt-dados-env-SMC     like tt-dados-env.
def temp-table tt-replica-msg-SMC   like tt-replica-msg.
def temp-table tt-control-env-SMC   like tt-control-env.
def temp-table tt-integracao-SMC    like tt-integracao.
/************Fim*****************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item-estab
&Scoped-define FIRST-EXTERNAL-TABLE item-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-estab.on-line-ate 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}on-line-ate ~{&FP2}on-line-ate ~{&FP3}
&Scoped-define ENABLED-TABLES item-estab
&Scoped-define FIRST-ENABLED-TABLE item-estab
&Scoped-Define ENABLED-OBJECTS rt-mold rt-key fi-tit-mat fi-tit-mob ~
fi-tit-ggf 
&Scoped-Define DISPLAYED-FIELDS item-estab.it-codigo item-estab.cod-estabel ~
item-estab.on-line-ate 
&Scoped-Define DISPLAYED-OBJECTS c-desc c-nome val-unit-mat-1 ~
val-unit-mob-1 val-unit-ggf-1 val-unit-mat-2 val-unit-mob-2 val-unit-ggf-2 ~
val-unit-mat-3 val-unit-mob-3 val-unit-ggf-3 fi-tit-mat fi-tit-mob ~
fi-tit-ggf 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS item-estab.it-codigo ~
item-estab.cod-estabel val-unit-mat-1 val-unit-mob-1 val-unit-ggf-1 ~
val-unit-mat-2 val-unit-mob-2 val-unit-ggf-2 val-unit-mat-3 val-unit-mob-3 ~
val-unit-ggf-3 
&Scoped-define ADM-MODIFY-FIELDS val-unit-mat-1 val-unit-mob-1 ~
val-unit-ggf-1 val-unit-mat-2 val-unit-mob-2 val-unit-ggf-2 val-unit-mat-3 ~
val-unit-mob-3 val-unit-ggf-3 

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
DEFINE VARIABLE c-desc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tit-ggf AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE fi-tit-mat AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE fi-tit-mob AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE val-unit-ggf-1 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88.

DEFINE VARIABLE val-unit-ggf-2 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88.

DEFINE VARIABLE val-unit-ggf-3 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88.

DEFINE VARIABLE val-unit-mat-1 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99" INITIAL 0 
     LABEL "":R28 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88.

DEFINE VARIABLE val-unit-mat-2 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88.

DEFINE VARIABLE val-unit-mat-3 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88.

DEFINE VARIABLE val-unit-mob-1 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88.

DEFINE VARIABLE val-unit-mob-2 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88.

DEFINE VARIABLE val-unit-mob-3 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 2.42.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 6.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-estab.it-codigo AT ROW 1.25 COL 18.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-desc AT ROW 1.25 COL 36 COLON-ALIGNED NO-LABEL
     item-estab.cod-estabel AT ROW 2.25 COL 18.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-nome AT ROW 2.25 COL 26 COLON-ALIGNED NO-LABEL
     val-unit-mat-1 AT ROW 5.29 COL 23 COLON-ALIGNED
     val-unit-mob-1 AT ROW 5.29 COL 45 COLON-ALIGNED NO-LABEL
     val-unit-ggf-1 AT ROW 5.29 COL 67 COLON-ALIGNED NO-LABEL
     val-unit-mat-2 AT ROW 6.29 COL 23 COLON-ALIGNED
     val-unit-mob-2 AT ROW 6.29 COL 45 COLON-ALIGNED NO-LABEL
     val-unit-ggf-2 AT ROW 6.29 COL 67 COLON-ALIGNED NO-LABEL
     val-unit-mat-3 AT ROW 7.29 COL 23 COLON-ALIGNED
     val-unit-mob-3 AT ROW 7.29 COL 45 COLON-ALIGNED NO-LABEL
     val-unit-ggf-3 AT ROW 7.29 COL 67 COLON-ALIGNED NO-LABEL
     item-estab.on-line-ate AT ROW 8.42 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY 1
     fi-tit-mat AT ROW 4.25 COL 23 COLON-ALIGNED NO-LABEL
     fi-tit-mob AT ROW 4.25 COL 45 COLON-ALIGNED NO-LABEL
     fi-tit-ggf AT ROW 4.25 COL 67 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 3.71 COL 1
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.item-estab
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 8.79
         WIDTH              = 88.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-estab.cod-estabel IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item-estab.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN val-unit-ggf-1 IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN val-unit-ggf-2 IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN val-unit-ggf-3 IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN val-unit-mat-1 IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN val-unit-mat-2 IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN val-unit-mat-3 IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN val-unit-mob-1 IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN val-unit-mob-2 IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN val-unit-mob-3 IN FRAME f-main
   NO-ENABLE 1 3                                                        */
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-liter.i Data_Padr∆o * R}
assign item-estab.on-line-ate:label in frame {&frame-name} = trim(return-value). 

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "item-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-estab"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    &IF  DEFINED (bf_man_custeio_item) &THEN
    find first item-uni-estab
        where item-uni-estab.it-codigo   = input frame {&frame-name} item-estab.it-codigo
          and item-uni-estab.cod-estabel = input frame {&frame-name} item-estab.cod-estabel no-lock no-error.
    if  not avail item-uni-estab
    or  item-uni-estab.metodo-custeio <> 5 then do:
        {utp/ut-liter.i Padr∆o * R}
        run utp/ut-msgs.p (input "show":U,
                           input 26092,
                           input trim(return-value)).
        return no-apply.    
    end.
    &ENDIF   

for each tt-item-estab:
    delete tt-item-estab.
end.

create tt-item-estab.
assign tt-item-estab.cod-versao-integracao = 001
       tt-item-estab.cod-estabel           = item-estab.cod-estabel
       tt-item-estab.it-codigo             = item-estab.it-codigo
       tt-item-estab.data-padrao           = input frame {&frame-name} item-estab.on-line-ate
       &IF  DEFINED (bf_man_custeio_item) &THEN
       tt-item-estab.val-unit-mat-o[1]     = input frame {&frame-name} val-unit-mat-1
       tt-item-estab.val-unit-mob-o[1]     = input frame {&frame-name} val-unit-mob-1
       tt-item-estab.val-unit-ggf-o[1]     = input frame {&frame-name} val-unit-ggf-1.  
       &ELSE
       tt-item-estab.val-unit-mat-p[1]     = input frame {&frame-name} val-unit-mat-1
       tt-item-estab.val-unit-mob-p[1]     = input frame {&frame-name} val-unit-mob-1
       tt-item-estab.val-unit-ggf-p[1]     = input frame {&frame-name} val-unit-ggf-1.  
       &ENDIF

if  param-estoq.tem-moeda1 then
    &IF  DEFINED (bf_man_custeio_item) &THEN
    assign tt-item-estab.val-unit-mat-o[2] = input frame {&frame-name} val-unit-mat-2
           tt-item-estab.val-unit-mob-o[2] = input frame {&frame-name} val-unit-mob-2
           tt-item-estab.val-unit-ggf-o[2] = input frame {&frame-name} val-unit-ggf-2.
    &ELSE
    assign tt-item-estab.val-unit-mat-p[2] = input frame {&frame-name} val-unit-mat-2
           tt-item-estab.val-unit-mob-p[2] = input frame {&frame-name} val-unit-mob-2
           tt-item-estab.val-unit-ggf-p[2] = input frame {&frame-name} val-unit-ggf-2.
    &ENDIF

if  param-estoq.tem-moeda2 then
    &IF  DEFINED (bf_man_custeio_item) &THEN
    assign tt-item-estab.val-unit-mat-o[3] = input frame {&frame-name} val-unit-mat-3
           tt-item-estab.val-unit-mob-o[3] = input frame {&frame-name} val-unit-mob-3
           tt-item-estab.val-unit-ggf-o[3] = input frame {&frame-name} val-unit-ggf-3.
    &ELSE
    assign tt-item-estab.val-unit-mat-p[3] = input frame {&frame-name} val-unit-mat-3
           tt-item-estab.val-unit-mob-p[3] = input frame {&frame-name} val-unit-mob-3
           tt-item-estab.val-unit-ggf-p[3] = input frame {&frame-name} val-unit-ggf-3.
    &ENDIF

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Gerando_Movimento_de_Variaá∆o *}
run pi-inicializar in h-acomp ( Return-value ).
run pi-desabilita-cancela in h-acomp.

run csp/csapi002.p (input        table tt-item-estab,
                    input-output table tt-erro,
                    input        yes).                       

assign c-retorno = return-value.          

run pi-finalizar in h-acomp.          

find first tt-erro no-error.
if avail tt-erro then                                       
   run cdp/cd0666.w (input table tt-erro).

if c-retorno = "nok" then return "adm-error".    

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

   /*****[ Geraá∆o de Transaá∆o Multiplanta Especifica do SMC ]******/
        for each tt-smc-item-estab:
            delete tt-smc-item-estab.
        end.
        assign  c-transacao = "SMC024".
        {cdp/cd7300.i5 "001" c-transacao "-SMC"}
        assign  i-tipo-movto = 2.
        run pi-cria-tt-dados-smc (i-tipo-movto).
        {cdp/cd7300.i6 "001" c-transacao "-SMC"}
   /***[Fim da Geraá∆o de Transaá∆o Multiplanta Especifica do SMC]***/


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

    find item 
        where item.it-codigo = item-estab.it-codigo no-lock no-error.
    if  avail item then
        assign c-desc = item.desc-item.
    else 
        assign c-desc = "".

    find estabelec 
        where estabelec.cod-estabel = item-estab.cod-estabel no-lock no-error.
    if  avail estabelec then 
        assign c-nome = estabelec.nome.
    else c-nome = "".

    if  avail item-estab then
        &IF  DEFINED (bf_man_custeio_item) &THEN
        assign val-unit-mat-1 = item-estab.val-unit-mat-o[1]
               val-unit-mat-2 = item-estab.val-unit-mat-o[2]
               val-unit-mat-3 = item-estab.val-unit-mat-o[3]
               val-unit-mob-1 = item-estab.val-unit-mob-o[1]
               val-unit-mob-2 = item-estab.val-unit-mob-o[2]
               val-unit-mob-3 = item-estab.val-unit-mob-o[3]
               val-unit-ggf-1 = item-estab.val-unit-ggf-o[1]
               val-unit-ggf-2 = item-estab.val-unit-ggf-o[2]
               val-unit-ggf-3 = item-estab.val-unit-ggf-o[3].
        &ELSE
        assign val-unit-mat-1 = item-estab.val-unit-mat-p[1]
               val-unit-mat-2 = item-estab.val-unit-mat-p[2]
               val-unit-mat-3 = item-estab.val-unit-mat-p[3]
               val-unit-mob-1 = item-estab.val-unit-mob-p[1]
               val-unit-mob-2 = item-estab.val-unit-mob-p[2]
               val-unit-mob-3 = item-estab.val-unit-mob-p[3]
               val-unit-ggf-1 = item-estab.val-unit-ggf-p[1]
               val-unit-ggf-2 = item-estab.val-unit-ggf-p[2]
               val-unit-ggf-3 = item-estab.val-unit-ggf-p[3].
        &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    if  param-estoq.tem-moeda1 = no then do:
        assign val-unit-mat-2:visible in frame {&frame-name} = no
               val-unit-mob-2:visible in frame {&frame-name} = no
               val-unit-ggf-2:visible in frame {&frame-name} = no.
    end.

    if param-estoq.tem-moeda2 = no then do:
       assign val-unit-mat-3:visible in frame {&frame-name} = no
              val-unit-mob-3:visible in frame {&frame-name} = no
              val-unit-ggf-3:visible in frame {&frame-name} = no.
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

    if  param-estoq.tem-moeda1 = no then do:
        assign val-unit-mat-2:visible in frame {&frame-name} = no
               val-unit-mob-2:visible in frame {&frame-name} = no
               val-unit-ggf-2:visible in frame {&frame-name} = no.
    end.

    if  param-estoq.tem-moeda2 = no then do:
        assign val-unit-mat-3:visible in frame {&frame-name} = no
               val-unit-mob-3:visible in frame {&frame-name} = no
               val-unit-ggf-3:visible in frame {&frame-name} = no.
    end. 

    find first param-estoq no-lock no-error.
    if  avail param-estoq then
        if  adm-new-record then 
            assign item-estab.on-line-ate:screen-value in frame {&frame-name} =
                                                      string(param-estoq.contab-ate + 1, "99/99/9999").
        else
            assign item-estab.on-line-ate:screen-value in frame {&frame-name} =          
                   string (if  item-estab.on-line-ate > param-estoq.contab-ate + 1 
                           then item-estab.on-line-ate
                           else param-estoq.contab-ate + 1, "99/99/9999").
    else
        assign item-estab.on-line-ate:screen-value in frame {&frame-name} = string(today, "99/99/9999").      

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

    {utp/ut-liter.i Material    * L} assign fi-tit-mat = return-value.
    {utp/ut-liter.i M∆o-de-Obra * L} assign fi-tit-mob = return-value.
    {utp/ut-liter.i GGF         * L} assign fi-tit-ggf = return-value.

    find first param-estoq no-lock no-error.
    find moeda where moeda.mo-codigo = 0 no-lock no-error.
    if  avail moeda then
        assign val-unit-mat-1:label in frame {&frame-name} = moeda.descricao.

    if  param-estoq.tem-moeda1 then do:
        find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
        if  avail moeda then
            assign val-unit-mat-2:label in frame {&frame-name} = moeda.descricao.
    end.
    else
        assign val-unit-mat-2:visible in frame {&frame-name} = no
               val-unit-mob-2:visible in frame {&frame-name} = no
               val-unit-ggf-2:visible in frame {&frame-name} = no.

    if  param-estoq.tem-moeda2 then do:
        find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
        if  avail moeda then
            assign val-unit-mat-3:label in frame {&frame-name} = moeda.descricao.
    end.
    else
        assign val-unit-mat-3:visible in frame {&frame-name} = no
               val-unit-mob-3:visible in frame {&frame-name} = no
               val-unit-ggf-3:visible in frame {&frame-name} = no.

    disp fi-tit-mat
         fi-tit-mob
         fi-tit-ggf with frame {&frame-name}. 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-smc V-table-Win 
PROCEDURE pi-cria-tt-dados-smc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter i-tipo-movto as integer.

    if  param-global.modulo-mp
    and tt-replica-msg-SMC.log-replica-msg  = yes
    then do:
        create  tt-smc-item-estab.
        buffer-copy item-estab to tt-smc-item-estab.
        create  tt-dados-env-SMC.
        assign  tt-dados-env-SMC.num-sequencia  = i-seq
                tt-dados-env-SMC.cod-tipo-reg   = 281
                tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
                tt-dados-env-SMC.identif-msg    = item-estab.cod-estabel + " , " +
                                                  item-estab.it-codigo.
        raw-transfer tt-smc-item-estab to tt-dados-env-SMC.conteudo-msg.
        assign i-seq = i-seq + 1.
    end.

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

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "item-estab"}

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



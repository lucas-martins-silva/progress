&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME

/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V40AD098 2.00.01.006 } /*** "010106" ***/

 
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v40ad098 MUT}
&ENDIF


/*def new global shared var c-arquivo-log    as char  format "x(60)" no-undo.*/
/*def var c-prg-vrs as char init "[[[{2}[[[" no-undo.*/
/*def var c-prg-obj as char no-undo.*/

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

define new global shared variable r-ped-venda-g as rowid   no-undo.
define new global shared variable r-registro    as rowid   no-undo.
define new global shared variable l-mostra-msg  as logical no-undo.
define new global shared variable gr-emitente   as rowid   no-undo.

define variable i-cont1 as integer initial 0 no-undo.
define variable i-cont2 as integer initial 0 no-undo.
define variable i-cont3 as integer initial 0 no-undo.
define variable i-cont4 as integer initial 0 no-undo.

define variable c-msg   as CHARACTER no-undo.
define variable c-help  as CHARACTER no-undo.

define variable l-considera-replica-pd as log no-undo.  /* usado na cdapi013.i1 */
define variable de-limite like emitente.lim-credito  no-undo.
define variable p6-vl-ap-abe-gp as decimal initial 0 no-undo.
define variable h-q03ad098      as handle            no-undo.
define variable rw-emitente     as rowid             no-undo.

DEFINE VARIABLE de-lim-credito-aux AS DECIMAL FORMAT "zz,zzz,zzz,zz9.99" NO-UNDO. 

def var i-cod-msg       as int         no-undo.

/*{cdp/cd8000.i1}*/

def var i-empresa like param-global.empresa-prin no-undo.
{cdp/cdcfgdis.i}

&IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
    {cdp/cd1022.i2}  
    {cmp/cm0201f.i3} /*** Gr∆os ***/
&ELSE
    {pdp/pd0902.i2}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 
&Scoped-Define DISPLAYED-OBJECTS de-lim-credito d-moeda de-totvlap-vw ~
i-totpdap de-vl-ped-vw de-totvlre-vw i-totpdre de-totvlaa-vw i-totpdaa ~
de-vl-nota-vw i-totpdcr de-saldo-cr-vw p5-vl-cr-abe de-saldo-ap-vw ~
p6-vl-ap-abe de-saldo-vw c-text-1 c-text-2 c-text-4 c-text-5 c-text-6 ~
c-sinal 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-pd0902-chamou V-table-Win 
FUNCTION fn-pd0902-chamou RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-sinal AS CHARACTER FORMAT "X(5)":U 
      VIEW-AS TEXT 
     SIZE 3.57 BY .63 NO-UNDO.

DEFINE VARIABLE c-text-1 AS CHARACTER FORMAT "X(5)":U INITIAL "( + )" 
      VIEW-AS TEXT 
     SIZE 4 BY .88
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE c-text-2 AS CHARACTER FORMAT "X(5)":U INITIAL "( - )" 
      VIEW-AS TEXT 
     SIZE 4 BY .88
     FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE c-text-4 AS CHARACTER FORMAT "X(5)":U INITIAL "( - )" 
      VIEW-AS TEXT 
     SIZE 4 BY .88
     FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE c-text-5 AS CHARACTER FORMAT "X(5)":U INITIAL "( - )" 
      VIEW-AS TEXT 
     SIZE 4 BY .88
     FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE c-text-6 AS CHARACTER FORMAT "X(5)":U INITIAL "( + )" 
      VIEW-AS TEXT 
     SIZE 4 BY .88
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE d-moeda AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS FILL-IN NATIVE 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-lim-credito AS DECIMAL FORMAT "zz,zzz,zzz,zz9.99" INITIAL 0 
     LABEL "":R17 
     VIEW-AS FILL-IN NATIVE 
     SIZE 25 BY .88.

DEFINE VARIABLE de-saldo-ap-vw AS DECIMAL FORMAT "-zz,zzz,zzz,zz9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo-cr-vw AS DECIMAL FORMAT "-zz,zzz,zzz,zz9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo-vw AS DECIMAL FORMAT "-zz,zzz,zzz,zz9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE de-totvlaa-vw AS DECIMAL FORMAT "zz,zzz,zzz,zz9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE de-totvlap-vw AS DECIMAL FORMAT "zz,zzz,zzz,zz9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE de-totvlre-vw AS DECIMAL FORMAT "zz,zzz,zzz,zz9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-nota-vw AS DECIMAL FORMAT "-zz,zzz,zzz,zz9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ped-vw AS DECIMAL FORMAT "zz,zzz,zzz,zz9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE i-totpdaa AS INTEGER FORMAT "(9999)":U INITIAL 0 
     VIEW-AS FILL-IN NATIVE 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-totpdap AS INTEGER FORMAT "(9999)":U INITIAL 0 
     VIEW-AS FILL-IN NATIVE 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-totpdcr AS INTEGER FORMAT "(9999)":U INITIAL 0 
     VIEW-AS FILL-IN NATIVE 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-totpdre AS INTEGER FORMAT "(9999)":U INITIAL 0 
     VIEW-AS FILL-IN NATIVE 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE p5-vl-cr-abe AS DECIMAL FORMAT "-zz,zzz,zzz,zz9.99":U INITIAL 0 
     VIEW-AS FILL-IN NATIVE 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE p6-vl-ap-abe AS DECIMAL FORMAT "-zz,zzz,zzz,zz9.99":U INITIAL 0 
     VIEW-AS FILL-IN NATIVE 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.29 BY 10.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-lim-credito AT ROW 1.38 COL 21.43 COLON-ALIGNED
     d-moeda AT ROW 1.38 COL 54.14 COLON-ALIGNED NO-LABEL
     de-totvlap-vw AT ROW 2.38 COL 21.43 COLON-ALIGNED
     i-totpdap AT ROW 2.38 COL 54.14 COLON-ALIGNED NO-LABEL
     de-vl-ped-vw AT ROW 3.38 COL 21.43 COLON-ALIGNED
     de-totvlre-vw AT ROW 4.38 COL 21.43 COLON-ALIGNED
     i-totpdre AT ROW 4.38 COL 54.14 COLON-ALIGNED NO-LABEL
     de-totvlaa-vw AT ROW 5.38 COL 21.43 COLON-ALIGNED
     i-totpdaa AT ROW 5.38 COL 54.14 COLON-ALIGNED NO-LABEL
     de-vl-nota-vw AT ROW 6.38 COL 21.43 COLON-ALIGNED
     i-totpdcr AT ROW 6.38 COL 54.14 COLON-ALIGNED NO-LABEL
     de-saldo-cr-vw AT ROW 7.38 COL 21.43 COLON-ALIGNED
     p5-vl-cr-abe AT ROW 7.38 COL 54.14 COLON-ALIGNED NO-LABEL
     de-saldo-ap-vw AT ROW 8.38 COL 21.43 COLON-ALIGNED
     p6-vl-ap-abe AT ROW 8.38 COL 54.14 COLON-ALIGNED NO-LABEL
     de-saldo-vw AT ROW 9.38 COL 21.43 COLON-ALIGNED
     c-text-1 AT ROW 1.42 COL 49.72 COLON-ALIGNED NO-LABEL
     c-text-2 AT ROW 2.42 COL 50 COLON-ALIGNED NO-LABEL
     c-text-4 AT ROW 6.42 COL 50 COLON-ALIGNED NO-LABEL
     c-text-5 AT ROW 7.5 COL 72.14 COLON-ALIGNED NO-LABEL
     c-text-6 AT ROW 8.5 COL 71.86 COLON-ALIGNED NO-LABEL
     c-sinal AT ROW 9.42 COL 50 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.emitente
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
         HEIGHT             = 10.04
         WIDTH              = 84.57.
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

/* SETTINGS FOR FILL-IN c-sinal IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-text-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-text-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-text-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-text-5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-text-6 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-lim-credito IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saldo-ap-vw IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saldo-cr-vw IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saldo-vw IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-totvlaa-vw IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-totvlap-vw IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-totvlre-vw IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-nota-vw IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ped-vw IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-totpdaa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-totpdap IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-totpdcr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-totpdre IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN p5-vl-cr-abe IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN p6-vl-ap-abe IN FRAME f-main
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


{pdp/pd9999.i2} /*definiá∆o dos campos da cm-param*/
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 

{include/i-epc200.i1}

{cdp/cdapi013.i}
{cdp/cdapi013.i1}

def temp-table tt-erro no-undo
    field i-sequen as int              
    field cd-erro  as int
    field mensagem as char format "x(255)".

def var i-moeda-credito as int no-undo.
def var i-aux           as int no-undo.


/* ***************************  Main Block  *************************** */

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
  {src/adm/template/row-list.i "emitente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "emitente"}

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

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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

if rw-emitente = rowid(emitente) then
   run pi-atualiza-dados (input no). /* Avaliaá∆o por Matriz/Cliente */                                                                                                                                     
                                                                                                                                                                                
/* Dispatch standard ADM method.                             */
RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

run pi-mostra-dados.

/* Code placed here will execute AFTER standard behavior.    */     

if  rowid(emitente) <> ? 
and rowid(emitente) = rw-emitente 
and l-mostra-msg then do:
    if  emitente.dt-lim-cred < today then 
        run utp/ut-msgs.p (input "show", input 3204, input emitente.nome-abrev).
    if  emitente.dt-fim-cred < today then 
        run utp/ut-msgs.p (input "show", input 3206, input emitente.nome-abrev).                          
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
  find first para-ped     no-lock no-error.
  find first para-fat     no-lock no-error.
  find first param-global no-lock no-error.
  find first cm-param     no-lock no-error.

  find param-cr where param-cr.ep-codigo = param-global.empresa-prin no-lock no-error.

  if  param-global.modulo-05 then
      assign l-vendor = yes.       

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */  
  {utp/ut-liter.i Lim_Cred/Lim_Adic * L}
  de-lim-credito:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Tot_Ped_Aprov/Aval * L}
  assign de-totvlap-vw:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Vl_Pedido_em_An†lise * L}
  assign de-vl-ped-vw:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Tot_Pedidos_Recusados * L}
  assign de-totvlre-vw:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Tot_Pedidos_a_Aprovar * L}
  assign de-totvlaa-vw:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i NFÔs_n∆o_Atual_no_CR * L}
  assign de-vl-nota-vw:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Sdo_Devedor_CR/Vl_MP * L}
  assign de-saldo-cr-vw:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Sdo_Credor_AP/Vl_MP * L}
  assign de-saldo-ap-vw:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Saldo_Atual * L}
  assign de-saldo-vw:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Valor_do_saldo_atual_pode_ser_diferente}
  assign c-msg = return-value.
  {utp/ut-liter.i O_valor_do_saldo_atual_pode_ser_diferente_do_apresentado_em_funá∆o_das_regras_definidas_no_Intellector}
  assign c-help = return-value.

  IF AVAIL param-global THEN DO:
       &IF '{&bf_dis_versao_ems}' >= '2.08':U &THEN 
           IF param-global.log-cr-clien = YES THEN
       &ELSE                                     
           IF SUBSTRING(param-global.char-2,32,1) = "S" THEN
       &ENDIF
              RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                 INPUT 27979,
                                 INPUT c-msg + "~~" + c-help).
  END.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view V-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if  valid-handle(h-q03ad098) then do:
      if  rw-emitente <> rowid(emitente) and
          rw-emitente <> ? then 
          run PI-REPOSICIONA-QUERY in h-q03ad098(input rw-emitente).             
  end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dados V-table-Win 
PROCEDURE pi-atualiza-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter l-matriz as logical format "matriz/cliente" no-undo.

DEF VAR c-cod-safra-ini AS CHAR INITIAL "00000000" NO-UNDO. 
DEF VAR c-cod-safra-fim AS CHAR INITIAL "99999999" NO-UNDO. 

&IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
    {cmp/cm0201f.i1}
&ELSE
    {pdp/pd0802f.i1}
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-handle-query V-table-Win 
PROCEDURE pi-handle-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define input parameter p-q03ad098 as handle no-undo.

  assign h-q03ad098 = p-q03ad098.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-dados V-table-Win 
PROCEDURE pi-mostra-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
    {cmp/cm0201f.i2}
&ELSE
    {pdp/pd0802f.i2}
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-rowid V-table-Win 
PROCEDURE pi-recebe-rowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define input parameter p-emitente as rowid no-undo.

  assign rw-emitente = p-emitente.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executa-upc V-table-Win 
PROCEDURE pi-executa-upc :


        /* UPC */
        IF  c-nom-prog-upc-mg97 <> "" THEN do:

            RUN VALUE(c-nom-prog-upc-mg97) (INPUT "replicaPD", 
                                            INPUT "",
                                            INPUT ?,
                                            INPUT ?,
                                            INPUT "",
                                            INPUT ?).

            if return-value = "NOK" then
               assign l-considera-replica-pd = yes. 


        end.                                        



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zera-valores V-table-Win 
PROCEDURE pi-zera-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  assign de-saldo-ap = 0
         de-totvlap  = 0
         de-totvlre  = 0
         de-totvlaa  = 0
         de-vl-nota  = 0
         de-saldo-cr = 0
         de-saldo-ap = 0
         de-saldo    = 0
         i-tot-pdap  = 0
         i-tot-pdre  = 0
         i-tot-pdaa  = 0
         i-tot-tit-cr = 0
         mp-vl-cr-abe = 0
         mp-vl-ap-abe = 0.

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
  {src/adm/template/snd-list.i "emitente"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-pd0902-chamou V-table-Win 
FUNCTION fn-pd0902-chamou RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var i-cont      as int.
  def var i-cont-char as int.
  def var l-retorno   as log init no.

  verifica:
  do i-cont = 1 to 9:
    do i-cont-char = 1 to (length(program-name(i-cont)) - 6):
      if substr(program-name(i-cont),i-cont-char,6) = "pd0902" then do:
        assign l-retorno = yes.
        leave verifica.
      end.
    end.
  end.

  RETURN l-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



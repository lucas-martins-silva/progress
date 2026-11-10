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
{include/i-prgvrs.i V05IN122 2.00.00.018}  /*** 010018 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V05IN122 MUT}
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
def new global shared var g-rw-item    as rowid no-undo.     
def new global shared var gr-familia   as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define var c-exp-opcao  as char no-undo.
define var c-valido     as char no-undo.

def var l-codigo-orig     as logical no-undo.
def var l-cd-trib-icm     as logical no-undo.
def var l-cd-trib-ipi     as logical no-undo.
def var l-baixa-estoq     as logical no-undo.
def var l-fraciona        as logical no-undo.
def var l-perm-saldo-neg  as logical no-undo.
def var l-class-fiscal    as logical no-undo.
def var l-gera-log        as logical no-undo.



define temp-table tt-fam
  field cd-trib-ipi    like familia.cd-trib-ipi
  field cd-trib-icm    like familia.cd-trib-icm
  field baixa-estoq    like familia.baixa-estoq
  field fraciona       like familia.fraciona
  field perm-saldo-neg like familia.perm-saldo-neg
  field class-fiscal   like familia.class-fiscal
  field codigo-orig    like familia.codigo-orig.

/************* Multi-Planta *******************/
def var i-tipo-movto as integer no-undo.
def var l-cria       as logical no-undo.

{cdp/cd7300.i1}
{cdp/cd0669.i}
/****************** Fim ***********************/

{include/i_fnctrad.i}

/************* Integra‡Æo com Sisdoc *******************/
def var i-integracao-sisdoc as integer init ?   no-undo.
def var c-handle            as char             no-undo.
def var c-opcao-int         as char             no-undo.
def var l-passou            as logical init no  no-undo.
def var i-retorno-erro      as integer init ?   no-undo.
    /* ** 5 => Quando parƒmetro "nao-integra" e o registro j  est  integrado **
       ** 6 => Erro de integra‡Æo no SISDOC                                  **
       ** 7 => Erro de integra‡Æo no EMS                                   ** */
/********************************************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES familia
&Scoped-define FIRST-EXTERNAL-TABLE familia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR familia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS familia.codigo-orig familia.baixa-estoq ~
familia.var-qtd-perm familia.fraciona familia.var-pre-perm ~
familia.class-fiscal 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}codigo-orig ~{&FP2}codigo-orig ~{&FP3}~
 ~{&FP1}var-qtd-perm ~{&FP2}var-qtd-perm ~{&FP3}~
 ~{&FP1}var-pre-perm ~{&FP2}var-pre-perm ~{&FP3}~
 ~{&FP1}class-fiscal ~{&FP2}class-fiscal ~{&FP3}
&Scoped-define ENABLED-TABLES familia
&Scoped-define FIRST-ENABLED-TABLE familia
&Scoped-Define ENABLED-OBJECTS rt-key-2 rt-key RECT-8 RECT-12 
&Scoped-Define DISPLAYED-FIELDS familia.fm-codigo familia.descricao ~
familia.codigo-orig familia.baixa-estoq familia.var-qtd-perm ~
familia.fraciona familia.var-pre-perm familia.class-fiscal 
&Scoped-Define DISPLAYED-OBJECTS cb-perm-saldo-neg fi-desc-class-fisc ~
cb-cd-trib-icm cb-cd-trib-ipi 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cb-perm-saldo-neg 
&Scoped-define ADM-ASSIGN-FIELDS cb-perm-saldo-neg 
&Scoped-define ADM-MODIFY-FIELDS cb-perm-saldo-neg 

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
DEFINE VARIABLE cb-cd-trib-icm AS CHARACTER FORMAT "X(256)" INITIAL "1" 
     LABEL "C¢digo Tributa‡Æo ICMS":R26 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cd-trib-ipi AS CHARACTER FORMAT "X(256)" INITIAL "1" 
     LABEL "C¢digo Tributa‡Æo IPI":R25 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-perm-saldo-neg AS CHARACTER FORMAT "X(256)" INITIAL "1" 
     LABEL "Saldo Neg":R11 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE fi-desc-class-fisc AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 41.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.86 BY 3.96.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40.72 BY 3.96.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.43 BY 3.96.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.86 BY 1.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     familia.fm-codigo AT ROW 1.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     familia.descricao AT ROW 1.25 COL 40 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     familia.codigo-orig AT ROW 3.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY 1
     familia.baixa-estoq AT ROW 3.25 COL 59.86
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .75
     familia.var-qtd-perm AT ROW 4.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     familia.fraciona AT ROW 4.25 COL 59.86
          VIEW-AS TOGGLE-BOX
          SIZE 27.43 BY .75
     familia.var-pre-perm AT ROW 5.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cb-perm-saldo-neg AT ROW 5.25 COL 57.86 COLON-ALIGNED HELP
          "Permite parametrizar o Tipo de Saldo"
     familia.class-fiscal AT ROW 7.46 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     fi-desc-class-fisc AT ROW 7.46 COL 41 COLON-ALIGNED NO-LABEL
     cb-cd-trib-icm AT ROW 8.46 COL 27 COLON-ALIGNED
     cb-cd-trib-ipi AT ROW 9.63 COL 27 COLON-ALIGNED
     rt-key-2 AT ROW 1 COL 1
     rt-key AT ROW 2.75 COL 1
     RECT-8 AT ROW 2.75 COL 47
     RECT-12 AT ROW 7 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.familia
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
         HEIGHT             = 10.17
         WIDTH              = 87.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R, COLUMNS                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-cd-trib-icm IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-cd-trib-icm:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-cd-trib-ipi IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-cd-trib-ipi:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-perm-saldo-neg IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
ASSIGN 
       familia.class-fiscal:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN familia.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-class-fisc IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-class-fisc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN familia.fm-codigo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       RECT-12:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME familia.class-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.class-fiscal V-table-Win
ON F5 OF familia.class-fiscal IN FRAME f-main /* Classifica‡Æo Fiscal */
DO:
  l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in046.w"
                  &tabela=familia
                  &atributo=class-fiscal}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.class-fiscal V-table-Win
ON LEAVE OF familia.class-fiscal IN FRAME f-main /* Classifica‡Æo Fiscal */
DO:
    {include/leave.i &tabela=classif-fisc
                     &atributo-ref=descricao
                     &variavel-ref=fi-desc-class-fisc
                     &where="classif-fisc.class-fiscal = input frame {&frame-name} familia.class-fiscal"}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.class-fiscal V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.class-fiscal IN FRAME f-main /* Classifica‡Æo Fiscal */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  if familia.class-fiscal:load-mouse-pointer ("Image\lupa.cur") in frame
     {&frame-name} then.

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
  {src/adm/template/row-list.i "familia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "familia"}

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
  /* Ponha na pi-validate todas as valida‡äes */
  do with frame {&FRAME-NAME}:
    assign cb-cd-trib-icm 
           cb-cd-trib-ipi 
           cb-perm-saldo-neg.
  end.       

  if input frame {&frame-name} familia.class-fiscal:hidden = no then do:
     find first classif-fisc where 
          classif-fisc.class-fiscal = input frame {&frame-name} familia.class-fiscal 
          no-lock no-error. 
     if not avail classif-fisc or input frame {&frame-name} familia.class-fiscal = " " then do:
        run utp/ut-msgs.p (input "show",
                           input 5670,
                           input " ").
        return 'ADM-ERROR':U.
     end.                       
  end.
  for each tt-fam:
    delete tt-fam.
  end.

  if avail familia then do:
    create  tt-fam.
    assign  tt-fam.codigo-orig    = familia.codigo-orig
            tt-fam.cd-trib-icm    = familia.cd-trib-icm
            tt-fam.cd-trib-ipi    = familia.cd-trib-ipi
            tt-fam.baixa-estoq    = familia.baixa-estoq
            tt-fam.fraciona       = familia.fraciona
            tt-fam.perm-saldo-neg = familia.perm-saldo-neg
            tt-fam.class-fiscal   = familia.class-fiscal.
  end.


  assign l-codigo-orig     = input frame {&frame-name} familia.codigo-orig  entered
         l-cd-trib-icm     = input frame {&frame-name} cb-cd-trib-icm       entered
         l-cd-trib-ipi     = input frame {&frame-name} cb-cd-trib-ipi       entered
         l-baixa-estoq     = input frame {&frame-name} familia.baixa-estoq  entered
         l-fraciona        = input frame {&frame-name} familia.fraciona     entered
         l-perm-saldo-neg  = input frame {&frame-name} cb-perm-saldo-neg    entered
         l-class-fiscal    = input frame {&frame-name} familia.class-fiscal entered.

/***************
message 
         " l-codigo-orig    " l-codigo-orig 
         " l-cd-trib-icm    " l-cd-trib-icm     
         " l-cd-trib-ipi    " l-cd-trib-ipi     
         " l-baixa-estoq    " l-baixa-estoq     
         " l-fraciona       " l-fraciona        
         " l-perm-saldo-neg " l-perm-saldo-neg  
         " l-class-fiscal   " l-class-fiscal    
         .
****************/

  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

/******* Integra‡Æo EMS x SISDOC ******/
  if i-integracao-sisdoc = ? then do:
     RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                 OUTPUT c-handle).
    run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
  end.

  if i-integracao-sisdoc = 3 then do:
     if adm-new-record then
        assign c-opcao-int = "inclui".
     else 
        assign c-opcao-int = "modifica".

     run cdp/cd2314.w (input rowid(item),
                       input ?,
                       input c-opcao-int,
                       input "bergen",
                       output i-retorno-erro).
     if  i-retorno-erro = 6 or
         i-retorno-erro = 7 then
         undo, return "ADM-ERROR":U.
   end.  /* if i-integracao-sisdoc = 3 */
   /***** Fim Integra‡Æo EMS x SISDOC ****/

if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */
  assign familia.cd-trib-icm    = {ininc/i07in122.i 06 cb-cd-trib-icm}
         familia.perm-saldo-neg = {ininc/i11in122.i 06 cb-perm-saldo-neg}
         familia.cd-trib-ipi    = {ininc/i10in172.i 06 cb-cd-trib-ipi}.

    /******************* Multi-Planta *********************/
    assign c-transacao = "MAT051".
    assign i-tipo-movto = 2.
    run pi-cria-tt-dados-familia (input i-tipo-movto).
    /*********************** Fim *************************/


  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Dispatch standard ADM method.                             */

/******* Integra‡Æo EMS x SISDOC ******/

  if  i-integracao-sisdoc = ? then do:
     RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                 OUTPUT c-handle).
    run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
  end.

  if  i-integracao-sisdoc = 2 then
      assign c-opcao-int = "nao-integra":U.
  if  i-integracao-sisdoc = 3 then
      assign c-opcao-int = "elimina":U.

  if  i-integracao-sisdoc = 2 or
      i-integracao-sisdoc = 3 then do:      
      run cdp/cd2314.w (input rowid(item),
                        input ?,
                        input c-opcao-int,
                        input "bergen",
                        output i-retorno-erro).
      if  i-retorno-erro = 5 or
          i-retorno-erro = 6 or
          i-retorno-erro = 7 then do:
          run notify ("pi-cancelar, tableio-source").
          return "ADM-ERROR":U.
      end.
  end.  /* if i-integracao-sisdoc = 2 or ...*/

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if avail familia then do with frame {&frame-name}:
     assign cb-cd-trib-icm:screen-value = {ininc/i07in122.i 04 familia.cd-trib-icm}.
     assign cb-perm-saldo-neg:screen-value = {ininc/i11in122.i 04 familia.perm-saldo-neg}.  
     assign cb-cd-trib-ipi:screen-value = {ininc/i10in172.i 04 familia.cd-trib-ipi}. 
  end.
  else do:
     assign cb-cd-trib-icm:screen-value = {ininc/i07in122.i 04 1}.
     assign cb-perm-saldo-neg:screen-value = {ininc/i11in122.i 04 1}. 
     assign cb-cd-trib-ipi:screen-value = {ininc/i10in172.i 04 1}.
  end.      

  find classif-fisc
        where classif-fisc.class-fiscal =  familia.class-fiscal no-lock no-error.
  if  avail classif-fisc then
      assign fi-desc-class-fisc:screen-value = classif-fisc.descricao.

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

  /******* Integra‡Æo EMS x SISDOC ******/

if not adm-new-record then do:
   if  i-integracao-sisdoc = ? then do:
    RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                OUTPUT c-handle).
    run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
   end.

   if  i-integracao-sisdoc = 2 then do:
       assign c-opcao-int = "nao-integra":U.
       run cdp/cd2314.w (input rowid(item),
                         input ?,
                         input c-opcao-int,
                         input "bergen",
                         output i-retorno-erro).
       if  i-retorno-erro = 5 or
           i-retorno-erro = 6 or
           i-retorno-erro = 7 then do:
           run notify ("pi-cancelar, tableio-source").
           return "ADM-ERROR":U.
       end.  /* if i-retorno-erro = 5 or ... */    
   end.  /* if i-integracao-sisdoc = 2 */     
end.  /* if not adm-new-record */

/***** Fim Integra‡Æo EMS x SISDOC ****/

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if l-codigo-orig  
  or l-cd-trib-icm       
  or l-cd-trib-ipi       
  or l-baixa-estoq  
  or l-fraciona     
  or l-perm-saldo-neg    
  or l-class-fiscal then do:
    run rep/re9001.w (output c-exp-opcao).
    find first item where item.fm-codigo = familia.fm-codigo no-lock no-error.
    if avail item then do:
     if c-exp-opcao = "2" then do:
       for each item use-index familia where
          item.fm-codigo = familia.fm-codigo EXCLUSIVE-LOCK:
          assign c-valido = "sim".      
          if l-codigo-orig  then
             assign item.codigo-orig = familia.codigo-orig.
          if l-cd-trib-ipi  then
             assign item.cd-trib-ipi = familia.cd-trib-ipi.
          if l-cd-trib-icm  then 
             assign item.cd-trib-icm = familia.cd-trib-icm.
          if l-baixa-estoq  then
             assign item.baixa-estoq = familia.baixa-estoq.
          if l-fraciona  then
             assign item.fraciona = familia.fraciona.
          if l-perm-saldo-neg  then
             assign item.perm-saldo-neg = familia.perm-saldo-neg.
          if l-class-fiscal  then do:
             find first classif-fisc where 
                  classif-fisc.class-fiscal = familia.class-fiscal no-lock no-error.
             if avail classif-fisc then
                assign item.class-fiscal = familia.class-fiscal
                       item.aliquota-ipi = classif-fisc.aliquota-ipi.
          end.   
          /******************* Multi-Planta *********************/
          assign c-transacao = "MAT040".
          {cdp/cd7300.i5 "001" c-transacao}

          assign i-tipo-movto = 2.

          run pi-cria-tt-dados-item (input i-tipo-movto).

          {cdp/cd7300.i6 "001" c-transacao}
          /*********************** Fim *************************/

       end.

     end.
     else do:
       if c-exp-opcao = "3" then do:
               assign g-rw-item = rowid(item).        
               RUN rep/re9002.w(input l-codigo-orig,
                                input l-cd-trib-icm,     
                                input l-cd-trib-ipi,     
                                input l-baixa-estoq,     
                                input l-fraciona,        
                                input l-perm-saldo-neg,  
                                input l-class-fiscal).

       end.
       else do:
            if c-exp-opcao = "4" then do:
               find first tt-fam no-lock no-error.
               for each item use-index familia where item.fm-codigo = familia.fm-codigo EXCLUSIVE-LOCK:
                    assign l-gera-log = no.
                    if l-codigo-orig 
                    and tt-fam.codigo-orig = item.codigo-orig then
                       assign item.codigo-orig = familia.codigo-orig
                              l-gera-log = yes.
                    if  l-fraciona
                    and tt-fam.fraciona = item.fraciona then
                       assign item.fraciona = familia.fraciona
                              l-gera-log = yes.
                    if l-perm-saldo-neg
                    and tt-fam.perm-saldo-neg = item.perm-saldo-neg then
                       assign item.perm-saldo-neg = familia.perm-saldo-neg
                              l-gera-log = yes.
                    if l-baixa-estoq
                    and tt-fam.baixa-estoq = item.baixa-estoq then
                       assign item.baixa-estoq = familia.baixa-estoq
                              l-gera-log = yes.
                    if l-cd-trib-icm
                    and tt-fam.cd-trib-icm = item.cd-trib-icm then
                       assign item.cd-trib-icm = familia.cd-trib-icm
                              l-gera-log = yes.
                    if l-cd-trib-ipi
                    and tt-fam.cd-trib-ipi = item.cd-trib-ipi then
                       assign item.cd-trib-ipi = familia.cd-trib-ipi
                              l-gera-log = yes.
                    if l-class-fiscal
                    and tt-fam.class-fiscal = item.class-fiscal then
                       assign item.class-fiscal = familia.class-fiscal
                              l-gera-log = yes.

                    if l-gera-log then do:

                        /******************* Multi-Planta *********************/
                       assign c-transacao = "MAT040".                       
                       assign i-tipo-movto = 2.                       
                       run pi-cria-tt-dados-item (input i-tipo-movto).
                       /*********************** Fim *************************/

                    end.                  
               end.                                                           
            end.                 
       end.
     end.
    end.
    else if not avail item and c-exp-opcao <> "1" then 
            run utp/ut-msgs.p (input "show",
                               input 5873,
                               input "").
  end.

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

   do with frame {&frame-name}:
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE c-lista AS CHARACTER  NO-UNDO.

        assign c-lista = {ininc/i07in122.i 03}.
	    run utp/ut-lstit.p (input-output c-lista).
        assign cb-cd-trib-icm:LIST-ITEM-PAIRS    = c-lista.

        assign c-lista = {ininc/i11in122.i 03}.
	    run utp/ut-lstit.p (input-output c-lista).
        assign cb-perm-saldo-neg:LIST-ITEM-PAIRS = c-lista.

        assign c-lista = {ininc/i10in172.i 03}.
	    run utp/ut-lstit.p (input-output c-lista).
        assign cb-cd-trib-ipi:LIST-ITEM-PAIRS    = c-lista.

    &else
        assign cb-cd-trib-icm:list-items    = {ininc/i07in122.i 03}
               cb-perm-saldo-neg:list-items = {ininc/i11in122.i 03}
               cb-cd-trib-ipi:list-items    = {ininc/i10in172.i 03}. 
    &endif
  end.  

  assign c-exp-opcao = "0".

  {utp/ut-field.i mgind item perm-saldo-neg 1}
  assign cb-perm-saldo-neg:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i C¢digo_Tributa‡Æo_IPI * R}
  assign cb-cd-trib-ipi:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i C¢digo_Tributa‡Æo_ICMS * R}
  assign cb-cd-trib-icm:label in frame {&FRAME-NAME} = trim(return-value).


  find first param-global no-lock no-error.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


  /*{utp/ut-liter.i Movimento_de_Acabado * R}
 *  assign l-acabado:label in frame {&frame-name} = return-value.
 *  {utp/ut-rtlbl.i mgind familia codigo-orig text-1}*/





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

  assign gr-familia = if  avail familia then rowid(familia)
                      else ?.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-familia V-table-Win 
PROCEDURE pi-cria-tt-dados-familia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter i-tipo-movto as integer.

if  param-global.modulo-mp then do:
    run cdp/cdapi150.p (input "familia" ,
                        input rowid(familia),
                        input i-tipo-movto,
                        input c-transacao,
                        input-output table tt-erro).
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-item V-table-Win 
PROCEDURE pi-cria-tt-dados-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter i-tipo-movto as integer.

if  param-global.modulo-mp then do:
    run cdp/cdapi150.p (input "item",
                        input rowid(item),
                        input i-tipo-movto,
                        input c-transacao,
                        input-output table tt-erro).                       
end.

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

   /*Segue um exemplo de valida‡Æo de programa 
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
  {src/adm/template/snd-list.i "familia"}

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

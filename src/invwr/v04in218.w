&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V04IN218 2.00.00.025}  /*** 010025 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i V04IN218 MUT}
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
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def buffer b-saldo for saldo-estoq.

def var dt-inspecao    as date no-undo.
def var c-op-des1      as char no-undo.
def var l-deleta-erros as logical no-undo.

DEF VAR l-leitura-item-fornec-estab AS LOGICAL NO-UNDO.

def var i-empresa like param-global.empresa-prin no-undo.

DEF VAR severa-normal-lote        AS INT NO-UNDO.
DEF VAR severa-normal-rejeitado   AS INT NO-UNDO.
DEF VAR normal-severa-lote        AS INT NO-UNDO.
DEF VAR normal-severa-rejeitado   AS INT NO-UNDO.
DEF VAR normal-atenuada-lote      AS INT NO-UNDO.
DEF VAR normal-atenuada-rejeitado AS INT NO-UNDO.
DEF VAR atenuada-normal-lote      AS INT NO-UNDO.
DEF VAR atenuada-normal-rejeitado AS INT NO-UNDO.

{cdp/cdcfgman.i}  /* Pre-Processadores */
{cep/ceapi001.i}
{cdp/cd0666.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-estoq item saldo-estoq
&Scoped-define FIRST-EXTERNAL-TABLE movto-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-estoq, item, saldo-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-estoq.un 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}un ~{&FP2}un ~{&FP3}
&Scoped-define ENABLED-TABLES movto-estoq
&Scoped-define FIRST-ENABLED-TABLE movto-estoq
&Scoped-Define ENABLED-OBJECTS rt-key c-conta rt-mold 
&Scoped-Define DISPLAYED-FIELDS movto-estoq.dt-trans ~
movto-estoq.serie-docto movto-estoq.nro-docto movto-estoq.it-codigo ~
item.desc-item movto-estoq.cod-estabel movto-estoq.cod-depos ~
item.cod-localiz movto-estoq.lote saldo-estoq.dt-vali-lote ~
movto-estoq.cod-refer movto-estoq.quantidade movto-estoq.un 
&Scoped-Define DISPLAYED-OBJECTS c-conta 

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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-conta AS CHARACTER FORMAT "x(17)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77.72 BY 4.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77.72 BY 10.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-estoq.dt-trans AT ROW 1.17 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     movto-estoq.serie-docto AT ROW 2.17 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     movto-estoq.nro-docto AT ROW 3.17 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-conta AT ROW 4.17 COL 26 COLON-ALIGNED
     movto-estoq.it-codigo AT ROW 5.67 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     item.desc-item AT ROW 5.67 COL 44.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 31.86 BY .88
     movto-estoq.cod-estabel AT ROW 6.67 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     movto-estoq.cod-depos AT ROW 7.67 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     item.cod-localiz AT ROW 8.67 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     movto-estoq.cod-localiz AT ROW 9.67 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     movto-estoq.lote AT ROW 10.67 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     saldo-estoq.dt-vali-lote AT ROW 11.67 COL 26 COLON-ALIGNED
          LABEL "":R29
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     movto-estoq.cod-refer AT ROW 12.67 COL 26 COLON-ALIGNED
          LABEL "":R12
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     movto-estoq.quantidade AT ROW 13.67 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     movto-estoq.un AT ROW 14.67 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 5.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.movto-estoq,mgind.item,movind.saldo-estoq
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
         HEIGHT             = 14.75
         WIDTH              = 77.86.
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

/* SETTINGS FOR FILL-IN movto-estoq.cod-depos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.cod-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.cod-localiz IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN movto-estoq.cod-refer IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN item.desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.dt-trans IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN saldo-estoq.dt-vali-lote IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN movto-estoq.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.nro-docto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.quantidade IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.serie-docto IN FRAME f-main
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-conta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta V-table-Win
ON F5 OF c-conta IN FRAME f-main
DO:
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = yes.

  {include/zoomvar.i &prog-zoom = adzoom/z01ad049.w
                     &campo     = c-conta
                     &campozoom = conta-contabil
                     &parametros="run pi-seta-est in wh-pesquisa (input input frame {&frame-name} movto-estoq.cod-estabel)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta IN FRAME f-main
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.un V-table-Win
ON F5 OF movto-estoq.un IN FRAME f-main /* Unid Medid */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in417.w"
                  &tabela=movto-estoq
                  &atributo=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.un IN FRAME f-main /* Unid Medid */
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

  /************************ INTERNAL PROCEDURES ********************/

{utp/ut-liter.i Conta MCQ L}
assign c-conta:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Localizaá∆o_Padr∆o MCQ L}
assign item.cod-localiz:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Data_de_Validade MCQ L}
assign saldo-estoq.dt-vali-lote:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Referància MCQ L}
assign movto-estoq.cod-refer:label in frame {&frame-name} = trim(return-value).

if  movto-estoq.un:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if  c-conta:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "movto-estoq"}
  {src/adm/template/row-list.i "item"}
  {src/adm/template/row-list.i "saldo-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-estoq"}
  {src/adm/template/row-find.i "item"}
  {src/adm/template/row-find.i "saldo-estoq"}

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a validaá∆o de chave duplicada */

  /* Ponha aqui as demais validaá‰es */

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

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

  find first param-global no-lock no-error.
  find first param-cq     no-lock no-error.
  find first param-estoq  no-lock no-error.
  find item where item.it-codigo = ficha-cq.it-codigo no-lock no-error.

  disp ficha-cq.serie-docto @ movto-estoq.serie-docto
       ficha-cq.nro-docto   @ movto-estoq.nro-docto
       dt-inspecao          @ movto-estoq.dt-trans 
       ficha-cq.it-codigo   @ movto-estoq.it-codigo 
       c-conta
       item.desc-item
       ficha-cq.cod-estabel @ movto-estoq.cod-estabel
       ficha-cq.cod-depos   @ movto-estoq.cod-depos
       item.cod-localiz
       ficha-cq.cod-localiz @ movto-estoq.cod-localiz
       ficha-cq.lote        @ movto-estoq.lote with frame {&frame-name}.

  /* HABILITA E MOSTRA OS CAMPOS QUANDO A OPÄ«O DE RETORNO FOR = PERDA */
  if  c-op-des1 = "4" then do:      
      if  item.tipo-con-est = 2
          then disp 1 @ movto-estoq.quantidade with frame {&frame-name}.
          else disp 0 @ movto-estoq.quantidade with frame {&frame-name}.

      if  item.tipo-con-est <> 2 then
          enable movto-estoq.quantidade with frame {&frame-name}.
      if  input frame {&frame-name} movto-estoq.serie-docto = "" then
          enable movto-estoq.serie-docto with frame {&frame-name}.
      if  input frame {&frame-name} movto-estoq.nro-docto = "" then
          enable movto-estoq.nro-docto with frame {&frame-name}.

      enable movto-estoq.dt-trans with frame {&frame-name}.
      apply 'entry' to movto-estoq.dt-trans in frame {&frame-name}.
  end.

  /* HABILITA E MOSTRA OS CAMPO QUANDO A OPÄ«O DE RETORNO FOR = REJEITADO */
  if  c-op-des1 = "3" then do:
      if  ficha-cq.origem = 2
      or (ficha-cq.origem = 1 and ficha-cq.baixa-estoq = yes)
      or (ficha-cq.origem = 3 and ficha-cq.baixa-estoq = yes) then do:
         if  item.tipo-con-est <> 2 then
             enable movto-estoq.quantidade with frame {&frame-name}.
      end.
      else
          disp ficha-cq.qt-original  - ficha-cq.qt-aprovada
             - ficha-cq.qt-consumida - ficha-cq.qt-rejeitada
             - ficha-cq.qt-apr-cond  @ movto-estoq.quantidade
             with frame {&frame-name}.
  end.

  find first saldo-estoq use-index estabel-dep
       where saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel
       and   saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos
       and   saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz
       and   saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote
       and   saldo-estoq.it-codigo   = item.it-codigo 
       no-lock no-error.
  if  not avail saldo-estoq then do:
      run utp/ut-msgs.p (input "show", input 1366, input "").
      return 'error'.
  end.
  if  item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
      disp saldo-estoq.cod-refer @ movto-estoq.cod-refer with frame {&frame-name}.

      find first b-saldo use-index lote
          where  b-saldo.lote      = input frame {&frame-name} movto-estoq.lote
          and    b-saldo.it-codigo = item.it-codigo
          no-lock no-error.
      if  avail b-saldo then
          disp b-saldo.dt-vali-lote @ saldo-estoq.dt-vali-lote
          with frame {&frame-name}.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorno V-table-Win 
PROCEDURE pi-retorno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param r-ficha-cq  as rowid no-undo.
    def input param de-inspecao as date  no-undo.
    def input param c-op-des    as char  no-undo.

    assign dt-inspecao = de-inspecao
           c-op-des1   = c-op-des.
    find ficha-cq where rowid(ficha-cq) = r-ficha-cq no-lock no-error.
    if  avail ficha-cq then run local-enable-fields.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica V-table-Win 
PROCEDURE pi-verifica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param r-ficha-cq    as rowid no-undo.
    def input param c-op-des      as char  no-undo.
    def var         i-insp        as integer no-undo.
    def var         i-var-aux     as integer no-undo.
    def var         i-var-aux-tot as integer no-undo.

    find first param-global no-lock no-error.
    find ficha-cq where rowid(ficha-cq) = r-ficha-cq no-lock no-error.
    find item
        where item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo no-lock no-error.

    find first saldo-estoq use-index estabel-dep
         where saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel
         and   saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos
         and   saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz
         and   saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote
         and   saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
         no-lock no-error.
    if  not avail saldo-estoq then do:
        run utp/ut-msgs.p (input "show", input 1366, input "").
        return error.
    end.

    assign i-empresa = param-global.empresa-prin.

    &if defined (bf_dis_consiste_conta) &then

        find estabelec where
             estabelec.cod-estabel = saldo-estoq.cod-estabel no-lock no-error.

        run cdp/cd9970.p (input rowid(estabelec),
                          output i-empresa).
    &endif

    find conta-contab
        where conta-contab.ep-codigo      = i-empresa
        and   conta-contab.conta-contabil = input frame {&frame-name} c-conta
        no-lock no-error.
    if  not avail conta-contab then do:
        run utp/ut-msgs.p (input "show", input 1060, input "").
        return error.
    end.
    if  conta-contab.estado <> 3 then do:
        run utp/ut-msgs.p (input "show", input 21, input "").
        return error.
    end.
    if  conta-contab.estoque = 9 then do:
        run utp/ut-msgs.p (input "show", input 1375, input "").
        return error.
    end.

    if  (item.tipo-contr = 4 or item.tipo-contr = 1 or item.it-codigo = "")
    and ficha-cq.nat-operacao <> "" then do:
        find first item-doc-est
            {cdp/cd8900.i "item-doc-est" "ficha-cq"}
            and item-doc-est.nr-ficha = ficha-cq.nr-ficha no-lock no-error.
        if  not avail item-doc-est then do:
            run utp/ut-msgs.p (input "show", input 1367, input "").
            return error.
        end.
    end.

    if  input frame {&frame-name} movto-estoq.quantidade <= 0 then do:
        run utp/ut-msgs.p (input "show", input 1368, input "").
        return error.    
    end.
    if  not item.fraciona and input frame {&frame-name} movto-estoq.quantidade
        <> int(input frame {&frame-name} movto-estoq.quantidade) then do:
        run utp/ut-msgs.p (input "show", input 1304, input "").
        return error.
    end.
    if  item.tipo-contr <> 4 and item.tipo-contr <> 1
    and item.it-codigo  <> "" then do:
        if  input frame {&frame-name} movto-estoq.quantidade > saldo-estoq.qtidade-atu
        or  ficha-cq.qt-original - ficha-cq.qt-consumida
          - ficha-cq.qt-aprovada - ficha-cq.qt-rejeitada
          - ficha-cq.qt-apr-cond < input frame {&frame-name} movto-estoq.quantidade then do:
            run utp/ut-msgs.p (input "show", input 1303, input "").
            return error.
        end.
    end.
    else do:
        if  ficha-cq.qt-original - ficha-cq.qt-consumida
          - ficha-cq.qt-aprovada - ficha-cq.qt-rejeitada
          - ficha-cq.qt-apr-cond < input frame {&frame-name} movto-estoq.quantidade then do:
            run utp/ut-msgs.p (input "show", input 1303, input "").
            return error.
        end.
    end.

    if  input frame {&frame-name} movto-estoq.un <> item.un then do:
        run utp/ut-msgs.p (input "show", input 1225, input "").
        return error.
    end.
    if  item.tipo-contr = 4 or item.tipo-contr = 1 or item.it-codigo = "" then do:
        create tt-movto.
        assign tt-movto.cod-versao-integracao = 1
               tt-movto.dt-trans       = input frame {&frame-name} movto-estoq.dt-trans
               tt-movto.serie-docto    = input frame {&frame-name} movto-estoq.serie-docto
               tt-movto.nro-docto      = input frame {&frame-name} movto-estoq.nro-docto
               tt-movto.ct-codigo      = substr(input frame {&frame-name} c-conta,1,8)
               tt-movto.sc-codigo      = substr(input frame {&frame-name} c-conta,9,16)
               tt-movto.conta-contabil = input frame {&frame-name} c-conta
               tt-movto.it-codigo      = ficha-cq.it-codigo
               tt-movto.cod-estabel    = ficha-cq.cod-estabel
               tt-movto.cod-depos      = ficha-cq.cod-depos
               tt-movto.cod-localiz    = ficha-cq.cod-localiz
               tt-movto.lote           = ficha-cq.lote
               tt-movto.cod-refer      = input frame {&frame-name} movto-estoq.cod-refer
               tt-movto.quantidade     = input frame {&frame-name} movto-estoq.quantidade
               tt-movto.un             = if ficha-cq.nat-operacao <> ""
                                            then item-doc-est.un else item.un
               tt-movto.tipo-trans     = 2
               tt-movto.esp-docto      = if c-op-des = "3" then 28 else 25
               tt-movto.descricao-db   = ficha-cq.narrativa
               tt-movto.cod-prog-orig  = "v06in218"
               tt-movto.usuario        = c-seg-usuario
               tt-movto.cod-emitente   = ficha-cq.cod-emitente
               l-deleta-erros          = yes.

        run cep/ceapi001.p (input-output table tt-movto,
                            input-output table tt-erro,
                            input        l-deleta-erros).

        /* CHAMADA DO BROWSE QUE MOSTRA AS INCONSIST“NCIAS DE CRIAÄ«O DO MOVTO-ESTOQ */
        find first tt-erro no-error.
        if  avail tt-erro then run cdp/cd0666.w (input table tt-erro).

        /* Localiza o movimento de estoque gerado, se n∆o houve erro */
        find first tt-movto no-error.
        find movto-estoq where rowid(movto-estoq) = r-mov-inv no-lock no-error.
        if  not avail movto-estoq then return 'adm-error'.
    end.
    else do:
        create tt-movto.
        assign tt-movto.cod-versao-integracao = 1
               tt-movto.dt-trans       = input frame {&frame-name} movto-estoq.dt-trans
               tt-movto.serie-docto    = input frame {&frame-name} movto-estoq.serie-docto
               tt-movto.nro-docto      = input frame {&frame-name} movto-estoq.nro-docto
               tt-movto.conta-contabil = input frame {&frame-name} c-conta
               tt-movto.ct-codigo      = substr(input frame {&frame-name} c-conta,1,8)
               tt-movto.sc-codigo      = substr(input frame {&frame-name} c-conta,9,16)
               tt-movto.it-codigo      = input frame {&frame-name} movto-estoq.it-codigo
               tt-movto.cod-estabel    = input frame {&frame-name} movto-estoq.cod-estabel
               tt-movto.cod-depos      = input frame {&frame-name} movto-estoq.cod-depos
               tt-movto.cod-localiz    = input frame {&frame-name} movto-estoq.cod-localiz
               tt-movto.lote           = input frame {&frame-name} movto-estoq.lote
               tt-movto.cod-refer      = input frame {&frame-name} movto-estoq.cod-refer
               tt-movto.quantidade     = input frame {&frame-name} movto-estoq.quantidade
               tt-movto.un             = input frame {&frame-name} movto-estoq.un
               tt-movto.tipo-trans     = 2
               tt-movto.esp-docto      = 28
               tt-movto.descricao-db   = ficha-cq.narrativa
               tt-movto.cod-prog-orig  = "v04in218"
               tt-movto.cod-emitente   = ficha-cq.cod-emitente
               tt-movto.usuario        = c-seg-usuario
               l-deleta-erros          = yes.

        run cep/ceapi001.p (input-output table tt-movto,
                            input-output table tt-erro,
                            input        l-deleta-erros).

        /* CHAMADA DO BROWSE QUE MOSTRA AS INCONSIST“NCIAS DE CRIAÄ«O DO MOVTO-ESTOQ */
        find first tt-erro no-error.
        if  avail tt-erro then run cdp/cd0666.w (input table tt-erro).

        /* Localiza o movimento de estoque gerado, se n∆o houve erro */
        find first tt-movto no-error.
        find movto-estoq where rowid(movto-estoq) = r-mov-inv no-lock no-error.
        if  not avail movto-estoq then return 'adm-error'.

        /* RECµLCULO DO PLANEJAMENTO */
        if  param-global.modulo-pl then do:
            run cdp/cd7000.p (input 1, input movto-estoq.it-codigo, movto-estoq.cod-estabel).
        end.

        /* ATUALIZAÄ«O DO CUNSUMO */
        run cdp/cd9750.p (input rowid(movto-estoq)).

        assign i-empresa = param-global.empresa-prin.

        &if defined (bf_dis_consiste_conta) &then

            find estabelec where
                 estabelec.cod-estabel = movto-estoq.cod-estabel no-lock no-error.

            run cdp/cd9970.p (input rowid(estabelec),
                              output i-empresa).
        &endif

        if  not avail conta-contab then
            find conta-contab
                where conta-contab.ep-codigo      = i-empresa
                and   conta-contab.conta-contabil = input frame {&frame-name} c-conta
                no-lock no-error.
        if  avail conta-contab then
            if (conta-contab.estoque   = 1
            or  conta-contab.estoque   = 3
            or  conta-contab.estoque   = 6)
            and movto-estoq.tipo-trans = 2
            and (item.data-ult-sai     = ?
            or   item.data-ult-sai     = movto-estoq.dt-trans) then
                assign item.data-ult-sai = movto-estoq.dt-trans.
    end.
    assign ficha-cq.qt-consumida = ficha-cq.qt-consumida
                                 + input frame {&frame-name} movto-estoq.quantidade.
    if  ficha-cq.qt-original  - ficha-cq.qt-aprovada
      - ficha-cq.qt-consumida - ficha-cq.qt-rejeitada
      - ficha-cq.qt-apr-cond <= 0 then
        assign ficha-cq.inspecionado = yes
               ficha-cq.situacao     = 4.
    if  ficha-cq.qt-a-liberar = 0
    and ficha-cq.inspecionado then
        assign ficha-cq.liberada = yes.

    {cdp/cd9320.i} /* Atualiza relaá∆o Item/Fornecedor */

    if  input frame {&frame-name} movto-estoq.dt-trans > ficha-cq.dt-inspecao
    or  ficha-cq.dt-inspecao = ? then
        assign ficha-cq.dt-inspecao = input frame {&frame-name} movto-estoq.dt-trans.

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
  {src/adm/template/snd-list.i "movto-estoq"}
  {src/adm/template/snd-list.i "item"}
  {src/adm/template/snd-list.i "saldo-estoq"}

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



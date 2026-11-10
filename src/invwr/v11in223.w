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
{include/i-prgvrs.i V11IN223 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V11IN223 MUT}
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
def var de-lim-inferior as decimal no-undo.
def var de-lim-superior as decimal no-undo.
def var de-valor        as decimal no-undo.
def var l-passou        as l init no no-undo.
def var de-valor-mat like movto-pend.valor-mat no-undo.
def var de-valor-mob like movto-pend.valor-mob no-undo.

def var de-preco-unit      as decimal no-undo.
def var de-desconto        as decimal no-undo.
def var de-val-contrato    as decimal no-undo.
def var de-val-aux         as decimal no-undo.
def var de-val-formula     as decimal no-undo.
def var de-vl-preuni       as decimal no-undo.
def var i-ordem            like ordem-compra.numero-ordem no-undo.
def var i-parcela          like prazo-compra.parcela no-undo.
def var de-qt-aux          like movto-pend.quantidade no-undo.
def var de-taxa            as decimal no-undo.

{cdp/cd4329.i2}  /* Aloca/Desaloca parcela de Compra */
{cdp/cdcfgmat.i} /* Pre-Processadores Materiais      */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-pend
&Scoped-define FIRST-EXTERNAL-TABLE movto-pend


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-pend.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-pend.un movto-pend.quantidade 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}un ~{&FP2}un ~{&FP3}~
 ~{&FP1}quantidade ~{&FP2}quantidade ~{&FP3}
&Scoped-define ENABLED-TABLES movto-pend
&Scoped-define FIRST-ENABLED-TABLE movto-pend
&Scoped-Define ENABLED-OBJECTS rt-key de-preco-total de-proporcao RECT-6 
&Scoped-Define DISPLAYED-FIELDS movto-pend.un movto-pend.quantidade ~
movto-pend.valor-mat[1] movto-pend.valor-mat[2] movto-pend.valor-mat[3] ~
movto-pend.valor-mob[1] movto-pend.valor-mob[2] movto-pend.valor-mob[3] 
&Scoped-Define DISPLAYED-OBJECTS c-desc-tab de-preco-total de-proporcao ~
c-moeda c-moeda1 c-moeda2 

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
DEFINE VARIABLE c-desc-tab AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE c-moeda1 AS CHARACTER FORMAT "x(20)":U 
      VIEW-AS TEXT 
     SIZE 17 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda2 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 13.29 BY .63 NO-UNDO.

DEFINE VARIABLE de-preco-total AS DECIMAL FORMAT ">>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17.72 BY .88 NO-UNDO.

DEFINE VARIABLE de-proporcao AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.29 BY 5.08.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.29 BY 6.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-pend.un AT ROW 2.17 COL 37.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     c-desc-tab AT ROW 2.17 COL 43.57 COLON-ALIGNED NO-LABEL
     movto-pend.quantidade AT ROW 3.17 COL 37.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     de-preco-total AT ROW 4.17 COL 37.86 COLON-ALIGNED
     de-proporcao AT ROW 5.17 COL 37.86 COLON-ALIGNED
     movto-pend.valor-mat[1] AT ROW 9.71 COL 15.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     movto-pend.valor-mat[2] AT ROW 9.71 COL 41.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     movto-pend.valor-mat[3] AT ROW 9.71 COL 66.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     movto-pend.valor-mob[1] AT ROW 10.71 COL 15.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     movto-pend.valor-mob[2] AT ROW 10.71 COL 41.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     movto-pend.valor-mob[3] AT ROW 10.71 COL 66.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     c-moeda AT ROW 8.67 COL 17 COLON-ALIGNED NO-LABEL
     c-moeda1 AT ROW 8.67 COL 42.14 COLON-ALIGNED NO-LABEL
     c-moeda2 AT ROW 8.67 COL 69.72 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     RECT-6 AT ROW 7.58 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.movto-pend
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
         HEIGHT             = 11.67
         WIDTH              = 86.86.
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

/* SETTINGS FOR FILL-IN c-desc-tab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.valor-mat[1] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.valor-mat[2] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.valor-mat[3] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.valor-mob[1] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.valor-mob[2] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.valor-mob[3] IN FRAME f-main
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

&Scoped-define SELF-NAME de-preco-total
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-preco-total V-table-Win
ON LEAVE OF de-preco-total IN FRAME f-main
DO:
  if input frame {&frame-name} de-preco-total > 0 then 
      enable movto-pend.valor-mat[1]
             movto-pend.valor-mob[1] with frame {&frame-name}.
  else 
      disable movto-pend.valor-mat[1]
              movto-pend.valor-mob[1] with frame {&frame-name}.
  assign movto-pend.valor-mat[1]:screen-value in frame {&frame-name} = 
                                 string(round((input frame {&frame-name} de-preco-total
                                        * input frame {&frame-name} de-proporcao / 100), 2))
         movto-pend.valor-mob[1]:screen-value in frame {&frame-name} = 
                                 string(input frame {&frame-name} de-preco-total
                                        - input frame {&frame-name} movto-pend.valor-mat[1]).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-proporcao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-proporcao V-table-Win
ON LEAVE OF de-proporcao IN FRAME f-main
DO:
  apply "leave" to de-preco-total in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.quantidade V-table-Win
ON LEAVE OF movto-pend.quantidade IN FRAME f-main /* Qtde */
DO:
  RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "numero-ordem":U).
  assign i-ordem = integer(return-value).
  find ordem-compra where
       ordem-compra.numero-ordem = i-ordem no-lock no-error.
  if avail ordem-compra then do:
      
      /* pi-preco-unit-ordem */
      run rep/re1908.p (rowid(ordem-compra),
                        docum-est.dt-emissao,
                        output de-preco-unit,  
                        output de-desconto,
                        output de-taxa).
      if param-global.modulo-cn then do:
          run cnp/cn9060.p (&IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
                                INPUT 0,
                            &ENDIF
                            ?,
                            i-ordem,
                            0,
                            no,
                            input frame {&frame-name} movto-pend.quantidade,
                            docum-est.dt-emissao,
                            output de-val-contrato,
                            output de-val-aux,
                            output de-val-formula,
                            output de-val-aux).

          if de-val-formula > 0 then
              assign de-preco-unit = de-val-formula /* /
                                     (input frame {&frame-name} movto-pend.quantidade +
                                     int(input frame {&frame-name} movto-pend.quantidade = 0)) */
                     de-desconto   = 0.
          else
          if de-val-contrato > 0 then
               assign de-preco-unit = de-val-contrato /* /    
                                    (input frame {&frame-name} movto-pend.quantidade +
                                     int(input frame {&frame-name} movto-pend.quantidade = 0)) */
                      de-desconto   = 0.
      end.
      assign de-vl-preuni = de-preco-unit - de-desconto
             de-preco-total:screen-value in frame {&frame-name} = string(input frame {&frame-name} movto-pend.quantidade *
                                                                  de-vl-preuni).
      /* fim pi-preco-unit-ordem */
      
  end.        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.un V-table-Win
ON F5 OF movto-pend.un IN FRAME f-main /* Unid */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in417.w"
                   &tabela=movto-pend
                   &atributo=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.un V-table-Win
ON LEAVE OF movto-pend.un IN FRAME f-main /* Unid */
DO:
  {include/leave.i &tabela=tab-unidade
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-tab
                   &where="tab-unidade.un = input frame {&frame-name} movto-pend.un"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-pend.un IN FRAME f-main /* Unid */
DO:
  apply "5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.valor-mat[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.valor-mat[1] V-table-Win
ON LEAVE OF movto-pend.valor-mat[1] IN FRAME f-main /* Valor Mat[1] */
DO:
    if  param-estoq.tem-moeda1 then do with frame {&frame-name}:
        run cdp/cd0813.p (input 0, input 1, input movto-pend.valor-mat[1], 
                          input docum-est.dt-trans, output de-valor).
        assign movto-pend.valor-mat[2]:screen-value = if de-valor = ? then "0"
                                                      else string(de-valor).
    end.
    if  param-estoq.tem-moeda2 then do with frame {&frame-name}:
        run cdp/cd0813.p (input 0, input 2, input movto-pend.valor-mat[1], 
                          input docum-est.dt-trans, output de-valor).
        assign movto-pend.valor-mat[3]:screen-value = if de-valor = ? then "0"
                                                      else string(de-valor).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.valor-mob[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.valor-mob[1] V-table-Win
ON LEAVE OF movto-pend.valor-mob[1] IN FRAME f-main /* Valor MOB[1] */
DO:
    if  param-estoq.tem-moeda1 then do with frame {&frame-name}:
        run cdp/cd0813.p (input 0, input 1, input movto-pend.valor-mob[1], 
                          input docum-est.dt-trans, output de-valor).
        assign movto-pend.valor-mob[2]:screen-value = if de-valor = ? then "0"
                                                      else string(de-valor).
    end.
    if  param-estoq.tem-moeda2 then do with frame {&frame-name}:
        run cdp/cd0813.p (input 0, input 2, input movto-pend.valor-mob[1], 
                          input docum-est.dt-trans, output de-valor).
        assign movto-pend.valor-mob[3]:screen-value = if de-valor = ? then "0"
                                                      else string(de-valor).
    end.
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

  find first param-estoq no-lock no-error.
  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
  if movto-pend.un:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "movto-pend"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-pend"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  {utp/ut-liter.i Material * L}
  assign movto-pend.valor-mat[1]:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i M∆o-de-Obra * L}
  assign movto-pend.valor-mob[1]:label in frame {&frame-name} = return-value.
           
  find moeda where moeda.mo-codigo = 0 no-lock no-error.
  if avail moeda then 
     assign c-moeda:screen-value in frame {&frame-name} = moeda.descricao.
  
  if param-estoq.tem-moeda1 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
     if avail moeda then 
        assign c-moeda1:screen-value in frame {&frame-name} = moeda.descricao.
  end.
   
  if param-estoq.tem-moeda2 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
     if avail moeda then 
        assign c-moeda2:screen-value in frame {&frame-name} = moeda.descricao.
  end.
  /* Code placed here will execute AFTER standard behavior.    */
  assign de-proporcao:screen-value in frame {&frame-name} = "100".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  RUN Get-Field-Screen-Value IN adm-broker-hdl
          (INPUT this-procedure, INPUT "numero-ordem":U).
  assign i-ordem = int(return-value).
  RUN Get-Field-Screen-Value IN adm-broker-hdl
          (INPUT this-procedure, INPUT "parcela":U).
  assign i-parcela = int(return-value).
  assign de-valor-mat[1] = input frame {&frame-name} movto-pend.valor-mat[1]
         de-valor-mat[2] = input frame {&frame-name} movto-pend.valor-mat[2]
         de-valor-mat[3] = input frame {&frame-name} movto-pend.valor-mat[3]
         de-valor-mob[1] = input frame {&frame-name} movto-pend.valor-mob[1]
         de-valor-mob[2] = input frame {&frame-name} movto-pend.valor-mob[2]
         de-valor-mob[3] = input frame {&frame-name} movto-pend.valor-mob[3]
         de-proporcao    = input frame {&frame-name} de-proporcao
         de-lim-inferior = 0
         de-lim-superior = 0
         de-lim-inferior = 0.
         
  if adm-new-record = no then
      assign de-qt-aux = movto-pend.quantidade.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
  assign movto-pend.valor-mat[1] = de-valor-mat[1]
         movto-pend.valor-mat[2] = de-valor-mat[2]
         movto-pend.valor-mat[3] = de-valor-mat[3]
         movto-pend.valor-mob[1] = de-valor-mob[1]
         movto-pend.valor-mob[2] = de-valor-mob[2]
         movto-pend.valor-mob[3] = de-valor-mob[3]
         movto-pend.dec-1        = de-proporcao.
    
  find prazo-compra
       where prazo-compra.numero-ordem = i-ordem
         and prazo-compra.parcela      = i-parcela
       exclusive-lock no-error.
  if avail prazo-compra then do:
      if adm-new-record then 
          run pi-aloca-ordem-cc (input yes,
                                 input movto-pend.quantidade,
                                 input rowid(prazo-compra)).
      else do:
          run pi-aloca-ordem-cc (input no,
                                 input de-qt-aux,
                                 input rowid(prazo-compra)).
          run pi-aloca-ordem-cc (input yes,
                                 input movto-pend.quantidade,
                                 input rowid(prazo-compra)).
      end.
  end.
  
         
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
  {utp/ut-liter.i Material * L}
  assign movto-pend.valor-mat[1]:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i M∆o-de-Obra * L}
  assign movto-pend.valor-mob[1]:label in frame {&frame-name} = return-value.
           
  find moeda where moeda.mo-codigo = 0 no-lock no-error.
  if avail moeda then 
     assign c-moeda:screen-value in frame {&frame-name} = moeda.descricao.
  
  if param-estoq.tem-moeda1 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
     if avail moeda then 
        assign c-moeda1:screen-value in frame {&frame-name} = moeda.descricao.
  end.
   
  if param-estoq.tem-moeda2 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
     if avail moeda then 
        assign c-moeda2:screen-value in frame {&frame-name} = moeda.descricao.
  end.

  /* Code placed here will execute AFTER standard behavior.    */

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
  if avail movto-pend then 
      assign de-preco-total:screen-value in frame {&frame-name} = string(movto-pend.valor-mat[1] + 
                                                                         movto-pend.valor-mob[1])
             de-proporcao:screen-value in frame {&frame-name}   = string(movto-pend.dec-1,">>9,99")
             l-passou = no.
  else 
      assign de-proporcao:screen-value in frame {&frame-name} = "100".
                                                                         
  find docum-est where
       rowid(docum-est) = v-row-parent no-lock no-error.

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
  find first param-estoq no-lock no-error.
  find first param-global no-lock no-error.
  find param-re where 
       param-re.usuario = c-seg-usuario no-lock no-error.
  /* Dispatch standard ADM method.                             */
  
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-field.i mgind item-doc-est preco-total 01}
  assign de-preco-total:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Proporá∆o_Mat * L}
  assign de-proporcao:label in frame {&frame-name} = return-value.
  
             
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campo V-table-Win 
PROCEDURE pi-inicializa-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input param rw-parcela as rowid no-undo.
  
  find prazo-compra where rowid(prazo-compra) = rw-parcela no-lock no-error.
  find ordem-compra where ordem-compra.numero-ordem = prazo-compra.numero-ordem
       no-lock no-error.
  find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
  find familia where familia.fm-codigo = item.fm-codigo no-lock no-error.
  
  assign de-lim-inferior = prazo-compra.quantidade * familia.var-qtd-perm / 100
         de-lim-superior = (prazo-compra.quant-saldo - prazo-compra.dec-1) + de-lim-inferior
         de-lim-inferior = (prazo-compra.quant-saldo - prazo-compra.dec-1) - de-lim-inferior
         i-ordem         = ordem-compra.numero-ordem.
  if adm-new-record then do:
      display (prazo-compra.quant-saldo 
               - prazo-compra.dec-1)   @ movto-pend.quantidade
              prazo-compra.un          @ movto-pend.un
              with frame {&frame-name}.
  
      if avail ordem-compra then do:
          /* pi-preco-unit-ordem */
          run rep/re1908.p (rowid(ordem-compra),
                            docum-est.dt-emissao,
                            output de-preco-unit,  
                            output de-desconto,
                            output de-taxa).
          if param-global.modulo-cn then do:
              run cnp/cn9060.p (&IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
                                    INPUT 0,
                                &ENDIF
                                ?,
                                i-ordem,
                                0,
                                no,
                                input frame {&frame-name} movto-pend.quantidade,
                                docum-est.dt-emissao,
                                output de-val-contrato,
                                output de-val-aux,
                                output de-val-formula,
                                output de-val-aux).
                       
              if de-val-formula > 0 then
                  assign de-preco-unit = de-val-formula /* /
                                         (input frame {&frame-name} movto-pend.quantidade +
                                         int(input frame {&frame-name} movto-pend.quantidade = 0)) */
                         de-desconto   = 0.
              else
              if de-val-contrato > 0 then
                   assign de-preco-unit = de-val-contrato /* /    
                                        (input frame {&frame-name} movto-pend.quantidade +
                                         int(input frame {&frame-name} movto-pend.quantidade = 0)) */
                          de-desconto   = 0.
          end.
          
          assign de-vl-preuni = de-preco-unit - de-desconto
                 de-preco-total:screen-value in frame {&frame-name} = string(input frame {&frame-name} movto-pend.quantidade *
                                                                      de-vl-preuni)
                 movto-pend.valor-mat[1]:screen-value in frame {&frame-name} = 
                                     string(round((input frame {&frame-name} de-preco-total
                                            * input frame {&frame-name} de-proporcao / 100), 2))
                 movto-pend.valor-mob[1]:screen-value in frame {&frame-name} = 
                                     string(input frame {&frame-name} de-preco-total
                                        - input frame {&frame-name} movto-pend.valor-mat[1]).
                                                                  
      /* fim pi-preco-unit-ordem */
      
      end.
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
  if not l-passou then do:
      RUN Get-Field-Screen-Value IN adm-broker-hdl
          (INPUT this-procedure, INPUT "num-pedido"). 
  
      RUN Get-Field-Screen-Value IN adm-broker-hdl
          (INPUT this-procedure, INPUT "it-codigo").
      find item where item.it-codigo = return-value no-lock no-error.
      if input frame {&frame-name} movto-pend.un <> item.un 
      and item.tipo-contr <> 4 then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 1225, input "").
          apply "entry" to movto-pend.quantidade in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if input frame {&frame-name} movto-pend.un = " " or
         input frame {&frame-name} movto-pend.un <> item.un then do:
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show":U, 
                            input 1225, 
                            input return-value).
         return 'ADM-ERROR':U.
      end.
      if adm-new-record = no    and
         param-global.modulo-cc and
         i-ordem <> 0 then do:
          find prazo-compra where
               prazo-compra.numero-ordem = i-ordem and
               prazo-compra.parcela      = i-parcela
               no-lock no-error.
          find ordem-compra where 
               ordem-compra.numero-ordem = prazo-compra.numero-ordem
               no-lock no-error.
          find item where 
               item.it-codigo = ordem-compra.it-codigo no-lock no-error.
          find familia where 
               familia.fm-codigo = item.fm-codigo no-lock no-error.
          assign de-lim-inferior = prazo-compra.quantidade * familia.var-qtd-perm / 100
                 de-lim-superior = (prazo-compra.quant-saldo - prazo-compra.dec-1) + de-lim-inferior
                 de-lim-inferior = (prazo-compra.quant-saldo - prazo-compra.dec-1) - de-lim-inferior.
      end.
      
      if  param-global.modulo-cc 
      and avail ordem-compra 
      and input frame {&frame-name} movto-pend.quantidade > de-lim-inferior then do:
          if not param-re.aceita-var and not 
            (adm-new-record = no and 
             de-lim-inferior = 0 and    /* modificando uma parcela que n∆o tem mais saldo p/ alocar */
             input frame {&frame-name} movto-pend.quantidade = movto-pend.quantidade)
          then do:
             {include/i-vldprg.i} 
              run utp/ut-msgs.p (input "show":U, input 5517, input "").
              apply "entry" to movto-pend.quantidade in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.
          else if not (adm-new-record = no and 
                       de-lim-inferior = 0 and    /* modificando uma parcela que n∆o tem mais saldo p/ alocar */
                       input frame {&frame-name} movto-pend.quantidade = 
                       movto-pend.quantidade)
          then do:
              {include/i-vldprg.i}
              {utp/ut-liter.i Quantidade MRE R}
              run utp/ut-msgs.p (input "show":U, input 6164, input return-value).
              if  return-value = "yes" then do:
                  apply "entry" to movto-pend.quantidade in frame {&frame-name}.
                  return 'ADM-ERROR':U.
              end.    
          end.
      end.
      assign l-passou = yes.
  end.
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
  {src/adm/template/snd-list.i "movto-pend"}

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



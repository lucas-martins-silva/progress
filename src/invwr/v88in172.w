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
{include/i-prgvrs.i V88IN172 2.00.00.023}  /*** "010023" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v88in172 MUT}
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

def var i-mes-fec     as integer   format   99 no-undo.
def var i-ano-fec     as integer   format 9999 initial 0 no-undo.
def var dias          as integer   extent 12 no-undo initial [31,28,31,30,31,30,31,31,30,31,30,31].
def var d-aux         as date      format "99/99/9999".
def var l-saldo       as logical   initial no no-undo.
def var da-iniper-x   as date      format 99/99/9999 no-undo.
def var da-fimper-x   as date      format 99/99/9999 no-undo.
def var da-iniper-fech  like param-estoq.ult-fech-dia no-undo.
def var da-fimper-fech  like param-estoq.ult-fech-dia no-undo.
def var i-per-corrente as integer format "99".
def var i-ano-corrente as integer format "9999".
def var da-ult-per     like param-estoq.ult-per-fech no-undo.
def var da-mensal-ate  as date                       no-undo.

/*data para controle, semelhante ao uso do first-of*/
def var da-anterior    as date                       no-undo. /*data do movimento anterior*/

def var i-ano         as integer   format 9999 no-undo.
def var i-dia-mes     as integer   format   99 no-undo.
def var c-ext         as character format "x(9)" no-undo.
def var de-saldo-acum as decimal format "->>>>,>>>,>>9.99" no-undo.
def var de-inicial    as decimal format "->>>>,>>>,>>9.99" no-undo.
def var i-dia         as integer format "99" no-undo.
def var tabela        as character extent 12 no-undo initial ["  Janeiro","Fevereiro","    Mar‡o","    Abril",
                                                              "     Maio","    Junho","    Julho","   Agosto",
                                                              " Setembro","  Outubro"," Novembro"," Dezembro"].

def var i-medio   as integer init 1     no-undo.
def var i-moeda   as integer            no-undo.
def var c-estab   as char               no-undo.

def var de-consumo as decimal no-undo.

{cdp/cdcfgmat.i}

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 
&Scoped-Define DISPLAYED-OBJECTS de-ent-qt de-ent-val fi-data-ult-ent ~
de-sd-qt de-sd-val fi-data-ult-sai de-atual-qt de-atual-val de-med-qt ~
de-med-val de-exc-qt de-exc-val de-seg-qt de-seg-val c-quantidade ~
c-ultimo-movto c-valor 

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
DEFINE VARIABLE c-quantidade AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

DEFINE VARIABLE c-ultimo-movto AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-valor AS CHARACTER FORMAT "X(07)":U 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE de-atual-qt AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-atual-val AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-ent-qt AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-ent-val AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-exc-qt AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-exc-val AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-med-qt AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-med-val AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-sd-qt AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-sd-val AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-seg-qt AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-seg-val AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data-ult-ent AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data-ult-sai AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.86 BY 7.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-ent-qt AT ROW 2.25 COL 20.72 COLON-ALIGNED
     de-ent-val AT ROW 2.25 COL 44.72 COLON-ALIGNED NO-LABEL
     fi-data-ult-ent AT ROW 2.25 COL 68.57 COLON-ALIGNED NO-LABEL
     de-sd-qt AT ROW 3.25 COL 20.72 COLON-ALIGNED
     de-sd-val AT ROW 3.25 COL 44.72 COLON-ALIGNED NO-LABEL
     fi-data-ult-sai AT ROW 3.25 COL 68.57 COLON-ALIGNED NO-LABEL
     de-atual-qt AT ROW 4.25 COL 20.72 COLON-ALIGNED
     de-atual-val AT ROW 4.25 COL 44.72 COLON-ALIGNED NO-LABEL
     de-med-qt AT ROW 5.25 COL 20.72 COLON-ALIGNED
     de-med-val AT ROW 5.25 COL 44.72 COLON-ALIGNED NO-LABEL
     de-exc-qt AT ROW 6.25 COL 20.72 COLON-ALIGNED
     de-exc-val AT ROW 6.25 COL 44.72 COLON-ALIGNED NO-LABEL
     de-seg-qt AT ROW 7.25 COL 20.72 COLON-ALIGNED
     de-seg-val AT ROW 7.25 COL 44.72 COLON-ALIGNED NO-LABEL
     c-quantidade AT ROW 1.33 COL 24.72 COLON-ALIGNED NO-LABEL
     c-ultimo-movto AT ROW 1.33 COL 68.43 COLON-ALIGNED NO-LABEL
     c-valor AT ROW 1.38 COL 51.72 COLON-ALIGNED NO-LABEL
     RECT-3 AT ROW 1.08 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
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
         HEIGHT             = 7.58
         WIDTH              = 85.86.
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

/* SETTINGS FOR FILL-IN c-quantidade IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ultimo-movto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-valor IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-atual-qt IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-atual-val IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-ent-qt IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-ent-val IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-exc-qt IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-exc-val IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-med-qt IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-med-val IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-sd-qt IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-sd-val IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-seg-qt IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-seg-val IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-data-ult-ent IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-data-ult-sai IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

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

  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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

  {utp/ut-liter.i Quantidade * L}
  assign c-quantidade = return-value.
  {utp/ut-liter.i Valor * L}
  assign c-valor = return-value.
  {utp/ut-liter.i éltimo_Movto * L}
  assign c-ultimo-movto = return-value.
  {utp/ut-liter.i Entradas * L}
  assign de-ent-qt:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Sa¡das * L}
  assign de-sd-qt:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Saldo_Atual * L}
  assign de-atual-qt:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Saldo_M‚dio * L}
  assign de-med-qt:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Excedente * L}
  assign de-exc-qt:label in frame {&frame-name}= return-value.
  {utp/ut-liter.i Seguran‡a * L}
  assign de-seg-qt:label in frame {&frame-name} = return-value.

   /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
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

  &if defined(bf_mat_fech_estab) &then
    if param-estoq.tp-fech = 2 then do:
       find estab-mat where estab-mat.cod-estabel = c-estab no-lock no-error.
       if avail estab-mat then
          assign da-ult-per = estab-mat.ult-per-fech
                 da-mensal-ate = estab-mat.mensal-ate.
    end.
    else
       assign da-ult-per = param-estoq.ult-per-fech
              da-mensal-ate = param-estoq.mensal-ate.
  &else
     assign da-ult-per = param-estoq.ult-per-fech
            da-mensal-ate = param-estoq.mensal-ate.
  &endif

  run cdp/cdapi005.p (input  da-ult-per,
                      output da-iniper-x,
                      output da-fimper-x,
                      output i-per-corrente,
                      output i-ano-corrente,
                      output da-iniper-fech,
                      output da-fimper-fech).

  {cep/ce0827.i}
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-roda-include V-table-Win 
PROCEDURE pi-roda-include :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-c-estab as char    no-undo.
def input param p-i-moeda as integer no-undo.
def input param p-i-medio as integer no-undo.

assign c-estab = p-c-estab
       i-moeda = p-i-moeda
       i-medio = p-i-medio.

{cep/ce0827.i}

RUN dispatch IN THIS-PROCEDURE ('open-query':U).
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  {src/adm/template/snd-list.i "item"}

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


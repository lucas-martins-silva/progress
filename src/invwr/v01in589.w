&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V01IN589 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in589 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var de-qtd-up     as decimal no-undo.
def var de-vl-desp    as decimal no-undo.
def var c-handle-1    as handle  no-undo.
def var c-handle-2    as handle  no-undo.
def var c-handle-3    as handle  no-undo.
def var de-vl-debito  as decimal no-undo.

def var de-val-corrig as decimal no-undo.

def var c-container as char no-undo.
def var i-cont      as integer no-undo.
def var l-calcula   as logical no-undo.

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
&Scoped-define EXTERNAL-TABLES estabelec
&Scoped-define FIRST-EXTERNAL-TABLE estabelec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estabelec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-OBJECTS de-vl-total-1 de-vl-total-2 de-vl-total-3 ~
de-qtd-total-up-1 de-qtd-total-up-2 de-qtd-total-up-3 de-vl-unit-up-1 ~
de-vl-unit-up-2 de-vl-unit-up-3 c-moeda-1 c-moeda-2 c-moeda-3 c-text-vl-tot ~
c-text-qtd-up c-text-vl-unit-up 

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
DEFINE BUTTON bt-calc 
     LABEL "Calcular" 
     SIZE 13.14 BY 1.

DEFINE VARIABLE c-moeda-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-moeda-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-moeda-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-text-qtd-up AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16.72 BY .67 NO-UNDO.

DEFINE VARIABLE c-text-vl-tot AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16.72 BY .67 NO-UNDO.

DEFINE VARIABLE c-text-vl-unit-up AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16.72 BY .67 NO-UNDO.

DEFINE VARIABLE de-qtd-total-up-1 AS DECIMAL FORMAT "->,>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-total-up-2 AS DECIMAL FORMAT "->,>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-total-up-3 AS DECIMAL FORMAT "->,>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-total-1 AS DECIMAL FORMAT "->,>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-total-2 AS DECIMAL FORMAT "->,>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-total-3 AS DECIMAL FORMAT "->,>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-unit-up-1 AS DECIMAL FORMAT "->,>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-unit-up-2 AS DECIMAL FORMAT "->,>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-unit-up-3 AS DECIMAL FORMAT "->,>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 7.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-vl-total-1 AT ROW 2.58 COL 17.57 COLON-ALIGNED NO-LABEL
     de-vl-total-2 AT ROW 2.58 COL 39.57 COLON-ALIGNED NO-LABEL
     de-vl-total-3 AT ROW 2.58 COL 61.57 COLON-ALIGNED NO-LABEL
     de-qtd-total-up-1 AT ROW 4.13 COL 17.57 COLON-ALIGNED NO-LABEL
     de-qtd-total-up-2 AT ROW 4.13 COL 39.57 COLON-ALIGNED NO-LABEL
     de-qtd-total-up-3 AT ROW 4.13 COL 61.57 COLON-ALIGNED NO-LABEL
     de-vl-unit-up-1 AT ROW 5.88 COL 17.57 COLON-ALIGNED NO-LABEL
     de-vl-unit-up-2 AT ROW 5.88 COL 39.57 COLON-ALIGNED NO-LABEL
     de-vl-unit-up-3 AT ROW 5.88 COL 61.57 COLON-ALIGNED NO-LABEL
     bt-calc AT ROW 7.21 COL 71.86
     c-moeda-1 AT ROW 1.75 COL 17.72 COLON-ALIGNED NO-LABEL
     c-moeda-2 AT ROW 1.75 COL 39.86 COLON-ALIGNED NO-LABEL
     c-moeda-3 AT ROW 1.75 COL 61.72 COLON-ALIGNED NO-LABEL
     c-text-vl-tot AT ROW 2.58 COL 2.14 NO-LABEL
     c-text-qtd-up AT ROW 4.13 COL 2.14 NO-LABEL
     c-text-vl-unit-up AT ROW 5.88 COL 2.14 NO-LABEL
     rt-mold AT ROW 1 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.estabelec
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
         HEIGHT             = 7.58
         WIDTH              = 85.29.
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
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON bt-calc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-text-qtd-up IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-text-vl-tot IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-text-vl-unit-up IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN de-qtd-total-up-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtd-total-up-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtd-total-up-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-total-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-total-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-total-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-unit-up-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-unit-up-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-unit-up-3 IN FRAME f-main
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

&Scoped-define SELF-NAME bt-calc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-calc V-table-Win
ON CHOOSE OF bt-calc IN FRAME f-main /* Calcular */
DO:
 
   run pi-soma-desp   in c-handle-3 (output de-vl-desp).
   run pi-soma-debito in c-handle-2 (output de-vl-debito).
   run pi-calc-qtd-up in c-handle-1 (output de-qtd-up).


/*********************  MOEDA CORRENTE  *****************/


   assign 
         de-vl-total-1     = (de-vl-desp + de-vl-debito)
         de-qtd-total-up-1 = de-qtd-up
         de-vl-unit-up-1   = (de-vl-total-1) / (de-qtd-total-up-1).  

   
/***************     MOEDA ALTERNATIVA 1   ****************/   
   
   
   find first param-estoq no-lock.      
   find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock.
   
   run "cdp/cd0812.p" (input 0,
                       input moeda.mo-codigo,
                       input de-vl-desp,
                       input today,
                       output de-val-corrig).
   if  de-val-corrig = ? then 
       de-val-corrig = 0.

       
   assign 
         de-vl-total-2     = (de-val-corrig + de-vl-debito).
         de-qtd-total-up-2 = de-qtd-up.
         de-vl-unit-up-2   = (de-vl-total-2) / (de-qtd-total-up-2).

   
/***************     MOEDA ALTERNATIVA 2    ****************/


   find first param-estoq no-lock.      
   find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock.
   
   run "cdp/cd0812.p" (input 0,
                       input moeda.mo-codigo,
                       input de-vl-desp,
                       input today,
                       output de-val-corrig).
   if  de-val-corrig = ? then 
       de-val-corrig = 0.


   assign 
         de-vl-total-3     = (de-val-corrig + de-vl-debito) 
         de-qtd-total-up-3 = de-qtd-up
         de-vl-unit-up-3   = (de-vl-total-3) / (de-qtd-total-up-3).
         
   
   display de-vl-total-1     
           de-qtd-total-up-1 
           de-vl-unit-up-1   
           de-qtd-total-up-2   when param-estoq.tem-moeda1
           de-vl-total-2       when param-estoq.tem-moeda1
           de-vl-unit-up-2     when param-estoq.tem-moeda1 
           de-vl-total-3       when param-estoq.tem-moeda2
           de-qtd-total-up-3   when param-estoq.tem-moeda2
           de-vl-unit-up-3     when param-estoq.tem-moeda2
           with frame {&frame-name}.

assign l-calcula = yes.

RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT this-procedure,
     OUTPUT c-container).

run pi-l-calcula in widget-handle(c-container) (input-output l-calcula).

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
  {src/adm/template/row-list.i "estabelec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estabelec"}

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

find first param-estoq no-lock.

find moeda where
     moeda.mo-codigo = 0 
     no-lock.
assign c-moeda-1 = moeda.descricao.
if param-estoq.tem-moeda1 then do:
    find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock.
    assign c-moeda-2 = moeda.descricao.
end.
if param-estoq.tem-moeda2 then do:
    find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock.
    assign c-moeda-3 = moeda.descricao.
end.

{utp/ut-liter.i Valor_Total_UP mcs}
assign c-text-vl-tot = return-value.

{utp/ut-liter.i Quantidade_Total_UP mcs}
assign c-text-qtd-up = return-value.

{utp/ut-liter.i Valor_Unit rio_UP mcs}
assign c-text-vl-unit-up = return-value.

disp  c-text-vl-tot c-text-qtd-up c-text-vl-unit-up
      c-moeda-1 c-moeda-2 c-moeda-3
     with frame {&frame-name}.



  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-estabel V-table-Win 
PROCEDURE pi-atualiza-estabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  find current estabelec exclusive-lock.

  assign estabelec.val-unit-up[1]    = input frame {&frame-name} de-vl-unit-up-1
         estabelec.val-unit-up[2]    = input frame {&frame-name} de-vl-unit-up-2
         estabelec.val-unit-up[3]    = input frame {&frame-name} de-vl-unit-up-3
         estabelec.qtd-up-prod[1]    = input frame {&frame-name} de-qtd-total-up-1
         estabelec.qtd-up-prod[2]    = input frame {&frame-name} de-qtd-total-up-2
         estabelec.qtd-up-prod[3]    = input frame {&frame-name} de-qtd-total-up-3              
         estabelec.val-desp-total[1] = input frame {&frame-name} de-vl-total-1
         estabelec.val-desp-total[2] = input frame {&frame-name} de-vl-total-2
         estabelec.val-desp-total[3] = input frame {&frame-name} de-vl-total-3.

  find first param-estoq no-lock no-error.
  
  
  do  i-cont = 1 to 3 :
      if i-cont = 1 then do:
          find first historico-up EXCLUSIVE-LOCK where 
              historico-up.cod-estabel  = estabelec.cod-estabel and 
              historico-up.mo-codigo    = 0                     and
              historico-up.data-atualiz = today no-error.
          if  not avail historico-up then
              create historico-up.
          assign historico-up.cod-estabel     = estabelec.cod-estabel
                 historico-up.mo-codigo       = 0
                 historico-up.vl-unit-up      = input frame {&frame-name} 
                                                de-vl-unit-up-1
                 historico-up.val-desp-total  = input frame {&frame-name} 
                                                de-vl-total-1        
                 historico-up.qtd-up-prod     = input frame {&frame-name} 
                                                de-qtd-total-up-1.
      end.
      if i-cont = 2 then do:
         if  param-estoq.tem-moeda1 then do:
             find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock.
             find first historico-up EXCLUSIVE-LOCK where 
                  historico-up.cod-estabel  = estabelec.cod-estabel and 
                  historico-up.mo-codigo    = moeda.mo-codigo       and
                  historico-up.data-atualiz = today no-error.
              if  not avail historico-up then
                  create historico-up.
              assign historico-up.cod-estabel     = estabelec.cod-estabel
                     historico-up.mo-codigo       = moeda.mo-codigo
                     historico-up.vl-unit-up      = input frame {&frame-name} 
                                                    de-vl-unit-up-2
                     historico-up.val-desp-total  = input frame {&frame-name} 
                                                    de-vl-total-2        
                     historico-up.qtd-up-prod     = input frame {&frame-name} 
                                                    de-qtd-total-up-2.
         end.
      end.
      if i-cont = 3 then do:
         if  param-estoq.tem-moeda2 then do:
             find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock.
             find first historico-up EXCLUSIVE-LOCK where 
                  historico-up.cod-estabel  = estabelec.cod-estabel and 
                  historico-up.mo-codigo    = moeda.mo-codigo       and
                  historico-up.data-atualiz = today  no-error.
              if  not avail historico-up then
                  create historico-up.
              assign historico-up.cod-estabel     = estabelec.cod-estabel
                     historico-up.mo-codigo       = moeda.mo-codigo
                     historico-up.vl-unit-up      = input frame {&frame-name} 
                                                    de-vl-unit-up-3
                     historico-up.val-desp-total  = input frame {&frame-name} 
                                                    de-vl-total-3        
                     historico-up.qtd-up-prod     = input frame {&frame-name} 
                                                    de-qtd-total-up-3.
         end.
      end.            
  end.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-handle V-table-Win 
PROCEDURE pi-envia-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter h-b78in172 as handle no-undo.
def input parameter h-b03in142 as handle no-undo.
def input parameter h-b04in142 as handle no-undo.

assign c-handle-1 = h-b78in172
       c-handle-2 = h-b03in142
       c-handle-3 = h-b04in142.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita V-table-Win 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter l-habilita as logical no-undo.

 assign  bt-calc:sensitive in frame {&frame-name} = l-habilita.
 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zera-dados V-table-Win 
PROCEDURE pi-zera-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign de-vl-unit-up-1:screen-value    in frame {&frame-name} = ""
       de-vl-unit-up-2:screen-value    in frame {&frame-name} = ""
       de-vl-unit-up-3:screen-value    in frame {&frame-name} = ""
       de-qtd-total-up-1:screen-value  in frame {&frame-name} = ""
       de-qtd-total-up-2:screen-value  in frame {&frame-name} = ""
       de-qtd-total-up-3:screen-value  in frame {&frame-name} = ""              
       de-vl-total-1:screen-value      in frame {&frame-name} = ""
       de-vl-total-2:screen-value      in frame {&frame-name} = ""
       de-vl-total-3:screen-value      in frame {&frame-name} = "".
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
  {src/adm/template/snd-list.i "estabelec"}

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


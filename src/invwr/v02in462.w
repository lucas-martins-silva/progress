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
{include/i-prgvrs.i V02IN462 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in462 MUT}
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

def var i-mes-dem             as int                                   no-undo.
def var i-tp-sald             as int  initial 1                        no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def var i-ini-empresa         LIKE empresa.ep-codigo  format "x(03)"                     no-undo.
&ELSE
def var i-ini-empresa         as int  format "999"                     no-undo.
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
def var i-fim-empresa         LIKE empresa.ep-codigo  format "x(03)"  initial "ZZZ"      no-undo.
&ELSE
def var i-fim-empresa         as int  format "999"  initial "999"      no-undo.
&ENDIF
def var c-ini-estabelecimento as char format "x(3)"                    no-undo.
def var c-fim-estabelecimento as char format "x(3)" initial "ZZZ"      no-undo.
def var c-ini-referencia      as char format "x(8)"                    no-undo.
def var c-fim-referencia      as char format "x(8)" initial "ZZZZZZZZ" no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define DISPLAYED-OBJECTS c-ult-atual hra-ult-atual ~
de-acum-sl-disp-planej de-acum-mat-poder-3os de-acum-cc-cp-comp ~
de-acum-cc-cp-plan de-acum-reser-comp de-acum-reser-plan ~
de-acum-ped-cli-abe de-acum-ped-cli-ant 

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
DEFINE VARIABLE c-ult-atual AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-acum-cc-cp-comp AS DECIMAL FORMAT "->>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "":R36 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE de-acum-cc-cp-plan AS DECIMAL FORMAT "->>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "":R35 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE de-acum-mat-poder-3os AS DECIMAL FORMAT ">>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "":R23 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE de-acum-ped-cli-abe AS DECIMAL FORMAT "->>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "":R17 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE de-acum-ped-cli-ant AS DECIMAL FORMAT "->>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "":R20 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE de-acum-reser-comp AS DECIMAL FORMAT "->>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "":R26 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE de-acum-reser-plan AS DECIMAL FORMAT "->>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "":R23 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE de-acum-sl-disp-planej AS DECIMAL FORMAT "->>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "":R35 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE hra-ult-atual AS CHARACTER FORMAT "X(8)":U INITIAL "  :  :" 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-ult-atual AT ROW 1.17 COL 38.43 COLON-ALIGNED
     hra-ult-atual AT ROW 1.17 COL 52.14 COLON-ALIGNED NO-LABEL
     de-acum-sl-disp-planej AT ROW 2.17 COL 38.43 COLON-ALIGNED
     de-acum-mat-poder-3os AT ROW 3.17 COL 38.43 COLON-ALIGNED
     de-acum-cc-cp-comp AT ROW 4.17 COL 38.43 COLON-ALIGNED
     de-acum-cc-cp-plan AT ROW 5.17 COL 38.43 COLON-ALIGNED
     de-acum-reser-comp AT ROW 6.17 COL 38.43 COLON-ALIGNED
     de-acum-reser-plan AT ROW 7.17 COL 38.43 COLON-ALIGNED
     de-acum-ped-cli-abe AT ROW 8.17 COL 38.43 COLON-ALIGNED
     de-acum-ped-cli-ant AT ROW 9.17 COL 38.43 COLON-ALIGNED
     "-" VIEW-AS TEXT
          SIZE 1 BY .63 AT ROW 1.25 COL 53.29
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
         HEIGHT             = 9.21
         WIDTH              = 64.57.
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

/* SETTINGS FOR FILL-IN c-ult-atual IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-acum-cc-cp-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-acum-cc-cp-plan IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-acum-mat-poder-3os IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-acum-ped-cli-abe IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-acum-ped-cli-ant IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-acum-reser-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-acum-reser-plan IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-acum-sl-disp-planej IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN hra-ult-atual IN FRAME f-main
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).

 {utp/ut-field.i mgind resum-item dt-ult-atual 1}
  assign c-ult-atual:label in frame {&frame-name} = return-value.  

  {utp/ut-field.i mgind resum-item sl-disp-planej l}
  assign de-acum-sl-disp-planej:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind resum-item mat-poder-3os l}
  assign de-acum-mat-poder-3os:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind resum-item cc-cp-comp 1}
  assign de-acum-cc-cp-comp:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind resum-item cc-cp-plan 1}
  assign de-acum-cc-cp-plan:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind resum-item reser-comp 1}
  assign de-acum-reser-comp:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind resum-item reser-plan 1}
  assign de-acum-reser-plan:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind resum-item ped-cli-abe 1}
  assign de-acum-ped-cli-abe:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind resum-item ped-cli-ant 1}
  assign de-acum-ped-cli-ant:label in frame {&frame-name} = return-value.

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

  run pi-atribui-valores.         

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

  {utp/ut-field.i mgind resum-item dt-ult-atual 1}
  assign c-ult-atual:label in frame {&frame-name} = return-value.  

  {utp/ut-field.i mgind resum-item sl-disp-planej 1}
  assign de-acum-sl-disp-planej:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind resum-item mat-poder-3os 1}
  assign de-acum-mat-poder-3os:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind resum-item cc-cp-comp 1}
  assign de-acum-cc-cp-comp:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind resum-item cc-cp-plan 1}
  assign de-acum-cc-cp-plan:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind resum-item reser-comp 1}
  assign de-acum-reser-comp:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind resum-item reser-plan 1}
  assign de-acum-reser-plan:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind resum-item ped-cli-abe 1}
  assign de-acum-ped-cli-abe:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind resum-item ped-cli-ant 1}
  assign de-acum-ped-cli-ant:label in frame {&frame-name} = return-value.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atribui-valores V-table-Win 
PROCEDURE pi-atribui-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

assign de-acum-sl-disp-planej = 0
       de-acum-mat-poder-3os  = 0
       de-acum-cc-cp-comp     = 0
       de-acum-cc-cp-plan     = 0
       de-acum-reser-comp     = 0
       de-acum-reser-plan     = 0
       de-acum-ped-cli-abe    = 0
       de-acum-ped-cli-ant    = 0
       c-ult-atual            = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF 
       hra-ult-atual          = "00:00:00".

for each resum-item where
         resum-item.it-codigo    = item.it-codigo and
         resum-item.ep-codigo   >= i-ini-empresa and
         resum-item.ep-codigo   <= i-fim-empresa and
         resum-item.cod-estabel >= c-ini-estabelecimento and
         resum-item.cod-estabel <= c-fim-estabelecimento and 
         resum-item.cd-refer    >= c-ini-referencia and
         resum-item.cd-refer    <= c-fim-referencia NO-LOCK:

    assign de-acum-sl-disp-planej = de-acum-sl-disp-planej + resum-item.sl-disp-planej 
           de-acum-mat-poder-3os  = de-acum-mat-poder-3os  + resum-item.mat-poder-3os 
           de-acum-cc-cp-comp     = de-acum-cc-cp-comp     + resum-item.cc-cp-comp[i-tp-sald]
           de-acum-cc-cp-plan     = de-acum-cc-cp-plan     + resum-item.cc-cp-plan[i-tp-sald]
           de-acum-reser-comp     = de-acum-reser-comp     + resum-item.reser-comp[i-tp-sald]
           de-acum-reser-plan     = de-acum-reser-plan     + resum-item.reser-plan[i-tp-sald]
           de-acum-ped-cli-abe    = de-acum-ped-cli-abe    + resum-item.ped-cli-abe[i-tp-sald]
           de-acum-ped-cli-ant    = de-acum-ped-cli-ant    + resum-item.ped-cli-ant[i-tp-sald].

    if resum-item.dt-ult-atual > c-ult-atual then
       assign c-ult-atual    = resum-item.dt-ult-atual
              hra-ult-atual  = resum-item.hr-ult-atual.

    else
         if resum-item.dt-ult-atual  = c-ult-atual 
         and resum-item.hr-ult-atual > hra-ult-atual then
           assign hra-ult-atual = resum-item.hr-ult-atual.

end.

assign de-acum-sl-disp-planej:screen-value in frame {&frame-name} = string(de-acum-sl-disp-planej)       
       de-acum-mat-poder-3os:screen-value in frame {&frame-name}  = string(de-acum-mat-poder-3os)
       de-acum-cc-cp-comp:screen-value in frame {&frame-name}     = string(de-acum-cc-cp-comp)
       de-acum-cc-cp-plan:screen-value in frame {&frame-name}     = string(de-acum-cc-cp-plan)
       de-acum-reser-comp:screen-value in frame {&frame-name}     = string(de-acum-reser-comp)
       de-acum-reser-plan:screen-value in frame {&frame-name}     = string(de-acum-reser-plan)
       de-acum-ped-cli-abe:screen-value in frame {&frame-name}    = string(de-acum-ped-cli-abe)
       de-acum-ped-cli-ant:screen-value in frame {&frame-name}    = string(de-acum-ped-cli-ant)
       c-ult-atual:screen-value in frame {&frame-name}            = string(c-ult-atual)
       hra-ult-atual:screen-value in frame {&frame-name}          = string(hra-ult-atual).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-var V-table-Win 
PROCEDURE pi-passa-var :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter i-mes-dem-param         as int                no-undo.
def input parameter i-tp-sald-param         as int                no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def input parameter i-ini-ep-codigo-param   LIKE empresa.ep-codigo  format "x(03)"  no-undo.
&ELSE
def input parameter i-ini-ep-codigo-param   as int  format "999"  no-undo.
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
def input parameter i-fin-ep-codigo-param   LIKE empresa.ep-codigo  format "x(03)"  no-undo.
&ELSE
def input parameter i-fin-ep-codigo-param   as int  format "999"  no-undo.
&ENDIF
def input parameter c-ini-cod-estabel-param as char format "x(8)" no-undo.
def input parameter c-fin-cod-estabel-param as char format "x(8)" no-undo.
def input parameter c-ini-cd-refer-param    as char format "x(3)" no-undo.
def input parameter c-fin-cd-refer-param    as char format "x(3)" no-undo.


assign i-mes-dem             = i-mes-dem-param 
       i-tp-sald             = i-tp-sald-param
       i-ini-empresa         = i-ini-ep-codigo-param            
       i-fim-empresa         = i-fin-ep-codigo-param           
       c-ini-estabelecimento = c-ini-cod-estabel-param          
       c-fim-estabelecimento = c-fin-cod-estabel-param          
       c-ini-referencia      = c-ini-cd-refer-param             
       c-fim-referencia      = c-fin-cd-refer-param.


run pi-atribui-valores.

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



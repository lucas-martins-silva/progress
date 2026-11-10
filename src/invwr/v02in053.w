&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
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
{include/i-prgvrs.i V02IN053 2.00.00.003 } /*** "010003" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN053 MUT}
&ENDIF


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
&Scoped-define EXTERNAL-TABLES res-fic-cq
&Scoped-define FIRST-EXTERNAL-TABLE res-fic-cq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR res-fic-cq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS res-fic-cq.cod-comp res-fic-cq.resultado 
&Scoped-define ENABLED-TABLES res-fic-cq
&Scoped-define FIRST-ENABLED-TABLE res-fic-cq
&Scoped-Define ENABLED-OBJECTS rt-key c-laudo fi-num-tabela fi-num-comp 
&Scoped-Define DISPLAYED-FIELDS res-fic-cq.cod-comp res-fic-cq.resultado ~
res-fic-cq.dt-result res-fic-cq.cod-resp 
&Scoped-define DISPLAYED-TABLES res-fic-cq
&Scoped-define FIRST-DISPLAYED-TABLE res-fic-cq
&Scoped-Define DISPLAYED-OBJECTS c-laudo c-descricao de-result-min-obt ~
de-result-max-obt result-min fi-num-tabela result-max fi-num-comp 

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
DEFINE VARIABLE c-laudo AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 4.72 BY 1 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-result-max-obt AS DECIMAL FORMAT "->>,>>9.999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-result-min-obt AS DECIMAL FORMAT "->>,>>9.999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-comp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-tabela AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE result-max AS DECIMAL FORMAT "->,>>>,>>9.999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE result-min AS DECIMAL FORMAT "->,>>>,>>9.999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.14 BY 7.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-laudo AT ROW 1.33 COL 3 NO-LABEL
     res-fic-cq.cod-comp AT ROW 1.38 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-descricao AT ROW 1.38 COL 31.14 COLON-ALIGNED NO-LABEL
     de-result-min-obt AT ROW 2.42 COL 25 COLON-ALIGNED
     res-fic-cq.resultado AT ROW 3.42 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     de-result-max-obt AT ROW 3.42 COL 25 COLON-ALIGNED
     result-min AT ROW 4.42 COL 25 COLON-ALIGNED
     fi-num-tabela AT ROW 4.42 COL 48.86 COLON-ALIGNED NO-LABEL
     result-max AT ROW 5.42 COL 25 COLON-ALIGNED
     fi-num-comp AT ROW 5.42 COL 48.72 COLON-ALIGNED NO-LABEL
     res-fic-cq.dt-result AT ROW 6.42 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     res-fic-cq.cod-resp AT ROW 7.42 COL 25 COLON-ALIGNED WIDGET-ID 2
          LABEL "Respons vel"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.res-fic-cq
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
         WIDTH              = 73.14.
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

/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-laudo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN res-fic-cq.cod-resp IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN de-result-max-obt IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-result-min-obt IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN res-fic-cq.dt-result IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-num-comp:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       fi-num-tabela:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN result-max IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN result-min IN FRAME f-main
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
  {src/adm/template/row-list.i "res-fic-cq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "res-fic-cq"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ini-faixa V-table-Win 
PROCEDURE pi-ini-faixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param cod-comp    like comp-exame.cod-comp   no-undo.
def input param descricao   like comp-exame.descricao  no-undo.
def input param resul-min   like comp-exame.result-min no-undo.
def input param resul-max   like comp-exame.result-max no-undo.
def input param resultado   like res-fic-cq.resultado  no-undo.
def input param res-max     like res-fic-cq.res-max    no-undo.
def input param dt-result   like res-fic-cq.dt-result  no-undo.
def input param cod-resp    like res-fic-cq.cod-resp   no-undo.


assign res-fic-cq.resultado:hidden in frame {&frame-name} = yes
       res-fic-cq.cod-comp:screen-value in frame {&frame-name}  = string(cod-comp)
       c-descricao:screen-value in frame {&frame-name}          = descricao
       de-result-min-obt:screen-value in frame {&frame-name}    = string(resultado)
       de-result-max-obt:screen-value in frame {&frame-name}    = string(res-max)
       result-min:screen-value in frame {&frame-name}           = string(resul-min)
       result-max:screen-value in frame {&frame-name}           = string(resul-max)
       res-fic-cq.dt-result:screen-value in frame {&frame-name} = string(dt-result)
       res-fic-cq.cod-resp:screen-value in frame {&frame-name}  = string(cod-resp).

{utp/ut-liter.i Result._M¡nimo_Obtido *}
assign de-result-min-obt:label in frame {&frame-name} = return-value.
{utp/ut-liter.i Result._M ximo_Obtido *}
assign de-result-max-obt:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgind comp-exame result-min 1}
assign result-min:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgind comp-exame result-max 1}
assign result-max:label in frame {&frame-name} = return-value.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ini-numerico V-table-Win 
PROCEDURE pi-ini-numerico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param cod-comp    like comp-exame.cod-comp   no-undo.
def input param descricao   like comp-exame.descricao  no-undo.
def input param resul-min   like comp-exame.result-min no-undo.
def input param resul-max   like comp-exame.result-max no-undo.
def input param resultado   like res-fic-cq.resultado  no-undo.
def input param dt-result   like res-fic-cq.dt-result  no-undo.
def input param cod-resp    like res-fic-cq.cod-resp   no-undo.

assign de-result-min-obt:hidden in frame {&frame-name} = yes
       de-result-max-obt:hidden in frame {&frame-name} = yes
       res-fic-cq.cod-comp:screen-value in frame {&frame-name}  = string(cod-comp)
       c-descricao:screen-value in frame {&frame-name}          = descricao
       res-fic-cq.resultado:screen-value in frame {&frame-name} = string(resultado)
       result-min:screen-value in frame {&frame-name}           = string(resul-min)
       result-max:screen-value in frame {&frame-name}           = string(resul-max)
       res-fic-cq.dt-result:screen-value in frame {&frame-name} = string(dt-result)
       res-fic-cq.cod-resp:screen-value in frame {&frame-name}  = string(cod-resp).

{utp/ut-field.i mgind comp-exame result-min 1}
assign result-min:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgind comp-exame result-max 1}
assign result-max:label in frame {&frame-name} = return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ini-tabela V-table-Win 
PROCEDURE pi-ini-tabela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param i-cod-comp     like comp-exame.cod-comp   no-undo.
def input param c-desc         like comp-exame.descricao  no-undo.
def input param nr-tabela      like res-fic-cq.nr-tabela  no-undo.   
def input param seq-comp       like res-fic-cq.seq-comp   no-undo. 
def input param dt-result      like res-fic-cq.dt-result  no-undo.
def input param cod-resp       like res-fic-cq.cod-resp   no-undo.

find first tab-result where
     tab-result.nr-tabela = nr-tabela no-lock no-error.
find first comp-tab-res where
     comp-tab-res.nr-tabela = nr-tabela and
     comp-tab-res.seq-comp  = seq-comp no-lock no-error.     

assign de-result-min-obt:hidden in frame {&frame-name}    = yes
       de-result-max-obt:hidden in frame {&frame-name}    = yes
       res-fic-cq.resultado:hidden in frame {&frame-name} = yes
       result-min:hidden in frame {&frame-name}           = no
       result-max:hidden in frame {&frame-name}           = no 
       fi-num-tabela:hidden in frame {&frame-name}        = no
       fi-num-comp:hidden in frame {&frame-name}          = no              
       fi-num-tabela:column in frame {&frame-name}        = result-min:column
       fi-num-comp:column in frame {&frame-name}          = result-max:column
       res-fic-cq.cod-comp:screen-value in frame {&frame-name}  = string(i-cod-comp)
       c-descricao:screen-value in frame {&frame-name}          = c-desc
       fi-num-tabela:screen-value in frame {&frame-name}        = if avail tab-result then tab-result.descricao
                                                                  else ""
       fi-num-comp:screen-value in frame {&frame-name}          = if avail comp-tab-res then comp-tab-res.descricao
                                                                  else ""      
       res-fic-cq.dt-result:screen-value in frame {&frame-name} = string(dt-result)
       res-fic-cq.cod-resp:screen-value in frame {&frame-name}  = string(cod-resp).

{utp/ut-field.i mgind tab-result nr-tabela 1}
assign result-min:label in frame {&frame-name} = return-value.
{utp/ut-liter.i Num._Componente *}
assign result-max:label in frame {&frame-name} = return-value.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ini-texto V-table-Win 
PROCEDURE pi-ini-texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param laudo       like res-fic-cq.laudo      no-undo.
def input param cod-resp    like res-fic-cq.cod-resp   no-undo.

assign c-laudo:hidden                   in frame {&frame-name}  = no
       c-laudo:width                    in frame {&frame-name}  = 69
       c-laudo:height                   in frame {&frame-name}  = 6
       c-laudo:screen-value             in frame {&frame-name}  = laudo
       res-fic-cq.cod-resp:screen-value in frame {&frame-name}  = string(cod-resp).


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
    
/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "res-fic-cq"}

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


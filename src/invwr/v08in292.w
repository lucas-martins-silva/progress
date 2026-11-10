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
{include/i-prgvrs.i V08IN292 2.00.00.020}  /*** 010020 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V08IN292 MUT}
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

{cdp/cdcfgmat.i}

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
&Scoped-define EXTERNAL-TABLES param-re
&Scoped-define FIRST-EXTERNAL-TABLE param-re


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-re.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-re.tp-doc-perm param-re.ajusta-vl ~
param-re.gera-ce-fatura 
&Scoped-define ENABLED-TABLES param-re
&Scoped-define FIRST-ENABLED-TABLE param-re
&Scoped-define DISPLAYED-TABLES param-re
&Scoped-define FIRST-DISPLAYED-TABLE param-re
&Scoped-Define ENABLED-OBJECTS RECT-12 RECT-15 RECT-16 rt-mold 
&Scoped-Define DISPLAYED-FIELDS param-re.tp-doc-perm param-re.ajusta-vl ~
param-re.gera-ce-fatura 
&Scoped-Define DISPLAYED-OBJECTS l-atu-quant l-atu-rma l-est-comis ~
c-doc-permi c-rma-permi 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS l-est-comis 
&Scoped-define ADM-ASSIGN-FIELDS l-est-comis 
&Scoped-define ADM-MODIFY-FIELDS l-est-comis 

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
DEFINE VARIABLE c-doc-permi AS CHARACTER FORMAT "X(35)":U 
      VIEW-AS TEXT 
     SIZE 28 BY .67 NO-UNDO.

DEFINE VARIABLE c-rma-permi AS CHARACTER FORMAT "X(35)":U 
      VIEW-AS TEXT 
     SIZE 28 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45 BY 4.5.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81 BY 4.75.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35 BY 4.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.43 BY 10.92.

DEFINE VARIABLE l-atu-quant AS LOGICAL INITIAL no 
     LABEL "Atualizar Quantidades" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE l-atu-rma AS LOGICAL INITIAL no 
     LABEL "Atualizar RMA" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE l-est-comis AS LOGICAL INITIAL no 
     LABEL "Estorna Comiss∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-re.tp-doc-perm AT ROW 2.96 COL 8 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "NFF", 1,
"Remito", 2,
"Ambos", 3
          SIZE 14.72 BY 2.75
     l-atu-quant AT ROW 3 COL 54
     l-atu-rma AT ROW 4 COL 54
     l-est-comis AT ROW 5 COL 54
     param-re.ajusta-vl AT ROW 8.25 COL 29
          VIEW-AS TOGGLE-BOX
          SIZE 18.57 BY .83
     param-re.gera-ce-fatura AT ROW 9.25 COL 29
          VIEW-AS TOGGLE-BOX
          SIZE 38 BY .83
     c-doc-permi AT ROW 1.75 COL 2.57 COLON-ALIGNED NO-LABEL
     c-rma-permi AT ROW 1.75 COL 48 COLON-ALIGNED NO-LABEL
     RECT-12 AT ROW 1.96 COL 3
     RECT-15 AT ROW 6.75 COL 3
     RECT-16 AT ROW 1.96 COL 49
     rt-mold AT ROW 1.17 COL 1.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-re
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
         HEIGHT             = 11.17
         WIDTH              = 85.14.
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

/* SETTINGS FOR FILL-IN c-doc-permi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-rma-permi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-atu-quant IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-atu-rma IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-est-comis IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
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

&Scoped-define SELF-NAME l-atu-quant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-atu-quant V-table-Win
ON VALUE-CHANGED OF l-atu-quant IN FRAME f-main /* Atualizar Quantidades */
DO:
  IF  l-atu-quant:CHECKED IN FRAME {&FRAME-NAME} THEN
    ENABLE l-atu-rma WITH FRAME {&FRAME-NAME}.
  ELSE DO:
    DISABLE l-atu-rma WITH FRAME {&FRAME-NAME}.
    ASSIGN l-atu-rma:CHECKED IN FRAME {&FRAME-NAME} = NO.
  END.  
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

  {utp/ut-liter.i Permiss∆o_Documentos_do_Usu†rio * R}
  assign c-doc-permi = return-value.

  {utp/ut-liter.i Ajusta_Preáo_Total * R}
  assign param-re.ajusta-vl:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "param-re"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-re"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  {utp/ut-liter.i Permiss∆o_Documentos_do_Usu†rio * R}
  assign c-doc-permi = return-value.

  {utp/ut-liter.i Permiss‰es_RMA * R}
  assign c-rma-permi:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Ajusta_Preáo_Total * R}
  assign param-re.ajusta-vl:label in frame {&frame-name} = return-value.

   DO WITH FRAME {&FRAME-NAME}:
     ASSIGN l-atu-quant:CHECKED = NO
            l-atu-rma:CHECKED   = NO
            l-est-comis:checked = no.
   END.

  /* Code placed here will execute AFTER standard behavior.    */

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
  if RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.

  ASSIGN &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
            param-re.log-atualiza-quant-rma = l-atu-quant:CHECKED IN FRAME {&FRAME-NAME}
            param-re.log-atualiza-rma       = l-atu-rma:CHECKED   IN FRAME {&FRAME-NAME}
         &ELSE
            OVERLAY(param-re.char-1, 9,1)    = IF l-atu-quant:CHECKED IN FRAME {&FRAME-NAME} THEN "1" ELSE " "
            OVERLAY(param-re.char-1, 10,1)   = IF l-atu-rma:CHECKED   IN FRAME {&FRAME-NAME} THEN "1" ELSE " "
         &ENDIF
         
         &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
         param-re.log-permis-comis-repres = l-est-comis:CHECKED IN FRAME {&FRAME-NAME}
         &else
         overlay(param-re.char-1, 11,1)   = IF l-est-comis:CHECKED IN FRAME {&FRAME-NAME} THEN "1" ELSE "0"
         &ENDIF
         .

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

  DO WITH FRAME {&FRAME-NAME}:
      DISABLE l-atu-quant
              l-atu-rma
              l-est-comis.
  END.

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

  {utp/ut-liter.i Permiss∆o_Documentos_do_Usu†rio * R}
  assign c-doc-permi = return-value.

  {utp/ut-liter.i Permiss‰es_RMA * R}
  assign c-rma-permi:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Ajusta_Preáo_Total * R}
  ASSIGN param-re.ajusta-vl:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Atualizar_Quantidades * R}
  assign l-atu-quant:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Atualizar_RMA * R}
  assign l-atu-rma:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Estorna_Comiss∆o * R}
  assign l-est-comis:label in frame {&frame-name} = return-value.

  IF AVAIL param-re THEN
      ASSIGN &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
                 l-atu-quant:CHECKED IN FRAME {&FRAME-NAME} = param-re.log-atualiza-quant-rma 
                 l-atu-rma:CHECKED   IN FRAME {&FRAME-NAME} = param-re.log-atualiza-rma
             &ELSE
                 l-atu-quant:CHECKED IN FRAME {&FRAME-NAME} = IF SUBSTRING(param-re.char-1, 9,1)  = "1" THEN YES ELSE no
                 l-atu-rma:CHECKED   IN FRAME {&FRAME-NAME} = IF SUBSTRING(param-re.char-1, 10,1) = "1" THEN YES ELSE no
             &ENDIF
             
             &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
             l-est-comis:CHECKED IN FRAME {&FRAME-NAME} = param-re.log-permis-comis-repres
             &else
             l-est-comis:CHECKED IN FRAME {&FRAME-NAME} = IF SUBSTRING(param-re.char-1, 11,1) = "1" THEN YES ELSE no
             &ENDIF
             .
  ELSE
      ASSIGN l-atu-quant:CHECKED IN FRAME {&FRAME-NAME} = NO
             l-atu-rma:CHECKED   IN FRAME {&FRAME-NAME} = NO
             &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN  
             l-est-comis:CHECKED IN FRAME {&FRAME-NAME} = NO
             &else                                       
             l-est-comis:CHECKED IN FRAME {&FRAME-NAME} = NO
             &ENDIF                                      
             .                                       

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
s------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  DO WITH FRAME {&FRAME-NAME}:
      ENABLE l-atu-quant
             l-atu-rma
             l-est-comis.
  END.

  IF  l-atu-quant:CHECKED IN FRAME {&FRAME-NAME} THEN
    ENABLE l-atu-rma WITH FRAME {&FRAME-NAME}.
  ELSE DO:
    DISABLE l-atu-rma WITH FRAME {&FRAME-NAME}.
    ASSIGN l-atu-rma:CHECKED IN FRAME {&FRAME-NAME} = NO.
  END.  

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


  {utp/ut-liter.i Permiss∆o_Documentos_do_Usu†rio * R}
  assign c-doc-permi = return-value.

  {utp/ut-liter.i Permiss‰es_RMA * R}
  assign c-rma-permi:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Ajusta_Preáo_Total * R}
  assign param-re.ajusta-vl:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Atualizar_Quantidades * R}
  assign l-atu-quant:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Atualizar_RMA * R}
  assign l-atu-rma:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Estorna_Comiss∆o * R}
  assign l-est-comis:label in frame {&frame-name} = return-value.

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
  {src/adm/template/snd-list.i "param-re"}

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


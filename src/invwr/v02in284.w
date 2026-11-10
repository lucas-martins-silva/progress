&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V02IN284 2.00.00.012 } /*** "010012" 28/02/2025 09:31:09 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN284 MUT}
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

DEFINE VARIABLE c-return AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp  AS HANDLE      NO-UNDO.

/* Local Variable Definitions ---                                       */

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
&Scoped-define EXTERNAL-TABLES param-cs
&Scoped-define FIRST-EXTERNAL-TABLE param-cs


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-cs.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-cs.valoriza-ref param-cs.calc-cs-mob ~
param-cs.calc-cs-mat param-cs.calc-cs-ggf param-cs.log-2 ~
param-cs.log-atualiz-hist 
&Scoped-define ENABLED-TABLES param-cs
&Scoped-define FIRST-ENABLED-TABLE param-cs
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-4 RECT-3 RECT-7 RECT-8 
&Scoped-Define DISPLAYED-FIELDS param-cs.valoriza-ref param-cs.calc-cs-mob ~
param-cs.calc-cs-mat param-cs.calc-cs-ggf param-cs.log-2 ~
param-cs.log-atualiz-hist 
&Scoped-define DISPLAYED-TABLES param-cs
&Scoped-define FIRST-DISPLAYED-TABLE param-cs


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
DEFINE VARIABLE c-text-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE c-text-4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE c-text-5 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 29.43 BY .63 NO-UNDO.

DEFINE VARIABLE c-text-6 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE c-text-7 AS CHARACTER FORMAT "X(225)":U 
      VIEW-AS TEXT 
     SIZE 17 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 2.08.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 2.08.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 2.08.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 2.08.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 2.25.

DEFINE VARIABLE tg-cc-estab AS LOGICAL INITIAL no 
     LABEL "Centros de Custo Produtivos vinculados com Estabelecimentos" 
     VIEW-AS TOGGLE-BOX
     SIZE 63 BY .83 NO-UNDO.

DEFINE VARIABLE tg-deb-ggf AS LOGICAL INITIAL no 
     LABEL "Considera Itens DÇbito GGF" 
     VIEW-AS TOGGLE-BOX
     SIZE 63 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-cs.valoriza-ref AT ROW 1.79 COL 10 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "MÇdio", 1,
"Ordem", 2
          SIZE 17 BY 1.38
     param-cs.calc-cs-mob AT ROW 1.79 COL 46.86 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Proporcional", 1,
"Total", 2
          SIZE 17 BY 1.38
     param-cs.calc-cs-mat AT ROW 4.46 COL 10 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Proporcional", 1,
"Total", 2
          SIZE 17 BY 1.38
     param-cs.calc-cs-ggf AT ROW 4.46 COL 47 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Proporcional", 1,
"Total", 2
          SIZE 17 BY 1.38
     param-cs.log-2 AT ROW 6.83 COL 6.29 WIDGET-ID 2
          LABEL "Custo de Preparaá∆o conforme seleá∆o"
          VIEW-AS TOGGLE-BOX
          SIZE 60 BY .83
     tg-deb-ggf AT ROW 7.71 COL 6.29 WIDGET-ID 8
     param-cs.log-atualiz-hist AT ROW 7.75 COL 36 
          LABEL "Armazenar Hist¢rico de Preáo no Fechamento"
          VIEW-AS TOGGLE-BOX
          SIZE 34 BY .83
     tg-cc-estab AT ROW 8.79 COL 6
     c-text-7 AT ROW 1.17 COL 4.86 COLON-ALIGNED NO-LABEL
     c-text-4 AT ROW 1.17 COL 41 COLON-ALIGNED NO-LABEL
     c-text-3 AT ROW 3.75 COL 4.57 COLON-ALIGNED NO-LABEL
     c-text-6 AT ROW 3.75 COL 41 COLON-ALIGNED NO-LABEL
     c-text-5 AT ROW 6.25 COL 4.57 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     RECT-5 AT ROW 1.42 COL 5
     RECT-4 AT ROW 1.42 COL 42
     RECT-3 AT ROW 4.04 COL 5
     RECT-7 AT ROW 4.04 COL 42
     RECT-8 AT ROW 6.5 COL 5 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-cs
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
         HEIGHT             = 8.96
         WIDTH              = 74.57.
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

/* SETTINGS FOR FILL-IN c-text-3 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-text-4 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-text-5 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-text-6 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-text-7 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX param-cs.log-2 IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX param-cs.log-atualiz-hist IN FRAME f-main
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR TOGGLE-BOX tg-cc-estab IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX tg-deb-ggf IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
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

&Scoped-define SELF-NAME param-cs.log-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cs.log-2 V-table-Win
ON VALUE-CHANGED OF param-cs.log-2 IN FRAME f-main /* Custo de Preparaá∆o conforme seleá∆o */
DO:
     IF param-cs.log-2 <> INPUT FRAME {&FRAME-NAME} param-cs.log-2 THEN DO:


         {utp/ut-liter.i Hist¢ricos_de_custos_(custo-data) *}
         ASSIGN c-return = RETURN-VALUE .
         {utp/ut-liter.i Todos_os_Hist¢ricos_de_custos_(custo-data)_ser∆o_eliminados_ao_confirmar_esta_alteraá∆o *}
         RUN utp/ut-msgs.p (INPUT "SHOW",
                            INPUT 52755,
                            INPUT c-return + "~~" + RETURN-VALUE).
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-cc-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-cc-estab V-table-Win
ON VALUE-CHANGED OF tg-cc-estab IN FRAME f-main /* Centros de Custo Produtivos vinculados com Estabelecimentos */
DO:

  IF tg-cc-estab:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
  
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 17006,
                       INPUT "Centros de Custo Produtivos por Estabelecimentos~~" +
                             "Devido a grande necessidade de recursos para ativaá∆o, esta funcionalidade dever† ser ativada pelo " +
                             "programa 'SPP/CSP/SPCS040.R', onde est∆o as informaá‰es necess†rias para execuá∆o do processo.").
        
    ASSIGN tg-cc-estab:CHECKED IN FRAME {&FRAME-NAME} = NO.
    DISP tg-cc-estab WITH FRAME {&FRAME-NAME}.
    
  END.
  ELSE DO:
  
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-deb-ggf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-deb-ggf V-table-Win
ON VALUE-CHANGED OF tg-deb-ggf IN FRAME f-main /* Considera Itens DÇbito GGF */
DO:

  IF tg-cc-estab:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
  
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 17006,
                       INPUT "Centros de Custo Produtivos por Estabelecimentos~~" +
                             "Devido a grande necessidade de recursos para ativaá∆o, esta funcionalidade dever† ser ativada pelo " +
                             "programa 'SPP/CSP/SPCS040.R', onde est∆o as informaá‰es necess†rias para execuá∆o do processo.").
        
    ASSIGN tg-cc-estab:CHECKED IN FRAME {&FRAME-NAME} = NO.
    DISP tg-cc-estab WITH FRAME {&FRAME-NAME}.
    
  END.
  ELSE DO:
  
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
  {src/adm/template/row-list.i "param-cs"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-cs"}

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

  /* Code placed here will execute AFTER standard behavior.    */

 

{utp\ut-rtlbl.i mgind param-cs calc-cs-mat c-text-3 }
{utp\ut-rtlbl.i mgind param-cs calc-cs-mob c-text-4 }


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

  IF param-cs.log-2 <> INPUT FRAME {&FRAME-NAME} param-cs.log-2 THEN DO:


      {utp/ut-liter.i Todos_os_hist¢ricos_de_Custos_ser∆o_eliminados *}
      RUN utp/ut-msgs.p (INPUT "SHOW",
                         INPUT 30068,
                         INPUT RETURN-VALUE).

      IF RETURN-VALUE = "NO" THEN 
          RETURN "ADM-ERROR":U.
      ELSE DO:
          RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

          RUN pi-inicializar IN h-acomp (INPUT "Eliminando registros").

          FOR EACH custo-data:
              RUN pi-acompanhar IN h-acomp ("Registro" + STRING(custo-data.tipo-custo) + "/" +
                                                         STRING(custo-data.it-codigo) + "/" + 
                                                         STRING(custo-data.cod-estabel)).
              DELETE custo-data.
          END.

          RUN pi-finalizar IN h-acomp.

      END.



  END.


  ASSIGN OVERLAY(param-cs.char-1,1,1) = IF tg-deb-ggf:CHECKED IN FRAME {&FRAME-NAME} THEN "1" ELSE "0".


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  if RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.




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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

 {utp\ut-rtlbl.i mgind param-cs valoriza-ref c-text-6 }
{utp\ut-rtlbl.i mgind param-cs calc-cs-mat c-text-3 }
{utp\ut-rtlbl.i mgind param-cs calc-cs-mob c-text-4 }
{utp\ut-rtlbl.i mgind param-cs calc-cs-ggf c-text-6 }

     ASSIGN tg-deb-ggf:CHECKED IN FRAME {&FRAME-NAME} = substring(param-cs.char-1,1,1) = "1".



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

  /* Centro de Custo X Estabelecimento */
  {cdp/cd0110.i}
  
  ASSIGN tg-deb-ggf:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

  /** LiberaÁ„o do parametro apenas na 11.5.12 **/
  IF l-funcao-ccusto-estab THEN DO:
    
    ASSIGN tg-cc-estab:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    ASSIGN tg-cc-estab = YES.
    ASSIGN tg-cc-estab:CHECKED IN FRAME {&FRAME-NAME} = YES.
    
    DISP tg-cc-estab WITH FRAME {&FRAME-NAME}.
  END.
  else do:
    ASSIGN tg-cc-estab:SENSITIVE IN FRAME {&FRAME-NAME} = true.
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

{utp\ut-rtlbl.i mgind param-cs valoriza-ref c-text-7}
{utp\ut-rtlbl.i mgind param-cs calc-cs-mat c-text-3 }
{utp\ut-rtlbl.i mgind param-cs calc-cs-mob c-text-4 }
{utp\ut-rtlbl.i mgind param-cs calc-cs-ggf c-text-6 }

    
{utp/ut-liter.i Custos_Gerenciais *}
ASSIGN c-text-5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.


{utp/ut-liter.i Armazenar_Historico_de_Preco_no_Fechamento * }
 ASSIGN param-cs.log-atualiz-hist:LABEL  = TRIM(RETURN-VALUE).

    
/** LiberaÁ„o do parametro apenas 11.5.12 **/
/*assign tg-cc-estab:visible in frame {&frame-name} = false.*/




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
  {src/adm/template/snd-list.i "param-cs"}

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


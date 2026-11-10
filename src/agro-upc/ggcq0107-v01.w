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
{include/i-prgvrs.i GGCQ0107-V01 2.00.00.007 } /*** "010007" ***/


{utp/ut-glob.i}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ggcq0107-v01 GGP}
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
&Scoped-define EXTERNAL-TABLES comp-exame
&Scoped-define FIRST-EXTERNAL-TABLE comp-exame


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR comp-exame.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS comp-exame.char-1 
&Scoped-define ENABLED-TABLES comp-exame
&Scoped-define FIRST-ENABLED-TABLE comp-exame
&Scoped-Define ENABLED-OBJECTS rt-key RECT-1 
&Scoped-Define DISPLAYED-OBJECTS c-comp-preco c-desc-comp ~
c-comp-preco-tx-padr c-desc-comp-2 

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
cod-exame|y|y|mgind.comp-exame.cod-exame
cod-comp|y|y|mgind.comp-exame.cod-comp
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cod-exame,cod-comp",
     Keys-Supplied = "cod-exame,cod-comp"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-comp-preco AS CHARACTER FORMAT "X(256)":U 
     LABEL "Componente de Pre‡o" 
     VIEW-AS FILL-IN 
     SIZE 17.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-comp-preco-tx-padr AS CHARACTER FORMAT "X(256)":U 
     LABEL "Comp de Pre‡o Tx Padr" 
     VIEW-AS FILL-IN 
     SIZE 17.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-comp AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 44.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-comp-2 AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 44.29 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82.14 BY 3.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 9.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     comp-exame.char-1 AT ROW 1.25 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2 BY .79
     c-comp-preco AT ROW 2.25 COL 19 COLON-ALIGNED
     c-desc-comp AT ROW 2.25 COL 37 COLON-ALIGNED HELP
          "Descri‡Æo" NO-LABEL
     c-comp-preco-tx-padr AT ROW 3.25 COL 19 COLON-ALIGNED
     c-desc-comp-2 AT ROW 3.25 COL 37 COLON-ALIGNED HELP
          "Descri‡Æo" NO-LABEL
     "Componente Vinculado" VIEW-AS TEXT
          SIZE 16.43 BY .54 AT ROW 1.25 COL 3.57
     rt-key AT ROW 1 COL 1
     RECT-1 AT ROW 1.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.comp-exame
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.5
         WIDTH              = 84.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

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

/* SETTINGS FOR FILL-IN c-comp-preco IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-comp-preco-tx-padr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-comp-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN comp-exame.char-1 IN FRAME f-main
   NO-DISPLAY                                                           */
ASSIGN 
       comp-exame.char-1:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME c-comp-preco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comp-preco V-table-Win
ON F5 OF c-comp-preco IN FRAME f-main /* Componente de Pre‡o */
DO:
    {include/zoomvar.i &prog-zoom  = ggp\gg1014-z01.w
                     &campo        = c-comp-preco
                     &campozoom    = cod-comp 
                     &campo        = c-desc-comp
                     &campozoom2   = descricao}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comp-preco V-table-Win
ON LEAVE OF c-comp-preco IN FRAME f-main /* Componente de Pre‡o */
DO:
    FIND FIRST gg-comp-preco NO-LOCK
        WHERE gg-comp-preco.cod-comp = INPUT FRAME {&FRAME-NAME} c-comp-preco NO-ERROR.
    IF AVAIL gg-comp-preco THEN
        ASSIGN c-desc-comp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gg-comp-preco.descricao.
    ELSE
        ASSIGN c-desc-comp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comp-preco V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-comp-preco IN FRAME f-main /* Componente de Pre‡o */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-comp-preco-tx-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comp-preco-tx-padr V-table-Win
ON F5 OF c-comp-preco-tx-padr IN FRAME f-main /* Comp de Pre‡o Tx Padr */
DO:
    {include/zoomvar.i &prog-zoom  = ggp\gg1014-z01.w
                     &campo        = c-comp-preco-tx-padr
                     &campozoom    = cod-comp 
                     &campo        = c-desc-comp-2
                     &campozoom2   = descricao}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comp-preco-tx-padr V-table-Win
ON LEAVE OF c-comp-preco-tx-padr IN FRAME f-main /* Comp de Pre‡o Tx Padr */
DO:
    FIND FIRST gg-comp-preco NO-LOCK
        WHERE gg-comp-preco.cod-comp = INPUT FRAME {&FRAME-NAME} c-comp-preco-tx-padr NO-ERROR.
    IF AVAIL gg-comp-preco THEN
        ASSIGN c-desc-comp-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gg-comp-preco.descricao.
    ELSE
        ASSIGN c-desc-comp-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comp-preco-tx-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-comp-preco-tx-padr IN FRAME f-main /* Comp de Pre‡o Tx Padr */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  c-comp-preco:LOAD-MOUSE-POINTER("image~\lupa.cur").
  c-comp-preco-tx-padr:LOAD-MOUSE-POINTER("image~\lupa.cur").

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
  {src/adm/template/row-list.i "comp-exame"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "comp-exame"}

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
    
    /*:T Ponha na pi-validate todas as valida‡äes */
    /*:T NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
   
    
   /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    IF INPUT FRAME {&FRAME-NAME} c-comp-preco <> "" THEN 
        IF NOT CAN-FIND (FIRST gg-comp-preco
            WHERE gg-comp-preco.cod-comp = INPUT FRAME {&FRAME-NAME} c-comp-preco) THEN DO:
            
            {utp/ut-liter.i "Componente de Pre‡o" * R}
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 2,
                               INPUT RETURN-VALUE).
            APPLY 'entry' TO c-comp-preco IN FRAME {&FRAME-NAME}.
            RETURN 'ADM-ERROR':U.
    
        END.

    IF INPUT FRAME {&FRAME-NAME} c-comp-preco-tx-padr <> "" THEN
        IF NOT CAN-FIND (FIRST gg-comp-preco
            WHERE gg-comp-preco.cod-comp = INPUT FRAME {&FRAME-NAME} c-comp-preco-tx-padr) THEN DO:
            
            {utp/ut-liter.i "Comp de Pre‡o Tx Padr" * R}
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 2,
                               INPUT RETURN-VALUE).
            APPLY 'entry' TO c-comp-preco-tx-padr IN FRAME {&FRAME-NAME}.
            RETURN 'ADM-ERROR':U.
        END.


    /*:T Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  

     FIND FIRST gg-ext-comp-exame EXCLUSIVE-LOCK
          WHERE gg-ext-comp-exame.cod-exame = comp-exame.cod-exame
            AND gg-ext-comp-exame.cod-comp  = comp-exame.cod-comp NO-ERROR.
     IF AVAIL gg-ext-comp-exame THEN DO:
         ASSIGN gg-ext-comp-exame.comp-preco = INPUT FRAME {&FRAME-NAME} c-comp-preco
                gg-ext-comp-exame.comp-preco-tx-padr = INPUT FRAME {&FRAME-NAME} c-comp-preco-tx-padr.
     END.

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
    disable c-comp-preco
            c-comp-preco-tx-padr
            with frame {&frame-name}. 

   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------            
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
   
   FIND FIRST gg-ext-comp-exame NO-LOCK
        WHERE gg-ext-comp-exame.cod-exame = comp-exame.cod-exame
          AND gg-ext-comp-exame.cod-comp  = comp-exame.cod-comp NO-ERROR.
   IF AVAIL gg-ext-comp-exame THEN DO:      
       ASSIGN c-comp-preco:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gg-ext-comp-exame.comp-preco
              c-comp-preco-tx-padr:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gg-ext-comp-exame.comp-preco-tx-padr.
       APPLY 'leave' TO c-comp-preco IN FRAME {&FRAME-NAME}.
   END.
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

    ENABLE c-comp-preco
           c-comp-preco-tx-padr
           WITH FRAME {&FRAME-NAME}.    

    APPLY 'leave' TO c-comp-preco IN FRAME {&FRAME-NAME}.
    APPLY 'leave' TO c-comp-preco-tx-padr IN FRAME {&FRAME-NAME}.


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

  APPLY 'leave' TO c-comp-preco IN FRAME {&FRAME-NAME}.
  APPLY 'leave' TO c-comp-preco-tx-padr IN FRAME {&FRAME-NAME}.
  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */
    
/*:T    Segue um exemplo de valida‡Æo de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cod-exame" "comp-exame" "cod-exame"}
  {src/adm/template/sndkycas.i "cod-comp" "comp-exame" "cod-comp"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "comp-exame"}

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


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
{include/i-prgvrs.i V01IN01093 2.00.00.006} /* 12/10/2024 11:17:32 */

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN01093 MUT}
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

DEFINE VARIABLE v-row-parent        AS ROWID       NO-UNDO.
DEFINE VARIABLE i-cod-domin         AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ind-modal         AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-cod-class-fisc    AS CHARACTER   NO-UNDO.


DEFINE BUFFER b-dominio-atrib FOR dominio-atrib.

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
&Scoped-define EXTERNAL-TABLES dominio-atrib
&Scoped-define FIRST-EXTERNAL-TABLE dominio-atrib


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR dominio-atrib.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS dominio-atrib.cod-atributo ~
dominio-atrib.cod-domin dominio-atrib.des-domin 
&Scoped-define ENABLED-TABLES dominio-atrib
&Scoped-define FIRST-ENABLED-TABLE dominio-atrib
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-1 fl-desc-atrib 
&Scoped-Define DISPLAYED-FIELDS dominio-atrib.cod-atributo ~
dominio-atrib.cod-domin dominio-atrib.des-domin 
&Scoped-define DISPLAYED-TABLES dominio-atrib
&Scoped-define FIRST-DISPLAYED-TABLE dominio-atrib
&Scoped-Define DISPLAYED-OBJECTS fl-desc-atrib 

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
class-fiscal||y|mgind.classif-atrib.cod-class-fisc
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "cod-class-fisc"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fl-desc-atrib AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 5.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     dominio-atrib.cod-atributo AT ROW 2.21 COL 15.43 COLON-ALIGNED WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .79
     fl-desc-atrib AT ROW 2.21 COL 31.43 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     dominio-atrib.cod-domin AT ROW 4.08 COL 15.43 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .79
     dominio-atrib.des-domin AT ROW 5.08 COL 1.43 WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 55 BY .79
     rt-mold AT ROW 1 COL 1
     RECT-1 AT ROW 1.5 COL 3 WIDGET-ID 68
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgcad.dominio-atrib
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
         HEIGHT             = 5.75
         WIDTH              = 75.
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

/* SETTINGS FOR FILL-IN dominio-atrib.des-domin IN FRAME f-main
   ALIGN-L                                                              */
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

&Scoped-define SELF-NAME dominio-atrib.cod-atributo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dominio-atrib.cod-atributo V-table-Win
ON ENTRY OF dominio-atrib.cod-atributo IN FRAME f-main /* Atributo */
DO:
    APPLY 'entry' TO dominio-atrib.cod-domin IN FRAME {&frame-name}.
    RETURN NO-APPLY.  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "dominio-atrib"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "dominio-atrib"}

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
         
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .  
        
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
        
    IF  adm-new-record THEN DO:

        /* C¢digo do Atributo deve ser obrigat¢rio */
        IF INPUT FRAME {&FRAME-NAME} dominio-atrib.cod-atributo = "" THEN DO:
            {utp/ut-field.i mgind dominio-atrib cod-atributo 1}
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 5793, INPUT return-value).
            APPLY "entry":U TO dominio-atrib.cod-atributo IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR":U.
        END.
        
        /* C¢digo do dominio deve ser obrigat¢rio */
        IF INPUT FRAME {&FRAME-NAME} dominio-atrib.cod-domin = "" THEN DO:
            {utp/ut-field.i mgind dominio-atrib cod-domin 1}
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 5793, INPUT return-value).
            APPLY "entry":U TO dominio-atrib.cod-domin IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR":U.
        END.

        
        IF CAN-FIND (FIRST b-dominio-atrib NO-LOCK 
                     WHERE b-dominio-atrib.cod-atributo   = INPUT FRAME {&FRAME-NAME} dominio-atrib.cod-atributo
                     AND   b-dominio-atrib.cod-domin      = INPUT FRAME {&FRAME-NAME} dominio-atrib.cod-domin) THEN DO:
            {utp/ut-table.i mgind dominio-atrib 1}
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 1, INPUT RETURN-VALUE).
            APPLY "entry":U TO dominio-atrib.cod-domin IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR":U.            
        END.
    END.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /*:T Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */        
        
    /* Somente para Exportaá∆o Ç que deve atualizar a tabela de Destaques */
    IF  i-ind-modal = 1 /* Exportaá∆o */ THEN DO:
        
        /* Como na tabela de Destaques o c¢digo do destaque Ç um inteiro, e na tabela de Atributos Ç um 
           caracter, somente atualiza o Destaques quando for poss°vel a convers∆o de CHAR para INT.
           Esta Ç uma atualizaá∆o tempor†rio, pois futuramente a tabela Destaques ser† descontinuada. */
        
        ASSIGN i-cod-domin = INT(INPUT FRAME {&FRAME-NAME} dominio-atrib.cod-domin) NO-ERROR.
        IF NOT ERROR-STATUS:ERROR AND i-cod-domin <> 0 THEN DO:

            FIND FIRST classif-destaq WHERE classif-destaq.class-fiscal = c-cod-class-fisc
                                      AND   classif-destaq.cod-destaq   = i-cod-domin
                                      EXCLUSIVE-LOCK NO-ERROR.
            IF  NOT AVAIL classif-destaq THEN DO:                
                CREATE classif-destaq.
                ASSIGN classif-destaq.class-fiscal = c-cod-class-fisc
                       classif-destaq.cod-destaq   = i-cod-domin
                       classif-destaq.dsl-destaq   = INPUT FRAME {&FRAME-NAME} dominio-atrib.des-domin. /* Descriá∆o atualiza somente na criaá∆o */
            END.

            ASSIGN OVERLAY(classif-destaq.cod-livre-1,1,10) = STRING(INPUT FRAME {&FRAME-NAME} dominio-atrib.cod-atributo).
        END.
        
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  
  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) . 
    
  /* Code placed here will execute AFTER standard behavior.    */  

  RETURN "OK":U.
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

  RETURN "OK":U.
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
    
    DISABLE dominio-atrib.cod-atributo with frame {&frame-name}.
    
    IF NOT adm-new-record THEN
        DISABLE dominio-atrib.cod-domin with frame {&frame-name}.
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Validaá∆o de dicion†rio */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receive-atrib V-table-Win 
PROCEDURE receive-atrib :
/*------------------------------------------------------------------------------
  Purpose:
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-class-fisc          AS CHARACTER       NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-atrib               AS CHARACTER       NO-UNDO.
    DEFINE INPUT PARAMETER p-des-atrib               AS CHARACTER       NO-UNDO.
    DEFINE INPUT PARAMETER p-ind-modal               AS INTEGER         NO-UNDO.    
    
    ASSIGN dominio-atrib.cod-atrib:SCREEN-VALUE IN FRAME {&frame-name} = p-cod-atrib
           fl-desc-atrib          :SCREEN-VALUE IN FRAME {&frame-name} = p-des-atrib
           c-cod-class-fisc                                            = p-cod-class-fisc
           i-ind-modal                                                 = p-ind-modal.
           
    DISABLE fl-desc-atrib WITH FRAME {&frame-name}.

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
  {src/adm/template/sndkycas.i "class-fiscal" "classif-atrib" "cod-class-fisc"}

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
  {src/adm/template/snd-list.i "dominio-atrib"}

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


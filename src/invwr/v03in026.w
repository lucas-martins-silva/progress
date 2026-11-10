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
{include/i-prgvrs.i V03IN026 2.00.00.002} /*** "010002" 30/07/2026 13:42:08 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN026 MUT}
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
def new global shared var gr-calen-gener as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

DEF VAR c-msg-aux AS CHARACTER NO-UNDO.

{cdp/cdcfgman.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES calen-gener
&Scoped-define FIRST-EXTERNAL-TABLE calen-gener


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR calen-gener.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS calen-gener.descricao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}descricao ~{&FP2}descricao ~{&FP3}
&Scoped-define ENABLED-TABLES calen-gener
&Scoped-define FIRST-ENABLED-TABLE calen-gener
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS calen-gener.cd-calen calen-gener.descricao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS calen-gener.cd-calen calen-gener.descricao 

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
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     calen-gener.cd-calen AT ROW 1.17 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .88
     calen-gener.descricao AT ROW 2.67 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.calen-gener
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
         HEIGHT             = 2.83
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN calen-gener.cd-calen IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN calen-gener.descricao IN FRAME f-main
   1                                                                    */
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
  {src/adm/template/row-list.i "calen-gener"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "calen-gener"}

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

    if ADM-NEW-RECORD then do: 
        find calen-gener where calen-gener.cd-calen = input frame {&frame-name} cd-calen 
             no-lock no-error.   
        if avail calen-gener then do:
          {utp/ut-field.i mgind calen-gener cd-calen 1}.
          run utp/ut-msgs.p (input "show":U, input 7, input return-value).
          return 'ADM-ERROR':U.
        end.     
    end.
    
    if input frame {&frame-name} cd-calen = "" then do:
          {utp/ut-field.i mgind calen-gener cd-calen 1}.
          run utp/ut-msgs.p (input "show":U, input 6216, input return-value).
          return 'ADM-ERROR':U.
    end.
    
   if input frame {&frame-name} descricao = "" then do:
          run utp/ut-msgs.p (input "show":U, input 190, input return-value).
          return 'ADM-ERROR':U.
    end.


    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */

  RUN set-cursor in adm-broker-hdl ("Wait").
  
  IF  AVAIL calen-gener THEN DO:
      ASSIGN c-msg-aux = "".
      RUN pi-valida-relacionamento IN THIS-PROCEDURE (INPUT  calen-gener.cd-calen,
                                                      OUTPUT c-msg-aux).
                                                      
      IF  c-msg-aux <> "" THEN DO:
          {utp/ut-table.i mgind calen-gener 1}
          run utp/ut-msgs.p (input "show", 
                             input 17,
                             input return-value + "~~" + c-msg-aux).
      END.
      ELSE DO:
          RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
      END.                                                      
  END.
  
  RUN set-cursor in adm-broker-hdl ("").

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
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
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
  
  find first calen-gener no-lock no-error.
  if avail calen-gener then
     assign gr-calen-gener = rowid(calen-gener).

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
  
  if avail calen-gener then
     assign gr-calen-gener = rowid(calen-gener).

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
  {src/adm/template/snd-list.i "calen-gener"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-relacionamento V-table-Win 
PROCEDURE pi-valida-relacionamento :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p-cd-calen    AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p-msg-retorno AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE c-msg-aux-frotas      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lFrotasImplantado     AS LOGICAL   NO-UNDO.
  
  IF  CAN-FIND(FIRST equipto
               WHERE equipto.cd-calen = p-cd-calen) THEN DO:
      {utp/ut-table.i mgmnt equipto 1}
      IF  p-msg-retorno <> "" THEN DO:
          ASSIGN p-msg-retorno = p-msg-retorno + ", " + RETURN-VALUE + " (CD0910)".
      END.
      ELSE DO:
          ASSIGN p-msg-retorno = RETURN-VALUE + " (CD0910)".
      END.         
  END.
        
  IF  CAN-FIND(FIRST mi-espec
               WHERE mi-espec.cd-calen = p-cd-calen) THEN DO:
      {utp/ut-table.i mgmnt mi-espec 1}
      IF  p-msg-retorno <> "" THEN DO:
          ASSIGN p-msg-retorno = p-msg-retorno + ", " + RETURN-VALUE + " (MI0103)".
      END.
      ELSE DO:
          ASSIGN p-msg-retorno = RETURN-VALUE + " (MI0103)".
      END.         
  END.

  IF  CAN-FIND(FIRST param-mi
               WHERE param-mi.cd-calen = p-cd-calen) THEN DO:
      {utp/ut-table.i mgmnt param-mi 1}
      IF  p-msg-retorno <> "" THEN DO:
          ASSIGN p-msg-retorno = p-msg-retorno + ", " + RETURN-VALUE + " (MI0101)".
      END.
      ELSE DO:
          ASSIGN p-msg-retorno = RETURN-VALUE + " (MI0101)".
      END.         
  END.
  
  IF  CAN-FIND(FIRST tecn-mi
               WHERE tecn-mi.cd-calen = p-cd-calen) THEN DO:
      {utp/ut-table.i mgmnt tecn-mi 1}
      IF  p-msg-retorno <> "" THEN DO:
          ASSIGN p-msg-retorno = p-msg-retorno + ", " + RETURN-VALUE + " (MI0104)".
      END.
      ELSE DO:
          ASSIGN p-msg-retorno = RETURN-VALUE + " (MI0104)".
      END.         
  END.

  IF  CAN-FIND(FIRST mnt-grup-maquina
               WHERE mnt-grup-maquina.cd-calen = p-cd-calen) THEN DO:
      {utp/ut-table.i mgmnt mnt-grup-maquina 1}
      IF  p-msg-retorno <> "" THEN DO:
          ASSIGN p-msg-retorno = p-msg-retorno + ", " + RETURN-VALUE.
      END.
      ELSE DO:
          ASSIGN p-msg-retorno = RETURN-VALUE.
      END.         
  END.
  
  RUN cdp/cd9902m.p (INPUT 3, OUTPUT lFrotasImplantado).
  IF  lFrotasImplantado THEN DO:
      ASSIGN c-msg-aux-frotas = "".
      RUN mip/mi0900i.p (INPUT   p-cd-calen,
                         OUTPUT  c-msg-aux-frotas).
      IF  c-msg-aux-frotas <> "" THEN DO:
          IF  p-msg-retorno <> "" THEN DO:
              ASSIGN p-msg-retorno = p-msg-retorno + ", " + c-msg-aux-frotas.
          END.
          ELSE DO:
              ASSIGN p-msg-retorno = c-msg-aux-frotas.
          END.         
      END.
  END.      
  
  IF  CAN-FIND(FIRST grup-maquina
               WHERE grup-maquina.cd-calen = p-cd-calen) THEN DO:
      {utp/ut-table.i mgind grup-maquina 1}
      IF  p-msg-retorno <> "" THEN DO:
          ASSIGN p-msg-retorno = p-msg-retorno + ", " + RETURN-VALUE + " (CD0111/SF0103)".
      END.
      ELSE DO:
          ASSIGN p-msg-retorno = RETURN-VALUE + " (CD0111/SF0103)".
      END.         
  END.
  
  IF  CAN-FIND(FIRST param-cp
               WHERE param-cp.cd-calen = p-cd-calen) THEN DO:
      {utp/ut-table.i mgind param-cp 1}
      IF  p-msg-retorno <> "" THEN DO:
          ASSIGN p-msg-retorno = p-msg-retorno + ", " + RETURN-VALUE + " (CP0106)".
      END.
      ELSE DO:
          ASSIGN p-msg-retorno = RETURN-VALUE + " (CP0106)".
      END.         
  END.
  
  /***Verifica se existem Par³metros e æreas de Produ»’o que utilizem o Calendÿrio na vers’o 2.02 ***********/
  &if defined (bf_man_sfc_lc) &then
    IF  CAN-FIND(FIRST param-sfc
                 WHERE param-sfc.cd-calen = p-cd-calen) THEN DO:
        {utp/ut-table.i mgind param-sfc 1}
        IF  p-msg-retorno <> "" THEN DO:
            ASSIGN p-msg-retorno = p-msg-retorno + ", " + RETURN-VALUE + " (SF0101)".
        END.
        ELSE DO:
            ASSIGN p-msg-retorno = RETURN-VALUE + " (SF0101)".
        END.         
    END.
    
    IF  CAN-FIND(FIRST area-produc
                 WHERE area-produc.cd-calen = p-cd-calen) THEN DO:
        {utp/ut-table.i mgind area-produc 1}
        IF  p-msg-retorno <> "" THEN DO:
            ASSIGN p-msg-retorno = p-msg-retorno + ", " + RETURN-VALUE + " (SF0102)".
        END.
        ELSE DO:
            ASSIGN p-msg-retorno = RETURN-VALUE + " (SF0102)".
        END.         
    END.
  &endif    
  
  &IF DEFINED(bf_man_204) &THEN
      DEFINE VARIABLE l-mudancas-sfc AS LOGICAL INITIAL NO NO-UNDO.
      /*verifica se a funcao Mudancas SFC estÿ ativa*/
      RUN sfc/sf9999.p(OUTPUT l-mudancas-sfc).
      IF  l-mudancas-sfc THEN DO:
          /*Valida a exclusao contra a tabela de Operador*/
          IF  CAN-FIND(FIRST operador WHERE 
                                          &IF DEFINED(bf_man_207) &THEN
                                              operador.cd-calend
                                          &else
                                              SUBSTRING(operador.char-1,1,9)
                                          &ENDIF
                                          = calen-gener.cd-calen NO-LOCK) THEN DO:
               {utp/ut-liter.i Operador *}
                IF  p-msg-retorno <> "" THEN DO:
                    ASSIGN p-msg-retorno = p-msg-retorno + ", " + RETURN-VALUE + " (SF0108)".
                END.
                ELSE DO:
                    ASSIGN p-msg-retorno = RETURN-VALUE + " (SF0108)".
                END.         
          END.
      END.
  &ENDIF
  
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




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
{include/i-prgvrs.i V16IN144 2.00.00.010 } /*** "010010" 07/11/2024 10:07:41  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V16IN144 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def buffer b-grup-maquina for grup-maquina.

def var v-row-parent as rowid no-undo.

{cdp/cd0666.i} /* utilizado na trigger de delete */
{com/totvs/datasul/eai/include/error.i } /* rowErrors*/

{cdp/cdapi990.i2} /* tt-cria-pendencia */
    
{cdp/cdcfgman.i}

def new global shared var gr-grup-maquina     as rowid no-undo.
def new global shared var gc-gm-codigo        as char no-undo.


/** Integraá∆o MES X PPI-Multitask **/
DEFINE VARIABLE h-cdapi993      AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-cdapi990      AS HANDLE       NO-UNDO.
DEFINE VARIABLE cXML            AS LONGCHAR     NO-UNDO.
DEFINE VARIABLE cXMLAux         AS LONGCHAR     NO-UNDO.
DEFINE VARIABLE cChave          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-des-msg-ret   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hShowMsg        AS HANDLE       NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES grup-maquina
&Scoped-define FIRST-EXTERNAL-TABLE grup-maquina


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR grup-maquina.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS grup-maquina.gm-codigo 
&Scoped-define ENABLED-TABLES grup-maquina
&Scoped-define FIRST-ENABLED-TABLE grup-maquina
&Scoped-define DISPLAYED-TABLES grup-maquina
&Scoped-define FIRST-DISPLAYED-TABLE grup-maquina
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS grup-maquina.gm-codigo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS grup-maquina.gm-codigo 

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


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     grup-maquina.gm-codigo AT ROW 1.17 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .88
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.grup-maquina
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
         HEIGHT             = 1.29
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN grup-maquina.gm-codigo IN FRAME f-main
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         




  /************************ INTERNAL PROCEDURES ********************/

{database/tgin/tdp/tdin144.i}

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
  {src/adm/template/row-list.i "grup-maquina"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "grup-maquina"}

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

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    
    /** Integraá∆o MES X PPI-Multitask **/    
    FIND FIRST param-cp NO-LOCK NO-ERROR.
    IF AVAIL param-cp AND param-cp.log-integr-ppi-mes THEN DO:
    
        IF AVAIL grup-maquina THEN DO:
            IF NOT VALID-HANDLE(h-cdapi993) OR
               h-cdapi993:TYPE <> "PROCEDURE":U OR
               h-cdapi993:FILE-NAME <> "cdp/cdapi993.p":U THEN DO:
               RUN cdp/cdapi993.p PERSISTENT SET h-cdapi993. 
            END.
            
            IF NOT VALID-HANDLE(h-cdapi990) OR
               h-cdapi990:TYPE <> "PROCEDURE":U OR
               h-cdapi990:FILE-NAME <> "cdp/cdapi990.p":U THEN DO:
               RUN cdp/cdapi990.p PERSISTENT SET h-cdapi990. 
            END.
            
            EMPTY TEMP-TABLE RowErrors NO-ERROR.
                      
            RUN pi-SendDirectUpsert IN h-cdapi993 (INPUT ROWID(grup-maquina),
                                                   OUTPUT cXml,
                                                   OUTPUT cChave,
                                                   OUTPUT TABLE RowErrors).
            
            IF CAN-FIND(FIRST RowErrors ) THEN DO:
                ASSIGN c-des-msg-ret = ""
                       cXMLAux     = cXML.
                
                /* Busca a descriá∆o dos erros para criar a pendencia */
                FOR EACH RowErrors:
                    ASSIGN c-des-msg-ret =  c-des-msg-ret + RowErrors.errorDescription + chr(10) .
                END.
                
                EMPTY TEMP-TABLE RowErrors NO-ERROR.
                
                /** Tela de confirmacao **/
                {utp/ut-liter.i do_grupo_de_m†quina * }
                RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                   INPUT 54394, 
                                   INPUT TRIM(RETURN-VALUE) + " ":U + grup-maquina.gm-codigo).
                IF RETURN-VALUE = "YES":U THEN DO:
                    EMPTY TEMP-TABLE tt-cria-pendencia NO-ERROR.
                    
                    DO WHILE(TRUE):
                        CREATE tt-cria-pendencia.
                        ASSIGN tt-cria-pendencia.cTransaction      = "WorkCenter":U
                               tt-cria-pendencia.cInternalId       = cChave
                               tt-cria-pendencia.cErrorDescription = c-des-msg-ret
                               tt-cria-pendencia.iTipStatus        = 1. /* Pendente com Erro */
                        
                        IF LENGTH(cXMLAux) > 9990 THEN DO:
                            ASSIGN tt-cria-pendencia.cXml  =  SUBSTR(cXMLAux, 1, 9990)
                                   SUBSTR(cXMLAux,1, 9990) = "":U.
                        END.
                        ELSE DO:
                            ASSIGN tt-cria-pendencia.cXml = cXMLAux.
                            LEAVE.        
                        END.
                    END. /*end do while*/
                    
                    RUN createPendency IN h-cdapi990 (INPUT TABLE tt-cria-pendencia,
                                                      OUTPUT TABLE RowErrors).
                END.
                ELSE DO:
                    UNDO, RETURN "ADM-ERROR":U.
                END.
            END.
            ELSE DO:
                /* Se o retorno for ok, verifica se existe pendencia para a chave. Se tiver, exlui */           
                IF CAN-FIND(FIRST pendcia-integr-mes 
                            WHERE pendcia-integr-mes.cod-chave-ident = cChave) THEN
                    RUN deletePendciaByIdentif IN h-cdapi990 (INPUT cChave).
            END.
            
            /* TODO: INCLUIR NA FASE 2 DA INTEGRACAO MES TOTVS ATRAVES DE PARAMETRO
            RUN pi-exporta-mensagem  IN h-cdapi993 (INPUT cXML, 
                                                    INPUT "WorkCenter":U, 
                                                    INPUT cChave,
                                                    INPUT 1, /* Pendente com Erro */
                                                    OUTPUT TABLE rowErrors APPEND). */
            
            IF CAN-FIND(FIRST rowErrors) THEN DO:
                {method/showmessage.i1}     
                {method/showmessage.i2 &Modal="YES"}
                {method/showmessage.i3}  
                RETURN "ADM-ERROR":U.
            END.
        END.
    END.
    
    IF VALID-HANDLE(h-cdapi990) AND
        h-cdapi990:TYPE = "PROCEDURE":U AND
        h-cdapi990:FILE-NAME = "cdp/cdapi990.p":U THEN DO:
        DELETE PROCEDURE h-cdapi990 NO-ERROR.
        ASSIGN h-cdapi990 = ?.
    END. 
    IF VALID-HANDLE(h-cdapi993) AND
        h-cdapi993:TYPE = "PROCEDURE":U AND
        h-cdapi993:FILE-NAME = "cdp/cdapi993.p":U THEN DO:
        DELETE PROCEDURE h-cdapi993 NO-ERROR.
        ASSIGN h-cdapi993 = ?.
    END. 

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

    DEFINE VARIABLE c-turno AS CHARACTER NO-UNDO.
    
    ASSIGN c-turno = "".
    FOR EACH gm-turno-crp WHERE gm-turno-crp.gm-codigo = grup-maquina.gm-codigo :
        ASSIGN c-turno = c-turno + ", " + gm-turno-crp.cod-model-turno.
    END.
    
    IF c-turno <> "" THEN DO:        
        run utp/ut-msgs.p (input "show",
                           input 57926,
                           input grup-maquina.gm-codigo + "~~" + c-turno).
        return "ADM-ERROR".
    END.

    run pi-valida-eliminacao-grup-maquina.
    if  return-value <> "ok" then do:
        run pi-mostra-erros.
        return "ADM-ERROR".
    end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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

    if not adm-new-record then    
       assign grup-maquina.gm-codigo:sensitive in frame {&frame-name} = no.

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

  assign grup-maquina.gm-codigo:sensitive in frame {&frame-name} = no.


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

  if avail grup-maquina then
     assign gr-grup-maquina = rowid(grup-maquina)
            gc-gm-codigo = grup-maquina.gm-codigo.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-erros V-table-Win 
PROCEDURE pi-mostra-erros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

for each tt-erro:
    delete tt-erro.
end.

{database/tgin/tdp/tdin144.i1}

run cdp/cd0666.w (input table tt-erro).

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

  if grup-maquina.gm-codigo:sensitive in frame {&frame-name} = yes
  and can-find (b-grup-maquina where b-grup-maquina.gm-codigo = input frame {&frame-name} grup-maquina.gm-codigo) then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind grup-maquina 1}
      run utp/ut-msgs.p (input "show",
                         input 7,
                         input return-value). 
      apply "entry" to grup-maquina.gm-codigo in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.

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
  {src/adm/template/snd-list.i "grup-maquina"}

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


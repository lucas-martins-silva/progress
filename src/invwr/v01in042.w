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
{include/i-prgvrs.i V01IN042 2.00.01.015 } /*** 010115 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN042 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{cdp/cdcfgman.i}

def buffer b-centro-custo for centro-custo.
def new global shared var gr-centro-custo as rowid no-undo.

def var l-encontrou as logical no-undo.
def var c-estab-ant like gm-estab.cod-estabel no-undo.
{cdp/cd0666.i}

/* Local Definitions for EAI                                   */
&IF DEFINED (bf_man_204) &THEN 
  {cdp/cd9043.i} /* Defini‡Æo da tabela de erros RowErros */
  DEF VAR c-action AS CHARACTER FORMAT "X(8)" NO-UNDO.
  DEFINE TEMP-TABLE tt-eai-centro-custo LIKE centro-custo.
  DEF VAR hShowMsg AS HANDLE NO-UNDO.
  DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 
  DEFINE TEMP-TABLE tt-eai-periodo NO-UNDO
       FIELD periodo LIKE ext-per-custo.periodo. 

&ENDIF

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
&Scoped-define EXTERNAL-TABLES centro-custo
&Scoped-define FIRST-EXTERNAL-TABLE centro-custo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR centro-custo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS centro-custo.descricao ~
centro-custo.cod-estabel 
&Scoped-define ENABLED-TABLES centro-custo
&Scoped-define FIRST-ENABLED-TABLE centro-custo
&Scoped-define DISPLAYED-TABLES centro-custo
&Scoped-define FIRST-DISPLAYED-TABLE centro-custo
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS centro-custo.cc-codigo ~
centro-custo.descricao centro-custo.cod-estabel 
&Scoped-Define DISPLAYED-OBJECTS c-desc 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS centro-custo.cc-codigo 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cc-codigo|y|y|mgind.centro-custo.cc-codigo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cc-codigo",
     Keys-Supplied = "cc-codigo"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     centro-custo.cc-codigo AT ROW 1.17 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     centro-custo.descricao AT ROW 2.67 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 33.43 BY .88
     centro-custo.cod-estabel AT ROW 3.67 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc AT ROW 3.67 COL 38 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.centro-custo
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
         HEIGHT             = 3.92
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

/* SETTINGS FOR FILL-IN c-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN centro-custo.cc-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME centro-custo.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.cod-estabel V-table-Win
ON F5 OF centro-custo.cod-estabel IN FRAME f-main /* Estabel */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=centro-custo.cod-estabel
                     &campozoom=cod-estabel
                     &campo2=c-desc
                     &campozoom2=nome}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.cod-estabel V-table-Win
ON LEAVE OF centro-custo.cod-estabel IN FRAME f-main /* Estabel */
DO:

  if input frame {&frame-name} centro-custo.cod-estabel <> "*" then do:
     {include/leave.i &tabela=estabelec
                      &atributo-ref=nome
                      &variavel-ref=c-desc
                      &where="estabelec.cod-estabel = input frame {&frame-name} centro-custo.cod-estabel"}  
  end.
  else do :
      {utp/ut-liter.i Comum_a_todos_estabelecimentos *}
      assign c-desc:screen-value = return-value .
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.cod-estabel IN FRAME f-main /* Estabel */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if centro-custo.cod-estabel:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/


{database/tgin/tdp/tdin042.i}

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
  DEF VAR key-value AS CHAR NO-UNDO.
  DEF VAR row-avail-enabled AS LOGICAL NO-UNDO.

  /* LOCK status on the find depends on FIELDS-ENABLED. */
  RUN get-attribute ('FIELDS-ENABLED':U).
  row-avail-enabled = (RETURN-VALUE eq 'yes':U).
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'cc-codigo':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = centro-custo
           &WHERE = "WHERE centro-custo.cc-codigo eq key-value"
       }
  END CASE.

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
  {src/adm/template/row-list.i "centro-custo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "centro-custo"}

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  assign c-estab-ant = input frame {&frame-name} centro-custo.cod-estabel.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

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
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.

    /* Ponha aqui a valida‡Æo de chave duplicada */
    IF AVAIL centro-custo THEN DO:

        if centro-custo.cc-codigo:sensitive in frame {&frame-name} = yes
        and can-find(b-centro-custo where b-centro-custo.cc-codigo = input frame {&frame-name} centro-custo.cc-codigo) then do:
            {utp/ut-table.i mgind centro-custo 1}
            run utp/ut-msgs.p (input "show",
                               input 7,
                               input return-value). 
            apply "entry" to centro-custo.cc-codigo in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.  

      if input frame {&frame-name} centro-custo.cod-estabel <> "*" AND 
         INPUT FRAME {&frame-name} centro-custo.cod-estabel <> centro-custo.cod-estabel then do :

           find first gm-estab where
                      gm-estab.cc-codigo   = input frame {&frame-name} centro-custo.cc-codigo and
                      gm-estab.cod-estabel = INPUT FRAME {&frame-name} centro-custo.cod-estabel no-lock no-error.
           if avail gm-estab then do :

              {utp/ut-table.i mgadm estabelec 01}
              run utp/ut-msgs.p (input "show",
                                 input 26929,
                                 input return-value).
              apply 'entry' to centro-custo.cod-estabel in frame {&frame-name}.
              return 'ADM-ERROR':U.  
           end.


           if input frame {&frame-name} centro-custo.cod-estabel = "" then do:
           {utp/ut-table.i mgadm estabelec 01}
           run utp/ut-msgs.p (input "show",
                              input 265,
                              input return-value).
           apply 'entry' to centro-custo.cod-estabel in frame {&frame-name}.
           return 'ADM-ERROR':U.  
           end.


          if not can-find(first estabelec 
                      where estabelec.cod-estabel = input frame {&frame-name} centro-custo.cod-estabel) then do:
                 {utp/ut-table.i mgadm estabelec 01}
                 run utp/ut-msgs.p (input "show",
                                    input 56,
                                    input return-value).
                 apply 'entry' to centro-custo.cod-estabel in frame {&frame-name}.
                 return 'ADM-ERROR':U.                     
          end.

     end.

        if input frame {&frame-name} centro-custo.cod-estabel  = "*" AND 
           INPUT FRAME {&frame-name} centro-custo.cod-estabel <> centro-custo.cod-estabel then do:

           find first gm-estab where
                      gm-estab.cc-codigo = centro-custo.cc-codigo no-lock no-error.
           if avail gm-estab then do :

             {utp/ut-table.i mgind centro-custo 01}
              run utp/ut-msgs.p (input "show",
                                 input 26929,
                                 input return-value).
              apply 'entry' to centro-custo.cod-estabel in frame {&frame-name}.
              return 'ADM-ERROR':U.             

           end.
        end. 
    END.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
       RETURN 'ADM-ERROR':U.

    /* Para execu‡Æo de Adapter da Mensagem Centro Custo - EAI */
    &IF DEFINED (bf_man_204) &THEN 
      IF v_log_eai_habilit THEN DO:
        IF adm-new-record THEN ASSIGN c-action = "add". 
        ELSE ASSIGN c-action = "upd".

        CREATE tt-eai-centro-custo.
        IF AVAIL centro-custo THEN BUFFER-COPY centro-custo TO tt-eai-centro-custo.
        RUN adapters/xml/ma2/axsma001.p (INPUT c-action,
                                         INPUT "cd0110.w",
                                         INPUT STRING(c-prg-vrs),
                                         INPUT  "CAD" , /* Evento */
                                         INPUT TABLE tt-eai-periodo,
                                         INPUT TABLE tt-eai-centro-custo,
                                         OUTPUT TABLE RowErrors).  
        DELETE tt-eai-centro-custo.
        IF AVAIL tt-eai-periodo THEN
           DELETE tt-eai-periodo.

        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:

           {method/showmessage.i1}
           {method/showmessage.i2 &Modal="YES"}
           EMPTY TEMP-TABLE RowErrors NO-ERROR.
           undo, return "ADM-ERROR":U.
        END.
      END.
    &ENDIF

    /* Code placed here will execute AFTER standard behavior.    */



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

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

  run pi-valida-eliminacao-centro-custo.
  if  return-value = "NOK" then do:
      run pi-mostra-erros.
      return "ADM-ERROR".
  end.

  find first gm-estab where
             gm-estab.cc-codigo = input frame {&frame-name} centro-custo.cc-codigo and
             gm-estab.cod-estabel = input frame {&frame-name} centro-custo.cod-estabel  no-lock no-error.
  if avail gm-estab then do :

     {utp/ut-table.i mgadm estabelec 01}
     run utp/ut-msgs.p (input "show",
                        input 26929,
                        input return-value).
     return 'ADM-ERROR':U.  
  end.

    /* Execucao caso usuario possua integracao EAI */
  &IF DEFINED (bf_man_204) &THEN 
    IF v_log_eai_habilit THEN DO:
        FOR EACH tt-eai-centro-custo EXCLUSIVE-LOCK: DELETE tt-eai-centro-custo. END.
        CREATE tt-eai-centro-custo.
        BUFFER-COPY centro-custo TO tt-eai-centro-custo.
    END.
  &ENDIF


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /* Execucao caso usuario possua integracao EAI */
  if NOT RETURN-VALUE = 'ADM-ERROR':U then DO:
    &IF DEFINED (bf_man_204) &THEN 
    IF v_log_eai_habilit THEN DO:
        IF CAN-FIND (FIRST tt-eai-centro-custo) THEN DO:
            RUN adapters/xml/ma2/axsma001.p (INPUT "del",
                                             INPUT "cd0110.w",
                                             INPUT STRING(c-prg-vrs),
                                             INPUT  "CAD" , /* Evento */
                                             INPUT TABLE tt-eai-periodo,
                                             INPUT TABLE tt-eai-centro-custo,
                                             OUTPUT TABLE RowErrors).  
            DELETE tt-eai-centro-custo.
            IF AVAIL tt-eai-periodo THEN
               DELETE tt-eai-periodo.

            IF CAN-FIND (FIRST RowErrors WHERE 
                               RowErrors.ErrorSubType = "ERROR":U) THEN DO:

               {method/showmessage.i1}
               {method/showmessage.i2 &Modal="YES"}
               EMPTY TEMP-TABLE RowErrors NO-ERROR.
               undo, return "ADM-ERROR":U.
            END.
        END.
    END.
  &ENDIF
 END. 


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

  if avail centro-custo then do:
     find first estabelec
          where estabelec.cod-estabel = centro-custo.cod-estabel no-lock no-error.
     assign c-desc = if avail estabelec then estabelec.nome else "".
     if centro-custo.cod-estabel = "*" then do:
         {utp/ut-liter.i Comum_a_todos_estabelecimentos *}
         assign c-desc  = return-value .
     end.

  end.
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
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

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

  /* Code placed here will execute AFTER standard behavior.    */
  if available centro-custo then do :
      assign gr-centro-custo = rowid(centro-custo).

  end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  IF AVAIL centro-custo THEN DO:

      IF input frame {&frame-name} centro-custo.cod-estabel <> centro-custo.cod-estabel THEN DO:
          find first gm-estab where
                     gm-estab.cc-codigo   = input frame {&frame-name} centro-custo.cc-codigo and
                     gm-estab.cod-estabel = centro-custo.cod-estabel no-lock no-error.
          if avail gm-estab then do :

             {utp/ut-table.i mgadm estabelec 01}
             run utp/ut-msgs.p (input "show",
                                input 26929,
                                input return-value).
             assign centro-custo.cod-estabel:screen-value in frame {&FRAME-NAME} = centro-custo.cod-estabel.
             apply "entry" to centro-custo.cod-estabel.
             return 'ADM-ERROR':U.  
          end.
      END.
  END.



  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

   /* Code placed here will execute AFTER standard behavior.    */

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

{database/tgin/tdp/tdin042.i1}

run cdp/cd0666.w (input table tt-erro).

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
  {src/adm/template/sndkycas.i "cc-codigo" "centro-custo" "cc-codigo"}

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
  {src/adm/template/snd-list.i "centro-custo"}

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


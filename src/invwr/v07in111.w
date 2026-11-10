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
{include/i-prgvrs.i V07IN111 2.00.00.036 } /*** 010036 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V07IN111 MUT}
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
def new global shared var v-row-parent      as rowid no-undo.  
def new global shared var gr-item           as rowid no-undo.
def var rw-item-ant                         as rowid no-undo.
/* (1)                               
def new global shared var gr-rot-fabric     as rowid no-undo.
def new global shared var gc-erro-estrutura as char  no-undo.
*/

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def buffer b-estrutura for estrutura.
def buffer b-item      for item.
def buffer b2-item     for item.
def var rw-item       as   rowid                no-undo.
def var v-row-table   as   rowid                no-undo.
/* (2)
def var c-it-codigo   like item.it-codigo       no-undo.
def var c-cod-roteiro like operacao.cod-roteiro no-undo.
*/
def var c-msg-erro    as char format "x(2000)"  no-undo.
def var c-unidade-it  as char                   no-undo.
def var c-unidade     as char                   no-undo.
def var c-es-codigo   as char                   no-undo.
def var c1-es-codigo  like estrutura.es-codigo.

def var c-handles as char no-undo.
def var h-handle  as handle no-undo.

def var i-variacao as integer no-undo.

/** Integraá∆o MES X PPI-Multitask **/
DEFINE VARIABLE h-cdapi1002     AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-cdapi990      AS HANDLE       NO-UNDO.
DEFINE VARIABLE cXML            AS LONGCHAR     NO-UNDO.
DEFINE VARIABLE cXMLAux         AS LONGCHAR     NO-UNDO.
DEFINE VARIABLE cChave          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-des-msg-ret   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hShowMsg        AS HANDLE       NO-UNDO.

{cdp/cdcfgman.i}
{com/totvs/datasul/eai/include/error.i } /* rowErrors*/
{cdp/cdapi990.i2} /* tt-cria-pendencia */

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
&Scoped-define EXTERNAL-TABLES estrutura
&Scoped-define FIRST-EXTERNAL-TABLE estrutura


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estrutura.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estrutura.sequencia 
&Scoped-define ENABLED-TABLES estrutura
&Scoped-define FIRST-ENABLED-TABLE estrutura
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS item.it-codigo item.desc-item ~
estrutura.sequencia estrutura.es-codigo 
&Scoped-define DISPLAYED-TABLES item estrutura
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-define SECOND-DISPLAYED-TABLE estrutura
&Scoped-Define DISPLAYED-OBJECTS c-descricao-1 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS estrutura.sequencia estrutura.es-codigo 
&Scoped-define ADM-ASSIGN-FIELDS estrutura.sequencia estrutura.es-codigo 

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
DEFINE VARIABLE c-descricao-1 AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 55.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.it-codigo AT ROW 1.17 COL 13.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     item.desc-item AT ROW 1.17 COL 31.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 55.43 BY .88
     estrutura.sequencia AT ROW 2.17 COL 13.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     estrutura.es-codigo AT ROW 3.17 COL 13.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao-1 AT ROW 3.17 COL 31.57 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estrutura
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
         HEIGHT             = 3.25
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

/* SETTINGS FOR FILL-IN c-descricao-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estrutura.es-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN item.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estrutura.sequencia IN FRAME f-main
   1 2                                                                  */
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

&Scoped-define SELF-NAME estrutura.es-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estrutura.es-codigo V-table-Win
ON F5 OF estrutura.es-codigo IN FRAME f-main /* Componente */
DO:

   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                      &campo=estrutura.es-codigo
                      &campozoom=it-codigo
                      &campo2=c-descricao-1
                      &campozoom2=desc-item}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estrutura.es-codigo V-table-Win
ON LEAVE OF estrutura.es-codigo IN FRAME f-main /* Componente */
DO:    
/****  Validaá∆o de item inexistente - ksm40435 ****/  
  FIND FIRST b2-ITEM WHERE b2-ITEM.it-codigo = estrutura.es-codigo:screen-value in FRAME {&frame-name} NO-LOCK NO-ERROR.
  IF NOT AVAIL b2-ITEM THEN DO:
        {utp/ut-table.i mgind item 1}
          run utp/ut-msgs.p (input "show",
                             input 56,
                             input return-value).
         APPLY 'ENTRY' TO estrutura.es-codigo IN FRAME {&FRAME-NAME}.
         /*RETURN "ADM-ERROR":U.*/
         RETURN NO-APPLY.
  END.
/****  fim da validaá∆o - ksm40435 ****/   


  FIND  b2-ITEM 
  WHERE b2-item.it-codigo = ITEM.it-codigo:SCREEN-VALUE IN FRAME {&frame-name} NO-LOCK NO-ERROR.
  ASSIGN c-unidade-it =   IF AVAIL b2-ITEM THEN STRING(b2-item.un) ELSE "":U.

  assign rw-item-ant = rowid(item).

  {include/leave.i &tabela=item
                   &atributo-ref=desc-item
                   &variavel-ref=c-descricao-1
                   &where="item.it-codigo = input frame {&frame-name} estrutura.es-codigo"}

/*  find first item
 *     where item.it-codigo = input frame {&frame-name} estrutura.es-codigo no-lock no-error.*/

  assign  c-descricao-1:screen-value in frame {&frame-name} = if avail item then item.desc-item else "":U
          c-unidade   = if avail item then string(item.un) else "":U
          c-es-codigo = estrutura.es-codigo:screen-value.

  assign  gr-item             = rw-item-ant.
  find item where rowid(item) = gr-item no-lock no-error.

  /*** Envia estrutura.es-codigo e item.un para a viewer da p†gina 1         ***/   
  RUN get-link-handle IN adm-broker-hdl (INPUT this-procedure,
                                         INPUT 'chave-target',
                                         OUTPUT c-handles).
  if num-entries (c-handles) = 1 then do:
     assign h-handle = widget-handle (c-handles).
     if valid-handle(h-handle) then  
        run pi-seta-estrutura in h-handle (input c-es-codigo,
                                           INPUT c-unidade-it).
  end. 


  /***************** chamada UPC ****************************************/
  IF c-nom-prog-upc-mg97 <> "":U THEN DO:
      RUN VALUE(c-nom-prog-upc-mg97) (INPUT "LEAVE-ES-CODIGO":U,
                                      INPUT "VIEWER",
                                      INPUT THIS-PROCEDURE:HANDLE,
                                      INPUT FRAME {&frame-name}:HANDLE,
                                      INPUT "item":U,
                                      INPUT ?).      
  END.
  /**********************************************************************/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estrutura.es-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estrutura.es-codigo IN FRAME f-main /* Componente */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  if estrutura.es-codigo:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "estrutura"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estrutura"}

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

  find last param-en no-lock no-error.
  if not avail param-en then
     create param-en.
  find last b-estrutura where b-estrutura.it-codigo = item.it-codigo no-lock no-error.

  if  avail b-estrutura then 
     assign estrutura.sequencia:screen-value in frame {&frame-name} = string(b-estrutura.sequencia + i-variacao).
  else
     assign estrutura.sequencia:screen-value in frame {&frame-name} = string(i-variacao).

  assign c-descricao-1:screen-value in frame {&frame-name} = "".


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
  /*{include/i-valid.i}*/
  /*if  not frame {&frame-name}:validate() then
 *     return 'ADM-ERROR':U.*/

find item where rowid(item) = v-row-parent no-lock no-error.

  run pi-validate.
  


  if return-value = 'ADM-ERROR':U then return 'ADM-ERROR':U.


  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.


  /* Code placed here will execute AFTER standard behavior.    */

   if avail b-item and avail item then
   if  ADM-NEW-RECORD
   and (item.tipo-con-est = 4 or b-item.tipo-con-est = 4) then do:

     run pi-atualiza-ref-estrut.

   end.

   do on error undo, leave:
      validate estrutura.
   end.

   if return-value <> 'ok' AND RETURN-VALUE <> "" then run pi-identifica-erro.

   if return-value <> 'ok' AND RETURN-VALUE <> "" THEN
      UNDO, LEAVE.

   FIND FIRST param-cp NO-LOCK NO-ERROR.
    IF AVAIL param-cp AND param-cp.log-integr-ppi-mes THEN DO:
  
        IF AVAIL estrutura THEN DO:
        
            RUN cdp/cdapi1002.p PERSISTENT SET h-cdapi1002. 
            RUN cdp/cdapi990.p  PERSISTENT SET h-cdapi990. 
            
            EMPTY TEMP-TABLE RowErrors NO-ERROR.
            
            RUN pi-SendDirectUpsert IN h-cdapi1002 (INPUT ROWID(estrutura),
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
                {utp/ut-liter.i da_estrutura * }
                RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                   INPUT 54394, 
                                   INPUT TRIM(RETURN-VALUE) + " ":U + estrutura.it-codigo).

                IF RETURN-VALUE = "YES":U THEN DO:
                    EMPTY TEMP-TABLE tt-cria-pendencia NO-ERROR.
                    
                    DO WHILE(TRUE):
                        CREATE tt-cria-pendencia.
                        ASSIGN tt-cria-pendencia.cTransaction      = "ItemStructure":U
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
                    END. 

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

            IF CAN-FIND(FIRST rowErrors) THEN DO:
                {method/showmessage.i1}     
                {method/showmessage.i2 &Modal="YES"}
                {method/showmessage.i3}  
                RETURN "ADM-ERROR":U.
            END.

            DELETE PROCEDURE h-cdapi990  NO-ERROR. 
            DELETE PROCEDURE h-cdapi1002 NO-ERROR.
        END.
    END.
    
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
   find item where rowid(item) = v-row-parent no-lock no-error.
   if available item  then
        assign estrutura.it-codigo = item.it-codigo.

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

  if  avail estrutura then do:
     find b-item where b-item.it-codigo = input frame {&frame-name} estrutura.es-codigo no-lock no-error.
     assign c-descricao-1:screen-value in frame {&frame-name} = if avail b-item then b-item.desc-item else "":U.
     if adm-new-record = no then do:
          assign c-es-codigo = estrutura.es-codigo:screen-value in frame {&frame-name}.
          /*** Envia estrutura.es-codigo e item.un para a viewer da p†gina 1         ***/   
          RUN get-link-handle IN adm-broker-hdl (INPUT this-procedure,
                                                 INPUT 'chave-target',
                                                 OUTPUT c-handles).
          if num-entries (c-handles) = 1 then do:
          assign h-handle = widget-handle (c-handles).
          if valid-handle(h-handle) then  
          run pi-seta-estrutura in h-handle (input c-es-codigo,
                                             INPUT c-unidade-it).
      end.   
  end.
  end.
  else
     assign c-descricao-1:screen-value = "".

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

  assign estrutura.sequencia:sensitive in frame {&frame-name} = adm-new-record.
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

  find item where rowid(item) = v-row-parent no-lock no-error.
  if not avail item then do:
     {utp/ut-table.i mgind Item 1} 
     run utp/ut-msgs.p (input "show",
                        input 56,
                        input return-value).
     return 'ADM-ERROR':U.
  end. 
  assign rw-item = v-row-parent.

  find first param-en no-lock no-error.
  if not avail param-en then
     create param-en.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-ref-estrut V-table-Win 
PROCEDURE pi-atualiza-ref-estrut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def var v-row-aux as rowid no-undo.

  assign v-row-aux    = v-row-parent
         v-row-parent = rowid(estrutura).

    /*** Se item e/ou componente for controlado por referància ser†  obrigat¢rio
           a inclus∆o de ref-estrut para a estrutura ***/

      /*** S¢ componente controlado por referància ***/

      if item.tipo-con-est <> 4 then do:
         find first ref-estrut
              where ref-estrut.it-codigo = estrutura.it-codigo
              and   ref-estrut.sequencia = estrutura.sequencia
              and   ref-estrut.es-codigo = estrutura.es-codigo
              no-lock no-error.          
         assign v-row-table = if avail ref-estrut then rowid(ref-estrut) else ?.
         run enp/en0105g.w (input v-row-table).
      end.
      else 
        /*** S¢ item pai da estrutura controlado por referància ***/
         if b-item.tipo-con-est <> 4 then 
             run enp/en0105h.w.
         else
             /*** Item pai da estrutura e componente controlados por referància ***/
             run enp/en0105i.w.

       assign v-row-parent = v-row-aux.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-variacao V-table-Win 
PROCEDURE pi-atualiza-variacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-variacao as integer no-undo.

assign i-variacao = p-variacao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-identifica-erro V-table-Win 
PROCEDURE pi-identifica-erro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  assign c-msg-erro = ''. 

  if return-value = 'it00':U  or 
     return-value = 'itob':U  or
     return-value = 'itdd':U  then
     apply 'entry' to estrutura.sequencia in frame {&frame-name}.      

  if return-value = 'cp00':U  or 
     return-value = 'cpob':U  or
     return-value = 'cpdd':U  then
     apply 'entry' to estrutura.es-codigo in frame {&frame-name}.      

{enp/en0105.i "show" 
                 estrutura.it-codigo
                 estrutura.sequencia
                 estrutura.es-codigo
                 0}  


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
/****  Validaá∆o de item inexistente - ksm40435 ****/  
  FIND FIRST b2-ITEM WHERE b2-ITEM.it-codigo = estrutura.es-codigo:screen-value in FRAME {&frame-name} NO-LOCK NO-ERROR.
  IF NOT AVAIL b2-ITEM THEN DO:
      {utp/ut-table.i mgind item 1}
        run utp/ut-msgs.p (input "show",
                           input 56,
                           input return-value).
       APPLY 'ENTRY' TO estrutura.es-codigo IN FRAME {&FRAME-NAME}.
       RETURN "ADM-ERROR":U.
  END.
   /****  fim da validaá∆o - ksm40435 ****/   

   if b2-item.cod-obsoleto >= 3 then do:                                                               
        run utp/ut-msgs.p (input "show",                                                          
                           input 563,                                                             
                           input b2-item.it-codigo).                                                 
        apply 'entry' to estrutura.es-codigo in frame {&frame-name}.                              
        return 'ADM-ERROR':U.                                                                     
   end.  

  /*** Validaá∆o de chave duplicada ***/
  if estrutura.sequencia:sensitive in frame {&frame-name} = yes 
  and can-find(first b-estrutura 
               where b-estrutura.it-codigo = item.it-codigo
               and   b-estrutura.es-codigo = input frame {&frame-name} estrutura.es-codigo  
               and   b-estrutura.sequencia = input frame {&frame-name} estrutura.sequencia) then do:
     {utp/ut-field.i mgind estrutura sequencia 1}
     run utp/ut-msgs.p (input "show",
                        input 1,
                        input return-value).
     apply "entry" to estrutura.sequencia in frame {&frame-name}.
     return "ADM-ERROR":U.
  end.   

  if estrutura.sequencia:sensitive in frame {&frame-name} = yes 
  and can-find(first b-estrutura 
               where b-estrutura.it-codigo = item.it-codigo
               and   b-estrutura.es-codigo = input frame {&frame-name} estrutura.es-codigo  
               and   param-en.log-1 = yes) then do:

     assign c1-es-codigo = input frame {&frame-name} estrutura.es-codigo.
     run utp/ut-msgs.p (input "show",
                        input 15570,
                        input c1-es-codigo + "~~" + item.it-codigo).
  end.                    

  

  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */


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
  {src/adm/template/snd-list.i "estrutura"}

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


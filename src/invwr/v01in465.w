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
{include/i-prgvrs.i V01IN465 2.00.00.016 } /*** 010016 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN465 MUT}
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

def new global shared var v-row-parent as rowid no-undo.   
def new global shared var gr-ferr-prod as rowid no-undo.

def buffer b-ferr-prod for ferr-prod.

/******* Definicoes Integra?Æo MES X PPI-Multitask *******/

{cdp/cd0666.i}                              /* utilizado na trigger de delete */
{com/totvs/datasul/eai/include/error.i }    /* RowErrors*/
{cdp/cdapi990.i2}                           /* tt-cria-pendencia */

def var h-cdapi991   as handle no-undo.
def var h-cdapi990   as handle no-undo.

DEFINE VARIABLE cXML            AS LONGCHAR     NO-UNDO.
DEFINE VARIABLE cXMLAux         AS LONGCHAR     NO-UNDO.
DEFINE VARIABLE cChave          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-des-msg-ret   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hShowMsg        AS HANDLE       NO-UNDO.

{cdp/cd0124.i}                            /* sendMessageFerramenta */

/******* Definicoes Integra?Æo MES X PPI-Multitask *******/

{cdp/cdcfgman.i}

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
&Scoped-define EXTERNAL-TABLES ferr-prod
&Scoped-define FIRST-EXTERNAL-TABLE ferr-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ferr-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ferr-prod.des-ferr-prod ferr-prod.it-codigo 
&Scoped-define ENABLED-TABLES ferr-prod
&Scoped-define FIRST-ENABLED-TABLE ferr-prod
&Scoped-Define ENABLED-OBJECTS RECT-3 rt-key rt-mold c-title 
&Scoped-Define DISPLAYED-FIELDS ferr-prod.cod-ferr-prod ~
ferr-prod.des-ferr-prod ferr-prod.it-codigo 
&Scoped-define DISPLAYED-TABLES ferr-prod
&Scoped-define FIRST-DISPLAYED-TABLE ferr-prod
&Scoped-Define DISPLAYED-OBJECTS c-it-codigo i-un-ciclo c-observacao ~
c-title 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS ferr-prod.cod-ferr-prod 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cod-ferr-prod|y|y|mgind.ferr-prod.cod-ferr-prod
it-codigo||y|mgind.ferr-prod.it-codigo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cod-ferr-prod",
     Keys-Supplied = "cod-ferr-prod,it-codigo"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-observacao AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
     SIZE 60 BY 5.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-title AS CHARACTER FORMAT "X(14)":U 
      VIEW-AS TEXT 
     SIZE 11.57 BY .67 NO-UNDO.

DEFINE VARIABLE i-un-ciclo AS INTEGER FORMAT ">>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.43 BY 5.71.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 9.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ferr-prod.cod-ferr-prod AT ROW 1.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     ferr-prod.des-ferr-prod AT ROW 2.67 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     ferr-prod.it-codigo AT ROW 3.67 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-it-codigo AT ROW 3.67 COL 39.86 COLON-ALIGNED NO-LABEL
     i-un-ciclo AT ROW 4.67 COL 22 COLON-ALIGNED
     c-observacao AT ROW 6 COL 24 NO-LABEL
     c-title AT ROW 5.46 COL 2.72 NO-LABEL
     RECT-3 AT ROW 5.71 COL 2
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ferr-prod
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
         HEIGHT             = 10.71
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

/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR c-observacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-title IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN ferr-prod.cod-ferr-prod IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN i-un-ciclo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       i-un-ciclo:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME ferr-prod.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ferr-prod.it-codigo V-table-Win
ON F5 OF ferr-prod.it-codigo IN FRAME f-main /* Item Ferramenta */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                     &campo=ferr-prod.it-codigo
                     &campozoom=it-codigo}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ferr-prod.it-codigo V-table-Win
ON LEAVE OF ferr-prod.it-codigo IN FRAME f-main /* Item Ferramenta */
DO:
     if input frame {&frame-name} ferr-prod.it-codigo <> "" then do:
        {include/leave.i &tabela=item
                      &atributo-ref=desc-item
                      &variavel-ref=c-it-codigo
                      &where="item.it-codigo = input frame {&frame-name} ferr-prod.it-codigo"}
     end.
     else assign c-it-codigo:screen-value in frame {&frame-name} = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ferr-prod.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ferr-prod.it-codigo IN FRAME f-main /* Item Ferramenta */
DO:
  apply 'F5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

if ferr-prod.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

{utp/ut-liter.i Unidades_Ciclo * R}
assign i-un-ciclo:label in frame {&frame-name} = return-value.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

&if defined (bf_man_sfc_lc) &then
    {inbo/boin465.i1}
&endif

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
    WHEN 'cod-ferr-prod':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = ferr-prod
           &WHERE = "WHERE ferr-prod.cod-ferr-prod eq key-value"
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
  {src/adm/template/row-list.i "ferr-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ferr-prod"}

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

  {utp/ut-liter.i Observa‡Æo * R}
  assign c-title:screen-value in frame {&frame-name} = RETURN-VALUE
         c-observacao:screen-value in frame {&frame-name} = ''.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

def var c-obs   like c-observacao.
def var i-ciclo like i-un-ciclo.

  /* Code placed here will execute PRIOR to standard behavior. */
  /*{include/i-valid.i}*/
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

/**************************** Valida‡Æo de Chave Duplicada **************************/
  if ferr-prod.cod-ferr-prod:sensitive in frame {&frame-name} = yes
  and can-find(b-ferr-prod where 
               b-ferr-prod.cod-ferr-prod = input frame {&frame-name} ferr-prod.cod-ferr-prod) then 
  do:
     {utp/ut-table.i mgind ferr-prod 1}
     run utp/ut-msgs.p (input "show",
                        input 8,
                        input return-value).
     apply 'entry' to ferr-prod.cod-ferr-prod in frame {&frame-name}.
     return 'adm-error':U.
  end.

/**************************** Valida‡Æo de Ferramenta Branco **************************/
  if ferr-prod.cod-ferr-prod:sensitive in frame {&FRAME-NAME} = yes and 
     ferr-prod.cod-ferr-prod:screen-value = "" then do:
     {utp/ut-field.i mgind ferr-prod cod-ferr-prod 1}
     run utp/ut-msgs.p (input "show",
                        input 164,
                        input return-value).
     apply 'entry' to ferr-prod.cod-ferr-prod in frame {&frame-name}.
     return 'adm-error':U.
  end. 


/**************************** Valida‡Æo de Descri‡Æo Branco **************************/
  if ferr-prod.des-ferr-prod:sensitive in frame {&FRAME-NAME} = yes and 
     ferr-prod.des-ferr-prod:screen-value = "" then do:
     {utp/ut-field.i mgind ferr-prod des-ferr-prod 1}
     run utp/ut-msgs.p (input "show",
                        input 164,
                        input return-value).
     apply 'entry' to ferr-prod.des-ferr-prod in frame {&frame-name}.
     return 'adm-error':U.
  end. 

/**************************** Valida‡Æo de Item Inexistente **************************/
  if ferr-prod.it-codigo:sensitive in frame {&frame-name} = yes and 
     ferr-prod.it-codigo:screen-value <> "" and 
     not(can-find(item where item.it-codigo = ferr-prod.it-codigo:screen-value in frame {&frame-name}))
     then do:
     {utp/ut-field.i mgind ferr-prod it-codigo 1}
     run utp/ut-msgs.p (input "show",
                        input 56,
                        input return-value).
     apply 'entry' to ferr-prod.it-codigo in frame {&frame-name}.
     return 'adm-error':U.
  end. 

  assign c-obs = input frame {&frame-name} c-observacao.

  &if defined (bf_man_sfc_lc) &then
      i-ciclo = input frame {&frame-name} i-un-ciclo.
  &endif.

  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  
    DO TRANS:
        /* Dispatch standard ADM method.                             */
        RUN dispatch IN THIS-PROCEDURE (INPUT 'assign-record':U) .
        IF RETURN-VALUE = 'ADM-ERROR':U THEN 
            RETURN 'ADM-ERROR':U.

        /* Code placed here will execute AFTER standard behavior.    */

        &IF DEFINED (bf_man_sfc_lc) &THEN
            ASSIGN ferr-prod.observacao = c-obs
                   ferr-prod.un-ciclo   = i-ciclo.

            IF  ferr-prod.un-ciclo <> 0 THEN
                RUN AlterarUnidadeCiclos(BUFFER ferr-prod).

        &ELSE
            ASSIGN ferr-prod.char-1 = c-obs.
        &ENDIF.

        ASSIGN c-observacao:read-only IN FRAME f-Main = YES. 
        
        /** Integra?Æo MES X PPI-Multitask       **/
        RUN sendMessageFerramenta IN THIS-PROCEDURE (INPUT 0).
        
        IF RETURN-VALUE <> "OK":U THEN
            UNDO, RETURN 'ADM-ERROR':U.
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
    RUN pi-validate.

    /** Integra?Æo MES X PPI-Multitask       **/
    RUN sendMessageFerramenta IN THIS-PROCEDURE (INPUT 1).
    
    IF RETURN-VALUE <> "OK":U THEN
        RETURN 'ADM-ERROR':U.
    
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

  &if defined (bf_man_sfc_lc) &then
      assign i-un-ciclo:sensitive in frame {&frame-name} = no.
  &endif.

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

  if available ferr-prod then do:
     if ferr-prod.it-codigo <> "" then do:
        find item 
            where item.it-codigo = ferr-prod.it-codigo no-lock no-error.
        assign c-it-codigo = if avail item then item.desc-item else "":U.
     end.
     else assign c-it-codigo = "":U. 

     &if defined (bf_man_sfc_lc) &then
         assign c-observacao = ferr-prod.observacao
                i-un-ciclo   = ferr-prod.un-ciclo
                i-un-ciclo:hidden in frame {&frame-name} = no.
     &else
         assign c-observacao = ferr-prod.char-1.
     &endif.
  end. 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-liter.i Observa‡Æo * R}
  assign c-title = return-value.

  ASSIGN c-observacao:sensitive in frame f-Main = YES
         c-observacao:read-only in frame f-Main = yes. 

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

  &if defined (bf_man_sfc_lc) &then
      assign i-un-ciclo:sensitive in frame {&frame-name} = yes.
  &endif.


  ASSIGN c-observacao:read-only in frame f-Main = NO. 

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
  if avail ferr-prod then 
     assign gr-ferr-prod = rowid(ferr-prod).

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
  {database/tgin/tdp/tdin465.i show}
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

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
  {src/adm/template/sndkycas.i "cod-ferr-prod" "ferr-prod" "cod-ferr-prod"}
  {src/adm/template/sndkycas.i "it-codigo" "ferr-prod" "it-codigo"}

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
  {src/adm/template/snd-list.i "ferr-prod"}

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


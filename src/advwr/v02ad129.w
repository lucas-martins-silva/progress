&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V02AD129 2.00.00.024 } /*** "010024" 06/11/2024 14:04:19  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02AD129 MUT}
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
def new global shared var v-row-parent as rowid   no-undo.   
def new global shared var l-exporta    as logical no-undo init no.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-cd0701-cad        as char           no-undo.
def var wh-cd0701-cad       as handle         no-undo.
def var wh-handle-cad       as handle         no-undo.
def var h-acomp             as handle         no-undo.
def var c-usuario           as char           no-undo.
def var i-cont              as int            no-undo.
def var l-f5                as log            no-undo.
def var l-ems2fin-x-mg      as log    init no no-undo.
def var l-assign-record as log no-undo.

{cdp/cdcfgdis.i} /* Include para Pre-Processadores */
{cdp/cdcfgfin.i} /* Definicao de Funá‰es */

define temp-table tt-usuario no-undo
    field user-libcre as char.
    
for each tt-usuario exclusive-lock:
   delete tt-usuario.
end.

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
&Scoped-define EXTERNAL-TABLES gr-cli
&Scoped-define FIRST-EXTERNAL-TABLE gr-cli


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gr-cli.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gr-cli.cod-transp gr-cli.cod-cond-pag ~
gr-cli.cod-rep gr-cli.categoria gr-cli.linha-produt gr-cli.atividade 
&Scoped-define ENABLED-TABLES gr-cli
&Scoped-define FIRST-ENABLED-TABLE gr-cli
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS gr-cli.cod-transp gr-cli.cod-cond-pag ~
gr-cli.cod-rep gr-cli.categoria gr-cli.linha-produt gr-cli.atividade 
&Scoped-define DISPLAYED-TABLES gr-cli
&Scoped-define FIRST-DISPLAYED-TABLE gr-cli
&Scoped-Define DISPLAYED-OBJECTS c-transportador c-desc-condicao ~
c-representante  

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS  

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-condicao AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-representante AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-transportador AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22.86 BY .88 NO-UNDO.

DEFINE VARIABLE idi-niv-aces AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Geral", 1,
"Restrito", 2
     SIZE 12 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21 BY 2.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     gr-cli.cod-transp AT ROW 1 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-transportador AT ROW 1 COL 34.57 COLON-ALIGNED NO-LABEL
     gr-cli.cod-cond-pag AT ROW 2 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-condicao AT ROW 2 COL 31.14 COLON-ALIGNED NO-LABEL
     gr-cli.cod-rep AT ROW 3 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-representante AT ROW 3 COL 34.57 COLON-ALIGNED NO-LABEL
     gr-cli.categoria AT ROW 4 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     idi-niv-aces AT ROW 4.75 COL 55 NO-LABEL WIDGET-ID 14
     gr-cli.linha-produt AT ROW 5 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     gr-cli.atividade AT ROW 6 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     "N°vel de Acesso" VIEW-AS TEXT
          SIZE 15 BY 1 AT ROW 4 COL 54 WIDGET-ID 12
     RECT-1 AT ROW 4.5 COL 53 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.gr-cli
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
         HEIGHT             = 8.04
         WIDTH              = 83.57.
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

/* SETTINGS FOR FILL-IN c-desc-condicao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-representante IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-transportador IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET idi-niv-aces IN FRAME f-main
   NO-ENABLE 3                                                          */
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

&Scoped-define SELF-NAME gr-cli.cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.cod-cond-pag V-table-Win
ON F5 OF gr-cli.cod-cond-pag IN FRAME f-main /* Cond Pagto */
DO:

   assign l-implanta = yes.
   
   {include/zoomvar.i &prog-zoom="adzoom/z01ad039.w"
                      &campo=gr-cli.cod-cond-pag
                      &campozoom=cod-cond-pag}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.cod-cond-pag V-table-Win
ON LEAVE OF gr-cli.cod-cond-pag IN FRAME f-main /* Cond Pagto */
DO:

    find first cond-pagto no-lock
         where cond-pagto.cod-cond-pag = input frame {&FRAME-NAME} gr-cli.cod-cond-pag no-error.
    
    if  avail cond-pagto then do:
        assign c-desc-condicao:screen-value in frame {&FRAME-NAME} = cond-pagto.descricao.
    end.
    else do:
        assign c-desc-condicao:screen-value in frame {&FRAME-NAME} = "".
    end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.cod-cond-pag V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gr-cli.cod-cond-pag IN FRAME f-main /* Cond Pagto */
DO:
  
  apply 'f5' to gr-cli.cod-cond-pag.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gr-cli.cod-rep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.cod-rep V-table-Win
ON F5 OF gr-cli.cod-rep IN FRAME f-main /* Representante */
DO:
   assign l-implanta = yes.
   
  {include/zoom.i &prog-zoom="adzoom/z01ad229.w"
                  &tabela=gr-cli
                  &atributo=cod-rep}
                  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.cod-rep V-table-Win
ON LEAVE OF gr-cli.cod-rep IN FRAME f-main /* Representante */
DO:
  {include/leave.i &tabela=repres 
                   &atributo-ref=nome-abrev
                   &variavel-ref=c-representante
                   &where="repres.cod-rep = input frame {&frame-name} gr-cli.cod-rep"}
  assign c-representante:screen-value in frame {&FRAME-NAME} = if avail repres then 
                                                                  repres.nome-abrev else "":U.                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.cod-rep V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gr-cli.cod-rep IN FRAME f-main /* Representante */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gr-cli.cod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.cod-transp V-table-Win
ON F5 OF gr-cli.cod-transp IN FRAME f-main /* Transportador Padr∆o */
DO:
   assign l-implanta = yes.
    
   {include/zoom.i &prog-zoom="adzoom/z01ad268.w"
                   &tabela=gr-cli
                   &atributo=cod-transp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.cod-transp V-table-Win
ON LEAVE OF gr-cli.cod-transp IN FRAME f-main /* Transportador Padr∆o */
DO:
  {include/leave.i &tabela=transporte 
                   &atributo-ref=nome-abrev
                   &variavel-ref=c-transportador
                   &where="transporte.cod-transp = input frame {&frame-name} gr-cli.cod-transp"}
  assign c-transportador:screen-value in frame {&FRAME-NAME} = if avail transporte then 
                                                                  transporte.nome-abrev else "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.cod-transp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gr-cli.cod-transp IN FRAME f-main /* Transportador Padr∆o */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

   if  gr-cli.cod-transp:load-mouse-pointer    ("image\lupa.cur") in frame {&FRAME-NAME} then.
   if  gr-cli.cod-rep:load-mouse-pointer      ("image\lupa.cur") in frame {&FRAME-NAME} then.
   if  gr-cli.cod-cond-pag:load-mouse-pointer ("image\lupa.cur") in frame {&FRAME-NAME} then.

  &if defined(BF_FIN_EMS2_X_MG) &then
      if can-find(first funcao where funcao.cd-funcao = "spp-ems2fin-x-mg"
                               and funcao.ativo = yes) then assign l-ems2fin-x-mg = yes.
  &endif
  

   
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
  {src/adm/template/row-list.i "gr-cli"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gr-cli"}

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

  {include/i-valid.i}
  
  assign l-assign-record    = yes.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  ASSIGN gr-cli.int-2 = INPUT FRAME {&FRAME-NAME} idi-niv-aces.

  assign l-assign-record    = NO.

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
  
  DISABLE idi-niv-aces WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if  avail gr-cli then do:
      find first transporte
          where transporte.cod-transp = input frame {&FRAME-NAME} gr-cli.cod-transp no-lock no-error.
          assign c-transportador:screen-value in frame {&FRAME-NAME} = if avail transporte then 
                                                                          transporte.nome-abrev else  
                                                                          "":U.
      find first repres
          where repres.cod-rep = input frame {&FRAME-NAME} gr-cli.cod-rep no-lock no-error.
          assign c-representante:screen-value in frame {&FRAME-NAME} = if avail repres then 
                                                                          repres.nome-abrev else 
                                                                          "":U.
      find first cond-pagto no-lock
           where cond-pagto.cod-cond-pag = gr-cli.cod-cond-pag no-error.
    
      if  avail cond-pagto then do:
          assign c-desc-condicao:screen-value in frame {&FRAME-NAME} = cond-pagto.descricao.
      end.
      else do:
          assign c-desc-condicao:screen-value in frame {&FRAME-NAME} = "".
      end.

      IF (NOT l-assign-record) THEN DO:

         ASSIGN idi-niv-aces:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF gr-cli.int-2 = 0 THEN "1" ELSE string(gr-cli.int-2).

      END.
      
             
  end.
     
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
  
  ENABLE idi-niv-aces WITH FRAME {&FRAME-NAME}.
  
 
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
  
  assign l-f5 = no.

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
    
    /***************************/
    /** Valida transportadora **/
    /***************************/
   
    if input frame {&FRAME-NAME} gr-cli.cod-transp <> 0 then do:    
        find first transporte
            where transporte.cod-transp = input frame {&FRAME-NAME} gr-cli.cod-transp
            no-lock no-error.
        if  not avail transporte then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show":U, 
                               input 2190, 
                               input input frame {&FRAME-NAME} gr-cli.cod-transp).
            apply 'entry' to gr-cli.cod-transp in frame {&FRAME-NAME}.                   
            return 'ADM-ERROR':U.
        end.    
    end.    
    
    /**********************************/
    /** Valida condiá∆o de pagamento **/
    /**********************************/
    
    if input frame {&frame-name} gr-cli.cod-cond-pag <> 0 then do:    
        find first cond-pagto where cond-pagto.cod-cond-pag = input frame {&frame-name} gr-cli.cod-cond-pag
        no-lock no-error.
        if not avail cond-pagto then do:
           {include/i-vldprg.i}
           run utp/ut-msgs.p (input "message",
                              input 1088,
                              input "").
           apply 'entry' to gr-cli.cod-cond-pag in frame {&frame-name}.
           return 'ADM-ERROR':U.                   
        end.
    end.    
    
    /**************************/
    /** Valida representante **/
    /**************************/
    
    find first repres
        where repres.cod-rep = input frame {&FRAME-NAME} gr-cli.cod-rep
        no-lock no-error.
    if  not avail repres then do:
        {include/i-vldprg.i}    
        run utp/ut-msgs.p (input "show":U, 
                           input 372, 
                           input input frame {&FRAME-NAME} gr-cli.cod-rep).
        apply 'entry' to gr-cli.cod-rep in frame {&FRAME-NAME}.
        return 'ADM-ERROR':U.
    end.    


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

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "gr-cli"}

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


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
{include/i-prgvrs.i V03AD129 2.00.00.030}  /*** 010030 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03AD129 MUT}
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

/* Definicao TTs e Variaveis - Validacao Decimais - Chile */
{cdp/cd1234.i}

{cdp/cdcfgfin.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid   no-undo.     
def new global shared var gr-gr-cli    as rowid   no-undo.                        
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var h-acomp      as handle  no-undo.
def var i-modalidade as integer no-undo.

/* Integraá∆o do EMS x Magnus */
{cdp/cd0005i1.i}

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
&Scoped-define EXTERNAL-TABLES gr-cli
&Scoped-define FIRST-EXTERNAL-TABLE gr-cli


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gr-cli.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gr-cli.portador gr-cli.nr-tabpre ~
gr-cli.bonificacao gr-cli.tp-rec-desp gr-cli.perc-fat-ped ~
gr-cli.per-max-canc gr-cli.per-minfat 
&Scoped-define ENABLED-TABLES gr-cli
&Scoped-define FIRST-ENABLED-TABLE gr-cli
&Scoped-define DISPLAYED-TABLES gr-cli
&Scoped-define FIRST-DISPLAYED-TABLE gr-cli
&Scoped-Define ENABLED-OBJECTS RECT-18 RECT-22 
&Scoped-Define DISPLAYED-FIELDS gr-cli.portador gr-cli.nr-tabpre ~
gr-cli.bonificacao gr-cli.tp-rec-desp gr-cli.perc-fat-ped ~
gr-cli.per-max-canc gr-cli.per-minfat 
&Scoped-Define DISPLAYED-OBJECTS cb-modalidade c-portador c-receita 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cb-modalidade 
&Scoped-define ADM-ASSIGN-FIELDS cb-modalidade 
&Scoped-define ADM-MODIFY-FIELDS cb-modalidade 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cod-gr-cli|y|y|mgadm.gr-cli.cod-gr-cli
cod-cond-pag||y|mgadm.gr-cli.cod-cond-pag
cod-rep||y|mgadm.gr-cli.cod-rep
cod-transp||y|mgadm.gr-cli.cod-transp
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cod-gr-cli",
     Keys-Supplied = "cod-gr-cli,cod-cond-pag,cod-rep,cod-transp"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-modalidade AS CHARACTER FORMAT "X(20)" INITIAL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20.57 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-portador AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS FILL-IN 
     SIZE 31.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-receita AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 3.25.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 1.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     gr-cli.portador AT ROW 1.25 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
          FONT 1
     cb-modalidade AT ROW 1.25 COL 27.14 COLON-ALIGNED NO-LABEL
     c-portador AT ROW 1.25 COL 47.86 COLON-ALIGNED NO-LABEL
     gr-cli.nr-tabpre AT ROW 2.25 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     gr-cli.bonificacao AT ROW 2.25 COL 66.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     gr-cli.tp-rec-desp AT ROW 3.25 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-receita AT ROW 3.25 COL 23.14 COLON-ALIGNED NO-LABEL
     gr-cli.perc-fat-ped AT ROW 4.75 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     gr-cli.per-max-canc AT ROW 4.75 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     gr-cli.per-minfat AT ROW 4.75 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     RECT-18 AT ROW 1 COL 1
     RECT-22 AT ROW 4.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


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
         HEIGHT             = 5.29
         WIDTH              = 88.14.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-portador IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-receita IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-modalidade IN FRAME f-main
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

&Scoped-define SELF-NAME cb-modalidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-modalidade V-table-Win
ON VALUE-CHANGED OF cb-modalidade IN FRAME f-main
DO:

  apply 'leave' to gr-cli.portador in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gr-cli.nr-tabpre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.nr-tabpre V-table-Win
ON F5 OF gr-cli.nr-tabpre IN FRAME f-main /* Tabela Preáos */
DO:
  
    assign l-implanta = no.
    if  l-ems2fin-x-mg then do:
        run pi-zoom-nr-tabpre-magnus IN THIS-PROCEDURE.
    end.
    else do:
        run pi-zoom-nr-tabpre-ems IN THIS-PROCEDURE.
    end.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.nr-tabpre V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gr-cli.nr-tabpre IN FRAME f-main /* Tabela Preáos */
DO:
  apply 'f5' to gr-cli.nr-tabpre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gr-cli.portador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.portador V-table-Win
ON F5 OF gr-cli.portador IN FRAME f-main /* Portador */
DO:
  assign l-implanta = yes.
   
  {include/zoomvar.i &prog-zoom="adzoom/z01ad209.w"
                     &campo=gr-cli.portador
                     &campozoom=cod-portador}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.portador V-table-Win
ON LEAVE OF gr-cli.portador IN FRAME f-main /* Portador */
DO:

  do  with frame {&frame-name}:
      find first portador 
           where portador.ep-codigo    = i-ep-codigo-usuario
           and   portador.cod-portador = input gr-cli.portador
           and   portador.modalidade   = {adinc/i03ad209.i 06 cb-modalidade:screen-value} no-lock no-error.
      if  avail portador then
          assign c-portador:screen-value = portador.nome-abrev.
      else
          assign c-portador:screen-value = "".
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.portador V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gr-cli.portador IN FRAME f-main /* Portador */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gr-cli.tp-rec-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.tp-rec-desp V-table-Win
ON F5 OF gr-cli.tp-rec-desp IN FRAME f-main /* Tp Recta/Desp */
DO:

     assign l-implanta = yes.
     {include/zoomvar.i &prog-zoom=adzoom/z01ad259.w
                        &campo=gr-cli.tp-rec-desp
                        &campozoom=tp-codigo}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.tp-rec-desp V-table-Win
ON LEAVE OF gr-cli.tp-rec-desp IN FRAME f-main /* Tp Recta/Desp */
DO:
  /* find tipo-rec-desp where tipo-rec-desp.tp-codigo = input frame {&frame-name} gr-cli.tp-rec-desp no-lock no-error.
 *    if avail tipo-rec-desp then
 *       if tipo-rec-desp.tipo = 2 then do:
 *          run utp/ut-msgs.p (input "show",
 *                             input 415,
 *                             input "").
 *          apply 'entry' to gr-cli.tp-rec-desp in frame {&frame-name}.
 *          return no-apply.
 *       end.
 *       else assign c-receita:screen-value in frame {&frame-name} = tipo-rec-desp.descricao.*/
 
  find tipo-rec-desp where tipo-rec-desp.tp-codigo = input frame {&frame-name} gr-cli.tp-rec-desp no-lock no-error.
  if avail tipo-rec-desp then
     assign c-receita:screen-value in frame {&frame-name} = tipo-rec-desp.descricao.
  else assign c-receita:screen-value in frame {&frame-name} = "".   
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.tp-rec-desp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gr-cli.tp-rec-desp IN FRAME f-main /* Tp Recta/Desp */
DO:
  
  apply 'f5' to self.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if  gr-cli.portador:load-mouse-pointer     ("image\lupa.cur") in frame {&FRAME-NAME} then.
  if  gr-cli.tp-rec-desp:load-mouse-pointer  ("image\lupa.cur") in frame {&FRAME-NAME} then.
  if  gr-cli.nr-tabpre:load-mouse-pointer    ("image\lupa.cur") in frame {&FRAME-NAME} then.

  {utp/ut-field.i mgadm gr-cli modalidade 1}
  assign cb-modalidade:list-items   in frame {&FRAME-NAME} = {adinc/i03ad209.i 03}
         cb-modalidade:screen-value in frame {&FRAME-NAME} = {adinc/i03ad209.i 04 1}.

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
    WHEN 'cod-gr-cli':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = gr-cli
           &WHERE = "WHERE gr-cli.cod-gr-cli eq INTEGER(key-value)"
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  {utp/ut-liter.i Perc_Desconto}
  assign gr-cli.bonificacao:label in frame {&frame-name} = return-value.

  if  avail para-ped then do:
      assign gr-cli.nr-tabpre:screen-value       in frame {&frame-name} = string(para-ped.tab-vigor).
  end.

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

  {include/i-valid.i}
   
  
  assign input frame {&FRAME-NAME} cb-modalidade.
  
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  assign gr-cli.modalidade = {adinc/i03ad209.i 06 cb-modalidade}.
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

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    if  avail gr-cli then do:

        find first portador
            where portador.cod-portador = input frame {&FRAME-NAME} gr-cli.portador no-lock no-error.
        
        assign c-portador:screen-value   in frame {&FRAME-NAME} = if avail portador then
                                                                     portador.nome-abrev else "":U.
        assign cb-modalidade:screen-value in frame {&FRAME-NAME}  = {adinc/i03ad209.i 04 gr-cli.modalidade}.
                                                                                                                                         
        find first tipo-rec-desp no-lock
             where  tipo-rec-desp.tp-codigo = gr-cli.tp-rec-desp no-error.
        
        if  avail tipo-rec-desp then do:
            assign c-receita:screen-value in frame {&FRAME-NAME} = tipo-rec-desp.descricao.
        end.
        else do:
            assign c-receita:screen-value in frame {&FRAME-NAME} = "".
        end.

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
  
  &IF DEFINED(BF_FIN_EMS2_X_MG) &THEN
      if  can-find(first funcao
                   where funcao.cd-funcao = "spp-ems2fin-x-mg"
                   and   funcao.ativo     = yes) then
          assign gr-cli.nr-tabpre:format in frame {&frame-name} = "xxx/xx".
  &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-liter.i Perc_Desconto}
  assign gr-cli.bonificacao:label in frame {&frame-name} = trim(return-value).

  find first para-ped no-lock no-error.

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
  
  if avail gr-cli then
     assign gr-gr-cli = rowid (gr-cli).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-modalidade V-table-Win 
PROCEDURE pi-passa-modalidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def output param p-modalidade-ant as char no-undo.
    
    assign p-modalidade-ant = cb-modalidade:screen-value in frame {&FRAME-NAME}.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-nr-tabpre V-table-Win 
PROCEDURE pi-retorna-nr-tabpre :
/*------------------------------------------------------------------------------
  Purpose: RETORNA O VALOR DO NR-TABPRE PARA A VIEWEW V01AD129 PARA QUE O 
           MESMO SEJA CONSISTIDO NO MAGNUS.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER c-nr-tabpre AS CHAR NO-UNDO.
    
    assign c-nr-tabpre = input frame {&frame-name} gr-cli.nr-tabpre.
    
    RETURN "OK":U.
    
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
  def var c-mod as char no-undo.
  
  
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
  
  /** Valida portador **/
  
  assign c-mod        = input frame {&frame-name} cb-modalidade.
         i-modalidade = {adinc/i03ad209.i 06 c-mod}.
  
  if not can-find(first portador where
                        portador.ep-codigo    = i-ep-codigo-usuario and
                        portador.cod-portador = input frame {&frame-name} gr-cli.portador and
                        portador.modalidade   = i-modalidade) then do:
     {include/i-vldprg.i}
     {utp/ut-liter.i Portador }
     run utp/ut-msgs.p (input "show",
                        input 948,
                        input trim(return-value)).
     apply 'entry' to gr-cli.portador in frame {&FRAME-NAME}.
     return 'adm-error'.
  end. 
  
  /** Valida tabela de preáo **/
  
  /*** Quando Estiver integrado com o MAGNUS a tabela de preco sera consistina na v01ad129.w ***/
  
  if  input frame {&frame-name} gr-cli.nr-tabpre <> "" and l-ems2fin-x-mg  = no  then do:  
      find first tb-preco where tb-preco.nr-tabpre = input frame {&frame-name} gr-cli.nr-tabpre 
      no-lock no-error.
      if not avail tb-preco then do:
         {include/i-vldprg.i}
         /* Inicio -- Projeto Internacional */
         {utp/ut-liter.i "Tabela_de_Preáo" *}
         run utp/ut-msgs.p (input "message",
                            input 2,
                            input RETURN-VALUE).
         apply 'entry' to gr-cli.nr-tabpre in frame {&frame-name}.
         return 'ADM-ERROR':U.                   
      end.
  end.    
  
  /** Valida tipo de receita/despesa **/
  
 find first tipo-rec-desp
      where tipo-rec-desp.tp-codigo = input frame {&frame-name} gr-cli.tp-rec-desp 
      no-lock no-error.
 if not avail tipo-rec-desp then do:  
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show",
                         input 3299,
                         input "").
      apply 'entry' to gr-cli.tp-rec-desp in frame {&FRAME-NAME}.
      return 'adm-error'.
 end.
 else do:
     if tipo-rec-desp.tipo <> 1 then do:  
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show",
                            input 415,
                            input "").
         apply 'entry' to gr-cli.tp-rec-desp in frame {&FRAME-NAME}.
         return 'adm-error'.
     end.
 end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-nr-tabpre-ems V-table-Win 
PROCEDURE pi-zoom-nr-tabpre-ems :
/*------------------------------------------------------------------------------
  Purpose:    Retorna o valor do ZOOM do Campo NR-TABPRE do EMS 2
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    assign l-implanta = yes.
   
    {include/zoomvar.i &prog-zoom="dizoom/z01di189.w"
                      &campo=gr-cli.nr-tabpre
                      &campozoom=nr-tabpre}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-nr-tabpre-magnus V-table-Win 
PROCEDURE pi-zoom-nr-tabpre-magnus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    assign l-implanta = no.
   
    {include/zoomvar.i &prog-zoom="dizoom/z05di189.w"
                      &campo=gr-cli.nr-tabpre
                      &campozoom=nr-tabpre}

    RETURN "OK":U.
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
  {src/adm/template/sndkycas.i "cod-gr-cli" "gr-cli" "cod-gr-cli"}
  {src/adm/template/sndkycas.i "cod-cond-pag" "gr-cli" "cod-cond-pag"}
  {src/adm/template/sndkycas.i "cod-rep" "gr-cli" "cod-rep"}
  {src/adm/template/sndkycas.i "cod-transp" "gr-cli" "cod-transp"}

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


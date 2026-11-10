&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgdis            PROGRESS
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
{include/i-prgvrs.i V01IN466 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in466 MUT}
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
def new global shared var gr-res-atp   as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES res-atp
&Scoped-define FIRST-EXTERNAL-TABLE res-atp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR res-atp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS res-atp.dat-atp res-atp.cod-refer ~
res-atp.cod-estabel res-atp.qtd-atp 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}dat-atp ~{&FP2}dat-atp ~{&FP3}~
 ~{&FP1}cod-refer ~{&FP2}cod-refer ~{&FP3}~
 ~{&FP1}cod-estabel ~{&FP2}cod-estabel ~{&FP3}~
 ~{&FP1}qtd-atp ~{&FP2}qtd-atp ~{&FP3}
&Scoped-define ENABLED-TABLES res-atp
&Scoped-define FIRST-ENABLED-TABLE res-atp
&Scoped-Define ENABLED-OBJECTS RECT-1 rt-mold 
&Scoped-Define DISPLAYED-FIELDS item-cli.nome-abrev item-cli.it-codigo ~
res-atp.dat-atp res-atp.cod-refer res-atp.cod-estabel res-atp.qtd-atp 
&Scoped-Define DISPLAYED-OBJECTS c-nome-emit c-desc-item c-ref-descricao ~
c-nome-estabel c-un 

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
DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 43.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 43.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE c-ref-descricao AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 33.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 5.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-cli.nome-abrev AT ROW 1.17 COL 20.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-nome-emit AT ROW 1.17 COL 38.14 COLON-ALIGNED NO-LABEL
     item-cli.it-codigo AT ROW 2.17 COL 20.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 2.17 COL 38.14 COLON-ALIGNED NO-LABEL
     res-atp.dat-atp AT ROW 3.17 COL 20.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     res-atp.cod-refer AT ROW 4.17 COL 20.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-ref-descricao AT ROW 4.17 COL 33.29 COLON-ALIGNED NO-LABEL
     res-atp.cod-estabel AT ROW 5.17 COL 20.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-nome-estabel AT ROW 5.17 COL 28 COLON-ALIGNED NO-LABEL
     res-atp.qtd-atp AT ROW 6.67 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     c-un AT ROW 6.67 COL 37 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1 COL 1
     rt-mold AT ROW 6.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.res-atp
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
         HEIGHT             = 6.75
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

/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-emit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ref-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-cli.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-cli.nome-abrev IN FRAME f-main
   NO-ENABLE                                                            */
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME res-atp.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL res-atp.cod-estabel V-table-Win
ON F5 OF res-atp.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  assign l-implanta = yes. 
  {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                     &campo=res-atp.cod-estabel
                     &campozoom=cod-estabel
                     &campo2=c-nome-estabel
                     &campozoom2=nome-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL res-atp.cod-estabel V-table-Win
ON LEAVE OF res-atp.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-nome-estabel
                   &where="estabelec.cod-estabel = input frame {&frame-name} res-atp.cod-estabel"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL res-atp.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF res-atp.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME res-atp.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL res-atp.cod-refer V-table-Win
ON F5 OF res-atp.cod-refer IN FRAME f-main /* Referˆncia */
DO:
  assign l-implanta = yes. 
  {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                     &campo=res-atp.cod-refer
                     &campozoom=cod-refer
                     &campo2=c-ref-descricao
                     &campozoom2=descricao
                     &parametros="run pi-seta-inicial in wh-pesquisa (input item-cli.it-codigo)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL res-atp.cod-refer V-table-Win
ON LEAVE OF res-atp.cod-refer IN FRAME f-main /* Referˆncia */
DO:
  {include/leave.i &tabela=referencia
                   &atributo-ref=descricao
                   &variavel-ref=c-ref-descricao
                   &where="referencia.cod-refer = input frame {&frame-name} res-atp.cod-refer"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL res-atp.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF res-atp.cod-refer IN FRAME f-main /* Referˆncia */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

if res-atp.cod-refer:load-mouse-pointer("image/lupa.cur") in frame {&frame-name} then.
if res-atp.cod-estabel:load-mouse-pointer("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "res-atp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "res-atp"}

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
  if  res-atp.cod-estabel:screen-value in frame {&frame-name} = "" then do with frame {&frame-name}:
      find estabelec where estabelec.cod-estabel = param-pm.cod-estabel no-lock.
      assign res-atp.cod-estabel:screen-value = param-pm.cod-estabel
             c-nome-estabel = estabelec.nome.
  end. 

  if item.tipo-con-est <> 4 then 
     assign res-atp.cod-refer:sensitive in frame {&frame-name} = no
            c-ref-descricao:sensitive   in frame {&frame-name} = no.
 
  display today + 1   @ res-atp.dat-atp 
          c-desc-item
          c-nome-emit
          c-un 
          c-ref-descricao          
          c-nome-estabel
          with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
def var c-tabela as char no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */
  if not frame {&frame-name}:validate() then
     return 'adm-error':U.
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
  find res-atp where res-atp.it-codigo   = item-cli.it-codigo
               and   res-atp.nome-abrev  = item-cli.nome-abrev
               and   res-atp.cod-refer   = input frame {&frame-name} res-atp.cod-refer
               and   res-atp.dat-atp     = input frame {&frame-name} res-atp.dat-atp 
               /*and   res-atp.cod-estabel = input frame {&frame-name} res-atp.cod-estabel*/
               no-lock no-error.
  if avail res-atp then do:
     {utp/ut-table.i mgind res-atp 1}
     run utp/ut-msgs.p (input "show",
                        input 7,  
                        input return-value).
     apply "entry" to res-atp.dat-atp in frame {&frame-name}.
     return 'ADM-ERROR':U.     
  end.

  /* Code placed here will execute PRIOR to standard behavior. */
      
  /* Ponha aqui as demais valida‡äes */
  if input res-atp.dat-atp <= today then do:
     {utp/ut-field.i mgind res-atp dat-atp 1}
     run utp/ut-msgs.p (input "show",
                        input 173,
                        input return-value).
     apply "entry" to res-atp.dat-atp in frame {&frame-name}.
     return 'ADM-ERROR':U.     
  end.
  
  if input res-atp.qtd-atp <= 0 then do:
     {utp/ut-field.i mgind res-atp qtd-atp 1}
     run utp/ut-msgs.p (input "show",
                        input 1368,
                        input return-value).
     apply "entry" to res-atp.qtd-atp in frame {&frame-name}.
     return 'ADM-ERROR':U.     
  end.

  if item.tipo-con-est = 4
     and not can-find(ref-item where ref-item.it-codigo = item.it-codigo and
         ref-item.cod-refer = input frame {&frame-name} res-atp.cod-refer) then do:
        {utp/ut-table.i mgind referencia 1}
        assign c-tabela = return-value.
        {utp/ut-table.i mgind item 1}
        run utp/ut-msgs.p (input "show",
                           input 2864,
                           input c-tabela + " " + input frame {&frame-name} res-atp.cod-refer + "~~" +
                                 return-value + " " + item.it-codigo).
        apply "entry" to res-atp.cod-refer in frame {&frame-name}.
        return 'ADM-ERROR':U.     
     end.

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  
  /* Code placed here will execute AFTER standard behavior.    */

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
  find item-cli  where rowid(item-cli)  = v-row-parent no-lock.
  assign res-atp.it-codigo   = item-cli.it-codigo
         res-atp.nome-abrev  = item-cli.nome-abrev.
 
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
    
  find item where item.it-codigo = item-cli.it-codigo no-lock no-error.
  assign c-un        = if avail item then item.un else "":U
         c-desc-item = if avail item then item.desc-item else "":U.
  
  find emitente where emitente.nome-abrev = item-cli.nome-abrev no-lock no-error.
  assign c-nome-emit = if avail emitente then emitente.nome-emit else "":U.     
  
  if avail res-atp then do:
     find referencia where referencia.cod-ref = res-atp.cod-refer no-lock no-error.
     assign c-ref-descricao = if avail referencia then referencia.descricao else "":U.
  end.
  
  if  avail res-atp then do:
      find estabelec where estabelec.cod-estabel = res-atp.cod-estabel no-lock no-error.
      assign c-nome-estabel = if avail estabelec then estabelec.nome else "":U.
  end.
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */      
  if  res-atp.cod-estabel:screen-value in frame {&frame-name} = "" then do with frame {&frame-name}:
     find estabelec where estabelec.cod-estabel = param-pm.cod-estabel no-lock no-error.
     assign res-atp.cod-estabel:screen-value = param-pm.cod-estabel
            c-nome-estabel = estabelec.nome.
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
  
  find item where  item.it-codigo = item-cli.it-codigo no-lock no-error. 
  if avail item and item.tipo-con-est <> 4 then 
  assign res-atp.cod-refer:sensitive in frame {&frame-name} = no.  
  
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
  
  find item-cli where rowid(item-cli) = v-row-parent no-lock no-error.
  find first param-pm no-lock.
 
 
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
  if avail res-atp then
     assign gr-res-atp = rowid(res-atp).

  /* Code placed here will execute AFTER standard behavior.    */

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
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
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
  {src/adm/template/snd-list.i "res-atp"}

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



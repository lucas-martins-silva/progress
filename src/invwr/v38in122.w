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
{include/i-prgvrs.i V38IN122 2.00.00.010}  /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v38in122 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

&IF '{&mgscm_version}' >= '2.06B' &THEN
DEFINE VARIABLE hDBOproxy AS HANDLE NO-UNDO.
{method/dbotterr.i}
&ENDIF

{mpp/mpapi007.i}
{mpp/mpapi007.i1}

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
&Scoped-define EXTERNAL-TABLES familia
&Scoped-define FIRST-EXTERNAL-TABLE familia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR familia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-31 
&Scoped-Define DISPLAYED-FIELDS familia.cod-lista-destino 
&Scoped-define DISPLAYED-TABLES familia
&Scoped-define FIRST-DISPLAYED-TABLE familia
&Scoped-Define DISPLAYED-OBJECTS cb-tipo-contr cb-tipo-con-est ~
cb-tipo-requis c-lista-destino c-liter-multi 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cb-tipo-contr cb-tipo-con-est ~
cb-tipo-requis familia.cod-lista-destino 
&Scoped-define ADM-MODIFY-FIELDS cb-tipo-contr cb-tipo-con-est ~
cb-tipo-requis familia.cod-lista-destino 

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
DEFINE VARIABLE cb-tipo-con-est AS CHARACTER FORMAT "X(30)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-contr AS CHARACTER FORMAT "X(25)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-requis AS CHARACTER FORMAT "X(30)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE c-lista-destino AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-liter-multi AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.72 BY 1.79.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.72 BY 4.13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-tipo-contr AT ROW 1.54 COL 28 COLON-ALIGNED HELP
          "Tipo Controle"
     cb-tipo-con-est AT ROW 2.63 COL 28 COLON-ALIGNED HELP
          "Tipo Controle Estoque"
     cb-tipo-requis AT ROW 3.75 COL 28 COLON-ALIGNED HELP
          "Tipo Requisi‡Æo"
     familia.cod-lista-destino AT ROW 6 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     c-lista-destino AT ROW 6 COL 46 COLON-ALIGNED NO-LABEL
     c-liter-multi AT ROW 5.33 COL 3 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
     RECT-31 AT ROW 5.58 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.familia
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
         HEIGHT             = 6.67
         WIDTH              = 86.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
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

/* SETTINGS FOR FILL-IN c-lista-destino IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-liter-multi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tipo-con-est IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-tipo-contr IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-tipo-requis IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN familia.cod-lista-destino IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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

&Scoped-define SELF-NAME cb-tipo-con-est
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-con-est V-table-Win
ON LEAVE OF cb-tipo-con-est IN FRAME f-main
DO:
  if  {ininc/i01in122.i 06 cb-tipo-con-est} = 4
  then do:
      run utp/ut-msgs.p (input "show", 
                         input 908, 
                         input ""). 
      apply 'entry' to cb-tipo-con-est in frame {&frame-name}.
      return 'adm-error':U. 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME familia.cod-lista-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-lista-destino V-table-Win
ON F5 OF familia.cod-lista-destino IN FRAME f-main /* Lista Destino Multiplanta */
DO:

   assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="mpzoom/z01mp043.w"
                     &campo=familia.cod-lista-destino
                     &campozoom=cd-lista-destino
                     &campo2=c-lista-destino
                     &campozoom2=desc-lista-dest}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-lista-destino V-table-Win
ON LEAVE OF familia.cod-lista-destino IN FRAME f-main /* Lista Destino Multiplanta */
DO:
    if  avail param-global
    and param-global.modulo-mp
    then do:

        for each tt-lista-destino:
            delete tt-lista-destino.
        end.
        
        create  tt-lista-destino.
        assign  tt-lista-destino.cod-versao-integracao  = 1
                tt-lista-destino.cd-lista-destino       = input frame {&frame-name} familia.cod-lista-destino.
    
        run mpp/mpapi007.p (input-output table tt-lista-destino,
                            input-output table tt-maq-lista-dest).

        find first tt-lista-destino no-lock no-error.
        if  return-value = "NOK"
        then
            assign c-lista-destino:screen-value = "".
        else
            assign c-lista-destino:screen-value = tt-lista-destino.desc-lista-dest.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-lista-destino V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.cod-lista-destino IN FRAME f-main /* Lista Destino Multiplanta */
DO:
  apply 'f5' to self.
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

 {utp/ut-field.i mgind familia tipo-contr 1} 
 assign cb-tipo-contr:label in frame {&frame-name} = return-value.
 {utp/ut-field.i mgind familia tipo-requis 1}
 assign cb-tipo-requis:label in frame {&frame-name} = return-value.
 {utp/ut-field.i mgind familia tipo-con-est 1}
 assign cb-tipo-con-est:label in frame {&frame-name} = return-value.
 {utp/ut-liter.i Multiplanta * r}
 assign c-liter-multi:screen-value in frame {&frame-name} = trim(return-value).

if familia.cod-lista-destino:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "familia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "familia"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  assign input frame {&frame-name} cb-tipo-contr
         input frame {&frame-name} cb-tipo-con-est
         input frame {&frame-name} cb-tipo-requis. 

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  
  DO WITH  FRAME {&FRAME-NAME} ON ERROR UNDO, RETURN "ADM-ERROR":
     assign familia.tipo-contr        = {ininc/i09in122.i 06 cb-tipo-contr}
            familia.tipo-con-est      = {ininc/i01in122.i 06 cb-tipo-con-est} 
            familia.tipo-requis       = {ininc/i08in122.i 06 cb-tipo-requis}
            familia.cod-lista-destino = input frame {&FRAME-NAME} familia.cod-lista-destino.
     if error-status:error then
        do:
          RUN dispatch  in this-procedure ('show-errors':U).
        end.            
  end.      

  &IF '{&mgscm_version}' >= '2.06B' &THEN
      IF CONNECTED('mgscm') THEN DO: 
          IF NOT VALID-HANDLE(hDBOproxy) THEN
              RUN wmp/wmprx042.p PERSISTENT SET hDBOproxy.
          RUN ReplicaFamilia IN hDBOproxy(INPUT 2,
                                          INPUT familia.fm-codigo, 
                                          INPUT familia.descricao,
                                          INPUT familia.un,
                                          INPUT familia.tipo-con-est,
                                          OUTPUT TABLE RowErrors).
          IF RETURN-VALUE = 'NOK':U THEN DO:
              FOR EACH RowErrors:
                  RUN utp/ut-msgs.p (INPUT "show":U,
                                     INPUT RowErrors.ErrorNumber,
                                     INPUT RowErrors.ErrorParameters).
              END.
              RUN destroy IN hDBOproxy.
              RETURN "ADM-ERROR":U.
          END.
          RUN destroy IN hDBOproxy.
      END.
  &ENDIF


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
 /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
 /*  &if  defined(ADM-MODIFY-FIELDS) &then
  *       disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  *  &endif*/
 
 disable {&adm-create-fields} {&adm-assign-fields} with frame {&frame-name}.
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

/*   if available familia then do:
 *      find lista-destino where lista-destino.cd-lista-destino = familia.cod-lista-destino no-lock no-error.
 *      assign c-lista-destino:screen-value in frame {&frame-name} = if avail lista-destino then lista-destino.desc-lista-dest else "":U
 *             familia.cod-lista-destino:screen-value in frame {&frame-name} = familia.cod-lista-destino.
 *   end.    */

    if  avail param-global
    and param-global.modulo-mp
    then do:

        for each tt-lista-destino:
            delete tt-lista-destino.
        end.
        
        create  tt-lista-destino.
        assign  tt-lista-destino.cod-versao-integracao  = 1
                tt-lista-destino.cd-lista-destino       = if avail familia then familia.cod-lista-destino
                                                          else "".
    
        run mpp/mpapi007.p (input-output table tt-lista-destino,
                            input-output table tt-maq-lista-dest).

        find first tt-lista-destino no-lock no-error.
        
        if  return-value = "NOK" then
            assign c-lista-destino          :screen-value in frame {&FRAME-NAME} = ""
                   familia.cod-lista-destino:screen-value in frame {&FRAME-NAME} = "".
        
        else
            assign c-lista-destino          :screen-value in frame {&FRAME-NAME} = tt-lista-destino.desc-lista-dest
                   familia.cod-lista-destino:screen-value in frame {&FRAME-NAME} = if avail familia then
                                                                                   familia.cod-lista-destino
                                                                                   else "".
    end.

  /* Dispatch standard ADM method.                             */
  
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .*/
  
    if avail familia then do with frame {&frame-name}: 
       assign cb-tipo-contr:screen-value   = {ininc/i09in122.i 04 familia.tipo-contr}
              cb-tipo-requis:screen-value  = {ininc/i08in122.i 04 familia.tipo-requis}
              cb-tipo-con-est:screen-value = {ininc/i01in122.i 04 familia.tipo-con-est}.
    end. 
    else do:
       assign cb-tipo-contr:screen-value   = {ininc/i09in122.i 04 1}
              cb-tipo-requis:screen-value  = {ininc/i08in122.i 04 1}
              cb-tipo-con-est:screen-value = {ininc/i01in122.i 04 1}.  
    end. 
  
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
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* &if  defined(ADM-MODIFY-FIELDS) &then
 *       enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
 *   &endif*/
 
  ENABLE {&adm-assign-fields} with frame {&frame-name}.
 
  if param-global.modulo-mp = yes then
      assign familia.cod-lista-destino:sensitive in frame {&frame-name} = yes.
  
  else
     assign familia.cod-lista-destino:sensitive in frame {&frame-name} = no.

  assign cb-tipo-con-est:sensitive in frame {&frame-name} = no.
 
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

  find first param-global no-lock no-error.   
  
  do  with frame {&frame-name}:
      assign cb-tipo-contr:list-items   = {ininc/i09in122.i 03}
             cb-tipo-requis:list-items  = {ininc/i08in122.i 03}
             cb-tipo-con-est:list-items = {ininc/i01in122.i 03}.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
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
  {src/adm/template/snd-list.i "familia"}

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


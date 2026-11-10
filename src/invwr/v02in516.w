&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mgmfg            PROGRESS
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
{include/i-prgvrs.i V02IN516 2.00.00.006} /*** "010006" 27/08/2024 08:50:28 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN516 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def var v-row-parent as rowid no-undo.

def buffer b-equipe  for equipe-prod.

def var c-label      as char  no-undo.

{cdp/cdcfgman.i}
&IF DEFINED(bf_man_204) &THEN
   {sfc/sf0108.i} /*funcao de tratamento de leave do cod-operador*/    
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
&Scoped-define EXTERNAL-TABLES equipe-prod
&Scoped-define FIRST-EXTERNAL-TABLE equipe-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR equipe-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS equipe-prod.des-equipe ~
equipe-prod.cod-operador equipe-prod.cod-area-produc equipe-prod.num-turno ~
equipe-prod.dat-inic-valid equipe-prod.dat-fim-valid 
&Scoped-define ENABLED-TABLES equipe-prod
&Scoped-define FIRST-ENABLED-TABLE equipe-prod
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS equipe-prod.cod-equipe ~
equipe-prod.des-equipe equipe-prod.cod-operador equipe-prod.cod-area-produc ~
equipe-prod.num-turno equipe-prod.dat-inic-valid equipe-prod.dat-fim-valid 
&Scoped-define DISPLAYED-TABLES equipe-prod
&Scoped-define FIRST-DISPLAYED-TABLE equipe-prod
&Scoped-Define DISPLAYED-OBJECTS c-desc-1 c-desc-2 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS equipe-prod.cod-equipe 
&Scoped-define ADM-MODIFY-FIELDS equipe-prod.des-equipe ~
equipe-prod.cod-operador equipe-prod.cod-area-produc equipe-prod.num-turno ~
equipe-prod.dat-inic-valid equipe-prod.dat-fim-valid 

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
DEFINE VARIABLE c-desc-1 AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 31.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-2 AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 28.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.29.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 5.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     equipe-prod.cod-equipe AT ROW 1.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     equipe-prod.des-equipe AT ROW 2.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     equipe-prod.cod-operador AT ROW 3.75 COL 18.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     c-desc-1 AT ROW 3.75 COL 27.86 COLON-ALIGNED NO-LABEL
     equipe-prod.cod-area-produc AT ROW 4.75 COL 18.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-desc-2 AT ROW 4.75 COL 30.72 COLON-ALIGNED NO-LABEL
     equipe-prod.num-turno AT ROW 5.75 COL 18.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     equipe-prod.dat-inic-valid AT ROW 6.75 COL 18.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     equipe-prod.dat-fim-valid AT ROW 7.75 COL 18.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.equipe-prod
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
         HEIGHT             = 7.96
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

/* SETTINGS FOR FILL-IN c-desc-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN equipe-prod.cod-area-produc IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN equipe-prod.cod-equipe IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN equipe-prod.cod-operador IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN equipe-prod.dat-fim-valid IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN equipe-prod.dat-inic-valid IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN equipe-prod.des-equipe IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN equipe-prod.num-turno IN FRAME f-main
   3                                                                    */
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

&Scoped-define SELF-NAME equipe-prod.cod-area-produc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL equipe-prod.cod-area-produc V-table-Win
ON F5 OF equipe-prod.cod-area-produc IN FRAME f-main /* µrea Produ‡Æo */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in511.w"
                       &campo=equipe-prod.cod-area-produc
                       &campozoom=cod-area-produc
                       &campo2=c-desc-2
                       &campozoom2=des-area-produc}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL equipe-prod.cod-area-produc V-table-Win
ON LEAVE OF equipe-prod.cod-area-produc IN FRAME f-main /* µrea Produ‡Æo */
DO:
    {include/leave.i &tabela=area-produc
                     &atributo-ref=des-area-produc
                     &variavel-ref=c-desc-2
                     &where="area-produc.cod-area-produc = input frame {&frame-name} equipe-prod.cod-area-produc"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL equipe-prod.cod-area-produc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF equipe-prod.cod-area-produc IN FRAME f-main /* µrea Produ‡Æo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME equipe-prod.cod-operador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL equipe-prod.cod-operador V-table-Win
ON F5 OF equipe-prod.cod-operador IN FRAME f-main /* Operador L¡der */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in518.w"
                       &campo=equipe-prod.cod-operador
                       &campozoom=cod-operador
                       &campo2=c-desc-1
                       &campozoom2=nom-operador}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL equipe-prod.cod-operador V-table-Win
ON LEAVE OF equipe-prod.cod-operador IN FRAME f-main /* Operador L¡der */
DO:
    &IF DEFINED(bf_man_204) &THEN
        ASSIGN equipe-prod.cod-operador:SCREEN-VALUE IN FRAME f-main =                     
               fnCodOperador(equipe-prod.cod-operador:SCREEN-VALUE IN FRAME f-main).     
    &ENDIF

    {include/leave.i &tabela=operador
                     &atributo-ref=nom-operador
                     &variavel-ref=c-desc-1
                     &where="operador.cod-operador = input frame {&frame-name} equipe-prod.cod-operador"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL equipe-prod.cod-operador V-table-Win
ON MOUSE-SELECT-DBLCLICK OF equipe-prod.cod-operador IN FRAME f-main /* Operador L¡der */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

if equipe-prod.cod-operador:load-mouse-pointer ("image~\lupa.cur") then.
if equipe-prod.cod-area-produc:load-mouse-pointer ("image~\lupa.cur") then.

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
  {src/adm/template/row-list.i "equipe-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "equipe-prod"}

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

  disp today @ equipe-prod.dat-inic-valid with frame {&frame-name}.

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

    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.    

    IF input frame {&frame-name} equipe-prod.cod-equipe = "":U THEN DO:
        {utp/ut-table.i mgind equipe-prod 01}        
        run utp/ut-msgs.p (input 'show',
                           input 30570,
                           input return-value).
        apply 'entry' to equipe-prod.cod-equipe in frame {&frame-name}.
        return 'ADM-ERROR'.
    END.

    if can-find(first b-equipe where b-equipe.cod-equipe = input frame {&frame-name} equipe-prod.cod-equipe and
                rowid(b-equipe) <> rowid(equipe-prod)) then do:
        {utp/ut-table.i mgind equipe-prod 01}        
        run utp/ut-msgs.p (input 'show',
                           input 8,
                           input return-value).
        apply 'entry' to equipe-prod.cod-equipe in frame {&frame-name}.
        return 'ADM-ERROR'.
    END.

    if input frame {&frame-name} equipe-prod.cod-operador <> "" AND
       input frame {&frame-name} equipe-prod.cod-operador <> "00000000":U then do:
        if not can-find(first operador where
                        operador.cod-operador = input frame {&frame-name} equipe-prod.cod-operador) then do:
           {utp/ut-table.i mgind operador 01}             
           run utp/ut-msgs.p (input 'show',
                              input 56,
                              input return-value).
           apply 'entry' to equipe-prod.cod-operador in frame {&frame-name}.
           return 'ADM-ERROR'.
        end.
    end.

    if input frame {&frame-name} equipe-prod.cod-area-produc <> "" then do:
        if not can-find(first area-produc where
                        area-produc.cod-area-produc = input frame {&frame-name} equipe-prod.cod-area-produc) then do:
           {utp/ut-table.i mgind area-produc 01}             
           run utp/ut-msgs.p (input 'show',
                              input 56,
                              input return-value).
           apply 'entry' to equipe-prod.cod-area-produc in frame {&frame-name}.
           return 'ADM-ERROR'.
        end.
    end.    

    if input frame {&frame-name} equipe-prod.dat-inic-valid > 
       input frame {&frame-name} equipe-prod.dat-fim-valid then do:
       {utp/ut-field.i mgind equipe-prod dat-inic-valid 01}
       assign c-label = return-value.
       {utp/ut-field.i mgind equipe-prod dat-fim-valid 01}
       run utp/ut-msgs.p (input 'show',
                          input 16906,
                          input c-label + "~~" + return-value).
       apply 'entry' to equipe-prod.dat-inic-valid in frame {&frame-name}.
       return 'ADM-ERROR'.
    end.

    if input frame {&frame-name} equipe-prod.dat-fim-valid < today then do:
       run utp/ut-msgs.p (input 'show',
                          input 16935,
                          input "").
       apply 'entry' to equipe-prod.dat-fim-valid in frame {&frame-name}.
       return 'ADM-ERROR'.
    end.    

    if input frame {&frame-name} equipe-prod.cod-operador <> "" AND 
       input frame {&frame-name} equipe-prod.cod-operador <> "00000000":U AND
       input frame {&frame-name} equipe-prod.cod-area-produ <> "" then do:
       
       FIND first operador where
                  operador.cod-operador = input frame {&frame-name} equipe-prod.cod-operador NO-LOCK NO-ERROR.

       IF operador.cod-area-produ <> "" AND
          operador.cod-area-produ <> input frame {&frame-name} equipe-prod.cod-area-produ THEN DO:

           {utp/ut-table.i mgind equipe-prod 01}
           run utp/ut-msgs.p (input 'show',
                              input 30886,
                              input return-value).
           apply 'entry' to equipe-prod.cod-equipe in frame {&frame-name}.
           return 'ADM-ERROR'.
       END.
    END.

    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    IF equipe-prod.cod-operador = "00000000":U THEN
        ASSIGN equipe-prod.cod-operador = "":U.

/*     if input frame {&frame-name} equipe-prod.cod-operador <> "" AND                                            */
/*        input frame {&frame-name} equipe-prod.cod-operador <> "0000000":U AND                                    */
/*        input frame {&frame-name} equipe-prod.cod-area-produ <> "" then do:                                     */
/*                                                                                                                */
/*        FIND first operador where                                                                               */
/*                   operador.cod-operador = input frame {&frame-name} equipe-prod.cod-operador NO-LOCK NO-ERROR. */
/*        IF operador.cod-area-produ <> "" AND                                                                    */
/*           operador.cod-area-produ <> input frame {&frame-name} equipe-prod.cod-area-produ THEN DO:             */
/*                                                                                                                */
/*            {utp/ut-table.i mgind equipe-prod 01}                                                               */
/*            run utp/ut-msgs.p (input 'show',                                                                    */
/*                               input 30886,                                                                     */
/*                               input return-value).                                                             */
/*            apply 'entry' to equipe-prod.cod-equipe in frame {&frame-name}.                                     */
/*            return 'ADM-ERROR'.                                                                                 */
/*        END.                                                                                                    */

    IF equipe-prod.cod-operador <> "" AND 
       not can-find(first equipe-operador 
                    where equipe-operador.cod-equipe   = equipe-prod.cod-equipe 
                      AND equipe-operador.cod-operador = equipe-prod.cod-operador) then do:
          create equipe-operador.
          assign equipe-operador.cod-equipe     = equipe-prod.cod-equipe
                 equipe-operador.cod-operador   = equipe-prod.cod-operador
                 equipe-operador.dat-inic-valid = equipe-prod.dat-inic-valid
                 equipe-operador.dat-fim-valid  = equipe-prod.dat-fim-valid.
    end.
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    if   available equipe-prod then do:
         find operador where operador.cod-operador = equipe-prod.cod-operador no-lock no-error.
         assign c-desc-1 = if avail operador then operador.nom-operador else "":U.
         find area-produc where area-produc.cod-area-produc = equipe-prod.cod-area-produc no-lock no-error.
         assign c-desc-2 = if avail area-produc then area-produc.des-area-produc else "":U.
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
  {src/adm/template/snd-list.i "equipe-prod"}

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


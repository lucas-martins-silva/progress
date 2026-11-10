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
{include/i-prgvrs.i V03IN283 2.00.01.005}  /*** 010105 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v03in283 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def buffer b-param-crp for param-crp.

def var v-row-parent as rowid  no-undo.
def var c-desc       as char   no-undo.
def var c-codigo     as char   no-undo.
def var i-cont       as int    no-undo.
def var h-acomp      as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-crp
&Scoped-define FIRST-EXTERNAL-TABLE param-crp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-crp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-crp.qtd-horizon-atraso ~
param-crp.qtd-horizon-carga param-crp.cod-calend-crp ~
param-crp.cod-model-turno 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}qtd-horizon-atraso ~{&FP2}qtd-horizon-atraso ~{&FP3}~
 ~{&FP1}qtd-horizon-carga ~{&FP2}qtd-horizon-carga ~{&FP3}~
 ~{&FP1}cod-calend-crp ~{&FP2}cod-calend-crp ~{&FP3}~
 ~{&FP1}cod-model-turno ~{&FP2}cod-model-turno ~{&FP3}
&Scoped-define ENABLED-TABLES param-crp
&Scoped-define FIRST-ENABLED-TABLE param-crp
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS param-crp.qtd-horizon-atraso ~
param-crp.qtd-horizon-carga param-crp.cod-calend-crp ~
param-crp.cod-model-turno param-crp.log-calc-autom-pl ~
param-crp.log-calc-online-cp 
&Scoped-Define DISPLAYED-OBJECTS c-desc-calen c-desc-model 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS param-crp.qtd-horizon-atraso ~
param-crp.qtd-horizon-carga param-crp.cod-calend-crp ~
param-crp.cod-model-turno 
&Scoped-define ADM-ASSIGN-FIELDS param-crp.qtd-horizon-atraso ~
param-crp.qtd-horizon-carga param-crp.cod-calend-crp ~
param-crp.cod-model-turno 
&Scoped-define ADM-MODIFY-FIELDS param-crp.qtd-horizon-atraso ~
param-crp.qtd-horizon-carga param-crp.cod-calend-crp ~
param-crp.cod-model-turno 

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
DEFINE VARIABLE c-desc-calen AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 33.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-model AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 33.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 4.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-crp.qtd-horizon-atraso AT ROW 1.38 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     param-crp.qtd-horizon-carga AT ROW 2.38 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     param-crp.cod-calend-crp AT ROW 3.38 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.14 BY .88
     param-crp.cod-model-turno AT ROW 4.38 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.14 BY .88
     param-crp.log-calc-autom-pl AT ROW 1.38 COL 46.57
          VIEW-AS TOGGLE-BOX
          SIZE 32 BY .83
     param-crp.log-calc-online-cp AT ROW 2.38 COL 46.57
          VIEW-AS TOGGLE-BOX
          SIZE 20.57 BY .83
     c-desc-calen AT ROW 3.38 COL 44.57 COLON-ALIGNED NO-LABEL
     c-desc-model AT ROW 4.38 COL 44.57 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-crp
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
         HEIGHT             = 4.5
         WIDTH              = 85.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-calen IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-model IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN param-crp.cod-calend-crp IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN param-crp.cod-model-turno IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR TOGGLE-BOX param-crp.log-calc-autom-pl IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       param-crp.log-calc-autom-pl:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX param-crp.log-calc-online-cp IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       param-crp.log-calc-online-cp:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN param-crp.qtd-horizon-atraso IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN param-crp.qtd-horizon-carga IN FRAME f-main
   1 2 3                                                                */
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

&Scoped-define SELF-NAME param-crp.cod-calend-crp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-crp.cod-calend-crp V-table-Win
ON F5 OF param-crp.cod-calend-crp IN FRAME f-main /* Calend†rio Padr∆o */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in026.w"
                   &campo=param-crp.cod-calend-crp
                   &campozoom=cd-calen
                   &campo2=c-desc-calen
                   &campozoom2=descricao}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-crp.cod-calend-crp V-table-Win
ON LEAVE OF param-crp.cod-calend-crp IN FRAME f-main /* Calend†rio Padr∆o */
DO:
    {include/leave.i &tabela=calen-gener 
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-calen
                     &where="calen-gener.cd-calen = input frame {&frame-name} param-crp.cod-calend-crp"} 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-crp.cod-calend-crp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-crp.cod-calend-crp IN FRAME f-main /* Calend†rio Padr∆o */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-crp.cod-model-turno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-crp.cod-model-turno V-table-Win
ON F5 OF param-crp.cod-model-turno IN FRAME f-main /* Modelo Turno Padr∆o */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in467.w"
                   &campo=param-crp.cod-model-turno
                   &campozoom=cod-model-turno
                   &campo2=c-desc-model
                   &campozoom2=des-model-turno}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-crp.cod-model-turno V-table-Win
ON LEAVE OF param-crp.cod-model-turno IN FRAME f-main /* Modelo Turno Padr∆o */
DO:
    {include/leave.i &tabela=model-turno-semana 
                     &atributo-ref=des-model-turno
                     &variavel-ref=c-desc-model
                     &where="model-turno-semana.cod-model-turno = input frame {&frame-name} param-crp.cod-model-turno"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-crp.cod-model-turno V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-crp.cod-model-turno IN FRAME f-main /* Modelo Turno Padr∆o */
DO:
    apply 'F5' to self.
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

if param-crp.cod-model-turno:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if param-crp.cod-calend-crp:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "param-crp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-crp"}

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

    run pi-validate.

    if RETURN-VALUE = 'ADM-ERROR':U then 
       return 'ADM-ERROR':U.

    if  input frame {&frame-name} param-crp.cod-calend-crp = ? then
        run pi-gera-calendario.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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

   RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    if  avail param-crp then do:
        find first calen-gener 
             where calen-gener.cd-calen = param-crp.cod-calend-crp no-lock no-error.
        assign c-desc-calen = if avail calen-gener 
                              then calen-gener.descricao
                              else "":U.

        find first model-turno-semana 
             where model-turno-semana.cod-model-turno = param-crp.cod-model-turno no-lock no-error. 
        assign c-desc-model = if avail model-turno-semana then model-turno-semana.des-model-turno
                              else "":U.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  if RETURN-VALUE = 'ADM-ERROR':U then 
      return 'ADM-ERROR':U.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     return 'ADM-ERROR':U.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-calendario V-table-Win 
PROCEDURE pi-gera-calendario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{utp/ut-liter.i Calend†rio_Produá∆o_-_CRP * R}
assign c-desc = trim(return-value).

assign c-codigo = "PROD-CRP".

run utp/ut-acomp.p persistent set h-acomp.

{utp/ut-liter.i Geraá∆o_Calend†rio *}
run pi-inicializar in h-acomp (input  Return-value ).

find first param-cp no-lock no-error.

find calen-gener
     where calen-gener.cd-calen = c-codigo no-lock no-error.
if  not avail calen-gener then do:
    create calen-gener.
    assign calen-gener.cd-calen  = c-codigo
           calen-gener.descricao = c-desc.
end.
else do:
    /*** Elimina todas as datas do calendario para depois
         recria-las ***/
    for each calen-data EXCLUSIVE-LOCK
        where calen-data.cd-calen = calen-gener.cd-calen
          and calen-data.data    >= today:
        delete calen-data.
    end.
end.

/*** Cria as datas do calendario conforme o calendario da
     producao ***/

for each calen-prod
    where calen-prod.cod-estabel = param-cp.cod-estabel
      and calen-prod.data       >= today no-lock:

    run pi-acompanhar in h-acomp (input c-codigo + " - " + string(calen-prod.data,"99/99/9999")).

    create calen-data.
    assign calen-data.cd-calen  = calen-gener.cd-calen
           calen-data.data      = calen-prod.data
           calen-data.tipo-dia  = calen-prod.tipo-dia
           calen-data.dia-manut = calen-prod.dia-manut.

    do  i-cont = 1 to 8:
        assign calen-data.turno[i-cont]    = calen-prod.turno[i-cont]
               calen-data.hora-ini[i-cont] = calen-prod.hora-ini[i-cont]
               calen-data.hora-fin[i-cont] = calen-prod.hora-fin[i-cont].

    end.
end.                                                           

disp calen-gener.cd-calen  @ param-crp.cod-calend-crp
     calen-gener.descricao @ c-desc-calen
     with frame {&frame-name}.

run pi-finalizar in h-acomp.

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

    /* Verifica se existe o calend†rio */
    find calen-gener where calen-gener.cd-calen = input frame {&frame-name} param-crp.cod-calend-crp
         no-lock no-error.
    if not avail calen-gener and input frame {&frame-name} param-crp.cod-calend-crp <> ? then do:     
        /* Este include deve ser colocado sempre antes do ut-msgs.p */
        {include/i-vldprg.i}
        {utp/ut-table.i mgind calen-gener 1}
        run utp/ut-msgs.p (input "show":U, input 56, input return-value).
        apply 'entry' to param-crp.cod-calend-crp.
        return 'ADM-ERROR':U.
    end.    

    /* Verifica se existe o modelo de turno */
    find model-turno-semana where model-turno-semana.cod-model-turno = input frame {&frame-name} param-crp.cod-model-turno
         no-lock no-error.
    if not avail model-turno-semana then do:     
        /* Este include deve ser colocado sempre antes do ut-msgs.p */
        {include/i-vldprg.i}
        {utp/ut-table.i mgind model-turno-semana 1}
        run utp/ut-msgs.p (input "show":U, input 56, input return-value).
        apply 'entry' to param-crp.cod-model-turno.
        return 'ADM-ERROR':U.
    end.    

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
  {src/adm/template/snd-list.i "param-crp"}

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



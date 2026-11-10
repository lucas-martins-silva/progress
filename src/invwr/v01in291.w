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
{include/i-prgvrs.i V01IN291 2.00.01.003}  /*** 010103 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in291 MUT}
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
&Scoped-define EXTERNAL-TABLES param-pm
&Scoped-define FIRST-EXTERNAL-TABLE param-pm


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-pm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-pm.cod-estabel param-pm.cd-calend ~
param-pm.cd-plano-atp param-pm.calc-atp-cot param-pm.num-var-recurso 
&Scoped-define ENABLED-TABLES param-pm
&Scoped-define FIRST-ENABLED-TABLE param-pm
&Scoped-define DISPLAYED-TABLES param-pm
&Scoped-define FIRST-DISPLAYED-TABLE param-pm
&Scoped-Define ENABLED-OBJECTS fi-programa c-integracao c-bancos rt-mold 
&Scoped-Define DISPLAYED-FIELDS param-pm.cod-estabel param-pm.cd-calend ~
param-pm.cd-plano-atp param-pm.calc-atp-cot param-pm.num-var-recurso 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel c-cd-calend c-desc-plano ~
fi-programa c-integracao c-bancos 

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
DEFINE VARIABLE c-integracao AS CHARACTER FORMAT "X(7)":U 
     LABEL "Integraá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "EMS","Magnus" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE c-bancos AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 87 BY 4 NO-UNDO.

DEFINE VARIABLE c-cd-calend AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-plano AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE fi-programa AS CHARACTER FORMAT "X(60)":U 
     LABEL "Atualiza Prev. Vendas" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 11.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-pm.cod-estabel AT ROW 1.17 COL 32.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-cod-estabel AT ROW 1.17 COL 37.72 COLON-ALIGNED NO-LABEL
     param-pm.cd-calend AT ROW 2.17 COL 32.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .88
     c-cd-calend AT ROW 2.17 COL 80 RIGHT-ALIGNED NO-LABEL
     param-pm.cd-plano-atp AT ROW 3.17 COL 32.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-desc-plano AT ROW 3.17 COL 46.57 COLON-ALIGNED NO-LABEL
     param-pm.calc-atp-cot AT ROW 4.17 COL 32.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     param-pm.num-var-recurso AT ROW 5.17 COL 32.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-programa AT ROW 6.17 COL 32.29 COLON-ALIGNED
     c-integracao AT ROW 7.17 COL 32.29 COLON-ALIGNED
     c-bancos AT ROW 8.5 COL 2 NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-pm
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
         HEIGHT             = 11.75
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

/* SETTINGS FOR FILL-IN c-cd-calend IN FRAME f-main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-plano IN FRAME f-main
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





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-integracao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-integracao V-table-Win
ON VALUE-CHANGED OF c-integracao IN FRAME f-main /* Integraá∆o */
DO:

  IF c-integracao:SCREEN-VALUE IN FRAME {&frame-name} = "EMS" 
  THEN ASSIGN c-bancos:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  ELSE ASSIGN c-bancos:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-pm.cd-calend
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-pm.cd-calend V-table-Win
ON F5 OF param-pm.cd-calend IN FRAME f-main /* Calend†rio */
DO:
   {include/zoomvar.i &prog-zoom=inzoom/z01in026.w
                      &campo=param-pm.cd-calend
                      &campozoom=cd-calen
                      &campo2=c-cd-calend
                      &campozoom2=descricao}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-pm.cd-calend V-table-Win
ON LEAVE OF param-pm.cd-calend IN FRAME f-main /* Calend†rio */
DO:
  {include/leave.i &tabela=calen-gener
                   &atributo-ref=descricao
                   &variavel-ref=c-cd-calend
                   &where="calen-gener.cd-calen = input frame {&frame-name} param-pm.cd-calend"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-pm.cd-calend V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-pm.cd-calend IN FRAME f-main /* Calend†rio */
DO:
   apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-pm.cd-plano-atp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-pm.cd-plano-atp V-table-Win
ON F5 OF param-pm.cd-plano-atp IN FRAME f-main /* Plano MPS Para ATP */
DO:
   {include/zoomvar.i &prog-zoom=inzoom/z01in313.w
                      &campo=param-pm.cd-plano-atp
                      &campozoom=cd-plano
                      &campo2=c-desc-plano
                      &campozoom2=descricao}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-pm.cd-plano-atp V-table-Win
ON LEAVE OF param-pm.cd-plano-atp IN FRAME f-main /* Plano MPS Para ATP */
DO:
    {include/leave.i &tabela=pl-mest
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-plano
                     &where="pl-mest.cd-plano = input frame {&frame-name} param-pm.cd-plano-atp"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-pm.cd-plano-atp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-pm.cd-plano-atp IN FRAME f-main /* Plano MPS Para ATP */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-pm.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-pm.cod-estabel V-table-Win
ON F5 OF param-pm.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                     &campo=param-pm.cod-estabel
                     &campozoom=cod-estabel
                     &campo2=c-cod-estabel
                     &campozoom2=nome}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-pm.cod-estabel V-table-Win
ON LEAVE OF param-pm.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
   assign l-implanta = yes.
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-cod-estabel
                   &where="estabelec.cod-estabel = input frame {&frame-name} param-pm.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-pm.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-pm.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
   apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-programa V-table-Win
ON F5 OF fi-programa IN FRAME f-main /* Atualiza Prev. Vendas */
or 'mouse-select-dblclick' of fi-programa do:

    def var c-arquivo as char no-undo.
    def var l-ok      as log  no-undo.

    system-dialog get-file c-arquivo
       filters "*.r" "*.r"
       ask-overwrite 
       default-extension "r"
       initial-dir entry (1, propath) 
       use-filename update l-ok.

    if l-ok then
        if search (c-arquivo) <> ? then
            assign fi-programa:screen-value in frame {&frame-name} = c-arquivo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  param-pm.cd-plano-atp:load-mouse-pointer ("Image/lupa.cur") in frame {&frame-name}.
  param-pm.cd-calend:load-mouse-pointer    ("Image/lupa.cur") in frame {&frame-name}.
  param-pm.cod-estabel:load-mouse-pointer  ("Image/lupa.cur") in frame {&frame-name}.
  fi-programa:load-mouse-pointer           ("Image/lupa.cur") in frame {&frame-name}.

  {utp/ut-liter.i Atualizaá∆o_Previs∆o_de_Vendas * R}
  assign fi-programa:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Sim/N∆o *}
  assign param-pm.calc-atp-cot:format = return-value.

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
  {src/adm/template/row-list.i "param-pm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-pm"}

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
  def var c-programa as char no-undo.

   if not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  run pi-validate. 

  assign c-programa = input frame {&frame-name} fi-programa.

  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  if input frame {&frame-name} param-pm.cd-calend = ? then 
      run pi-gera-calendario.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

  assign param-pm.val-fator-niv-carga = 0
         param-pm.val-fator-niv-defas = 0
         param-pm.char-1              = IF INPUT FRAME {&frame-name} c-integracao = "EMS" 
                                        THEN ""
                                        ELSE INPUT FRAME {&frame-name} c-bancos
         param-pm.char-2              = trim(c-programa).

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

    if  avail param-pm then do:

        find calen-gener
            where calen-gener.cd-calen = param-pm.cd-calend no-lock no-error.
        assign c-cd-calend = if avail calen-gener then calen-gener.descricao else "":U.

        find estabelec
            where estabelec.cod-estabel = param-pm.cod-estabel no-lock no-error.
        assign c-cod-estabel = if avail estabelec then estabelec.nome else "":U.

        find pl-mest
            where pl-mest.cd-plano = param-pm.cd-plano-atp no-lock no-error.
        assign c-desc-plano = if avail pl-mest then  pl-mest.descricao else "":U.

        ASSIGN c-bancos                                         = param-pm.char-1
               c-integracao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "EMS"
               c-bancos:SENSITIVE IN FRAME {&FRAME-NAME}        = NO.

        IF param-pm.char-1 <> "" THEN
            ASSIGN c-integracao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Magnus"
                   c-bancos:SENSITIVE IN FRAME {&FRAME-NAME}        = YES.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-calendario V-table-Win 
PROCEDURE pi-gera-calendario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR c-desc   AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR c-codigo AS CHAR FORMAT "x(08)" NO-UNDO.
DEF VAR h-acomp  AS HANDLE              NO-UNDO.
DEF VAR i-cont   AS INTEGER             NO-UNDO.

{utp/ut-liter.i Calend†rio_Produá∆o_-_MPS * R}
assign c-desc = trim(return-value).

assign c-codigo = "PROD-MPS".

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Geraá∆o_Calend†rio *}
run pi-inicializar in h-acomp (input  Return-value ).

find first param-cp no-lock no-error.

find first calen-gener
     where calen-gener.cd-calen = c-codigo no-lock no-error.
if  not avail calen-gener then do:
    create calen-gener.
    assign calen-gener.cd-calen  = c-codigo
           calen-gener.descricao = c-desc.
end.
else do:
    /*** Elimina todas as datas do calendario para depois
         recria-las ***/
    for each calen-data
        where calen-data.cd-calen = calen-gener.cd-calen
          and calen-data.data    >= TODAY EXCLUSIVE-LOCK:
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

disp calen-gener.cd-calen  @ param-pm.cd-calend
     calen-gener.descricao @ c-cd-calend
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

    find first pl-mest no-lock no-error.
    if  avail pl-mest 
    and input frame {&frame-name} param-pm.cd-plano-atp <> 0 then do:
        find pl-mest 
            where pl-mest.cd-plano = input frame {&frame-name} param-pm.cd-plano-atp 
            no-lock no-error.
        if  not avail pl-mest then do:     
            {include/i-vldprg.i} 
            {utp/ut-field.i mgind pl-mest cd-plano 1}
            run utp/ut-msgs.p (input "show":U,
                               input 56, 
                               input return-value).
            apply 'entry' to param-pm.cd-plano-atp.
            return 'ADM-ERROR':U.
        end.
    end.

    if input frame {&frame-name} fi-programa <> "" and
       search(input frame {&frame-name} fi-programa) = ? then do:
        run utp/ut-msgs.p (input "show":U,
                           input 19377, 
                           input fi-programa:screen-value in frame {&frame-name}).
        apply 'entry' to fi-programa.
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
  {src/adm/template/snd-list.i "param-pm"}

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


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
{include/i-prgvrs.i V01IN504 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN504 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

&Scop adm-attribute-dlg support/viewerd.w

{cdp/cd0666.i}       /* defini‡Æo temp-table de erros */
{include/boerrtab.i} /* defini‡Æo temp-table tt-bo-erro */
{include/i_fnctrad.i}

def buffer b-ind-vis-man for ind-vis-man.

def var v-row-parent as rowid no-undo.

def var c-lista      as char no-undo.
def var c-cod-indice as char no-undo.
def var c-lista-aux  as char no-undo.
def var h-boin504    as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ind-vis-man
&Scoped-define FIRST-EXTERNAL-TABLE ind-vis-man


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ind-vis-man.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ind-vis-man.des-ind-man ~
ind-vis-man.cod-um-gerc ind-vis-man.formato ind-vis-man.log-ativo ~
ind-vis-man.formula 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}des-ind-man ~{&FP2}des-ind-man ~{&FP3}~
 ~{&FP1}cod-um-gerc ~{&FP2}cod-um-gerc ~{&FP3}~
 ~{&FP1}formato ~{&FP2}formato ~{&FP3}
&Scoped-define ENABLED-TABLES ind-vis-man
&Scoped-define FIRST-ENABLED-TABLE ind-vis-man
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 cb-indice c-formula 
&Scoped-Define DISPLAYED-FIELDS ind-vis-man.cod-visao ind-vis-man.seq-ind ~
ind-vis-man.cod-ind-alias ind-vis-man.des-ind-man ind-vis-man.cod-um-gerc ~
ind-vis-man.formato ind-vis-man.log-ativo ind-vis-man.formula 
&Scoped-Define DISPLAYED-OBJECTS c-desc i-teste cb-indice c-desc-indice ~
c-formula 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS ind-vis-man.cod-ind-alias 
&Scoped-define ADM-ASSIGN-FIELDS ind-vis-man.seq-ind 

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
DEFINE VARIABLE cb-indice AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 18.29 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-indice AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-formula AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 10.43 BY .67 NO-UNDO.

DEFINE VARIABLE i-teste AS DECIMAL FORMAT "->>>>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.57 BY 3.83.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.33.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 7.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ind-vis-man.cod-visao AT ROW 1.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-desc AT ROW 1.17 COL 39.57 COLON-ALIGNED NO-LABEL
     ind-vis-man.seq-ind AT ROW 2.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     ind-vis-man.cod-ind-alias AT ROW 3.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     ind-vis-man.des-ind-man AT ROW 4.75 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     ind-vis-man.cod-um-gerc AT ROW 5.75 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     ind-vis-man.formato AT ROW 5.75 COL 52 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     i-teste AT ROW 5.75 COL 65 COLON-ALIGNED NO-LABEL
     ind-vis-man.log-ativo AT ROW 6.75 COL 25
          VIEW-AS TOGGLE-BOX
          SIZE 14.29 BY .83
     ind-vis-man.formula AT ROW 8.17 COL 21 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
          SIZE 60 BY 2
     cb-indice AT ROW 10.29 COL 19 COLON-ALIGNED
     c-desc-indice AT ROW 10.29 COL 37.57 COLON-ALIGNED NO-LABEL
     c-formula AT ROW 7.5 COL 2.57 NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.46 COL 1
     RECT-1 AT ROW 7.71 COL 1.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ind-vis-man
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
         HEIGHT             = 10.83
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

/* SETTINGS FOR FILL-IN c-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-indice IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-formula IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN ind-vis-man.cod-ind-alias IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN ind-vis-man.cod-visao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-teste IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       i-teste:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN ind-vis-man.seq-ind IN FRAME f-main
   NO-ENABLE 2                                                          */
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

&Scoped-define SELF-NAME cb-indice
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-indice V-table-Win
ON LEAVE OF cb-indice IN FRAME f-main
DO:
    assign ind-vis-man.formula:screen-value in frame {&frame-name} = 
                                            ind-vis-man.formula:screen-value in frame {&frame-name} + " " +
                                                      cb-indice:screen-value in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-indice V-table-Win
ON VALUE-CHANGED OF cb-indice IN FRAME f-main
DO:
    find first b-ind-vis-man
        where b-ind-vis-man.cod-ind-alias = input frame {&frame-name} cb-indice no-lock no-error.  
    if  avail b-ind-vis-man then
        assign c-desc-indice:screen-value in frame {&frame-name} = b-ind-vis-man.des-ind-man.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

    {utp/ut-liter.i Öndices_Dispon¡veis * R}
    assign cb-indice:label in frame {&frame-name} = trim(return-value).

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
  {src/adm/template/row-list.i "ind-vis-man"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ind-vis-man"}

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

    if avail visao-man then do:
        disp visao-man.cod-visao @ ind-vis-man.cod-visao 
             visao-man.des-visao @ c-desc
             with frame {&frame-name}.

        find last b-ind-vis-man
             where b-ind-vis-man.cod-visao = visao-man.cod-visao no-lock no-error.
        if avail b-ind-vis-man then
             assign ind-vis-man.seq-ind:screen-value in frame {&frame-name} = string(b-ind-vis-man.seq-ind + 1).
        else assign ind-vis-man.seq-ind:screen-value in frame {&frame-name} = "1".  

        apply 'value-changed' to cb-indice in frame {&frame-name}.
    end.

    {utp/ut-rtlbl.i mgind ind-vis-man formula c-formula}

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

    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    for each tt-erro:
        delete tt-erro.
    end.

    if  input frame {&frame-name} ind-vis-man.formato <> "" then do:
        assign i-teste:format in frame {&frame-name} = input frame {&frame-name} ind-vis-man.formato no-error.
        if  i-teste:format in frame {&frame-name} <> input frame {&frame-name} ind-vis-man.formato then do:
            run utp/ut-msgs.p (input "show":U, 
                               input 2744, 
                               input "").
            apply 'entry' to ind-vis-man.formato in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.    

    if  input frame {&frame-name} ind-vis-man.formula <> "" then do:
        run tratarFormulaIndice in h-boin504 (input input frame {&frame-name} ind-vis-man.cod-visao,
                                              input input frame {&frame-name} ind-vis-man.cod-ind-alias,
                                              input input frame {&frame-name} ind-vis-man.formula,
                                              output table tt-bo-erro).
        if  can-find (first tt-bo-erro) then do:
            for each tt-bo-erro:
                create tt-erro.
                assign tt-erro.i-sequen = tt-bo-erro.i-sequen
                       tt-erro.cd-erro  = tt-bo-erro.cd-erro
                       tt-erro.mensagem = tt-bo-erro.mensagem.
            end.
            find first tt-erro no-error.
            if  avail tt-erro then do:
                run cdp/cd0666.w (input table tt-erro).
                return 'ADM-ERROR':U.
            end.
        end.
    end.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    assign ind-vis-man.cod-ind-int = input frame {&frame-name} ind-vis-man.cod-ind-alias.    

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

    find visao-man  where rowid(visao-man) = v-row-parent no-error.
    if available visao-man  then 
        assign ind-vis-man.cod-visao = visao-man.cod-visao.


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

  if avail ind-vis-man then do:
     find first visao-man 
          where visao-man.cod-visao = ind-vis-man.cod-visao no-lock no-error.
     assign c-desc:screen-value in frame {&frame-name} = if avail visao-man then visao-man.des-visao
                                                         else "".
  end.

  {utp/ut-rtlbl.i mgind ind-vis-man formula c-formula}

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

    assign c-lista = "".
    if  avail ind-vis-man then do:
        if  ind-vis-man.log-reg-dtsul = no 
        or  adm-new-record            = yes then do:

            for each b-ind-vis-man
                where b-ind-vis-man.cod-visao = visao-man.cod-visao no-lock:

                /* NÆo considera o ¡ndice que est  sendo alterado */
                if b-ind-vis-man.cod-ind-alias = ind-vis-man.cod-ind-alias and
                   adm-new-record = no
                   then next.

                if  c-lista = "" then
                    assign c-lista      = string(b-ind-vis-man.cod-ind-alias)
                           c-cod-indice = b-ind-vis-man.cod-ind-alias
                           c-lista-aux  = c-lista.
                else
                    assign c-lista = c-lista + ',' + 
                                     string(b-ind-vis-man.cod-ind-alias).
            end.

            &if "{&fnc_multi_idioma}":U = "yes":U &then
                RUN utp/ut-lstit.p (INPUT-OUTPUT c-lista).
                RUN utp/ut-lstit.p (INPUT-OUTPUT c-lista-aux).
                    assign cb-indice:LIST-ITEM-PAIRS in frame {&frame-name} = c-lista.
            &ELSE
                    assign cb-indice:LIST-ITEMS in frame {&frame-name} = c-lista.
            &ENDIF
            ASSIGN cb-indice = c-lista-aux.

            disp cb-indice 
                 with frame {&frame-name}.
        end.
        else
            assign cb-indice:sensitive               in frame {&frame-name} = no
                   ind-vis-man.formula:sensitive     in frame {&frame-name} = no
                   ind-vis-man.cod-um-gerc:sensitive in frame {&frame-name} = no.
    end.

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

    find visao-man  where rowid(visao-man) = v-row-parent no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-h-boin504 as handle.

    assign h-boin504 = p-h-boin504.

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
  {src/adm/template/snd-list.i "ind-vis-man"}

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



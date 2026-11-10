&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
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
{include/i-prgvrs.i V01IN270 2.00.00.020}  /*** 010020 ***/
&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN270 MUT}
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

{cdp/cdcfgmnt.i}
 
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
def buffer b-ord-manut for ord-manut.
def new global shared var gr-ord-manut as rowid no-undo.
def var c-tarefa as char no-undo.
def var l-resposta as logical no-undo.
def var c-est-om like ord-manut.estado-om no-undo.
def var c-param-aloc as char format "x(20)" no-undo.
def var h_query as handle no-undo.
def var rw-ord-manut as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ord-manut
&Scoped-define FIRST-EXTERNAL-TABLE ord-manut


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-manut.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-manut.estado-om ord-manut.motivo 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES ord-manut
&Scoped-define FIRST-ENABLED-TABLE ord-manut
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-5 RECT-8 RECT-6 RECT-7 ~
bt-suspensao bt-reativa 
&Scoped-Define DISPLAYED-FIELDS ord-manut.nr-ord-produ ord-manut.cd-equipto ~
ord-manut.cd-manut ord-manut.tipo ord-manut.estado-om ord-manut.cd-tag ~
ord-manut.cd-parada ord-manut.dt-manut ord-manut.cd-pend-padr ~
ord-manut.motivo 
&Scoped-Define DISPLAYED-OBJECTS c-equipto-descricao c-manut-descricao ~
c-pend-padrao-descricao FILL-IN-3 FILL-IN-7 FILL-IN-5 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS ord-manut.nr-ord-produ 
&Scoped-define ADM-ASSIGN-FIELDS ord-manut.nr-ord-produ 
&Scoped-define ADM-MODIFY-FIELDS ord-manut.estado-om 

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
DEFINE BUTTON bt-reativa 
     LABEL "&Reativaá∆o" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-suspensao 
     LABEL "&Suspens∆o" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE c-equipto-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-manut-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-pend-padrao-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10.43 BY .63 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15 BY .63 NO-UNDO.

DEFINE VARIABLE FILL-IN-7 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87 BY 3.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87 BY 1.25.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.29 BY 6.29.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.57 BY 2.54.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87 BY 1.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-manut.nr-ord-produ AT ROW 1.38 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-equipto-descricao AT ROW 2.38 COL 39.14 COLON-ALIGNED NO-LABEL
     ord-manut.cd-equipto AT ROW 2.42 COL 21.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     ord-manut.cd-manut AT ROW 3.42 COL 21.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-manut-descricao AT ROW 3.42 COL 34.14 COLON-ALIGNED NO-LABEL
     ord-manut.tipo AT ROW 5.25 COL 3 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Preventiva", 1,
"Corretiva", 2,
"Preditiva", 3,
"Outros", 4
          SIZE 46 BY .75
     ord-manut.estado-om AT ROW 7 COL 5 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "N∆o Iniciada", 1,
"Iniciada", 2,
"Suspensa", 3,
"Terminada", 4
          SIZE 55 BY .75
     ord-manut.cd-tag AT ROW 8.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     ord-manut.cd-parada AT ROW 8.5 COL 48 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     ord-manut.dt-manut AT ROW 9.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ord-manut.cd-pend-padr AT ROW 10.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-pend-padrao-descricao AT ROW 10.5 COL 34 COLON-ALIGNED NO-LABEL
     ord-manut.motivo AT ROW 12 COL 4 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 83.86 BY 1.96
          FONT 2
     bt-suspensao AT ROW 14.75 COL 2
     bt-reativa AT ROW 14.75 COL 17
     FILL-IN-3 AT ROW 4.75 COL 4 COLON-ALIGNED NO-LABEL
     FILL-IN-7 AT ROW 6.25 COL 4 COLON-ALIGNED NO-LABEL
     FILL-IN-5 AT ROW 8 COL 1 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1.25 COL 1.86
     RECT-5 AT ROW 5 COL 2
     RECT-8 AT ROW 6.75 COL 2
     RECT-6 AT ROW 8.25 COL 2
     RECT-7 AT ROW 11.75 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-manut
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
         HEIGHT             = 15.04
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

/* SETTINGS FOR FILL-IN c-equipto-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-manut-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-pend-padrao-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-equipto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-manut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-parada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-pend-padr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-tag IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.dt-manut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET ord-manut.estado-om IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-7 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.nr-ord-produ IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR RADIO-SET ord-manut.tipo IN FRAME f-main
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

&Scoped-define SELF-NAME bt-reativa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-reativa V-table-Win
ON CHOOSE OF bt-reativa IN FRAME f-main /* Reativaá∆o */
DO:
    find first param-global no-lock no-error.  
    if  avail ord-manut then do:
        if ord-manut.estado-om <> 3 then do:
            {utp/ut-table.i mgind ord-manut 1}
            run utp/ut-msgs.p (input "show" , input 17272, input return-value).
            return 'adm-error'.
        end.
     &if defined (bf_mnt_ems203) &then
     &else   
        find ord-prod where ord-prod.nr-ord-produ = ord-manut.nr-ord-produ no-lock no-error.
        if not avail ord-prod then do:
            run utp/ut-msgs.p (input "show" , input 8881, input c-tarefa).
        end.    
     &endif   
        run utp/ut-msgs.p (input "show" , input 8888, input c-tarefa).
        if return-value = "yes" then do:
            find current ord-manut exclusive-lock.
            assign ord-manut.estado-om = if ord-manut.estado <> 1 then 2 else 1
            ord-manut.cd-pend-padr = ""
            ord-manut.om-encerrada = no
            ord-manut.dt-fecham    = ?
            ord-manut.motivo = "".
            {mip/mi0314.i "ord-esp.encerrada" "ord-esp.conclusao"} /* Realoca especialidades das tarefas */
            find current ord-manut no-lock.
        end.
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
    end.                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-suspensao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-suspensao V-table-Win
ON CHOOSE OF bt-suspensao IN FRAME f-main /* Suspens∆o */
DO:
 
   if  avail ord-manut then do: 
       if ord-manut.om-encerrada = yes then do:
           run utp/ut-msgs.p (input "show" , input 724, input c-tarefa).
           return 'adm-error'.
           /* Estado da ordem n∆o permite alteraá∆o */
       end.
       if  ord-manut.estado-om = 3 then do:
           run utp/ut-msgs.p (input "show" , input 8877 , input c-tarefa).
           return 'adm-error'.
       end. 
    &if defined (bf_mnt_ems203) &then
    &else       
       find ord-prod where ord-prod.nr-ord-produ = ord-manut.nr-ord-produ no-lock no-error.
       if not avail ord-prod then do:
           run utp/ut-msgs.p (input "show" , input 8879 , input "").
           run utp/ut-msgs.p (input "help" , input 8879 , input "").
           find current ord-manut exclusive-lock.
           assign ord-manut.motivo = return-value.
           find current ord-manut no-lock.
           return 'adm-error'.
       end. 
       else 
    &endif   
/*           if  ord-manut.estado-om <> 3 then do:
 *                for each ord-taref
 *                    where ord-taref.nr-ord-produ = ord-manut.nr-ord-produ break by ord-taref.cd-tarefa:
 *                    if  ord-taref.tempo-real = 0 then do:
 *                        assign c-tarefa = string(ord-taref.cd-tarefa,"99999").
 *                        run utp/ut-msgs.p (input "show" , input 602 , input c-tarefa).
 *                        if  return-value = "no" then do:
 *                            return 'adm-error'.
 *                        end.    
 *                    end.
 *                end.
 *            end.*/
 
       run mip/mi0311a.w (input rowid(ord-manut),
                          input-output ord-manut.cd-pend-padr,
                          input-output ord-manut.motivo,
                          input-output ord-manut.estado-om,
                          input-output ord-manut.om-encerrada).
 
       assign rw-ord-manut = rowid(ord-manut).
 
       find current ord-manut no-lock.
       run dispatch in h_query ('open-query').
       run pi-reposiciona-query in h_query (input rw-ord-manut). 
    end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-manut.cd-equipto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.cd-equipto V-table-Win
ON LEAVE OF ord-manut.cd-equipto IN FRAME f-main /* Equipamento */
DO:
  {include/leave.i &tabela=equipto
                   &atributo-ref=descricao
                   &variavel-ref=c-equipto-descricao
                   &where="equipto.cd-equipto = input frame {&frame-name} ord-manut.cd-equipto"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-manut.cd-manut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.cd-manut V-table-Win
ON LEAVE OF ord-manut.cd-manut IN FRAME f-main /* Manutená∆o */
DO:
  {include/leave.i &tabela=manut
                   &atributo-ref=descricao
                   &variavel-ref=c-manut-descricao
                   &where="manut.cd-manut = input frame {&frame-name} ord-manut.cd-manut"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-manut.cd-pend-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.cd-pend-padr V-table-Win
ON F5 OF ord-manut.cd-pend-padr IN FRAME f-main /* Pendància Padr∆o */
DO:
    {include/zoom.i &prog-zoom="inzoom/Z01in297.w"
                  &tabela=ord-manut  
                  &atributo=cd-pend-padr}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.cd-pend-padr V-table-Win
ON LEAVE OF ord-manut.cd-pend-padr IN FRAME f-main /* Pendància Padr∆o */
DO:
  {include/leave.i   &tabela=pend-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-pend-padrao-descricao
                   &where="pend-padrao.cd-pend-padr = input frame {&frame-name} ord-manut.cd-pend-padr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.cd-pend-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ord-manut.cd-pend-padr IN FRAME f-main /* Pendància Padr∆o */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-manut.motivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.motivo V-table-Win
ON LEAVE OF ord-manut.motivo IN FRAME f-main /* Motivo */
DO:   
   assign ord-manut.cd-pend-padr:sensitive in frame {&frame-name} = no
          ord-manut.motivo:sensitive in frame {&frame-name} = no.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 
  find first param-global no-lock no-error.
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  /*{utp/ut-rtlbl.i mgind ord-manut estado-om fill-in-2}*/
  {utp/ut-rtlbl.i mgind ord-manut estado-om fill-in-7}
  {utp/ut-rtlbl.i mgind ord-manut tipo fill-in-3}
  {utp/ut-rtlbl.i mgind ord-manut motivo fill-in-5}
  if ord-manut.nr-ord-produ:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if ord-manut.cd-manut:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
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
  {src/adm/template/row-list.i "ord-manut"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-manut"}

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
   {utp/ut-rtlbl.i mgind ord-manut tipo fill-in-3}
   {utp/ut-rtlbl.i mgind ord-manut motivo fill-in-5}
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

        /* Code placed here will execute PRIOR to standard behavior. */
       /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
       RETURN 'ADM-ERROR':U.

    /* Code placed here will execute AFTER standard behavior.    */

    find first param-global
        no-lock no-error.

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
 
  if avail ord-manut then do:
    /* assign c-est-om = ord-manut.estado-om. */
     find equipto where equipto.cd-equipto = ord-manut.cd-equipto no-lock no-error.
     assign c-equipto-descricao = if avail equipto then equipto.descricao else "":U.
     find manut where manut.cd-manut = ord-manut.cd-manut no-lock no-error.
     assign c-manut-descricao = if avail manut then manut.descricao else "":U.
     find pend-padrao where pend-padrao.cd-pend-padr = ord-manut.cd-pend-padr no-lock no-error.
     assign c-pend-padrao-descricao = if avail pend-padrao then pend-padrao.descricao else "":U.
  end.   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  /*find first param-mi
 *       no-lock no-error.
 *   if  avail param-mi and param-mi.formato-cd-equipto <> " " then do:
 *       assign ord-manut.cd-equipto:format in frame {&frame-name} = param-mi.formato-cd-equipto.
 *   end.
 *   if  avail param-mi and param-mi.formato-cd-tag <> " " then do:
 *       assign ord-manut.cd-tag:format in frame {&frame-name} = param-mi.formato-cd-tag.
 *   end.*/
 
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
  /* Dispatch standard ADM method. */
 
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
  if avail ord-manut then
     assign gr-ord-manut = rowid(ord-manut).
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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
 
  /* Ponha aqui a validaá∆o de chave duplicada */
 
  /* Ponha aqui as demais validaá‰es */
 
  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
 
  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
 *   if  return-value = 'ADM-ERROR':U THEN
 *   return 'ADM-ERROR':U.
 *   */
 
  /* Code placed here will execute AFTER standard behavior.    */
 
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
def input parameter h_query1 as handle no-undo.
 
assign h_query = h_query1.
 
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
  {src/adm/template/snd-list.i "ord-manut"}

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



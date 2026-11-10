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
{include/i-prgvrs.i V01IN284 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN284 MUT}
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

/* Parameters Definitions ---                                        */
{cdp/cdcfgman.i}
/* Local Variable Definitions ---                                       */

def var i-var            as integer.
def var da-iniper        as date format "99/99/9999"   no-undo.
def var da-fimper        as date format "99/99/9999"   no-undo.
def var i-per-corrente   as int  format "99"           no-undo.
def var i-ano-corrente   as int  format "9999"         no-undo.
def var da-iniper-fech   as date format "99/99/9999"   no-undo.
def var da-fimper-fech   as date format "99/99/9999"   no-undo.
def var c-per            like ext-per-custo.periodo    no-undo.

/* Local Definitions for EAI                                   */
&IF DEFINED (bf_man_204) &THEN 
  {cdp/cd9043.i} /* Defini‡Æo da tabela de erros RowErros */
  DEFINE TEMP-TABLE tt-eai-centro-custo LIKE centro-custo.
  DEF VAR hShowMsg AS HANDLE NO-UNDO.
  DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 
  DEFINE TEMP-TABLE tt-eai-periodo NO-UNDO
       FIELD periodo LIKE ext-per-custo.periodo. 
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
&Scoped-define EXTERNAL-TABLES param-cs
&Scoped-define FIRST-EXTERNAL-TABLE param-cs


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-cs.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-cs.tp-relogio param-cs.ocorrencia[1] ~
param-cs.ocorrencia[2] param-cs.ocorrencia[3] param-cs.ocorrencia[4] ~
param-cs.ocorrencia[5] param-cs.ocorrencia[6] 
&Scoped-define ENABLED-TABLES param-cs
&Scoped-define FIRST-ENABLED-TABLE param-cs
&Scoped-Define ENABLED-OBJECTS tgParam RECT-6 RECT-7 RECT-8 
&Scoped-Define DISPLAYED-FIELDS param-cs.tp-relogio param-cs.ocorrencia[1] ~
param-cs.ocorrencia[2] param-cs.ocorrencia[3] param-cs.ocorrencia[4] ~
param-cs.ocorrencia[5] param-cs.ocorrencia[6] 
&Scoped-define DISPLAYED-TABLES param-cs
&Scoped-define FIRST-DISPLAYED-TABLE param-cs
&Scoped-Define DISPLAYED-OBJECTS tgParam 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD retorna-campo V-table-Win 
FUNCTION retorna-campo RETURNS CHARACTER
  ( input i-campo as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-text-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE c-text-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35 BY 5.75.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 7.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35 BY 1.25.

DEFINE VARIABLE tgParam AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-cs.tp-relogio AT ROW 2.25 COL 39.57 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Hor rio", 1,
"Diferen‡a Hor rio", 2,
"Centesimal", 3,
"Diferen‡a Centesimal", 4
          SIZE 23.57 BY 5
     param-cs.ocorrencia[1] AT ROW 2.58 COL 11.29 COLON-ALIGNED
          LABEL "1":R15
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     param-cs.ocorrencia[2] AT ROW 3.58 COL 11.29 COLON-ALIGNED
          LABEL "2":R15
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     param-cs.ocorrencia[3] AT ROW 4.58 COL 11.29 COLON-ALIGNED
          LABEL "3":R15
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     param-cs.ocorrencia[4] AT ROW 5.58 COL 11.29 COLON-ALIGNED
          LABEL "4":R15
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     param-cs.ocorrencia[5] AT ROW 6.58 COL 11.29 COLON-ALIGNED
          LABEL "5":R15
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     param-cs.ocorrencia[6] AT ROW 7.58 COL 11.29 COLON-ALIGNED
          LABEL "6":R15
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tgParam AT ROW 7.75 COL 39
     c-text-1 AT ROW 1.5 COL 2 COLON-ALIGNED NO-LABEL
     c-text-2 AT ROW 1.5 COL 39 COLON-ALIGNED NO-LABEL
     RECT-6 AT ROW 1.75 COL 38
     RECT-7 AT ROW 1.75 COL 2
     RECT-8 AT ROW 7.5 COL 38
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-cs
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
         HEIGHT             = 8.25
         WIDTH              = 74.
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

/* SETTINGS FOR FILL-IN c-text-1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-text-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN param-cs.ocorrencia[1] IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN param-cs.ocorrencia[2] IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN param-cs.ocorrencia[3] IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN param-cs.ocorrencia[4] IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN param-cs.ocorrencia[5] IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN param-cs.ocorrencia[6] IN FRAME f-main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         


  /************************ INTERNAL PROCEDURES ********************/

 {utp/ut-rtlbl.i mgind param-cs ocorrencia c-text-1 }
 {utp/ut-rtlbl.i mgind param-cs tp-relogio c-text-2 }

find first param-estoq no-lock no-error.
run cdp/cdapi005.p (input param-estoq.ult-per-fech,
                    output da-iniper,
                    output da-fimper,
                    output i-per-corrente,
                    output i-ano-corrente,
                    output da-iniper-fech,
                    output da-fimper-fech).
assign c-per = string(i-ano-corrente,"9999")+ string(i-per-corrente,"99").


{utp/ut-liter.i "Valoriza OP de reaproveitamento pelo NMB?"}
assign tgParam:label in frame {&frame-name} = trim(return-value).

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
  {src/adm/template/row-list.i "param-cs"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-cs"}

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

  /* chamada para mostrar os labels dso campos radio-set */  

  {utp/ut-rtlbl.i mgind param-cs ocorrencia c-text-1 }
  {utp/ut-rtlbl.i mgind param-cs tp-relogio c-text-2 }


  /* fim chamada para mostrar labels campos radio-set */
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

  run get-attribute in this-procedure ('adm-new-record').

  SESSION:SET-WAIT-STATE ("General":U).

  if return-value = "no" then do:   
     do i-var = 1 to 6:
        if retorna-campo (input i-var) <> param-cs.ocorrencia[i-var] then do:
           for each ext-per-custo where ext-per-custo.periodo = c-per exclusive-lock:
               assign ext-per-custo.custo-prev [i-var]  = 0
                      ext-per-custo.custo-total[i-var]  = 0
                      ext-per-custo.custo-pad  [i-var]  = 0
                      ext-per-custo.custo-medio[i-var]  = 0.
               /* EAI */
               &IF DEFINED (bf_man_204) &THEN
                   IF v_log_eai_habilit THEN DO:
                      FIND FIRST centro-custo WHERE 
                                 centro-custo.cc-codigo = ext-per-custo.cc-codigo NO-LOCK NO-ERROR.
                      IF AVAIL centro-custo THEN DO:
                         IF NOT CAN-FIND(FIRST tt-eai-centro-custo WHERE
                                               tt-eai-centro-custo.cc-codigo = centro-custo.cc-codigo) THEN DO:
                            CREATE tt-eai-centro-custo.
                            BUFFER-COPY centro-custo TO tt-eai-centro-custo.
                         END.
                     END.
                   END.
               &ENDIF
           end.

           if retorna-campo (input i-var) = "" and
              retorna-campo (input i-var) <> param-cs.ocorrencia[i-var] then
              for each centro-custo exclusive-lock:
                  assign centro-custo.conta-contabil[i-var] = ""
                         centro-custo.ct-codigo[i-var]      = ""
                         centro-custo.sc-codigo[i-var]      = "".
                   /***** EAI ******/
                   &IF DEFINED (bf_man_204) &THEN
                     IF v_log_eai_habilit THEN DO:
                        IF NOT CAN-FIND(FIRST tt-eai-centro-custo WHERE
                                              tt-eai-centro-custo.cc-codigo = centro-custo.cc-codigo) THEN DO:
                           CREATE tt-eai-centro-custo.
                           BUFFER-COPY centro-custo TO tt-eai-centro-custo.
                        END.
                     END.
                   &ENDIF

              end.           
        end.
     end.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

    /* Para execu‡Æo de Adapter da Mensagem Centro Custo - EAI */
    &IF DEFINED (bf_man_204) &THEN 
      IF v_log_eai_habilit THEN DO:

        IF CAN-FIND(FIRST tt-eai-centro-custo) THEN DO:

            /* Cria temp-table de per¡odo*/
            CREATE tt-eai-periodo.
            ASSIGN tt-eai-periodo.periodo = c-per.


             RUN adapters/xml/ma2/axsma001.p (INPUT "upd",
                                             INPUT "cs0104.w",
                                             INPUT STRING(c-prg-vrs),
                                             INPUT "",       /* Evento */
                                             INPUT TABLE tt-eai-periodo,
                                             INPUT TABLE tt-eai-centro-custo,
                                             OUTPUT TABLE RowErrors).  
            DELETE tt-eai-centro-custo.
            DELETE tt-eai-periodo.
            IF CAN-FIND (FIRST RowErrors WHERE 
                               RowErrors.ErrorSubType = "ERROR":U) THEN DO:
               {method/showmessage.i1}
               {method/showmessage.i2 &Modal="YES"}
               EMPTY TEMP-TABLE RowErrors NO-ERROR.
               undo, return "ADM-ERROR":U.
            END.
        END.
      END.
    &ENDIF
    ASSIGN param-cs.log-1 = INPUT  frame {&frame-name} tgParam.

    SESSION:SET-WAIT-STATE ("":U).

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
  ASSIGN tgParam:CHECKED IN  frame {&frame-name} = param-cs.log-1.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

 run get-attribute in this-procedure ('adm-new-record').

 if return-value = "no" then do:   
    do i-var = 1 to 6:
       if retorna-campo (input i-var) <> param-cs.ocorrencia[i-var] then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show" ,
                             input 248 ,
                             input string(i-var)).
          if return-value = "no" then do:
             case i-var:
                  when 1 then apply 'entry' to param-cs.ocorrencia[1]
                                               in frame {&frame-name}.
                  when 2 then apply 'entry' to param-cs.ocorrencia[2]
                                               in frame {&frame-name}.
                  when 3 then apply 'entry' to param-cs.ocorrencia[3]
                                               in frame {&frame-name}.
                  when 4 then apply 'entry' to param-cs.ocorrencia[4]
                                               in frame {&frame-name}.
                  when 5 then apply 'entry' to param-cs.ocorrencia[5]
                                               in frame {&frame-name}.
                  when 6 then apply 'entry' to param-cs.ocorrencia[6]
                                               in frame {&frame-name}.
             end.                              
             return "adm-error".
          end.
       end.
    end.
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
  {src/adm/template/snd-list.i "param-cs"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION retorna-campo V-table-Win 
FUNCTION retorna-campo RETURNS CHARACTER
  ( input i-campo as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  case i-campo:
       when 1 then RETURN input frame {&frame-name} param-cs.ocorrencia[1].
       when 2 then RETURN input frame {&frame-name} param-cs.ocorrencia[2].
       when 3 then RETURN input frame {&frame-name} param-cs.ocorrencia[3].
       when 4 then RETURN input frame {&frame-name} param-cs.ocorrencia[4].
       when 5 then RETURN input frame {&frame-name} param-cs.ocorrencia[5].
       when 6 then RETURN input frame {&frame-name} param-cs.ocorrencia[6].
  end.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


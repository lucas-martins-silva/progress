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
{include/i-prgvrs.i V27IN172 2.00.00.010}  /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V27IN172 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define new global shared variable gr-item          as rowid                   no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
define new global shared variable c-cod-estabel    as character format "x(05)" no-undo.
&ELSE
define new global shared variable c-cod-estabel    as character format "x(3)" no-undo.
&ENDIF
define new global shared variable i-cd-plano       as integer   format  ">>9" no-undo.

define variable de-refugo   as decimal no-undo.
define variable de-ordens   as decimal no-undo.
define variable de-qt-perda as decimal no-undo.

{cdp/cdcfgman.i} /*Miniflexibiliza‡Æo. Utilizado no EMS 2.03 - NÇO ELIMINAR
                 * Vari vel preprocessador bf_man_203 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-13 
&Scoped-Define DISPLAYED-OBJECTS de-saldo fi-qt-pedidos fi-qt-ord-comp ~
fi-qt-plano fi-qt-ord-plan de-disponivel fi-qt-res-comp c-contr-plan ~
fi-qt-res-plan 

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
DEFINE VARIABLE c-contr-plan AS CHARACTER FORMAT "X(25)":U 
     LABEL "CtrPlan" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE de-disponivel AS DECIMAL FORMAT "->,>>>,>>9.9999":U INITIAL 0 
     LABEL "Dispon" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo AS DECIMAL FORMAT "->,>>>,>>9.9999":U INITIAL 0 
     LABEL "Sdo" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qt-ord-comp AS DECIMAL FORMAT ">>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "Ordens Comprom":R17 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE fi-qt-ord-plan AS DECIMAL FORMAT ">>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "Ordens Planej":R16 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE fi-qt-pedidos AS DECIMAL FORMAT ">>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "Ped":R4 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE fi-qt-plano AS DECIMAL FORMAT ">>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "Qtde Plano/PV":R16 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE fi-qt-res-comp AS DECIMAL FORMAT "->>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "Reservas Comprom":R20 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE fi-qt-res-plan AS DECIMAL FORMAT "->>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "Reservas Planej":R18 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.57 BY 6.63.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-saldo AT ROW 1.46 COL 21.14 COLON-ALIGNED
     fi-qt-pedidos AT ROW 1.46 COL 59.29 COLON-ALIGNED
     fi-qt-ord-comp AT ROW 2.71 COL 21.14 COLON-ALIGNED
     fi-qt-plano AT ROW 2.71 COL 59.29 COLON-ALIGNED
     fi-qt-ord-plan AT ROW 3.96 COL 21.14 COLON-ALIGNED
     de-disponivel AT ROW 3.96 COL 59.29 COLON-ALIGNED
     fi-qt-res-comp AT ROW 5.21 COL 21.14 COLON-ALIGNED
     c-contr-plan AT ROW 5.21 COL 59.29 COLON-ALIGNED
     fi-qt-res-plan AT ROW 6.46 COL 21.14 COLON-ALIGNED
     RECT-13 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         WIDTH              = 83.72.
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

/* SETTINGS FOR FILL-IN c-contr-plan IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-disponivel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saldo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qt-ord-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qt-ord-plan IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qt-pedidos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qt-plano IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qt-res-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qt-res-plan IN FRAME f-main
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

{utp/ut-liter.i Dispon¡vel MPL L}
assign de-disponivel:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgind pl-it-calc saldo 1}
assign de-saldo:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgind item contr-plan 1}
assign c-contr-plan:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgind it-periodo qt-ord-comp 1}
assign fi-qt-ord-comp:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgind it-periodo qt-ord-plan 1}
assign fi-qt-ord-plan:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgind it-periodo qt-res-comp 1}
assign fi-qt-res-comp:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgind it-periodo qt-pedidos 1}
assign fi-qt-pedidos:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgind it-periodo qt-res-plan 1}
assign fi-qt-res-plan:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgind it-periodo qt-plano 1}
assign fi-qt-plano:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

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

  /* Code placed here will execute PRIOR to standard behavior.
     Dispatch standard ADM method. */
  /* Code placed here will execute AFTER standard behavior.  */

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).

    assign de-saldo       = 0
           de-disponivel  = 0
           fi-qt-pedidos  = 0
           fi-qt-res-comp = 0
           fi-qt-ord-comp = 0
           fi-qt-res-plan = 0
           fi-qt-ord-plan = 0
           fi-qt-plano    = 0.

    find item where rowid(item) = gr-item no-lock no-error.
    if avail item then do with frame {&frame-name}:
        &IF DEFINED (bf_man_203) &THEN
        for each pl-prod where pl-prod.cd-plano= i-cd-plano and
                               pl-prod.pl-estado = 1 no-lock:
           for each pl-it-calc
                where pl-it-calc.cd-plano  = pl-prod.cd-plano
                and   pl-it-calc.it-codigo = item.it-codigo  no-lock:

             if pl-prod.log-multi-estabel = yes then                  
                for each pl-ext-item where pl-ext-item.it-codigo = pl-it-calc.it-codigo
                                and   pl-ext-item.num-calc-plano = pl-prod.num-calc-plano
                                and   pl-ext-item.cod-estabel    = c-cod-estabel no-lock:
                  assign de-saldo = de-saldo + pl-ext-item.qt-saldo.
                end.
             else
                  assign de-saldo = de-saldo + pl-it-calc.saldo.

             for each it-periodo use-index codigo where
                      it-periodo.num-calc-plano = pl-prod.num-calc-plano and
                      it-periodo.cod-estabel = (if pl-prod.log-multi-estabel = yes then
                                                c-cod-estabel
                                                else "") and
                      it-periodo.it-codigo = pl-it-calc.it-codigo no-lock:
                      fi-qt-pedidos  = fi-qt-pedidos  + it-periodo.qt-pedidos.
                      fi-qt-res-comp = fi-qt-res-comp + it-periodo.qt-res-comp.
                      fi-qt-ord-comp = fi-qt-ord-comp + it-periodo.qt-ord-comp.
                      fi-qt-res-plan = fi-qt-res-plan + it-periodo.qt-res-plan.
                      fi-qt-ord-plan = fi-qt-ord-plan + it-periodo.qt-ord-plan.
                      fi-qt-plano    = fi-qt-plano    + it-periodo.qt-plano.
                      de-ordens      = de-ordens   + it-periodo.nr-ordens.
             end.
             assign de-refugo = de-refugo
                             + round(((fi-qt-ord-comp)
                             + (fi-qt-ord-plan))
                             * (pl-it-calc.fator-refugo / 100),4)
                    de-qt-perda = de-qt-perda + pl-it-calc.quant-perda.
           end.
        end.
        assign de-disponivel = de-saldo
                             - (fi-qt-res-comp)
                             + (fi-qt-ord-comp)
                             - (fi-qt-res-plan)
                             + (fi-qt-ord-plan)
                             - de-refugo
                             - ((de-ordens)
                            * de-qt-perda).
        &ELSE
        find pl-it-calc use-index item no-lock
              where pl-it-calc.it-codigo = item.it-codigo no-error.

           if  avail pl-it-calc then do:
              assign de-saldo = pl-it-calc.saldo.
              for each it-periodo use-index codigo where
                       it-periodo.it-codigo = pl-it-calc.it-codigo no-lock:
                       accumulate it-periodo.qt-pedidos(total).
                       accumulate it-periodo.qt-res-comp(total).
                       accumulate it-periodo.qt-ord-comp(total).
                       accumulate it-periodo.qt-res-plan(total).
                       accumulate it-periodo.qt-ord-plan(total).
                       accumulate it-periodo.qt-plano(total).
                       accumulate it-periodo.nr-ordens(total).
              end.
              assign de-refugo = round(((accum total it-periodo.qt-ord-comp)
                                      + (accum total it-periodo.qt-ord-plan))
                                      * (pl-it-calc.fator-refugo / 100),4)
                     de-disponivel = de-saldo
                                   - (accum total it-periodo.qt-res-comp)
                                   + (accum total it-periodo.qt-ord-comp)
                                   - (accum total it-periodo.qt-res-plan)
                                   + (accum total it-periodo.qt-ord-plan)
                                   - de-refugo
                                   - ((accumulate total it-periodo.nr-ordens)
                                   * pl-it-calc.quant-perda).
                   assign de-saldo    = de-saldo
                          de-disponivel  = de-disponivel
                          fi-qt-pedidos  = accum total it-periodo.qt-pedidos
                          fi-qt-res-comp = accum total it-periodo.qt-res-comp
                          fi-qt-ord-comp = accum total it-periodo.qt-ord-comp
                          fi-qt-res-plan = accum total it-periodo.qt-res-plan
                          fi-qt-ord-plan = accum total it-periodo.qt-ord-plan
                          fi-qt-plano    = accum total it-periodo.qt-plano.
          end.
        &ENDIF

    display de-saldo
            de-disponivel
            fi-qt-pedidos
            fi-qt-res-comp
            fi-qt-ord-comp
            fi-qt-res-plan
            fi-qt-ord-plan
            fi-qt-plano.
      
      RUN utp/ut-liter.p (trim({ininc/i15in172.i 04 item.contr-plan}), "*", "").
      assign c-contr-plan:screen-value in frame {&frame-name} = RETURN-VALUE.

      &IF DEFINED (bf_man_203) &THEN
          find first item-uni-estab
               where item-uni-estab.cod-estabel = c-cod-estabel
                 and item-uni-estab.it-codigo   = item.it-codigo no-lock no-error.
          if avail item-uni-estab THEN DO:
             RUN utp/ut-liter.p (trim({ininc/i15in172.i 04 item-uni-estab.contr-plan}), "*", "").
             assign c-contr-plan:screen-value in frame {&frame-name} = RETURN-VALUE.
          END.
      &ENDIF
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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a valida‡Æo de chave duplicada */

  /* Ponha aqui as demais valida‡äes */

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "item"}

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



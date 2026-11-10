&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V05IN124 2.00.00.018 } /*** 010018 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V05IN124 MUT}
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

{cdp/cdcfgmat.i}
{include/i_dbvers.i}
 
/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w
 
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ficha-cq
&Scoped-define FIRST-EXTERNAL-TABLE ficha-cq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ficha-cq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ficha-cq.inspecionado ficha-cq.cod-emitente ~
ficha-cq.log-dia-sem-fornec ficha-cq.serie-docto ficha-cq.nro-docto ~
ficha-cq.dat-emis-nf ficha-cq.dt-inspecao ficha-cq.nat-operacao ~
ficha-cq.cod-resp ficha-cq.nr-ordem ficha-cq.parcela ~
ficha-cq.cod-fabricante ficha-cq.cdn-lab 
&Scoped-define ENABLED-TABLES ficha-cq
&Scoped-define FIRST-ENABLED-TABLE ficha-cq
&Scoped-Define ENABLED-OBJECTS rt-mold id-docto num-seq-item 
&Scoped-Define DISPLAYED-FIELDS ficha-cq.inspecionado ficha-cq.cod-emitente ~
ficha-cq.log-dia-sem-fornec ficha-cq.serie-docto ficha-cq.nro-docto ~
ficha-cq.dat-emis-nf ficha-cq.dt-inspecao ficha-cq.nat-operacao ~
ficha-cq.cod-resp ficha-cq.nr-ordem ficha-cq.parcela ~
ficha-cq.cod-fabricante ficha-cq.cdn-lab 
&Scoped-define DISPLAYED-TABLES ficha-cq
&Scoped-define FIRST-DISPLAYED-TABLE ficha-cq
&Scoped-Define DISPLAYED-OBJECTS c-des-emitente tg-log-exter id-docto ~
c-origem num-seq-item c-estado fi-c-desc-fabricante fi-c-desc-laboratorio 

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
DEFINE VARIABLE c-des-emitente AS CHARACTER FORMAT "X(12)" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-estado AS CHARACTER FORMAT "X(15)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-origem AS CHARACTER FORMAT "X(10)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-c-desc-fabricante AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE fi-c-desc-laboratorio AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE id-docto AS DECIMAL FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Id Documento WMS" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE num-seq-item AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Sequˆncia Item WMS" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 10.25.

DEFINE VARIABLE tg-log-exter LIKE analis-lab-period.log-exter
     VIEW-AS TOGGLE-BOX
     SIZE 10 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ficha-cq.inspecionado AT ROW 1.13 COL 56
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .88
     ficha-cq.cod-emitente AT ROW 1.17 COL 16.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .88
     c-des-emitente AT ROW 1.17 COL 29 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor" NO-LABEL
     ficha-cq.log-dia-sem-fornec AT ROW 2.13 COL 56 WIDGET-ID 8
          LABEL "Dia sem Fornecimento/Fabrica‡Æo"
          VIEW-AS TOGGLE-BOX
          SIZE 30 BY .88
     ficha-cq.serie-docto AT ROW 2.17 COL 16.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     tg-log-exter AT ROW 3.13 COL 56 HELP
          "Externo" WIDGET-ID 14
     ficha-cq.nro-docto AT ROW 3.17 COL 16.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     ficha-cq.dat-emis-nf AT ROW 4.17 COL 16.86 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     ficha-cq.dt-inspecao AT ROW 4.71 COL 65.29 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ficha-cq.nat-operacao AT ROW 5.17 COL 16.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     id-docto AT ROW 5.71 COL 65.29 COLON-ALIGNED
     c-origem AT ROW 6.17 COL 16.86 COLON-ALIGNED
     num-seq-item AT ROW 6.71 COL 65.29 COLON-ALIGNED
     c-estado AT ROW 7.17 COL 16.86 COLON-ALIGNED
     ficha-cq.cod-resp AT ROW 7.71 COL 65.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     ficha-cq.nr-ordem AT ROW 8.17 COL 16.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     ficha-cq.parcela AT ROW 8.17 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     ficha-cq.cod-fabricante AT ROW 9.17 COL 16.86 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fi-c-desc-fabricante AT ROW 9.17 COL 30.14 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     ficha-cq.cdn-lab AT ROW 10.17 COL 16.86 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fi-c-desc-laboratorio AT ROW 10.17 COL 30.14 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ficha-cq
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
         HEIGHT             = 10.38
         WIDTH              = 85.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 10.38
       FRAME f-main:WIDTH            = 85.72.

/* SETTINGS FOR FILL-IN c-des-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-origem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-c-desc-fabricante IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-c-desc-laboratorio IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX ficha-cq.log-dia-sem-fornec IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-log-exter IN FRAME f-main
   NO-ENABLE LIKE = mgcad.analis-lab-period.log-exter EXP-SIZE          */
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
  {src/adm/template/row-list.i "ficha-cq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ficha-cq"}

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
    def var c-id-docto     as char no-undo.
    def var c-num-seq-item as char no-undo.
    DEFINE BUFFER bf-emitente FOR emitente.

    /* Code placed here will execute PRIOR to standard behavior. */
    IF  AVAIL ficha-cq THEN DO:
        FIND emitente NO-LOCK
            WHERE emitente.cod-emitente = ficha-cq.cod-emitente NO-ERROR.
        ASSIGN c-des-emitente = IF AVAIL emitente THEN emitente.nome-abrev ELSE "":U.

        FOR FIRST fab-medic FIELDS(nom-fabrican)
            WHERE fab-medic.cdn-fabrican = ficha-cq.cod-fabricante NO-LOCK: END.
        ASSIGN fi-c-desc-fabricante = IF AVAIL fab-medic THEN fab-medic.nom-fabrican ELSE "":U.

        FOR FIRST bf-emitente FIELDS(nome-abrev)
            WHERE bf-emitente.cod-emitente = ficha-cq.cdn-lab NO-LOCK: END.
        ASSIGN fi-c-desc-laboratorio = IF AVAIL bf-emitente THEN bf-emitente.nome-abrev ELSE "":U.

        FOR FIRST analis-lab-period FIELDS(log-exter)
            WHERE analis-lab-period.nr-ficha = ficha-cq.nr-ficha NO-LOCK: END.
        ASSIGN tg-log-exter = IF AVAIL analis-lab-period THEN analis-lab-period.log-exter ELSE FALSE.

    end.
 
    /* Dispatch standard ADM method.                             */
    run dispatch in this-procedure ( input 'display-fields':U ) .
 
    /* Code placed here will execute AFTER standard behavior.    */
    if avail ficha-cq then
        do with frame {&FRAME-NAME}:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
                ASSIGN cAuxTraducao001 = {ininc/i01in124.i 04 ficha-cq.origem}.
                run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                    INPUT "",
                                    INPUT "").
                ASSIGN  c-origem:screen-value = RETURN-VALUE.
            &else
                ASSIGN c-origem:screen-value = {ininc/i01in124.i 04 ficha-cq.origem}.
            &endif
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
                ASSIGN cAuxTraducao002 = {ininc/i02in124.i 04 ficha-cq.estado}.
                run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                                    INPUT "",
                                    INPUT "").
                ASSIGN  c-estado:screen-value = RETURN-VALUE.
            &else
                ASSIGN c-estado:screen-value = {ininc/i02in124.i 04 ficha-cq.estado}.
            &endif
        end.

    &if "{&mgscm_version}":U >= "2.04":U &then
        if  id-docto:hidden in frame {&frame-name} = no 
        and num-seq-item:hidden in frame {&frame-name} = no then do:
            if  avail ficha-cq
            and connected("mgscm") 
            and avail param-estoq
            and (  substr(param-estoq.char-2,6,1) = "1" 
                or param-estoq.int-1 = 1) then do:
                /** acesso as tabelas de wms **/
                run wmp/wm9027.p (input  rowid(ficha-cq),
                                  output c-id-docto,
                                  output c-num-seq-item).
                assign id-docto:screen-value     in frame {&frame-name} = c-id-docto
                       num-seq-item:screen-value in frame {&frame-name} = c-num-seq-item.          
            end.
            else
                assign id-docto:screen-value     in frame {&frame-name} = "0"
                       num-seq-item:screen-value in frame {&frame-name} = "0".          
        end.
  &endif

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
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-field.i mgind ficha-cq origem 1}
  assign c-origem:label in frame {&FRAME-NAME} = return-value.
 
  {utp/ut-field.i mgind ficha-cq estado 1}
  assign c-estado:label in frame {&FRAME-NAME} = return-value.
 
  &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
        FIND FIRST param-estoq NO-LOCK NO-ERROR.
        IF AVAIL param-estoq AND SUBSTRING(param-estoq.char-2,6,1) = "1" THEN
            ASSIGN id-docto:HIDDEN IN FRAME {&FRAME-NAME}     = NO
                   num-seq-item:HIDDEN IN FRAME {&FRAME-NAME} = NO.        
        ELSE
            ASSIGN id-docto:HIDDEN IN FRAME {&FRAME-NAME}     = YES
                   num-seq-item:HIDDEN IN FRAME {&FRAME-NAME} = YES.        
  &ELSE
        ASSIGN id-docto:HIDDEN IN FRAME {&FRAME-NAME}     = YES
               num-seq-item:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  &ENDIF
  
   disable id-docto     with frame {&FRAME-NAME}.
   disable num-seq-item with frame {&FRAME-NAME}.

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
  {src/adm/template/snd-list.i "ficha-cq"}

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


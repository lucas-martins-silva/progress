&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            ORACLE
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
{include/i-prgvrs.i V02IN292 2.00.00.051 } /*** "010051" 26/08/2024 15:58:09 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in292 MUT}
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
/* Parameters Definitions ---                                           */
{include/i_hle.i}
/* Local Variable Definitions ---                                       */
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

DEF VAR l-spp-nfe AS LOG NO-UNDO.

DEF VAR l-usa-fech-geren AS LOGICAL NO-UNDO.
DEF VAR l-integr-totvs-colab AS LOG NO-UNDO.
DEF VAR c-versao-totvs-colab AS CHAR NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES param-re
&Scoped-define FIRST-EXTERNAL-TABLE param-re


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-re.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-re.of-on-line param-re.pd-aliq-icms ~
param-re.ap-on-line param-re.pd-cd-icms param-re.baixa-estoq ~
param-re.pd-aliq-ipi param-re.pd-cd-ipi param-re.ped-imp-nota ~
param-re.pd-cf-item 
&Scoped-define ENABLED-TABLES param-re
&Scoped-define FIRST-ENABLED-TABLE param-re
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-9 tb-ri-on-line perc-red-ipi ~
perc-red-icm l-informa-pedagio tb-atual-geren-fecha 
&Scoped-Define DISPLAYED-FIELDS param-re.of-on-line param-re.pd-aliq-icms ~
param-re.ap-on-line param-re.pd-cd-icms param-re.baixa-estoq ~
param-re.pd-aliq-ipi param-re.pd-cd-ipi param-re.ped-imp-nota ~
param-re.pd-cf-item 
&Scoped-define DISPLAYED-TABLES param-re
&Scoped-define FIRST-DISPLAYED-TABLE param-re
&Scoped-Define DISPLAYED-OBJECTS tb-ri-on-line tb-danfe-inv tb-chave-nfe ~
tb-nfe-aut perc-red-ipi tb-manif-dest perc-red-icm tb-valid-ch-tc20 ~
l-informa-pedagio tb-atual-geren-fecha c-atualizacao c-impostos 

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
DEFINE VARIABLE c-atualizacao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE c-impostos AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7.57 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 10.75.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 10.75.

DEFINE VARIABLE l-informa-pedagio AS LOGICAL INITIAL no 
     LABEL "Informa Ped gio" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.43 BY .83 NO-UNDO.

DEFINE VARIABLE perc-red-icm AS LOGICAL INITIAL no 
     LABEL "Perc Red ICMS" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.43 BY .83 NO-UNDO.

DEFINE VARIABLE perc-red-ipi AS LOGICAL INITIAL no 
     LABEL "Perc Red IPI" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-atual-geren-fecha AS LOGICAL INITIAL no 
     LABEL "Atualiza Gerencial Fechado" 
     VIEW-AS TOGGLE-BOX
     SIZE 37.57 BY .83 DROP-TARGET NO-UNDO.

DEFINE VARIABLE tb-chave-nfe AS LOGICAL INITIAL no 
     LABEL "Atualiza OF NF-e Inv lida" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.14 BY .83 DROP-TARGET NO-UNDO.

DEFINE VARIABLE tb-danfe-inv AS LOGICAL INITIAL no 
     LABEL "Atualiza NF-e com DANFE inv lido" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-manif-dest AS LOGICAL INITIAL no 
     LABEL "Atualiza Manifesta‡Æo Destinat rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.14 BY .83 TOOLTIP "Atualiza Manifesta‡Æo Destinat rio" DROP-TARGET NO-UNDO.

DEFINE VARIABLE tb-nfe-aut AS LOGICAL INITIAL no 
     LABEL "Atualiza NF-e Automaticamente" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.14 BY .83 DROP-TARGET NO-UNDO.

DEFINE VARIABLE tb-ri-on-line AS LOGICAL INITIAL no 
     LABEL "Atualiza RI Automaticamente" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-valid-ch-tc20 AS LOGICAL INITIAL no 
     LABEL "Habilita valida‡Æo ass¡ncrona NF-e/CT-e" 
     VIEW-AS TOGGLE-BOX
     SIZE 37.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-re.of-on-line AT ROW 1.79 COL 5.43
          VIEW-AS TOGGLE-BOX
          SIZE 33.57 BY .83
     param-re.pd-aliq-icms AT ROW 1.79 COL 49.43
          VIEW-AS TOGGLE-BOX
          SIZE 13.72 BY .83
     param-re.ap-on-line AT ROW 2.79 COL 5.43
          VIEW-AS TOGGLE-BOX
          SIZE 33.43 BY .83
     param-re.pd-cd-icms AT ROW 2.79 COL 49.43
          VIEW-AS TOGGLE-BOX
          SIZE 18.57 BY .83
     param-re.baixa-estoq AT ROW 3.79 COL 5.43
          VIEW-AS TOGGLE-BOX
          SIZE 30.72 BY .83
     param-re.pd-aliq-ipi AT ROW 3.79 COL 49.43
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .83
     tb-ri-on-line AT ROW 4.79 COL 5.43
     param-re.pd-cd-ipi AT ROW 4.79 COL 49.43
          VIEW-AS TOGGLE-BOX
          SIZE 16.14 BY .83
     tb-danfe-inv AT ROW 5.79 COL 5.43
     param-re.ped-imp-nota AT ROW 5.79 COL 49.43
          VIEW-AS TOGGLE-BOX
          SIZE 19.14 BY .83
     tb-chave-nfe AT ROW 6.79 COL 5.43 HELP
          "Permite atualizar OF com chave de acesso NF-e inv lida"
     param-re.pd-cf-item AT ROW 6.79 COL 49.43
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .83
     tb-nfe-aut AT ROW 7.79 COL 5.43
     perc-red-ipi AT ROW 7.79 COL 49.43
     tb-manif-dest AT ROW 8.79 COL 5.43 HELP
          "Atualiza Manifesta‡Æo Destinat rio" WIDGET-ID 2
     perc-red-icm AT ROW 8.79 COL 49.43
     tb-valid-ch-tc20 AT ROW 9.79 COL 5.43 WIDGET-ID 6
     l-informa-pedagio AT ROW 9.79 COL 49.43 WIDGET-ID 4
     tb-atual-geren-fecha AT ROW 10.79 COL 5.43 WIDGET-ID 8
     c-atualizacao AT ROW 1 COL 4 COLON-ALIGNED NO-LABEL
     c-impostos AT ROW 1 COL 45 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 1.25 COL 3
     RECT-9 AT ROW 1.25 COL 45
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-re
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
         HEIGHT             = 11.42
         WIDTH              = 84.14.
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
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-atualizacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-impostos IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       param-re.pd-aliq-icms:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       param-re.pd-cd-icms:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       param-re.pd-cf-item:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tb-chave-nfe IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-danfe-inv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-manif-dest IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-nfe-aut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-valid-ch-tc20 IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

    /*{utp/ut-field.i mgind param-re orig-aliq-ip 1}
    display return-value @ c-orig-aliq-ip with frame {&frame-name}.

    if param-re.esp-def-nff:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.*/

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
  {src/adm/template/row-list.i "param-re"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-re"}

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
  ASSIGN tb-ri-on-line:screen-value in frame {&frame-name} = "no":U.  

  {utp/ut-liter.i Atualiza‡Æo * R}
  assign c-atualizacao:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Impostos * R}
  assign c-impostos:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Atualiza_Estoque_Autom tico * R}
  assign param-re.baixa-estoq:label in frame {&frame-name} = return-value.

&if  "{&bf_mat_versao_ems}" >= "2.04" &then
  {utp/ut-liter.i Perc._Redu‡Æo_ICMS * L}
  assign perc-red-icm:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Perc._Redu‡Æo_IPI * L}
  assign perc-red-ipi:label in frame {&frame-name} = return-value.
&else
&endif

  IF l-spp-nfe THEN
     assign tb-chave-nfe:checked in frame {&frame-name} = no
            tb-nfe-aut:checked   in frame {&frame-name} = no.

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
  def var c-perc-red-ipi as char format "x(1)" no-undo.
  def var c-perc-red-icm as char format "x(1)" no-undo.
  def var c-ri-on-line   as char format "x(1)" no-undo.

  DEF VAR c-atu-nfe-inva AS CHAR FORMAT "x(1)" NO-UNDO.
  DEF VAR c-atu-nfe-aut  AS CHAR FORMAT "x(1)" NO-UNDO.
  DEF VAR c-manif-destin AS CHAR FORMAT "x(1)" NO-UNDO.
  DEF VAR c-danfe-inv    AS CHAR FORMAT "x(1)" NO-UNDO.
  DEF VAR c-inf-pedagio  AS CHAR FORMAT "X(1)" NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e nem na PI-validate. */
  /* Dispatch standard ADM method.                             */

    /*find espec-ap where espec-ap.cod-esp = input frame {&frame-name} param-re.esp-def-nff no-lock no-error.
    if available espec-ap then do:
        if espec-ap.tipo = 2 then do:
           run utp/ut-msgs.p (input "show", 
                              input 4641, 
                              input "").
           apply "entry" to param-re.esp-def-nff in frame {&frame-name}.
           return error.
        end.
    end.  */         

    if perc-red-ipi:checked in frame {&frame-name} then 
        assign c-perc-red-ipi = "1".
    else 
        assign c-perc-red-ipi = "0".    

    if perc-red-icm:checked in frame {&frame-name} then 
        assign c-perc-red-icm = "1".
    else 
        assign c-perc-red-icm = "0".    

    /*MRI*/
    if tb-ri-on-line:checked in frame {&frame-name} then 
        assign c-ri-on-line = "1".
    else 
        assign c-ri-on-line = "0".    
    /*MRI*/
    IF tb-chave-nfe:CHECKED IN FRAME {&FRAME-NAME}  THEN
        ASSIGN c-atu-nfe-inva = "1".
    ELSE 
        ASSIGN c-atu-nfe-inva = "".

    IF tb-nfe-aut:CHECKED IN FRAME {&FRAME-NAME} THEN
       ASSIGN c-atu-nfe-aut = "1".
    ELSE 
        ASSIGN c-atu-nfe-aut = "".

    IF tb-manif-dest:CHECKED IN FRAME {&FRAME-NAME} THEN
         ASSIGN c-manif-destin = "1".
    ELSE 
         ASSIGN c-manif-destin = "0".


    IF tb-danfe-inv:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN c-danfe-inv = "1".
    ELSE 
        ASSIGN c-danfe-inv = "0".

    IF l-informa-pedagio:CHECKED IN FRAME {&FRAME-NAME}  THEN
        ASSIGN c-inf-pedagio = "1".
    ELSE 
        ASSIGN c-inf-pedagio = "".

    IF tb-valid-ch-tc20:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN tb-valid-ch-tc20 = YES.
    ELSE
        ASSIGN tb-valid-ch-tc20 = NO.

    IF tb-atual-geren-fecha:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN tb-atual-geren-fecha = YES.
    ELSE
        ASSIGN tb-atual-geren-fecha = NO.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
      if RETURN-VALUE = 'ADM-ERROR':U then 
          RETURN 'ADM-ERROR':U.

    if avail param-re then do:

        assign substring(param-re.char-1,3,1)  = c-perc-red-ipi    
               substring(param-re.char-1,4,1)  = c-perc-red-icm
               substring(param-re.char-1,21,1)  = c-inf-pedagio.
               /*MRI*/
        &IF  "{&bf_mat_versao_ems}"  >=  "2.07"  &THEN
              ASSIGN param-re.log-recuper-impto-online = IF (c-ri-on-line = "1") THEN YES ELSE NO.
        &ELSE
            substring(param-re.char-1,15,1) = c-ri-on-line.
        &ENDIF
               /*MRI*/

        IF l-spp-nfe THEN DO:
          &IF  "{&bf_mat_versao_ems}"  >=  "2.07"  &THEN
                ASSIGN param-re.log-atualiza-nfe-of  =  IF (c-atu-nfe-inva = "1") THEN YES ELSE NO.
          &ELSE 
                ASSIGN OVERLAY(param-re.char-1,16,1) = c-atu-nfe-inva.
          &ENDIF
          
          &IF  "{&bf_mat_versao_ems}"  >=  "2.071"  &THEN
                ASSIGN param-re.log-atualiza-nfe-aut =  IF (c-atu-nfe-aut = "1") THEN YES ELSE NO.
          &ELSE 
                ASSIGN OVERLAY(param-re.char-1,17,1) = c-atu-nfe-aut.
          &ENDIF

          &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN 
               ASSIGN param-re.log-manif-destin    =  IF c-manif-dest = "1" THEN YES ELSE NO.
          &ELSE
               ASSIGN OVERLAY(param-re.char-1,19,1) = c-manif-destin.
          &ENDIF
          
          &IF "{&bf_mat_versao_ems}" >= "2.08" &THEN 
               ASSIGN param-re.log-atual-nfe-danfe-invldo =  IF c-danfe-inv = "1" THEN YES ELSE NO.
          &ELSE
               ASSIGN OVERLAY(param-re.char-1,20,1) = c-danfe-inv.
          &ENDIF

        END.

        IF tb-valid-ch-tc20 THEN
            ASSIGN OVERLAY(param-re.char-1,22,1) = "1". /* Habilita valida‡Æo ass¡ncrona NF-e/CT-e */
        ELSE
            ASSIGN OVERLAY(param-re.char-1,22,1) = "0".

         IF l-usa-fech-geren THEN DO:

             IF tb-atual-geren-fecha THEN
                ASSIGN param-re.log-nf-geren = YES.
             ELSE
                ASSIGN param-re.log-nf-geren = NO.

         END.
    end.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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
  assign perc-red-ipi :sensitive in frame {&frame-name} = no
         perc-red-icm :sensitive in frame {&frame-name} = no
         tb-ri-on-line:sensitive in frame {&frame-name} = no
         tb-manif-dest:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         tb-danfe-inv:SENSITIVE  IN FRAME {&FRAME-NAME} = NO
         l-informa-pedagio:sensitive in frame {&frame-name} = NO
         tb-valid-ch-tc20:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         tb-atual-geren-fecha:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  &IF "{&isEmsStart}" = "YES" &THEN
     DISABLE tb-nfe-aut WITH FRAME {&FRAME-NAME}.
     tb-nfe-aut:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
  &ENDIF

  IF l-spp-nfe THEN
     DISABLE tb-chave-nfe tb-nfe-aut tb-danfe-inv WITH FRAME {&FRAME-NAME}.

  IF NOT l-usa-fech-geren THEN
      DISABLE tb-atual-geren-fecha WITH FRAME {&FRAME-NAME}.
    
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

  {utp/ut-liter.i Atualiza‡Æo * R}
  assign c-atualizacao:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Impostos * R}
  assign c-impostos:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Atualiza_Estoque_Autom tico * R}
  assign param-re.baixa-estoq:label in frame {&frame-name} = return-value.

&if  "{&bf_mat_versao_ems}" >= "2.04" &then
  {utp/ut-liter.i Perc._Redu‡Æo_ICMS * L}
  assign perc-red-icm:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Perc._Redu‡Æo_IPI * L}
  assign perc-red-ipi:label in frame {&frame-name} = return-value.

  assign perc-red-ipi:checked in frame {&frame-name} = 
         if (avail param-re and int(substring(param-re.char-1,3,1)) = 0) then no else yes.
  assign perc-red-icm:checked in frame {&frame-name} = 
         if (avail param-re and int(substring(param-re.char-1,4,1)) = 0) then no else yes.

  assign l-informa-pedagio:checked in frame {&frame-name} = 
         if (avail param-re and int(substring(param-re.char-1,21,1)) = 0) then no else yes.  

  /*MRI*/
  if {cdp/cd9870.i2 "EMS"} then
  assign tb-ri-on-line:checked in frame {&frame-name} = 
        &IF  "{&bf_mat_versao_ems}"  >=  "2.07"  &THEN
            if (avail param-re and int(param-re.log-recuper-impto-online) = 0) then no else yes. 
        &ELSE
            if (avail param-re and int(substring(param-re.char-1,15,1)) = 0) then no else yes.
        &ENDIF
  else
      assign tb-ri-on-line:hidden in frame {&frame-name} = yes.
  /*MRI*/
&else
  /* na 2.00 e 2.02 esconder os campos da tela */
  assign perc-red-ipi :hidden in frame {&frame-name} = yes
         perc-red-icm :hidden in frame {&frame-name} = yes
         /*MRI*/
         tb-ri-on-line:hidden in frame {&frame-name} = yes.
         /*MRI*/
&endif

  
  find first param-estoq  no-lock no-error.
  IF param-estoq.log-fechto-geren AND 
     CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-fech-gerencial":U AND funcao.ativo = YES) THEN DO:
     ASSIGN l-usa-fech-geren = YES.
  END.
  ELSE DO:
      ASSIGN l-usa-fech-geren = NO.
  END.

   IF l-usa-fech-geren AND AVAIL param-re THEN DO:
       IF param-re.log-nf-geren = YES THEN
          ASSIGN tb-atual-geren-fecha :checked in frame {&frame-name} = YES.
       ELSE
          ASSIGN tb-atual-geren-fecha :checked in frame {&frame-name} = NO.
   END.
   ELSE DO:
        assign tb-atual-geren-fecha :hidden in frame {&frame-name} = yes.
   END.
       
  /* Code placed here will execute AFTER standard behavior.    */
  IF l-spp-nfe AND AVAIL param-re THEN 
     ASSIGN tb-chave-nfe:CHECKED IN FRAME {&FRAME-NAME} = &IF  "{&bf_mat_versao_ems}"  >=  "2.07"  &THEN
                                                               param-re.log-atualiza-nfe-of 
                                                          &ELSE SUBSTR(param-re.char-1,16,1) = "1" &ENDIF
            tb-nfe-aut:CHECKED   IN FRAME {&FRAME-NAME} = &IF  "{&bf_mat_versao_ems}"  >=  "2.071"  &THEN
                                                               param-re.log-atualiza-nfe-aut
                                                          &ELSE SUBSTR(param-re.char-1,17,1) = "1" &ENDIF
            tb-manif-dest:CHECKED IN FRAME {&FRAME-NAME} = &IF  "{&bf_mat_versao_ems}"  >=  "2.09"  &THEN
                                                               param-re.log-manif-destin
                                                           &ELSE SUBSTR(param-re.char-1,19,1) = "1" &ENDIF
                                                            
            tb-danfe-inv:CHECKED IN FRAME {&FRAME-NAME} = &IF  "{&bf_mat_versao_ems}"  >=  "2.08"  &THEN
                                                               param-re.log-atual-nfe-danfe-invldo
                                                           &ELSE SUBSTR(param-re.char-1,20,1) = "1" &ENDIF                                                .
                                                           
   IF AVAIL param-re AND l-integr-totvs-colab AND c-versao-totvs-colab >= "2.0":U THEN
       ASSIGN tb-valid-ch-tc20:CHECKED IN FRAME {&FRAME-NAME} = SUBSTR(param-re.char-1,22,1) = "1".

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

  /* disable perc-red-ipi perc-red-icm with frame {&frame-name}. */
  assign perc-red-ipi :sensitive in frame {&frame-name} = yes
         perc-red-icm :sensitive in frame {&frame-name} = yes
         l-informa-pedagio:sensitive in frame {&frame-name} = YES
         tb-manif-dest:SENSITIVE IN FRAME {&FRAME-NAME} = YES
  /*MRI*/
         tb-ri-on-line:sensitive in frame {&frame-name} = YES
  /*MRI*/
         tb-danfe-inv:SENSITIVE  IN FRAME {&FRAME-NAME} = YES
         tb-valid-ch-tc20:SENSITIVE IN FRAME {&FRAME-NAME} = YES
         tb-atual-geren-fecha:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
         

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  IF l-spp-nfe THEN DO:
    ENABLE tb-chave-nfe WITH FRAME {&FRAME-NAME}.
    ENABLE tb-danfe-inv WITH FRAME {&FRAME-NAME}.

    &IF "{&isEmsStart}" = "NO" &THEN 
        ENABLE tb-nfe-aut WITH FRAME {&FRAME-NAME}.
    &ENDIF
  END.

  IF l-usa-fech-geren THEN DO:
    ENABLE tb-atual-geren-fecha WITH FRAME {&FRAME-NAME}.
  END.
  
  IF l-integr-totvs-colab AND c-versao-totvs-colab >= "2.0":U THEN
    ENABLE tb-valid-ch-tc20 WITH FRAME {&FRAME-NAME}.

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

  if  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
      assign param-re.of-on-line:sensitive in frame {&frame-name} = NO
             param-re.of-on-line:hidden    in frame {&frame-name} = YES
             perc-red-ipi:HIDDEN IN FRAME {&FRAME-NAME}           = YES
             perc-red-icm:HIDDEN IN FRAME {&FRAME-NAME}           = YES
             tb-atual-geren-fecha:HIDDEN IN FRAME {&FRAME-NAME}   = YES.
  END.
  
      
  assign perc-red-ipi :sensitive in frame {&frame-name} = no
         perc-red-icm :sensitive in frame {&frame-name} = no
         l-informa-pedagio:sensitive in frame {&frame-name} = NO

         /*MRI*/
         tb-ri-on-line:sensitive in frame {&frame-name} = no
         /*MRI*/
         tb-manif-dest:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         tb-danfe-inv:SENSITIVE  IN FRAME {&FRAME-NAME} = NO
         tb-valid-ch-tc20:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         tb-atual-geren-fecha:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

 
         
         
         
  /* Integracao Totvs Colaboracao - parametro global */
  RUN cdp/cd0029a.p (output l-integr-totvs-colab).
  ASSIGN c-versao-totvs-colab = RETURN-VALUE. /* TRIM(SUBSTRING(param-global.char-2,41,4)) */


  /* Code placed here will execute AFTER standard behavior. */

  /* Nota Fiscal Eletronica */
  &IF "{&isEmsStart}" = "YES" &THEN
     DISABLE tb-nfe-aut WITH FRAME {&FRAME-NAME}.
     tb-nfe-aut:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  &ENDIF

  ASSIGN l-spp-nfe = CAN-FIND(FIRST funcao WHERE 
                                    funcao.cd-funcao = "SPP-NFE":U AND funcao.ativo = YES).

  IF NOT l-spp-nfe THEN DO WITH FRAME {&FRAME-NAME}:
     ASSIGN tb-chave-nfe:HIDDEN = YES
            tb-nfe-aut:HIDDEN   = YES
            tb-danfe-inv:HIDDEN = YES.
  END.
  ELSE IF NOT {cdp/cd9870.i2 "EMS"} THEN
      ASSIGN tb-ri-on-line:HIDDEN = YES.          

 IF l-usa-fech-geren THEN DO WITH FRAME {&FRAME-NAME}:
     IF param-re.log-nf-geren = YES THEN
       tb-atual-geren-fecha:CHECKED IN FRAME {&FRAME-NAME} = YES. 
     ELSE
       tb-atual-geren-fecha:CHECKED IN FRAME {&FRAME-NAME} = NO.


     /*Busca cen rio gerencial para alterar op‡Æo*/
     DEFINE VARIABLE c-label-tb-gerencial AS CHARACTER NO-UNDO.
    
     {utp/ut-liter.i Atualiza}
     ASSIGN c-label-tb-gerencial = RETURN-VALUE + " " + param-estoq.cod-cenar-geren.
     {utp/ut-liter.i Fechado}
     ASSIGN c-label-tb-gerencial = c-label-tb-gerencial + " " + RETURN-VALUE.
     ASSIGN tb-atual-geren-fecha:LABEL IN FRAME {&FRAME-NAME} = c-label-tb-gerencial.

  END.
  ELSE DO:
    ASSIGN tb-atual-geren-fecha:HIDDEN = YES.
  END.

  IF NOT l-integr-totvs-colab OR NOT c-versao-totvs-colab >= "2.0":U THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN tb-valid-ch-tc20:HIDDEN = YES.
  END.

  IF l-spp-nfe AND AVAIL param-re THEN 
     ASSIGN tb-chave-nfe:CHECKED IN FRAME {&FRAME-NAME} = &IF  "{&bf_mat_versao_ems}"  >=  "2.07"  &THEN
                                                               param-re.log-atualiza-nfe-of 
                                                          &ELSE 
                                                               SUBSTR(param-re.char-1,16,1) = "1" 
                                                          &ENDIF
            tb-nfe-aut:CHECKED   IN FRAME {&FRAME-NAME} = &IF  "{&bf_mat_versao_ems}"  >=  "2.071"  &THEN
                                                               param-re.log-atualiza-nfe-aut
                                                          &ELSE 
                                                                SUBSTR(param-re.char-1,17,1) = "1" 
                                                          &ENDIF
            tb-manif-dest:CHECKED IN FRAME {&FRAME-NAME} = &IF  "{&bf_mat_versao_ems}"  >=  "2.09"  &THEN
                                                               param-re.log-manif-destin
                                                           &ELSE
                                                               SUBSTR(param-re.char-1,19,1) = "1" 
                                                           &ENDIF
            tb-danfe-inv:CHECKED IN FRAME {&FRAME-NAME} = &IF  "{&bf_mat_versao_ems}"  >=  "2.08"  &THEN
                                                               param-re.log-atual-nfe-danfe-invldo
                                                          &ELSE 
                                                               SUBSTR(param-re.char-1,20,1) = "1" 
                                                          &ENDIF .
                                                          
  IF AVAIL param-re AND l-integr-totvs-colab AND c-versao-totvs-colab >= "2.0":U THEN
      ASSIGN tb-valid-ch-tc20:CHECKED IN FRAME {&FRAME-NAME} = SUBSTRING(param-re.char-1,22,1) = "1". /* Habilita valida‡Æo ass¡ncrona NF-e/CT-e */

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
  {src/adm/template/snd-list.i "param-re"}

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


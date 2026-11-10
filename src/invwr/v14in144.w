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
{include/i-prgvrs.i V14IN144 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V14IN144 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var gr-grup-maquina as rowid no-undo.
def new global shared var c-programa      as char  no-undo.

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
def var h_handle     as handle.

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
&Scoped-define EXTERNAL-TABLES grup-maquina
&Scoped-define FIRST-EXTERNAL-TABLE grup-maquina


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR grup-maquina.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS grup-maquina.cod-area-produc ~
grup-maquina.cd-calen grup-maquina.qtd-capac-ctrab ~
grup-maquina.cod-unid-capac grup-maquina.log-crp grup-maquina.num-maquinas ~
grup-maquina.log-overlap grup-maquina.log-minimiza-tempo 
&Scoped-define ENABLED-TABLES grup-maquina
&Scoped-define FIRST-ENABLED-TABLE grup-maquina
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 
&Scoped-Define DISPLAYED-FIELDS grup-maquina.cod-area-produc ~
grup-maquina.cd-calen grup-maquina.qtd-capac-ctrab ~
grup-maquina.cod-unid-capac grup-maquina.log-crp grup-maquina.num-maquinas ~
grup-maquina.log-overlap grup-maquina.log-minimiza-tempo 
&Scoped-define DISPLAYED-TABLES grup-maquina
&Scoped-define FIRST-DISPLAYED-TABLE grup-maquina
&Scoped-Define DISPLAYED-OBJECTS cb-tip-ctrab c-desc1 c-desc c-desc-capac ~
c-texto1 c-texto2 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-tip-ctrab grup-maquina.cod-area-produc ~
grup-maquina.cd-calen grup-maquina.qtd-capac-ctrab ~
grup-maquina.num-maquinas grup-maquina.log-overlap ~
grup-maquina.log-minimiza-tempo 

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
DEFINE VARIABLE cb-tip-ctrab AS CHARACTER FORMAT "X(19)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 17.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 30.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-capac AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc1 AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 44.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-texto1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9.57 BY .67 NO-UNDO.

DEFINE VARIABLE c-texto2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 5.43 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 5.58.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 4.13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-tip-ctrab AT ROW 1.5 COL 23 COLON-ALIGNED
     grup-maquina.cod-area-produc AT ROW 2.67 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-desc1 AT ROW 2.67 COL 35.57 COLON-ALIGNED NO-LABEL
     grup-maquina.cd-calen AT ROW 3.67 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .88
     c-desc AT ROW 3.67 COL 36.57 COLON-ALIGNED NO-LABEL
     grup-maquina.qtd-capac-ctrab AT ROW 4.67 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     grup-maquina.cod-unid-capac AT ROW 5.67 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     c-desc-capac AT ROW 5.67 COL 32.57 COLON-ALIGNED NO-LABEL
     grup-maquina.log-crp AT ROW 7.08 COL 25.43
          VIEW-AS TOGGLE-BOX
          SIZE 17.57 BY .83
     grup-maquina.num-maquinas AT ROW 8 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     grup-maquina.log-overlap AT ROW 9 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.14 BY .88
     grup-maquina.log-minimiza-tempo AT ROW 10 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-texto1 AT ROW 1 COL 2.72 NO-LABEL
     c-texto2 AT ROW 6.79 COL 2.43 NO-LABEL
     RECT-1 AT ROW 1.21 COL 1.14
     RECT-2 AT ROW 7 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.grup-maquina
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
         HEIGHT             = 10.17
         WIDTH              = 85.14.
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

/* SETTINGS FOR FILL-IN c-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-capac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-texto2 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR COMBO-BOX cb-tip-ctrab IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN grup-maquina.cd-calen IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN grup-maquina.cod-area-produc IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN grup-maquina.log-minimiza-tempo IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN grup-maquina.log-overlap IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN grup-maquina.num-maquinas IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN grup-maquina.qtd-capac-ctrab IN FRAME f-main
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

&Scoped-define SELF-NAME grup-maquina.cd-calen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cd-calen V-table-Win
ON F5 OF grup-maquina.cd-calen IN FRAME f-main /* Calend rio */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in026.w"
                       &campo=grup-maquina.cd-calen
                       &campozoom=cd-calen
                       &campo2=c-desc
                       &campozoom2=descricao}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cd-calen V-table-Win
ON LEAVE OF grup-maquina.cd-calen IN FRAME f-main /* Calend rio */
DO:
    {include/leave.i &tabela=calen-gener
                     &atributo-ref=descricao
                     &variavel-ref=c-desc
                     &where="calen-gener.cd-calen = input frame {&frame-name} grup-maquina.cd-calen"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cd-calen V-table-Win
ON MOUSE-SELECT-DBLCLICK OF grup-maquina.cd-calen IN FRAME f-main /* Calend rio */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME grup-maquina.cod-area-produc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cod-area-produc V-table-Win
ON F5 OF grup-maquina.cod-area-produc IN FRAME f-main /* Area Produ‡Æo */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in511.w"
                       &campo=grup-maquina.cod-area-produc
                       &campozoom=cod-area-produc
                       &campo2=c-desc1
                       &campozoom2=des-area-produc} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cod-area-produc V-table-Win
ON LEAVE OF grup-maquina.cod-area-produc IN FRAME f-main /* Area Produ‡Æo */
DO:
    {include/leave.i &tabela=area-produc
                     &atributo-ref=des-area-produc
                     &variavel-ref=c-desc1
                     &where="area-produc.cod-area-produc = input frame {&frame-name} grup-maquina.cod-area-produc"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cod-area-produc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF grup-maquina.cod-area-produc IN FRAME f-main /* Area Produ‡Æo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME grup-maquina.cod-unid-capac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cod-unid-capac V-table-Win
ON F5 OF grup-maquina.cod-unid-capac IN FRAME f-main /* Unidade Capacidade */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in460.w"
                       &campo=grup-maquina.cod-unid-capac
                       &campozoom=cod-unid-capac
                       &campo2=c-desc-capac
                       &campozoom2=des-unid-capac}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cod-unid-capac V-table-Win
ON LEAVE OF grup-maquina.cod-unid-capac IN FRAME f-main /* Unidade Capacidade */
DO:
    {include/leave.i &tabela=unid-capac
                     &atributo-ref=des-unid-capac
                     &variavel-ref=c-desc-capac
                     &where="unid-capac.cod-unid-capac = input frame {&frame-name} grup-maquina.cod-unid-capac"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cod-unid-capac V-table-Win
ON MOUSE-SELECT-DBLCLICK OF grup-maquina.cod-unid-capac IN FRAME f-main /* Unidade Capacidade */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-liter.i C lculo_Cap.}
assign c-texto1 = return-value.

{utp/ut-liter.i CRP}
assign c-texto2 = return-value.

{utp/ut-field.i mgind grup-maquina ind-tip-ctrab 01}
assign cb-tip-ctrab:label in frame {&frame-name} = return-value.

if grup-maquina.cd-calen:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if grup-maquina.cod-unid-capac:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if grup-maquina.cod-area-produc:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "grup-maquina"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "grup-maquina"}

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
    {include/i-valid.i}
    
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    do with frame {&frame-name}:
        assign cb-tip-ctrab.
    end. 
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    assign grup-maquina.ind-tip-ctrab = {ininc/i03in144.i 06 cb-tip-ctrab}.
    
    if c-programa = "sf0103" then do:
        RUN Who-Is-The-Container IN adm-broker-hdl
            (INPUT this-procedure,
             OUTPUT h_handle).    
        run pi-habilita-bt in h_handle(input yes).    
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

    if c-programa = "sf0103" then do:
        RUN Who-Is-The-Container IN adm-broker-hdl
            (INPUT this-procedure,
             OUTPUT h_handle).     
        run pi-habilita-bt in h_handle(input yes).
    end.
     
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

  if available grup-maquina then do with frame {&frame-name}:
     find area-produc where area-produc.cod-area-produc = grup-maquina.cod-area-produc no-lock no-error.
     assign c-desc1 = if avail area-produc then area-produc.des-area-produc else "":U.
  
     find calen-gener where calen-gener.cd-calen = grup-maquina.cd-calen no-lock no-error.
     assign c-desc = if avail calen-gener then calen-gener.descricao else "":U.
     
     find unid-capac where unid-capac.cod-unid-capac = grup-maquina.cod-unid-capac no-lock no-error.
     assign c-desc-capac = if avail unid-capac then unid-capac.des-unid-capac else "":U.  
     
     assign cb-tip-ctrab = {ininc/i03in144.i 04 grup-maquina.ind-tip-ctrab}.
  end.
  else do:
       assign cb-tip-ctrab = {ininc/i03in144.i 04 1}.
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
    /*if adm-new-record = yes then*/
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    if c-programa = "sf0103" then do:
        RUN Who-Is-The-Container IN adm-broker-hdl
            (INPUT this-procedure,
             OUTPUT h_handle).     
        run pi-habilita-bt in h_handle(input adm-new-record).
    end.

    if avail grup-maquina then do:
        if can-find(first ctrab
                    where ctrab.gm-codigo = grup-maquina.gm-codigo) then
            assign grup-maquina.num-maquinas:sensitive in frame {&frame-name}    = no
                   grup-maquina.qtd-capac-ctrab:sensitive in frame {&frame-name} = no.
        else
            assign grup-maquina.num-maquinas:sensitive in frame {&frame-name}    = yes
                   grup-maquina.qtd-capac-ctrab:sensitive in frame {&frame-name} = yes.     
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

 do with frame {&frame-name}:
    assign cb-tip-ctrab:list-items = {ininc/i03in144.i 03}.
 end.

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
  {src/adm/template/snd-list.i "grup-maquina"}

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


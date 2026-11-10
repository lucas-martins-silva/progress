&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgdis            PROGRESS
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
{include/i-prgvrs.i V10AD209 2.00.00.021}  /*** 010021 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V10AD209 MUT}
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

/* Parameters Definitions ---                                           */
{include/i_dbvers.i}
{cdp/cdcfgfin.i}

{cdp/cd0901i.i}

&if "{&mgdis_version}" >= "2.03" &then
    {cdp/cd0901g.i} /* define tt-config-nome-arq */
&endif

def var h_v05ad209 as handle.
def var h_v01ad209 as handle.
DEF VAR h-ap0507b-v02 AS HANDLE.

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
def var i-cod-febraban as int no-undo.
def var i-modalidade   as int no-undo.
def var i-portador     as int no-undo.

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
&Scoped-define EXTERNAL-TABLES portador
&Scoped-define FIRST-EXTERNAL-TABLE portador


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR portador.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS portador.log-2 
&Scoped-define ENABLED-TABLES portador
&Scoped-define FIRST-ENABLED-TABLE portador
&Scoped-define DISPLAYED-TABLES portador
&Scoped-define FIRST-DISPLAYED-TABLE portador
&Scoped-Define ENABLED-OBJECTS bt-configura l-configura c-tipo-layout ~
num-conv-pagto-bb num-conv-pagto num-seq num-agencia-conv num-conta-conv ~
log-autoriz num-ident-emp num-tp-conta-corren num-conta-comp num-agenc-cheq ~
c-tipo-software RECT-18 RECT-3 RECT-4 RECT-5 RECT-6 RECT-7 rt-mold 
&Scoped-Define DISPLAYED-FIELDS portador.log-2 
&Scoped-Define DISPLAYED-OBJECTS l-configura c-tipo-layout ~
num-conv-pagto-bb num-conv-pagto num-seq num-agencia-conv num-conta-conv ~
log-autoriz num-ident-emp num-tp-conta-corren num-conta-comp num-agenc-cheq ~
c-tipo-software 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define List-4 portador.log-2 

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
DEFINE BUTTON bt-configura 
     LABEL "Configura" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE c-tipo-layout AS CHARACTER FORMAT "X(15)":U INITIAL "DEB473/CBR388" 
     LABEL "Layout" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "DEB473/CBR388","CNAB240" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-tipo-software AS CHARACTER FORMAT "X(5)":U INITIAL "TBI" 
     LABEL "Software" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "TBI","WEBTA" 
     DROP-DOWN-LIST
     SIZE 11.57 BY 1 NO-UNDO.

DEFINE VARIABLE num-agenc-cheq AS INTEGER FORMAT "9999999":U INITIAL 0 
     LABEL "Agˆncia Cheque" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE num-agencia-conv AS INTEGER FORMAT "9999999":U INITIAL 0 
     LABEL "Agˆncia Convˆnio" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE num-conta-comp AS INTEGER FORMAT "99999999":U INITIAL 0 
     LABEL "Conta Complementar" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE num-conta-conv AS INTEGER FORMAT "99999999":U INITIAL 0 
     LABEL "Conta Convˆnio" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE num-conv-pagto AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Convˆnio" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE num-conv-pagto-bb AS CHARACTER FORMAT "X(20)":U 
     LABEL "Convˆnio" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE num-ident-emp AS INTEGER FORMAT "99999999":U INITIAL 0 
     LABEL "Identif. Empresa" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE num-seq AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Sequˆncia" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE num-tp-conta-corren AS DECIMAL FORMAT "999999999":U INITIAL 0 
     LABEL "Tipo Conta Corrente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 76.72 BY 1.71.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35 BY 1.54.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35 BY 2.38.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35 BY 1.54.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35.29 BY 3.33.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35.29 BY 2.46.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 76.72 BY 7.54.

DEFINE VARIABLE l-configura AS LOGICAL INITIAL no 
     LABEL "Configura nome do arquivo de envio?" 
     VIEW-AS TOGGLE-BOX
     SIZE 38 BY .83 NO-UNDO.

DEFINE VARIABLE log-autoriz AS LOGICAL INITIAL no 
     LABEL "Documento Autorizado?" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.86 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     bt-configura AT ROW 8.96 COL 52.43
     l-configura AT ROW 9.21 COL 6.29
     portador.log-2 AT ROW 1.29 COL 4
          VIEW-AS TOGGLE-BOX
          SIZE 46 BY .83
     c-tipo-layout AT ROW 1.29 COL 57.57 COLON-ALIGNED
     num-conv-pagto-bb AT ROW 2.79 COL 11.29 COLON-ALIGNED
     num-conv-pagto AT ROW 2.79 COL 22.29 COLON-ALIGNED
     num-seq AT ROW 4.63 COL 22.29 COLON-ALIGNED
     num-agencia-conv AT ROW 2.75 COL 59.57 COLON-ALIGNED
     num-conta-conv AT ROW 3.75 COL 59.57 COLON-ALIGNED
     log-autoriz AT ROW 4.75 COL 41.29
     num-ident-emp AT ROW 6.25 COL 22.29 COLON-ALIGNED
     num-tp-conta-corren AT ROW 6.25 COL 59.57 COLON-ALIGNED
     num-conta-comp AT ROW 7.25 COL 22.29 COLON-ALIGNED
     num-agenc-cheq AT ROW 7.25 COL 59.57 COLON-ALIGNED
     c-tipo-software AT ROW 1.29 COL 62 COLON-ALIGNED
     RECT-18 AT ROW 8.67 COL 1.14
     RECT-3 AT ROW 4.21 COL 3.43
     RECT-4 AT ROW 6 COL 3.43
     RECT-5 AT ROW 2.46 COL 3.43
     RECT-6 AT ROW 2.46 COL 40.29
     RECT-7 AT ROW 5.96 COL 40.43
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgdis.portador
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
         HEIGHT             = 9.46
         WIDTH              = 77.14.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

ASSIGN 
       bt-configura:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       l-configura:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX portador.log-2 IN FRAME f-main
   4                                                                    */
ASSIGN 
       RECT-18:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME bt-configura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-configura V-table-Win
ON CHOOSE OF bt-configura IN FRAME f-main /* Configura */
DO:
    &if "{&mgdis_version}" >= "2.03" &then

        run pi-passa-modalidade in h_v01ad209 (output i-modalidade).
        run pi-passa-portador   in h_v01ad209 (output i-portador).

        find first config-nome-arq exclusive-lock
            where config-nome-arq.ep-codigo    = i-ep-codigo-usuario
            and   config-nome-arq.cod-portador = i-portador
            and   config-nome-arq.modalidade   = i-modalidade
            and   config-nome-arq.modulo       = 1 /* APP */ no-error.
        if  avail config-nome-arq then do:
            find first tt-config-nome-arq no-lock no-error.
            if  not avail tt-config-nome-arq then do:
                create tt-config-nome-arq.
                assign tt-config-nome-arq.nome-diretorio = config-nome-arq.nome-diretorio
                       tt-config-nome-arq.nome-prefixo   = config-nome-arq.nome-prefixo
                       tt-config-nome-arq.nome-extensao  = config-nome-arq.nome-extensao
                       tt-config-nome-arq.prox-seq-port  = config-nome-arq.prox-seq-port
                       tt-config-nome-arq.prim-seq-dia   = config-nome-arq.prim-seq-dia
                       tt-config-nome-arq.prox-seq-dia   = config-nome-arq.prox-seq-dia
                       tt-config-nome-arq.dt-ult-seq-dia = config-nome-arq.dt-ult-seq-dia.
            end.           
        end.

        run cdp/cd0901g.w (input-output table tt-config-nome-arq).
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-tipo-layout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tipo-layout V-table-Win
ON VALUE-CHANGED OF c-tipo-layout IN FRAME f-main /* Layout */
DO:
    if  input frame {&FRAME-NAME} c-tipo-layout  = "DEB473/CBR388" then do:
        assign num-conv-pagto-bb:hidden in frame {&FRAME-NAME} = yes.
        disable num-conv-pagto-bb with frame {&FRAME-NAME}.
        &if "{&mgdis_version}" >= "2.02" &then
            assign num-conv-pagto:hidden    in frame {&FRAME-NAME} = no.
            enable  num-conv-pagto    with frame {&FRAME-NAME}.
        &endif    
    end.       
    else do:
        assign num-conv-pagto:hidden    in frame {&FRAME-NAME} = yes
               num-conv-pagto-bb:hidden in frame {&FRAME-NAME} = no.
        enable  num-conv-pagto-bb with frame {&FRAME-NAME}.
        disable num-conv-pagto    with frame {&FRAME-NAME}.       
    end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-configura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-configura V-table-Win
ON VALUE-CHANGED OF l-configura IN FRAME f-main /* Configura nome do arquivo de envio? */
DO:

   if  l-configura:screen-value in frame {&FRAME-NAME} = "yes" then
       assign bt-configura:sensitive in frame {&FRAME-NAME} = yes. 
   else
       assign bt-configura:sensitive in frame {&FRAME-NAME} = no. 
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
  {src/adm/template/row-list.i "portador"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "portador"}

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

assign input frame {&FRAME-NAME} num-seq
       input frame {&FRAME-NAME} log-autoriz 
       input frame {&FRAME-NAME} num-conta-conv
       input frame {&FRAME-NAME} num-agencia-conv
       input frame {&FRAME-NAME} num-tp-conta-corren
       input frame {&FRAME-NAME} num-agenc-cheq
       input frame {&FRAME-NAME} num-conv-pagto
       input frame {&FRAME-NAME} num-conta-comp
       input frame {&FRAME-NAME} num-ident-emp
       input frame {&FRAME-NAME} c-tipo-layout
       input frame {&FRAME-NAME} c-tipo-software
       input frame {&FRAME-NAME} num-conv-pagto-bb.

    &if "{&mgdis_version}" >= "2.03" &then
        assign input frame {&FRAME-NAME} l-configura.        
    &endif

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    if  avail portador then do:
        &if "{&mgdis_version}" >= "2.02" &then
            assign portador.sequencia       = integer(num-seq:screen-value in frame {&FRAME-NAME})
                   portador.autorizado      = log-autoriz:checked in frame {&FRAME-NAME} = yes
                   portador.conta-convenio  = integer(num-conta-conv:screen-value in frame {&FRAME-NAME})
                   portador.agencia-conv    = integer(num-agencia-conv:screen-value in frame {&FRAME-NAME})
                   portador.tp-conta-corren = decimal(num-tp-conta-corren:screen-value in frame {&FRAME-NAME})
                   portador.agencia-cheque  = integer(num-agenc-cheq:screen-value in frame {&FRAME-NAME})
                   portador.convenio-pagto  = integer(num-conv-pagto:screen-value in frame {&FRAME-NAME}).
           assign  portador.conta-comp      = integer(num-conta-comp:screen-value in frame {&FRAME-NAME})
                   portador.ident-emp       = integer(num-ident-emp:screen-value in frame {&frame-name}).
        &endif

        &if "{&mgdis_version}" >= "2.03" &then
            run pi-grava-configuracao in this-procedure.
        &endif

        if  portador.cod-febraban = 1 then do:
            if  input frame {&FRAME-NAME} c-tipo-layout = "DEB473/CBR388" then
                assign overlay(portador.complemento,21,21) = "1" + num-conv-pagto-bb:screen-value in frame {&FRAME-NAME}.
            else 
                assign overlay(portador.complemento,21,21) = "2" + num-conv-pagto-bb:screen-value in frame {&FRAME-NAME}.        
        end.        
        if portador.cod-febraban = 237 then do:
            if input frame {&FRAME-NAME} c-tipo-software = "TBI" then
                assign portador.dec-2 = 1.
            else
                assign portador.dec-2 = 2.
        end.                              
    end.

    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

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

    run pi-retorna-cod-febraban in h_v05ad209 (output i-cod-febraban).

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */

    run pi-disable-fields.

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


    &if "{&mgdis_version}" < "2.02" &then
        assign num-seq:hidden              in frame {&FRAME-NAME} = yes
               log-autoriz:hidden          in frame {&FRAME-NAME} = yes
               num-conta-conv:hidden       in frame {&FRAME-NAME} = yes
               num-agencia-conv:hidden     in frame {&FRAME-NAME} = yes
               num-conta-comp:hidden       in frame {&FRAME-NAME} = yes
               num-ident-emp:hidden        in frame {&FRAME-NAME} = yes
               num-tp-conta-corren:hidden  in frame {&FRAME-NAME} = yes
               num-conv-pagto:hidden       in frame {&FRAME-NAME} = yes
               num-agenc-cheq:hidden       in frame {&FRAME-NAME} = yes
               rect-3:hidden               in frame {&FRAME-NAME} = yes
               rect-4:hidden               in frame {&FRAME-NAME} = yes
               rect-5:hidden               in frame {&FRAME-NAME} = yes
               rect-6:hidden               in frame {&FRAME-NAME} = yes
               rect-7:hidden               in frame {&FRAME-NAME} = yes.
    &else
       if not adm-new-record then do: 
          disable num-seq
                  log-autoriz
                  num-conta-conv
                  num-agencia-conv
                  num-conta-comp
                  num-ident-emp
                  num-tp-conta-corren
                  num-conv-pagto
                  num-conv-pagto-bb
                  num-agenc-cheq
                  c-tipo-layout
                  c-tipo-software
                  with frame {&FRAME-NAME}.


           assign num-seq:screen-value in frame {&FRAME-NAME}             = string(portador.sequencia)       when avail portador
                  log-autoriz:screen-value in frame {&FRAME-NAME}         = string(portador.autorizado)      when avail portador
                  num-conta-conv:screen-value in frame {&FRAME-NAME}      = string(portador.conta-convenio)  when avail portador
                  num-agencia-conv:screen-value in frame {&FRAME-NAME}    = string(portador.agencia-conv)    when avail portador
                  num-conta-comp:screen-value in frame {&FRAME-NAME}      = string(portador.conta-comp)      when avail portador
                  num-ident-emp:screen-value in frame {&frame-name}       = string(portador.ident-emp)       when avail portador
                  num-tp-conta-corren:screen-value in frame {&FRAME-NAME} = string(portador.tp-conta-corren) when avail portador
                  num-agenc-cheq:screen-value in frame {&FRAME-NAME}      = string(portador.agencia-cheque)  when avail portador
                  num-conv-pagto:screen-value in frame {&FRAME-NAME}      = string(portador.convenio-pagto)  when avail portador.
       end.


    &endif

    &if "{&mgdis_version}" >= "2.03" &then
        if  l-arq-pag-escr = yes then do:
            assign l-configura:hidden     in frame {&FRAME-NAME} = no
                   l-configura:sensitive  in frame {&FRAME-NAME} = no
                   bt-configura:hidden    in frame {&FRAME-NAME} = no
                   bt-configura:sensitive in frame {&FRAME-NAME} = no
                   rect-18:hidden         in frame {&FRAME-NAME} = no.

            find first config-nome-arq no-lock
                where config-nome-arq.ep-codigo    = i-ep-codigo-usuario
                and   config-nome-arq.cod-portador = portador.cod-portador
                and   config-nome-arq.modalidade   = portador.modalidade 
                and   config-nome-arq.modulo       = 1 /* APP */ no-error.
            if  avail config-nome-arq then 
                assign l-configura:screen-value in frame {&FRAME-NAME} = if config-nome-arq.config-nome-arq = yes then "yes" else "no".
            else 
                assign l-configura:screen-value in frame {&FRAME-NAME} = "no".

            if  l-configura:screen-value in frame {&FRAME-NAME} = "yes" 
            and adm-new-record = yes then
                assign bt-configura:sensitive in frame {&FRAME-NAME} = yes.
        end.    

    &endif

    if not adm-new-record then do:
       if  avail portador then do:
           if portador.cod-febraban = 1 then do:
              disable c-tipo-software
                      num-conv-pagto
                      num-conv-pagto-bb with frame {&FRAME-NAME}.       
              assign  c-tipo-layout:hidden           in frame {&FRAME-NAME} = no
                      c-tipo-software:hidden         in frame {&FRAME-NAME} = yes
                      num-conv-pagto-bb:screen-value in frame {&FRAME-NAME} = substring(portador.complemento,22,20)
                      c-tipo-layout:screen-value     in frame {&FRAME-NAME} = if substring(portador.complemento,21,1) = "2"
                                                                                 then "CNAB240"
                                                                                 else "DEB473/CBR388".

              if  c-tipo-layout:screen-value in frame {&FRAME-NAME} = "DEB473/CBR388" then do:
                  assign num-conv-pagto-bb:hidden   in frame {&FRAME-NAME} = yes.
                  &if "{&mgdis_version}" >= "2.02" &then
                      assign num-conv-pagto:hidden      in frame {&FRAME-NAME} = no.
                  &else
                      assign num-conv-pagto:hidden      in frame {&FRAME-NAME} = yes.    
                  &endif
              end.        
              else            
                assign num-conv-pagto-bb:hidden   in frame {&FRAME-NAME} = no
                       num-conv-pagto:hidden      in frame {&FRAME-NAME} = yes.
           end.            
           else do:
                assign num-conv-pagto-bb:hidden       in frame {&FRAME-NAME} = yes
                       c-tipo-layout:hidden           in frame {&FRAME-NAME} = yes           
                       num-conv-pagto-bb:screen-value in frame {&FRAME-NAME} = " ".
                &if "{&mgdis_version}" >= "2.02" &then       
                   assign num-conv-pagto:hidden      in frame {&FRAME-NAME} = no.
                &else    
                   assign num-conv-pagto:hidden      in frame {&FRAME-NAME} = yes.
                &endif 
           end.    
           if portador.cod-febraban = 237 then do:
              assign c-tipo-software:hidden           in frame {&FRAME-NAME} = no
                     c-tipo-layout:HIDDEN             IN FRAME {&FRAME-NAME} = YES
                     c-tipo-software:screen-value     in frame {&FRAME-NAME} = if portador.dec-2 = 1
                                                                               then "TBI"
                                                                               else "WEBTA".
           end.
           ELSE 
              assign c-tipo-software:HIDDEN           in frame {&FRAME-NAME} = YES.


       end.
    end.    

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

    run pi-retorna-cod-febraban in h_v05ad209 (output i-cod-febraban).

    &if "{&mgdis_version}" >= "2.03" &then
        
        for each tt-config-nome-arq:
            delete tt-config-nome-arq.
        end.

        run pi-passa-modalidade in h_v01ad209 (output i-modalidade).
        run pi-passa-portador   in h_v01ad209 (output i-portador).

        find first config-nome-arq exclusive-lock
            where config-nome-arq.ep-codigo    = i-ep-codigo-usuario
            and   config-nome-arq.cod-portador = i-portador
            and   config-nome-arq.modalidade   = i-modalidade
            and   config-nome-arq.modulo       = 1 /* APP */ no-error.
        if  avail config-nome-arq then do:
            create tt-config-nome-arq.
            assign tt-config-nome-arq.nome-diretorio = config-nome-arq.nome-diretorio
                   tt-config-nome-arq.nome-prefixo   = config-nome-arq.nome-prefixo
                   tt-config-nome-arq.nome-extensao  = config-nome-arq.nome-extensao
                   tt-config-nome-arq.prox-seq-port  = config-nome-arq.prox-seq-port
                   tt-config-nome-arq.prim-seq-dia   = config-nome-arq.prim-seq-dia
                   tt-config-nome-arq.prox-seq-dia   = config-nome-arq.prox-seq-dia
                   tt-config-nome-arq.dt-ult-seq-dia = config-nome-arq.dt-ult-seq-dia.
        end.
    &endif    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    /* Code placed here will execute AFTER standard behavior.    */

    run pi-enable-fields.

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

  {utp/ut-liter.i Envia_documentos_em_atraso_para_pagamento_escritural? * R}
  assign portador.log-2:label in frame {&FRAME-NAME} = return-value.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-disable-fields V-table-Win 
PROCEDURE pi-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    &if "{&mgdis_version}" >= "2.02" &then
        case i-cod-febraban:
            when 237 then do:
                 disable log-autoriz
                         num-conta-conv
                         num-agencia-conv
                         num-tp-conta-corren
                         num-conv-pagto
                         num-conv-pagto-bb
                         num-agenc-cheq
                         c-tipo-layout
                         with frame {&FRAME-NAME}.
            end.
            when 479 then do:
                 disable num-conta-comp
                         num-ident-emp
                         num-tp-conta-corren
                         num-conv-pagto
                         num-conv-pagto-bb
                         num-agenc-cheq
                         c-tipo-layout
                         c-tipo-software
                         with frame {&FRAME-NAME}.
            end.
            when 230 then do:
                 disable log-autoriz
                         num-conta-conv
                         num-agencia-conv
                         num-conta-comp
                         num-ident-emp
                         num-conv-pagto
                         num-conv-pagto-bb
                         c-tipo-layout
                         c-tipo-software
                         with frame {&FRAME-NAME}.
            end.
            when 1 then do:
                 disable log-autoriz
                         num-conta-conv
                         num-agencia-conv
                         num-conta-comp
                         num-ident-emp
                         num-tp-conta-corren
                         num-agenc-cheq
                         num-conv-pagto
                         num-conv-pagto-bb
                         c-tipo-software
                         with frame {&FRAME-NAME}.
            end.
            WHEN 41 THEN DO:
                 DISABLE num-conv-pagto
                         c-tipo-software with frame {&FRAME-NAME}. 
            END.
            WHEN 399 THEN DO:
                DISABLE num-conv-pagto
                        c-tipo-software with frame {&FRAME-NAME}. 
            END.
        end case.
        IF i-cod-febraban <> 237  THEN 
           ASSIGN c-tipo-software:HIDDEN in frame {&FRAME-NAME} = YES.

    &else
        disable c-tipo-layout
                num-conv-pagto-bb
                c-tipo-software
                with frame {&FRAME-NAME}.

    &endif


    &if "{&mgdis_version}" >= "2.03" &then
        disable l-configura
                bt-configura
                c-tipo-software with frame {&FRAME-NAME}.
        for each tt-config-nome-arq:
            delete tt-config-nome-arq.
        end.        
    &endif    

    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-enable-fields V-table-Win 
PROCEDURE pi-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if "{&mgdis_version}" >= "2.02" &then

        enable num-seq with frame {&FRAME-NAME}.
        case i-cod-febraban:
           when 237
               then do:
                  enable num-conta-comp
                         num-ident-emp
                         c-tipo-software with frame {&FRAME-NAME}.
              end.
          when 479
              then do:
                  enable log-autoriz
                         num-conta-conv
                         num-agencia-conv
                         with frame {&FRAME-NAME}.
              end.
           when 230
               then do:
                  enable num-tp-conta-corren
                         num-agenc-cheq
                         with frame {&FRAME-NAME}.
              end.
          when 1
               then do:
                  if  input frame {&FRAME-NAME} c-tipo-layout  = "DEB473/CBR388" then do:
                      enable  num-conv-pagto
                              c-tipo-layout     with frame {&FRAME-NAME}.
                      disable num-conv-pagto-bb 
                              c-tipo-software with frame {&FRAME-NAME}.            
                  end.                      
                  else do:   
                      enable  num-conv-pagto-bb
                              c-tipo-layout   with frame {&FRAME-NAME}.
                      disable num-conv-pagto
                              c-tipo-software with frame {&FRAME-NAME}.
                  end.    
              end.
          when 41 
              then do:
                   enable num-conv-pagto with frame {&FRAME-NAME}.
              end.
          WHEN 399 
              THEN DO:
                   enable num-conv-pagto with frame {&FRAME-NAME}.
              END.
        end case.
    &else
        if  i-cod-febraban = 1 then do:
            DISABLE c-tipo-software with frame {&FRAME-NAME}. 
            if  input frame {&FRAME-NAME} c-tipo-layout  = "CNAB240" THEN 
                enable num-conv-pagto-bb
                       c-tipo-layout with frame {&FRAME-NAME}.

            else           
                enable c-tipo-layout with frame {&FRAME-NAME}.
        end.     
    &endif

    &if "{&mgdis_version}" >= "2.03" &then
        assign l-configura:sensitive  in frame {&FRAME-NAME} = yes.

        if  l-configura:screen-value in frame {&FRAME-NAME} = "yes" then
            assign bt-configura:sensitive in frame {&FRAME-NAME} = yes.
     &endif

    if  i-cod-febraban = 0 then do:
        assign c-tipo-layout:hidden        in frame {&FRAME-NAME} = yes
               num-conv-pagto-bb:hidden    in frame {&FRAME-NAME} = yes
               num-conv-pagto:screen-value in frame {&FRAME-NAME} = "000000".
        disable num-conv-pagto
                c-tipo-software
                c-tipo-layout with frame {&FRAME-NAME}.
    end.           

    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-configuracao V-table-Win 
PROCEDURE pi-grava-configuracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   &if "{&mgdis_version}" >= "2.03" &then
  
      find first tt-config-nome-arq no-lock no-error.
      if  avail tt-config-nome-arq and l-configura = yes then do:
          find first config-nome-arq exclusive-lock
              where config-nome-arq.ep-codigo    = i-ep-codigo-usuario
              and   config-nome-arq.cod-portador = portador.cod-portador
              and   config-nome-arq.modalidade   = portador.modalidade
              and   config-nome-arq.modulo       = 1 /* APP */ no-error.
          if  not avail config-nome-arq then
              create config-nome-arq.

          assign config-nome-arq.ep-codigo       = i-ep-codigo-usuario
                 config-nome-arq.cod-portador    = portador.cod-portador
                 config-nome-arq.modalidade      = portador.modalidade
                 config-nome-arq.modulo          = 1 /* APP */
                 config-nome-arq.config-nome-arq = yes
                 config-nome-arq.nome-diretorio  = tt-config-nome-arq.nome-diretorio
                 config-nome-arq.nome-prefixo    = tt-config-nome-arq.nome-prefixo
                 config-nome-arq.nome-extensao   = tt-config-nome-arq.nome-extensao
                 config-nome-arq.prox-seq-port   = tt-config-nome-arq.prox-seq-port
                 config-nome-arq.prim-seq-dia    = tt-config-nome-arq.prim-seq-dia
                 config-nome-arq.prox-seq-dia    = tt-config-nome-arq.prox-seq-dia
                 config-nome-arq.dt-ult-seq-dia  = tt-config-nome-arq.dt-ult-seq-dia.
      end.
      else do:
          IF l-configura = NO THEN DO:
              find first config-nome-arq exclusive-lock
                  where config-nome-arq.ep-codigo    = i-ep-codigo-usuario
                  and   config-nome-arq.cod-portador = portador.cod-portador
                  and   config-nome-arq.modalidade   = portador.modalidade
                  and   config-nome-arq.modulo       = 1 /* APP */ no-error.
              if  avail config-nome-arq then
                  delete config-nome-arq.
          END.
      end.

      for each tt-config-nome-arq:
          delete tt-config-nome-arq.
      end.
   &endif   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-mostra V-table-Win 
PROCEDURE pi-habilita-mostra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run pi-retorna-cod-febraban in h_v05ad209 (output i-cod-febraban).

    if i-cod-febraban = 1 then do:
        assign c-tipo-layout:hidden           in frame {&FRAME-NAME} = no
               c-tipo-software:HIDDEN         IN FRAME {&FRAME-NAME} = YES.

        if  avail portador then
            assign num-conv-pagto-bb:screen-value in frame {&FRAME-NAME} = substring(portador.complemento,22,20)
                   c-tipo-layout:screen-value     in frame {&FRAME-NAME} = if substring(portador.complemento,21,1) = "2"
                                                                           then "CNAB240"
                                                                           else "DEB473/CBR388".
        else
            assign num-conv-pagto-bb:screen-value in frame {&FRAME-NAME} = " "
                   c-tipo-layout:screen-value     in frame {&FRAME-NAME} = "DEB473/CBR388".                                                            

        if  c-tipo-layout:screen-value in frame {&FRAME-NAME} = "DEB473/CBR388" then do:
            assign num-conv-pagto-bb:hidden   in frame {&FRAME-NAME} = yes.
            &if "{&mgdis_version}" >= "2.02" &then            
                assign num-conv-pagto:hidden      in frame {&FRAME-NAME} = no.
            &else    
                assign num-conv-pagto:hidden      in frame {&FRAME-NAME} = yes.
            &endif    
        end.    
        else
            assign num-conv-pagto-bb:hidden   in frame {&FRAME-NAME} = no
                   num-conv-pagto:hidden      in frame {&FRAME-NAME} = yes.
    end.            
    else do:
        if i-cod-febraban = 237 then do:
           assign c-tipo-software:hidden      in frame {&FRAME-NAME} = no
                  c-tipo-layout:hidden        in frame {&FRAME-NAME} = YES.

           if  avail portador then
               assign c-tipo-software:screen-value    in frame {&FRAME-NAME} = if portador.dec-2 = 1
                                                                           then "TBI"
                                                                           else "WEBTA".
           else 
               assign c-tipo-software:screen-value    in frame {&FRAME-NAME} = "TBI".
        end.

        disable num-conv-pagto 
                c-tipo-software with frame {&FRAME-NAME}.
        assign num-conv-pagto-bb:hidden       in frame {&FRAME-NAME} = yes
               c-tipo-layout:hidden           in frame {&FRAME-NAME} = yes           
               num-conv-pagto-bb:screen-value in frame {&FRAME-NAME} = " ".

        &if "{&mgdis_version}" >= "2.02" &then       
            assign num-conv-pagto:hidden       in frame {&FRAME-NAME} = no.
            IF i-cod-febraban <> 41 and
               i-cod-febraban <> 399 THEN
               ASSIGN num-conv-pagto:screen-value in frame {&FRAME-NAME} = "0000000".
        &else
            assign num-conv-pagto:hidden       in frame {&FRAME-NAME} = yes.
        &endif 
    end.
    run pi-disable-fields.      
    run pi-enable-fields. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter h-handle  as handle no-undo.

 assign h_v01ad209 = h-handle.

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

    def input param p_v05ad209 as handle.

    assign h_v05ad209 = p_v05ad209.
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
  {src/adm/template/snd-list.i "portador"}

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

